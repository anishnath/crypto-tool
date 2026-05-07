<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Rubik's Cube Solver — math-studio shell.

        Vanilla-JS port of the React reference at /Users/anish/junk/rubiks-solver.
        Dependencies (loaded as ES modules from CDN, no build step):
          · cubejs    — Kociemba two-phase solver           (esm.sh)
          · three.js  — 3D scene with animated face turns   (unpkg)

        Core logic ported to /js/rubiks/*.js:
          cube.js, moves.js, share.js, cubies.js, parser.js, cube-net.js,
          cube-3d.js, solver.js, app.js.

        v1 omits: Web-Worker isolation + tightest-mode iterative tightening
        (cubejs's default solve() returns 20–22 moves in <50 ms on the main
        thread; that's good enough for a launch). Tightest mode requires
        worker termination on cube-state changes — a follow-up.
    --%>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free Rubik's Cube Solver — 3D Animated Step-by-Step" />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolDescription" value="Free Rubik's Cube solver with 3D animated playback. Scramble, twist, or upload a photo — instant Kociemba solution + GIF export. No signup, browser-only." />
        <jsp:param name="toolUrl" value="math/rubiks-cube-solver.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        <jsp:param name="toolKeywords" value="rubiks cube solver, rubik's cube solver, online rubiks cube solver, free rubiks cube solver, 3d rubiks cube solver, animated rubiks cube, kociemba algorithm, 3x3 cube solver, rubik solver online, online cube solver, cube simulator, virtual rubiks cube, gods number, how to solve rubiks cube, rubiks cube algorithm, speedcubing solver, rubiks cube net parser, free cube simulator" />
        <jsp:param name="toolImage" value="rubik-cube-solver-og.png" />
        <jsp:param name="toolFeatures" value="Image-to-state parser (CV pipeline with center-calibration in CIE Lab),Kociemba two-phase solver via cubejs (typically 20-22 moves),Click-to-edit cube net for fixing mis-detected stickers,3D animated cube with face-turn playback,Step-by-step navigation with auto-play (slow / normal / fast),Random scramble + reset + shareable URL,Drag-and-drop or paste image (Cmd+V) anywhere on the page,Keyboard nav (left right arrows + space),Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="teaches" value="Rubik's Cube notation, Kociemba two-phase algorithm, cube state representation, group theory basics, recreational mathematics" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate" />
        <jsp:param name="howToSteps" value="Get a cube state in|Upload a flat-net image with the Upload button or paste/drop one anywhere on the page. Or click Random scramble for a programmatic state.,Fix any wrong stickers|The detected state shows in an editable cube net. Click any sticker to cycle through the six face colors and correct mis-detections.,Click Solve|cubejs runs Kociemba's two-phase algorithm. Solutions are typically 20-22 moves and arrive in under 50 ms after a one-time pruning-table init (~3 s).,Step through the solution|Use the Prev / Next buttons or hit Play for auto-advance with slow / normal / fast speeds. The 3D cube animates each face turn while the 2D net highlights the active face.,Share|Click Share to copy a URL that reproduces the exact current state — useful for asking a teacher or sharing a tricky scramble." />
        <jsp:param name="faq1q" value="What is the Kociemba algorithm?" />
        <jsp:param name="faq1a" value="Kociemba's two-phase algorithm is a fast Rubik's-Cube-solving method that splits the search into phase 1 (reaching the G1 subgroup where edges are oriented and U/D-slice edges are in place) and phase 2 (solving the rest using only U, D, R2, L2, F2, B2 moves). Pruning tables make each phase efficient. Solutions are typically 20-22 moves and computed in under 50 milliseconds, after a one-time ~3-second initialization. The optimal upper bound for any cube state is 20 moves (God's Number, proven 2010)." />
        <jsp:param name="faq2q" value="What is God's Number for a Rubik's Cube?" />
        <jsp:param name="faq2a" value="God's Number is 20 — every solvable Rubik's Cube state can be solved in 20 face turns or fewer. This was proven in 2010 by Tomas Rokicki, Herbert Kociemba, Morley Davidson, and John Dethridge using ~35 CPU-years of cluster compute. The Kociemba algorithm doesn't always find a 20-move solution on the first try; it returns the first solution it finds, which is typically 20-22 moves. Tighter solvers iterate to find the formal 20-move bound." />
        <jsp:param name="faq3q" value="How does the image parser work?" />
        <jsp:param name="faq3a" value="The parser auto-crops the unfolded-net image to its bounding box, divides the cropped area into a 12 x 9 sticker grid, samples a small patch at each sticker's geometric center in CIE Lab color space, then assigns each sticker to a face by classifying against the six center stickers. The center calibration uses brute-force optimal 6-way assignment over all 720 permutations, which makes it robust to palette drift across renderers. Works on flat-net images from Ruwix, this app's own renderer, and most online cube simulators." />
        <jsp:param name="faq4q" value="What cube notation does the solver use?" />
        <jsp:param name="faq4a" value="Standard Rubik's Cube notation: U / D / L / R / F / B for the six faces (Up, Down, Left, Right, Front, Back). A bare letter means a 90-degree clockwise rotation looking at that face from outside. An apostrophe suffix means counter-clockwise (e.g. R' is right face counter-clockwise). A 2 suffix means 180 degrees (e.g. F2 is front face half-turn). Solutions are space-separated sequences of these moves." />
        <jsp:param name="faq5q" value="Is my cube state sent to a server?" />
        <jsp:param name="faq5a" value="No. Everything runs in your browser — image parsing, solving, and rendering are all client-side JavaScript. The cubejs solver loads from a CDN once, then all subsequent solving is local. The shareable URL encodes the cube state in the URL fragment (after the hash), which by HTTP convention is never sent to the server." />
        <jsp:param name="faq6q" value="Can I edit a sticker if the parser misreads it?" />
        <jsp:param name="faq6a" value="Yes. Click any sticker on the editable cube net to cycle through the six face colors (white, red, green, yellow, orange, blue). The validity check updates in real time — when all six colors have nine stickers and centers are distinct, the Solve button becomes available." />
    </jsp:include>

    <%--
        SoftwareApplication schema — drives the "Free / Educational" rich-result
        badge in Google.  Tells crawlers this page is a free utility app, not
        just an article; meaningfully lifts SERP CTR for "rubiks cube solver"
        and similar intent queries.
    --%>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Free Rubik's Cube Solver",
      "url": "https://8gwifi.org/math/rubiks-cube-solver.jsp",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any (browser)",
      "offers": {
        "@type": "Offer",
        "price": "0.00",
        "priceCurrency": "USD",
        "availability": "https://schema.org/InStock"
      },
      "browserRequirements": "Requires modern browser with WebGL and ES modules.",
      "isAccessibleForFree": true,
      "featureList": [
        "Kociemba two-phase solver (cubejs) — typically 20–22 moves in <50 ms",
        "Animated 3D cube playback (Three.js)",
        "Image-to-state parser for unfolded-net screenshots",
        "Click-to-fix sticker editor",
        "18 manual move buttons + keyboard shortcuts (U/R/F/D/L/B + Shift)",
        "Random scramble + auto-scramble on first load",
        "Move history with Undo (Cmd/Ctrl-Z)",
        "Animated GIF export of solution playback"
      ],
      "creator": {
        "@type": "Person",
        "name": "Anish Nath",
        "url": "https://8gwifi.org",
        "sameAs": ["https://twitter.com/anish2good"]
      }
    }
    </script>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://esm.sh">
    <link rel="dns-prefetch" href="https://unpkg.com">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <%--
        Import map: lets the Three.js examples (OrbitControls etc.) resolve the
        bare specifier 'three' when they internally `import { ... } from 'three'`.
        Must appear before the first <script type="module"> that triggers a
        Three.js import.  unpkg is the official Three.js CDN; esm.sh would also
        work but pulls a transformed bundle.
    --%>
    <script type="importmap">
    {
        "imports": {
            "three":         "https://unpkg.com/three@0.160.0/build/three.module.js",
            "three/addons/": "https://unpkg.com/three@0.160.0/examples/jsm/"
        }
    }
    </script>

    <style>
        /* ─── Rubik's-cube tokens (sit on top of math-studio palette) ─── */
        :root {
            --rk-tool: #6366f1;
            --rk-tool-dark: #4f46e5;
            --rk-gradient: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            --rk-light: rgba(99, 102, 241, 0.08);
        }
        [data-theme="dark"] { --rk-light: rgba(99, 102, 241, 0.16); }

        .rk-stage {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
            gap: 1.25rem;
            align-items: start;
        }
        @media (max-width: 880px) {
            .rk-stage { grid-template-columns: 1fr; }
        }

        .rk-card {
            background: var(--ms-panel-bg);
            border: 1px solid var(--ms-line);
            border-radius: var(--ms-radius);
            padding: 1rem 1.1rem;
            color: var(--ms-ink);
        }
        .rk-card h2.rk-card-title {
            font: 500 1rem var(--ms-font-serif);
            color: var(--ms-ink);
            margin: 0 0 0.75rem;
            letter-spacing: -0.01em;
        }

        #rk-net-host { background: var(--ms-panel-bg-soft); border-radius: var(--ms-radius-sm); padding: 0.75rem; }
        #rk-cube3d-host {
            width: 100%; height: 360px;
            background: var(--ms-panel-bg-soft);
            border-radius: var(--ms-radius-sm);
        }

        .rk-toolbar {
            display: flex; flex-wrap: wrap; gap: 0.5rem;
            align-items: center;
            margin-bottom: 0.85rem;
        }
        .rk-btn {
            padding: 0.55rem 0.95rem;
            font: 600 0.85rem var(--ms-font-sans);
            border: 1.5px solid var(--ms-line);
            border-radius: var(--ms-radius-sm);
            background: var(--ms-panel-bg);
            color: var(--ms-ink-soft);
            cursor: pointer;
            transition: border-color 0.12s, background 0.12s;
            min-height: 44px;
        }
        .rk-btn:hover:not(:disabled) {
            border-color: var(--rk-tool);
            color: var(--rk-tool);
        }
        .rk-btn:disabled { opacity: 0.55; cursor: not-allowed; }
        .rk-btn-primary {
            background: var(--rk-gradient);
            color: #fff;
            border-color: transparent;
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.22);
        }
        .rk-btn-primary:hover:not(:disabled) {
            background: var(--rk-gradient);
            color: #fff;
            border-color: transparent;
            opacity: 0.92;
        }

        .rk-status {
            margin-left: auto;
            font: 500 0.78rem var(--ms-font-mono);
            color: var(--ms-muted);
            padding: 0.3rem 0.65rem;
            border-radius: 999px;
            background: var(--ms-panel-bg-soft);
            border: 1px solid var(--ms-line);
        }
        .rk-status[data-state="ready"] { color: #15803d; border-color: rgba(21, 128, 61, 0.3); }

        /* Compact playback strip — second toolbar row, only when solution active. */
        .rk-playback-strip {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.65rem;
            padding-top: 0.65rem;
            border-top: 1px dashed var(--ms-line);
            flex-wrap: wrap;
        }
        .rk-playback-summary {
            font: 600 0.85rem var(--ms-font-sans);
            color: var(--rk-tool-dark);
        }
        .rk-playback-step {
            font: 0.78rem var(--ms-font-mono);
            color: var(--ms-muted);
            margin-left: auto;
        }

        .rk-banner {
            margin: 0 0 0.75rem;
            padding: 0.55rem 0.85rem;
            font: 0.85rem/1.5 var(--ms-font-sans);
            border-radius: var(--ms-radius-sm);
            border: 1px solid transparent;
        }
        .rk-banner-ok  { background: var(--rk-light);                 color: var(--ms-ink-soft); border-color: rgba(99,102,241,0.25); }
        .rk-banner-bad { background: rgba(239, 68, 68, 0.08);         color: #b91c1c;            border-color: rgba(239,68,68,0.3); }
        .rk-banner-err { background: rgba(239, 68, 68, 0.12);         color: #b91c1c;            border-color: rgba(239,68,68,0.4); }
        .rk-banner-info{ background: rgba(99, 102, 241, 0.12);        color: var(--rk-tool-dark); border-color: rgba(99,102,241,0.4); }

        /* Solution panel */
        .rk-moves-list {
            display: flex; flex-wrap: wrap; gap: 0.3rem;
            margin: 0.5rem 0 0.85rem;
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

        /* History strip — shows manual twists with an Undo button. */
        .rk-history-strip {
            display: flex; align-items: center; gap: 0.5rem;
            margin-top: 0.65rem; padding-top: 0.65rem;
            border-top: 1px dashed var(--ms-line);
            flex-wrap: wrap;
        }
        .rk-history-label {
            font: 600 0.78rem var(--ms-font-sans);
            color: var(--ms-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .rk-history-list {
            display: flex; gap: 0.25rem; flex-wrap: wrap;
            flex: 1; min-width: 0;
            max-height: 4.5rem; overflow-y: auto;
        }
        .rk-history-list .rk-move {
            cursor: default;
            padding: 0.2rem 0.5rem;
            font: 600 0.75rem var(--ms-font-mono);
        }
        .rk-history-list .rk-move:hover { border-color: var(--ms-line); }

        /* GIF recording status pill */
        .rk-record-status {
            display: inline-block;
            margin-left: 0.5rem;
            padding: 0.25rem 0.65rem;
            border-radius: 999px;
            font: 600 0.75rem var(--ms-font-mono);
            background: rgba(99, 102, 241, 0.12);
            color: var(--rk-tool-dark);
            border: 1px solid rgba(99, 102, 241, 0.35);
        }

        .rk-step-controls { display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap; margin-bottom: 0.5rem; }
        .rk-step-status   { color: var(--ms-muted); font: 0.82rem var(--ms-font-sans); flex: 1; min-width: 0; }
        .rk-speed-row     { display: flex; gap: 0.4rem; align-items: center; font: 0.78rem var(--ms-font-sans); color: var(--ms-muted); }
        .rk-speed-btn     { padding: 0.3rem 0.7rem; font: 500 0.75rem var(--ms-font-sans); border: 1.5px solid var(--ms-line); background: var(--ms-panel-bg); color: var(--ms-ink-soft); border-radius: 999px; cursor: pointer; }
        .rk-speed-btn.active { background: var(--rk-tool); color: #fff; border-color: var(--rk-tool); }

        .rk-hint { font: 0.78rem var(--ms-font-sans); color: var(--ms-muted); margin: 0.5rem 0 0; }

        /* Twist panel — 18 buttons (6 faces × 3 turn types) for manual moves. */
        .rk-twist-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0.55rem 1.5rem;
        }
        @media (max-width: 540px) {
            .rk-twist-grid { grid-template-columns: 1fr; }
        }
        .rk-twist-row {
            display: grid;
            grid-template-columns: 2.25rem repeat(3, minmax(0, 1fr));
            gap: 0.4rem;
            align-items: center;
        }
        .rk-twist-face {
            font: 700 0.9rem var(--ms-font-mono);
            color: var(--rk-tool);
            text-align: center;
            background: var(--rk-light);
            padding: 0.45rem 0;
            border-radius: var(--ms-radius-sm);
        }
        .rk-twist-btn {
            padding: 0.5rem 0;
            font: 600 0.85rem var(--ms-font-mono);
            border: 1.5px solid var(--ms-line);
            background: var(--ms-panel-bg);
            color: var(--ms-ink);
            border-radius: var(--ms-radius-sm);
            cursor: pointer;
            min-height: 40px;
            transition: border-color 0.12s, background 0.12s, color 0.12s;
        }
        .rk-twist-btn:hover:not(:disabled) {
            border-color: var(--rk-tool);
            color: var(--rk-tool);
            background: var(--rk-light);
        }
        .rk-twist-btn:active:not(:disabled) {
            transform: translateY(1px);
        }
        .rk-twist-btn:disabled { opacity: 0.45; cursor: not-allowed; }

        .rk-notation { margin-top: 1rem; padding: 0.85rem 1rem; background: var(--ms-panel-bg-soft); border: 1px solid var(--ms-line); border-radius: var(--ms-radius-sm); }
        .rk-notation summary { cursor: pointer; font-weight: 600; }
        .rk-notation ul { margin: 0.5rem 0 0; padding-left: 1.25rem; font: 0.85rem/1.6 var(--ms-font-sans); color: var(--ms-ink-soft); }
        .rk-notation code { font-family: var(--ms-font-mono); background: var(--ms-panel-bg); padding: 0.1rem 0.3rem; border-radius: 4px; border: 1px solid var(--ms-line); }
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

    <% request.setAttribute("activeService", "rubiks-cube"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Rubik's Cube Solver</span>
            </nav>
            <h1>Free Rubik's Cube Solver &mdash; 3D Animated, Step-by-Step</h1>
        </header>

        <!-- Toolbar -->
        <div class="rk-card">
            <div class="rk-toolbar">
                <input type="file" id="rk-file-input" accept="image/*" style="display:none;">
                <button type="button" class="rk-btn"        id="rk-upload-btn">Upload net image</button>
                <button type="button" class="rk-btn"        id="rk-scramble-btn">Random scramble</button>
                <button type="button" class="rk-btn"        id="rk-reset-btn">Reset</button>
                <button type="button" class="rk-btn"        id="rk-share-btn" title="Copy a URL that reproduces this exact state">Share</button>
                <button type="button" class="rk-btn rk-btn-primary" id="rk-solve-btn" disabled>Solve</button>
                <span class="rk-status" id="rk-status" role="status" aria-live="polite" data-state="init">Solver: initializing…</span>
            </div>

            <%--
                Compact playback strip — appears directly under the main toolbar
                whenever a solution is active.  Keeps the primary playback
                controls (Prev / Play / Next) and the step counter above the
                fold so users can run the solve without scrolling to the
                detail panel below the stage.
            --%>
            <div class="rk-playback-strip" id="rk-playback-strip" style="display:none;">
                <span class="rk-playback-summary" id="rk-tb-summary"></span>
                <button type="button" class="rk-btn"               id="rk-tb-prev-btn">&larr; Prev</button>
                <button type="button" class="rk-btn rk-btn-primary" id="rk-tb-play-btn">&#9654; Play</button>
                <button type="button" class="rk-btn"               id="rk-tb-next-btn">Next &rarr;</button>
                <span class="rk-playback-step" id="rk-tb-step"></span>
            </div>

            <%-- Manual-twist history strip — only shown when there's something to undo. --%>
            <div class="rk-history-strip" id="rk-history-strip" style="display:none;">
                <span class="rk-history-label">History:</span>
                <div class="rk-history-list" id="rk-history-list"></div>
                <button type="button" class="rk-btn" id="rk-undo-btn"
                        title="Undo last manual twist (Cmd/Ctrl-Z)">&#x21B6; Undo</button>
            </div>

            <p class="rk-banner rk-banner-ok" id="rk-validation"
               role="status" aria-live="polite">
                Valid cube state — click any sticker to fix a wrong color. Tip:
                paste (⌘V) or drop a net image anywhere on the page.
            </p>
            <p class="rk-banner rk-banner-err" id="rk-parse-error" role="alert" style="display:none;"></p>
            <p class="rk-banner rk-banner-err" id="rk-solve-error" role="alert" style="display:none;"></p>
            <p class="rk-banner rk-banner-info" id="rk-share-feedback" role="status" aria-live="polite" style="display:none;"></p>
        </div>

        <div class="rk-stage" style="margin-top:1.25rem;">
            <!-- 2D net -->
            <div class="rk-card">
                <h2 class="rk-card-title">Cube net &mdash; click a sticker to fix it</h2>
                <div id="rk-net-host" aria-label="Editable cube net"></div>
            </div>

            <!-- 3D preview -->
            <div class="rk-card">
                <h2 class="rk-card-title">3D preview &mdash; drag to orbit</h2>
                <div id="rk-cube3d-host"></div>
            </div>
        </div>

        <!-- Manual twist controls — 18 buttons (6 faces × 3 turns) -->
        <div class="rk-card" id="rk-twist-panel" style="margin-top:1.25rem;">
            <h2 class="rk-card-title">Twist the cube &mdash; try out moves</h2>
            <div class="rk-twist-grid">
                <% String[] faces = { "U", "R", "F", "D", "L", "B" }; %>
                <% for (String f : faces) { %>
                <div class="rk-twist-row">
                    <span class="rk-twist-face"><%=f%></span>
                    <button type="button" class="rk-twist-btn" data-move="<%=f%>"  title="<%=f%> &mdash; 90° clockwise"><%=f%></button>
                    <button type="button" class="rk-twist-btn" data-move="<%=f%>'" title="<%=f%>' &mdash; 90° counter-clockwise"><%=f%>'</button>
                    <button type="button" class="rk-twist-btn" data-move="<%=f%>2" title="<%=f%>2 &mdash; 180°"><%=f%>2</button>
                </div>
                <% } %>
            </div>
            <p class="rk-hint">Click any move to twist the 3D cube. Manual moves clear the active solution &mdash; treat this as a sandbox for learning notation or trying algorithms.</p>
        </div>

        <!-- Solution panel (hidden until Solve runs) -->
        <div class="rk-card" id="rk-moves-panel" style="margin-top:1.25rem; display:none;">
            <h2 class="rk-card-title" id="rk-moves-header">Solution</h2>
            <div class="rk-moves-list" id="rk-moves-list"></div>
            <%-- Description of the current step — unique to this panel (toolbar
                 strip just shows a step counter; this adds "Up face — 90° CW" etc.). --%>
            <p class="rk-step-status" id="rk-moves-status" aria-live="polite" style="margin:0 0 0.5rem;color:var(--ms-muted);font:0.82rem var(--ms-font-sans);"></p>

            <div class="rk-speed-row">
                <span>Speed:</span>
                <button type="button" class="rk-speed-btn"        data-speed="slow">slow</button>
                <button type="button" class="rk-speed-btn active"  data-speed="normal">normal</button>
                <button type="button" class="rk-speed-btn"        data-speed="fast">fast</button>
                <button type="button" class="rk-btn" id="rk-record-btn" style="margin-left:auto;"
                        title="Record solution playback as an animated GIF">🎬 Record GIF</button>
                <span class="rk-record-status" id="rk-record-status" style="display:none;"></span>
            </div>
            <p class="rk-hint">Tip: ← / → to step, space to play / pause. Type U/R/F/D/L/B for manual twists (Shift = prime). Cmd/Ctrl-Z to undo.</p>

            <details class="rk-notation">
                <summary>Notation legend</summary>
                <ul>
                    <li><code>U</code>, <code>D</code>, <code>L</code>, <code>R</code>, <code>F</code>, <code>B</code> &mdash; Up, Down, Left, Right, Front, Back face</li>
                    <li>Bare letter = 90° clockwise (looking at that face from outside the cube)</li>
                    <li><code>'</code> suffix = 90° counter-clockwise (e.g. <code>R'</code>)</li>
                    <li><code>2</code> suffix = 180° (e.g. <code>F2</code>)</li>
                </ul>
            </details>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Below-fold: cubing guide + FAQ -->
        <section class="rk-card" style="margin-top:1.25rem;">
            <h2 class="ms-section-title">Cubing guide &mdash; notation, algorithms &amp; solving</h2>
            <p style="font:0.95rem/1.5 var(--ms-font-sans); color:var(--ms-ink-soft); margin:0 0 0.85rem;">
                A visual, click-to-play reference. Open any tab below for notation, beginner method,
                speedcubing (CFOP), big-cube reduction + parity, the algorithm library, or the cubing glossary.
                Every move has a &#9654; button that animates on the live cube on the right.
                Prefer a dedicated page? <a href="<%=request.getContextPath()%>/math/cubing-guide.jsp" style="color:var(--rk-tool);">Open the standalone guide &rarr;</a>
            </p>
            <jsp:include page="components/cubing-guide-body.jsp" />
        </section>

        <section class="rk-card" style="margin-top:1.25rem;">
            <h2 class="ms-section-title">Frequently asked questions</h2>
            <div class="ms-faq">
                <div class="ms-faq-item">
                    <div class="ms-faq-q">What is the Kociemba algorithm?</div>
                    <div class="ms-faq-a">A two-phase Rubik's-Cube solver: phase 1 reaches the G1 subgroup (edges oriented, U/D-slice edges in place) using all 18 face turns; phase 2 finishes with only U, D, R<sub>2</sub>, L<sub>2</sub>, F<sub>2</sub>, B<sub>2</sub>. Pre-computed pruning tables make each phase efficient. Typical solutions are 20-22 moves; God's Number (the formal upper bound) is 20.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">What is God's Number?</div>
                    <div class="ms-faq-a">God's Number is 20 — proven in 2010 by Rokicki, Kociemba, Davidson, and Dethridge using ~35 CPU-years of cluster compute. Every solvable Rubik's Cube state is reachable from solved in 20 face turns or fewer, in the half-turn metric.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">How does the image parser work?</div>
                    <div class="ms-faq-a">It auto-crops to the non-background bounding box (background sampled from the image corners), divides into a 12 × 9 sticker grid, samples a small patch at each sticker's geometric center, converts to CIE Lab, and classifies against the six center stickers. Center calibration brute-forces the optimal 6-way assignment over all 720 permutations — robust to palette drift across renderers.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">What notation does the solver use?</div>
                    <div class="ms-faq-a">Standard cube notation: U / D / L / R / F / B for the six faces. A bare letter is 90° clockwise (looking at the face from outside). An apostrophe means counter-clockwise (R'). A 2 means 180° (F<sub>2</sub>). Solutions are space-separated sequences.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Is my cube state sent to a server?</div>
                    <div class="ms-faq-a">No. Image parsing, solving, and rendering are all client-side JavaScript. The cubejs library loads from a CDN once. The shareable URL encodes the state in the URL fragment (after #), which is never sent to the server by HTTP convention.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Do you have a 2×2 cube solver?</div>
                    <div class="ms-faq-a">Yes — try the <a href="<%=request.getContextPath()%>/math/pocket-cube-solver.jsp" style="color:var(--rk-tool);text-decoration:underline;">2×2 Pocket Cube Solver</a>. It uses a bidirectional BFS solver written in vanilla JS (no external solver dependency, since cubejs is 3×3-only), and returns provably optimal solutions in ≤11 moves (God's Number for 2×2). Same animated 3D playback + GIF export, lighter footprint.</div>
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

<!-- ─── App entry: imports the rubiks/* modules and wires up the page ─── -->
<script type="module">
import { bootstrap } from '<%=request.getContextPath()%>/js/rubiks/app.js?v=<%=v%>';

const $ = (id) => document.getElementById(id);

bootstrap({
    netHost:        $('rk-net-host'),
    cube3dHost:     $('rk-cube3d-host'),
    fileInput:      $('rk-file-input'),
    statusEl:       $('rk-status'),
    validationEl:   $('rk-validation'),
    parseErrorEl:   $('rk-parse-error'),
    solveErrorEl:   $('rk-solve-error'),
    shareFeedbackEl:$('rk-share-feedback'),
    solveBtn:       $('rk-solve-btn'),
    movesPanel:     $('rk-moves-panel'),
    movesHeader:    $('rk-moves-header'),
    movesList:      $('rk-moves-list'),
    movesStatus:    $('rk-moves-status'),
    // prevBtn / nextBtn / playBtn deliberately omitted — those duplicate
    // controls now live only in the toolbar's playback strip.
    // Compact strip in the toolbar — same handlers as the panel buttons.
    playbackStrip:  $('rk-playback-strip'),
    tbSummary:      $('rk-tb-summary'),
    tbStep:         $('rk-tb-step'),
    tbPrevBtn:      $('rk-tb-prev-btn'),
    tbNextBtn:      $('rk-tb-next-btn'),
    tbPlayBtn:      $('rk-tb-play-btn'),
    historyStrip:   $('rk-history-strip'),
    historyList:    $('rk-history-list'),
    undoBtn:        $('rk-undo-btn'),
    recordBtn:      $('rk-record-btn'),
    recordStatus:   $('rk-record-status'),
    speedBtns: {
        slow:   document.querySelector('.rk-speed-btn[data-speed="slow"]'),
        normal: document.querySelector('.rk-speed-btn[data-speed="normal"]'),
        fast:   document.querySelector('.rk-speed-btn[data-speed="fast"]'),
    },
    uploadBtn:   $('rk-upload-btn'),
    scrambleBtn: $('rk-scramble-btn'),
    resetBtn:    $('rk-reset-btn'),
    shareBtn:    $('rk-share-btn'),
}).catch((err) => {
    console.error("Rubik's solver bootstrap failed:", err);
    const v = document.getElementById('rk-validation');
    if (v) {
        v.className = 'rk-banner rk-banner-bad';
        v.textContent = 'Failed to load solver: ' + (err && err.message ? err.message : err);
    }
});
</script>

</body>
</html>
