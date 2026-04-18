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

## Adding new skills

1. Create a new directory at the repo root: `<skill-name>/`
2. Add `<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`)
3. Commit and push
4. Run `npx skills update -g` on any machine to pick it up

See the [official skills authoring guide](https://github.com/anthropics/skills#authoring-skills) for structure requirements.

## License

MIT
