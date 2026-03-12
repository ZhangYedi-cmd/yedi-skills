#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 8 ]]; then
  echo "Usage: $0 <repo-root> <state-path> <task-id> <prompt-file> <log-file> <engine> <model> <reasoning>" >&2
  exit 1
fi

REPO_ROOT="$1"
STATE_PATH="$2"
TASK_ID="$3"
PROMPT_FILE="$4"
LOG_FILE="$5"
ENGINE="$6"
MODEL="$7"
REASONING="$8"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$REPO_ROOT/.swarm/config.env"

record_exit() {
  local exit_code="$1"
  python3 "$SCRIPT_DIR/swarm_state.py" record-exit \
    --state "$STATE_PATH" \
    --task-id "$TASK_ID" \
    --exit-code "$exit_code" >/dev/null 2>&1 || true
}

trap 'record_exit "$?"' EXIT

if [[ -f "$CONFIG_FILE" ]]; then
  set -a
  source "$CONFIG_FILE"
  set +a
fi

mkdir -p "$(dirname "$LOG_FILE")"

if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "Prompt file not found: $PROMPT_FILE" | tee -a "$LOG_FILE"
  exit 2
fi

START_TS="$(date '+%Y-%m-%d %H:%M:%S')"
echo "[$START_TS] task=$TASK_ID engine=$ENGINE model=$MODEL reasoning=$REASONING" | tee -a "$LOG_FILE"

set +e
case "$ENGINE" in
  codex)
    codex exec \
      --skip-git-repo-check \
      --model "$MODEL" \
      -c "model_reasoning_effort=$REASONING" \
      --dangerously-bypass-approvals-and-sandbox \
      - < "$PROMPT_FILE" 2>&1 | tee -a "$LOG_FILE"
    EXIT_CODE=${PIPESTATUS[0]}
    ;;
  claude)
    PROMPT_CONTENT="$(cat "$PROMPT_FILE")"
    CLAUDE_LOG_FORMAT="${SWARM_CLAUDE_LOG_FORMAT:-stream-json}"
    CLAUDE_INCLUDE_PARTIAL="${SWARM_CLAUDE_INCLUDE_PARTIAL_MESSAGES:-1}"
    CLAUDE_VERBOSE="${SWARM_CLAUDE_VERBOSE:-1}"
    CLAUDE_DEBUG="${SWARM_CLAUDE_DEBUG:-0}"
    CLAUDE_DEBUG_FILTER="${SWARM_CLAUDE_DEBUG_FILTER:-}"
    CLAUDE_DEBUG_TO_FILE="${SWARM_CLAUDE_DEBUG_TO_FILE:-1}"
    CLAUDE_DEBUG_LOG_FILE="${LOG_FILE%.log}.claude-debug.log"

    CLAUDE_ARGS=(
      -p "$PROMPT_CONTENT"
      --model "$MODEL"
      --effort "$REASONING"
      --dangerously-skip-permissions
    )

    case "$CLAUDE_LOG_FORMAT" in
      text)
        ;;
      json)
        CLAUDE_ARGS+=(--output-format json)
        ;;
      stream-json)
        CLAUDE_ARGS+=(--output-format stream-json)
        if [[ "$CLAUDE_INCLUDE_PARTIAL" == "1" ]]; then
          CLAUDE_ARGS+=(--include-partial-messages)
        fi
        ;;
      *)
        echo "Unsupported SWARM_CLAUDE_LOG_FORMAT: $CLAUDE_LOG_FORMAT" | tee -a "$LOG_FILE"
        exit 2
        ;;
    esac

    if [[ "$CLAUDE_VERBOSE" == "1" ]]; then
      CLAUDE_ARGS+=(--verbose)
    fi

    if [[ "$CLAUDE_DEBUG" == "1" ]]; then
      if [[ -n "$CLAUDE_DEBUG_FILTER" ]]; then
        CLAUDE_ARGS+=(-d "$CLAUDE_DEBUG_FILTER")
      else
        CLAUDE_ARGS+=(-d)
      fi
      if [[ "$CLAUDE_DEBUG_TO_FILE" == "1" ]]; then
        CLAUDE_ARGS+=(--debug-file "$CLAUDE_DEBUG_LOG_FILE")
        echo "[$START_TS] claude_debug_log=$CLAUDE_DEBUG_LOG_FILE" | tee -a "$LOG_FILE"
      fi
    fi

    claude "${CLAUDE_ARGS[@]}" 2>&1 | tee -a "$LOG_FILE"
    EXIT_CODE=${PIPESTATUS[0]}
    ;;
  *)
    echo "Unsupported engine: $ENGINE" | tee -a "$LOG_FILE"
    EXIT_CODE=2
    ;;
esac
set -e

END_TS="$(date '+%Y-%m-%d %H:%M:%S')"
echo "[$END_TS] task=$TASK_ID exit_code=$EXIT_CODE" | tee -a "$LOG_FILE"
exit "$EXIT_CODE"
