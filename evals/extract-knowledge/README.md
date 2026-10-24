# extract-knowledge eval

An eval set and scoring kit for the `extract-knowledge` skill: a shared link in, a fast and faithful knowledge extraction out.

## Layout
- The live skill is at `skills/produto/extract-knowledge/SKILL.md` in the repository root. `history/` holds earlier versions used during tuning.
- `cases/<id>/`: the full source as read (post JSON, transcripts, article text, images, repo metadata) plus `gold.md`. Each gold file lists 3-7 key points, the claim-vs-framing splits, 3-5 must-answer questions, and known traps.
  - Tuning cases:
    - `c1-guille`: X post with video
    - `c4-theo`: X long-form article with diagrams
    - `c5-orca`: GitHub README plus API metadata
    - (2 cases with proprietary content excluded from public repo)
  - Held-out case: `h1-langchain-evals`, a blog post not used during tuning.
- `outputs/v1`, `outputs/v2` (first revision), `outputs/v3` (final): one extraction per case.
- `rubric.md`: 8 criteria scored 0-2, plus a hard-fail rule and length budgets.
- `check.py`: mechanical checks for unverifiable quotes, paraphrased quotes, unsourced numbers, and body word count.
- `scores/`: per-version tables, critiques, failure patterns, pairwise notes, and the held-out result.

## How to rerun
1. Run the skill on each case, reading only the files in `cases/<id>/`. The links are in each `gold.md` header and in the eval request. Save the output to `outputs/<version>/<case>.md`. For a fair run, use a fresh agent that hasn't seen `gold.md`.
2. Run the mechanical check:
   `for c in cases/*/; do n=$(basename $c); python3 check.py outputs/<version>/${n%%-*}.md $c; done`
   Every flag needs a manual decision. `PARAPHRASED-QUOTE` and `QUOTE-NOT-IN-SOURCE` usually mean the quote was misquoted or is a scare quote. `UNSOURCED-NUMBER` means the number was invented or is a labeled estimate.
3. Judge each output against its source and `gold.md` with `rubric.md`. Use a fresh, skeptical judge, ideally a different model or a person. Do claim-by-claim faithfulness first, then the gold key-point and question coverage, then the remaining criteria. Any fabricated quote, number, name, or timestamp is a hard fail.
4. For subjective quality, compare two versions pairwise and read them in both orders. Treat a disagreement between the two orders as a tie.
5. Add a fresh held-out link each time you change the skill.

## Caveats
- The same agent wrote the gold files, generated the outputs, and judged them. The gold files were written before any output, and the quote and number checks are mechanical, but the rubric scores are still self-judged. The next step is an independent judge (another model or a PM with domain expertise) on a sample of cases.
- Five tuning cases and one held-out case are a small set. Treat the score gains as directional, apart from the hard-fail and misquote findings, which `check.py` verifies.

## Methods this follows
- FineSurE (ACL 2024): sentence-level fact checking plus keyfact alignment.
- LongSumEval (2026): question-based coverage.
- Hamel Husain's LLM-judge guide: binary or low-cardinality judgments with critiques.
- Eugene Yan on LLM evaluators: direct scoring for objective criteria, pairwise for subjective ones.
