# agent-skills

Personal agent skills for [Cursor](https://cursor.com), [Codex](https://github.com/openai/codex), [Claude Code](https://docs.claude.com/en/docs/claude-code), [Pi](https://github.com/badlogic/pi-mono), and any other coding agent that reads the `.agents/skills/` or per-agent skills directory.

Synced across machines and agents via [`npx skills`](https://github.com/anthropics/skills).

## Install everything (own skills + third-party) on a new machine

Two-step bootstrap. Run once per new laptop:

```bash
git clone git@github.com:LeoLiang-zihao/agent-skills.git ~/Projects/agent-skills
cd ~/Projects/agent-skills && ./scripts/bootstrap.sh
```

This:

1. Installs every skill authored in this repo to all agents via `npx skills add`.
2. Reads [`external-skills.json`](./external-skills.json) and replays each third-party `npx skills add <repo> -s <skill>` command, so skills I use from upstream repos (Vercel, Anthropic, etc.) also land on the new machine.

To refresh any time:

```bash
~/Projects/agent-skills/scripts/bootstrap.sh --update
```

## Install only this repo's own skills (no manifest)

```bash
npx --yes skills add LeoLiang-zihao/agent-skills -g -a '*' --all -y
```

Places skills under:

- `~/.agents/skills/` — universal (Cursor, Codex, Antigravity, Gemini CLI, OpenCode, etc.)
- `~/.claude/skills/` — Claude Code
- `~/.codebuddy/skills/`, `~/.pi/agent/skills/`, etc. — symlinked for per-agent layouts

## Install into a single project

```bash
cd /path/to/project
npx --yes skills add LeoLiang-zihao/agent-skills -a '*' --all -y
```

## Adding a third-party skill (keep cross-machine sync working)

Never run a bare `npx skills add <third-party-repo>` — it only affects the current machine. Instead:

1. `npx --yes skills add <owner>/<repo> -g -a '*' -s <skill-name> -y`
2. Append the `{repo, skills, note}` entry to [`external-skills.json`](./external-skills.json).
3. Commit + push.

The `publish-agent-skill` skill automates this (Track B). See its `SKILL.md` for the exact workflow.

## Skills included

### `research-doc`

Stage 1 of a three-stage human-gated pipeline: `research.md` (this skill) → human review → `plan.md` (next agent) → human review → implementation. Produces a structured `research.md` with clarifying questions, frontier-product/paper search with pain-point analysis, trade-off tables, and citations — then stops. Does not write a plan or code.

**Use when** the user asks to research, investigate options, do tech selection, propose architectures, compare approaches, or when a task is large or ambiguous enough that jumping straight to code risks wasted work.

### `plan-from-research`

Stage 2 of the 3-stage pipeline (`research-doc` → **this** → implementation). Consumes an approved `research.md` and produces an execution-ready `plan.md` for frontend, backend, data, or full-stack work. Preserves the chosen direction from research, expands each roadmap row into concrete phases with files-to-change, verification, rollback, compatibility, and brief load-bearing skeletons, then stops. Halts and routes the user back to `research-doc` if the research is missing, draft, or has unresolved open questions.

**Use when** the user says "write a plan", "write implementation plan / implementation md", "refactor plan", "根据 research.md 写 plan", "写实现方案", "写一个 plan.md".

### `publish-agent-skill`

Two-track workflow for shipping **any** skill to every coding agent on the machine AND keeping the central repo authoritative so new machines can replay the install. **Track A** — author a new personal skill here (scaffold `SKILL.md`, trigger-rich `description`, commit, push, `npx skills update -g`). **Track B** — install a third-party skill from someone else's repo AND record it in `external-skills.json` so `bootstrap.sh` on future machines restores it.

**Use when** the user asks to create, update, or sync a skill; or to install a third-party skill (`vercel-labs/agent-skills`, `anthropics/skills`, etc.); or to troubleshoot a skill that is not being picked up.

### `frontend-design`

Design-first frontend implementation skill for building distinctive, production-grade UIs with a clear aesthetic point of view instead of generic AI-looking layouts. Pushes the agent to choose an intentional visual direction, make typography and palette decisions that carry character, and implement real working code with refined motion, spacing, and composition.

**Use when** the user asks to build or restyle a web page, landing page, dashboard, React component, HTML/CSS artifact, poster, or any interface where visual quality and taste are part of the task.

### `youtube-content`

Fetch a YouTube video's transcript via `youtube-transcript-api` and reshape it into the format the user asks for — summary, chapters, chapter summaries, Twitter/X thread, blog post, or quote reel. Accepts every YouTube URL variant (`watch?v=`, `youtu.be/`, `shorts/`, `embed/`, `live/`) or a raw 11-char video ID, supports a language fallback chain (e.g. `--language zh-Hans,zh,en`), and chunks long transcripts before summarizing.

**Use when** the user pastes a YouTube link, asks to "summarize / 总结 / 写摘要", extract "chapters / 章节", pull "quotes / 金句", or turn a talk into a "thread / 推文" or "blog post / 博客".

## Adding new skills (authoritative: `publish-agent-skill` skill)

An agent with `publish-agent-skill` loaded does both tracks automatically. Manual shortcut for humans:

**Track A — new personal skill:**

1. `mkdir ~/Projects/agent-skills/<skill-name>/`
2. Write `<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`).
3. Append an entry to "Skills included" above.
4. Commit + push.
5. `npx skills update -g -y` on any machine to pick it up.

**Track B — third-party skill:**

1. `npx --yes skills add <owner>/<repo> -g -a '*' -s <skill-name> -y`.
2. Append to `external-skills.json`:
   ```json
   { "repo": "<owner>/<repo>", "skills": ["<skill-name>"], "note": "why installed" }
   ```
3. Commit + push.
4. Any future machine runs `./scripts/bootstrap.sh` and gets the same set.

See the [official skills authoring guide](https://github.com/anthropics/skills#authoring-skills) for `SKILL.md` structure.

## License

MIT
