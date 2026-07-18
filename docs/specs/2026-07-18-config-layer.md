# Spec: Config layer - dotfiles/ + manifest (piece 2)

**Status:** implemented (2026-07-18) · **Date:** 2026-07-18

## Goal

Generalize the Claude-only config mirror (`home-claude/` ↔ `~/.claude`) into a
**manifest-driven, per-tool** config layer, so later pieces (Codex, VS Code, shell)
slot in without touching `install.sh`/`capture.sh` again. This piece ships the
mechanic with **only Claude** as its one tool - and captures the current live drift.

## Scope

- **In:** rename `home-claude/` → `dotfiles/claude/`; add `dotfiles/manifest`;
  make `install.sh` (copy) and `capture.sh` (pull-back) manifest-driven; capture
  the live `~/.claude` drift into `dotfiles/claude/`; update docs/memory refs.
- **Out (later pieces):** Codex (P3), VS Code (P4), shell glue (P5). No new tools
  here - just Claude through the new machine.

## Manifest: `dotfiles/manifest`

Pipe-delimited (paths can contain spaces, e.g. mac's `Application Support`):

```
# tool | target-linux | target-mac | target-wsl | exclude (comma globs)
claude | ~/.claude | ~/.claude | ~/.claude | .credentials.json,settings.local.json,history.jsonl,sessions,projects
```

- Source is always `dotfiles/<tool>/`. Target is the column for the detected OS
  (`~` expanded). WSL uses `target-wsl`. A `-` target = "skip this tool on this OS".
- `exclude` = files/dirs never copied **or** captured (secrets/local state). Belt
  to the existing gitignore + capture's "only-already-tracked" rule.
- Piece 2 has one row; the format is chosen so Codex/VS Code just add rows (VS Code
  will use a `$WINHOME/...` token in `target-wsl`, resolved like ade-stack's
  `win_home` - deferred to P4).

## install.sh (config step, replaces the `home-claude` block)

Add small OS detection (linux/mac/wsl, same test as ade-stack). For each manifest
row: pick the OS target (skip if `-`), expand `~`, copy `dotfiles/<tool>/*` → target,
skipping `exclude` matches, backing up any differing real file (today's logic). Same
summary line. `CLAUDE_HOME` keeps overriding Claude's target (back-compat for tests).

## capture.sh (whole file, manifest-driven)

For each row: pull the live target's files back into `dotfiles/<tool>/`, only the
ones already tracked there (unchanged rule), skipping `exclude`. Keep the
settings.json home→`$HOME` sanitisation **as a Claude-specific post-step** (only
Claude's settings has machine paths); note it's per-tool.

## Back-compat

The Claude **target stays `~/.claude`** - existing machines are unaffected; re-running
`install.sh` is idempotent (source dir renamed in the repo only). Update every
`home-claude/` reference: README, CLAUDE.md, `.gitignore` (the
`home-claude/.credentials.json` etc. lines → `dotfiles/claude/…`), agent memory.

## The drift capture

After the rename + `capture.sh` rework, run `./capture.sh` to pull the live
`~/.claude` drift (notably `settings.json`) into `dotfiles/claude/`. **Review the
diff for anything sensitive** before committing (public repo); the exclude list +
sanitisation guard secrets/paths. This closes the flagged drift as part of P2.

## Verification (definition of done)

Dogfood in a temp target (`CLAUDE_HOME` + a throwaway `~`):
1. `install.sh` copies `dotfiles/claude/` → target on linux (and the wsl path picks
   `target-wsl`); excluded files never land; a differing file is backed up.
2. `capture.sh` pulls a live edit back into `dotfiles/claude/`, skips excludes, and
   sanitises a home path in `settings.json` → `$HOME`.
3. Full `install.sh` still symlinks own skills, provisions the registry, arms the
   hook - i.e. the rename didn't break the other steps.
4. `security-scan` green; no `home-claude` refs left dangling (grep).

Ship: branch + PR, scan green, merge. Then P3 (Codex) is one manifest row + a dir.
