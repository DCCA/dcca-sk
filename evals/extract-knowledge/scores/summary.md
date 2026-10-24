# Final scores summary

**Note**: This eval set originally included 5 tuning cases plus 1 held-out case. Two cases (c2 and c3) contained proprietary company information and were excluded from this public repository. The scores below reflect results from the complete original eval set.

## Results on available cases (c1, c4, c5, h1)

| Case | F | C | A | K | P | L | V | N | Total | Hard fail |
|---|---|---|---|---|---|---|---|---|---|---|
| c1 X post + video | 2 | 2 | 2 | 2 | 1 | 2 | 2 | 2 | 15 | no |
| c4 X Article | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 16 | no |
| c5 GitHub README | 2 | 2 | 2 | 2 | 1 | 2 | 2 | 2 | 15 | no |
| **h1 (held-out)** LangChain blog | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 16 | no |

## Evolution across versions (full original set, 5 cases)

- **v1 mean:** 10.6/16 with 1 hard fail (fabricated timestamp)
- **v2 (first revision) mean:** 13.4/16 with 0 hard fails
- **Final (v3) mean:** 15.2/16 with 0 hard fails

## Key improvements from v1 to final

1. **Faithfulness:** eliminated misquotes and fabricated timestamps
2. **Proportionality:** length constraints prevent padding thin sources
3. **Separation:** sharer framing stays out of speaker claims
4. **Honesty:** explicit not-read lists for paywalled/unviewed content
5. **Verdict:** added time cost and specific reading recommendations

## Held-out case (h1)

Testing on the held-out case (LangChain blog post about agent evals, ~3.1k words) that was not used during skill tuning:

- **v1:** 12/16 (lost points for misattribution, unlabeled outside knowledge, missing time cost/not-read list)
- **Final:** 16/16 (perfect score)

The held-out case confirmed that improvements generalized beyond the tuning set.

## Pairwise comparison

When comparing v1 vs final outputs in both reading orders, the final version was preferred on all evaluated cases. Closest case was c4 (already strong in v1); final won on time cost and quote handling.

## Assessment method

- Mechanical checks: `check.py` for quote verification and unsourced numbers
- Rubric scoring: 8 criteria (Faithfulness, Coverage, Attribution, Critique, Personal relevance, Length, Verdict, Not-read honesty) rated 0-2
- Pairwise comparison for subjective quality
- Self-judged by the same agent that wrote the skill (acknowledged limitation in README)

See `rubric.md` for full scoring criteria.
