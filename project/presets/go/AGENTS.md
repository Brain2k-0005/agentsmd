# AGENTS.md - Go Project

## Project Overview

A Go application, service, or CLI built around standard Go modules and the Go toolchain.

## Commands

```
install:  go mod download
dev:      go run ./...
build:    go build ./...
test:     go test ./...
lint:     golangci-lint run
format:   gofmt -w .
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Go |
| Framework   | Standard library or project framework |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | Go modules |

## Code Style

- Keep packages small and focused
- Export only what is needed by other packages
- Prefer simple error handling over abstraction-heavy wrappers
- Use context-aware APIs for network and database work
- Document concurrency or goroutine ownership rules in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `go test ./...` (go test)

- Unit tests: `_test.go` files beside the source package
- Integration tests: package-specific directories or tagged tests
- E2E tests: project-specific if present

## Boundaries

**Never modify:**
- `vendor/` unless the repo intentionally vendors dependencies
- generated code directories
- secret files or local environment files

**External services:**
- Use local test doubles or containers for databases and queues
