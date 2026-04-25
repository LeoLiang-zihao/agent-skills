# Model Contracts

Use contracts to stop RecSys model bugs from spreading across loader, collator, model, loss, and evaluator.

## Data Facts Snapshot

Model work should carry a compact fact snapshot from the local data/schema/evaluator context. This is not a full rules review; it is the minimum set of facts needed to avoid designing the wrong model.

Include:

- Prediction target and label semantics.
- Train/valid/holdout/test field differences.
- Which fields are sequence, static user, static item, context, dense, sparse, and list/multi-hot.
- Sequence ordering, truncation, and label-time cutoff rules.
- Padding/null/sentinel values.
- Whether test rows include labels, candidates, timestamps, or any missing feature groups.
- Primary metric and any loss-alignment constraints.
- Leakage constraints and forbidden fields.
- Submission-facing output shape if it affects the model head.

Keep the snapshot to roughly 8-12 bullets. If a fact is uncertain, mark it `UNKNOWN` and inspect the narrowest official/local source that can resolve it.

Example:

```text
Data Facts Snapshot:
- Target: pCVR-style binary label from train/valid only.
- Test: same feature surface as train minus label.
- User history: multiple domain sequences, ordered by timestamp before label_time.
- Static features: user/item scalar int, user/item list int, user dense vectors.
- Metric: GAUC/logloss path in local evaluator; model head returns one row-level logit.
- Leakage: no events after label_time in sequence features.
```

## Batch Contract

Before editing a model, write or infer the batch contract from the smallest relevant source:

- Key name.
- Tensor/list type.
- Shape with symbolic dimensions, e.g. `B`, `L`, `D`, `n_fields`.
- Dtype.
- Device ownership.
- Padding value and mask semantics.
- Whether the key exists in train, valid, holdout, and test.
- Whether the value is label-time safe.

Example:

```text
domain_seq_ids: LongTensor[B, L] padded with 0
domain_seq_mask: BoolTensor[B, L] true means valid token
user_dense: list[FloatTensor[B, D_i]] no padding, may be absent in test only if official docs say so
pcvr_label: FloatTensor[B] train/valid only, never required for submission rows
```

## Model Forward Contract

Every model change should preserve or intentionally update:

- Required batch keys.
- Optional batch keys and fallback behavior.
- Output dict keys.
- Main logit shape, usually `[B]` or `[B, 1]` but never ambiguous.
- Auxiliary outputs and losses.
- `model.train()` vs `model.eval()` behavior.

Good output contract:

```python
{
    "pcvr_logit": torch.Tensor,  # shape [B]
    "aux_losses": dict[str, torch.Tensor],
}
```

## Config Contract

For optional modules:

- Add one config flag with a clear default.
- Keep default behavior stable unless the task explicitly changes the baseline.
- Wire config -> module construction -> forward branch -> test.
- Prefer explicit disabled behavior over partially initialized modules.

## Shape Checks

Use cheap assertions at module boundaries when shapes are non-obvious:

```python
assert x.ndim == 3, f"expected [B, L, H], got {tuple(x.shape)}"
assert mask.shape == x.shape[:2]
```

Avoid scattered assertions inside hot inner loops unless they are gated or used only in tests.
