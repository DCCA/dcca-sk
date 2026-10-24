---
name: unslop
description: 'Use before publishing or delivering any written text (summaries, docs, newsletters, write-ups) to strip AI-writing tells; applies to English and Brazilian Portuguese.'
---

# Unslop

Adapted from pstack's `unslop` skill (github.com/cursor/plugins, pstack/skills/unslop, commit 190d287). See THIRD_PARTY_NOTICES.md in the repository root for the full MIT License text.

Edit text to remove AI patterns. Scan for the patterns below, then rewrite. Preserve meaning, facts, numbers, links, and the intended tone. For Brazilian Portuguese text, apply the same rules with the natural pt-BR equivalents (for example "além disso", "crucial", "fundamental", "no cenário atual", "vale ressaltar que").

## Patterns to detect and fix

Rule numbers are stable ids. A removed rule leaves a gap.

### Content

3. **Superficial -ing phrases.** "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...". Delete, or expand with the real fact or source.
5. **Vague attributions.** "Experts believe", "Industry reports suggest", "Some critics argue". Name the source or delete.

### Language

7. **AI vocabulary.** Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape (abstract), pivotal, showcase, tapestry (abstract), testament, underscore, vibrant. Replace with plain words.
8. **Fancy ways to say "is".** "serves as", "stands as", "boasts", "features". Say "is" or "has".
9. **"Not just X, but Y."** State the point directly.
10. **Rule of three.** Don't force ideas into groups of three. Use the natural number.
11. **Synonym cycling.** Pick one name for a thing and repeat it.
12. **False ranges.** "from X to Y" where X and Y aren't on a meaningful scale. List the topics directly.

### Style

13. **Dash overuse.** Use em dashes rarely; prefer periods or commas. Don't swap them for en dashes or hyphens used as dashes. If a thought needs separation, end the sentence.
14. **Colon overuse.** Colons are fine before a list or example, not as mid-sentence connectors.
15. **Boldface overuse.** Don't bold every proper noun or acronym.
16. **Inline-header lists.** A bold label plus colon that restates the line ("**Performance:** Performance improved...") becomes prose. A bold lead-in that names the item and is followed by genuinely new detail is fine.
17. **Title case headings.** Use sentence case.
18. **Decorative emojis.** Remove from headings and bullets.
19. **Curly quotes.** Use straight quotes in code, data, and JSON.

### Communication artifacts

20. **Chatbot phrases.** "I hope this helps!", "Let me know if...", "Of course!", "Certainly!". Remove.
22. **Sycophantic tone.** "Great question! You're absolutely right!" Respond directly.

### Filler

23. **Filler phrases.** "In order to" becomes "To". "Due to the fact that" becomes "Because". Delete "It is important to note that".
24. **Excessive hedging.** "could potentially possibly be argued that it might" becomes "may".
25. **Generic conclusions.** "The future looks bright." State specific plans or facts.

### Jargon

26. **Abstract metaphor nouns.** Substrate, wedge, vector (meaning way), locus, vantage, nexus, primitive as a noun, harness as a metaphor, surface as in "API surface", bedrock, scaffolding as a metaphor, modality, paradigm, gold-plating, ratchet as a metaphor, endgame, north star, flywheel. Pick the concrete word.

### Plain speech

27. **Say what it does, not how it feels.** Name the mechanism or a number. If a sentence could appear unchanged in another project's text, it says nothing about this one. Cut it.
28. **Shorten or split dense sentences.** One idea per sentence.
29. **Active voice.** Name the actor. Passive only when the actor is unknown or doesn't matter.
30. **Cut adverbs, or use a stronger verb.** "significantly improves" becomes the measured delta.
31. **Prefer the plain word.** "utilize" and "leverage" become "use"; "facilitate" becomes "help".
32. **Mannered prose.** Aphorisms, rhetorical fragments, personified code, figurative verbs. Say it literally.
33. **Over-compression.** Dropped articles, verbless fragments, arrows, and symbol-speak. Write whole sentences.

## How to apply

1. Read the draft once and mark every hit by rule number.
2. Rewrite the marked sentences. Never change facts, quotes, numbers, names, or URLs.
3. Re-read the result once for meaning and tone, and keep any required format (structured fields, schemas, length limits).
