# AGENTS.md - Scala Project

## Project Overview

A Scala application, library, or service built with the standard JVM toolchain and a Scala build system.

## Commands

```
install:  sbt update
dev:      sbt run
build:    sbt compile
test:     sbt test
lint:     sbt scalafmtCheck
format:   sbt scalafmtAll
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Scala |
| Framework   | Play / Akka / project framework |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | sbt |

## Code Style

- Prefer case classes and immutable values
- Keep effects at the edges and core logic pure when practical
- Use clear package and module boundaries
- Avoid implicit-heavy designs unless the repo already relies on them
- Record repo-specific conventions in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `sbt test` (ScalaTest / MUnit)

- Unit tests: `src/test/scala/`
- Integration tests: `src/it/scala/` if present
- E2E tests: only if the repo defines them

## Boundaries

**Never modify:**
- `target/`
- generated artifacts
- secrets or environment files

**External services:**
- Use sandbox credentials or local containers for development
