---
name: youtube-content
description: "Fetch a YouTube video's transcript and transform it into structured content — summary, chapters, chapter summaries, Twitter/X thread, blog post, or quote reel. Use when the user shares any YouTube URL (youtube.com/watch, youtu.be, shorts, embed, live) or a raw 11-char video ID, asks to summarize / 总结 / 写摘要 / 提炼要点 a video, requests a transcript / 字幕 / 逐字稿, wants chapters / 章节 / 时间戳, or asks to turn a talk into a thread / 推文 / 博客 / 文章 / 金句. 用来抓 YouTube 视频字幕并生成摘要、章节、推文、博客、金句等结构化内容。Skip for non-YouTube video sources (Bilibili, Vimeo, local files) — different tooling."
---

# YouTube Content Tool

Fetch a YouTube video's transcript via `youtube-transcript-api`, then reshape it into whatever format the user wants. No scraping, no yt-dlp; just the official caption track.

## When to use

- User pastes a YouTube URL (any format: `watch?v=`, `youtu.be/`, `shorts/`, `embed/`, `live/`) or raw 11-char ID.
- User asks to **summarize / 总结**, **transcribe / 字幕 / 逐字稿**, **extract chapters / 章节**, **quote / 金句**, **turn into a thread / 推文 / 线程**, or **write a blog post / 博客 / 文章** from a video.
- User asks to pull subtitles in a specific language (`--language tr,en` fallback chain).

Do NOT use for:

- Non-YouTube videos (Bilibili, Vimeo, TikTok, local files). Different toolchains.
- Videos with transcripts disabled — detect early and tell the user, don't guess content.
- Pure audio transcription tasks with no caption track — use the `transcribe-audio` skill + `whisper-cpp`.

## Setup (one-time per machine)

```bash
pip install youtube-transcript-api
python3 -c "import youtube_transcript_api; print(youtube_transcript_api.__version__)"
```

`SKILL_DIR` below is the directory containing this `SKILL.md`. When an agent loads this skill, substitute the actual absolute path (`~/.agents/skills/youtube-content/` on most machines).

## Helper script

`scripts/fetch_transcript.py` accepts any YouTube URL variant or a raw video ID.

```bash
# JSON with metadata (default)
python3 SKILL_DIR/scripts/fetch_transcript.py "https://youtube.com/watch?v=VIDEO_ID"

# Plain text only — good for piping into an LLM or grep
python3 SKILL_DIR/scripts/fetch_transcript.py "URL" --text-only

# Text with timestamps (use this for chapter / quote tasks)
python3 SKILL_DIR/scripts/fetch_transcript.py "URL" --text-only --timestamps

# Language fallback chain (first that matches wins)
python3 SKILL_DIR/scripts/fetch_transcript.py "URL" --language zh-Hans,zh,en
```

Exit status is non-zero on error; JSON/stderr includes a human-readable reason.

## Workflow (always follow)

1. **Fetch** — call the helper with `--text-only --timestamps` unless the user explicitly only wants plain text or raw JSON. Example:

   ```bash
   python3 SKILL_DIR/scripts/fetch_transcript.py "$URL" --text-only --timestamps > /tmp/yt.txt
   wc -l /tmp/yt.txt   # verify non-empty
   ```

2. **Validate** — confirm the transcript is non-empty and in the expected language. If empty, retry without `--language` to accept any track. If still empty, stop and tell the user transcripts appear disabled.

3. **Chunk if needed** — if the transcript exceeds ~50K characters, split into overlapping chunks (~40K body + 2K overlap), summarize each chunk, then merge. Keep section timestamps from the first chunk each range appears in.

4. **Transform** into the requested output format (see below). If the user did not specify a format, default to a **summary + chapters** combo.

5. **Verify** — re-read your output and check: timestamps are monotonically increasing, in `MM:SS` or `H:MM:SS` format, and actually exist in the transcript; the final language matches what the user asked for; no hallucinated facts beyond what the transcript supports.

## Output formats

Concrete examples live in [`references/output-formats.md`](./references/output-formats.md). Quick menu:

- **Summary** — 5–10 sentence overview of the whole video.
- **Chapters** — timestamped list of topic shifts, one line each.
- **Chapter summaries** — each chapter plus a short paragraph.
- **Thread** — numbered Twitter/X posts, each ≤ 280 chars, ending with source URL.
- **Blog post** — title, intro, H2 sections with quotes, takeaways.
- **Quotes** — notable lines with timestamps.

## Error handling

| Symptom | Fix |
|---|---|
| `Transcripts are disabled for this video.` | Tell the user; suggest checking if subtitles show on the video page, or falling back to `transcribe-audio`. |
| `No transcript found` for the requested language | Retry without `--language`; note to the user which language actually came back. |
| `ImportError: youtube_transcript_api` | `pip install youtube-transcript-api` and retry. |
| Private / age-gated / region-blocked video | Relay the upstream error verbatim and ask the user to confirm the URL or provide a transcript manually. |
| URL parse fails | The regex accepts `watch?v=`, `youtu.be/`, `shorts/`, `embed/`, `live/`, and raw 11-char IDs. If none match, the script treats the input as a raw ID — double-check with the user. |

## References

- `youtube-transcript-api`: https://github.com/jdepoix/youtube-transcript-api
- Output format examples: [`references/output-formats.md`](./references/output-formats.md)
- Sibling skill for non-captioned audio: `transcribe-audio`
