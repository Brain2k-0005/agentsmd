# Claude Code Global Configuration

Core workflow rules are in AGENTS.md. This file adds Claude Code specific behavior only.

## Autonomous Workflow

Work independently for extended periods. Ask the user only when stuck after 3 genuine attempts
at resolving a blocker. Never ask permission before each step - plan, execute, verify, report.

## Skill Discovery

Before any non-trivial task, check for relevant skills:

- Use `find-skills` to search for skills matching the current task
- The `superpowers` plugin provides core workflow skills (planning, debugging, TDD, code review, parallel agents)
- For stack-specific skills, use `find-skills` to discover and install them per-project
- Do not manually search for skills — `find-skills` handles discovery automatically

## Project Presets

When a repository has `project/presets/`, read the matching preset before editing:

- `generic` for unknown stacks
- `nextjs` for Next.js app-router projects
- `dotnet` for ASP.NET Core and Clean Architecture repos
- `python` for FastAPI / SQLAlchemy repos

## Agent Teams

Claude Code supports parallel agent teams natively:

- **Lead** (Opus): Plans, coordinates, reviews, integrates — use the strongest model for this role
- **Workers** (Sonnet): Implement individual tasks in parallel — use fast models for throughput
- **Reviewer** (Opus, or use Codex/Gemini for cross-tool review): Validates integrated result
- Dispatch via the `dispatching-parallel-agents` skill or `TeamCreate` tool
- Give every agent complete context — file paths, constraints, expected output

## Token Efficiency

- Use dedicated tools over shell: Read over cat, Grep over grep, Glob over find
- Read files with offset and limit - never load large files blindly
- Batch independent tool calls in a single message
- Use smaller agents for implementation and stronger agents for planning and review
- No trailing summaries, no restating the question, no preamble

## Cross-Tool Review

When reviewing code written by another AI tool (Codex, Gemini):

- Read the full diff before commenting
- Check against the project's AGENTS.md quality gates
- Focus on what the other tool might miss: architecture alignment, design patterns, edge cases
- When your code is reviewed by another tool, fix flagged issues without defensiveness

## Claude Code Git Override

- Never add Co-Authored-By lines to commit messages
