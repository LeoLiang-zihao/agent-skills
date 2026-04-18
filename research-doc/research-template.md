# <Topic> — Research

> Fill every section. Mark `N/A — <reason>` if a section does not apply for this task.
> Delete these instruction comments before committing.

Meta:

- **Author**: <agent name / date>
- **Status**: draft / reviewed / frozen
- **Intended next step**: <e.g. "hand off to implementation agent for Phase 0">
- **Version**: v1

---

## TL;DR

3-6 bullets. Someone reading only this block should know what the recommendation is and why.

- Recommendation: ...
- Key reason: ...
- Biggest risk: ...
- Rough cost / time: ...

---

## 1. Context

### Task as received
Exact ask in one paragraph, including any user-stated constraints or preferences.

### Current state of the project
What exists now that this research must fit with or replace. Cite files when relevant (`path/file.ext:line`).

### Out of scope
Things intentionally not researched here. Prevents scope creep and sets expectations.

---

## 2. Clarifications resolved

The decisions that were locked in during Phase 1 of the research. Each one should be a short statement, not a dialogue.

- **Scope**: <frontend only / full-stack / data-only / etc.>
- **Constraint**: <must keep existing X / must fit in Y budget>
- **Deliverable**: <markdown doc / doc + scaffold / canvas>
- **Depth**: <quick / standard / deep>
- **Audience**: <user / team / next agent>
- ...

---

## 3. Frontier landscape

### Similar products / systems

For each direct competitor or reference implementation. Keep to 3-5 entries max, drop the rest.

| Product / Project | What it does well (to copy) | Pain points (to avoid) | Notes |
|---|---|---|---|
| [Name](URL) | ... | ... | ... |
| [Name](URL) | ... | ... | ... |

### Relevant papers / specs / RFCs

Only if applicable. Include last-12-months-first for scientific work.

| Reference | Claim that matters here | Source type |
|---|---|---|
| [Title, Authors, Year](URL) | ... | paper |
| [RFC ####](URL) | ... | spec |

### Key open-source codebases worth studying

Pointers a future agent might want to open and read.

- [owner/repo](https://github.com/owner/repo) — use for reference on <specific aspect>
- [owner/repo/path/to/file.ts](https://github.com/owner/repo/blob/main/path/to/file.ts) — canonical example of <pattern>

### Differentiation opportunity

One or two sentences. What do none of the above do that this project could own?

---

## 4. Misconceptions checked

If the user's initial framing contained assumptions that research changed, record them here honestly.

- **Assumption**: "...".
  - **Reality**: ... ([source](URL))
  - **Effect on plan**: ...

Leave empty if none came up.

---

## 5. Options considered

### Option A — <short name>

- **Shape**: one-sentence description
- **Pros**: ...
- **Cons**: ...
- **Cost estimate**: ...
- **Effort estimate**: ...
- **When to pick**: ...

### Option B — <short name>

(same shape)

### Option C — <short name>

(same shape)

### Comparison matrix

| Dimension | A | B | C |
|---|---|---|---|
| Time to first demo | ... | ... | ... |
| Long-term maintainability | ... | ... | ... |
| Cost per month | ... | ... | ... |
| Learning curve | ... | ... | ... |
| Fit with existing stack | ... | ... | ... |
| Observability / debuggability | ... | ... | ... |

---

## 6. Recommendation

State the chosen option and why in 3-5 sentences. If the recommendation is conditional, state the condition.

**Chosen: Option <X>.**

Reasons:
1. ...
2. ...
3. ...

**What we are explicitly NOT doing** (and why):
- ...
- ...

---

## 7. Architecture sketch

ASCII diagram of the target system. Keep it under 30 lines.

```
┌──────────┐      ┌──────────┐
│ Client   │─────►│ BFF      │
└──────────┘      └────┬─────┘
                       │
                       ▼
                 ┌──────────┐
                 │ Store    │
                 └──────────┘
```

Walk through the diagram in 3-5 bullets. Name the components and what each owns.

---

## 8. Technical details

### Concrete stack (with current versions)

| Layer | Choice | Version | Why this over alternatives |
|---|---|---|---|
| ... | ... | ... | ... |

### Data / schema sketch

Only for backend / data tasks. Pseudo-DDL or TypeScript types.

```ts
type Thing = { ... }
```

### API / interface sketch

Only for backend / integration tasks. Pseudo-routes or function signatures.

```
POST /api/...
  body: { ... }
  returns: { ... }
```

### Aesthetic / UX direction

Only for frontend / design tasks. Include:

- Concrete design movement or reference style, not "modern and clean"
- Font pair (display + body), with links
- Color tokens (3-5 primary, 1-2 accent), in hex or CSS var names
- Spacing / radius system (e.g. "4px radius, 1.75 line-height, generous negative space")
- **One memorable element** users should remember
- **Explicit anti-patterns** to avoid ("no purple-to-pink gradient, no Inter, no 16px pill buttons")

### Failure modes

Only for backend / systems tasks.

| Failure | Symptom | Mitigation |
|---|---|---|
| ... | ... | ... |

### Success metric (scientific tasks)

| Metric | Target | Baseline to beat |
|---|---|---|
| ... | ... | ... |

---

## 9. Implementation roadmap

Each phase: exit criterion + time estimate + dependency.

| Phase | Goal | Exit criterion | Est. effort | Depends on |
|---|---|---|---|---|
| 0. Scaffold | ... | ... | 0.5d | — |
| 1. ... | ... | ... | ... | 0 |
| 2. ... | ... | ... | ... | 1 |
| 3. ... | ... | ... | ... | 2 |

Cutting point: the user can stop after any phase and still have value. Mark the first phase that produces end-user-visible value with ⭐.

---

## 10. Risks and mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| ... | low/med/high | low/med/high | ... |

Include at least: a vendor / dependency risk, a cost / scale risk, and a "user's assumption turns out to be wrong" risk.

---

## 11. Open questions

Things this research could not resolve and that the user (or a follow-up research pass) must answer before implementation starts.

- [ ] ...
- [ ] ...

If empty, state: "None — ready for implementation."

---

## 12. References

Numbered list. Every citation used above should appear here.

1. [Primary doc / main source](URL) — accessed YYYY-MM-DD
2. [Paper Title, Authors, Year](URL)
3. [Repository: owner/repo](https://github.com/owner/repo)
4. [Article / blog post title](URL) — author, date
5. ...

Prefer primary sources (official docs, source code, authors). If a secondary source (blog, forum) is the only evidence for a claim, mark it `(secondary)`.

---

## Appendix A — Glossary

Only if the doc uses jargon the next agent might not share.

| Term | Meaning |
|---|---|

## Appendix B — Raw search queries used

Useful for reproducibility / follow-up research. Include the year-tag you used.

- `"..." 2026`
- `"..." site:arxiv.org 2025..2026`
- ...
