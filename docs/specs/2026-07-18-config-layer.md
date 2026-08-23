# Spec: config layer (retired)

**Status:** retired on 2026-08-17 and fully removed from dcca-sk

This historical slice introduced the manifest-driven config copier. The
runtime ownership was later moved to `DCCA/dcca-env`, and the active copier,
manifest, shell glue and VS Code seed files were removed from this repository.

## Current ownership

`dcca-sk` is a skills-only authored module. It does not own configuration
rows, runtime destinations, agent links, shell glue, VS Code settings, capture
flows, credentials, histories, sessions, caches or generated state.

`install.sh` remains only as a validation compatibility wrapper. It may set
`core.hooksPath` in this clone's local Git config so the pre-push security hook
can run. `capture.sh` is a non-mutating deprecation handoff and does not copy
live state anywhere.

Use the DCCA/dcca-env restore flow for agent configuration and runtime state.
Keep this document as historical provenance only; do not add new configuration
ownership here.
