---
name: summarize-video
description: Install, configure, and use summarize.sh for URLs, YouTube, podcasts, PDFs, media, and local files.
---

# SKILL.md: Summarize Video

**Skill Name**: Summarize Video
**Purpose**: End-to-end use of summarize.sh for URLs, YouTube/videos, podcasts, articles, transcripts, PDFs, media files, images, and local files
**Invocation**: `summarize` CLI binary, `~/.local/bin/summarize` launcher, or `npx -y @steipete/summarize`
**Docs**: https://summarize.sh/docs/quickstart.html

---

## Description

Use the summarize.sh CLI to summarize or extract clean text from URLs, local files, YouTube links, podcasts, media, PDFs, images, or stdin. The default command is `summarize <url|file|->`; other subcommands are secondary.

## When to Use

Use this skill immediately when the user asks any of:

- "use summarize.sh"
- "what's this link/video about?"
- "summarize this URL/article/PDF/file"
- "summarize this YouTube video/podcast"
- "transcribe this YouTube/video/audio"
- "extract this article/transcript without summarizing"

## Operating Workflow

1. Detect whether `summarize` exists:

```bash
bash .github/skills/summarize-video/scripts/bootstrap.sh --verify
```

2. If missing, automate setup as far as the environment allows. The helper uses npm when Node 24+ is active, attempts `nvm install 24` when nvm exists, installs a local launcher in `~/.local/bin/summarize`, and falls back to Homebrew when available:

```bash
bash .github/skills/summarize-video/scripts/bootstrap.sh --install --config --cli-provider codex --verify
```

If sandboxing or permissions block install/config writes, request approval and rerun the same command with escalation. If the user wants a one-shot run without installing, use:

```bash
npx -y @steipete/summarize "https://example.com"
```

3. Ensure one model path is available. Prefer an existing logged-in CLI backend with `--cli codex`, `--cli claude`, or `--cli gemini`; otherwise use an exported provider key such as `OPENAI_API_KEY`, `GEMINI_API_KEY`, or `OPENROUTER_API_KEY`.

4. Run the requested summary or extraction. Keep stdout for the result and stderr for progress/warnings. Use `--json` only when the caller needs machine-readable output.

5. If the user asked for a transcript and it is huge, return a tight summary first, then ask which section or time range to expand.

## Install Notes

Requirements:

- Node 24 or newer for the npm package; the bootstrap helper can install/use Node 24 through nvm when nvm is present.
- macOS, Linux, Windows, containers, and WSL2 are supported.
- Optional media tools: `ffmpeg`, `yt-dlp`, `tesseract`, and `whisper.cpp`.

Install paths from the docs:

```bash
npm i -g @steipete/summarize
brew install summarize
npx -y @steipete/summarize "https://example.com"
```

For media-heavy work, install optional dependencies when available:

```bash
bash .github/skills/summarize-video/scripts/bootstrap.sh --install-media
```

The bootstrap helper also installs a local launcher in `~/.local/bin/summarize` so fresh shells can run `summarize` without manually sourcing `nvm`.

## Common Commands

Summarize a web page:

```bash
summarize "https://example.com"
```

Summarize a YouTube video or podcast:

```bash
summarize "https://youtu.be/I845O57ZSy4"
summarize "https://podcasts.apple.com/.../episode-..."
```

Summarize a local file or stdin:

```bash
summarize ./report.pdf
summarize ./meeting.m4a
summarize ./diagram.png
summarize -
```

Extract clean text without a full LLM summary:

```bash
summarize "https://example.com" --extract --format md
summarize "https://youtu.be/..." --extract --format md --markdown-mode llm
```

Get JSON for scripts:

```bash
summarize "https://example.com" --json --metrics detailed
```

Control output length:

```bash
summarize "https://example.com/long-article" --length short
summarize "https://example.com/long-article" --length 3k
summarize "https://example.com/long-article" --length 30000
```

Use a local CLI backend:

```bash
summarize "https://example.com" --cli codex
summarize "https://example.com" --cli claude
summarize "https://example.com" --cli gemini
```

## Useful Flags

- `--length short|medium|long|xl|xxl|<chars>` controls summary size; default is `xl`.
- `--extract` returns clean extracted text instead of a summary.
- `--format md` saves extracted content as Markdown.
- `--markdown-mode llm` lightly formats raw transcripts into headings and paragraphs.
- `--json` writes a stable JSON envelope to stdout.
- `--plain` makes terminal output easier to parse.
- `--timeout <duration>` caps fetch and model calls, for example `30s` or `2m`.
- `--metrics off|on|detailed` controls token/timing metrics.
- `--slides` adds scene-change keyframes for video.
- `--slides-ocr` OCRs slide/keyframe text when `tesseract` is available.
- `--cli <provider>` forces a local CLI backend such as `codex`, `claude`, `gemini`, `agent`, `openclaw`, `opencode`, or `copilot`.

## Config

Optional config file: `~/.summarize/config.json`. Use the bootstrap helper to create a conservative default:

```bash
bash .github/skills/summarize-video/scripts/bootstrap.sh --config --cli-provider codex
```

Default shape:

```json
{
  "model": "auto",
  "output": {
    "length": "long",
    "language": "auto"
  },
  "youtube": "auto",
  "firecrawl": "auto",
  "cli": {
    "enabled": ["claude", "gemini", "codex", "agent", "openclaw", "opencode", "copilot"],
    "autoFallback": {
      "enabled": true,
      "onlyWhenNoApiKeys": true,
      "order": ["claude", "gemini", "codex", "agent", "openclaw", "opencode", "copilot"]
    }
  }
}
```

`cli.enabled` is the allowlist for explicit `--cli` and `cli/...` model use. `cli.autoFallback` controls implicit auto mode when no model is selected. Set API keys in the process environment first; `env` in config is a fallback for non-secret defaults.

## Troubleshooting

- `summarize: command not found`: run the bootstrap helper with `--install`, or use the `npx -y @steipete/summarize ...` one-shot form.
- Node is too old: install Node 24+ or use Homebrew if available.
- Provider/model failure: try `--cli codex`, set a provider key, or use `OPENROUTER_API_KEY` plus `summarize refresh-free`.
- YouTube/media extraction is weak: install optional media dependencies with `--install-media`.
- Scripts need parseable output: use `--json`, `--plain`, and avoid relying on stderr progress text.
