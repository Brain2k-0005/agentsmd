# AGENTS.md - Next.js Project

## Project Overview

A Next.js 16 web application using the App Router, TypeScript, and Tailwind CSS.

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
| Language | TypeScript 6.x        |
| Framework| Next.js 16 (App Router) |
| Styling  | Tailwind CSS 4        |
| Database | Supabase (PostgreSQL) |
| Auth     | Supabase Auth         |
| Hosting  | Vercel                |

## Code Style

- Use Server Components by default; add "use client" only when needed
- Named exports only - no default exports except `page.tsx` and `layout.tsx`
- Co-locate route-specific components with their page
- Use `cn()` for conditional class merging
- Prefer Server Actions over API routes for mutations

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Recommended: `nextjs-developer`, `vercel-react-best-practices`, `vercel-composition-patterns`, `shadcn`, `web-design-guidelines`
- Install stack-specific skills only when they match the feature area

## Testing

**Run tests:** `npm test` (Vitest)

- Unit tests: co-located as `*.test.ts` next to source files
- E2E tests: `tests/e2e/` using Playwright
- All API handlers and auth paths must have tests

## Boundaries

**Never modify:**
- `supabase/migrations/` - migrations are append-only
- `public/` - static assets managed separately
- `.env.local` - contains secrets, never commit

**External services:**
- Supabase - use local dev instance for testing, never hit production
- Stripe - test keys only in development
