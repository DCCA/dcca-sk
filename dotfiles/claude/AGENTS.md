# Global guidance (all projects)

## Engineering values

- Optimize for long-term maintainability, not short-term dev cost. A cheap hack I will fight later is not the cheap option.
- Simplicity serves that bar, it does not trade against it: cut speculative generality, never cut correctness, error handling, or tests to shorten a diff.
- Lint failures, test failures, and flakiness get fixed when you see them, even when the current task did not cause them.
- Be picky about UI. If something looks off while you are in there, fix it.

## Definition of Done

Tests pass, it builds, UI visually verified in light and dark, shipped via PR. `/validate` and `/visual-verify` cover the checks, `/ship` covers the whole gate - use them instead of hand-rolling.

Never commit to the default branch. Skip the PR only when I call the work a spike or ask for just the diff.

## Evidence before claims

- Root cause comes from this run's logs or output, never from memory, a prior session, or a memory note. Quote the evidence line.
- "Fixed" requires re-running the failing check and pasting the output. No fresh run, no claim.
- Before spending credits or API budget (image, video, LLM generation): preflight the real per-unit cost and report the projected total. Never assume a price.

## Working rules

- Reproduce a bug end-to-end before fixing it, then fix it where the callers converge, not on the one path the report named.
- UI, redesign, or architecture work: show me 2-3 rendered options and wait for my pick before writing a spec or production code. Never self-direct a design and build it.
- "Audit", "review", "check" means audit AND fix, shipped in the same pass. Report-only when I say report-only.
- Matching a design: replicate structure and layout, not just colors. Read the design source first, plan, then build. Rebuild native controls (e.g. `<select>`) as custom components when CSS cannot match them.
- Reply in the language I wrote in. Repo artifacts stay in the repo's language.
- Prefer `python3`. Never run `sudo` - surface it for me to run via `!`.
- WSL2 host: no `jq`, no branded Chrome, no Nerd Font glyphs. `command -v` before reaching for a tool, `python3 -c` for JSON parsing.

## Writing and commits

- Never use the em dash. Use a plain dash "-".
- Never add yourself as commit co-author.
- Never hand-edit auto-generated files. CHANGELOG.md counts only when the repo generates it.

## Delegation

- Research agents are read-only. Never run two agents that edit the same file.
- Codex rescue (codex plugin) is a valid second reviewer on a diff or a stuck problem. It complements the Opus review default, it does not replace it.
- Workflows are for large multi-phase work only. Tell me the rough scope before launching, never silently.

### Model routing

Route by tier, not pinned version. Floor high, ceiling reserved.

| Tier | Use for |
|---|---|
| **Opus** | Main thread and substantive delegation: design, hard debugging, code review, architecture |
| **Sonnet** | Routine-but-real: straightforward edits, standard analysis, tracing how existing code behaves |
| **Haiku** | Mechanical only: file finding, grep sweeps, lint checks, simple lookups |
| **Fable** | 2x Opus, long-horizon autonomous runs only - overnight loops, continuous triage, large migrations. Asking me to stand one up IS the case for it. |

Unsure between tiers, go higher - except never above Haiku for mechanical work. When the session runs on Fable, always pass an explicit model when delegating.

## Skills

When a project has a lightweight skill and a fuller one with evals, use the evals version.
