---
name: pi-docs-assistant
description: Use when the user asks about pi itself — how pi works, what pi can do, how to build or configure pi extensions/themes/skills/prompt templates/TUI/keybindings/SDK integrations/custom providers/models/packages, or why pi behaves a certain way. 当用户问“pi 是怎么工作的”“pi 的 SDK / extension / theme / skill / prompt template / TUI / model / provider 怎么写或怎么配”“pi 为什么会知道某些上下文”时，先触发这个 skill。 Read the locally installed pi docs and examples first, then answer or implement from those sources instead of relying on memory. Follow Markdown cross-references for related APIs and examples before making claims about pi-specific behavior.
---

# Pi Docs Assistant

Use local pi documentation and examples as the source of truth for pi-specific questions and implementation tasks.

## When to use

- The user asks how pi works internally or where its behavior comes from.
- The user asks about pi extensions, themes, skills, prompt templates, TUI components, keybindings, SDK usage, custom providers, models, or pi packages.
- The user wants code or configuration for pi itself, not for a generic app.
- The user asks why pi loaded certain context files, tools, prompts, or skills.

Do NOT use for:
- Generic app development unrelated to pi.
- Third-party agent harnesses unless the user explicitly wants a pi comparison.
- Guessing undocumented pi APIs from memory without checking local docs.

## Workflow

1. Identify the exact pi subtopic.
   - Map the request to the primary doc:
     - overview / context files / startup behavior → `README.md`
     - extensions → `docs/extensions.md`
     - themes → `docs/themes.md`
     - skills → `docs/skills.md`
     - prompt templates → `docs/prompt-templates.md`
     - TUI components → `docs/tui.md`
     - keybindings → `docs/keybindings.md`
     - SDK / embedding → `docs/sdk.md`
     - custom providers → `docs/custom-provider.md`
     - models → `docs/models.md`
     - pi packages → `docs/packages.md`

2. Locate the local pi docs before answering.
   - Prefer a dynamic path instead of hard-coding a machine-specific one:
   ```bash
   PI_ROOT="$(npm root -g)/@mariozechner/pi-coding-agent"
   test -d "$PI_ROOT" && printf '%s\n' "$PI_ROOT"
   ```
   - If that fails, verify the package is installed:
   ```bash
   npm list -g --depth=0 @mariozechner/pi-coding-agent
   ```
   - Verification: the resolved directory should contain `README.md`, `docs/`, and `examples/`.

3. Read the primary Markdown file completely.
   - Read the whole `.md` file, not just a snippet, when the user is asking how pi works or how to implement against pi APIs.
   - If the doc references another pi Markdown file for details, read that file too before answering.
   - Verification: cite the exact local file path(s) you checked in your answer or implementation notes.

4. Read relevant examples when the task is implementation-oriented.
   - For SDK or extension work, inspect matching files under `examples/` after reading the docs.
   - For TUI or extension UI work, read `docs/tui.md` plus any cited examples before writing code.
   - Verification: mention which example file or doc section you relied on.

5. Answer from docs, not from memory.
   - Prefer: “According to `<path>` ...” or “The docs say ...”.
   - If the docs are ambiguous, say so explicitly and avoid inventing behavior.
   - When the user is bilingual, explain concepts in Chinese for understanding, but preserve important English API names and terms.

6. For implementation tasks, follow through with code/config changes only after doc review.
   - Re-check the relevant docs before using pi-specific hooks, events, or file locations.
   - Verification after edits:
   ```bash
   rg -n "<api-or-hook-name>" "$PI_ROOT/docs" "$PI_ROOT/examples" 2>/dev/null
   ```

## Topic checklist

### How pi gets context / “background knowledge”

Read these first:
- `README.md` → context files, system prompt, customization
- `docs/skills.md` → progressive disclosure and on-demand skill loading
- `docs/extensions.md` → `before_agent_start` and per-turn system prompt changes
- `docs/sdk.md` → `DefaultResourceLoader`, context files, skills, prompts, themes, and agentsFiles overrides

### Extensions

Read completely:
- `docs/extensions.md`
- `docs/tui.md` if the extension renders UI
- matching `examples/extensions/` files referenced by the docs

### Themes

Read completely:
- `docs/themes.md`
- any theme examples referenced there

### Skills

Read completely:
- `docs/skills.md`
- `docs/packages.md` if publishing/distributing via package

### Prompt templates

Read completely:
- `docs/prompt-templates.md`

### SDK

Read completely:
- `docs/sdk.md`
- matching `examples/sdk/` files mentioned by the docs

### Providers / models

Read completely:
- `docs/custom-provider.md`
- `docs/models.md`
- `docs/providers.md` when auth/setup details matter

## Common issues

- pi-specific answer looks hand-wavy → read the local docs first and cite the exact files.
- Only read one section but missed important linked behavior → follow Markdown cross-references before answering.
- Wrote extension or SDK code without checking examples → inspect `examples/` after reading the doc.
- User asks “why does pi know X?” → check context files, skills, extensions, and SDK resource loading docs together.
- Path to pi docs differs across machines → resolve via `npm root -g` instead of embedding a user-specific absolute path.

## References

- Pi repository: https://github.com/badlogic/pi-mono
- pi package: https://www.npmjs.com/package/@mariozechner/pi-coding-agent
- pi docs root: local installation under `@mariozechner/pi-coding-agent`
- Extensions docs: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/extensions.md
- SDK docs: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/sdk.md
- Skills docs: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/skills.md
