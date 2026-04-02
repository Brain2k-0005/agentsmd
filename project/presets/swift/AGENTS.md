# AGENTS.md - Swift Project

## Project Overview

A Swift application, package, or app target using Swift Package Manager or Xcode.

## Commands

```
install:  swift package resolve
dev:      swift run
build:    swift build
test:     swift test
lint:     swiftlint
format:   swiftformat .
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Swift |
| Framework   | SwiftUI / Foundation / project framework |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | SwiftPM |

## Code Style

- Prefer value types and explicit protocol boundaries
- Keep view logic and business logic separate
- Use async/await for concurrency when available
- Align target and module names with folders
- Document platform-specific rules in the root `AGENTS.md`

## Skills

- Use `find-skills` for testing, review, and automation workflows
- Add Swift-specific skills only if the repository adopts extra tooling
- Keep this preset aligned with the repo's actual package manager and formatter

## Testing

**Run tests:** `swift test` (XCTest)

- Unit tests: `Tests/`
- UI tests: project-specific if present
- Integration tests: only if the repository defines them

## Boundaries

**Never modify:**
- `.build/`
- derived data or generated Xcode artifacts
- secrets or local configuration files

**External services:**
- Use sandbox endpoints and test credentials only
