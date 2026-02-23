#!/usr/bin/env bash
set -euo pipefail

LOG_PREFIX="[skill-sync]"

log() {
  printf "%s %s\n" "$LOG_PREFIX" "$*"
}

warn() {
  printf "%s WARNING: %s\n" "$LOG_PREFIX" "$*" >&2
}

die() {
  printf "%s ERROR: %s\n" "$LOG_PREFIX" "$*" >&2
  exit 1
}

in_path() {
  local dir="$1"
  case ":$PATH:" in
    *":$dir:"*) return 0 ;;
    *) return 1 ;;
  esac
}

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || die "Must run inside the yedi-skills git repository."
cd "$REPO_ROOT"

[ -f ".githooks/post-commit" ] || die "Missing hook file: ${REPO_ROOT}/.githooks/post-commit"
[ -f "scripts/sync-skills.sh" ] || die "Missing sync script: ${REPO_ROOT}/scripts/sync-skills.sh"
[ -f "scripts/skillsync" ] || die "Missing CLI script: ${REPO_ROOT}/scripts/skillsync"

chmod +x ".githooks/post-commit" "scripts/sync-skills.sh" "scripts/skillsync" "scripts/install-hooks.sh"
git config core.hooksPath .githooks

SKILLSYNC_BIN_DIR="${SKILLSYNC_BIN_DIR:-$HOME/.local/node-v20.20.0/bin}"
SKILLSYNC_BIN_DIR="${SKILLSYNC_BIN_DIR%/}"
mkdir -p "$SKILLSYNC_BIN_DIR"
ln -sfn "${REPO_ROOT}/scripts/skillsync" "${SKILLSYNC_BIN_DIR}/skillsync"

log "Installed git hooks with core.hooksPath=.githooks"
log "Current hooksPath: $(git config --get core.hooksPath)"
log "Installed CLI symlink: ${SKILLSYNC_BIN_DIR}/skillsync -> ${REPO_ROOT}/scripts/skillsync"

if ! in_path "$SKILLSYNC_BIN_DIR"; then
  warn "Directory is not in PATH: ${SKILLSYNC_BIN_DIR}"
  warn "Add it to PATH to use 'skillsync' globally."
fi

log "Done."
