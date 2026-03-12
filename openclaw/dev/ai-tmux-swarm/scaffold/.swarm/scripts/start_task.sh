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

ARGS=("$SCRIPT_DIR/swarm_state.py" start-task --repo-root "$REPO_ROOT" --task-id "$TASK_ID")
if [[ "$RETRY" == "1" ]]; then
  ARGS+=(--retry)
fi

python3 "${ARGS[@]}"
