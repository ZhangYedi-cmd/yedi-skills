#!/usr/bin/env bash
set -euo pipefail

# Claude Code Dispatch — 入口脚本
# 解析参数 → 写 state.json → 开 tmux session → 装 cron monitor

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---- 解析参数 ----
WORKDIR=""
TASK_NAME=""
PROMPT=""
AGENT_ID=""
FEISHU_TARGET=""
FEISHU_ACCOUNT=""
ALLOWED_TOOLS="Skill,Write,Read,WebSearch,WebFetch,Bash,Agent,Glob,Grep"
MAX_RETRIES=2
MODEL="claude-sonnet-4-6"

usage() {
  cat <<'EOF'
Usage: dispatch.sh --workdir <path> --task-name <name> --prompt <prompt> [options]

Required:
  --workdir          Claude Code 工作目录
  --task-name        任务显示名称
  --prompt           传给 claude -p 的提示

Options:
  --agent            回调 Agent ID
  --feishu-target    飞书群 chat_id
  --feishu-account   飞书账户 ID
  --allowed-tools    Claude Code 工具白名单 (默认: Skill,Write,Read,...)
  --max-retries      最大重试次数 (默认: 2)
  --model            Claude 模型 (默认: claude-sonnet-4-6)
  -h, --help         显示帮助
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workdir)       WORKDIR="$2"; shift 2 ;;
    --task-name)     TASK_NAME="$2"; shift 2 ;;
    --prompt)        PROMPT="$2"; shift 2 ;;
    --agent)         AGENT_ID="$2"; shift 2 ;;
    --feishu-target) FEISHU_TARGET="$2"; shift 2 ;;
    --feishu-account) FEISHU_ACCOUNT="$2"; shift 2 ;;
    --allowed-tools) ALLOWED_TOOLS="$2"; shift 2 ;;
    --max-retries)   MAX_RETRIES="$2"; shift 2 ;;
    --model)         MODEL="$2"; shift 2 ;;
    -h|--help)       usage ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$WORKDIR" || -z "$TASK_NAME" || -z "$PROMPT" ]]; then
  echo "Error: --workdir, --task-name, --prompt are required" >&2
  usage
fi

WORKDIR="$(cd "$WORKDIR" 2>/dev/null && pwd || echo "$WORKDIR")"

# ---- 读取项目级 config（CLI 参数优先）----
# 记录哪些参数是用户通过 CLI 显式传入的
_CLI_MODEL="$MODEL" _CLI_MAX_RETRIES="$MAX_RETRIES" _CLI_ALLOWED_TOOLS="$ALLOWED_TOOLS"

CONFIG_FILE="$WORKDIR/.claude-dispatch/config.json"
if [[ -f "$CONFIG_FILE" ]]; then
  echo "[dispatch] Loading config: $CONFIG_FILE"
  _cfg() { jq -r "$1 // empty" "$CONFIG_FILE" 2>/dev/null || true; }

  # 有默认值的参数：CLI 值等于初始默认值 → 视为未指定 → 用 config
  [[ "$_CLI_MODEL" == "claude-sonnet-4-6" ]]    && { v="$(_cfg '.model')";          [[ -n "$v" ]] && MODEL="$v"; }
  [[ "$_CLI_MAX_RETRIES" == "2" ]]              && { v="$(_cfg '.max_retries')";     [[ -n "$v" ]] && MAX_RETRIES="$v"; }
  [[ "$_CLI_ALLOWED_TOOLS" == "Skill,Write,Read,WebSearch,WebFetch,Bash,Agent,Glob,Grep" ]] && { v="$(_cfg '.allowed_tools')"; [[ -n "$v" ]] && ALLOWED_TOOLS="$v"; }

  # 无默认值的参数：CLI 为空 → 用 config
  [[ -z "$FEISHU_TARGET" ]]   && { v="$(_cfg '.notify.feishu_target')";  [[ -n "$v" ]] && FEISHU_TARGET="$v"; }
  [[ -z "$FEISHU_ACCOUNT" ]]  && { v="$(_cfg '.notify.feishu_account')"; [[ -n "$v" ]] && FEISHU_ACCOUNT="$v"; }
  [[ -z "$AGENT_ID" ]]        && { v="$(_cfg '.notify.agent_id')";       [[ -n "$v" ]] && AGENT_ID="$v"; }
fi

# ---- 生成任务 ID ----
# 中文任务名用 md5 前8位做 slug
TASK_SLUG="$(echo "$TASK_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')"
if [[ -z "$TASK_SLUG" ]]; then
  TASK_SLUG="$(printf '%s' "$TASK_NAME" | md5sum 2>/dev/null | cut -c1-8 || printf '%s' "$TASK_NAME" | md5 -q 2>/dev/null | cut -c1-8 || echo "task")"
