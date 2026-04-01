# Test-Driven Development

## Workflow (Red -> Green -> Refactor)

1. **Red**: Write a failing test that describes the desired behavior
2. **Green**: Write the minimal implementation to make the test pass — nothing more
3. **Refactor**: Clean up code and tests while keeping all tests green
4. Repeat for the next behavior

Never write implementation before the test exists.

## Coverage Requirements

- Every public function or method gets at least one test
- Every meaningful branch (if/else, early return, error path) gets a test
- Edge cases to cover for every function:
  - Empty input (empty string, empty array, zero)
  - Null or undefined input
  - Boundary values (max, min, off-by-one)
  - Error and exception paths
  - Concurrent or repeated calls where applicable

## Running Tests

- Run the full test suite after every change — not just the file you touched
- A passing unit test does not mean integration tests pass; run both
- If a test was already failing before your change, note it and do not mask it

## Test Quality Rules

- Test behavior, not implementation — avoid testing private internals
- One assertion per logical concept (multiple asserts are fine if they describe one behavior)
- Test names must describe what the test verifies, not how
- Do not use `sleep` or time-dependent logic in tests; mock time if needed
- Flaky tests must be fixed or deleted — never ignored

## When Tests Do Not Exist

If you change code that has no tests, write tests for the changed behavior before modifying the code. This establishes a baseline and prevents silent regressions.
