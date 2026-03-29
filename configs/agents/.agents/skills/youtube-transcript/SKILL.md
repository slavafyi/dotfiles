---
name: youtube-transcript
description: Fetches timestamped transcripts from YouTube videos. Use when a user shares a YouTube URL or video ID and needs captions for summarization, note-taking, quote extraction, or analysis.
compatibility: Requires Node.js 22.18.0 or later, pnpm or npm, and internet access. Uses Node's native TypeScript type stripping.
metadata:
  tags: youtube, transcript, captions, summarization, research, video
---

# YouTube Transcript

## When to use

Use this skill when the task involves:
- a YouTube video URL or 11-character video ID
- getting the transcript before summarizing or analyzing a video
- extracting timestamped quotes or notes from a video

## Setup

If this skill is installed as part of a workspace, install dependencies from the workspace root:

```bash
pnpm install
```

If you copy the skill somewhere else, install dependencies from the copied skill directory with `pnpm install` or `npm install`.

Optional validation from the skill directory:

```bash
pnpm run typecheck
```

## Usage

From the skill directory, run:

```bash
pnpm run transcript -- <video-id-or-url>
```

You can also invoke the script directly:

```bash
node scripts/transcript.ts <video-id-or-url>
```

Accepted inputs:
- `EBw7gsDPAYQ`
- `https://www.youtube.com/watch?v=EBw7gsDPAYQ`
- `https://youtu.be/EBw7gsDPAYQ`

## Output

The script prints timestamped transcript lines:

```text
[0:00] All right. So, I got this UniFi Theta
[0:15] I took the camera out, painted it
[1:23] And here's the final result
```

## Notes

- Requires captions/transcripts to be available for the video
- Works with both auto-generated and manual transcripts
- Prints an error and exits non-zero when the transcript cannot be fetched
