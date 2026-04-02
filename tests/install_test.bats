#!/usr/bin/env bats
# install_test.bats - Test suite for install.sh
#
# Requires bats-core: https://github.com/bats-core/bats-core
# Run:  bats tests/install_test.bats

load test_helper

# ---------------------------------------------------------------------------
# 1. --list-presets shows all presets
# ---------------------------------------------------------------------------
@test "--list-presets shows all presets" {
  run bash "$SCRIPT_DIR/install.sh" --list-presets

  [ "$status" -eq 0 ]

  # Verify key preset names appear in the output
  [[ "$output" == *"nextjs"*  ]]
  [[ "$output" == *"python"*  ]]
  [[ "$output" == *"dotnet"*  ]]
  [[ "$output" == *"go"*      ]]
  [[ "$output" == *"generic"* ]]
}

# ---------------------------------------------------------------------------
# 2. --dry-run writes no files
# ---------------------------------------------------------------------------
@test "--dry-run --all writes no files" {
  cd "$FAKE_PROJECT"

  run bash "$SCRIPT_DIR/install.sh" --all --dry-run

  [ "$status" -eq 0 ]

  # No AGENTS.md should have been created in the fake HOME directories
  [ ! -f "$FAKE_HOME/.claude/AGENTS.md" ]
  [ ! -f "$FAKE_HOME/.codex/AGENTS.md"  ]
  [ ! -f "$FAKE_HOME/.gemini/AGENTS.md" ]

  # No AGENTS.md should have been created in the fake project
  [ ! -f "$FAKE_PROJECT/AGENTS.md" ]
}

# ---------------------------------------------------------------------------
# 3. --preset nextjs copies correct file
# ---------------------------------------------------------------------------
@test "--preset nextjs installs AGENTS.md with Next.js content" {
  cd "$FAKE_PROJECT"

  run bash "$SCRIPT_DIR/install.sh" --preset nextjs

  [ "$status" -eq 0 ]
  [ -f "$FAKE_PROJECT/AGENTS.md" ]

  # The Next.js preset file should mention "Next.js"
  run grep -i "Next.js" "$FAKE_PROJECT/AGENTS.md"
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# 4. Unknown argument exits with error
# ---------------------------------------------------------------------------
@test "unknown argument exits with error" {
  run bash "$SCRIPT_DIR/install.sh" --bogus

  [ "$status" -eq 1 ]
  [[ "$output" == *"Unknown argument"* ]]
}

# ---------------------------------------------------------------------------
# 5. Backup creation
# ---------------------------------------------------------------------------
@test "existing file is backed up before overwrite" {
  cd "$FAKE_PROJECT"

  # Pre-create an AGENTS.md so backup_file triggers
  echo "original content" > "$FAKE_PROJECT/AGENTS.md"

  run bash "$SCRIPT_DIR/install.sh" --preset generic

  [ "$status" -eq 0 ]

  # There should be a .backup. file alongside the original
  local backup_count
  backup_count=$(ls "$FAKE_PROJECT"/AGENTS.md.backup.* 2>/dev/null | wc -l)
  [ "$backup_count" -ge 1 ]
}

# ---------------------------------------------------------------------------
# 6. Missing preset falls back to generic
# ---------------------------------------------------------------------------
@test "missing preset falls back to generic" {
  cd "$FAKE_PROJECT"

  run bash "$SCRIPT_DIR/install.sh" --preset nonexistent

  [ "$status" -eq 0 ]
  [ -f "$FAKE_PROJECT/AGENTS.md" ]

  # Output should mention the fallback
  [[ "$output" == *"Falling back to generic"* ]]

  # The installed file should match the generic preset content
  run grep -i "Generic Project" "$FAKE_PROJECT/AGENTS.md"
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# 7. Package manager detection - npm
# ---------------------------------------------------------------------------
@test "detects npm from package-lock.json" {
  cd "$FAKE_PROJECT"
  touch "$FAKE_PROJECT/package-lock.json"

  run bash "$SCRIPT_DIR/install.sh" --preset nextjs

  [ "$status" -eq 0 ]

  # npm is the default in the preset, so "npm install" should be present
  run grep "npm install" "$FAKE_PROJECT/AGENTS.md"
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# 8. Package manager detection - pnpm
# ---------------------------------------------------------------------------
@test "detects pnpm from pnpm-lock.yaml" {
  cd "$FAKE_PROJECT"
  touch "$FAKE_PROJECT/pnpm-lock.yaml"

  run bash "$SCRIPT_DIR/install.sh" --preset nextjs

  [ "$status" -eq 0 ]

  # Output should mention pnpm detection
  [[ "$output" == *"pnpm"* ]]
}

# ---------------------------------------------------------------------------
# 9. Package manager detection - yarn
# ---------------------------------------------------------------------------
@test "detects yarn from yarn.lock" {
  cd "$FAKE_PROJECT"
  touch "$FAKE_PROJECT/yarn.lock"

  run bash "$SCRIPT_DIR/install.sh" --preset nextjs

  [ "$status" -eq 0 ]

  # Output should mention yarn detection
  [[ "$output" == *"yarn"* ]]
}

# ---------------------------------------------------------------------------
# 10. Package manager detection - bun
# ---------------------------------------------------------------------------
@test "detects bun from bun.lockb" {
  cd "$FAKE_PROJECT"
  touch "$FAKE_PROJECT/bun.lockb"

  run bash "$SCRIPT_DIR/install.sh" --preset nextjs

  [ "$status" -eq 0 ]

  # Output should mention bun detection
  [[ "$output" == *"bun"* ]]
}

# ---------------------------------------------------------------------------
# 11. Preset rendering replaces npm commands with pnpm
# ---------------------------------------------------------------------------
@test "pnpm lockfile causes npm commands to be replaced with pnpm in preset" {
  cd "$FAKE_PROJECT"
  touch "$FAKE_PROJECT/pnpm-lock.yaml"

  run bash "$SCRIPT_DIR/install.sh" --preset nextjs

  [ "$status" -eq 0 ]
  [ -f "$FAKE_PROJECT/AGENTS.md" ]

  # The rendered file should contain "pnpm install" instead of "npm install"
  run grep "pnpm install" "$FAKE_PROJECT/AGENTS.md"
  [ "$status" -eq 0 ]

  # Bare "npm install" (not "pnpm install") should NOT appear in the rendered output.
  # grep for "npm install" then exclude lines containing "pnpm install".
  # If nothing remains, the pipeline returns non-zero which is what we want.
  run bash -c "grep 'npm install' '$FAKE_PROJECT/AGENTS.md' | grep -v 'pnpm install'"
  [ "$status" -ne 0 ]
}
