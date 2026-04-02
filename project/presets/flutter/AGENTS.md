# AGENTS.md - Flutter Project

## Project Overview

A Flutter application using Dart, the Flutter SDK, and a mobile-first app structure.

## Commands

```
install:  flutter pub get
dev:      flutter run
build:    flutter build
test:     flutter test
lint:     flutter analyze
format:   dart format .
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Dart |
| Framework   | Flutter |
| State       | Fill in |
| Testing     | Fill in |
| Hosting     | Fill in |
| Package Mgr | pub |

## Code Style

- Prefer small widgets with explicit composition
- Keep business logic out of widget build methods
- Use immutable models when practical
- Keep platform-specific code isolated
- Record platform and architecture rules in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `flutter test` (flutter_test)

- Unit tests: `test/`
- Widget tests: `test/`
- Integration tests: `integration_test/` if present

## Boundaries

**Never modify:**
- `.dart_tool/`
- build outputs
- generated code unless the repo explicitly owns it

**External services:**
- Use local emulators and sandbox credentials where possible
