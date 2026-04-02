# AGENTS.md - Ruby Project

## Project Overview

A Ruby application, gem, or service built with Bundler and a conventional Ruby stack.

## Commands

```
install:  bundle install
dev:      bundle exec ruby bin/dev
build:    bundle exec rake build
test:     bundle exec rspec
lint:     bundle exec rubocop
format:   bundle exec rubocop -A
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Ruby |
| Framework   | Rails / Sinatra / project framework |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | Bundler |

## Code Style

- Prefer explicit service objects when business logic grows beyond a model
- Keep controllers thin and views simple
- Use frozen string literals if the project already does
- Prefer conventional Ruby/Rails directory structure
- Put repo-specific conventions in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `bundle exec rspec` (RSpec)

- Unit tests: `spec/`
- Integration tests: request or feature specs when present
- System tests: only if the app uses them

## Boundaries

**Never modify:**
- `vendor/bundle/`
- generated assets
- `.env` or secret files

**External services:**
- Use test credentials only
- Keep mail, storage, and third-party APIs in sandbox mode during development
