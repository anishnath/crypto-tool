<%--
    Cubing Guide — reusable body fragment.

    Includes its own scoped styles + markup + script tag.  Drop this in
    anywhere you want the tabbed cubing reference to appear:

        <jsp:include page="components/cubing-guide-body.jsp" />

    Currently included by:
      - math/cubing-guide.jsp        (standalone page)
      - math/rubik-nxn-solver.jsp    (replaces the legacy "How it works")

    Three.js importmap MUST already be set on the host page (the solver
    page sets it; the standalone cubing-guide.jsp sets it).
--%>
<% String cgV = String.valueOf(System.currentTimeMillis()); %>
<style>
    /* All cubing-guide rules use a `.cg-` prefix to avoid colliding with
       the solver's `.rk-` rules.  Colours / typography pick up from the
       shared math-studio.css and the solver's `--rk-tool` palette. */
    .cg-root {
        margin-top: 0.4rem;
        font: 0.92rem/1.5 var(--ms-font-sans);
        color: var(--ms-text);
    }
    .cg-section-intro {
        margin: 0 0 1rem;
        color: var(--ms-ink-soft);
    }
    .cg-layout {
        display: grid;
        grid-template-columns: 1fr 320px;
        gap: 1.4rem;
        align-items: start;
    }
    @media (max-width: 880px) { .cg-layout { grid-template-columns: 1fr; } }

    /* ── tabs ──────────────────────────────────────────────────── */
    .cg-tabs {
        display: flex;
        flex-wrap: wrap;
        gap: 0.25rem;
        border-bottom: 2px solid var(--ms-line);
        margin: 0.4rem 0 1rem;
    }
    .cg-tab {
        background: transparent;
        border: 0;
        padding: 0.55rem 0.95rem;
        font: 600 0.85rem var(--ms-font-sans);
        color: var(--ms-muted, var(--ms-ink-soft));
        cursor: pointer;
        border-bottom: 2px solid transparent;
        margin-bottom: -2px;
        border-radius: 5px 5px 0 0;
        transition: color 120ms, background 120ms, border-color 120ms;
    }
    .cg-tab:hover { color: var(--ms-text); background: var(--ms-surface, #f8f9fa); }
    .cg-tab.active {
        color: var(--rk-tool, #6366f1);
        border-bottom-color: var(--rk-tool, #6366f1);
        background: var(--rk-light, rgba(99,102,241,0.08));
    }

    /* ── live cube card (sticky on the right) ──────────────────── */
    .cg-live-cube-card {
        position: sticky;
        top: 1rem;
        background: var(--ms-surface, #f8f9fa);
        border: 1px solid var(--ms-line);
        border-radius: 8px;
        padding: 0.85rem;
    }
    .cg-live-cube-title {
        font: 700 0.78rem var(--ms-font-sans);
        margin: 0 0 0.55rem;
        color: var(--ms-ink-soft);
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }
    #cg-live-cube-host {
        width: 100%;
        height: 280px;
        background: rgba(0,0,0,0.02);
        border-radius: 6px;
    }
    .cg-live-cube-help {
        font-size: 0.78rem;
        color: var(--ms-ink-soft);
        margin-top: 0.55rem;
    }

    /* ── filter chips ──────────────────────────────────────────── */
    .cg-filter-row {
        display: flex;
        flex-wrap: wrap;
        gap: 0.35rem;
        margin: 0.5rem 0 0.85rem;
    }
    .cg-chip {
        background: transparent;
        border: 1px solid var(--ms-line);
        color: var(--ms-text);
        padding: 0.3rem 0.7rem;
        font: 600 0.74rem var(--ms-font-sans);
        border-radius: 999px;
        cursor: pointer;
        transition: background 120ms, border-color 120ms;
    }
    .cg-chip:hover { background: var(--ms-surface, #f8f9fa); }
    .cg-chip.active {
        background: var(--rk-tool, #6366f1);
        color: white;
        border-color: var(--rk-tool, #6366f1);
    }

    /* ── notation table ────────────────────────────────────────── */
    .cg-table-wrap { overflow-x: auto; }
    .cg-notation-table {
        width: 100%;
        border-collapse: collapse;
        font: 0.84rem var(--ms-font-sans);
    }
    .cg-notation-table th, .cg-notation-table td {
        padding: 0.45rem 0.55rem;
        border-bottom: 1px solid var(--ms-line);
        text-align: left;
        vertical-align: middle;
    }
    .cg-notation-table th {
        background: var(--ms-surface, #f8f9fa);
        font-weight: 700;
        font-size: 0.74rem;
        text-transform: uppercase;
        letter-spacing: 0.04em;
        color: var(--ms-ink-soft);
    }
    .cg-move code {
        font: 700 0.95rem var(--ms-font-mono);
        color: var(--rk-tool, #6366f1);
        background: var(--rk-light, rgba(99,102,241,0.1));
        padding: 0.1rem 0.35rem;
        border-radius: 4px;
    }
    .cg-alias {
        font-size: 0.72rem;
        color: var(--ms-ink-soft);
        margin-left: 0.35rem;
    }
    .cg-meaning { max-width: 360px; }
    .cg-sizes {
        font: 600 0.8rem var(--ms-font-mono);
        color: var(--ms-ink-soft);
    }
    .cg-net-cell { width: 84px; }
    .cg-net-svg { display: block; max-width: 90px; }
    .cg-net-skip {
        font-style: italic;
        color: var(--ms-ink-soft);
        font-size: 0.78rem;
    }

    /* ── play button ───────────────────────────────────────────── */
    .cg-play-btn {
        background: var(--rk-tool, #6366f1);
        color: white;
        border: 0;
        border-radius: 50%;
        width: 28px; height: 28px;
        font-size: 0.78rem;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        line-height: 1;
        transition: background 120ms, transform 120ms;
    }
    .cg-play-btn:hover { background: var(--rk-tool-dark, #4f46e5); transform: scale(1.06); }
    .cg-play-btn-lg { width: 34px; height: 34px; font-size: 0.9rem; }

    /* ── stage cards (LBL / CFOP / big cube) — match .rk-card look ── */
    .cg-stage-card {
        background: var(--ms-surface, #f8f9fa);
        border: 1px solid var(--ms-line);
        border-left: 3px solid var(--rk-tool, #6366f1);
        border-radius: 6px;
        padding: 0.85rem 1rem;
        margin-bottom: 0.85rem;
    }
    .cg-stage-name {
        font: 700 1.05rem var(--ms-font-sans);
        margin: 0 0 0.45rem;
        color: var(--ms-text);
    }
    .cg-stage-goal, .cg-stage-tip {
        margin: 0 0 0.45rem;
        font-size: 0.88rem;
    }
    .cg-stage-algs {
        margin-top: 0.65rem;
        display: flex;
        flex-direction: column;
        gap: 0.35rem;
    }
    .cg-stage-alg {
        display: flex;
        align-items: center;
        gap: 0.55rem;
        padding: 0.35rem 0.55rem;
        background: var(--ms-bg, white);
        border: 1px solid var(--ms-line);
        border-radius: 5px;
        flex-wrap: wrap;
    }
    .cg-stage-alg-name { font-weight: 600; font-size: 0.84rem; }
    .cg-stage-alg code {
        font: 0.84rem var(--ms-font-mono);
        color: var(--rk-tool-dark, #4f46e5);
        flex: 1;
        min-width: 100px;
    }
    .cg-intro {
        margin: 0 0 1rem;
        color: var(--ms-text);
    }
    .cg-intro-after { margin-top: 0.65rem; }

    /* ── algorithm library grid ────────────────────────────────── */
    .cg-controls { margin-bottom: 0.5rem; }
    .cg-search {
        width: 100%;
        padding: 0.45rem 0.7rem;
        font: 0.92rem var(--ms-font-sans);
        border: 1px solid var(--ms-line);
        border-radius: 6px;
        background: var(--ms-bg, white);
        color: var(--ms-text);
    }
    .cg-search:focus {
        outline: 2px solid var(--rk-tool, #6366f1);
        outline-offset: 1px;
    }
    .cg-alg-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
        gap: 0.85rem;
        margin-top: 0.85rem;
    }
    .cg-alg-card {
        background: var(--ms-surface, #f8f9fa);
        border: 1px solid var(--ms-line);
        border-radius: 8px;
        padding: 0.8rem;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }
    .cg-alg-head {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .cg-alg-name {
        font: 700 0.95rem var(--ms-font-sans);
        margin: 0;
    }
    .cg-alg-notation {
        display: block;
        font: 0.84rem var(--ms-font-mono);
        background: var(--ms-bg, white);
        padding: 0.4rem 0.55rem;
        border-radius: 5px;
        border: 1px solid var(--ms-line);
        color: var(--rk-tool-dark, #4f46e5);
        word-break: break-all;
    }
    .cg-alg-purpose { font-size: 0.82rem; color: var(--ms-ink-soft); margin: 0; }
    .cg-alg-tags { display: flex; flex-wrap: wrap; gap: 0.25rem; }
    .cg-tag {
        background: var(--ms-bg, white);
        border: 1px solid var(--ms-line);
        color: var(--ms-ink-soft);
        font: 600 0.7rem var(--ms-font-sans);
        padding: 0.15rem 0.45rem;
        border-radius: 999px;
    }
    .cg-empty { color: var(--ms-ink-soft); padding: 1rem; text-align: center; }

    /* ── glossary + schemes ────────────────────────────────────── */
    .cg-section-h {
        font: 700 1.1rem var(--ms-font-sans);
        margin: 1.2rem 0 0.65rem;
        color: var(--ms-text);
    }
    .cg-section-h:first-child { margin-top: 0; }
    .cg-scheme-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
        gap: 0.85rem;
    }
    .cg-scheme-card {
        background: var(--ms-surface, #f8f9fa);
        border: 1px solid var(--ms-line);
        border-radius: 6px;
        padding: 0.85rem;
    }
    .cg-scheme-card h4 {
        margin: 0 0 0.4rem;
        font: 700 0.95rem var(--ms-font-sans);
    }
    .cg-scheme-common { margin: 0 0 0.55rem; font-size: 0.82rem; color: var(--ms-ink-soft); }
    .cg-scheme-layout {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 0.4rem;
        margin-bottom: 0.55rem;
    }
    .cg-scheme-swatch { display: flex; align-items: center; gap: 0.4rem; }
    .cg-scheme-color {
        width: 18px; height: 18px;
        border: 1px solid var(--ms-line);
        border-radius: 3px;
    }
    .cg-scheme-label { font: 0.78rem var(--ms-font-mono); }
    .cg-scheme-mnemonic { margin: 0; font-size: 0.82rem; }
    .cg-glossary {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        column-gap: 1.2rem;
        row-gap: 0.55rem;
        margin: 0;
    }
    .cg-glossary dt {
        font: 700 0.86rem var(--ms-font-mono);
        color: var(--rk-tool, #6366f1);
        margin-top: 0.4rem;
    }
    .cg-glossary dd {
        margin: 0 0 0.4rem;
        font-size: 0.84rem;
        color: var(--ms-text);
    }
    .cg-sources { font-size: 0.86rem; padding-left: 1.2rem; }
    .cg-sources li { margin-bottom: 0.2rem; }
    .cg-sources a { color: var(--rk-tool, #6366f1); text-decoration: none; }
    .cg-sources a:hover { text-decoration: underline; }
</style>

<div class="cg-root">
    <div class="cg-tabs" role="tablist">
        <button class="cg-tab" role="tab" data-tab="notation">Notation</button>
        <button class="cg-tab" role="tab" data-tab="beginner">Beginner (LBL)</button>
        <button class="cg-tab" role="tab" data-tab="cfop">Speedcubing (CFOP)</button>
        <button class="cg-tab" role="tab" data-tab="bigcube">Big Cubes (4&times;4+)</button>
        <button class="cg-tab" role="tab" data-tab="algs">Algorithm Library</button>
        <button class="cg-tab" role="tab" data-tab="glossary">Glossary &amp; Schemes</button>
    </div>

    <div class="cg-layout">
        <div>
            <section class="cg-tab-panel" data-tab="notation"  role="tabpanel" id="cg-tab-notation"></section>
            <section class="cg-tab-panel" data-tab="beginner"  role="tabpanel" id="cg-tab-beginner" style="display:none;"></section>
            <section class="cg-tab-panel" data-tab="cfop"      role="tabpanel" id="cg-tab-cfop"     style="display:none;"></section>
            <section class="cg-tab-panel" data-tab="bigcube"   role="tabpanel" id="cg-tab-bigcube"  style="display:none;"></section>
            <section class="cg-tab-panel" data-tab="algs"      role="tabpanel" id="cg-tab-algs"     style="display:none;"></section>
            <section class="cg-tab-panel" data-tab="glossary"  role="tabpanel" id="cg-tab-glossary" style="display:none;"></section>
        </div>

        <aside class="cg-live-cube-card" id="cg-live-cube-card">
            <div class="cg-live-cube-title">Live cube</div>
            <div id="cg-live-cube-host"></div>
            <div class="cg-live-cube-help">
                Click any &#9654; button on the left to play that move or algorithm here.
                Drag a sticker to twist a face. Drag empty space to orbit.
            </div>
        </aside>
    </div>
</div>

<script type="module" src="<%=request.getContextPath()%>/js/cubing-guide/app.js?v=<%=cgV%>"></script>
