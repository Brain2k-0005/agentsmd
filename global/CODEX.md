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

## Agent Teams

Codex CLI supports parallel task execution:

- **Lead** (strongest available model): Plans, distributes, and integrates work
- **Workers** (fast models): Execute focused tasks in parallel within the sandbox
- **Reviewer** (strong model, or use Claude/Gemini for cross-tool review): Validates result
- Break work into self-contained tasks with complete context and file paths
- Each worker operates independently — no cross-dependencies during implementation

## Cross-Tool Review

When reviewing code written by another AI tool (Claude, Gemini):

- Read the full diff before commenting
- Check against the project's AGENTS.md quality gates
- Focus on what the other tool might miss: over-engineering, unnecessary complexity, practical issues
- When your code is reviewed by another tool, fix flagged issues without defensiveness

## Token Efficiency

- Read files with targeted line ranges, not entire files
- Batch independent operations in a single response
- Use CLI tools for file operations, not workarounds
- Keep responses terse — lead with the answer
