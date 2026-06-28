---
name: execute-verified-change
description: Executes code changes following strict test-driven development (TDD), writing failing tests first, implementing minimal code, and running local verification before committing.
---

# Execute Verified Change

## Objective
Implement code changes strictly according to the agreed plan using Test-Driven Development (TDD), minimal increments, and local verification.

---

## When to Use
- After `plan-change` has been reviewed and agreed upon.
- For all bug fixes, features, and code refactorings.

---

## Core Execution Rules

### 1. Test-First Execution (Mandatory)
Never write production implementation code without a test:
- **If fixing a Bug / Regression**:
  1. Write the minimal failing test that reproduces the exact reported issue.
  2. Run the test and verify that it **fails with the expected error or assertion**.
  3. Capture the failure message as evidence before making any fix.
- **If implementing a Feature / Enhancement**:
  1. Define types/interfaces.
  2. Write acceptance unit/integration tests that assert the expected behavior.
  3. Verify the tests fail or cannot compile before writing the implementation.

### 2. Make the Smallest Correct Change
- Write only enough code to make the failing test pass.
- **Do not over-engineer**: Avoid speculative helpers, premature abstractions, or extra parameters not required by the acceptance criteria.
- **Do not rewrite working code**: Respect existing conventions and preserve unrelated docstrings, comments, and logic.

### 3. Run the Canonical Verification Pipeline
Before considering any step complete, run the project's single source-of-truth verification command:
```bash
# Example canonical command (repo-specific):
make verify
# or
pnpm run verify
```
This command must enforce:
1. Code formatting & linting
2. Type checking
3. Unit & integration tests
4. Build verification

If any check fails, fix the failure immediately before committing.

### 4. Small, Atomic Commits
- Commit progress in small, logical chunks with clear commit messages.
- Commit messages should describe *why* the change was made, not just *what* changed.
- Never bundle unrelated changes (e.g., formatting an entire file while fixing a one-line bug).

---

## Verification Checklist

Before declaring the implementation phase complete, verify:
- [ ] Failing test was created and failed first (TDD proof).
- [ ] Production code was written to satisfy only the required behavior.
- [ ] No unrelated files or working functions were modified.
- [ ] Canonical verification command (`make verify` / `npm run verify`) exited with code `0`.
- [ ] Changes are cleanly committed to a dedicated feature/fix branch.
