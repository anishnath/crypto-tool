<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root{--fib-primary:#d97706;--fib-primary-dark:#b45309;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
    </style>

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Fibonacci Spiral Generator Free Online - Golden Spiral" />
        <jsp:param name="toolDescription" value="Free Fibonacci spiral &amp; golden spiral generator: Fibonacci sequence on squares, φ ratio readout, colors, PNG export. Visual canvas tool in your browser." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="fibonacci-spiral.jsp" />
        <jsp:param name="toolKeywords" value="fibonacci spiral generator, golden spiral generator, fibonacci spiral calculator, fibonacci spiral ascii art, fibonacci spiral ascii, fibonacci sequence spiral, fibonacci spiral numbers, fibonacci spiral, fibonacci spiral online, golden ratio spiral, phi spiral, fibonacci tiling, fibonacci sequence visualization, golden spiral approximation, fibonacci squares spiral, F(n) calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Fibonacci spiral &amp; golden spiral preview,F(n) calculator &amp; sequence list,ASCII art copy,Phi ratio readout,Fibonacci numbers per square,PNG export,No registration" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a Fibonacci spiral?" />
        <jsp:param name="faq1a" value="It is a spiral formed by connecting quarter-circle arcs in squares whose side lengths follow the Fibonacci sequence (1, 1, 2, 3, 5, …). It approximates a golden (logarithmic) spiral as you add more squares." />
        <jsp:param name="faq2q" value="Is this a golden spiral generator?" />
        <jsp:param name="faq2a" value="Yes in the usual sense: the Fibonacci spiral built from quarter circles in Fibonacci squares closely approximates the golden spiral. The tool draws that classic Fibonacci spiral and shows how ratios of consecutive Fibonacci numbers approach φ (about 1.618)." />
        <jsp:param name="faq3q" value="Does it work as a Fibonacci spiral calculator?" />
        <jsp:param name="faq3a" value="Yes: enter n to get F(n) with exact integers (BigInt), copy the value, and generate comma-separated lists of the first n terms. The canvas also labels each square and shows F_last/F_{last-1} approaching φ." />
        <jsp:param name="faq4q" value="Is there Fibonacci spiral ASCII art?" />
        <jsp:param name="faq4a" value="Yes: the ASCII preview matches the same tiling and spiral in monospace text (digits in squares, asterisks on the spiral). Copy it for terminals, docs, or social posts. For high-resolution art, use PNG export." />
        <jsp:param name="faq5q" value="How is the spiral drawn?" />
        <jsp:param name="faq5a" value="Squares are placed in the standard Fibonacci tiling pattern. Each arc is a quarter circle with radius equal to the square side; the center is the square corner closest to the spiral pole (the corner shared by the first two 1×1 squares), so the arc stays inside the square and meets the next arc smoothly." />
    </jsp:include>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        :root {
            --fib-tool-primary: #d97706;
            --fib-tool-primary-dark: #b45309;
            --fib-tool-gradient: linear-gradient(135deg, #f59e0b 0%, #b45309 100%);
            --fib-tool-light: #fffbeb;
        }
        [data-theme="dark"] {
            --fib-tool-gradient: linear-gradient(135deg, #fbbf24 0%, #d97706 100%);
            --fib-tool-light: rgba(245, 158, 11, 0.12);
        }
        .fib-canvas-wrap {
            position: relative;
            width: 100%;
            border-radius: 12px;
            overflow: hidden;
            background: var(--bg-secondary, #f8fafc);
            border: 1px solid var(--border, #e2e8f0);
            cursor: grab;
            touch-action: none;
        }
        .fib-canvas-wrap.fib-panning {
            cursor: grabbing;
        }
        .fib-canvas-wrap canvas {
            display: block;
            width: 100%;
            height: auto;
            vertical-align: middle;
        }
        .fib-legend {
            font-size: 0.8125rem;
            color: var(--text-secondary, #475569);
            margin-top: 0.75rem;
            line-height: 1.5;
        }
        .fib-edu {
            max-width: 1600px;
            margin: 0 auto;
            padding: 0 1.5rem 2rem;
        }
        .fib-edu-card {
            background: var(--bg-primary, #fff);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 12px;
            padding: 1.25rem 1.5rem;
        }
        [data-theme="dark"] .fib-edu-card {
            background: #1e293b;
            border-color: #334155;
        }
        .fib-edu-card h2 {
            font-size: 1.125rem;
            margin-bottom: 0.75rem;
            color: var(--text-primary, #0f172a);
        }
        .fib-edu-card p, .fib-edu-card li {
            font-size: 0.9375rem;
            color: var(--text-secondary, #475569);
            margin-bottom: 0.5rem;
        }
        .fib-edu-card ul {
            margin: 0.5rem 0 0 1.25rem;
        }
        .tool-mobile-ad-container { max-width: 1600px; margin: 0 auto; padding: 0 1.5rem 1rem; }
        @media (min-width: 1200px) { .tool-mobile-ad-container { display: none; } }
        .fib-ascii-pre {
            font-family: ui-monospace, Menlo, Consolas, monospace;
            font-size: 0.625rem;
            line-height: 1;
            letter-spacing: 0;
            margin-top: 0.75rem;
            padding: 0.75rem;
            background: var(--bg-secondary, #f1f5f9);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 8px;
            overflow: auto;
            max-height: 240px;
            white-space: pre;
            color: var(--text-primary, #0f172a);
        }
        [data-theme="dark"] .fib-ascii-pre {
            background: #0f172a;
            border-color: #334155;
            color: #e2e8f0;
        }
        .fib-calc-result {
            font-size: 0.875rem;
            margin-top: 0.5rem;
            padding: 0.5rem 0.65rem;
            background: var(--bg-secondary, #f8fafc);
            border-radius: 8px;
            border: 1px solid var(--border, #e2e8f0);
            word-break: break-all;
            font-variant-numeric: tabular-nums;
        }
        [data-theme="dark"] .fib-calc-result { background: #1e293b; border-color: #334155; }

        /* Narrower sidebar, wider preview — scoped to this tool only */
        .fib-tool-page.tool-page-container {
            grid-template-columns: minmax(228px, 292px) minmax(0, 1fr) minmax(232px, 280px);
            gap: 1rem;
            padding: 1rem 1.25rem;
        }
        @media (max-width: 1199px) {
            .fib-tool-page.tool-page-container {
                grid-template-columns: minmax(220px, 300px) minmax(0, 1fr);
            }
        }
        .fib-tool-page .tool-input-column {
            top: 80px;
            max-height: calc(100vh - 96px);
        }
        .fib-tool-page .fib-input-card .tool-card-body.fib-compact {
            padding: 0.65rem 0.75rem;
        }
        .fib-tool-page .fib-input-card .tool-form-group {
            margin-bottom: 0.6rem;
        }
        .fib-tool-page .fib-input-card .tool-form-label {
            font-size: 0.8125rem;
            margin-bottom: 0.25rem;
        }
        .fib-tool-page .fib-check-row {
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
        }
        .fib-tool-page .fib-check-row label {
            margin-top: 0 !important;
        }
        .fib-tool-page details.fib-disclosure {
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 8px;
            margin-top: 0.5rem;
            background: var(--bg-primary, #fff);
        }
        [data-theme="dark"] .fib-tool-page details.fib-disclosure {
            background: #1e293b;
            border-color: #334155;
        }
        .fib-tool-page details.fib-disclosure > summary {
            cursor: pointer;
            padding: 0.45rem 0.6rem;
            font-weight: 600;
            font-size: 0.8125rem;
            list-style: none;
            user-select: none;
            color: var(--text-primary, #0f172a);
        }
        .fib-tool-page details.fib-disclosure > summary::-webkit-details-marker { display: none; }
        .fib-tool-page details.fib-disclosure > summary::after {
            content: '▸';
            float: right;
            font-size: 0.7rem;
            opacity: 0.65;
        }
        .fib-tool-page details.fib-disclosure[open] > summary::after {
            content: '▾';
        }
        .fib-tool-page .fib-disclosure-body {
            padding: 0.5rem 0.65rem 0.65rem;
            border-top: 1px solid var(--border, #e2e8f0);
        }
        [data-theme="dark"] .fib-tool-page .fib-disclosure-body {
            border-top-color: #334155;
        }
        .fib-tool-page .tool-output-wrapper.fib-output-card {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-height: min(72vh, 920px);
        }
        @media (max-width: 900px) {
            .fib-tool-page .tool-output-wrapper.fib-output-card {
                min-height: 400px;
            }
            .fib-tool-page .fib-output-card .fib-canvas-wrap {
                min-height: 300px;
            }
        }
        .fib-tool-page .fib-output-card .tool-actions-bar {
            flex-shrink: 0;
        }
        .fib-tool-page .fib-output-card .fib-canvas-wrap {
            flex: 1;
            min-height: min(44vh, 560px);
        }
        .fib-ascii-details > summary {
            list-style: none;
        }
        .fib-ascii-details > summary::-webkit-details-marker {
            display: none;
        }
        .fib-ascii-details[open] .fib-ascii-pre {
            max-height: 180px;
        }

        /* Elevated visual scene (page-scoped) */
        body.fib-spiral-page {
            background:
                radial-gradient(ellipse 115% 75% at 50% -18%, rgba(245, 158, 11, 0.16) 0%, transparent 52%),
                radial-gradient(ellipse 70% 50% at 92% 28%, rgba(251, 191, 36, 0.07) 0%, transparent 42%),
                linear-gradient(180deg, #f8fafc 0%, #f1f5f9 55%, #eef2f7 100%);
        }
        html[data-theme="dark"] body.fib-spiral-page {
            background:
                radial-gradient(ellipse 115% 75% at 50% -18%, rgba(245, 158, 11, 0.1) 0%, transparent 52%),
                radial-gradient(ellipse 80% 55% at 8% 75%, rgba(30, 58, 138, 0.12) 0%, transparent 45%),
                linear-gradient(180deg, #0f172a 0%, #020617 100%);
        }
        body.fib-spiral-page .tool-page-header {
            background: linear-gradient(180deg, #ffffff 0%, #fffbeb 72%, #ffffff 100%);
            box-shadow: 0 4px 28px -10px rgba(180, 83, 9, 0.14);
            border-bottom-color: rgba(251, 191, 36, 0.35);
        }
        html[data-theme="dark"] body.fib-spiral-page .tool-page-header {
            background: linear-gradient(180deg, #1e293b 0%, #172033 100%);
            box-shadow: 0 8px 32px -12px rgba(0, 0, 0, 0.55);
            border-bottom-color: #334155;
        }
        body.fib-spiral-page .tool-description-section {
            background: linear-gradient(180deg, rgba(255, 251, 235, 0.85) 0%, rgba(248, 250, 252, 0.65) 100%);
            border-bottom-color: rgba(226, 232, 240, 0.9);
        }
        html[data-theme="dark"] body.fib-spiral-page .tool-description-section {
            background: linear-gradient(180deg, rgba(30, 41, 59, 0.95) 0%, rgba(15, 23, 42, 0.85) 100%);
            border-bottom-color: #334155;
        }
        body.fib-spiral-page .fib-tool-page .tool-card {
            border-radius: 0.875rem;
            box-shadow:
                0 1px 2px rgba(15, 23, 42, 0.04),
                0 10px 28px -8px rgba(15, 23, 42, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.65);
        }
        html[data-theme="dark"] body.fib-spiral-page .fib-tool-page .tool-card {
            box-shadow:
                0 1px 2px rgba(0, 0, 0, 0.25),
                0 14px 36px -10px rgba(0, 0, 0, 0.55);
        }
        body.fib-spiral-page .fib-canvas-wrap {
            border-radius: 14px;
            border: 1px solid rgba(226, 232, 240, 0.95);
            box-shadow:
                0 4px 6px -1px rgba(15, 23, 42, 0.06),
                0 18px 44px -14px rgba(180, 83, 9, 0.18),
                inset 0 1px 0 rgba(255, 255, 255, 0.5);
        }
        html[data-theme="dark"] body.fib-spiral-page .fib-canvas-wrap {
            border-color: #334155;
            box-shadow:
                0 4px 6px rgba(0, 0, 0, 0.35),
                0 20px 48px -12px rgba(0, 0, 0, 0.65),
                inset 0 1px 0 rgba(255, 255, 255, 0.04);
        }
        body.fib-spiral-page .fib-edu-card {
            box-shadow:
                0 8px 32px -12px rgba(15, 23, 42, 0.12),
                inset 0 1px 0 rgba(255, 255, 255, 0.5);
        }
        html[data-theme="dark"] body.fib-spiral-page .fib-edu-card {
            box-shadow: 0 12px 40px -14px rgba(0, 0, 0, 0.55);
        }
        body.fib-spiral-page .fib-tool-page details.fib-disclosure {
            box-shadow: 0 1px 3px rgba(15, 23, 42, 0.05);
        }
        html[data-theme="dark"] body.fib-spiral-page .fib-tool-page details.fib-disclosure {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.25);
        }
    </style>
</head>
<body class="fib-spiral-page">
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Fibonacci Spiral Generator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#math">Mathematics</a> /
                    Fibonacci Spiral Generator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Free</span>
                <span class="tool-badge">Live preview</span>
                <span class="tool-badge">Client-side</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free <strong>Fibonacci spiral generator</strong> and <strong>golden spiral</strong> preview, <strong>Fibonacci calculator</strong> (F(n) and first-n terms), <strong>ASCII art</strong> text you can copy, Fibonacci numbers on squares, live <strong>φ</strong> ratio, colors, and PNG export.</p>
            </div>
            <div class="tool-description-ad">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <main class="tool-page-container fib-tool-page">
        <div class="tool-input-column">
            <div class="tool-card fib-input-card">
                <div class="tool-card-body fib-compact">
                    <p class="tool-form-hint" style="margin:0 0 0.5rem;font-size:0.75rem;line-height:1.35">Spiral controls — preview updates live.</p>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="squaresRange">Squares <span id="squaresLabel" class="tool-form-hint">(10)</span></label>
                        <input type="range" id="squaresRange" class="tool-input" min="3" max="18" value="10" aria-describedby="squaresHelp">
                        <p id="squaresHelp" class="tool-form-hint" style="margin-top:0.25rem;font-size:0.72rem">More squares → larger Fibonacci sizes.</p>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="scaleRange">Scale</label>
                        <input type="range" id="scaleRange" class="tool-input" min="4" max="28" value="12" aria-label="Preview scale">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="colorScheme">Colors</label>
                        <select id="colorScheme" class="tool-select" aria-label="Color scheme">
                            <option value="amber">Amber</option>
                            <option value="rainbow">Rainbow</option>
                            <option value="ocean">Ocean</option>
                            <option value="mono">Mono</option>
                        </select>
                    </div>
                    <div class="tool-form-group fib-check-row">
                        <label class="tool-form-label">
                            <input type="checkbox" id="showSpiral" checked> Spiral arcs
                        </label>
                        <label class="tool-form-label">
                            <input type="checkbox" id="showNumbers" checked> Numbers on squares
                        </label>
                        <label class="tool-form-label">
                            <input type="checkbox" id="showGrid"> Grid lines
                        </label>
                    </div>
                    <div class="tool-form-row" style="gap:0.4rem;flex-wrap:wrap">
                        <button type="button" class="tool-btn tool-btn-primary" id="fitBtn">Reset scale</button>
                        <button type="button" class="tool-btn" id="exportBtn">PNG</button>
                    </div>

                    <details class="fib-disclosure">
                        <summary>Fibonacci calculator F(n) &amp; sequence</summary>
                        <div class="fib-disclosure-body">
                            <p class="tool-form-hint" style="margin:0 0 0.45rem;font-size:0.72rem">F<sub>1</sub>=1, F<sub>2</sub>=1, …</p>
                            <div class="tool-form-group" style="margin-bottom:0.45rem">
                                <label class="tool-form-label" for="calcN">n</label>
                                <input type="number" id="calcN" class="tool-input" min="1" max="500" value="12" inputmode="numeric">
                            </div>
                            <div id="calcResult" class="fib-calc-result" role="status" aria-live="polite">F<sub>12</sub> = 144</div>
                            <div class="tool-form-row" style="gap:0.35rem;flex-wrap:wrap;margin-top:0.45rem">
                                <button type="button" class="tool-btn tool-btn-primary" id="calcBtn">Compute</button>
                                <button type="button" class="tool-btn" id="copyFnBtn">Copy F(n)</button>
                            </div>
                            <div class="tool-form-group" style="margin-top:0.55rem;margin-bottom:0.35rem">
                                <label class="tool-form-label" for="seqLen">First <span id="seqLenLabel">12</span> terms</label>
                                <input type="range" id="seqLen" class="tool-input" min="2" max="40" value="12">
                                <textarea id="seqOut" class="tool-input" readonly rows="2" style="font-size:0.75rem;margin-top:0.3rem;font-family:ui-monospace,monospace" aria-label="Fibonacci sequence"></textarea>
                                <button type="button" class="tool-btn" id="copySeqBtn" style="margin-top:0.4rem;width:100%">Copy sequence</button>
                            </div>
                        </div>
                    </details>

                    <details class="fib-disclosure">
                        <summary>ASCII text export</summary>
                        <div class="fib-disclosure-body">
                            <p class="tool-form-hint" style="margin:0 0 0.45rem;font-size:0.72rem">Monospace raster; wider = more detail.</p>
                            <div class="tool-form-group" style="margin-bottom:0.45rem">
                                <label class="tool-form-label" for="asciiCols">Width (chars)</label>
                                <input type="range" id="asciiCols" class="tool-input" min="40" max="100" value="72">
                            </div>
                            <div class="tool-form-row" style="gap:0.35rem;flex-wrap:wrap">
                                <button type="button" class="tool-btn tool-btn-primary" id="copyAsciiBtn">Copy ASCII</button>
                                <button type="button" class="tool-btn" id="refreshAsciiBtn">Refresh</button>
                            </div>
                        </div>
                    </details>
                </div>
            </div>
        </div>

        <div class="tool-output-column">
            <div class="tool-card tool-output-wrapper fib-output-card">
                <div class="tool-actions-bar">
                    <div class="tool-live-indicator">
                        <span class="tool-live-dot" aria-hidden="true"></span>
                        Live preview
                    </div>
                    <div class="tool-actions-spacer"></div>
                    <span id="phiApprox" class="tool-form-hint" style="font-variant-numeric: tabular-nums" aria-live="polite"></span>
                </div>
                <div class="fib-canvas-wrap" id="canvasWrap" title="Scroll to zoom · Drag to pan · Double-click to re-center">
                    <canvas id="fibCanvas" role="img" aria-label="Fibonacci spiral diagram — scroll wheel zoom, drag to pan"></canvas>
                </div>
                <p class="fib-legend" id="canvasLegend">Scroll <strong>up/down</strong> to zoom · <strong>Drag</strong> to pan · <strong>Double-click</strong> resets pan · Square sides follow Fibonacci 1, 1, 2, 3, …</p>
                <details class="fib-ascii-details" style="margin-top:0.5rem">
                    <summary class="tool-form-label" style="cursor:pointer;font-weight:600;font-size:0.875rem;list-style:none;user-select:none">ASCII preview <span class="tool-form-hint" style="font-weight:400">(optional)</span></summary>
                    <pre class="fib-ascii-pre" id="asciiPre" role="region" aria-label="Fibonacci spiral ASCII art text" style="margin-top:0.5rem"></pre>
                </details>
            </div>
        </div>

        <div class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <div class="fib-edu">
        <div class="fib-edu-card">
            <h2>How it works</h2>
            <p><strong>Fibonacci numbers</strong> start with 1, 1, then each term is the sum of the two before: 1, 1, 2, 3, 5, 8, 13, …</p>
            <p><strong>Tiling</strong> packs squares with those side lengths along a rectangle in a fixed order (add to the right, then below, then left, then above, and repeat).</p>
            <p><strong>Spiral</strong> In each square, a quarter circle of radius equal to the side length is drawn with its center at the corner <strong>nearest the spiral pole</strong> (where the first two 1×1 squares meet), so each arc stays inside its square and joins the next; this approximates the <strong>golden spiral</strong>. Ratios of consecutive Fibonacci numbers approach φ ≈ 1.618.</p>
            <ul>
                <li>φ = (1 + √5) / 2</li>
                <li>F<sub>n+1</sub>/F<sub>n</sub> → φ as n grows</li>
            </ul>
        </div>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="fibonacci-spiral.jsp"/>
        <jsp:param name="category" value="Mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <%@ include file="modern/components/support-section.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            </div>
        </div>
    </footer>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
    <script>
(function () {
    'use strict';

    function fibonacciArray(n) {
        var f = [];
        for (var i = 0; i < n; i++) {
            if (i === 0 || i === 1) f.push(1);
            else f.push(f[i - 1] + f[i - 2]);
        }
        return f;
    }

    /**
     * Standard Fibonacci tiling in canvas coordinates (x right, y down).
     * After two 1×1 squares, each new square is attached to the outside of the current bbox:
     * right → down → left → above → repeat.
     */
    function computeRects(numSquares) {
        var F = fibonacciArray(numSquares);
        var rects = [];
        var minX = 0, maxX = 0, minY = 0, maxY = 0;
        var dir = 0;

        for (var i = 0; i < numSquares; i++) {
            var s = F[i];
            var x, y;
            if (i === 0) {
                x = 0;
                y = 0;
                minX = 0;
                maxX = s;
                minY = 0;
                maxY = s;
            } else {
                switch (dir) {
                    case 0:
                        x = maxX;
                        y = minY;
                        break;
                    case 1:
                        x = minX;
                        y = maxY;
                        break;
                    case 2:
                        x = minX - s;
                        y = maxY - s;
                        break;
                    case 3:
                        x = maxX - s;
                        y = minY - s;
                        break;
                    default:
                        x = 0;
                        y = 0;
                }
                minX = Math.min(minX, x);
                maxX = Math.max(maxX, x + s);
                minY = Math.min(minY, y);
                maxY = Math.max(maxY, y + s);
            }
            rects.push({ x: x, y: y, s: s, i: i });
            if (i === 0) dir = 0;
            else dir = (dir + 1) % 4;
        }
        return { rects: rects, fib: F, minX: minX, minY: minY, maxX: maxX, maxY: maxY };
    }

    /**
     * For a square, circle center at one corner; quarter arc runs between the two corners
     * adjacent to that center along the square edges (radius = side length).
     */
    function neighborsOfCenterOnSquare(cx, cy, rect) {
        var x = rect.x, y = rect.y, s = rect.s;
        var e = 1e-9;
        if (Math.abs(cx - (x + s)) < e && Math.abs(cy - (y + s)) < e)
            return [{ x: x + s, y: y }, { x: x, y: y + s }];
        if (Math.abs(cx - x) < e && Math.abs(cy - (y + s)) < e)
            return [{ x: x, y: y }, { x: x + s, y: y + s }];
        if (Math.abs(cx - x) < e && Math.abs(cy - y) < e)
            return [{ x: x + s, y: y }, { x: x, y: y + s }];
        if (Math.abs(cx - (x + s)) < e && Math.abs(cy - y) < e)
            return [{ x: x, y: y }, { x: x + s, y: y + s }];
        return null;
    }

    function pointsEqual2D(a, b, eps) {
        eps = eps || 1e-6;
        return Math.abs(a.x - b.x) < eps && Math.abs(a.y - b.y) < eps;
    }

    /**
     * Spiral pole: corner shared by the first two 1×1 squares in this tiling (computeRects origin).
     * Classical Fibonacci spiral: each quarter-arc center is the square corner closest to this pole.
     * (Breaking on “first matching corner” in loop order wrongly picked e.g. (2,0) instead of (1,1) for square 1.)
     */
    var SPIRAL_POLE = { x: 1, y: 1 };

    function buildFibonacciArcChain(rects) {
        var out = [];
        var prevEnd = null;
        for (var i = 0; i < rects.length; i++) {
            var R = rects[i];
            var s = R.s;
            var x = R.x, y = R.y;
            var corners = [
                { x: x, y: y },
                { x: x + s, y: y },
                { x: x + s, y: y + s },
                { x: x, y: y + s }
            ];
            if (i === 0) {
                var cx = x + s, cy = y + s;
                var pStart = { x: x, y: y + s };
                var pEnd = { x: x + s, y: y };
                prevEnd = pEnd;
                out.push({ rect: R, cx: cx, cy: cy, pStart: pStart, pEnd: pEnd });
                continue;
            }
            var candidates = [];
            for (var ci = 0; ci < 4; ci++) {
                var cxi = corners[ci].x, cyi = corners[ci].y;
                var neigh = neighborsOfCenterOnSquare(cxi, cyi, R);
                if (!neigh) continue;
                var pA = neigh[0], pB = neigh[1];
                if (pointsEqual2D(pA, prevEnd)) {
                    candidates.push({ cx: cxi, cy: cyi, pStart: pA, pEnd: pB });
                }
                if (pointsEqual2D(pB, prevEnd)) {
                    candidates.push({ cx: cxi, cy: cyi, pStart: pB, pEnd: pA });
                }
            }
            if (candidates.length === 0) break;
            candidates.sort(function (a, b) {
                var da = Math.hypot(a.cx - SPIRAL_POLE.x, a.cy - SPIRAL_POLE.y);
                var db = Math.hypot(b.cx - SPIRAL_POLE.x, b.cy - SPIRAL_POLE.y);
                if (Math.abs(da - db) > 1e-9) return da - db;
                return a.cx - b.cx || a.cy - b.cy;
            });
            var found = candidates[0];
            prevEnd = found.pEnd;
            out.push({ rect: R, cx: found.cx, cy: found.cy, pStart: found.pStart, pEnd: found.pEnd });
        }
        return out;
    }

    function arcAnglesFromChainEntry(entry) {
        var R = entry.rect;
        var cx = entry.cx, cy = entry.cy;
        var a0 = Math.atan2(entry.pStart.y - cy, entry.pStart.x - cx);
        var a1 = Math.atan2(entry.pEnd.y - cy, entry.pEnd.x - cx);
        return pickQuarterArc(a0, a1, cx, cy, R.s, R.x, R.y);
    }

    /**
     * Same sweep normalization as canvas ctx.arc / sampleArcAngles.
     * Between two corners 90° apart on the circle, one sweep is π/2 (inside the square) and one is 3π/2 (outside).
     * Always take the π/2 sweep — the old midpoint-inside heuristic could pick the long arc.
     */
    function sweepDeltaForArc(a0, a1, anticlockwise) {
        var da = a1 - a0;
        if (anticlockwise) {
            if (da < 0) da += 2 * Math.PI;
        } else {
            if (da > 0) da -= 2 * Math.PI;
        }
        return da;
    }

    function pickQuarterArc(a0, a1, cx, cy, r, sx, sy) {
        var pi2 = Math.PI / 2;
        var eps = 5e-4;
        var daAcw = sweepDeltaForArc(a0, a1, true);
        var daCw = sweepDeltaForArc(a0, a1, false);
        var acwQuarter = Math.abs(Math.abs(daAcw) - pi2) < eps;
        var cwQuarter = Math.abs(Math.abs(daCw) - pi2) < eps;
        if (acwQuarter && !cwQuarter) {
            return { start: a0, end: a1, anticlockwise: true };
        }
        if (cwQuarter && !acwQuarter) {
            return { start: a0, end: a1, anticlockwise: false };
        }
        /* Fallback only if angles are degenerate / numeric edge case */
        var s = r;
        function inside(px, py) {
            return px >= sx - 1e-6 && px <= sx + s + 1e-6 && py >= sy - 1e-6 && py <= sy + s + 1e-6;
        }
        function midForDir(anticlockwise) {
            var da = sweepDeltaForArc(a0, a1, anticlockwise);
            return a0 + da * 0.5;
        }
        var mAcw = midForDir(true);
        var mxA = cx + Math.cos(mAcw) * r * 0.42;
        var myA = cy + Math.sin(mAcw) * r * 0.42;
        var mCw = midForDir(false);
        var mxC = cx + Math.cos(mCw) * r * 0.42;
        var myC = cy + Math.sin(mCw) * r * 0.42;
        if (inside(mxA, myA) && !inside(mxC, myC)) return { start: a0, end: a1, anticlockwise: true };
        if (inside(mxC, myC) && !inside(mxA, myA)) return { start: a0, end: a1, anticlockwise: false };
        return { start: a0, end: a1, anticlockwise: true };
    }

    function sampleArcAngles(ang) {
        var n = 28;
        var a0 = ang.start;
        var a1 = ang.end;
        var da = sweepDeltaForArc(a0, a1, ang.anticlockwise);
        var out = [];
        for (var k = 0; k <= n; k++) {
            out.push(a0 + da * (k / n));
        }
        return out;
    }

    function fibNthOneIndexedBig(n) {
        var ni = parseInt(n, 10);
        if (isNaN(ni) || ni <= 0) return 0n;
        if (ni <= 2) return 1n;
        var a = 1n;
        var b = 1n;
        for (var i = 3; i <= ni; i++) {
            var c = a + b;
            a = b;
            b = c;
        }
        return b;
    }

    function insideRect(wx, wy, rr) {
        return wx >= rr.x && wx <= rr.x + rr.s && wy >= rr.y && wy <= rr.y + rr.s;
    }

    function buildAsciiArt(rects, F, data, cols) {
        var minX = data.minX;
        var minY = data.minY;
        var maxX = data.maxX;
        var maxY = data.maxY;
        var w = maxX - minX;
        var h = maxY - minY;
        if (w < 1e-9 || h < 1e-9) return '(empty)';
        var rows = Math.max(6, Math.round(cols * (h / w) * 0.48));
        var grid = [];
        var r, c;
        for (r = 0; r < rows; r++) {
            grid[r] = [];
            for (c = 0; c < cols; c++) {
                var wx = minX + (c + 0.5) / cols * w;
                var wy = minY + (r + 0.5) / rows * h;
                var ch = ' ';
                for (var i = 0; i < rects.length; i++) {
                    if (insideRect(wx, wy, rects[i])) {
                        ch = String(F[i]).slice(-1);
                        break;
                    }
                }
                grid[r][c] = ch;
            }
        }
        function markCell(wx, wy, ch) {
            var cc = Math.floor(((wx - minX) / w) * cols);
            var rr = Math.floor(((wy - minY) / h) * rows);
            if (cc < 0 || cc >= cols || rr < 0 || rr >= rows) return;
            grid[rr][cc] = ch;
        }
        var arcChain = buildFibonacciArcChain(rects);
        for (var s = 0; s < arcChain.length; s++) {
            var entry = arcChain[s];
            var R = entry.rect;
            var ang = arcAnglesFromChainEntry(entry);
            var pts = sampleArcAngles(ang);
            var rad = R.s;
            var cen = { cx: entry.cx, cy: entry.cy };
            for (var p = 0; p < pts.length; p++) {
                var wx = cen.cx + rad * Math.cos(pts[p]);
                var wy = cen.cy + rad * Math.sin(pts[p]);
                markCell(wx, wy, '*');
            }
        }
        var lines = [];
        for (r = 0; r < rows; r++) {
            lines.push(grid[r].join(''));
        }
        return lines.join('\n');
    }

    function colorForIndex(scheme, idx, total) {
        var t = total <= 1 ? 0 : idx / (total - 1);
        switch (scheme) {
            case 'rainbow':
                return 'hsl(' + ((idx * 360 / Math.max(total, 1)) % 360) + ', 72%, 52%)';
            case 'ocean':
                return 'hsl(' + (195 + t * 40) + ', 70%, ' + (42 + t * 18) + '%)';
            case 'mono':
                return 'hsl(220, 12%, ' + (88 - t * 55) + '%)';
            case 'amber':
            default:
                return 'hsl(' + (32 + t * 22) + ', 78%, ' + (52 - t * 12) + '%)';
        }
    }

    var canvas = document.getElementById('fibCanvas');
    var ctx = canvas.getContext('2d');
    var squaresRange = document.getElementById('squaresRange');
    var scaleRange = document.getElementById('scaleRange');
    var colorScheme = document.getElementById('colorScheme');
    var showSpiral = document.getElementById('showSpiral');
    var showNumbers = document.getElementById('showNumbers');
    var showGrid = document.getElementById('showGrid');
    var phiApprox = document.getElementById('phiApprox');
    var squaresLabel = document.getElementById('squaresLabel');
    var calcN = document.getElementById('calcN');
    var calcResult = document.getElementById('calcResult');
    var calcBtn = document.getElementById('calcBtn');
    var copyFnBtn = document.getElementById('copyFnBtn');
    var seqLen = document.getElementById('seqLen');
    var seqLenLabel = document.getElementById('seqLenLabel');
    var seqOut = document.getElementById('seqOut');
    var copySeqBtn = document.getElementById('copySeqBtn');
    var asciiCols = document.getElementById('asciiCols');
    var asciiPre = document.getElementById('asciiPre');
    var copyAsciiBtn = document.getElementById('copyAsciiBtn');
    var refreshAsciiBtn = document.getElementById('refreshAsciiBtn');

    var baseScale = parseInt(scaleRange.value, 10);
    /** Pan offset in CSS pixels (applied after centering). */
    var viewPanX = 0;
    var viewPanY = 0;

    function fibSequenceString(len) {
        var parts = [];
        var L = Math.min(500, Math.max(2, parseInt(len, 10) || 2));
        for (var i = 1; i <= L; i++) {
            parts.push(fibNthOneIndexedBig(i).toString());
        }
        return parts.join(', ');
    }

    function updateFibCalc() {
        var n = parseInt(calcN.value, 10);
        if (isNaN(n) || n < 1) n = 1;
        if (n > 500) n = 500;
        calcN.value = String(n);
        var fib = fibNthOneIndexedBig(n);
        calcResult.innerHTML = 'F<sub>' + n + '</sub> = ' + fib.toString();
    }

    function updateSeq() {
        var len = parseInt(seqLen.value, 10);
        seqLenLabel.textContent = String(len);
        seqOut.value = fibSequenceString(len);
    }

    function phiFromLastTwo(F) {
        if (F.length < 2) return null;
        var a = F[F.length - 1];
        var b = F[F.length - 2];
        if (b === 0) return null;
        return a / b;
    }

    function draw() {
        var n = parseInt(squaresRange.value, 10);
        baseScale = parseInt(scaleRange.value, 10);
        squaresLabel.textContent = '(' + n + ')';

        var data = computeRects(n);
        var rects = data.rects;
        var F = data.fib;
        var wWorld = data.maxX - data.minX;
        var hWorld = data.maxY - data.minY;

        var phi = phiFromLastTwo(F);
        if (phiApprox) {
            phiApprox.textContent = phi
                ? 'F' + n + '/F' + (n - 1) + ' ≈ ' + phi.toFixed(6) + ' (→ φ)'
                : '';
        }

        var pad = 24;
        var wrap = document.getElementById('canvasWrap');
        var cssW = Math.max(280, wrap.clientWidth || 600);
        var cw = Math.max(300, Math.min(1200, cssW));
        var ch = Math.max(300, Math.min(980, (hWorld / Math.max(wWorld, 1e-6)) * cw + pad * 2));

        var dpr = window.devicePixelRatio || 1;
        canvas.width = Math.round(cw * dpr);
        canvas.height = Math.round(ch * dpr);
        canvas.style.width = cw + 'px';
        canvas.style.height = ch + 'px';
        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        ctx.fillStyle = isDark ? '#0f172a' : '#f8fafc';
        ctx.fillRect(0, 0, cw, ch);

        var sx = (cw - pad * 2) / Math.max(wWorld, 1e-6);
        var sy = (ch - pad * 2) / Math.max(hWorld, 1e-6);
        var fitUniform = Math.min(sx, sy);
        var zoom = baseScale / 12;
        var uniform = fitUniform * zoom;
        var maxUniform = Math.min((cw - pad * 2) / wWorld, (ch - pad * 2) / hWorld);
        if (uniform > maxUniform) uniform = maxUniform;
        var ox = pad + (cw - pad * 2 - wWorld * uniform) / 2 - data.minX * uniform + viewPanX;
        var oy = pad + (ch - pad * 2 - hWorld * uniform) / 2 - data.minY * uniform + viewPanY;

        function TX(x) { return ox + x * uniform; }
        function TY(y) { return oy + y * uniform; }

        var scheme = colorScheme.value;

        for (var r = 0; r < rects.length; r++) {
            var rect = rects[r];
            var rx = TX(rect.x);
            var ry = TY(rect.y);
            var rs = rect.s * uniform;

            ctx.fillStyle = colorForIndex(scheme, r, rects.length);
            ctx.globalAlpha = 0.88;
            ctx.fillRect(rx, ry, rs, rs);
            ctx.globalAlpha = 1;
            ctx.strokeStyle = isDark ? '#94a3b8' : '#64748b';
            ctx.lineWidth = Math.max(1, 1 / uniform);
            ctx.strokeRect(rx, ry, rs, rs);

            if (showGrid.checked) {
                ctx.strokeStyle = 'rgba(100,116,139,0.25)';
                ctx.lineWidth = 0.5;
                ctx.strokeRect(rx + rs * 0.5, ry, 0, rs);
                ctx.strokeRect(rx, ry + rs * 0.5, rs, 0);
            }
        }

        if (showSpiral.checked) {
            ctx.strokeStyle = isDark ? '#f8fafc' : '#1e293b';
            ctx.lineWidth = Math.max(2, 2.5 / uniform);
            ctx.lineJoin = 'round';
            var spiralArcs = buildFibonacciArcChain(rects);
            for (var s = 0; s < spiralArcs.length; s++) {
                var entry = spiralArcs[s];
                var R = entry.rect;
                var cx = TX(entry.cx);
                var cy = TY(entry.cy);
                var rad = R.s * uniform;
                var ang = arcAnglesFromChainEntry(entry);
                ctx.beginPath();
                ctx.arc(cx, cy, rad, ang.start, ang.end, ang.anticlockwise);
                ctx.stroke();
            }
        }

        if (showNumbers.checked) {
            ctx.fillStyle = isDark ? '#e2e8f0' : '#0f172a';
            var fs = Math.max(10, Math.min(18, 11 * uniform / 3));
            ctx.font = '600 ' + fs + 'px Inter, system-ui, sans-serif';
            ctx.textAlign = 'center';
            ctx.textBaseline = 'middle';
            for (var t = 0; t < rects.length; t++) {
                var rr = rects[t];
                ctx.fillText(String(F[t]), TX(rr.x + rr.s / 2), TY(rr.y + rr.s / 2));
            }
        }

        updateAsciiText();
    }

    function updateAsciiText() {
        if (!asciiPre) return;
        var n = parseInt(squaresRange.value, 10);
        var cols = parseInt(asciiCols.value, 10) || 72;
        var data = computeRects(n);
        asciiPre.textContent = buildAsciiArt(data.rects, data.fib, data, cols);
    }

    function scheduleDraw() {
        window.requestAnimationFrame(draw);
    }

    squaresRange.addEventListener('input', scheduleDraw);
    scaleRange.addEventListener('input', scheduleDraw);
    colorScheme.addEventListener('change', scheduleDraw);
    showSpiral.addEventListener('change', scheduleDraw);
    showNumbers.addEventListener('change', scheduleDraw);
    showGrid.addEventListener('change', scheduleDraw);

    document.getElementById('fitBtn').addEventListener('click', function () {
        scaleRange.value = 12;
        viewPanX = 0;
        viewPanY = 0;
        scheduleDraw();
        if (window.ToolUtils && ToolUtils.showToast) ToolUtils.showToast('Scale and pan reset', 1500, 'info');
    });

    (function setupCanvasPanZoom() {
        var wrap = document.getElementById('canvasWrap');
        if (!wrap || !canvas) return;

        wrap.addEventListener('wheel', function (e) {
            e.preventDefault();
            var dir = Math.sign(e.deltaY);
            if (dir === 0) return;
            var v = parseInt(scaleRange.value, 10) - dir;
            v = Math.max(4, Math.min(28, v));
            if (v !== parseInt(scaleRange.value, 10)) {
                scaleRange.value = String(v);
                scheduleDraw();
            }
        }, { passive: false });

        var panning = false;
        var lastX = 0;
        var lastY = 0;
        var activePointerId = null;

        wrap.addEventListener('pointerdown', function (e) {
            if (e.button !== 0) return;
            panning = true;
            activePointerId = e.pointerId;
            lastX = e.clientX;
            lastY = e.clientY;
            wrap.classList.add('fib-panning');
            try {
                wrap.setPointerCapture(e.pointerId);
            } catch (err) { /* ignore */ }
        });

        wrap.addEventListener('pointermove', function (e) {
            if (!panning) return;
            viewPanX += e.clientX - lastX;
            viewPanY += e.clientY - lastY;
            lastX = e.clientX;
            lastY = e.clientY;
            scheduleDraw();
        });

        function endPan() {
            if (!panning) return;
            panning = false;
            wrap.classList.remove('fib-panning');
            if (activePointerId != null) {
                try {
                    wrap.releasePointerCapture(activePointerId);
                } catch (err) { /* ignore */ }
                activePointerId = null;
            }
        }
        wrap.addEventListener('pointerup', endPan);
        wrap.addEventListener('pointercancel', endPan);

        wrap.addEventListener('dblclick', function (e) {
            e.preventDefault();
            viewPanX = 0;
            viewPanY = 0;
            scheduleDraw();
        });
    })();

    document.getElementById('exportBtn').addEventListener('click', function () {
        try {
            var a = document.createElement('a');
            a.download = 'fibonacci-spiral-' + Date.now() + '.png';
            a.href = canvas.toDataURL('image/png');
            a.click();
            if (window.ToolUtils && ToolUtils.showToast) ToolUtils.showToast('PNG downloaded', 2000, 'success');
        } catch (e) {
            if (window.ToolUtils && ToolUtils.showToast) ToolUtils.showToast('Could not export image', 2500, 'error');
        }
    });

    calcBtn.addEventListener('click', updateFibCalc);
    calcN.addEventListener('change', updateFibCalc);
    calcN.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') updateFibCalc();
    });
    copyFnBtn.addEventListener('click', function () {
        var n = parseInt(calcN.value, 10);
        var fib = fibNthOneIndexedBig(isNaN(n) ? 1 : n);
        if (window.ToolUtils && ToolUtils.copyToClipboard) {
            ToolUtils.copyToClipboard(fib.toString(), { toastMessage: 'F(n) copied' });
        }
    });
    seqLen.addEventListener('input', updateSeq);
    copySeqBtn.addEventListener('click', function () {
        if (window.ToolUtils && ToolUtils.copyToClipboard) {
            ToolUtils.copyToClipboard(seqOut.value, { toastMessage: 'Sequence copied' });
        }
    });
    asciiCols.addEventListener('input', updateAsciiText);
    copyAsciiBtn.addEventListener('click', function () {
        if (asciiPre && window.ToolUtils && ToolUtils.copyToClipboard) {
            ToolUtils.copyToClipboard(asciiPre.textContent, { toastMessage: 'ASCII copied' });
        }
    });
    refreshAsciiBtn.addEventListener('click', updateAsciiText);

    window.addEventListener('resize', function () {
        clearTimeout(window._fibResize);
        window._fibResize = setTimeout(draw, 120);
    });

    if (window.ResizeObserver) {
        var ro = new ResizeObserver(scheduleDraw);
        ro.observe(document.getElementById('canvasWrap'));
    }

    updateFibCalc();
    updateSeq();
    draw();
})();
    </script>
</body>
</html>
