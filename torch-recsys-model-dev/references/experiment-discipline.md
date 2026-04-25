# Experiment Discipline

Use this guide when a repo already contains many plausible model ideas.

## One Idea Per Patch

Pick one axis:

- Embedding/fusion.
- Sequence block.
- Attention/mask.
- Temporal/domain conditioning.
- Head/loss.
- Training schedule.
- Evaluation/calibration.

Do not combine axes until each one has a focused test and a smoke result.

## Baseline Protection

Before adding a new module:

- Identify the current baseline path.
- Verify the smallest baseline smoke command still runs.
- Add a config flag for the new path.
- Keep disabled behavior equivalent to the baseline.

## Ablation-Friendly Design

Every experimental component should answer:

- What input does it consume?
- Where does it add into the representation?
- What output shape does it produce?
- Which config flag controls it?
- Which focused test proves it is wired?
- Which metric or smoke output will decide whether it stays?

## Backlog Instead of Context Expansion

When a design idea is interesting but not needed to fix the current boundary:

- Do not load large research notes to explore it.
- Write a one-line backlog note in the final response or the project issue tracker if requested.
- Return to the current failing contract.

## Verification Ladder

Use the smallest ladder that matches the change:

```text
pure module change     -> focused model test
batch/model boundary   -> focused data or collate test + model test
loss/head change       -> focused loss/head test
train-loop change      -> max_steps=1 or max_steps=2 smoke
eval/submission change -> evaluator/submission smoke with tiny rows
```

Avoid full-suite runs as the first move unless the user explicitly asks or the change is broad.
