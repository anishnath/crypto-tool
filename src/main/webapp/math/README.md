# Math AI CAS Engine — Developer Guide

This guide explains how the unified **Math AI cores engine** works, how to change existing cores, and how to add new calculator / chat features without loading dozens of separate scripts on every page.

---

## Overview

Math tool pages and Math AI chat share the same symbolic-math engines (`IntegralCalculatorCore`, `ODECalculatorCore`, `StatisticsChatCore`, etc.). Those engines used to load as **25+ individual `<script>` tags**, which hurt LCP and page load time.

**Today:**

| Artifact | Role |
|----------|------|
| Individual `*-core.js` source files | **Source of truth** — edit these |
| `modern/js/math-ai-cores-engine.js` | **Generated bundle** — one HTTP request at runtime |
| `scripts/build-math-ai-cores-bundle.mjs` | Build script — run after source changes |
| `scripts/math-ai-cores.manifest.json` | Ordered list of files concatenated into the engine |

**Do not edit `math-ai-cores-engine.js` by hand.** Your changes will be overwritten on the next build.

---

## What gets loaded on a page

### Math AI only (statistics, bode, prime-number, etc.)

```jsp
<%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
```

Loads **one script**: `modern/js/math-ai-cores-engine.js`

### Full calculator page (integral, derivative, limit, ODE, algebra, trig, …)

```jsp
<%@ include file="/modern/components/math-tool-engine-boot.inc.jsp" %>
<jsp:include page="/math/partials/<tool>-calculator-scripts.jsp" />
<jsp:include page="/math/partials/math-input-setup.jsp" />
```

`math-tool-engine-boot.inc.jsp` loads:

1. `math-libs.jsp` (KaTeX, Plotly loader, tool-utils, …) **without duplicate nerdamer**
2. `math-ai-cores-engine.js` (nerdamer + all chat/CAS cores)

**Load order matters:** engine boot must come **before** any page script that uses `window.*CalculatorCore` globals.

Tool partials under `math/partials/` should only contain **page UI** (worksheet, graph, export, DOM controllers). Shared CAS cores live in the engine, not in the partial.

---

## Day-to-day workflow: fix or change an existing core

1. **Find the source file** — usually `modern/js/*-calculator-core.js`, `modern/js/*-chat-core.js`, or `js/*-solver-*.js`. See the manifest for the full list.

2. **Edit the source file** — implement your fix or behavior change there.

3. **Rebuild the engine** from the repo root:

   ```bash
   node scripts/build-math-ai-cores-bundle.mjs
   ```

4. **Verify** in the browser:
   - Calculator **Calculate** tab (page controller)
   - Math AI **chat** (Solve / Steps / Graph chips) if the tool has AI

5. **Commit both** the source file(s) and the regenerated `math-ai-cores-engine.js`.

---

## Adding a new module to the engine

Use this when a new `*-core.js` must be available on **all** Math AI pages (chat router, cross-topic chips, etc.).

### 1. Create or identify the source file

Place it under `src/main/webapp/modern/js/` or `src/main/webapp/js/` following existing naming:

- `something-calculator-core.js` — pure logic + `window.SomethingCalculatorCore`
- `something-chat-core.js` — Math AI chat block handler

Use an IIFE and attach APIs to `window`, same as existing cores.

### 2. Register it in the manifest

Edit `scripts/math-ai-cores.manifest.json` and add the path to the `files` array **in dependency order** (dependencies first).

Example — adding after stats modules:

```json
"js/stats-graph.js",
"modern/js/statistics-chat-core.js",
"modern/js/my-new-chat-core.js"
```

### 3. Rebuild

```bash
node scripts/build-math-ai-cores-bundle.mjs
```

### 4. Wire Math AI chat (if applicable)

If the feature appears in chat, also update:

| File | Purpose |
|------|---------|
| `modern/js/ai/math-action-extract.js` | Parse ```block``` types from AI responses |
| `modern/js/ai/math-chat-compute.js` | Run Solve / Steps / Graph actions |
| `modern/js/ai/adapters/math-profiles/generic-calculus.js` | Profile prompts, focus chips, context |

### 5. Wire the calculator JSP (if applicable)

- Page-specific DOM controller stays in `math/partials/<tool>-calculator-scripts.jsp` or `modern/js/<tool>.js`
- Do **not** add a second `<script>` for a core that is already in the engine
- Use `math-tool-engine-boot.inc.jsp` before the partial

---

## Adding a page-only script (not in the global engine)

Some files are **only** for one calculator’s UI and should **not** go in the engine, for example:

- `modern/js/integral-calculator.js` — DOM / button wiring
- `js/polynomial-calculator-graph.js` — Plotly UI for one page
- `js/variance-calculator-core.js` — statistics page orchestration

Load these in the tool JSP or `math/partials/<tool>-calculator-scripts.jsp` **after** engine boot. No rebuild required unless you also changed engine modules.

