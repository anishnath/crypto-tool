<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Rubik's Cube Notation, Algorithms &amp; Solving Guide (Visual, Interactive)" />
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

    <%-- Match the solver's accent palette so the embedded fragment looks
         identical whether it's on this standalone page or inside the
         solver page. --%>
    <style>
        :root {
            --rk-tool: #6366f1;
            --rk-tool-dark: #4f46e5;
            --rk-light: rgba(99, 102, 241, 0.08);
        }
        .ms-studio { padding: 1rem; }
        .rk-card {
            background: var(--ms-bg, white);
            border: 1px solid var(--ms-line);
            border-radius: 10px;
            padding: 1rem 1.2rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../navigation.jsp" />

    <main class="ms-studio">
        <section class="rk-card">
            <h1 class="ms-section-title" style="margin:0 0 0.3rem;">Rubik's Cube &mdash; Notation, Algorithms &amp; Solving Guide</h1>
            <p style="color:var(--ms-ink-soft); margin:0 0 1rem;">A visual, click-to-play reference for cubers &mdash; beginners through speedsolvers. Every move and algorithm has a &#9654; button that animates on the live cube.</p>

            <jsp:include page="components/cubing-guide-body.jsp" />
        </section>

        <%-- Visible FAQ — same content as the JSON-LD FAQPage in
             seo-tool-page.jsp.  Single source of truth. --%>
        <jsp:include page="../modern/components/visible-faq.jsp" />
    </main>

    <jsp:include page="../footer_adsense.jsp" />

    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
</body>
</html>
