---
name: publish-agent-skill
description: "Ship ANY skill — authored here or installed from someone else's repo — to every coding agent on the user's machine (Cursor, Codex, Claude Code, Pi, Antigravity, Windsurf, Gemini CLI, and ~40 others via `npx skills`) AND record it in the central `LeoLiang-zihao/agent-skills` repo so cross-machine sync works. Two tracks: Track A (author a new personal skill here), Track B (install a third-party skill AND mirror its source into `external-skills.json` so a new machine can replay the same install). Use when the user wants to create, update, publish, install, sync, or troubleshoot a skill — including installing a skill from GitHub like `vercel-labs/agent-skills` or `anthropics/skills`. 用来把任何 skill（自己写的或第三方的）同步到全 agent 并在个人 repo 里留底，新机器一条命令恢复全部。Always end Track B by pushing an updated `external-skills.json` — skipping this breaks cross-machine sync. Follow this exact workflow — do not invent alternatives."
---

# Publish Agent Skill

One-stop workflow for making **any** skill — authored locally or installed from a third-party repo — visible to every coding agent on this machine AND reproducible on every other machine the user signs into.

## When to use

Trigger this skill for **both** of these cases:

### Track A — authoring a new personal skill

- "Turn this into a skill" / "写成一个 skill"
- "Sync my skill to all my agents" / "装到所有 agent 上" / "全 agent 同步"
- "Update my skill" / "改一下我那个 skill"
- "Add a new skill to my agent-skills repo"
- "How do I make a skill for all my agents"

### Track B — installing a third-party skill

- "Install `vercel-labs/agent-skills` / `anthropics/skills` / any other repo"
- "装一下 xxx 的 skill" / "把某某 repo 的 skill 加进来"
- "Why does my new machine not have all the skills I use?"
- "为什么 Codex / Claude Code / Pi 看不到这个 skill" (diagnosis)
- Any `npx skills add <third-party-repo> ...` request

> **Why Track B matters**: `npx skills add` on its own only installs to the current machine. If you do not also append the `{repo, skills}` tuple to `external-skills.json` and push, a new laptop will silently miss those skills. This skill's job is to make that step impossible to forget.

Do **not** trigger for:

- Editing `AGENTS.md` rules (use the `create-rule` skill instead).
- One-off project-local `.agents/skills/` changes that should not be shared across machines.

## Prerequisites (check once, cache the result)

1. Central GitHub repo for personal skills. Default: `LeoLiang-zihao/agent-skills` at `~/Projects/agent-skills/`.
   - Verify: `git -C ~/Projects/agent-skills remote -v`
   - If missing: `gh repo create <user>/agent-skills --public --source ~/Projects/agent-skills --remote origin --push` plus a README.
2. `gh` and `git` authenticated: `gh auth status`.
3. `npx` + `python3` available.
4. At least one universal agent install (Cursor / Codex). This is how `~/.agents/skills/` gets populated.

Do not proceed if any of the above is missing — surface it to the user and fix first.

---

## Track A — Author a new personal skill (6 steps)

Each step has a verification. Do not skip.

### A1 — Clarify the skill

- **Name**: short, kebab-case, unique. Becomes the directory name AND the `name:` frontmatter value.
- **Description**: one dense paragraph packed with trigger phrases (EN + 中文 if bilingual), scope, and explicit "use when" clause. 3–6 sentences. This is the single most important field — agents only see `name` + `description` until they decide to read `SKILL.md`.
- **Scope check**: `ls ~/Projects/agent-skills/` and `npx skills list -g --json` to confirm no collision.

If the request is vague, use `AskQuestion` to pin down triggers / inputs / outputs / whether a bundle (scripts, templates) is needed.

### A2 — Scaffold

```bash
cd ~/Projects/agent-skills
mkdir <skill-name>
```

Create `~/Projects/agent-skills/<skill-name>/SKILL.md`:

```markdown
---
name: <skill-name>
description: <dense paragraph with trigger phrases, scope, explicit "use when"; EN + 中文 if bilingual>
---

# <Human Title>

<One-paragraph what-and-why.>

## When to use

- Concrete trigger 1
- Concrete trigger 2

Do NOT use for:
- Anti-trigger 1

## Workflow

1. Step 1 — with verification command
2. Step 2 — …

## Common issues

- Problem → fix

## References

- [link]
```

Body rules:

- Actionable, not narrative. Bullets + code blocks with real commands.
- After every mutating step, show the command that proves it worked.
- Cite sources (docs, repos, articles).
- Supporting files only if they pay for themselves. Prefer one strong SKILL.md over a sprawling bundle.

### A3 — Self-review frontmatter

