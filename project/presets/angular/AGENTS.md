# AGENTS.md - Angular Project

## Project Overview

A modern Angular application using the Angular CLI, standalone components, and TypeScript.

## Commands

```
install:  npm install
dev:      npm start
build:    npm run build
test:     npm test
lint:     npm run lint
format:   npx prettier --write .
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | TypeScript |
| Framework   | Angular |
| State       | Fill in |
| Testing     | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Prefer standalone components and modern Angular APIs
- Keep templates declarative and move logic into services or signals
- Use feature folders and clear route boundaries
- Keep RxJS usage intentional and minimal
- Record Angular-specific conventions in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `npm test` (Karma / Jest)

- Unit tests: `*.spec.ts`
- Integration tests: project-specific if present
- E2E tests: `e2e/` or project-specific if present

## Boundaries

**Never modify:**
- `dist/`
- generated Angular artifacts
- `.env` and secret files

**External services:**
- Use local or sandbox endpoints for backend dependencies
