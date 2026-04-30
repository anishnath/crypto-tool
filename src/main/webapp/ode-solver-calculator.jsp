<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        ODE Solver Calculator — math-studio shell (matches integral-calculator).
        Uses ic-stack / ic-hero / ic-result-card / ic-output-tabs / ic-panel /
        ic-hero-cta / ic-hero-methods / ic-worksheet-cta classes throughout
        for visual parity with integral / limit / matrix tools.

        Legacy ode-* IDs preserved verbatim so /modern/js/ode-solver-calculator.js
        continues to work without modification.  Tab / panel buttons carry BOTH
        the ic-* (styling) and ode-* (legacy JS hook) class names.

        Quick wins landed inline:
          1. y' / y'' / dy/dx → yp / ypp / yp normalization on input
          2. URL ?expr= / ?order= / ?mode= auto-fill on page load
          3. AI photo scan with ODE-specific extraction prompt
          4. Practice Worksheet CTA (existing 1,000+ bank)
          5. MathLive Visual/Text on the 3 expression inputs
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow,max-image-preview:large,max-snippet:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="author" content="Anish Nath">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="ODE Solver Calculator with Steps + AI Photo Scan" />
        <jsp:param name="toolDescription" value="Free AI ODE solver with step-by-step solutions, photo scan, and 1,000+ practice problems. Solve first-, second-, and higher-order differential equations with initial conditions. Separable, linear, Bernoulli, exact, Cauchy-Euler, Laplace transforms, direction fields. Snap a problem from your textbook or type any ODE — Symbolab-style smart input. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="ode-solver-calculator.jsp" />
        <jsp:param name="toolKeywords" value="differential equation calculator, ODE solver, ODE solver with steps, AI ODE solver, ODE solver scan image, ODE photo math, scan differential equation, snap ODE problem, photo math ODE, differential equation calculator with steps, ordinary differential equation solver, first order differential equation calculator, 2nd order ODE solver, higher order ODE solver, differential equation solver with initial conditions, initial value problem solver, IVP solver, homogeneous differential equation calculator, direction field calculator, slope field plotter, separable ODE, Bernoulli equation, exact equation, integrating factor, Cauchy-Euler equation solver, Laplace transform ODE solver, characteristic equation calculator, MathLive ODE editor, Symbolab style ODE calculator, differential equation worksheet, ODE practice problems, ODE worksheet with answers, differential equation practice worksheet, AP differential equations practice, ODE quiz generator, free ODE solver online, no signup ODE calculator" />
        <jsp:param name="educationalLevel" value="High School, AP Calculus, College, University, Graduate" />
        <jsp:param name="teaches" value="Ordinary differential equations, ODEs, initial value problems, separable equations, linear ODEs, Bernoulli equations, exact equations, homogeneous equations, higher-order differential equations, characteristic equations, direction fields, slope fields, solution verification, integrating factors, Cauchy-Euler equations, Laplace transform methods, power series solutions, Euler method" />
        <jsp:param name="howToSteps" value="Snap a photo OR type the ODE|Click the camera button to scan a problem from a photo or PDF (AI extracts the ODE and any initial conditions in one shot) OR type your equation directly using the visual MathLive editor with derivatives like y' (yp) and y'' (ypp).,Pick a mode|Choose 1st Order, Higher-Order (2nd-5th), or Direction Field. The mode-specific inputs appear automatically.,Optionally add initial conditions|Tick the IVP checkbox to enter y(x0)=y0 (and y'(x0)=y'0 for higher-order). The calculator solves the IVP exactly.,Click Solve|The calculator classifies the ODE (separable / linear / Bernoulli / exact / homogeneous / Cauchy-Euler) and shows a tutorial-grade solution with the matching method.,Review steps and graph|Switch to the Graph tab for the solution curve or direction field; Python tab for the editable SymPy code." />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="AI photo scan with step-by-step solver,MathLive visual ODE editor (Visual / Text toggle),y prime notation auto-normalized to calculator syntax,First-order ODE solver with classification,Higher-order ODE solver (2nd 3rd 4th 5th order),Direction field (slope field) plotter,Automatic ODE classification,Initial value problem (IVP) support,Solution verification,Interactive solution curve graphs,Live KaTeX math preview,Copy LaTeX Download PDF Share URL,Built-in Python compiler,1000+ ODE practice worksheet problems,Filter by 8+ question types and 4 difficulty levels,Dark mode no signup no limits free forever" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="Can I scan an ODE problem from a photo?" />
        <jsp:param name="faq1a" value="Yes. Click the green Scan button next to the equation input, upload a photo or PDF of your homework, and our AI extracts every ODE on the page along with any initial conditions. Pick one to fill the form and solve. Works on textbook pages, exam papers, and handwritten work." />
        <jsp:param name="faq2q" value="How do you solve a first-order ODE?" />
        <jsp:param name="faq2a" value="First identify the ODE type: separable, linear, Bernoulli, exact, or homogeneous. Then apply the appropriate method. For separable ODEs, separate variables and integrate both sides. For linear ODEs y'+P(x)y=Q(x), multiply by the integrating factor mu=e^(integral P dx). This calculator automatically classifies and solves first-order ODEs with full step-by-step working." />
        <jsp:param name="faq3q" value="Does this ODE solver support initial conditions (IVP)?" />
        <jsp:param name="faq3a" value="Yes. This calculator solves initial value problems (IVPs) — ODEs with initial conditions at a specific point. For first-order: y(x0)=y0. For second-order: y(x0)=y0 and y'(x0)=dy0. Initial conditions determine the unique particular solution from the general solution family." />
        <jsp:param name="faq4q" value="What is a direction field (slope field)?" />
        <jsp:param name="faq4a" value="A direction field is a graphical representation of a first-order ODE dy/dx=f(x,y). At each point (x,y) in the plane, a short line segment shows the slope f(x,y). The pattern of these segments reveals the qualitative behavior of solutions without solving the equation analytically." />
        <jsp:param name="faq5q" value="What ODE types can this calculator solve?" />
        <jsp:param name="faq5a" value="This calculator solves: separable, first-order linear, Bernoulli, exact, homogeneous, second-order constant coefficient (homogeneous and non-homogeneous), Cauchy-Euler, and many more. It automatically classifies the ODE type and applies the appropriate solution method." />
        <jsp:param name="faq6q" value="What is the difference between general and particular solutions?" />
        <jsp:param name="faq6a" value="A general solution contains arbitrary constants (C1, C2, etc.) and represents all possible solutions. A particular solution is obtained by applying initial conditions to determine specific values of these constants. First-order ODEs have one constant (C1), second-order have two (C1, C2)." />
        <jsp:param name="faq7q" value="Is this ODE solver calculator free?" />
        <jsp:param name="faq7a" value="Yes — 100 percent free, no signup, no daily limits. Includes step-by-step solutions, ODE classification, solution verification, interactive graphs, direction field plots, AI photo scan, MathLive visual input, 1,000+ practice worksheet problems with answer keys, and a built-in Python compiler." />
        <jsp:param name="faq8q" value="Does this ODE solver include practice worksheets?" />
        <jsp:param name="faq8a" value="Yes. This calculator includes a built-in worksheet generator with over 1,000 ODE practice problems. You can filter by 8+ question types (exact equations, Laplace transforms, Euler method, power series, Euler-Cauchy, Bernoulli, homogeneous substitutions, and systems of ODEs) and 4 difficulty levels. Each worksheet is randomly generated with a full answer key." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <!-- Shared site CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">

    <!-- Math shell — provides ALL ic-* classes (ic-hero, ic-result-card, ic-output-tabs, etc.) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=cacheVersion%>">

    <!-- Tool-specific CSS — kept for the legacy ode-* mode toggle, IC fields, formula table styling -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ode-solver-calculator.css?v=<%=cacheVersion%>">

    <!-- KaTeX + MathLive + image-to-math -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css?v=<%=cacheVersion%>">

    <style>
    /* Busy-spinner for the primary CTA — locks Solve while compute is in
       flight and adds a small spinner glyph so users know something is
       happening (the SymPy round-trip can take 1–3s). */
    .ic-hero-cta.is-busy {
        opacity: 0.65;
        cursor: progress;
        pointer-events: none;
    }
    .ic-hero-cta.is-busy::after {
        content: '';
        display: inline-block;
        margin-left: 0.6rem;
        width: 12px; height: 12px;
        border: 2px solid rgba(255,255,255,0.4);
        border-top-color: #fff;
        border-radius: 50%;
        animation: ode-cta-spin 0.7s linear infinite;
        vertical-align: middle;
    }
    @keyframes ode-cta-spin { to { transform: rotate(360deg); } }

    /* Hide the noisy three-badge row at the top of the result.  The legacy
       controller emits three spans:
         · "SymPy dsolve"  — implementation detail, not student-facing
         · "separable"     — classification badge
         · "✓ Verified"    — verification flag
       The ODE classification and verification are already conveyed by the
       Steps tab + the result LaTeX rendering in plain English; the row
       just adds visual noise above the actual solution. */
    .ode-method-badge,
    .ode-classify-badge,
    .ode-verified-badge { display: none !important; }
    /* Hide the wrapping detail-row too if it becomes empty after we hide
       its three children, so we don't leave an empty top-margin gap. */
    .ode-result-detail:empty { display: none !important; }
    .ode-result-detail:has(> .ode-method-badge:only-child),
    .ode-result-detail:has(.ode-method-badge + .ode-classify-badge + .ode-verified-badge) { display: none !important; }
    </style>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

    <%@ include file="modern/components/nav-header.jsp" %>

    <jsp:include page="/math/partials/matter-bg.jsp" />

    <div class="ms-hero">
        <%@ include file="modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="ms-main">

        <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
            &#9776; Math tools
        </button>

        <% request.setAttribute("activeService", "ode"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">ODE</span>
                </nav>
                <div style="display:flex;align-items:baseline;justify-content:space-between;gap:1rem;flex-wrap:wrap;">
                    <h1 style="margin:0;">ODE Solver Calculator</h1>
                    <a href="#worksheet" id="ode-header-worksheet-link" style="font-size:0.85rem;color:var(--ms-accent,#15803d);text-decoration:none;font-weight:600;border:1px solid var(--ms-accent,#15803d);padding:0.3rem 0.7rem;border-radius:9999px;white-space:nowrap;">&#128221; Practice worksheet</a>
                </div>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="ode-hero" data-input-mode="visual">

                    <!-- Top row: ODE mode toggle + Visual/Text + Scan -->
                    <div class="ic-hero-top">
                        <div class="ic-mode-toggle ode-mode-toggle" role="radiogroup" aria-label="ODE order">
                            <button type="button" class="ic-mode-btn ode-mode-btn active" data-mode="first" role="radio" aria-checked="true" title="dy/dx = f(x, y)">1st Order</button>
                            <button type="button" class="ic-mode-btn ode-mode-btn"        data-mode="second" role="radio" aria-checked="false" title="d²y/dx² and beyond">Higher-Order</button>
                            <button type="button" class="ic-mode-btn ode-mode-btn"        data-mode="field"  role="radio" aria-checked="false" title="Slope field plot only">Direction Field</button>
                        </div>
                        <div class="ic-expr-label-actions" style="display:flex;gap:0.5rem;align-items:center;">
                            <div class="ic-input-mode-toggle" data-mml-toggle role="radiogroup" aria-label="Input mode">
                                <button type="button" class="ic-input-mode-btn active" data-input-mode="visual" role="radio" aria-checked="true" title="Write math visually">
                                    <span aria-hidden="true" style="font-family:'Times New Roman',serif;font-style:italic;">&fnof;</span><span class="ic-mode-label"> Visual</span>
                                </button>
                                <button type="button" class="ic-input-mode-btn" data-input-mode="text" role="radio" aria-checked="false" title="Type a plain-text expression">
                                    <span aria-hidden="true" style="font-family:var(--font-mono,monospace);">&lt;/&gt;</span><span class="ic-mode-label"> Text</span>
                                </button>
                            </div>
                            <button type="button" class="ic-image-btn" id="ode-scan-btn" title="Scan ODE problems from image or PDF">&#128247; Scan</button>
                        </div>
                    </div>

                    <%-- 1st-order input (mode-specific wrap toggled by JS) --%>
                    <div id="ode-first-wrap">
                        <div class="ic-expr-wrap mml-pair">
                            <math-field class="ic-mathfield mml-mathfield" aria-label="dy/dx RHS"
                                        placeholder="-2xy"
                                        smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                            <input type="text" class="tool-input tool-input-mono mml-text" id="ode-first-expr"
                                   placeholder="e.g. -2*x*y" autocomplete="off" spellcheck="false"
                                   aria-label="dy/dx RHS text">
                            <span class="tool-form-hint ic-expr-hint">
                                <span class="ic-hint-visual">Type derivatives naturally: <code>y'</code>, <code>dy/dx</code>, etc. (auto-translates to calculator syntax).</span>
                                <span class="ic-hint-text">Use <code>y</code> for y(x). Multiplication needs <code>*</code>: <code>2*x*y</code>.</span>
                            </span>
                        </div>
                        <div class="ode-ic-row" style="margin-top:0.6rem;">
                            <input type="checkbox" id="ode-first-ic-check"> <label for="ode-first-ic-check">Initial condition <em>y(x&#8320;) = y&#8320;</em></label>
                        </div>
                        <div class="ode-ic-fields" id="ode-first-ic-fields">
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="ode-first-ic-x0">x&#8320;</label>
                                <input type="text" class="tool-input tool-input-mono" id="ode-first-ic-x0" value="0">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="ode-first-ic-y0">y&#8320;</label>
                                <input type="text" class="tool-input tool-input-mono" id="ode-first-ic-y0" value="1">
                            </div>
                        </div>
                    </div>

                    <%-- Higher-order input --%>
                    <div id="ode-second-wrap" style="display:none;">
                        <div class="ode-order-selector" id="ode-order-selector" style="margin-bottom:0.5rem;">
                            <button type="button" class="ode-order-btn active" data-order="2">2nd</button>
                            <button type="button" class="ode-order-btn" data-order="3">3rd</button>
                            <button type="button" class="ode-order-btn" data-order="4">4th</button>
                            <button type="button" class="ode-order-btn" data-order="5">5th</button>
                        </div>
                        <div class="ic-expr-wrap mml-pair">
                            <math-field class="ic-mathfield mml-mathfield" aria-label="Higher-order ODE RHS"
                                        placeholder="-2yp - y"
                                        smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                            <input type="text" class="tool-input tool-input-mono mml-text" id="ode-second-expr"
                                   placeholder="e.g. -2*yp - y" autocomplete="off" spellcheck="false"
                                   aria-label="Higher-order ODE RHS text">
                            <span class="tool-form-hint ic-expr-hint">
                                <span class="ic-hint-visual">Type <code>y'</code> / <code>y''</code> naturally — auto-translates to <code>yp</code> / <code>ypp</code>.</span>
                                <span class="ic-hint-text">Use <code>yp</code> for y'(x), <code>ypp</code> for y''(x), <code>yppp</code> for y'''(x), etc.</span>
                            </span>
                        </div>
                        <div class="ode-ic-row" style="margin-top:0.6rem;">
                            <input type="checkbox" id="ode-second-ic-check"> <label for="ode-second-ic-check" id="ode-second-ic-label">Initial conditions <em>y(x&#8320;)=y&#8320;</em>, <em>y'(x&#8320;)=y'&#8320;</em></label>
                        </div>
                        <div class="ode-ic-fields" id="ode-second-ic-fields">
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="ode-second-ic-x0">x&#8320;</label>
                                <input type="text" class="tool-input tool-input-mono" id="ode-second-ic-x0" value="0">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="ode-second-ic-y0">y&#8320;</label>
                                <input type="text" class="tool-input tool-input-mono" id="ode-second-ic-y0" value="0">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="ode-second-ic-dy0">y'&#8320;</label>
                                <input type="text" class="tool-input tool-input-mono" id="ode-second-ic-dy0" value="0">
                            </div>
                            <div id="ode-extra-ic-fields"></div>
                        </div>
                    </div>

                    <%-- Direction field input --%>
                    <div id="ode-field-wrap" style="display:none;">
                        <div class="ic-expr-wrap mml-pair">
                            <math-field class="ic-mathfield mml-mathfield" aria-label="Direction field RHS"
                                        placeholder="x+y"
                                        smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                            <input type="text" class="tool-input tool-input-mono mml-text" id="ode-field-expr"
                                   placeholder="e.g. x + y" autocomplete="off" spellcheck="false"
                                   aria-label="Direction field RHS text">
                            <span class="tool-form-hint ic-expr-hint">
                                <span class="ic-hint-visual">Direction field plots <em>dy/dx = f(x, y)</em>.</span>
                                <span class="ic-hint-text">Direction field plots <em>dy/dx = f(x, y)</em>.</span>
                            </span>
                        </div>
                        <div style="display:flex;align-items:baseline;justify-content:space-between;margin-top:0.6rem;">
                            <span style="font-size:0.78rem;color:var(--ms-muted,#94a3b8);font-weight:600;">Plot range</span>
                            <button type="button" id="ode-field-reset-range" style="font-size:0.75rem;color:var(--ms-accent,#15803d);background:none;border:none;cursor:pointer;text-decoration:underline;padding:0;">&#8634; Reset to default</button>
                        </div>
                        <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:0.5rem;margin-top:0.3rem;">
                            <div class="tool-form-group"><label class="tool-form-label" for="ode-field-xmin">x min</label><input type="number" class="tool-input" id="ode-field-xmin" value="-5"></div>
                            <div class="tool-form-group"><label class="tool-form-label" for="ode-field-xmax">x max</label><input type="number" class="tool-input" id="ode-field-xmax" value="5"></div>
                            <div class="tool-form-group"><label class="tool-form-label" for="ode-field-ymin">y min</label><input type="number" class="tool-input" id="ode-field-ymin" value="-5"></div>
                            <div class="tool-form-group"><label class="tool-form-label" for="ode-field-ymax">y max</label><input type="number" class="tool-input" id="ode-field-ymax" value="5"></div>
                        </div>
                        <div class="ode-ic-row" style="margin-top:0.6rem;">
                            <input type="checkbox" id="ode-field-curve-check"> <label for="ode-field-curve-check">Overlay solution curve through (x&#8320;, y&#8320;)</label>
                        </div>
                        <div class="ode-ic-fields" id="ode-field-curve-fields">
                            <div class="tool-form-group"><label class="tool-form-label" for="ode-field-curve-x0">x&#8320;</label><input type="text" class="tool-input tool-input-mono" id="ode-field-curve-x0" value="0"></div>
                            <div class="tool-form-group"><label class="tool-form-label" for="ode-field-curve-y0">y&#8320;</label><input type="text" class="tool-input tool-input-mono" id="ode-field-curve-y0" value="1"></div>
                        </div>
                    </div>

                    <!-- Live preview strip -->
                    <div class="ic-preview-strip">
                        <span class="ic-preview-label">Preview</span>
                        <span class="ic-preview" id="ode-preview">type an ODE above&hellip;</span>
                    </div>

                    <!-- Primary CTA — `id="ode-compute-btn"` preserves the legacy JS hook -->
                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta ode-compute-btn" id="ode-compute-btn" data-mml-submit>Solve &amp; explain &rarr;</button>
                        <button type="button" class="ode-random-btn" id="ode-random-btn" title="Random example">&#127922; Random</button>
                        <span class="ic-hero-warn" id="ode-warn" role="alert" aria-live="polite"></span>
                    </div>

                    <!-- Headline examples — surfaced inline so first-time
                         students see real starting points without having to
                         click an accordion.  Each chip data-encodes the mode,
                         expression, optional order, and optional IC. -->
                    <div class="ic-method-row" style="margin:0.4rem 0 0.2rem;">
                        <span class="ic-method-label">Try one</span>
                        <button type="button" class="ic-example-chip" data-headline data-mode="first" data-expr="-2*x*y" data-x0="0" data-y0="1" title="Separable IVP">y' = &minus;2xy, y(0)=1</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="first" data-expr="2*y - x" title="Linear ODE">y' + 2y = x</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="second" data-order="2" data-expr="-y" data-x0="0" data-y0="1" data-dy0="0" title="Simple harmonic oscillator">y'' + y = 0, y(0)=1, y'(0)=0</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="field" data-expr="x + y" title="Direction field">slope field x + y</button>
                    </div>

                    <!-- Examples — uses ic-hero-methods accordion just like integral-calculator -->
                    <details class="ic-hero-methods" id="ode-examples-wrap">
                        <summary class="ic-hero-methods-summary">
                            <span>More examples</span>
                            <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </summary>
                        <div class="ic-hero-methods-body">
                            <div id="ode-examples"></div>
                        </div>
                    </details>

                    <!-- Reference table accordion -->
                    <details class="ic-hero-methods" id="ode-formulas-wrap">
                        <summary class="ic-hero-methods-summary">
                            <span>ODE Reference Table</span>
                            <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </summary>
                        <div class="ic-hero-methods-body">
                            <div id="ode-formulas-content">
                                <table class="ode-formulas-table">
                                    <thead><tr><th>Type</th><th>Form</th><th>Method</th></tr></thead>
                                    <tbody>
                                        <tr><td>Separable</td><td id="ode-formula-f0"></td><td id="ode-formula-m0"></td></tr>
                                        <tr><td>1st Linear</td><td id="ode-formula-f1"></td><td id="ode-formula-m1"></td></tr>
                                        <tr><td>Bernoulli</td><td id="ode-formula-f2"></td><td id="ode-formula-m2"></td></tr>
                                        <tr><td>Exact</td><td id="ode-formula-f3"></td><td id="ode-formula-m3"></td></tr>
                                        <tr><td>Homogeneous</td><td id="ode-formula-f4"></td><td id="ode-formula-m4"></td></tr>
                                        <tr><td>2nd Const Coeff</td><td id="ode-formula-f5"></td><td id="ode-formula-m5"></td></tr>
                                        <tr><td>Non-Homogeneous</td><td id="ode-formula-f6"></td><td id="ode-formula-m6"></td></tr>
                                        <tr><td>Cauchy-Euler</td><td id="ode-formula-f7"></td><td id="ode-formula-m7"></td></tr>
                                        <tr><td>3rd Const Coeff</td><td id="ode-formula-f8"></td><td id="ode-formula-m8"></td></tr>
                                        <tr><td>4th Order (Beam)</td><td id="ode-formula-f9"></td><td id="ode-formula-m9"></td></tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </details>

                    <!-- Syntax help accordion -->
                    <div class="ic-hero-syntax" id="ode-syntax-wrap">
                        <button type="button" class="ic-syntax-toggle" id="ode-syntax-btn">
                            Syntax help
                            <svg class="ic-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </button>
                        <div class="ic-syntax-content" id="ode-syntax-content">
                            <strong>Variable:</strong> <code>y</code> represents y(x).<br>
                            <strong>Derivatives:</strong> <code>y'</code>, <code>y''</code>, <code>dy/dx</code>, <code>d²y/dx²</code> (all auto-normalize) &mdash; or use <code>yp</code>, <code>ypp</code>, <code>yppp</code>, <code>y4</code>, <code>y5</code> directly.<br>
                            <strong>Functions:</strong> <code>sin</code>, <code>cos</code>, <code>tan</code>, <code>exp</code>, <code>log</code>, <code>sqrt</code>.<br>
                            <strong>Powers / multiplication:</strong> <code>x^2</code> or <code>x**2</code>; always use <code>*</code> (e.g. <code>2*x*y</code>).<br>
                            <strong>Constants:</strong> <code>pi</code>, <code>e</code>.
                        </div>
                    </div>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs ode-output-tabs" role="tablist">
                        <button type="button" class="ic-output-tab ode-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                        <button type="button" class="ic-output-tab ode-output-tab"        data-panel="graph"  role="tab" aria-selected="false">Graph</button>
                        <button type="button" class="ic-output-tab ode-output-tab"        data-panel="python" role="tab" aria-selected="false">Python Compiler</button>
                    </div>

                    <div class="ic-panel ode-panel active" id="ode-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="ode-result-content">
                                <div class="tool-empty-state ic-empty-state" id="ode-empty-state">
                                    <div class="ic-empty-illustration">dy/dx</div>
                                    <h3>Ready when you are</h3>
                                    <p>Type an ODE above and hit <strong>Solve</strong>.</p>
                                </div>
                            </div>

                            <div class="tool-result-actions" id="ode-result-actions">
                                <button type="button" class="tool-action-btn" id="ode-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="ode-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="ode-download-pdf-btn">Download PDF</button>
                            </div>

                            <div class="ic-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="ode-worksheet-btn">
                                    Practice ODE Worksheet &mdash; 1,000+ problems
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel ode-panel" id="ode-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:360px;">
                                <div id="ode-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                                <p id="ode-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Solve an ODE to see its graph.</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel ode-panel" id="ode-panel-python" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:0;">
                                <iframe id="ode-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- In-content ad (mobile/tablet) -->
            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- ═══ VISIBLE FAQ (mirrors faqNq/faqNa params above) ═══ -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="ODE solver FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can I scan an ODE problem from a photo?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Click the green <strong>&#128247; Scan</strong> button next to the equation input, upload a photo or PDF of your homework, and our AI extracts every ODE on the page along with any initial conditions. Pick a problem to fill the form and solve. Works on textbook pages, exam papers, and handwritten work.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you solve a first-order ODE?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">First identify the type: <strong>separable, linear, Bernoulli, exact, or homogeneous</strong>. Then apply the appropriate method. For separable ODEs, separate variables and integrate. For linear ODEs <em>y' + P(x)y = Q(x)</em>, multiply by the integrating factor <em>&mu; = e<sup>&int;P dx</sup></em>. The calculator automatically classifies and solves first-order ODEs.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Does this ODE solver support initial conditions (IVP)?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. The calculator solves <strong>initial value problems (IVPs)</strong>. For first-order: <em>y(x&#8320;) = y&#8320;</em>. For second-order: <em>y(x&#8320;) = y&#8320;</em> and <em>y'(x&#8320;) = y'&#8320;</em>. Initial conditions determine the unique particular solution.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is a direction field (slope field)?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">A <strong>direction field</strong> is a graphical representation of <em>dy/dx = f(x, y)</em>. At each point a short line segment shows the slope <em>f(x, y)</em>. The pattern reveals qualitative solution behaviour without solving analytically.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What ODE types can this calculator solve?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Separable, first-order linear, Bernoulli, exact, homogeneous, second-order constant coefficient (homogeneous and non-homogeneous), Cauchy-Euler, and many more. Auto-classification chooses the right method.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the difference between general and particular solutions?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">A <strong>general solution</strong> contains arbitrary constants (<em>C&#8321;, C&#8322;, &hellip;</em>) and represents all possible solutions. A <strong>particular solution</strong> applies initial conditions to fix those constants.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Is this ODE solver calculator free?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes &mdash; <strong>100% free, no signup, no daily limits</strong>. Step-by-step solutions, ODE classification, verification, interactive graphs, direction field plots, AI photo scan, MathLive visual input, 1,000+ practice problems, and a built-in Python compiler.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Does this ODE solver include practice worksheets?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes &mdash; over <strong>1,000 ODE practice problems</strong>. Filter by 8+ question types and 4 difficulty levels. Each worksheet is randomly generated with a full answer key.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2025 8gwifi.org &mdash; Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%--
        Script load order:
          1. math-libs                  — KaTeX, plotly loader, image-to-math, tool-utils, dark-mode, search
          2. ode-solver-calculator.js   — existing controller (unchanged; reads ode-* IDs)
          3. worksheet-engine.js        — practice worksheet
          4. math-input-multi           — MathLive Visual/Text on the 3 ODE expression inputs (.mml-pair)
          5. inline scan + worksheet wiring + quick-win normalizers
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />

    <script>window.ODE_CALC_CTX = "<%=request.getContextPath()%>";</script>

    <script src="<%=request.getContextPath()%>/js/worksheet-engine.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/ode-solver-calculator.js?v=<%=cacheVersion%>"></script>

    <jsp:include page="/math/partials/math-input-multi.jsp" />

    <script>
    // ─────────────────────────────────────────────────────────────────────
    //  Quick win #1 — full ODE input normalization
    //
    //  Two layers:
    //    (a) Derivative notation:  y' / y'' / dy/dx → yp / ypp / etc.
    //    (b) Implicit multiplication:  -2xy → -2*x*y, x(y+1) → x*(y+1),
    //        2pi → 2*pi, etc. — done with a small tokenizer so that
    //        multi-char keywords (yp, ypp, sin, cos, sqrt, pi, …) stay
    //        intact while bare adjacent variables get a * inserted
    //        between them.
    //
    //  Runs on input in CAPTURE phase so the legacy controller's bubble-
    //  phase listener sees the rewritten value.
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        var INPUT_IDS = ['ode-first-expr', 'ode-second-expr', 'ode-field-expr'];

        // Multi-char tokens that must NOT be split by implicit-mul logic.
        // Sorted longest-first so the tokenizer prefers `yppp` over `yp`.
        var KEYWORDS = [
            'yppp', 'ypp', 'y5', 'y4', 'yp',
            'asinh', 'acosh', 'atanh',
            'sinh', 'cosh', 'tanh',
            'asin', 'acos', 'atan',
            'sin', 'cos', 'tan',
            'sqrt', 'exp', 'log', 'ln', 'abs',
            'theta', 'pi'
        ];
        KEYWORDS.sort(function (a, b) { return b.length - a.length; });

        // Functions that accept a parenthesised argument — when followed
        // by '(' we DON'T insert a * (otherwise sin(x) → sin*(x)).
        var FUNCTIONS = {
            sin: 1, cos: 1, tan: 1, asin: 1, acos: 1, atan: 1,
            sinh: 1, cosh: 1, tanh: 1, asinh: 1, acosh: 1, atanh: 1,
            exp: 1, log: 1, ln: 1, sqrt: 1, abs: 1, min: 1, max: 1
        };

        function isAlnum(c) { return !!c && /[A-Za-z0-9_]/.test(c); }
        function lastChar(s) { return s.length ? s[s.length - 1] : ''; }
        function lastWord(s) {
            var j = s.length - 1;
            while (j >= 0 && /[A-Za-z]/.test(s[j])) j--;
            return s.substring(j + 1);
        }

        function normalize(s) {
            if (!s) return s;

            // ── Layer (a): derivative notation ──
            s = s.replace(/d\^?5y\s*\/\s*dx\^?5/g, 'y5');
            s = s.replace(/d\^?4y\s*\/\s*dx\^?4/g, 'y4');
            s = s.replace(/d\^?3y\s*\/\s*dx\^?3/g, 'yppp');
            s = s.replace(/d\^?2y\s*\/\s*dx\^?2/g, 'ypp');
            s = s.replace(/dy\s*\/\s*dx/g, 'yp');
            s = s.replace(/y'{5}/g, 'y5');
            s = s.replace(/y'{4}/g, 'y4');
            s = s.replace(/y'{3}/g, 'yppp');
            s = s.replace(/y'{2}/g, 'ypp');
            s = s.replace(/y'/g, 'yp');
            s = s.replace(/y\u2032\u2032\u2032\u2032\u2032/g, 'y5');
            s = s.replace(/y\u2032\u2032\u2032\u2032/g, 'y4');
            s = s.replace(/y\u2032\u2032\u2032/g, 'yppp');
            s = s.replace(/y\u2032\u2032/g, 'ypp');
            s = s.replace(/y\u2032/g, 'yp');
            // MathLive Visual mode renders multiplication as \cdot — strip it
            s = s.replace(/\\cdot/g, '*');
            s = s.replace(/\\times/g, '*');
            // Unicode → ASCII operator equivalents (copy-paste from textbooks
            // commonly carries Unicode minus, en-dash, multiplication sign, etc.)
            s = s.replace(/[\u2212\u2013\u2014]/g, '-');  // U+2212 minus, en-dash, em-dash
            s = s.replace(/[\u00D7\u22C5\u2219]/g, '*');  // ×, ⋅, ∙
            s = s.replace(/[\u00F7\u2215]/g, '/');         // ÷, ∕

            // Strip ALL internal whitespace before tokenization — otherwise
            // "x y" looks like two tokens to the legacy parser.
            s = s.replace(/\s+/g, '');

            // ── Layer (b): tokenize and insert * between atoms ──
            var i = 0, out = '';
            while (i < s.length) {
                var c = s[i];

                // Number (one digit-block, allowing one decimal point)
                if (/[0-9.]/.test(c)) {
                    var num = '';
                    while (i < s.length && /[0-9.]/.test(s[i])) { num += s[i]; i++; }
                    var lc = lastChar(out);
                    if (lc === ')' || /[A-Za-z]/.test(lc)) out += '*';
                    out += num;
                    continue;
                }

                // Letter — match a keyword if possible, else a single variable
                if (/[A-Za-z]/.test(c)) {
                    var matched = null;
                    for (var k = 0; k < KEYWORDS.length; k++) {
                        var kw = KEYWORDS[k];
                        if (s.substr(i, kw.length).toLowerCase() === kw &&
                            !isAlnum(s[i + kw.length])) {
                            matched = kw;
                            break;
                        }
                    }
                    var token = matched || c;
                    var lc2 = lastChar(out);
                    if (lc2 === ')' || /[A-Za-z0-9]/.test(lc2)) out += '*';
                    out += s.substr(i, token.length);
                    i += token.length;
                    continue;
                }

                // Open paren — insert * unless preceded by a function name
                if (c === '(') {
                    var lc3 = lastChar(out);
                    if (lc3 === ')' || /[A-Za-z0-9]/.test(lc3)) {
                        var prev = lastWord(out).toLowerCase();
                        if (!FUNCTIONS[prev]) out += '*';
                    }
                    out += c; i++; continue;
                }

                // Operators / parens / other — pass through verbatim
                out += c; i++;
            }
            return out;
        }

        INPUT_IDS.forEach(function (id) {
            var el = document.getElementById(id);
            if (!el) return;
            // Capture-phase so the legacy controller's bubble-phase
            // listener sees the rewritten value.
            el.addEventListener('input', function () {
                var raw = el.value || '';
                var norm = normalize(raw);
                if (raw !== norm) {
                    var pos = el.selectionStart;
                    var diff = norm.length - raw.length;
                    el.value = norm;
                    try { el.setSelectionRange(pos + diff, pos + diff); } catch (e) {}
                }
            }, true);
        });

        // Expose for debugging / smoke-testing in the console
        window.__odeNormalize = normalize;
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  Quick win #2 — URL ?expr=&order=&mode= auto-fill
    //
    //  A user clicking from "how to solve y' = -2xy" should land with the
    //  ODE pre-filled and ready to Solve.  Reads URL params on boot,
    //  switches mode, fills the matching expression input, and clicks
    //  Solve after a short delay (so MathLive has time to upgrade).
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        try {
            var p = new URL(window.location.href).searchParams;
            var expr = p.get('expr');
            var order = parseInt(p.get('order') || '1', 10);
            var mode = p.get('mode'); // explicit override: first | second | field
            if (!expr && !mode) return;

            var apply = function () {
                var modeKey = mode || (order >= 2 ? 'second' : 'first');
                var modeBtn = document.querySelector('.ode-mode-btn[data-mode="' + modeKey + '"]');
                if (modeBtn) modeBtn.click();
                if (modeKey === 'second' && order >= 2) {
                    var ordBtn = document.querySelector('.ode-order-btn[data-order="' + order + '"]');
                    if (ordBtn) ordBtn.click();
                }
                if (expr) {
                    var inputId = modeKey === 'first'  ? 'ode-first-expr' :
                                  modeKey === 'field'  ? 'ode-field-expr' :
                                                          'ode-second-expr';
                    var el = document.getElementById(inputId);
                    if (el) {
                        el.value = expr;
                        el.dispatchEvent(new Event('input', { bubbles: true }));
                    }
                }
                /* Slight delay so the MathLive upgrade + ODE controller
                   have time to wire listeners before we synthesize a click. */
                setTimeout(function () {
                    var solveBtn = document.getElementById('ode-compute-btn');
                    if (solveBtn) solveBtn.click();
                }, 400);
            };
            if (window.customElements && customElements.whenDefined) {
                customElements.whenDefined('math-field').then(apply, apply);
            } else { apply(); }
        } catch (e) { /* malformed URL — ignore */ }
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  AI photo scan — ODE-specific extraction prompt
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        if (typeof ImageToMath === 'undefined') return;
        var CTX = window.ODE_CALC_CTX || '';
        ImageToMath.init({
            buttonId: 'ode-scan-btn',
            aiUrl: CTX + '/ai',
            toolName: 'ODE Solver',
            extractionPrompt:
                'You are a math problem extractor for an ODE solver.\n' +
                'Return a JSON array. Each object has:\n' +
                '  - "expr": the right-hand side as plain text using y for y(x), yp for y\', ypp for y\'\', * for multiplication, ^ for power.  Examples: "-2*x*y", "y*(1-y)", "-2*yp - y".\n' +
                '  - "order": 1, 2, 3, 4, or 5\n' +
                '  - "ic": optional, e.g. {"x0": "0", "y0": "1", "dy0": "0"}\n' +
                '  - "display": full ODE in LaTeX for the card heading (e.g. "y\' = -2xy,\\\\; y(0)=1")\n' +
                'Rules: expr is the RHS of dⁿy/dxⁿ = f(...); do NOT include "dy/dx =". Return ONLY valid JSON, no fences.\n' +
                'Example input: "Solve y\' = -2xy with y(0) = 1"\n' +
                'Example output: [{"expr":"-2*x*y","order":1,"ic":{"x0":"0","y0":"1"},"display":"y\' = -2xy,\\\\; y(0)=1"}]',
            onSelect: function (problem) {
                var apply = function () {
                    var order = parseInt(problem.order, 10) || 1;
                    var modeBtn = document.querySelector('.ode-mode-btn[data-mode="' + (order === 1 ? 'first' : 'second') + '"]');
                    if (modeBtn) modeBtn.click();
                    if (order >= 2) {
                        var ordBtn = document.querySelector('.ode-order-btn[data-order="' + order + '"]');
                        if (ordBtn) ordBtn.click();
                    }
                    var inputId = order === 1 ? 'ode-first-expr' : 'ode-second-expr';
                    var el = document.getElementById(inputId);
                    if (el) {
                        el.value = problem.expr || '';
                        el.dispatchEvent(new Event('input', { bubbles: true }));
                    }
                    var ic = problem.ic || {};
                    if (order === 1 && (ic.x0 != null || ic.y0 != null)) {
                        var c1 = document.getElementById('ode-first-ic-check'); if (c1 && !c1.checked) c1.click();
                        if (ic.x0 != null) { var x = document.getElementById('ode-first-ic-x0'); if (x) x.value = ic.x0; }
                        if (ic.y0 != null) { var y = document.getElementById('ode-first-ic-y0'); if (y) y.value = ic.y0; }
                    } else if (order >= 2 && (ic.x0 != null || ic.y0 != null || ic.dy0 != null)) {
                        var c2 = document.getElementById('ode-second-ic-check'); if (c2 && !c2.checked) c2.click();
                        if (ic.x0 != null) { var x2 = document.getElementById('ode-second-ic-x0'); if (x2) x2.value = ic.x0; }
                        if (ic.y0 != null) { var y2 = document.getElementById('ode-second-ic-y0'); if (y2) y2.value = ic.y0; }
                        if (ic.dy0 != null) { var d = document.getElementById('ode-second-ic-dy0'); if (d) d.value = ic.dy0; }
                    }
                    setTimeout(function () {
                        var b = document.getElementById('ode-compute-btn'); if (b) b.click();
                    }, 250);
                };
                if (window.customElements && customElements.whenDefined) {
                    customElements.whenDefined('math-field').then(apply, apply);
                } else { apply(); }
            }
        });
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  Quick win — headline example chips above the accordion
    //
    //  Each chip carries data-mode/data-order/data-expr/data-x0/data-y0/
    //  data-dy0 attributes that fully describe a starter problem.  Click
    //  switches the mode, sets the order selector if relevant, fills the
    //  matching expression input, ticks the IVP checkbox if x0/y0 given,
    //  then clicks Solve.
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        document.querySelectorAll('.ic-example-chip[data-headline]').forEach(function (chip) {
            chip.addEventListener('click', function () {
                var apply = function () {
                    var mode = chip.getAttribute('data-mode') || 'first';
                    var order = parseInt(chip.getAttribute('data-order') || '1', 10);
                    var expr = chip.getAttribute('data-expr') || '';
                    var x0 = chip.getAttribute('data-x0');
                    var y0 = chip.getAttribute('data-y0');
                    var dy0 = chip.getAttribute('data-dy0');

                    var modeBtn = document.querySelector('.ode-mode-btn[data-mode="' + mode + '"]');
                    if (modeBtn) modeBtn.click();
                    if (mode === 'second' && order >= 2) {
                        var ordBtn = document.querySelector('.ode-order-btn[data-order="' + order + '"]');
                        if (ordBtn) ordBtn.click();
                    }
                    var inputId = mode === 'first' ? 'ode-first-expr' :
                                  mode === 'field' ? 'ode-field-expr' : 'ode-second-expr';
                    var el = document.getElementById(inputId);
                    if (el) {
                        el.value = expr;
                        el.dispatchEvent(new Event('input', { bubbles: true }));
                    }
                    if (mode === 'first' && (x0 != null || y0 != null)) {
                        var c1 = document.getElementById('ode-first-ic-check'); if (c1 && !c1.checked) c1.click();
                        if (x0 != null) { var x = document.getElementById('ode-first-ic-x0'); if (x) x.value = x0; }
                        if (y0 != null) { var y = document.getElementById('ode-first-ic-y0'); if (y) y.value = y0; }
                    } else if (mode === 'second' && (x0 != null || y0 != null || dy0 != null)) {
                        var c2 = document.getElementById('ode-second-ic-check'); if (c2 && !c2.checked) c2.click();
                        if (x0 != null) { var x2 = document.getElementById('ode-second-ic-x0'); if (x2) x2.value = x0; }
                        if (y0 != null) { var y2 = document.getElementById('ode-second-ic-y0'); if (y2) y2.value = y0; }
                        if (dy0 != null) { var d = document.getElementById('ode-second-ic-dy0'); if (d) d.value = dy0; }
                    }
                    setTimeout(function () {
                        var b = document.getElementById('ode-compute-btn'); if (b) b.click();
                    }, 250);
                };
                if (window.customElements && customElements.whenDefined) {
                    customElements.whenDefined('math-field').then(apply, apply);
                } else { apply(); }
            });
        });
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  Quick win — .is-busy spinner lock on Solve button
    //
    //  Adds .is-busy when Solve is clicked, removes it when the result
    //  panel updates (MutationObserver) OR after a 30s safety timeout.
    //  Same pattern matrix-calculator and the limit/series tools use.
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        var btn = document.getElementById('ode-compute-btn');
        var resultContent = document.getElementById('ode-result-content');
        if (!btn || !resultContent) return;

        var resultObserver = null;
        var safetyTimer = null;

        function unlock() {
            btn.classList.remove('is-busy');
            if (resultObserver) { resultObserver.disconnect(); resultObserver = null; }
            if (safetyTimer) { clearTimeout(safetyTimer); safetyTimer = null; }
        }
        function lock() {
            if (btn.classList.contains('is-busy')) return;
            btn.classList.add('is-busy');
            if ('MutationObserver' in window) {
                resultObserver = new MutationObserver(function () { unlock(); });
                resultObserver.observe(resultContent, { childList: true, subtree: true, characterData: true });
            }
            safetyTimer = setTimeout(unlock, 30000);
        }
        btn.addEventListener('click', lock);
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  Quick win — ↺ Reset range on direction field
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        var btn = document.getElementById('ode-field-reset-range');
        if (!btn) return;
        btn.addEventListener('click', function () {
            var defaults = { 'ode-field-xmin': -5, 'ode-field-xmax': 5,
                             'ode-field-ymin': -5, 'ode-field-ymax': 5 };
            Object.keys(defaults).forEach(function (id) {
                var el = document.getElementById(id);
                if (el) {
                    el.value = defaults[id];
                    el.dispatchEvent(new Event('input', { bubbles: true }));
                    el.dispatchEvent(new Event('change', { bubbles: true }));
                }
            });
        });
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  Quick win — header "📝 Practice worksheet" mini-link
    //  Routes to the same WorksheetEngine modal as the Result-panel CTA
    //  so teachers can jump straight to worksheet generation without
    //  solving anything first.
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        var link = document.getElementById('ode-header-worksheet-link');
        if (!link) return;
        link.addEventListener('click', function (e) {
            e.preventDefault();
            if (typeof WorksheetEngine === 'undefined') return;
            var ctx = (window.ODE_CALC_CTX || '');
            WorksheetEngine.open({
                jsonUrl: ctx + '/worksheet/math/calculus/ode.json',
                title: 'ODEs',
                accentColor: '#db2777',
                branding: '8gwifi.org',
                defaultCount: 20
            });
        });
    })();

    // ── FAQ accordion ──
    (function () {
        document.querySelectorAll('.ms-faq-q').forEach(function (q) {
            q.addEventListener('click', function () {
                q.closest('.ms-faq-item').classList.toggle('open');
            });
        });
    })();
    </script>
</body>
</html>
