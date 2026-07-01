<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis());
   request.setAttribute("aiToolId", "math-ai");
   request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Inequality Solver — migrated to math-studio shell (Phase 2).

        Architecture:
          · Single MathLive input. ascii-math mirrors into #ic-expr; the
            extracted scripts partial reads from there.
          · AI image-scan via image-to-math.js + inequality-specific prompt.
          · Empty-state chips cover all 6 inequality types (linear,
            quadratic, polynomial, rational, absolute-value, compound).
          · Hidden #iq-examples, #iq-syntax-btn, #iq-preview keep the
            extracted partial's IIFE happy without visible chrome.

        SEO ported VERBATIM from the original (6 FAQ pairs, full keywords,
        feature list).

        Positioning: this page owns "general inequalities" — linear,
        polynomial, rational, absolute-value, compound. Quadratic
        inequalities are also covered, but quadratic-solver.jsp has the
        deeper step methods; cross-link sends users there for that case.
    --%>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Inequality Solver — AI Photo Scan, Step-by-Step Free" />
        <jsp:param name="toolDescription" value="Free inequality solver with AI photo scan. Solve linear, quadratic, polynomial, rational, absolute value, and compound inequalities with full sign chart steps." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="inequality-solver.jsp" />
        <jsp:param name="toolKeywords" value="inequality solver, solve inequalities online, inequality calculator with steps, quadratic inequality solver, polynomial inequality calculator, rational inequality solver, absolute value inequality, interval notation calculator, sign chart method, inequality graphing calculator, solve inequalities step by step free, ai inequality solver, photo math solver, scan inequality from photo, ai math homework helper, inequality photo solver, math problem photo scanner, compound inequality calculator, set builder notation calculator" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="AI photo scanner extracts inequalities from images,Step-by-step sign chart method,Linear and quadratic inequalities,Polynomial inequality solver,Rational inequality solver,Absolute value inequalities,Compound inequalities,Interval notation output,Set-builder notation,Interactive number line,Function graph with solution shading,Download PDF,Copy LaTeX,Share via URL,Python compiler,Photo math problem solver,Auto-detect inequality type from image,1500+ practice worksheet problems,Printable worksheet with answer key,35 question types from basic to scholar,NCERT Class 11 word problems,IIT-JEE Advanced and Putnam-level problems,Free with no signup or limits,Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What types of inequalities can this solver handle?" />
        <jsp:param name="faq1a" value="This solver handles linear inequalities (2x+3>7), quadratic inequalities (x^2-4>=0), polynomial inequalities (x^3-x<0), rational inequalities ((x-1)/(x+2)>0), absolute value inequalities (|x-3|<5), and compound inequalities (1<2x+3<7). It finds all solutions using the sign chart method and presents results in interval notation and set-builder notation." />
        <jsp:param name="faq2q" value="How does the sign chart method work?" />
        <jsp:param name="faq2a" value="The sign chart method works by: (1) moving all terms to one side to get f(x)>0, (2) finding critical points where f(x)=0 or is undefined, (3) testing the sign of f(x) in each interval between critical points, (4) selecting intervals where the sign satisfies the inequality. This method works for all polynomial and rational inequalities." />
        <jsp:param name="faq3q" value="What is interval notation?" />
        <jsp:param name="faq3a" value="Interval notation uses parentheses () for excluded endpoints (strict inequalities) and brackets [] for included endpoints (non-strict). For example, (-2,3] means all numbers greater than -2 and up to 3. Union symbol U combines disjoint intervals: (-inf,-2) U (2,inf). The empty set is shown as {} and all real numbers as (-inf,inf)." />
        <jsp:param name="faq4q" value="What is the difference between < and ≤?" />
        <jsp:param name="faq4a" value="The less-than symbol (<) is a strict inequality excluding the endpoint, shown with open circles on the number line and parentheses in interval notation. The less-than-or-equal symbol (≤) is non-strict and includes the endpoint, shown with closed/filled circles and brackets. For example, x<2 gives (-inf,2) while x≤2 gives (-inf,2]." />
        <jsp:param name="faq5q" value="Can I download or share my solution?" />
        <jsp:param name="faq5a" value="Yes. After solving an inequality you can: (1) Download as PDF with the original inequality, solution, sign chart, and steps, (2) Copy as LaTeX for papers and documents, (3) Copy as plain text, or (4) Generate a shareable URL. The PDF includes a watermark and date." />
        <jsp:param name="faq6q" value="Is this inequality solver free?" />
        <jsp:param name="faq6a" value="Yes, completely free with no signup, no account, and no limits. All computation runs client-side in your browser using the sign chart method. You get step-by-step solutions, interactive number line, function graph, PDF download, LaTeX export, and a Python SymPy compiler." />
        <jsp:param name="faq7q" value="Can I scan an inequality from a photo or textbook?" />
        <jsp:param name="faq7a" value="Yes. Click the Scan button and upload (or drop in) a photo of a handwritten or printed inequality. The AI vision model extracts the inequality (preserving < ≤ > ≥ symbols and absolute-value bars), fills the math field automatically, and detects the inequality type. Works on phone snapshots, textbook pages, whiteboard photos, and worksheet scans." />
        <jsp:param name="faq8q" value="What grade levels and curricula does this cover?" />
        <jsp:param name="faq8a" value="Covers Algebra 1 (linear inequalities, compound), Algebra 2 (quadratic, polynomial, rational, absolute value), Precalculus (sign chart analysis), and college algebra. Aligned with Common Core HSA-REI.B.3 and HSA-CED.A.1, plus CBSE/ICSE class 9-11 inequalities chapters. SAT, ACT, and JEE Mains practice covered." />
        <jsp:param name="faq9q" value="Where is the inequality practice worksheet?" />
        <jsp:param name="faq9a" value="Click the Practice Worksheet — 1,500+ inequalities with answer key button below the result. The worksheet engine generates printable problem sets across 4 difficulty tiers (basic, medium, hard, scholar) and 35 problem types — linear (with parens, fractions, sign-flip), quadratic (factored and general), polynomial (cubic), rational, absolute-value (simple, complex, compound), log, exponential, system of linear inequalities, NCERT Class 11 word problems (IQ/mental-age, acid-mixing, rectangle perimeter, score threshold), and IIT-JEE Advanced / Putnam scholar problems (exp-quadratic substitution, log fractional base, nested logs, square-root inequalities, modulus-vs-modulus, AM-GM optimisation, Cauchy-Schwarz, Bernoulli's inequality). Every problem and answer is CAS-verified." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css?v=<%=v%>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>
    <%@ include file="modern/components/math-ai-head.inc.jsp" %>
    <style>
    .ic-expr-label-actions .math-ai-tab-btn {
        display: inline-flex; align-items: center; gap: 0.35rem;
        appearance: none; border: 1px solid var(--ms-accent, #15803d);
        background: var(--ms-panel-bg, #fff); color: var(--ms-accent, #15803d);
        font: 600 0.78rem/1 var(--ms-font, system-ui);
        padding: 0.35rem 0.75rem; border-radius: 6px; cursor: pointer;
    }
    .ic-expr-label-actions .math-ai-tab-btn:hover { background: rgba(21, 128, 61, 0.08); }
    </style>

    <style>
        /* iq-* result rendering classes — pulled forward from legacy and
           tuned to math-studio tokens. The extracted partial generates
           HTML using these. */
        .iq-result-math { padding: 1.25rem; text-align: center; overflow-x: auto; max-width: 100%; }
        .iq-result-label {
            font-size: 0.72rem; font-weight: 600; text-transform: uppercase;
            letter-spacing: 0.05em; color: var(--ms-muted, #78716c);
            margin-bottom: 0.25rem; text-align: left;
        }
        .iq-result-solution {
            background: var(--ms-accent, #15803d); color: #fff;
            padding: 0.85rem 1rem; border-radius: var(--ms-radius, 14px);
            text-align: center; font-size: 1.2rem; font-weight: 700;
            margin: 0.6rem 0;
        }
        .iq-error {
            background: rgba(251,191,36,0.12); border: 1px solid rgba(251,191,36,0.4);
            border-radius: var(--ms-radius, 14px); padding: 1.1rem; color: #92400e;
        }
        [data-theme="dark"] .iq-error { background: rgba(251,191,36,0.15); color: #fbbf24; }
        .iq-error h4 { font-size: 0.95rem; margin: 0 0 0.5rem; font-weight: 600; }
        .iq-error p, .iq-error ul { font-size: 0.85rem; line-height: 1.5; margin: 0.25rem 0; }
        .iq-error ul { padding-left: 1.25rem; }

        .iq-sign-chart {
            width: 100%; border-collapse: collapse;
            font-size: 0.82rem; margin-top: 0.75rem;
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius-sm, 8px);
            overflow: hidden;
        }
        .iq-sign-chart th, .iq-sign-chart td {
            padding: 0.45rem 0.6rem;
            border-bottom: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            text-align: left;
        }
        .iq-sign-chart th {
            background: var(--ms-panel-bg-soft, #faf8f4);
            font-weight: 600; color: var(--ms-ink-soft, #44403c);
            font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.05em;
        }
        .iq-sign-chart td.positive { color: #15803d; font-weight: 700; }
        .iq-sign-chart td.negative { color: #dc2626; font-weight: 700; }
        .iq-sign-chart td.zero { color: var(--ms-muted, #78716c); font-weight: 600; }
        .iq-sign-chart td.in-solution { background: rgba(21,128,61,0.08); }

        .iq-steps-btn {
            display: inline-flex; align-items: center; gap: 0.4rem;
            padding: 0.5rem 0.95rem; font-size: 0.82rem; font-weight: 500;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-pill, 999px);
            background: transparent; color: var(--ms-ink-soft, #44403c);
            cursor: pointer; margin-top: 0.75rem;
            transition: background 200ms, color 200ms, border-color 200ms;
        }
        .iq-steps-btn:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            border-color: var(--ms-accent, #15803d);
        }
        .iq-steps-container {
            margin-top: 1rem;
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius, 14px); overflow: hidden;
        }
        .iq-steps-header {
            padding: 0.55rem 1rem;
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            font-size: 0.78rem; font-weight: 600;
        }
        .iq-step {
            padding: 0.7rem 1rem;
            border-bottom: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            display: flex; gap: 0.75rem; align-items: flex-start;
        }
        .iq-step:last-child { border-bottom: none; }
        .iq-step-num {
            flex-shrink: 0; width: 22px; height: 22px;
            border-radius: 50%;
            background: var(--ms-accent, #15803d); color: #fff;
            font-size: 0.72rem; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
        }
        .iq-step-body { flex: 1; min-width: 0; }
        .iq-step-title { font-size: 0.78rem; font-weight: 600; color: var(--ms-ink-soft, #44403c); margin-bottom: 0.25rem; }
        .iq-step-math { font-size: 0.95rem; overflow-x: auto; }

        .iq-legacy-hidden { display: none !important; }

        .ic-hero-cta-row .ic-clear-btn {
            padding: 0.5rem 0.9rem;
            font-size: 0.82rem; font-weight: 500;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-pill, 999px);
            background: transparent;
            color: var(--ms-ink-soft, #44403c);
            cursor: pointer;
            font-family: var(--ms-font-sans, Inter, sans-serif);
            transition: background 200ms, color 200ms, border-color 200ms;
        }
        .ic-hero-cta-row .ic-clear-btn:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            border-color: var(--ms-accent, #15803d);
        }

        .iq-var-row {
            display: flex; align-items: center; gap: 0.5rem;
            margin: 0.5rem 0 0.75rem;
        }
        .iq-var-row label {
            font-size: 0.72rem; font-weight: 600; color: var(--ms-muted, #78716c);
            text-transform: uppercase; letter-spacing: 0.05em;
        }
        .iq-var-row select {
            padding: 0.3rem 0.55rem;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-sm, 8px);
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            font-size: 0.85rem;
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-ink, #1c1917);
            cursor: pointer;
        }

        /* Empty-state chip grid (reuses quadratic/polynomial styling). */
        .qs-empty-chips {
            display: grid; grid-template-columns: auto 1fr;
            gap: 0.45rem 0.75rem; align-items: center;
            max-width: 460px; margin: 1rem auto 0; text-align: left;
        }
        .qs-empty-chips .qs-chip-label {
            font-size: 0.72rem; font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase; letter-spacing: 0.05em;
        }
        .qs-empty-chips .ic-example-chip {
            justify-self: start; text-align: left;
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            font-size: 0.85rem;
        }
        .qs-empty-hint {
            color: var(--ms-muted, #78716c);
            font-size: 0.8rem; margin: 1.25rem 0 0; text-align: center;
        }
    </style>
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

        <% request.setAttribute("activeService", "inequality"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Inequality</span>
                </nav>
                <h1>Inequality Solver &mdash; Sign Chart, Interval Notation &amp; Steps</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="ic-hero" data-input-mode="visual">

                    <div class="ic-hero-top">
                        <div class="ic-expr-label-actions" style="display:flex;gap:0.5rem;align-items:center;margin-left:auto;">
                            <div class="ic-input-mode-toggle" id="ic-input-mode-toggle" role="radiogroup" aria-label="Input mode">
                                <button type="button" class="ic-input-mode-btn active" data-input-mode="visual" role="radio" aria-checked="true" title="Write math visually">
                                    <span aria-hidden="true" style="font-family:'Times New Roman',serif;font-style:italic;">&fnof;</span><span class="ic-mode-label"> Visual</span>
                                </button>
                                <button type="button" class="ic-input-mode-btn" data-input-mode="text" role="radio" aria-checked="false" title="Type a plain-text inequality">
                                    <span aria-hidden="true" style="font-family:var(--font-mono,monospace);">&lt;/&gt;</span><span class="ic-mode-label"> Text</span>
                                </button>
                            </div>
                            <button type="button" class="ic-image-btn" id="iq-image-btn" title="Scan an inequality from an image">&#128247; Scan</button>
                            <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — solve in chat (Ctrl+Shift+A)">&#10024; AI</button>
                        </div>
                    </div>

                    <div class="ic-expr-wrap" id="ic-expr-wrap">
                        <math-field id="ic-mathfield" class="ic-mathfield" aria-label="Inequality"
                                    placeholder="x^2 - 5x + 6 < 0"
                                    math-virtual-keyboard-policy="manual"
                                    smart-mode="on" smart-fence="on" smart-superscript="on"
                                    remove-extraneous-parentheses="on" math-mode-space="\:"></math-field>

                        <input type="text" class="tool-input tool-input-mono" id="ic-expr"
                               placeholder="e.g.  x^2 - 5x + 6 < 0   or   |x - 3| <= 5"
                               autocomplete="off" spellcheck="false" aria-label="Inequality">

                        <span class="tool-form-hint ic-expr-hint">
                            <span class="ic-hint-visual">Use <code>&lt;</code> <code>&gt;</code> <code>&lt;=</code> <code>&gt;=</code> for the comparison. Absolute value: <code>|x - 3| &lt; 5</code>. Compound: <code>2 &lt; x+1 &lt; 8</code>.</span>
                            <span class="ic-hint-text"><code>x^2 - 5x + 6 &lt; 0</code> &middot; <code>(x-1)/(x+2) &gt; 0</code> &middot; <code>|x-3| &lt;= 5</code></span>
                        </span>
                    </div>

                    <div class="iq-var-row">
                        <label for="iq-var">Variable</label>
                        <select id="iq-var">
                            <option value="x" selected>x</option>
                            <option value="y">y</option>
                            <option value="z">z</option>
                            <option value="t">t</option>
                            <option value="n">n</option>
                        </select>
                    </div>

                    <!-- Primary CTA — IS the legacy #iq-solve-btn so the partial wires it directly. -->
                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta is-disabled" id="iq-solve-btn" aria-disabled="true">Solve Inequality</button>
                        <button type="button" class="ic-clear-btn" id="iq-clear-btn" title="Clear inputs and start over">Clear</button>
                        <span class="ic-hero-warn" id="iq-solve-warn" role="alert" aria-live="polite"></span>
                    </div>
                </div>

                <!-- ═══ RESULT CARD ═══
                     Tabs and panels carry BOTH ic-* and iq-* classes/IDs:
                     iq-* is what the legacy partial wires; ic-* picks up
                     math-studio shell styling. -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs" role="tablist">
                        <button type="button" class="ic-output-tab iq-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                        <button type="button" class="ic-output-tab iq-output-tab" data-panel="numberline" role="tab" aria-selected="false">Number Line</button>
                        <button type="button" class="ic-output-tab iq-output-tab" data-panel="graph" role="tab" aria-selected="false">Graph</button>
                        <button type="button" class="ic-output-tab iq-output-tab" data-panel="python" role="tab" aria-selected="false">Python</button>
                    </div>

                    <div class="ic-panel iq-panel active" id="iq-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="iq-result-content">
                                <div class="tool-empty-state ic-empty-state" id="iq-empty-state">
                                    <div class="ic-empty-illustration">&lt; &gt;</div>
                                    <h3>Try an inequality</h3>
                                    <div class="qs-empty-chips">
                                        <span class="qs-chip-label">Linear</span>
                                        <button type="button" class="ic-example-chip" data-expr="2x - 5 > 7">2x &minus; 5 &gt; 7</button>

                                        <span class="qs-chip-label">Quadratic</span>
                                        <button type="button" class="ic-example-chip" data-expr="x^2 - 5x + 6 < 0">x&sup2; &minus; 5x + 6 &lt; 0</button>

                                        <span class="qs-chip-label">Polynomial</span>
                                        <button type="button" class="ic-example-chip" data-expr="x^3 - 6x^2 + 11x - 6 >= 0">x&sup3; &minus; 6x&sup2; + 11x &minus; 6 &ge; 0</button>

                                        <span class="qs-chip-label">Rational</span>
                                        <button type="button" class="ic-example-chip" data-expr="(x+1)/(x-2) > 0">(x+1)/(x&minus;2) &gt; 0</button>

                                        <span class="qs-chip-label">Absolute</span>
                                        <button type="button" class="ic-example-chip" data-expr="|x - 3| <= 5">|x &minus; 3| &le; 5</button>

                                        <span class="qs-chip-label">Compound</span>
                                        <button type="button" class="ic-example-chip" data-expr="2 < x + 1 < 8">2 &lt; x + 1 &lt; 8</button>
                                    </div>
                                    <p class="qs-empty-hint">or type your own inequality above</p>
                                </div>
                            </div>

                            <div class="tool-result-actions" id="iq-result-actions">
                                <button type="button" class="tool-action-btn" id="iq-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="iq-copy-text-btn">Copy Text</button>
                                <button type="button" class="tool-action-btn" id="iq-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="iq-download-pdf-btn">Download PDF</button>
                                <button type="button" class="tool-action-btn" id="iq-worksheet-btn-toolbar">Worksheet</button>
                            </div>

                            <!-- Practice worksheet CTA (1,500 SymPy-verified problems
                                 across 35 types: linear, quadratic, polynomial,
                                 rational, abs-value, log, exp, system, NCERT word
                                 problems, and IIT-JEE / Putnam scholar problems). -->
                            <div class="ic-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="iq-worksheet-btn">
                                    Practice Worksheet &mdash; 1,500+ inequalities with answer key
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel iq-panel" id="iq-panel-numberline" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:200px;padding:1rem;display:flex;flex-direction:column;justify-content:center;">
                                <div id="iq-numberline-container" style="width:100%;"></div>
                                <p id="iq-numberline-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Solve an inequality to see its solution shaded on the number line.</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel iq-panel" id="iq-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:360px;padding:0.75rem;">
                                <div id="iq-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                                <p id="iq-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Solve an inequality to see f(x) graphed with the solution region shaded.</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel iq-panel" id="iq-panel-python" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="display:flex;align-items:center;gap:0.5rem;padding:0.6rem 0.75rem;">
                                <span style="font-size:0.78rem;color:var(--ms-muted);font-weight:600;">Template:</span>
                                <select id="iq-compiler-template" style="padding:0.35rem 0.6rem;border:1px solid var(--ms-line-strong);border-radius:6px;font-size:0.8rem;background:var(--ms-panel-bg);color:var(--ms-ink);">
                                    <option value="sympy-solve">SymPy solve_univariate_inequality</option>
                                    <option value="sympy-reduce">SymPy reduce_inequalities</option>
                                </select>
                            </div>
                            <div style="flex:1;min-height:0;">
                                <iframe id="iq-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <section class="ic-learn" aria-label="Inequality solving techniques">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Sign chart</span>
                    <code class="ic-learn-formula">find critical points &rarr; test intervals &rarr; pick those that satisfy</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Absolute value</span>
                    <code class="ic-learn-formula">|f| &lt; a &rArr; -a &lt; f &lt; a, &nbsp; |f| &gt; a &rArr; f &gt; a or f &lt; -a</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Rational</span>
                    <code class="ic-learn-formula">include numerator zeros, exclude denominator zeros (open circles)</code>
                </article>
            </section>

            <section class="ic-related-strip" style="margin-top:2rem;display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:0.75rem;">
                <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Just a quadratic?</div>
                    <div style="font-weight:600;">Quadratic Formula Calculator &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">Vertex, completing the square, factoring, and a 50-problem worksheet for degree-2.</div>
                </a>
                <a href="<%=request.getContextPath()%>/polynomial-calculator.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Working with polynomials?</div>
                    <div style="font-weight:600;">Polynomial Calculator &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">Add, subtract, multiply, divide, expand, factor, and find roots of any-degree polynomials.</div>
                </a>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- ═══ HIDDEN LEGACY STATE (referenced by the extracted partial)
         These elements MUST exist in DOM or the IIFE throws. The chip
         container (#iq-examples) gets a click handler bound but never fires
         because our visible chips live in the empty-state grid above. -->
    <div class="iq-legacy-hidden" aria-hidden="true">
        <div id="iq-preview"></div>
        <button type="button" id="iq-syntax-btn">Syntax</button>
        <div id="iq-syntax-content"></div>
        <div id="iq-examples"></div>
    </div>

    <!-- Visible FAQ — keep in sync with faqNq/faqNa jsp:params. -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Inequality solver FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What types of inequalities can this solver handle?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">This solver handles <strong>linear</strong> (<em>2x + 3 &gt; 7</em>), <strong>quadratic</strong> (<em>x&sup2; &minus; 4 &ge; 0</em>), <strong>polynomial</strong> (<em>x&sup3; &minus; x &lt; 0</em>), <strong>rational</strong> (<em>(x &minus; 1)/(x + 2) &gt; 0</em>), <strong>absolute value</strong> (<em>|x &minus; 3| &lt; 5</em>), and <strong>compound</strong> (<em>1 &lt; 2x + 3 &lt; 7</em>) inequalities. It finds all solutions using the sign chart method and presents results in interval notation and set-builder notation.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How does the sign chart method work?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The <strong>sign chart method</strong> works by: (1) moving all terms to one side to get <em>f(x) &gt; 0</em>, (2) finding critical points where <em>f(x) = 0</em> or is undefined, (3) testing the sign of <em>f(x)</em> in each interval between critical points, (4) selecting intervals where the sign satisfies the inequality. Works for all polynomial and rational inequalities.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is interval notation?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a"><strong>Interval notation</strong> uses parentheses <em>( )</em> for excluded endpoints (strict inequalities) and brackets <em>[ ]</em> for included endpoints (non-strict). For example, <em>(&minus;2, 3]</em> means all numbers greater than &minus;2 and up to 3. Union symbol <em>&cup;</em> combines disjoint intervals: <em>(&minus;&infin;, &minus;2) &cup; (2, &infin;)</em>. The empty set is shown as <em>&empty;</em> and all real numbers as <em>(&minus;&infin;, &infin;)</em>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the difference between &lt; and &le;?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The less-than symbol (<em>&lt;</em>) is a <strong>strict inequality</strong> excluding the endpoint &mdash; shown with open circles on the number line and parentheses in interval notation. The less-than-or-equal symbol (<em>&le;</em>) is <strong>non-strict</strong> and includes the endpoint &mdash; shown with closed/filled circles and brackets. For example, <em>x &lt; 2</em> gives <em>(&minus;&infin;, 2)</em> while <em>x &le; 2</em> gives <em>(&minus;&infin;, 2]</em>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can I download or share my solution?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. After solving an inequality you can: (1) <strong>Download as PDF</strong> with the original inequality, solution, sign chart, and steps; (2) <strong>Copy as LaTeX</strong> for papers and documents; (3) <strong>Copy as plain text</strong>; or (4) <strong>Generate a shareable URL</strong>. The PDF includes a watermark and date.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Is this inequality solver free?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes &mdash; completely free with no signup, no account, and no limits. All computation runs client-side in your browser using the sign chart method. You get step-by-step solutions, interactive number line, function graph, PDF download, LaTeX export, and a Python SymPy compiler.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can I scan an inequality from a photo or textbook?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Click the <strong>&#128247; Scan</strong> button and upload (or drop in) a photo of a handwritten or printed inequality. The AI vision model extracts the inequality (preserving <em>&lt; &le; &gt; &ge;</em> symbols and absolute-value bars), fills the math field automatically, and detects the inequality type. Works on phone snapshots, textbook pages, whiteboard photos, and worksheet scans.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What grade levels and curricula does this cover?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Covers <strong>Algebra 1</strong> (linear inequalities, compound), <strong>Algebra 2</strong> (quadratic, polynomial, rational, absolute value), <strong>Precalculus</strong> (sign chart analysis), and college algebra. Aligned with Common Core HSA-REI.B.3 and HSA-CED.A.1, plus CBSE/ICSE class 9&ndash;11 inequalities chapters. SAT, ACT, and JEE Mains practice covered.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Where is the inequality practice worksheet?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Click the <strong>Practice Worksheet &mdash; 1,500+ inequalities with answer key</strong> button below the result. The worksheet engine generates printable problem sets across 4 difficulty tiers (basic, medium, hard, scholar) and <strong>35 problem types</strong> &mdash; linear (with parens, fractions, sign-flip), quadratic (factored and general), polynomial (cubic), rational, absolute-value (simple, complex, compound), log, exponential, system of linear inequalities, NCERT Class 11 word problems (IQ/mental-age, acid-mixing, rectangle perimeter, score threshold), and IIT-JEE Advanced / Putnam scholar problems (exp-quadratic substitution, log fractional base, nested logs, square-root inequalities, modulus-vs-modulus, AM-GM optimisation, Cauchy-Schwarz, Bernoulli's inequality). Every problem and answer is <em>CAS-verified</em>.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <%--
        Canonical 3-partial load order:
          1. math-libs                       — KaTeX, nerdamer (core+Algebra+Calculus),
                                               Plotly loader, tool-utils, dark-mode,
                                               search, image-to-math
          2. inequality-solver-scripts       — Solve.js, the giant IIFE, math-studio
                                               wiring, image-scan init
          3. math-input-setup                — MathLive ES module + Visual/Text mode
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />
    <jsp:include page="/math/partials/inequality-solver-scripts.jsp" />
    <jsp:include page="/math/partials/math-input-setup.jsp" />

    <!-- ─── Worksheet engine + button binding (uses the existing
            worksheet/math/algebra/inequalities.json — 1,500+ problems
            across 35 types).  Both the toolbar Worksheet button and
            the prominent CTA route here. ─── -->
    <script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>
    <script>
    (function () {
        function openInequalityWorksheet() {
            if (!window.WorksheetEngine || typeof window.WorksheetEngine.open !== 'function') {
                if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
                    ToolUtils.showToast('Worksheet engine not loaded', 2500, 'warning');
                }
                return;
            }
            window.WorksheetEngine.open({
                jsonUrl: '<%=request.getContextPath()%>/worksheet/math/algebra/inequalities.json',
                title: 'Inequalities',
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
            var primary = document.getElementById('iq-worksheet-btn');
            if (primary) primary.addEventListener('click', openInequalityWorksheet);
            var toolbar = document.getElementById('iq-worksheet-btn-toolbar');
            if (toolbar) toolbar.addEventListener('click', openInequalityWorksheet);
        });
    })();
    </script>

    <%@ include file="/modern/components/math-calculus-cores.inc.jsp" %>
    <%
        request.setAttribute("mathAiButtonId", "btnMathAI");
        request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
        request.setAttribute("mathAiProfileExport", "configureInequalityMathShell");
    %>
    <%@ include file="/modern/components/math-ai-boot.inc.jsp" %>

</body>
</html>
