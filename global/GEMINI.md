# Gemini CLI Global Configuration

Core workflow rules are in AGENTS.md. This file adds Gemini CLI specific behavior only.

## Autonomous Mode

Use the two-phase approach for complex tasks:

- Plan mode: reason through the approach in read-only mode before writing code
- Execute mode: implement the plan, then verify before reporting completion

Only pause to ask the user when genuinely blocked after 3 attempts on the same issue.

## Skill Activation

Before starting any non-trivial task, check for applicable skills:

- Use the Gemini skill activation workflow to load relevant skills
- Prefer existing skills over improvising a workflow
- Keep broadly useful skills installed globally
- Keep project-specific skills scoped to the repository when they only apply there

## Project Presets

When a repository has `project/presets/`, read the matching preset before editing:

- `generic` for unknown stacks
- `nextjs` for Next.js app-router projects
- `dotnet` for ASP.NET Core and Clean Architecture repos
- `python` for FastAPI / SQLAlchemy repos

## Agent Teams

Gemini CLI supports subagent dispatch for parallel work:

- **Lead** (strongest Gemini model): Plans the approach, distributes tasks, integrates results
- **Workers** (fast Gemini models): Each gets a focused, self-contained task with all required context
- **Reviewer** (strong model, or use Claude/Codex for cross-tool review): Validates against plan
- Run independent workstreams in parallel — do not serialize work that can overlap
- After workers complete, the lead integrates and reviews all output before reporting done

## MCP Server Integration

Leverage configured MCP servers to extend capabilities beyond the default toolset:

- Check available MCP tools at the start of complex tasks
- Use MCP servers for extended file access, external APIs, specialized search, database queries
- Prefer MCP tools over workarounds when an appropriate server is configured

## Cross-Tool Review

When reviewing code written by another AI tool (Claude, Codex):

- Read the full diff before commenting
- Check against the project's AGENTS.md quality gates
- Focus on what the other tool might miss: alternative approaches, edge cases, documentation gaps
- When your code is reviewed by another tool, fix flagged issues without defensiveness

## Token Efficiency

- Read files with offsets - never load entire large files into context
- Batch independent tool calls in a single response
- CLI tools for simple ops; MCP tools for external services
- Give subagents focused tasks with file paths, not broad exploration
