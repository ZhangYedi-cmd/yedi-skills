#!/usr/bin/env bash
# =============================================================================
# Launch — Start coding agent via ACPX (preferred) or tmux (fallback)
# =============================================================================
# Usage: launch.sh <task_id> <worktree_dir> <prompt_file> [backend] [agent]
#
# task_id:      Must match setup.sh's task_id
# worktree_dir: Working directory for the agent
# prompt_file:  File containing the task description
# backend:      "acpx" | "tmux" | "auto" (default: auto-detect)
# agent:        "claude" | "gemini" | "codex" | "aider" | "auto" (default: auto)
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Arguments
# ---------------------------------------------------------------------------
TASK_ID="${1:?Usage: launch.sh <task_id> <worktree_dir> <prompt_file> [backend] [agent]}"
WORKTREE_DIR="${2:?Usage: launch.sh <task_id> <worktree_dir> <prompt_file> [backend] [agent]}"
PROMPT_FILE="${3:?Usage: launch.sh <task_id> <worktree_dir> <prompt_file> [backend] [agent]}"
BACKEND="${4:-auto}"
AGENT="${5:-auto}"

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
TMUX_SOCKET="/tmp/openclaw-tmux/openclaw.sock"
REPO_ROOT="$(git rev-parse --show-toplevel)"
ORCHESTRATOR_DIR="${REPO_ROOT}/.clawdbot"
ACTIVE_TASKS_FILE="${ORCHESTRATOR_DIR}/active-tasks.json"
MEMORY_FILE="${REPO_ROOT}/MEMORY.md"
DAILY_MEMORY_DIR="${REPO_ROOT}/memory"
DATE_TODAY="$(date -u +%Y-%m-%d)"
TIME_NOW="$(date -u +%H:%M)"
TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

mkdir -p "$ORCHESTRATOR_DIR"

# Clear stale runtime artifacts for reused task IDs
rm -f \
    "${ORCHESTRATOR_DIR}/${TASK_ID}-callback.json" \
    "${ORCHESTRATOR_DIR}/${TASK_ID}-callback-retries" \
    "${ORCHESTRATOR_DIR}/${TASK_ID}-last-callback.sha"

# ---------------------------------------------------------------------------
# Auto-detect backend
# ---------------------------------------------------------------------------
if [ "$BACKEND" = "auto" ]; then
    if command -v acpx &>/dev/null; then
        BACKEND="acpx"
    elif command -v tmux &>/dev/null; then
        BACKEND="tmux"
    else
        echo "[launch] ERROR: Neither acpx nor tmux found."
        exit 1
    fi
fi
echo "[launch] Backend: ${BACKEND}"

# ---------------------------------------------------------------------------
# Auto-detect agent
# ---------------------------------------------------------------------------
if [ "$AGENT" = "auto" ]; then
    if command -v claude &>/dev/null; then
        AGENT="claude"
    elif command -v gemini &>/dev/null; then
        AGENT="gemini"
    elif command -v codex &>/dev/null; then
        AGENT="codex"
    elif command -v aider &>/dev/null; then
        AGENT="aider"
    else
        AGENT="none"
        echo "[launch] WARNING: No coding agent found."
    fi
fi
echo "[launch] Agent: ${AGENT}"

# ---------------------------------------------------------------------------
# Build full prompt with callback instruction
# ---------------------------------------------------------------------------
FULL_PROMPT_FILE=$(mktemp)
CURRENT_BRANCH="$(cd "$WORKTREE_DIR" && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"

cat > "$FULL_PROMPT_FILE" <<PROMPT_HEADER
# Task Assignment

You are an autonomous coding agent. Complete the following task in this
repository. When finished, you MUST output a structured callback.

## Working Directory
$(realpath "$WORKTREE_DIR")

## Task Description
$(cat "$PROMPT_FILE")

## Structured Callback (MANDATORY)

When you complete this task, output the following JSON block on a line by
itself, wrapped in triple backticks with language tag "callback-json":

