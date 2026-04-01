#!/usr/bin/env bash
# install.sh — Autonomous Agent Setup
# Installs global AI CLI configs and project templates
# Usage: ./install.sh [--dry-run]

set -euo pipefail

# ---------------------------------------------------------------------------
# Color helpers
# ---------------------------------------------------------------------------
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { printf "${CYAN}%s${RESET}\n" "$*"; }
success() { printf "${GREEN}%s${RESET}\n" "$*"; }
warn()    { printf "${YELLOW}WARNING: %s${RESET}\n" "$*"; }
error()   { printf "${RED}ERROR: %s${RESET}\n" "$*" >&2; }
bold()    { printf "${BOLD}%s${RESET}\n" "$*"; }

# ---------------------------------------------------------------------------
# Dry-run support
# ---------------------------------------------------------------------------
DRY_RUN=false
for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    DRY_RUN=true
  fi
done

dry_prefix() {
  if $DRY_RUN; then
    printf "${YELLOW}[DRY RUN]${RESET} "
  fi
}

# Run a command, or print it if dry-run
run() {
  if $DRY_RUN; then
    printf "${YELLOW}[DRY RUN]${RESET} Would run: %s\n" "$*"
  else
    "$@"
  fi
}

# Copy with dry-run support
copy_file() {
  local src="$1"
  local dst="$2"
  if $DRY_RUN; then
    printf "${YELLOW}[DRY RUN]${RESET} Would copy: %s -> %s\n" "$src" "$dst"
  else
    cp "$src" "$dst"
    success "  Copied: $src -> $dst"
  fi
}

# ---------------------------------------------------------------------------
# Resolve repo root (directory where this script lives)
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$SCRIPT_DIR/global"
PROJECT_DIR="$SCRIPT_DIR/project"

# ---------------------------------------------------------------------------
# Backup helper
# ---------------------------------------------------------------------------
backup_file() {
  local target="$1"
  if [[ -f "$target" ]]; then
    local stamp
    stamp="$(date +%Y%m%d_%H%M%S)"
    local backup="${target}.backup.${stamp}"
    if $DRY_RUN; then
      printf "${YELLOW}[DRY RUN]${RESET} Would backup: %s -> %s\n" "$target" "$backup"
    else
      cp "$target" "$backup"
      warn "  Backed up: $target -> $backup"
    fi
  fi
}

# ---------------------------------------------------------------------------
# Banner
# ---------------------------------------------------------------------------
print_banner() {
  echo ""
  bold "============================================================"
  bold " Autonomous Agent Setup"
  bold " Configure AI CLI tools for autonomous coding"
  bold "============================================================"
  if $DRY_RUN; then
    warn "Dry-run mode enabled — no files will be written."
  fi
  echo ""
}

# ---------------------------------------------------------------------------
# Option 1: Install global configs
# ---------------------------------------------------------------------------
install_global() {
  info "--- Installing global config ---"

  local claude_dir="$HOME/.claude"
  local codex_dir="$HOME/.codex"
  local gemini_dir="$HOME/.gemini"

  local claude_detected=false
  local codex_detected=false
  local gemini_detected=false

  [[ -d "$claude_dir" ]] && claude_detected=true
  [[ -d "$codex_dir" ]]  && codex_detected=true
  [[ -d "$gemini_dir" ]] && gemini_detected=true

  if ! $claude_detected && ! $codex_detected && ! $gemini_detected; then
    warn "No AI tool config directories detected (~/.claude, ~/.codex, ~/.gemini)."
    warn "Creating ~/.claude as a fallback."
    run mkdir -p "$claude_dir"
    claude_detected=true
  fi

  # ---- AGENTS.md ----
  local agents_src="$GLOBAL_DIR/AGENTS.md"
  if [[ ! -f "$agents_src" ]]; then
    error "Source file not found: $agents_src"
    return 1
  fi

  if $claude_detected; then
    run mkdir -p "$claude_dir"
    backup_file "$claude_dir/AGENTS.md"
    copy_file "$agents_src" "$claude_dir/AGENTS.md"
  fi

  if $codex_detected; then
    run mkdir -p "$codex_dir"
    backup_file "$codex_dir/AGENTS.md"
    copy_file "$agents_src" "$codex_dir/AGENTS.md"
  fi

  if $gemini_detected; then
    run mkdir -p "$gemini_dir"
    backup_file "$gemini_dir/AGENTS.md"
    copy_file "$agents_src" "$gemini_dir/AGENTS.md"
  fi

  # ---- CLAUDE.md ----
  if $claude_detected; then
    local claude_md_src="$GLOBAL_DIR/CLAUDE.md"
    if [[ -f "$claude_md_src" ]]; then
      backup_file "$claude_dir/CLAUDE.md"
      copy_file "$claude_md_src" "$claude_dir/CLAUDE.md"
    else
      warn "global/CLAUDE.md not found — skipping."
    fi
  fi

  # ---- GEMINI.md ----
  if $gemini_detected; then
    local gemini_md_src="$GLOBAL_DIR/GEMINI.md"
    if [[ -f "$gemini_md_src" ]]; then
      backup_file "$gemini_dir/GEMINI.md"
      copy_file "$gemini_md_src" "$gemini_dir/GEMINI.md"
    else
      warn "global/GEMINI.md not found — skipping."
    fi
  fi

  success "Global config install complete."
  echo ""
}

