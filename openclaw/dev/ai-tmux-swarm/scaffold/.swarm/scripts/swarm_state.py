#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import re
import shlex
import subprocess
import sys
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path

import fcntl

TERMINAL_STATUSES = {"done", "failed"}
VALID_STATUSES = {"pending", "running", "retrying", "done", "failed"}
VALID_ENGINES = {"codex", "claude"}
DEFAULT_MODELS = {
    "codex": "gpt-5.3-codex",
    "claude": "claude-sonnet-4-6",
}


def now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def slugify(value: str, fallback: str = "item") -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")
    return slug or fallback


def default_model_for(engine: str) -> str:
    return DEFAULT_MODELS.get(engine, DEFAULT_MODELS["codex"])


def resolve_path(base: Path, value: str) -> Path:
    path = Path(value).expanduser()
    if path.is_absolute():
        return path
    return (base / path).resolve()


def run_command(args: list[str], cwd: Path | None = None, check: bool = False) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, cwd=str(cwd) if cwd else None, text=True, capture_output=True, check=check)


def command_exists(name: str) -> bool:
    return subprocess.run(["bash", "-lc", f"command -v {shlex.quote(name)}"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0


def has_tmux_session(name: str) -> bool:
    if not command_exists("tmux"):
        return False
    return subprocess.run(["tmux", "has-session", "-t", name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0


def state_path_for(repo_root: Path) -> Path:
    return repo_root / ".swarm" / "state" / "tasks.json"


@contextmanager
def locked_state_file(state_path: Path):
    lock_path = state_path.with_suffix(state_path.suffix + ".lock")
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    with lock_path.open("a+", encoding="utf-8") as handle:
        fcntl.flock(handle.fileno(), fcntl.LOCK_EX)
        try:
            yield
        finally:
            fcntl.flock(handle.fileno(), fcntl.LOCK_UN)


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def task_map(state: dict) -> dict[str, dict]:
    return {task["id"]: task for task in state.get("tasks", [])}


def update_state_timestamp(state: dict) -> None:
    state["updated_at"] = now_iso()


def validate_engine(value: str, label: str) -> str:
    if value not in VALID_ENGINES:
        raise SystemExit(f"{label} must be one of: {', '.join(sorted(VALID_ENGINES))}")
    return value


def validate_manifest(repo_root: Path, manifest_path: Path, default_engine_override: str | None, default_model_override: str | None, chat_id_override: str | None) -> dict:
    try:
        manifest = read_json(manifest_path)
    except FileNotFoundError as exc:
        raise SystemExit(f"Manifest not found: {manifest_path}") from exc
    except json.JSONDecodeError as exc:
        raise SystemExit(f"Invalid manifest JSON: {manifest_path}: {exc}") from exc

    version = manifest.get("version", 1)
    defaults = manifest.get("defaults") or {}
    if not isinstance(defaults, dict):
        raise SystemExit("Manifest field 'defaults' must be an object.")

    tasks = manifest.get("tasks")
    if not isinstance(tasks, list) or not tasks:
        raise SystemExit("Manifest field 'tasks' must be a non-empty array.")

    repo_slug = slugify(repo_root.name, "repo")
    manifest_dir = manifest_path.parent

    default_engine = validate_engine(default_engine_override or defaults.get("engine") or "codex", "defaults.engine")
    default_model = default_model_override or defaults.get("model") or default_model_for(default_engine)
    default_reasoning = str(defaults.get("reasoning") or "high")
    default_base_branch = str(defaults.get("base_branch") or "main")
    try:
      default_max_restarts = int(defaults.get("max_restarts", 3))
    except (TypeError, ValueError) as exc:
      raise SystemExit("defaults.max_restarts must be an integer.") from exc
    if default_max_restarts < 0:
        raise SystemExit("defaults.max_restarts must be >= 0.")

    notify_mode = os.environ.get("SWARM_NOTIFY_MODE", "openclaw_event")
    if notify_mode not in {"openclaw_event", "telegram", "both", "none"}:
        raise SystemExit("SWARM_NOTIFY_MODE must be one of: openclaw_event, telegram, both, none")

    openclaw_event_mode = os.environ.get("OPENCLAW_EVENT_MODE", "now")
    if openclaw_event_mode not in {"now", "next-heartbeat"}:
        raise SystemExit("OPENCLAW_EVENT_MODE must be 'now' or 'next-heartbeat'")

    telegram_target = chat_id_override or os.environ.get("TELEGRAM_CHAT_ID", "")
    telegram_thread_id = os.environ.get("TELEGRAM_THREAD_ID", "")

    seen_ids: set[str] = set()
    seen_slugs: set[str] = set()
    seen_branches: set[str] = set()
    seen_sessions: set[str] = set()
    seen_workdirs: set[str] = set()
    built_tasks: list[dict] = []

    for raw_task in tasks:
        if not isinstance(raw_task, dict):
            raise SystemExit("Each task entry must be an object.")

        task_id = str(raw_task.get("id") or "").strip()
        if not task_id:
            raise SystemExit("Every task requires a non-empty string 'id'.")
        if task_id in seen_ids:
            raise SystemExit(f"Duplicate task id: {task_id}")
        seen_ids.add(task_id)

        task_slug = slugify(task_id, "task")
        if task_slug in seen_slugs:
            raise SystemExit(f"Task ids must remain unique after slugification: {task_id}")
        seen_slugs.add(task_slug)

        prompt_value = str(raw_task.get("prompt_file") or "").strip()
        if not prompt_value:
            raise SystemExit(f"Task {task_id} requires a prompt_file.")
        prompt_path = resolve_path(manifest_dir, prompt_value)
        if not prompt_path.is_file():
            raise SystemExit(f"Task {task_id} prompt not found: {prompt_path}")

        depends_on = raw_task.get("depends_on") or []
        if not isinstance(depends_on, list) or any(not isinstance(dep, str) or not dep.strip() for dep in depends_on):
            raise SystemExit(f"Task {task_id} depends_on must be an array of task ids.")
        depends_on = [dep.strip() for dep in depends_on]

        task_engine = raw_task.get("engine")
        if task_engine is not None:
            task_engine = validate_engine(str(task_engine), f"task {task_id} engine")
        else:
            task_engine = default_engine

        task_model = raw_task.get("model")
        if task_model is None:
            if raw_task.get("engine") and task_engine != default_engine:
                task_model = default_model_for(task_engine)
            else:
                task_model = default_model
        task_reasoning = str(raw_task.get("reasoning") or default_reasoning)
        task_base_branch = str(raw_task.get("base_branch") or default_base_branch)
        try:
            task_max_restarts = int(raw_task.get("max_restarts", default_max_restarts))
        except (TypeError, ValueError) as exc:
            raise SystemExit(f"Task {task_id} max_restarts must be an integer.") from exc
        if task_max_restarts < 0:
            raise SystemExit(f"Task {task_id} max_restarts must be >= 0.")

        branch = str(raw_task.get("branch") or f"swarm/{repo_slug}/{task_slug}")
        session_name = f"openclaw-{repo_slug}-{task_slug}"
        workdir = str((repo_root / ".swarm" / "worktree" / task_slug).resolve())
        log_file = str((repo_root / ".swarm" / "logs" / f"{task_slug}.log").resolve())

        if branch in seen_branches:
            raise SystemExit(f"Derived branch conflict: {branch}")
        if session_name in seen_sessions:
            raise SystemExit(f"Derived tmux session conflict: {session_name}")
        if workdir in seen_workdirs:
            raise SystemExit(f"Derived worktree conflict: {workdir}")
        seen_branches.add(branch)
        seen_sessions.add(session_name)
        seen_workdirs.add(workdir)

        built_tasks.append(
            {
                "id": task_id,
                "slug": task_slug,
                "description": str(raw_task.get("description") or task_id),
                "prompt_file": str(prompt_path),
                "prompt_ref": prompt_value,
                "depends_on": depends_on,
                "engine": task_engine,
                "model": str(task_model),
                "reasoning": task_reasoning,
                "base_branch": task_base_branch,
                "branch": branch,
                "max_restarts": task_max_restarts,
                "session_name": session_name,
                "workdir": workdir,
                "log_file": log_file,
                "status": "pending",
                "attempt_count": 0,
                "restart_count": 0,
                "last_exit_code": None,
                "last_attempt_started_at": None,
                "last_attempt_finished_at": None,
                "started_at": None,
                "completed_at": None,
                "updated_at": None,
                "note": "",
            }
        )

    ids = {task["id"] for task in built_tasks}
    adjacency: dict[str, list[str]] = {}
    for task in built_tasks:
        missing = [dep for dep in task["depends_on"] if dep not in ids]
        if missing:
            raise SystemExit(f"Task {task['id']} depends on unknown tasks: {', '.join(missing)}")
        adjacency[task["id"]] = task["depends_on"]

    visited: dict[str, int] = {}

    def dfs(node: str) -> None:
        state = visited.get(node, 0)
        if state == 1:
            raise SystemExit(f"Dependency cycle detected at task: {node}")
        if state == 2:
            return
        visited[node] = 1
        for dep in adjacency[node]:
            dfs(dep)
        visited[node] = 2

    for node in adjacency:
        dfs(node)

    timestamp = now_iso()
    state = {
        "version": int(version),
        "repo_root": str(repo_root.resolve()),
        "repo_slug": repo_slug,
        "manifest_path": str(manifest_path.resolve()),
        "created_at": timestamp,
        "updated_at": timestamp,
        "defaults": {
            "base_branch": default_base_branch,
            "engine": default_engine,
            "model": default_model,
            "reasoning": default_reasoning,
            "max_restarts": default_max_restarts,
        },
        "notify": {
            "mode": notify_mode,
            "openclaw_event_mode": openclaw_event_mode,
            "telegram_target": telegram_target,
            "telegram_thread_id": telegram_thread_id,
            "all_terminal_notified_at": None,
        },
        "tasks": built_tasks,
    }
    refresh_pending_notes(state)
    return state


def refresh_pending_notes(state: dict) -> None:
    tasks = task_map(state)
    for task in state.get("tasks", []):
        if task["status"] != "pending":
            continue
        waiting = [dep for dep in task["depends_on"] if tasks[dep]["status"] != "done"]
        if waiting:
            task["note"] = f"Waiting for dependencies: {', '.join(waiting)}"
        else:
            task["note"] = "Ready to start"


def load_state(state_path: Path) -> dict:
    if not state_path.exists():
        raise SystemExit(f"State file not found: {state_path}")
    state = read_json(state_path)
    for task in state.get("tasks", []):
        if task.get("status") not in VALID_STATUSES:
            raise SystemExit(f"Invalid task status in state: {task.get('id')}: {task.get('status')}")
    return state


def resolve_base_ref(repo_root: Path, base_branch: str) -> str:
    run_command(["git", "fetch", "origin", base_branch], cwd=repo_root)
    remote = run_command(["git", "rev-parse", "--verify", f"origin/{base_branch}"], cwd=repo_root)
    if remote.returncode == 0:
        return f"origin/{base_branch}"
    local = run_command(["git", "rev-parse", "--verify", base_branch], cwd=repo_root)
    if local.returncode == 0:
        return base_branch
    raise RuntimeError(f"Base branch not found: {base_branch}")


def ensure_worktree(repo_root: Path, task: dict) -> None:
    workdir = Path(task["workdir"])
    if workdir.exists():
        return

    workdir.parent.mkdir(parents=True, exist_ok=True)
    branch = task["branch"]
    base_ref = resolve_base_ref(repo_root, task["base_branch"])

    branch_exists = run_command(["git", "show-ref", "--verify", "--quiet", f"refs/heads/{branch}"], cwd=repo_root).returncode == 0
    if branch_exists:
        result = run_command(["git", "worktree", "add", str(workdir), branch], cwd=repo_root)
    else:
        result = run_command(["git", "worktree", "add", "-b", branch, str(workdir), base_ref], cwd=repo_root)

    if result.returncode != 0:
        raise RuntimeError((result.stderr or result.stdout or "git worktree add failed").strip())


def notify(state: dict, text: str) -> None:
    mode = state.get("notify", {}).get("mode", "openclaw_event")
    if mode == "none":
        return

    if mode in {"openclaw_event", "both"} and command_exists("openclaw"):
        subprocess.run(
            [
                "openclaw",
                "system",
                "event",
                "--text",
                text,
                "--mode",
                state["notify"].get("openclaw_event_mode", "now"),
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )

    target = state.get("notify", {}).get("telegram_target")
    if mode in {"telegram", "both"} and target and command_exists("openclaw"):
        args = [
            "openclaw",
            "message",
            "send",
            "--channel",
            "telegram",
            "--target",
            target,
            "--message",
            text,
        ]
        thread_id = state["notify"].get("telegram_thread_id")
        if thread_id:
            args.extend(["--thread-id", thread_id])
        subprocess.run(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False)


def notification_lines_for_transitions(before: dict[str, str], after_state: dict) -> list[str]:
    lines: list[str] = []
    repo_slug = after_state["repo_slug"]
    for task in after_state.get("tasks", []):
        previous = before.get(task["id"])
        current = task["status"]
        if previous == current:
            continue
        if current == "done":
            lines.append(f"✅ Swarm {repo_slug} task {task['id']} done.")
        elif current == "failed":
            lines.append(f"❌ Swarm {repo_slug} task {task['id']} failed: {task['note']}")
    return lines


def start_task(repo_root: Path, state_path: Path, task_id: str, retry: bool) -> str:
    with locked_state_file(state_path):
        state = load_state(state_path)
        tasks = task_map(state)
        task = tasks.get(task_id)
        if task is None:
            raise SystemExit(f"Unknown task id: {task_id}")
        if task["status"] in TERMINAL_STATUSES:
            raise SystemExit(f"Task already terminal: {task_id}")
        if has_tmux_session(task["session_name"]):
            raise SystemExit(f"tmux session already exists: {task['session_name']}")

        try:
            ensure_worktree(repo_root, task)
        except Exception as exc:
            task["status"] = "failed"
            task["completed_at"] = now_iso()
            task["updated_at"] = now_iso()
            task["last_exit_code"] = 125
            task["note"] = f"Launch setup failed: {exc}"
            update_state_timestamp(state)
            write_json(state_path, state)
            raise

        Path(task["log_file"]).parent.mkdir(parents=True, exist_ok=True)
        attempt_number = int(task.get("attempt_count", 0)) + 1
        if retry:
            task["restart_count"] = int(task.get("restart_count", 0)) + 1
        task["attempt_count"] = attempt_number
        task["status"] = "running"
        task["last_exit_code"] = None
        task["last_attempt_started_at"] = now_iso()
        task["started_at"] = task.get("started_at") or task["last_attempt_started_at"]
        task["completed_at"] = None
        task["updated_at"] = now_iso()
        if retry:
            task["note"] = f"Retry {task['restart_count']}/{task['max_restarts']} launched"
        else:
            task["note"] = f"Attempt {attempt_number} launched"
        update_state_timestamp(state)
        write_json(state_path, state)

    run_task_path = (repo_root / ".swarm" / "scripts" / "run_task.sh").resolve()
    cmd = [
        "bash",
        str(run_task_path),
        str(repo_root),
        str(state_path),
        task["id"],
        task["prompt_file"],
        task["log_file"],
        task["engine"],
        task["model"],
        task["reasoning"],
    ]

    launch = subprocess.run(
        ["tmux", "new-session", "-d", "-s", task["session_name"], "-c", task["workdir"], " ".join(shlex.quote(part) for part in cmd)],
        text=True,
        capture_output=True,
    )
    if launch.returncode != 0:
        with locked_state_file(state_path):
            state = load_state(state_path)
            task = task_map(state)[task_id]
            task["status"] = "failed"
            task["completed_at"] = now_iso()
            task["updated_at"] = now_iso()
            task["last_exit_code"] = 125
            task["last_attempt_finished_at"] = now_iso()
            task["note"] = (launch.stderr or launch.stdout or "tmux launch failed").strip()
            update_state_timestamp(state)
            write_json(state_path, state)
        raise SystemExit(f"Failed to launch tmux session {task['session_name']}: {(launch.stderr or launch.stdout).strip()}")

    repo_slug = slugify(repo_root.name, "repo")
    if retry:
        return f"🔁 Swarm {repo_slug} task {task_id} retry {task['restart_count']}/{task['max_restarts']} started."
    return f"▶️ Swarm {repo_slug} task {task_id} started (attempt {attempt_number})."


def cmd_init_run(args: argparse.Namespace) -> int:
    repo_root = Path(args.repo_root).resolve()
    manifest_path = resolve_path(repo_root, args.manifest or ".swarm/tasks.json")
    state = validate_manifest(repo_root, manifest_path, args.default_engine, args.default_model, args.chat_id)
    state_path = state_path_for(repo_root)
    with locked_state_file(state_path):
        write_json(state_path, state)
    print(state_path)
    return 0


def cmd_start_task(args: argparse.Namespace) -> int:
    repo_root = Path(args.repo_root).resolve()
    state_path = state_path_for(repo_root)
    message = start_task(repo_root, state_path, args.task_id, retry=args.retry)
    with locked_state_file(state_path):
        state = load_state(state_path)
    notify(state, message)
    print(message)
    return 0


def cmd_record_exit(args: argparse.Namespace) -> int:
    state_path = Path(args.state).resolve()
    exit_code = int(args.exit_code)
    with locked_state_file(state_path):
        state = load_state(state_path)
        tasks = task_map(state)
        if args.task_id not in tasks:
            raise SystemExit(f"Unknown task id: {args.task_id}")
        task = tasks[args.task_id]
        task["last_exit_code"] = exit_code
        task["last_attempt_finished_at"] = now_iso()
        task["updated_at"] = now_iso()
        if exit_code == 0:
            task["note"] = "Last attempt exited successfully; waiting for monitor reconciliation"
        else:
            task["note"] = f"Last attempt exited with code {exit_code}"
        update_state_timestamp(state)
        write_json(state_path, state)
    return 0


def cmd_monitor_once(args: argparse.Namespace) -> int:
    state_path = Path(args.state).resolve()
    repo_root = Path(load_state(state_path)["repo_root"]).resolve()

    launch_queue: list[tuple[str, bool]] = []
    notifications: list[str] = []
    strict_errors: list[str] = []

    with locked_state_file(state_path):
        state = load_state(state_path)
        before = {task["id"]: task["status"] for task in state.get("tasks", [])}
        tasks = task_map(state)

        for task in state.get("tasks", []):
            if task["status"] in TERMINAL_STATUSES:
                continue

            dependency_statuses = {dep: tasks[dep]["status"] for dep in task["depends_on"]}
            failed_dependencies = [dep for dep, status in dependency_statuses.items() if status == "failed"]
            if failed_dependencies:
                task["status"] = "failed"
                task["completed_at"] = now_iso()
                task["updated_at"] = now_iso()
                task["note"] = f"Blocked by failed dependencies: {', '.join(failed_dependencies)}"
                continue

            session_alive = has_tmux_session(task["session_name"])
            if session_alive:
                task["status"] = "running"
                task["updated_at"] = now_iso()
                if not task.get("note"):
                    task["note"] = f"Attempt {task['attempt_count']} running"
                continue

            if task["status"] == "running":
                if task.get("last_exit_code") == 0:
                    task["status"] = "done"
                    task["completed_at"] = now_iso()
                    task["updated_at"] = now_iso()
                    task["note"] = "Task completed successfully"
                elif int(task.get("restart_count", 0)) < int(task["max_restarts"]):
                    task["status"] = "retrying"
                    task["updated_at"] = now_iso()
                    task["note"] = f"Preparing retry {int(task['restart_count']) + 1}/{task['max_restarts']} after exit {task.get('last_exit_code', 'unknown')}"
                    launch_queue.append((task["id"], True))
                else:
                    task["status"] = "failed"
                    task["completed_at"] = now_iso()
                    task["updated_at"] = now_iso()
                    task["note"] = f"Reached max restarts after exit {task.get('last_exit_code', 'unknown')}"
            elif task["status"] == "retrying":
                launch_queue.append((task["id"], True))
            elif task["status"] == "pending":
                waiting = [dep for dep in task["depends_on"] if tasks[dep]["status"] != "done"]
                if not waiting:
                    launch_queue.append((task["id"], False))
                else:
                    task["note"] = f"Waiting for dependencies: {', '.join(waiting)}"
                    task["updated_at"] = now_iso()

        refresh_pending_notes(state)
        update_state_timestamp(state)
        write_json(state_path, state)

    for task_id, retry in launch_queue:
        try:
            notifications.append(start_task(repo_root, state_path, task_id, retry=retry))
        except SystemExit as exc:
            strict_errors.append(str(exc))
        except Exception as exc:
            strict_errors.append(str(exc))

    with locked_state_file(state_path):
        state = load_state(state_path)
        notifications.extend(notification_lines_for_transitions(before, state))
        all_terminal = all(task["status"] in TERMINAL_STATUSES for task in state.get("tasks", []))
        if all_terminal and not state["notify"].get("all_terminal_notified_at"):
            done_count = sum(1 for task in state["tasks"] if task["status"] == "done")
            failed_count = sum(1 for task in state["tasks"] if task["status"] == "failed")
            summary = f"🏁 Swarm {state['repo_slug']} finished: {done_count} done, {failed_count} failed."
            notifications.append(summary)
            state["notify"]["all_terminal_notified_at"] = now_iso()
            update_state_timestamp(state)
            write_json(state_path, state)

    seen: set[str] = set()
    for line in notifications:
        if not line or line in seen:
            continue
        seen.add(line)
        notify(state, line)

    if args.strict_launch and strict_errors:
        raise SystemExit("; ".join(strict_errors))
    return 0


def cmd_all_terminal(args: argparse.Namespace) -> int:
    state = load_state(Path(args.state).resolve())
    all_terminal = all(task["status"] in TERMINAL_STATUSES for task in state.get("tasks", []))
    return 0 if all_terminal else 1


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Manage ai-tmux-swarm state.")
    sub = parser.add_subparsers(dest="command", required=True)

    init_run = sub.add_parser("init-run")
    init_run.add_argument("--repo-root", required=True)
    init_run.add_argument("--manifest")
    init_run.add_argument("--default-engine")
    init_run.add_argument("--default-model")
    init_run.add_argument("--chat-id")
    init_run.set_defaults(func=cmd_init_run)

    start_task_cmd = sub.add_parser("start-task")
    start_task_cmd.add_argument("--repo-root", required=True)
    start_task_cmd.add_argument("--task-id", required=True)
    start_task_cmd.add_argument("--retry", action="store_true")
    start_task_cmd.set_defaults(func=cmd_start_task)

    record_exit = sub.add_parser("record-exit")
    record_exit.add_argument("--state", required=True)
    record_exit.add_argument("--task-id", required=True)
    record_exit.add_argument("--exit-code", required=True)
    record_exit.set_defaults(func=cmd_record_exit)

    monitor_once = sub.add_parser("monitor-once")
    monitor_once.add_argument("--state", required=True)
    monitor_once.add_argument("--strict-launch", action="store_true")
    monitor_once.set_defaults(func=cmd_monitor_once)

    all_terminal = sub.add_parser("all-terminal")
    all_terminal.add_argument("--state", required=True)
    all_terminal.set_defaults(func=cmd_all_terminal)

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
