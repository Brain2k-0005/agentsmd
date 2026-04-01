# Quality Gates — Checklist Before Claiming Done

Run through every gate before reporting a task as complete. If any gate fails, fix it first.

## Gates

**1. Build**
- Code compiles or parses without errors
- No missing imports, unresolved references, or syntax errors
- Command: `npm run build`, `tsc --noEmit`, `cargo build`, `dotnet build`, etc.

**2. Tests**
- All existing tests pass — not just tests in the files you changed
- New functionality has at least one new test
- No tests were deleted or skipped to make the suite pass
- Command: `npm test`, `pytest`, `dotnet test`, `cargo test`, etc.

**3. Lint and Formatting**
- Linter reports no errors (warnings are acceptable if pre-existing)
- Formatter has been run and output is clean
- Command: `eslint`, `ruff`, `golangci-lint`, `dotnet format`, etc.

**4. Types**
- No type errors, no implicit `any`, no unsafe casts introduced
- Command: `tsc --noEmit` or equivalent strict type check

**5. Security**
- No secrets, tokens, or credentials in committed code
- No unsanitized input passed to SQL, shell, or eval
- No new dependencies with known critical vulnerabilities

**6. Scope**
- Change does exactly what was requested — no more, no less
- No unrelated files modified as a side effect
- No debug code, console logs, or temporary hacks left in

**7. Git Hygiene**
- `git status` is clean — no untracked generated files
- No `.env`, credential files, or build artifacts staged

## Failure Policy

If any gate fails: stop, fix the issue, re-run the full checklist from the top. Do not report partial completion as done.
