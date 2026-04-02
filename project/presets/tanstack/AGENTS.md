# AGENTS.md - TanStack Project

## Project Overview

A TanStack-based application using TanStack Start, TanStack Router, or related TanStack packages.

## Commands

```
install:  npm install
dev:      npm run dev
build:    npm run build
test:     npm test
lint:     npm run lint
format:   npx prettier --write .
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | TypeScript |
| Framework   | TanStack Start / Router |
| State       | Fill in |
| Testing     | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Keep routing, data loading, and server boundaries explicit
- Prefer TanStack conventions over custom wrappers
- Keep query and route configuration close to the feature that uses it
- Record app and deployment rules in the root `AGENTS.md`

## Skills

- Use `web-design-guidelines` for UI work when available
- Use `find-skills` for testing, review, and automation workflows
- Add TanStack-specific skills only if the repository standardizes on them

## Testing

**Run tests:** `npm test` (Vitest)

- Unit tests: project-specific `*.test.ts`
- Integration tests: project-specific if present
- E2E tests: project-specific if present

## Boundaries

**Never modify:**
- build outputs
- generated artifacts
- `.env` and secret files

**External services:**
- Use sandbox endpoints and local mocks during development