- `name:` exactly matches the directory name.
- `description:` contains at least one user-language trigger phrase ("用来…", "use when…").
- No secrets, no absolute user paths, no machine hostnames.
- `head -10 ~/Projects/agent-skills/<skill-name>/SKILL.md` shows valid YAML between `---` fences.

### A4 — Update README

Append an entry under "Skills included" in `~/Projects/agent-skills/README.md` (name, one-line purpose, trigger). Skip this for pure edits.

### A5 — Commit and push

```bash
cd ~/Projects/agent-skills
git add <skill-name>/ README.md
git -c commit.gpgsign=false commit -m "feat: add <skill-name> skill"   # or "chore: update <skill-name>"
git push origin main
```

Verify:

```bash
git -C ~/Projects/agent-skills log --oneline -1
gh repo view LeoLiang-zihao/agent-skills --json pushedAt -q .pushedAt
```

### A6 — Fan out

Brand-new skill (first time this repo is installed on this machine):

```bash
npx --yes skills add LeoLiang-zihao/agent-skills -g -a '*' --all -y
```

Existing skill edited, or new skill added to an already-installed repo:

```bash
npx --yes skills update -g -y
```

Verify coverage (expect 25+ agents per skill):

```bash
npx --yes skills list -g --json | python3 -c "
import json, sys
data = json.load(sys.stdin)
for s in data:
    if s['scope'] == 'global':
        print(f\"{s['name']:<30} {len(s['agents']):>3} agents\")
"
```

Sanity-check universal + per-agent paths:

```bash
ls ~/.agents/skills/<skill-name>/SKILL.md
ls -la ~/.claude/skills/<skill-name> ~/.pi/agent/skills/<skill-name> 2>/dev/null
```

If any path is missing, re-run `skills update -g -y`, then fall back to `skills add LeoLiang-zihao/agent-skills -g -a '*' --all -y`.

---

## Track B — Install a third-party skill AND record it (4 steps)

This is the track the skill's own `external-skills.json` manifest exists for. Every time the user runs `npx skills add <other-repo>`, finish the job by updating the manifest.

### B1 — Install to every agent

Always scope to **all agents** (`-a '*'`) so Codex, Cursor, Pi, Claude Code, etc. all get it. Pin specific skills with `-s`; use `--all` only if the user genuinely wants every skill from that repo.

```bash
# Example: two skills from one repo
npx --yes skills add <github-owner>/<repo> -g -a '*' \
  -s <skill-name-1> -s <skill-name-2> -y

# Example: everything from a repo
npx --yes skills add <github-owner>/<repo> -g -a '*' --all -y
```

Verify immediately:

```bash
for s in <skill-name-1> <skill-name-2>; do
  echo "--- $s ---"
  ls ~/.agents/skills/$s/SKILL.md 2>/dev/null && echo "  universal OK"
  ls -la ~/.claude/skills/$s ~/.pi/agent/skills/$s 2>/dev/null
done
```

### B2 — Append to `external-skills.json` (**this is the step that is easy to forget — do not skip it**)

Edit `~/Projects/agent-skills/external-skills.json`. Add or extend a `sources[]` entry:

```json
{
  "sources": [
    {
      "repo": "<github-owner>/<repo>",
      "skills": ["<skill-name-1>", "<skill-name-2>"],
      "note": "<one-line why-we-installed-this>"
    }
  ]
}
```

Rules:

- If the repo already has an entry, add to its `skills` array and dedupe — do NOT create a duplicate source entry.
- `note` is required (one line, ≤ 80 chars) so future-you remembers why it was installed.
- Preserve stable key ordering (`repo`, `skills`, `note`).

Validate:

```bash
python3 -c "import json; json.load(open('$HOME/Projects/agent-skills/external-skills.json'))" \
  && echo "manifest JSON is valid"

# Confirm bootstrap would run the expected commands
~/Projects/agent-skills/scripts/bootstrap.sh --help 2>/dev/null  # (dry-run not supported; use python to preview:)
python3 - ~/Projects/agent-skills/external-skills.json <<'PY'
import json, shlex, sys
m = json.load(open(sys.argv[1]))
for src in m.get("sources", []):
    parts = ["npx", "--yes", "skills", "add", shlex.quote(src["repo"]), "-g", "-a", "'*'"]
    for s in src.get("skills", []):
        parts += ["-s", shlex.quote(s)]
    parts.append("-y")
    print(" ".join(parts))
PY
```

### B3 — Commit the manifest change

```bash
cd ~/Projects/agent-skills
git add external-skills.json
git -c commit.gpgsign=false commit -m "chore(external): add <skill-name-1>, <skill-name-2> from <owner>/<repo>"
git push origin main
```

Verify:

```bash
git -C ~/Projects/agent-skills log --oneline -1
```

### B4 — Hand-off

Tell the user concisely:

