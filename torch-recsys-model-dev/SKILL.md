---
name: torch-recsys-model-dev
description: "Guides systematic PyTorch recommender-system model development across compact data facts, existing source code, configs, focused tests, and training loops without overloading context from broad research archives. Use when building, debugging, or refactoring torch/nn.Module RecSys models with Transformer/HSTU/attention blocks, sparse/dense/list feature fusion, pCVR/CTR heads, ablation axes, or competition codebases where many model ideas exist but bugs and interface drift must be controlled. 用来指导推荐系统 PyTorch 模型开发、Transformer/HSTU 建模、关键数据事实、特征交互、shape/debug、训练闭环和已有模型结构的系统化推进。"
---

# Torch RecSys Model Dev

Use this skill to turn existing RecSys model ideas into stable PyTorch code by keeping context small, carrying the most important data facts, making contracts explicit, and tying each change to a focused verification.

## When to use

- Building or debugging `torch.nn.Module` recommender models.
- Working with Transformer, HSTU, attention, FiLM, RAB, MTP, dual-mask, dense/list/sparse feature fusion, pCVR/CTR heads, or ablation axes.
- A repo already has many model designs and bugs come from interface drift, shape mismatch, masking, config flags, or train/eval mismatch.

Do NOT use for:
- Full official competition rule interpretation or submission policy review; use the domain skill such as `taac-unirec-dl` when those facts are uncertain.
- Broad literature review or historical plan synthesis.

## Context Budget

1. Start from the current task, error, or module name; do not read broad archives first.
2. Keep a compact Data Facts Snapshot in context before model work: target label, train/test field differences, sequence/static feature groups, padding/null rules, metric/loss alignment, and leakage constraints.
3. Prefer `configs/base.yaml`, the directly touched `src/model/*.py`, the relevant `src/data/*` contract file, and the current train/eval entrypoint.
4. Read tests narrowly: one focused test file for the touched module plus one smoke/integration test only when the boundary crosses data -> model -> loss -> eval.
5. Do not load large historical planning or synthesis documents unless the user explicitly asks for design archaeology.

## Workflow

1. Identify the active boundary.
   - Choose exactly one primary boundary: data/collate, embedding/fusion, sequence block, head/loss, train loop, evaluator, or config wiring.
   - If the task spans multiple boundaries, write the handoff contract first and change one side at a time.

2. Establish the Data Facts Snapshot.
   - Pull only the facts needed for model design from local official docs, schema code, dataset sample readers, or the domain skill.
   - Include facts in the working context; do not keep model work blind to labels, test shape, missing fields, metric, or leakage constraints.
   - See [references/model-contracts.md](references/model-contracts.md).

3. Establish contracts before editing.
   - Batch contract: input keys, shape, dtype, padding/null convention, device, and expected missing fields.
   - Model contract: `forward()` inputs, output keys, logit shape, auxiliary losses, and train/eval behavior.
   - Config contract: each optional component has a flag, default, and test-visible behavior.
   - See [references/model-contracts.md](references/model-contracts.md).

4. Debug systematically.
   - Reproduce the smallest failure command first.
   - Classify the failure as schema, collate, shape, mask, feature fusion, loss, training instability, metric, or config wiring.
   - Fix the first broken contract, then rerun only the smallest relevant verification.
   - See [references/debugging-protocol.md](references/debugging-protocol.md).

5. Keep experiments disciplined.
   - One architecture idea per patch.
   - New modules must be ablation-friendly and not silently change baseline behavior.
   - Do not add another model idea while baseline smoke or focused tests are red.
   - See [references/experiment-discipline.md](references/experiment-discipline.md).

## Inline Example

Before changing a model module:

```bash
rg -n "class .*Model|def forward|PcvrConfig|use_|loss|logit" src/model src/train_eval.py configs
```

Then read only the files named by the result that are directly involved in the current failure or feature.
