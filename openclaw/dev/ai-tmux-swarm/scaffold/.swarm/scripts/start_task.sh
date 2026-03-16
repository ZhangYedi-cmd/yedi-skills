#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <task-id> [--retry]" >&2
  exit 1
fi

TASK_ID="$1"
shift || true

RETRY=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --retry)
      RETRY=1
      shift
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

swarm_log() {
  local level="$1" component="$2" msg="$3"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$component] [$level] $msg"
}

swarm_log "INFO" "start-task" "task=$TASK_ID retry=$RETRY"

ARGS=("$SCRIPT_DIR/swarm_state.py" start-task --repo-root "$REPO_ROOT" --task-id "$TASK_ID")
if [[ "$RETRY" == "1" ]]; then
  ARGS+=(--retry)
fi

set +e
python3 "${ARGS[@]}"
rc=$?
set -e

if [[ $rc -eq 0 ]]; then
  swarm_log "INFO" "start-task" "task=$TASK_ID started successfully"
else
  swarm_log "ERROR" "start-task" "task=$TASK_ID start failed (exit $rc)"
fi
exit $rc
