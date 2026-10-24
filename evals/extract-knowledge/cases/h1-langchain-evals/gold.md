# Gold: h1 (held-out) LangChain blog, "The Most Common Questions About Agent Evals, Answered"

**Source**: https://langchain.com/blog/agent-evals-questions (Divya Santhanam, Oct 15 2026, ~3.1k words)

**Fetch instructions**: Open the blog post URL and read the full article.

## Key points
1. Start: read traces, pick one behavior, build a 10-20 example dataset from traces (dogfood if pre-prod), run a baseline experiment, add each new failure -> improvement loop.
2. Offline (dataset, pre-ship, regressions; reference outputs) vs online (live traces, no reference, code checks + judges); you need both and online failures feed the offline set. Same dataset when same behavior + evaluators; new dataset when inputs/evaluators/purpose differ.
3. Evaluator types: code, LLM judge, human review, pairwise. Targets: single step, final response, full conversation (thread), end state of an environment.
4. Trusting judges: calibrate against human scores, ask narrow questions, binary/small labeled categories instead of 1-10.
5. Benchmarks = offline evals of multi-step tasks in containerized environments scored by a test script on final state; Harbor (powers Terminal-Bench) logs to LangSmith; hill-climb, even with an agent loop (Karpathy autoresearch reference).
6. Cost of online evals: sample/filter, code checks, cheaper judge (their "Jev-as-a-Judge" experiment: $0.34 vs $28.17 for Claude Sonnet 4.6, matched human labels on every pass/fail).
7. Multi-turn: group by thread ID, score whole thread; beyond final output, check path and final state.
## Claims vs framing / evidence
- Vendor content: nearly every answer routes to a LangSmith feature; the migration and framework-agnostic sections are sales.
- Evidence: worked travel-agent example; internal uses (Deep Agents on Terminal-Bench 2.0, IssueBench) with no numbers here; the Jev comparison gives cost but no sample size in this article.
## Questions
Q1. What is the minimal way to start (how many examples, from where)?
Q2. When do you use offline vs online evals?
Q3. How do you make an LLM judge trustworthy?
Q4. How do you evaluate a multi-step agent beyond its final answer?
Q5. How do you keep online eval costs down?
## Traps
Inventing benchmark scores or sample sizes; presenting the Jev result as independent; claiming LangSmith is required.
