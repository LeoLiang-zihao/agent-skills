---
name: publish-agent-skill
description: Author a new personal agent skill locally and publish it so every coding agent on the user's machine picks it up — Cursor, Codex, Claude Code, Pi, Antigravity, Windsurf, Gemini CLI, and the other ~30 agents supported by the `npx skills` CLI. Use when the user wants to create, update, iterate on, or ship a skill (SKILL.md) to all their agents at once, sync changes across machines, or troubleshoot a skill that is not being picked up. Covers the full flow: scaffold SKILL.md with correct YAML frontmatter, commit to the central `agent-skills` GitHub repo, run `npx skills update -g` to fan it out, and verify per-agent coverage. Follow this exact workflow — do not invent alternatives.
---

# Publish Agent Skill

One-stop workflow for turning a local idea / process / checklist into a personal agent skill that every coding agent on the user's machine can see, then keeping it in sync.

## When to use

Trigger this skill when the user says anything like:

- "Turn this into a skill" / "写成一个 skill"
- "Sync this skill to all my agents" / "装到所有 agent 上" / "全 agent 同步"
- "Update my skill" / "改一下我那个 skill"
- "为什么 Claude Code / Cursor / Pi 看不到这个 skill"
- "Add a new skill to my agent-skills repo"
- "How do I make a skill for all my agents"

Do **not** trigger for:
- Installing a **third-party** skill from someone else's repo (that's just `npx skills add <repo> -g --all -y`; no authoring needed).
- Editing `AGENTS.md` rules (use the `create-rule` skill instead).
- One-off project-local `.agents/skills/` changes that should not be shared across machines.

## Prerequisites (check once, cache the result)

1. A central GitHub repo for the user's personal skills. Default for this user: `LeoLiang-zihao/agent-skills`, cloned at `~/Projects/agent-skills/`.
   - Verify: `git -C ~/Projects/agent-skills remote -v`
   - If missing: create with `gh repo create <user>/agent-skills --public --source ~/Projects/agent-skills --remote origin --push` and add a README.
2. `gh` and `git` authenticated. Quick check: `gh auth status`.
3. `npx` available (comes with Node).
4. At least one universal agent install (e.g. Cursor or Codex). This is how `~/.agents/skills/` gets populated.

Do not proceed if any of the above is missing — surface it to the user and fix first.

## The workflow (6 steps)

Always follow this exact order. Each step has a verification you must run before moving on.

### Step 1 — Clarify the skill

Before writing any file, pin down:

- **Name**: short, kebab-case, unique across the repo. Becomes the directory name and the `name:` frontmatter value.
- **Description**: one dense paragraph that tells the future agent exactly when to fire this skill. **This is the most important field** — agents only see `name` + `description` until they decide to read `SKILL.md`. Pack trigger phrases (EN + 中文 if user is bilingual), scope, and an explicit "use when" clause. Aim for 3–6 sentences, not a novel.
- **Scope check**: confirm there is not already an existing skill that covers this. Run `ls ~/Projects/agent-skills/` and `npx skills list -g --json` to verify.

If the user's request is vague ("make a skill for my workflow"), use `AskQuestion` to nail down: trigger conditions, inputs, expected outputs, and whether it should be one SKILL.md or a bundle with scripts/templates.

### Step 2 — Scaffold the skill directory

```bash
cd ~/Projects/agent-skills
mkdir <skill-name>
```

Then create `~/Projects/agent-skills/<skill-name>/SKILL.md` using this template:

```markdown
---
name: <skill-name>
description: <one dense paragraph packed with trigger phrases, scope, and explicit "use when"; pack EN + 中文 trigger keywords if the user is bilingual>
---

# <Human Title>

<One-paragraph what-and-why.>

## When to use

- Concrete trigger 1
- Concrete trigger 2
- ...

Do NOT use for:
- Anti-trigger 1
- Anti-trigger 2

## Workflow

1. Step 1 — with verification command
2. Step 2 — ...

## Common issues

- Problem → fix

## References

- [link]
```

Rules for the body:

- **Actionable, not narrative.** Bullet lists, numbered steps, code blocks with real commands. No "let's explore the options" prose.
- **Embed verification commands.** After every mutating step, show the command that proves it worked.
- **Cite sources.** Link to the GitHub repos, docs, or articles the skill depends on.
- **Add supporting files only if they pay for themselves.** A `template.md`, `check.sh`, or `examples/` dir is fine; random boilerplate is not. Prefer one strong SKILL.md over a sprawling bundle.

### Step 3 — Self-review the frontmatter

Before committing, verify:

- `name:` exactly matches the directory name.
- `description:` contains at least one user-language trigger phrase ("用来...", "use when...") so the agent reliably activates it.
- No secrets, absolute user paths that vary across machines, or machine-specific hostnames in `SKILL.md`.
- `SKILL.md` renders as valid markdown (`head -5 SKILL.md` should show the `---` fences and three fields at most).

Quick lint:

