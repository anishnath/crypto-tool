<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Rubik N×N Solver — single-page UX for 3×3 and 4×4.

        3×3 path: cubejs (Kociemba two-phase) in the browser, ~50 ms.
        4×4 path: full server pipeline (centres → orient → phase3 → phase4
                  → reduce → Kociemba), pure-Java port of the
                  rubikscubennnsolver (Python+C) reference.  Hooked at
                  /CubeSolverFunctionality.

        FE design adapts the reference React app
        /Users/anish/junk/Rubiks-Cube-Solver to the math-studio shell.
    --%>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free Rubik N×N Solver — 3×3 and 4×4" />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolDescription" value="Free Rubik's Cube N×N solver supporting 3×3 (Kociemba in-browser) and 4×4 (server-side pure-Java pipeline). Scramble, twist, solve — step-by-step playback." />
        <jsp:param name="toolUrl" value="math/rubik-nxn-solver.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        <jsp:param name="toolKeywords" value="rubiks cube solver, 4x4 cube solver, NxN cube solver, kociemba algorithm, rubiks revenge solver, cube reduction method, online cube solver, free cube solver, animated cube solver, rubiks cube tutorial" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Single page handles 3×3 and 4×4,Kociemba two-phase solver for 3×3 (browser),Full reduction-method pipeline for 4×4 (server),Step-by-step playback with Prev / Play / Next,Random scramble and reset,Manual twist controls,Move list breakdown by phase" />
    </jsp:include>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://esm.sh">
    <link rel="dns-prefetch" href="https://unpkg.com">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <%-- Three.js importmap: lets the OrbitControls addon resolve `import * as
         THREE from 'three'`.  Must come before the first module that imports
         three. --%>
    <script type="importmap">
    {
        "imports": {
            "three":         "https://unpkg.com/three@0.160.0/build/three.module.js",
            "three/addons/": "https://unpkg.com/three@0.160.0/examples/jsm/"
        }
    }
    </script>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <style>
        :root {
            --rk-tool: #6366f1;
            --rk-tool-dark: #4f46e5;
            --rk-gradient: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            --rk-light: rgba(99, 102, 241, 0.08);
        }
        [data-theme="dark"] { --rk-light: rgba(99, 102, 241, 0.16); }

        .rk-card {
            background: var(--ms-panel-bg);
            border: 1px solid var(--ms-line);
            border-radius: var(--ms-radius);
            padding: 1rem 1.1rem;
            color: var(--ms-ink);
            box-sizing: border-box;
            max-width: 100%;
            min-width: 0;
        }
        .rk-card h2.rk-card-title {
            font: 500 1rem var(--ms-font-serif);
            color: var(--ms-ink);
            margin: 0 0 0.75rem;
            letter-spacing: -0.01em;
        }
        #rk-net-host {
            background: var(--ms-panel-bg-soft);
            border-radius: var(--ms-radius-sm);
            padding: 0.6rem;
            text-align: center;
            overflow: hidden;
        }
        #rk-net-host svg { margin: 0 auto; max-width: 100%; height: auto; max-height: 280px; }
        #rk-cube3d-host {
            width: 100%;
            height: 280px;
            background: var(--ms-panel-bg-soft);
            border-radius: var(--ms-radius-sm);
            cursor: grab;
            overflow: hidden;
        }
        #rk-cube3d-host:active { cursor: grabbing; }
        #rk-cube3d-host canvas { display: block; width: 100% !important; height: 100% !important; }

        /* ─────────────────────────────────────────────────────────
           Toolbar — clean Linear/Vercel-style: borderless icons in
           segmented bars, single solid primary button, subtle tooltips.
           ───────────────────────────────────────────────────────── */
        .rk-ic { width: 14px; height: 14px; flex-shrink: 0; display: inline-block; vertical-align: -0.15em; }

        .rk-toolbar {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.85rem;
        }
        .rk-toolbar > .rk-status { margin-left: auto; }
        @media (max-width: 720px) { .rk-toolbar > .rk-status { margin-left: 0; } }

        /* Segmented control container (replaces .rk-size-group + .rk-action-group). */
        .rk-segment, .rk-size-group, .rk-action-group {
            display: inline-flex;
            background: var(--ms-panel-bg);
            border: 1px solid var(--ms-line);
            border-radius: 8px;
            padding: 2px;
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.04);
            gap: 0;
        }
        .rk-segment > * + *, .rk-size-group > * + *, .rk-action-group > * + * { margin-left: 1px; }

        /* Size selector */
        .rk-size-btn {
            padding: 0 0.85rem;
            height: 30px;
            font: 600 0.78rem var(--ms-font-sans);
            background: transparent;
            color: var(--ms-muted);
            border: 0;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.12s, color 0.12s;
            min-width: 44px;
            letter-spacing: -0.01em;
        }
        .rk-size-btn:hover:not(.active) { background: var(--rk-light); color: var(--ms-ink); }
        .rk-size-btn.active { background: var(--ms-ink); color: var(--ms-panel-bg); }
        [data-theme="dark"] .rk-size-btn.active { background: var(--rk-tool); color: #fff; }

        .rk-actions { display: flex; flex-wrap: wrap; gap: 0.4rem; align-items: center; }

        /* Default text button — used by primary Solve / Play */
        .rk-btn {
            padding: 0 0.95rem;
            height: 34px;
            font: 600 0.8rem var(--ms-font-sans);
            letter-spacing: -0.005em;
            border: 1px solid var(--ms-line);
            border-radius: 7px;
            background: var(--ms-panel-bg);
            color: var(--ms-ink-soft);
            cursor: pointer;
            transition: background 0.12s, color 0.12s, border-color 0.12s;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            white-space: nowrap;
        }
        .rk-btn:hover:not(:disabled) {
            background: var(--rk-light);
            color: var(--rk-tool-dark);
            border-color: rgba(99, 102, 241, 0.35);
        }
        .rk-btn:disabled { opacity: 0.45; cursor: not-allowed; }
        .rk-btn:focus-visible { outline: 2px solid var(--rk-tool); outline-offset: 2px; }
        .rk-btn-primary {
            background: var(--rk-tool);
            color: #fff;
            border-color: var(--rk-tool);
            box-shadow: 0 1px 2px rgba(99, 102, 241, 0.25);
        }
        .rk-btn-primary:hover:not(:disabled) {
            background: var(--rk-tool-dark);
            border-color: var(--rk-tool-dark);
            color: #fff;
        }

        /* Icon-only button (lives inside a segment) */
        .rk-btn-icon {
            width: 32px;
            height: 30px;
            padding: 0;
            border: 0;
            border-radius: 6px;
            background: transparent;
            color: var(--ms-muted);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background 0.12s, color 0.12s;
            position: relative;
        }
        .rk-btn-icon .rk-ic { width: 15px; height: 15px; }
        .rk-btn-icon:hover:not(:disabled) { background: var(--rk-light); color: var(--rk-tool-dark); }
        .rk-btn-icon:disabled { opacity: 0.4; cursor: not-allowed; }
        .rk-btn-icon:focus-visible { outline: 2px solid var(--rk-tool); outline-offset: 1px; }
        .rk-btn-icon.active { background: var(--ms-ink); color: var(--ms-panel-bg); }
        [data-theme="dark"] .rk-btn-icon.active { background: var(--rk-tool); color: #fff; }

        /* Subtle dark tooltip on hover (no arrow — minimal) */
        .rk-btn-icon .rk-label {
            position: absolute;
            bottom: calc(100% + 4px);
            left: 50%;
            transform: translateX(-50%);
            padding: 0.25rem 0.5rem;
            font: 500 0.7rem var(--ms-font-sans);
            background: rgba(15, 23, 42, 0.96);
            color: #fff;
            border-radius: 4px;
            white-space: nowrap;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.1s;
            z-index: 5;
            letter-spacing: 0.005em;
        }
        .rk-btn-icon:hover .rk-label,
        .rk-btn-icon:focus-visible .rk-label { opacity: 1; }

        .rk-status {
            font: 500 0.75rem var(--ms-font-sans);
            color: var(--ms-muted);
            padding: 0 0.7rem;
            height: 30px;
            line-height: 30px;
            border-radius: 999px;
            background: var(--ms-panel-bg-soft);
            border: 1px solid var(--ms-line);
            white-space: nowrap;
            letter-spacing: -0.005em;
        }
        .rk-status::before {
            content: '';
            display: inline-block;
            width: 6px; height: 6px;
            border-radius: 50%;
            background: var(--ms-muted);
            margin-right: 0.45rem;
            vertical-align: 1px;
        }
        .rk-status[data-state="ready"] { color: #15803d; border-color: rgba(21, 128, 61, 0.3); background: rgba(21, 128, 61, 0.04); }
        .rk-status[data-state="ready"]::before { background: #16a34a; }
        .rk-status[data-state="busy"]  { color: #b45309; border-color: rgba(180, 83, 9, 0.3);  background: rgba(180, 83, 9, 0.04); }
        .rk-status[data-state="busy"]::before { background: #f59e0b; animation: rk-pulse 1s ease-in-out infinite; }
        @keyframes rk-pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.3; } }

        /* ── Spinner + animated thinking dots ── */
        .rk-spinner {
            display: inline-block;
            width: 0.85em; height: 0.85em;
            border: 2px solid currentColor;
            border-right-color: transparent;
            border-radius: 50%;
            vertical-align: -0.15em;
            margin-right: 0.4em;
            animation: rk-spin 0.7s linear infinite;
        }
        @keyframes rk-spin { to { transform: rotate(360deg); } }
        .rk-dots::after {
            content: '';
            display: inline-block;
            width: 1.2em;
            text-align: left;
            animation: rk-dots 1.4s steps(4, end) infinite;
        }
        @keyframes rk-dots {
            0%   { content: ''; }
            25%  { content: '.'; }
            50%  { content: '..'; }
            75%  { content: '...'; }
            100% { content: ''; }
        }

        /* ── Solve overlay: full-card busy state with phase tracker ── */
        .rk-busy-card {
            margin-top: 1rem;
            padding: 1rem 1.2rem;
            border: 1px solid rgba(99, 102, 241, 0.3);
            background: linear-gradient(135deg, rgba(99,102,241,0.06), rgba(139,92,246,0.06));
            border-radius: var(--ms-radius);
            display: none;
            align-items: center;
            gap: 1rem;
        }
        .rk-busy-card.active { display: flex; }
        .rk-busy-spinner {
            width: 2.4rem; height: 2.4rem;
            border: 3px solid var(--ms-line);
            border-top-color: var(--rk-tool);
            border-right-color: var(--rk-tool);
            border-radius: 50%;
            animation: rk-spin 0.9s linear infinite;
            flex-shrink: 0;
        }
        .rk-busy-text { flex: 1; min-width: 0; }
        .rk-busy-title {
            font: 600 0.95rem var(--ms-font-sans);
            color: var(--rk-tool-dark);
            margin: 0 0 0.2rem;
        }
        .rk-busy-sub {
            font: 0.78rem var(--ms-font-mono);
            color: var(--ms-muted);
            margin: 0;
        }

        .rk-banner {
            margin: 0 0 0.75rem;
            padding: 0.55rem 0.85rem;
            font: 0.85rem/1.5 var(--ms-font-sans);
            border-radius: var(--ms-radius-sm);
            border: 1px solid transparent;
        }
        .rk-banner-ok   { background: var(--rk-light);          color: var(--ms-ink-soft);  border-color: rgba(99,102,241,0.25); }
        .rk-banner-bad  { background: rgba(239, 68, 68, 0.08);  color: #b91c1c;             border-color: rgba(239,68,68,0.3); }
        .rk-banner-info { background: rgba(99, 102, 241, 0.12); color: var(--rk-tool-dark); border-color: rgba(99,102,241,0.4); }

        .rk-stage {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
            gap: 1.25rem;
            align-items: start;
        }
        @media (max-width: 880px) { .rk-stage { grid-template-columns: 1fr; } }

        .rk-moves-list {
            display: flex; flex-wrap: wrap; gap: 0.3rem;
            margin: 0.5rem 0 0.85rem;
            max-height: 9rem; overflow-y: auto;
        }
        .rk-move {
            padding: 0.3rem 0.6rem;
            font: 600 0.85rem var(--ms-font-mono);
            background: var(--ms-panel-bg-soft);
            border: 1.5px solid var(--ms-line);
            color: var(--ms-ink);
            border-radius: 0.45rem;
            cursor: pointer;
            min-width: 44px; text-align: center;
            transition: all 0.12s;
        }
        .rk-move:hover { border-color: var(--rk-tool); }
        .rk-move.done    { background: var(--ms-panel-bg-soft); color: var(--ms-muted); opacity: 0.6; }
        .rk-move.current { background: var(--rk-tool); color: #fff; border-color: var(--rk-tool); }

        .rk-moves-meta {
            font: 500 0.85rem var(--ms-font-sans);
            color: var(--rk-tool-dark);
            margin: 0 0 0.5rem;
        }
        .rk-moves-breakdown {
            font: 0.8rem/1.6 var(--ms-font-mono);
            color: var(--ms-muted);
            margin: 0 0 0.65rem;
            display:flex; flex-wrap:wrap; gap:0.5rem 0.85rem;
        }
        .rk-piece { padding: 0.15rem 0.5rem; background: var(--ms-panel-bg-soft); border-radius: 0.4rem; border: 1px solid var(--ms-line); }
        .rk-piece strong { color: var(--rk-tool-dark); }

        .rk-playback-strip {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex-wrap: wrap;
            padding-top: 0.75rem;
            border-top: 1px dashed var(--ms-line);
            margin-top: 0.65rem;
        }
        .rk-play-step {
            margin-left: auto;
            font: 600 0.72rem var(--ms-font-mono);
            color: var(--ms-muted);
            padding: 0 0.55rem;
            background: transparent;
            border: 0;
            letter-spacing: 0.02em;
        }
        #rk-tb-step { margin-left: 0.35rem; }

        /* ── Twist panel (collapsible, tiny when closed) ── */
        .rk-twist-card {
            box-sizing: border-box;
            max-width: 100%;
            overflow: hidden;
            padding: 0 1rem !important;       /* override .rk-card padding */
        }
        .rk-twist-toggle {
            width: 100%;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.55rem 0;
            margin: 0;
            font: 600 0.85rem var(--ms-font-sans);
            color: var(--ms-ink-soft);
            background: transparent;
            border: 0;
            cursor: pointer;
            text-align: left;
            min-height: 38px;
            line-height: 1.2;
        }
        .rk-twist-toggle:hover { color: var(--rk-tool); }
        .rk-twist-toggle .rk-ic { transition: transform 0.18s; }
        .rk-twist-card.open .rk-twist-toggle .rk-ic { transform: rotate(90deg); }
        .rk-twist-toggle .rk-twist-hint { color: var(--ms-muted); font: 400 0.78rem var(--ms-font-sans); margin-left: auto; }

        /* default = collapsed; only the .open variant displays the body */
        .rk-twist-body { display: none !important; padding: 0.5rem 0 0.85rem; }
        .rk-twist-card.open .rk-twist-body { display: block !important; }

        .rk-twist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(min(100%, 280px), 1fr));
            gap: 0.5rem 1rem;
            box-sizing: border-box;
            max-width: 100%;
        }
        .rk-twist-row {
            display: grid;
            grid-template-columns: 1.8rem repeat(3, minmax(0, 1fr));
            gap: 0.35rem;
            align-items: center;
            min-width: 0;
        }
        .rk-twist-face {
            font: 700 0.85rem var(--ms-font-mono);
            color: var(--rk-tool);
            text-align: center;
            background: var(--rk-light);
            padding: 0.4rem 0;
            border-radius: var(--ms-radius-sm);
            min-width: 0;
        }
        .rk-twist-btn {
            padding: 0.45rem 0.25rem;
            font: 600 0.8rem var(--ms-font-mono);
            border: 1.5px solid var(--ms-line);
            background: var(--ms-panel-bg);
            color: var(--ms-ink);
            border-radius: var(--ms-radius-sm);
            cursor: pointer;
            min-height: 38px;
            min-width: 0;
            transition: border-color 0.12s, background 0.12s, color 0.12s;
            box-sizing: border-box;
        }
        .rk-twist-btn:hover:not(:disabled) {
            border-color: var(--rk-tool);
            color: var(--rk-tool);
            background: var(--rk-light);
        }
        .rk-twist-wide-toggle {
            display: inline-flex; align-items: center; gap: 0.4rem;
            font: 0.82rem var(--ms-font-sans); color: var(--ms-muted);
            margin-top: 0.65rem;
        }
        .rk-twist-wide-toggle.disabled { opacity: 0.45; }

        .rk-hint { font: 0.78rem var(--ms-font-sans); color: var(--ms-muted); margin: 0.5rem 0 0; }
    </style>
    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

<jsp:include page="../modern/components/nav-header.jsp" />
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="../modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">

    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
        &#9776; Math tools
    </button>

    <% request.setAttribute("activeService", "rubik-nxn"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Rubik N×N Solver</span>
            </nav>
            <h1>Rubik N&times;N Solver &mdash; 3&times;3 and 4&times;4</h1>
        </header>

        <div class="rk-card">
            <div class="rk-toolbar">
                <div class="rk-segment rk-size-group" role="tablist" aria-label="Cube size">
                    <button type="button" class="rk-size-btn active" data-size="3" role="tab" aria-selected="true">3&times;3</button>
                    <button type="button" class="rk-size-btn"        data-size="4" role="tab" aria-selected="false">4&times;4</button>
                </div>
                <div class="rk-actions">
                    <input type="file" id="rk-file-input" accept="image/*" style="display:none;">

                    <%-- Group 1: state input (image / manual edit) --%>
                    <div class="rk-segment rk-action-group" role="group" aria-label="Input state">
                        <button type="button" class="rk-btn rk-btn-icon" id="rk-upload-btn" aria-label="Upload net image" title="Upload an unfolded-net image">
                            <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                            <span class="rk-label">Upload net</span>
                        </button>
                        <button type="button" class="rk-btn rk-btn-icon" id="rk-sample-btn" aria-label="Download sample net" title="Download sample net image">
                            <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><polyline points="9 14 12 17 15 14"/><line x1="12" y1="11" x2="12" y2="17"/></svg>
                            <span class="rk-label">Sample net</span>
                        </button>
                        <button type="button" class="rk-btn rk-btn-icon" id="rk-edit-toggle" aria-label="Edit stickers" title="Toggle sticker editing" aria-pressed="false">
                            <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                            <span class="rk-label">Edit stickers</span>
                        </button>
                    </div>

                    <%-- Group 2: cube state --%>
                    <div class="rk-segment rk-action-group" role="group" aria-label="Cube state">
                        <button type="button" class="rk-btn rk-btn-icon" id="rk-scramble-btn" aria-label="Random scramble" title="Random scramble">
                            <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="3" width="18" height="18" rx="2.5"/><circle cx="8.5" cy="8.5" r="1.2" fill="currentColor"/><circle cx="15.5" cy="15.5" r="1.2" fill="currentColor"/><circle cx="15.5" cy="8.5" r="1.2" fill="currentColor"/><circle cx="8.5" cy="15.5" r="1.2" fill="currentColor"/><circle cx="12" cy="12" r="1.2" fill="currentColor"/></svg>
                            <span class="rk-label">Scramble</span>
                        </button>
                        <button type="button" class="rk-btn rk-btn-icon" id="rk-reset-btn" aria-label="Reset to solved" title="Reset to solved state">
                            <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"/></svg>
                            <span class="rk-label">Reset</span>
                        </button>
                    </div>

                    <%-- Group 3: solve + inline playback (visible only after a solve) --%>
                    <button type="button" class="rk-btn rk-btn-primary" id="rk-solve-btn" title="Solve the current state">
                        <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polygon points="5 3 19 12 5 21 5 3" fill="currentColor"/></svg>
                        Solve
                    </button>
                    <div class="rk-segment rk-action-group" id="rk-tb-playback" role="group" aria-label="Playback" style="display:none;">
                        <button type="button" class="rk-btn rk-btn-icon" id="rk-tb-prev" aria-label="Previous step" title="Previous step (←)">
                            <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="15 18 9 12 15 6"/></svg>
                            <span class="rk-label">Prev</span>
                        </button>
                        <button type="button" class="rk-btn rk-btn-primary" id="rk-tb-play" title="Play / pause (space)" aria-label="Play or pause" style="height:30px;padding:0 0.7rem;font-size:0.75rem;border-radius:6px;">
                            <svg class="rk-ic" id="rk-tb-play-ic" viewBox="0 0 24 24" fill="currentColor" stroke="none" aria-hidden="true"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                            <span id="rk-tb-play-label">Play</span>
                        </button>
                        <button type="button" class="rk-btn rk-btn-icon" id="rk-tb-next" aria-label="Next step" title="Next step (→)">
                            <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="9 18 15 12 9 6"/></svg>
                            <span class="rk-label">Next</span>
                        </button>
                        <span class="rk-play-step" id="rk-tb-step">0 / 0</span>
                    </div>
                </div>
                <span class="rk-status" id="rk-status" role="status" aria-live="polite" data-state="idle">Ready &middot; 3&times;3</span>
            </div>

            <p class="rk-banner rk-banner-ok" id="rk-validation" role="status" aria-live="polite">
                Pick a cube size, scramble, then click Solve.
                3×3 solves in your browser; 4×4 runs on the server.
            </p>

            <div class="rk-busy-card" id="rk-busy-card" role="status" aria-live="polite">
                <div class="rk-busy-spinner" aria-hidden="true"></div>
                <div class="rk-busy-text">
                    <p class="rk-busy-title" id="rk-busy-title">Thinking<span class="rk-dots"></span></p>
                    <p class="rk-busy-sub"   id="rk-busy-sub">Solving on the server &mdash; this can take 5&ndash;40 seconds for adversarial 4&times;4 scrambles.</p>
                </div>
            </div>
        </div>

        <div class="rk-stage" style="margin-top:1.25rem;">
            <div class="rk-card">
                <h2 class="rk-card-title">Cube net &mdash; click stickers to fix colours (Edit mode)</h2>
                <div id="rk-net-host" aria-label="Cube net"></div>
                <p class="rk-hint">Tip: paste (&#8984;V) or drag-and-drop a net image anywhere on the page.</p>
            </div>
            <div class="rk-card">
                <h2 class="rk-card-title">3D preview &mdash; drag to orbit</h2>
                <div id="rk-cube3d-host" aria-label="3D cube preview"></div>
            </div>
        </div>

        <div class="rk-card rk-twist-card" id="rk-twist-panel" style="margin-top:1.25rem;">
            <button type="button" class="rk-twist-toggle" id="rk-twist-toggle" aria-expanded="false" aria-controls="rk-twist-body">
                <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="9 18 15 12 9 6"/></svg>
                Twist the cube manually
                <span class="rk-twist-hint">(click to expand)</span>
            </button>
            <div class="rk-twist-body" id="rk-twist-body">
                <div class="rk-twist-grid">
                    <% String[] faces = { "U", "R", "F", "D", "L", "B" }; %>
                    <% for (String f : faces) { %>
                    <div class="rk-twist-row">
                        <span class="rk-twist-face"><%=f%></span>
                        <button type="button" class="rk-twist-btn" data-move="<%=f%>"  title="<%=f%>"><%=f%></button>
                        <button type="button" class="rk-twist-btn" data-move="<%=f%>'" title="<%=f%>'"><%=f%>'</button>
                        <button type="button" class="rk-twist-btn" data-move="<%=f%>2" title="<%=f%>2"><%=f%>2</button>
                    </div>
                    <% } %>
                </div>
                <p class="rk-hint">
                    Standard WCA notation. Wide turns (<code>Uw</code>, <code>Rw'</code>) appear in the 4&times;4 solution automatically.
                </p>
            </div>
        </div>
        <script>
        document.addEventListener('DOMContentLoaded', function () {
            var card = document.getElementById('rk-twist-panel');
            var btn  = document.getElementById('rk-twist-toggle');
            if (!card || !btn) return;
            btn.addEventListener('click', function () {
                var open = card.classList.toggle('open');
                btn.setAttribute('aria-expanded', String(open));
                var hint = btn.querySelector('.rk-twist-hint');
                if (hint) hint.textContent = open ? '(click to collapse)' : '(click to expand)';
            });
        });
        </script>

        <div class="rk-card" id="rk-moves-panel" style="margin-top:1.25rem; display:none;">
            <h2 class="rk-card-title">Solution</h2>
            <p class="rk-moves-meta" id="rk-moves-meta"></p>
            <div class="rk-moves-breakdown" id="rk-moves-breakdown"></div>
            <div class="rk-moves-list" id="rk-moves-list"></div>
            <div class="rk-playback-strip">
                <button type="button" class="rk-btn"               id="rk-play-prev">&larr; Prev</button>
                <button type="button" class="rk-btn rk-btn-primary" id="rk-play-play">&#9654; Play</button>
                <button type="button" class="rk-btn"               id="rk-play-next">Next &rarr;</button>
                <button type="button" class="rk-btn"               id="rk-record-btn" title="Record solution playback as an animated GIF" style="margin-left:auto;">
                    <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="4" fill="currentColor" stroke="none"/></svg>
                    Record GIF
                </button>
                <span class="rk-play-step" id="rk-play-step"></span>
            </div>
            <p class="rk-record-status" id="rk-record-status" style="display:none; margin:0.55rem 0 0; font:600 0.78rem var(--ms-font-mono); color:var(--rk-tool-dark); padding:0.4rem 0.7rem; background:rgba(99,102,241,0.08); border:1px solid rgba(99,102,241,0.3); border-radius:var(--ms-radius-sm);"></p>
            <p class="rk-hint">Tip: &larr; / &rarr; to step, space to play / pause. Click any move to jump.</p>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <section class="rk-card" style="margin-top:1.25rem;">
            <h2 class="ms-section-title">How it works</h2>
            <p style="font:0.95rem/1.65 var(--ms-font-sans); color:var(--ms-ink-soft); margin:0 0 0.85rem;">
                <strong>3&times;3</strong> uses
                <a href="https://github.com/ldez/cubejs" target="_blank" rel="noopener" style="color:var(--rk-tool);text-decoration:underline;">cubejs</a>,
                a JavaScript port of Herbert Kociemba's two-phase algorithm.
                Phase&nbsp;1 reaches the G1 subgroup using all 18 face turns; phase&nbsp;2
                finishes with only U, D, R<sub>2</sub>, L<sub>2</sub>, F<sub>2</sub>, B<sub>2</sub>.
                Solutions are typically 20&ndash;22 moves and complete in under 50 milliseconds
                after a one-time pruning-table init (~3&nbsp;seconds, in your browser).
            </p>
            <p style="font:0.95rem/1.65 var(--ms-font-sans); color:var(--ms-ink-soft); margin:0 0 0.85rem;">
                <strong>4&times;4</strong> uses the
                <em>reduction method</em>: solve all 24 centres &rarr; orient the 24 edge
                wings &rarr; pair the 12 dedges (2 phases) &rarr; reduce the cube to a
                3&times;3 view &rarr; finish with Kociemba. Each stage uses pre-computed
                pruning tables (mmap'd from a remote mirror, ~60&nbsp;MB total) and IDA*
                search. Ported from
                <code>rubikscubennnsolver</code> (Python+C) to pure Java &mdash; runs on
                our servlet, no external solver dependency. Typical solves take
                5&ndash;40 seconds and produce 50&ndash;65 total moves.
            </p>
        </section>

        <section class="rk-card" style="margin-top:1.25rem;">
            <h2 class="ms-section-title">Frequently asked questions</h2>
            <div class="ms-faq">
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Why does 4&times;4 run on the server?</div>
                    <div class="ms-faq-a">The reduction-method pipeline depends on ~60 MB of pre-computed pruning tables that we don't want every visitor to download. The Java implementation memory-maps the tables and runs IDA* over byte arrays at ~40 million nodes/second &mdash; well under a second per stage on warm tables.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">What notation does the solver use?</div>
                    <div class="ms-faq-a">Standard WCA notation: U / D / L / R / F / B for outer faces; <code>Uw</code> / <code>Rw</code> / etc. for wide turns (used on 4&times;4). A bare letter is 90&deg; CW; <code>'</code> is CCW; <code>2</code> is 180&deg;.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Do you have a 2&times;2 solver?</div>
                    <div class="ms-faq-a">Yes &mdash; the <a href="<%=request.getContextPath()%>/math/pocket-cube-solver.jsp" style="color:var(--rk-tool);text-decoration:underline;">2&times;2 Pocket Cube Solver</a> uses bidirectional BFS for provably optimal solutions in &le;11 moves.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Are 5&times;5, 6&times;6, 7&times;7 supported?</div>
                    <div class="ms-faq-a">Not yet. The Java engine is size-agnostic, but each size needs its own pruning tables wired up. 4&times;4 is the first cut; larger sizes are on the roadmap.</div>
                </div>
            </div>
        </section>
    </section>

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="../modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="../modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../modern/components/analytics.jsp" %>

<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>

<script type="module">
import { bootstrap } from '<%=request.getContextPath()%>/js/rubiks-nxn/app.js?v=<%=v%>';

const $ = (id) => document.getElementById(id);

bootstrap({
    netHost:        $('rk-net-host'),
    cube3dHost:     $('rk-cube3d-host'),
    fileInput:      $('rk-file-input'),
    uploadBtn:      $('rk-upload-btn'),
    sampleBtn:      $('rk-sample-btn'),
    editToggle:     $('rk-edit-toggle'),
    statusEl:       $('rk-status'),
    busyCard:       $('rk-busy-card'),
    busyTitle:      $('rk-busy-title'),
    busySub:        $('rk-busy-sub'),
    validation:     $('rk-validation'),
    scrambleBtn:    $('rk-scramble-btn'),
    resetBtn:       $('rk-reset-btn'),
    solveBtn:       $('rk-solve-btn'),
    movesPanel:     $('rk-moves-panel'),
    movesMeta:      $('rk-moves-meta'),
    movesBreakdown: $('rk-moves-breakdown'),
    movesList:      $('rk-moves-list'),
    playPrev:       $('rk-play-prev'),
    playPlay:       $('rk-play-play'),
    playNext:       $('rk-play-next'),
    playStep:       $('rk-play-step'),
    tbPlayback:     $('rk-tb-playback'),
    tbPrev:         $('rk-tb-prev'),
    tbPlay:         $('rk-tb-play'),
    tbPlayLabel:    $('rk-tb-play-label'),
    tbNext:         $('rk-tb-next'),
    tbStep:         $('rk-tb-step'),
    recordBtn:      $('rk-record-btn'),
    recordStatus:   $('rk-record-status'),
});
</script>

</body>
</html>
