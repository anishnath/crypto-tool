<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Rubik's Cube Notation, Algorithms & Solving Guide (Visual, Interactive)" />
        <jsp:param name="toolCategory" value="Puzzles" />
        <jsp:param name="toolDescription" value="A visual, interactive cubing reference: WCA notation cheat sheet with click-to-play moves, beginner LBL walkthrough, CFOP overview, big-cube reduction + parity, an algorithm library (sexy, sune, T-perm, J-perm, Y-perm, …) with cube-net diagrams, and a glossary of cubing terms (BLD, OH, COLL, ZBLL, FMC, sub-X, AO5, …)." />
        <jsp:param name="toolUrl" value="math/cubing-guide.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        <jsp:param name="toolKeywords" value="rubiks cube notation, WCA notation, cube algorithms, sexy move, sune, T perm, Y perm, J perm, OLL algorithms, PLL algorithms, F2L cases, beginner method, layer by layer, CFOP method, Fridrich method, 4x4 parity, OLL parity, PLL parity, reduction method, big cube tutorial, cubing glossary, BLD, OH, AO5, sub-20, color scheme, Western BOY, cubejs notation, 3x3 cube guide, 4x4 cube guide" />
        <jsp:param name="toolImage" value="cubing-guide-og.png" />
        <jsp:param name="toolFeatures" value="Notation cheat sheet — every WCA move with one-line meaning,Click any move to see it animated on a live 3D cube,Beginner LBL — 7 stages with goal states + algorithms,CFOP overview — Cross / F2L / OLL / PLL explained,Big cube reduction method — centres / edge pairing / parity,Algorithm library — sexy / sune / T-perm / Y-perm / J-perm with cube nets,Glossary — BLD OH FMC COLL ZBLL sub-X explained,Color schemes — Western Japanese Stickerless layouts,Static cube nets generated client-side from algorithm strings,No signup, works offline after first load" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="teaches" value="Rubik's cube notation (WCA), beginner LBL method, CFOP method, F2L principles, OLL, PLL, big-cube reduction, parity algs, cubing terminology" />
        <jsp:param name="educationalLevel" value="Beginner, Intermediate, Speedcuber" />
        <jsp:param name="howToSteps" value="Open the Notation tab|Browse all WCA moves with plain-English meanings — face turns, wide turns, inner slices, middle slices, cube rotations.,Click any ▶ button|Each move and algorithm has a play button that animates on the live 3D cube — see exactly what happens.,Pick the tab for your level|Beginner — start with the LBL tab. Improving — read the CFOP tab. Bigger cube — Big Cube tab covers reduction + parity.,Use the algorithm library|Search by name or filter by tag (PLL OLL F2L beginner trigger). Each card shows the cube net AFTER the alg is applied, so you can recognise the case visually.,Bookmark deep links|Each tab + each move has its own URL fragment — link directly to a specific case from your notes." />
        <jsp:param name="faq1q" value="What's the easiest way to learn Rubik's cube notation?" />
        <jsp:param name="faq1a" value="Start with the 6 face turns (R U F D L B) and 3 modifiers (R = clockwise, R' = counter-clockwise, R2 = 180°). That covers everything you need for a 3×3 with the beginner method. Wide turns (Rw) and big-cube notation (3Rw, 2R, x y z) come later when you move past 3×3. The Notation tab on this page lists every notation form with a click-to-animate button so you can see exactly what each one does." />
        <jsp:param name="faq2q" value="What does sexy move (R U R' U') do?" />
        <jsp:param name="faq2a" value="The 'sexy move' is a 4-move trigger that cycles 3 corners and 3 edges of the cube. It's the building block of dozens of algorithms (most of OLL, several PLLs, F2L cases). Memorise it as a single chunk — the pattern is easy: R, then U, then prime each in reverse order. Once you can do it without looking at your fingers, recognising algorithms gets dramatically easier." />
        <jsp:param name="faq3q" value="What's the difference between OLL and PLL?" />
        <jsp:param name="faq3a" value="In CFOP (the most common speedsolving method), the last layer is solved in 2 stages. OLL = Orient Last Layer = make the top sticker of every last-layer piece match the top colour (typically yellow). PLL = Permute Last Layer = move those pieces to their correct positions. Beginners learn 2-look OLL (10 algs) and 2-look PLL (6 algs) — 16 algs total — which gets you sub-30. Full OLL (57) + full PLL (21) is the next milestone for sub-20." />
        <jsp:param name="faq4q" value="Why does my 4×4 end up with a flipped edge or two swapped edges?" />
        <jsp:param name="faq4a" value="That's parity — a state that's mathematically possible on a 4×4 but impossible on a 3×3. It happens because edge-pairing during reduction can leave one pair with reversed orientation. There are two cases: OLL parity (single flipped edge — fix with Rw U2 Rw U2 Rw U2 Rw U2 Rw U2 Rw) and PLL parity (two edges swapped — fix with 2R2 U2 2R2 Uw2 2R2 Uw2). The Big Cube tab walks through both with diagrams." />
        <jsp:param name="faq5q" value="What's the BOY color scheme?" />
        <jsp:param name="faq5a" value="BOY = Blue, Orange, Yellow appear in clockwise order around one corner of the cube. It's the dominant Western color scheme: White on top, Yellow on bottom, Green front, Blue back, Red right, Orange left. Almost every speedcube ships with this layout. The older Japanese scheme has Blue on the bottom instead. The Glossary tab on this page shows all three common schemes with swatches." />
        <jsp:param name="faq6q" value="What does sub-20 / sub-15 / sub-X mean?" />
        <jsp:param name="faq6a" value="It means averaging UNDER X seconds across multiple solves. Sub-20 = average under 20 seconds, sub-15 = under 15, etc. The standard WCA average is 'AO5' (average of 5 — drop the best and worst, mean of the middle 3). 'PB' means personal best (single solve). World-class times are sub-7 (averaging under 7 seconds), with the world record single under 4 seconds." />
    </jsp:include>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://esm.sh">
    <link rel="dns-prefetch" href="https://unpkg.com">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <%-- three.js importmap (cube-3d-nxn.js needs it for the live demo cube) --%>
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
            --cg-tool: #6366f1;
            --cg-tool-dark: #4f46e5;
            --cg-accent: #fff200;
        }
        .cg-page {
            max-width: 1200px;
            margin: 1.5rem auto;
            padding: 0 1rem;
            font: 0.92rem/1.5 var(--ms-font-sans);
            color: var(--ms-text);
        }
        .cg-h1 {
            font: 700 1.6rem/1.2 var(--ms-font-sans);
            margin: 0 0 0.4rem;
        }
        .cg-sub {
            color: var(--ms-muted);
            margin: 0 0 1.4rem;
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
            margin-bottom: 1rem;
        }
        .cg-tab {
            background: transparent;
            border: 0;
            padding: 0.55rem 0.95rem;
            font: 600 0.85rem var(--ms-font-sans);
            color: var(--ms-muted);
            cursor: pointer;
            border-bottom: 2px solid transparent;
            margin-bottom: -2px;
            border-radius: 5px 5px 0 0;
            transition: color 120ms, background 120ms, border-color 120ms;
        }
        .cg-tab:hover { color: var(--ms-text); background: var(--ms-surface); }
        .cg-tab.active {
            color: var(--cg-tool);
            border-bottom-color: var(--cg-tool);
            background: rgba(99,102,241,0.06);
        }

        /* ── live cube card (sticky on the right) ──────────────────── */
        .cg-live-cube-card {
            position: sticky;
            top: 1rem;
            background: var(--ms-surface);
            border: 1px solid var(--ms-line);
            border-radius: 8px;
            padding: 0.85rem;
        }
        .cg-live-cube-title {
            font: 700 0.85rem var(--ms-font-sans);
            margin: 0 0 0.55rem;
            color: var(--ms-muted);
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
        #cg-live-cube-host {
            width: 100%;
            height: 280px;
            background: rgba(0,0,0,0.02);
            border-radius: 6px;
        }
        .cg-live-cube-help {
            font-size: 0.78rem;
            color: var(--ms-muted);
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
        .cg-chip:hover { background: var(--ms-surface); }
        .cg-chip.active {
            background: var(--cg-tool);
            color: white;
            border-color: var(--cg-tool);
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
            background: var(--ms-surface);
            font-weight: 700;
            font-size: 0.74rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--ms-muted);
        }
        .cg-move code {
            font: 700 0.95rem var(--ms-font-mono);
            color: var(--cg-tool);
            background: var(--cg-tool, rgba(99,102,241,0.1));
            background: rgba(99,102,241,0.1);
            padding: 0.1rem 0.35rem;
            border-radius: 4px;
        }
        .cg-alias {
            font-size: 0.72rem;
            color: var(--ms-muted);
            margin-left: 0.35rem;
        }
        .cg-meaning { max-width: 360px; }
        .cg-sizes {
            font: 600 0.8rem var(--ms-font-mono);
            color: var(--ms-muted);
        }
        .cg-net-cell { width: 84px; }
        .cg-net-svg { display: block; max-width: 90px; }
        .cg-net-skip {
            font-style: italic;
            color: var(--ms-muted);
            font-size: 0.78rem;
        }

        /* ── play button ───────────────────────────────────────────── */
        .cg-play-btn {
            background: var(--cg-tool);
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
        .cg-play-btn:hover { background: var(--cg-tool-dark); transform: scale(1.06); }
        .cg-play-btn-lg { width: 34px; height: 34px; font-size: 0.9rem; }

        /* ── stage cards (LBL / CFOP / big cube) ───────────────────── */
        .cg-stage-card {
            background: var(--ms-surface);
            border: 1px solid var(--ms-line);
            border-left: 3px solid var(--cg-tool);
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
            background: var(--ms-bg);
            border: 1px solid var(--ms-line);
            border-radius: 5px;
            flex-wrap: wrap;
        }
        .cg-stage-alg-name { font-weight: 600; font-size: 0.84rem; }
        .cg-stage-alg code {
            font: 0.84rem var(--ms-font-mono);
            color: var(--cg-tool-dark);
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
            background: var(--ms-bg);
            color: var(--ms-text);
        }
        .cg-search:focus {
            outline: 2px solid var(--cg-tool);
            outline-offset: 1px;
        }
        .cg-alg-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 0.85rem;
            margin-top: 0.85rem;
        }
        .cg-alg-card {
            background: var(--ms-surface);
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
            background: var(--ms-bg);
            padding: 0.4rem 0.55rem;
            border-radius: 5px;
            border: 1px solid var(--ms-line);
            color: var(--cg-tool-dark);
            word-break: break-all;
        }
        .cg-alg-purpose { font-size: 0.82rem; color: var(--ms-muted); margin: 0; }
        .cg-alg-tags { display: flex; flex-wrap: wrap; gap: 0.25rem; }
        .cg-tag {
            background: var(--ms-bg);
            border: 1px solid var(--ms-line);
            color: var(--ms-muted);
            font: 600 0.7rem var(--ms-font-sans);
            padding: 0.15rem 0.45rem;
            border-radius: 999px;
        }
        .cg-empty { color: var(--ms-muted); padding: 1rem; text-align: center; }

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
            background: var(--ms-surface);
            border: 1px solid var(--ms-line);
            border-radius: 6px;
            padding: 0.85rem;
        }
        .cg-scheme-card h4 {
            margin: 0 0 0.4rem;
            font: 700 0.95rem var(--ms-font-sans);
        }
        .cg-scheme-common { margin: 0 0 0.55rem; font-size: 0.82rem; color: var(--ms-muted); }
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
            color: var(--cg-tool);
            margin-top: 0.4rem;
        }
        .cg-glossary dd {
            margin: 0 0 0.4rem;
            font-size: 0.84rem;
            color: var(--ms-text);
        }
        .cg-sources { font-size: 0.86rem; padding-left: 1.2rem; }
        .cg-sources li { margin-bottom: 0.2rem; }
        .cg-sources a { color: var(--cg-tool); text-decoration: none; }
        .cg-sources a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <jsp:include page="../navigation.jsp" />

    <main class="cg-page">
        <h1 class="cg-h1">Rubik's Cube — Notation, Algorithms &amp; Solving Guide</h1>
        <p class="cg-sub">A visual, click-to-play reference for cubers — beginners through speedsolvers. Every move and algorithm has a ▶ button that animates on the live cube.</p>

        <%-- ── tab navigation ───────────────────────────────────── --%>
        <div class="cg-tabs" role="tablist">
            <button class="cg-tab" role="tab" data-tab="notation">Notation</button>
            <button class="cg-tab" role="tab" data-tab="beginner">Beginner (LBL)</button>
            <button class="cg-tab" role="tab" data-tab="cfop">Speedcubing (CFOP)</button>
            <button class="cg-tab" role="tab" data-tab="bigcube">Big Cubes (4×4+)</button>
            <button class="cg-tab" role="tab" data-tab="algs">Algorithm Library</button>
            <button class="cg-tab" role="tab" data-tab="glossary">Glossary &amp; Schemes</button>
        </div>

        <%-- ── 2-column layout: tab content + sticky live cube ──── --%>
        <div class="cg-layout">
            <div>
                <section class="cg-tab-panel" data-tab="notation"  role="tabpanel" id="cg-tab-notation"></section>
                <section class="cg-tab-panel" data-tab="beginner"  role="tabpanel" id="cg-tab-beginner" style="display:none;"></section>
                <section class="cg-tab-panel" data-tab="cfop"      role="tabpanel" id="cg-tab-cfop" style="display:none;"></section>
                <section class="cg-tab-panel" data-tab="bigcube"   role="tabpanel" id="cg-tab-bigcube" style="display:none;"></section>
                <section class="cg-tab-panel" data-tab="algs"      role="tabpanel" id="cg-tab-algs" style="display:none;"></section>
                <section class="cg-tab-panel" data-tab="glossary"  role="tabpanel" id="cg-tab-glossary" style="display:none;"></section>
            </div>

            <aside class="cg-live-cube-card" id="cg-live-cube-card">
                <div class="cg-live-cube-title">Live cube</div>
                <div id="cg-live-cube-host"></div>
                <div class="cg-live-cube-help">
                    Click any ▶ button on the left to play that move or algorithm here.
                    Drag a sticker to twist a face. Drag empty space to orbit.
                </div>
            </aside>
        </div>
    </main>

    <jsp:include page="../footer_adsense.jsp" />

    <script type="module" src="<%=request.getContextPath()%>/js/cubing-guide/app.js?v=<%=v%>"></script>
</body>
</html>
