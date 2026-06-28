# Agent Skills: Disciplined Autonomous Coding Stack

A vendor-agnostic, central repository of standard skills for AI coding agents.

This repository combines:
* **Matt Pocock’s engineering rigor**: Disciplined TDD, small increments, tight feedback loops, type-driven boundaries, and prevention of architectural drift.
* **Pstack’s autonomous patterns**: Deterministic blast-radius analysis, evidence-based investigation, adversarial review, CI failure babysitting, and durable retrospectives.

Instead of installing heavy third-party plugins with broad credentials, this repository provides a **clean, vendor-agnostic foundation** of six portable skills (`SKILL.md`) that work seamlessly across **Antigravity, Claude Code, Cursor, Aider, GitHub Actions, and headless CI agents**.

---

## The 6 Core Skills

```text
Task / Bug Report
       │
       ▼
1. understand-and-scope   ──► Static AST & LSP blast-radius analysis (Zero code edits)
       │
       ▼
2. plan-change            ──► Compact plan with explicit non-goals & acceptance criteria
       │
       ▼
3. execute-verified-change ──► TDD (failing test first) ──► Minimal code ──► `make verify`
       │
       ▼
4. review-diff            ──► Adversarial, clean-context review (Anti-AI-slop audit)
       │
       ▼
5. ci-repair              ──► Bounded repair for deterministic CI errors (Max 2 attempts)
       │
       ▼
6. durable-retro          ──► Upgrades durable controls: Types → Lint → Tests (Separate PR)
```

| Skill | Path | Description |
| :--- | :--- | :--- |
| **`understand-and-scope`** | [`skills/understand-and-scope/SKILL.md`](./skills/understand-and-scope/SKILL.md) | Traces execution paths, inspects Git context, and computes blast radius using deterministic tooling before touching code. |
| **`plan-change`** | [`skills/plan-change/SKILL.md`](./skills/plan-change/SKILL.md) | Produces an actionable plan with binary acceptance criteria, explicit non-goals, and risk analysis. |
| **`execute-verified-change`** | [`skills/execute-verified-change/SKILL.md`](./skills/execute-verified-change/SKILL.md) | Enforces strict TDD (failing test first for bugs, interface contracts for features), minimal fixes, and local verification. |
| **`review-diff`** | [`skills/review-diff/SKILL.md`](./skills/review-diff/SKILL.md) | Evaluates diffs in an isolated context for correctness, edge cases, security, and removes unnecessary abstractions ("AI slop"). |
| **`ci-repair`** | [`skills/ci-repair/SKILL.md`](./skills/ci-repair/SKILL.md) | Automatically repairs bounded, deterministic CI errors. Imposes a hard 2-attempt limit and strictly bans test weakening or skipping. |
| **`durable-retro`** | [`skills/durable-retro/SKILL.md`](./skills/durable-retro/SKILL.md) | When an error recurs, converts the learning into durable programmatic controls (Types > Lint > Tests > CI), never just prompt text. |

---

## Strategy: Using Across Projects & Machines

### The Hub-and-Spoke Architecture
To keep skills synchronized across all repositories and machines without manual copy-pasting:

1. **The Hub (This Repo)**: Store canonical skill definitions here in version control.
2. **The Spokes (Your Projects)**: Mirror skills into each project's `.skills/` directory.

### Syncing into Downstream Projects

#### Option A: Quick Sync via Script (Recommended)
Add [`scripts/sync-skills.sh`](./scripts/sync-skills.sh) to your project tooling or run directly:

```bash
# In downstream project root:
curl -sSL https://raw.githubusercontent.com/your-org/agent-skills/main/scripts/sync-skills.sh | bash
```

This:
1. Copies the canonical skills to `.skills/`.
2. Creates `./AGENTS.md` to bootstrap any agent entering the repo.
3. Automatically creates symlinks for `.claude/skills` and `.cursor/rules` if those folders exist.

#### Option B: Git Submodule
If you prefer strict Git version-pinning across your organization:
```bash
git submodule add https://github.com/your-org/agent-skills.git .skills
```

---

## Cross-Agent Compatibility

Different AI agents look for instructions in different configuration folders. Authoring all skills in universal Markdown + YAML frontmatter (`SKILL.md`) allows all agents to consume them:

- **Antigravity**: Discovers skills automatically in `skills/` or `.agent/skills/`.
- **Claude Code**: Symlink `.claude/skills` $\to$ `.skills/` or reference via `CLAUDE.md`.
- **Cursor**: Symlink `.cursor/rules` $\to$ `.skills/` or reference via `.cursorrules`.
- **Aider / Copilot / Others**: Add a pointer in `.github/copilot-instructions.md` or `AGENTS.md`.

Use the provided [`templates/AGENTS.md`](./templates/AGENTS.md) as the universal entry point at the root of every project.

---

## The Verification Contract (`make verify`)

Skills should be language-agnostic, but verification is repository-specific.

Every project using these skills must provide a single canonical verification command:
```bash
make verify
# or
npm run verify
```

See [`templates/Makefile.verify.example`](./templates/Makefile.verify.example) for a standard pipeline template enforcing:
1. Formatting
2. Linting (Static analysis)
3. Type checking
4. Automated unit/integration tests
5. Production build

Both local agents and CI runners run this **exact same command**.

---

## Autonomy Boundaries & Security

To safely run autonomous agents in production and CI:

* **Least-Privilege GitHub Tokens**: Never grant `admin` or permanent tokens. Use a scoped GitHub App with only `contents: write` and `pull-requests: write`.
* **CI Circuit Breakers**: `ci-repair` terminates after 2 failed attempts and alerts a human.
* **Test Anti-Tampering**: Agents are forbidden from deleting tests, weakening assertions, or altering CI workflows to achieve green builds.
* **Human Approval Gates**: Autonomous merges are only allowed for low-risk, green PRs (e.g., docs, dependencies, isolated tests). Core business logic, migrations, and infrastructure require human approval.
