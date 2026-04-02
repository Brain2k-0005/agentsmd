# AGENTS.md - Astro Project

## Project Overview

An Astro application using the Astro framework, TypeScript, and component islands where needed.

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
| Framework   | Astro |
| State       | Fill in |
| Testing     | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Prefer static content first and add islands only where needed
- Keep client-side frameworks isolated to the components that need them
- Use layout and component boundaries consistently
- Avoid turning simple pages into over-engineered React apps
- Record site and content rules in the root `AGENTS.md`

## Skills

- Use `web-design-guidelines` for UI and layout work when available
- Use `find-skills` for testing, review, and automation workflows
- Add Astro-specific skills only if the repository standardizes on them

## Testing

**Run tests:** `npm test` (Vitest)

- Unit tests: project-specific `*.test.ts`
- Integration tests: project-specific if present
- E2E tests: project-specific if present

## Boundaries

**Never modify:**
- build outputs such as `dist/`
- generated artifacts
- `.env` and secret files

**External services:**
- Use local or sandbox endpoints for any networked dependency
