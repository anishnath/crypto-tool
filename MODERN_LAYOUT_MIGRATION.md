# Modern Layout Migration Guide

Reference document for migrating old Bootstrap calculator/solver pages to the modern three-column layout with modular JS.

---

## Architecture Pattern

Each migrated tool consists of:

| File | Purpose |
|------|---------|
| `css/<tool>.css` | Tool-specific CSS with unique prefix (e.g., `sc-`, `ec-`, `qs-`) |
| `js/<tool>-render.js` | KaTeX rendering, step-by-step DOM building |
| `js/<tool>-graph.js` | Plotly graph (lazy-loaded). Skip if tool has no graph |
| `js/<tool>-export.js` | LaTeX copy, share URLs, Python compiler templates |
| `js/<tool>-core.js` | IIFE orchestration: state, events, init. Loads last |
| `<tool>.jsp` | Three-column layout JSP with seo-tool-page.jsp include |

### JS Module Pattern
```javascript
(function() {
'use strict';
// ... all code ...
window.ToolNameRender = { method1: method1, method2: method2 };
})();
```
- ES5 compatible (`var`, not `let`/`const`)
- IIFE with namespace on `window`
- Core.js references other modules: `var R = window.ToolNameRender;`

### JSP Layout Structure
```
<head>
  seo-tool-page.jsp (SEO params, JSON-LD, meta tags)
  CSS: design-system, navigation, three-column-tool, tool-page, ads, dark-mode, footer, search
  css/<tool>.css
  KaTeX CSS
  Inline <style> for gradient overrides (.tool-action-btn, .tool-badge)
</head>
<body>
  nav-header.jsp
  Header: H1, breadcrumbs, badges
  Description section with --tool-light background

  <main class="tool-page-container">
    INPUT COLUMN (tool-input-column) - sticky left sidebar
    OUTPUT COLUMN (tool-output-column) - center with tabs
    ADS COLUMN (tool-ads-column) - right sidebar
  </main>

  Mobile ad, related-tools.jsp
  Educational content (scroll-animated with IntersectionObserver)
  FAQ accordion
  Explore More Math Tools links
  support-section.jsp, footer
  Scripts: KaTeX, [math.js if needed], tool-utils.js, render.js, [graph.js], export.js, core.js
  analytics.jsp
</body>
```

### SEO Title Rules (seo-tool-page.jsp logic)
- **< 50 chars** → appends `| 8gwifi.org` (avoid this — wastes chars on brand)
- **50-60 chars** → renders as-is (SWEET SPOT)
- **> 60 chars** → truncated at 43 + `... | 8gwifi.org` (avoid — keywords get cut)

### Color Theme Convention
Each tool gets a unique color to avoid visual monotony:
- Linear solver: Indigo `#4f46e5`
- Quadratic solver: Purple `#7c3aed`
- Series calculator: Blue `#2563eb`
- Exponent calculator: Amber `#d97706`
- Logarithm calculator: Teal `#0d9488`

---

## Completed Migrations (Fully Modular)

### 1. Linear Equations Solver
- **Files:** `css/linear-solver.css`, `js/linear-solver-{render,graph,matrix,export,core}.js`, `linear-equations-solver.jsp`
- **Prefix:** `ls-`
- **Color:** Indigo `#4f46e5`
- **Features:** Up to 6x6 systems, Gaussian elimination steps, Plotly graph, 5 Python templates
- **SEO:** Done

### 2. Quadratic Solver
- **Files:** `css/quadratic-solver.css`, `js/quadratic-solver-{render,graph,export,core}.js`, `quadratic-solver.jsp`
- **Prefix:** `qs-`
- **Color:** Purple `#7c3aed`
- **Features:** 4 forms (Standard/Vertex/Factored/Inequality), 3 solving methods, Plotly parabola, discriminant analysis
- **SEO:** Done

