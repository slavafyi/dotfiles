import { fetchTranscript } from 'youtube-transcript-plus'

const YOUTUBE_VIDEO_ID_PATTERN = /^[a-zA-Z0-9_-]{11}$/

type TranscriptEntry = {
  offset: number
  text: string
}

/**
 * Fetch and print a video's transcript.
 */
async function main(): Promise<void> {
  const args = process.argv.slice(2).map(argument => argument.trim()).filter(Boolean)
  const input = args[0] === '--' ? args[1] : args[0]

  if (!input) {
    console.error('Usage: node transcript.ts <video-id-or-url>')
    console.error('Example: node transcript.ts EBw7gsDPAYQ')
    console.error('Example: node transcript.ts https://www.youtube.com/watch?v=EBw7gsDPAYQ')
    process.exitCode = 1
    return
  }

  try {
    const transcript = toTranscriptEntries(await fetchTranscript(parseVideoId(input)))

    for (const entry of transcript) {
      console.log(`[${formatTimestamp(entry.offset)}] ${entry.text}`)
    }
  }
  catch (error: unknown) {
    const message = error instanceof Error ? error.message : String(error)
    console.error('Error:', message)
    process.exitCode = 1
  }
}

/**
 * Parse a YouTube video ID from a raw ID or supported URL.
 * @param {string} input Raw YouTube video ID or URL.
 * @returns {string} The validated YouTube video ID.
 */
function parseVideoId(input: string): string {
  if (YOUTUBE_VIDEO_ID_PATTERN.test(input)) {
    return input
  }

  let url: URL
  try {
    url = new URL(input)
  }
  catch {
    throw new TypeError('Expected a YouTube video ID or URL')
  }

  const hostname = url.hostname.replace(/^www\./, '')
  let videoId: string | null = null

  if (hostname === 'youtu.be') {
    videoId = url.pathname.split('/').filter(Boolean)[0] ?? null
  }
  else if (
    hostname === 'youtube.com'
    || hostname === 'm.youtube.com'
    || hostname === 'music.youtube.com'
    || hostname === 'youtube-nocookie.com'
  ) {
    if (url.pathname === '/watch') {
      videoId = url.searchParams.get('v')
    }
    else {
      const [prefix, id] = url.pathname.split('/').filter(Boolean)
      if (prefix === 'embed' || prefix === 'shorts' || prefix === 'live') {
        videoId = id ?? null
      }
    }
  }

  if (videoId && YOUTUBE_VIDEO_ID_PATTERN.test(videoId)) {
    return videoId
  }

  throw new TypeError('Could not extract a YouTube video ID from the provided URL')
}

/**
 * Validate the transcript payload returned by the library.
 * @param {unknown} value Transcript payload returned by the library.
 * @returns {TranscriptEntry[]} The validated transcript entries.
 */
function toTranscriptEntries(value: unknown): TranscriptEntry[] {
  if (!Array.isArray(value) || !value.every(isTranscriptEntry)) {
    throw new TypeError('Unexpected transcript response')
  }

  return value
}

/**
 * Check whether a value matches the transcript entry shape.
 * @param {unknown} value Value to validate.
 * @returns {boolean} True when the value matches the transcript entry shape.
 */
function isTranscriptEntry(value: unknown): value is TranscriptEntry {
  if (typeof value !== 'object' || value === null) {
    return false
  }

  const entry = value as Record<string, unknown>
  return typeof entry.offset === 'number' && typeof entry.text === 'string'
}

/**
 * Format a transcript offset as m:ss or h:mm:ss.
 * @param {number} seconds Transcript offset in seconds.
 * @returns {string} The formatted timestamp.
 */
function formatTimestamp(seconds: number): string {
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = Math.floor(seconds % 60)

  if (h > 0) {
    return `${h}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
  }

  return `${m}:${s.toString().padStart(2, '0')}`
}

void main()
