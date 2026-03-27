# Math Editor Demo Recorder

Records MP4 demo videos of the Math Editor using Playwright.

## Prerequisites

1. **Node.js** — `npm install` in this directory
2. **Playwright Chromium** — `npm run install-browsers`
3. **ffmpeg** (optional, for MP4 conversion) — `brew install ffmpeg` on macOS
4. **Local server** — Math Editor must be running (e.g. `http://localhost:8080`)

## Usage

```bash
# Start your app server first, then:
DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-math-demo.js
```

Or use the npm script:

```bash
DEMO_URL=http://localhost:8080/mywebapp2_war_exploded/ npm run demo:math

# Integral calculator (step-by-step demo)
DEMO_URL=http://localhost:8080/mywebapp2_war_exploded/ npm run demo:integral

**Video size:** default **1920×1080** (same as `VIEWPORT` in `helpers.js`). Override with  
`DEMO_VIEWPORT=1280x720` (width×height) if you need a smaller frame.
```

## Scripts

| Script | Output | Description |
|--------|--------|-------------|
| `record-math-demo.js` | `math-editor-hero-demo.mp4` | Full hero demo: typing, compute, graphs |
| `record-integral-calculator-demo.js` | `integral-calculator-demo.mp4` | Integral calculator: by-parts, u-sub, definite + Show Steps |
| `record-slash-demo.js` | `slash-commands-demo.mp4` | Slash menu and formatting |
| `record-drawing-demo.js` | `drawing-demo.mp4` | Drawing canvas and diagrams |
| `convert-to-mp4.js` | — | Batch convert .webm → .mp4 |

## Output

- Videos are saved to `demo-recorder/output/`
- Format: `.webm` (always) and `.mp4` (if ffmpeg is installed)
- Viewport: 1280×720

## Flow

1. Launches Chromium (visible, not headless)
2. Navigates to the Math Editor and performs the demo script
3. On completion, closes browser and converts WebM → MP4 via ffmpeg

## Troubleshooting

- **"Playwright not found"** — Run `npm install` and `npm run install-browsers`
- **"ffmpeg not found"** — WebM is still saved; convert manually:  
  `ffmpeg -i output/math-editor-hero-demo.webm -c:v libx264 -crf 22 output/math-editor-hero-demo.mp4`
- **Selector fails** — Editor UI may have changed; update selectors in `helpers.js` or the record scripts
