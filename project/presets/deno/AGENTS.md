# AGENTS.md - Deno Project

## Project Overview

A Deno application, script, or service using `deno.json` or `deno.jsonc`.

## Commands

```
install:  deno cache
dev:      deno task dev
build:    deno task build
test:     deno test
lint:     deno lint
format:   deno fmt
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | TypeScript / JavaScript |
| Runtime     | Deno |
| Framework   | Fill in |
| Testing     | Deno test |
| Hosting     | Fill in |
| Package Mgr | Deno |

## Code Style

- Prefer standard library and Deno-first APIs
- Keep permissions explicit and minimal
- Use `deno task` for repo-defined workflows
- Avoid Node-specific patterns unless the repo intentionally uses them
- Record runtime and permission rules in the root `AGENTS.md`

## Skills

- Use `find-skills` for testing, review, and automation workflows
- Use `typescript-best-practices` or Deno-specific skills if available
- Keep the preset aligned with the repo's task definitions

## Testing

**Run tests:** `deno test` (Deno test)

- Unit tests: `*_test.ts` or `*.test.ts`
- Integration tests: project-specific if present
- E2E tests: project-specific if present

## Boundaries

**Never modify:**
- generated output
- `.env` and secret files
- lockfiles unless dependency changes are requested

**External services:**
- Use sandbox endpoints and explicit permission flags