- Which upstream repo was installed.
- Which skills landed + how many agents they now cover.
- That the manifest was updated and pushed (commit SHA + repo URL), so any future machine can run `./scripts/bootstrap.sh` to get the same set.

---

## Cross-machine sync

**Every new machine** (or re-imaged machine) does exactly this:

```bash
# 1. Clone personal skill repo
git clone git@github.com:LeoLiang-zihao/agent-skills.git ~/Projects/agent-skills

# 2. Run bootstrap: installs own skills AND all third-party skills recorded in external-skills.json
cd ~/Projects/agent-skills && ./scripts/bootstrap.sh
```

One command. Any time you want to refresh:

```bash
~/Projects/agent-skills/scripts/bootstrap.sh --update
```

As long as Track B is followed on every machine (manifest pushed whenever a third-party skill is added), this command reproduces the full skill library on any device. If you ever catch a skill on machine X that is not on machine Y, it means someone bypassed Track B — fix the manifest, push, re-bootstrap.

---

## Agents covered (as of this skill's creation)

Universal path `~/.agents/skills/` is read natively by: **Cursor, Codex, Antigravity, Amp, Cline, Gemini CLI, OpenCode, Crush, Goose, Windsurf, Continue, and every other agent that honors the `.agents/skills/` convention.**

The `skills` CLI additionally creates per-agent symlinks for: **Augment, IBM Bob, Claude Code, OpenClaw, CodeBuddy, Command Code, Continue, Cortex Code, Crush, Droid, Goose, Junie, iFlow CLI, Kilo Code, Kiro CLI, Kode, MCPJam, Mistral Vibe, Mux, OpenHands, Pi, Qoder, Qwen Code, Roo Code, Trae, Trae CN, Windsurf, Zencoder, Neovate, Pochi, AdaL.**

Net result: a single `git push` + `bootstrap.sh` makes a skill live in ~45 coding agents with zero per-agent configuration.

## Common issues and fixes

| Symptom | Cause | Fix |
|---|---|---|
| New own skill invisible to any agent | Forgot to push, or repo not registered on this machine | `git push`; then `npx --yes skills add LeoLiang-zihao/agent-skills -g -a '*' --all -y` |
| Third-party skill on old machine, missing on new machine | Track B step B2 was skipped — manifest never updated | Add the `{repo, skills}` entry to `external-skills.json`, commit, push; run `./scripts/bootstrap.sh --update` on the new machine |
| Visible to Cursor but not Claude Code / Pi | Universal path updated, per-agent symlinks stale | `npx --yes skills update -g -y`; if still missing, `skills remove -g -s <name> -a '*' -y` then `skills add … --all -y` |
| Visible to Cursor but not Codex | Old version of skills CLI didn't treat Codex as universal; Codex now is | Re-run `skills add <repo> -g -a '*' -s <skill> -y` — current CLI will drop it into `~/.agents/skills/` where Codex reads |
| Old copy of skill in `~/.cursor/skills/<name>/` or `~/.codex/skills/<name>/` | Legacy per-agent install predating universal path | Delete: `rm -rf ~/.cursor/skills/<skill-name>` (same for other per-agent dirs) |
| Agent reads `SKILL.md` but never fires it | `description:` too vague or missing trigger phrases | Rewrite `description:` with explicit "use when …" and trigger keywords in the user's language |
| `skills update -g` says "up to date" but changes seem absent | Cached refs or update only checks git HEAD, not add-time agent list | `git -C ~/Projects/agent-skills log -1` to confirm push landed; then `skills add <repo> -g -a '*' -s <skill> -y` to re-fan the agent list |
| YAML frontmatter parse error | Missing `---` fence, tabs in YAML, or unescaped colons in description | Keep description a single line; quote values containing `:` with double quotes |
| `external-skills.json` invalid JSON | Trailing comma, tab, or unterminated string | `python3 -c "import json; json.load(open('~/Projects/agent-skills/external-skills.json'))"` to pinpoint |

## Output and hand-off

When this skill finishes, tell the user concisely:

1. **Track A**: skill name + one-line purpose + commit SHA + repo URL + "now covered on N agents".
2. **Track B**: upstream repo + skill names + commit SHA of manifest update + "bootstrap.sh on future machines picks this up".
3. Which agents need a restart to pick up the new skill (Cursor: yes for in-session prompt; Codex / Claude Code / Pi: next invocation).

Keep the final summary tight — the user cares about "it's live everywhere AND reproducible on the next machine" more than about the mechanics.

## References

- `skills` CLI (Anthropic): https://github.com/anthropics/skills
- Skill authoring guide: https://github.com/anthropics/skills#authoring-skills
- Personal skill repo: https://github.com/LeoLiang-zihao/agent-skills
- Sister skill in this repo: `research-doc`, `pi-docs-assistant`
