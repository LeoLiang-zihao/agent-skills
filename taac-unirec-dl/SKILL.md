---
name: taac-unirec-dl
description: "Guides deep-learning model development for TAAC 2026 Tencent UNI-REC and related Transformer recommender-system competition work without importing assumptions from older TAAC tasks. Use when working on TAAC 2026, Tencent UNI-REC, Tencent Ads Algorithm Competition 2026, Transformer recommendation models, unified sequence-plus-feature interaction, retrieval/ranking, official evaluation, or competition submissions."
---

# TAAC UNI-REC DL

Use this skill for competition-grade PyTorch recommendation modeling where TAAC 2026 official data, unified sequence-plus-feature interaction, and evaluator fidelity matter.

## Workflow

1. Establish official context before coding.
   - Inspect this repo for `README*`, `AGENTS.md`, `CLAUDE.md`, configs, dataset schemas, and baseline files.
   - Use BTCA search when official code is absent or stale: clone/search user-provided TAAC 2026 links and Tencent UNI-REC official packages under `~/.btca/agent/sandbox`.
   - Read [references/official-context.md](references/official-context.md) before changing model, dataset, inference, or evaluation behavior.

2. Anchor every change to official data and metrics.
   - Prefer official dataset schemas, split definitions, feature dictionaries, candidate generation rules, and submission format over inferred structures.
   - For Hugging Face-hosted official data, use `huggingface-datasets` to inspect subsets, splits, parquet shards, row examples, and statistics before writing loaders.
   - Do not invent columns, labels, metrics, negative sampling, or target semantics without finding them in official docs/data/code.

3. Develop model code conservatively.
   - Treat official baseline behavior as the first regression target; run or reproduce baseline tests before replacing components.
   - Keep model changes modular: embeddings/features, sequence encoder, interaction block, retrieval head, ranker head, loss, sampler, evaluator.
   - Do not assume TAAC 2025 architectures, feature subsets, semantic-ID pipelines, sampling, or metrics apply to TAAC 2026 unless 2026 official docs/code say so.
   - Use PyTorch mixed precision, gradient clipping, deterministic seeds, checkpoint metadata, and explicit config files for experiments.

4. Verify like a competition entry.
   - Run the smallest official-compatible smoke test first: schema load -> one batch -> forward -> loss -> eval metric -> submission row.
   - Compare against the official baseline or sample evaluator whenever available.
   - Log run config, git SHA, data version, metric values, and failure notes. Use `huggingface-trackio` when training metrics or alerts matter.

## Inline Example

Before editing a loader:

```bash
rg -n "load_dataset|read_parquet|schema|feature|sequence|candidate|metric|evaluate|submit" .
```

Then inspect the official schema/source named by the result, not a guessed replacement.
