# Gold: c4 X Article by Theo (t3.gg), "What is a 'harness'?" (~1.4k words + 4 diagrams)

**Source**: https://x.com/theo/status/2113424203345265053

**Fetch instructions**: Open the X post URL and read the full long-form article (the "Article" tab on X). Download diagrams if analyzing images.

Source parts: post, article body, diagrams.

## Key points
1. Definition: an LLM only emits text; a harness = tools + tool-call syntax + parser that runs code + returning results to the LLM + a tool list with descriptions.
2. Interface vs harness: humans use interfaces (Claude TUI/GUI, Codex app, T3 Code); LLMs use harnesses (Claude Agent SDK, Codex CLI/App Server, Pi). Claude Code/Codex bake the harness into their apps, which causes confusion; harnesses can be reused in other apps (Cursor harness used by Grok Bot; Agents SDK + Codex App Server used by T3 Code; Pi used by OpenClaw).
3. Tools vs MCP: tools = code that runs in the harness ("tool plane"); MCP = API request to code running elsewhere ("data plane"); MCP mostly exposes data. Good harnesses let users bring their own tools; Claude Code/Codex include many tools, Pi is minimal.
4. Agent = harness + LLM (kitchen + chef); different "agents" are often just different harness configurations (tools, instructions, MCP servers).
5. T3 Code is not a harness ("restaurant" that brings any kitchen); it exposes multi-harness features (e.g., Claude Code threads spawning Codex subagents) via an MCP server instead of per-harness plugins (examples of similar tools: Herdr, Orca, Superset).

## Claims vs framing
- Definitional/explanatory piece; claims are mostly conceptual, not empirical. Analogies (kitchen/chef/restaurant/cookbook) are framing devices.
- Incentive: Theo builds T3 Code (positioned favorably; MCP choice defended) and promotes a paid Mega.dev course.
- Debatable: "Neither the human nor the LLM can see the tools" (the LLM sees tool descriptions via harness); line between tool and MCP is blurry (local stdio MCP servers run on your machine) - not mentioned by Theo. Data plane box includes memory/CLAUDE.md/AGENTS.md (diagram) without discussion.

## Questions
Q1. What are the components of a harness per Theo?
Q2. What is the difference between an interface and a harness? Give an example.
Q3. How does Theo distinguish tools from MCP?
Q4. What is an "agent" in his definition?
Q5. Why does T3 Code use MCP rather than plugins?

## Traps
- Saying Theo claims T3 Code is a harness. Adding definitions not in source. Missing the self-promotion. Over-criticizing a solid explainer.
