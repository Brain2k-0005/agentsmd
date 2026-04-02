# Claude Code Global Configuration

Core workflow rules are in AGENTS.md. This file adds Claude Code specific behavior only.

## Autonomous Workflow

Work independently for extended periods. Ask the user only when stuck after 3 genuine attempts
at resolving a blocker. Never ask permission before each step - plan, execute, verify, report.

## Skill Discovery

Before any non-trivial task, check for relevant skills first:

- Use the Claude skill discovery workflow to find a matching skill or plugin
- Prefer installed skills over ad hoc prompting
- Keep broadly useful skills installed globally:
  - discovery and setup
  - planning and implementation
  - debugging and testing
  - code review and verification
- Keep stack-specific skills at the project scope when they only apply to one repo

## Project Presets

When a repository has `project/presets/`, read the matching preset before editing:

- `generic` for unknown stacks
- `nextjs` for Next.js app-router projects
- `dotnet` for ASP.NET Core and Clean Architecture repos
- `python` for FastAPI / SQLAlchemy repos

## Agent Teams

For any task touching 3+ independent files or areas, use parallel agents:

- Create teams via the Claude Code team workflow or parallel agent skill
- Lead agent: plans, coordinates, reviews, integrates
- Worker agents: implement individual tasks in parallel
- Reviewer: reviews the integrated result before marking done

## Token Efficiency

- Use dedicated tools over shell: Read over cat, Grep over grep, Glob over find
- Read files with offset and limit - never load large files blindly
- Batch independent tool calls in a single message
- Use smaller agents for implementation and stronger agents for planning and review
- No trailing summaries, no restating the question, no preamble

## Claude Code Git Override

- Never add Co-Authored-By lines to commit messages
