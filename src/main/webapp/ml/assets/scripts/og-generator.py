"""
og-generator.py — generate Open Graph / Twitter card images for each ML page.

Writes SVG into webapp/images/site/<slug>.svg, then converts each to
PNG via rsvg-convert (1200×630, the OG standard).  PNG is what social
crawlers actually fetch; we keep the SVG checked in for editing.

Run:
    cd src/main/webapp/ml/assets/scripts
    python3 og-generator.py

Requires:  rsvg-convert  (brew install librsvg)
"""
from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

# ── Page metadata ──────────────────────────────────────────
# Each entry produces one SVG + PNG pair.  The colour matches the
# section accent used on the live page.
PAGES = [
    {
        "slug": "ml-visualized-og",
        "title": "Machine Learning,",
        "title_em": "visualized",
        "subtitle": "Eight interactive demos. Real algorithms, in your browser.",
        "section": "/ml",
        "color": "#4f46e5",
        "color_soft": "rgba(79, 70, 229, 0.18)",
    },
    {
        "slug": "gradient-descent-og",
        "title": "Gradient Descent,",
        "title_em": "visualized",
        "subtitle": "Watch a regression line learn its slope and intercept — one epoch at a time.",
        "section": "Optimization",
        "color": "#4f46e5",
        "color_soft": "rgba(79, 70, 229, 0.18)",
    },
    {
        "slug": "activation-functions-og",
        "title": "Activation Functions,",
        "title_em": "visualized",
        "subtitle": "Sigmoid, ReLU, GELU, Swish — function + derivative, side by side.",
        "section": "Optimization",
        "color": "#4f46e5",
        "color_soft": "rgba(79, 70, 229, 0.18)",
    },
    {
        "slug": "k-means-og",
        "title": "K-Means,",
        "title_em": "visualized",
        "subtitle": "Watch centroids snap. See where it fails: moons, rings, anisotropic blobs.",
        "section": "Clustering",
        "color": "#14b8a6",
        "color_soft": "rgba(20, 184, 166, 0.20)",
    },
    {
        "slug": "pca-og",
        "title": "PCA,",
        "title_em": "visualized",
        "subtitle": "Principal components on a 3D point cloud. Scree plot + variance retained.",
        "section": "Reduction",
        "color": "#14b8a6",
        "color_soft": "rgba(20, 184, 166, 0.20)",
    },
    {
        "slug": "perceptron-og",
        "title": "Perceptron,",
        "title_em": "visualized",
        "subtitle": "3D hyperplane that learns by Novikoff's theorem — or fails on XOR.",
        "section": "Linear Models",
        "color": "#ec4899",
        "color_soft": "rgba(236, 72, 153, 0.20)",
    },
    {
        "slug": "logistic-regression-og",
        "title": "Logistic Regression,",
        "title_em": "visualized",
        "subtitle": "Sigmoid boundary, cross-entropy loss, gradient descent — click to add points.",
        "section": "Linear Models",
        "color": "#ec4899",
        "color_soft": "rgba(236, 72, 153, 0.20)",
    },
    {
        "slug": "roc-auc-og",
        "title": "ROC, AUC & PR,",
        "title_em": "visualized",
        "subtitle": "Drag the threshold. Watch the operating point sweep. AUC interpretation bands.",
        "section": "Evaluation",
        "color": "#ec4899",
        "color_soft": "rgba(236, 72, 153, 0.20)",
    },
    {
        "slug": "ml-pipeline-og",
        "title": "ML Pipeline,",
        "title_em": "end to end",
        "subtitle": "Six stages from dataset to deployment — interactive walkthrough.",
        "section": "Lifecycle",
        "color": "#4f46e5",
        "color_soft": "rgba(79, 70, 229, 0.18)",
    },
    {
        "slug": "nn-architecture-og",
        "title": "Neural Network Architecture,",
        "title_em": "visualized",
        "subtitle": "FCNN, LeNet, AlexNet — interactive SVG export of every layer.",
        "section": "Neural Nets",
        "color": "#8b5cf6",
        "color_soft": "rgba(139, 92, 246, 0.20)",
    },
]


