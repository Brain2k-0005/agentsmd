# Code Review — Automated Review Checklist

## When to Run

Run a review pass on every significant change before claiming the task is done. "Significant" means any logic change, new feature, refactor, or dependency addition.

## Review Dimensions

**Correctness**
- Does the code do what the plan or ticket requires?
- Are there off-by-one errors, incorrect conditionals, or wrong return values?
- Are error paths handled — not just the happy path?

**Security (OWASP Top 10 focus)**
- No unsanitized user input passed to SQL, shell, or eval
- No secrets, tokens, or credentials hardcoded or logged
- Authentication and authorization checked before data access
- No path traversal or unsafe file operations
- Dependencies are not known-vulnerable versions

**Performance**
- No N+1 query patterns introduced
- No unbounded loops over large data sets
- No synchronous blocking in async contexts
- Caching not invalidated unnecessarily

**Type Safety and Compilation**
- Code compiles or parses without errors
- No implicit `any` types or type assertions masking real issues
- All imports resolve correctly

**Code Quality**
- No dead code or unused imports left behind
- No copy-pasted blocks that should be extracted into a function
- Variable and function names are clear and consistent with the codebase
- No commented-out code committed

**Side Effects**
- Change does not break unrelated functionality
- No unexpected mutations to shared state
- Database migrations are reversible or backward-compatible

## Output Format

Report findings as: `[SEVERITY] file:line — description`. Severity levels: BLOCKER, WARNING, NOTE. Fix all BLOCKERs before marking done.