### 3. Series Calculator (Taylor/Maclaurin)
- **Files:** `css/series-calculator.css`, `js/series-calculator-{render,graph,export,core}.js`, `series-calculator.jsp`
- **Prefix:** `sc-`
- **Color:** Blue `#2563eb`
- **Features:** Taylor/Maclaurin expansion, math.js symbolic differentiation (no AI needed), Plotly convergence graph with term slider, function palette (12 buttons), 8 examples
- **SEO:** Title 54 chars "Taylor & Maclaurin Series Calculator - Free with Steps"
- **Note:** Uses math.js CDN for symbolic derivatives — 100% client-side

### 4. Exponent Calculator
- **Files:** `css/exponent-calculator.css`, `js/exponent-calculator-{render,export,core}.js`, `exponent-calculator.jsp`
- **Prefix:** `ec-`
- **Color:** Amber `#d97706`
- **Features:** 4 modes (Basic Power / Apply Rules / Simplify / All Laws), all 8 exponent laws with KaTeX steps, no graph needed
- **SEO:** Title 56 chars "Exponent Calculator with Steps - All 8 Laws of Exponents"
- **Note:** No graph module — exponent calculations don't need visualization

---

## Modern Layout BUT Still Inline JS (Need JS Extraction)

These pages already use the modern three-column layout and seo-tool-page.jsp, but their JavaScript is still inline (not extracted into modules). Lower priority — they work fine, just not as maintainable.

| Page | Lines | Inline JS Lines | Notes |
|------|-------|----------------|-------|
| `logarithm-calculator.jsp` | 1369 | ~761 | Has external core.js reference |
| `derivative-calculator.jsp` | 1187 | ~661 | Has external core.js reference |
| `integral-calculator.jsp` | 2133 | ~935 | Large, has external core.js |
| `inequality-solver.jsp` | 1439 | ~865 | Has external core.js |
| `limit-calculator.jsp` | 549 | Small | Mostly externalized already |
| `matrix-transpose-calculator.jsp` | 529 | All inline | No external modules |
| `matrix-multiplication-calculator.jsp` | 506 | All inline | No external modules |

---

## Old Layout — Not Yet Migrated

These pages still use the old Bootstrap layout with `header-script.jsp`, inline CSS/JS, and MathJax. They need full migration (CSS + JS modules + JSP rewrite).

### Math Calculators (High Priority)
| Page | Description | Complexity |
|------|-------------|------------|
| `scientific-calculator.jsp` | Full scientific calculator | High |
| `graphing-calculator.jsp` | Graphing calculator | High |
| `triangle-solver.jsp` | Triangle solver (sides/angles) | Medium |
| `system-equations-solver.jsp` | Systems of equations | Medium |
| `factoring-calculator.jsp` | Polynomial factoring | Medium |
| `percentage-calculator.jsp` | Percentage calculations | Low |
| `area-volume-calculator.jsp` | Area/volume formulas | Medium |
| `distance-formula-calculator.jsp` | Distance formula | Low |

### Statistics Calculators
| Page | Description | Complexity |
|------|-------------|------------|
| `probability-calculator.jsp` | Probability distributions | Medium |
| `confidence-interval-calculator.jsp` | Confidence intervals | Medium |
| `normal-distribution-calculator.jsp` | Normal distribution | Medium |
| `z-score-calculator.jsp` | Z-score calculator | Low |
| `t-test-calculator.jsp` | T-test | Medium |
| `variance-calculator.jsp` | Variance/std dev | Low |
| `linear-regression-calculator.jsp` | Regression analysis | Medium |

### Chemistry Calculators
| Page | Description | Complexity |
|------|-------------|------------|
| `chemical-equation-balancer.jsp` | Balance equations | Medium |
| `molarity-dilution-calculator.jsp` | Molarity/dilution | Low |
| `ph-calculator.jsp` | pH calculations | Low |
| `stoichiometry-calculator.jsp` | Stoichiometry | Medium |
| `limiting-reagent-calculator.jsp` | Limiting reagent | Medium |
| `electron-configuration-calculator.jsp` | Electron config | Medium |

