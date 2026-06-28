# Agent Operating Guidelines & Skills

This repository enforces disciplined, test-driven, and evidence-based AI coding workflows. 

All AI coding assistants (Antigravity, Claude Code, Cursor, Aider, Copilot, CI agents) MUST adhere to the standardized skills located in `.skills/` (or `skills/`).

---

## Autonomous Workflow Sequence

Every coding task must follow this pipeline:

```text
Task / Issue
   │
   ▼
1. understand-and-scope   ──► Deterministic blast-radius check & AST inspection (NO edits)
   │
   ▼
2. plan-change            ──► Spec + testable acceptance criteria + explicit non-goals
   │
   ▼
3. execute-verified-change ──► Failing test FIRST ──► Smallest code fix ──► `make verify`
   │
   ▼
4. review-diff            ──► Adversarial, clean-context review before opening PR
   │
   ▼
5. ci-repair              ──► Bounded repair for deterministic CI failures (max 2 tries)
   │
   ▼
6. durable-retro          ──► Upgrade types/lint/tests on recurring issues (separate PR)
```

---

## Canonical Skills Reference

Before taking action, read the relevant skill instruction file:

- **Before planning or writing code**: Read [`.skills/understand-and-scope/SKILL.md`](./.skills/understand-and-scope/SKILL.md).
- **When creating an implementation plan**: Read [`.skills/plan-change/SKILL.md`](./.skills/plan-change/SKILL.md).
- **When implementing or fixing bugs**: Read [`.skills/execute-verified-change/SKILL.md`](./.skills/execute-verified-change/SKILL.md).
- **Before submitting a PR or requesting review**: Read [`.skills/review-diff/SKILL.md`](./.skills/review-diff/SKILL.md).
- **If CI checks fail on an agent branch**: Read [`.skills/ci-repair/SKILL.md`](./.skills/ci-repair/SKILL.md).
- **When addressing recurring regressions**: Read [`.skills/durable-retro/SKILL.md`](./.skills/durable-retro/SKILL.md).

---

## Canonical Verification Command

Every code change must be verified locally before committing by running the single repository verification command:

```bash
make verify
# or
npm run verify
```

Never commit code if `make verify` fails. Never weaken assertions or disable linter rules to force a pass.
