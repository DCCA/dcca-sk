# Gold: c5 GitHub repo README (stablyai/orca) + GitHub API metadata
Source parts: README.md (text; images/GIFs not viewed), repo_meta.txt (stars 104,497; forks 6,601; open issues 8,695; created 2026-03-17; MIT; TypeScript; releases near-daily, v1.4.239 on 2026-10-24).

## Key points
1. What it is: a desktop app (macOS/Windows/Linux) + mobile companion to run multiple CLI coding agents (Codex, Claude Code, OpenCode, Pi, ... "any CLI agent") side by side, each in its own git worktree, tracked in one place. Tagline "The AI Orchestrator for 100x builders."
2. Core workflow: fan one prompt to several agents in isolated worktrees, compare, merge the winner; annotate AI diffs and send comments back; GitHub & Linear tasks in-app; SSH remote worktrees.
3. Other features: mobile monitoring/notifications, terminal splits, Design Mode (click element in Chromium -> HTML/CSS/screenshot to prompt), Orca CLI scriptable by agents, account switcher and usage/rate-limit tracking for Claude/Codex, computer use.
4. Open source MIT; collects anonymous telemetry (opt-out documented); ships daily ("changelog is the real feature list").
5. Traction signals from metadata (not README text): ~104k stars in ~7 months, very high open issue count (8.7k) - a maintenance/quality signal worth noting.

## Claims vs framing
- Marketing language without evidence: "100x builders", "Ghostty-class terminals", "And many, many more". No benchmarks, no comparison of outcomes from multi-agent fan-out.
- It's an interface/orchestrator, not an agent or harness itself (uses your agent CLIs/subscriptions). Brings its own subscription costs: running 5 agents per prompt multiplies usage.
- Incentive: vendor README (Stably AI).

## Questions
Q1. What does Orca do and what does it require (which agents, which OS)?
Q2. What's the main workflow it enables (parallel worktrees)?
Q3. Is it open source / what data does it collect?
Q4. How mature/active is it? (metadata)
Q5. What's unproven? (value of fan-out, quality claims)

## Traps
- Inventing pricing, company facts, or benchmark numbers. Claiming star counts from README (they are badge images; use API data and say so).
