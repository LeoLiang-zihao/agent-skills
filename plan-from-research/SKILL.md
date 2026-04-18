---
name: plan-from-research
description: "Stage 2 of the research-doc → plan-from-research → implementation pipeline. Turns an approved research.md into a concrete plan.md with phased roadmap, per-phase files-to-change list, compilable code skeletons (≤30 lines each), exact verification commands, rollback steps, a risk matrix, and a what-must-not-break compatibility section — then stops. Does NOT re-do research, write production code, or pick new architectures. If research.md is missing, draft, or has unresolved open questions, halts and routes back to research-doc. Use when the user says 'write a plan', 'write implementation plan / implementation md', 'refactor plan', '根据 research.md 写 plan', '根据研究写实现计划', '写实现方案', '写一个 plan.md'. 用来把 research-doc 产出的 research.md 转成可落地的 plan.md，下游 agent 或人类按阶段执行。Follow the 5-phase workflow inside — do not invent alternatives."
---

# Plan From Research

Turn an approved `research.md` into a `plan.md` that a separate implementation agent (or a human) can execute phase by phase without going back to the user for clarifications. Produce the plan. Stop there.

## Pipeline position

This is stage 2 of 3. Know your boundaries:

```
ambiguous request
     │
     ▼
┌─────────────────┐     👤 user reviews/edits
│ research-doc    │──► research.md ─────────────┐
│ (stage 1)       │                             ▼
└─────────────────┘                    (approved research.md)
                                               │
                                               ▼
                                    ┌────────────────────┐     👤 user reviews/edits
                                    │ THIS SKILL         │──► plan.md ──────┐
                                    │ (plan-from-        │                  ▼
                                    │  research, stage 2)│         (approved plan.md)
                                    └────────────────────┘                  │
                                                                            ▼
                                                               ┌────────────────────┐
                                                               │ implementation     │
                                                               │ (stage 3, separate │
                                                               │  agent or human)   │
                                                               └────────────────────┘
```

Hard rules while in this stage:

- **Do not re-do research.** Trade-off tables, product comparisons, misconception checks — all that belongs in `research.md`. If something is missing, halt and route the user back to `research-doc`, do not fill it in yourself.
- **Do not write production code.** Code blocks in `plan.md` are **skeletons** — type signatures, function stubs, 30-line max per block, enough for the next agent to reconstruct the intent. No business logic inside `if` branches. No filled-in LLM prompts (those are implementation).
- **Do not pick new options.** The recommendation was frozen in `research.md §6`. If the user wants to change course, halt and send them back to research.
- **Do not execute the plan.** Plan only. The implementation agent runs it.

## When to use

Trigger this skill when ALL of:

1. A `research.md` (or similar — `*-research.md`, `research/*.md`) exists in the repo.
2. The user explicitly wants a plan, e.g.:
   - "Write a plan / implementation plan / refactor plan"
   - "写一个实现计划 / 写一个 plan / 写一个 implementation md / 写实现方案"
   - "Based on this research, what do we build?" / "根据这份 research 写一下怎么做"
   - "Next step after research" / "research 完了下一步"
3. The research is approved (not `Status: draft`) OR the user explicitly says "I'm happy with the research, make a plan".

Do NOT trigger for:

- No research doc exists → send user to `research-doc` first.
- Research marked `draft` or has unresolved `## 11. Open questions` → halt and flag.
- User wants to skip research ("just write the plan") → push back once; if they insist, document the missing research as assumptions in a top-level block of the plan and proceed, but note it as a risk.
- User wants code written, not a plan → wrong skill; this only produces the plan document.

## Prerequisites (check in order, stop on first failure)

1. **Locate `research.md`.** Search in: `docs/`, `research/`, repo root, then any path the user hands you. If multiple candidates, ask which one.
2. **Verify required sections exist.** Read the research doc and confirm it has at minimum:
   - `## 6. Recommendation` with a picked option
   - `## 7. Architecture sketch`
   - `## 9. Implementation roadmap` with ≥ 2 phases
   - `## 10. Risks and mitigations`
   - `## 11. Open questions` either empty or marked "None — ready for implementation"
