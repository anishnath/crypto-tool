<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        2×2 Pocket Cube Solver — math-studio shell.

        Vanilla-JS bidirectional-BFS solver, no external deps (no cubejs —
        cubejs is 3×3-only, and the 2×2 state space is small enough to
        solve from scratch in <100ms).  Modules at /js/rubiks2/.

        v1 omits 3D — 2D net + solver + step playback only.  3D will reuse
        the rubiks/cube-3d.js scaffolding with a size param in a follow-up.
    --%>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free 2×2 Cube Solver — Optimal Solution in 11 Moves" />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolDescription" value="Free 2×2 Pocket Cube solver with 3D animated playback. Optimal solution in 11 moves or fewer (God's Number). Manual twists, GIF export, no signup." />
        <jsp:param name="toolUrl" value="math/pocket-cube-solver.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        <jsp:param name="toolKeywords" value="2x2 cube solver, pocket cube solver, 2x2 rubiks cube solver, online 2x2 solver, free 2x2 solver, 2x2 cube algorithm, mini cube solver, 2x2x2 solver, pocket cube algorithm, beginner cube solver, optimal 2x2 solution, gods number 2x2, 2x2 rubiks cube online, 3d 2x2 solver, 2x2 cube simulator, how to solve 2x2 cube, 2x2 ortega method, easiest rubiks cube" />
        <jsp:param name="toolImage" value="rubik-cube-solver-og.png" />
        <jsp:param name="toolFeatures" value="Optimal solver — every solution at most 11 moves (God's number for 2x2),Bidirectional BFS in vanilla JS — no external solver dependency,Click-to-edit cube net for fixing mis-detected stickers,Step-by-step solution playback with auto-play,18 manual move buttons (U/R/F/D/L/B with prime and double),Random scramble + reset + shareable URL,Drag-and-drop image upload,Keyboard nav (left right arrows + space)" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="teaches" value="2x2 Rubik's Cube notation, Pocket Cube solving, bidirectional BFS, recreational mathematics, basic group theory" />
        <jsp:param name="educationalLevel" value="Middle School, High School" />
        <jsp:param name="howToSteps" value="Get a cube state in|Click Random scramble for a programmatic state, or upload / paste / drop a flat-net image of a 2x2 cube.,Fix any wrong stickers|The detected state shows in an editable 8x6 cube net. Click any sticker to cycle the six face colors and correct mis-detections.,Click Solve|The solver runs bidirectional BFS in your browser and returns an optimal solution (at most 11 moves) in well under 100 milliseconds.,Step through the solution|Use Prev / Next or hit Play for auto-advance with slow / normal / fast speeds. The 2D net highlights the active face on each step.,Share|Click Share to copy a URL that reproduces the exact current state." />
        <jsp:param name="faq1q" value="What is God's Number for the 2×2 cube?" />
        <jsp:param name="faq1a" value="11 in the half-turn (face-turn) metric. Every solvable 2×2 (Pocket Cube) state can be solved in 11 face turns or fewer. This was proved in 1981 by Eric Larson and others — far easier than the 3×3 (which took until 2010 to prove its number is 20). The 2×2 state space has only 3,674,160 reachable positions, small enough to brute-force enumerate." />
        <jsp:param name="faq2q" value="How does the solver work?" />
        <jsp:param name="faq2a" value="Bidirectional BFS — breadth-first search from the input state forward AND from the solved state backward, alternating expansion of the smaller frontier until the two meet. With branching factor 6 (after deduping same-face moves), each side reaches depth 6 with about 47,000 states; the meet typically happens within 100 ms in pure JavaScript with no precomputation. Solutions are guaranteed optimal." />
        <jsp:param name="faq3q" value="Why doesn't the same solver work for the 3×3?" />
        <jsp:param name="faq3a" value="The 3×3 state space has about 4.3 × 10^19 positions — bidirectional BFS would need exponentially more memory to reach depth 10 each side. The 3×3 needs the Kociemba two-phase algorithm with precomputed pruning tables. The 2×2 has only ~3.7 million states, small enough that pure BFS works without any precomputation." />
        <jsp:param name="faq4q" value="What notation does the solver use?" />
        <jsp:param name="faq4a" value="Standard cube notation — U / D / L / R / F / B for the six faces. A bare letter is a 90° clockwise turn looking at that face from outside. An apostrophe means counter-clockwise (R'). A 2 means 180° (F2). For the 2×2 specifically, since there are no fixed centers, only 3 of the 6 faces are strictly needed (e.g. U, R, F) — but all 6 are supported and accept any orientation." />
        <jsp:param name="faq5q" value="Can I solve a 2×2 cube without an algorithm?" />
        <jsp:param name="faq5a" value="Yes — the 2×2 is the easiest of the Rubik's family. With practice you can solve it intuitively in ~30 seconds with no memorized algorithms by using the layered method: solve one face first (3-4 moves), then orient and permute the last layer with a small handful of standard moves. This solver shows the OPTIMAL solution which is shorter (≤11 moves) but uses moves you wouldn't naturally discover — useful for learning what's possible." />
    </jsp:include>

    <%--
        SoftwareApplication schema — drives the "Free / Educational" rich-result
        badge in Google.  Tells crawlers this page is a free utility app, not
        just an article; meaningfully lifts SERP CTR for "2x2 cube solver"
        and similar intent queries.
    --%>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Free 2×2 Pocket Cube Solver",
      "url": "https://8gwifi.org/math/pocket-cube-solver.jsp",
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
        "Bidirectional BFS solver — guaranteed optimal solutions (≤11 moves)",
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
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <%--
        Import map: lets Three.js's OrbitControls addon resolve the bare
        specifier 'three' when it internally `import { ... } from 'three'`.
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
        :root {
            --rk-tool: #0e7490;
            --rk-tool-dark: #0c4a6e;
            --rk-gradient: linear-gradient(135deg, #0e7490 0%, #14b8a6 100%);
            --rk-light: rgba(14, 116, 144, 0.08);
        }
        [data-theme="dark"] { --rk-light: rgba(14, 116, 144, 0.18); }

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

        #rk-net-host { background: var(--ms-panel-bg-soft); border-radius: var(--ms-radius-sm); padding: 1rem; }
        #rk-cube3d-host {
            width: 100%; height: 360px;
            background: var(--ms-panel-bg-soft);
            border-radius: var(--ms-radius-sm);
        }
        .rk-stage {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
            gap: 1.25rem;
            align-items: start;
        }
        @media (max-width: 880px) { .rk-stage { grid-template-columns: 1fr; } }

        .rk-toolbar {
            display: flex; flex-wrap: wrap; gap: 0.5rem;
            align-items: center; margin-bottom: 0.85rem;
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
        .rk-btn:hover:not(:disabled) { border-color: var(--rk-tool); color: var(--rk-tool); }
        .rk-btn:disabled { opacity: 0.55; cursor: not-allowed; }
        .rk-btn-primary {
            background: var(--rk-gradient);
            color: #fff; border-color: transparent;
            box-shadow: 0 2px 8px rgba(14, 116, 144, 0.25);
        }
        .rk-btn-primary:hover:not(:disabled) { background: var(--rk-gradient); color: #fff; opacity: 0.92; }

        .rk-playback-strip {
            display: flex; align-items: center; gap: 0.5rem;
            margin-top: 0.65rem; padding-top: 0.65rem;
            border-top: 1px dashed var(--ms-line);
            flex-wrap: wrap;
        }
        .rk-playback-summary { font: 600 0.85rem var(--ms-font-sans); color: var(--rk-tool-dark); }
        .rk-playback-step    { font: 0.78rem var(--ms-font-mono); color: var(--ms-muted); margin-left: auto; }

        .rk-banner {
            margin: 0 0 0.75rem;
            padding: 0.55rem 0.85rem;
            font: 0.85rem/1.5 var(--ms-font-sans);
            border-radius: var(--ms-radius-sm);
            border: 1px solid transparent;
        }
        .rk-banner-ok  { background: var(--rk-light);                 color: var(--ms-ink-soft); border-color: rgba(14,116,144,0.25); }
        .rk-banner-bad { background: rgba(239, 68, 68, 0.08);         color: #b91c1c;            border-color: rgba(239,68,68,0.3); }
        .rk-banner-err { background: rgba(239, 68, 68, 0.12);         color: #b91c1c;            border-color: rgba(239,68,68,0.4); }
        .rk-banner-info{ background: rgba(14, 116, 144, 0.12);        color: var(--rk-tool-dark); border-color: rgba(14,116,144,0.4); }

        .rk-moves-list { display: flex; flex-wrap: wrap; gap: 0.3rem; margin: 0.5rem 0 0.85rem; }
        .rk-move {
            padding: 0.3rem 0.6rem;
            font: 600 0.85rem var(--ms-font-mono);
            background: var(--ms-panel-bg-soft);
            border: 1.5px solid var(--ms-line);
            color: var(--ms-ink);
            border-radius: 0.45rem;
            cursor: pointer; min-width: 44px; text-align: center;
            transition: all 0.12s;
        }
        .rk-move:hover { border-color: var(--rk-tool); }
        .rk-move.done    { color: var(--ms-muted); opacity: 0.6; }
        .rk-move.current { background: var(--rk-tool); color: #fff; border-color: var(--rk-tool); }

        .rk-step-controls { display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap; margin-bottom: 0.5rem; }
        .rk-step-status   { color: var(--ms-muted); font: 0.82rem var(--ms-font-sans); flex: 1; min-width: 0; }
        .rk-speed-row     { display: flex; gap: 0.4rem; align-items: center; font: 0.78rem var(--ms-font-sans); color: var(--ms-muted); }
        .rk-speed-btn     { padding: 0.3rem 0.7rem; font: 500 0.75rem var(--ms-font-sans); border: 1.5px solid var(--ms-line); background: var(--ms-panel-bg); color: var(--ms-ink-soft); border-radius: 999px; cursor: pointer; }
        .rk-speed-btn.active { background: var(--rk-tool); color: #fff; border-color: var(--rk-tool); }

        .rk-hint { font: 0.78rem var(--ms-font-sans); color: var(--ms-muted); margin: 0.5rem 0 0; }

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
            background: rgba(14, 116, 144, 0.12);
            color: var(--rk-tool-dark);
            border: 1px solid rgba(14, 116, 144, 0.3);
        }

        /* Twist panel */
        .rk-twist-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0.55rem 1.5rem;
        }
        @media (max-width: 540px) { .rk-twist-grid { grid-template-columns: 1fr; } }
        .rk-twist-row { display: grid; grid-template-columns: 2.25rem repeat(3, minmax(0, 1fr)); gap: 0.4rem; align-items: center; }
        .rk-twist-face {
            font: 700 0.9rem var(--ms-font-mono); color: var(--rk-tool); text-align: center;
            background: var(--rk-light); padding: 0.45rem 0; border-radius: var(--ms-radius-sm);
        }
        .rk-twist-btn {
            padding: 0.5rem 0;
            font: 600 0.85rem var(--ms-font-mono);
            border: 1.5px solid var(--ms-line);
            background: var(--ms-panel-bg); color: var(--ms-ink);
            border-radius: var(--ms-radius-sm);
            cursor: pointer; min-height: 40px;
        }
        .rk-twist-btn:hover:not(:disabled) { border-color: var(--rk-tool); color: var(--rk-tool); background: var(--rk-light); }
        .rk-twist-btn:disabled { opacity: 0.45; cursor: not-allowed; }
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

    <% request.setAttribute("activeService", "pocket-cube"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Pocket Cube (2×2) Solver</span>
            </nav>
            <h1>Free 2×2 Pocket Cube Solver &mdash; Optimal in 11 Moves</h1>
        </header>

        <!-- Toolbar -->
        <div class="rk-card">
            <div class="rk-toolbar">
                <input type="file" id="rk-file-input" accept="image/*" style="display:none;">
                <button type="button" class="rk-btn"        id="rk-upload-btn">Upload net image</button>
                <button type="button" class="rk-btn"        id="rk-scramble-btn">Random scramble</button>
                <button type="button" class="rk-btn"        id="rk-reset-btn">Reset</button>
                <button type="button" class="rk-btn"        id="rk-share-btn">Share</button>
                <button type="button" class="rk-btn rk-btn-primary" id="rk-solve-btn">Solve</button>
            </div>

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
                        title="Undo last manual twist (Ctrl/Cmd-Z)">&#x21B6; Undo</button>
            </div>

            <p class="rk-banner rk-banner-ok" id="rk-validation" role="status" aria-live="polite">
                Valid 2×2 cube state — click any sticker to fix a wrong color.
            </p>
            <p class="rk-banner rk-banner-err" id="rk-parse-error" role="alert" style="display:none;"></p>
            <p class="rk-banner rk-banner-err" id="rk-solve-error" role="alert" style="display:none;"></p>
            <p class="rk-banner rk-banner-info" id="rk-share-feedback" role="status" aria-live="polite" style="display:none;"></p>
        </div>

        <!-- 2D net + 3D cube side by side -->
        <div class="rk-stage" style="margin-top:1.25rem;">
            <div class="rk-card">
                <h2 class="rk-card-title">Cube net &mdash; click a sticker to fix it</h2>
                <div id="rk-net-host" aria-label="Editable cube net"></div>
                <p class="rk-hint">8×6 grid of 24 stickers — 4 per face in the standard cross layout.</p>
            </div>
            <div class="rk-card">
                <h2 class="rk-card-title">3D preview &mdash; drag to orbit</h2>
                <div id="rk-cube3d-host"></div>
            </div>
        </div>

        <!-- Manual twist controls -->
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
            <p class="rk-hint">Click any move to twist the cube. Manual moves clear the active solution &mdash; treat this as a sandbox for learning notation or trying algorithms.</p>
        </div>

        <!-- Solution panel -->
        <div class="rk-card" id="rk-moves-panel" style="margin-top:1.25rem; display:none;">
            <h2 class="rk-card-title" id="rk-moves-header">Solution</h2>
            <div class="rk-moves-list" id="rk-moves-list"></div>
            <%-- Step description (unique to panel; toolbar strip just shows step counter). --%>
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
        </div>

        <div class="ms-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Below-fold explainer -->
        <section class="rk-card" style="margin-top:1.25rem;">
            <h2 class="ms-section-title">How the 2×2 solver works</h2>
            <p style="font:0.95rem/1.65 var(--ms-font-sans); color:var(--ms-ink-soft); margin:0 0 0.85rem;">
                The 2×2 (Pocket Cube) has only <strong>3,674,160 reachable states</strong> — small
                enough to solve from scratch by <strong>bidirectional breadth-first search</strong>
                with no precomputed pruning tables. We BFS forward from the input state and
                backward from the solved state, alternating expansion of the smaller frontier
                until the two meet. With branching factor 6 (after deduping same-face moves),
                each side reaches depth ~6 with about 47,000 states; the meet typically happens
                within 100 milliseconds in pure JavaScript.
            </p>
            <p style="font:0.95rem/1.65 var(--ms-font-sans); color:var(--ms-ink-soft); margin:0 0 0.85rem;">
                Solutions are <strong>guaranteed optimal</strong> — every cube is solved in at
                most 11 moves (God's Number for the 2×2 in face-turn metric, proven 1981).
                For comparison, the 3×3 has 4.3 × 10<sup>19</sup> states and needs the
                Kociemba two-phase algorithm with megabytes of pruning tables; the 2×2 doesn't.
            </p>
        </section>

        <section class="rk-card" style="margin-top:1.25rem;">
            <h2 class="ms-section-title">Frequently asked questions</h2>
            <div class="ms-faq">
                <div class="ms-faq-item">
                    <div class="ms-faq-q">What is God's Number for the 2×2?</div>
                    <div class="ms-faq-a">11 in the face-turn metric — every solvable 2×2 state is reachable from solved in 11 face turns or fewer (Larson et al., 1981). The state space is just 3,674,160 positions, small enough to enumerate exhaustively.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">How does the solver work?</div>
                    <div class="ms-faq-a">Bidirectional BFS — search forward from your scrambled state and backward from solved at the same time, alternating which frontier to expand to keep the meet balanced. With 6 effective moves per state (we skip same-face repeats), each side reaches depth 6 with ~47K states, and the two meet at depth ≤11. No pruning tables needed.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Why doesn't this same solver work for the 3×3?</div>
                    <div class="ms-faq-a">The 3×3 has 4.3 × 10<sup>19</sup> states — bidirectional BFS to depth 10 each side would need petabytes of memory. The 3×3 needs Kociemba's two-phase algorithm with precomputed pruning tables. The 2×2's 3.7 million states fit comfortably in browser memory, so pure BFS is enough.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">What notation does the solver use?</div>
                    <div class="ms-faq-a">Standard cube notation: U / D / L / R / F / B for the six faces. Bare letter = 90° clockwise (looking at face from outside). Apostrophe = counter-clockwise (e.g. R'). 2 = 180° (e.g. F2). Since the 2×2 has no fixed centers, only 3 of the 6 faces are strictly necessary for solving — but all 6 are supported.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Can I solve a 2×2 by hand?</div>
                    <div class="ms-faq-a">Easily — the 2×2 is the easiest puzzle in the Rubik's family. With practice, ~30 seconds intuitive solve with no memorized algorithms. Solve one face first (3-5 moves), then orient and permute the last layer with a small handful of standard moves. The optimal solution this solver shows uses fewer moves but moves that aren't always intuitive.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Do you have a 3×3 cube solver?</div>
                    <div class="ms-faq-a">Yes — try the <a href="<%=request.getContextPath()%>/math/rubiks-cube-solver.jsp" style="color:var(--rk-tool);text-decoration:underline;">Rubik's Cube Solver (3×3)</a>. It uses Kociemba's two-phase algorithm via cubejs, returning solutions in ≤22 moves typically (God's Number for 3×3 = 20). Same 3D animated playback + GIF export + image-net parser.</div>
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
import { bootstrap } from '<%=request.getContextPath()%>/js/rubiks2/app.js?v=<%=v%>';

const $ = (id) => document.getElementById(id);

bootstrap({
    netHost:        $('rk-net-host'),
    cube3dHost:     $('rk-cube3d-host'),
    fileInput:      $('rk-file-input'),
    validationEl:   $('rk-validation'),
    parseErrorEl:   $('rk-parse-error'),
    solveErrorEl:   $('rk-solve-error'),
    shareFeedbackEl:$('rk-share-feedback'),
    solveBtn:       $('rk-solve-btn'),
    movesPanel:     $('rk-moves-panel'),
    movesHeader:    $('rk-moves-header'),
    movesList:      $('rk-moves-list'),
    movesStatus:    $('rk-moves-status'),
    // prevBtn / nextBtn / playBtn omitted — duplicate controls now live only
    // in the toolbar's playback strip.
    speedBtns: {
        slow:   document.querySelector('.rk-speed-btn[data-speed="slow"]'),
        normal: document.querySelector('.rk-speed-btn[data-speed="normal"]'),
        fast:   document.querySelector('.rk-speed-btn[data-speed="fast"]'),
    },
    uploadBtn:   $('rk-upload-btn'),
    scrambleBtn: $('rk-scramble-btn'),
    resetBtn:    $('rk-reset-btn'),
    shareBtn:    $('rk-share-btn'),
    playbackStrip:$('rk-playback-strip'),
    tbSummary:   $('rk-tb-summary'),
    tbStep:      $('rk-tb-step'),
    tbPrevBtn:   $('rk-tb-prev-btn'),
    tbNextBtn:   $('rk-tb-next-btn'),
    tbPlayBtn:   $('rk-tb-play-btn'),
    historyStrip:$('rk-history-strip'),
    historyList: $('rk-history-list'),
    undoBtn:     $('rk-undo-btn'),
    recordBtn:   $('rk-record-btn'),
    recordStatus:$('rk-record-status'),
});
</script>

</body>
</html>
