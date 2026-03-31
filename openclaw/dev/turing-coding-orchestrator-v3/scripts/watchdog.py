#!/usr/bin/env python3
"""
watchdog.py — Turing Coding Orchestrator v3
Zero-token background monitor for ACPX (native session) coding agent sessions.

Usage:
    python3 watchdog.py <task_id>
    python3 watchdog.py  # monitor all running tasks

Environment variables (all optional with fallbacks):
    WATCHDOG_REPO_ROOT       — main git repo root (avoids worktree confusion)
    WATCHDOG_INTERVAL        — poll interval in seconds (default: 30)
    STALL_TIMEOUT            — stall detection in seconds (default: 1800)
    CALLBACK_RETRY_LIMIT     — max callback correction retries (default: 2)
    OPENCLAW_BIN             — path to openclaw binary
    SWARM_AGENT_ID           — directed delivery agent id
    OPENCLAW_EVENT_MODE      — system event mode: now|next-heartbeat (default: now)
"""

import json
import logging
import os
import re
import signal
import subprocess
import sys
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from enum import Enum
from hashlib import sha256
from pathlib import Path
from typing import Dict, List, Optional, Set

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="[watchdog %(asctime)s] %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger("watchdog")


# ---------------------------------------------------------------------------
# Task State
# ---------------------------------------------------------------------------
class TaskState(str, Enum):
    PENDING    = "pending"
    RUNNING    = "running"
    REPAIRING  = "repairing"
    BLOCKED    = "blocked"
    VERIFIED   = "verified"
    PR_CREATED = "pr_created"
    COMPLETED  = "completed"
    FAILED     = "failed"
    CRASHED    = "crashed"
    ABANDONED  = "abandoned"

TERMINAL_STATES = {
    TaskState.COMPLETED,
    TaskState.FAILED,
    TaskState.CRASHED,
    TaskState.ABANDONED,
}

# States where watchdog's monitoring job is done (includes VERIFIED —
# the orchestrator handles verified -> pr_created -> completed).
WATCHDOG_EXIT_STATES = TERMINAL_STATES | {TaskState.VERIFIED}

ACTIVE_STATES = {TaskState.RUNNING, TaskState.REPAIRING, TaskState.BLOCKED}


# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
@dataclass
class Config:
    repo_root: Path
    orchestrator_dir: Path
    active_tasks_file: Path
    memory_file: Path
    daily_memory_dir: Path
    interval: int
    stall_timeout: int
    callback_retry_limit: int
    openclaw_bin: str
    swarm_agent_id: str
    event_mode: str

    @classmethod
    def load(cls) -> "Config":
        # REPO_ROOT: env > git rev-parse (but NOT from worktree)
        repo_root_env = os.environ.get("WATCHDOG_REPO_ROOT", "")
        if repo_root_env:
            repo_root = Path(repo_root_env)
        else:
            try:
                result = subprocess.run(
                    ["git", "rev-parse", "--show-toplevel"],
                    capture_output=True, text=True, timeout=5
                )
                repo_root = Path(result.stdout.strip())
            except Exception:
                repo_root = Path.cwd()

        orchestrator_dir = repo_root / ".clawdbot"

        # openclaw binary: env > well-known paths > nvm > PATH
        openclaw_bin = os.environ.get("OPENCLAW_BIN", "")
        if not openclaw_bin:
            import shutil
            # 1. Well-known install locations
            for candidate in [
                "/usr/local/bin/openclaw",
                str(Path.home() / ".local" / "bin" / "openclaw"),
            ]:
                p = Path(candidate)
                if p.is_file() and os.access(p, os.X_OK):
                    openclaw_bin = str(p)
                    break
            # 2. nvm node versions
            if not openclaw_bin:
                nvm_dir = Path.home() / ".nvm" / "versions" / "node"
                if nvm_dir.exists():
                    for node_bin in sorted(nvm_dir.glob("*/bin/openclaw"), reverse=True):
                        if os.access(node_bin, os.X_OK):
                            openclaw_bin = str(node_bin)
                            break
            # 3. PATH fallback
            if not openclaw_bin:
                openclaw_bin = shutil.which("openclaw") or ""

        return cls(
            repo_root=repo_root,
            orchestrator_dir=orchestrator_dir,
            active_tasks_file=orchestrator_dir / "active-tasks.json",
            memory_file=repo_root / "MEMORY.md",
            daily_memory_dir=repo_root / "memory",
            interval=int(os.environ.get("WATCHDOG_INTERVAL", "30")),
            stall_timeout=int(os.environ.get("STALL_TIMEOUT", "1800")),
            callback_retry_limit=int(os.environ.get("CALLBACK_RETRY_LIMIT", "3")),
            openclaw_bin=openclaw_bin,
            swarm_agent_id=os.environ.get("SWARM_AGENT_ID", ""),
            event_mode=os.environ.get("OPENCLAW_EVENT_MODE", "now"),
        )

    def validate(self) -> List[str]:
        """Return list of warnings (non-fatal issues)."""
        warnings = []
        if not self.active_tasks_file.exists():
            warnings.append(f"active-tasks.json not found: {self.active_tasks_file}")
        if not self.openclaw_bin:
            warnings.append("openclaw binary not found — notifications disabled")
        return warnings


