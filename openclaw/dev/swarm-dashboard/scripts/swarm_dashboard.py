#!/usr/bin/env python3
"""Swarm Dashboard — zero-dependency web monitor for ai-tmux-swarm.

Usage:
    python3 swarm_dashboard.py --swarm-dir /path/to/repo/.swarm
    python3 swarm_dashboard.py                    # auto-detect .swarm/ in cwd ancestors
    python3 swarm_dashboard.py --port 9000        # custom port
"""
from __future__ import annotations

import argparse
import json
import mimetypes
import os
import queue
import re
import sys
import threading
import time
from datetime import datetime, timezone
from http.server import HTTPServer, BaseHTTPRequestHandler
from pathlib import Path
from socketserver import ThreadingMixIn
from urllib.parse import unquote

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

DEFAULT_PORT = 8420
STATE_POLL_INTERVAL = 2.0      # seconds
LOG_POLL_INTERVAL = 1.0        # seconds
LOG_TAIL_LINES = 500
SENSITIVE_KEYS = re.compile(
    r"(TOKEN|SECRET|KEY|PASSWORD|CHAT_ID|ACCOUNT_ID|THREAD_ID)", re.IGNORECASE
)

# ---------------------------------------------------------------------------
# Path helpers
# ---------------------------------------------------------------------------

def find_swarm_dir(start: Path | None = None) -> Path | None:
    """Walk up from *start* looking for a .swarm/ directory."""
    d = (start or Path.cwd()).resolve()
    for _ in range(20):
        candidate = d / ".swarm"
        if candidate.is_dir():
            return candidate
        parent = d.parent
        if parent == d:
            break
        d = parent
    return None


def read_json_safe(path: Path, retries: int = 3) -> dict | None:
    """Read JSON with retry on parse failure (atomic-write race)."""
    for attempt in range(retries):
        try:
            return json.loads(path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, UnicodeDecodeError):
            if attempt < retries - 1:
                time.sleep(0.1)
        except FileNotFoundError:
            return None
    return None


def tail_lines(path: Path, n: int = LOG_TAIL_LINES) -> str:
    """Return last *n* lines of a file."""
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
        lines = text.splitlines()
        return "\n".join(lines[-n:])
    except FileNotFoundError:
        return ""


def sanitize_config(text: str) -> str:
    """Mask sensitive values in config.env content."""
    lines = []
    for line in text.splitlines():
        if "=" in line and not line.lstrip().startswith("#"):
            key, _, value = line.partition("=")
            if SENSITIVE_KEYS.search(key) and value.strip():
                line = f"{key}=****"
        lines.append(line)
    return "\n".join(lines)


def strip_ansi(text: str) -> str:
    """Remove ANSI escape sequences."""
    return re.sub(r"\x1b\[[0-9;]*[a-zA-Z]", "", text)


# ---------------------------------------------------------------------------
# StateWatcher — background thread
# ---------------------------------------------------------------------------

class StateWatcher:
    """Polls state/tasks.json by mtime and fans out changes to subscribers."""

    def __init__(self, state_path: Path):
        self.state_path = state_path
        self._lock = threading.Lock()
        self._subscribers: list[queue.Queue] = []
        self._last_mtime: float = 0.0
        self._last_state: dict | None = None
        self._stop = threading.Event()

    def subscribe(self) -> queue.Queue:
        q: queue.Queue = queue.Queue(maxsize=64)
        with self._lock:
            self._subscribers.append(q)
            # Push current state immediately so the client doesn't start blank
            if self._last_state is not None:
                try:
                    q.put_nowait(self._last_state)
                except queue.Full:
                    pass
        return q

    def unsubscribe(self, q: queue.Queue) -> None:
        with self._lock:
            try:
                self._subscribers.remove(q)
            except ValueError:
                pass

    def get_state(self) -> dict | None:
        return self._last_state

    def _broadcast(self, state: dict) -> None:
        with self._lock:
            dead: list[queue.Queue] = []
            for q in self._subscribers:
                try:
                    # Drop oldest if full
                    if q.full():
                        try:
                            q.get_nowait()
                        except queue.Empty:
                            pass
                    q.put_nowait(state)
                except Exception:
                    dead.append(q)
            for q in dead:
                try:
                    self._subscribers.remove(q)
                except ValueError:
                    pass

    def run(self) -> None:
        while not self._stop.is_set():
            try:
                if self.state_path.exists():
                    mtime = self.state_path.stat().st_mtime
                    if mtime != self._last_mtime:
                        state = read_json_safe(self.state_path)
                        if state is not None:
                            self._last_mtime = mtime
                            self._last_state = state
                            self._broadcast(state)
            except OSError:
                pass
            self._stop.wait(STATE_POLL_INTERVAL)

    def stop(self) -> None:
        self._stop.set()


