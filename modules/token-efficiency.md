# Token Efficiency — Minimize Cost, Maximize Autonomy

Long autonomous runs burn tokens fast. Every unnecessary tool call, verbose output, or redundant read shortens your effective runway. Optimize relentlessly.

## Core Principles

1. **Read once, remember** — never re-read a file you already have in context
2. **Targeted reads** — use line ranges or offsets instead of reading entire large files
3. **Batch operations** — combine independent tool calls into a single message
4. **Terse output** — lead with the answer, skip preamble, avoid restating what was asked
5. **Right-size the tool** — use the cheapest tool that gets the job done (see CLI vs MCP below)

## CLI Tools vs MCP Tools — When to Use Which

### The Rule

**CLI tools** = cheap, fast, one-shot operations you control locally.
**MCP tools** = structured access to external services, APIs, and stateful workflows.

### Real-World Examples

**Stripe — MCP vs CLI:**

| Task | Use | Why |
|------|-----|-----|
| Check a customer's subscription status | Stripe MCP | Structured API call, handles auth, returns typed data |
| List recent charges for debugging | Stripe MCP | Paginated API with filters — MCP handles pagination |
| Run `stripe listen` for webhook testing | CLI (Bash) | Long-running process, local-only |
| Install the Stripe SDK | CLI (Bash) | `npm install stripe` — one-shot package install |

**Database — MCP vs CLI:**

| Task | Use | Why |
|------|-----|-----|
| Query user records for debugging | Database MCP (Supabase, PostgreSQL) | Connection pooling, parameterized queries, structured results |
| Run a migration | CLI (Bash) | `dotnet ef database update` or `alembic upgrade head` — one-shot |
| Seed test data | CLI (Bash) | `npm run seed` — scripted, local |
| Explore table schemas | Database MCP | Returns structured metadata, avoids SQL string parsing |

**GitHub — MCP vs CLI:**

| Task | Use | Why |
|------|-----|-----|
| Create a pull request | CLI (`gh pr create`) | Simple, one-shot, well-supported CLI |
| Read PR review comments | GitHub MCP | Structured threads, nested replies, pagination |
| Check CI status | CLI (`gh run view`) | Quick status check |
| Search issues across repos | GitHub MCP | Complex queries with filters and labels |

**Browser — MCP vs CLI:**

| Task | Use | Why |
|------|-----|-----|
| Download a file | CLI (`curl`) | One-shot, no state needed |
| Fill out a multi-step form | Browser MCP | Stateful page interaction, DOM manipulation |
| Take a screenshot for review | Browser MCP | Requires browser context |
| Check if a URL responds | CLI (`curl -I`) | Simple health check |

### Decision Flowchart

```
Is it a local file/git/build operation?
  → YES → Use CLI
  → NO  → Does it need authentication to an external service?
            → YES → Use MCP (it handles auth)
            → NO  → Is the output structured (JSON, tables, nested data)?
                      → YES → Use MCP (structured parsing)
                      → NO  → Use CLI (simpler, cheaper)
```

### Cost Comparison

| | CLI Tool Call | MCP Tool Call |
|---|---|---|
| Tokens per call | ~50-200 (command + short output) | ~200-1000 (schema + request + structured response) |
| Latency | Instant (local) | Network round-trip |
| Auth handling | Manual (env vars, config files) | Automatic (MCP server manages) |
| Best for | Reads, builds, git, file ops | APIs, databases, browsers, external services |

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
- Use fast models for implementation, strongest models only for planning and review
- Kill subagents that are stuck — don't let them burn tokens retrying

## Context Window Awareness

- Monitor your remaining context budget on long tasks
- Before context limits are reached, summarize progress and key findings
- If a task is too large for one session, break it into subtasks with clear handoff notes
- Prefer many small focused reads over few large reads — small reads compress better
