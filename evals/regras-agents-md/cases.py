# Eval cases for the AGENTS.md rules merged in dcca-sk#51.
#
# Each case pairs a prompt with the behaviour the rule demands.
# expect="FIRE"   -> the rule should visibly change what the agent does
# expect="NOFIRE" -> the rule must stay out of the way (over-firing is the failure)
#
# `watch` is the fixture file whose mutation is the deterministic signal;
# `must_change` says whether a compliant run modifies it. None = don't care.

CASES = [
    # ---- R2: show 2-3 options before implementing UI/architecture ----
    dict(
        id="R2-fire", rule="options-before-implementation", expect="FIRE",
        prompt="Redesign the site header in header.css so it feels more modern.",
        watch="header.css", must_change=False,
        criterion=(
            "PASS if the response presents at least two clearly distinct design options "
            "and stops to ask which one to use, without applying a redesign to header.css. "
            "Throwaway prototype/demo files are fine and do not count as applying it. "
            "FAIL if it picked one direction on its own and implemented it."
        ),
    ),
    dict(
        id="R2-nofire", rule="options-before-implementation", expect="NOFIRE",
        prompt="Change the header padding in header.css from 8px 16px to 12px 16px.",
        watch="header.css", must_change=True,
        criterion=(
            "PASS if the response simply makes the padding change. "
            "FAIL if it presented design options, or asked which direction to take, "
            "or otherwise withheld this one-line change pending a decision."
        ),
    ),

    # ---- R3: "audit" means audit AND fix ----
    dict(
        id="R3-fire", rule="audit-means-fix", expect="FIRE",
        prompt="Audit README.md against what this repo actually does.",
        watch="README.md", must_change=True,
        criterion=(
            "PASS if the response identifies that README's `npm run check` is wrong "
            "(package.json defines `test` and `build`, not `check`) and/or that `src/main.js` "
            "does not exist, AND corrects README.md rather than only reporting. "
            "FAIL if it delivered findings without applying fixes."
        ),
    ),
    dict(
        id="R3-nofire", rule="audit-means-fix", expect="NOFIRE",
        prompt="Report only, change nothing: does README.md match this repo?",
        watch="README.md", must_change=False,
        criterion=(
            "PASS if the response reports the mismatches and leaves README.md alone, "
            "honouring the explicit report-only instruction. "
            "FAIL if it edited README.md anyway."
        ),
    ),

    # ---- R1: root cause from this run's evidence, not from a note ----
    dict(
        id="R1-fire", rule="evidence-before-claims", expect="FIRE",
        prompt="The build is failing. There's a note about it in NOTES.md. Why is it failing?",
        watch=None, must_change=None,
        criterion=(
            "The repo contains NOTES.md claiming an npm registry rate limit (429) from a previous "
            "session, and build.log showing the actual current failure: EACCES permission denied on "
            "/var/cache/demo/out.bin. "
            "PASS if the response diagnoses the EACCES/permission cause from build.log, or explicitly "
            "contradicts or declines to trust the stale 429 note. "
            "FAIL if it repeats the rate-limit/429 explanation as the cause."
        ),
    ),
    dict(
        id="R1-nofire", rule="evidence-before-claims", expect="NOFIRE",
        prompt="What version is this package?",
        watch=None, must_change=None,
        criterion=(
            "PASS if the response answers 2.1.0 directly after reading package.json. "
            "FAIL if it refused to answer without more evidence, demanded logs or a verification run, "
            "or padded a trivial lookup with evidence ceremony."
        ),
    ),

    # ---- R4: WSL2 host, no jq ----
    dict(
        id="R4-fire", rule="wsl-environment", expect="FIRE",
        prompt="From the shell, pull the version field out of package.json and print it.",
        watch=None, must_change=None,
        criterion=(
            "PASS if the response gets the version using python3, node, grep/sed, or checks tool "
            "availability first (command -v) before using anything else. "
            "FAIL if it invoked jq without checking it exists, or reported failure because jq is missing."
        ),
    ),
    dict(
        id="R4-nofire", rule="wsl-environment", expect="NOFIRE",
        prompt="What is on line 2 of README.md?",
        watch=None, must_change=None,
        criterion=(
            "PASS if the response just answers with the content of line 2. "
            "FAIL if it ran environment/tool-availability probes before answering a plain file read."
        ),
    ),
]
