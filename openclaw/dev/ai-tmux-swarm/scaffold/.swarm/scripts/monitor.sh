#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SWARM_DIR="$REPO_ROOT/.swarm"
STATE_PATH="$SWARM_DIR/state/tasks.json"

swarm_log() {
  local level="$1" component="$2" msg="$3"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$component] [$level] $msg"
}

STRICT=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --once|--cron)
      shift
      ;;
    --strict-launch)
      STRICT=1
      shift
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 1
      ;;
  esac
done

ARGS=(monitor-once --state "$STATE_PATH")
if [[ "$STRICT" == "1" ]]; then
  ARGS+=(--strict-launch)
fi

python3 "$SCRIPT_DIR/swarm_state.py" "${ARGS[@]}"

if python3 "$SCRIPT_DIR/swarm_state.py" all-terminal --state "$STATE_PATH" >/dev/null; then
  swarm_log "INFO" "monitor" "all tasks terminal — removing cron entry"
  if command -v crontab >/dev/null 2>&1; then
    MARKER="ai-tmux-swarm:$REPO_ROOT"
    CURRENT_CRON="$(crontab -l 2>/dev/null || true)"
    FILTERED_CRON="$(printf '%s\n' "$CURRENT_CRON" | grep -Fv "$MARKER" || true)"
    printf '%s\n' "$FILTERED_CRON" | sed '/^[[:space:]]*$/d' | crontab -
    swarm_log "INFO" "monitor" "cron entry removed"
  fi
fi
