#!/usr/bin/env bash
set -euo pipefail

LOG_PREFIX="[skill-sync]"
SCRIPT_NAME="$(basename "$0")"

DRY_RUN=0
VERBOSE=0
MODE="incremental"
TARGET="all"
COMMIT_REF="HEAD"
HAS_COMMIT_ARG=0
HAS_ALL_ARG=0

CODEX_SKILLS_DIR="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
CLAUDE_CODE_SKILLS_DIR="${CLAUDE_CODE_SKILLS_DIR:-$HOME/.claude/skills}"
OPENCLAW_SKILLS_DIR="${OPENCLAW_SKILLS_DIR:-$HOME/.openclaw/skills}"

TMP_ROOTS_RAW=""
TMP_ROOTS=""
TMP_ROUTES_RAW=""
TMP_ROUTES_SORTED=""

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} [options]

Sync skills from this repository to global agent skill directories.

Options:
  --commit <ref>  Sync incrementally from a specific commit (default: HEAD)
  --all           Full sync all detected skills in repository
  --target <t>    Sync routes for target: all|codex|claude-code|openclaw (default: all)
  --dry-run       Print planned actions only
  --verbose       Print verbose logs
  -h, --help      Show this help

Env overrides:
  CODEX_SKILLS_DIR         (default: ~/.codex/skills)
  CLAUDE_CODE_SKILLS_DIR   (default: ~/.claude/skills)
  OPENCLAW_SKILLS_DIR      (default: ~/.openclaw/skills)
EOF
}

log_info() {
  printf "%s %s\n" "$LOG_PREFIX" "$*"
}

log_warn() {
  printf "%s WARNING: %s\n" "$LOG_PREFIX" "$*" >&2
}

log_error() {
  printf "%s ERROR: %s\n" "$LOG_PREFIX" "$*" >&2
}

log_verbose() {
  if [ "$VERBOSE" -eq 1 ]; then
    log_info "$*"
  fi
}

die() {
  log_error "$*"
  exit 1
}

cleanup() {
  [ -n "${TMP_ROOTS_RAW:-}" ] && [ -f "$TMP_ROOTS_RAW" ] && rm -f "$TMP_ROOTS_RAW"
  [ -n "${TMP_ROOTS:-}" ] && [ -f "$TMP_ROOTS" ] && rm -f "$TMP_ROOTS"
  [ -n "${TMP_ROUTES_RAW:-}" ] && [ -f "$TMP_ROUTES_RAW" ] && rm -f "$TMP_ROUTES_RAW"
  [ -n "${TMP_ROUTES_SORTED:-}" ] && [ -f "$TMP_ROUTES_SORTED" ] && rm -f "$TMP_ROUTES_SORTED"
}

trap cleanup EXIT INT TERM

require_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || die "Required command not found: ${cmd}"
}

expand_home() {
  local path="$1"
  case "$path" in
    "~")
      printf "%s\n" "$HOME"
      ;;
    "~/"*)
      printf "%s/%s\n" "$HOME" "${path#~/}"
      ;;
    *)
      printf "%s\n" "$path"
      ;;
  esac
}

trim_trailing_slash() {
  local path="$1"
  while [ "${#path}" -gt 1 ] && [ "${path%/}" != "$path" ]; do
    path="${path%/}"
  done
  printf "%s\n" "$path"
}

is_valid_scope() {
  case "$1" in
    shared|codex|claude-code|openclaw) return 0 ;;
    *) return 1 ;;
  esac
}

is_valid_target() {
  case "$1" in
    all|codex|claude-code|openclaw) return 0 ;;
    *) return 1 ;;
  esac
}

extract_skill_root() {
  local path="$1"
  local scope remainder namespace skill

  path="${path#./}"

  scope="${path%%/*}"
  [ "$scope" != "$path" ] || return 1

  remainder="${path#*/}"
  namespace="${remainder%%/*}"
  [ "$namespace" != "$remainder" ] || return 1

  remainder="${remainder#*/}"
  skill="${remainder%%/*}"

  is_valid_scope "$scope" || return 1
  [ -n "$namespace" ] || return 1
  [ -n "$skill" ] || return 1

  printf "%s/%s/%s\n" "$scope" "$namespace" "$skill"
}

targets_for_scope() {
  local scope="$1"
  case "$scope" in
    shared)
      printf "codex\nclaude-code\nopenclaw\n"
      ;;
    codex|claude-code|openclaw)
      printf "%s\n" "$scope"
      ;;
    *)
      return 1
      ;;
  esac
}

