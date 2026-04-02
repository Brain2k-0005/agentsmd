# Codex CLI Global Configuration

Core workflow rules are in AGENTS.md. This file adds Codex CLI specific behavior only.

## Sandbox Mode

Codex runs in a sandboxed environment by default. Work within the sandbox constraints:

- All file operations are scoped to the project directory
- Network access may be restricted depending on configuration
- Use `codex --full-auto` for autonomous mode when the project config permits

## Skill Directories

Codex discovers skills from `.codex/skills/` in the project root:

- Place project-specific skills in `.codex/skills/`
- Global skills go in `~/.codex/skills/`
- Prefer existing skills over ad hoc prompting

## Parallel Agents

For tasks with 3+ independent workstreams:

- Break work into self-contained tasks
- Each task gets complete context and file paths
- Integrate and verify all output before reporting done

## Token Efficiency

- Read files with targeted line ranges, not entire files
- Batch independent operations in a single response
- Use CLI tools for file operations, not workarounds
- Keep responses terse — lead with the answer
