# AGENTS.md - C Project

## Project Overview

A C application, library, or systems component built with the standard native toolchain.

## Commands

```
install:  cmake -S . -B build
dev:      cmake --build build --target run
build:    cmake --build build
test:     ctest --test-dir build
lint:     clang-tidy
format:   clang-format -i *.c *.h
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | C |
| Framework   | Fill in |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | CMake / Make |

## Code Style

- Prefer explicit memory ownership and cleanup
- Keep header files minimal and focused
- Use small functions with clear responsibilities
- Avoid hidden globals unless the project already depends on them
- Record build-system rules in the root `AGENTS.md`

## Skills

- Use `find-skills` for testing, review, and build workflows
- Add C-specific skills only when the repository adopts extra tooling
- Keep compiler and formatter settings aligned with the project

## Testing

**Run tests:** `ctest --test-dir build` (CTest)

- Unit tests: project-specific test folders or files
- Integration tests: project-specific if present
- E2E tests: only if the repo defines them

## Boundaries

**Never modify:**
- `build/`
- generated headers or artifacts
- secrets or environment files

**External services:**
- Use local test doubles or sandbox endpoints for development
