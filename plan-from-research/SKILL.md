---
name: plan-from-research
description: "Turn an approved `research.md` into an execution-ready `plan.md` for frontend, backend, data, or full-stack work. Use when the user wants the next step after research: write a plan, implementation plan, refactor plan, based on this research what do we build, 根据 research 写 plan / 写实现方案 / 写 implementation md. Consume a reviewed or frozen research doc, preserve its chosen direction, expand roadmap rows into concrete phases with files-to-change, verification, rollback, compatibility, and brief load-bearing code skeletons, then stop. Do not redo research, switch options, or write production code; if research is missing, draft, or still open-ended, halt and route back to `research-doc`."
---

# Plan From Research

Turn approved `research.md` into a `plan.md` that another agent or a human can execute without returning to discovery mode. Produce the plan. Stop there.

Use `plan-template.md` as the output structure. Keep this file focused on workflow and guardrails, not long examples.

## Boundaries

- Plan only. Do not implement the plan.
- Preserve `research.md §6` as the frozen direction. Do not pick a new option.
- Do not redo research. If the research is incomplete, stop and route back to `research-doc`.
- Write skeletons only, never production code. Keep each block to 30 lines or fewer.
- If `research.md §11` still contains unresolved blockers, halt instead of guessing.

## When to use

Use this skill when all of the following are true:

1. A `research.md` or `*-research.md` exists.
2. The user explicitly wants a plan: "write a plan", "implementation plan", "refactor plan", "根据 research 写 plan", "写实现方案", "research 完了下一步".
3. The research is approved, reviewed, frozen, or the user explicitly says to continue from it.

Do not use this skill when:

- Research is missing. Route to `research-doc`.
- Research is still `draft` or has unresolved open questions.
- The user wants code now rather than a plan.

## Preconditions

Check these in order and stop on first failure:

1. Locate the source research doc in `docs/`, `research/`, repo root, or the path the user provided.
2. Verify the research contains at least:
   - `## 6. Recommendation`
   - `## 7. Architecture sketch`
   - `## 9. Implementation roadmap`
   - `## 10. Risks and mitigations`
   - `## 11. Open questions`
3. Confirm the research is approved enough to plan from: `reviewed`, `frozen`, or explicit user approval.
4. Read project-level rules such as `AGENTS.md`, `CLAUDE.md`, or `.cursorrules`.

If a prerequisite fails, explain the gap in one paragraph and point to the exact next action.

## Workflow

Track progress with this checklist:

```text
- [ ] Intake — extract the decision spine from research.md
- [ ] Ground in code — read the files and invariants the plan must respect
- [ ] Expand phases — convert roadmap rows into executable phase blocks
- [ ] Draft plan.md — fill plan-template.md in the repo's language
- [ ] Hand off — report path, cut-point, assumptions, prerequisites
```

### 1. Intake

Extract and lock these inputs from `research.md`:

- chosen option from `§6`
- target architecture from `§7`
- stack and version choices from `§8`
- roadmap rows from `§9`
- risks from `§10`
- open questions from `§11`

If the recommendation is hybrid, map which responsibilities belong to client, server, data, or infra before planning.

### 2. Ground in code

Read, but do not edit:

- `AGENTS.md` / `CLAUDE.md` / `.cursorrules`
- `README.md`
- dependency manifests such as `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`
- entrypoints named by the research
- `git log --oneline -10`

Extract the invariants the plan must not break:

- existing API contracts
- persisted data shapes or schema expectations
- developer workflow commands already in use
- doc language and naming conventions
- test layout, import aliases, and file organization patterns

These invariants belong in the plan's compatibility section.

### 3. Expand phases

Convert each roadmap row in `research.md §9` into one concrete phase block. Every phase must contain:

1. `Goal`
2. `Exit criterion`
3. `Depends on`
4. `Est. effort`
5. `Prerequisite user actions` if any
6. `Files changed`, grouped by `Add / Modify / Delete / Move`
7. `Code skeletons` for 1-3 load-bearing files
8. `Verification` commands
9. `Rollback`

Rules:

- One roadmap row becomes one phase unless it is too vague to verify. Split it if needed.
- Every phase must be independently cuttable. Mark the first end-user-visible value with `STAR`.
- Every file-level change must cite the research section that justifies it.
- Skeletons should show shape, interfaces, and one representative path only. Leave real logic as TODOs.

### 4. Draft `plan.md`

Write the plan using `plan-template.md`.

Path rules:

- If the repo has `docs/`, write `docs/<research-slug>-implementation.md`.
- Otherwise write `<slug>-plan.md` in the repo root.

Writing rules:

- Match the language of `research.md`.
- Cite existing-code claims with `path:line`.
- Cite architectural or scope claims back to the research doc.
- Do not reopen trade-offs or add "maybe use X instead" commentary.

Domain notes:

- Frontend tasks: fill the design / UX section and preserve the chosen aesthetic direction verbatim.
- Backend or data tasks: fill schema, API, failure-mode, and rollback sections; mark UX-only sections as `N/A`.
- Full-stack tasks: separate client, server, and data boundaries in phases and verification steps.

### 5. Hand off

Before finishing:

- Check `git status` and make sure only the expected plan doc changed.
- Commit only if the user asked or repo conventions clearly expect it.
- Report:
  - path to the new `plan.md`
  - source `research.md`
  - number of phases and the `STAR` cut-point
  - assumptions forced by research gaps
  - prerequisites for Phase 0
  - the literal first implementation step

## Common failure modes

- Rewriting the research instead of operationalizing it.
- Writing full code instead of skeletons.
- Emitting phases with no observable exit criterion.
- Creating a catch-all phase like "Polish".
- Mixing languages when the research is clearly Chinese-only or English-only.
- Ignoring repo invariants discovered in `AGENTS.md` or existing entrypoints.

## References

- Companion stage-1 skill: `research-doc`
- Output structure: `plan-template.md`
