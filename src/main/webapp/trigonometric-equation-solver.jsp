<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Trig Equation Solver — math-studio shell (matches integral / ODE /
        PDE / matrix / trig-function calculators).  Wraps existing trig-*
        markup verbatim so /js/trig-common.js + /js/trig-equation-core.js +
        /js/trig-graph.js + /js/trig-export.js continue to work without
        modification (every trig-* id and class preserved).

        New on top of the legacy page:
          · math-studio shell (sidebar, ms-rail, matter-bg, ic-stack)
          · MathLive Visual/Text on the trig-expr input (mml-pair)
          · AI photo scan with a trig-equation-specific extraction prompt
          · ".is-busy" spinner lock on the primary CTA
          · Friendlier "Solve & explain →" button copy
          · Headline example chips inline (above the legacy "More examples")
          · Unit toggle hidden in Simplify mode (no degrees/radians on a
            pure expression)
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow,max-image-preview:large,max-snippet:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Trig Equation Solver with Steps + AI Photo Scan" />
        <jsp:param name="toolDescription" value="Free AI trig equation solver with step-by-step solutions and photo scan. Solve trig equations, inequalities, and simplify expressions with general solutions and periodicity. Snap a textbook problem or type any expression. Interactive function graphs. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="trigonometric-equation-solver.jsp" />
        <jsp:param name="toolKeywords" value="trigonometric equation solver, solve trig equations online, trig inequality solver, trig simplifier, general solution trig, AI trig equation solver, trig solver scan image, snap trig problem, photo math trig, MathLive trig editor, free trig solver no signup" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="AI photo scan with step-by-step solver,MathLive visual trig editor (Visual / Text toggle),Solve trig equations with step-by-step solutions,Find all solutions in 0 to 2pi with general form,Trig inequality solver with interval notation,Simplify trig expressions using identities,Interactive function graphs with solution markers,Hybrid client-side and AI solving engine,Python SymPy code generation,LaTeX export for homework and papers,Live KaTeX preview,Dark mode no signup no limits free" />
        <jsp:param name="teaches" value="Solving trigonometric equations, general solutions with periodicity, trig inequalities, simplifying trig expressions, inverse trig functions, factoring trig equations" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Snap a photo OR type the equation|Click the camera button to scan a problem from a photo OR type a trig equation like sin(x)=1/2 or sin(2x)=cos(x) directly using the MathLive visual editor.,Pick a mode|Choose Equation to solve trig equations OR Inequality for inequalities OR Simplify to reduce trig expressions.,Select angle unit|Toggle Degrees or Radians for the output format (not needed for Simplify).,Click Solve|Step-by-step solution renders with full LaTeX rendering.,View graph|Switch to Graph for the function plot with solution points marked or Python for editable SymPy code." />
        <jsp:param name="faq1q" value="Can I scan a trig equation from a photo?" />
        <jsp:param name="faq1a" value="Yes. Click the green Scan button next to the expression input, upload a photo or PDF of your homework, and our AI extracts every trig equation on the page along with the mode (equation / inequality / simplify) and angle unit. Pick one to fill the form and solve. Works on textbook pages, exam papers, and handwritten work." />
        <jsp:param name="faq2q" value="How do I solve trig equations step by step?" />
        <jsp:param name="faq2a" value="Enter the equation like sin(x)=1/2 or 2cos^2(x)-1=0. For simple forms, solutions are computed instantly. For complex equations, our AI solver provides step-by-step solutions with all solutions in [0, 2pi) and the general solution with periodicity." />
        <jsp:param name="faq3q" value="What is the general solution of a trig equation?" />
        <jsp:param name="faq3a" value="Since trig functions are periodic, equations have infinitely many solutions. The general solution uses +2n pi for sine and cosine or +n pi for tangent, where n is any integer. We show both specific solutions in [0, 2pi) and the general form." />
        <jsp:param name="faq4q" value="Can the solver handle trig inequalities?" />
        <jsp:param name="faq4a" value="Yes switch to Inequality mode and enter inequalities like sin(x)>1/2 or cos(x)<=0. The solver finds critical points, tests intervals, and expresses the solution set in interval notation with periodicity." />
        <jsp:param name="faq5q" value="How does trig simplification work?" />
        <jsp:param name="faq5a" value="Enter any trig expression like (sin^4(x)-cos^4(x))/(sin^2(x)-cos^2(x)). The solver applies Pythagorean, double angle, and other identities step by step to reduce it to the simplest form. It verifies the result by checking a specific angle value." />
        <jsp:param name="faq6q" value="What if my trig equation has no solution?" />
        <jsp:param name="faq6a" value="The solver detects impossible equations like sin(x)=2 (since sine ranges from -1 to 1) and clearly reports No Solution with an explanation. It also detects impossible inequalities like sin(x)>2." />
        <jsp:param name="faq7q" value="What trig equation types are supported?" />
        <jsp:param name="faq7a" value="Simple forms like sin(x)=k, cos(x)=k, tan(x)=k. Quadratic forms like 2cos^2(x)-1=0. Multi-function equations like sin(2x)=cos(x). Product equations like sin(x)cos(x)=1/2. And any combination using standard trig notation." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">

    <!-- Math shell -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=cacheVersion%>">

    <!-- Tool-specific CSS (trig-* mode toggles, examples, ops table, etc.) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/trigonometry-calculator.css?v=<%=cacheVersion%>">

    <!-- KaTeX + MathLive + image-to-math -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css?v=<%=cacheVersion%>">

    <style>
    /* Busy-spinner for the primary CTA — locks Solve while compute is in
       flight and adds a small spinner glyph. */
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
        animation: trig-cta-spin 0.7s linear infinite;
        vertical-align: middle;
    }
    @keyframes trig-cta-spin { to { transform: rotate(360deg); } }
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

        <% request.setAttribute("activeService", "trig-eq"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Trig Equation Solver</span>
                </nav>
                <h1>Trigonometric Equation Solver</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="trig-hero" data-input-mode="visual">

                    <!-- Top row: mode toggle + Visual/Text + Scan -->
                    <div class="ic-hero-top">
                        <div class="ic-mode-toggle trig-mode-toggle" role="radiogroup" aria-label="Trig solver mode">
                            <button type="button" class="ic-mode-btn trig-mode-btn active" data-mode="solve_equation"   role="radio" aria-checked="true"  title="Solve a trig equation for x">Equation</button>
                            <button type="button" class="ic-mode-btn trig-mode-btn"        data-mode="solve_inequality" role="radio" aria-checked="false" title="Solve a trig inequality">Inequality</button>
                            <button type="button" class="ic-mode-btn trig-mode-btn"        data-mode="simplify"          role="radio" aria-checked="false" title="Simplify a trig expression using identities">Simplify</button>
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
                            <button type="button" class="ic-image-btn" id="trig-scan-btn" title="Scan trig problems from image or PDF">&#128247; Scan</button>
                        </div>
                    </div>

                    <!-- Expression input — MathLive Visual / Text pair -->
                    <div class="ic-expr-wrap mml-pair" id="trig-expr-wrap">
                        <math-field class="ic-mathfield mml-mathfield" aria-label="Trig equation"
                                    placeholder="\sin(x)=\tfrac{1}{2}"
                                    smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                        <input type="text" class="trig-input-text mml-text" id="trig-expr"
                               value="" placeholder="e.g. sin(x)=1/2, sin(2x)=cos(x), sin(x)>1/2"
                               autocomplete="off" spellcheck="false" aria-label="Trig equation text">
                        <span class="tool-form-hint ic-expr-hint">
                            <span class="ic-hint-visual">Type <code>sin(x)=1/2</code>, <code>cos(x)&gt;0</code>, or any trig expression — use the Visual editor for fractions and powers.</span>
                            <span class="ic-hint-text">Equation: <code>sin(x)=1/2</code> &middot; Inequality: <code>sin(x)&gt;1/2</code> &middot; Simplify: any trig expression.</span>
                        </span>
                    </div>

                    <!-- Unit toggle — degrees / radians (hidden in Simplify mode) -->
                    <div class="ic-hero-params" id="trig-unit-group" style="grid-template-columns:auto 1fr;align-items:center;gap:0.6rem;margin-top:0.6rem;">
                        <span class="tool-form-label" style="margin:0;">Angle unit</span>
                        <div class="trig-unit-toggle" style="display:inline-flex;align-self:start;">
                            <button type="button" class="trig-unit-btn active" data-unit="deg">Degrees</button>
                            <button type="button" class="trig-unit-btn"        data-unit="rad">Radians</button>
                        </div>
                    </div>

                    <!-- Live preview strip -->
                    <div class="ic-preview-strip">
                        <span class="ic-preview-label">Preview</span>
                        <span class="ic-preview trig-preview" id="trig-preview">type an equation above&hellip;</span>
                    </div>

                    <!-- Primary CTA — id="trig-calc-btn" preserves the legacy JS hook -->
                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta" id="trig-calc-btn" data-mml-submit>Solve &amp; explain &rarr;</button>
                        <button type="button" class="ode-random-btn" id="trig-clear-btn" title="Clear input">&#128465; Clear</button>
                    </div>

                    <!-- Headline examples — one row of starting points. -->
                    <div class="ic-method-row" style="margin:0.4rem 0 0.2rem;">
                        <span class="ic-method-label">Try one</span>
                        <button type="button" class="ic-example-chip" data-headline data-mode="solve_equation"   data-expr="sin(x)=1/2"        title="Solve sin(x)=1/2">sin(x)=&frac12;</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="solve_equation"   data-expr="sin(2x)=cos(x)"    title="Solve sin(2x)=cos(x)">sin(2x)=cos(x)</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="solve_equation"   data-expr="2cos(x)^2-1=0"     title="Solve 2cos²(x)−1=0">2cos&sup2;(x)&minus;1=0</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="solve_inequality" data-expr="sin(x)>1/2"        title="Solve sin(x)>1/2">sin(x) &gt; &frac12;</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="simplify"         data-expr="(sin(x)^4-cos(x)^4)/(sin(x)^2-cos(x)^2)" title="Simplify a trig expression">Simplify sin&#8308;&minus;cos&#8308;</button>
                    </div>
                    <!-- Hidden anchor for legacy share-URL / deep-link
                         hooks that may still reference #trig-examples. -->
                    <div class="trig-examples" id="trig-examples" style="display:none;" aria-hidden="true"></div>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs trig-output-tabs" role="tablist">
                        <button type="button" class="ic-output-tab trig-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                        <button type="button" class="ic-output-tab trig-output-tab"        data-panel="graph"  role="tab" aria-selected="false">Graph</button>
                        <button type="button" class="ic-output-tab trig-output-tab"        data-panel="python" role="tab" aria-selected="false">Python</button>
                    </div>

                    <div class="ic-panel trig-panel active" id="trig-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="trig-result-content">
                                <div class="tool-empty-state ic-empty-state" id="trig-empty-state">
                                    <div class="ic-empty-illustration">&theta;=</div>
                                    <h3>Ready when you are</h3>
                                    <p>Type a trig equation above and hit <strong>Solve</strong>.</p>
                                </div>
                            </div>
                            <div class="tool-result-actions" id="trig-result-actions">
                                <button type="button" class="tool-action-btn" id="trig-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="trig-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="trig-worksheet-btn-toolbar">Worksheet</button>
                            </div>

                            <!-- Practice worksheet CTA — 1,500-problem CAS-verified
                                 trigonometry bank with NCERT word problems and
                                 IIT-JEE classics. Shared across all 3 trig calcs. -->
                            <div class="ic-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="trig-worksheet-btn">
                                    Practice Worksheet &mdash; 1,500+ trig problems with answer key
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel trig-panel" id="trig-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:360px;">
                                <div id="trig-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                                <p id="trig-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Solve to see the function plot with solution markers.</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel trig-panel" id="trig-panel-python" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:0;">
                                <iframe id="trig-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- In-content ad (mobile/tablet) -->
            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- ════════════ EDUCATIONAL CONTENT (preserved for SEO) ════════════ -->
            <section class="tool-expertise-section" style="margin:2rem 0;">

                <!-- 1. Solving Trig Equations -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">How to Solve Trigonometric Equations</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.75rem;">A <strong>trigonometric equation</strong> contains trig functions of an unknown angle. Unlike identities (true for all angles), trig equations are satisfied only by <strong>specific angle values</strong>. Because trig functions are periodic, most equations have <strong>infinitely many solutions</strong> &mdash; you find solutions in one period, then express the general solution.</p>

                    <div class="trig-feature-grid">
                        <div class="trig-feature-card trig-anim trig-anim-d1">
                            <h4>Step 1: Isolate</h4>
                            <p>Isolate the trig function on one side. Convert to a single function if possible using identities.</p>
                        </div>
                        <div class="trig-feature-card trig-anim trig-anim-d2">
                            <h4>Step 2: Solve in [0, 2&pi;)</h4>
                            <p>Use inverse trig functions and the unit circle to find all solutions in one period.</p>
                        </div>
                        <div class="trig-feature-card trig-anim trig-anim-d3">
                            <h4>Step 3: Generalize</h4>
                            <p>Add the period (2n&pi; for sin/cos, n&pi; for tan) to express all infinite solutions.</p>
                        </div>
                        <div class="trig-feature-card trig-anim trig-anim-d4">
                            <h4>Step 4: Verify</h4>
                            <p>Substitute solutions back into the original equation. Discard any extraneous roots.</p>
                        </div>
                    </div>
                </div>

                <!-- 2. Common Solution Methods -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.5rem;">Common Solution Methods</h2>
                    <div style="overflow-x:auto;">
                        <table class="trig-ops-table">
                            <thead><tr><th>Method</th><th>When to Use</th><th>Example</th></tr></thead>
                            <tbody>
                                <tr><td>Direct Inverse</td><td>Simple form: sin(x) = k, cos(x) = k, tan(x) = k</td><td>sin(x) = 1/2 &rarr; x = &pi;/6, 5&pi;/6</td></tr>
                                <tr><td>Factoring</td><td>Quadratic in trig function or product equals zero</td><td>2cos&sup2;x &minus; cos x &minus; 1 = 0</td></tr>
                                <tr><td>Identity Substitution</td><td>Multiple trig functions &mdash; reduce to one function</td><td>sin&sup2;x + sin x = 0</td></tr>
                                <tr><td>Double Angle</td><td>Contains 2x terms alongside x terms</td><td>sin(2x) = cos(x)</td></tr>
                                <tr><td>Squaring Both Sides</td><td>Mixed functions (check for extraneous!)</td><td>sin x + cos x = 1</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="trig-worked-example" style="margin-top:1rem;">
                        <strong>Example:</strong> Solve sin(x) = 1/2<br>
                        1. Reference angle: arcsin(1/2) = &pi;/6 = 30&deg;<br>
                        2. sin is positive in Q1 and Q2<br>
                        3. Solutions in [0, 2&pi;): x = &pi;/6 and x = 5&pi;/6<br>
                        4. General: <strong>x = &pi;/6 + 2n&pi;</strong> and <strong>x = 5&pi;/6 + 2n&pi;</strong>, n &isin; &integers; &nbsp;&#10003;
                    </div>
                </div>

                <!-- 3. General Solutions + No Solution -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">General Solutions &amp; the &ldquo;No Solution&rdquo; Cases</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.5rem;">Standard general-solution forms:</p>
                    <div class="trig-formula-box" style="line-height:2;">
                        <strong>sin(x) = k</strong> &nbsp;(|k| &le; 1): &nbsp; x = arcsin(k) + 2n&pi; &nbsp;or&nbsp; x = &pi; &minus; arcsin(k) + 2n&pi;<br>
                        <strong>cos(x) = k</strong> &nbsp;(|k| &le; 1): &nbsp; x = &plusmn;arccos(k) + 2n&pi;<br>
                        <strong>tan(x) = k</strong> &nbsp;(any real k): &nbsp; x = arctan(k) + n&pi;
                    </div>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-top:0.75rem;">Sine and cosine are bounded between &minus;1 and 1, so equations like <strong>sin(x) = 2</strong>, <strong>cos(x) = &minus;3</strong>, or <strong>csc(x) = 0.5</strong> have <strong>no solution</strong>. Our solver detects these automatically.</p>
                </div>

                <!-- 4. Trig Inequalities + Simplification -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">Trig Inequalities &amp; Simplification</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.5rem;"><strong>Inequalities:</strong> solve the corresponding equation to find critical points, test intervals, then write the answer in interval notation with periodicity.</p>
                    <div class="trig-worked-example">
                        <strong>Example:</strong> sin(x) &gt; 1/2 &nbsp;&rarr;&nbsp; <strong>(&pi;/6 + 2n&pi;, &nbsp; 5&pi;/6 + 2n&pi;)</strong>, &nbsp; n &isin; &integers;
                    </div>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-top:0.75rem;"><strong>Simplification:</strong> rewrite an expression in a more compact equivalent form using Pythagorean, double-angle, and sum-to-product identities. Example: <em>(sin&#8308;x &minus; cos&#8308;x)/(sin&sup2;x &minus; cos&sup2;x) = 1</em>.</p>
                </div>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- ═══ VISIBLE FAQ (mirrors faqNq/faqNa above) ═══ -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Trig equation solver FAQ">
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">Can I scan a trig equation from a photo?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Yes. Click the green <strong>&#128247; Scan</strong> button next to the expression input, upload a photo or PDF of your homework, and our AI extracts every trig equation along with the mode (equation / inequality / simplify) and angle unit.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How do I solve trig equations step by step?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Enter the equation like <em>sin(x)=1/2</em> or <em>2cos&sup2;(x)&minus;1=0</em>. For simple forms, solutions compute instantly; for complex equations the AI solver provides step-by-step work with all solutions in [0, 2&pi;) plus the general solution.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What is the general solution of a trig equation?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Trig functions are periodic, so equations have infinitely many solutions. We add +2n&pi; for sine and cosine or +n&pi; for tangent (n any integer) to capture them all.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">Can the solver handle trig inequalities?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Yes &mdash; switch to <strong>Inequality</strong> mode and enter inequalities like <em>sin(x)&gt;1/2</em> or <em>cos(x)&le;0</em>. The solver finds critical points, tests intervals, and writes the solution set in interval notation with periodicity.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How does trig simplification work?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Enter any trig expression like <em>(sin&#8308;x&minus;cos&#8308;x)/(sin&sup2;x&minus;cos&sup2;x)</em>. The solver applies Pythagorean, double-angle, and other identities step-by-step, then verifies the result by checking a specific angle.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What if my equation has no solution?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">The solver detects impossible equations like <em>sin(x)=2</em> (sine is bounded between &minus;1 and 1) and impossible inequalities like <em>sin(x)&gt;2</em>, and reports &ldquo;No Solution&rdquo; with a range explanation.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What equation types are supported?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Simple forms (sin(x)=k, cos(x)=k, tan(x)=k), quadratic forms (2cos&sup2;x&minus;1=0), multi-function equations (sin(2x)=cos(x)), product equations (sinx&middot;cosx=1/2), and any combination using standard trig notation.</div></div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2026 8gwifi.org &mdash; Free Online Tools</p>
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
          2. nerdamer                   — client-side simplify backend used by trig-equation-core
          3. trig-* JS                  — existing controller stack (unchanged; reads trig-* IDs)
          4. math-input-multi           — MathLive Visual/Text on the trig-expr input (.mml-pair)
          5. inline scan + busy-lock + headline-chip + simplify-mode + FAQ accordion
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />

    <script>window.TRIG_CALC_CTX = "<%=request.getContextPath()%>";</script>

    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>

    <script src="<%=request.getContextPath()%>/js/trig-common.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-graph.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-export.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-equation-core.js?v=<%=cacheVersion%>"></script>

    <%-- SymPy fast path — exposes window.TrigBackend.compute for the
         controller to call between the regex shortcut and the LLM. --%>
    <jsp:include page="/math/partials/trig-calculator-scripts.jsp" />

    <jsp:include page="/math/partials/math-input-multi.jsp" />

    <script>
    // ─────────────────────────────────────────────────────────────────────
    //  Headline example chips above the accordion
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        document.querySelectorAll('.ic-example-chip[data-headline]').forEach(function (chip) {
            chip.addEventListener('click', function () {
                var apply = function () {
                    var mode = chip.getAttribute('data-mode') || 'solve_equation';
                    var expr = chip.getAttribute('data-expr') || '';
                    var modeBtn = document.querySelector('.trig-mode-btn[data-mode="' + mode + '"]');
                    if (modeBtn) modeBtn.click();
                    var el = document.getElementById('trig-expr');
                    if (el) {
                        el.value = expr;
                        el.dispatchEvent(new Event('input', { bubbles: true }));
                    }
                    setTimeout(function () {
                        var b = document.getElementById('trig-calc-btn'); if (b) b.click();
                    }, 250);
                };
                if (window.customElements && customElements.whenDefined) {
                    customElements.whenDefined('math-field').then(apply, apply);
                } else { apply(); }
            });
        });
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  Note: the unit-toggle is hidden in Simplify mode by the controller
    //  (trig-equation-core.js → switchMode) — no inline handler needed.
    // ─────────────────────────────────────────────────────────────────────

    // ─────────────────────────────────────────────────────────────────────
    //  .is-busy spinner lock on Solve
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        var btn = document.getElementById('trig-calc-btn');
        var resultContent = document.getElementById('trig-result-content');
        if (!btn || !resultContent) return;
        var resultObserver = null, safetyTimer = null;
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
    //  AI photo scan — trig-equation-specific extraction prompt
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        if (typeof ImageToMath === 'undefined') return;
        var CTX = window.TRIG_CALC_CTX || '';
        ImageToMath.init({
            buttonId: 'trig-scan-btn',
            aiUrl: CTX + '/ai',
            toolName: 'Trig Equation Solver',
            extractionPrompt:
                'You are a math problem extractor for a trig equation solver. The solver has 3 modes: solve_equation, solve_inequality, simplify.\n' +
                'Return a JSON array. Each object has:\n' +
                '  - "mode": "solve_equation" | "solve_inequality" | "simplify"\n' +
                '  - "expr": the equation, inequality, or expression in calculator syntax (sin/cos/tan/csc/sec/cot, pi, * for multiplication, ^ for power).\n' +
                '  - "unit": "deg" | "rad"  (omit or default rad for simplify)\n' +
                '  - "display": full problem in LaTeX for the card heading\n' +
                'Mapping rules:\n' +
                '  · "Solve sin(x)=1/2" / "Find all x with cos(x)=0" → mode="solve_equation", expr contains an "="\n' +
                '  · "Solve sin(x) > 1/2" / "cos(x) ≤ 0" → mode="solve_inequality", expr contains <, >, ≤, ≥\n' +
                '  · "Simplify (sin^4 x − cos^4 x)/(sin^2 x − cos^2 x)" → mode="simplify", no = or inequality sign\n' +
                'CRITICAL: Return ONLY valid JSON, no fences. If no problem found, return [].\n' +
                'Example: "Solve sin(x)=1/2" → [{"mode":"solve_equation","expr":"sin(x)=1/2","unit":"rad","display":"\\\\sin(x)=\\\\tfrac{1}{2}"}]',
            onSelect: function (problem) {
                var apply = function () {
                    var mode = problem.mode || 'solve_equation';
                    var modeBtn = document.querySelector('.trig-mode-btn[data-mode="' + mode + '"]');
                    if (modeBtn) modeBtn.click();
                    if (problem.unit && mode !== 'simplify') {
                        var unitBtn = document.querySelector('.trig-unit-btn[data-unit="' + problem.unit + '"]');
                        if (unitBtn) unitBtn.click();
                    }
                    var el = document.getElementById('trig-expr');
                    if (el) {
                        el.value = problem.expr || '';
                        el.dispatchEvent(new Event('input', { bubbles: true }));
                    }
                    setTimeout(function () {
                        var b = document.getElementById('trig-calc-btn'); if (b) b.click();
                    }, 250);
                };
                if (window.customElements && customElements.whenDefined) {
                    customElements.whenDefined('math-field').then(apply, apply);
                } else { apply(); }
            }
        });
    })();

    // ── FAQ accordion + scroll-anim ──
    (function () {
        document.querySelectorAll('.ms-faq-q').forEach(function (q) {
            q.addEventListener('click', function () { q.closest('.ms-faq-item').classList.toggle('open'); });
        });
        var els = document.querySelectorAll('.trig-anim');
        if (els.length && 'IntersectionObserver' in window) {
            var io = new IntersectionObserver(function (entries) {
                entries.forEach(function (e) {
                    if (e.isIntersecting) { e.target.classList.add('trig-visible'); io.unobserve(e.target); }
                });
            }, { threshold: 0.15 });
            els.forEach(function (el) { io.observe(el); });
        }
    })();
    </script>

    <!-- ─── Trigonometry practice worksheet (shared across all 3 trig calcs) ─── -->
    <script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>
    <script>
    (function () {
        function openTrigWorksheet() {
            if (!window.WorksheetEngine || typeof window.WorksheetEngine.open !== 'function') {
                if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
                    ToolUtils.showToast('Worksheet engine not loaded', 2500, 'warning');
                }
                return;
            }
            window.WorksheetEngine.open({
                jsonUrl: '<%=request.getContextPath()%>/worksheet/math/trigonometry/trigonometry.json',
                title: 'Trigonometry',
                accentColor: '#15803d',
                branding: '8gwifi.org',
                defaultCount: 20
            });
        }
        function whenReady(fn) {
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', fn);
            } else { fn(); }
        }
        whenReady(function () {
            var primary = document.getElementById('trig-worksheet-btn');
            if (primary) primary.addEventListener('click', openTrigWorksheet);
            var toolbar = document.getElementById('trig-worksheet-btn-toolbar');
            if (toolbar) toolbar.addEventListener('click', openTrigWorksheet);
        });
    })();
    </script>
</body>
</html>
