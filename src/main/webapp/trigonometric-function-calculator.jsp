<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Trig Function Calculator — math-studio shell (matches integral /
        ODE / PDE / matrix calculators).  Wraps existing trig-* markup
        verbatim so /js/trig-common.js + /js/trig-evaluator-core.js +
        /js/trig-graph.js + /js/trig-export.js continue to work without
        modification (every trig-* id and class preserved).

        New on top of the legacy page:
          · math-studio shell (sidebar, ms-rail, matter-bg, ic-stack)
          · MathLive Visual/Text on the trig-expr input (mml-pair)
          · AI photo scan with a trig-function-specific extraction prompt
          · ".is-busy" spinner lock on the primary CTA
          · Friendlier "Evaluate & explain →" button copy
          · Headline example chips inline (above the legacy "More examples")
          · Three-badge result-row noise hidden (matches the ODE pattern)
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow,max-image-preview:large,max-snippet:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Trig Function Calculator with Steps + AI Photo Scan" />
        <jsp:param name="toolDescription" value="Free AI trig function calculator with step-by-step solutions and photo scan. Evaluate sin, cos, tan, csc, sec, cot at any angle (degrees or radians). Find quadrants, reference angles, coterminal angles. Snap a textbook problem or type any expression. Interactive unit circle. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="trigonometric-function-calculator.jsp" />
        <jsp:param name="toolKeywords" value="trigonometric function calculator, trig calculator online, evaluate sin cos tan, AI trig calculator, trig calculator scan image, snap trig problem, photo math trig, unit circle calculator, quadrant calculator, reference angle calculator, coterminal angles calculator, special angle values, ASTC rule, trig values table, exact trig values, sin cos tan calculator with steps, trig calculator degrees radians, MathLive trig editor, free trig calculator no signup" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="AI photo scan with step-by-step solver,MathLive visual trig editor (Visual / Text toggle),Evaluate all 6 trig functions at any angle,Exact values for special angles (0 30 45 60 90),Quadrant and reference angle finder,Coterminal angles with general formula,Interactive unit circle visualization,Step-by-step solutions with LaTeX,Python SymPy code generation,Degrees / radians toggle,Live KaTeX preview,Copy LaTeX Share URL,Dark mode no signup no limits free" />
        <jsp:param name="teaches" value="Trigonometric functions, unit circle, reference angles, coterminal angles, quadrant signs, ASTC rule, special angle values, radians and degrees" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Snap a photo OR type the expression|Click the camera button to scan a problem from a photo OR type a trig expression like sin(45) cos(pi/3) tan(60) directly using the MathLive visual editor.,Pick a mode|Choose Evaluate to compute values OR Quadrant to find quadrant info OR Coterminal to find coterminal angles.,Select degrees or radians|Toggle the angle unit if needed.,Click Evaluate|Step-by-step solution renders with full LaTeX rendering.,View graph|Switch to Graph for the interactive unit circle visualization or Python for editable SymPy code." />
        <jsp:param name="faq1q" value="Can I scan a trig problem from a photo?" />
        <jsp:param name="faq1a" value="Yes. Click the green Scan button next to the expression input, upload a photo or PDF of your homework, and our AI extracts every trig problem on the page along with the angle unit (degrees or radians). Pick one to fill the form and solve. Works on textbook pages, exam papers, and handwritten work." />
        <jsp:param name="faq2q" value="How do I evaluate trig functions at any angle?" />
        <jsp:param name="faq2a" value="Enter the trig function and angle like sin(45) or cos(pi/3). For special angles (0, 30, 45, 60, 90 degrees and their multiples), you get exact values with radicals. For other angles, you get decimal approximations. Toggle between degrees and radians using the unit button." />
        <jsp:param name="faq3q" value="How do I find the quadrant of an angle?" />
        <jsp:param name="faq3a" value="Switch to Quadrant mode and enter any angle. The calculator normalizes it to 0-360 degrees, tells you the quadrant (Q1-Q4), shows the reference angle, and displays the signs of all 6 trig functions using the ASTC rule (All Students Take Calculus)." />
        <jsp:param name="faq4q" value="What are coterminal angles?" />
        <jsp:param name="faq4a" value="Coterminal angles share the same terminal side on the unit circle. They differ by multiples of 360 degrees (or 2 pi radians). For example 30, 390, and -330 degrees are all coterminal. Our calculator shows 3 positive and 3 negative coterminal angles for any input." />
        <jsp:param name="faq5q" value="What are the exact values of trig functions for special angles?" />
        <jsp:param name="faq5a" value="Special angles (0, 30, 45, 60, 90 degrees) have exact trig values using fractions and square roots. For example sin(30)=1/2, cos(45)=sqrt(2)/2, tan(60)=sqrt(3). This calculator shows all 6 function values for every special angle." />
        <jsp:param name="faq6q" value="What is the ASTC rule for trigonometry?" />
        <jsp:param name="faq6a" value="ASTC stands for All Students Take Calculus. It tells which trig functions are positive in each quadrant: Q1 All positive, Q2 Sine positive, Q3 Tangent positive, Q4 Cosine positive. The reciprocal functions follow: csc with sin, sec with cos, cot with tan." />
        <jsp:param name="faq7q" value="How do I convert between degrees and radians?" />
        <jsp:param name="faq7a" value="To convert degrees to radians multiply by pi/180. To convert radians to degrees multiply by 180/pi. For example 90 degrees = pi/2 radians and pi/3 radians = 60 degrees. Our calculator accepts both units with a single toggle." />
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
    /* Busy-spinner for the primary CTA — locks Calculate while compute is
       in flight and adds a small spinner glyph. */
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

        <% request.setAttribute("activeService", "trig-fn"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Trig Functions</span>
                </nav>
                <h1>Trigonometric Function Calculator</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="trig-hero" data-input-mode="visual">

                    <!-- Top row: mode toggle + Visual/Text + Scan -->
                    <div class="ic-hero-top">
                        <div class="ic-mode-toggle trig-mode-toggle" role="radiogroup" aria-label="Trig calculator mode">
                            <button type="button" class="ic-mode-btn trig-mode-btn active" data-mode="evaluate"   role="radio" aria-checked="true"  title="Compute trig values at an angle">Evaluate</button>
                            <button type="button" class="ic-mode-btn trig-mode-btn"        data-mode="quadrant"   role="radio" aria-checked="false" title="Find quadrant + reference angle + ASTC signs">Quadrant</button>
                            <button type="button" class="ic-mode-btn trig-mode-btn"        data-mode="coterminal" role="radio" aria-checked="false" title="List coterminal angles">Coterminal</button>
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
                        <math-field class="ic-mathfield mml-mathfield" aria-label="Trig expression"
                                    placeholder="\sin(45)"
                                    smart-mode="on" smart-fence="on" smart-superscript="on"></math-field>
                        <input type="text" class="trig-input-text mml-text" id="trig-expr"
                               value="sin(45)" placeholder="e.g. sin(45), 210, pi/3"
                               autocomplete="off" spellcheck="false" aria-label="Trig expression text">
                        <span class="tool-form-hint ic-expr-hint">
                            <span class="ic-hint-visual">Type <code>sin</code>, <code>cos</code>, <code>tan</code>, <code>pi</code> naturally — use the Visual editor for fractions and roots.</span>
                            <span class="ic-hint-text">Evaluate: <code>sin(45)</code>, <code>cos(pi/3)</code> &middot; Quadrant / Coterminal: just an angle like <code>210</code> or <code>750</code>.</span>
                        </span>
                    </div>

                    <!-- Unit toggle — degrees / radians -->
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
                        <span class="ic-preview trig-preview" id="trig-preview">type an expression above&hellip;</span>
                    </div>

                    <!-- Primary CTA — id="trig-calc-btn" preserves the legacy JS hook -->
                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta" id="trig-calc-btn" data-mml-submit>Evaluate &amp; explain &rarr;</button>
                        <button type="button" class="ode-random-btn" id="trig-clear-btn" title="Clear input">&#128465; Clear</button>
                    </div>

                    <!-- Headline examples — one row of starting points
                         students can tap to fill the form and run. -->
                    <div class="ic-method-row" style="margin:0.4rem 0 0.2rem;">
                        <span class="ic-method-label">Try one</span>
                        <button type="button" class="ic-example-chip" data-headline data-mode="evaluate"   data-expr="sin(45)"   data-unit="deg" title="Evaluate sin at 45°">sin(45&deg;)</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="evaluate"   data-expr="cos(pi/3)" data-unit="rad" title="Evaluate cos at π/3">cos(&pi;/3)</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="evaluate"   data-expr="tan(60)"   data-unit="deg" title="Evaluate tan at 60°">tan(60&deg;)</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="quadrant"   data-expr="210"       data-unit="deg" title="Find quadrant of 210°">Quadrant 210&deg;</button>
                        <button type="button" class="ic-example-chip" data-headline data-mode="coterminal" data-expr="750"       data-unit="deg" title="Coterminal angles of 750°">Coterminal 750&deg;</button>
                    </div>
                    <!-- Hidden anchor for legacy share-URL / iframe deep-links
                         that may still reference #trig-examples. -->
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
                                    <div class="ic-empty-illustration">sin &theta;</div>
                                    <h3>Ready when you are</h3>
                                    <p>Type a trig expression above and hit <strong>Evaluate</strong>.</p>
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
                                <p id="trig-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Calculate to see the unit circle / graph.</p>
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

                <!-- 1. Understanding Trig Functions -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">Understanding Trigonometric Functions</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.75rem;">The six trigonometric functions &mdash; <strong>sine</strong>, <strong>cosine</strong>, <strong>tangent</strong>, <strong>cosecant</strong>, <strong>secant</strong>, and <strong>cotangent</strong> &mdash; relate angles to ratios of sides in a right triangle. On the <strong>unit circle</strong> (radius 1, centred at the origin), for any angle &theta; the coordinates of the terminal point are (<em>cos &theta;</em>, <em>sin &theta;</em>). These functions are foundational in physics, engineering, signal processing, and navigation.</p>

                    <div class="trig-feature-grid">
                        <div class="trig-feature-card trig-anim trig-anim-d1">
                            <h4>Primary Functions</h4>
                            <p><strong>sin &theta;</strong> = opposite / hypotenuse<br><strong>cos &theta;</strong> = adjacent / hypotenuse<br><strong>tan &theta;</strong> = opposite / adjacent</p>
                        </div>
                        <div class="trig-feature-card trig-anim trig-anim-d2">
                            <h4>Reciprocal Functions</h4>
                            <p><strong>csc &theta;</strong> = 1/sin &theta;<br><strong>sec &theta;</strong> = 1/cos &theta;<br><strong>cot &theta;</strong> = 1/tan &theta;</p>
                        </div>
                        <div class="trig-feature-card trig-anim trig-anim-d3">
                            <h4>Key Relationships</h4>
                            <p>sin&sup2;&theta; + cos&sup2;&theta; = 1<br>tan &theta; = sin &theta; / cos &theta;<br>Period: sin, cos = 2&pi;; tan = &pi;</p>
                        </div>
                    </div>
                </div>

                <!-- 2. Special Angles Table -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.5rem;">Special Angle Values</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.75rem;">The angles 0&deg;, 30&deg;, 45&deg;, 60&deg;, 90&deg; produce <strong>exact trig values</strong> using fractions and square roots. Memorising this table is essential for precalculus, calculus, and standardised tests.</p>
                    <div style="overflow-x:auto;">
                        <table class="trig-ops-table">
                            <thead><tr><th>Angle</th><th>sin</th><th>cos</th><th>tan</th><th>csc</th><th>sec</th><th>cot</th></tr></thead>
                            <tbody>
                                <tr><td>0&deg;</td><td>0</td><td>1</td><td>0</td><td>undef</td><td>1</td><td>undef</td></tr>
                                <tr><td>30&deg;</td><td>1/2</td><td>&radic;3/2</td><td>1/&radic;3</td><td>2</td><td>2/&radic;3</td><td>&radic;3</td></tr>
                                <tr><td>45&deg;</td><td>&radic;2/2</td><td>&radic;2/2</td><td>1</td><td>&radic;2</td><td>&radic;2</td><td>1</td></tr>
                                <tr><td>60&deg;</td><td>&radic;3/2</td><td>1/2</td><td>&radic;3</td><td>2/&radic;3</td><td>2</td><td>1/&radic;3</td></tr>
                                <tr><td>90&deg;</td><td>1</td><td>0</td><td>undef</td><td>1</td><td>undef</td><td>0</td></tr>
                            </tbody>
                        </table>
                    </div>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);font-size:0.85rem;margin-top:0.75rem;"><strong>Memory trick:</strong> sin values for 0&deg;, 30&deg;, 45&deg;, 60&deg;, 90&deg; follow &radic;0/2, &radic;1/2, &radic;2/2, &radic;3/2, &radic;4/2. Cosine is the same sequence reversed.</p>
                </div>

                <!-- 3. ASTC + Reference Angles -->
                <div class="tool-card trig-anim" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">ASTC Rule &mdash; Signs by Quadrant</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.75rem;">The mnemonic <strong>&ldquo;All Students Take Calculus&rdquo;</strong> tells which trig functions are positive in each quadrant: <strong>Q1</strong> All &middot; <strong>Q2</strong> Sine &middot; <strong>Q3</strong> Tangent &middot; <strong>Q4</strong> Cosine.</p>
                    <div class="trig-worked-example">
                        <strong>Example:</strong> Evaluate sin(150&deg;)<br>
                        1. 150&deg; is in Q2 &rarr; reference angle = 180&deg; &minus; 150&deg; = 30&deg;<br>
                        2. sin(30&deg;) = 1/2<br>
                        3. In Q2 sine is positive (ASTC: S)<br>
                        4. sin(150&deg;) = +1/2 &nbsp;&#10003;
                    </div>
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
        <div class="ms-faq" aria-label="Trig function calculator FAQ">
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">Can I scan a trig problem from a photo?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Yes. Click the green <strong>&#128247; Scan</strong> button next to the expression input, upload a photo or PDF of your homework, and our AI extracts every trig problem on the page along with the angle unit. Pick a problem to fill the form and solve.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How do I evaluate trig functions at any angle?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Enter the trig function and angle like <em>sin(45)</em> or <em>cos(pi/3)</em>. For special angles you get exact values with radicals; for other angles, decimal approximations. Toggle degrees / radians.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How do I find the quadrant of an angle?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Switch to <strong>Quadrant</strong> mode and enter any angle. The calculator normalises it to 0&ndash;360&deg;, names the quadrant (Q1&ndash;Q4), shows the reference angle, and prints ASTC signs.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What are coterminal angles?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Coterminal angles share the same terminal side on the unit circle. They differ by multiples of 360&deg; (or 2&pi; rad). 30&deg;, 390&deg;, &minus;330&deg; are all coterminal &mdash; identical trig values.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What are the exact values for special angles?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">0&deg;, 30&deg;, 45&deg;, 60&deg;, 90&deg; produce exact values with fractions and square roots. e.g. sin(30&deg;)=1/2, cos(45&deg;)=&radic;2/2, tan(60&deg;)=&radic;3.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What is the ASTC rule?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a"><strong>All Students Take Calculus</strong>: Q1 = all positive, Q2 = sine (and csc) positive, Q3 = tangent (and cot) positive, Q4 = cosine (and sec) positive.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How do I convert between degrees and radians?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">degrees &rarr; radians: multiply by &pi;/180. radians &rarr; degrees: multiply by 180/&pi;. e.g. 90&deg; = &pi;/2 rad, &pi;/3 rad = 60&deg;. The unit toggle handles both.</div></div>
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
          2. trig-* JS                  — existing controller stack (unchanged; reads trig-* IDs)
          3. math-input-multi           — MathLive Visual/Text on the trig-expr input (.mml-pair)
          4. inline scan + busy-lock + headline-chip + FAQ accordion
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />

    <script>window.TRIG_CALC_CTX = "<%=request.getContextPath()%>";</script>

    <script src="<%=request.getContextPath()%>/js/trig-common.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-graph.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-export.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-evaluator-core.js?v=<%=cacheVersion%>"></script>

    <%-- SymPy fast path — fallback for composed expressions the simple
         "single trig call" parser rejects (sin(20)cos(40)sin(80) etc.). --%>
    <jsp:include page="/math/partials/trig-calculator-scripts.jsp" />

    <jsp:include page="/math/partials/math-input-multi.jsp" />

    <script>
    // ─────────────────────────────────────────────────────────────────────
    //  Headline example chips above the accordion
    //
    //  data-mode (evaluate / quadrant / coterminal), data-expr (text the
    //  legacy controller will read from #trig-expr), data-unit (deg/rad).
    //  Sets each, dispatches input, then clicks Calculate after a small
    //  delay so MathLive has time to mirror.
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        document.querySelectorAll('.ic-example-chip[data-headline]').forEach(function (chip) {
            chip.addEventListener('click', function () {
                var apply = function () {
                    var mode = chip.getAttribute('data-mode') || 'evaluate';
                    var expr = chip.getAttribute('data-expr') || '';
                    var unit = chip.getAttribute('data-unit');
                    var modeBtn = document.querySelector('.trig-mode-btn[data-mode="' + mode + '"]');
                    if (modeBtn) modeBtn.click();
                    if (unit) {
                        var unitBtn = document.querySelector('.trig-unit-btn[data-unit="' + unit + '"]');
                        if (unitBtn) unitBtn.click();
                    }
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
    //  .is-busy spinner lock on Calculate
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
    //  AI photo scan — trig-function-specific extraction prompt
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        if (typeof ImageToMath === 'undefined') return;
        var CTX = window.TRIG_CALC_CTX || '';
        ImageToMath.init({
            buttonId: 'trig-scan-btn',
            aiUrl: CTX + '/ai',
            toolName: 'Trig Function Calculator',
            extractionPrompt:
                'You are a math problem extractor for a trig function calculator. The calculator has 3 modes: evaluate, quadrant, coterminal.\n' +
                'Return a JSON array. Each object has:\n' +
                '  - "mode": "evaluate" | "quadrant" | "coterminal"\n' +
                '  - "expr": for evaluate, a trig expression like "sin(45)", "cos(pi/3)", "tan(60)" using calculator syntax (sin/cos/tan/csc/sec/cot, pi, * for multiplication).  For quadrant or coterminal, just an angle like "210" or "750".\n' +
                '  - "unit": "deg" | "rad"\n' +
                '  - "display": full problem in LaTeX for the card heading\n' +
                'Mapping rules:\n' +
                '  · "Find sin(45°)" / "Evaluate cos(π/3)" → mode="evaluate"\n' +
                '  · "Which quadrant is 210°?" → mode="quadrant"\n' +
                '  · "Find coterminal angles of 750°" → mode="coterminal"\n' +
                'CRITICAL: Return ONLY valid JSON, no fences. If no problem found, return [].\n' +
                'Example: "Evaluate sin(45°)" → [{"mode":"evaluate","expr":"sin(45)","unit":"deg","display":"\\\\sin(45^\\\\circ)"}]',
            onSelect: function (problem) {
                var apply = function () {
                    var mode = problem.mode || 'evaluate';
                    var modeBtn = document.querySelector('.trig-mode-btn[data-mode="' + mode + '"]');
                    if (modeBtn) modeBtn.click();
                    if (problem.unit) {
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

    // ── FAQ accordion (existing scroll-anim + new ms-faq) ──
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
