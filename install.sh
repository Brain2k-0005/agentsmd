#!/usr/bin/env bash
# install.sh - agentsmd Setup
# Installs global AI CLI configs and project templates
# Usage: ./install.sh [--dry-run] [--enable-modules mod1,mod2] [--disable-modules mod1,mod2]

set -euo pipefail

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

DRY_RUN=false
ALL=false
PRESET=""
LIST_PRESETS=false
ENABLE_MODULES=""
DISABLE_MODULES=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --all)
      ALL=true
      shift
      ;;
    --list-presets)
      LIST_PRESETS=true
      shift
      ;;
    --preset)
      PRESET="${2:-}"
      if [[ -z "$PRESET" || "$PRESET" == --* ]]; then
        error "Missing preset name after --preset"
        exit 1
      fi
      shift 2
      ;;
    --enable-modules)
      ENABLE_MODULES="${2:-}"
      if [[ -z "$ENABLE_MODULES" || "$ENABLE_MODULES" == --* ]]; then
        error "Missing module list after --enable-modules"
        exit 1
      fi
      shift 2
      ;;
    --disable-modules)
      DISABLE_MODULES="${2:-}"
      if [[ -z "$DISABLE_MODULES" || "$DISABLE_MODULES" == --* ]]; then
        error "Missing module list after --disable-modules"
        exit 1
      fi
      shift 2
      ;;
    *)
      error "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ -n "$ENABLE_MODULES" && -n "$DISABLE_MODULES" ]]; then
  error "--enable-modules and --disable-modules are mutually exclusive."
  exit 1
fi

run() {
  if $DRY_RUN; then
    printf "${YELLOW}[DRY RUN]${RESET} Would run: %s\n" "$*"
  else
    "$@"
  fi
}

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

VALID_MODULES="agent-teams quality-gates code-review tdd skill-discovery token-efficiency"

validate_module_names() {
  local modules_csv="$1"
  local IFS=','
  for mod in $modules_csv; do
    mod="$(echo "$mod" | tr -d '[:space:]')"
    local found=false
    for valid in $VALID_MODULES; do
      if [[ "$mod" == "$valid" ]]; then
        found=true
        break
      fi
    done
    if ! $found; then
      error "Unknown module name: '$mod'"
      error "Valid modules: $VALID_MODULES"
      exit 1
    fi
  done
}