---

## Manifest contents (reference)

The engine concatenates, in order:

1. `modern/js/math-ai-cores-bootstrap.js` — context path, Plotly lazy loader, algebra bridge flags
2. Nerdamer vendor (`js/vendor/nerdamer/*.js`)
3. Calculus / algebra / signal cores (integral → z-transform)
4. Algebra page engines (quadratic, systems, polynomial render, inequality headless)
5. Vector, trig, statistics chat modules

Full list: `scripts/math-ai-cores.manifest.json`

---

## Build script details

```bash
# One-time: install minifier (terser) for the build script
cd scripts && npm install && cd ..

node scripts/build-math-ai-cores-bundle.mjs
```

**Output:** `src/main/webapp/modern/js/math-ai-cores-engine.js` (minified by default)

The build concatenates all manifest modules, then runs **terser** with compression enabled and **mangling disabled** so `window.*CalculatorCore` global names stay intact.

Typical size: ~1.8 MB concatenated → ~960 KB minified.

**Debug unminified output** (readable stack traces):

```bash
MATH_AI_CORES_SKIP_MINIFY=1 node scripts/build-math-ai-cores-bundle.mjs
```

**Also:**

- Copies nerdamer from `system-equations-test/node_modules/nerdamer` → `js/vendor/nerdamer/`
- Removes legacy `math-ai-cores.bundle.js` if present

**Prerequisite** — if build fails with missing nerdamer:

```bash
cd system-equations-test && npm install && cd ..
node scripts/build-math-ai-cores-bundle.mjs
```

---

## JSP includes cheat sheet

| Include | When to use |
|---------|-------------|
| `modern/components/math-calculus-cores.inc.jsp` | Math AI chat only; stats/signal pages with `math-ai-boot.inc.jsp` |
| `modern/components/math-tool-engine-boot.inc.jsp` | Calculator pages that need math-libs + engine (most math studio tools) |
| `math/partials/math-libs.jsp` alone | Pages that need KaTeX/nerdamer but **not** the full engine (exams, some legacy pages) |

---

## Checklist: new Math Studio + AI feature

- [ ] Source core(s) created or updated
- [ ] Entry added to `scripts/math-ai-cores.manifest.json` (if globally shared)
- [ ] `node scripts/build-math-ai-cores-bundle.mjs` run
- [ ] JSP uses `math-tool-engine-boot.inc.jsp` (calculator) or `math-calculus-cores.inc.jsp` (AI-only)
- [ ] Tool partial does **not** duplicate core `<script>` tags
- [ ] Chat wired in `math-action-extract.js`, `math-chat-compute.js`, `generic-calculus.js` (if chat blocks needed)
- [ ] `math-ai-boot.inc.jsp` + profile on the JSP
- [ ] Manual test: Calculate tab + AI chat Solve/Steps/Graph

---

## Troubleshooting

### `*CalculatorCore is not defined` in the browser

- Engine boot is included **after** the page script that needs it → move `math-tool-engine-boot.inc.jsp` above the tool partial.

### Changes to a core file don’t appear

- You edited source but forgot to run `node scripts/build-math-ai-cores-bundle.mjs`
- Or the browser cached the old engine — hard refresh; JSP adds `?v=timestamp` cache bust on deploy

### Nerdamer errors / `nerdamer is not defined`

- Page uses `math-libs.jsp` without engine boot and nerdamer was skipped — use engine boot or ensure `mathLibsSkipNerdamer` is not set incorrectly.

### Build fails: missing source file

- Path in `math-ai-cores.manifest.json` is wrong, or file was renamed — fix manifest or restore the file.

---

## Related paths (repo root)

```
scripts/
  build-math-ai-cores-bundle.mjs   ← run this to rebuild
  math-ai-cores.manifest.json      ← module order / membership

src/main/webapp/
  modern/js/math-ai-cores-engine.js          ← generated (commit after build)
  modern/js/math-ai-cores-bootstrap.js       ← bootstrap snippet (in manifest)
  modern/js/*-calculator-core.js             ← typical CAS sources
  modern/components/math-calculus-cores.inc.jsp
  modern/components/math-tool-engine-boot.inc.jsp
  math/partials/*-calculator-scripts.jsp     ← page UI only, not shared cores
```

---

## Summary

| Task | What to do |
|------|------------|
| Fix a bug in an existing core | Edit source `*-core.js` → rebuild → commit source + engine |
| Add shared chat/CAS capability | New core file → add to manifest → rebuild → wire AI router |
| Add page-only UI | Edit JSP / partial / `*-calculator.js` — no manifest change |
| New calculator page with AI | `math-tool-engine-boot.inc.jsp` + partial + `math-ai-boot.inc.jsp` |

**Rebuild command (always after engine source changes):**

```bash
node scripts/build-math-ai-cores-bundle.mjs
```
