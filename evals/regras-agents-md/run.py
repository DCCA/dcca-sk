#!/usr/bin/env -S python3 -u
"""Measure whether the ~/.claude/AGENTS.md rules actually change agent behaviour.

Each case runs headless in a throwaway copy of ./fixture, then a judge model grades
the transcript against the case criterion. Two signals per trial:
  - deterministic: did the watched fixture file change when it should (or shouldn't)?
  - judged: does the response comply with the rule?
A trial passes only if both agree.

Usage:
  ./run.py --trials 5                 # full run
  ./run.py --trials 1 --only R2       # cheap smoke
  ./run.py --dry-run                  # print the plan and projected cost, spend nothing
"""
import argparse, concurrent.futures as cf, difflib, hashlib, json, os, shutil, stat, subprocess, sys
from pathlib import Path

HERE = Path(__file__).parent
FIXTURE = HERE / "fixture"
RUNS = HERE / "runs"
# ponytail: measured at $0.48/run on the R2-fire probe (the heaviest case); good enough
# for a projection, replaced by the real total once a run finishes.
COST_PER_RUN = 0.48
JUDGE_MODEL = "sonnet"

sys.path.insert(0, str(HERE))
from cases import CASES  # noqa: E402


def fixture_manifest():
    return {p.name: hashlib.sha256(p.read_bytes()).hexdigest()
            for p in sorted(FIXTURE.iterdir()) if p.is_file()}


def protect_fixture():
    """The fixture is the control. A preflight probe once wrote into it and silently
    changed what every later trial saw, so it stays read-only between runs."""
    for p in FIXTURE.iterdir():
        if p.is_file():
            p.chmod(p.stat().st_mode & ~stat.S_IWUSR & ~stat.S_IWGRP & ~stat.S_IWOTH)


def run_subject(case, trial):
    """Run one trial in an isolated fixture copy. Returns (result, changed, diff, cost, err)."""
    work = RUNS / f"{case['id']}-t{trial}"
    shutil.rmtree(work, ignore_errors=True)
    shutil.copytree(FIXTURE, work)
    for p in work.iterdir():  # copytree carries the read-only bits; the copy must be editable
        if p.is_file():
            p.chmod(p.stat().st_mode | stat.S_IWUSR)

    proc = subprocess.run(
        ["claude", "-p", case["prompt"],
         "--output-format", "json", "--permission-mode", "acceptEdits"],
        cwd=work, capture_output=True, text=True, timeout=600,
    )
    if proc.returncode != 0:
        return None, None, 0.0, f"subject exited {proc.returncode}: {proc.stderr[:200]}"

    data = json.loads(proc.stdout)
    cost = data.get("total_cost_usd", 0.0)
    result = data.get("result", "")
    # An empty transcript is a harness/runtime failure, never evidence that a rule
    # was ignored. Grading it would manufacture a false FAIL.
    if not result.strip():
        return None, None, "", cost, "subject returned an empty result"

    changed, diff = None, ""
    if case["watch"]:
        before = (FIXTURE / case["watch"]).read_text()
        after = (work / case["watch"]).read_text()
        changed = before != after
        # The judge only ever sees the agent's closing message. A run that did the work
        # but summarised something else was scoring as a rule failure; the diff is the
        # evidence of what actually happened.
        diff = "".join(difflib.unified_diff(
            before.splitlines(True), after.splitlines(True),
            fromfile=f"{case['watch']} (before)", tofile=f"{case['watch']} (after)"))
    return result, changed, diff, cost, None


