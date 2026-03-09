<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free Online Graphing Calculator - 2D, 3D, Calculus (2026)" />
        <jsp:param name="toolDescription" value="Free graphing calculator online: plot functions, 3D surfaces, derivatives f'(x), integrals, limits, polar, parametric, and equations. Auto-detect input type, 50+ presets, sliders, animation. No signup. Desmos alternative with built-in CAS." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="graphing-calculator.jsp" />
        <jsp:param name="toolKeywords" value="graphing calculator, online graphing calculator free, graphing calculator online, free graphing calculator, 3D graphing calculator, graph functions online, desmos alternative, graphing calculator with derivatives, calculus graphing calculator, plot functions online free, graph equations online, parametric graphing calculator, polar graph plotter, 3D surface plot calculator, graph inequalities online, function plotter, limit calculator graph, systems of equations grapher, interactive math graph tool, TI-84 graphing calculator online" />
        <jsp:param name="toolImage" value="graphing-calculator.svg" />
        <jsp:param name="toolFeatures" value="3D surface plotting for z=f(x y) expressions,Derivative overlay f'(x) for any function,Symbolic antiderivative F(x) plotting via CAS,Definite integral shading with adjustable bounds,Limit evaluation and visualization with annotations,Auto-detect expression type (cartesian polar parametric surface equation inequality),Systems of equations with intersection solving,Implicit equation solver (circles ellipses hyperbolas),50+ built-in presets including calculus physics and ML,Parameter sliders with real-time animation,Trace mode showing coordinates and slope,KaTeX live math preview as you type,Export as PNG or SVG,Shareable graph URLs,Unicode math input support (π θ √ ² ³)" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Type an expression|Enter any math expression like sin(x) or x^2+y^2=25 and the calculator auto-detects the graph type,Enable calculus overlays|Toggle f'(x) for derivatives or F(x) for antiderivatives or shade definite integrals with adjustable bounds,Evaluate limits|Switch to Limit type and enter the approach value to see the limit computed symbolically and annotated on the graph,Add more expressions|Click Add Expression to overlay multiple functions with different colors and compare them visually,Export or share|Export your graph as PNG or SVG or generate a shareable link to send to classmates or colleagues" />
        <jsp:param name="teaches" value="Calculus derivatives and integrals, limits, graphing functions, systems of equations, polar and parametric curves" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate" />
        <jsp:param name="faq1q" value="What types of graphs can this calculator plot?" />
        <jsp:param name="faq1a" value="This graphing calculator supports 8 plot types: Cartesian y=f(x) functions like sin(x) and x^2, equations solved symbolically such as x^2+y^2=25 or 2x+3y=8, parametric curves x(t) y(t), polar graphs r=f(theta), limits with visual annotations, piecewise functions, inequalities with shaded regions, and statistical distributions. Just type any expression and it auto-detects the type." />
        <jsp:param name="faq2q" value="How do I graph derivatives, integrals, and antiderivatives?" />
        <jsp:param name="faq2a" value="For any Cartesian function, use the calculus toggles next to the expression input. Toggle f'(x) to overlay the derivative curve, click the integral symbol to shade the area under the curve with adjustable a and b bounds, or toggle F(x) to plot the symbolic antiderivative computed by the built-in CAS engine. All three can be shown simultaneously." />
        <jsp:param name="faq3q" value="How does the limit calculator work on the graph?" />
        <jsp:param name="faq3a" value="Select the Limit type from the dropdown, enter the function like sin(x)/x, and set the approach value such as 0. The calculator uses a symbolic CAS to compute the exact limit, plots the function, and annotates the limit point with an open circle marker, a dashed horizontal line at y=L, and a dotted vertical line at x=a. Try presets like lim sin(x)/x as x approaches 0 equals 1." />
        <jsp:param name="faq4q" value="Can I solve systems of equations and find intersections?" />
        <jsp:param name="faq4a" value="Yes. Add multiple equations such as y=x^2 and y=2x+3 and the calculator graphs both curves. Use the Intersections button to find where they cross. The Equation type uses Nerdamer CAS to solve any equation symbolically, including circles, ellipses, hyperbolas, and higher-degree polynomials. Over 15 system presets are built in." />
        <jsp:param name="faq5q" value="Does it support parameter sliders and animation?" />
        <jsp:param name="faq5a" value="Yes. Type any single letter like a, b, or c in your expression and a slider appears automatically. Drag the slider to change the parameter in real time. Press the play button to animate and watch the graph evolve continuously. This works for all plot types including polar, parametric, and implicit equations." />
        <jsp:param name="faq6q" value="What are the 50+ built-in presets?" />
        <jsp:param name="faq6a" value="Presets include Quick Start (sin, parametric, polar), Calculus (antiderivative of x^2, FTC demo, limit sin(x)/x), Systems of Equations (linear, circle+line, parabola+line), Creative Curves (spirograph, lissajous, butterfly, cardioid), Physics (damped oscillation, projectile, wave interference), Machine Learning (activation functions, loss functions, gradient descent), and Classic curves (Witch of Agnesi, folium, cissoid)." />
        <jsp:param name="faq7q" value="Is this graphing calculator really free? What are the limits?" />
        <jsp:param name="faq7a" value="100 percent free with no signup, no ads blocking the graph, and no usage limits. All computation runs entirely in your browser using Math.js, Plotly.js, Nerdamer CAS, and KaTeX. Export graphs as PNG or SVG, save expression sets to local storage, or generate shareable URLs. Works on desktop, tablet, and mobile browsers." />
        <jsp:param name="faq8q" value="Can I plot 3D surfaces like z = sin(x)*cos(y)?" />
        <jsp:param name="faq8a" value="Yes. Type any expression with both x and y like sin(x)*cos(y) or x^2+y^2 and the calculator auto-detects it as a 3D surface. It loads a full WebGL renderer and displays an interactive surface you can rotate and zoom. Presets include Ripple, Saddle, Gaussian, and Waves. You can also type z=f(x,y) with a z= prefix." />
    </jsp:include>

    <!-- Preconnect to CDN origins (high priority) -->
    <link rel="preconnect" href="https://cdn.plot.ly" crossorigin>
    <link rel="preconnect" href="https://cdnjs.cloudflare.com" crossorigin>
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- Preload heavy JS: download starts during CSS parse, doesn't block render -->
    <link rel="preload" href="https://cdn.plot.ly/plotly-basic-2.27.0.min.js" as="script" crossorigin>
    <link rel="preload" href="https://cdnjs.cloudflare.com/ajax/libs/mathjs/12.4.1/math.min.js" as="script" crossorigin>
    <link rel="preload" href="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.min.js" as="script" crossorigin>

    <!-- Critical CSS: only layout + above-the-fold (render-blocking, small) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/graphing-calculator.css?v=<%=cacheVersion%>">

    <!-- Non-critical CSS: load async (ads, dark mode, footer, search) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" media="print" onload="this.media='all'">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" media="print" onload="this.media='all'">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" media="print" onload="this.media='all'">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" media="print" onload="this.media='all'">

    <!-- Fonts: non-blocking -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"></noscript>

    <!-- Font Awesome: non-blocking (icons aren't above the fold on mobile) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></noscript>

    <!-- KaTeX CSS: non-blocking (math preview is below the fold on mobile) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" media="print" onload="this.media='all'">

    <!-- MathQuill CSS: WYSIWYG math input -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathquill@0.10.1/build/mathquill.css" media="print" onload="this.media='all'">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- LCP placeholder: inline style for graph area so it paints immediately -->
    <style>
        .gc-graph-placeholder {
            display: flex; align-items: center; justify-content: center;
            flex: 1; min-height: 300px; color: var(--gc-tool, #8b5cf6);
            font-size: 0.875rem; opacity: 0.6;
        }
    </style>
    <style>
        .tool-action-btn { background: var(--gc-gradient) !important; }
        .tool-badge { background: var(--gc-light); color: var(--gc-tool); }
        /* Collapse ad containers until they actually load content */
        .ad-container:not(.ad-loaded) { min-height: 0 !important; padding: 0 !important; margin: 0 !important; border: none !important; box-shadow: none !important; overflow: hidden !important; }
        .ad-container:not(.ad-loaded) .ad-label { display: none !important; }
        /* ===== TABLET: compact padding ===== */
        @media (max-width: 1024px) {
            body .tool-page-header { padding: 0.75rem 1rem !important; }
            body .tool-page-title { font-size: 1.35rem !important; margin: 0 !important; }
            body .tool-badge { padding: 0.15rem 0.5rem !important; font-size: 0.65rem !important; }
            body .tool-description-section { padding: 0.5rem 1rem !important; }
            body .tool-page-container { min-height: auto !important; }
            body .related-tools-section { margin-top: 1rem !important; }
            body .related-tools-card { padding: 1rem !important; }
            body .support-section-modern { margin: 1rem 0 !important; }
            body .support-card { padding: 1.25rem !important; }
            body .page-footer { padding: 1rem !important; }
        }
        /* ===== MOBILE COMPACT — all !important to beat any external CSS ===== */
        @media (max-width: 900px) {
            /* Header */
            body .tool-page-header { padding: 0.5rem 0.75rem !important; margin-top: 64px !important; }
            body .tool-page-header-inner { gap: 0.25rem !important; flex-wrap: wrap !important; }
            body .tool-page-title { font-size: 1.15rem !important; font-weight: 700 !important; margin: 0 !important; margin-bottom: 0 !important; }
            body .tool-breadcrumbs { margin-top: 0.125rem !important; font-size: 0.7rem !important; }
            body .tool-page-badges { gap: 0.25rem !important; }
            body .tool-badge { padding: 0.125rem 0.4rem !important; font-size: 0.6rem !important; border-radius: 12px !important; }
            /* Description */
            body .tool-description-section { padding: 0.375rem 0.75rem !important; }
            body .tool-description-inner { gap: 0.25rem !important; }
            body .tool-description-content p { font-size: 0.78rem !important; line-height: 1.35 !important; margin: 0 !important; }
            /* Main container */
            body .tool-page-container { padding: 0.375rem !important; gap: 0.375rem !important; min-height: auto !important; max-width: 100% !important; display: flex !important; flex-direction: column !important; }
            body .gc-page-container.tool-page-container { padding: 0.375rem !important; gap: 0.375rem !important; min-height: auto !important; max-width: 100% !important; }
            /* Columns: full width on mobile */
            body .tool-input-column { width: 100% !important; max-width: 100% !important; max-height: none !important; overflow-y: visible !important; position: relative !important; top: auto !important; }
            body .tool-output-column { width: 100% !important; max-width: 100% !important; min-height: 250px !important; position: relative !important; top: auto !important; }
            /* Cards */
            body .gc-page-container .tool-card { margin-bottom: 0 !important; }
            body .gc-page-container .tool-card-body { padding: 0.5rem !important; }
            body .gc-page-container .tool-card-header { padding: 0.4rem 0.625rem !important; font-size: 0.8rem !important; }
            body .gc-page-container .tool-section-content { padding: 0.375rem !important; }
            body .gc-page-container .tool-section-header { padding: 0.4rem 0.5rem !important; font-size: 0.75rem !important; }
            body .gc-page-container .tool-card + .tool-card { margin-top: 0.375rem !important; }
            /* Graph card */
            body .gc-graph-card { border-radius: 8px !important; }
            body .gc-graph-toolbar { padding: 0.3rem 0.5rem !important; }
            /* Related tools */
            body .related-tools-section { margin-top: 0.5rem !important; padding: 0 0.375rem !important; }
            body .related-tools-card { padding: 0.625rem !important; }
            body .related-tools-header { margin-bottom: 0.375rem !important; padding-bottom: 0.25rem !important; }
            body .related-tools-header h3 { font-size: 0.9rem !important; }
            body .related-tools-grid { gap: 0.375rem !important; }
            body .related-tool-item { padding: 0.5rem !important; }
            /* FAQ */
            body .tool-expertise-section { margin: 0.5rem auto !important; padding: 0 0.375rem !important; }
            body .tool-expertise-section > .tool-card { padding: 0.625rem !important; margin-bottom: 0 !important; }
            body .tool-expertise-section h2 { font-size: 0.95rem !important; margin-bottom: 0.25rem !important; }
            body .faq-question { padding: 0.5rem 0.25rem !important; font-size: 0.8rem !important; }
            body .faq-answer { padding: 0 0.25rem 0.5rem !important; font-size: 0.78rem !important; line-height: 1.4 !important; }
            /* Support */
            body .support-section-modern { margin: 0.5rem 0 !important; padding: 0 0.375rem !important; }
            body .support-card { padding: 0.625rem !important; }
            body .support-header { margin-bottom: 0.375rem !important; gap: 0.375rem !important; }
            body .support-title { font-size: 0.9rem !important; }
            body .support-message { font-size: 0.78rem !important; margin-bottom: 0.375rem !important; }
            body .support-stats { margin-bottom: 0.375rem !important; gap: 0.25rem !important; }
            body .stat-badge { padding: 0.15rem 0.4rem !important; font-size: 0.65rem !important; }
            body .support-actions { gap: 0.375rem !important; }
            body .support-btn { padding: 0.4rem 0.625rem !important; gap: 0.375rem !important; }
            body .btn-icon { font-size: 1.1rem !important; }
            body .btn-text { font-size: 0.75rem !important; }
            body .btn-label { font-size: 0.55rem !important; }
            body .security-guarantee { padding: 0.25rem 0.5rem !important; margin-top: 0.375rem !important; }
            body .security-text { font-size: 0.65rem !important; }
            /* Footer */
            body .page-footer { padding: 0.5rem !important; }
            body .footer-content { padding: 0.25rem !important; }
            body .footer-text { font-size: 0.7rem !important; margin: 0 !important; }
            body .footer-links { gap: 0.5rem !important; }
            body .footer-link { font-size: 0.7rem !important; }
            /* Ad containers */
            body .tool-mobile-ad-container { padding: 0.375rem !important; }
            body .ad-container { margin: 0.25rem auto !important; }
        }
        @media (max-width: 480px) {
            body .tool-page-header { padding: 0.375rem 0.5rem !important; }
            body .tool-page-title { font-size: 1rem !important; }
            body .tool-page-badges { display: none !important; }
            body .tool-description-section { padding: 0.25rem 0.5rem !important; }
            body .tool-description-content p { font-size: 0.75rem !important; }
            body .tool-page-container { padding: 0.25rem !important; gap: 0.25rem !important; }
            body .gc-page-container.tool-page-container { padding: 0.25rem !important; gap: 0.25rem !important; }
            body .gc-page-container .tool-card-body { padding: 0.375rem !important; }
            body .gc-page-container .tool-section-content { padding: 0.25rem !important; }
            body .gc-preset-chips { gap: 0.25rem !important; }
            body .gc-preset-chip { padding: 0.2rem 0.4rem !important; font-size: 0.65rem !important; }
            body .gc-preset-category-label { font-size: 0.65rem !important; margin-bottom: 0.125rem !important; }
        }
    </style>
</head>
<body>
<script>
/* Mobile compact: inject inline styles that beat any CSS. Runs before paint. */
(function(){
  if(window.innerWidth > 900) return;
  var s = document.createElement('style');
  s.textContent = [
    /* --- nuclear mobile overrides via :where(body) + inline-level specificity --- */
    '.tool-page-header{padding:0.5rem 0.75rem!important;margin-top:64px!important}',
    '.tool-page-header-inner{gap:0.25rem!important;flex-wrap:wrap!important}',
    '.tool-page-title{font-size:1.15rem!important;margin:0!important}',
    '.tool-breadcrumbs{margin-top:0.125rem!important;font-size:0.7rem!important}',
    '.tool-page-badges{gap:0.25rem!important}',
    '.tool-badge{padding:0.125rem 0.4rem!important;font-size:0.6rem!important}',
    '.tool-description-section{padding:0.375rem 0.75rem!important}',
    '.tool-description-inner{gap:0.25rem!important}',
    '.tool-description-content p{font-size:0.78rem!important;line-height:1.35!important;margin:0!important}',
    '.tool-page-container,.gc-page-container.tool-page-container{padding:0.375rem!important;gap:0.375rem!important;min-height:auto!important;max-width:100%!important;display:flex!important;flex-direction:column!important}',
    '.tool-input-column{width:100%!important;max-width:100%!important;max-height:none!important;overflow-y:visible!important;position:relative!important;top:auto!important}',
    '.tool-output-column{width:100%!important;max-width:100%!important;min-height:250px!important;position:relative!important;top:auto!important}',
    '.gc-page-container .tool-card{margin-bottom:0!important}',
    '.gc-page-container .tool-card-body{padding:0.5rem!important}',
    '.gc-page-container .tool-card-header{padding:0.4rem 0.625rem!important;font-size:0.8rem!important}',
    '.gc-page-container .tool-section-content{padding:0.375rem!important}',
    '.gc-page-container .tool-section-header{padding:0.4rem 0.5rem!important;font-size:0.75rem!important}',
    '.gc-graph-card{border-radius:8px!important}',
    '.gc-graph-toolbar{padding:0.3rem 0.5rem!important}',
    '.related-tools-section{margin-top:0.5rem!important;padding:0 0.375rem!important}',
    '.related-tools-card{padding:0.625rem!important}',
    '.related-tools-header{margin-bottom:0.375rem!important;padding-bottom:0.25rem!important}',
    '.related-tools-header h3{font-size:0.9rem!important}',
    '.related-tools-grid{gap:0.375rem!important}',
    '.related-tool-item{padding:0.5rem!important}',
    '.tool-expertise-section{margin:0.5rem auto!important;padding:0 0.375rem!important}',
    '.tool-expertise-section>.tool-card{padding:0.625rem!important;margin-bottom:0!important}',
    '.tool-expertise-section h2{font-size:0.95rem!important;margin-bottom:0.25rem!important}',
    '.faq-question{padding:0.5rem 0.25rem!important;font-size:0.8rem!important}',
    '.faq-answer{padding:0 0.25rem 0.5rem!important;font-size:0.78rem!important;line-height:1.4!important}',
    '.support-section-modern{margin:0.5rem 0!important;padding:0 0.375rem!important}',
    '.support-card{padding:0.625rem!important}',
    '.support-header{margin-bottom:0.375rem!important;gap:0.375rem!important}',
    '.support-title{font-size:0.9rem!important}',
    '.support-message{font-size:0.78rem!important;margin-bottom:0.375rem!important}',
    '.support-stats{margin-bottom:0.375rem!important;gap:0.25rem!important}',
    '.stat-badge{padding:0.15rem 0.4rem!important;font-size:0.65rem!important}',
    '.support-actions{gap:0.375rem!important}',
    '.support-btn{padding:0.4rem 0.625rem!important;gap:0.375rem!important}',
    '.btn-icon{font-size:1.1rem!important}',
    '.btn-text{font-size:0.75rem!important}',
    '.btn-label{font-size:0.55rem!important}',
    '.security-guarantee{padding:0.25rem 0.5rem!important;margin-top:0.375rem!important}',
    '.security-text{font-size:0.65rem!important}',
    '.page-footer{padding:0.5rem!important}',
    '.footer-content{padding:0.25rem!important}',
    '.footer-text{font-size:0.7rem!important;margin:0!important}',
    '.footer-links{gap:0.5rem!important}',
    '.footer-link{font-size:0.7rem!important}',
    '.ad-container:not(.ad-loaded){min-height:0!important;padding:0!important;margin:0!important;border:none!important;box-shadow:none!important;overflow:hidden!important}',
    '.ad-container:not(.ad-loaded) .ad-label{display:none!important}',
    '.tool-mobile-ad-container{padding:0.375rem!important}',
    '.support-icon-wrapper{width:32px!important;height:32px!important}',
    '.support-icon{font-size:1rem!important}'
  ].join('');
  document.head.appendChild(s);
})();
</script>
<%@ include file="modern/components/nav-header.jsp" %>

<!-- ==================== PAGE HEADER ==================== -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Graphing Calculator Online</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                Graphing Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">Calculus Built-In</span>
            <span class="tool-badge">50+ Presets</span>
        </div>
    </div>
</header>

<!-- ==================== HERO / DESCRIPTION + AD ==================== -->
<section class="tool-description-section gc-desc-section" style="background:var(--gc-light);">
    <div class="tool-description-inner" style="gap:0.375rem;">
        <div class="tool-description-content">
            <p style="margin:0;">Free <strong>online graphing calculator</strong> &mdash; plot functions, <strong>3D surfaces</strong>, <strong>derivatives</strong>, <strong>integrals</strong>, <strong>limits</strong>, polar, parametric, equations, and inequalities. Auto-detects your input type. Built-in CAS for symbolic calculus, 50+ presets, sliders, animation. A powerful <strong>Desmos alternative</strong> &mdash; no signup, works on any device.</p>
        </div>
    </div>
    <div style="max-width:1400px;margin:0.25rem auto 0;padding:0 0.5rem;">
        <%@ include file="modern/ads/ad-hero-banner.jsp" %>
    </div>
</section>

<!-- ==================== TWO-COLUMN LAYOUT ==================== -->
<main class="tool-page-container gc-page-container">

    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">

        <!-- Expressions Card -->
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--gc-gradient);"><i class="fas fa-chart-line" style="margin-right:0.375rem;"></i> Expressions</div>
            <div class="tool-card-body">
                <div id="expressions-list"></div>
                <div class="d-flex gap-2 flex-wrap">
                    <button class="gc-btn-add" onclick="addExpression()">
                        <i class="fas fa-plus"></i> Add Expression
                    </button>
                    <button class="gc-btn-add" onclick="addFolder()" style="background:#f0f0f0;color:#555;border:1px dashed #ccc;" title="Group expressions into a collapsible folder">
                        <i class="fas fa-folder-plus"></i> Folder
                    </button>
                </div>
            </div>
        </div>

        <!-- Presets Card (collapsible, open by default) -->
        <div class="tool-card" style="margin-top:0.5rem;">
            <div class="tool-section-header" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('hidden');" style="color:var(--gc-tool);">
                <span><i class="fas fa-wand-magic-sparkles" style="margin-right:0.375rem;"></i> Presets &amp; Examples</span>
                <span class="chevron">&#9660;</span>
            </div>
            <div class="tool-section-content">
                <!-- Top picks: visible immediately -->
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Quick Start</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickSample('cartesian')">sin(x)</button>
                        <button class="gc-preset-chip" onclick="gcQuickSample('parametric')">Parametric</button>
                        <button class="gc-preset-chip" onclick="gcQuickSample('polar')">Polar</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('circle_line')">Circle + Line</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('heart')">Heart</button>
                    </div>
                </div>
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Calculus</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickPreset('antiderivative_poly')">∫ x&sup2; dx</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('antiderivative_trig')">∫ Trig</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('ftc_demo')">FTC Demo</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('limit_sinx_x')">lim sin(x)/x</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('limit_rational')">lim (x&sup2;-1)/(x-1)</button>
                    </div>
                </div>
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Systems of Equations</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickPreset('linear_system')">Linear 2&times;2</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('circle_line_system')">Circle + Line</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('parabola_line')">Parabola + Line</button>
                    </div>
                </div>

                <!-- More presets: hidden until toggled -->
                <div id="gc-more-presets" style="display:none;">
                    <div class="gc-preset-category">
                        <div class="gc-preset-category-label">More Systems</div>
                        <div class="gc-preset-chips">
                            <button class="gc-preset-chip" onclick="gcQuickPreset('two_circles')">Two Circles</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('ellipse_line')">Ellipse + Line</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('hyperbola_line')">Hyperbola + Line</button>
                        </div>
                    </div>
                    <div class="gc-preset-category">
                        <div class="gc-preset-category-label">More Calculus</div>
                        <div class="gc-preset-chips">
                            <button class="gc-preset-chip" onclick="gcQuickPreset('antiderivative_exp')">∫ eˣ dx</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('limit_exp_minus1')">lim (eˣ-1)/x</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('piece_deriv_integral')">Piecewise+Calc</button>
                        </div>
                    </div>
                    <div class="gc-preset-category">
                        <div class="gc-preset-category-label">Multi-Expression</div>
                        <div class="gc-preset-chips">
                            <button class="gc-preset-chip" onclick="gcQuickPreset('sin_cos')">Sin + Cos</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('polar_flowers')">Polar Flowers</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('band_inequality')">Inequality</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('data_vs_fit')">Data + Fit</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('logistic_exp')">Logistic vs Exp</button>
                        </div>
                    </div>
                    <div class="gc-preset-category">
                        <div class="gc-preset-category-label">Creative Curves</div>
                        <div class="gc-preset-chips">
                            <button class="gc-preset-chip" onclick="gcQuickPreset('spirograph')">Spirograph</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('lissajous')">Lissajous</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('astroid')">Astroid</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('cardioid')">Cardioid</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('golden_spiral')">Golden Spiral</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('cycloid')">Cycloid</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('butterfly')">Butterfly</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('limacon')">Lima&ccedil;on</button>
                        </div>
                    </div>
                    <div class="gc-preset-category">
                        <div class="gc-preset-category-label">Advanced</div>
                        <div class="gc-preset-chips">
                            <button class="gc-preset-chip" onclick="gcQuickPreset('rose_curves')">Rose Curves</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('fourier_square')">Fourier Square</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('quad_regression')">Regression</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('spirals')">Spirals</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('distributions_overlay')">Distributions</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('lemniscate')">Lemniscate</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('deltoid')">Deltoid</button>
                        </div>
                    </div>
                    <div class="gc-preset-category">
                        <div class="gc-preset-category-label">Physics &amp; Science</div>
                        <div class="gc-preset-chips">
                            <button class="gc-preset-chip" onclick="gcQuickPreset('damped_oscillation')">Damped Osc.</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('catenary')">Catenary</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('wave_interference')">Wave Interf.</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('projectile')">Projectile</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('pendulum_phase')">Pendulum</button>
                        </div>
                    </div>
                    <div class="gc-preset-category">
                        <div class="gc-preset-category-label">Classic &amp; Historical</div>
                        <div class="gc-preset-chips">
                            <button class="gc-preset-chip" onclick="gcQuickPreset('witch_agnesi')">Witch of Agnesi</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('folium')">Folium</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('cissoid')">Cissoid</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('tractrix')">Tractrix</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('nephroid')">Nephroid</button>
                        </div>
                    </div>
                    <div class="gc-preset-category">
                        <div class="gc-preset-category-label">Machine Learning</div>
                        <div class="gc-preset-chips">
                            <button class="gc-preset-chip" onclick="gcQuickPreset('activation_functions')">Activations</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('sigmoid_tanh')">Sigmoid/Tanh</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('relu_variants')">ReLU Variants</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('loss_functions')">Loss Fns</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('gradient_descent')">Grad Descent</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('gaussian_distributions')">Gaussians</button>
                            <button class="gc-preset-chip" onclick="gcQuickPreset('vanishing_gradient')">Vanish Grad</button>
                        </div>
                    </div>
                </div>

                <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                    <button class="gc-preset-chip" style="flex:1;" onclick="var m=document.getElementById('gc-more-presets');var b=this;if(m.style.display==='none'){m.style.display='block';b.textContent='Show less';}else{m.style.display='none';b.textContent='More presets...';}">More presets...</button>
                    <button class="gc-preset-chip" style="border-color:#dc3545;color:#dc3545;" onclick="gcClearAll()"><i class="fas fa-broom"></i> Clear</button>
                </div>
            </div>
        </div>

        <!-- Graph Settings Card (collapsible, collapsed by default) -->
        <div class="tool-card" style="margin-top:0.5rem;">
            <div class="tool-section-header collapsed" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('hidden');" style="color:var(--gc-tool);">
                <span><i class="fas fa-cog" style="margin-right:0.375rem;"></i> Graph Settings</span>
                <span class="chevron">&#9660;</span>
            </div>
            <div class="tool-section-content hidden">
                <div class="tool-form-group" style="margin-bottom:0.5rem;">
                    <label class="tool-form-label">X Range</label>
                    <div style="display:flex;gap:0.5rem;">
                        <input type="number" class="tool-input" id="xMin" value="-10" placeholder="Min" style="text-align:center;">
                        <input type="number" class="tool-input" id="xMax" value="10" placeholder="Max" style="text-align:center;">
                    </div>
                </div>
                <div class="tool-form-group" style="margin-bottom:0.5rem;">
                    <label class="tool-form-label">Y Range</label>
                    <div style="display:flex;gap:0.5rem;">
                        <input type="number" class="tool-input" id="yMin" value="-10" placeholder="Min" style="text-align:center;">
                        <input type="number" class="tool-input" id="yMax" value="10" placeholder="Max" style="text-align:center;">
                    </div>
                </div>
                <div style="display:flex;gap:1rem;margin-bottom:0.5rem;">
                    <label class="tool-checkbox">
                        <input type="checkbox" id="showGrid" checked onchange="updateGraph()"> Show Grid
                    </label>
                    <label class="tool-checkbox">
                        <input type="checkbox" id="showLegend" checked onchange="updateGraph()"> Legend
                    </label>
                </div>
                <div class="gc-sidebar-actions" style="margin-top:0.5rem;">
                    <button class="gc-action-btn" onclick="findIntersections()"><i class="fas fa-project-diagram"></i> Intersections</button>
                    <button class="gc-action-btn" onclick="areaBetweenCurves()"><i class="fas fa-fill-drip"></i> Area Between</button>
                    <button class="gc-action-btn" onclick="solveEquation()"><i class="fas fa-calculator"></i> Solve f(x)=0</button>
                    <button class="gc-action-btn" onclick="toggleTableOfValues()"><i class="fas fa-table"></i> Table</button>
                    <button class="gc-action-btn" onclick="textToGraph()"><i class="fas fa-font"></i> Text to Graph</button>
                    <button class="gc-action-btn" onclick="updateGraph()"><i class="fas fa-refresh"></i> Apply Range</button>
                </div>
            </div>
        </div>

        <!-- Share & Export Card (collapsible, collapsed by default) -->
        <div class="tool-card" style="margin-top:0.5rem;">
            <div class="tool-section-header collapsed" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('hidden');" style="color:var(--gc-tool);">
                <span><i class="fas fa-share-nodes" style="margin-right:0.375rem;"></i> Share &amp; Export</span>
                <span class="chevron">&#9660;</span>
            </div>
            <div class="tool-section-content hidden">
                <div class="gc-sidebar-actions">
                    <button class="gc-action-btn" onclick="generateShareableLink()"><i class="fas fa-link"></i> Copy Share Link</button>
                    <button class="gc-action-btn" onclick="showEmbedCode()" style="border-color:var(--gc-tool);color:var(--gc-tool);"><i class="fas fa-code"></i> Embed on Your Site</button>
                    <button class="gc-action-btn" onclick="exportAsPNG()"><i class="fas fa-image"></i> Download PNG</button>
                    <button class="gc-action-btn" onclick="exportAsSVG()"><i class="fas fa-file-code"></i> Download SVG</button>
                </div>
            </div>
        </div>

        <!-- My Graphs Card (collapsible, collapsed by default) -->
        <div class="tool-card" style="margin-top:0.5rem;">
            <div class="tool-section-header collapsed" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('hidden');" style="color:var(--gc-tool);">
                <span><i class="fas fa-folder-open" style="margin-right:0.375rem;"></i> My Graphs</span>
                <span class="chevron">&#9660;</span>
            </div>
            <div class="tool-section-content hidden">
                <div class="gc-sidebar-actions">
                    <button class="gc-action-btn" onclick="saveExpressionSet()"><i class="fas fa-save"></i> Save Current</button>
                    <button class="gc-action-btn" onclick="loadExpressionSet()"><i class="fas fa-upload"></i> Load Saved</button>
                    <button class="gc-action-btn" onclick="manageSavedSets()"><i class="fas fa-trash-can"></i> Manage</button>
                </div>
                <p style="font-size:0.7rem;color:var(--text-tertiary,#9ca3af);margin:0.5rem 0 0;">Saved to your browser&apos;s local storage.</p>
            </div>
        </div>

        <!-- Quick Guide Card (collapsible, collapsed by default) -->
        <div class="tool-card" style="margin-top:0.5rem;">
            <div class="tool-section-header collapsed" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('hidden');" style="color:var(--gc-tool);">
                <span><i class="fas fa-info-circle" style="margin-right:0.375rem;"></i> Quick Guide</span>
                <span class="chevron">&#9660;</span>
            </div>
            <div class="tool-section-content hidden">
                <div class="gc-quick-guide">
                    <strong>Plot Types:</strong><br>
                    y = f(x): x^2, sin(x)<br>
                    Equation: 2x+3y=8, x&sup2;+y&sup2;=25<br>
                    Parametric: cos(t), sin(t)<br>
                    Polar: r = 2*cos(&theta;)<br>
                    Limit: sin(x)/x as x&rarr;0<br>
                    Inequality: y &gt; x^2<br><br>
                    <strong>Smart Input:</strong><br>
                    Type any equation &mdash; auto-detects type<br>
                    f'(x) / f''(x) / Min/Max / Inflect toggles<br>
                    Domain restrict: x^2 {x &gt; 0}<br>
                    Use a,b,c for auto parameter sliders<br>
                    Trace Mode: click for pinned coordinates<br><br>
                    <strong>Functions:</strong><br>
                    Trig: sin, cos, tan, asin, acos, atan<br>
                    Logs: log (ln), log10, exp<br>
                    Powers: sqrt, cbrt, x^n<br>
                    Constants: pi, e
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <div class="gc-graph-card">
            <div class="gc-graph-toolbar">
                <span class="gc-graph-toolbar-title"><i class="fas fa-chart-line"></i> Graph</span>
                <div class="gc-graph-toolbar-actions">
                    <button class="gc-toolbar-btn" onclick="resetView()" title="Reset View"><i class="fas fa-sync"></i></button>
                    <button class="gc-toolbar-btn" onclick="toggleTraceMode()" title="Trace Mode"><i class="fas fa-crosshairs"></i></button>
                    <button class="gc-toolbar-btn" onclick="exportAsPNG()" title="Download PNG"><i class="fas fa-image"></i></button>
                    <button class="gc-toolbar-btn" onclick="generateShareableLink()" title="Share Link"><i class="fas fa-link"></i></button>
                </div>
            </div>
            <div id="graph"><div class="gc-graph-placeholder" id="gc-graph-placeholder"><i class="fas fa-chart-line" style="margin-right:0.5rem;"></i> Loading graphing engine&hellip;</div></div>
        </div>
    </div>

</main>

<!-- Embed Code Modal -->
<div id="gc-embed-modal" style="display:none;position:fixed;inset:0;z-index:9999;background:rgba(0,0,0,0.5);align-items:center;justify-content:center;">
    <div style="background:var(--surface-primary,#fff);border-radius:12px;max-width:640px;width:90%;max-height:85vh;overflow-y:auto;padding:1.5rem;box-shadow:0 20px 60px rgba(0,0,0,0.3);position:relative;">
        <button onclick="document.getElementById('gc-embed-modal').style.display='none'" style="position:absolute;top:12px;right:12px;background:none;border:none;font-size:1.25rem;cursor:pointer;color:var(--text-secondary,#6b7280);">&times;</button>
        <h3 style="margin:0 0 1rem;font-size:1.1rem;"><i class="fas fa-code" style="color:var(--gc-tool);margin-right:0.5rem;"></i>Embed Graphing Calculator</h3>

        <div style="margin-bottom:1rem;">
            <label style="font-size:0.8rem;font-weight:500;display:block;margin-bottom:0.25rem;">Options</label>
            <div style="display:flex;flex-wrap:wrap;gap:0.5rem;">
                <label style="font-size:0.8rem;"><input type="checkbox" id="embed-opt-inputs" checked onchange="updateEmbedPreview()"> Show input panel</label>
                <label style="font-size:0.8rem;"><input type="checkbox" id="embed-opt-grid" checked onchange="updateEmbedPreview()"> Show grid</label>
                <label style="font-size:0.8rem;"><input type="checkbox" id="embed-opt-legend" checked onchange="updateEmbedPreview()"> Show legend</label>
                <label style="font-size:0.8rem;"><input type="checkbox" id="embed-opt-dark" onchange="updateEmbedPreview()"> Dark theme</label>
            </div>
        </div>

        <div style="margin-bottom:1rem;">
            <label style="font-size:0.8rem;font-weight:500;display:block;margin-bottom:0.25rem;">Size</label>
            <div style="display:flex;gap:0.5rem;align-items:center;">
                <input type="number" id="embed-width" value="800" style="width:80px;padding:4px 8px;border:1px solid #e5e7eb;border-radius:4px;font-size:0.8rem;" onchange="updateEmbedPreview()">
                <span style="font-size:0.8rem;">&times;</span>
                <input type="number" id="embed-height" value="500" style="width:80px;padding:4px 8px;border:1px solid #e5e7eb;border-radius:4px;font-size:0.8rem;" onchange="updateEmbedPreview()">
                <span style="font-size:0.75rem;color:#6b7280;">px (or use 100% for responsive)</span>
            </div>
        </div>

        <div style="margin-bottom:0.75rem;">
            <label style="font-size:0.8rem;font-weight:500;display:block;margin-bottom:0.25rem;">Embed Code</label>
            <textarea id="embed-code-output" readonly onclick="this.select()" style="width:100%;height:80px;font-family:'JetBrains Mono',monospace;font-size:0.75rem;padding:0.5rem;border:1px solid #e5e7eb;border-radius:6px;resize:vertical;background:#f9fafb;"></textarea>
        </div>

        <div style="display:flex;gap:0.5rem;">
            <button onclick="copyEmbedCode()" style="flex:1;padding:8px 16px;background:var(--gc-gradient);color:#fff;border:none;border-radius:6px;cursor:pointer;font-size:0.85rem;font-weight:500;"><i class="fas fa-copy"></i> Copy Code</button>
            <button onclick="document.getElementById('gc-embed-modal').style.display='none'" style="padding:8px 16px;background:none;border:1px solid #e5e7eb;border-radius:6px;cursor:pointer;font-size:0.85rem;">Close</button>
        </div>

        <div style="margin-top:1rem;padding-top:0.75rem;border-top:1px solid #e5e7eb;">
            <p style="font-size:0.75rem;color:#6b7280;margin:0 0 0.5rem;"><strong>postMessage API</strong> &mdash; control the embed from your page:</p>
            <pre style="font-size:0.7rem;background:#f1f5f9;padding:0.5rem;border-radius:4px;overflow-x:auto;margin:0;"><code>// Set expression
iframe.contentWindow.postMessage({
  action: 'setExpression',
  expr: 'sin(x)', type: 'cartesian'
}, '*');

// Load a preset
iframe.contentWindow.postMessage({
  action: 'loadPreset', preset: 'heart'
}, '*');

// Add another expression
iframe.contentWindow.postMessage({
  action: 'addExpression',
  expr: 'cos(x)', type: 'cartesian'
}, '*');

// Change range
iframe.contentWindow.postMessage({
  action: 'setRange',
  xmin: -5, xmax: 5, ymin: -5, ymax: 5
}, '*');

// Listen for ready event
window.addEventListener('message', (e) => {
  if (e.data.type === 'graphReady') {
    console.log('Calculator loaded!');
  }
});</code></pre>
        </div>
    </div>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="graphing-calculator.jsp"/>
    <jsp:param name="keyword" value="math"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ==================== FEATURES & HOW TO USE ==================== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:0.75rem auto;padding:0 0.5rem;" id="features">
    <div class="tool-card" style="padding:0.75rem;margin-bottom:0;">
        <h2 style="font-size:1.1rem;margin-bottom:0.75rem;">All Features &amp; How to Use</h2>

        <!-- ── Expression Types ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Expression Types</h3>
        <p style="font-size:0.82rem;line-height:1.5;margin-bottom:0.5rem;">Type any expression and the calculator <strong>auto-detects</strong> the type. You can also pick the type manually from the dropdown.</p>
        <table style="width:100%;font-size:0.8rem;border-collapse:collapse;margin-bottom:0.75rem;">
            <thead><tr style="background:#f8f9fa;text-align:left;">
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Type</th>
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Example Input</th>
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">What It Does</th>
            </tr></thead>
            <tbody>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Cartesian</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>x^2</code>, <code>sin(x)</code>, <code>y = 2x+1</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Plots y = f(x) curves. Supports domain restrictions like <code>x^2 {x &gt; 0}</code></td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Equation</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>x^2+y^2=25</code>, <code>y^2=4ax</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Solves symbolically via CAS &mdash; circles, ellipses, parabolas, any implicit curve</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Parametric</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>cos(t), sin(t)</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Plots x(t) and y(t) as a curve. Uses variable <code>t</code></td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Polar</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>2+2*cos(theta)</code>, <code>sin(3*&theta;)</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Plots r = f(&theta;). Type <code>theta</code> or use &theta;</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Inequality</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>y &gt; x^2</code>, <code>x+y &lt;= 5</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Shades the region satisfying the inequality</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Piecewise</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>x&lt;0: -x, x&gt;=0: x^2</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Define different formulas for different domains</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Limit</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>sin(x)/x</code> at x&rarr;0</td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Computes the limit symbolically and annotates it on the graph</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>3D Surface</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>sin(x)*cos(y)</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Auto-detected when both x and y appear. Interactive WebGL 3D plot</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Point(s)</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>(2, 3)</code>, <code>[(1,2),(3,4)]</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Plot labeled scatter points. Also accepts <code>(1,2), (3,4)</code> without brackets</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Vector(s)</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>&lt;3, 4&gt;</code>, <code>&lt;2,3&gt; @ (1,1)</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Draw arrows from an origin. Use <code>@ (ox,oy)</code> to set the starting point</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Vector Field</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>&lt;-y, x&gt;</code>, <code>F(x,y) = &lt;x, -y&gt;</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Grid of arrows showing a 2D vector field. Presets: rotation, radial, vortex, wave</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Table</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">CSV data: <code>1,2 &bsol;n 3,4</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Plot raw x,y data from a table</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Regression</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">CSV data + type dropdown</td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Fit linear, quadratic, exponential, log, or power curves to your data</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;"><strong>Distribution</strong></td>
                <td style="padding:0.3rem 0.5rem;">Normal, Poisson, Binomial&hellip;</td>
                <td style="padding:0.3rem 0.5rem;">Plot probability distributions with adjustable parameters</td></tr>
            </tbody>
        </table>

        <!-- ── Calculus Toggles ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Calculus Toggles (Cartesian expressions)</h3>
        <p style="font-size:0.82rem;line-height:1.5;margin-bottom:0.4rem;">Each Cartesian expression has toggle checkboxes in its toolbar. Click any to enable:</p>
        <table style="width:100%;font-size:0.8rem;border-collapse:collapse;margin-bottom:0.75rem;">
            <thead><tr style="background:#f8f9fa;text-align:left;">
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Toggle</th>
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">What It Shows</th>
            </tr></thead>
            <tbody>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>f&apos;(x)</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">First derivative curve overlaid in a dashed line</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>f&apos;&apos;(x)</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Second derivative curve overlaid in a dotted line</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Min/Max</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Critical points (local minima and maxima) marked on the graph</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Inflect</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Inflection points where concavity changes</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>&int;</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Definite integral with shaded area. Set bounds <em>a</em> and <em>b</em>, choose Riemann sum method (left, midpoint, right, trapezoidal) and number of rectangles</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>F(x)</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Symbolic antiderivative computed by the CAS engine and plotted as a separate curve</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Table</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Editable table of values (Desmos-style). Type custom x-values, see computed y-values, and plot the points on the graph. Works for all expression types including polar and parametric</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Zeros</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Finds and marks the roots (x-intercepts) of the function as green markers with coordinates</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>V.Asym</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Detects vertical asymptotes (where f(x) &rarr; &pm;&infin;) and draws red dashed lines</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>Tangent</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Draws a tangent line at a specified x-value. Enter the x-coordinate and see the tangent line, slope, and point of tangency</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;"><strong>LaTeX</strong></td>
                <td style="padding:0.3rem 0.5rem;">Copies the expression as LaTeX notation to your clipboard (e.g., <code>\sin(x)</code>, <code>\frac{x}{2}</code>)</td></tr>
            </tbody>
        </table>

        <!-- ── Parameter Sliders ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Parameter Sliders &amp; Animation</h3>
        <ul style="font-size:0.82rem;line-height:1.6;margin:0 0 0.5rem 1.25rem;">
            <li>Type any single letter (except x, y, t, e) in your expression and a <strong>slider appears automatically</strong>. Example: <code>a*sin(b*x)</code> creates sliders for <code>a</code> and <code>b</code>.</li>
            <li>Click the <strong>&#9881; gear icon</strong> next to any slider to customize its <strong>min, max, and step</strong> values (default: &minus;10 to 10, step 0.1).</li>
            <li>Press the <strong>&#9654; play button</strong> to animate the first parameter. Choose speed: Slow, Normal, or Fast. The animation respects your custom slider range.</li>
            <li>Sliders work for <strong>all expression types</strong>: Cartesian, polar, parametric, equation, and even vector fields.</li>
        </ul>

        <!-- ── Function Composition ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Function Composition</h3>
        <p style="font-size:0.82rem;line-height:1.5;margin-bottom:0.4rem;">Define named functions and compose them across expressions:</p>
        <ol style="font-size:0.82rem;line-height:1.6;margin:0 0 0.5rem 1.25rem;">
            <li>In expression 1, type: <code>f(x) = x^2</code> &mdash; this defines f and plots x&sup2;</li>
            <li>In expression 2, type: <code>f(f(x))</code> &mdash; this auto-resolves to x&#8308; and plots it</li>
            <li>You can also define <code>g(x) = sin(x)</code> and then use <code>f(g(x))</code> to get sin&sup2;(x)</li>
        </ol>
        <p style="font-size:0.8rem;color:#6b7280;">Tip: the function definition both defines the name and plots the RHS. Composition works up to 10 nesting levels.</p>

        <!-- ── Summation, Product, Fourier ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Summation, Product &amp; Fourier Series</h3>
        <table style="width:100%;font-size:0.8rem;border-collapse:collapse;margin-bottom:0.75rem;">
            <thead><tr style="background:#f8f9fa;text-align:left;">
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Syntax</th>
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Example</th>
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Description</th>
            </tr></thead>
            <tbody>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>sum(var, start, end, body)</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>sum(n, 1, 10, x^n/factorial(n))</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">&Sigma; summation. Body can contain both the loop variable and x (plotted as a function of x)</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><strong>prod(var, start, end, body)</strong></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>prod(k, 1, 5, 1-x/k)</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">&Pi; product notation. Same rules as sum</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;"><strong>fourier(f(x), N)</strong></td>
                <td style="padding:0.3rem 0.5rem;"><code>fourier(x, 5)</code></td>
                <td style="padding:0.3rem 0.5rem;">Computes and plots the first N terms of the Fourier series approximation of f(x) on [&minus;&pi;, &pi;]</td></tr>
            </tbody>
        </table>

        <!-- ── Vectors ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Vectors &amp; Vector Fields</h3>
        <table style="width:100%;font-size:0.8rem;border-collapse:collapse;margin-bottom:0.75rem;">
            <thead><tr style="background:#f8f9fa;text-align:left;">
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Input</th>
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Result</th>
            </tr></thead>
            <tbody>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>&lt;3, 4&gt;</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Arrow from origin (0,0) with direction (3,4), with arrowhead</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>&lt;2, 3&gt; @ (1, 1)</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Arrow starting from point (1,1) instead of origin</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>&lt;1,0&gt;, &lt;0,1&gt;, &lt;1,1&gt;</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Multiple vectors drawn from the same origin</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>&lt;-y, x&gt;</code></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Vector field: 15&times;15 grid of arrows showing the rotation field</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;"><code>F(x,y) = &lt;x^2, -x*y&gt;</code></td>
                <td style="padding:0.3rem 0.5rem;">Named vector field with explicit F(x,y) prefix</td></tr>
            </tbody>
        </table>

        <!-- ── Trace Mode ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Trace Mode &amp; Annotations</h3>
        <ul style="font-size:0.82rem;line-height:1.6;margin:0 0 0.5rem 1.25rem;">
            <li>Click the <strong>crosshair icon</strong> in the graph toolbar to enable Trace Mode.</li>
            <li>Hover over any curve to see <strong>exact coordinates and slope (dy/dx)</strong> with a crosshair.</li>
            <li>Click on a point to <strong>pin an annotation</strong> that stays on the graph.</li>
            <li>Press <strong>Escape</strong> to exit trace mode.</li>
        </ul>

        <!-- ── Keyboard Shortcuts ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Keyboard Shortcuts</h3>
        <table style="width:100%;font-size:0.8rem;border-collapse:collapse;margin-bottom:0.75rem;">
            <thead><tr style="background:#f8f9fa;text-align:left;">
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Shortcut</th>
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Action</th>
            </tr></thead>
            <tbody>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><kbd style="background:#f3f4f6;padding:0.1rem 0.3rem;border-radius:3px;border:1px solid #d1d5db;font-size:0.75rem;">Ctrl+Z</kbd> / <kbd style="background:#f3f4f6;padding:0.1rem 0.3rem;border-radius:3px;border:1px solid #d1d5db;font-size:0.75rem;">&#8984;Z</kbd></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Undo last expression add/delete/change (when not typing in an input)</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><kbd style="background:#f3f4f6;padding:0.1rem 0.3rem;border-radius:3px;border:1px solid #d1d5db;font-size:0.75rem;">Ctrl+Shift+Z</kbd> / <kbd style="background:#f3f4f6;padding:0.1rem 0.3rem;border-radius:3px;border:1px solid #d1d5db;font-size:0.75rem;">&#8984;Y</kbd></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Redo</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><kbd style="background:#f3f4f6;padding:0.1rem 0.3rem;border-radius:3px;border:1px solid #d1d5db;font-size:0.75rem;">Ctrl+Enter</kbd> / <kbd style="background:#f3f4f6;padding:0.1rem 0.3rem;border-radius:3px;border:1px solid #d1d5db;font-size:0.75rem;">&#8984;Enter</kbd></td>
                <td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Add a new expression</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;"><kbd style="background:#f3f4f6;padding:0.1rem 0.3rem;border-radius:3px;border:1px solid #d1d5db;font-size:0.75rem;">Escape</kbd></td>
                <td style="padding:0.3rem 0.5rem;">Exit trace mode</td></tr>
            </tbody>
        </table>

        <!-- ── Expression Folders ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Expression Folders</h3>
        <ul style="font-size:0.82rem;line-height:1.6;margin:0 0 0.5rem 1.25rem;">
            <li>Click the <strong>Folder</strong> button to create a collapsible group for organizing related expressions.</li>
            <li>Each folder has a <strong>custom name</strong> (click the name to edit), a <strong>+</strong> button to add expressions inside, and a toggle to collapse/expand.</li>
            <li>Removing a folder deletes all expressions inside it. This action is undoable with <kbd style="background:#f3f4f6;padding:0.1rem 0.3rem;border-radius:3px;border:1px solid #d1d5db;font-size:0.75rem;">Ctrl+Z</kbd>.</li>
        </ul>

        <!-- ── Export & Sharing ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Export &amp; Sharing</h3>
        <ul style="font-size:0.82rem;line-height:1.6;margin:0 0 0.5rem 1.25rem;">
            <li><strong>PNG / SVG export</strong> &mdash; download the graph as an image via the Plotly toolbar (camera icon).</li>
            <li><strong>Share URL</strong> &mdash; click &ldquo;Share&rdquo; to generate a link that encodes all expressions, colors, and axis settings in the URL.</li>
            <li><strong>Embed</strong> &mdash; generate an iframe embed code for embedding the graph in a website or blog.</li>
            <li><strong>Copy as LaTeX</strong> &mdash; click the &ldquo;LaTeX&rdquo; button on any expression to copy it as LaTeX notation to your clipboard.</li>
        </ul>

        <!-- ── Math Input Tips ── -->
        <h3 style="font-size:0.95rem;margin:0.75rem 0 0.4rem;color:#4f46e5;border-bottom:1px solid #e5e7eb;padding-bottom:0.25rem;">Math Input Tips</h3>
        <table style="width:100%;font-size:0.8rem;border-collapse:collapse;margin-bottom:0.5rem;">
            <thead><tr style="background:#f8f9fa;text-align:left;">
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">You Type</th>
                <th style="padding:0.35rem 0.5rem;border-bottom:2px solid #e5e7eb;">Interpreted As</th>
            </tr></thead>
            <tbody>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>2x</code></td><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">2*x (implicit multiplication)</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>xy</code></td><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">x*y</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>2(x+1)</code></td><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">2*(x+1)</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>2sin(x)</code></td><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">2*sin(x)</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>e^x</code></td><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">exp(x)</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>ln(x)</code></td><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">log(x) (natural log)</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>|x|</code></td><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">abs(x)</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>&pi;</code> or <code>pi</code></td><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">&pi; &asymp; 3.14159</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;"><code>&theta;</code> or <code>theta</code></td><td style="padding:0.3rem 0.5rem;border-bottom:1px solid #f0f0f0;">Polar angle variable</td></tr>
            <tr><td style="padding:0.3rem 0.5rem;"><code>x^2 {x &gt; 0}</code></td><td style="padding:0.3rem 0.5rem;">Domain restriction: plot only where x &gt; 0</td></tr>
            </tbody>
        </table>
        <p style="font-size:0.8rem;color:#6b7280;margin:0;">A live <strong>KaTeX math preview</strong> renders below each input as you type, so you can verify the expression is parsed correctly.</p>
    </div>
</section>

<!-- ==================== VISIBLE FAQ SECTION ==================== -->
<section class="tool-expertise-section gc-faq-section" style="max-width:1200px;margin:0.75rem auto;padding:0 0.5rem;">
    <div class="tool-card gc-faq-card" style="padding:0.75rem;margin-bottom:0;">
        <h2 style="font-size:1rem;margin-bottom:0.5rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What types of graphs can this calculator plot?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">This graphing calculator supports <strong>8 plot types</strong>: Cartesian functions y=f(x) like sin(x) and x&sup2;, equations solved symbolically such as x&sup2;+y&sup2;=25 or 2x+3y=8, parametric curves x(t) &amp; y(t), polar graphs r=f(&theta;), <strong>limits with visual annotations</strong>, piecewise functions, inequalities with shaded regions, and statistical distributions. Just type any expression &mdash; it <strong>auto-detects the type</strong>.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I graph derivatives, integrals, and antiderivatives?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">For any Cartesian function, use the <strong>calculus toggles</strong> next to the expression input. Toggle <strong>f&apos;(x)</strong> to overlay the derivative curve, click <strong>&int;</strong> to shade the area under the curve with adjustable <em>a</em> and <em>b</em> bounds, or toggle <strong>F(x)</strong> to plot the symbolic antiderivative computed by the built-in CAS engine (Nerdamer). All three can be shown simultaneously on the same graph.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How does the limit calculator work on the graph?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Select the <strong>Limit</strong> type from the dropdown, enter a function like <code>sin(x)/x</code>, and set the approach value (e.g., 0). The calculator uses a <strong>symbolic CAS</strong> to compute the exact limit, plots the function, and annotates the limit point with an open circle marker, a dashed horizontal line at y=L, and a dotted vertical line at x=a. Try the built-in presets: lim sin(x)/x &rarr; 1, lim (e<sup>x</sup>&minus;1)/x &rarr; 1, lim (x&sup2;&minus;1)/(x&minus;1) &rarr; 2.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can I solve systems of equations and find intersections?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes. Add multiple equations such as <code>y=x&sup2;</code> and <code>y=2x+3</code> and the calculator graphs both curves. Use the <strong>Intersections</strong> button to find where they cross. The Equation type uses <strong>Nerdamer CAS</strong> to solve any equation symbolically, including circles, ellipses, hyperbolas, and higher-degree polynomials. Over 15 system presets are built in, from linear 2&times;2 to circle+line and parabola+line.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Does it support parameter sliders and animation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes. Type any single letter like <code>a</code>, <code>b</code>, or <code>c</code> in your expression and a <strong>slider appears automatically</strong>. Drag to change the parameter in real time. Press the play button to animate and watch the graph evolve continuously. This works for all plot types including polar, parametric, and implicit equations.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What are the 50+ built-in presets?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Presets are organized by category: <strong>Quick Start</strong> (sin, parametric, polar), <strong>Calculus</strong> (antiderivative of x&sup2;, FTC demo, limit sin(x)/x), <strong>Systems of Equations</strong> (linear 2&times;2, circle+line, parabola+line), <strong>Creative Curves</strong> (spirograph, lissajous, butterfly, cardioid, golden spiral), <strong>Physics</strong> (damped oscillation, projectile, wave interference), <strong>Machine Learning</strong> (activation functions, loss functions, gradient descent, Gaussians), and <strong>Classic &amp; Historical</strong> curves (Witch of Agnesi, folium, cissoid, nephroid). Click any preset chip to load instantly.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this graphing calculator really free? What are the limits?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">100% free with <strong>no signup</strong>, no usage limits, and no ads blocking the graph area. All computation runs entirely in your browser using Math.js, Plotly.js, Nerdamer CAS, and KaTeX. Export graphs as PNG or SVG, save expression sets to local storage, or <strong>generate shareable URLs</strong> to send to classmates or colleagues. Works on desktop, tablet, and mobile.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How does auto-detect work for expression types?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The calculator analyzes your input <strong>as you type</strong>. If you enter an equation with <code>y</code> and an equals sign like <code>2x+3y=8</code>, it automatically switches to Equation mode and solves symbolically. If you type an inequality like <code>y &gt; x&sup2;</code>, it switches to Inequality mode with shaded regions. Plain expressions like <code>sin(x)</code> stay in Cartesian y=f(x) mode. You can always override by selecting the type manually from the dropdown. A <strong>live KaTeX math preview</strong> shows the rendered expression as you type.</div>
        </div>
    </div>
</section>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>

<!-- ==================== SCRIPT LOADING STRATEGY ====================
     Stage 1: Math.js + Plotly (core — needed for first graph render)
     Stage 2: Engine + Presets (depends on Stage 1)
     Stage 3: Nerdamer + KaTeX (deferred — needed on user interaction only)
     Stage 4: Utilities (dark mode, search — lowest priority)
     ================================================================= -->

<!-- Nerdamer fix: set before any Nerdamer code loads -->
<script>if (typeof window.i === 'undefined') window.i = NaN;</script>

<!-- Dark mode bridge: runs before graph init so first paint uses correct theme -->
<script>
(function(){
  function syncDark(){
    var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    window.GC_DARK = isDark;
    try{ if (typeof updateGraph === 'function') updateGraph(); }catch(_){}
  }
  new MutationObserver(syncDark).observe(document.documentElement, {attributes:true, attributeFilter:['data-theme']});
  syncDark();
})();
</script>

<!-- Stage 1: Math.js + Plotly + Nerdamer load in parallel (all needed before engine) -->
<script>
(function(){
  var ph = document.getElementById('gc-graph-placeholder');
  var loaded = { math: false, plotly: false, nerdamer: false };

  function checkReady() {
    if (!loaded.math || !loaded.plotly || !loaded.nerdamer) return;
    // Stage 2: Load engine + presets (all dependencies ready)
    loadScript('<%=request.getContextPath()%>/js/graphing-tool-engine.js', function(){
      loadScript('<%=request.getContextPath()%>/js/graphing-calculator-presets.js?v=<%=cacheVersion%>', function(){
        if (ph) ph.remove();
        var g = document.getElementById('graph');
        if (g && typeof ResizeObserver !== 'undefined') {
          new ResizeObserver(function(){ try{ Plotly.Plots.resize('graph'); }catch(_){} }).observe(g);
        }
      });
    });
    // Stage 3: KaTeX + MathQuill (deferred — needed on user interaction only)
    loadScript('https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js', function(){
      loadScript('https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js');
    });
    // MathQuill needs jQuery
    if (!window.jQuery) {
      loadScript('https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js', function(){
        loadScript('https://cdn.jsdelivr.net/npm/mathquill@0.10.1/build/mathquill.min.js', function(){
          window.MQ = MathQuill.getInterface(2);
          if (typeof _initMathQuillFields === 'function') _initMathQuillFields();
        });
      });
    } else {
      loadScript('https://cdn.jsdelivr.net/npm/mathquill@0.10.1/build/mathquill.min.js', function(){
        window.MQ = MathQuill.getInterface(2);
        if (typeof _initMathQuillFields === 'function') _initMathQuillFields();
      });
    }
  }

  function loadScript(src, cb) {
    var s = document.createElement('script');
    s.src = src;
    s.async = true;
    s.setAttribute('data-cfasync', 'false');
    if (cb) s.onload = cb;
    s.onerror = function(){ console.warn('Failed to load: ' + src); if (cb) cb(); };
    document.body.appendChild(s);
  }

  // Load Math.js, Plotly, and Nerdamer core all in parallel
  loadScript('https://cdnjs.cloudflare.com/ajax/libs/mathjs/12.4.1/math.min.js', function(){
    loaded.math = true; checkReady();
  });
  loadScript('https://cdn.plot.ly/plotly-basic-2.27.0.min.js', function(){
    loaded.plotly = true; checkReady();
  });
  // Nerdamer: core → Algebra → Calculus → Solve (must be sequential — each extends the previous)
  loadScript('https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.min.js', function(){
    loadScript('https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.min.js', function(){
      loadScript('https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.min.js', function(){
        loadScript('https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Solve.min.js', function(){
          loaded.nerdamer = true; checkReady();
        });
      });
    });
  });

  // Show error if core libs fail
  setTimeout(function(){
    if (!loaded.math || !loaded.plotly) {
      if (ph) ph.innerHTML = '<span style="color:#dc3545;">Libraries failed to load. Check your network or disable script blockers.</span>';
    }
  }, 15000);
})();
</script>

<!-- Stage 4: Low-priority utilities -->
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