# ---------------------------------------------------------------------------
# HTTP Handler
# ---------------------------------------------------------------------------

class DashboardHandler(BaseHTTPRequestHandler):
    """Routes REST, SSE, and static-file requests."""

    # Injected by the server
    swarm_dir: Path
    static_dir: Path
    watcher: StateWatcher

    # Suppress default logging
    def log_message(self, format, *args):
        pass

    # ---- routing -----------------------------------------------------------

    def do_GET(self):
        path = unquote(self.path).split("?")[0]

        # Static files
        if path == "/":
            return self._serve_file(self.static_dir / "index.html")
        if path.startswith("/static/"):
            rel = path[len("/static/"):]
            return self._serve_file(self.static_dir / rel)

        # REST API
        if path == "/api/state":
            return self._api_state()
        if path == "/api/manifest":
            return self._api_manifest()
        if path == "/api/config":
            return self._api_config()
        if path.startswith("/api/logs/"):
            slug = path[len("/api/logs/"):]
            return self._api_logs(slug)
        if path.startswith("/api/prompt/"):
            slug = path[len("/api/prompt/"):]
            return self._api_prompt(slug)

        # SSE
        if path == "/api/events/state":
            return self._sse_state()
        if path.startswith("/api/events/logs/"):
            slug = path[len("/api/events/logs/"):]
            return self._sse_logs(slug)

        self._not_found()

    # ---- REST endpoints ----------------------------------------------------

    def _api_state(self):
        state = self.watcher.get_state()
        if state is None:
            state_path = self.swarm_dir / "state" / "tasks.json"
            state = read_json_safe(state_path)
        if state is None:
            return self._json_response({"error": "state not found"}, 404)
        self._json_response(state)

    def _api_manifest(self):
        manifest_path = self.swarm_dir / "tasks.json"
        data = read_json_safe(manifest_path)
        if data is None:
            return self._json_response({"error": "manifest not found"}, 404)
        self._json_response(data)

    def _api_config(self):
        config_path = self.swarm_dir / "config.env"
        if not config_path.exists():
            config_path = self.swarm_dir / "config.env.example"
        if not config_path.exists():
            return self._json_response({"error": "config not found"}, 404)
        try:
            raw = config_path.read_text(encoding="utf-8")
        except OSError:
            return self._json_response({"error": "config read error"}, 500)
        self._json_response({"file": config_path.name, "content": sanitize_config(raw)})

    def _api_logs(self, slug: str):
        slug = _safe_slug(slug)
        if slug is None:
            return self._json_response({"error": "invalid slug"}, 400)
        log_path = self.swarm_dir / "logs" / f"{slug}.log"
        content = tail_lines(log_path)
        if not content and not log_path.exists():
            return self._json_response({"error": "log not found"}, 404)
        self._json_response({"slug": slug, "content": strip_ansi(content)})

    def _api_prompt(self, slug: str):
        slug = _safe_slug(slug)
        if slug is None:
            return self._json_response({"error": "invalid slug"}, 400)

        # Find the prompt_file from state
        state = self.watcher.get_state()
        if state is None:
            return self._json_response({"error": "state not loaded"}, 404)

        task = None
        for t in state.get("tasks", []):
            if t.get("slug") == slug or t.get("id") == slug:
                task = t
                break
        if task is None:
            return self._json_response({"error": "task not found"}, 404)

        prompt_file = task.get("prompt_file", "")
        if not prompt_file:
            return self._json_response({"error": "no prompt_file"}, 404)

        prompt_path = Path(prompt_file)
        if not prompt_path.is_absolute():
            prompt_path = self.swarm_dir / prompt_file

        try:
            content = prompt_path.read_text(encoding="utf-8")
        except FileNotFoundError:
            return self._json_response({"error": "prompt file not found"}, 404)
        except OSError:
            return self._json_response({"error": "prompt read error"}, 500)

        self._json_response({"slug": slug, "file": str(prompt_path), "content": content})

    # ---- SSE endpoints -----------------------------------------------------

    def _sse_state(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/event-stream")
        self.send_header("Cache-Control", "no-cache")
        self.send_header("Connection", "keep-alive")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()

        sub = self.watcher.subscribe()
        try:
            while True:
                try:
                    state = sub.get(timeout=30)
                    data = json.dumps(state, ensure_ascii=False)
                    self.wfile.write(f"data: {data}\n\n".encode())
                    self.wfile.flush()
                except queue.Empty:
                    # Send keepalive comment
                    self.wfile.write(b": keepalive\n\n")
                    self.wfile.flush()
        except (BrokenPipeError, ConnectionResetError, OSError):
            pass
        finally:
            self.watcher.unsubscribe(sub)

    def _sse_logs(self, slug: str):
        slug = _safe_slug(slug)
        if slug is None:
            return self._json_response({"error": "invalid slug"}, 400)

        log_path = self.swarm_dir / "logs" / f"{slug}.log"

        self.send_response(200)
        self.send_header("Content-Type", "text/event-stream")
        self.send_header("Cache-Control", "no-cache")
        self.send_header("Connection", "keep-alive")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()

        offset = 0
        try:
            while True:
                try:
                    if log_path.exists():
                        size = log_path.stat().st_size
                        if size > offset:
                            with log_path.open("r", encoding="utf-8", errors="replace") as f:
                                f.seek(offset)
                                chunk = f.read()
                                offset = f.tell()
                            if chunk:
                                clean = strip_ansi(chunk)
                                # SSE data lines can't contain bare newlines
                                for line in clean.splitlines():
                                    self.wfile.write(f"data: {line}\n".encode())
                                self.wfile.write(b"\n")
                                self.wfile.flush()
                        elif size < offset:
                            # File was truncated/rotated
                            offset = 0
                    time.sleep(LOG_POLL_INTERVAL)
                except OSError:
                    time.sleep(LOG_POLL_INTERVAL)
        except (BrokenPipeError, ConnectionResetError, OSError):
            pass

    # ---- helpers -----------------------------------------------------------

    def _json_response(self, data: dict, status: int = 200):
        body = json.dumps(data, ensure_ascii=False).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(body)

    def _serve_file(self, file_path: Path):
        # Prevent path traversal
        try:
            file_path = file_path.resolve()
            if not str(file_path).startswith(str(self.static_dir.resolve())):
                return self._not_found()
        except (OSError, ValueError):
            return self._not_found()

        if not file_path.is_file():
            return self._not_found()

        mime, _ = mimetypes.guess_type(str(file_path))
        if mime is None:
            mime = "application/octet-stream"

        try:
            body = file_path.read_bytes()
        except OSError:
            return self._not_found()

        self.send_response(200)
        self.send_header("Content-Type", mime)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-cache")
        self.end_headers()
        self.wfile.write(body)

    def _not_found(self):
        body = b"404 Not Found"
        self.send_response(404)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


def _safe_slug(slug: str) -> str | None:
    """Validate slug to prevent path traversal."""
    slug = slug.strip()
    if not slug or "/" in slug or "\\" in slug or ".." in slug:
        return None
    if not re.match(r"^[a-zA-Z0-9_-]+$", slug):
        return None
    return slug


# ---------------------------------------------------------------------------
# Threaded HTTP server
# ---------------------------------------------------------------------------

class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    daemon_threads = True
    allow_reuse_address = True


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="Swarm Dashboard — web monitor for ai-tmux-swarm")
    parser.add_argument("--swarm-dir", type=str, default=None,
                        help="Path to the .swarm/ directory")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT,
                        help=f"HTTP port (default: {DEFAULT_PORT})")
    parser.add_argument("--host", type=str, default="127.0.0.1",
                        help="Bind address (default: 127.0.0.1)")
    args = parser.parse_args()

    # Resolve .swarm directory
    if args.swarm_dir:
        swarm_dir = Path(args.swarm_dir).resolve()
    else:
        swarm_dir = find_swarm_dir()
    if swarm_dir is None or not swarm_dir.is_dir():
        print("Error: could not find .swarm/ directory.", file=sys.stderr)
        print("Use --swarm-dir or run from within a repo that has .swarm/", file=sys.stderr)
        sys.exit(1)

    # Resolve static directory (relative to this script)
    script_dir = Path(__file__).resolve().parent
    static_dir = script_dir.parent / "static"
    if not static_dir.is_dir():
        print(f"Error: static directory not found: {static_dir}", file=sys.stderr)
        sys.exit(1)

    state_path = swarm_dir / "state" / "tasks.json"

    # Start state watcher
    watcher = StateWatcher(state_path)
    watcher_thread = threading.Thread(target=watcher.run, daemon=True)
    watcher_thread.start()

    # Configure handler
    DashboardHandler.swarm_dir = swarm_dir
    DashboardHandler.static_dir = static_dir
    DashboardHandler.watcher = watcher

    server = ThreadedHTTPServer((args.host, args.port), DashboardHandler)

    repo_name = swarm_dir.parent.name
    print(f"Swarm Dashboard running at http://{args.host}:{args.port}")
    print(f"  .swarm dir : {swarm_dir}")
    print(f"  repo       : {repo_name}")
    print(f"  state file : {state_path}")
    print()

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down...")
        watcher.stop()
        server.shutdown()


if __name__ == "__main__":
    main()
