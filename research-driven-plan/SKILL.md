---
name: research-driven-plan
description: Produces a structured research markdown document that prepares the next agent to write an implementation plan. Covers frontend, backend, aesthetic/design, and scientific research project tasks. Includes up-front clarifying questions, web search of frontier similar products or papers with pain-point analysis, trade-off tables, and citations to code repositories and online articles. Use when the user asks to research, investigate options, do tech selection, propose architectures, compare approaches, or when a task is large or ambiguous enough that jumping straight to code risks wasted work.
---

# Research-Driven Plan

Turn an ambiguous user request into a research markdown doc that the next agent (or the same agent in the next turn) can read and produce a concrete implementation plan from, without needing to re-ask questions or re-do searches.

## When to use

Apply this skill when any of the following is true:

- User literally says: research, investigate, compare, explore options, tech selection, architecture, 调研, 研究, 对比
- Task involves picking between 2+ frameworks, libraries, algorithms, or design directions
- Task spans frontend + backend + data, or touches aesthetic choices, or is scientific in nature (method selection, experiment design, literature review)
- User's request contains misconceptions that need to be checked against current reality before committing to a direction
- The scope is large enough that an implementation attempt without research would likely need to be thrown away

Do NOT apply for:

- Trivial edits (rename a variable, add a comment)
- Tasks where requirements are fully specified and the only unknown is how to type the code
- Pure debugging where the task is to find a single known-wrong line

## The 5-phase workflow

Copy this checklist and track progress in the conversation:

```
- [ ] Phase 1: Clarify — ask structured questions before searching
- [ ] Phase 2: Context — read project-local files that constrain the answer
- [ ] Phase 3: Frontier search — find current state-of-art, competitors, papers
- [ ] Phase 4: Synthesize — trade-off tables, honest corrections, cost analysis
- [ ] Phase 5: Output — write research.md from the template, commit if in a repo
```

Do NOT skip phases. Skipping Phase 1 is the single most common failure mode: it leads to thorough research in the wrong direction.

---

## Phase 1: Clarify

Before any search, resolve ambiguities that would change the research direction.

### Default to the structured AskQuestion tool when available

Bundle 3-5 decisions into one AskQuestion call. Avoid one-question-at-a-time ping-pong.

Each question needs:
- A `prompt` naming the decision the answer will unblock (e.g. "Billing model — decides auth complexity")
- 3-5 concrete options that are meaningfully different (not "yes/no/maybe")
- At least one option phrased as "let the agent decide" for when the user doesn't care

### What to always ask before researching

1. **Scope boundary**: "Is this frontend only, full-stack, or includes data/infra?"
2. **Constraint you must respect**: "Is there an existing stack/vendor/budget to fit into?"
3. **Deliverable form**: "Do you want a markdown doc, a doc + scaffold code, or something else?"
4. **Depth/time budget**: "Quick scan (1 doc, ~30 min) or thorough (multi-doc with prototype)?"
5. **Audience of the output**: "Is this for you, a team, or a future agent to hand off to?"

### When NOT to use AskQuestion

- If the user explicitly says "don't ask, just go" — respect it
- If AskQuestion is not in the tool set — ask conversationally, still bundle questions
- If there is literally only one sensible interpretation — just proceed

### Respect for user expertise cues

If the user reveals they are a fan of a specific person/tool (e.g. "I'm a fan of X and Y"), a domain expert, or that they've already rejected certain options, lean into those signals. Do not pretend to be neutral when the user has already expressed a strong preference — but also do not sycophantically agree if their preference is technically incorrect.

---

## Phase 2: Gather project context

Before going to the web, ground yourself in the repo.

### Always read (if present)

- `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `.github/copilot-instructions.md` — project-level agent instructions
- `README.md` — product intent
- `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `requirements.txt` — current stack
- Any `ARCHITECTURE.md`, `docs/` folder — prior decisions

### Check the live state

- `git status`, `git log --oneline -20` — what's recent, what's WIP
- Current running processes, recent terminal activity if accessible
- Entry-point files (e.g. `main.py`, `index.html`, `src/index.ts`) — scan, don't read fully

### What to extract

