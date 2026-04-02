# AGENTS.md - SolidStart Project

## Project Overview

A SolidStart application using TypeScript, Solid, and the SolidStart routing/data model.

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
| Framework   | SolidStart |
| State       | Fill in |
| Testing     | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Prefer Solid primitives and route-based organization
- Keep server and client concerns separated where SolidStart does that naturally
- Avoid React-style patterns
- Record routing and deployment rules in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

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