target_dir_for_agent() {
  local agent="$1"
  case "$agent" in
    codex) printf "%s\n" "$CODEX_SKILLS_DIR" ;;
    claude-code) printf "%s\n" "$CLAUDE_CODE_SKILLS_DIR" ;;
    openclaw) printf "%s\n" "$OPENCLAW_SKILLS_DIR" ;;
    *) return 1 ;;
  esac
}

should_include_agent_for_target() {
  local agent="$1"
  if [ "$TARGET" = "all" ]; then
    return 0
  fi
  [ "$agent" = "$TARGET" ]
}

validate_skill_name() {
  local skill="$1"
  [ -n "$skill" ] || return 1
  case "$skill" in
    "."|".."|*/*) return 1 ;;
    *) return 0 ;;
  esac
}

validate_delete_target() {
  local target_root="$1"
  local target_path="$2"
  local skill="$3"

  validate_skill_name "$skill" || {
    log_error "Unsafe skill name for delete: ${skill}"
    return 1
  }

  case "$target_path" in
    "${target_root}/"*) ;;
    *)
      log_error "Refusing to delete path outside target root: ${target_path}"
      return 1
      ;;
  esac

  if [ "$target_path" = "$target_root" ]; then
    log_error "Refusing to delete target root directory: ${target_root}"
    return 1
  fi

  return 0
}

add_root_candidate_from_path() {
  local path="$1"
  local root=""
  root="$(extract_skill_root "$path" || true)"
  [ -n "$root" ] || return 0
  printf "%s\n" "$root" >> "$TMP_ROOTS_RAW"
  log_verbose "Detected changed root '${root}' from path '${path}'"
}

collect_roots_from_commit() {
  local commit_ref="$1"
  local status status_code old_path new_path file_path

  if ! git rev-parse --verify "${commit_ref}^{commit}" >/dev/null 2>&1; then
    die "Commit not found: ${commit_ref}"
  fi

  while IFS= read -r -d '' status; do
    status_code="${status:0:1}"
    case "$status_code" in
      R|C)
        IFS= read -r -d '' old_path || die "Malformed diff-tree output for status ${status}"
        IFS= read -r -d '' new_path || die "Malformed diff-tree output for status ${status}"
        add_root_candidate_from_path "$old_path"
        add_root_candidate_from_path "$new_path"
        ;;
      *)
        IFS= read -r -d '' file_path || die "Malformed diff-tree output for status ${status}"
        add_root_candidate_from_path "$file_path"
        ;;
    esac
  done < <(git diff-tree -z --name-status -r --root -M --no-commit-id "$commit_ref")
}

collect_roots_all() {
  local scope scope_dir skill_file rel root candidate

  for scope in shared codex claude-code openclaw; do
    scope_dir="${REPO_ROOT}/${scope}"
    [ -d "$scope_dir" ] || continue

    while IFS= read -r -d '' skill_file; do
      rel="${skill_file#${REPO_ROOT}/}"
      root="${rel%/SKILL.md}"
      candidate="$(extract_skill_root "$root" || true)"
      [ -n "$candidate" ] || continue
      printf "%s\n" "$candidate" >> "$TMP_ROOTS_RAW"
      log_verbose "Detected root '${candidate}' from full scan"
    done < <(find "$scope_dir" -mindepth 3 -maxdepth 3 -type f -name "SKILL.md" -print0)
  done
}

build_routes() {
  local root scope remainder skill action agent

  while IFS= read -r root; do
    [ -n "$root" ] || continue

    scope="${root%%/*}"
    remainder="${root#*/}"
    skill="${remainder#*/}"

    validate_skill_name "$skill" || die "Invalid skill name from root '${root}'"

    action="delete"
    if [ -f "${REPO_ROOT}/${root}/SKILL.md" ]; then
      action="sync"
    fi

    while IFS= read -r agent; do
      [ -n "$agent" ] || continue
      should_include_agent_for_target "$agent" || continue
      printf "%s|%s|%s|%s\n" "$agent" "$skill" "$action" "$root" >> "$TMP_ROUTES_RAW"
    done < <(targets_for_scope "$scope")
  done < "$TMP_ROOTS"
}

detect_conflicts() {
  local prev_key="" prev_root=""
  local key agent skill action root
  local has_conflict=0

  while IFS='|' read -r agent skill action root; do
    key="${agent}|${skill}"
    if [ "$key" = "$prev_key" ] && [ "$root" != "$prev_root" ]; then
      log_error "Name conflict for target '${agent}/${skill}': '${prev_root}' vs '${root}'"
      has_conflict=1
    fi
    prev_key="$key"
    prev_root="$root"
  done < "$TMP_ROUTES_SORTED"

  [ "$has_conflict" -eq 0 ] || return 1
}

