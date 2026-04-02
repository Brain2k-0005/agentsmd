# AGENTS.md - Node.js Project

## Project Overview

A Node.js application or service, typically using TypeScript, npm/pnpm, and a conventional package manifest.

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
| Framework   | Node.js service or app |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Prefer explicit async boundaries and avoid callback-style APIs unless required
- Keep server code and client code in separate folders when both exist
- Use one top-level module per domain feature
- Prefer ESM unless the project already uses CommonJS
- Document any runtime-specific rules in the root `AGENTS.md`

## Skills

- Install project skills for the relevant framework or runtime only when needed
- Use `find-skills` for debugging, testing, review, and automation workflows
- Keep stack-specific conventions in this preset instead of spreading them across files

## Testing

**Run tests:** `npm test` (project test runner)

- Unit tests: `*.test.ts` or `*.spec.ts`
- Integration tests: `tests/integration/`
- E2E tests: `tests/e2e/`

## Boundaries

**Never modify:**
- `node_modules/`
- build outputs such as `dist/` or `.next/`
- `.env` files or checked-in secrets

**External services:**
- Use local or sandbox endpoints for any hosted API
- Never commit credentials into config files
