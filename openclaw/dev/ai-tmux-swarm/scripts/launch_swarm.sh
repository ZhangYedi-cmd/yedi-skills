#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $0 <repo-path> --agent-id <id> [--feishu-chat-id <open_id>] [--feishu-account-id <account_id>] [--engine codex|claude] [--notify none|feishu|telegram|both]" >&2
  exit 1
}

[[ $# -lt 1 ]] && usage

REPO_PATH="$1"
shift

AGENT_ID=""
FEISHU_CHAT_ID=""
FEISHU_ACCOUNT_ID=""
ENGINE="claude"
NOTIFY_MODE="feishu"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent-id)
      [[ $# -ge 2 ]] || usage
      AGENT_ID="$2"; shift 2 ;;
    --feishu-chat-id)
      [[ $# -ge 2 ]] || usage
      FEISHU_CHAT_ID="$2"; shift 2 ;;
    --feishu-account-id)
      [[ $# -ge 2 ]] || usage
      FEISHU_ACCOUNT_ID="$2"; shift 2 ;;
    --engine)
      [[ $# -ge 2 ]] || usage
      ENGINE="$2"; shift 2 ;;
    --notify)
      [[ $# -ge 2 ]] || usage
      NOTIFY_MODE="$2"; shift 2 ;;
    *)
      echo "Unknown argument: $1" >&2; usage ;;
  esac
done

[[ -n "$AGENT_ID" ]] || { echo "Error: --agent-id is required" >&2; usage; }

REPO_PATH="$(cd "$REPO_PATH" && pwd)"
SWARM_DIR="$REPO_PATH/.swarm"
CONFIG_FILE="$SWARM_DIR/config.env"

# ── Step 1: Install scaffold (idempotent) ──────────────────────────────────
echo "[launch-swarm] Installing scaffold: $REPO_PATH (engine=$ENGINE)"
"$SCRIPT_DIR/install_swarm.sh" "$REPO_PATH" --engine "$ENGINE"

# ── Step 2: Merge-write config.env ────────────────────────────────────────
if [[ ! -f "$CONFIG_FILE" ]]; then
  if [[ -f "$SWARM_DIR/config.env.example" ]]; then
    cp "$SWARM_DIR/config.env.example" "$CONFIG_FILE"
    echo "[launch-swarm] Created config.env from example"
  else
    touch "$CONFIG_FILE"
    echo "[launch-swarm] Created empty config.env"
  fi
fi

# Merge: only overwrite the 5 keys we own; preserve everything else.
python3 - <<PY "$CONFIG_FILE" "$AGENT_ID" "$NOTIFY_MODE" "$FEISHU_CHAT_ID" "$FEISHU_ACCOUNT_ID"
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
agent_id    = sys.argv[2]
notify_mode = sys.argv[3]
feishu_chat = sys.argv[4]
feishu_acct = sys.argv[5]

OWNED_KEYS = {
    "SWARM_AGENT_ID":      agent_id,
    "OPENCLAW_EVENT_MODE": "now",
    "SWARM_NOTIFY_MODE":   notify_mode,
    "FEISHU_CHAT_ID":      feishu_chat,
    "FEISHU_ACCOUNT_ID":   feishu_acct,
}

lines = config_path.read_text(encoding="utf-8").splitlines()
updated = {k: False for k in OWNED_KEYS}
result = []

for line in lines:
    stripped = line.strip()
    if stripped.startswith("#") or "=" not in stripped:
        result.append(line)
        continue
    key = stripped.split("=", 1)[0].strip()
    if key in OWNED_KEYS:
        result.append(f"{key}={OWNED_KEYS[key]}")
        updated[key] = True
    else:
        result.append(line)

# Append any keys not yet present
for key, value in OWNED_KEYS.items():
    if not updated[key]:
        result.append(f"{key}={value}")

config_path.write_text("\n".join(result) + "\n", encoding="utf-8")
print(f"[launch-swarm] config.env updated: SWARM_AGENT_ID={agent_id} SWARM_NOTIFY_MODE={notify_mode}")
PY

# ── Step 3: Start swarm ───────────────────────────────────────────────────
echo "[launch-swarm] Starting swarm..."
bash "$REPO_PATH/.swarm/scripts/start_all.sh"
