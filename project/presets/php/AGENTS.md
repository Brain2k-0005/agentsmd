# AGENTS.md - PHP Project

## Project Overview

A PHP application or service using Composer and a conventional PHP framework or runtime.

## Commands

```
install:  composer install
dev:      php artisan serve
build:    composer dump-autoload -o
test:     vendor/bin/phpunit
lint:     vendor/bin/phpstan analyse
format:   vendor/bin/pint
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | PHP |
| Framework   | Laravel / Symfony / project framework |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | Composer |

## Code Style

- Keep controllers thin and move logic into services or actions
- Prefer typed properties and return types where the project supports them
- Use framework conventions instead of custom abstractions unless justified
- Document any environment or runtime assumptions in the root `AGENTS.md`

## Skills

- Use `find-skills` for testing, review, deployment, and automation workflows
- Add framework-specific skills only when the repository standardizes on them
- Keep code style and static analysis rules aligned with the repo tools

## Testing

**Run tests:** `vendor/bin/phpunit` (PHPUnit)

- Unit tests: `tests/Unit/`
- Feature tests: `tests/Feature/`
- E2E tests: only if the repository defines them

## Boundaries

**Never modify:**
- `vendor/`
- generated cache or build artifacts
- secret environment files

**External services:**
- Use sandbox credentials and local services for development
