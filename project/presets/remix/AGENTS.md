# AGENTS.md - Remix Project

## Project Overview

A Remix application using React, TypeScript, and the Remix route/data model.

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
| Framework   | Remix |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Keep loaders and actions close to the routes they serve
- Prefer server-first data access and minimize client-only state
- Use React patterns that fit the Remix route model
- Keep shared UI and route logic separated cleanly
- Record route, data, and deployment rules in the root `AGENTS.md`

## Skills

- Use `web-design-guidelines` and React-focused skills for UI work when available
- Use `find-skills` for testing, review, and automation workflows
- Add Remix-specific skills only if the repo standardizes on them

## Testing

**Run tests:** `npm test` (Vitest)

- Unit tests: project-specific `*.test.tsx`
- Integration tests: project-specific if present
- E2E tests: project-specific if present

## Boundaries

**Never modify:**
- build outputs
- generated artifacts
- `.env` and secret files

**External services:**
- Use local emulators and sandbox APIs for development
