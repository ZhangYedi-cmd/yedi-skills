#!/usr/bin/env bash
# =============================================================================
# Watchdog — Dual-backend observation, crash detection, and recovery
# =============================================================================
# Usage: watchdog.sh [task_id]
#   If task_id is provided, monitor only that task.
#   If omitted, monitor ALL tasks in active-tasks.json.
# =============================================================================
# Zero LLM token consumption. All monitoring via shell commands.
# Supports both ACPX and tmux backends (auto-detected from active-tasks.json).
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
TMUX_SOCKET="/tmp/openclaw-tmux/openclaw.sock"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
ORCHESTRATOR_DIR="${REPO_ROOT}/.clawdbot"
ACTIVE_TASKS_FILE="${ORCHESTRATOR_DIR}/active-tasks.json"
MEMORY_FILE="${REPO_ROOT}/MEMORY.md"
DAILY_MEMORY_DIR="${REPO_ROOT}/memory"

WATCHDOG_INTERVAL="${WATCHDOG_INTERVAL:-300}"   # 5 minutes
STALL_TIMEOUT="${STALL_TIMEOUT:-1800}"          # 30 minutes
CAPTURE_LINES=50
CALLBACK_RETRY_LIMIT="${CALLBACK_RETRY_LIMIT:-2}"

# OpenClaw notification config
OPENCLAW_BIN="${OPENCLAW_BIN:-$(command -v openclaw 2>/dev/null || echo "")}"
SWARM_AGENT_ID="${SWARM_AGENT_ID:-}"
OPENCLAW_EVENT_MODE="${OPENCLAW_EVENT_MODE:-now}"

SINGLE_TASK="${1:-}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
log() {
    echo "[watchdog $(date -u +%H:%M:%S)] $*"
}

daily_file() {
    local date_today
    date_today="$(date -u +%Y-%m-%d)"
    local fpath="${DAILY_MEMORY_DIR}/${date_today}.md"
    if ! [ -f "$fpath" ]; then
        mkdir -p "$DAILY_MEMORY_DIR"
        echo "# ${date_today}" > "$fpath"
        echo "" >> "$fpath"
    fi
    echo "$fpath"
}

write_milestone() {
    local task_id="$1"
    local milestone="$2"
    local time_now
    time_now="$(date -u +%H:%M)"
    local df
    df="$(daily_file)"

    echo "- **${time_now}** [${task_id}] ${milestone}" >> "$df"

    if [ -f "$MEMORY_FILE" ] && command -v sed &>/dev/null; then
        sed -i '' "/### ${task_id}:/,/^### / {
            s|- \*\*Latest Milestone\*\*:.*|- **Latest Milestone**: ${time_now} - ${milestone}|
        }" "$MEMORY_FILE" 2>/dev/null || true
    fi

    log "${task_id}: milestone — ${milestone}"
}

update_task_status() {
    local task_id="$1"
    local new_status="$2"

    if command -v jq &>/dev/null && [ -f "$ACTIVE_TASKS_FILE" ]; then
        local tmp
        tmp=$(mktemp)
        jq --arg tid "$task_id" --arg st "$new_status" \
            '(.tasks[] | select(.task_id == $tid)).status = $st' \
            "$ACTIVE_TASKS_FILE" > "$tmp" && mv "$tmp" "$ACTIVE_TASKS_FILE"
    fi

    if [ -f "$MEMORY_FILE" ] && command -v sed &>/dev/null; then
        sed -i '' "/### ${task_id}:/,/^### / {
            s|- \*\*Status\*\*:.*|- **Status**: ${new_status}|
        }" "$MEMORY_FILE" 2>/dev/null || true
    fi
}

update_callback_state() {
    local task_id="$1"
    local callback_state="$2"

    if [ -f "$MEMORY_FILE" ] && command -v sed &>/dev/null; then
        sed -i '' "/### ${task_id}:/,/^### / {
            s|- \*\*Callback\*\*:.*|- **Callback**: ${callback_state}|
        }" "$MEMORY_FILE" 2>/dev/null || true
    fi
}

