# AGENTS.md - C++ Project

## Project Overview

A C++ application, library, or systems component built with the standard native toolchain.

## Commands

```
install:  cmake -S . -B build
dev:      cmake --build build --target run
build:    cmake --build build
test:     ctest --test-dir build
lint:     clang-tidy
format:   clang-format -i *.cpp *.hpp *.h *.cc *.cxx
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | C++ |
| Framework   | Fill in |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | CMake / Conan / vcpkg |

## Code Style

- Prefer RAII and explicit ownership
- Use modern C++ language features when the project supports them
- Keep headers small and avoid unnecessary coupling
- Make build flags and standard version explicit in the root `AGENTS.md`
- Keep generated code and vendored dependencies isolated

## Skills

- Use `find-skills` for testing, review, and build workflows
- Add C++-specific skills only when the repository standardizes on them
- Keep formatter, sanitizer, and static analysis settings aligned with the project

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
- Use local services or mocks for any networked dependency
