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

### `publish-agent-skill`

Two-track workflow for shipping **any** skill to every coding agent on the machine AND keeping the central repo authoritative so new machines can replay the install. **Track A** — author a new personal skill here (scaffold `SKILL.md`, trigger-rich `description`, commit, push, `npx skills update -g`). **Track B** — install a third-party skill from someone else's repo AND record it in `external-skills.json` so `bootstrap.sh` on future machines restores it.

**Use when** the user asks to create, update, or sync a skill; or to install a third-party skill (`vercel-labs/agent-skills`, `anthropics/skills`, etc.); or to troubleshoot a skill that is not being picked up.

### `frontend-design`

Design-first frontend implementation skill for building distinctive, production-grade UIs with a clear aesthetic point of view instead of generic AI-looking layouts. Pushes the agent to choose an intentional visual direction, make typography and palette decisions that carry character, and implement real working code with refined motion, spacing, and composition.

**Use when** the user asks to build or restyle a web page, landing page, dashboard, React component, HTML/CSS artifact, poster, or any interface where visual quality and taste are part of the task.

### `taac-unirec-dl`

Competition-grade deep-learning workflow for TAAC 2026 Tencent UNI-REC and related Tencent Ads Algorithm Competition recommender-system work. It forces agents to inspect official code/data first, use BTCA for official baseline search when needed, preserve dataset schema and evaluator fidelity, and develop Transformer/SASRec/semantic-ID changes through reproducible PyTorch experiments.

**Use when** working on TAAC, Tencent UNI-REC, Tencent Ads Algorithm Competition, Transformer RecSys, SASRec, semantic IDs, sequence modeling, feature interaction, retrieval/ranking, or competition submissions.

### `youtube-content`

Fetch a YouTube video's transcript via `youtube-transcript-api` and reshape it into the format the user asks for — summary, chapters, chapter summaries, Twitter/X thread, blog post, or quote reel. Accepts every YouTube URL variant (`watch?v=`, `youtu.be/`, `shorts/`, `embed/`, `live/`) or a raw 11-char video ID, supports a language fallback chain (e.g. `--language zh-Hans,zh,en`), and chunks long transcripts before summarizing.

**Use when** the user pastes a YouTube link, asks to "summarize / 总结 / 写摘要", extract "chapters / 章节", pull "quotes / 金句", or turn a talk into a "thread / 推文" or "blog post / 博客".

### `youtube-tech-deep-dive-site`

Turn a YouTube engineering or tech video into a polished HTML study site rather than a plain summary. The skill fetches the transcript with timestamps, reconstructs the speaker's real decision structure, and packages the result into a reusable learning page with sections like stack breakdowns, migration maps, skeptical reading, scenario mapping, and self-test prompts.

**Use when** the user asks for things like "把这个 YouTube 视频做成完整 tech deep dive", "做成 HTML 学习网站", "turn this tech talk into a study site", or "generate a transcript-backed learning page from this engineering video".

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
