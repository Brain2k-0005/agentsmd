# AGENTS.md - Laravel Project

## Project Overview

A Laravel application or service using PHP, Composer, and the standard Laravel application structure.

## Commands

```
install:  composer install
dev:      php artisan serve
build:    composer dump-autoload -o
test:     vendor/bin/pest
lint:     vendor/bin/pint
format:   vendor/bin/pint
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | PHP |
| Framework   | Laravel |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | Composer |

## Code Style

- Keep controllers thin and move business logic into actions, jobs, or services
- Use Laravel conventions before inventing custom abstractions
- Keep Eloquent usage consistent with the repo's conventions
- Record queue, event, and policy rules in the root `AGENTS.md`

## Skills

- Use `find-skills` for testing, review, and automation workflows
- Prefer Laravel-specific installable skills when the repo depends on common packages
- Use `php-code-review`, `php-testing`, or `laravel-best-practices` if those skills are available
- Keep framework conventions centralized in this preset rather than scattered

## Testing

**Run tests:** `vendor/bin/pest` (Pest)

- Unit tests: `tests/Unit/`
- Feature tests: `tests/Feature/`
- E2E tests: only if the repository defines them

## Boundaries

**Never modify:**
- `vendor/`
- `storage/` runtime artifacts
- secret environment files

**External services:**
- Use sandbox credentials for third-party APIs
