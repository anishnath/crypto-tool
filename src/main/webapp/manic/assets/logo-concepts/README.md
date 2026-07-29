# manic logo concepts (for review)

> **Adopted:** `logo-a-tree` is the official manic logo (2026-07-28) →
> `assets/manic-logo.svg` (vector) + `assets/manic-logo.png` (540×540 raster).
> The other three are kept here as alternates.

Four candidate directions for the manic mark. Each is a self-contained 540×540
SVG (navy badge + mark + `manic` wordmark), with a rendered PNG beside it.
Live gallery: https://claude.ai/code/artifact/ae0d7589-a1a4-4f16-878a-2c793f6d330a

| File | Concept | Idea | Read |
|------|---------|------|------|
| `logo-a-tree` | Recursive tree | manic's own intro figure — a `def branch()` recursion, gold trunk → magenta tips | True to the product; beautiful large, muddy at favicon size |
| `logo-b-text-motion` | text → motion | code lines → arrow → animated frames | Clearest story, but a *scene* not a monogram |
| `logo-c-motion-m` | Motion-path "m" | the letter drawn as an easing curve with keyframe nodes | **Strongest icon** — one idea, scales all the way down |
| `logo-d-strobe` | Strobe monogram | bold "m" with a fading echo trail | Most energetic; leans decorative, can read as a glitch |

**Recommendation:** `logo-c-motion-m` as the app icon / favicon, with `logo-a-tree`
kept as the "full" brand illustration for wide banners and the engine intro —
same story at two scales.

Palette (from `src/style.rs`): magenta `#FF2D95` · cyan `#00E5FF` ·
lime `#7CFF6B` · gold `#FFD166` · navy `#0B0E17`.

## Regenerate / re-render

The SVGs are emitted by `scripts/gen-logos.py` (baked so the recursive tree is
deterministic). PNG previews:

```sh
for f in logo-a-tree logo-b-text-motion logo-c-motion-m logo-d-strobe; do
  rsvg-convert -w 540 -h 540 "$f.svg" -o "$f.png"
done
```

Notes for the finalist: the wordmark uses the system monospace face for preview —
the production file will outline it for portability. Once a direction is chosen it
replaces `assets/manic-logo.png`, and (since it's manic) I'll also author a
`.manic` scene that *draws* the mark so it's regenerable by the engine.
