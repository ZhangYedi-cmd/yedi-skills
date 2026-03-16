#!/usr/bin/env bash
set -euo pipefail

# Claude Code Dispatch — 任务执行脚本
# 在 tmux session 内运行，负责调用 claude CLI 并记录退出码

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <state-file> <log-file>" >&2
  exit 1
fi

STATE_FILE="$1"
LOG_FILE="$2"

# ---- 从 state.json 读取任务参数 ----
WORKDIR="$(jq -r '.workdir' "$STATE_FILE")"
PROMPT="$(jq -r '.prompt' "$STATE_FILE")"
MODEL="$(jq -r '.model // "claude-sonnet-4-6"' "$STATE_FILE")"
ALLOWED_TOOLS="$(jq -r '.allowed_tools // ""' "$STATE_FILE")"
TASK_ID="$(jq -r '.task_id' "$STATE_FILE")"

cd "$WORKDIR"
mkdir -p "$(dirname "$LOG_FILE")"

START_TS="$(date '+%Y-%m-%d %H:%M:%S')"
echo "[$START_TS] task=$TASK_ID model=$MODEL starting..." | tee -a "$LOG_FILE"

# ---- 记录退出码到 state.json ----
record_exit() {
  local code="$1"
  local now
  now="$(date -Iseconds)"
  TMP="$(jq --argjson code "$code" --arg ts "$now" \
    '.exit_code = $code | .last_attempt_finished_at = $ts' "$STATE_FILE" 2>/dev/null || true)"
  if [[ -n "$TMP" ]]; then
    echo "$TMP" > "$STATE_FILE"
  fi
}

trap 'record_exit "$?"' EXIT

# ---- 构造 claude 命令 ----
CLAUDE_ARGS=(
  -p "$PROMPT"
  --model "$MODEL"
  --dangerously-skip-permissions
)

if [[ -n "$ALLOWED_TOOLS" ]]; then
  CLAUDE_ARGS+=(--allowedTools "$ALLOWED_TOOLS")
fi

# ---- 执行 ----
set +e
claude "${CLAUDE_ARGS[@]}" 2>&1 | tee -a "$LOG_FILE"
EXIT_CODE=${PIPESTATUS[0]}
set -e

END_TS="$(date '+%Y-%m-%d %H:%M:%S')"
echo "[$END_TS] task=$TASK_ID exit_code=$EXIT_CODE" | tee -a "$LOG_FILE"

exit "$EXIT_CODE"
