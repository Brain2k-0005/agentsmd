#!/usr/bin/env bash
# test_helper.bash - Shared setup/teardown for bats tests
#
# Creates isolated temp directories so tests never touch the real HOME
# or any real agent config directories.

# Point SCRIPT_DIR at the repo root (one level up from tests/)
export SCRIPT_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

setup() {
  # Create a unique temp directory for this test
  TEST_TMPDIR="$(mktemp -d "${BATS_TMPDIR:-/tmp}/install_test.XXXXXX")"

  # Build a fake HOME inside the temp dir
  FAKE_HOME="$TEST_TMPDIR/home"
  mkdir -p "$FAKE_HOME"

  # Pre-create the AI tool config directories that install.sh checks for
  mkdir -p "$FAKE_HOME/.claude"
  mkdir -p "$FAKE_HOME/.codex"
  mkdir -p "$FAKE_HOME/.gemini"

  # Build a fake project directory (distinct from SCRIPT_DIR so install_project
  # does not bail out with "running from inside the setup repo" error)
  FAKE_PROJECT="$TEST_TMPDIR/project"
  mkdir -p "$FAKE_PROJECT"

  # Seed the fake project with a minimal package.json
  cat > "$FAKE_PROJECT/package.json" <<'PKGJSON'
{
  "name": "fake-project",
  "version": "1.0.0"
}
PKGJSON

  # Override HOME for every command in the test
  export HOME="$FAKE_HOME"
}

teardown() {
  # Clean up the temp directory tree
  if [[ -n "${TEST_TMPDIR:-}" && -d "$TEST_TMPDIR" ]]; then
    rm -rf "$TEST_TMPDIR"
  fi
}
