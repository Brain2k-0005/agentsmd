# AGENTS.md - Tauri Project

## Project Overview

A Tauri desktop application with a Rust backend and a web frontend.

## Commands

```
install:  npm install && cargo fetch
dev:      npm run tauri dev
build:    npm run tauri build
test:     cargo test
lint:     cargo clippy --all-targets --all-features
format:   cargo fmt
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Rust + TypeScript / JavaScript |
| Framework   | Tauri |
| Frontend    | Fill in |
| Testing     | cargo test + frontend tests |
| Hosting     | Desktop app |
| Package Mgr | Cargo + npm / pnpm / yarn |

## Code Style

- Keep Rust and frontend boundaries explicit
- Use Tauri commands only where a desktop bridge is needed
- Avoid leaking platform-specific logic into shared UI code
- Record permission and window rules in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Install stack-specific skills only when they match the feature area
- Keep skill dependencies documented in the project root AGENTS.md

## Testing

**Run tests:** `cargo test` (cargo test)

- Rust unit tests: `src/` and `tests/`
- Frontend tests: project-specific if present
- Integration tests: project-specific if present

## Boundaries

**Never modify:**
- `src-tauri/target/`
- generated assets
- `.env` and secret files

**External services:**
- Use sandbox APIs and local mock services during development
