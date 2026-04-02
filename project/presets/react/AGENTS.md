# AGENTS.md - React Project

## Project Overview

A React application, typically TypeScript-based, with a component-driven frontend workflow.

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
| Framework   | React |
| State       | Fill in |
| Testing     | Fill in |
| Hosting     | Fill in |
| Package Mgr | npm / pnpm / yarn |

## Code Style

- Prefer function components and hooks
- Keep component props minimal and explicit
- Co-locate component tests with the component when practical
- Avoid premature abstraction in UI code
- Record design-system and folder rules in the root `AGENTS.md`

## Skills

- Use `web-design-guidelines`, `vercel-react-best-practices`, `vercel-composition-patterns`, and `shadcn` for UI work when available
- Use `find-skills` before testing, review, and automation work
- Add React-specific skills only if the repository standardizes on them

## Testing

**Run tests:** `npm test` (Vitest / Jest)

- Unit tests: `*.test.tsx` or `*.spec.tsx`
- Integration tests: `tests/integration/` if present
- E2E tests: `tests/e2e/` if present

## Boundaries

**Never modify:**
- build outputs such as `dist/` or `build/`
- generated assets
- `.env` and secret files

**External services:**
- Use local mocks or sandbox APIs for development
