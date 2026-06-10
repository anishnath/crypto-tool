# Math Tool Page — Migration Template

> **Purpose**: rewrite the ~48 math calculator pages onto a single three-column
> layout with a shared sidebar, shared CSS tokens, shared script partials, and
> a decorative physics backdrop. This document is the single source of truth —
> if you close the session, hand this file to the next assistant and the work
> resumes.

**Status** (2026-04-24): reference pair built and validated —
- `/math/index2.jsp` → landing page reference
- `/integral-calculator2.jsp` → tool page reference

Existing `math/index.jsp` and `integral-calculator.jsp` are untouched; migrate
by copying the reference pattern, verifying, then `git mv` over the originals.

---

## 1. The shape we're building

```
╔══════════ body.ms-body ═══════════════════════════════════════════╗
║  <modern-nav> (fixed 72px)                                         ║
║  ┌─ Matter.js backdrop ─ absolute, fades bottom ─────────────┐    ║
║  │                                                            │    ║
║  └────────────────────────────────────────────────────────────┘    ║
║  <div.ms-hero>  ← full-width banner ad                             ║
║  ┌─────── main.ms-main ─── max-w 1440 ──────────────────────┐      ║
║  │ ┌ sidebar ─┐ ┌ workspace ──────────────┐ ┌ rail ─┐       │      ║
║  │ │ tree     │ │  .ms-title (crumbs+H1)  │ │ ads   │       │      ║
║  │ │ 272px    │ │  .ic-hero  (input)      │ │ 300px │       │      ║
║  │ │          │ │  .ic-result-card        │ │       │       │      ║
║  │ │          │ │  .ic-learn (ref band)   │ │       │       │      ║
║  │ └──────────┘ └─────────────────────────┘ └───────┘       │      ║
║  └──────────────────────────────────────────────────────────┘      ║
║  <ad-sticky-footer>                                                 ║
╚═════════════════════════════════════════════════════════════════════╝
```

**Column widths** (CSS variables in `math-studio.css`):
- Sidebar: `--ms-sidebar-w: 272px`
- Right rail: `--ms-rail-w: 300px` (only shown ≥1280px)
- Gap: `--ms-gap: 1.5rem`

Below 1024 px the sidebar becomes an off-canvas drawer toggled by a
hamburger button. Below 1280 px the right rail hides and an in-content
ad takes its place (`.ms-inline-ad`).

---

## 2. File inventory

### Files created (shared infrastructure — do not duplicate)

| File | Role |
|------|------|
| `math/css/math-studio.css` | All shell styles — layout, sidebar, workspace, button hierarchy, `.ic-stack` / `.ic-hero` / `.ic-result-card` / `.ic-learn`, matter backdrop positioning, print styles |
| `math/partials/sidebar.jsp` | Shared sidebar tree — 48 tools in 8 collapsible categories with search + active highlight + localStorage persistence. Accepts `activeService` request attribute |
| `math/partials/matter-bg.jsp` | One-line include: host div + Matter.js CDN + physics script |
| `math/partials/integral-calculator-scripts.jsp` | Extracted script block for integral tool (KaTeX, MathLive ES module, nerdamer CAS, 785-line inline IIFEs for mode toggle / image-to-math / result rendering). Canonical example for future tools |
| `math/js/math-matter-bg.js` | Decorative physics scene — math-themed shapes in accent palette, reduced-motion aware, tab-pause, theme-aware recolor |

### Reference pages (the two templates)

| File | Mirrors which original | When to use as template |
|------|------------------------|--------------------------|
| `math/index2.jsp` | `math/index.jsp` | Landing / category pages |
| `integral-calculator2.jsp` | `integral-calculator.jsp` | Any calculator tool page |

### Files that MUST remain untouched (shared across wider site)

| File | Why |
|------|-----|
| `modern/css/navigation.css` | Fixed-nav, shared |
| `modern/css/dark-mode.css` | Theme toggle, shared |
| `modern/css/ai-vision-modal.css`, `ai-progress-bar.css`, `ai-chat-modal.css` | Only relevant to circuit AI flow — do NOT link from math pages |
| `modern/css/integral-calculator.css` | Still used, we override specific classes. Don't edit; add overrides in `math-studio.css` scoped under `.ic-result-card` |
| `modern/js/integral-calculator*.js`, `image-to-math.js`, `tool-utils.js`, `worksheet-engine.js` | Tool behavior — the shared-scripts partial includes them |

