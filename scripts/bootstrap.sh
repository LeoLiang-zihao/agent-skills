#!/usr/bin/env bash
# bootstrap.sh — wire this repo's own skills + every third-party skill
# recorded in external-skills.json into every agent on this machine.
#
# Usage (on a brand-new machine, after cloning this repo):
#   cd ~/Projects/agent-skills && ./scripts/bootstrap.sh
#
# Usage (any time, to re-sync):
#   ./scripts/bootstrap.sh --update
#
# Idempotent: safe to re-run.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$REPO_ROOT/external-skills.json"

MODE="add"
if [[ "${1:-}" == "--update" ]]; then
  MODE="update"
fi

say() { printf "\033[1;36m▸ %s\033[0m\n" "$*"; }
die() { printf "\033[1;31m✗ %s\033[0m\n" "$*" >&2; exit 1; }

command -v npx >/dev/null 2>&1 || die "npx not found (install Node.js first)"
command -v python3 >/dev/null 2>&1 || die "python3 not found"
[[ -f "$MANIFEST" ]] || die "manifest missing: $MANIFEST"

# -----------------------------------------------------------------------------
# 1. Own skills (this repo)
# -----------------------------------------------------------------------------
OWN_REPO="LeoLiang-zihao/agent-skills"
if [[ "$MODE" == "add" ]]; then
  say "Installing own skills from $OWN_REPO to all agents…"
  npx --yes skills add "$OWN_REPO" -g -a '*' --all -y
else
  say "Updating all global skills…"
  npx --yes skills update -g -y
fi

# -----------------------------------------------------------------------------
# 2. Third-party skills (from external-skills.json)
# -----------------------------------------------------------------------------
say "Installing third-party skills from $MANIFEST…"
COMMANDS=$(python3 - "$MANIFEST" <<'PY'
import json, shlex, sys
manifest = json.load(open(sys.argv[1]))
for src in manifest.get("sources", []):
    repo = src["repo"]
    skills = src.get("skills", [])
    if not skills:
        continue
    parts = ["npx", "--yes", "skills", "add", shlex.quote(repo), "-g", "-a", "'*'"]
    for s in skills:
        parts += ["-s", shlex.quote(s)]
    parts.append("-y")
    print(" ".join(parts))
PY
)

if [[ -z "$COMMANDS" ]]; then
  say "  (manifest has no third-party sources — skipping)"
else
  while IFS= read -r cmd; do
    [[ -z "$cmd" ]] && continue
    say "  \$ $cmd"
    eval "$cmd"
  done <<< "$COMMANDS"
fi

# -----------------------------------------------------------------------------
# 3. Verify coverage
# -----------------------------------------------------------------------------
say "Verifying coverage (want 25+ agents per skill)…"
npx --yes skills list -g --json | python3 <<'PY'
import json, sys
data = json.load(sys.stdin)
globals_ = [s for s in data if s.get("scope") == "global"]
bad = [s for s in globals_ if len(s.get("agents", [])) < 25]
for s in sorted(globals_, key=lambda x: x["name"]):
    n = len(s.get("agents", []))
    marker = "⚠" if n < 25 else "✓"
    print(f"  {marker} {s['name']:<32} {n:>3} agents")
if bad:
    print(f"\n\033[1;33m{len(bad)} skill(s) under 25 agents — consider re-adding.\033[0m", file=sys.stderr)
PY

say "Done. Restart Cursor / Codex / Claude Code sessions to pick up new skills."