```bash
head -10 ~/Projects/agent-skills/<skill-name>/SKILL.md
```

### Step 4 — Update the repo README (only when adding a new skill)

Append a short entry under "Skills included" in `~/Projects/agent-skills/README.md` with the skill name, one-line purpose, and the trigger. Skip this for pure edits to an existing skill.

### Step 5 — Commit and push

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

### Step 6 — Fan out to every agent

Two cases:

**Case A — brand new skill, never installed from this repo on this machine.**

```bash
npx --yes skills add LeoLiang-zihao/agent-skills -g -a '*' --all -y
```

**Case B — existing skill edited, or new skill added to a repo already installed.**

```bash
npx --yes skills update -g -y
```

Either way, verify coverage:

```bash
npx --yes skills list -g --json | python3 -c "
import json, sys
data = json.load(sys.stdin)
for s in data:
    if s['scope'] == 'global':
        print(f\"{s['name']:<30} {len(s['agents']):>3} agents\")
"
```

Expected: the new/updated skill appears with 25+ agents listed.

Also sanity-check the universal path — this is what Cursor, Codex, Antigravity, and Gemini CLI all read from:

```bash
ls ~/.agents/skills/<skill-name>/SKILL.md
```

And per-agent symlinks (Claude Code and Pi have their own homes that the CLI symlinks):

```bash
ls -la ~/.claude/skills/<skill-name> 2>/dev/null
ls -la ~/.pi/agent/skills/<skill-name> 2>/dev/null
```

If any of these are missing, re-run `npx --yes skills update -g -y` and then `npx --yes skills add LeoLiang-zihao/agent-skills -g -a '*' --all -y` as a fallback.

## Agents covered (as of this skill's creation)

Universal path `~/.agents/skills/` is read natively by: **Cursor, Codex, Antigravity, Gemini CLI, OpenCode, Crush, Goose, Windsurf, Continue, and every other VSCode/Gemini-family agent that honors the `.agents/skills/` convention.**

The `skills` CLI additionally creates symlinks for: Augment, IBM Bob, Claude Code, OpenClaw, CodeBuddy, Command Code, Continue, Cortex Code, Crush, Droid, Goose, Junie, iFlow CLI, Kilo Code, Kiro CLI, Kode, MCPJam, Mistral Vibe, Mux, OpenHands, Pi, Qoder, Qwen Code, Roo Code, Trae, Trae CN, Windsurf, Zencoder, Neovate, Pochi, AdaL.

Net result: a single `git push` + `npx skills update -g` makes the skill live in ~45 coding agents without per-agent configuration.

## Common issues and fixes

| Symptom | Cause | Fix |
|---|---|---|
| New skill not visible to any agent | Forgot to push, or repo not yet registered on this machine | `git push`, then `npx --yes skills add LeoLiang-zihao/agent-skills -g -a '*' --all -y` |
| Visible to Cursor but not Claude Code / Pi | Only the universal path updated, per-agent symlinks stale | `npx --yes skills update -g -y`; if still missing, remove stale entry and re-add: `npx skills remove -g -s <skill-name> -a '*' -y` then `npx skills add ... --all -y` |
| Old copy of skill in `~/.cursor/skills/<name>/` | Legacy per-agent install from before global universal path | Delete the redundant copy: `rm -rf ~/.cursor/skills/<skill-name>` (same for `~/.codex/skills/<name>`, etc.) |
| Agent reads `SKILL.md` but never fires it | `description:` too vague or missing trigger phrases | Rewrite `description:` with explicit "use when …" clauses and trigger keywords in the user's language |
| Changes pushed but `npx skills update -g` says "up to date" | Cached git refs | `cd ~/Projects/agent-skills && git log -1` to confirm push landed; then retry update with `--yes` |
| YAML frontmatter parse error | Missing `---` fence, tabs in YAML, or unescaped colons in description | Keep description a single line, use only spaces, wrap values with problematic chars in double quotes |

## Cross-machine sync

On any new machine the user signs into:

```bash
npx --yes skills add LeoLiang-zihao/agent-skills -g -a '*' --all -y
```

That single command pulls the entire personal skill library and wires it into every supported agent on that machine. Periodic refresh:

```bash
npx --yes skills update -g -y
```

No manual copying, no per-agent config files, no dotfile symlink management.

## Output and hand-off

When this skill finishes, tell the user (concisely):

1. What was added or changed (skill name + one-line purpose).
2. Commit SHA and repo URL.
3. Number of agents now covered (from `skills list -g --json`).
4. Any agent that needs a restart to pick up the new skill (Cursor: yes for in-session prompt; Codex / Claude Code: next invocation).

Keep the final summary tight — the user cares about "it's live everywhere" more than about the mechanics.

## References

- `skills` CLI (Anthropic): https://github.com/anthropics/skills
- Skill authoring guide: https://github.com/anthropics/skills#authoring-skills
- Personal skill repo: https://github.com/LeoLiang-zihao/agent-skills
- Companion skill in this repo: `research-driven-plan`