---

## 3. Migration recipe — any math tool page

### Step 1: Gather the originals

For `<tool>-calculator.jsp`:
- `webapp/<tool>-calculator.jsp` (the page)
- `modern/css/<tool>-calculator.css` (if present)
- `modern/js/<tool>-calculator.js` + related scripts

**Also record what SEO signals the original has** (you will need to
port ALL of them — see §6.5):
- The full `<jsp:include page="seo-tool-page.jsp">` param block
- Any inline `<script type="application/ld+json">` blocks (CollectionPage,
  ItemList, FAQPage, HowTo, LearningResource — copy each verbatim)
- The visible `tool-expertise-section` word count (so you know what
  content you owe back, either as expertise cards or expanded FAQ)

### Step 2: Extract its scripts into a partial

Mirror `math/partials/integral-calculator-scripts.jsp`. Copy the entire
**scripts block** (from the first `<script>` after `<body>` down to the last
`</script>` before `</body>`) verbatim. This becomes the single source of
truth both the old page AND the new one use.

Watch for **three sections** in the original that tend to sit outside the
main script block:
1. An ES-module `<script type="module">` that imports MathLive from
   `https://cdn.jsdelivr.net/npm/mathlive/+esm` — **must** be included
2. An inline `<script>` IIFE binding the mode toggles / input sync
3. An image-to-math `<script>` init block (if the tool has a 📷 scan feature)

Missing any one of these breaks the tool silently — QuickExamples stop working,
or both inputs render simultaneously, or Scan does nothing. **The partial is
the single source of truth — do NOT also keep the inline blocks in the parent
page.**

### Step 3: Build `<tool>-calculator2.jsp`

