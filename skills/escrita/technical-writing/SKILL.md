---
name: technical-writing
description: 'Use when writing or reviewing docs, PRDs, RFCs, specs, READMEs, PR descriptions, or commit messages, to apply a layered clear-writing standard (Diátaxis, Google developer style, STE, Global English).'
---

# Technical writing

Adapted from pstack's `technical-writing` skill (github.com/cursor/plugins, pstack/skills/technical-writing, commit 190d287, MIT License, (c) 2026 Lauren Tan).

Write so a tired reader understands on the first read. Apply all four layers.

Three rules sit above the layers:

- **Cut every word that does no work.** "In order to" is "to". "It is important to note that" is nothing.
- **Use the short, everyday word.** "Use", not "utilize". "Help", not "facilitate". A long word has to buy its length with precision.
- **When a rule makes a sentence worse, fix the sentence another way or leave it alone.** A sentence that follows every rule and sounds like a machine wrote it has failed.

The system is the word list. Write the real symbol, file, flag, command, field, or product name, not a synonym or a description of it.

Don't invent jargon. A named pattern is fine when the doc says what it means the first time.

## Vary the rhythm

- Mix sentence lengths on purpose. Short sentences land a point. Longer ones carry a fact with its condition or consequence.
- Split the sentence that carries two thoughts. Keep the long sentence that carries one.
- Have a view where the mode allows it. Explanation weighs trade-offs, so say what you make of them. Reference stays dry.
- Be specific over sterile. Not "schema changes can cause issues" but "a column rename fails the build".

## Pick the mode first (Diátaxis)

One document, one mode. Does the content inform action or understanding, and does it serve learning or work?

- Action + learning: **tutorial**.
- Action + work: **how-to**.
- Understanding + work: **reference**.
- Understanding + learning: **explanation**.

**Tutorial.** The learner's success is your job. Open by saying what they will build. Every step produces a visible result; tell them what they should see. Keep explanation to one clause and a link. Write as "we", in commands.

**How-to.** Solve a problem a person has. Assume competence. Action only; link background instead. Allow forks: "If you want x, do y." Name it by the task.

**Reference.** Only describe. No instruction, persuasion, or opinion. Be dry, complete, and sure. Mirror the structure of the thing described.

**Explanation.** One bounded topic anchored on a real why question. Give context: decisions, history, constraints, alternatives. Opinion is allowed here and nowhere else.

Don't mix modes. Split and link instead. A PRD or spec usually pairs an explanation (problem, why, trade-offs) with a reference (requirements, rules, metrics); keep them in separate sections.

## Write sentences to the reader (Google developer style)

- Talk to the reader as "you", in the present tense.
- Say who does what: "the engine checks", not "is checked".
- Write instructions as commands. State facts plainly. Never "should be done".
- Put the condition before the instruction: "To delete the document, click Delete."
- Put the common case first, exceptions after.
- No buzzwords, no figurative language, no "please" in instructions, and never "simply", "easy", or "quickly" in a procedure.
- Don't pre-announce, and don't start consecutive sentences with the same phrase.
- Link text says where the link goes. Never "click here".
- Headings carry the point, not just the topic. Sentence case. One h1 per page, no skipped levels.
- Numbered lists for sequences, bullets for everything else. Introduce a list with a complete sentence. Keep items parallel.
- Code in code font, UI elements in bold, serial commas, no "etc.".

## Make statements load one at a time (STE rules)

- One instruction per sentence. One thought per sentence everywhere else.
- Split instructions longer than about 20 words and other sentences longer than about 25.
- Put the warning or condition before the step it guards.
- Keep "the" and "a".
- Give each word one meaning, and pick one word per action and stick to it.
- Write procedures as direct commands, never narration or passive.
- Avoid "-ing" words where you can.

## Leave no sentence open to two readings (Global English)

- Keep "only" and "not" next to the word they change.
- Break up long noun strings.
- Make every "it", "they", and "this" point at one obvious thing. Repeat the noun when in doubt.
- Don't drop verbs from parallel clauses.
- Keep the small structural words, such as "that".
- Use periods, not semicolons. Replace an em dash with a new sentence.
- Parenthetical text is a full grammatical unit or its own sentence. Never form plurals with "(s)".
- No slashes: write "a, b, or both".
- Call each thing by one name, everywhere.
- Skip idioms, Latin abbreviations, and metaphors.

## Voice and specifics

- Run the **unslop** skill on every doc this skill touches.
- PR descriptions and commit messages are writing too. Every layer except Diátaxis applies. A PR body is a briefing a reviewer can read in under a minute; link logs and tables instead of pasting them.
- Product UI strings follow the product's own copy guidelines, not this skill.
- Make every count or claim true at the time it ships, and say where the number comes from.

## Worked example

Before:

> Configuration of the proto import ratchet budget script parameters is performed via budget.json. Note that it's important to remember that running with --write, which updates the committed budget to reflect the current count, should only be done when lowering it. If exceeded, CI fails.

After:

> `budget.mjs` reads the committed budget from `budget.json` and counts the files that import protos. If the count exceeds the budget, CI fails. Run `budget.mjs --write` only to lower the budget.
