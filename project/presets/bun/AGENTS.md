# AGENTS.md - Bun Project

## Project Overview

A Bun-based JavaScript or TypeScript project using the Bun runtime, package manager, and test runner.

## Commands

```
install:  bun install
dev:      bun run dev
build:    bun run build
test:     bun test
lint:     bunx eslint .
format:   bunx prettier --write .
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | TypeScript / JavaScript |
| Runtime     | Bun |
| Framework   | Fill in |
| Testing     | Bun test or project runner |
| Hosting     | Fill in |
| Package Mgr | Bun |

## Code Style

- Prefer Bun-native tooling when the repo has standardized on it
- Keep runtime-specific scripts in `package.json`
- Avoid mixing Bun and Node package-manager conventions unless the repo already does
- Record deployment and runtime rules in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `bun test` (Bun test)

- Unit tests: project-specific `*.test.ts` or `*.test.tsx`
- Integration tests: project-specific if present
- E2E tests: project-specific if present

## Boundaries

**Never modify:**
- `node_modules/`
- build outputs
- `.env` and secret files

**External services:**
- Use sandbox endpoints and test credentials only
