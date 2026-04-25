# Model Contracts

Use contracts to stop RecSys model bugs from spreading across loader, collator, model, loss, and evaluator.

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