# ---------------------------------------------------------------------------
# Task Registry
# ---------------------------------------------------------------------------
@dataclass
class Task:
    task_id: str
    session: str
    branch: str
    worktree: str
    backend: str
    agent: str
    status: str
    started_at: str
    launched_at: str = ""

    @property
    def state(self) -> TaskState:
        try:
            return TaskState(self.status)
        except ValueError:
            return TaskState.RUNNING

    @property
    def worktree_path(self) -> Path:
        return Path(self.worktree) if self.worktree else Path.cwd()


class TaskRegistry:
    def __init__(self, config: Config):
        self.config = config

    def _load(self) -> dict:
        try:
            with open(self.config.active_tasks_file) as f:
                return json.load(f)
        except Exception as e:
            logger.error(f"Failed to load active-tasks.json: {e}")
            return {"tasks": []}

    def _save(self, data: dict):
        try:
            import fcntl
            tmp = self.config.active_tasks_file.with_suffix(".tmp")
            with open(tmp, "w") as f:
                fcntl.flock(f, fcntl.LOCK_EX)
                json.dump(data, f, indent=2)
                fcntl.flock(f, fcntl.LOCK_UN)
            tmp.rename(self.config.active_tasks_file)
        except ImportError:
            # fcntl not available (Windows) — fall back to unprotected write
            tmp = self.config.active_tasks_file.with_suffix(".tmp")
            with open(tmp, "w") as f:
                json.dump(data, f, indent=2)
            tmp.rename(self.config.active_tasks_file)
        except Exception as e:
            logger.error(f"Failed to save active-tasks.json: {e}")

    def get(self, task_id: str) -> Optional[Task]:
        data = self._load()
        for t in data.get("tasks", []):
            if t.get("task_id") == task_id:
                return Task(
                    task_id=t["task_id"],
                    session=t.get("session", task_id),
                    branch=t.get("branch", ""),
                    worktree=t.get("worktree", ""),
                    backend=t.get("backend", "acpx"),
                    agent=t.get("agent", "claude"),
                    status=t.get("status", "running"),
                    started_at=t.get("started_at", ""),
                    launched_at=t.get("launched_at", ""),
                )
        return None

    def get_active(self) -> List[Task]:
        data = self._load()
        tasks = []
        for t in data.get("tasks", []):
            state = t.get("status", "running")
            if state in {s.value for s in ACTIVE_STATES}:
                tasks.append(self.get(t["task_id"]))
        return [t for t in tasks if t]

    def update_status(self, task_id: str, new_status: str):
        data = self._load()
        for t in data["tasks"]:
            if t["task_id"] == task_id:
                t["status"] = new_status
                break
        self._save(data)


