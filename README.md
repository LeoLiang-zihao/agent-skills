# agent-skills

Personal agent skills for [Cursor](https://cursor.com), [Codex](https://github.com/openai/codex), [Claude Code](https://docs.claude.com/en/docs/claude-code), [Pi](https://github.com/badlogic/pi-mono), and any other coding agent that reads the `.agents/skills/` or per-agent skills directory.

Synced across machines and agents via [`npx skills`](https://github.com/anthropics/skills).

## Install globally (all agents, all projects on this machine)

```bash
npx --yes skills add LeoLiang-zihao/agent-skills -g -a '*' --all -y
```

This places the skills under:

- `~/.agents/skills/` — universal (Cursor, Codex, Antigravity, Gemini CLI, OpenCode, etc.)
- `~/.claude/skills/` — Claude Code
- `~/.codebuddy/skills/`, `~/.pi/skills/`, etc. — symlinked for per-agent layouts

## Install into a single project

```bash
cd /path/to/project
npx --yes skills add LeoLiang-zihao/agent-skills -a '*' --all -y
```

## Update to latest

```bash
npx --yes skills update -g
```

## Skills included

### `research-driven-plan`

Produces a structured research markdown document that prepares the next agent to write an implementation plan. Covers frontend, backend, aesthetic/design, and scientific research project tasks. Includes up-front clarifying questions, web search of frontier similar products and papers with pain-point analysis, trade-off tables, and citations to code repositories and online articles.

**Use when** the user asks to research, investigate options, do tech selection, propose architectures, compare approaches, or when a task is large or ambiguous enough that jumping straight to code risks wasted work.

### `publish-agent-skill`

Full workflow for authoring a new personal skill locally and shipping it to every coding agent on the machine (Cursor, Codex, Claude Code, Pi, Antigravity, Windsurf, Gemini CLI, and ~40 others). Covers scaffolding `SKILL.md`, writing a trigger-rich `description`, committing to this repo, fanning out with `npx skills update -g`, and verifying per-agent coverage.

**Use when** the user asks to create, update, or sync a skill to all their agents, or to troubleshoot a skill that is not being picked up.

## Adding new skills

The `publish-agent-skill` skill is the authoritative workflow for this repo; an agent with that skill loaded will do the right thing automatically. Manual version for humans:

1. Create a new directory at the repo root: `<skill-name>/`
2. Add `<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`)
3. Append an entry to the "Skills included" section above
4. Commit and push
5. Run `npx skills update -g -y` on any machine to pick it up

See the [official skills authoring guide](https://github.com/anthropics/skills#authoring-skills) for structure requirements.

## License

MIT
