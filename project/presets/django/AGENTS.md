# AGENTS.md - Django Project

## Project Overview

A Django application using Python, Django, and the standard Django project layout.

## Commands

```
install:  uv sync
dev:      uv run python manage.py runserver
build:    uv build
test:     uv run python manage.py test
lint:     uv run ruff check .
format:   uv run ruff format .
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Python |
| Framework   | Django |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | uv / pip |

## Code Style

- Keep apps modular and domain-focused
- Prefer Django conventions over custom plumbing
- Use forms, serializers, or services consistently with the repo
- Record admin, migration, and settings rules in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Recommended: `sql-optimization`, `sql-code-review`
- Install stack-specific skills only when they match the feature area

## Testing

**Run tests:** `uv run python manage.py test` (Django test / pytest)

- Unit tests: app-local `tests.py` or `tests/` packages
- Integration tests: project-specific if present
- E2E tests: only if the repository defines them

## Boundaries

**Never modify:**
- `staticfiles/` build outputs
- migrations unless the change explicitly requires one
- `.env` and secret files

**External services:**
- Use local services or test credentials for development