- **Invariants**: things the research output must NOT break (user workflows, existing data shapes, API contracts)
- **Assumptions the user made**: often encoded in file organization or naming
- **Style/tone**: if docs are in Chinese, write the research doc in Chinese; if code comments follow a specific convention, honor it in any code snippets

---

## Phase 3: Frontier search

Use `WebSearch` (or the equivalent) to find current state. This is where "research" earns its name.

### Year-tag every query

Agents' training data is often 6-18 months stale. Current year must appear in queries for time-sensitive topics (frameworks, APIs, model versions, pricing, TOS).

```
Good:  "OpenAI Realtime API WebRTC authentication 2026"
Bad:   "OpenAI Realtime API WebRTC authentication"
```

### Run 3-5 parallel searches

Batch the searches into a single tool-call turn. Cover these angles:

1. **Official docs** — primary source of truth, check for latest version
2. **Competitors / similar products** — what do they do, what do users complain about
3. **Papers / RFCs** — for scientific or protocol-level work, hit arxiv / IETF / relevant venues
4. **Community opinion** — Hacker News, Reddit, X, dev.to, personal blogs from credible people
5. **Known-misconception check** — if the user assumed something, search to verify/refute it

### What to record for each finding

For every useful source, note:

- Canonical URL (not shortened, not tracking-wrapped)
- Publication or last-update date
- One-sentence summary of the relevant claim
- Whether it's **primary** (docs, source code, author) or **secondary** (blog, aggregator)

These become the citations in the final `research.md`. Missing citations = finding will be silently dropped from the output.

### Specifically for each domain

**Frontend**: look for design system references (shadcn/ui, Radix, Base UI, Arco Pro), real-world inspiration (awwwards, mobbin, godly), accessibility patterns (WAI-ARIA, inclusive components), perf benchmarks.

**Backend**: look for reference architectures from companies at your scale tier (engineering blogs from Stripe, Linear, Cal.com, Discord, Cloudflare), framework benchmarks (TechEmpower), ORM/DB tradeoffs, hosting cost calculators.

**Aesthetic/design**: look for named design movements (editorial, brutalist, neo-geo), typography references (Fonts in Use, Typewolf), color systems (Tailwind v4 palette, Radix Colors, Apple HIG), anti-AI-slop principles (explicitly search "not generic AI aesthetic").

**Scientific research**: arxiv search for the last 12 months on your topic, cite-by-paper on Semantic Scholar / Papers With Code for benchmarks, check if method has open-source implementation, note limitations sections from recent papers.

### Dig into similar products' **pain points**, not just features

Every similar-product search should answer:

1. What do they get right (to copy)?
2. What do users complain about (to avoid)?
3. What do they NOT offer that we could own (differentiation)?

Source pain points from: app store reviews, "alternatives to X" posts, G2/Trustpilot summaries, GitHub issues tagged "enhancement" or "bug" in open-source competitors.

---

## Phase 4: Synthesize

### Correct misconceptions honestly

If research contradicts the user's assumption, say so directly, but give partial credit where it's due. Structure:

1. "You were right that A."
2. "You were wrong that B — here's the evidence: <citation>."
3. "Net effect on your plan: <concrete change>."

Do not soften the correction into vagueness. Do not gloat.

### Build trade-off tables, not paragraphs

Any decision with 2+ options gets a table:

```markdown
| Option | Pros | Cons | Best when |
|---|---|---|---|
| A      | ...  | ...  | ...       |
| B      | ...  | ...  | ...       |
```

Bias toward **one recommendation** at the end of each table. "It depends" is allowed only when you genuinely cannot pick without more user input — in which case return to Phase 1 and ask.

### Put concrete numbers on fuzzy choices

- Cost: per month, per 1k users, per request
- Latency: p50 / p99
- Time to implement: days, by phase
- Bundle size, memory, cold start

Missing numbers = reader will supply their own (usually too optimistic).

### Draw architecture diagrams in ASCII

Keep them simple and greppable. Avoid mermaid unless the doc will be rendered in a viewer known to support it.

```
┌──────────┐     ┌──────────┐
│ Client   │────►│ BFF      │
└──────────┘     └─────┬────┘
                       ▼
                ┌──────────┐
                │ DB       │
                └──────────┘
```

### Propose a phased rollout

End every research doc with an implementation roadmap. Each phase:

