# AGENTS.md - Vue Project

## Project Overview

A Vue application, typically using TypeScript, component SFCs, and a modern Vite-based workflow.

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
| Framework   | Vue |
| State       | Fill in |
| Testing     | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Prefer `<script setup>` for new single-file components
- Keep template logic simple and extracted into composables when needed
- Use component props and emits explicitly
- Avoid mixing framework-specific patterns across components
- Record design-system and folder rules in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Recommended: `web-design-guidelines`, `shadcn`
- Install stack-specific skills only when they match the feature area

## Testing

**Run tests:** `npm test` (Vitest)

- Unit tests: `*.test.ts` or `*.spec.ts`
- Integration tests: project-specific if present
- E2E tests: project-specific if present

## Boundaries

**Never modify:**
- build outputs such as `dist/`
- generated artifacts
- `.env` and secret files

**External services:**
- Use sandbox or mock endpoints for local development