# ---------------------------------------------------------------------------
# Memory Writer
# ---------------------------------------------------------------------------
class MemoryWriter:
    def __init__(self, config: Config):
        self.config = config

    def write_milestone(self, task_id: str, milestone: str):
        now = datetime.now(timezone.utc)
        time_str = now.strftime("%H:%M")
        date_str = now.strftime("%Y-%m-%d")

        # Daily memory
        self.config.daily_memory_dir.mkdir(parents=True, exist_ok=True)
        daily = self.config.daily_memory_dir / f"{date_str}.md"
        try:
            with open(daily, "a") as f:
                f.write(f"- **{time_str}** [{task_id}] {milestone}\n")
        except Exception as e:
            logger.warning(f"Failed to write daily memory: {e}")

        # MEMORY.md — update Latest Milestone line
        self._update_memory_field(
            task_id,
            "Latest Milestone",
            f"{time_str} - {milestone}"
        )
        logger.info(f"{task_id}: milestone — {milestone}")

    def update_status(self, task_id: str, status: str):
        self._update_memory_field(task_id, "Status", status)

    def update_callback_state(self, task_id: str, state: str):
        self._update_memory_field(task_id, "Callback", state)

    def _update_memory_field(self, task_id: str, field: str, value: str):
        if not self.config.memory_file.exists():
            return
        try:
            content = self.config.memory_file.read_text()
            # Use negative lookahead to stay within the current task section (stop at next ###)
            pattern = (
                r'(### ' + re.escape(task_id) + r':(?:(?!###).)*?)'
                r'(- \*\*' + re.escape(field) + r'\*\*: )([^\n]*)'
            )
            replacement = r'\g<1>\g<2>' + value.replace("\\", "\\\\")
            new_content = re.sub(pattern, replacement, content, flags=re.DOTALL, count=1)
            if new_content != content:
                self.config.memory_file.write_text(new_content)
        except Exception as e:
            logger.warning(f"Failed to update MEMORY.md ({field}): {e}")


# ---------------------------------------------------------------------------
# ACPX Client
# ---------------------------------------------------------------------------
class AcpxClient:
    def __init__(self, task: Task):
        self.task = task
        self._agent = task.agent if task.agent in ("claude", "codex", "gemini") else "claude"

    def _run(self, args: list[str], timeout: int = 15) -> Optional[str]:
        """Run acpx command for the task's worktree. Returns stdout or None on failure.

        Uses --cwd as a global arg so ACPX resolves session names relative to
        the worktree (sessions are bound to the cwd they were created with).
        """
        cwd_args = []
        if self.task.worktree_path.exists():
            cwd_args = ["--cwd", str(self.task.worktree_path)]
        cmd = ["acpx"] + cwd_args + [self._agent] + args
        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=timeout,
            )
            if result.returncode != 0:
                logger.debug(f"acpx exit {result.returncode}: {result.stderr.strip()[:200]}")
                return None
            return result.stdout
        except subprocess.TimeoutExpired:
            logger.warning(f"{self.task.task_id}: acpx timeout ({timeout}s): {' '.join(args[:3])}")
            return None
        except FileNotFoundError:
            logger.error("acpx not found in PATH")
            return None
        except Exception as e:
            logger.warning(f"acpx error: {e}")
            return None

    def session_alive(self) -> bool:
        """Check if the named ACPX session exists via `sessions show <name>`."""
        out = self._run(["sessions", "show", self.task.session], timeout=10)
        return out is not None

    def read_history(self, limit: int = 50) -> Optional[str]:
        """Read recent session output via `sessions history --limit N <name>`."""
        return self._run(
            ["sessions", "history", "--limit", str(limit), self.task.session],
            timeout=30,
        )

    def get_status(self) -> Optional[str]:
        """Query agent process status via `status -s <name>`.

        Returns status string (e.g. 'running', 'idle', 'dead') or None.
        """
        out = self._run(["status", "-s", self.task.session], timeout=10)
        if out is None:
            return None
        # `acpx <agent> status` outputs key:value lines
        for line in out.splitlines():
            lower = line.lower().strip()
            if lower.startswith("status:"):
                return lower.split(":", 1)[1].strip()
        # If output exists but no status line, assume running
        return "running"

    def send_prompt(self, message: str) -> bool:
        """Send a follow-up prompt via ACPX session IPC."""
        cwd_args = []
        if self.task.worktree_path.exists():
            cwd_args = ["--cwd", str(self.task.worktree_path)]
        result = subprocess.run(
            ["acpx"] + cwd_args + ["--approve-all", self._agent, "prompt",
             "-s", self.task.session, "--no-wait", message],
            capture_output=True,
            text=True,
            timeout=15,
        )
        return result.returncode == 0