- Has a clear exit criterion ("cards list page renders from tRPC")
- Has a rough time estimate (hours or days)
- Has explicit dependencies on prior phases
- Can be cut without blocking the next (so the user can stop anytime)

---

## Phase 5: Output the research.md

### File location

- If the project has a `docs/` folder, write to `docs/<slug>-research.md`
- Otherwise, write to the repo root as `<slug>-research.md`
- Slug is kebab-case, descriptive: `frontend-stack-research.md`, `vector-db-choice-research.md`, `attention-variant-research.md`

### Follow the template

Use `research-template.md` (in this skill's directory) as the structure. Fill every section or explicitly mark `N/A — <reason>`. Do not leave blank headings.

### Citation rules

- **Every non-trivial factual claim** needs a citation: `[Source Name](URL)` or `[Paper Title, Authors, Year](URL)`
- **Code references** in the research must include the repo URL: `[calcom/cal.com](https://github.com/calcom/cal.com)` (optionally with a path and line range if pointing to a specific file)
- Bundle sources into a **References** section at the end, numbered, so readers can audit
- If the research includes a quote, it must be a real quote with source; do not paraphrase-as-quote

### Commit if in a repo

After writing the doc:

1. `git status` to confirm only expected files changed
2. Stage only the new doc (not incidental files)
3. Commit with a clear message: `docs: research for <topic>`
4. If pushing, confirm branch and remote before push

Do not create commits unless the user asked or the project convention clearly expects it.

---

## Domain-specific addenda (apply per task type)

### Frontend task

- Include a "UI aesthetic direction" section with one bold choice (editorial / brutalist / organic / etc.) — never "modern and clean" alone
- Reference specific fonts, colors, and spacing tokens, not just vibes
- List things to explicitly NOT do (anti-AI-slop rules)
- If the task is a redesign, include before/after of the mental model

### Backend task

- Include a data model sketch (tables or schemas), even if rough
- Include a failure modes table (what happens if DB is slow, cache is cold, external API is down)
- Put throughput / latency targets in numbers
- Include the deploy target (Vercel / Fly / self-hosted / k8s) and its implications

### Aesthetic / design task

- Collect 3-5 reference images or live sites (cite with URLs)
- Name the concrete movement or era you're drawing from
- List the ONE memorable element users should remember about the design
- Include a "keep / kill / invent" summary of the current design if redesigning

### Scientific research / ML method task

- Include a literature review subsection: last 12 months, grouped by approach
- Identify the specific gap you're filling, in one sentence
- Propose a measurable success criterion (metric + target) before proposing method
- Include a simplest-possible baseline you must beat before claiming novelty
- If reproducing a paper, link paper + any open-source implementation found

---

## Anti-patterns (do not do)

1. **Research before clarifying**. Solves the wrong problem efficiently.
2. **Link dump without commentary**. A bare URL is not research; the value is the synthesis.
3. **"Modern and clean" design direction**. Meaningless. Pick something.
4. **Picking 3 options and refusing to recommend**. You have more context than the user thinks; commit.
5. **Citing the training data**. If you can't find a URL, flag the claim as "unverified" or drop it.
6. **Letting the research doc mention the original user's private details unnecessarily**. Keep the output reusable — the next agent might be a different model or context.
7. **Never checking whether the user's assumption was correct**. When the user proposes an approach, verify it exists and works, especially for rapidly-evolving APIs.

---

## Calibration: quick vs thorough

Adjust effort to the scope signal:

| Signal | Treatment |
|---|---|
| User says "quick look" or "just a sanity check" | 1-2 searches, short doc (1 page), no architecture diagrams |
| User says "research" or "调研" without qualifier | Full 5-phase, 3-5 pages of markdown |
| User says "deep dive" or "comprehensive" | Full 5-phase + prototype + explicit risk matrix + 10+ citations |
| User is deciding between 2+ paid products | Include a cost table with monthly spend scenarios |
| User mentions an interview or resume context | Include a "talking points" section so the decision is also defensible verbally |

---

## Reference files in this skill

- `research-template.md` — the exact structure to fill when writing the output doc

---

## Summary

The output of this skill is always a single markdown file that lets the next agent skip Phase 1-4 and go straight to planning/building. Judge your work by: can a fresh agent, given only this doc, produce a correct implementation plan without asking the user anything? If yes, the skill was applied well.
