# Debugging Protocol

Debug the first broken contract. Do not compensate downstream for an upstream bug.

## Minimal Reproduction

Start with one failing command:

```bash
uv run pytest tests/model/test_some_module.py -q
```

or:

```bash
uv run python -m src.train_eval --config configs/base.yaml --max_steps 2
```

If no command is known, create the smallest one-batch script or focused test path from existing code. Do not scan the whole test tree by default.

## Failure Classes

- Schema: official/local data field differs from code expectation.
- Collate: row examples are valid but batch construction changes type, shape, padding, or mask meaning.
- Shape: module receives correct semantic data but incompatible dimensions.
- Mask: valid/pad polarity, causal/bidirectional choice, domain mask, or attention mask layout is wrong.
- Feature fusion: dense/list/sparse feature branch drops information, broadcasts accidentally, or joins the wrong token.
- Loss: target shape/dtype/range, ignored index, sample weights, or aux loss scale is wrong.
- Training instability: NaN/Inf, exploding gradients, collapse, zero learning, AMP issue, or bad initialization.
- Metric/eval: prediction/label grouping, calibration, split leakage, or aggregation bug.
- Config wiring: flag exists but is not passed, default changes silently, or test config differs from train config.

## Fix Order

1. Confirm the boundary where observed vs expected first diverges.
2. Add the smallest regression test or assertion that would have caught it.
3. Patch that boundary only.
4. Rerun the focused verification.
5. Only then run a broader smoke test if the boundary crosses data -> model -> loss -> eval.

## Common RecSys Transformer Bugs

- Mask polarity is inverted between collate and attention.
- `padding_idx=0` exists in embeddings but pooled list features still include zeros.
- A `[B, 1]` logit silently broadcasts against `[B]` labels.
- Dense modalities with different dimensions are concatenated before normalization.
- Train and eval use different feature subsets because optional keys are missing.
- Aux losses stay on CPU or use a different dtype under AMP.
- A config flag disables construction but forward still references the module.