# ---------------------------------------------------------------------------
# Callback Parser
# ---------------------------------------------------------------------------
class CallbackParser:
    # Matches the FIRST ```callback-json ... ``` block only
    PATTERN = re.compile(
        r'```callback-json\s*\n(.*?)\n```',
        re.DOTALL
    )

    @classmethod
    def extract(cls, text: str, expected_task_id: str) -> Optional[dict]:
        """
        Extract and validate callback-json blocks.
        Scans ALL blocks and returns the LAST valid one
        (avoids old placeholder blocks shadowing newer real callbacks).
        Returns parsed dict or None if no valid block found.
        """
        valid_statuses = {"completed", "failed", "need_clarification"}
        required = {"task_id", "status", "branch", "test_results"}

        last_valid: Optional[dict] = None

        for match in cls.PATTERN.finditer(text):
            raw = match.group(1).strip()
            try:
                cb = json.loads(raw)
            except json.JSONDecodeError:
                continue

            # task_id must match
            if cb.get("task_id") != expected_task_id:
                continue

            # status must be a known value (not a placeholder)
            if cb.get("status") not in valid_statuses:
                continue

            # required fields must exist
            if required - cb.keys():
                continue

            last_valid = cb

        if last_valid is None:
            # Log only if there were any blocks at all (avoids noise when no callback yet)
            if cls.PATTERN.search(text):
                logger.warning(f"callback found but none valid for task_id={expected_task_id}")
        return last_valid

    @staticmethod
    def fingerprint(cb: dict) -> str:
        return sha256(json.dumps(cb, sort_keys=True).encode()).hexdigest()


# ---------------------------------------------------------------------------
# Notifier
# ---------------------------------------------------------------------------
class Notifier:
    def __init__(self, config: Config):
        self.config = config

    def notify(self, text: str):
        if not self.config.openclaw_bin:
            logger.warning("notify: openclaw not found, skipping")
            return

        if self.config.swarm_agent_id:
            self._notify_directed(text)
        else:
            self._notify_broadcast(text)

    def _notify_directed(self, text: str):
        logger.info(f"notify: directed → agent={self.config.swarm_agent_id}")
        try:
            subprocess.run(
                [self.config.openclaw_bin, "agent",
                 "--agent", self.config.swarm_agent_id,
                 "--message", text, "--json"],
                capture_output=True, timeout=15,
            )
        except Exception as e:
            logger.warning(f"notify directed failed: {e}")

    def _notify_broadcast(self, text: str):
        logger.info("notify: broadcast via system event")
        try:
            result = subprocess.run(
                [self.config.openclaw_bin, "system", "event",
                 "--text", text,
                 "--mode", self.config.event_mode,
                 "--json"],
                capture_output=True, text=True, timeout=15,
            )
            if result.stdout.strip():
                logger.info(f"notify result: {result.stdout.strip()}")
            if result.returncode != 0:
                logger.warning(f"notify failed: {result.stderr.strip()[:200]}")
        except Exception as e:
            logger.warning(f"notify broadcast failed: {e}")


# ---------------------------------------------------------------------------
# Watchdog Core
# ---------------------------------------------------------------------------
IDLE_GRACE_SECONDS = 60  # wait this long after idle/dead before requesting correction


