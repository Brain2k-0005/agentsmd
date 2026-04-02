# AGENTS.md - Elixir Project

## Project Overview

An Elixir application or service built with Mix and the standard BEAM ecosystem.

## Commands

```
install:  mix deps.get
dev:      mix phx.server
build:    mix compile
test:     mix test
lint:     mix format --check-formatted
format:   mix format
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Elixir |
| Framework   | Phoenix / project framework |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | Mix |

## Code Style

- Prefer small modules and explicit function pipelines
- Keep side effects at the edges
- Use pattern matching for clear control flow
- Keep Phoenix contexts and boundaries explicit
- Record project conventions in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `mix test` (ExUnit)

- Unit tests: `test/`
- Integration tests: `test/` or project-specific folders
- E2E tests: only if the repo defines them

## Boundaries

**Never modify:**
- `_build/`
- `deps/`
- generated artifacts or secrets

**External services:**
- Use sandbox credentials and local services for development
