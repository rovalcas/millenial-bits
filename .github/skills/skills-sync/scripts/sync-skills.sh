#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)}"
REPO_SKILLS_DIR="$REPO_ROOT/.github/skills"
GLOBAL_SKILLS_DIR="${GLOBAL_SKILLS_DIR:-$HOME/.agents/skills}"
WINDOWS_SKILLS_DIR="${WINDOWS_SKILLS_DIR:-/mnt/c/Users/roman.castro/.agents/skills}"

usage() {
  cat <<'USAGE'
Usage: sync-skills.sh <direction> [skill-name]

Directions:
  repo-to-global   Copy repo skills into the active global target(s)
  global-to-repo   Copy active global target(s) back into the repo
  repo-to-repo     Copy skills between two repo roots
  status           Show resolved paths and available skill folders

Examples:
  sync-skills.sh repo-to-global
  sync-skills.sh global-to-repo summarize-video
  sync-skills.sh repo-to-repo /path/from/repo /path/to/repo summarize-video
USAGE
}

log() {
  printf '%s\n' "$*"
}

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

have_rsync() {
  command -v rsync >/dev/null 2>&1
}

is_wsl() {
  [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/version 2>/dev/null
}

global_targets() {
  printf '%s\n' "$GLOBAL_SKILLS_DIR"
  if is_wsl && [[ -d "$(dirname "$WINDOWS_SKILLS_DIR")" || -d /mnt/c/Users ]]; then
    printf '%s\n' "$WINDOWS_SKILLS_DIR"
  fi
}

global_sources() {
  if [[ -d "$GLOBAL_SKILLS_DIR" ]]; then
    printf '%s\n' "$GLOBAL_SKILLS_DIR"
  fi
  if is_wsl && [[ -d "$WINDOWS_SKILLS_DIR" ]]; then
    printf '%s\n' "$WINDOWS_SKILLS_DIR"
  fi
}

validate_skill_file() {
  local file="$1"

  [[ -f "$file" ]] || die "Missing skill file: $file"

  awk '
    NR == 1 {
      if ($0 != "---") exit 20
      next
    }

    !end_seen && /^---$/ {
      if (end_seen) exit 21
      end_seen = 1
      next
    }

    !end_seen {
      if ($0 ~ /^[[:space:]]*$/ || $0 ~ /^#/) next
      if ($0 ~ /^[[:space:]]*name:[[:space:]]+/) {
        if (name_seen++) exit 22
        next
      }
      if ($0 ~ /^[[:space:]]*description:[[:space:]]+/) {
        if (desc_seen++) exit 23
        next
      }
      exit 24
    }

    END {
      if (!end_seen) exit 25
      if (!name_seen) exit 26
      if (!desc_seen) exit 27
    }
  ' "$file" || die "Invalid skill frontmatter: $file"
}

validate_skill_tree() {
  local root="$1"
  local file
  local found=0

  [[ -d "$root" ]] || die "Missing skill tree: $root"

  while IFS= read -r file; do
    found=1
    validate_skill_file "$file"
  done < <(find "$root" -mindepth 2 -name SKILL.md -print)

  [[ $found -eq 1 ]] || die "No skills found under: $root"
}

validate_skill_source() {
  local path="$1"

  if [[ -f "$path/SKILL.md" ]]; then
    validate_skill_file "$path/SKILL.md"
    return 0
  fi

  validate_skill_tree "$path"
}

sync_dir() {
  local src="$1"
  local dst="$2"

  [[ -d "$src" ]] || die "Missing source directory: $src"
  mkdir -p "$dst"

  if have_rsync; then
    rsync -a "$src"/ "$dst"/
  else
    cp -a "$src"/. "$dst"/
  fi
}

sync_skill() {
  local src_root="$1"
  local dst_root="$2"
  local skill_name="${3:-}"
  local src="$src_root"
  local dst="$dst_root"

  if [[ -n "$skill_name" ]]; then
    src="$src_root/$skill_name"
    dst="$dst_root/$skill_name"
    validate_skill_source "$src"
    sync_dir "$src" "$dst"
    log "Synced $skill_name: $src -> $dst"
    return 0
  fi

  [[ -d "$src_root" ]] || die "Missing source root: $src_root"
  validate_skill_tree "$src_root"
  mkdir -p "$dst_root"

  if have_rsync; then
    rsync -a "$src_root"/ "$dst_root"/
  else
    cp -a "$src_root"/. "$dst_root"/
  fi

  log "Synced skills: $src_root -> $dst_root"
}

sync_global_targets() {
  local src_root="$1"
  local skill_name="${2:-}"
  local dst_root

  while IFS= read -r dst_root; do
    [[ -n "$dst_root" ]] || continue
    sync_skill "$src_root" "$dst_root" "$skill_name"
  done < <(global_targets)
}

sync_from_global_sources() {
  local skill_name="${1:-}"
  local src_root

  while IFS= read -r src_root; do
    [[ -n "$src_root" ]] || continue
    if [[ -d "$src_root" ]]; then
      sync_skill "$src_root" "$REPO_SKILLS_DIR" "$skill_name"
      return 0
    fi
  done < <(global_sources)

  die "No global source directory found"
}

show_status() {
  log "repo:    $REPO_SKILLS_DIR"
  log "global:  $GLOBAL_SKILLS_DIR"
  log "windows: $WINDOWS_SKILLS_DIR"
  log "mode:    $(is_wsl && printf 'wsl' || printf 'native')"
  log "rsync:   $(command -v rsync || printf 'missing')"
}

direction="${1:-}"
skill_name="${2:-}"
from_repo="${3:-}"
to_repo="${4:-}"

case "$direction" in
  repo-to-global)
    validate_skill_tree "$REPO_SKILLS_DIR"
    sync_global_targets "$REPO_SKILLS_DIR" "$skill_name"
    ;;
  global-to-repo)
    while IFS= read -r src_root; do
      [[ -n "$src_root" ]] || continue
      validate_skill_tree "$src_root"
    done < <(global_sources)
    sync_from_global_sources "$skill_name"
    ;;
  repo-to-repo)
    [[ -n "$from_repo" && -n "$to_repo" ]] || die "repo-to-repo requires <from-repo> <to-repo> [skill-name]"
    sync_skill "$from_repo/.github/skills" "$to_repo/.github/skills" "$skill_name"
    ;;
  status)
    show_status
    ;;
  ""|-h|--help)
    usage
    ;;
  *)
    usage >&2
    die "Unknown direction: $direction"
    ;;
esac
