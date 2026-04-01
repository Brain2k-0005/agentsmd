# AGENTS.md — Next.js Project

## Project Overview

A Next.js 15 web application using the App Router, TypeScript, and Tailwind CSS.

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

| Layer      | Technology               |
|------------|--------------------------|
| Language   | TypeScript 5.x           |
| Framework  | Next.js 15 (App Router)  |
| Styling    | Tailwind CSS 4           |
| Database   | Supabase (PostgreSQL)    |
| Auth       | Supabase Auth            |
| Hosting    | Vercel                   |

## Code Style

- Use Server Components by default; add "use client" only when needed
- Named exports only — no default exports except page.tsx and layout.tsx
- Co-locate components with their page: `app/(routes)/feature/components/`
- Use `cn()` utility for conditional class merging (tailwind-merge + clsx)
- Prefer Server Actions over API routes for mutations

## Testing

**Run tests:** `npm test` (Vitest) / `npx playwright test` (E2E)

- Unit tests: co-located as `*.test.ts` next to source files
- E2E tests: `tests/e2e/` using Playwright
- All API handlers and auth paths must have tests

## Boundaries

**Never modify:**
- `supabase/migrations/` — migrations are append-only
- `public/` — static assets managed separately
- `.env.local` — contains secrets, never commit

**External services:**
- Supabase — use local dev instance for testing, never hit production
- Stripe — test keys only in development
