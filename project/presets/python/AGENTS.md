# AGENTS.md - Python Project

## Project Overview

A Python 3.12 FastAPI application with SQLAlchemy ORM and PostgreSQL.

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
| Language    | Python 3.12            |
| Framework   | FastAPI                |
| ORM         | SQLAlchemy 2.x         |
| Database    | PostgreSQL             |
| Auth        | JWT via python-jose    |
| Hosting     | Docker + Railway/Fly.io |
| Package Mgr | uv                     |

## Code Style

- Type hints on all function signatures - `mypy --strict` must pass
- Use Pydantic v2 models for all request/response schemas
- Dependency injection via FastAPI `Depends()`
- Async endpoints and database sessions throughout
- One module per domain concept in `src/domains/`
- Prefer `pathlib.Path` over string path manipulation

## Skills

- Testing and verification skills should be installed globally
- Add project-specific skills here if the stack grows beyond the base FastAPI workflow
- Use the matching preset before introducing new abstractions

## Testing

**Run tests:** `uv run pytest` (pytest + pytest-asyncio)

- Unit tests: `tests/unit/` mirroring src structure
- Integration tests: `tests/integration/` with test database
- Fixtures in `tests/conftest.py` - shared database session, test client
- All API endpoints must have integration tests

## Boundaries

**Never modify:**
- `alembic/versions/` - migrations are append-only
- `.env` - secrets, never commit
- `src/generated/` - auto-generated OpenAPI client, do not edit

**External services:**
- PostgreSQL - use Docker Compose for local dev
- Redis - use fakeredis in tests
