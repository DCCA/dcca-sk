# Global guidance (applies to all projects)

Project-specific commands and architecture live in each repo's own CLAUDE.md. This file holds cross-project working habits.

## Engineering values

These shape every technical decision, not just the final check.

- When making technical decisions, do not give much weight to short-term development cost. Prefer quality, simplicity, robustness, scalability, and long-term maintainability. A cheap hack that I will fight later is not actually the cheap option.
- Hold a high bar for engineering excellence: lint, test failures, and test flakiness. If you see one, fix it even when it is not caused by the work in front of you right now.
- Be picky about UI. When you exercise a product end-to-end, get obsessed with getting it right visually. If something clearly looks off, try to fix it along the way even if it is unrelated to the current task.

## Definition of Done

A change is not "done" until, in order:

1. Tests pass. Run the project's full test suite(s) (frontend and backend). Prefer TDD: write or extend the test before the implementation. For async, event-driven, or timing-dependent work (content scripts, drag locks, streamed output, print/export), passing unit tests is not "done". Exercise the real runtime path (integration/e2e smoke, headless run, or actual app run) and confirm no races or swallowed errors.
2. It builds. Run the project's build/typecheck.
3. Visually verified (UI work). Render the actual change (run the app or screenshot the affected surface) and confirm it looks and behaves right, in both light and dark mode when the project supports them. Do not claim a UI change works from code alone.
4. Shipped via PR. Branch (never commit straight to the default branch), commit, push, open a PR, then merge once checks are green. Delete the branch after merge.

State results with evidence (the command output), not assertions. If a step fails or was skipped, say so plainly.

## Bug fixes

Start by reproducing the bug in an end-to-end setting, as close as possible to how a real user hits it. Reproducing it first makes sure you are solving the actual problem and that the fix really works, rather than patching a symptom.

## UI redesigns

When asked to match a design, replicate the full functional structure and layout, not just colors and design tokens. Read the actual design source files first, then show a short plan before implementing. If a native control (e.g. `<select>`) cannot be styled to match (the OS-rendered dropdown ignores CSS), rebuild it as a custom component rather than leaving the gap.

## Writing and commits

- Never use the em dash. Use a plain dash "-" instead.
- When writing commit messages, never auto-add your agent name as co-author.
- Never hand-edit files marked as auto-generated; check the file header or the build/release config if you are unsure. This applies to CHANGELOG.md only when the repo generates it. If the changelog is hand-maintained, edit it normally.

## Skills

When a project has both a lightweight skill and a fuller version with evals, default to the version that includes evals.

## Delegation (subagents and workflows)

Default to delegating work that doesn't need to happen in the main context. The main conversation is for decisions, edits, and the throughline - not for raw exploration.

**Reach for a subagent when:**
- Answering means reading across many files or directories and I only need the conclusion - delegate the search, keep the answer.
- There are 2+ independent tasks with no shared state - launch them in parallel in a single message.
- A step would flood context with logs, search output, or file dumps I won't reference again.

**Keep in the main session:** sequential work where each step needs the last one's full output, and any approval-gated edit. Scope research agents to read-only. Never have two agents edit the same file in parallel.

**Brief every subagent like a stranger** - it sees only the prompt, not this conversation. Give it paths, error text, constraints, and the relevant rule from this file explicitly.

**Workflows** (deterministic multi-agent fan-out) are for structured, repeatable multi-phase work at scale - broad audits, migrations, review-then-verify passes, deep research. They're expensive: use one when the task is genuinely large and parallel, and tell me the rough scope first rather than launching silently. For everything smaller, a subagent or a few parallel subagents is the right tool.

### Model routing (quality-first)

Default the floor high, reserve the ceiling. Pick the model to fit the task's difficulty and horizon, not one tier for everything.

- **Opus 4.8** - default for the main thread and any substantive delegated work: design, hard debugging, code review, architecture, anything accuracy-critical.
- **Sonnet 5** - routine-but-real subagents: straightforward edits, standard analysis, and research that explains how existing code or behavior works (tracing a flow, mapping a subsystem). Pure mechanical search is Haiku; research that feeds a hard design or correctness decision is Opus.
- **Haiku 4.5** - mechanical grunt only: file finding, log/grep sweeps, lint and style checks, simple lookups. Don't burn a bigger model on these.
- **Fable 5** - reserved top rung. Only for genuinely long-horizon autonomous runs (multi-hour agent loops, large migrations, deep multi-phase workflows) where staying focused across millions of tokens is the whole point. It costs 2x Opus - it's not the everyday default. When I reach for it, I'll say why first.

When unsure between two tiers, take the higher one - but never route mechanical work above Haiku just to be safe.

## Environment (WSL)

Prefer `python3` over `python`. Do not run `sudo` commands. Surface them for me to run via `!`.
