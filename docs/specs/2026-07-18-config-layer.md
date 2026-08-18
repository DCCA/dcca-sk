# Spec: config layer (retired)

**Status:** retired on 2026-08-17

This historical slice introduced the manifest-driven config copier. Its Claude
and Codex destinations were removed when agent runtime ownership moved to
`dcca-env`.

## Current ownership

`dcca-sk` keeps only the rows in [`dotfiles/manifest`](../../dotfiles/manifest):

- shell glue under `~/.config/dcca-sk`;
- VS Code settings and extension seed data.

`install.sh` and `capture.sh` continue to serve those rows. They do not read or
write Claude, Codex, Pi, agent links, credentials, histories, sessions, caches,
or generated runtime state. The dcca-env restore flow is the only writer for
agent configuration.

The old `claude`, `codex`, backup, and home-normalization behavior is no longer
part of this repo. Keep this document as provenance only; do not add new agent
rows here.
