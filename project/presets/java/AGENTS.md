# AGENTS.md - Java Project

## Project Overview

A Java application or service built with Maven or Gradle.

## Commands

```
install:  mvn dependency:go-offline
dev:      mvn spring-boot:run
build:    mvn package
test:     mvn test
lint:     mvn checkstyle:check
format:   mvn spotless:apply
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Java |
| Framework   | Spring Boot or project framework |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | Maven / Gradle |

## Code Style

- Use packages that mirror bounded contexts or modules
- Prefer constructor injection for dependencies
- Keep controllers thin and move business logic into services
- Use immutable data carriers when practical
- Document any framework conventions in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `mvn test` (JUnit)

- Unit tests: `src/test/java/`
- Integration tests: framework-specific test directories or tags
- E2E tests: only if the repository defines them

## Boundaries

**Never modify:**
- `target/`
- generated sources
- production secrets or local environment files

**External services:**
- Use test containers or local emulators where possible