fi
TASK_ID="${TASK_SLUG}-$(date +%Y%m%d%H%M%S)"
SESSION_NAME="claude-dispatch-${TASK_SLUG}"

# ---- 检查是否有同名 tmux session 在跑 ----
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  echo "Error: tmux session '$SESSION_NAME' already exists. Task may be running." >&2
  echo "  tmux attach -t $SESSION_NAME" >&2
  exit 1
fi

# ---- 创建目录结构 ----
DISPATCH_DIR="$WORKDIR/.claude-dispatch"
LOG_DIR="$DISPATCH_DIR/logs"
mkdir -p "$LOG_DIR"

STATE_FILE="$DISPATCH_DIR/state.json"
LOG_FILE="$LOG_DIR/${TASK_ID}.log"

# ---- 写 state.json ----
cat > "$STATE_FILE" <<STATEEOF
{
  "task_id": "${TASK_ID}",
  "task_name": "${TASK_NAME}",
  "status": "pending",
  "workdir": "${WORKDIR}",
  "prompt": $(printf '%s' "$PROMPT" | jq -Rs .),
  "model": "${MODEL}",
  "allowed_tools": "${ALLOWED_TOOLS}",
  "session_name": "${SESSION_NAME}",
  "log_file": "${LOG_FILE}",
  "exit_code": null,
  "max_retries": ${MAX_RETRIES},
  "retry_count": 0,
  "started_at": null,
  "completed_at": null,
  "notify": {
    "agent_id": "${AGENT_ID}",
    "feishu_target": "${FEISHU_TARGET}",
    "feishu_account": "${FEISHU_ACCOUNT}"
  }
}
STATEEOF

echo "[dispatch] State written: $STATE_FILE"

# ---- 更新状态为 running ----
NOW="$(date -Iseconds)"
TMP_STATE="$(jq --arg ts "$NOW" '.status = "running" | .started_at = $ts' "$STATE_FILE")"
echo "$TMP_STATE" > "$STATE_FILE"

# ---- 启动 tmux session ----
tmux new-session -d -s "$SESSION_NAME" -c "$WORKDIR" \
  "bash '${SCRIPT_DIR}/run_task.sh' '${STATE_FILE}' '${LOG_FILE}'; read -p 'Task finished. Press Enter to close.'"

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  echo "Error: Failed to create tmux session" >&2
  TMP_STATE="$(jq '.status = "failed" | .exit_code = 125' "$STATE_FILE")"
  echo "$TMP_STATE" > "$STATE_FILE"
  exit 1
fi

echo "[dispatch] tmux session started: $SESSION_NAME"
echo "  tmux attach -t $SESSION_NAME"

# ---- 安装 cron monitor ----
MARKER="claude-dispatch:${WORKDIR}"
BASH_BIN="$(command -v bash)"
MONITOR_CMD="PATH='$PATH'; '$BASH_BIN' '${SCRIPT_DIR}/monitor.sh' '${STATE_FILE}' >> '${LOG_DIR}/monitor.log' 2>&1"
CRON_LINE="* * * * * ${MONITOR_CMD} # ${MARKER}"

CURRENT_CRON="$(crontab -l 2>/dev/null || true)"
# 移除同项目旧条目
FILTERED="$(printf '%s\n' "$CURRENT_CRON" | grep -Fv "$MARKER" || true)"

{
  printf '%s\n' "$FILTERED" | sed '/^[[:space:]]*$/d'
  printf '%s\n' "$CRON_LINE"
} | crontab -

echo "[dispatch] cron monitor installed (every minute)"

# ---- 通知已派发 ----
OPENCLAW_BIN="$(command -v openclaw 2>/dev/null || true)"

if [[ -n "$FEISHU_TARGET" && -n "$FEISHU_ACCOUNT" && -n "$OPENCLAW_BIN" ]]; then
  "$OPENCLAW_BIN" message send \
    --channel feishu \
    --account "$FEISHU_ACCOUNT" \
    --target "$FEISHU_TARGET" \
    --message "🚀 已派发 Claude Code 任务「${TASK_NAME}」，完成后会自动通知你" \
    2>/dev/null && echo "[dispatch] Feishu notification sent" || echo "[dispatch] Feishu send failed"
fi

if [[ -n "$AGENT_ID" && -n "$OPENCLAW_BIN" ]]; then
  "$OPENCLAW_BIN" agent \
    --agent "$AGENT_ID" \
    --message "[task_dispatched] task_name=${TASK_NAME} task_id=${TASK_ID} workdir=${WORKDIR} session=${SESSION_NAME}" \
    2>/dev/null && echo "[dispatch] Agent notified" || echo "[dispatch] Agent notify failed"
fi

echo "[dispatch] Done. Task '$TASK_NAME' is running."
echo "  State: $STATE_FILE"
echo "  Log:   $LOG_FILE"
echo "  tmux:  tmux attach -t $SESSION_NAME"
