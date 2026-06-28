---
name: plan-change
description: Produces a compact, testable implementation plan with explicit acceptance criteria, non-goals, risk assessment, and verification commands.
---

# Plan Change

## Objective
Formulate a minimal, disciplined implementation plan before touching code. Establish clear acceptance criteria, explicit boundaries on what NOT to change, and define the exact verification commands that must pass.

---

## When to Use
- Immediately following `understand-and-scope`.
- Before making any multi-file change, non-trivial feature, or architectural refactor.

---

## Planning Principles
1. **Small Steps**: Break the implementation into small, testable, atomic increments.
2. **Explicit Non-Goals**: Prevent architectural drift and scope creep by stating what will *not* be modified or refactored.
3. **Test-First Mindset**: Define the exact tests that will prove correctness before touching implementation.
4. **Minimal Surface Area**: Prefer simple, readable solutions over unnecessary abstractions or speculative generalizations.

---

## Execution Steps

### 1. Define Acceptance Criteria
Formulate concrete, binary conditions that determine whether the task succeeded.
- Use explicit Given-When-Then or clear bulleted checklists.
- Cover both normal operational paths and critical edge/error cases.

### 2. Specify Non-Goals
Explicitly list what is out of scope for this change:
- Unrelated refactorings or style cleanups.
- Premature performance optimizations.
- Future-proofing abstractions or generic interfaces not required right now.

### 3. Sequence the Implementation Steps
Order steps logically to support incremental verification:
1. **Contracts & Interfaces**: Types, schemas, or API definitions.
2. **Test Cases**: Acceptance tests or reproduction tests.
3. **Core Logic**: Smallest implementation to satisfy tests.
4. **Verification**: Run project-level checks (`make verify` or `npm run verify`).

### 4. Risk Assessment & Rollback
- Identify potential points of failure (breaking existing consumers, database migration risks, external dependency failures).
- Define how the change can be safely rolled back if issues emerge.

---

## Deliverable / Output Template

Produce an implementation plan matching this format:

```markdown
## Implementation Plan: [Task Title]

### 1. Goal & Acceptance Criteria
- [ ] Criterion 1: [Specific, testable behavior]
- [ ] Criterion 2: [Error handling behavior]
- [ ] Criterion 3: [Edge case requirement]

### 2. Explicit Non-Goals
- We will NOT touch [unrelated modules or files].
- We will NOT introduce [unnecessary patterns or generic wrappers].
- We will NOT alter [existing working behaviors/contracts].

### 3. Step-by-Step Implementation Sequence
1. **Step 1: Test Scaffold / Reproduction**
   - File: `path/to/test.ts`
   - Action: Add failing test case for [X].
2. **Step 2: Core Implementation**
   - File: `path/to/module.ts`
   - Action: Implement minimal logic to pass test.
3. **Step 3: Verification & Integration**
   - Action: Run project-wide verify command.

### 4. Verification Command
- Command: `make verify` (or `npm run verify`)

### 5. Risk & Rollback
- **Risk Level**: [Low | Medium | High]
- **Rollback Strategy**: [Revert commit / flag toggle]
```
