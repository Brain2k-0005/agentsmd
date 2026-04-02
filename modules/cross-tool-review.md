# Cross-Tool Review — Dual Control for Higher Quality

## The Idea

When you have access to multiple AI coding tools, use them to review each other's work. Different models catch different mistakes. A change that looks correct to one model may have obvious flaws when reviewed by another.

This is like pair programming — but between AI agents instead of humans.

## When to Use

- After completing a significant feature or refactor
- Before merging to main
- When working on security-sensitive code
- When a single tool's review feels insufficient

## Workflows

### Claude Reviews Codex Output

1. Codex implements the feature (fast, cost-effective)
2. Open the same project in Claude Code
3. Ask Claude to review the changes: "Review the recent changes in this project against the AGENTS.md quality gates"
4. Claude reads the diff, checks against project rules, and flags issues
5. Fix issues in whichever tool you prefer

### Codex Reviews Claude Output

1. Claude implements the feature (thorough, architecture-aware)
2. Open the same project in Codex CLI
3. Ask Codex to review: "Review the uncommitted changes for correctness, security, and code style"
4. Codex provides a second opinion with fresh eyes
5. Iterate until both tools agree the code is solid

### Gemini as Third Reviewer

1. After Claude or Codex implements and the other reviews
2. Use Gemini for a final pass: "Review this diff for anything the previous reviewers might have missed"
3. Gemini's different training brings a third perspective

### Rotating Implementation

For maximum coverage across a project:

```
Feature A: Claude implements → Codex reviews
Feature B: Codex implements → Claude reviews  
Feature C: Gemini implements → Claude reviews
Integration: All three review the merged result
```

## What Each Tool Brings

| Tool | Strength as Implementer | Strength as Reviewer |
|------|------------------------|---------------------|
| Claude Code | Architecture, planning, complex refactors | Deep code review, security analysis, design patterns |
| Codex CLI | Fast implementation, sandbox safety | Fresh perspective, catches over-engineering |
| Gemini CLI | Broad knowledge, documentation | Alternative approaches, edge case detection |

## Setting Up Cross-Tool Review

All three tools read AGENTS.md from the project root. This means:

- They all follow the same project rules
- They all know the same quality gates
- Reviews are consistent because the standard is shared

No extra configuration needed. Just open the same project in a different tool and ask for a review.

## Review Prompt Templates

**For the reviewing tool:**

```
Review the uncommitted changes in this project. Check against the quality gates 
in AGENTS.md: build passes, tests pass, no type errors, no security issues, 
change matches what was requested. Flag anything that looks wrong.
```

**For a security-focused review:**

```
Review the recent changes for security issues: SQL injection, XSS, exposed 
secrets, missing auth checks, path traversal, insecure dependencies. 
Check the OWASP top 10 against this diff.
```

**For an architecture review:**

```
Review whether the recent changes follow the project's architecture as 
described in AGENTS.md. Check layer boundaries, dependency direction, 
and separation of concerns.
```
