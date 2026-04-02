# Skill Discovery — Finding and Using Agent Skills

## Before Starting Any Task

Use `find-skills` to discover relevant skills for the current task. This is the primary discovery mechanism — agents should self-discover what they need rather than relying on hardcoded skill lists. Skills provide specialized workflows that are faster and more reliable than building from scratch.

## Discovery by Platform

**Claude Code**
- Use `find-skills` to search for skills matching your task — this is the default discovery path
- The `superpowers` plugin provides core workflow skills (planning, debugging, TDD, code review, parallel agents)
- List installed plugins: run `/plugins` or check settings
- Install a plugin: `/install-plugin <name>@<marketplace>`

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