3. **Check status.** Frontmatter or meta block says `reviewed` or `frozen`, not `draft`. If `draft`, stop.
4. **Read `AGENTS.md` (or `CLAUDE.md`, `.cursorrules`) if present.** The plan must not violate project-wide agent rules.

If any step fails, halt, explain the gap in one paragraph, and point the user at either `research-doc` (for missing research) or a specific clarification.

---

## The 5-phase workflow

Copy this checklist and track progress:

```
- [ ] Phase 1: Intake — read research.md, verify completeness, extract the spine
- [ ] Phase 2: Ground in code — read project files that the plan must respect
- [ ] Phase 3: Decompose — expand each research-roadmap row into a full phase block
- [ ] Phase 4: Draft plan.md from plan-template.md
- [ ] Phase 5: Commit and hand off
```

Do not skip phases. Phase 3 is where plans usually fail (vague phases, no verification, no rollback) — spend the most effort there.

### Phase 1 — Intake

From `research.md`, extract these into working memory:

- **Chosen option** (§6) — the plan implements this and nothing else.
- **Architecture diagram** (§7) — the plan's §1 will reproduce it verbatim, not redraw.
- **Concrete stack + versions** (§8) — every package added in Phase 0 of the plan must come from here.
- **Roadmap rows** (§9) — becomes the spine of the plan's phases, one row → one P-block.
- **Risk rows** (§10) — carried forward into the plan's risk matrix with code-level mitigations added.
- **Open questions** (§11) — if non-empty, stop.

If the research recommends a hybrid (e.g. "use X for A, Y for B"), the plan must explicitly show which files belong to which half.

### Phase 2 — Ground in code

Read (do not edit):

