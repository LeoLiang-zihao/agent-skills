# <Topic> — Implementation Plan

> Fill every section. Mark `N/A — <reason>` if a section does not apply.
> Delete these instruction comments before committing.
> Write this doc in the same language as the source `research.md`.

Meta:

- **Source research**: `docs/<slug>-research.md` (version: v<N>)
- **Author**: <agent name / date>
- **Status**: draft / ready-to-build / in-progress / done
- **Intended executor**: <next agent / human / both>
- **Version**: v1

---

## TL;DR

3–6 bullets. Someone reading only this block should know:

- What this plan delivers (one sentence from research §6).
- How many phases + effort estimate total.
- Which phase to start at (usually Phase 0).
- Any prerequisite user actions (OAuth login, API key, account).
- ⭐ Which phase is the cut-point (first end-user-visible value).

---

## Table of contents

- Phase 0 — <name>
- Phase 1 — <name>
- Phase 2 — <name>
- Phase 3 — <name>
- ...
- Dependencies & environment
- Risk matrix
- Compatibility: what must NOT break
- Acceptance checklist
- Appendix: open questions / research cross-reference

---

## 1. Architecture refresher

Reproduce the ASCII diagram from `research.md §7` verbatim. Add a 3-line caption if needed.

```
(diagram copied from research)
```

**Key invariants** (one line each, cite research §):

- ...
- ...

Do not redo the architectural discussion here. Link, don't rewrite: see `research.md §6–§8`.

---

## 2. Design / UX principles (frontend tasks only)

Only fill if research §8 had an "Aesthetic / UX direction" block. Copy the decisions verbatim:

- **Fonts**: <display> + <body> (from research)
- **Color tokens**: …
- **Spacing / radius**: …
- **Memorable element**: …
- **Anti-patterns (do NOT)**: …

Skip this section for backend / data / ML tasks.

---

## 3. Phased roadmap

One block per phase. Use the exact structure below for each.

### Phase 0 — Scaffold

**Goal**: <one sentence>.

**Exit criterion** (research §9): <observable outcome, e.g. "`pnpm --filter web dev` serves a blank page at localhost:3000">.

**Depends on**: — (entry phase).

**Est. effort**: <from research>.

**Prerequisite user actions** (if any):

```bash
# example: one-time subscription login
pi /login
```

**Files changed**:

```
Add      apps/web/package.json             — Next.js 15 + deps from research §8
Add      apps/web/src/app/layout.tsx       — root layout
Modify   start.sh                          — add `dev` subcommand (per research §9 P0)
```

**Code skeletons** (load-bearing files only, ≤ 30 lines each):

```ts
// apps/web/src/server/api/routers/cards.ts
import { z } from "zod";
import { procedure, router } from "@/server/api/trpc";

export const cardsRouter = router({
  list: procedure
    .input(z.object({ limit: z.number().default(20) }))
    .query(async ({ input }) => {
      // TODO: wire to backend/main.py /api/cards (research §7)
      return [];
    }),
});
```

**Verification**:

```bash
pnpm --filter web build
pnpm --filter web dev &
curl -sf http://localhost:3000/ > /dev/null && echo "OK"
```

**Rollback**: `git revert <phase-tag>`; optionally `rm -rf apps/web/`.

---

### Phase 1 — <name>

(same structure as Phase 0)

---

### Phase 2 — <name>  ⭐ cut-point

(same structure; mark the first phase producing end-user-visible value)

---

<!-- Continue with Phase 3, 4, 5... as needed, one block each -->

---

## 4. Dependencies and environment

### New dependencies

List ALL packages added across all phases, with versions from research §8. Group by phase so the next agent knows when each is introduced.

| Phase | Package | Version | Purpose |
|---|---|---|---|
| P0 | next | 15.x | app scaffold |
| P0 | @trpc/server | 11.x | BFF |
| ... | ... | ... | ... |

### Environment variables

```bash
# .env.example (add to repo, do not commit .env.local)
NEXT_PUBLIC_API_URL=http://localhost:8000
# Optional: Pi / LLM auth fallbacks (primary resolution: ~/.pi/agent/auth.json)
ANTHROPIC_API_KEY=
OPENAI_API_KEY=
```

### One-time user setup

```bash
# e.g. Pi subscription login (OAuth to ChatGPT Plus / Claude Pro)
pi /login
```

---

## 5. Risk matrix

Carry every risk from `research.md §10` and add code-level mitigations that the implementation agent can act on. Add at least one risk per category below.

| Risk | Likelihood | Impact | Mitigation (code-level) | First visible in |
|---|---|---|---|---|
| Vendor API deprecates during build | med | high | Pin version + add `vendor-fallback.ts` abstraction | P2 |
| User-assumption was wrong ("X supports Y") | low | high | Phase N verification will fail fast; fallback documented in P3 | P3 |
| Rollback destroys data | low | high | Phase 4 migration is additive-only; old columns stay | P4 |
| ... | ... | ... | ... | ... |

Must include: (a) a dependency risk, (b) a user-assumption risk, (c) a rollback/ops risk.

---

## 6. Compatibility: what must NOT break

Enumerate every invariant pulled from `AGENTS.md`, existing API contracts, or live user workflows. For each, say how the plan preserves it.

| Invariant | Source | How this plan honors it |
|---|---|---|
| Existing API `POST /api/cards` payload shape | `backend/main.py:42` | Next.js BFF forwards unchanged; no schema change |
| Bilingual writing style in docs | `AGENTS.md §Writing style` | Plan + code comments follow |
| `./start.sh add <url>` command still works | user muscle memory | P2 rewires impl, keeps command signature |
| ... | ... | ... |

---

## 7. Acceptance checklist

The plan is considered executed when all of these are checked. The implementation agent uses this as its definition of done.

```
- [ ] P0 — scaffold: `<exit criterion>`
- [ ] P1 — <name>: `<exit criterion>`
- [ ] P2 — <name>: `<exit criterion>` ⭐
- [ ] P3 — <name>: `<exit criterion>`
- [ ] P4 — <name>: `<exit criterion>`
- [ ] Compatibility: all invariants in §6 verified green
- [ ] Risk mitigations: each row in §5 either executed or explicitly deferred
- [ ] Docs: README + AGENTS.md updated to reflect new layout
```

---

## Appendix A — Cross-reference to research

Map each phase back to the research section(s) it operationalizes.

| Phase | Research section | Notes |
|---|---|---|
| P0 | §7 architecture + §8 stack | scaffolding, no business logic |
| P1 | §9 roadmap row 1 | ... |
| ... | ... | ... |

---

## Appendix B — Open questions not yet resolved

If research §11 had any unresolved question that still blocks implementation, list it here with a proposed resolution strategy. If empty, state "None — ready for implementation."

- [ ] ...

---

## Appendix C — Commit checklist for the implementation agent

Suggested git hygiene as the plan is executed:

1. One phase = one PR (or at least one commit series with a clear tag `plan-P<N>-start` / `plan-P<N>-done`).
2. Verification output pasted into the PR description.
3. Any deviation from this plan → update this file first, then implement.
