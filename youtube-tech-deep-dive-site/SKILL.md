---
name: youtube-tech-deep-dive-site
description: "Turn a YouTube engineering or tech video into a complete HTML study site with transcript-backed deep dive, chaptered analysis, stack or architecture breakdowns, tradeoff summaries, and learning scaffolding such as timelines, scenario mapping, and quiz cards. Use when Codex should take a YouTube URL or video ID and produce a polished standalone HTML page rather than a plain summary, especially for requests like “把这个 YouTube 视频做成完整 tech deep dive”, “做成 HTML 学习网站”, “turn this video into a study site”, “make an HTML learning page from this tech talk”, or “把这个技术视频整理成可学习的网站”. Best for tech stack videos, architecture walkthroughs, AI tooling talks, devtool demos, and software engineering content that benefits from structured study. Prefer the official YouTube caption track first; only fall back to local transcription when the user has provided local audio or explicitly asks for a fallback."
---

# YouTube Tech Deep Dive Site

Build a reusable learning artifact, not a pretty transcript dump. The goal is to turn a YouTube tech video into a study page that helps the user revisit the material later: what the speaker chose, why they chose it, where the tradeoffs are, and how to apply the ideas.

## Do not use for

- Simple summary, chapters, quotes, or blog post requests with no HTML deliverable. Use `youtube-content`.
- Non-YouTube sources unless the user already supplied local media for transcription fallback.
- Pure frontend redesign tasks with no video-analysis component. Use `frontend-design`.

## Workflow

### 1. Capture the transcript with timestamps

Prefer the official caption track. If the global `youtube-content` skill is installed, use its helper:

```bash
python3 ~/.agents/skills/youtube-content/scripts/fetch_transcript.py "$URL" --text-only --timestamps > /tmp/video-transcript.txt
wc -l /tmp/video-transcript.txt
sed -n '1,80p' /tmp/video-transcript.txt
```

If the official transcript is empty or disabled:

- Retry without language pinning if you had specified one.
- Stop and tell the user transcripts appear disabled.
- Only fall back to `transcribe-audio` when the user has provided local audio/video or explicitly wants that route.

Do not hallucinate missing content.

### 2. Reconstruct the teaching structure before writing HTML

Do not write the page directly from raw transcript order. First extract the reusable structure:

- Core thesis: what is the speaker really arguing?
- Major layers or systems: stack layers, architecture blocks, workflow stages, or decision categories.
- Migrations: old approach -> new approach, and what changed.
- Tradeoffs: where the speaker is opinionated, biased, or conditional.
- Applicability: who should copy this, and who should not.
- Memorable review hooks: chapter timeline, principles, misconceptions, scenario mapping, quiz prompts.

For stack or tooling videos, prefer a layer-by-layer breakdown. For architecture or research talks, prefer concepts and system flow over vendor lists.

### 3. Choose a strong learning-page format

Default to a single-file HTML page unless the user asks for a larger site. If the global `frontend-design` skill is installed, follow its aesthetic guidance and make the page feel intentional, not generic.

Good default directions:

- Editorial technical manual
- Field guide / operating handbook
- Annotated architecture board
- Research notebook

Avoid generic dashboard UI unless the video itself is about dashboards.

### 4. Build the page around study value

Use the page to compress, organize, and challenge the source material. Load [references/page-blueprint.md](./references/page-blueprint.md) and adapt it rather than copying every section blindly.

Strong default sections:

- Hero / thesis
- Executive overview
- Interactive stack or concept map
- Old vs new migration view
- Timestamped chapter index
- Underlying principles
- Where to stay skeptical
- Scenario-based application
- Study path or self-test questions

Always link timestamp references back to the YouTube URL when possible.

### 5. Keep the content evidence-backed

When summarizing the speaker:

- Separate what the speaker explicitly says from your own interpretation.
- Do not present sponsored claims as neutral truth.
- Call out when a recommendation is workload-specific, maturity-specific, or team-specific.
- Preserve concrete timestamps for the most important claims.

If the transcript clearly shows uncertainty, flux, or “this might change soon”, keep that uncertainty in the page.

### 6. Verify the artifact locally

Before you finish, verify the page is actually usable:

```bash
python3 - <<'PY'
from html.parser import HTMLParser
from pathlib import Path
class P(HTMLParser):
    pass
p = P()
p.feed(Path("OUTPUT.html").read_text())
print("html_parse_ok")
PY
```

Then do a local visual pass:

- Open the HTML page in a browser.
- Check section navigation or anchor links.
- Check any interactive panels or tabs.
- Confirm the page still works on a narrow viewport.

If the page has interactive sections, verify that the content actually changes and is not a static mock.

### 7. Hand off clearly

In the final response, report:

- The generated file path.
- The page shape you chose.
- The most important content blocks included.
- Any fallback or limitation, such as transcript gaps or unverifiable sections.

## Common mistakes

- Treating the page as a transcript beautifier instead of a learning system.
- Copying every opinion without marking where it is conditional.
- Making the page visually fancy but intellectually flat.
- Forgetting to link timestamps back to the original video.
- Building a generic SaaS layout even when the content wants an editorial or handbook style.

## References

- [Page blueprint](./references/page-blueprint.md)
- `~/.agents/skills/youtube-content/SKILL.md`
- `~/.agents/skills/frontend-design/SKILL.md`
