# AGENTS.md - .NET Project

## Project Overview

A .NET 9 Web API using Clean Architecture with Entity Framework Core and SQL Server.

## Commands

```
install:  dotnet restore
dev:      dotnet run --project src/Api
build:    dotnet build
test:     dotnet test
lint:     dotnet format --verify-no-changes
format:   dotnet format
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language | C# 13 / .NET 9           |
| Framework| ASP.NET Core Minimal API  |
| ORM      | Entity Framework Core 9   |
| Database | SQL Server               |
| Auth     | ASP.NET Identity + JWT   |
| Hosting  | Azure App Service        |

## Code Style

- Clean Architecture layers: Api -> Application -> Domain -> Infrastructure
- All database access via repository interfaces in Application, implementations in Infrastructure
- Use record types for DTOs and value objects
- Prefer `IResult` return types in endpoint handlers
- No business logic in controllers/endpoints - delegate to Application services
- Use `CancellationToken` on all async methods

## Skills

- API work: `aspnet-minimal-api-openapi`
- Testing: `csharp-xunit`, `csharp-async`
- Data access: `ef-core`
- General .NET guidance: `dotnet-best-practices`
- Keep project-specific skills documented here as the codebase evolves

## Testing

**Run tests:** `dotnet test` (xUnit)

- Unit tests: `tests/UnitTests/` mirroring src structure
- Integration tests: `tests/IntegrationTests/` using WebApplicationFactory
- All public API endpoints must have integration tests
- Use NSubstitute for mocking, FluentAssertions for assertions

## Boundaries

**Never modify:**
- `src/Domain/` entities without updating corresponding migrations
- `Migrations/` - EF migrations are append-only, create new ones instead
- `appsettings.Production.json` - production config managed by CI/CD

**External services:**
- SQL Server - use LocalDB or Docker for local dev
- Azure - never deploy from local machine, CI/CD only