# ── SVG template ───────────────────────────────────────────
# Inline fonts as Google Fonts via @import inside <style>.  rsvg-convert
# can't fetch external resources, so we fall back to system serif/sans
# but the inline Instrument Serif / Inter face names still ride through
# the SVG itself (useful if someone opens the SVG in a browser).
SVG_TEMPLATE = """<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630" width="1200" height="630">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#fefdfb"/>
      <stop offset="100%" stop-color="#f7f6f3"/>
    </linearGradient>
    <radialGradient id="accent" cx="0%" cy="0%" r="80%">
      <stop offset="0%" stop-color="{color}" stop-opacity="0.16"/>
      <stop offset="60%" stop-color="{color}" stop-opacity="0.04"/>
      <stop offset="100%" stop-color="{color}" stop-opacity="0"/>
    </radialGradient>
    <radialGradient id="accent2" cx="100%" cy="100%" r="60%">
      <stop offset="0%" stop-color="{color}" stop-opacity="0.10"/>
      <stop offset="100%" stop-color="{color}" stop-opacity="0"/>
    </radialGradient>
  </defs>

  <rect width="1200" height="630" fill="url(#bg)"/>
  <rect width="1200" height="630" fill="url(#accent)"/>
  <rect width="1200" height="630" fill="url(#accent2)"/>

  <!-- Top accent bar -->
  <rect x="80" y="100" width="64" height="4" fill="{color}"/>

  <!-- Eyebrow row -->
  <text x="80" y="86" font-family="JetBrains Mono, ui-monospace, monospace"
        font-size="15" letter-spacing="3" fill="#78716c" font-weight="500">
    ML &#183; 8GWIFI.ORG
  </text>
  <text x="1120" y="86" font-family="JetBrains Mono, ui-monospace, monospace"
        font-size="15" letter-spacing="3" fill="{color}" font-weight="500" text-anchor="end">
    {section_upper}
  </text>

  <!-- Title -->
  <text x="80" y="318" font-family="Instrument Serif, Iowan Old Style, Georgia, serif"
        font-size="92" font-weight="400" fill="#1c1917" letter-spacing="-2.5">
    {title}
  </text>
  <text x="80" y="420" font-family="Instrument Serif, Iowan Old Style, Georgia, serif"
        font-size="92" font-style="italic" fill="{color}" letter-spacing="-2.5">
    {title_em}.
  </text>

  <!-- Subtitle (auto-wrapped) -->
  {subtitle_svg}

  <!-- Footer line + URL -->
  <line x1="80" y1="572" x2="200" y2="572" stroke="{color}" stroke-width="2"/>
  <text x="80" y="602" font-family="Inter, system-ui, sans-serif"
        font-size="16" fill="#78716c" font-weight="500">
    8gwifi.org/ml
  </text>

  <!-- Decorative side mark -->
  <g transform="translate(1040, 540)" opacity="0.7">
    <circle cx="0" cy="0" r="6" fill="{color}"/>
    <circle cx="20" cy="0" r="6" fill="{color}" fill-opacity="0.5"/>
    <circle cx="40" cy="0" r="6" fill="{color}" fill-opacity="0.25"/>
  </g>
</svg>
"""


def wrap_subtitle (text: str, max_chars: int = 62) -> list[str]:
    """Greedy line-wrap for the subtitle.  Two-line max."""
    words = text.split()
    lines: list[str] = []
    cur = ""
    for w in words:
        if len(cur) + len(w) + 1 <= max_chars:
            cur = (cur + " " + w).strip()
        else:
            lines.append(cur)
            cur = w
    if cur:
        lines.append(cur)
    return lines[:2]  # OG card has limited vertical real estate


def xml_escape (s: str) -> str:
    return (
        s.replace("&", "&amp;")
         .replace("<", "&lt;")
         .replace(">", "&gt;")
         .replace('"', "&quot;")
    )


def render_subtitle_svg (text: str, x: int = 80, y: int = 488) -> str:
    lines = wrap_subtitle(text)
    tspans = "\n".join(
        f'    <tspan x="{x}" dy="{0 if i == 0 else 32}">{xml_escape(line)}</tspan>'
        for i, line in enumerate(lines)
    )
    return (
        f'<text x="{x}" y="{y}" font-family="Inter, system-ui, sans-serif" '
        f'font-size="22" fill="#44403c" font-weight="500">\n{tspans}\n  </text>'
    )


def build_svg (spec: dict) -> str:
    return SVG_TEMPLATE.format(
        title=xml_escape(spec["title"]),
        title_em=xml_escape(spec["title_em"]),
        section_upper=xml_escape(spec["section"].upper()),
        color=spec["color"],
        subtitle_svg=render_subtitle_svg(spec["subtitle"]),
    )


def main () -> None:
    here = Path(__file__).resolve().parent
    out_dir = here.parent.parent.parent / "images" / "site"
    out_dir.mkdir(parents=True, exist_ok=True)

    for spec in PAGES:
        svg_path = out_dir / f"{spec['slug']}.svg"
        png_path = out_dir / f"{spec['slug']}.png"
        svg = build_svg(spec)
        svg_path.write_text(svg, encoding="utf-8")
        # Convert SVG → PNG via rsvg-convert (1200×630 native).
        try:
            subprocess.run(
                ["rsvg-convert", "-w", "1200", "-h", "630",
                 "-o", str(png_path), str(svg_path)],
                check=True, capture_output=True,
            )
            png_kb = png_path.stat().st_size / 1024
            print(f"  ✓ {spec['slug']:32s} {png_kb:5.1f} KB")
        except subprocess.CalledProcessError as e:
            print(f"  ✗ {spec['slug']}: rsvg-convert failed: {e.stderr.decode()}", file=sys.stderr)


if __name__ == "__main__":
    main()
