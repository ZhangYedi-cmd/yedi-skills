#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SWARM_DIR="$REPO_ROOT/.swarm"
STATE_PATH="$SWARM_DIR/state/tasks.json"
CONFIG_FILE="$SWARM_DIR/config.env"
PYTHON_BIN="${PYTHON_BIN:-python3}"

swarm_log() {
  local level="$1" component="$2" msg="$3"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$component] [$level] $msg"
}

CHAT_ID=""
ENGINE=""
MODEL=""
MANIFEST=""

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --manifest)
      [[ $# -ge 2 ]] || { echo "--manifest requires a path" >&2; exit 1; }
      MANIFEST="$2"
      shift 2
      ;;
    --help|-h)
      echo "Usage: $0 [chat-id] [engine] [model] [--manifest <path>]" >&2
      exit 0
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

if [[ ${#POSITIONAL[@]} -gt 0 ]]; then
  CHAT_ID="${POSITIONAL[0]}"
fi
if [[ ${#POSITIONAL[@]} -gt 1 ]]; then
  ENGINE="${POSITIONAL[1]}"
fi
if [[ ${#POSITIONAL[@]} -gt 2 ]]; then
  MODEL="${POSITIONAL[2]}"
fi
if [[ ${#POSITIONAL[@]} -gt 3 ]]; then
  echo "Too many positional arguments." >&2
  exit 1
fi

if [[ -f "$CONFIG_FILE" ]]; then
  set -a
  source "$CONFIG_FILE"
  set +a
  swarm_log "DEBUG" "start-all" "config loaded from $CONFIG_FILE"
fi

mkdir -p "$SWARM_DIR/state" "$SWARM_DIR/logs" "$SWARM_DIR/worktree"

# Persist all start_all output (including first monitor sweep) to monitor.log
exec > >(tee -a "$SWARM_DIR/logs/monitor.log") 2>&1

swarm_log "INFO" "start-all" "starting swarm: repo=$REPO_ROOT engine=${ENGINE:-default} model=${MODEL:-default}"

INIT_ARGS=(
  "$PYTHON_BIN" "$SCRIPT_DIR/swarm_state.py" init-run
  --repo-root "$REPO_ROOT"
)

if [[ -n "$MANIFEST" ]]; then
  INIT_ARGS+=(--manifest "$MANIFEST")
fi
if [[ -n "$ENGINE" ]]; then
  INIT_ARGS+=(--default-engine "$ENGINE")
fi
if [[ -n "$MODEL" ]]; then
  INIT_ARGS+=(--default-model "$MODEL")
fi
if [[ -n "$CHAT_ID" ]]; then
  INIT_ARGS+=(--chat-id "$CHAT_ID")
fi

swarm_log "INFO" "start-all" "initializing state..."
"${INIT_ARGS[@]}"
swarm_log "INFO" "start-all" "state initialized at $STATE_PATH"

swarm_log "INFO" "start-all" "running first monitor sweep (--strict-launch)"
"$SCRIPT_DIR/monitor.sh" --once --strict-launch

is_all_terminal() {
  "$PYTHON_BIN" "$SCRIPT_DIR/swarm_state.py" all-terminal --state "$STATE_PATH" >/dev/null
}

install_cron() {
  if [[ "${SWARM_AUTO_INSTALL_CRON:-1}" != "1" ]]; then
    swarm_log "DEBUG" "start-all" "SWARM_AUTO_INSTALL_CRON=0, skipping cron install"
    return 0
  fi
  if ! command -v crontab >/dev/null 2>&1; then
    swarm_log "WARN" "start-all" "crontab not found; skipping monitor install"
    return 0
  fi

  local interval="${SWARM_POLL_INTERVAL_MINUTES:-1}"
  if [[ ! "$interval" =~ ^[1-9]$|^[1-5][0-9]$ ]]; then
    interval=1
  fi

  local schedule="* * * * *"
  if [[ "$interval" != "1" ]]; then
    schedule="*/$interval * * * *"
  fi

  local bash_bin
  bash_bin="$(command -v bash || true)"
  [[ -n "$bash_bin" ]] || bash_bin="/bin/bash"

  # Build a deduplicated, essential PATH for the cron environment.
  # Raw $PATH can be very long and break crontab line parsing.
  local clean_path
  clean_path="$(printf '%s\n' "${PATH//:/$'\n'}" | awk '!seen[$0]++' | paste -sd: -)"

  local marker="ai-tmux-swarm:$REPO_ROOT"
  local current
  current="$(crontab -l 2>/dev/null || true)"
  local command="cd \"$REPO_ROOT\" && \"$bash_bin\" \"$SCRIPT_DIR/monitor.sh\" --cron >> \"$SWARM_DIR/logs/monitor.log\" 2>&1"
  local line="$schedule $command # $marker"
  local filtered
  filtered="$(printf '%s\n' "$current" | grep -Fv "$marker" || true)"
  # Also remove any stale PATH= line we may have written before
  filtered="$(printf '%s\n' "$filtered" | grep -Fv "# swarm-path:$REPO_ROOT" || true)"

  {
    printf '%s\n' "$filtered" | sed '/^[[:space:]]*$/d'
    printf 'PATH=%s # swarm-path:%s\n' "$clean_path" "$REPO_ROOT"
    printf '%s\n' "$line"
  } | crontab -

  swarm_log "INFO" "start-all" "monitor cron installed ($schedule)"
}

if ! is_all_terminal; then
  install_cron
fi

swarm_log "INFO" "start-all" "swarm initialized. State: $STATE_PATH"