- `AGENTS.md` / `CLAUDE.md` / `.cursorrules` — project invariants the plan must preserve.
- `README.md` — user-facing product intent.
- `package.json` / `pyproject.toml` / `Cargo.toml` / `go.mod` — existing deps (so Phase 0 only adds what's missing, does not duplicate).
- Entry-point files named by the research (e.g. `backend/main.py`, `src/index.ts`) — scan structure, note existing exports.
- `git log --oneline -10` — recent direction of the project.

Extract **invariants**: things the plan must not break. Common ones:

- API contracts (routes, payload shapes) that existing clients depend on.
- Data file formats (`data/*.json`, DB schemas) already in production.
- Developer workflow commands (`./start.sh`, `pnpm dev`) that are muscle memory.
- Chinese / English writing conventions in docs.
- File-naming patterns, import aliases, test layout.

These go into the plan's `§ Compatibility` section.

### Phase 3 — Decompose

For each roadmap row in research.md §9, produce one **phase block** with this exact internal structure:

1. **Header** `## Phase N — <short name>` with one-sentence goal.
2. **Exit criterion** (quote from research §9) — a single observable outcome a human can verify.
3. **Depends on** — previous phases by number.
4. **Est. effort** — carried from research.
5. **Files changed** — grouped by **Add / Modify / Delete / Move**. One line per file, ≤ 80 chars, with the purpose:
   ```
   Add      apps/web/src/server/api/routers/cards.ts   — tRPC list/get/delete
   Modify   backend/main.py                            — add /api/cards/recent
   Delete   frontend/index.html                         — replaced by Next.js
   ```
6. **Code skeletons** — for the 1–3 most load-bearing files only. Type signatures + function stubs. Fill one representative happy-path body to show shape; leave the rest as `// TODO implement in stage 3`. Keep each block ≤ 30 lines.
7. **Verification** — exact shell commands (or HTTP calls) that prove the phase is done. Something like:
   ```bash
   pnpm --filter web test -- cards
   curl -s localhost:3000/api/trpc/cards.list | jq '.result.data | length'
   ```
8. **Rollback** — how to undo this phase without breaking the previous one. Usually: git revert the phase tag, or delete N specific files. If rollback is destructive (data migration), say so.

Rules:

- Every phase must be **independently cuttable**: the user can stop at phase N and ship what's there. Mark the first end-user-visible phase with ⭐.
- Every file-level change must be **traceable to a research.md section** (cite as `(research §7)`).
- If a phase needs a user action (OAuth login, API key purchase, DNS change), mark it **prerequisite** at the top and include the exact command.

### Phase 4 — Draft `plan.md`

Use `plan-template.md` (sibling file in this skill) as the structure. Fill every section or explicitly mark `N/A — <reason>`.

File location:

- If the project has `docs/`, write to `docs/<same-slug>-implementation.md` (mirror the research doc's slug).
- Otherwise, write to the repo root as `<slug>-plan.md`.
- Example: `docs/frontend-t3-research.md` → `docs/frontend-t3-implementation.md`.

Style rules:

- Write in the **same language** as `research.md` (Chinese → Chinese, English → English). Do not mix unless the research itself does.
- Every non-trivial claim about the existing codebase cites a file + line, e.g. `backend/main.py:42`.
- Every architectural claim references the research doc, e.g. `(per research §6)`.
- No new trade-offs, no new options, no "we could also use …" asides.

### Phase 5 — Commit and hand off

1. `git status` — confirm only the new plan.md is staged (and maybe README/index updates).
2. Stage and commit:
   ```bash
   git add docs/<slug>-implementation.md
   git -c commit.gpgsign=false commit -m "docs: plan for <topic> (from <research-doc-slug>)"
   ```
3. Push only if the user asks.
4. Emit the hand-off summary (see "Output" below).

---

## Output and hand-off

When the plan is written, tell the user in ≤ 6 bullets:

1. Path to the new `plan.md` + commit SHA.
2. Research doc it was built from (path + any section that was ambiguous).
3. Number of phases + the cut-point phase marked with ⭐.
4. Any assumptions the plan had to make (only possible if research left gaps — should be rare).
5. What the **next agent** needs to start Phase 0 (prerequisite user actions, env vars, accounts).
6. Suggested first implementation step: literally "run Phase 0 step 1".

Do NOT:
- Summarize the plan's content in the chat (the plan is the deliverable).
- Start implementing Phase 0 (wrong stage).
- Offer to "also write the code" (wrong stage).

---

## Anti-patterns (do not do)

1. **Phases with no exit criterion.** "Phase 2: build the UI" — what proves it's done? Must be a shell command or HTTP call.
2. **File lists without purpose.** `src/foo.ts` alone is useless; it must say what the file is for in one line.
3. **Code skeletons that are actually full code.** If a block is > 30 lines, you are writing the implementation. Cut to signatures + one representative body.
4. **Rewriting the research.** If you find yourself typing out trade-offs, STOP. Link to `research.md §X`.
5. **Picking an option the research left open.** Halt and send the user back.
6. **Plans that assume zero failure.** Risk matrix must have ≥ 3 entries: a dependency risk, a user-assumption risk, a rollback/ops risk.
7. **Plans that break AGENTS.md invariants silently.** The Compatibility section must explicitly list each invariant and how the plan honors it.
8. **Mixing English and Chinese.** Match the research doc's language throughout.
9. **Creating a "Phase X — Polish" catch-all.** Every phase needs a concrete goal. If you can't name it, it isn't a phase.

---

## Common issues and fixes

| Symptom | Cause | Fix |
|---|---|---|
| Research has 2 viable options and §6 didn't pick | Research is unfinished | Halt, ask user to pick or route back to `research-doc` |
| Plan grows past 1000 lines | Over-filling code skeletons | Trim each block to ≤ 30 lines; move full examples to stage 3 |
| Can't describe Phase N exit criterion | Phase is too abstract | Split into two phases, each with a verifiable outcome |
| Research in Chinese, plan came out English | Language auto-switched by agent default | Rewrite plan in research's language; this is the user's choice |
| User wants to "just build it" without a plan | Stage 3 skipped to implementation | Push back once: a plan takes 10 minutes and de-risks hours. If insistent, note as a risk in stage 3 and proceed without plan |
| `plan.md` path conflicts with an existing file | Previous attempt left residue | Either version-bump (`-v2`) in filename or git-rm the old one; never overwrite without telling user |
| AGENTS.md says "do not use X" but research picked X | Research bypassed project rules | Halt, flag the conflict, send user to reconcile research ↔ AGENTS.md before planning |

---

## References

- Companion skill (stage 1): `research-doc` in the same repo
- Companion skill (stage 0 meta): `publish-agent-skill`
- Skill authoring guide: https://github.com/anthropics/skills#authoring-skills
- Template file: `plan-template.md` (sibling to this SKILL.md)
