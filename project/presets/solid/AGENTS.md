# AGENTS.md - Solid Project

## Project Overview

A Solid application, typically with TypeScript and a Vite-based toolchain.

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
| Language    | TypeScript / JavaScript |
| Framework   | Solid / SolidStart |
| State       | Fill in |
| Testing     | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Keep components small and reactive
- Prefer signals and stores that match the project style
- Avoid mixing React-style patterns into Solid components
- Use route- and feature-based folders when the project grows
- Record app-specific rules in the root `AGENTS.md`

## Skills

- Use `web-design-guidelines` for UI work when available
- Use `find-skills` for testing, review, and automation workflows
- Add Solid-specific skills only if the repo standardizes on them

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
