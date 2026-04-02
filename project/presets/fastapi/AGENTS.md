# AGENTS.md - FastAPI Project

## Project Overview

A FastAPI application using Python, Pydantic, and an ASGI-based service layout.

## Commands

```
install:  uv sync
dev:      uv run fastapi dev src/main.py
build:    uv build
test:     uv run pytest
lint:     uv run ruff check .
format:   uv run ruff format .
typecheck: uv run mypy src/
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Python |
| Framework   | FastAPI |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | uv |

## Code Style

- Keep request and response models explicit
- Prefer dependency injection through FastAPI dependencies
- Use async endpoints consistently when the repo is async-first
- Keep routers, services, and repositories separated when the app grows
- Record API and environment rules in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `uv run pytest` (pytest)

- Unit tests: `tests/unit/`
- Integration tests: `tests/integration/`
- E2E tests: only if the repository defines them

## Boundaries

**Never modify:**
- `alembic/versions/` unless the change explicitly requires a new migration
- generated clients or artifacts
- `.env` and secret files

**External services:**
- Use local or sandbox databases and APIs for development
