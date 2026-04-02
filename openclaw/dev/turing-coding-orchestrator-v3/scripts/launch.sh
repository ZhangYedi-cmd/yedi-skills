#!/usr/bin/env bash
# =============================================================================
# Launch — Start coding agent via ACPX native session mode
# =============================================================================
# Usage: launch.sh <task_id> <worktree_dir> [prompt_file] [agent]
#
# task_id:      Must match setup.sh's task_id
# worktree_dir: Working directory for the agent
# prompt_file:  File containing the task spec or description (optional —
#               auto-resolves: .clawdbot/{task_id}-spec.md > {task_id}-desc.md)
# agent:        "claude" | "gemini" | "codex" | "auto" (default: auto)
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Arguments
# ---------------------------------------------------------------------------
TASK_ID="${1:?Usage: launch.sh <task_id> <worktree_dir> [prompt_file] [agent]}"
WORKTREE_DIR="${2:?Usage: launch.sh <task_id> <worktree_dir> [prompt_file] [agent]}"
PROMPT_FILE="${3:-}"
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
    "${ORCHESTRATOR_DIR}/${TASK_ID}-last-callback.sha" \
    "${ORCHESTRATOR_DIR}/${TASK_ID}-full-prompt.md"
# Note: do NOT clear {task_id}-techplan.md and {task_id}-spec.md here —
# they are produced by upstream SKILLs (techplan-agent-v2 / task-spec-gen)
# and may still be valid for a re-launch. Clearing them would force the user
# to re-run the entire spec generation flow. These are only overwritten when
# the upstream SKILLs are explicitly re-run.

# ---------------------------------------------------------------------------
# Auto-resolve prompt file: spec > desc > error
# ---------------------------------------------------------------------------
if [ -z "$PROMPT_FILE" ] || [ ! -f "$PROMPT_FILE" ]; then
    SPEC_FILE="${ORCHESTRATOR_DIR}/${TASK_ID}-spec.md"
    DESC_FILE="${ORCHESTRATOR_DIR}/${TASK_ID}-desc.md"
    if [ -f "$SPEC_FILE" ]; then
        PROMPT_FILE="$SPEC_FILE"
        echo "[launch] Auto-resolved prompt: ${SPEC_FILE} (spec)"
    elif [ -f "$DESC_FILE" ]; then
        PROMPT_FILE="$DESC_FILE"
        echo "[launch] Auto-resolved prompt: ${DESC_FILE} (raw description)"
    else
        echo "[launch] ERROR: No prompt file found. Provide as arg3 or ensure .clawdbot/{task_id}-spec.md or {task_id}-desc.md exists."
        exit 1
    fi
fi

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
TASK_CONTENT="$(cat "$PROMPT_FILE")"

# ---------------------------------------------------------------------------
# Detect spec mode vs raw mode
# ---------------------------------------------------------------------------
SPEC_MODE=false
if echo "$TASK_CONTENT" | grep -qE '## Tasks|## Acceptance Criteria|### Task [0-9]'; then
    SPEC_MODE=true
    echo "[launch] Detected structured spec — using spec-driven prompt template."
else
    echo "[launch] No spec markers found — using raw prompt template."
fi

# Check for tech plan reference file
TECHPLAN_FILE="${ORCHESTRATOR_DIR}/${TASK_ID}-techplan.md"
HAS_TECHPLAN=false
if [ -f "$TECHPLAN_FILE" ]; then
    HAS_TECHPLAN=true
    # Copy tech plan to worktree so agent can read it
    WORKTREE_CLAWDBOT="${WORKTREE_DIR}/.clawdbot"
    mkdir -p "$WORKTREE_CLAWDBOT"
    cp "$TECHPLAN_FILE" "${WORKTREE_CLAWDBOT}/${TASK_ID}-techplan.md"
    echo "[launch] Tech plan copied to worktree: .clawdbot/${TASK_ID}-techplan.md"
fi

# ---------------------------------------------------------------------------
# Build prompt: Spec mode (structured spec with hard constraints)
# ---------------------------------------------------------------------------
if [ "$SPEC_MODE" = true ]; then
    cat > "$FULL_PROMPT_FILE" <<PROMPT_SPEC
# Task Assignment — Spec-Driven Mode

You are an autonomous coding agent executing a **structured task specification**.
You MUST follow the spec precisely. This is a contract, not a suggestion.

## Working Directory
$(realpath "$WORKTREE_DIR")

## Execution Rules (MANDATORY)

### 1. Strict Spec Compliance
- Execute tasks **in the order listed** in the spec
- Only modify files explicitly listed in the spec's "Files" sections
- Do NOT add features, refactors, or "improvements" beyond what the spec describes
- If the spec lists "Off-limits" or "Boundaries", do NOT touch those files under any circumstances
- If the spec lists "Constraint", follow it exactly

