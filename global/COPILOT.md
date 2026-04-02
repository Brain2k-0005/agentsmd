# GitHub Copilot Global Configuration

Core workflow rules are in AGENTS.md. This file adds GitHub Copilot specific behavior only.

## Context Files

Copilot reads context from the repository root:

- `AGENTS.md` — project rules and conventions (primary config)
- `.github/copilot-instructions.md` — Copilot-specific instructions (if needed)
- Keep both files in sync when using both

## Workspace Conventions

- Follow the code style detected from existing files
- Prefer existing patterns in the codebase over introducing new ones
- When suggesting changes, respect the project's test framework and directory structure

## Review Workflow

- Review all suggestions against the project's quality gates before accepting
- Verify type safety when the project uses static typing
- Check that suggestions follow the commit conventions from git log

## Boundaries

- Never suggest changes to generated files, migrations, or secrets
- Follow the never-modify list in the project AGENTS.md
- When in doubt, follow the existing codebase pattern