class Watchdog:
    def __init__(self, config: Config, task_id: Optional[str] = None):
        self.config = config
        self.task_id = task_id
        self.registry = TaskRegistry(config)
        self.memory = MemoryWriter(config)
        self.notifier = Notifier(config)
        # Per-task state
        self._seen_fingerprints: Dict[str, Set] = {}
        self._retry_counts: Dict[str, int] = {}
        self._idle_since: Dict[str, float] = {}  # task_id → timestamp when idle first seen

    # ------------------------------------------------------------------
    # Entry point
    # ------------------------------------------------------------------
    def run(self):
        logger.info("Watchdog started.")
        logger.info(f"  REPO_ROOT:   {self.config.repo_root}")
        logger.info(f"  TASKS FILE:  {self.config.active_tasks_file} "
                    f"({'exists' if self.config.active_tasks_file.exists() else 'MISSING'})")
        logger.info(f"  INTERVAL:    {self.config.interval}s")
        logger.info(f"  STALL:       {self.config.stall_timeout}s")
        logger.info(f"  OPENCLAW:    {self.config.openclaw_bin or 'NOT FOUND'}")
        logger.info(f"  MODE:        {'single (' + self.task_id + ')' if self.task_id else 'all tasks'}")

        for w in self.config.validate():
            logger.warning(f"CONFIG WARNING: {w}")

        self._run_recovery()

        while True:
            if self.task_id:
                task = self.registry.get(self.task_id)
                if task is None:
                    logger.error(f"Task '{self.task_id}' not found in registry.")
                    break
                if task.state in WATCHDOG_EXIT_STATES:
                    logger.info(f"Task '{self.task_id}' is in terminal state ({task.state}). Exiting.")
                    break
                done = self._monitor_task(task)
                if done:
                    logger.info(f"Task '{self.task_id}' reached terminal state. Watchdog done.")
                    break
            else:
                tasks = self.registry.get_active()
                if not tasks:
                    logger.info("No active tasks remaining. Exiting.")
                    break
                for task in tasks:
                    self._monitor_task(task)

            time.sleep(self.config.interval)

        logger.info("Watchdog stopped.")

    # ------------------------------------------------------------------
    # Recovery on startup
    # ------------------------------------------------------------------
    def _run_recovery(self):
        logger.info("Running recovery check...")
        if not self.config.active_tasks_file.exists():
            logger.warning("active-tasks.json missing — skipping recovery.")
            return

        tasks = self.registry.get_active()
        if not tasks:
            logger.info("No active tasks found.")
            return

        for task in tasks:
            client = AcpxClient(task)
            if client.session_alive():
                logger.info(f"Recovery: {task.task_id} — session alive.")
            else:
                logger.warning(f"Recovery: {task.task_id} — session DEAD → crashed.")
                self._mark_crashed(task)

    # ------------------------------------------------------------------
    # Per-task monitoring dispatch
    # ------------------------------------------------------------------
    def _monitor_task(self, task: Task) -> bool:
        """Returns True if task reached a terminal state."""
        return self._monitor_acpx(task)

    # ------------------------------------------------------------------
    # ACPX monitoring
    # ------------------------------------------------------------------
    def _monitor_acpx(self, task: Task) -> bool:
        client = AcpxClient(task)

        # 1. Session still alive?
        if not client.session_alive():
            logger.warning(f"{task.task_id}: ACPX session not found → crashed.")
            self._mark_crashed(task)
            return True

        # 2. Check for callback in session history
        history = client.read_history(limit=100)
        if history:
            cb = CallbackParser.extract(history, task.task_id)
            if cb:
                fp = CallbackParser.fingerprint(cb)
                seen = self._seen_fingerprints.setdefault(task.task_id, set())
                if fp in seen:
                    # Already processed — re-read registry for fresh state
                    fresh = self.registry.get(task.task_id)
                    return (fresh.state in WATCHDOG_EXIT_STATES) if fresh else True
                seen.add(fp)
                self.memory.write_milestone(task.task_id, "Agent completed (callback detected)")
                return self._handle_callback(task, client, cb)

        # 3. No callback yet — check agent status for stall/death
        agent_status = client.get_status()
        if agent_status in ("dead", "idle") and agent_status is not None:
            # Grace period: agent may still be writing the callback block
            first_seen = self._idle_since.get(task.task_id)
            now = time.monotonic()
            if first_seen is None:
                self._idle_since[task.task_id] = now
                logger.debug(f"{task.task_id}: agent status={agent_status}, starting grace period ({IDLE_GRACE_SECONDS}s)")
                return False
            if now - first_seen < IDLE_GRACE_SECONDS:
                return False
            # Grace period exceeded
            self._idle_since.pop(task.task_id, None)
            logger.warning(f"{task.task_id}: agent status={agent_status} for >{IDLE_GRACE_SECONDS}s, no callback → requesting correction")
            return self._request_callback_correction(
                task, client,
                f"Agent finished (status: {agent_status}) without callback-json"
            )

        # Agent still running — reset idle timer, check stall
        self._idle_since.pop(task.task_id, None)
        self._check_stall(task)
        return False

    def _check_stall(self, task: Task):
        """Warn if the task has been running longer than stall_timeout."""
        launched = task.launched_at or task.started_at
        if not launched:
            return
        try:
            started_ts = datetime.fromisoformat(launched.replace("Z", "+00:00"))
            elapsed = (datetime.now(timezone.utc) - started_ts).total_seconds()
            if elapsed > self.config.stall_timeout:
                logger.warning(
                    f"{task.task_id}: possible stall — running for "
                    f"{int(elapsed / 60)}m (limit {self.config.stall_timeout // 60}m)"
                )
                self.memory.write_milestone(
                    task.task_id,
                    f"WARNING: possible stall ({int(elapsed / 60)}m elapsed)"
                )
        except Exception:
            pass

    # ------------------------------------------------------------------
    # Callback handler — state machine
    # ------------------------------------------------------------------
    def _handle_callback(self, task: Task, client: AcpxClient, cb: dict) -> bool:
        status = cb.get("status")
        failed = int(cb.get("test_results", {}).get("failed", 0))
        summary = cb.get("summary", "No summary")

        logger.info(f"{task.task_id}: callback — status={status}, failed={failed}")
        self.memory.update_callback_state(task.task_id, "received")

        if status == "completed" and failed == 0:
            self._retry_counts.pop(task.task_id, None)  # reset retry counter on success
            # Transition to VERIFIED (not COMPLETED) — orchestrator handles
            # independent verification and optional PR creation before COMPLETED.
            self._transition(task, TaskState.VERIFIED, f"Verified: {summary}")
            self.notifier.notify(f"Task {task.task_id} verified (awaiting orchestrator): {summary}")
            return True  # Watchdog's monitoring job is done

        elif status == "completed" and failed > 0:
            self._transition(task, TaskState.REPAIRING, f"Completed with {failed} test failures")
            msg = (
                f"There are {failed} failing tests. "
                f"Fix them and output a new callback-json block."
            )
            success = client.send_prompt(msg)
            logger.info(f"{task.task_id}: repair prompt sent: {success}")
            # Reset fingerprint so next callback is not filtered as duplicate
            self._seen_fingerprints.get(task.task_id, set()).clear()
            return False  # Keep monitoring in repairing state

        elif status == "failed":
            self._transition(task, TaskState.FAILED, f"Failed: {summary}")
            self.notifier.notify(f"Task {task.task_id} FAILED: {summary}")
            return True

        elif status == "need_clarification":
            self._transition(task, TaskState.BLOCKED, f"Needs clarification: {summary}")
            self.notifier.notify(f"Task {task.task_id} needs clarification: {summary}")
            # Keep monitoring — orchestrator will forward user reply, agent will
            # resume and emit a new callback. Clear fingerprints so we detect it.
            self._seen_fingerprints.get(task.task_id, set()).clear()
            return False

        else:
            # Should not reach here — CallbackParser already validates status
            return self._request_callback_correction(
                task, client, f"Unexpected status: {status}"
            )

    # ------------------------------------------------------------------
    # Callback correction request
    # ------------------------------------------------------------------
    def _request_callback_correction(self, task: Task, client: AcpxClient, reason: str) -> bool:
        retries = self._retry_counts.get(task.task_id, 0) + 1
        self._retry_counts[task.task_id] = retries

        if retries <= self.config.callback_retry_limit:
            self.memory.update_callback_state(
                task.task_id, f"retry-{retries}/{self.config.callback_retry_limit}"
            )
            self.memory.write_milestone(
                task.task_id,
                f"Callback contract violation: {reason}. Correction {retries}/{self.config.callback_retry_limit}"
            )
            msg = (
                f"You finished without a valid callback-json block. {reason}. "
                f"Output a corrected callback-json block now with: "
                f"task_id, status, branch, files_changed, test_results, duration_minutes, summary."
            )
            client.send_prompt(msg)
            return False

        # Retry limit exceeded
        self._transition(task, TaskState.FAILED,
                         f"Callback contract violated after {self.config.callback_retry_limit} retries: {reason}")
        self.notifier.notify(f"Task {task.task_id} failed: callback contract violated ({reason})")
        return True

    # ------------------------------------------------------------------
    # State helpers
    # ------------------------------------------------------------------
    def _transition(self, task: Task, new_state: TaskState, milestone: str):
        self.registry.update_status(task.task_id, new_state.value)
        self.memory.update_status(task.task_id, new_state.value)
        self.memory.write_milestone(task.task_id, milestone)

    def _mark_crashed(self, task: Task):
        self._transition(task, TaskState.CRASHED, "Session lost (detected by watchdog)")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
def main():
    task_id = sys.argv[1] if len(sys.argv) > 1 else None
    config = Config.load()
    watchdog = Watchdog(config, task_id)

    # Graceful shutdown on SIGTERM / SIGINT
    def _handle_signal(signum, frame):
        logger.info(f"Watchdog received signal {signum}, shutting down.")
        sys.exit(0)

    signal.signal(signal.SIGTERM, _handle_signal)
    signal.signal(signal.SIGINT, _handle_signal)

    watchdog.run()


if __name__ == "__main__":
    main()
