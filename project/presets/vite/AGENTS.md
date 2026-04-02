# AGENTS.md - Vite Project

## Project Overview

A Vite-based frontend application or app shell using TypeScript or JavaScript.

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
| Framework   | Vite |
| State       | Fill in |
| Testing     | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Keep framework-specific logic close to the UI layer it belongs to
- Prefer simple Vite conventions over custom build wrappers
- Use the package manager already encoded in the repo
- Record app-specific rules in the root `AGENTS.md`

## Skills

- Use `web-design-guidelines` for UI work when available
- Use `vercel-react-best-practices`, `vercel-composition-patterns`, or framework-specific skills when relevant
- Use `find-skills` for testing, review, and automation workflows

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
