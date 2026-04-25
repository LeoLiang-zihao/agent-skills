# Official Context

Load this reference when working on TAAC 2026 Tencent UNI-REC, Tencent Ads Algorithm Competition 2026 baselines, or related Transformer recommender-system code.

## Current Public Facts

- KDD Cup 2026 Tencent UNI-REC is described publicly as a next-generation recommender-system challenge for large-scale advertising that unifies sequence modeling and feature interaction.
- Tencent's public challenge copy says participants work with privacy-preserving real-world data and design a unified modeling block for scalability bottlenecks.
- The official site referenced publicly is `https://algo.qq.com`.
- TAAC 2026 differs materially from TAAC 2025. Do not transfer 2025 model, data, metric, or submission assumptions into 2026 work unless a 2026 official source explicitly confirms them.

## Official/Primary Sources To Check

- KDD/SIGKDD public post for challenge framing: `https://www.linkedin.com/posts/sigkdd_kdd2026-kddcup-recsys-activity-7436479008034426880-3pZd`
- Tencent challenge site: `https://algo.qq.com`
- User-provided TAAC 2026 official repository, data package, rules page, leaderboard package, or starter kit.

## BTCA Official-Code Search

When official code is not already in the project, use the BTCA workflow:

```bash
mkdir -p ~/.btca/agent/sandbox
cd ~/.btca/agent/sandbox
# Clone the user-provided TAAC 2026 official repo/package first.
# Example placeholder; replace with the actual 2026 source URL.
git clone <taac-2026-official-repo-url> taac-2026-official
rg -n "UNI-REC|unirec|feature|sequence|candidate|metric|evaluate|submit|baseline|dataloader|schema" taac-2026-official
```

Only look at TAAC 2025 after marking it as non-authoritative historical context, and only when the user asks for comparison or no 2026 official implementation is available.

## Data-Schema Checks

For Hugging Face-hosted official datasets, inspect before coding:

```bash
curl -s "https://datasets-server.huggingface.co/splits?dataset=<official-dataset>"
curl -s "https://datasets-server.huggingface.co/first-rows?dataset=<official-dataset>&config=<config>&split=<split>"
curl -s "https://datasets-server.huggingface.co/parquet?dataset=<official-dataset>"
```

If the official data is distributed elsewhere, inspect local files or the official API/package directly. Never substitute TAAC 2025 schema names for missing TAAC 2026 schema details.

## Development Guardrails

- Baseline first: prove the official or local baseline can load data and run a minimal forward/eval path before changing architecture.
- Schema first: write loader tests against real official row examples, including null/cold-start fields and large integer IDs.
- Metric fidelity first: port official evaluator behavior exactly before optimizing models.
- Ablate one idea at a time: sequence encoder changes, feature-cross blocks, retrieval/ranking heads, negative sampling, and loss changes should be separately attributable.
- Avoid leakage: do not use target/candidate/test-only fields during training unless official rules explicitly allow it.
