# Claude Code Global Configuration

Core workflow rules are in AGENTS.md. This file adds Claude Code specific behavior only.

## Autonomous Workflow

Work independently for extended periods. Ask the user only when stuck after 3 genuine attempts
at resolving a blocker. Never ask permission before each step — plan, execute, verify, report.

## Skill Discovery (Claude Code Specific)

Before starting any non-trivial task, check for relevant skills:
- Run the `find-skills` skill to discover available skills for the current task type
- Always prefer an existing skill over reinventing the approach
- Key superpowers skills:
  - `brainstorming` — explore approaches before committing
  - `writing-plans` — formal plans for medium/large tasks
  - `executing-plans` — structured plan execution with review checkpoints
  - `systematic-debugging` — root cause analysis for hard bugs
  - `test-driven-development` — write tests first
  - `verification-before-completion` — quality gate before claiming done
  - `dispatching-parallel-agents` — coordinate parallel agent teams
  - `requesting-code-review` — review before merge

## Agent Teams (Claude Code Specific)

For any task touching 3+ independent files or areas, use parallel agents:
- Create teams via `TeamCreate` or dispatch with `dispatching-parallel-agents` skill
- Lead agent: Opus — plans, coordinates, reviews, integrates
- Worker agents: Sonnet — implement individual tasks in parallel
- Reviewer: Opus — reviews integrated result before marking done
- Use `verification-before-completion` skill after integration

## Token Efficiency (Claude Code Specific)

- Use dedicated tools over Bash: Read over cat, Grep over grep, Glob over find
- Read files with offset+limit — never read 2000 lines when you need 50
- Batch independent tool calls in a single message
- Grep with context (-C) instead of grep-then-read
- Use Sonnet/Haiku for implementation subagents, Opus only for planning and review
- No trailing summaries, no restating the question, no preamble

## Claude Code Git Override

- Never add Co-Authored-By lines to commit messages
