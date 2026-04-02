# Autonomous Agent Config - Improvement Spec

**Date:** 2026-04-02
**Status:** Approved

## Summary

Seven improvements to harden the project for public use: preset templating, installer tests, README trim, CI pipeline, module flags, conservative defaults, and missing tool configs.

## 1. Preset Templating System

**Goal:** Replace 37 manually maintained preset files with a generator.

**Files created:**
- `templates/preset-template.md` — Single Mustache-style template with `{{variable}}` placeholders
- `templates/preset-config.yaml` — Per-stack variable definitions for all 37 presets
- `templates/generate-presets.sh` — Bash generator that reads YAML + template, writes `project/presets/*/AGENTS.md`
- `templates/generate-presets.ps1` — PowerShell equivalent

**Template variables:** `name`, `overview`, `commands` (install/dev/build/test/lint/format/extra), `tech_stack` rows, `code_style` bullets, `skills` bullets, `testing` (command/framework/unit/integration/e2e), `boundaries` (never_modify/external_services).

**Output:** The 37 preset files remain as generated output. Running the generator overwrites them. The generator uses simple `sed`/string replacement — no external template engine dependency.

## 2. Installer Testing

**Files created:**
- `tests/install_test.bats` — bats-core test cases
- `tests/test_helper.bash` — shared setup/teardown (temp dirs, fixture creation)

**Test cases:**
- `--list-presets` outputs all preset names
- `--dry-run` writes no files
- `--preset nextjs` copies correct preset
- `--all --dry-run` prints all install steps
- Unknown argument exits with error
- Backup creation works when target exists
- Missing preset falls back to generic
- Package manager detection (npm, pnpm, yarn, bun)

## 3. README Trim

**Changes to `README.md`:**
- Replace lines 193-226 (35 `cp` commands) with single parameterized instruction:
  ```
  cp project/presets/<your-stack>/AGENTS.md /path/to/your/project/AGENTS.md
  ```
- List available stacks as a comma-separated line, not individual commands
- Total manual install section: ~15 lines instead of ~45

## 4. CI Pipeline

**File created:** `.github/workflows/ci.yml`

**Jobs:**
- `lint`: shellcheck on `install.sh` and `templates/generate-presets.sh`
- `test`: bats test suite
- `markdown`: markdownlint on all `.md` files (allow long lines)
- `presets`: run generator and verify output matches committed presets (drift detection)

**Triggers:** push to main, pull requests.

## 5. Installer Module Flags

**Changes to `install.sh` and `install.ps1`:**

New flags:
- `--enable-modules <comma-list>` — only keep listed module blocks in the generated AGENTS.md
- `--disable-modules <comma-list>` — remove listed module blocks from the generated AGENTS.md

Implementation: After copying `global/AGENTS.md`, scan for `<!-- MODULE: name -->` / `<!-- /MODULE: name -->` comment pairs and strip disabled blocks. Default: all modules enabled.

Module names: `agent-teams`, `quality-gates`, `code-review`, `tdd`, `skill-discovery`, `token-efficiency`.

## 6. Conservative Settings Default

**Changes:**
- `global/claude-settings.json` — Replace `Bash(*)` with specific safe patterns: `Bash(git *)`, `Bash(npm *)`, `Bash(node *)`, `Bash(npx *)`, `Bash(pnpm *)`, `Bash(yarn *)`, `Bash(bun *)`, `Bash(dotnet *)`, `Bash(go *)`, `Bash(cargo *)`, `Bash(python *)`, `Bash(uv *)`, `Bash(pip *)`, `Bash(pytest *)`, `Bash(cat *)`, `Bash(ls *)`, `Bash(pwd)`, `Bash(which *)`, `Bash(echo *)`, `Bash(mkdir *)`, `Bash(cp *)`, `Bash(mv *)`, `Bash(cd *)`.
- `global/claude-settings-power.json` — Copy of current settings with `Bash(*)` for power users who want unrestricted shell access.
- Update README to mention both options.

## 7. Missing Tool-Specific Configs

**Files created:**
- `global/CODEX.md` — Codex CLI specific extensions (sandbox mode, skill directories, parallel agents)
- `global/COPILOT.md` — GitHub Copilot specific extensions (context files, workspace conventions)

**Changes to installers:** Detect `~/.codex` and copy `CODEX.md`; Copilot reads from repo root so document in README only.
