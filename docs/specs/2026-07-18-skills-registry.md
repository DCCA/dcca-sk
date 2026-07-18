# Spec: Skills registry (piece 1 of "AI setup, versioned + agent-installed")

**Status:** implemented (2026-07-18) · **Date:** 2026-07-18

## Goal

Version a list of **external skills** the user relies on so `install.sh` provisions
them on any machine. The repo holds **pointers, not content** ("reference, don't
vendor"). Own skills stay in `skills/` (symlinked, unchanged); this adds a registry
for skills that live elsewhere.

## Scope

- **In:** a registry file + one new `install.sh` step that installs `git` and `npx`
  skills and *verifies* `plugin` skills. Docs + one test.
- **Out (later pieces):** `home-claude/` → `dotfiles/` rename, the config manifest,
  Codex/VS Code/shell. This piece touches neither `home-claude/` nor the config flow.

## The registry file: `skills/registry`

Plain text, one skill per line, `#` comments, blank lines ignored. Three entry types:

```
# type   args
plugin   <plugin-name>              # e.g. superpowers  (verified against settings.json)
git      <name>  <url>              # cloned to ~/.claude/skills/<name>
npx      <package-spec>             # installed via `npx skills add <package-spec>`
npm      <package-spec>             # global CLI tool: `npm install -g <package-spec>`
```

`npm` is for CLI tools with native Claude Code integration (e.g. openspec) that
install globally rather than into `~/.claude/skills`. Only pointers (names / URLs /
packages) - **no secrets**, safe in the public repo.
Not a `SKILL.md`, so it sits outside the existing `find skills -name SKILL.md`
symlink loop - no conflict with own-skill symlinking.

## `install.sh` behavior (new step, after the config-copy step)

Read `skills/registry`; dispatch per line by type into the skills target
(`$TARGET`, default `~/.claude/skills`):

- **plugin** → check `<plugin-name>` is in `dotfiles/claude/settings.json`
  `enabledPlugins`. Missing ⇒ `c_warn` (settings.json is the real installer;
  this is a consistency check only). Read-only.
- **git** → if `$TARGET/<name>` is a git repo: `git -C … pull --ff-only`; else
  `git clone --depth 1 <url> $TARGET/<name>`. First cut assumes the repo root is
  the skill (`SKILL.md` at root). Name collides with an own-skill symlink ⇒ warn +
  skip.
- **npx** → `have npx` ? `( cd "$HOME" && npx -y skills add <spec> )` : warn + skip.
  Run from `$HOME`: the skills CLI installs into the **cwd's** `.agents/skills/`,
  so running elsewhere pollutes that dir; from `$HOME` it lands in the global
  `~/.agents/skills` (symlinked into `~/.claude/skills`). A `<spec>` may be a
  **collection** (e.g. taste = design-taste-frontend +12).
- **npm** → `have npm` ? `npm install -g <spec>` : warn + skip. (Global CLI, not a
  `~/.claude/skills` skill.)
- Unknown type / malformed line ⇒ warn + skip. Missing `git`/`npx`/`npm` ⇒ warn +
  continue (matches the repo's warn-and-continue ethos). End with a summary line
  (`registry: N git, M npx, P npm, K plugin-checks`).

## Idempotency

git = clone-or-pull; `npx skills add` = re-runnable; plugin = read-only. Safe to
re-run - the whole point.

## Constraints / edge cases

- **Public repo:** registry carries no secrets. A **private** git skill would need
  the machine's own SSH/token auth (never stored here) - documented limitation.
- **git skill structure:** first cut assumes the repo root (or `[subdir]`) holds the
  skill (`SKILL.md`). Collection repos beyond that are a later extension.
- Registry warnings **do not fail** the install; only broken *own-skill* frontmatter
  still exits non-zero (unchanged).

## Security

`security-scan.sh` already flags secrets; a token-in-URL (`https://TOKEN@github…`)
trips the existing secret regex. Add one test asserting a registry line with a
token-URL fails the scan. No scanner change expected.

## Verification (definition of done)

Dogfood against a temp target (`CLAUDE_SKILLS_DIR` + temp `HOME`):
1. a real small **public git skill** clones; re-run does a `pull` (idempotent);
2. a **bogus git URL** warns without aborting the install;
3. a **plugin** entry absent from `enabledPlugins` warns;
4. the **npx** path skips cleanly when `npx` is absent;
5. `install.sh` still validates own-skill frontmatter and only that can exit non-zero.

Ship: branch + PR, `security-scan` green, merge.

## Rollout

Land the mechanism with a minimal example registry, then the user fills in real
entries (git URLs / npx packages / plugin names). Plugins they already use
(superpowers, ponytail, skill-creator, …) are listed as `plugin` entries for
completeness and cross-checked against the already-versioned `settings.json`.