# ---------------------------------------------------------------------------
# Option 2: Install project template
# ---------------------------------------------------------------------------
install_project() {
  info "--- Installing project template ---"

  local cwd
  cwd="$(pwd)"

  if [[ "$cwd" == "$SCRIPT_DIR" ]]; then
    error "You are running from inside the setup repo itself."
    error "Change to your project directory first, then re-run this script."
    return 1
  fi

  local src="$PROJECT_DIR/AGENTS.md"
  if [[ ! -f "$src" ]]; then
    error "Source file not found: $src"
    return 1
  fi

  local dst="$cwd/AGENTS.md"
  backup_file "$dst"
  copy_file "$src" "$dst"

  success "Project template install complete."
  echo ""
}

# ---------------------------------------------------------------------------
# Option 3: Install Claude Code settings
# ---------------------------------------------------------------------------
install_settings() {
  info "--- Installing Claude Code settings ---"

  local claude_dir="$HOME/.claude"
  local src="$GLOBAL_DIR/claude-settings.json"

  if [[ ! -f "$src" ]]; then
    error "Source file not found: $src"
    return 1
  fi

  run mkdir -p "$claude_dir"
  backup_file "$claude_dir/settings.json"
  copy_file "$src" "$claude_dir/settings.json"

  warn "This REPLACES your existing settings.json (backup was created)."
  warn "If you have custom permissions, consider manually merging instead."
  warn "Review permissions before using. See README for details."

  success "Claude Code settings install complete."
  echo ""
}

# ---------------------------------------------------------------------------
# Menu
# ---------------------------------------------------------------------------
print_menu() {
  echo ""
  bold "What would you like to install?"
  echo "  [1] Global config (AGENTS.md + tool-specific configs)"
  echo "  [2] Project template (copy AGENTS.md to current project)"
  echo "  [3] Claude Code settings (auto mode, permissions, plugins)"
  echo "  [4] All of the above"
  echo ""
  printf "Enter choice [1-4]: "
}

# ---------------------------------------------------------------------------
# Summary tracker
# ---------------------------------------------------------------------------
INSTALLED_ITEMS=()

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  print_banner

  print_menu
  local choice
  read -r choice

  echo ""

  case "$choice" in
    1)
      install_global
      INSTALLED_ITEMS+=("Global config (AGENTS.md + tool-specific configs)")
      ;;
    2)
      install_project
      INSTALLED_ITEMS+=("Project template (AGENTS.md -> $(pwd)/AGENTS.md)")
      ;;
    3)
      install_settings
      INSTALLED_ITEMS+=("Claude Code settings (~/.claude/settings.json)")
      ;;
    4)
      install_global
      INSTALLED_ITEMS+=("Global config (AGENTS.md + tool-specific configs)")
      install_project
      INSTALLED_ITEMS+=("Project template (AGENTS.md -> $(pwd)/AGENTS.md)")
      install_settings
      INSTALLED_ITEMS+=("Claude Code settings (~/.claude/settings.json)")
      ;;
    *)
      error "Invalid choice: '$choice'. Please enter 1, 2, 3, or 4."
      exit 1
      ;;
  esac

  # Summary
  bold "============================================================"
  bold " Installation Summary"
  bold "============================================================"
  if [[ ${#INSTALLED_ITEMS[@]} -eq 0 ]]; then
    warn "Nothing was installed."
  else
    for item in "${INSTALLED_ITEMS[@]}"; do
      success "  + $item"
    done
  fi
  if $DRY_RUN; then
    warn "Dry-run mode was active — no files were written."
  fi
  echo ""
}

main
