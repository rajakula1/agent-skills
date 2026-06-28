---
name: review-diff
description: Performs an adversarial, clean-context review of code diffs for correctness, edge cases, security, test quality, and anti-AI-slop hygiene before PR creation.
---

# Review Diff

## Objective
Critically and adversarially review the full Git diff against repository standards, security requirements, and acceptance criteria. Act as a demanding peer reviewer before any Pull Request is opened.

---

## When to Use
- After `execute-verified-change` passes local verification.
- Before opening a PR or merging code into protected branches.
- Whenever reviewing changes from an autonomous subagent.

---

## Review Hierarchy

Always evaluate in this strict order:

```text
1. Correctness & Logic
      ↓
2. Security & Data Protection
      ↓
3. Edge Cases & Concurrency
      ↓
4. Test Quality & Assertions
      ↓
5. "Anti-AI-Slop" Hygiene
      ↓
6. Style & Conventions
```

---

## Review Inspection Checklist

### 1. Correctness & Logic
- Does the diff fulfill all acceptance criteria from the original plan?
- Does it introduce unintended side effects in callers or consumers?
- Are error paths and fallback logic properly handled?

### 2. Security & Data Protection
- **Injection Risks**: Any unescaped SQL, command injection, or unsanitized user inputs?
- **Auth & Access**: Are permissions, roles, and authentication checks enforced?
- **Secrets & PHI/PII**: Are secrets, tokens, or unmasked sensitive data leaked in code or log messages?

### 3. Edge Cases & Concurrency
- Boundary values: `0`, `-1`, `MAX_INT`, empty lists, `null`, `undefined`, NaN.
- Concurrency: Race conditions, re-entrancy, unhandled promise rejections, deadlock potentials.
- Resource cleanup: Are database connections, sockets, streams, or timers reliably closed/cleared?

### 4. Test Quality Audit
- **Did the tests actually assert behavior?** Look out for "fake tests" that merely run code without meaningful assertions, or test suites where assertions were softened (`toBeTruthy()` instead of exact value matching).
- Are edge cases and negative (error) paths covered by tests?

### 5. "Anti-AI-Slop" Audit
- **Unnecessary Abstractions**: Were generic factories, interfaces, or helper wrappers added for single-use logic?
- **Comment Bloat**: Are there redundant conversational comments explaining obvious code lines?
- **Docstring Tampering**: Were existing docstrings or comments altered without explicit instructions?
- **Rewriting Working Code**: Was existing, working code refactored when a targeted fix was sufficient?

---

## Output Template

Deliver a structured review report:

```markdown
## Code Review Report: [Branch / PR Name]

### 1. Verdict
- [ ] **APPROVE**: Ready for PR / merge.
- [ ] **REQUEST_CHANGES**: Requires specific fixes detailed below.
- [ ] **BLOCK**: Critical defect or security vulnerability detected.

### 2. Findings & Action Items
- **[Severity: High/Medium/Low]** `file.ts:L42`
  - **Issue**: [Concise description of the bug or risk]
  - **Remediation**: [Exact code change required]

### 3. Anti-Slop & Quality Assessment
- **Unnecessary abstractions**: [None detected | Found X]
- **Test validity**: [Meaningful assertions verified | Weak assertions found]
- **Performance/Complexity**: [O(N) time, O(1) space - acceptable]
```
