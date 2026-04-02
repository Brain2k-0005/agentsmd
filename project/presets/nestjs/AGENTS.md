# AGENTS.md - NestJS Project

## Project Overview

A NestJS backend built with TypeScript, Node.js, and the Nest application structure.

## Commands

```
install:  npm install
dev:      npm run start:dev
build:    npm run build
test:     npm test
lint:     npm run lint
format:   npx prettier --write .
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | TypeScript |
| Framework   | NestJS |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Use modules, controllers, providers, and services the Nest way
- Keep dependency injection explicit
- Move validation and transformation into DTOs and pipes
- Keep adapters and integrations isolated from business logic
- Record architecture and layering rules in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `npm test` (Jest)

- Unit tests: `*.spec.ts`
- Integration tests: `test/` or project-specific folders
- E2E tests: `test/e2e/` if present

## Boundaries

**Never modify:**
- `dist/`
- generated clients or artifacts
- `.env` and secret files

**External services:**
- Use sandbox services or local emulators during development