Structure (copy from `integral-calculator2.jsp`):

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="..." />
        <jsp:param name="toolCategory" value="Math" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        ...
    </jsp:include>

    <!-- Fonts (Inter + JetBrains Mono + Instrument Serif for display) -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">

    <!-- Shared site CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">

    <!-- Math shell (ALWAYS loads after the tool CSS) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <!-- Tool-specific CSS (loads before math-studio? No — load BEFORE so
         math-studio overrides still win.  Check load order!) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/<tool>-calculator.css?v=<%=v%>">

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">
    <%@ include file="modern/components/nav-header.jsp" %>

    <jsp:include page="/math/partials/matter-bg.jsp" />

    <div class="ms-hero">
        <%@ include file="modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="ms-main">
        <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
            &#9776; Math tools
        </button>

        <% request.setAttribute("activeService", "<TOOL-KEY>"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">
            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Tool Name</span>
                </nav>
                <h1>Tool Name</h1>
            </header>

            <div class="ic-stack">
                <div class="ic-hero" id="ic-hero" data-input-mode="visual">
                    <!-- top row: mode toggles + scan -->
                    <!-- function input -->
                    <!-- params -->
                    <!-- CTA button (.ic-hero-cta) -->
                    <!-- collapsed examples (<details class="ic-hero-methods">) -->
                    <!-- collapsed syntax help (.ic-hero-syntax) -->
                </div>

                <div class="ic-result-card">
                    <div class="ic-output-tabs" role="tablist">...</div>
                    <div class="ic-panel active" id="ic-panel-result">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="ic-result-content">
                                <div class="tool-empty-state ic-empty-state">
                                    <div class="ic-empty-illustration">&#8747;</div>
                                    <h3>Ready when you are</h3>
                                    <p>Type above and hit <strong>Compute</strong>.</p>
                                </div>
                            </div>
                            <div class="tool-result-actions">
                                <button class="tool-action-btn">Copy LaTeX</button>
                                ...
                            </div>
                            <div class="ic-worksheet-cta">
                                <button class="tool-action-btn">Practice Worksheet</button>
                            </div>
                        </div>
                    </div>
                    <!-- Graph + Python panels... -->
                </div>
            </div>

            <!-- Methods reference strip -->
            <section class="ic-learn">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Method 1</span>
                    <code class="ic-learn-formula">f(x) = …</code>
                </article>
                ...
            </section>

            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>
        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Shared tool scripts partial (single source of truth) -->
    <jsp:include page="/math/partials/<tool>-calculator-scripts.jsp" />

    <!-- UX scripts: prevent double-submit, scroll to result -->
    <script>
    (function () {
        var btn = document.getElementById('ic-integrate-btn');
        var target = document.getElementById('ic-panel-result');
        var resultContent = document.getElementById('ic-result-content');
        if (!btn || !target || !resultContent) return;
        /* … see integral-calculator2.jsp for the full 30-line block … */
    })();
    </script>
</body>
</html>
```

### Step 4: Sidebar `activeService` key

In `math/partials/sidebar.jsp` each item has a key (see file for the list):

| Tool | activeService key |
|------|------------------|
| Home | `home` |
| Math Editor | `editor` |
| Percentage | `percentage` |
| Exponent | `exponent` |
| Logarithm | `logarithm` |
| Quadratic | `quadratic` |
| Derivative | `derivative` |
| Integral | `integral-calculator` |
| Limit | `limit` |
| Matrix Determinant | `matrix-det` |
| … (30+ more in the partial) | |

If migrating a tool not yet in the sidebar, **add its entry first** to
`math/partials/sidebar.jsp` under the right `<div class="ms-group">`
category. Icon: use a Unicode glyph that hints at the concept (`∫`, `Σ`,
`x²`, `|A|`, `λ`). Label: short (≤ 20 chars).

### Step 5: Verify in a browser

Checklist below (section 6). When everything passes:

```bash
git mv <tool>-calculator.jsp <tool>-calculator.legacy.jsp
git mv <tool>-calculator2.jsp <tool>-calculator.jsp
```

Keep the `.legacy.jsp` around for a week until we're confident nothing
downstream is broken (search traffic, internal links, bookmarks).

---

## 4. Design tokens — reference

All tokens live in `math/css/math-studio.css` under `:root`. **Never
hard-code colors or radii in individual pages — use the tokens.**

### Palette

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `--ms-page-bg` | `#f7f6f3` | `#0c0a09` | Full page bg (warm zinc/stone) |
| `--ms-panel-bg` | `#fefdfb` | `#1c1917` | Cards, hero, result, sidebar |
| `--ms-panel-bg-soft` | `#faf8f4` | `#292524` | Input fields, chip tray, subtle tint |
| `--ms-ink` | `#1c1917` | `#f5f5f4` | Primary text |
| `--ms-ink-soft` | `#44403c` | `#d6d3d1` | Secondary text |
| `--ms-muted` | `#78716c` | `#a8a29e` | Kickers, labels, muted UI |
| `--ms-line` | `rgba(28,25,23,0.08)` | `rgba(245,245,244,0.08)` | Hairline borders |
| `--ms-line-strong` | `rgba(28,25,23,0.14)` | `rgba(245,245,244,0.14)` | Input borders |
| `--ms-accent` | `#15803d` | `#4ade80` | Primary accent (forest/sage) |
| `--ms-accent-hover` | `#166534` | `#86efac` | Accent hover state |
| `--ms-accent-soft` | `rgba(21,128,61,0.08)` | `rgba(74,222,128,0.1)` | Accent-tinted backgrounds |
| `--ms-accent-ring` | `rgba(21,128,61,0.22)` | `rgba(74,222,128,0.28)` | Focus rings, borders on active pills |
| `--ms-cta-start` / `--ms-cta-end` | Green gradient endpoints | Auto-adjusted | Primary CTA (unused currently; kept for future) |

### Radii

| Token | Value | Usage |
|-------|-------|-------|
| `--ms-radius-sm` | 8px | Small elements, code blocks, search field |
| `--ms-radius` | 14px | Standard cards, buttons in form-like contexts |
| `--ms-radius-lg` | 20px | Hero, result card |
| `--ms-radius-pill` | 999px | All buttons, toggles, chips, badges |

### Shadows

| Token | Purpose |
|-------|---------|
| `--ms-shadow-sm` | Default card depth (2 layers, tight) |
| `--ms-shadow` | Hover / active cards |
| `--ms-shadow-lg` | Floating (modals, drawer) |
| `--ms-ring` | Focus rings — `0 0 0 3px var(--ms-accent-ring)` |

### Transitions

```css
--ms-ease: cubic-bezier(0.2, 0.8, 0.2, 1);   /* spring-ish */
--ms-transition: 200ms var(--ms-ease);       /* the standard */
```

### Typography

| Token | Stack | Usage |
|-------|-------|-------|
| `--ms-font-sans` | Inter | All UI body + buttons |
| `--ms-font-serif` | Instrument Serif | Display (H1, hero titles, card titles, empty state heading) |
| `--ms-font-mono` | JetBrains Mono | Input fields, formulas, code, chip labels |

---

## 5. Button hierarchy — one family

**Same geometry, same motion — hierarchy is signaled by fill, not size.**

| Tier | Used by | Visual |
|------|---------|--------|
| **1 · Primary** | Main action (Integrate, Practice Worksheet) | `.ic-hero-cta` or scoped override: solid `--ms-accent` fill, white text, pill radius, `padding 0.5rem 1rem`, `font 500 0.82rem Inter` |
| **2 · Secondary** | Copy LaTeX, Copy Text, Share, Download PDF, Show Steps | `.tool-action-btn` inside `.ic-result-card .tool-result-actions`: transparent bg, `--ms-line-strong` border, `--ms-ink-soft` text → accent on hover, same size as Tier 1 |
| **3 · Toggle / Segment** | Indef/Def, Visual/Text, Result/Graph/Python tabs | `.ic-mode-toggle` or `.ic-stack .ic-output-tabs`: pill group inside a rounded container; active tab becomes a white card with accent text |
| **4 · Disclosure** | "Syntax help", "Examples by method" | `.ic-syntax-toggle` / `<summary>`: text-only, chevron icon, rotates on open |

**Never introduce a 5th tier**. If a new button doesn't fit, re-check
whether it's really a new tier or can be one of the above.

**Critical `!important` overrides** (documented, not arbitrary):
- `.tool-action-btn` is defined in both `three-column-tool.css` AND
  `integral-calculator.css` with `width: 100%; background: gradient;
  margin-top: 1rem`. Since both files load AFTER `math-studio.css`, the
  `.ic-result-card .tool-result-actions .tool-action-btn` rules need
  `!important` on `width`, `background`, `color`, `margin-top`, `opacity`.
  Same for `.ic-worksheet-cta .tool-action-btn`.

---

## 6. Testing checklist — every migrated page

### Visual
- [ ] Top ~72px clear of nav (body padding) — page content visible below fixed nav
- [ ] Sidebar sticky at `top: header+12px`, scrolls internally when tall
- [ ] Current tool highlighted in sidebar (active-state background + icon recolor)
- [ ] Category containing current tool is auto-expanded; others respect `localStorage`
- [ ] Search in sidebar filters items live; matching groups auto-expand
- [ ] Matter.js backdrop visible behind title + hero, fades by 700px
- [ ] `.ms-hero` banner ad renders above the grid
- [ ] Right ad rail visible at ≥1280px; `.ms-inline-ad` visible below that
- [ ] Page typography: serif H1, Inter body, JetBrains Mono for formulas/inputs

### Functionality — input hero
- [ ] Indef/Def toggle switches mode; bounds row appears only in Definite
- [ ] Visual/Text toggle swaps input modes (ONLY ONE visible at a time)
- [ ] In Visual mode: math-field renders; plain text input hidden; live preview hidden
- [ ] In Text mode: plain text input visible; math-field hidden; live preview renders KaTeX of parsed expression
- [ ] 📷 Scan button opens image-to-math modal (if supported by tool)
- [ ] "Examples by method" collapsed by default; opens on click with chevron rotation
- [ ] "Syntax help" collapsed by default; opens on click
- [ ] Clicking an example chip populates the input

### Functionality — primary action
- [ ] Primary button is solid accent pill (not gradient, not full-width)
- [ ] Click: button immediately shows `.is-busy` class (spinner + dim)
- [ ] Second click during compute: ignored (preventDefault + stopImmediatePropagation)
- [ ] Result content appears in `#ic-result-content` → MutationObserver unlocks button
- [ ] Safety timer unlocks button after 30s (smoke test: disable network mid-compute)
- [ ] Page smooth-scrolls to `#ic-panel-result` 140ms after click

### Functionality — result rendering
- [ ] Result area: labels in muted uppercase kicker, main formula in serif, method in accent pill
- [ ] "Show Steps" button is Tier-2 ghost pill; hover fills with accent
- [ ] Steps panel: accent-tinted header strip, step numbers as solid-accent circles with white digits
- [ ] Copy LaTeX / Copy Text / Share / Download PDF buttons are uniform pills (same size, same hover)
- [ ] Practice Worksheet is a Tier-1 solid pill — same size as Integrate, NOT full-width
- [ ] Graph tab: plotly renders; panel reveals without layout jank
- [ ] Python tab: iframe loads lazily; select dropdown aligned to the right

### Functionality — tabs
- [ ] Tab bar is a pill segment control aligned to the top-left of the result card
- [ ] Clicking a tab swaps `.active` class; correct panel shown
- [ ] Only the currently-active panel has `display: flex`; others `display: none`

### Motion / a11y
- [ ] `prefers-reduced-motion`: matter.js canvas hidden; all transitions shortened
- [ ] Tab hidden: matter runner stopped (check DevTools → Performance → no work in hidden tab)
- [ ] Theme toggle: matter bodies recolor within one tick; card borders / backgrounds all flip
- [ ] Focus ring on inputs: visible accent ring with `--ms-ring`
- [ ] Keyboard: Tab cycles through mode toggles → input → params → CTA → examples → syntax → tabs → action buttons

### Print
- [ ] Print preview (Cmd-P): sidebar gone, rail gone, ads gone, tabs gone, hero actions gone
- [ ] Only `.ms-title` + `.ic-hero` (input state) + `.ic-result-card` (active panel) visible
- [ ] Panels render with 1px solid black border, no shadows
- [ ] Typography: Georgia fallback for serif (KaTeX still renders fine)

### SEO parity (MUST-PASS — see §6.5)
- [ ] Every `jsp:param` from the original is present in the new file with
      same-or-better value (run the `git diff … | grep jsp:param` sanity)
- [ ] `toolDescription` length ≥ original (no truncation)
- [ ] All `faqNq` / `faqNa` pairs ported (no FAQs dropped)
- [ ] `educationalLevel` + `teaches` + `howToSteps` + `hasSteps` all present if original had them
- [ ] Long-tail keyword list matches original (±5 phrases OK, not −20)
- [ ] `CollectionPage + ItemList` JSON-LD block ported for landing pages
- [ ] **Visible FAQ accordion** renders all the FAQ Q&A the schema claims
      (DOM cross-validation)
- [ ] `#faqs` anchor still works for inbound links
- [ ] Google Rich Results test passes for the new URL
      (https://search.google.com/test/rich-results)
- [ ] Word count on page ≥ ~1,200 words; if below, expand FAQ or add a
      listing section

---

## 6.5. SEO parity — the #1 regression risk

> Every migration must preserve **100%** of the original page's SEO signals.
> Thin content = Google re-indexes as a weaker page, ranking drops, traffic
> regresses for weeks. This is more important than visual polish.

### 6.5.1 Always port verbatim

| Signal | Where it lives | Port with |
|--------|----------------|-----------|
| `toolName`, `toolDescription`, `toolKeywords` | `jsp:include page="seo-tool-page.jsp"` params | Exact string copy from original |
| `educationalLevel` param (LearningResource schema) | Same | Same |
| `teaches` param (Course schema — academic tools only) | Same | Same |
| `howToSteps` param (HowTo schema) | Same | Same |
| `hasSteps` flag | Same | Same |
| `toolFeatures` list | Same | Same |
| **Every `faqNq` / `faqNa` pair (FAQPage schema)** | Same | Same — never trim these, they power rich snippets |
| **CollectionPage + ItemList** `<script type="application/ld+json">` | Inline in the original `<head>` | Copy the whole `<script>` block verbatim |
| `currentToolUrl` for related-tools | Inside `related-tools.jsp` include | Drop only if you're replacing related-tools with something else |

### 6.5.2 Render FAQ visibly AND in schema

Having FAQ content only in `jsp:param` populates the FAQPage schema but the
**rendered HTML is empty** — Google cross-validates schema against DOM and
penalises schema-only FAQ. Every migrated page needs:

1. `jsp:param faq1q`..`faqNq` / `faq1a`..`faqNa` in `<head>` (schema)
2. **Matching `<section class="ms-faq-wrap">` with `.ms-faq-item` entries
   in the DOM** (visible content)

Keep them in sync — if you change one, change the other. Both reference pages
(`integral-calculator2.jsp`, `math/index2.jsp`) show the pattern.

### 6.5.3 Internal-link equity

The legacy `math/index.jsp` rendered 48 tool cards in the body. The new shell
moves those links to the sidebar, which is still crawlable but less weighted.
**Compensate by:**

1. Keeping the `CollectionPage + ItemList` JSON-LD listing all 48 tools —
   explicit Google-parseable signal that this page is a collection
2. Keeping the sidebar visible on every page (not a hidden drawer by default
   on desktop — only collapse at `<1024px`)
3. If word-count drops below ~1,200 on a landing page, add a visible list
   section or beefed-up FAQ to compensate

### 6.5.4 Per-page SEO audit checklist (run before `git mv`)

```
git diff <original>.jsp <new>.jsp | grep -E 'jsp:param|ld\+json|faq|keywords'
```

Eyeball that every `jsp:param` key in the original appears in the new file
with the same (or deliberately improved) value. Any missing = regression.

### 6.5.5 Common SEO mistakes we made on first pass

1. **Shortened toolDescription** from 420 chars to 150 — cut weight on
   descriptive keywords. *Fix:* keep the full original description.
2. **Dropped 8 FAQ pairs** from the head (shortened to 3) — lost 5 rich-snippet
   opportunities. *Fix:* port every faqN/faqNa verbatim.
3. **Missing `CollectionPage + ItemList` JSON-LD** on the landing page —
   lost the "48 items" structured listing signal. *Fix:* copy the whole
   `<script type="application/ld+json">` block.
4. **Removed `tool-expertise-section`** with 6 H2 blocks worth ~1,500 words —
   dropped content density. *Fix (optional):* restore later; meanwhile
   compensate with expanded FAQ. NOTE: explicitly out-of-scope for
   integral-calculator2 per owner decision.
5. **Duplicated position numbers** in ItemList (original had two ListItems
   at position 8). *Fix:* renumber sequentially on port and verify
   `numberOfItems` matches.

---

## 7. Pitfalls we hit — don't repeat

1. **`!important` on `.ic-mathfield { display: block }`** broke the mode-toggle
   hide logic from `integral-calculator.css` — both inputs rendered at once.
   **Fix:** never override `display` on `.ic-mathfield` or `#ic-expr`. Let
   `integral-calculator.css` own those.

2. **Sticky `.ic-hero` pushed the result below the fold on desktop.** Clicking
   Integrate appeared to do nothing because the newly-rendered result was
   off-screen.
   **Fix:** `.ic-hero` is NOT sticky. The auto-scroll inline script handles
   the "bring result into view" concern instead.

3. **Missing MathLive ES module in the scripts partial** → `<math-field>`
   never registered → IIFE blew up on first line → Quick Example click
   handlers never bound.
   **Fix:** the shared scripts partial MUST include the `<script type="module">`
   block with `import '.../mathlive/+esm'`. Not the UMD bundle — it interferes.

4. **Live preview redundant in Visual mode.** The `<math-field>` IS the
   preview. Showing a second KaTeX preview below duplicated what the user
   just typed.
   **Fix:** `.ic-hero[data-input-mode="visual"] .ic-preview-strip { display: none }`.
   The script sets `data-input-mode` on the hero via `wrap.closest('.tool-card-body')
   || wrap.parentNode` fallback — so the hero IS the effective cardBody.

5. **Result content was styled with legacy indigo.** Script injects classes
   like `.ic-method-badge`, `.ic-steps-btn`, `.ic-step-num` — all defined in
   `integral-calculator.css` with `var(--tool-primary)` (indigo). Result
   appeared in a completely different palette.
   **Fix:** override every class under `.ic-result-card` scope in
   `math-studio.css` with `!important` (load order makes this necessary).
   Search for `Result content — injected by integral-calculator.js` in
   `math-studio.css` for the full block.

6. **Tool header was a heavy card competing with the hero.** User felt middle
   column was cluttered.
   **Fix:** `.ms-title` is plain type (no card) — serif H1 + crumbs only.
   Badges and description paragraph: removed. Empty state + hero carry the
   context.

7. **Emoji icons on action buttons made four buttons look like four
   different buttons.** 📋 📄 🔗 📄 — two 📄 glyphs, inconsistent widths.
   **Fix:** no emoji. Plain text labels. Uniform pills.

8. **Primary CTA + gradient + full-width + big shadow** looked like a
   billboard next to the subtle secondary pills.
   **Fix:** same size as secondary pills, solid accent fill, no gradient,
   no heavy shadow.

9. **Double-click during compute** fired the CAS twice.
   **Fix:** `.is-busy` class + capture-phase click handler with
   `preventDefault` + `stopImmediatePropagation`. MutationObserver on the
   result container re-enables when content lands.

10. **Sidebar search not expanding collapsed groups** hid matches.
    **Fix:** on every keystroke in search, remove `.collapsed` from all
    groups if the query is non-empty.

---

## 8. Decorative backdrop — when to use

`math/partials/matter-bg.jsp` is enabled on both reference pages. Include it
in every migrated page unless:
- The page is an ad-heavy / conversion-critical surface where reading
  performance matters more than ambient decoration
- The page is expected to be embedded in an iframe
- The page is print-only

The backdrop automatically:
- Hides on `prefers-reduced-motion: reduce`
- Pauses when the tab is hidden
- Caps at 22 bodies, culls fallen ones — constant memory

Palette uses the same `--ms-accent` family so it feels like part of the
page, not a screensaver. If you ever want to tune density or fade depth,
edit `math/js/math-matter-bg.js` (`MAX_BODIES`, spawn interval) and the
`.ms-matter-host` rules in `math-studio.css` (`height`, mask gradient).

---

## 9. Sidebar maintenance

When adding a new tool:

1. Open `math/partials/sidebar.jsp`
2. Pick the right `<div class="ms-group" data-group="...">` category
3. Add a line:
   ```jsp
   <a href="<%= ctx %>/your-tool.jsp" class="ms-item <%= "your-key".equals(activeService) ? "active" : "" %>">
       <span class="ms-item-icon">&#xXXXX;</span> <span class="ms-item-label">Your Tool</span>
   </a>
   ```
4. Pick an icon: browse https://unicode.org/charts/ or use a common math
   glyph (∫ ∑ ∏ ∆ ∇ ∞ ≈ π ≤ ≥ · → ⊂ ∩)
5. In the target page, set `request.setAttribute("activeService", "your-key")`

Categories currently available:
- `home` (Home + Math Editor)
- `everyday` (Percentage, Sig Figs, Exponents, Logarithm, 24 Game)
- `algebra` (Quadratic, Linear Eq, System, Inequality, Polynomial)
- `calculus` (Derivative, Integral, Limit, Series, Vector Calc)
- `linear-algebra` (9 matrix tools + Vector)
- `trig` (Trig Function, Trig Identity, Trig Equation)
- `statistics` (21 tools)
- `graphing` (Graphing Calculator)

---

## 10. Rollout plan for all ~48 tools

### Phase 1 (done)
- ✅ Build reference pair: `math/index2.jsp` + `integral-calculator2.jsp`
- ✅ Build shared CSS, sidebar, matter backdrop
- ✅ Document migration recipe (this file)

### Phase 2 (next)
Migrate **one tool per PR** following section 3. Start with the
highest-traffic tools:
1. `derivative-calculator` (same script family as integral — easiest)
2. `limit-calculator`
3. `series-calculator`
4. `quadratic-solver`
5. `matrix-determinant-calculator`

For each: create `<tool>-calculator2.jsp`, verify via checklist (section 6),
`git mv` to replace the original, observe for a week, then delete the
`.legacy.jsp` backup.

### Phase 3 (cleanup)
- Drop `modern/css/three-column-tool.css` once no page references it
- Drop `modern/css/<tool>-calculator.css` when its rules are all absorbed
  into `math-studio.css` (for tools that followed the exact same script
  contract)
- Rename `math/index2.jsp` → `math/index.jsp`
- Rename `integral-calculator2.jsp` → `integral-calculator.jsp`

---

## 11. What's outside this scope

- **AI features** (ChatGPT-style assistants for math problems) — the circuit
  simulator has a chat modal at `/modern/js/ai-chat-modal.js` that could be
  reused, but integration into math tools is a future initiative
- **Offline / PWA** — the shell + fonts + scripts all load over CDN today; a
  service worker could cache for offline use but that's a separate project
- **Dashboard / editor** pages (`math/dashboard.jsp`, `math/editor.jsp`) —
  likely keep their own layout; they're not calculators

---

## 12. Session restart — if you're a fresh assistant

Read this file top to bottom. The reference pages are:
- `/Users/anish/git/crypto-tool/src/main/webapp/math/index2.jsp`
- `/Users/anish/git/crypto-tool/src/main/webapp/integral-calculator2.jsp`

The shell CSS is `/Users/anish/git/crypto-tool/src/main/webapp/math/css/math-studio.css`.

If the user asks to "migrate X tool", follow section 3. If they ask about
a specific design decision, check sections 4–7 first. If something looks
broken, check section 7.

**The reference pair is canonical. Anything that differs from it without a
strong reason is a bug.**
