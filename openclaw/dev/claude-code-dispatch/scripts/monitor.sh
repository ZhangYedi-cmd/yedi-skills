#!/usr/bin/env bash
set -euo pipefail

# Claude Code Dispatch — cron 监控脚本
# 每分钟由 cron 调用，检查 tmux session 状态，更新 state.json，触发通知/重试

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <state-file>" >&2
  exit 1
fi

STATE_FILE="$1"

if [[ ! -f "$STATE_FILE" ]]; then
  echo "[monitor] State file not found: $STATE_FILE" >&2
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCLAW_BIN="$(command -v openclaw 2>/dev/null || true)"
NOW="$(date -Iseconds)"

# ---- 读取状态 ----
STATUS="$(jq -r '.status' "$STATE_FILE")"
SESSION_NAME="$(jq -r '.session_name' "$STATE_FILE")"
TASK_NAME="$(jq -r '.task_name' "$STATE_FILE")"
TASK_ID="$(jq -r '.task_id' "$STATE_FILE")"
EXIT_CODE="$(jq -r '.exit_code // "null"' "$STATE_FILE")"
MAX_RETRIES="$(jq -r '.max_retries // 2' "$STATE_FILE")"
RETRY_COUNT="$(jq -r '.retry_count // 0' "$STATE_FILE")"
WORKDIR="$(jq -r '.workdir' "$STATE_FILE")"
LOG_FILE="$(jq -r '.log_file' "$STATE_FILE")"
AGENT_ID="$(jq -r '.notify.agent_id // ""' "$STATE_FILE")"
FEISHU_TARGET="$(jq -r '.notify.feishu_target // ""' "$STATE_FILE")"
FEISHU_ACCOUNT="$(jq -r '.notify.feishu_account // ""' "$STATE_FILE")"

# ---- 辅助函数（必须在调用前定义）----
remove_cron() {
  if command -v crontab >/dev/null 2>&1; then
    MARKER="claude-dispatch:${WORKDIR}"
    CURRENT="$(crontab -l 2>/dev/null || true)"
    FILTERED="$(printf '%s\n' "$CURRENT" | grep -Fv "$MARKER" || true)"
    printf '%s\n' "$FILTERED" | sed '/^[[:space:]]*$/d' | crontab -
    echo "[monitor] cron removed for $WORKDIR"
  fi
}

notify_feishu() {
  local msg="$1"
  if [[ -n "$FEISHU_TARGET" && -n "$FEISHU_ACCOUNT" && -n "$OPENCLAW_BIN" ]]; then
    "$OPENCLAW_BIN" message send \
      --channel feishu \
      --account "$FEISHU_ACCOUNT" \
      --target "$FEISHU_TARGET" \
      --message "$msg" 2>/dev/null || true
  fi
}

notify_agent() {
  local msg="$1"
  if [[ -n "$AGENT_ID" && -n "$OPENCLAW_BIN" ]]; then
    "$OPENCLAW_BIN" agent \
      --agent "$AGENT_ID" \
      --message "$msg" 2>/dev/null || true
  fi
}

get_output_summary() {
  if [[ -f "$LOG_FILE" ]]; then
    tail -c 2000 "$LOG_FILE" | tr '\n' ' ' | cut -c1-1500
  else
    echo "日志文件不存在"
  fi
}

calc_duration() {
  local started
  started="$(jq -r '.started_at // ""' "$STATE_FILE")"
  if [[ -z "$started" ]]; then
    echo "未知"
    return
  fi
  local start_epoch end_epoch delta
  # macOS: 用 python3 解析 ISO 8601，兼容性最好
  start_epoch="$(python3 -c "
from datetime import datetime, timezone
import sys
s = '${started}'
try:
    dt = datetime.fromisoformat(s)
    print(int(dt.timestamp()))
except:
    print(0)
" 2>/dev/null || echo 0)"
  end_epoch="$(date +%s)"
  delta=$(( end_epoch - start_epoch ))
  if [[ $delta -lt 0 ]]; then delta=0; fi
  if [[ $delta -lt 60 ]]; then
    echo "${delta}秒"
  elif [[ $delta -lt 3600 ]]; then
    echo "$(( delta / 60 ))分$(( delta % 60 ))秒"
  else
    echo "$(( delta / 3600 ))小时$(( (delta % 3600) / 60 ))分"
  fi
}

