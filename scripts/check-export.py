#!/usr/bin/env python3
"""Validate dcca-sk's explicit authored-skill export manifest."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
FRONTMATTER = re.compile(r"^---\s*\n(.*?)\n---(?:\s*\n|$)", re.DOTALL)
FALLBACK_FIELD = re.compile(r"^(name|description):[ \t]*(.*?)\s*$")


def fail(message: str) -> None:
    print(f"export manifest invalido: {message}", file=sys.stderr)
    raise SystemExit(1)


def parse_fallback_frontmatter(frontmatter: str, expected_name: str) -> None:
    """Validate the small frontmatter subset needed when PyYAML is unavailable."""
    fields: dict[str, str] = {}
    for line in frontmatter.splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        match = FALLBACK_FIELD.fullmatch(line)
        if not match or match.group(1) in fields:
            continue
        value = match.group(2).strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in "'\\\"":
            value = value[1:-1]
        fields[match.group(1)] = value

    if fields.get("name") != expected_name:
        fail(f"frontmatter name deve ser exatamente {expected_name!r}")
    if not fields.get("description", "").strip():
        fail("frontmatter description deve ser nao vazia")


def main() -> None:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).resolve().parents[1]).resolve()
    manifest_path = root / "skills" / "export-manifest.json"
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        fail(f"nao foi possivel ler skills/export-manifest.json: {exc}")

    if not isinstance(manifest, dict) or manifest.get("version") != 1:
        fail("version deve ser 1")
    entries = manifest.get("skills")
    if not isinstance(entries, list) or not entries:
        fail("skills deve ser uma lista nao vazia")

    listed: set[Path] = set()
    names: set[str] = set()
    for entry in entries:
        if not isinstance(entry, dict) or set(entry) != {"name", "path"}:
            fail("cada entrada deve conter apenas name e path")
        name = entry["name"]
        relative = entry["path"]
        if not isinstance(name, str) or not NAME.fullmatch(name):
            fail(f"nome invalido: {name!r}")
        if name in names:
            fail(f"nome duplicado: {name}")
        names.add(name)
        if not isinstance(relative, str) or not relative.startswith("skills/"):
            fail(f"path fora de skills/: {relative!r}")
        path = (root / relative).resolve()
        try:
            path.relative_to(root / "skills")
        except ValueError:
            fail(f"path escapa de skills/: {relative!r}")
        if not path.is_dir() or not (path / "SKILL.md").is_file():
            fail(f"skill ausente ou sem SKILL.md: {relative!r}")
        if path in listed:
            fail(f"path duplicado: {relative}")
        listed.add(path)

        text = (path / "SKILL.md").read_text(encoding="utf-8")
        match = FRONTMATTER.match(text)
        if not match:
            fail(f"{relative}/SKILL.md: frontmatter ausente ou invalido")
        frontmatter = match.group(1)
        try:
            import yaml
        except ImportError:
            parse_fallback_frontmatter(frontmatter, name)
        else:
            try:
                parsed = yaml.safe_load(frontmatter)
            except Exception as exc:
                fail(f"{relative}/SKILL.md: YAML invalido: {str(exc).splitlines()[0]}")
            if not isinstance(parsed, dict) or parsed.get("name") != name or not parsed.get("description"):
                fail(f"{relative}/SKILL.md: name deve ser {name!r} e description deve existir")

    actual = {
        path.parent.resolve()
        for path in (root / "skills").rglob("SKILL.md")
        if path.is_file()
    }
    if actual != listed:
        missing = sorted(str(path.relative_to(root)) for path in actual - listed)
        stale = sorted(str(path.relative_to(root)) for path in listed - actual)
        details = []
        if missing:
            details.append("nao listadas: " + ", ".join(missing))
        if stale:
            details.append("inexistentes: " + ", ".join(stale))
        fail("; ".join(details))

    print(f"OK authored-skill export: {len(entries)} skill(s) validada(s), nenhum runtime link")


if __name__ == "__main__":
    main()
