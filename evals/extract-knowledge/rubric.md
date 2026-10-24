# Rubric: extract-knowledge outputs

Score each criterion 0-2 (0 = fails, 1 = partial, 2 = meets the bar). Max 16 per case.
Judge with the source files and gold.md open. First run `python3 check.py <output> <case_dir>` and resolve every flag by hand.

**HARD FAIL** (case fails regardless of score): any fabricated quote, number, name, timestamp, or event that is not in the source and not clearly labeled as the extractor's own estimate. A paraphrase inside quotation marks that changes the wording of a key claim counts as a misquote: score faithfulness 0, but it is not a hard fail unless it changes the meaning.

| # | Criterion | 2 | 1 | 0 |
|---|---|---|---|---|
| F | Faithfulness (claim-level) | Every factual sentence is supported by a source line; quotes are verbatim; garbled or inconsistent passages are flagged, not resolved silently | 1-2 minor issues: overstated paraphrase, quotation marks around paraphrase, a soft unsupported premise | Misquote of a key claim, misattribution, or several unsupported claims |
| C | Coverage of gold key points + must-answer questions | >=80% of gold key points and all must-answer questions answerable from the extraction alone | 50-79%, or one must-answer question not answerable | <50% |
| A | Claim vs framing vs evidence separation | Speaker, sharer/host, ads, and evidence kept apart; no sharer framing leaks into other sections as fact | Separation present but incomplete or leaks once | Mixed up or absent where needed |
| K | Critique quality | Specific to this source (missing evidence, incentive, concrete counterpoint); credits solid parts; premises come from the source or are marked as general knowledge | Partly generic, or one unsupported premise | Reflexive or absent |
| P | Personal relevance | 1-3 implications tied to a named project/decision of the reader AND to what the source actually says | Tied to the reader's area but generic, or one implication not grounded in the source | Generic or absent when context exists |
| L | Concision proportional to source | Within the length budget for the source type; no padding; no repetition across sections | Up to ~1.5x budget or some padding | >1.5x budget, or longer than the source |
| V | Verdict usefulness | Skip/Skim/Go deeper with a reason, time cost, and the part worth reading | Verdict present but missing time or pointer | Missing or misleading |
| N | Honesty about what was not read | Lists every unread part (paywall, images/video not viewed, linked originals, auto-caption quality, metadata vs content) | Partial list | Missing when something wasn't read |

Length budgets used for L (body words, excluding title):
- Short post or clip (<3 min, <500 words of source): 80-180
- Article, README, short video (<=4k words or <=20 min): 200-450
- Long podcast/video/paper (>4k words or >20 min): 450-850
- Partial/paywalled: never longer than the part read

Sources for method: FineSurE (Song et al., ACL 2024: sentence-level fact checking + keyfact alignment for faithfulness/completeness/conciseness), LongSumEval (QA-based coverage for long documents, 2026), Hamel Husain's LLM-judge guide (binary/low-cardinality judgments with written critiques), Eugene Yan on LLM evaluators (direct scoring for objective criteria like faithfulness; pairwise with order swap for subjective ones).
