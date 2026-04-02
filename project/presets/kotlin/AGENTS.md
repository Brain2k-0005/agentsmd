# AGENTS.md - Kotlin Project

## Project Overview

A Kotlin application, service, or multiplatform project using the Kotlin toolchain and a conventional JVM or Android stack.

## Commands

```
install:  ./gradlew dependencies
dev:      ./gradlew run
build:    ./gradlew build
test:     ./gradlew test
lint:     ./gradlew ktlintCheck
format:   ./gradlew ktlintFormat
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Kotlin |
| Framework   | Spring Boot / Android / project framework |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | Gradle |

## Code Style

- Prefer immutable vals and data classes
- Keep coroutine boundaries explicit
- Use package structure that mirrors modules or features
- Avoid overusing extension functions when plain functions are clearer
- Document platform-specific rules in the root `AGENTS.md`

## Skills

- Use `find-skills` for testing, review, and build workflows
- Add Kotlin-specific skills when the repo standardizes on a framework
- Keep formatter and lint configuration in sync with this preset

## Testing

**Run tests:** `./gradlew test` (JUnit / Kotest)

- Unit tests: `src/test/`
- Integration tests: `src/integrationTest/` or project-specific folders
- Android tests: only if the repo uses them

## Boundaries

**Never modify:**
- `.gradle/`
- build outputs such as `build/`
- generated sources or secrets

**External services:**
- Use test containers or local mocks for backend dependencies
