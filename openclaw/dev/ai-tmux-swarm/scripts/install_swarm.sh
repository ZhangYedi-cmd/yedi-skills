#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <repo-path> [chat-id] [--engine codex|claude]" >&2
  exit 1
}

[[ $# -lt 1 ]] && usage

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE="$SKILL_DIR/scaffold/.swarm"

REPO="$1"
shift || true

CHAT_ID=""
if [[ $# -gt 0 && "${1:-}" != --* ]]; then
  CHAT_ID="$1"
  shift
fi

ENGINE="codex"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --engine)
      [[ $# -ge 2 ]] || usage
      ENGINE="$2"
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done

[[ "$ENGINE" == "codex" || "$ENGINE" == "claude" ]] || {
  echo "Error: --engine must be codex or claude" >&2
  exit 1
}

DEFAULT_MODEL="gpt-5.3-codex"
[[ "$ENGINE" == "claude" ]] && DEFAULT_MODEL="claude-sonnet-4-6"

mkdir -p "$REPO"
REPO_PATH="$(cd "$REPO" && pwd)"
cd "$REPO_PATH"

if [[ ! -d .git ]]; then
  git init -b main >/dev/null
fi

if ! git rev-parse HEAD >/dev/null 2>&1; then
  echo "# project" > README.md
  git add README.md
  git commit -m "chore: bootstrap repository" >/dev/null 2>&1 || true
fi

mkdir -p .swarm
if command -v rsync >/dev/null 2>&1; then
  rsync -a \
    --exclude 'config.env' \
    --exclude 'logs/' \
    --exclude 'state/' \
    --exclude 'worktree/' \
    "$SOURCE/" "$REPO_PATH/.swarm/"
else
  cp -R "$SOURCE/." "$REPO_PATH/.swarm/"
  rm -rf "$REPO_PATH/.swarm/logs" "$REPO_PATH/.swarm/state" "$REPO_PATH/.swarm/worktree"
fi

python3 - <<'PY' "$REPO_PATH/.swarm/tasks.json" "$ENGINE" "$DEFAULT_MODEL"
import json
import sys
from pathlib import Path

tasks_path = Path(sys.argv[1])
engine = sys.argv[2]
model = sys.argv[3]

data = json.loads(tasks_path.read_text())
defaults = data.setdefault("defaults", {})
defaults["engine"] = engine
defaults["model"] = model
tasks_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
PY

chmod +x "$REPO_PATH/.swarm/scripts/"*.sh "$REPO_PATH/.swarm/scripts/"*.py 2>/dev/null || true

echo "Installed ai-tmux-swarm scaffold to: $REPO_PATH/.swarm"
echo "Default engine: $ENGINE ($DEFAULT_MODEL)"

if [[ -f "$REPO_PATH/.swarm/config.env" ]]; then
  echo "Config: using existing .swarm/config.env"
else
  echo "Optional config: copy .swarm/config.env.example to .swarm/config.env to customize notifications or polling."
fi

if [[ -n "$CHAT_ID" ]]; then
  echo "Legacy chat-id preserved only as a runtime override. It is used when SWARM_NOTIFY_MODE=telegram|both and start_all receives a chat-id."
fi
