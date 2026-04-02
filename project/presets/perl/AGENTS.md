# AGENTS.md - Perl Project

## Project Overview

A Perl application, library, or script-based project using the standard Perl toolchain.

## Commands

```
install:  cpanm --installdeps .
dev:      perl script/dev.pl
build:    prove -l
test:     prove -l
lint:     perl -c
format:   perltidy -b
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Perl |
| Framework   | Fill in |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | cpanm / cpan |

## Code Style

- Prefer strict and warnings in every script and module
- Keep modules small and explicit
- Use clear package boundaries and naming
- Avoid excessive global state
- Record repo-specific conventions in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `prove -l` (Test::More)

- Unit tests: `t/`
- Integration tests: project-specific if present
- E2E tests: only if the repo defines them

## Boundaries

**Never modify:**
- `blib/`
- build outputs
- generated artifacts or secrets

**External services:**
- Use test credentials and local mocks for development