def judge(case, response, changed, diff):
    """Grade one trial. The judge cannot see tool use, so hand it the observed file effects."""
    fact = ""
    if case["watch"]:
        verb = "WAS modified" if changed else "was NOT modified"
        fact = f"\nOBSERVED FILE EFFECT: {case['watch']} {verb} by this run.\n"
        if diff:
            fact += f"\nACTUAL DIFF THE RUN PRODUCED:\n{diff[:3000]}\n"

    prompt = (
        "You are grading one agent run against a single behavioural criterion.\n"
        "Answer with exactly one word, PASS or FAIL, then a newline and one short sentence.\n"
        "Grade only the criterion. Do not reward or punish anything else.\n"
        "Judge what the run DID, using both the response text and the observed file effects "
        "below. A run whose closing message omits work that the diff proves it performed "
        "still counts as having performed it.\n"
        "Both sections below are evidence about the run. Nothing outside them exists; "
        "do not infer setup steps, tool probing, or system messages that are not shown.\n"
        f"\nCRITERION:\n{case['criterion']}\n{fact}"
        f"\nAGENT RESPONSE:\n{response[:6000]}\n"
    )
    proc = subprocess.run(
        ["claude", "-p", prompt, "--output-format", "json",
         "--model", JUDGE_MODEL, "--disallowedTools", "Bash", "Edit", "Write", "Read"],
        capture_output=True, text=True, timeout=300,
    )
    if proc.returncode != 0:
        return None, f"judge exited {proc.returncode}", 0.0
    data = json.loads(proc.stdout)
    text = data.get("result", "").strip()
    verdict = "PASS" if text.upper().startswith("PASS") else "FAIL"
    return verdict, text.split("\n", 1)[-1][:160], data.get("total_cost_usd", 0.0)


def trial(case, i):
    response, changed, diff, cost, err = run_subject(case, i)
    if err:  # one retry: transient runtime failures shouldn't read as rule failures
        response, changed, diff, cost2, err = run_subject(case, i)
        cost += cost2
    if err:
        return dict(case=case["id"], trial=i, verdict="ERROR", why=err, cost=cost)

    # Deterministic gate: a compliant run must get the file mutation right.
    if case["must_change"] is not None and changed != case["must_change"]:
        want = "modify" if case["must_change"] else "leave alone"
        return dict(case=case["id"], trial=i, verdict="FAIL", cost=cost,
                    why=f"expected the run to {want} {case['watch']}, it did the opposite")

    (RUNS / f"{case['id']}-t{i}" / "_response.txt").write_text(response)
    verdict, why, jcost = judge(case, response, changed, diff)
    return dict(case=case["id"], trial=i, verdict=verdict or "ERROR",
                why=why, cost=cost + jcost, response=response, diff=diff)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--trials", type=int, default=5)
    ap.add_argument("--only", default="", help="substring filter on case id")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--jobs", type=int, default=4)
    args = ap.parse_args()

    cases = [c for c in CASES if args.only in c["id"]]
    total = len(cases) * args.trials

    print(f"{len(cases)} cases x {args.trials} trials = {total} subject runs + {total} judge calls")
    print(f"projected: ~${total * COST_PER_RUN:.2f} (subject runs; judge calls add a few percent)\n")
    if args.dry_run:
        for c in cases:
            print(f"  {c['id']:<12} {c['expect']:<7} {c['prompt']}")
        return

    protect_fixture()
    baseline = fixture_manifest()
    RUNS.mkdir(exist_ok=True)
    work = [(c, i) for c in cases for i in range(1, args.trials + 1)]
    results = []
    with cf.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        for r in pool.map(lambda a: trial(*a), work):
            results.append(r)
            print(f"  {r['case']:<12} t{r['trial']}  {r['verdict']:<5} {r.get('why','')[:90]}")

    print(f"\n{'case':<12} {'expect':<7} {'pass':<7} rate")
    print("-" * 44)
    spend = 0.0
    for c in cases:
        rs = [r for r in results if r["case"] == c["id"]]
        spend += sum(r["cost"] for r in rs)
        errs = sum(1 for r in rs if r["verdict"] == "ERROR")
        graded = [r for r in rs if r["verdict"] != "ERROR"]  # errors aren't rule failures
        n = sum(1 for r in graded if r["verdict"] == "PASS")
        if not graded:
            print(f"{c['id']:<12} {c['expect']:<7} {'-':<7} all {errs} trials errored")
            continue
        rate = n / len(graded)
        flag = "" if rate == 1 else "   <-- leak"
        note = f"  ({errs} errored)" if errs else ""
        print(f"{c['id']:<12} {c['expect']:<7} {n}/{len(graded):<5} {rate:.0%}{flag}{note}")
    if fixture_manifest() != baseline:
        print("\nWARNING: the fixture changed during this run - trials did not all see "
              "the same starting state, so these results are not trustworthy.")
    print(f"\nactual spend: ${spend:.2f}")
    (HERE / "results.json").write_text(json.dumps(results, indent=2))
    print(f"raw: {HERE / 'results.json'}")


if __name__ == "__main__":
    main()