### Physics Calculators
| Page | Description | Complexity |
|------|-------------|------------|
| `kinematics-calculator.jsp` | Kinematics equations | Medium |
| `momentum-collision-calculator.jsp` | Momentum/collisions | Medium |
| `ohms-law-calculator.jsp` | Ohm's law | Low |

---

## Migration Checklist (Per Page)

When migrating a new page, follow this order:

1. **Read the existing JSP** — understand modes, inputs, computation logic, output format
2. **Choose color theme** — pick a unique color not already used
3. **Choose CSS prefix** — 2-3 letter abbreviation (e.g., `fc-` for factoring calculator)
4. **Create `css/<tool>.css`** — copy structure from `css/exponent-calculator.css`, replace prefix and colors
5. **Create `js/<tool>-render.js`** — port all rendering/step-building logic, KaTeX instead of MathJax
6. **Create `js/<tool>-graph.js`** (if needed) — Plotly lazy-load pattern from `linear-solver-graph.js`
7. **Create `js/<tool>-export.js`** — LaTeX copy, share URL (base64 JSON in `?d=`), Python compiler templates (2-3 templates)
8. **Create `js/<tool>-core.js`** — IIFE, state object, event binding, references R/G/E modules
9. **Rewrite `<tool>.jsp`** — three-column layout, match series-calculator.jsp structure
10. **Consistency check** — verify all DOM IDs in core.js exist in JSP, all CSS classes exist
11. **SEO audit** — title 50-60 chars, description ~160 chars, 5 FAQ pairs targeting PAA queries

### Python Compiler Templates
Each tool should have 2-3 Python templates for the onecompiler-embed panel:
- Template 1: Basic computation (plain Python)
- Template 2: All features/modes demonstrated
- Template 3: SymPy symbolic version

### Share URL Pattern
```javascript
// Encode
var data = { mode: 'basic', a: 2, b: 5 };
var url = location.origin + location.pathname + '?d=' + btoa(JSON.stringify(data));

// Decode
var params = new URLSearchParams(location.search);
var data = JSON.parse(atob(params.get('d')));
```

### Educational Content Pattern
Below the main tool, add 3-4 scroll-animated sections:
1. "What is [concept]?" — definition with visual breakdown
2. Key formulas/rules grid
3. Real-world applications (3 cards)
4. FAQ accordion (5 questions targeting Google PAA)

---

## Key Reference Files

| File | Use As Template For |
|------|-------------------|
| `series-calculator.jsp` | Full JSP layout (most recent, cleanest) |
| `css/exponent-calculator.css` | CSS structure (modes, steps, laws, examples) |
| `js/linear-solver-core.js` | Core.js pattern with graph integration |
| `js/exponent-calculator-core.js` | Core.js pattern without graph (simpler) |
| `js/series-calculator-export.js` | Export module with Python templates |
| `modern/components/seo-tool-page.jsp` | SEO title/description rendering logic |

---

## Suggested Next Migrations (Priority Order)

Based on traffic potential and complexity:

1. **`percentage-calculator.jsp`** — Low complexity, extremely high search volume ("percentage calculator" is massive)
2. **`triangle-solver.jsp`** — Medium complexity, high search volume
3. **`factoring-calculator.jsp`** — Medium complexity, strong math education traffic
4. **`z-score-calculator.jsp`** — Low complexity, steady statistics traffic
5. **`probability-calculator.jsp`** — Medium complexity, good traffic
6. **`normal-distribution-calculator.jsp`** — Medium complexity, pairs well with z-score
7. **`scientific-calculator.jsp`** — High complexity, very high traffic but big effort
8. **`graphing-calculator.jsp`** — High complexity, very competitive SERP
