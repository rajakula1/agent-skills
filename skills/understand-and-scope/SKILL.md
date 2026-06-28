---
name: understand-and-scope
description: Traces code paths, static AST dependencies, git history, and calculates blast radius using deterministic tooling before making any edits.
---

# Understand and Scope

## Objective
Thoroughly understand the problem, trace the actual execution paths, and compute the blast radius of changes before modifying any code. 

**Core Rule**: Never write or edit implementation code during this step.

---

## When to Use
- At the start of any new feature, bug fix, refactor, or issue investigation.
- Whenever a request touches unfamiliar modules, shared interfaces, or public APIs.

---

## Execution Steps

### 1. Identify Entry Points and Execution Paths
- Locate the primary entry points (API endpoints, CLI commands, UI routes, event handlers) associated with the task.
- Trace the flow of data from inputs to downstream side effects (database, external services, caches).
- Document file paths, line numbers, and relevant symbol names.

### 2. Deterministic Blast-Radius Analysis
**Do NOT guess or hallucinate dependencies.** Use deterministic static-analysis and grep tools:
- **LSP / References**: Run symbol reference lookups or AST-based searches to find all direct consumers of functions/types you plan to alter.
- **Dependency Graphs**: In monorepos or multi-package projects, run workspace dependency tools:
  - TypeScript/JS: `pnpm --filter ...`, `nx affected:graph`, `madge --circular`, or `ts-prune`.
  - Python: `pydeps`, `pipdeptree`, or AST inspection.
  - Go: `go list -m all`, `go vet`, or package dependency queries.
- **Call-Site Audit**: If modifying an interface, function signature, or data model, list every caller that will be affected.

### 3. Historical and Telemetry Context
- Check Git history on affected files to understand recent modifications and design decisions:
  ```bash
  git log -n 5 --oneline <file-path>
  git log -S "<symbol-name>" -n 3
  ```
- Identify previous bug fixes or regressions in the same area to avoid re-introducing past failures.

### 4. Existing Test Audit
- Locate existing unit, integration, and e2e tests covering the target files.
- Determine whether current test coverage is adequate to detect regressions when behavior changes.

---

## Hard Constraints
1. **Zero Code Edits**: Do not create or edit production or test code during this step.
2. **Explicit Unknowns**: If external APIs, undocumented schemas, or ambiguities exist, call them out explicitly. Do not assume or guess.
3. **Evidence-Based Reporting**: Every finding must reference concrete files, line numbers, or command outputs.

---

## Deliverable / Output Template

Produce a concise briefing with the following structure:

```markdown
### 1. Problem Summary & Target Behavior
- **Goal**: [Clear description of what needs to happen]
- **Target Files**: [List of absolute/relative file paths and line ranges]

### 2. Execution Path Trace
- `Entrypoint` -> `Service/Controller` -> `Data Layer / Side Effects`

### 3. Blast Radius & Affected Consumers
- **Direct Callers / Importers**: [List of files calling the target code]
- **Shared Types / Schemas**: [Any contracts being changed]
- **Risk Level**: [Low | Medium | High] (High if touching shared public APIs or core schemas)

### 4. Existing Test Coverage
- **Existing Test Files**: [Paths to existing test suites]
- **Coverage Gaps**: [What scenarios are currently un-tested]

### 5. Assumptions & Open Questions
- [Bullet list of validated assumptions or questions requiring clarification]
```