### 2. Test-Driven Development (per task)
For each task that has a "Test" field in the spec:
1. Write the test first (it should fail or not compile initially)
2. Implement the minimal code to make the test pass
3. Verify all tests pass (existing + new)
4. Check incremental line coverage ≥ 60% (if coverage command provided in spec)
5. Commit with a descriptive message referencing the task

For tasks without a "Test" field (e.g., pure styling, config changes):
1. Implement the change
2. Verify existing tests still pass
3. Commit

### 3. Acceptance Criteria Verification
Before outputting the callback, verify EVERY acceptance criterion listed in the spec:
- Run the exact validation commands specified in the spec
- If any criterion fails, fix it before declaring completion
- In the callback summary, list each criterion and its pass/fail status

### 4. When Information is Insufficient — Three-Layer Resolution
Follow in order. Do NOT skip layers:
1. **Spec is authoritative** — follow it directly
2. **Tech plan is supplementary** — if spec lacks detail on interfaces, types,
   or interaction rules, read \`.clawdbot/${TASK_ID}-techplan.md\` (focus on 第五章 模块详细设计)
3. **Ask via callback** — if BOTH spec and tech plan are insufficient:
   → status: "need_clarification"
   → summary: describe exactly what information you need
   → Do NOT guess, do NOT improvise, do NOT proceed without the answer

If spec and tech plan contradict each other, **spec wins**.

---

## Task Specification

${TASK_CONTENT}

PROMPT_SPEC

# ---------------------------------------------------------------------------
# Build prompt: Raw mode (backward compatible, no spec)
# ---------------------------------------------------------------------------
else
    cat > "$FULL_PROMPT_FILE" <<PROMPT_RAW
# Task Assignment

You are an autonomous coding agent. Complete the following task in this
repository. When finished, you MUST output a structured callback.

## Working Directory
$(realpath "$WORKTREE_DIR")

## Task Description

${TASK_CONTENT}

PROMPT_RAW
fi

# ---------------------------------------------------------------------------
# Append tech plan reference (if available, both modes)
# ---------------------------------------------------------------------------
if [ "$HAS_TECHPLAN" = true ]; then
    cat >> "$FULL_PROMPT_FILE" <<TECHPLAN_REF

## Reference: Technical Plan

完整技术方案位于 \`.clawdbot/${TASK_ID}-techplan.md\`，包含接口定义、类型结构、
交互流程、边界条件等补充信息。当任务描述中的细节不够明确时，查阅技术方案第五章。

TECHPLAN_REF
fi

# ---------------------------------------------------------------------------
# Append callback schema (same for both modes)
# ---------------------------------------------------------------------------
cat >> "$FULL_PROMPT_FILE" <<CALLBACK_SCHEMA
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
CALLBACK_SCHEMA

echo "[launch] Built prompt ($(wc -l < "$FULL_PROMPT_FILE") lines, mode: $([ "$SPEC_MODE" = true ] && echo 'spec' || echo 'raw'))."

# Save full prompt (separate from user's original prompt file)
cp "$FULL_PROMPT_FILE" "${ORCHESTRATOR_DIR}/${TASK_ID}-full-prompt.md"

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

PERSISTENT_PROMPT="${ORCHESTRATOR_DIR}/${TASK_ID}-full-prompt.md"

# Ensure the named session exists (idempotent — no-op if already created)
# --approve-all required: without it, nonInteractivePermissions=deny blocks Agent init
acpx --approve-all --cwd "${WORKTREE_DIR}" ${ACPX_AGENT} sessions ensure --name "${TASK_ID}" \
&& echo "[launch] ACPX session '${TASK_ID}' ensured." \
|| { echo "[launch] ERROR: Failed to create ACPX session."; exit 1; }

# Wait for agent process to fully connect before submitting prompt
# npx cold-start can take 30-120s on first run (downloads adapter package)
# Poll until lastPromptTime is no longer '-' or timeout after 180s
echo "[launch] Waiting for agent to connect (polling up to 180s)..."
WAIT_ELAPSED=0
WAIT_INTERVAL=5
WAIT_TIMEOUT=40
while [ $WAIT_ELAPSED -lt $WAIT_TIMEOUT ]; do
    STATUS_OUT=$(acpx --cwd "${WORKTREE_DIR}" ${ACPX_AGENT} status -s "${TASK_ID}" 2>/dev/null || true)
    AGENT_STATUS=$(echo "$STATUS_OUT" | grep "^status:" | awk '{print $2}')
    if [ "$AGENT_STATUS" = "running" ]; then
        echo "[launch] Agent is running after ${WAIT_ELAPSED}s."
        break
    fi
    sleep $WAIT_INTERVAL
    WAIT_ELAPSED=$((WAIT_ELAPSED + WAIT_INTERVAL))
done
if [ $WAIT_ELAPSED -ge $WAIT_TIMEOUT ]; then
    echo "[launch] WARNING: Agent did not reach running state within ${WAIT_TIMEOUT}s, submitting anyway."
fi

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
