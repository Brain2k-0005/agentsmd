# AGENTS.md - Svelte Project

## Project Overview

A Svelte application, typically built with Vite or SvelteKit and TypeScript.

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
| Framework   | Svelte / SvelteKit |
| State       | Fill in |
| Testing     | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Keep components small and easy to read
- Prefer stores or local component state over extra abstraction
- Use clear file names that match routes or components
- Avoid mixing framework styles from React or Vue
- Record app-specific rules in the root `AGENTS.md`

## Skills

- Use `web-design-guidelines` for UI work when available
- Use `find-skills` before testing, review, and automation workflows
- Add Svelte-specific skills only when the repo standardizes on them

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
- Use sandbox endpoints and mock data for development
