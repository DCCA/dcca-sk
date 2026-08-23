#!/usr/bin/env python3
"""Regression tests for the skills-only repository boundary."""

from __future__ import annotations

import importlib.util
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest import mock


ROOT = Path(__file__).resolve().parents[1]
RUNNER_PATH = ROOT / "evals" / "regras-agents-md" / "run.py"


def load_eval_runner():
    spec = importlib.util.spec_from_file_location("agents_eval_runner", RUNNER_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def tree_snapshot(path: Path) -> dict[str, bytes]:
    if not path.exists():
        return {}
    snapshot: dict[str, bytes] = {}
    for item in path.rglob("*"):
        relative = str(item.relative_to(path))
        if item.is_dir():
            snapshot[f"{relative}/"] = b""
        elif item.is_file():
            snapshot[relative] = item.read_bytes()
    return snapshot


class ExportContractTests(unittest.TestCase):
    def test_normal_export_passes_with_and_without_pyyaml(self):
        for args in (("python3",), ("python3", "-S")):
            proc = subprocess.run(
                [*args, str(ROOT / "scripts/check-export.py"), str(ROOT)],
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertEqual(proc.returncode, 0, proc.stderr)
            self.assertIn("OK authored-skill export", proc.stdout)

    def test_fallback_rejects_manifest_name_mismatch(self):
        with tempfile.TemporaryDirectory() as temp:
            clone = Path(temp)
            shutil.copytree(ROOT / "skills", clone / "skills")
            skill = clone / "skills/produto/daily-review/SKILL.md"
            text = skill.read_text(encoding="utf-8")
            skill.write_text(text.replace("name: daily-review", "name: wrong-name", 1), encoding="utf-8")
            proc = subprocess.run(
                ["python3", "-S", str(ROOT / "scripts/check-export.py"), str(clone)],
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertNotEqual(proc.returncode, 0)
            self.assertIn("deve ser exatamente 'daily-review'", proc.stderr)


class BoundaryTests(unittest.TestCase):
    def test_current_docs_route_terminal_restore_to_dcca_env(self):
        for path in (ROOT / "README.md", ROOT / "CLAUDE.md"):
            text = path.read_text(encoding="utf-8")
            self.assertIn("dcca-env", text)
            self.assertNotIn("setup-ade-stack.sh", text)

    def test_install_only_changes_clone_git_config(self):
        with tempfile.TemporaryDirectory() as temp:
            base = Path(temp)
            clone = base / "clone"
            home = base / "home"
            global_config = base / "global-git-config"
            clone.mkdir()
            home.mkdir()
            shutil.copytree(ROOT / "skills", clone / "skills")
            shutil.copytree(ROOT / "scripts", clone / "scripts")
            shutil.copytree(ROOT / "githooks", clone / "githooks")
            shutil.copy2(ROOT / "install.sh", clone / "install.sh")
            subprocess.run(["git", "init", "-q", str(clone)], check=True)
            outside_before = {
                "home": tree_snapshot(home),
                "global": tree_snapshot(global_config),
            }
            env = os.environ | {
                "HOME": str(home),
                "XDG_CONFIG_HOME": str(home / "config"),
                "GIT_CONFIG_GLOBAL": str(global_config),
                "GIT_CONFIG_NOSYSTEM": "1",
            }
            proc = subprocess.run(["bash", "install.sh"], cwd=clone, env=env,
                                  capture_output=True, text=True, check=False)
            self.assertEqual(proc.returncode, 0, proc.stderr)
            self.assertEqual(outside_before["home"], tree_snapshot(home))
            self.assertEqual(outside_before["global"], tree_snapshot(global_config))
            local = subprocess.run(
                ["git", "-C", str(clone), "config", "--local", "--get", "core.hooksPath"],
                capture_output=True, text=True, check=True,
            )
            self.assertEqual(local.stdout.strip(), "githooks")
            self.assertIn("DCCA/dcca-env", proc.stdout)

    def test_deprecated_capture_does_not_mutate_clone_or_home(self):
        with tempfile.TemporaryDirectory() as temp:
            base = Path(temp)
            clone = base / "clone"
            home = base / "home"
            clone.mkdir()
            home.mkdir()
            shutil.copy2(ROOT / "capture.sh", clone / "capture.sh")
            before_clone = tree_snapshot(clone)
            before_home = tree_snapshot(home)
            env = os.environ | {"HOME": str(home), "XDG_CONFIG_HOME": str(home / "config")}
            proc = subprocess.run(["bash", "capture.sh"], cwd=clone, env=env,
                                  capture_output=True, text=True, check=False)
            self.assertEqual(proc.returncode, 0, proc.stderr)
            self.assertEqual(before_clone, tree_snapshot(clone))
            self.assertEqual(before_home, tree_snapshot(home))
            self.assertIn("Nenhum arquivo foi alterado", proc.stdout)


class EvalRunnerRegressionTests(unittest.TestCase):
    def test_subject_failure_has_five_values_and_trial_returns_error(self):
        runner = load_eval_runner()
        with tempfile.TemporaryDirectory() as temp:
            base = Path(temp)
            fixture = base / "fixture"
            fixture.mkdir()
            (fixture / "watched.txt").write_text("baseline\n", encoding="utf-8")
            policy = base / "AGENTS.md"
            policy.write_text("policy\n", encoding="utf-8")
            old_fixture, old_runs, old_policy = runner.FIXTURE, runner.RUNS, runner.POLICY
            runner.FIXTURE, runner.RUNS, runner.POLICY = fixture, base / "runs", policy
            case = {"id": "R-test", "prompt": "unused", "watch": None, "must_change": None}
            try:
                failed_process = subprocess.CompletedProcess(
                    args=["claude"], returncode=9, stdout="", stderr="simulated failure"
                )
                with mock.patch.object(runner.subprocess, "run", return_value=failed_process):
                    values = runner.run_subject(case, 1)
                self.assertEqual(len(values), 5)
                self.assertIn("subject exited 9", values[4])

                with mock.patch.object(
                    runner, "run_subject", return_value=(None, None, "", 0.0, "simulated failure")
                ) as run_subject:
                    result = runner.trial(case, 1)
                self.assertEqual(result["verdict"], "ERROR")
                self.assertIn("simulated failure", result["why"])
                self.assertEqual(run_subject.call_count, 2)
            finally:
                runner.FIXTURE, runner.RUNS, runner.POLICY = old_fixture, old_runs, old_policy


if __name__ == "__main__":
    unittest.main()
