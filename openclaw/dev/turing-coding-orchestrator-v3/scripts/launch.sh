#!/usr/bin/env bash
# =============================================================================
# Launch — Start coding agent via ACPX native session mode
# =============================================================================
# Usage: launch.sh <task_id> <worktree_dir> <prompt_file> [agent]
#
# task_id:      Must match setup.sh's task_id
# worktree_dir: Working directory for the agent
# prompt_file:  File containing the task description
# agent:        "claude" | "gemini" | "codex" | "auto" (default: auto)
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Arguments
# ---------------------------------------------------------------------------
TASK_ID="${1:?Usage: launch.sh <task_id> <worktree_dir> <prompt_file> [agent]}"
WORKTREE_DIR="${2:?Usage: launch.sh <task_id> <worktree_dir> <prompt_file> [agent]}"
PROMPT_FILE="${3:?Usage: launch.sh <task_id> <worktree_dir> <prompt_file> [agent]}"
AGENT="${4:-auto}"

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
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
# Verify ACPX is available
# ---------------------------------------------------------------------------
if ! command -v acpx &>/dev/null; then
    echo "[launch] ERROR: acpx not found in PATH."
    exit 1
fi

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
# Launch via ACPX native session mode
# ---------------------------------------------------------------------------
echo "[launch] Starting via ACPX (native session mode)..."

# Resolve acpx agent subcommand
case "$AGENT" in
    claude)  ACPX_AGENT="claude" ;;
    gemini)  ACPX_AGENT="gemini" ;;
    codex)   ACPX_AGENT="codex" ;;
    *)       ACPX_AGENT="claude" ;;
esac

PERSISTENT_PROMPT="${ORCHESTRATOR_DIR}/${TASK_ID}-prompt.md"

# Ensure the named session exists (idempotent — no-op if already created)
acpx --cwd "${WORKTREE_DIR}" ${ACPX_AGENT} sessions ensure --name "${TASK_ID}" \
&& echo "[launch] ACPX session '${TASK_ID}' ensured." \
|| { echo "[launch] ERROR: Failed to create ACPX session."; exit 1; }

# Submit prompt to a named ACPX session.
#   --approve-all: auto-approve tool use           (global opt, before agent)
#   --ttl 0      : queue owner stays alive indefinitely (global opt)
#   --cwd        : working directory for the agent  (global opt)
#   -s           : named session for watchdog to query later (agent opt)
#   --no-wait    : returns immediately; queue owner handles execution (agent opt)
acpx --approve-all --ttl 0 --cwd "${WORKTREE_DIR}" ${ACPX_AGENT} \
    -s "${TASK_ID}" \
    --no-wait \
    -f "${PERSISTENT_PROMPT}" \
&& echo "[launch] ACPX prompt submitted to session '${TASK_ID}'." \
|| { echo "[launch] ERROR: Failed to submit ACPX session."; exit 1; }

LAUNCH_PID="acpx:${TASK_ID}"
echo "[launch] ACPX session '${TASK_ID}' started (session-managed)."

# ---------------------------------------------------------------------------
# Update active-tasks.json
# ---------------------------------------------------------------------------
if command -v jq &>/dev/null && [ -f "$ACTIVE_TASKS_FILE" ]; then
    TEMP_FILE=$(mktemp)
    jq --arg tid "$TASK_ID" \
       --arg ts "$TIMESTAMP" \
       --arg pid "$LAUNCH_PID" \
       --arg ag "$AGENT" \
       '(.tasks[] | select(.task_id == $tid)) |= . + {
           "status": "running",
           "launched_at": $ts,
           "backend": "acpx",
           "agent": $ag,
           "pid": $pid
       }' "$ACTIVE_TASKS_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$ACTIVE_TASKS_FILE"
fi

# ---------------------------------------------------------------------------
# Update MEMORY.md
# ---------------------------------------------------------------------------
if [ -f "$MEMORY_FILE" ] && command -v sed &>/dev/null; then
    sed -i '' "/### ${TASK_ID}:/,/^### / {
        s/- \*\*Status\*\*: pending/- **Status**: running/
        s/- \*\*Agent\*\*: .*/- **Agent**: ${AGENT}/
        s/- \*\*Latest Milestone\*\*: .*/- **Latest Milestone**: ${TIME_NOW} - Agent launched/
    }" "$MEMORY_FILE" 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# Write daily memory
# ---------------------------------------------------------------------------
DAILY_FILE="${DAILY_MEMORY_DIR}/${DATE_TODAY}.md"
if [ -f "$DAILY_FILE" ]; then
    echo "- **${TIME_NOW}** [${TASK_ID}] Agent launched (acpx/${AGENT})" >> "$DAILY_FILE"
fi

# ---------------------------------------------------------------------------
# Start watchdog
# ---------------------------------------------------------------------------
WATCHDOG_PY="$(dirname "$0")/watchdog.py"
if [ -f "$WATCHDOG_PY" ] && command -v python3 &>/dev/null; then
    echo "[launch] Starting watchdog for task '${TASK_ID}'."

    SWARM_AGENT_ID="${SWARM_AGENT_ID:-}" \
    WATCHDOG_INTERVAL="${WATCHDOG_INTERVAL:-30}" \
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
echo "[launch]   Agent:    ${AGENT}"
echo "[launch]   PID:      ${LAUNCH_PID}"
echo "[launch]   History:  acpx --cwd ${WORKTREE_DIR} ${ACPX_AGENT} sessions history --limit 20 ${TASK_ID}"
echo "[launch]   Status:   acpx --cwd ${WORKTREE_DIR} ${ACPX_AGENT} sessions show ${TASK_ID}"
