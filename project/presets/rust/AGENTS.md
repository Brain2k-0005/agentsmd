# AGENTS.md - Rust Project

## Project Overview

A Rust application, library, or CLI using Cargo and the standard Rust ecosystem.

## Commands

```
install:  cargo fetch
dev:      cargo run
build:    cargo build
test:     cargo test
lint:     cargo clippy --all-targets --all-features
format:   cargo fmt
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | Rust |
| Framework   | Standard library or project framework |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | Cargo |

## Code Style

- Prefer ownership and borrowing over cloning unless cloning is deliberate
- Use `Result` and `?` for error propagation
- Keep modules and crates small and explicit
- Avoid unsafe code unless the repo already requires it
- Record async runtime or feature-flag rules in the root `AGENTS.md`

## Skills

- Use `find-skills` for review, testing, and build workflows
- Add Rust-specific skills only when the crate depends on a special framework
- Keep lint and format requirements in sync with Cargo configuration

## Testing

**Run tests:** `cargo test` (cargo test)

- Unit tests: `#[cfg(test)]` in the same module or adjacent test modules
- Integration tests: `tests/`
- Benchmarks or examples: only if the repository uses them

## Boundaries

**Never modify:**
- `target/`
- generated bindings or build artifacts
- secrets, tokens, or local config files

**External services:**
- Use local test fixtures or mocks for networked dependencies
