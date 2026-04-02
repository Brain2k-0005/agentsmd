# AGENTS.md - C# Project

## Project Overview

A C# application or service, typically using the .NET SDK, modern language features, and the standard dotnet toolchain.

## Commands

```
install:  dotnet restore
dev:      dotnet run
build:    dotnet build
test:     dotnet test
lint:     dotnet format --verify-no-changes
format:   dotnet format
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language    | C# |
| Framework   | ASP.NET Core / project framework |
| Database    | Fill in |
| Auth        | Fill in |
| Hosting     | Fill in |
| Package Mgr | dotnet |

## Code Style

- Prefer nullable reference types and explicit async APIs
- Keep controllers thin and push logic into services
- Use records for DTOs when immutable data transfer is appropriate
- Align namespaces with the folder structure
- Record any solution-specific conventions in the root `AGENTS.md`

## Skills

- Use `find-skills` to discover skills matching your current task before starting
- Recommended: `dotnet-best-practices`, `csharp-xunit`, `csharp-async`
- Install stack-specific skills only when they match the feature area

## Testing

**Run tests:** `dotnet test` (xUnit)

- Unit tests: `tests/UnitTests/`
- Integration tests: `tests/IntegrationTests/`
- E2E tests: only if the repository defines them

## Boundaries

**Never modify:**
- `bin/` and `obj/`
- migration or generated code outputs
- secrets, tokens, or local environment files

**External services:**
- Use test or local endpoints for any networked dependency