notify_openclaw() {
    local text="$1"
    if [ -z "$OPENCLAW_BIN" ]; then
        return 0
    fi
    if [ -n "$SWARM_AGENT_ID" ]; then
        # Directed delivery to specific agent
        "$OPENCLAW_BIN" agent \
            --agent "$SWARM_AGENT_ID" \
            --message "$text" \
            --json 2>/dev/null || true
    else
        # Fallback: system event via heartbeat
        "$OPENCLAW_BIN" system event \
            --text "$text" \
            --mode "$OPENCLAW_EVENT_MODE" 2>/dev/null || true
    fi
}

get_task_backend() {
    local task_id="$1"
    if command -v jq &>/dev/null && [ -f "$ACTIVE_TASKS_FILE" ]; then
        jq -r --arg tid "$task_id" \
            '.tasks[] | select(.task_id == $tid) | .backend // "tmux"' \
            "$ACTIVE_TASKS_FILE"
    else
        echo "tmux"
    fi
}

extract_callback_json() {
    local captured="$1"
    # Extract JSON between ```callback-json and ```, handling cases where
    # the opening fence and JSON may be on the same line (e.g. ```callback-json{)
    local block
    block=$(printf '%s\n' "$captured" | awk '
        /```callback-json/ {
            # Strip the fence marker, keep any JSON on the same line
            sub(/.*```callback-json/, "")
            if (length($0) > 0) print
            capture = 1
            next
        }
        capture && /```/ {
            capture = 0
            next
        }
        capture { print }
    ')
    printf '%s\n' "$block"
}

callback_fingerprint_file() {
    local task_id="$1"
    echo "${ORCHESTRATOR_DIR}/${task_id}-last-callback.sha"
}

callback_retry_file() {
    local task_id="$1"
    echo "${ORCHESTRATOR_DIR}/${task_id}-callback-retries"
}

callback_fingerprint() {
    local callback_json="$1"
    if command -v shasum &>/dev/null; then
        printf "%s" "$callback_json" | shasum -a 256 | awk '{print $1}'
    else
        printf "%s" "$callback_json" | cksum | awk '{print $1}'
    fi
}

callback_already_processed() {
    local task_id="$1"
    local callback_json="$2"
    local fp_file fp

    fp_file="$(callback_fingerprint_file "$task_id")"
    fp="$(callback_fingerprint "$callback_json")"

    [ -f "$fp_file" ] && [ "$(cat "$fp_file" 2>/dev/null || true)" = "$fp" ]
}

mark_callback_processed() {
    local task_id="$1"
    local callback_json="$2"
    callback_fingerprint "$callback_json" > "$(callback_fingerprint_file "$task_id")"
}

reset_callback_retry_state() {
    local task_id="$1"
    rm -f "$(callback_retry_file "$task_id")"
    update_callback_state "$task_id" "received"
}

request_callback_correction() {
    local task_id="$1"
    local reason="$2"
    local backend
    backend=$(get_task_backend "$task_id")

    local retry_file attempt
    retry_file="$(callback_retry_file "$task_id")"
    attempt=0
    if [ -f "$retry_file" ]; then
        attempt=$(cat "$retry_file" 2>/dev/null || echo 0)
    fi
    attempt=$(( attempt + 1 ))
    echo "$attempt" > "$retry_file"

    if [ "$attempt" -le "$CALLBACK_RETRY_LIMIT" ]; then
        update_callback_state "$task_id" "retry-${attempt}/${CALLBACK_RETRY_LIMIT}"
        write_milestone "$task_id" \
            "Callback contract violation: ${reason}. Requested correction ${attempt}/${CALLBACK_RETRY_LIMIT}"

        if [ "$backend" = "acpx" ] && command -v acpx &>/dev/null; then
            acpx prompt -s "$task_id" --no-wait \
                "You finished without the required valid callback-json block. ${reason}. Output a corrected callback-json fenced block now with task_id, status, branch, files_changed, test_results, duration_minutes, and summary." \
                2>/dev/null || true
        elif [ "$backend" = "tmux" ]; then
            tmux -S "$TMUX_SOCKET" send-keys -t "$task_id" \
                "You finished without the required valid callback-json block. ${reason}. Output a corrected callback-json fenced block now with task_id, status, branch, files_changed, test_results, duration_minutes, and summary." Enter \
                2>/dev/null || true
        fi

        return 0
    fi

    update_task_status "$task_id" "failed"
    update_callback_state "$task_id" "failed"
    write_milestone "$task_id" \
        "Callback contract violated after ${CALLBACK_RETRY_LIMIT} retries: ${reason}"

    notify_openclaw "Task ${task_id} failed: callback contract violated (${reason})"

    return 1
}

# ---------------------------------------------------------------------------
# Callback handling (shared by both backends)
# ---------------------------------------------------------------------------
handle_callback() {
    local task_id="$1"
    local callback_json="$2"

    if [ -z "$callback_json" ]; then
        log "${task_id}: empty callback JSON"
        if request_callback_correction "$task_id" "Empty callback JSON"; then
            return 1
        fi
        return 0
    fi

    if ! echo "$callback_json" | jq empty 2>/dev/null; then
        log "${task_id}: invalid callback JSON"
        if request_callback_correction "$task_id" "Invalid callback JSON"; then
            return 1
        fi
        return 0
    fi

    local status failed summary
    status=$(echo "$callback_json" | jq -r '.status // "unknown"')
    failed=$(echo "$callback_json" | jq -r '.test_results.failed // 0')
    summary=$(echo "$callback_json" | jq -r '.summary // "No summary"')
    local backend
    backend=$(get_task_backend "$task_id")

    log "${task_id}: callback — status=${status}, failed=${failed}"
    mark_callback_processed "$task_id" "$callback_json"

    case "${status}" in
        completed)
            if [ "$failed" -eq 0 ] 2>/dev/null; then
                update_task_status "$task_id" "completed"
                reset_callback_retry_state "$task_id"
                write_milestone "$task_id" "Completed: ${summary}"
                echo "$callback_json" > "${ORCHESTRATOR_DIR}/${task_id}-callback.json"
                notify_openclaw "Task ${task_id} completed: ${summary}"
                return 0
            else
                update_task_status "$task_id" "repairing"
                update_callback_state "$task_id" "received"
                write_milestone "$task_id" "Completed with ${failed} test failures"
                # Send fix instruction via appropriate backend
                if [ "$backend" = "acpx" ] && command -v acpx &>/dev/null; then
                    acpx prompt -s "$task_id" --no-wait \
                        "There are ${failed} failing tests. Fix them and output a new callback-json block." \
                        2>/dev/null || true
                elif [ "$backend" = "tmux" ]; then
                    tmux -S "$TMUX_SOCKET" send-keys -t "$task_id" \
                        "There are ${failed} failing tests. Please fix them and output a new callback-json block." Enter \
                        2>/dev/null || true
                fi
                return 1
            fi
            ;;
        failed)
            update_task_status "$task_id" "failed"
            reset_callback_retry_state "$task_id"
            write_milestone "$task_id" "Failed: ${summary}"
            echo "$callback_json" > "${ORCHESTRATOR_DIR}/${task_id}-callback.json"
            notify_openclaw "Task ${task_id} FAILED: ${summary}"
            return 0
            ;;
        need_clarification)
            update_task_status "$task_id" "blocked"
            reset_callback_retry_state "$task_id"
            write_milestone "$task_id" "Needs clarification: ${summary}"
            echo "$callback_json" > "${ORCHESTRATOR_DIR}/${task_id}-callback.json"
            notify_openclaw "Task ${task_id} needs clarification: ${summary}"
            return 0
            ;;
        *)
            log "${task_id}: unknown status '${status}'"
            if request_callback_correction "$task_id" "Unknown callback status '${status}'"; then
                return 1
            fi
            return 0
            ;;
    esac
}

# ---------------------------------------------------------------------------
# ACPX monitoring
# ---------------------------------------------------------------------------
monitor_acpx_task() {
    local task_id="$1"

    # Check if ACPX session exists
    if ! acpx sessions show "$task_id" &>/dev/null; then
        log "${task_id}: ACPX session not found — marking as crashed."
        update_task_status "$task_id" "crashed"
        write_milestone "$task_id" "ACPX session lost"
        return 0
    fi

    # Check agent status via acpx status
    local agent_status
    agent_status=$(acpx status -s "$task_id" 2>/dev/null | grep '^status:' | awk '{print $2}')

    if [ "$agent_status" = "running" ]; then
        return 1  # Still running, keep monitoring
    fi

    # Agent is no longer running (dead/idle/etc) — check for callback in history
    if [ "$agent_status" = "dead" ] || [ "$agent_status" = "idle" ] || [ -n "$agent_status" ]; then
        log "${task_id}: Agent status is '${agent_status}' — checking for callback."

        local output
        output=$(acpx sessions read --tail 1 "$task_id" 2>/dev/null || echo "")

        if [ -z "$output" ]; then
            return 1  # No output yet
        fi

        # Check for callback-json in output
        if echo "$output" | grep -q 'callback-json'; then
            write_milestone "$task_id" "Agent completed (callback detected)"

            local callback_json
            callback_json=$(extract_callback_json "$output")
            if callback_already_processed "$task_id" "$callback_json"; then
                return 1
            fi
            if handle_callback "$task_id" "$callback_json"; then
                return 0
            fi
            return 1
        else
            # Agent finished but no callback found
            if request_callback_correction "$task_id" \
                "Agent finished (status: ${agent_status}) without callback-json"; then
                return 1
            fi
        fi
        return 0
    fi

    return 1  # Keep monitoring
}

# ---------------------------------------------------------------------------
# tmux monitoring
# ---------------------------------------------------------------------------
detect_milestones_tmux() {
    local task_id="$1"
    local captured="$2"

    if echo "$captured" | grep -q 'callback-json'; then
        write_milestone "$task_id" "Agent completed (callback detected)"
        local callback_json
        callback_json="$(extract_callback_json "$captured")"
        if callback_already_processed "$task_id" "$callback_json"; then
            return 1
        fi
        if handle_callback "$task_id" "$callback_json"; then
            return 0
        fi
        return 1
    fi

    if echo "$captured" | grep -qi 'creating file\|wrote file\|created.*\.'; then
        write_milestone "$task_id" "Creating files"
    fi
    if echo "$captured" | grep -qi 'running tests\|npm test\|pytest\|go test\|make test'; then
        write_milestone "$task_id" "Running tests"
    fi
    if echo "$captured" | grep -qi 'tests\? passed\|✓\|PASS'; then
        write_milestone "$task_id" "Tests passing"
    fi
    if echo "$captured" | grep -qi 'tests\? failed\|✗\|FAIL'; then
        write_milestone "$task_id" "Tests failing"
    fi
    if echo "$captured" | grep -qi 'git add\|git commit\|committed'; then
        write_milestone "$task_id" "Committing changes"
    fi
    if echo "$captured" | grep -qi 'error\|Error\|FATAL\|panic\|traceback'; then
        write_milestone "$task_id" "Error detected"
    fi

    return 1
}

monitor_tmux_task() {
    local task_id="$1"

    if ! tmux -S "$TMUX_SOCKET" has-session -t "$task_id" 2>/dev/null; then
        log "${task_id}: tmux session not found — marking as crashed."
        update_task_status "$task_id" "crashed"
        write_milestone "$task_id" "tmux session lost"
        return 0
    fi

    local captured
    captured=$(tmux -S "$TMUX_SOCKET" capture-pane -p -t "$task_id" -S -"$CAPTURE_LINES" 2>/dev/null || echo "")

    if [ -z "$captured" ]; then
        return 1
    fi

    # Strip ANSI
    captured=$(echo "$captured" | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' 2>/dev/null || echo "$captured")

    if detect_milestones_tmux "$task_id" "$captured"; then
        return 0
    fi

    # Stall check
    if command -v jq &>/dev/null && [ -f "$ACTIVE_TASKS_FILE" ]; then
        local started_at
        started_at=$(jq -r --arg tid "$task_id" \
            '.tasks[] | select(.task_id == $tid) | .launched_at // .started_at // ""' \
            "$ACTIVE_TASKS_FILE")
        if [ -n "$started_at" ]; then
            local now started_epoch elapsed
            now=$(date +%s)
            started_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$started_at" +%s 2>/dev/null || \
                            date -d "$started_at" +%s 2>/dev/null || echo 0)
            if [ "$started_epoch" -gt 0 ]; then
                elapsed=$(( now - started_epoch ))
                if [ "$elapsed" -gt "$STALL_TIMEOUT" ]; then
                    local last_line
                    last_line=$(tmux -S "$TMUX_SOCKET" capture-pane -p -t "$task_id" -S -1 2>/dev/null || echo "")
                    if [ -z "$last_line" ]; then
                        write_milestone "$task_id" "WARNING: Possible stall (${STALL_TIMEOUT}s)"
                    fi
                fi
            fi
        fi
    fi

    return 1
}

# ---------------------------------------------------------------------------
# Unified monitoring dispatch
# ---------------------------------------------------------------------------
monitor_task() {
    local task_id="$1"
    local backend
    backend=$(get_task_backend "$task_id")

    case "$backend" in
        acpx)
            if command -v acpx &>/dev/null; then
                monitor_acpx_task "$task_id"
            else
                log "${task_id}: ACPX not available, skipping."
                return 1
            fi
            ;;
        tmux|*)
            monitor_tmux_task "$task_id"
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Recovery: check orphaned tasks on startup
# ---------------------------------------------------------------------------
run_recovery() {
    log "Running recovery check..."

    if ! [ -f "$ACTIVE_TASKS_FILE" ] || ! command -v jq &>/dev/null; then
        log "No active-tasks.json or jq — skipping recovery."
        return
    fi

    local task_data
    task_data=$(jq -r '.tasks[] | select(.status == "running" or .status == "repairing") | "\(.task_id)|\(.backend // "tmux")"' "$ACTIVE_TASKS_FILE")

    while IFS='|' read -r tid backend; do
        [ -z "$tid" ] && continue

        case "$backend" in
            acpx)
                if command -v acpx &>/dev/null && acpx sessions show "$tid" &>/dev/null; then
                    log "Recovery: ${tid} (acpx) — session alive."
                else
                    log "Recovery: ${tid} (acpx) — session DEAD."
                    update_task_status "$tid" "crashed"
                    write_milestone "$tid" "ACPX session crashed (detected on startup)"
                fi
                ;;
            tmux|*)
                if tmux -S "$TMUX_SOCKET" has-session -t "$tid" 2>/dev/null; then
                    log "Recovery: ${tid} (tmux) — session alive."
                else
                    log "Recovery: ${tid} (tmux) — session DEAD."
                    update_task_status "$tid" "crashed"
                    write_milestone "$tid" "tmux session crashed (detected on startup)"
                fi
                ;;
        esac
    done <<< "$task_data"
}

# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------
monitor_all() {
    if ! [ -f "$ACTIVE_TASKS_FILE" ] || ! command -v jq &>/dev/null; then
        log "No tasks to monitor."
        return
    fi

    local task_ids
    task_ids=$(jq -r '.tasks[] | select(.status == "running" or .status == "repairing") | .task_id' "$ACTIVE_TASKS_FILE")

    if [ -z "$task_ids" ]; then
        log "No running tasks."
        return
    fi

    for tid in $task_ids; do
        monitor_task "$tid" || true
    done
}

main() {
    log "Watchdog started."
    log "  Interval: ${WATCHDOG_INTERVAL}s"
    log "  Stall:    ${STALL_TIMEOUT}s"
    log "  Mode:     $([ -n "$SINGLE_TASK" ] && echo "single (${SINGLE_TASK})" || echo "all tasks")"

    run_recovery

    while true; do
        if [ -n "$SINGLE_TASK" ]; then
            if monitor_task "$SINGLE_TASK"; then
                log "Task '${SINGLE_TASK}' completed or crashed. Exiting."
                break
            fi
        else
            monitor_all
        fi

        sleep "$WATCHDOG_INTERVAL"
    done

    log "Watchdog stopped."
}

main
