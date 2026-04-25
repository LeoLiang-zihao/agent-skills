# Official Context

Load this reference when working on TAAC 2026 Tencent UNI-REC, Tencent Ads Algorithm Competition baselines, or related Transformer recommender-system code.

## Current Public Facts

- KDD Cup 2026 Tencent UNI-REC is described publicly as a next-generation recommender-system challenge for large-scale advertising that unifies sequence modeling and feature interaction.
- Tencent's public challenge copy says participants work with privacy-preserving real-world data and design a unified modeling block for scalability bottlenecks.
- The official site referenced publicly is `https://algo.qq.com`.
- Related TAAC 2025 public materials are useful prior art, not a substitute for TAAC 2026 rules when 2026 docs/baselines are available.

## Official/Primary Sources To Check

- KDD/SIGKDD public post for challenge framing: `https://www.linkedin.com/posts/sigkdd_kdd2026-kddcup-recsys-activity-7436479008034426880-3pZd`
- Tencent challenge site: `https://algo.qq.com`
- TAAC 2025 paper: `https://arxiv.org/abs/2604.04976`
- TAAC 2025 baseline: `https://github.com/TencentAdvertisingAlgorithmCompetition/baseline_2025`
- TAAC 2025 datasets: `https://huggingface.co/datasets/TAAC2025`

## BTCA Official-Code Search

When official code is not already in the project, use the BTCA workflow:

```bash
mkdir -p ~/.btca/agent/sandbox
cd ~/.btca/agent/sandbox
git clone https://github.com/TencentAdvertisingAlgorithmCompetition/baseline_2025.git 2>/dev/null || git -C baseline_2025 pull --ff-only
rg -n "SASRec|Transformer|RQ-VAE|semantic|candidate|seq|user_feat|item_feat|NDCG|recall|submit|faiss" baseline_2025
```

If the user provides a TAAC 2026 repository or official package, clone/search that first and treat it as authoritative over TAAC 2025.

## Data-Schema Checks

For Hugging Face datasets, inspect before coding:

```bash
curl -s "https://datasets-server.huggingface.co/splits?dataset=TAAC2025/TencentGR-10M"
curl -s "https://datasets-server.huggingface.co/first-rows?dataset=TAAC2025/TencentGR-10M&config=seq&split=train"
curl -s "https://datasets-server.huggingface.co/parquet?dataset=TAAC2025/TencentGR-10M"
```

Expected TAAC 2025 public subsets include `candidate`, `item_feat`, multimodal embedding subsets, `seq`, and `user_feat`. Re-check live metadata instead of hardcoding this list.

## Development Guardrails

- Baseline first: prove the official or local baseline can load data and run a minimal forward/eval path before changing architecture.
- Schema first: write loader tests against real official row examples, including null/cold-start fields and large integer IDs.
- Metric fidelity first: port official evaluator behavior exactly before optimizing models.
- Ablate one idea at a time: semantic IDs, sequence encoder changes, feature-cross blocks, retrieval/ranking heads, negative sampling, and loss changes should be separately attributable.
- Avoid leakage: do not use target/candidate/test-only fields during training unless official rules explicitly allow it.
