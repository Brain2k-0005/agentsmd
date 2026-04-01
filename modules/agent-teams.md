# Agent Teams — Multi-Agent Coordination

## When to Use

Use agent teams when a task involves 3+ independent files or areas that can be worked on in parallel without shared state conflicts.

## Roles

**Lead agent** (strongest model: Opus, o3, etc.)
- Writes the plan and breaks work into self-contained tasks
- Dispatches worker agents with full context
- Reviews and integrates all worker output
- Makes final architectural decisions

**Worker agents** (fast models: Sonnet, codex-mini, etc.)
- Each receives one focused, self-contained task
- Implement without needing to ask the lead for clarification
- Return their output for the lead to integrate

**Reviewer agent** (strong model)
- Validates the integrated result against the original plan
- Checks for gaps, regressions, and inconsistencies
- Approves or flags issues before the task is marked done

## Workflow

```
Plan -> Dispatch -> Implement (parallel) -> Integrate -> Review -> Done
```

1. Lead writes a plan listing every task and its inputs/outputs
2. Each worker gets: task description, relevant file paths, expected output, constraints
3. Workers run in parallel — no cross-agent dependencies during implementation
4. Lead integrates all output, resolving conflicts
5. Reviewer validates against plan requirements

## Rules

- Every agent gets complete context — no implicit knowledge, no "you know the codebase"
- Workers must not assume other workers have finished; treat shared files as read-only
- If a worker hits a blocker, it reports back rather than guessing
- The lead never delegates integration — it always owns the final merge
