# Gemini CLI Global Configuration

Core workflow rules are in AGENTS.md. This file adds Gemini CLI specific behavior only.

## Autonomous Mode (Gemini Specific)

Use the two-phase approach for complex tasks:
- Plan mode: reason through the approach in read-only mode before writing code
- Execute mode: implement the plan, then verify before reporting completion

Only pause to ask the user when genuinely blocked after 3 attempts on the same issue.

## Skill Activation (Gemini Specific)

Before starting any non-trivial task, check for applicable skills:
- Use the `activate_skill` tool to load skills relevant to the current task
- Prefer existing skills over improvising — skills encode proven workflows
- Common skill types to look for: planning, debugging, testing, code review, verification

## Subagents for Parallel Work (Gemini Specific)

For tasks with 3+ independent workstreams, dispatch subagents:
- Each subagent gets a clear, self-contained task description with all required context
- Run independent workstreams in parallel — do not serialize work that can overlap
- After subagents complete, integrate and review their output before reporting done

## MCP Server Integration

Leverage configured MCP servers to extend capabilities beyond the default toolset:
- Check available MCP tools at the start of complex tasks
- Use MCP servers for: extended file access, external APIs, specialized search, database queries
- Prefer MCP tools over workarounds when an appropriate server is configured

## Token Efficiency (Gemini Specific)

- Read files with offsets — never load entire large files into context
- Batch independent tool calls in a single response
- CLI tools for simple ops (file reads, git, builds); MCP tools for external services
- Give subagents focused tasks with file paths, not broad exploration
