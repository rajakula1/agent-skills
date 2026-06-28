---
name: ci-repair
description: Bounded, self-contained repair of deterministic CI failures on PR branches with strict circuit breakers, anti-tampering rules, and retry limits.
---

# CI Failure Repair

## Objective
Diagnose and repair reproducible, deterministic failures on an agent's PR branch without human intervention, while preventing infinite loops, test tampering, or scope creep.

---

## When to Use
- Triggered automatically when CI status checks fail on a branch owned by an agent.
- When local verification fails and requires targeted root-cause analysis.

---

## Circuit Breakers & Invariants (Mandatory)

1. **Max 2 Repair Attempts**:
   - The agent is permitted at most **two (2)** repair attempts per PR.
   - If Attempt 2 does not produce a passing CI build, the agent must stop immediately, label the PR `agent-stuck`, post a summary of findings, and request human assistance.

2. **Strict Prohibition on Test Tampering**:
   The repair agent must **NEVER**:
   - Delete failing tests or assertions.
   - Weaken test thresholds (e.g., changing `expect(x).toBe(5)` to `expect(x).toBeDefined()`).
   - Add `@ts-ignore`, `eslint-disable`, or comment out broken tests to make a build pass.
   - Alter CI configuration files (`.github/workflows/*`, `tsconfig.json`, linter configs) to bypass checks.

3. **Diff Budget Constraint**:
   - Fixes must be tightly bounded to the files already modified in the PR.
   - The agent cannot touch more than **15%** of unrelated codebase lines to fix a CI error.

4. **Flakiness / Infrastructure Filter**:
   - Before editing code, inspect the CI failure log for infrastructure issues (timeouts, runner crashes, rate limits, flaky external APIs).
   - If an infrastructure failure or flaky test is detected, **do not touch application code**. Request a workflow rerun or flag the flaky test.

---

## Execution Steps

### 1. Extract and Parse the Failure Log
- Identify the exact command that failed (e.g., `npm run test`, `tsc --noEmit`, `eslint`).
- Extract the specific error code, stack trace, and failing assertion.

### 2. Classify the Failure
- **Type Error**: Incompatible arguments, missing properties, or incorrect return types.
- **Assertion Failure**: Logic bug or regression against expected behavior.
- **Lint/Format Violation**: Code style mismatch.
- **Flake / Infra Error**: Network timeout or runner error (trigger rerun, no code edits).

### 3. Minimal Targeted Fix
- Reproduce the failure locally:
  ```bash
  npm test -- -t "failing test name"
  ```
- Make the smallest possible code modification to resolve the underlying failure.
- Verify locally using the canonical verification command:
  ```bash
  make verify
  ```

### 4. Push & Document
- Commit with message: `fix(ci): address [specific failure description] (attempt X/2)`.
- If this is Attempt 2 and it still fails:
  - Stop.
  - Post comment on PR:
    ```markdown
    ### Autonomous CI Repair Halted
    - **Attempt Count**: 2 / 2
    - **Failing Check**: [Name of check]
    - **Observed Error**: [Stack trace / error message]
    - **Root Cause Hypothesis**: [Agent analysis]
    - **Action**: Escalating to human reviewer.
    ```
