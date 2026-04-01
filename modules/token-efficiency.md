# Token Efficiency — Minimize Cost, Maximize Autonomy

Long autonomous runs burn tokens fast. Every unnecessary tool call, verbose output, or redundant read shortens your effective runway. Optimize relentlessly.

## Core Principles

1. **Read once, remember** — never re-read a file you already have in context
2. **Targeted reads** — use line ranges or offsets instead of reading entire large files
3. **Batch operations** — combine independent tool calls into a single message
4. **Terse output** — lead with the answer, skip preamble, avoid restating what was asked
5. **Right-size the tool** — use the cheapest tool that gets the job done (see CLI vs MCP below)

## CLI Tools vs MCP Tools — When to Use Which

| Use CLI tools (Bash) when... | Use MCP tools when... |
|---|---|
| Simple file ops: ls, mkdir, cp, mv | Structured queries: databases, APIs, search |
| Running build/test/lint commands | External services: GitHub, Jira, Slack |
| Git operations | Complex browser automation |
| One-shot system commands | Stateful multi-step workflows |
| Output is small and predictable | Output needs parsing or filtering |

**Rule of thumb**: CLI tools are token-cheap (short input, short output). MCP tools carry overhead per call (schema, serialization) but provide structured data. If `grep` or `git log` answers the question, don't call an MCP tool.

## File Reading Strategy

- **Glob/Grep first** — find the exact file and line before reading
- **Read with offsets** — `Read(file, offset=100, limit=50)` instead of reading 2000 lines
- **Never cat via Bash** — dedicated Read tool is cheaper and gives line numbers
- **Skip generated files** — node_modules, dist, build, .next, bin, obj are noise

## Search Strategy

- **Grep > Agent** for known patterns (`class FooService`, `TODO`, `import X`)
- **Glob > find** for known file patterns (`**/*.test.ts`, `**/Dockerfile`)
- **Agent (Explore)** only when the search space is genuinely unknown
- **Never grep then read the same content** — grep with context lines (-C) gives you both

## Response Efficiency

- No trailing summaries of what you just did — the diff speaks for itself
- No "Let me explain what I changed" unless asked
- No repeating the user's question back to them
- Status updates at milestones only, not every file edit
- When listing items, use tables or bullets — never prose paragraphs for structured data

## Subagent Token Economy

- Give subagents focused tasks — broad tasks cause expensive exploration
- Include file paths and line numbers in subagent prompts to skip discovery
- Use Sonnet/Haiku for implementation, Opus only for planning and review
- Kill subagents that are stuck — don't let them burn tokens retrying

## Context Window Awareness

- Monitor your remaining context budget on long tasks
- Before context limits are reached, summarize progress and key findings
- If a task is too large for one session, break it into subtasks with clear handoff notes
- Prefer many small focused reads over few large reads — small reads compress better