filter_modules() {
  local file_path="$1"
  local mode="$2"
  local modules_csv="$3"

  if $DRY_RUN; then
    printf "${YELLOW}[DRY RUN]${RESET} Would filter modules (%s: %s) in %s\n" "$mode" "$modules_csv" "$file_path"
    return
  fi

  if [[ ! -f "$file_path" ]]; then
    warn "Cannot filter modules: file not found: $file_path"
    return
  fi

  validate_module_names "$modules_csv"

  local content
  content="$(cat "$file_path")"

  if [[ "$mode" == "disable" ]]; then
    # Remove blocks for each listed module
    local IFS=','
    for mod in $modules_csv; do
      mod="$(echo "$mod" | tr -d '[:space:]')"
      # Use perl for reliable multi-line matching
      content="$(printf '%s' "$content" | perl -0777 -pe "s/\\n?<!-- MODULE: ${mod} -->.*?<!-- \\/MODULE: ${mod} -->//gs")"
    done
  elif [[ "$mode" == "enable" ]]; then
    # Remove all module blocks EXCEPT those in the list
    for valid in $VALID_MODULES; do
      local keep=false
      local IFS=','
      for mod in $modules_csv; do
        mod="$(echo "$mod" | tr -d '[:space:]')"
        if [[ "$mod" == "$valid" ]]; then
          keep=true
          break
        fi
      done
      if ! $keep; then
        content="$(printf '%s' "$content" | perl -0777 -pe "s/\\n?<!-- MODULE: ${valid} -->.*?<!-- \\/MODULE: ${valid} -->//gs")"
      fi
    done
  fi

  printf '%s\n' "$content" > "$file_path"
  info "  Filtered modules ($mode: $modules_csv) in $file_path"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$SCRIPT_DIR/global"
PROJECT_DIR="$SCRIPT_DIR/project"
PRESET_DIR="$PROJECT_DIR/presets"

print_banner() {
  echo ""
  bold "============================================================"
  bold " agentsmd Setup"
  bold " Configure AI CLI tools for autonomous coding"
  bold "============================================================"
  if $DRY_RUN; then
    warn "Dry-run mode enabled - no files will be written."
  fi
  echo ""
}

get_available_presets() {
  if [[ -d "$PRESET_DIR" ]]; then
    local dir
    for dir in "$PRESET_DIR"/*; do
      [[ -d "$dir" ]] && basename "$dir"
    done | sort
  fi
}

get_preset_path() {
  local preset="$1"
  printf '%s\n' "$PRESET_DIR/$preset/AGENTS.md"
}

print_preset_catalog() {
  bold "Available presets"
  local preset
  while IFS= read -r preset; do
    [[ -n "$preset" ]] && echo "  $preset"
  done < <(get_available_presets || true)
  echo ""
}

detect_package_manager() {
  local root="$1"

  if [[ -f "$root/bun.lockb" || -f "$root/bunfig.toml" ]]; then
    printf 'bun\n'
    return
  fi

  if [[ -f "$root/pnpm-lock.yaml" ]]; then
    printf 'pnpm\n'
    return
  fi

  if [[ -f "$root/yarn.lock" ]]; then
    printf 'yarn\n'
    return
  fi

  if [[ -f "$root/package-lock.json" ]]; then
    printf 'npm\n'
    return
  fi

  if [[ -f "$root/package.json" ]]; then
    if grep -Eq '"packageManager"[[:space:]]*:[[:space:]]*"bun@' "$root/package.json"; then
      printf 'bun\n'
      return
    fi
    if grep -Eq '"packageManager"[[:space:]]*:[[:space:]]*"pnpm@' "$root/package.json"; then
      printf 'pnpm\n'
      return
    fi
    if grep -Eq '"packageManager"[[:space:]]*:[[:space:]]*"yarn@' "$root/package.json"; then
      printf 'yarn\n'
      return
    fi
    if grep -Eq '"packageManager"[[:space:]]*:[[:space:]]*"npm@' "$root/package.json"; then
      printf 'npm\n'
      return
    fi
  fi
}

render_preset_content() {
  local content="$1"
  local package_manager="$2"

  case "$package_manager" in
    pnpm)
      content="${content//npm install/pnpm install}"
      content="${content//npm run /pnpm }"
      content="${content//npm test/pnpm test}"
      content="${content//npx /pnpm exec }"
      ;;
    yarn)
      content="${content//npm install/yarn install}"
      content="${content//npm run /yarn }"
      content="${content//npm test/yarn test}"
      content="${content//npx /yarn exec }"
      ;;
    bun)
      content="${content//npm install/bun install}"
      content="${content//npm run /bun run }"
      content="${content//npm test/bun test}"
      content="${content//npx /bunx }"
      ;;
  esac

  printf '%s' "$content"
}

detect_preset() {
  local root="$1"

  if [[ -f "$root/bun.lockb" || -f "$root/bunfig.toml" ]]; then
    printf 'bun\n'
    return
  fi

  if [[ -f "$root/package.json" ]] && grep -Eq '"packageManager"[[:space:]]*:[[:space:]]*"bun@|"bunx"|"bun run"' "$root/package.json"; then
    printf 'bun\n'
    return
  fi

  if [[ -f "$root/deno.json" || -f "$root/deno.jsonc" ]]; then
    printf 'deno\n'
    return
  fi

  if [[ -f "$root/package.json" ]] && grep -Eq '"deno task"|"deno run"|"deno test"' "$root/package.json"; then
    printf 'deno\n'
    return
  fi

  if [[ -f "$root/astro.config.mjs" || -f "$root/astro.config.ts" || -f "$root/astro.config.js" ]]; then
    printf 'astro\n'
    return
  fi

  if [[ -f "$root/remix.config.js" || -f "$root/remix.config.ts" || -f "$root/app/root.tsx" || -f "$root/app/root.jsx" ]]; then
    printf 'remix\n'
    return
  fi

  if [[ -f "$root/svelte.config.js" || -f "$root/svelte.config.ts" ]]; then
    printf 'svelte\n'
    return
  fi

  if [[ -f "$root/solid.config.js" || -f "$root/solid.config.ts" || -f "$root/src/root.tsx" ]]; then
    printf 'solid\n'
    return
  fi

  if [[ -f "$root/next.config.js" || -f "$root/next.config.mjs" || -f "$root/next.config.ts" || -d "$root/app" || -d "$root/src/app" ]]; then
    printf 'nextjs\n'
    return
  fi

  if [[ -f "$root/angular.json" ]]; then
    printf 'angular\n'
    return
  fi

  if [[ -f "$root/pubspec.yaml" && -f "$root/lib/main.dart" ]]; then
    printf 'flutter\n'
    return
  fi

  if [[ -f "$root/package.json" ]]; then
    if [[ -f "$root/src/App.vue" ]] || grep -Eq '"vue"|"vue-router"' "$root/package.json"; then
      printf 'vue\n'
      return
    fi

    if [[ -f "$root/src/App.tsx" ]] || [[ -f "$root/src/App.jsx" ]] || grep -Eq '"react"|"react-dom"' "$root/package.json"; then
      printf 'react\n'
      return
    fi

    if grep -Eq '"solid-start"|"@solidjs/start"|"solid-start dev"|"solid-start build"' "$root/package.json"; then
      printf 'solidstart\n'
      return
    fi

    if grep -Eq '"@tanstack/start"|"@tanstack/react-router"|"tanstack start"' "$root/package.json"; then
      printf 'tanstack\n'
      return
    fi

    if grep -Eq '"vite"|"vite dev"|"vite build"|"@vitejs/plugin-react"|"@vitejs/plugin-vue"' "$root/package.json"; then
      printf 'vite\n'
      return
    fi

    if [[ -f "$root/nest-cli.json" ]] || grep -Eq '"@nestjs/core"|"nestjs"' "$root/package.json"; then
      printf 'nestjs\n'
      return
    fi
  fi

  if [[ -n "$(find "$root" -type f -name '*.csproj' -print -quit 2>/dev/null)" ]]; then
    printf 'dotnet\n'
    return
  fi

  if [[ -n "$(find "$root" -type f -name '*.cs' -print -quit 2>/dev/null)" ]]; then
    printf 'csharp\n'
    return
  fi

  if [[ -n "$(find "$root" -type f \( -name '*.cpp' -o -name '*.cc' -o -name '*.cxx' \) -print -quit 2>/dev/null)" || -f "$root/CMakeLists.txt" ]]; then
    printf 'cpp\n'
    return
  fi

  if [[ -n "$(find "$root" -type f -name '*.c' -print -quit 2>/dev/null)" ]]; then
    printf 'c\n'
    return
  fi

  if [[ -d "$root/src-tauri" || -f "$root/tauri.conf.json" || -f "$root/tauri.conf.json5" ]]; then
    printf 'tauri\n'
    return
  fi

  if [[ -f "$root/package.json" ]]; then
    if [[ -f "$root/nest-cli.json" ]] || grep -Eq '"@nestjs/core"|"nestjs"' "$root/package.json"; then
      printf 'nestjs\n'
      return
    fi

    if grep -Eq '"express"' "$root/package.json"; then
      printf 'express\n'
      return
    fi

    printf 'nodejs\n'
    return
  fi

  if [[ -f "$root/go.mod" ]]; then
    printf 'go\n'
    return
  fi

  if [[ -f "$root/Cargo.toml" ]]; then
    printf 'rust\n'
    return
  fi

  if [[ -f "$root/build.gradle.kts" || -n "$(find "$root" -type f -name '*.kt' -print -quit 2>/dev/null)" ]]; then
    printf 'kotlin\n'
    return
  fi

  if [[ -f "$root/Package.swift" || -n "$(find "$root" -type f -name '*.swift' -print -quit 2>/dev/null)" ]]; then
    printf 'swift\n'
    return
  fi

  if [[ -f "$root/pom.xml" || -f "$root/build.gradle" || -f "$root/build.gradle.kts" || -f "$root/settings.gradle" || -f "$root/settings.gradle.kts" ]]; then
    printf 'java\n'
    return
  fi

  if [[ -f "$root/Gemfile" || -f "$root/.ruby-version" ]]; then
    printf 'ruby\n'
    return
  fi

  if [[ -f "$root/composer.json" || -f "$root/artisan" ]]; then
    if [[ -f "$root/composer.json" ]] && grep -Eq '"laravel/framework"' "$root/composer.json"; then
      printf 'laravel\n'
      return
    fi

    printf 'php\n'
    return
  fi

  if [[ -f "$root/pyproject.toml" || -f "$root/uv.lock" || -f "$root/requirements.txt" ]]; then
    if [[ -f "$root/manage.py" || -f "$root/settings.py" ]]; then
      printf 'django\n'
      return
    fi

    if [[ -f "$root/main.py" || -f "$root/src/main.py" ]]; then
      printf 'fastapi\n'
      return
    fi

    printf 'python\n'
    return
  fi

  if [[ -f "$root/mix.exs" ]]; then
    printf 'elixir\n'
    return
  fi

  if [[ -f "$root/cpanfile" || -f "$root/Makefile.PL" || -n "$(find "$root" -type f \( -name '*.pl' -o -name '*.pm' \) -print -quit 2>/dev/null)" ]]; then
    printf 'perl\n'
    return
  fi

  if [[ -f "$root/build.sbt" || -n "$(find "$root" -type f -name '*.scala' -print -quit 2>/dev/null)" ]]; then
    printf 'scala\n'
    return
  fi

  printf 'generic\n'
}

select_preset() {
  local presets=()
  local preset
  while IFS= read -r preset; do
    [[ -n "$preset" ]] && presets+=("$preset")
  done < <(get_available_presets || true)
  if [[ ${#presets[@]} -eq 0 ]]; then
    warn "No presets found under project/presets. Falling back to generic."
    printf 'generic\n'
    return
  fi

  bold "Choose a project preset:"
  echo "  [1] Auto-detect"
  local i=0
  for preset in "${presets[@]}"; do
    i=$((i + 1))
    echo "  [$((i + 1))] $preset"
  done
  echo
  printf "Enter choice [1-%d]: " "$((${#presets[@]} + 1))"
  local choice
  read -r choice

  if [[ -z "$choice" || "$choice" == "1" ]]; then
    printf 'auto\n'
    return
  fi

  if [[ "$choice" =~ ^[0-9]+$ ]]; then
    local index=$((choice - 2))
    if [[ $index -ge 0 && $index -lt ${#presets[@]} ]]; then
      printf '%s\n' "${presets[$index]}"
      return
    fi
  fi

  for preset in "${presets[@]}"; do
    if [[ "$choice" == "$preset" ]]; then
      printf '%s\n' "$preset"
      return
    fi
  done

  warn "Invalid preset choice. Falling back to auto-detect."
  printf 'auto\n'
}

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

  local agents_src="$GLOBAL_DIR/AGENTS.md"
  if [[ ! -f "$agents_src" ]]; then
    error "Source file not found: $agents_src"
    return 1
  fi

  local module_mode=""
  local module_list=""
  if [[ -n "$ENABLE_MODULES" ]]; then
    module_mode="enable"
    module_list="$ENABLE_MODULES"
  elif [[ -n "$DISABLE_MODULES" ]]; then
    module_mode="disable"
    module_list="$DISABLE_MODULES"
  fi

  if $claude_detected; then
    run mkdir -p "$claude_dir"
    backup_file "$claude_dir/AGENTS.md"
    copy_file "$agents_src" "$claude_dir/AGENTS.md"
    if [[ -n "$module_mode" ]]; then
      filter_modules "$claude_dir/AGENTS.md" "$module_mode" "$module_list"
    fi
  fi

  if $codex_detected; then
    run mkdir -p "$codex_dir"
    backup_file "$codex_dir/AGENTS.md"
    copy_file "$agents_src" "$codex_dir/AGENTS.md"
    if [[ -n "$module_mode" ]]; then
      filter_modules "$codex_dir/AGENTS.md" "$module_mode" "$module_list"
    fi
  fi

  if $gemini_detected; then
    run mkdir -p "$gemini_dir"
    backup_file "$gemini_dir/AGENTS.md"
    copy_file "$agents_src" "$gemini_dir/AGENTS.md"
    if [[ -n "$module_mode" ]]; then
      filter_modules "$gemini_dir/AGENTS.md" "$module_mode" "$module_list"
    fi
  fi

  if $claude_detected; then
    local claude_md_src="$GLOBAL_DIR/CLAUDE.md"
    if [[ -f "$claude_md_src" ]]; then
      backup_file "$claude_dir/CLAUDE.md"
      copy_file "$claude_md_src" "$claude_dir/CLAUDE.md"
    else
      warn "global/CLAUDE.md not found - skipping."
    fi
  fi

  if $gemini_detected; then
    local gemini_md_src="$GLOBAL_DIR/GEMINI.md"
    if [[ -f "$gemini_md_src" ]]; then
      backup_file "$gemini_dir/GEMINI.md"
      copy_file "$gemini_md_src" "$gemini_dir/GEMINI.md"
    else
      warn "global/GEMINI.md not found - skipping."
    fi
  fi

  if $codex_detected; then
    local codex_md_src="$GLOBAL_DIR/CODEX.md"
    if [[ -f "$codex_md_src" ]]; then
      backup_file "$codex_dir/CODEX.md"
      copy_file "$codex_md_src" "$codex_dir/CODEX.md"
    else
      warn "global/CODEX.md not found - skipping."
    fi
  fi

  success "Global config install complete."
  echo ""
}

install_project() {
  local preset_name="${1:-auto}"

  info "--- Installing project template ---"

  local cwd
  cwd="$(pwd)"

  if [[ "$cwd" == "$SCRIPT_DIR" ]]; then
    error "You are running from inside the setup repo itself."
    error "Change to your project directory first, then re-run this script."
    return 1
  fi

  if [[ "$preset_name" == "auto" ]]; then
    preset_name="$(detect_preset "$cwd")"
  fi

  local src
  src="$(get_preset_path "$preset_name")"
  if [[ ! -f "$src" ]]; then
    warn "Preset '$preset_name' not found. Falling back to generic."
    preset_name="generic"
    src="$(get_preset_path "$preset_name")"
  fi

  if [[ ! -f "$src" ]]; then
    error "Source file not found: $src"
    return 1
  fi

  local package_manager
  package_manager="$(detect_package_manager "$cwd" || true)"

  local dst="$cwd/AGENTS.md"
  backup_file "$dst"
  if $DRY_RUN; then
    if [[ -n "$package_manager" ]]; then
      printf "${YELLOW}[DRY RUN]${RESET} Would render %s commands: %s -> %s\n" "$package_manager" "$src" "$dst"
    else
      printf "${YELLOW}[DRY RUN]${RESET} Would copy: %s -> %s\n" "$src" "$dst"
    fi
  else
    local content
    content="$(cat "$src")"
    if [[ -n "$package_manager" ]]; then
      content="$(render_preset_content "$content" "$package_manager")"
      success "  Rendered $package_manager commands: $src -> $dst"
    else
      success "  Copied: $src -> $dst"
    fi
    printf '%s\n' "$content" > "$dst"
  fi

  success "Installed project preset: $preset_name"
  if [[ -n "$package_manager" ]]; then
    info "Adjusted command examples for package manager: $package_manager"
  fi
  echo ""
}

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

print_menu() {
  echo ""
  bold "What would you like to install?"
  echo "  [1] Global config (AGENTS.md + tool-specific configs)"
  echo "  [2] Project template (auto-detect preset)"
  echo "  [3] Project template (choose preset manually)"
  echo "  [4] Claude Code settings (auto mode, permissions, plugins)"
  echo "  [5] All of the above"
  echo ""
  printf "Enter choice [1-5]: "
}

INSTALLED_ITEMS=()

main() {
  if $LIST_PRESETS; then
    print_preset_catalog
    return
  fi

  if $ALL || [[ -n "$PRESET" ]]; then
    local preset_choice
    preset_choice="${PRESET:-auto}"
    local detected_package_manager=""

    if [[ "$preset_choice" == "auto" ]]; then
      detected_package_manager="$(detect_package_manager "$(pwd)" || true)"
      if [[ -n "$detected_package_manager" ]]; then
        info "Detected package manager: $detected_package_manager"
      fi
    fi

    if $ALL; then
      install_global
      INSTALLED_ITEMS+=("Global config (AGENTS.md + tool-specific configs)")
      install_project "$preset_choice"
      INSTALLED_ITEMS+=("Project template (preset: $preset_choice -> $(pwd)/AGENTS.md)")
      install_settings
      INSTALLED_ITEMS+=("Claude Code settings (~/.claude/settings.json)")
    else
      install_project "$preset_choice"
      INSTALLED_ITEMS+=("Project template (preset: $preset_choice -> $(pwd)/AGENTS.md)")
    fi

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
    if [[ -n "$detected_package_manager" ]]; then
      echo "  Package manager: $detected_package_manager"
    fi
    if $DRY_RUN; then
      warn "Dry-run mode was active - no files were written."
    fi
    echo ""
    return
  fi

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
      install_project "auto"
      INSTALLED_ITEMS+=("Project template (auto-detected preset -> $(pwd)/AGENTS.md)")
      ;;
    3)
      local preset
      preset="$(select_preset)"
      install_project "$preset"
      INSTALLED_ITEMS+=("Project template (preset: $preset -> $(pwd)/AGENTS.md)")
      ;;
    4)
      install_settings
      INSTALLED_ITEMS+=("Claude Code settings (~/.claude/settings.json)")
      ;;
    5)
      install_global
      INSTALLED_ITEMS+=("Global config (AGENTS.md + tool-specific configs)")
      install_project "auto"
      INSTALLED_ITEMS+=("Project template (auto-detected preset -> $(pwd)/AGENTS.md)")
      install_settings
      INSTALLED_ITEMS+=("Claude Code settings (~/.claude/settings.json)")
      ;;
    *)
      error "Invalid choice: '$choice'. Please enter 1, 2, 3, 4, or 5."
      exit 1
      ;;
  esac

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
    warn "Dry-run mode was active - no files were written."
  fi
  echo ""
}

main
