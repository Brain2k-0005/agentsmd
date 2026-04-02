# AGENTS.md - Express Project

## Project Overview

A Node.js API or web service built with Express and conventional JavaScript or TypeScript.

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
| Framework   | Express |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Keep route handlers thin and delegate logic to services
- Prefer middleware for cross-cutting concerns
- Keep request validation explicit and centralized
- Avoid framework-specific abstractions that hide the HTTP layer
- Record project-specific routing rules in the root `AGENTS.md`

## Skills

- Use `find-skills` for testing, review, and automation workflows
- Add API documentation or security skills when the repo needs them
- Use `nodejs-best-practices` and `typescript-best-practices` if the repo is TypeScript-first
- Keep Express conventions and folder structure in this preset

## Testing

**Run tests:** `npm test` (Jest / Mocha)

- Unit tests: `*.test.ts` or `*.spec.ts`
- Integration tests: `tests/integration/` if present
- E2E tests: project-specific if present

## Boundaries

**Never modify:**
- `node_modules/`
- build outputs
- `.env` and secret files

**External services:**
- Use local or sandbox endpoints during development
