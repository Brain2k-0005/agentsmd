# Skill Discovery — Finding and Using Agent Skills

## Before Starting Any Task

Check what skills and tools are available. Skills provide specialized workflows that are faster and more reliable than building from scratch.

## Discovery by Platform

**Claude Code**
- Use the `find-skills` skill to search for skills matching your task
- List installed plugins: run `/plugins` or check settings
- Install a plugin: `/install-plugin <name>@<marketplace>`
- Superpowers skills activate automatically when relevant

**Codex CLI**
- Check `.codex/skills/` in the repo for project skills
- Check `~/.codex/skills/` for global skills
- Codex reads AGENTS.md for workflow guidance

**Gemini CLI**
- Use `activate_skill` tool to load available skills
- Check configured MCP servers for extended capabilities
- Gemini reads AGENTS.md and GEMINI.md for workflow guidance

## Recommended Skill Categories

| Category | What it covers |
|---|---|
| Debugging | Systematic root cause analysis, stack trace reading |
| Testing | TDD workflows, test generation, coverage reporting |
| Code review | Automated review against plan, security scanning |
| Architecture | ADR creation, blueprint generation, design patterns |
| Documentation | Structured docs, API references, README generation |
| Git | Conventional commits, branch workflows, PR creation |

## Usage Rules

- If a skill exists for the task, use it — do not reimplement its workflow manually
- Install skills globally when they are useful across all projects (review, commit, debug)
- Install skills at project scope when they depend on project conventions
- After installing a new skill, read its description before invoking it
- If no skill covers the task, check if a related skill covers part of it
