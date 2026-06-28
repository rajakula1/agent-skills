---
name: durable-retro
description: Analyzes recurring failures, review comments, and regressions to upgrade durable controls (types, lint rules, tests, CI checks) rather than relying on prompt instructions.
---

# Durable Retrospective

## Objective
Institutionalize learning from bugs, code review feedback, and CI failures by implementing durable, programmatic guardrails instead of relying on fragile prompt instructions.

**Core Axiom**: *"If an error happens twice, strengthen enforcement in types, lint, tests, or CI—not merely another sentence in a prompt."*

---

## When to Use
- After resolving a recurring bug or regression.
- When human reviewers repeatedly flag the same pattern across PRs.
- When CI catches a preventable class of defect.

---

## The Durable Enforcement Ladder

Always upgrade controls at the **lowest possible layer** in the hierarchy:

```text
1. Type System (Compile-Time)       ── Highest Durability, Instant Feedback
      ↓
2. Linter / Static Analysis         ── Catches AST anti-patterns across repo
      ↓
3. Automated Tests (Unit/Integ)     ── Asserts runtime behavior & edge cases
      ↓
4. CI / Pre-commit Guardrail        ── Prevents merge of violating patterns
      ↓
5. Documentation / Agent Prompt     ── Lowest Durability (Advisory only)
```

---

## Execution Steps

### 1. Root Cause Analysis
- Identify the structural reason the defect was allowed to occur:
  - *Did the type system allow `any` or an overly broad union?*
  - *Was a deprecated or dangerous API accessible without warning?*
  - *Was an invariant assumed but never asserted in tests?*

### 2. Select the Durable Control
1. **Type Level**:
   - Make illegal states unrepresentable (e.g., discriminate unions, branded types, `readonly` properties).
2. **Lint Level**:
   - Enable an existing ESLint/Ruff/Clippy rule (e.g., `@typescript-eslint/no-floating-promises`, `no-console`).
   - Write a custom AST lint rule if the pattern is organization-specific.
3. **Test Level**:
   - Add a parameterized test suite covering the entire equivalence class of the bug.
4. **CI Level**:
   - Add architectural boundary check (e.g., dependency-cruiser, forbid imports between modules).

### 3. Isolation Rule (Crucial)
**NEVER commit broad durable rule upgrades into the active feature PR.**
- Upgrading a lint rule or enabling strict types often triggers hundreds of violations across an existing codebase.
- Doing this in a feature PR blocks the feature and creates massive merge conflicts.

**Correct Procedure**:
1. Fix the immediate issue in the current PR using standard tests.
2. Open a **separate, dedicated "Hardening" Issue or Draft PR** containing:
   - The upgraded rule / type definition.
   - The rationale citing the regression.
   - The phased plan or fix for legacy occurrences across the repo.

---

## Output Template

Deliver a retrospective summary:

```markdown
## Durable Retrospective Report

### 1. Incident / Pattern Summary
- **Observed Defect**: [Describe the recurring failure]
- **Root Cause**: [Why existing checks failed to catch it]

### 2. Upgraded Durable Control
- **Control Level**: [Type System | Lint Rule | Test Suite | CI Check]
- **Target File**: [e.g., `tsconfig.json`, `.eslintrc.js`, `contracts/types.ts`]
- **Specific Rule**: [e.g., `no-unsafe-argument: error`]

### 3. Execution Plan
- [x] Immediate fix verified in current PR with regression test.
- [ ] Separate Hardening Issue opened: `#123 - Enforce strict null check on [Module]`.
```
