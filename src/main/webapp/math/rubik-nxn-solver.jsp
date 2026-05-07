<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Rubik N×N Solver — single-page UX for 3×3, 4×4, and 5×5.

        3×3 path: cubejs (Kociemba two-phase) in the browser, ~50 ms.
        4×4 path: full server pipeline (centres → orient → phase3 → phase4
                  → reduce → Kociemba), pure-Java port of the
                  rubikscubennnsolver (Python+C) reference.
        5×5 path: full server pipeline (LR + FB centres → EO → phase4 →
                  phase5 → phase6 → reduce → Kociemba), 8-stage pure-Java
                  port.  Hooked at /CubeSolverFunctionality.

        FE design adapts the reference React app.
    --%>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Rubik's Cube Solver Online — 3x3, 4x4, 5x5, 6x6 and 7x7 (Animated 3D, Step-by-Step)" />
        <jsp:param name="toolCategory" value="Puzzles" />
        <jsp:param name="toolDescription" value="Free online Rubik's Cube solver for 3x3, 4x4, 5x5, 6x6 and 7x7 cubes. Enter your scramble — get a step-by-step solution with animated 3D playback. No signup, no ads in the way, works in any browser. Includes random scrambler, manual twist with WCA notation, and image-upload for net photos." />
        <jsp:param name="toolUrl" value="math/rubik-nxn-solver.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        <jsp:param name="toolKeywords" value="rubiks cube solver, rubik's cube solver, online rubiks cube solver, free rubiks cube solver, 3x3 cube solver, 4x4 cube solver, 5x5 cube solver, 6x6 cube solver, 7x7 cube solver, rubiks revenge solver, professor cube solver, big cube solver, NxN cube solver, animated cube solver, 3d rubiks cube simulator, rubiks cube scrambler, scramble generator, WCA scramble, cube notation, how to solve a rubiks cube, step by step rubiks cube solver, rubiks cube algorithm finder, rubiks cube simulator online, virtual rubiks cube, speedcubing tool, cube reduction method" />
        <jsp:param name="toolImage" value="rubik-cube-solver-og.png" />
        <jsp:param name="toolFeatures" value="Solves 3x3 / 4x4 / 5x5 / 6x6 / 7x7 — one tool every cube,Animated 3D cube — watch each face turn in real time,Step-by-step playback with Prev / Play / Next,Random scramble button (configurable length),Manual twist with full WCA notation (outer / wide / 3-layer),Upload net image — auto-detect colors via CIE Lab calibration,Click stickers to fix mis-detected colors,Pure browser UI — works offline after first load (3x3),Mobile-friendly responsive layout,No signup, no paywall, no algorithm timer overlay" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="teaches" value="Rubik's Cube notation (WCA), reduction method for big cubes, edge orientation, centres staging, Kociemba two-phase algorithm, group theory basics" />
        <jsp:param name="educationalLevel" value="Beginner, Intermediate, Speedcuber" />
        <jsp:param name="howToSteps" value="Pick your cube size|Click 3×3 / 4×4 / 5×5 / 6×6 / 7×7 in the size selector. The 3D cube and net resize instantly.,Enter your scramble|Three options: (a) click Random scramble for a fresh state, (b) click Upload net to detect colors from a photo, or (c) click stickers in Edit mode to set each colour by hand.,Click Solve|For 3×3 the solution is computed in the browser in under 100 ms. For 4×4 / 5×5 / 6×6 / 7×7 it's solved on our server in seconds. The solve splits into stages so you can see what each phase did.,Watch the solution|Press Play to auto-step through the moves with animation, or use Prev / Next to step manually. Click any move chip to jump to that position. ←/→ arrow keys also work.,Save or share|The current state lives in the URL fragment so you can bookmark it. Right-click the 3D cube to capture an image of any step." />
        <jsp:param name="faq1q" value="What's the fastest way to solve a 3x3 Rubik's Cube?" />
        <jsp:param name="faq1a" value="The mathematically fastest solution from any state is at most 20 face turns (God's Number, proved 2010). Speedcubers typically average 50–60 moves with the CFOP method (Cross, F2L, OLL, PLL); world-record averages are sub-5 seconds. This solver returns near-optimal solutions instantly using the Kociemba two-phase algorithm — typically 20–22 moves in standard WCA notation, which is shorter than what most human methods produce." />
        <jsp:param name="faq2q" value="How do you scramble a 4x4 Rubik's Cube (Rubik's Revenge)?" />
        <jsp:param name="faq2a" value="Standard WCA 4x4 scrambles are 40 moves long, mixing outer face turns (R, U, F, etc.) with wide turns (Rw, Uw, Fw). Click Random scramble in this tool — it generates a valid scramble using single and wide turns and animates each move on the 3D cube so you can copy it onto a real cube. Manual twist buttons let you input any WCA scramble character-by-character." />
        <jsp:param name="faq3q" value="Can this solver handle 5x5, 6x6 and 7x7 cubes?" />
        <jsp:param name="faq3a" value="Yes — all four big cubes (5x5 Professor's Cube, 6x6 V-Cube, 7x7 V-Cube) are fully supported. Big cubes use the reduction method: solve all face centres → pair the edge cubies → finish like a 3x3 with Kociemba. Solve times scale with size: 5x5 is usually a few seconds, 6x6 takes 5–30 seconds, 7x7 can take longer for hard scrambles." />
        <jsp:param name="faq4q" value="What does WCA notation mean (R, R', R2, Rw, 3Rw)?" />
        <jsp:param name="faq4a" value="WCA = World Cube Association — the official notation used in competitions. R = right face 90° clockwise (looking at it from outside). R' (R-prime) = 90° counter-clockwise. R2 = 180°. Rw = wide R = rotate the right face PLUS the slice next to it (2 layers); only on 4x4 and bigger. 3Rw = 3-layer wide right turn; only on 6x6 and bigger. Same pattern for U (Up), L (Left), D (Down), F (Front), B (Back)." />
        <jsp:param name="faq5q" value="Is there a way to upload a photo of my cube and have it solved?" />
        <jsp:param name="faq5a" value="Yes. Click Upload net and pick a flat unfolded-net image of your cube (the standard cross layout: U on top, then L F R B in a row, D on the bottom). The image parser auto-crops, samples each sticker's colour in CIE Lab space, and calibrates against the 6 face centres to handle palette drift. Misread stickers can be fixed with one click in Edit mode." />
        <jsp:param name="faq6q" value="Does this work on a phone or only on desktop?" />
        <jsp:param name="faq6a" value="Both. The 3D cube uses Three.js / WebGL which runs on every modern phone browser. The toolbar collapses to a single column on narrow screens. Drag with one finger to orbit the cube, pinch to zoom. Move-step playback and manual twist buttons work the same as desktop." />
        <jsp:param name="faq7q" value="Do I need to install anything? Is it really free?" />
        <jsp:param name="faq7a" value="No install — runs in any modern browser (Chrome, Firefox, Safari, Edge). Yes really free, no signup, no email required. The 3x3 solver runs entirely in your browser (your scramble never leaves your device). Bigger cubes (4x4 through 7x7) send the cube state to our server for solving and return the move list — no personal data, no tracking beyond standard analytics." />
        <jsp:param name="faq8q" value="Can I share or save a specific scramble?" />
        <jsp:param name="faq8a" value="Yes — the cube state is encoded in the URL after the # symbol. Bookmark or share that URL to reproduce the exact scramble. The fragment never leaves your browser (HTTP convention) so it's safe for tournament-prep scrambles you don't want logged." />
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
        .rk-toolbar > .rk-status {
            margin-left: auto;
            min-width: 0;
            max-width: 100%;
        }
        /* On narrow viewports, push the status pill to its own row so it
           never overlaps the action buttons.  flex-basis:100% forces a
           wrap; order:99 puts it last in the wrap order. */
        @media (max-width: 900px) {
            .rk-toolbar > .rk-status {
                margin-left: 0;
                flex-basis: 100%;
                order: 99;
                text-align: center;
            }
        }

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

        /* Subtle dark tooltip — appears BELOW the button on hover.
           Hidden VERY firmly by default (visibility + opacity + clip)
           so no CSS leakage from the parent stylesheet can ever leave
           the text visible on the page. */
        .rk-btn-icon .rk-label {
            position: absolute;
            top: calc(100% + 6px);
            left: 50%;
            transform: translateX(-50%);
            padding: 0.25rem 0.5rem;
            font: 500 0.7rem var(--ms-font-sans);
            background: rgba(15, 23, 42, 0.96);
            color: #fff;
            border-radius: 4px;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            pointer-events: none;
            transition: opacity 0.1s, visibility 0s 0.1s;
            z-index: 100;
            letter-spacing: 0.005em;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.18);
        }
        .rk-btn-icon:hover .rk-label,
        .rk-btn-icon:focus-visible .rk-label {
            opacity: 1;
            visibility: visible;
            transition: opacity 0.1s, visibility 0s;
        }
        /* Hovered button itself rises so its tooltip sits above neighbours. */
        .rk-btn-icon:hover, .rk-btn-icon:focus-visible { z-index: 100; }
        /* On touch devices (no hover), disable the JS tooltip entirely
           and rely on the native `title` attribute instead — touch users
           get no hover state, so a "stuck open" tooltip is the failure
           mode we're guarding against. */
        @media (hover: none) {
            .rk-btn-icon .rk-label { display: none !important; }
        }

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

        /* ── Scramble input row ────────────────────────────────────── */
        .rk-scramble-row {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0.85rem 0 0.65rem;
        }
        .rk-scramble-label {
            font: 600 0.78rem var(--ms-font-sans);
            color: var(--ms-muted);
            white-space: nowrap;
            flex-shrink: 0;
        }
        .rk-scramble-input {
            flex: 1;
            min-width: 0;
            height: 34px;
            padding: 0 0.7rem;
            font: 500 0.82rem var(--ms-font-mono);
            color: var(--ms-ink);
            background: var(--ms-panel-bg);
            border: 1px solid var(--ms-line);
            border-radius: 7px;
            transition: border-color 0.12s, box-shadow 0.12s;
        }
        .rk-scramble-input:focus {
            outline: none;
            border-color: var(--rk-tool);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
        }
        .rk-scramble-input.invalid {
            border-color: #dc2626;
            background: rgba(239, 68, 68, 0.04);
        }
        @media (max-width: 640px) {
            .rk-scramble-row { flex-wrap: wrap; }
            .rk-scramble-label { flex-basis: 100%; }
        }

        /* ── Notation explainer (shown above playback strip) ──────── */
        .rk-notation-line {
            font: 600 0.85rem var(--ms-font-sans);
            color: var(--ms-ink);
            margin: 0 0 0.6rem;
            padding: 0.5rem 0.75rem;
            background: var(--rk-light);
            border-left: 3px solid var(--rk-tool);
            border-radius: 0 var(--ms-radius-sm) var(--ms-radius-sm) 0;
            display: none;
        }
        .rk-notation-line.active { display: block; }
        .rk-notation-line code {
            font: 700 0.95rem var(--ms-font-mono);
            color: var(--rk-tool-dark);
            padding: 0.05rem 0.4rem;
            background: var(--ms-panel-bg);
            border-radius: 4px;
            margin: 0 0.3rem;
        }
        .rk-notation-line .rk-notation-desc { color: var(--ms-ink-soft); font-weight: 500; }

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
            grid-template-columns: repeat(auto-fit, minmax(min(100%, 360px), 1fr));
            gap: 0.5rem 1.25rem;
            box-sizing: border-box;
            max-width: 100%;
        }
        /* Per-face row: face-label | 3 outer | sep | 3 wide(2L) | sep | 3 wide(3L) */
        .rk-twist-row {
            display: grid;
            grid-template-columns:
                1.4rem
                repeat(3, minmax(0, 1fr))
                0.4rem
                repeat(3, minmax(0, 1fr))
                0.4rem
                repeat(3, minmax(0, 1fr));
            gap: 0.25rem;
            align-items: center;
            min-width: 0;
        }
        .rk-twist-sep {
            width: 1px;
            height: 65%;
            background: var(--ms-line);
            justify-self: center;
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
        .rk-twist-btn.wide {
            background: var(--ms-panel-bg-soft);
            color: var(--ms-ink-soft);
            font-weight: 500;
        }
        .rk-twist-btn.wide3 {
            background: rgba(99, 102, 241, 0.06);
            color: var(--ms-ink-soft);
            font-weight: 500;
            font-size: 0.72rem;     /* "3Uw2" is wider than "Uw2" */
        }
        .rk-twist-btn:disabled {
            opacity: 0.35;
            cursor: not-allowed;
        }
        .rk-twist-btn:disabled:hover {
            background: var(--ms-panel-bg-soft);
            color: var(--ms-ink-soft);
            border-color: var(--ms-line);
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
            <h1>Rubik N&times;N Solver &mdash; 3&times;3, 4&times;4, 5&times;5, 6&times;6 and 7&times;7</h1>
        </header>

        <div class="rk-card">
            <div class="rk-toolbar">
                <div class="rk-segment rk-size-group" role="tablist" aria-label="Cube size">
                    <button type="button" class="rk-size-btn active" data-size="3" role="tab" aria-selected="true">3&times;3</button>
                    <button type="button" class="rk-size-btn"        data-size="4" role="tab" aria-selected="false">4&times;4</button>
                    <button type="button" class="rk-size-btn"        data-size="5" role="tab" aria-selected="false">5&times;5</button>
                    <button type="button" class="rk-size-btn"        data-size="6" role="tab" aria-selected="false">6&times;6</button>
                    <button type="button" class="rk-size-btn"        data-size="7" role="tab" aria-selected="false">7&times;7</button>
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

            <%-- Scramble / state input — accepts WCA notation OR a full
                 sticker-state string.  Auto-detects which one and
                 auto-switches cube size to match. --%>
            <div class="rk-scramble-row">
                <label for="rk-scramble-input" class="rk-scramble-label">Paste scramble or state</label>
                <input type="text" id="rk-scramble-input" class="rk-scramble-input"
                       placeholder="WCA notation (R U' L2 ...) or sticker state (URFDLB chars, 54/96/150/216/294 long)"
                       autocomplete="off" spellcheck="false" />
                <button type="button" class="rk-btn" id="rk-scramble-apply">
                    <svg class="rk-ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="5 13 9 17 19 7"/></svg>
                    Apply
                </button>
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
                        <button type="button" class="rk-twist-btn"        data-move="<%=f%>"    title="<%=f%>"><%=f%></button>
                        <button type="button" class="rk-twist-btn"        data-move="<%=f%>'"   title="<%=f%>'"><%=f%>'</button>
                        <button type="button" class="rk-twist-btn"        data-move="<%=f%>2"   title="<%=f%>2"><%=f%>2</button>
                        <span class="rk-twist-sep" aria-hidden="true"></span>
                        <button type="button" class="rk-twist-btn wide"   data-move="<%=f%>w"   data-wide="1" title="<%=f%>w &mdash; 2 layers"><%=f%>w</button>
                        <button type="button" class="rk-twist-btn wide"   data-move="<%=f%>w'"  data-wide="1" title="<%=f%>w'"><%=f%>w'</button>
                        <button type="button" class="rk-twist-btn wide"   data-move="<%=f%>w2"  data-wide="1" title="<%=f%>w2"><%=f%>w2</button>
                        <span class="rk-twist-sep" aria-hidden="true"></span>
                        <button type="button" class="rk-twist-btn wide3"  data-move="3<%=f%>w"  data-wide3="1" title="3<%=f%>w &mdash; 3 layers (6&times;6+)">3<%=f%>w</button>
                        <button type="button" class="rk-twist-btn wide3"  data-move="3<%=f%>w'" data-wide3="1" title="3<%=f%>w'">3<%=f%>w'</button>
                        <button type="button" class="rk-twist-btn wide3"  data-move="3<%=f%>w2" data-wide3="1" title="3<%=f%>w2">3<%=f%>w2</button>
                    </div>
                    <% } %>
                </div>
                <p class="rk-hint">
                    Standard WCA notation.
                    <strong>Outer</strong> (left, dark) — single layer, every size.
                    <strong>Wide</strong> (middle, lighter — <code>Uw</code>) — 2 layers, 4&times;4+.
                    <strong>3-layer wide</strong> (right, tinted — <code>3Uw</code>) — 3 layers, 6&times;6+ only.
                    Buttons not applicable to the current size are greyed out.
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

            <%-- Notation explainer — shows current move + plain-English description.
                 Becomes visible (.active) as soon as a step is played; great for
                 cubers still learning WCA notation. --%>
            <p class="rk-notation-line" id="rk-notation-line" aria-live="polite"></p>

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
            <p style="font:0.95rem/1.65 var(--ms-font-sans); color:var(--ms-ink-soft); margin:0 0 0.85rem;">
                <strong>5&times;5</strong> (Professor's Cube) extends the reduction
                method into <strong>8 stages</strong>:
                LR-centres staging &rarr;
                FB-centres staging &rarr;
                edge orientation (24 wings + 12 midges) &rarr;
                phase&nbsp;4 (stage 4 chosen edges) &rarr;
                phase&nbsp;5 (pair the 4 edges + LFRB centres) &rarr;
                phase&nbsp;6 (last 8 edges + all centres) &rarr;
                reduce to 3&times;3 &rarr; Kociemba. Each phase combines multiple
                pruning tables under IDA*&nbsp;with a max-cost heuristic; the largest
                table (phase&nbsp;4) is 184&nbsp;MB compressed and accessed via
                mmap'd binary search to keep RSS small. The whole pipeline is
                pure&nbsp;Java &mdash; no Python or C runtime on the server.
            </p>
        </section>

        <section class="rk-card" style="margin-top:1.25rem;">
            <h2 class="ms-section-title">Frequently asked questions</h2>
            <div class="ms-faq">
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Why do 4&times;4 and 5&times;5 run on the server?</div>
                    <div class="ms-faq-a">Their reduction-method pipelines depend on hundreds of MB of pre-computed pruning tables that we don't want every visitor to download. The Java implementation memory-maps the tables and runs IDA* over byte arrays &mdash; well under a second per stage on warm tables for 4&times;4; a few seconds per stage on 5&times;5.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">What notation does the solver use?</div>
                    <div class="ms-faq-a">Standard WCA notation: U / D / L / R / F / B for outer faces; <code>Uw</code> / <code>Rw</code> / etc. for wide turns (used on 4&times;4 and 5&times;5). A bare letter is 90&deg; CW; <code>'</code> is CCW; <code>2</code> is 180&deg;.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">How long does a 5&times;5 solve take?</div>
                    <div class="ms-faq-a">First request after server startup downloads ~2&nbsp;GB of lookup tables and warms the JVM (one-time cost). After that, easy scrambles solve in seconds; harder ones (longer scramble or unfortunate wing-string choice) can take 30&ndash;60&nbsp;seconds. Solutions are typically 80&ndash;120 total moves across all 8 stages plus the final 3&times;3.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Do you have a 2&times;2 solver?</div>
                    <div class="ms-faq-a">Yes &mdash; the <a href="<%=request.getContextPath()%>/math/pocket-cube-solver.jsp" style="color:var(--rk-tool);text-decoration:underline;">2&times;2 Pocket Cube Solver</a> uses bidirectional BFS for provably optimal solutions in &le;11 moves.</div>
                </div>
                <div class="ms-faq-item">
                    <div class="ms-faq-q">Are 6&times;6 and 7&times;7 supported?</div>
                    <div class="ms-faq-a">Yes &mdash; both are now supported via the upstream Rubik solver service. The browser handles state, validation, scrambling, manual twists and the 3D animation; solving is forwarded to the server. Solve times scale with cube size: 6&times;6 typically takes 5&ndash;30&nbsp;seconds; 7&times;7 can take longer.</div>
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
    notationLine:   $('rk-notation-line'),
    scrambleInput:  $('rk-scramble-input'),
    scrambleApply:  $('rk-scramble-apply'),
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