execute_routes() {
  local agent skill action root target_root src target_path
  local executed=0 skipped=0

  while IFS='|' read -r agent skill action root; do
    target_root="$(target_dir_for_agent "$agent")"
    target_root="$(trim_trailing_slash "$(expand_home "$target_root")")"

    if [ ! -d "$target_root" ]; then
      log_warn "Target dir missing for ${agent}: ${target_root}. Skip '${action}' for '${skill}'."
      skipped=$((skipped + 1))
      continue
    fi

    src="${REPO_ROOT}/${root}"
    target_path="${target_root}/${skill}"

    case "$action" in
      sync)
        if [ ! -f "${src}/SKILL.md" ]; then
          die "Missing SKILL.md for sync source: ${src}"
        fi

        if [ "$DRY_RUN" -eq 1 ]; then
          log_info "DRY-RUN sync ${root} -> ${agent}:${target_path}"
        else
          mkdir -p "$target_path"
          rsync -a --delete "${src}/" "${target_path}/"
          log_info "Synced ${root} -> ${target_path}"
        fi
        ;;
      delete)
        validate_delete_target "$target_root" "$target_path" "$skill" || return 1
        if [ "$DRY_RUN" -eq 1 ]; then
          log_info "DRY-RUN delete ${agent}:${target_path} (source removed: ${root})"
        else
          if [ -e "$target_path" ]; then
            rm -rf "$target_path"
            log_info "Deleted ${target_path} (source removed: ${root})"
          else
            log_verbose "No-op delete, path not present: ${target_path}"
          fi
        fi
        ;;
      *)
        die "Unknown action '${action}' for route '${agent}|${skill}|${root}'"
        ;;
    esac

    executed=$((executed + 1))
  done < "$TMP_ROUTES_SORTED"

  log_info "Completed ${executed} actions (${skipped} skipped due to missing target dirs)."
}

parse_args() {
  while [ $# -gt 0 ]; do
    case "$1" in
      --commit)
        [ $# -ge 2 ] || die "--commit requires a ref argument"
        COMMIT_REF="$2"
        HAS_COMMIT_ARG=1
        shift 2
        ;;
      --all)
        MODE="all"
        HAS_ALL_ARG=1
        shift
        ;;
      --target)
        [ $# -ge 2 ] || die "--target requires a value"
        is_valid_target "$2" || die "Invalid target: $2 (expected all|codex|claude-code|openclaw)"
        TARGET="$2"
        shift 2
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --verbose)
        VERBOSE=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done

  if [ "$HAS_COMMIT_ARG" -eq 1 ] && [ "$HAS_ALL_ARG" -eq 1 ]; then
    die "--commit and --all cannot be used together"
  fi
}

main() {
  parse_args "$@"

  require_cmd git
  require_cmd rsync
  require_cmd sort
  require_cmd find

  REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || die "Must run inside a git repository."
  REPO_ROOT="$(trim_trailing_slash "$REPO_ROOT")"
  cd "$REPO_ROOT"

  TMP_ROOTS_RAW="$(mktemp "${TMPDIR:-/tmp}/skill-sync-roots-raw.XXXXXX")"
  TMP_ROOTS="$(mktemp "${TMPDIR:-/tmp}/skill-sync-roots.XXXXXX")"
  TMP_ROUTES_RAW="$(mktemp "${TMPDIR:-/tmp}/skill-sync-routes-raw.XXXXXX")"
  TMP_ROUTES_SORTED="$(mktemp "${TMPDIR:-/tmp}/skill-sync-routes.XXXXXX")"

  log_verbose "Repo root: ${REPO_ROOT}"
  log_verbose "Mode: ${MODE}"
  log_verbose "Target: ${TARGET}"
  log_verbose "Commit ref: ${COMMIT_REF}"
  log_verbose "Dry run: ${DRY_RUN}"

  if [ "$MODE" = "all" ]; then
    collect_roots_all
  else
    collect_roots_from_commit "$COMMIT_REF"
  fi

  if [ ! -s "$TMP_ROOTS_RAW" ]; then
    log_info "No relevant skill changes found."
    exit 0
  fi

  sort -u "$TMP_ROOTS_RAW" > "$TMP_ROOTS"

  build_routes

  if [ ! -s "$TMP_ROUTES_RAW" ]; then
    log_info "No sync routes generated."
    exit 0
  fi

  sort -u -t '|' -k1,1 -k2,2 -k3,3 -k4,4 "$TMP_ROUTES_RAW" > "$TMP_ROUTES_SORTED"

  detect_conflicts || die "Aborted due to conflicting skill names for at least one target."
  execute_routes
}

main "$@"