\`\`\`callback-json
{
  "task_id": "${TASK_ID}",
  "status": "completed",
  "branch": "${CURRENT_BRANCH}",
  "files_changed": ["list all files you modified"],
  "test_results": { "passed": 0, "failed": 0, "skipped": 0 },
  "duration_minutes": 0,
  "summary": "Brief description of what was done"
}
\`\`\`

### Status Values
- **completed**: Task is done (fill in test_results and files_changed)
- **failed**: Task could not be completed (explain in summary)
- **need_clarification**: Blocked, need user input (explain in summary)

### Rules
1. Always commit your changes before outputting the callback
2. Run tests and report accurate test_results
3. The callback JSON must be valid JSON
4. Do not skip the callback — it is how the orchestrator knows you are done
PROMPT_HEADER

echo "[launch] Built prompt ($(wc -l < "$FULL_PROMPT_FILE") lines)."

# Save prompt for debugging
cp "$FULL_PROMPT_FILE" "${ORCHESTRATOR_DIR}/${TASK_ID}-prompt.md"

# ---------------------------------------------------------------------------
# Launch via selected backend
# ---------------------------------------------------------------------------
LAUNCH_PID="unknown"

if [ "$BACKEND" = "acpx" ]; then
    # -----------------------------------------------------------------------
    # ACPX backend — use `exec` (one-shot, client holds connection until done)
    # Runs inside a tmux pane so the process is not killed when shell exits.
    # Output is tee'd to <task_id>-output.log for watchdog to read.
    # -----------------------------------------------------------------------
    echo "[launch] Starting via ACPX (exec mode in tmux)..."

    # Resolve acpx agent subcommand
    case "$AGENT" in
        claude)  ACPX_AGENT="claude" ;;
        gemini)  ACPX_AGENT="gemini" ;;
        codex)   ACPX_AGENT="codex" ;;
        *)       ACPX_AGENT="claude" ;;
    esac

    OUTPUT_LOG="${ORCHESTRATOR_DIR}/${TASK_ID}-output.log"
    mkdir -p "$(dirname "$TMUX_SOCKET")"

    # Kill existing tmux session (idempotent)
    if tmux -S "$TMUX_SOCKET" has-session -t "$TASK_ID" 2>/dev/null; then
        tmux -S "$TMUX_SOCKET" kill-session -t "$TASK_ID"
    fi

    # Create tmux session with large scrollback
    tmux -S "$TMUX_SOCKET" new-session -d -s "$TASK_ID" -c "$WORKTREE_DIR" -x 220 -y 50
    tmux -S "$TMUX_SOCKET" set-option -t "$TASK_ID" history-limit 5000

    # Launch: acpx exec holds connection until [done], tee output to file
    PERSISTENT_PROMPT="${ORCHESTRATOR_DIR}/${TASK_ID}-prompt.md"
    tmux -S "$TMUX_SOCKET" send-keys -t "$TASK_ID" \
        "acpx --approve-all ${ACPX_AGENT} exec -f '${PERSISTENT_PROMPT}' 2>&1 | tee '${OUTPUT_LOG}'" Enter

    LAUNCH_PID=$(tmux -S "$TMUX_SOCKET" display-message -t "$TASK_ID" -p '#{pane_pid}' 2>/dev/null || echo "unknown")
    echo "[launch] ACPX exec session '${TASK_ID}' started in tmux (PID: ${LAUNCH_PID})."

    # Mark as acpx-exec so watchdog uses tmux-based monitoring (not acpx sessions show)
    BACKEND="acpx-exec"
    LAUNCH_PID="acpx-exec:${TASK_ID}"
    echo "[launch] ACPX session '${TASK_ID}' started."

fi

if [ "$BACKEND" = "tmux" ]; then
    # -----------------------------------------------------------------------
    # tmux backend (fallback)
    # -----------------------------------------------------------------------
    echo "[launch] Starting via tmux..."

    mkdir -p "$(dirname "$TMUX_SOCKET")"

    # Kill existing session (idempotent)
    if tmux -S "$TMUX_SOCKET" has-session -t "$TASK_ID" 2>/dev/null; then
        echo "[launch] Session '${TASK_ID}' exists. Killing and re-creating."
        tmux -S "$TMUX_SOCKET" kill-session -t "$TASK_ID"
    fi

    # Create session (5000-line scrollback so output is not lost)
    tmux -S "$TMUX_SOCKET" new-session -d -s "$TASK_ID" -c "$WORKTREE_DIR" -x 220 -y 50
    tmux -S "$TMUX_SOCKET" set-option -t "$TASK_ID" history-limit 5000

    # Detect agent command
    case "$AGENT" in
        claude)  AGENT_CMD="claude --print --permission-mode bypassPermissions" ;;
        gemini)  AGENT_CMD="gemini" ;;
        codex)   AGENT_CMD="codex" ;;
        aider)   AGENT_CMD="aider" ;;
        *)       AGENT_CMD="" ;;
    esac

    # Use the persistent prompt copy (not the temp file which gets deleted)
    PERSISTENT_PROMPT="${ORCHESTRATOR_DIR}/${TASK_ID}-prompt.md"
    OUTPUT_LOG="${ORCHESTRATOR_DIR}/${TASK_ID}-output.log"
    if [ -n "$AGENT_CMD" ]; then
        tmux -S "$TMUX_SOCKET" send-keys -t "$TASK_ID" \
            "${AGENT_CMD} < '${PERSISTENT_PROMPT}' 2>&1 | tee '${OUTPUT_LOG}'" Enter
    else
        tmux -S "$TMUX_SOCKET" send-keys -t "$TASK_ID" \
            "cat '${PERSISTENT_PROMPT}'" Enter
    fi

    LAUNCH_PID=$(tmux -S "$TMUX_SOCKET" display-message -t "$TASK_ID" -p '#{pane_pid}' 2>/dev/null || echo "unknown")
    echo "[launch] tmux session '${TASK_ID}' started (PID: ${LAUNCH_PID})."
fi

# ---------------------------------------------------------------------------
# Update active-tasks.json
# ---------------------------------------------------------------------------
if command -v jq &>/dev/null && [ -f "$ACTIVE_TASKS_FILE" ]; then
    TEMP_FILE=$(mktemp)
    jq --arg tid "$TASK_ID" \
       --arg ts "$TIMESTAMP" \
       --arg pid "$LAUNCH_PID" \
       --arg be "$BACKEND" \
       --arg ag "$AGENT" \
       '(.tasks[] | select(.task_id == $tid)) |= . + {
           "status": "running",
           "launched_at": $ts,
           "backend": $be,
           "agent": $ag,
           "pid": $pid
       }' "$ACTIVE_TASKS_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$ACTIVE_TASKS_FILE"
fi

# ---------------------------------------------------------------------------
# Update MEMORY.md
# ---------------------------------------------------------------------------
if [ -f "$MEMORY_FILE" ] && command -v sed &>/dev/null; then
    sed -i '' "/### ${TASK_ID}:/,/^### / {
        s/- \*\*Status\*\*: pending/- **Status**: in-progress/
        s/- \*\*Backend\*\*: .*/- **Backend**: ${BACKEND}/
        s/- \*\*Agent\*\*: .*/- **Agent**: ${AGENT}/
        s/- \*\*Latest Milestone\*\*: .*/- **Latest Milestone**: ${TIME_NOW} - Agent launched/
    }" "$MEMORY_FILE" 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# Write daily memory
# ---------------------------------------------------------------------------
DAILY_FILE="${DAILY_MEMORY_DIR}/${DATE_TODAY}.md"
if [ -f "$DAILY_FILE" ]; then
    echo "- **${TIME_NOW}** [${TASK_ID}] Agent launched (${BACKEND}/${AGENT})" >> "$DAILY_FILE"
fi

# ---------------------------------------------------------------------------
# Start watchdog for ALL backends (ACPX also needs callback detection + notification)
# ---------------------------------------------------------------------------
WATCHDOG_PY="$(dirname "$0")/watchdog.py"
if [ -f "$WATCHDOG_PY" ] && command -v python3 &>/dev/null; then
    echo "[launch] Starting watchdog (Python) for task '${TASK_ID}' (backend: ${BACKEND})."
    # Resolve gateway token: env > config file
    _resolve_gw_token() {
        if [ -n "${OPENCLAW_GATEWAY_TOKEN:-}" ]; then echo "$OPENCLAW_GATEWAY_TOKEN"; return; fi
        local cfg="${OPENCLAW_CONFIG_PATH:-$HOME/.clawdbot/openclaw.json}"
        if [ -f "$cfg" ] && command -v python3 &>/dev/null; then
            python3 -c "
import json
try:
    with open('$cfg') as f: d=json.load(f)
    print(d.get('gateway',{}).get('auth',{}).get('token',''))
except: pass
" 2>/dev/null
        fi
    }
    GW_TOKEN="${OPENCLAW_GATEWAY_TOKEN:-$(_resolve_gw_token)}"

    SWARM_AGENT_ID="${SWARM_AGENT_ID:-}" \
    WATCHDOG_INTERVAL="${WATCHDOG_INTERVAL:-30}" \
    OPENCLAW_GATEWAY_TOKEN="$GW_TOKEN" \
    WATCHDOG_REPO_ROOT="$REPO_ROOT" \
        nohup python3 "$WATCHDOG_PY" "$TASK_ID" > "${ORCHESTRATOR_DIR}/${TASK_ID}-watchdog.log" 2>&1 &
    WATCHDOG_PID=$!
    echo "$WATCHDOG_PID" > "${ORCHESTRATOR_DIR}/${TASK_ID}-watchdog.pid"
fi

# ---------------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------------
rm -f "$FULL_PROMPT_FILE"

echo ""
echo "[launch] Done for task '${TASK_ID}'."
echo "[launch]   Backend:  ${BACKEND}"
echo "[launch]   Agent:    ${AGENT}"
echo "[launch]   PID:      ${LAUNCH_PID}"
if [ "$BACKEND" = "tmux" ] || [ "$BACKEND" = "acpx-exec" ]; then
    echo "[launch]   Attach:   tmux -S ${TMUX_SOCKET} attach -t ${TASK_ID}"
elif [ "$BACKEND" = "acpx" ]; then
    echo "[launch]   Status:   acpx sessions show -s ${TASK_ID}"
fi
