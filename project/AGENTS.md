# AGENTS.md
<!-- Copy this file to your project root and fill in the placeholders. -->
<!-- This file guides AI coding agents (Claude Code, Codex, Gemini CLI, Copilot, Cursor, etc.) -->

## Project Overview

<!-- Describe what this project does in 1-2 sentences -->

**Preset**
<!-- Use the matching preset from `project/presets/` when possible: generic, nextjs, dotnet, python, nodejs, go, rust, java, ruby, php, c, cpp, csharp, kotlin, swift, react, vue, angular, flutter, svelte, remix, astro, solid, solidstart, nestjs, express, laravel, fastapi, django, bun, deno, vite, tanstack, tauri, elixir, perl, scala, or a project-specific variant. -->

**Key architectural decisions:**
<!-- List any non-obvious decisions agents must respect, e.g.:
- We use optimistic UI updates everywhere - do not add loading spinners to mutations
- All database access goes through the repository layer, never direct ORM calls in routes
-->

---

## Commands

```
install:  # e.g. npm install / pip install -r requirements.txt
dev:      # e.g. npm run dev
build:    # e.g. npm run build
test:     # e.g. npm test
lint:     # e.g. npm run lint
format:   # e.g. npm run format
```

---

## Tech Stack

<!-- List your primary technologies. Agents should verify exact versions by reading package.json, pyproject.toml, go.mod, etc. -->

| Layer       | Technology |
|-------------|------------|
| Language    |            |
| Framework   |            |
| Database    |            |
| Auth        |            |
| Hosting     |            |
| Package Mgr |            |

---

## Code Style

<!-- List conventions not captured by linter configs. Check .editorconfig and linter configs for formatting rules. -->

- Read the matching preset before editing stack-specific code
- Use the repo's existing folder boundaries and naming conventions
- Prefer changes that keep the current architecture intact unless a redesign is requested
- Record any project-specific skill requirements here if the project depends on them

---

## Skills And Workflow

**Skills discovery:**
- Use `find-skills` to discover relevant skills before non-trivial work
- The `superpowers` plugin provides core workflows (planning, debugging, TDD, code review, parallel agents)
- Install stack-specific skills only when they match this project's feature area
- Record useful project-specific skills in this file as the project evolves

**Autonomy rules:**
- Inspect manifests, docs, and recent commits before asking questions
- Prefer the smallest preset that matches the project
- If the stack is unclear, fall back to `project/presets/generic/AGENTS.md`

---

## Testing

**Run tests:** <!-- e.g. npm test / pytest / go test ./... -->

**Conventions:**
- Unit tests: <!-- e.g. co-located with source files as *.test.ts -->
- Integration tests: <!-- e.g. tests/integration/ -->
- E2E tests: <!-- e.g. tests/e2e/ using Playwright -->

**What must be tested:** <!-- e.g. All public API handlers, all auth paths, all data transforms -->

---

## Boundaries

**Never modify:**
- <!-- e.g. db/migrations/ - migrations are append-only -->
- <!-- e.g. .github/workflows/ - CI is managed separately -->
- <!-- e.g. src/generated/ - auto-generated, do not edit by hand -->

**External services requiring caution:**
- <!-- e.g. Stripe - use test keys only; never call live endpoints in dev -->
- <!-- e.g. SendGrid - all email in dev must route to the sandbox account -->

---

## Project-Specific Rules

<!-- Rules here override global agent behavior. Be explicit. -->

- <!-- e.g. Do not install new dependencies without confirming with the user first -->
- <!-- e.g. All SQL queries must be reviewed for injection risk before committing -->
- <!-- e.g. Feature flags live in src/flags.ts - wrap any experimental code in one -->