# ---- 已经是终态，移除 cron 退出 ----
if [[ "$STATUS" == "done" || "$STATUS" == "failed" ]]; then
  remove_cron
  exit 0
fi

# ---- 检查 tmux session ----
SESSION_ALIVE=0
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  SESSION_ALIVE=1
fi

# ---- 状态机 ----
if [[ "$SESSION_ALIVE" == "1" ]]; then
  # 还在跑，不动
  echo "[monitor] $TASK_ID: running (tmux alive)"
  exit 0
fi

# tmux session 已结束，根据 exit code 决定下一步
echo "[monitor] $TASK_ID: tmux session ended, exit_code=$EXIT_CODE"

if [[ "$EXIT_CODE" == "0" ]]; then
  # ---- 成功 ----
  DURATION="$(calc_duration)"
  TMP="$(jq --arg ts "$NOW" '.status = "done" | .completed_at = $ts' "$STATE_FILE")"
  echo "$TMP" > "$STATE_FILE"
  echo "[monitor] $TASK_ID: done"

  SUMMARY="$(get_output_summary)"

  # 飞书通知（简洁，不 dump 日志内容）
  notify_feishu "$(cat <<EOF
✅ 任务完成

📋 任务：${TASK_NAME}
⏰ 耗时：${DURATION}

详细结果稍后由 Agent 整理推送，也可直接查看工作目录
EOF
)"

  # Agent 回调（带完整摘要，由 Agent 整理后通知用户）
  notify_agent "[task_complete] task_name=${TASK_NAME} task_id=${TASK_ID} feishu_target=${FEISHU_TARGET}
结果摘要:
${SUMMARY:0:1200}"

  remove_cron

elif [[ "$RETRY_COUNT" -lt "$MAX_RETRIES" ]]; then
  # ---- 重试 ----
  NEW_RETRY=$(( RETRY_COUNT + 1 ))
  TMP="$(jq --argjson r "$NEW_RETRY" --arg ts "$NOW" \
    '.status = "retrying" | .retry_count = $r | .exit_code = null | .last_retry_at = $ts' "$STATE_FILE")"
  echo "$TMP" > "$STATE_FILE"
  echo "[monitor] $TASK_ID: retrying ($NEW_RETRY/$MAX_RETRIES)"

  # 通知正在重试
  notify_feishu "🔄 任务「${TASK_NAME}」失败，正在自动重试（${NEW_RETRY}/${MAX_RETRIES}）"

  # 更新状态为 running
  TMP="$(jq --arg ts "$NOW" '.status = "running"' "$STATE_FILE")"
  echo "$TMP" > "$STATE_FILE"

  # 重新启动 tmux
  tmux new-session -d -s "$SESSION_NAME" -c "$WORKDIR" \
    "bash '${SCRIPT_DIR}/run_task.sh' '${STATE_FILE}' '${LOG_FILE}'; read -p 'Task finished. Press Enter to close.'"

  if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "[monitor] $TASK_ID: retry tmux started"
  else
    echo "[monitor] $TASK_ID: retry tmux failed" >&2
    TMP="$(jq --arg ts "$NOW" '.status = "failed" | .completed_at = $ts | .exit_code = 125' "$STATE_FILE")"
    echo "$TMP" > "$STATE_FILE"
    notify_feishu "❌ 任务「${TASK_NAME}」重试启动失败"
    notify_agent "[task_failed] task_name=${TASK_NAME} task_id=${TASK_ID} reason=tmux_retry_launch_failed"
    remove_cron
  fi

else
  # ---- 重试用完，标记失败 ----
  DURATION="$(calc_duration)"
  TMP="$(jq --arg ts "$NOW" '.status = "failed" | .completed_at = $ts' "$STATE_FILE")"
  echo "$TMP" > "$STATE_FILE"
  echo "[monitor] $TASK_ID: failed (retries exhausted)"

  notify_feishu "$(cat <<EOF
❌ 任务失败

📋 任务：${TASK_NAME}
⏰ 耗时：${DURATION}
🔄 已重试：${RETRY_COUNT}/${MAX_RETRIES}

请检查日志：${LOG_FILE}
EOF
)"

  notify_agent "[task_failed] task_name=${TASK_NAME} task_id=${TASK_ID} feishu_target=${FEISHU_TARGET} retries=${RETRY_COUNT}/${MAX_RETRIES}"

  remove_cron
fi
