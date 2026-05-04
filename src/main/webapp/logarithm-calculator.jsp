<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Logarithm Calculator — migrated to math-studio shell.

        Architecture:
          · MathLive is the primary input (#ic-mathfield + #ic-expr + Visual/Text
            toggle, all wired by /math/partials/math-input-setup.jsp).
          · A small bridge IIFE mirrors #ic-expr ↔ #lc-input so the legacy
            ~760-line inline IIFE keeps reading the same ID it always read.
            That IIFE — KaTeX preview, nerdamer formula solve, AI fallback,
            Plotly graph, Python compiler — is preserved verbatim.
          · #lc-keyboard kept in DOM (empty + display:none) so the legacy
            addEventListener does not throw.  The custom soft keyboard is
            replaced by MathLive's virtual keyboard.
          · AI image-scan via image-to-math.js with a log-specific extraction
            prompt — fills MathLive directly.
          · Worksheet CTA opens WorksheetEngine on
            worksheet/math/algebra/logarithms.json (594 KB, 2,000+ SymPy-
            verified problems across 31 types).

        SEO ported from the original (8 FAQ pairs, full keyword list,
        feature list).  Adds AI photo scan keywords + AI scan FAQ.
    --%>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Logarithm Calculator with Steps &mdash; AI Scan &amp; Worksheet" />
        <jsp:param name="toolDescription" value="Free logarithm calculator with AI photo scan + 2,000 practice problems. Solve, expand, condense, simplify, evaluate ln, log2, log10, and any base." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="logarithm-calculator.jsp" />
        <jsp:param name="toolKeywords" value="logarithm calculator, logarithm calculator with steps, log equation solver, solve logarithmic equations, simplify logarithms, expand logarithms, condense logarithms, log calculator, ln calculator, natural log calculator, log base 2 calculator, log base 10 calculator, logarithm rules, change of base formula, log solver step by step free, logarithm worksheet, log worksheet with answers, logarithm practice problems, log worksheet generator, logarithm worksheet pdf, logarithm practice worksheet, log equations worksheet, condense logarithms worksheet, expand logarithms worksheet, natural log worksheet, log equations with answers, logarithm quiz generator, ai logarithm solver, photo math solver, scan logarithm from photo, ai math homework helper, logarithm photo solver, math problem photo scanner" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Solve log equations step by step,Expand and condense using log rules,Simplify and evaluate expressions,2000+ practice worksheet problems,Printable worksheet with answer key,31 question types,4 difficulty levels,Interactive Plotly graph,Built-in Python SymPy compiler,AI-powered fallback for complex problems,AI photo scanner extracts logarithms from images,ln log log2 log10 any base,Copy LaTeX and share results,Live KaTeX preview,Photo math problem solver,Free with no signup" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="High School, AP Precalculus, College Algebra, University" />
        <jsp:param name="teaches" value="Logarithms, Log Equations, Natural Logarithm, Change of Base, Logarithm Rules, Expand Logarithms, Condense Logarithms, Log Derivatives, Log Integrals" />
        <jsp:param name="faq1q" value="What types of logarithm problems can this calculator solve?" />
        <jsp:param name="faq1a" value="This calculator solves logarithmic equations (log2(x) = 5), simplifies expressions (log(e^2) = 2), expands logarithms using product/quotient/power rules, condenses multiple logs into one, and evaluates to decimal values. It supports natural log (ln), common log (log10), binary log (log2), and any custom base." />
        <jsp:param name="faq2q" value="What is the difference between Solve, Expand, Condense, Simplify, and Evaluate?" />
        <jsp:param name="faq2a" value="Solve finds the variable value in a log equation. Expand breaks a single log into multiple logs using rules. Condense combines multiple logs into one. Simplify reduces to the simplest form. Evaluate computes a decimal result." />
        <jsp:param name="faq3q" value="How does the hybrid solver work?" />
        <jsp:param name="faq3a" value="The calculator first attempts to solve using nerdamer (client-side CAS). It normalizes log bases, eliminates common denominators, and uses algebraic solving. If nerdamer cannot solve, it falls back to AI-powered step-by-step solutions. This gives instant results for standard problems and detailed explanations for complex ones." />
        <jsp:param name="faq4q" value="What is the difference between ln and log?" />
        <jsp:param name="faq4a" value="ln (natural logarithm) is log base e (approximately 2.71828). log typically means log base 10 in everyday use. This calculator accepts both: type ln(x) or log(x) for natural log, and log10(x) for common log base 10. Use log2(x) for binary log or logb(x, base) for any custom base." />
        <jsp:param name="faq5q" value="Is this logarithm calculator free?" />
        <jsp:param name="faq5a" value="This logarithm calculator is completely free with no signup required. You get formula-based solving, AI step-by-step solutions, interactive graphs, a Python SymPy compiler, LaTeX export, and shareable URLs. Most computation runs in your browser for instant results." />
        <jsp:param name="faq6q" value="Does this logarithm calculator include practice worksheets?" />
        <jsp:param name="faq6a" value="Yes. This calculator includes a built-in worksheet generator with over 2,000 logarithm practice problems. You can filter by 31 question types (solve equations, expand, condense, change of base, log derivatives, log integrals, word problems, inequalities, and more) and 4 difficulty levels (basic, medium, hard, scholar). Each worksheet is randomly generated with a full answer key, perfect for exam prep, homework review, or classroom quizzes." />
        <jsp:param name="faq7q" value="What types of logarithm problems are in the worksheet?" />
        <jsp:param name="faq7a" value="The worksheet covers 31 problem types: evaluate basic logs, solve single and multi-log equations, expand and condense logs (simple and complex), rewrite between log and exponential form, change of base, log inequalities, logarithmic differentiation, log derivatives and integrals, inverse properties, system of log equations, log limits, graphing log functions, domain of logs, and word problems. Problems range from basic textbook to scholar-level exam difficulty." />
        <jsp:param name="faq8q" value="Can I scan a logarithm problem from a photo or textbook?" />
        <jsp:param name="faq8a" value="Yes. Click the Scan button and upload (or drop in) a photo of a handwritten or printed logarithm problem. The AI vision model extracts the expression (preserving log/ln subscripts and bases), fills the math field automatically, and detects whether to solve, expand, condense, or evaluate. Works on phone snapshots, textbook pages, whiteboard photos, and worksheet scans." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        /* ─── Mode pill bar (Solve / Simplify / Expand / Condense / Evaluate) ─── */
        .lc-mode-bar {
            display: flex; flex-wrap: wrap; gap: 0.35rem;
            padding: 0.4rem 0.5rem;
            background: var(--ms-panel-bg-soft, #faf8f4);
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius, 14px);
            align-items: center;
            margin-bottom: 0.85rem;
        }
        .lc-mode-bar .lc-mode-label {
            font-size: 0.7rem; font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase; letter-spacing: 0.05em;
            margin-right: 0.25rem;
        }
        .lc-mode-bar .lc-mode-btn {
            flex: 0 1 auto;
            padding: 0.4rem 0.7rem;
            font-size: 0.8rem; font-weight: 500;
            border: none;
            border-radius: var(--ms-radius-pill, 999px);
            background: transparent;
            color: var(--ms-ink-soft, #44403c);
            cursor: pointer;
            font-family: var(--ms-font-sans, Inter, sans-serif);
            transition: background 200ms, color 200ms;
        }
        .lc-mode-bar .lc-mode-btn:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
        }
        .lc-mode-bar .lc-mode-btn.active {
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-accent, #15803d);
            box-shadow: 0 1px 2px rgba(0,0,0,0.06);
            font-weight: 600;
        }
        .lc-mode-hint {
            font-size: 0.78rem;
            color: var(--ms-muted, #78716c);
            margin-bottom: 0.65rem;
        }

        /* ─── Hide legacy soft keyboard (kept in DOM for JS contract) ─── */
        #lc-keyboard { display: none !important; }

        /* ─── Live preview (KaTeX) ─── */
        #lc-preview {
            margin: 0.6rem 0 0.4rem;
            padding: 0.8rem 1rem;
            background: var(--ms-panel-bg-soft, #faf8f4);
            border-radius: var(--ms-radius, 14px);
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            font-size: 1.05rem;
            text-align: center;
            overflow-x: auto;
            min-height: 48px;
            display: flex; align-items: center; justify-content: center;
        }
        #lc-preview .katex-display { margin: 0; }

        /* ─── Variable selector ─── */
        .lc-var-row {
            display: flex; align-items: center; gap: 0.5rem;
            margin: 0.6rem 0;
        }
        .lc-var-row label {
            font-size: 0.75rem; font-weight: 600;
            color: var(--ms-ink-soft, #44403c);
        }
        #lc-var {
            padding: 0.4rem 0.7rem;
            font-size: 0.85rem;
            font-family: var(--ms-font-mono, 'JetBrains Mono', monospace);
            border: 1.5px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-pill, 999px);
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-ink, #1c1917);
            cursor: pointer;
        }

        /* ─── Examples chip row ─── */
        .lc-examples {
            display: flex; flex-wrap: wrap; gap: 0.4rem;
        }
        .lc-example-chip {
            padding: 0.35rem 0.7rem;
            font-size: 0.78rem; font-weight: 500;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-pill, 999px);
            background: transparent;
            color: var(--ms-ink-soft, #44403c);
            cursor: pointer;
            font-family: var(--ms-font-mono, 'JetBrains Mono', monospace);
            transition: background 200ms, color 200ms, border-color 200ms;
            white-space: nowrap;
        }
        .lc-example-chip:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            border-color: var(--ms-accent, #15803d);
        }

        /* ─── Result panel tunes (the inline JS emits these classes; here we
                map them to math-studio tokens so result text stays readable
                in both light and dark modes). ─── */
        #lc-result-content { padding: 1rem 1.25rem; min-height: 220px; }
        #lc-result-content .tool-empty-state,
        #lc-result-content .ic-empty-state {
            background: transparent !important;
            color: var(--ms-ink, #1c1917);
            padding: 2.25rem 1rem;
        }
        #lc-result-content .tool-empty-state h3,
        #lc-result-content .ic-empty-state h3 { color: var(--ms-ink, #1c1917); }
        #lc-result-content .tool-empty-state p,
        #lc-result-content .ic-empty-state p { color: var(--ms-muted, #78716c); }
        #lc-result-content .lc-error {
            background: rgba(245, 158, 11, 0.08);
            border: 1px solid rgba(245, 158, 11, 0.3);
            border-left: 3px solid #f59e0b;
            border-radius: var(--ms-radius, 14px);
            color: var(--ms-ink, #1c1917);
            padding: 0.85rem 1rem;
        }
        #lc-result-content .katex { color: var(--ms-ink, #1c1917); }
        .lc-badge {
            display: inline-block;
            padding: 0.2rem 0.55rem;
            background: var(--ms-accent-soft, rgba(21,128,61,0.10));
            color: var(--ms-accent, #15803d);
            border-radius: var(--ms-radius-pill, 999px);
            font-size: 0.7rem; font-weight: 600;
        }

        /* ─── Tabs / panels ─── */
        .lc-output-tabs { display: flex; }
        .lc-panel { display: none; }
        .lc-panel.active { display: block; }
        #lc-graph-container {
            width: 100%; min-height: 440px;
            border-radius: var(--ms-radius, 14px);
        }
        .js-plotly-plot .plotly .modebar { top: 4px !important; right: 4px !important; }
        #lc-compiler-template {
            margin-left: auto;
            padding: 0.3rem 0.55rem;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-sm, 8px);
            font-size: 0.78rem;
            font-family: var(--ms-font-sans, Inter, sans-serif);
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-ink, #1c1917);
            cursor: pointer;
        }

        /* ─── Worksheet CTA ─── */
        .lc-worksheet-cta {
            display: flex; align-items: center; justify-content: center;
            padding: 0.75rem 1rem;
            margin-top: 0.6rem;
        }
        .lc-worksheet-cta .tool-action-btn {
            background: var(--ms-accent, #15803d) !important;
            color: #fff !important;
            border: none;
            font-weight: 600;
        }

        /* ─── Mobile tweaks ─── */
        @media (max-width: 720px) {
            .lc-mode-bar .lc-mode-btn { padding: 0.35rem 0.55rem; font-size: 0.75rem; }
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

        <% request.setAttribute("activeService", "logarithm"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Logarithm</span>
                </nav>
                <h1>Logarithm Calculator &mdash; Solve, Expand, Condense &amp; Evaluate</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="ic-hero">

                    <!-- Top: input-mode toggle + Scan button -->
                    <div class="ic-hero-top">
                        <div id="ic-input-mode-toggle" class="ic-input-mode-toggle" role="tablist" aria-label="Input mode">
                            <button type="button" class="ic-input-mode-btn active" data-input-mode="visual" role="tab" aria-checked="true">Visual</button>
                            <button type="button" class="ic-input-mode-btn"        data-input-mode="text"   role="tab" aria-checked="false">Text</button>
                        </div>
                        <div class="ic-expr-label-actions" style="display:flex;gap:0.5rem;align-items:center;margin-left:auto;">
                            <button type="button" class="ic-image-btn" id="lc-image-btn" title="Scan a logarithm problem from an image">&#128247; Scan</button>
                        </div>
                    </div>

                    <!-- Mode pill bar -->
                    <div class="lc-mode-bar" role="radiogroup" aria-label="Operation">
                        <span class="lc-mode-label">Mode</span>
                        <button type="button" class="lc-mode-btn active" data-mode="solve"    role="radio" aria-checked="true">Solve</button>
                        <button type="button" class="lc-mode-btn"        data-mode="simplify" role="radio" aria-checked="false">Simplify</button>
                        <button type="button" class="lc-mode-btn"        data-mode="expand"   role="radio" aria-checked="false">Expand</button>
                        <button type="button" class="lc-mode-btn"        data-mode="condense" role="radio" aria-checked="false">Condense</button>
                        <button type="button" class="lc-mode-btn"        data-mode="evaluate" role="radio" aria-checked="false">Evaluate</button>
                        <button type="button" class="lc-mode-btn"        data-mode="rewrite"  role="radio" aria-checked="false">Rewrite</button>
                    </div>
                    <div class="lc-mode-hint" id="lc-mode-hint">Find the value of x in a log equation</div>

                    <!-- MathLive primary input + hidden #lc-input twin (legacy contract) -->
                    <div id="ic-expr-wrap" class="ic-expr-wrap" data-input-mode="visual">
                        <math-field id="ic-mathfield" class="ic-mathfield" placeholder="\log_2(x) = 5"></math-field>
                        <input type="text" id="ic-expr" class="ic-expr-input" autocomplete="off" spellcheck="false" placeholder="e.g. log2(x) = 5  or  ln(x) + ln(x-2) = 3">
                    </div>

                    <!-- Hidden legacy text input — kept in sync with #ic-expr by the bridge IIFE. -->
                    <input type="hidden" id="lc-input" value="" autocomplete="off">

                    <!-- Hidden legacy soft keyboard — empty container; the inline IIFE
                         attaches a delegated click listener to it.  MathLive's own
                         virtual keyboard replaces the function. -->
                    <div id="lc-keyboard" aria-hidden="true"></div>

                    <!-- Live KaTeX preview — driven by the legacy IIFE on lc-input.input -->
                    <div id="lc-preview">
                        <span style="color:var(--ms-muted, #78716c);font-size:0.85rem;">Type a problem above&hellip;</span>
                    </div>

                    <!-- Variable input — free-form so users can solve for k, n, a,
                         etc., not just x/y/t.  Comma-separated for systems
                         (e.g. `x,y` when entering two equations separated by
                         `;`).  The datalist gives autocomplete suggestions. -->
                    <div class="lc-var-row">
                        <label for="lc-var">Variable</label>
                        <input type="text" id="lc-var" value="x" list="lc-var-options"
                               maxlength="12" autocomplete="off" spellcheck="false"
                               style="width:8rem;text-align:center;"
                               title="One letter (e.g. x), or comma-separated for systems (e.g. x,y)">
                        <datalist id="lc-var-options">
                            <option value="x"></option>
                            <option value="y"></option>
                            <option value="t"></option>
                            <option value="k"></option>
                            <option value="n"></option>
                            <option value="a"></option>
                            <option value="b"></option>
                            <option value="m"></option>
                            <option value="p"></option>
                            <option value="x,y"></option>
                            <option value="x,y,z"></option>
                        </datalist>
                        <span style="font-size:0.7rem;color:var(--ms-muted, #78716c);margin-left:0.5rem;">
                            (use <code style="font-family:var(--ms-font-mono, monospace);">x,y</code> for systems)
                        </span>
                    </div>

                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta" id="lc-solve-btn">Solve Equation</button>
                    </div>

                    <!-- Examples chips (legacy IIFE listens on .lc-example-chip) -->
                    <div style="margin-top: 0.85rem;">
                        <div style="font-size: 0.7rem; font-weight: 600; color: var(--ms-muted, #78716c); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.4rem;">Examples</div>
                        <div class="lc-examples">
                            <button type="button" class="lc-example-chip" data-expr="ln(x)=2"                       data-mode="solve">ln(x)=2</button>
                            <button type="button" class="lc-example-chip" data-expr="log10(x)=3"                    data-mode="solve">log&#8321;&#8320;(x)=3</button>
                            <button type="button" class="lc-example-chip" data-expr="log2(8)"                       data-mode="evaluate">log&#8322;(8)</button>
                            <button type="button" class="lc-example-chip" data-expr="log(x)+log(y)"                 data-mode="condense">ln(x)+ln(y)</button>
                            <button type="button" class="lc-example-chip" data-expr="log(x^2*y)"                    data-mode="expand">ln(x&#178;y)</button>
                            <button type="button" class="lc-example-chip" data-expr="2*log(x)-log(y)"               data-mode="condense">2&middot;ln(x)&minus;ln(y)</button>
                            <button type="button" class="lc-example-chip" data-expr="log(e^2)"                      data-mode="simplify">ln(e&#178;)</button>
                            <button type="button" class="lc-example-chip" data-expr="log3(x+2)-log3(x)=2"           data-mode="solve">log&#8323;(x+2)&minus;log&#8323;(x)=2</button>
                            <button type="button" class="lc-example-chip" data-expr="log3(x)+log3(y)=4 ; log3(x/y)=2" data-vars="x,y" data-mode="solve" title="System of two equations — set Variable field to x,y">SYS: log&#8323;x+log&#8323;y=4 ; log&#8323;(x/y)=2</button>
                            <button type="button" class="lc-example-chip" data-expr="5^3 = 125"                     data-mode="rewrite">REWRITE: 5&#179; = 125</button>
                        </div>
                    </div>

                    <!-- Syntax help (collapsed style hint) -->
                    <p style="margin-top:0.85rem;font-size:0.75rem;color:var(--ms-muted, #78716c);line-height:1.5;">
                        <strong>Syntax:</strong>
                        <code style="font-family:var(--ms-font-mono, monospace);">ln(x)</code> &middot; <code style="font-family:var(--ms-font-mono, monospace);">log(x)</code> &middot;
                        <code style="font-family:var(--ms-font-mono, monospace);">log2(x)</code> &middot; <code style="font-family:var(--ms-font-mono, monospace);">log10(x)</code> &middot;
                        <code style="font-family:var(--ms-font-mono, monospace);">logb(x, base)</code>.
                    </p>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs lc-output-tabs" role="tablist">
                        <button type="button" class="ic-output-tab lc-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                        <button type="button" class="ic-output-tab lc-output-tab"        data-panel="graph"  role="tab" aria-selected="false">Graph</button>
                        <button type="button" class="ic-output-tab lc-output-tab"        data-panel="python" role="tab" aria-selected="false">Python</button>
                    </div>

                    <!-- Result panel -->
                    <div class="ic-panel lc-panel active" id="lc-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="lc-result-content">
                                <div class="tool-empty-state ic-empty-state" id="lc-empty-state">
                                    <div class="ic-empty-illustration">log</div>
                                    <h3>Enter a logarithm problem</h3>
                                    <p>Solve equations, simplify, expand, condense, or evaluate. Formula-based first, AI fallback when needed.</p>
                                </div>
                            </div>
                            <div class="tool-result-actions" id="lc-result-actions" style="display:none;">
                                <button type="button" class="tool-action-btn" id="lc-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="lc-copy-text-btn">Copy Text</button>
                                <button type="button" class="tool-action-btn" id="lc-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="lc-steps-btn">Show Steps</button>
                            </div>

                            <!-- Worksheet CTA -->
                            <div class="lc-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="log-worksheet-btn">
                                    Practice Worksheet &mdash; 2,000+ problems with answer key
                                </button>
                            </div>
                        </div>
                        <div id="lc-steps-area" style="margin-top:1rem"></div>
                    </div>

                    <!-- Graph panel -->
                    <div class="ic-panel lc-panel" id="lc-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:0;padding:0.75rem;">
                                <div id="lc-graph-container"></div>
                                <p id="lc-graph-hint" style="text-align:center;font-size:0.78rem;color:var(--ms-muted, #78716c);margin-top:0.5rem;">Solve a logarithm problem to see its graph.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Python panel -->
                    <div class="ic-panel lc-panel" id="lc-panel-python" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="display:flex;align-items:center;gap:0.6rem;padding:0.75rem 1rem;border-bottom:1px solid var(--ms-line, rgba(0,0,0,0.08));">
                                <strong style="font-size:0.85rem;color:var(--ms-ink-soft, #44403c);">SymPy template</strong>
                                <select id="lc-compiler-template">
                                    <option value="sympy-solve">SymPy Solve</option>
                                    <option value="sympy-simplify">SymPy Simplify</option>
                                    <option value="sympy-expand">SymPy Expand</option>
                                </select>
                            </div>
                            <div style="flex:1;min-height:0;">
                                <iframe id="lc-compiler-iframe" loading="lazy" title="Python compiler" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- Method-at-a-glance cards: log rules -->
            <section class="ic-learn" aria-label="Logarithm rules">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Product rule</span>
                    <code class="ic-learn-formula">log<sub>b</sub>(xy) = log<sub>b</sub>(x) + log<sub>b</sub>(y)</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Quotient rule</span>
                    <code class="ic-learn-formula">log<sub>b</sub>(x/y) = log<sub>b</sub>(x) &minus; log<sub>b</sub>(y)</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Power rule</span>
                    <code class="ic-learn-formula">log<sub>b</sub>(x<sup>n</sup>) = n &middot; log<sub>b</sub>(x)</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Change of base</span>
                    <code class="ic-learn-formula">log<sub>b</sub>(x) = ln(x) / ln(b)</code>
                </article>
            </section>

            <section class="ic-related-strip" style="margin-top:2rem;display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:0.75rem;">
                <a href="<%=request.getContextPath()%>/exponent-calculator.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Inverse</div>
                    <div style="font-weight:600;">Exponent Calculator &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">Logs and exponents are inverses &mdash; cover both sides of the rule.</div>
                </a>
                <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Algebra</div>
                    <div style="font-weight:600;">Quadratic Solver &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">Solve ax²+bx+c=0 with full steps and worksheet.</div>
                </a>
                <a href="<%=request.getContextPath()%>/derivative-calculator.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Calculus</div>
                    <div style="font-weight:600;">Derivative Calculator &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">d/dx[ln(x)] = 1/x &mdash; logarithmic differentiation, chain rule.</div>
                </a>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- Visible FAQ — keep in sync with faqNq/faqNa jsp:params. -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Logarithm calculator FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What types of logarithm problems can this calculator solve?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">This calculator solves <strong>logarithmic equations</strong> (<em>log&#8322;(x) = 5</em>), simplifies expressions (<em>log(e&#178;) = 2</em>), expands logarithms using product/quotient/power rules, condenses multiple logs into one, and evaluates to decimal values. It supports natural log (<em>ln</em>), common log (<em>log&#8321;&#8320;</em>), binary log (<em>log&#8322;</em>), and any custom base.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the difference between Solve, Expand, Condense, Simplify, and Evaluate?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a"><strong>Solve</strong> finds the variable in a log equation. <strong>Expand</strong> breaks a single log into multiple logs using rules. <strong>Condense</strong> combines multiple logs into one. <strong>Simplify</strong> reduces to the simplest form. <strong>Evaluate</strong> computes a decimal result.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How does the hybrid solver work?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The calculator first attempts to solve using <strong>nerdamer</strong> (client-side CAS). It normalizes log bases, eliminates common denominators, and uses algebraic solving. If nerdamer cannot solve, it falls back to <strong>AI-powered</strong> step-by-step solutions. This gives instant results for standard problems and detailed explanations for complex ones.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the difference between ln and log?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a"><em>ln</em> (natural logarithm) is log base <em>e</em> (&asymp; 2.71828). <em>log</em> typically means log base 10 in everyday use. This calculator accepts both: type <code>ln(x)</code> or <code>log(x)</code> for natural log, and <code>log10(x)</code> for common log. Use <code>log2(x)</code> for binary log or <code>logb(x, base)</code> for any custom base.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Is this logarithm calculator free?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Completely free with no signup. You get formula-based solving, AI step-by-step solutions, interactive Plotly graphs, a Python SymPy compiler, LaTeX export, shareable URLs, and a 2,000-problem practice worksheet. Most computation runs in your browser for instant results.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Does this logarithm calculator include practice worksheets?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Click the <strong>Practice Worksheet</strong> button to open the worksheet engine with over <strong>2,000 SymPy-verified problems</strong> across <strong>31 question types</strong> (solve equations, expand, condense, change of base, log derivatives/integrals, word problems, inequalities, and more) and <strong>4 difficulty levels</strong> (basic, medium, hard, scholar). Each worksheet is randomly generated with a full answer key &mdash; perfect for exam prep, homework review, or classroom quizzes.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What types of logarithm problems are in the worksheet?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The worksheet covers <strong>31 problem types</strong>: evaluate basic logs, solve single and multi-log equations, expand and condense (simple and complex), rewrite between log and exponential form, change of base, log inequalities, logarithmic differentiation, log derivatives and integrals, inverse properties, system of log equations, log limits, graphing log functions, domain of logs, and word problems. Problems range from basic textbook to scholar-level exam difficulty.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can I scan a logarithm problem from a photo or textbook?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Click the <strong>&#128247; Scan</strong> button and upload (or drop in) a photo of a handwritten or printed logarithm problem. The AI vision model extracts the expression (preserving log/ln subscripts and bases), fills the math field automatically, and detects whether to solve, expand, condense, or evaluate. Works on phone snapshots, textbook pages, whiteboard photos, and worksheet scans.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- ═══════════════════════════════════════════════════════════════════
         Scripts — load order matters:
           1. math-libs.jsp          — KaTeX, nerdamer (core+Algebra+Calculus),
                                       Plotly loader, tool-utils, dark-mode,
                                       search, image-to-math
           2. nerdamer Solve         — Solve.js (logarithm-specific extra)
           3. legacy inline IIFE     — VERBATIM from the previous JSP
           4. worksheet-engine + binding
           5. math-input-setup.jsp   — MathLive ESM + visual/text mode toggle
                                       (must run AFTER #ic-mathfield exists)
           6. lc-input ↔ ic-expr     — bridge IIFE (mirrors MathLive into the
                                       legacy ID the inline IIFE reads)
           7. AI scan init           — image-to-math.js with logarithm prompt
           8. FAQ accordion          — math-studio standard
       ═══════════════════════════════════════════════════════════════════ -->
    <jsp:include page="/math/partials/math-libs.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Solve.js"></script>

    <!-- ═══ SymPy power-engine ═══
         Python template read by the inline IIFE to compute expand_log,
         logcombine, simplify, evaluate, and solve with domain filtering
         for extraneous solutions.  Posted to /OneCompilerFunctionality
         (same endpoint systems-solver uses).  Uses %MODE% / %VAR% /
         %RAW_B64% placeholders so the JS side does not have to escape
         backslashes / quotes inside the Python source. -->
    <script type="text/x-python" id="lc-sympy-template">
import sys, json, re, base64
sys.setrecursionlimit(5000)  # JEE-style nested-log problems blow the default 1000

import sympy as sp  # the LR_* rule helpers + step-emitters use sp.log, sp.Wild, etc.
from sympy import (symbols, log, expand_log, logcombine, simplify, solve, Eq,
                   latex, S, N, I, sympify, Symbol, nsimplify, Integer,
                   Float, sqrt, exp, E, pi, LambertW, Pow, Wild, Mul, Add)
from sympy.parsing.sympy_parser import (parse_expr, standard_transformations,
                                         implicit_multiplication_application,
                                         convert_xor)

MODE = "%MODE%"
VAR = "%VAR%"
RAW = base64.b64decode("%RAW_B64%").decode("utf-8")

# ---- Pre-parser: convert calculator notation to SymPy syntax ----
def find_matching(s, start):
    depth = 1
    i = start
    while i < len(s) and depth > 0:
        c = s[i]
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
        i += 1
    return i - 1

def convert_log_bases(s):
    out = []
    i = 0
    while i < len(s):
        m = re.match(r"\blog(\d+)\s*\(", s[i:])
        if m:
            base = m.group(1)
            start = i + m.end()
            end = find_matching(s, start)
            inner = convert_log_bases(s[start:end])
            out.append("log(" + inner + ", " + base + ")")
            i = end + 1
            continue
        m2 = re.match(r"\blog_(\d+)\s*\(", s[i:])
        if m2:
            base = m2.group(1)
            start = i + m2.end()
            end = find_matching(s, start)
            inner = convert_log_bases(s[start:end])
            out.append("log(" + inner + ", " + base + ")")
            i = end + 1
            continue
        out.append(s[i])
        i += 1
    return "".join(out)

def convert_logb(s):
    out = []
    i = 0
    while i < len(s):
        m = re.match(r"\blogb\s*\(", s[i:])
        if m:
            start = i + m.end()
            end = find_matching(s, start)
            args = s[start:end]
            depth = 0
            split = -1
            for j, c in enumerate(args):
                if c == "(":
                    depth += 1
                elif c == ")":
                    depth -= 1
                elif c == "," and depth == 0:
                    split = j
                    break
            if split >= 0:
                expr_part = args[:split].strip()
                base_part = args[split+1:].strip()
                out.append("log(" + expr_part + ", " + base_part + ")")
            else:
                out.append(s[i:end+1])
            i = end + 1
            continue
        out.append(s[i])
        i += 1
    return "".join(out)

def normalize(s):
    s = s.strip()
    s = re.sub(r"\bln\s*\(", "log(", s)
    s = convert_logb(s)
    s = convert_log_bases(s)
    s = s.replace("^", "**")
    # Treat bare `e` (not part of another identifier) as Euler's number.
    # Without this, SymPy parses `log(e^2)` as `log(Symbol('e')**2)` and
    # cannot simplify to 2.  With `E`, `simplify(log(E**2)) = 2`.
    s = re.sub(r"(?<![A-Za-z0-9_])e(?![A-Za-z0-9_])", "E", s)
    return s

TRANS = standard_transformations + (implicit_multiplication_application, convert_xor)

def safe_parse(s):
    return parse_expr(normalize(s), transformations=TRANS)

def emit(latex_form, plain_form, method, numeric=None):
    payload = {
        "latex": latex_form,
        "plain": plain_form,
        "method": method
    }
    if numeric is not None:
        payload["numeric"] = numeric
    print("RESULT:" + json.dumps(payload))

def emit_extraneous(items):
    print("EXTRANEOUS:" + json.dumps(items))

# ── Step-emitter: STEPS:json line carries rule-annotated derivation
#    steps so the JS Show-Steps button can render real pedagogy instead
#    of a generic placeholder.  Mirrors the pattern in
#    trig-calculator-scripts.jsp (TR1, TR2, … rule list with before/after).
# ──────────────────────────────────────────────────────────────────────
def emit_steps(steps):
    if not steps:
        return
    payload = []
    for s in steps:
        try:
            before_latex = sp.latex(s["before"]) if s.get("before") is not None else ""
        except Exception:
            before_latex = str(s.get("before", ""))
        try:
            after_latex = sp.latex(s["after"]) if s.get("after") is not None else ""
        except Exception:
            after_latex = str(s.get("after", ""))
        payload.append({
            "rule": s.get("rule", "step"),
            "label": s.get("label", ""),
            "before_latex": before_latex,
            "after_latex": after_latex,
        })
    print("STEPS:" + json.dumps(payload))


# ── Logarithm rule library — Wild-pattern transformations.  Each LR_*
#    function returns a NEW expression with the rule applied once
#    (or unchanged if the pattern doesn't match).  Used by the greedy
#    step-emitter for Expand/Condense/Simplify modes.
# ──────────────────────────────────────────────────────────────────────
_W_A = sp.Wild("A", exclude=[0])
_W_B = sp.Wild("B", exclude=[0])
_W_N = sp.Wild("n")

def LR_product(e):
    """log(A*B) → log(A) + log(B)  (forward — Expand)"""
    return e.replace(sp.log(_W_A * _W_B),
                     lambda A, B: sp.log(A) + sp.log(B))

def LR_quotient(e):
    """log(A/B) → log(A) − log(B)  (forward — Expand)"""
    return e.replace(sp.log(_W_A / _W_B),
                     lambda A, B: sp.log(A) - sp.log(B))

def LR_power(e):
    """log(A^n) → n*log(A)  (forward — Expand / Power rule)"""
    return e.replace(sp.log(_W_A ** _W_N),
                     lambda A, n: n * sp.log(A))

def LR_ln_e(e):
    """log(e^n) → n  (special case once power rule has reduced)"""
    return e.replace(sp.log(sp.E), 1)

def LR_log_one(e):
    """log(1) → 0"""
    return e.replace(sp.log(sp.Integer(1)), 0)

def LR_log_b_b(e):
    """log_b(b) = 1 — handled implicitly by SymPy log(b, b) = 1"""
    return e

def LR_inverse_power(e):
    """n*log(A) → log(A^n)  (reverse — Condense)"""
    return e.replace(_W_N * sp.log(_W_A),
                     lambda n, A: sp.log(A ** n))

def LR_inverse_combine(e):
    """log(A) + log(B) → log(A*B)  AND  log(A) - log(B) → log(A/B)
       Done via SymPy's logcombine which handles both with force=True."""
    return sp.logcombine(e, force=True)

def LR_full_expand(e):
    """One-shot expand_log fallback if the per-rule loop stalls."""
    return sp.expand_log(e, force=True)

# Forward (Expand) rule set — applied greedily until no rule reduces
# the expression's log-related complexity score.
EXPAND_RULES = [
    ("LR_quotient",  "Apply quotient rule:  log(A/B) = log(A) − log(B)",   LR_quotient),
    ("LR_product",   "Apply product rule:   log(A·B) = log(A) + log(B)",  LR_product),
    ("LR_power",     "Apply power rule:     log(Aⁿ) = n·log(A)",          LR_power),
    ("LR_ln_e",      "Simplify log(e) = 1",                                LR_ln_e),
    ("LR_log_one",   "Simplify log(1) = 0",                                LR_log_one),
]

# Reverse (Condense) rule set — applied in opposite order.
CONDENSE_RULES = [
    ("LR_inverse_power",   "Power rule (reverse): n·log(A) = log(Aⁿ)",   LR_inverse_power),
    ("LR_inverse_combine", "Combine logs: log(A) ± log(B) = log(A·B) or log(A/B)",
                                                                          LR_inverse_combine),
]

def _log_complexity(e):
    """Cost metric: count of log() calls + symbolic operations.
    Lower = closer to fully-expanded form."""
    try:
        return (
            sum(1 for _ in e.atoms(sp.log)),
            sp.count_ops(e),
            len(str(e)),
        )
    except Exception:
        return (10**6, 10**6, 10**6)

def _detect_expand_rules(expr):
    """Inspect each log() in `expr` and report which expansion rules
    would fire.  Returns a list of rule names in textbook order
    (quotient, product, power) for the rules that apply."""
    fired = set()
    for a in expr.atoms(sp.log):
        if not a.args:
            continue
        arg = a.args[0]
        if isinstance(arg, sp.Pow):
            # log(A^n)  with n ≠ 1   → power rule
            if arg.exp != 1:
                fired.add("power")
        if isinstance(arg, sp.Mul):
            has_neg_pow = any(isinstance(f, sp.Pow) and f.exp.is_negative
                              for f in arg.args)
            if has_neg_pow:
                fired.add("quotient")
            # Strip any Pow(_, -k) factors and check if a real product remains
            positive_factors = [f for f in arg.args
                                if not (isinstance(f, sp.Pow) and f.exp.is_negative)]
            if len(positive_factors) > 1:
                fired.add("product")
        if isinstance(arg, sp.Rational) and arg != 0:
            n, d = arg.as_numer_denom()
            if d != 1:
                fired.add("quotient")
    order = ["quotient", "product", "power"]
    return [r for r in order if r in fired]

_RULE_LABEL = {
    "product":  "Apply product rule:  log(A·B) = log(A) + log(B)",
    "quotient": "Apply quotient rule: log(A/B) = log(A) − log(B)",
    "power":    "Apply power rule:    log(Aⁿ) = n·log(A)",
}

def expand_with_steps(expr):
    """Single-step (or rule-list) expansion: detect which rules fire,
    label the transformation, emit ONE before/after pair.  Avoids the
    circular-rewrite traps of pure greedy stepping with Wild patterns."""
    final = sp.expand_log(expr, force=True)
    if final == expr:
        return expr, []
    rules = _detect_expand_rules(expr)
    if not rules:
        return final, [{
            "rule":  "LR_simplify",
            "label": "Apply log identities",
            "before": expr,
            "after":  final,
        }]
    if len(rules) == 1:
        return final, [{
            "rule":  "LR_" + rules[0],
            "label": _RULE_LABEL[rules[0]],
            "before": expr,
            "after":  final,
        }]
    # Multiple rules apply — emit a combined-rule step listing them
    label = "Apply log expansion rules: " + ", ".join(rules)
    return final, [{
        "rule":  "LR_full_expand",
        "label": label,
        "before": expr,
        "after":  final,
    }]

def condense_with_steps(expr):
    """Single-step condensation.  Detect which inverse rules fire by
    comparing the number of log() calls before and after logcombine."""
    final = sp.logcombine(expr, force=True)
    if final == expr:
        return expr, []
    before_logs = sum(1 for _ in expr.atoms(sp.log))
    after_logs  = sum(1 for _ in final.atoms(sp.log))
    if after_logs < before_logs:
        # logs got combined — the textbook rule is product/quotient
        # (reverse) plus possibly power-rule reverse if coefficients
        # were absorbed.
        has_power_coef = any(
            isinstance(t, sp.Mul) and any(isinstance(f, sp.log) for f in t.args)
            for t in (expr.args if isinstance(expr, sp.Add) else [expr])
        )
        if has_power_coef:
            label = "Apply power rule (reverse) and combine logs"
            rule_name = "LR_inverse_power_combine"
        else:
            label = "Combine logs:  log(A) ± log(B) = log(A·B)  or  log(A/B)"
            rule_name = "LR_inverse_combine"
        return final, [{
            "rule":  rule_name,
            "label": label,
            "before": expr,
            "after":  final,
        }]
    # Same log count but expression changed — just label as simplify
    return final, [{
        "rule":  "LR_simplify",
        "label": "Apply log identities",
        "before": expr,
        "after":  final,
    }]

def solve_with_steps(eq_expr, var_sym):
    """Structured step-emitter for Solve mode.  Walks: combine logs →
    convert to exponential form (if applicable) → solve algebraically →
    domain check.  Returns (solutions_list, extraneous_list, steps_list).
    """
    steps = []
    current = eq_expr  # form: lhs - rhs (set to 0)

    # Step 1: condense any sums of logs on the equation
    condensed = sp.logcombine(current, force=True)
    if condensed != current:
        steps.append({
            "rule": "LR_inverse_combine",
            "label": "Combine logs on each side using product / quotient rules",
            "before": current,
            "after": condensed,
        })
        current = condensed

    # Step 2: if `current` has the shape  log_b(arg) - c  =  0,  rewrite
    #         as `arg = b^c`.  Detect by structure: a single log() and a
    #         non-log remainder.
    log_atoms = list(current.atoms(sp.log))
    if len(log_atoms) == 1:
        L = log_atoms[0]
        # current = c1 * L + c2   →  L = -c2/c1, then arg = b^(L)
        try:
            poly = sp.Poly(current, L)
            if poly.degree() == 1:
                a1, a0 = poly.all_coeffs()  # a1 * L + a0
                rhs_log = -a0 / a1
                base = L.args[1] if len(L.args) == 2 else sp.E
                arg = L.args[0]
                exp_form = sp.Eq(arg, base ** rhs_log, evaluate=False)
                steps.append({
                    "rule": "LR_exponential_form",
                    "label": "Convert log_b(arg) = c  →  arg = b^c",
                    "before": current,
                    "after": exp_form.lhs - exp_form.rhs,
                })
                current = exp_form.lhs - exp_form.rhs
        except Exception:
            pass

    # Step 3: algebraic solve.  If the post-combine form trips SymPy
    # (e.g. NotImplementedError on certain symbolic-parameter cubics),
    # fall back to solving the ORIGINAL equation — the parameter-aware
    # solver in pre-refactor handled that fine.
    try:
        candidates = sp.solve(current, var_sym)
    except NotImplementedError:
        try:
            candidates = sp.solve(eq_expr, var_sym)
            # If we fell back, the combine/exponentiate steps may not
            # describe what actually solved the equation — strip them so
            # the user doesn't see a misleading trace.
            steps = [{
                "rule":  "LR_solve",
                "label": "Solve the original equation symbolically",
                "before": eq_expr,
                "after":  None,
            }]
        except Exception:
            candidates = []
    if not candidates:
        steps.append({
            "rule": "LR_solve",
            "label": "Solve the resulting algebraic equation",
            "before": current,
            "after": sp.Symbol("\\text{no solution}"),
        })
        return [], [], steps

    sol_summary = sp.Symbol(", ".join([f"{var_sym} = {s}" for s in candidates]))
    steps.append({
        "rule": "LR_solve",
        "label": "Solve the resulting algebraic equation",
        "before": current,
        "after": sol_summary,
    })

    # Step 4: domain check on the ORIGINAL log arguments
    log_args_orig = list({a.args[0] for a in eq_expr.atoms(sp.log)})
    valid, extraneous = [], []
    for c in candidates:
        if c.has(sp.I):
            extraneous.append(c)
            continue
        ok = True
        for arg in log_args_orig:
            try:
                sub_val = arg.subs(var_sym, c)
                if sub_val.has(sp.I):
                    ok = False; break
                if sub_val.free_symbols - {var_sym}:
                    continue  # parameter-dependent
                ev = sub_val.evalf()
                if ev.is_real == False:
                    ok = False; break
                if ev.is_real and float(ev) <= 1e-12:
                    ok = False; break
            except Exception:
                pass
        (valid if ok else extraneous).append(c)

    if extraneous and valid:
        steps.append({
            "rule": "LR_domain_check",
            "label": "Reject extraneous roots — log(arg) requires arg > 0",
            "before": sp.Symbol("candidates: " + ", ".join(str(c) for c in candidates)),
            "after":  sp.Symbol("valid: "      + ", ".join(str(c) for c in valid)),
        })
    elif extraneous and not valid:
        steps.append({
            "rule": "LR_domain_check",
            "label": "Every candidate root makes a log() argument ≤ 0 — no real solution",
            "before": sp.Symbol("candidates: " + ", ".join(str(c) for c in candidates)),
            "after":  sp.Symbol("\\emptyset"),
        })

    return valid, extraneous, steps

def rewrite_steps(form, b, exp_arg, log_arg):
    """2-step trace for Rewrite mode."""
    if form == "exp_to_log":
        # b^x = y  →  log_b(y) = x
        return [
            {"rule": "LR_identify",  "label": "Identify exponential form b^x = y",
             "before": sp.Symbol(f"{sp.latex(b)}^{{{sp.latex(exp_arg)}}} = {sp.latex(log_arg)}"),
             "after":  sp.Symbol(f"\\text{{base }} b={sp.latex(b)},\\; \\text{{exponent }}={sp.latex(exp_arg)},\\; \\text{{value }}={sp.latex(log_arg)}")},
            {"rule": "LR_log_form",   "label": "Apply definition: b^x = y  ⇔  log_b(y) = x",
             "before": sp.Symbol(f"{sp.latex(b)}^{{{sp.latex(exp_arg)}}} = {sp.latex(log_arg)}"),
             "after":  sp.Symbol(f"\\log_{{{sp.latex(b)}}}\\left({sp.latex(log_arg)}\\right) = {sp.latex(exp_arg)}")},
        ]
    else:  # log_to_exp
        return [
            {"rule": "LR_identify",  "label": "Identify logarithmic form log_b(y) = x",
             "before": sp.Symbol(f"\\log_{{{sp.latex(b)}}}\\left({sp.latex(log_arg)}\\right) = {sp.latex(exp_arg)}"),
             "after":  sp.Symbol(f"\\text{{base }} b={sp.latex(b)},\\; \\text{{value }}={sp.latex(log_arg)},\\; \\text{{result }}={sp.latex(exp_arg)}")},
            {"rule": "LR_exp_form",   "label": "Apply definition: log_b(y) = x  ⇔  b^x = y",
             "before": sp.Symbol(f"\\log_{{{sp.latex(b)}}}\\left({sp.latex(log_arg)}\\right) = {sp.latex(exp_arg)}"),
             "after":  sp.Symbol(f"{sp.latex(b)}^{{{sp.latex(exp_arg)}}} = {sp.latex(log_arg)}")},
        ]

# Fix #5: symbolic-base post-processor.  logcombine(force=True) on a
# change-of-base expression often returns the ugly form
#   log(X**(1/log(B)))           which is log_B(X) but unreadable.
# We unwind it back to log(X)/log(B) so the LaTeX renders as a clean
# fraction (matching the form most textbooks use for change-of-base).
def _cleanup_symbolic_base(expr):
    if not hasattr(expr, "replace"):
        return expr
    X = Wild("X", exclude=[0])
    B = Wild("B", exclude=[0])
    pat = log(X ** (1 / log(B)))
    try:
        out = expr.replace(pat, lambda X, B: log(X) / log(B))
        # Also unwind log(X**something*log(...))/log(B) shapes that simplify left
        return out
    except Exception:
        return expr

# Fix #4: numeric companion.  When a closed-form solution contains
# LambertW or other intractable special functions, render a numeric
# decimal alongside so users can actually use the answer.
def _numeric_companion(expr):
    try:
        n = complex(N(expr, 8))
        if abs(n.imag) < 1e-10:
            v = float(n.real)
            if abs(v - round(v)) < 1e-10:
                return str(int(round(v)))
            return f"{v:.6g}"
    except Exception:
        pass
    return None

# Fix #5/#7: ugliness scorer.  Multiple `simplify` candidates compete to
# be displayed; pick the one with the cleanest form.  Penalises:
#   · nested pow-with-log exponents (the logcombine-with-symbolic-base form)
#   · LambertW (intractable; we still show it but prefer alternatives)
#   · sheer string length as a tiebreaker
def _ugliness(c):
    s = str(c)
    score = len(s)
    if "**(1/log" in s or ")**log(" in s or "**(log(" in s:
        score += 200  # the truly ugly logcombine form
    if "LambertW" in s:
        score += 80
    if s.count("log(") > 6:
        score += 30
    return score

# Fix #7 (partial): parameter-aware domain check.  When a candidate
# carries free symbols that aren't the chosen unknown, we can't decide
# if log args are positive — accept the candidate (mark as
# parameter-dependent).  Without this guard, the filter rejects all of
# them as "extraneous" because evalf() on a symbolic expression has
# is_real == None.
def _domain_ok(arg, var_sym, candidate):
    try:
        sub_val = arg.subs(var_sym, candidate)
        if sub_val.has(I):
            return False
        # Parameter-dependent — can't decide, give benefit of the doubt
        if sub_val.free_symbols:
            return True
        ev = sub_val.evalf()
        if ev.is_real == False:
            return False
        if ev.is_real and float(ev) <= 1e-12:
            return False
        return True
    except Exception:
        return True  # be permissive — let the user see the answer

try:
    if MODE == "expand":
        if "=" in RAW:
            print("ERROR:Expand mode does not accept equations. Switch to Solve mode.")
        else:
            e = safe_parse(RAW)
            out, steps = expand_with_steps(e)
            out = _cleanup_symbolic_base(out)
            emit(latex(out), str(out), "Expand (CAS)")
            emit_steps(steps)

    elif MODE == "condense":
        if "=" in RAW:
            print("ERROR:Condense mode does not accept equations. Switch to Solve mode.")
        else:
            e = safe_parse(RAW)
            out, steps = condense_with_steps(e)
            out = _cleanup_symbolic_base(out)
            emit(latex(out), str(out), "Condense (CAS)")
            emit_steps(steps)

    elif MODE == "simplify":
        if "=" in RAW:
            print("ERROR:Simplify mode does not accept equations. Switch to Solve mode.")
        else:
            e = safe_parse(RAW)
            steps = []  # populated below for the dominant transformation

            candidates = []
            try: candidates.append(simplify(logcombine(e, force=True)))
            except Exception: pass
            try: candidates.append(logcombine(simplify(e), force=True))
            except Exception: pass
            try: candidates.append(expand_log(e, force=True))
            except Exception: pass
            try: candidates.append(simplify(expand_log(e, force=True)))
            except Exception: pass
            try: candidates.append(simplify(e))
            except Exception: pass
            candidates = [_cleanup_symbolic_base(c) for c in candidates if c is not None]
            best = e if not candidates else min(candidates, key=_ugliness)

            # Try numeric reduction
            numeric_collapse = False
            try:
                num = float(e.evalf())
                if abs(num - round(num)) < 1e-12:
                    cand_num = Integer(int(round(num)))
                    if _ugliness(cand_num) < _ugliness(best):
                        best = cand_num
                        numeric_collapse = True
                elif abs(num) < 1e10:
                    nv = nsimplify(num, rational=False, tolerance=1e-10)
                    if _ugliness(nv) < _ugliness(best):
                        best = nv
            except Exception:
                pass

            # Construct steps from the chosen transformation:
            #   · numeric collapse → "evaluate to constant"
            #   · best comes from expand → use expand_with_steps
            #   · best comes from logcombine → use condense_with_steps
            if numeric_collapse:
                steps = [{
                    "rule": "LR_evaluate",
                    "label": "Reduce to a constant by applying log identities and evaluating",
                    "before": e,
                    "after": best,
                }]
            else:
                # Try expansion path; if it produces best, use those steps.
                try:
                    out_exp, steps_exp = expand_with_steps(e)
                    if _cleanup_symbolic_base(out_exp) == best:
                        steps = steps_exp
                except Exception:
                    pass
                if not steps:
                    try:
                        out_con, steps_con = condense_with_steps(e)
                        if _cleanup_symbolic_base(out_con) == best:
                            steps = steps_con
                    except Exception:
                        pass
                if not steps and best != e:
                    steps = [{
                        "rule": "LR_simplify",
                        "label": "Apply combined log rules and simplify",
                        "before": e,
                        "after": best,
                    }]

            emit(latex(best), str(best), "Simplify (CAS)")
            emit_steps(steps)

    elif MODE == "evaluate":
        if "=" in RAW:
            print("ERROR:Evaluate mode does not accept equations.")
        else:
            e = safe_parse(RAW)
            num = float(e.evalf())
            if abs(num - round(num)) < 1e-12:
                emit(str(int(round(num))), str(int(round(num))), "Evaluate (CAS)")
            else:
                v = N(num, 12)
                emit(latex(v), str(v), "Evaluate (CAS)")

    elif MODE == "rewrite":
        # Fix #1: notation conversion.  Detect which form the user typed
        # and emit the other.  Two shapes:
        #   exponential:  b^x = y    →    log_b(y) = x
        #   logarithmic:  log_b(y) = x  →  b^x = y
        #
        # We construct the output LaTeX/plain manually rather than using
        # SymPy's Eq() — Eq auto-evaluates when both sides are concrete
        # numbers (5**3 == 125 → Eq(125, 125) → True).  Manual construction
        # preserves the educational form even when both sides numerically
        # equal.
        if "=" not in RAW:
            print("ERROR:Rewrite mode needs an equation. Try `5^3 = 125` or `log_5(125) = 3`.")
        else:
            lhs_raw, rhs_raw = RAW.split("=", 1)
            lhs = parse_expr(normalize(lhs_raw.strip()), transformations=TRANS, evaluate=False)
            rhs = parse_expr(normalize(rhs_raw.strip()), transformations=TRANS, evaluate=False)

            has_log = lhs.has(log) or rhs.has(log)
            done = False

            if has_log:
                # Logarithmic form — find the side that IS a single log() call
                for side, other in [(lhs, rhs), (rhs, lhs)]:
                    if hasattr(side, "func") and side.func == log:
                        # Plain log(y) → base e; log(y, b) → base b
                        if len(side.args) == 2:
                            y, b = side.args
                        else:
                            y, b = side.args[0], E
                        # Manual emission — bypass Eq() auto-eval.
                        out_latex = "%s^{%s} = %s" % (latex(b), latex(other), latex(y))
                        out_plain = "%s**(%s) = %s" % (str(b), str(other), str(y))
                        emit(out_latex, out_plain, "Rewrite (log → exponential)")
                        emit_steps(rewrite_steps("log_to_exp", b=b, exp_arg=other, log_arg=y))
                        done = True
                        break
                if not done:
                    print("ERROR:Could not isolate a single log() term to rewrite. Try simplifying first.")
            else:
                # Exponential form — look for Pow(base, exp) on either side.
                # When parse_expr keeps evaluate=False, 5**3 remains a Pow.
                for side, other in [(lhs, rhs), (rhs, lhs)]:
                    if isinstance(side, Pow):
                        b, x = side.base, side.exp
                        out_latex = "\\log_{%s}\\left(%s\\right) = %s" % (latex(b), latex(other), latex(x))
                        out_plain = "log_%s(%s) = %s" % (str(b), str(other), str(x))
                        emit(out_latex, out_plain, "Rewrite (exponential → log)")
                        emit_steps(rewrite_steps("exp_to_log", b=b, exp_arg=x, log_arg=other))
                        done = True
                        break
                if not done:
                    print("ERROR:Could not detect exponential form (b^x = y) to rewrite.")

    elif MODE == "solve":
        # Fix #12: system detection.  When RAW contains `;` or newline
        # separators, treat as multi-equation system and route to
        # solve(eqs, vars, dict=True).  Variables are comma-separated in
        # VAR (e.g. "x,y").
        eqs_raw = [e.strip() for e in re.split(r"[;\n]", RAW) if e.strip()]

        if len(eqs_raw) > 1:
            var_names = [v.strip() for v in VAR.split(",") if v.strip()]
            if not var_names:
                print("ERROR:System mode requires variables. Type e.g. `x,y` in the variable field.")
                sys.exit()
            var_syms = [symbols(v) for v in var_names]

            eqs_parsed = []
            for eq_str in eqs_raw:
                if "=" not in eq_str:
                    print("ERROR:System equation missing `=`: " + eq_str)
                    sys.exit()
                lhs, rhs = eq_str.split("=", 1)
                try:
                    lhs_e = safe_parse(lhs.strip())
                    rhs_e = safe_parse(rhs.strip())
                except Exception as ex:
                    print("ERROR:Could not parse `%s`: %s" % (eq_str, ex))
                    sys.exit()
                eqs_parsed.append(lhs_e - rhs_e)

            try:
                sols = solve(eqs_parsed, var_syms, dict=True)
            except RecursionError:
                print("ERROR:System too deeply nested for the symbolic solver.")
                sys.exit()

            if not sols:
                print("NOSOL")
                sys.exit()

            # Collect every log argument across every equation
            all_log_args = set()
            for e in eqs_parsed:
                for la in e.atoms(log):
                    all_log_args.add(la.args[0])
            log_args = list(all_log_args)

            valid, extraneous = [], []
            for sol_dict in sols:
                ok = True
                for arg in log_args:
                    try:
                        sub_val = arg.subs(sol_dict)
                        if sub_val.has(I):
                            ok = False; break
                        # Parameter-dependent (extra symbols still free) — accept
                        if sub_val.free_symbols - set(var_syms):
                            continue
                        ev = sub_val.evalf()
                        if ev.is_real == False:
                            ok = False; break
                        if ev.is_real and float(ev) <= 1e-12:
                            ok = False; break
                    except Exception:
                        pass
                (valid if ok else extraneous).append(sol_dict)

            def _render(d, kind):
                parts = []
                for v in var_syms:
                    val = d.get(v)
                    if val is None:
                        continue
                    if kind == "latex":
                        parts.append("%s = %s" % (latex(v), latex(val)))
                    else:
                        parts.append("%s = %s" % (str(v), str(val)))
                if kind == "latex":
                    return "\\left(" + ",\\; ".join(parts) + "\\right)"
                return "(" + ", ".join(parts) + ")"

            if not valid:
                print("NOSOL")
                if extraneous:
                    emit_extraneous([
                        {"latex": _render(d, "latex"), "plain": _render(d, "plain")}
                        for d in extraneous
                    ])
            else:
                sep_l = " \\quad \\text{or} \\quad "
                valid_latex = sep_l.join([_render(d, "latex") for d in valid])
                valid_plain = "  or  ".join([_render(d, "plain") for d in valid])
                emit(valid_latex, valid_plain, "Solve System (CAS)")
                if extraneous:
                    emit_extraneous([
                        {"latex": _render(d, "latex"), "plain": _render(d, "plain")}
                        for d in extraneous
                    ])
            sys.exit()

        # ── Single-equation solve path (original behaviour) ──
        if "=" not in RAW:
            e = safe_parse(RAW)
            try:
                num = float(e.evalf())
                emit(latex(N(num, 12)), str(N(num, 12)), "Evaluate (CAS)")
            except (TypeError, ValueError):
                # Symbolic input in Solve mode — give a helpful redirect
                # instead of the raw "Cannot convert expression to float"
                # error that confused users (Audit chip-failure issue).
                if e.has(log):
                    print("ERROR:Solve mode needs an equation (with `=`). For symbolic log expressions, switch to Expand, Condense, or Simplify mode.")
                else:
                    print("ERROR:Solve mode needs an equation (with `=`). Got expression only.")
        else:
            lhs, rhs = RAW.split("=", 1)
            lhs_e = safe_parse(lhs.strip())
            rhs_e = safe_parse(rhs.strip())
            eq = lhs_e - rhs_e
            v = symbols(VAR)

            # Fix #2: wrap solve in a recursion guard.  JEE-style problems
            # like  x^(log_5 x) + x^(log_5(5/x)) = 25  send SymPy into deep
            # recursion.  We catch and emit a clean error instead of an
            # opaque server-side traceback.
            try:
                # Use the structured step-emitter for the entire solve flow.
                # It returns (valid, extraneous, steps) — same domain-filter
                # logic as before but with named pedagogical steps.
                valid, extraneous, steps = solve_with_steps(eq, v)
            except RecursionError:
                print("ERROR:Problem is too deeply nested for the symbolic solver. Try numerical evaluate mode or simplify the expression first.")
                sys.exit()

            if not valid:
                print("NOSOL")
                if extraneous:
                    emit_extraneous([
                        {"latex": VAR + " = " + latex(c), "plain": VAR + " = " + str(c)}
                        for c in extraneous
                    ])
                emit_steps(steps)
            else:
                sep = " \\quad \\text{or} \\quad "
                valid_latex = sep.join([VAR + " = " + latex(c) for c in valid])
                valid_plain = "  or  ".join([VAR + " = " + str(c) for c in valid])

                # Fix #4: append numeric companion when LambertW or other
                # intractable special functions appear in the closed form.
                payload = {
                    "latex": valid_latex,
                    "plain": valid_plain,
                    "method": "Solve (CAS)"
                }
                if any(c.has(LambertW) for c in valid):
                    nums = []
                    for c in valid:
                        n = _numeric_companion(c)
                        if n is not None:
                            nums.append(VAR + " ≈ " + n)
                    if nums:
                        payload["numeric"] = "  or  ".join(nums)
                print("RESULT:" + json.dumps(payload))
                emit_steps(steps)

                if extraneous:
                    emit_extraneous([
                        {"latex": VAR + " = " + latex(c), "plain": VAR + " = " + str(c)}
                        for c in extraneous
                    ])
    else:
        print("ERROR:Unknown mode: " + MODE)

except RecursionError:
    print("ERROR:Problem is too deeply nested for the symbolic engine. Try simpler input or numerical mode.")
except Exception as ex:
    print("ERROR:" + type(ex).__name__ + ": " + str(ex))
    </script>

    <!-- ─── Legacy inline IIFE — preserved verbatim from the pre-migration
            JSP.  Reads from #lc-input, #lc-var, #lc-mode-btn, #lc-keyboard,
            #lc-example-chip, etc.  All those IDs are present in the new
            shell so the script behaves identically.

            Power-engine additions (this commit):
              · _sympyLogSolve / _renderSympyResult / _showSympyPending —
                hit /OneCompilerFunctionality?action=execute with the Python
                template above.
              · doSolve now routes Expand and Condense to SymPy directly
                (nerdamer's expand/simplify do not apply log rules).
              · Solve mode runs a JS-side extraneous-solution filter on
                nerdamer results, falls back to SymPy if nerdamer returns
                nothing.
              · Simplify falls back to SymPy when nerdamer returns
                "(already simplified)".
            ─── -->
    <script>
    (function() {
    'use strict';

    // Custom log base: logb(x, base) = log(x)/log(base)
    if (typeof nerdamer !== 'undefined') {
        try { nerdamer.setFunction('logb', ['x','b'], 'log(x)/log(b)'); } catch(e) {}
    }

    var inputEl = document.getElementById('lc-input');
    var previewEl = document.getElementById('lc-preview');
    var varSelect = document.getElementById('lc-var');
    var solveBtn = document.getElementById('lc-solve-btn');
    var resultContent = document.getElementById('lc-result-content');
    var resultActions = document.getElementById('lc-result-actions');
    var emptyState = document.getElementById('lc-empty-state');
    var stepsArea = document.getElementById('lc-steps-area');
    var stepsBtn = document.getElementById('lc-steps-btn');
    var graphHint = document.getElementById('lc-graph-hint');

    var currentMode = 'solve';
    var lastResult = null;
    var lastResultLatex = '';
    var lastSolvedBy = null; // 'formula' | 'ai' | 'sympy'
    var lastExtraneous = []; // populated by SymPy or the JS-side filter
    var compilerLoaded = false;
    var pendingGraph = null;

    var __sympyEndpoint = '<%=request.getContextPath()%>/OneCompilerFunctionality?action=execute';

    // ── SymPy power-engine helpers ──────────────────────────────────────
    // Build the Python source for a given mode/raw/var by templating the
    // <script type="text/x-python" id="lc-sympy-template"> block in the JSP.
    function _b64encode(s) {
        return btoa(unescape(encodeURIComponent(s)));
    }
    function _buildSympyCode(mode, raw, varName) {
        var tpl = document.getElementById('lc-sympy-template');
        if (!tpl) return null;
        var src = tpl.textContent;
        return src
            .replace('%MODE%', mode)
            .replace('%VAR%', varName)
            .replace('%RAW_B64%', _b64encode(raw));
    }

    // Replaces the result panel with a small "Computing with SymPy…" notice
    // — matches the systems-solver `sy-sympy-pending` pattern visually.
    function _showSympyPending(msg) {
        if (emptyState) emptyState.style.display = 'none';
        resultActions.style.display = 'none';
        stepsArea.innerHTML = '';
        resultContent.innerHTML =
            '<div class="lc-sympy-pending" style="padding:1.5rem;text-align:center;color:var(--ms-ink-soft, #44403c);">' +
                '<div style="font-size:0.78rem;font-weight:600;color:var(--ms-muted, #78716c);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.5rem;">' +
                    '<span class="lc-badge">CAS</span> &nbsp; Computing&hellip;' +
                '</div>' +
                '<div style="font-size:0.85rem;">' + (msg || 'Sending to SymPy server-side engine.') + '</div>' +
            '</div>';
    }

    // Send Python to the OneCompiler endpoint.  Result format is line-based:
    //   RESULT:<json>          — main answer { latex, plain, method }
    //   EXTRANEOUS:<json>      — array of { latex, plain } discarded roots
    //   NOSOL                  — no real solutions
    //   ERROR:<message>        — Python-side error / unsupported input
    function _sympyLogSolve(mode, raw, varName, onResult) {
        var code = _buildSympyCode(mode, raw, varName);
        if (!code) {
            onResult({ ok: false, error: 'SymPy template missing.' });
            return;
        }
        var controller = new AbortController();
        var timeoutId = setTimeout(function () { controller.abort(); }, 45000);
        fetch(__sympyEndpoint, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: controller.signal
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            clearTimeout(timeoutId);
            var stdout = ((data.Stdout || data.stdout || '') + '').trim();

            var errMatch = stdout.match(/ERROR:(.*)/);
            if (errMatch) {
                onResult({ ok: false, error: errMatch[1].trim() });
                return;
            }
            if (stdout.indexOf('NOSOL') !== -1) {
                var ext1 = stdout.match(/EXTRANEOUS:(.+)/);
                var extraneous1 = [];
                if (ext1) {
                    try { extraneous1 = JSON.parse(ext1[1].trim()); } catch (e) {}
                }
                onResult({ ok: true, nosol: true, extraneous: extraneous1, method: 'CAS' });
                return;
            }
            var resMatch = stdout.match(/RESULT:(.+)/);
            if (!resMatch) {
                onResult({ ok: false, error: stdout || 'Empty response from server.' });
                return;
            }
            var payload;
            try { payload = JSON.parse(resMatch[1].trim()); }
            catch (e) {
                onResult({ ok: false, error: 'Could not parse SymPy result.' });
                return;
            }
            var ext2 = stdout.match(/EXTRANEOUS:(.+)/);
            var extraneous2 = [];
            if (ext2) {
                try { extraneous2 = JSON.parse(ext2[1].trim()); } catch (e) {}
            }
            // Pedagogical step trace from the Python step-emitter.  Each
            // step has { rule, label, before_latex, after_latex }.
            var stepsMatch = stdout.match(/STEPS:(.+)/);
            var steps = [];
            if (stepsMatch) {
                try { steps = JSON.parse(stepsMatch[1].trim()); } catch (e) {}
            }
            payload.ok = true;
            payload.extraneous = extraneous2;
            payload.steps = steps;
            onResult(payload);
        })
        .catch(function (err) {
            clearTimeout(timeoutId);
            var msg = err.name === 'AbortError'
                ? 'SymPy request timed out (45s).'
                : (err.message || 'Network error');
            onResult({ ok: false, error: msg });
        });
    }

    function _renderSympyResult(payload, raw) {
        if (!payload) return;

        if (payload.nosol) {
            var nosolHtml = '<div style="padding:1.5rem;text-align:center;">' +
                '<div style="font-size:0.78rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--ms-muted, #78716c);margin-bottom:0.5rem;">' +
                    '<span class="lc-badge">CAS</span>' +
                '</div>' +
                '<h3 style="margin:0.5rem 0;color:var(--ms-ink, #1c1917);">No real solution</h3>' +
                '<p style="font-size:0.85rem;color:var(--ms-ink-soft, #44403c);">All candidate roots were discarded as extraneous (a log argument would be &le; 0).</p>' +
            '</div>';
            if (payload.extraneous && payload.extraneous.length) {
                nosolHtml += '<div style="border-top:1px solid var(--ms-line, rgba(0,0,0,0.08));padding:0.85rem 1rem;">' +
                    '<div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted, #78716c);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.4rem;">Extraneous (rejected)</div>';
                payload.extraneous.forEach(function (ex, i) {
                    nosolHtml += '<div id="lc-ext-' + i + '" style="font-family:var(--ms-font-mono, monospace);font-size:0.85rem;margin:0.25rem 0;color:var(--ms-muted, #78716c);"></div>';
                });
                nosolHtml += '</div>';
            }
            resultContent.innerHTML = nosolHtml;
            (payload.extraneous || []).forEach(function (ex, i) {
                var el = document.getElementById('lc-ext-' + i);
                if (el && window.katex) {
                    try { katex.render(ex.latex, el, { displayMode: false, throwOnError: false }); }
                    catch (e) { el.textContent = ex.plain; }
                }
            });
            resultActions.style.display = 'none';
            lastSolvedBy = 'sympy';
            lastExtraneous = payload.extraneous || [];
            lastResult = { result: 'No real solution', method: payload.method || 'SymPy', raw: raw };
            return;
        }

        lastSolvedBy = 'sympy';
        lastResultLatex = payload.latex || '';
        lastExtraneous = payload.extraneous || [];

        var html = '<div style="text-align:center;padding:1.5rem;">';
        html += '<div style="font-size:0.78rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--ms-muted, #78716c);margin-bottom:0.5rem;">' +
                'Result <span class="lc-badge">CAS</span></div>';
        html += '<div id="lc-result-math" style="font-size:1.3rem;margin:1rem 0;"></div>';
        // Numeric companion: shown when SymPy returns a closed form that
        // contains LambertW or other intractable special functions.
        if (payload.numeric) {
            html += '<div style="font-size:0.95rem;color:var(--ms-accent, #15803d);font-family:var(--ms-font-mono, monospace);margin:0.4rem 0;">' +
                    String(payload.numeric).replace(/</g, '&lt;') + '</div>';
        }
        html += '<div style="font-size:0.85rem;color:var(--ms-ink-soft, #44403c);margin-top:0.5rem;">' + (payload.method || 'SymPy') + '</div>';
        html += '</div>';

        if (lastExtraneous.length) {
            html += '<div style="border-top:1px solid var(--ms-line, rgba(0,0,0,0.08));padding:0.85rem 1rem;background:rgba(245,158,11,0.06);">' +
                '<div style="font-size:0.72rem;font-weight:600;color:#b45309;text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.4rem;">Extraneous (rejected, log argument &le; 0)</div>';
            lastExtraneous.forEach(function (ex, i) {
                html += '<div id="lc-ext-' + i + '" style="font-family:var(--ms-font-mono, monospace);font-size:0.85rem;margin:0.25rem 0;color:#92400e;"></div>';
            });
            html += '</div>';
        }

        resultContent.innerHTML = html;
        try {
            katex.render(payload.latex || '', document.getElementById('lc-result-math'),
                { displayMode: true, throwOnError: false });
        } catch (e) {
            document.getElementById('lc-result-math').textContent = payload.plain || '';
        }
        lastExtraneous.forEach(function (ex, i) {
            var el = document.getElementById('lc-ext-' + i);
            if (el && window.katex) {
                try { katex.render(ex.latex, el, { displayMode: false, throwOnError: false }); }
                catch (e) { el.textContent = ex.plain; }
            }
        });

        resultActions.style.display = 'flex';
        if (emptyState) emptyState.style.display = 'none';
        stepsArea.innerHTML = '';
        lastResult = {
            result: payload.plain,
            method: payload.method || 'SymPy',
            raw: raw,
            steps: payload.steps || []   // rule-annotated steps for Show-Steps
        };

        // Prepare graph for solve mode (uses raw, not sympy output, since the
        // graph engine consumes the original equation form).
        if (currentMode === 'solve' && raw && raw.indexOf('=') >= 0) {
            try {
                var normExpr = normalizeInput(raw);
                prepareGraph(normExpr, varSelect.value);
            } catch (e) {}
        }
    }

    // JS-side extraneous-solution filter — fast path that runs WITHOUT a
    // server round-trip when nerdamer's solve gave us candidates.  Walks
    // every `log(arg)` (after normalization) in the equation, evaluates
    // each at every candidate, and rejects any candidate where any arg
    // evaluates to <= 0 or non-real.
    //
    // Returns { valid: [...], extraneous: [...] }.
    function _filterExtraneousJs(raw, varName, candidates) {
        var result = { valid: [], extraneous: [] };
        if (!candidates || !candidates.length) return result;

        // Collect log(arg) sub-expressions from the normalized equation.
        var norm = normalizeInput(raw);
        var combined = norm.replace('=', '+(');
        if (norm.indexOf('=') >= 0) combined += ')';
        var logArgs = [];
        var i = 0;
        while (i < combined.length) {
            var m = combined.substr(i).match(/^\blog\s*\(/);
            if (m) {
                var start = i + m[0].length;
                var end = findMatchingParen(combined, start);
                var arg = combined.substring(start, end);
                // Skip the literal numeric base in our normalized
                // (log(x)/log(N)) pattern — purely-numeric `log(N)` does
                // not constrain the domain.
                if (!/^\s*\d+(\.\d+)?\s*$/.test(arg)) {
                    logArgs.push(arg);
                }
                i = end + 1;
            } else {
                i++;
            }
        }

        candidates.forEach(function (sol) {
            var ok = true;
            try {
                for (var k = 0; k < logArgs.length; k++) {
                    var argEvalText;
                    try {
                        argEvalText = nerdamer(logArgs[k])
                            .sub(varName, '(' + sol + ')')
                            .evaluate()
                            .text('decimals');
                    } catch (e) {
                        argEvalText = '';
                    }
                    var argNum = parseFloat(argEvalText);
                    if (isFinite(argNum) && argNum <= 1e-12) { ok = false; break; }
                    // Non-finite or NaN typically means complex/symbolic — treat
                    // as extraneous to be safe (SymPy fallback can re-validate).
                    if (argEvalText && argEvalText.indexOf('i') >= 0) { ok = false; break; }
                }
            } catch (e) {
                // If nerdamer choked, leave the candidate in place — the
                // SymPy round-trip can decide later.
            }
            if (ok) result.valid.push(sol);
            else result.extraneous.push(sol);
        });
        return result;
    }
    // ── end SymPy power-engine helpers ──────────────────────────────────

    function findMatchingParen(str, start) {
        var depth = 1, i = start;
        while (depth > 0 && i < str.length) {
            if (str[i] === '(') depth++;
            else if (str[i] === ')') depth--;
            i++;
        }
        return i - 1;
    }

    function convertLogBases(s) {
        var result = '';
        var i = 0;
        while (i < s.length) {
            var m = s.substr(i).match(/^\blog(\d+)\s*\(/);
            if (m) {
                var base = m[1];
                var start = i + m[0].length;
                var end = findMatchingParen(s, start);
                var inner = s.substring(start, end);
                inner = convertLogBases(inner);
                result += '(log(' + inner + ')/log(' + base + '))';
                i = end + 1;
            } else {
                result += s[i];
                i++;
            }
        }
        return result;
    }

    function convertLogb(s) {
        var result = '';
        var i = 0;
        while (i < s.length) {
            var m = s.substr(i).match(/^\blogb\s*\(/);
            if (m) {
                var start = i + m[0].length;
                var end = findMatchingParen(s, start);
                var args = s.substring(start, end);
                var depth = 0, splitIdx = -1;
                for (var j = 0; j < args.length; j++) {
                    if (args[j] === '(') depth++;
                    else if (args[j] === ')') depth--;
                    else if (args[j] === ',' && depth === 0) { splitIdx = j; break; }
                }
                if (splitIdx >= 0) {
                    var expr = args.substring(0, splitIdx).trim();
                    var base = args.substring(splitIdx + 1).trim();
                    result += '(log(' + expr + ')/log(' + base + '))';
                } else {
                    result += s.substring(i, end + 1);
                }
                i = end + 1;
            } else {
                result += s[i];
                i++;
            }
        }
        return result;
    }

    function normalizeInput(s) {
        if (!s || !s.trim()) return s;
        s = s.trim();
        s = s.replace(/\bln\s*\(/g, 'log(');
        s = s.replace(/\blog_(\d+)\s*\(/g, function(m,b){ return 'log'+b+'('; });
        s = convertLogb(s);
        s = convertLogBases(s);
        return s;
    }

    function convertLogFracToSubscript(expr) {
        var result = expr;
        var out = '';
        var idx = 0;
        while (idx < result.length) {
            var m = result.substr(idx).match(/^\(log\(/);
            if (m) {
                var innerStart = idx + m[0].length;
                var innerEnd = findMatchingParen(result, innerStart);
                if (result.substr(innerEnd + 1, 5) === '/log(') {
                    var baseStart = innerEnd + 6;
                    var baseEnd = findMatchingParen(result, baseStart);
                    var baseStr = result.substring(baseStart, baseEnd);
                    var afterBase = baseEnd + 1;
                    if (result[afterBase] === ')') afterBase++;
                    if (baseStr) {
                        var inner = result.substring(innerStart, innerEnd);
                        var innerTex;
                        var innerConverted = convertLogFracToSubscript(inner);
                        if (/\\log_\{/.test(innerConverted)) {
                            innerTex = innerConverted;
                        } else {
                            try { innerTex = nerdamer(inner).toTeX(); } catch (e) { innerTex = inner.replace(/\*/g, ' \\cdot '); }
                        }
                        out += '\\log_{' + baseStr + '}\\left(' + innerTex + '\\right)';
                        idx = afterBase;
                        continue;
                    }
                }
            }
            out += result[idx];
            idx++;
        }
        return out;
    }

    function exprToLatex(expr) {
        try {
            var custom = convertLogFracToSubscript(expr);
            if (/\\log_\{/.test(custom)) {
                custom = custom.replace(/\*(?=\\log)/g, '');
                custom = custom.replace(/\*/g, ' \\cdot ');
                custom = custom.replace(/log\(([^)]+)\)/g, function(m, inner) {
                    try { return '\\ln\\left(' + nerdamer(inner).toTeX() + '\\right)'; }
                    catch(e) { return '\\ln(' + inner + ')'; }
                });
                return custom;
            }
            var e = nerdamer(expr);
            var tex = e.toTeX();
            var r = tex;
            r = r.replace(/\\frac\{\\ln\\left\((.+?)\\right\)\}\{\\ln\\left\((.+?)\\right\)\}/g, function(m, num, den) {
                var denNum = den.match(/^(\d+)$/);
                if (denNum) return '\\log_{' + denNum[1] + '}\\left(' + num + '\\right)';
                return m;
            });
            r = r.replace(/\\frac\{\\log\\left\((.+?)\\right\)\}\{\\log\\left\((.+?)\\right\)\}/g, function(m, num, den) {
                var denNum = den.match(/^(\d+)$/);
                if (denNum) return '\\log_{' + denNum[1] + '}\\left(' + num + '\\right)';
                return m;
            });
            r = r.replace(/\\frac\{\\mathrm\{ln\}\\left\((.+?)\\right\)\}\{\\mathrm\{ln\}\\left\((.+?)\\right\)\}/g, function(m, num, den) {
                var denNum = den.match(/^(\d+)$/);
                if (denNum) return '\\log_{' + denNum[1] + '}\\left(' + num + '\\right)';
                return m;
            });
            return r;
        } catch (err) {
            return expr.replace(/\*/g,' \\cdot ').replace(/\^/g,'^{').replace(/(\d)([\w])/g,'$1\\cdot $2');
        }
    }

    function updatePreview() {
        var s = inputEl.value.trim();
        if (!s) {
            previewEl.innerHTML = '<span style="color:var(--ms-muted, #78716c);font-size:0.85rem;">Type a problem above&hellip;</span>';
            return;
        }
        try {
            var norm = normalizeInput(s);
            var latex;
            if (norm.indexOf('=') >= 0) {
                var parts = norm.split('=');
                latex = exprToLatex(parts[0].trim()) + ' = ' + exprToLatex(parts[1].trim());
            } else {
                latex = exprToLatex(norm);
            }
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            previewEl.innerHTML = '<span style="color:var(--ms-muted, #78716c);">' + (s.length > 40 ? s.substring(0,40)+'...' : s) + '</span>';
        }
    }

    var previewTimer;
    inputEl.addEventListener('input', function() {
        clearTimeout(previewTimer);
        previewTimer = setTimeout(updatePreview, 200);
    });

    var modeConfig = {
        solve:    { btn: 'Solve Equation',       hint: 'Find the chosen variable. For systems, separate equations with `;` and set Variable to e.g. x,y',  placeholder: 'e.g. log2(x) = 5  ·  ln(x)+ln(x-2)=3  ·  log3(x)+log3(y)=4 ; log3(x/y)=2' },
        simplify: { btn: 'Simplify Expression',  hint: 'Reduce to simplest form, e.g. log(e²) → 2',                     placeholder: 'e.g. log(e^2)  or  ln(1)  or  log10(1000)' },
        expand:   { btn: 'Expand Logarithm',     hint: 'Break apart using product, quotient, power rules',              placeholder: 'e.g. log(x^2*y)  or  ln(a/b)  or  log(x^3)' },
        condense: { btn: 'Condense Logarithm',   hint: 'Combine multiple logs into a single log',                       placeholder: 'e.g. 2*log(x)+log(y)  or  ln(a)-ln(b)' },
        evaluate: { btn: 'Evaluate to Decimal',  hint: 'Compute the numeric decimal value',                             placeholder: 'e.g. log2(10)  or  ln(5)  or  log10(50)' },
        rewrite:  { btn: 'Rewrite Equation',     hint: 'Convert between exponential and logarithmic form',              placeholder: 'e.g. 5^3 = 125  ↔  log_5(125) = 3' }
    };
    var modeHintEl = document.getElementById('lc-mode-hint');

    document.querySelectorAll('.lc-mode-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            currentMode = this.getAttribute('data-mode');
            document.querySelectorAll('.lc-mode-btn').forEach(function(b){ b.classList.remove('active'); });
            this.classList.add('active');
            var cfg = modeConfig[currentMode];
            solveBtn.textContent = cfg.btn;
            modeHintEl.textContent = cfg.hint;
            inputEl.placeholder = cfg.placeholder;
            updatePreview();
        });
    });

    document.querySelectorAll('.lc-example-chip').forEach(function(chip) {
        chip.addEventListener('click', function() {
            // 1. Switch mode FIRST so currentMode, button label, hint, and
            //    placeholder all reflect the example's intended operation.
            //    Without this, clicking a chip like `log(x²y)` left the user
            //    in the default Solve mode and produced a TypeError.
            var dm = this.getAttribute('data-mode');
            if (dm) {
                var pill = document.querySelector('.lc-mode-btn[data-mode="' + dm + '"]');
                if (pill) pill.click();
            }
            // 2. Optional: chip-specific variable (systems need e.g. `x,y`).
            var dv = this.getAttribute('data-vars');
            if (dv && varSelect) varSelect.value = dv;
            // 3. Fill the input and let the legacy preview/auto-calc take over.
            inputEl.value = this.getAttribute('data-expr');
            inputEl.dispatchEvent(new Event('input', { bubbles: true }));
            updatePreview();
        });
    });

    // Legacy soft-keyboard delegation — div is empty in the new shell so
    // this is a no-op, but the listener is preserved to avoid touching JS.
    var kbd = document.getElementById('lc-keyboard');
    if (kbd) {
        kbd.addEventListener('click', function(e) {
            var btn = e.target.closest('.lc-key-btn');
            if (btn && btn.dataset.insert) {
                e.preventDefault();
                inputEl.focus();
                // (legacy insertAtCursor — only reachable if a .lc-key-btn
                //  is added back to the DOM)
            }
        });
    }

    function showResult(html, method, solvedBy) {
        lastResult = { html: html, method: method };
        lastSolvedBy = solvedBy;
        resultContent.innerHTML = html;
        resultActions.style.display = 'flex';
        if (emptyState) emptyState.style.display = 'none';
        stepsArea.innerHTML = '';
    }

    function showError(msg) {
        resultContent.innerHTML = '<div class="lc-error"><h4>Could not solve</h4><p>' + (msg || 'Try rephrasing or use a simpler expression.') + '</p></div>';
        resultActions.style.display = 'none';
        if (emptyState) emptyState.style.display = 'none';
    }

    function eliminateLogBase(eq) {
        var baseRe = /\/log\((\d+)\)/g;
        var match, bases = [];
        while ((match = baseRe.exec(eq)) !== null) {
            bases.push(match[1]);
        }
        if (bases.length === 0) return eq;
        var allSame = bases.every(function(b) { return b === bases[0]; });
        if (!allSame) return eq;
        var base = bases[0];
        var logBase = 'log(' + base + ')';
        try {
            var multiplied = nerdamer('expand((' + eq + ')*' + logBase + ')').text();
            return multiplied;
        } catch (e) {
            return eq;
        }
    }

    function tryFormulaSolve() {
        var raw = inputEl.value.trim();
        if (!raw) return null;
        var expr = normalizeInput(raw);
        var v = varSelect.value;

        try {
            if (currentMode === 'solve' && expr.indexOf('=') >= 0) {
                var sides = expr.split('=');
                var lhs = sides[0].trim(), rhs = sides[1].trim();
                var eqRaw = lhs + '-(' + rhs + ')';
                var eqSimplified = eliminateLogBase(eqRaw);
                var sols = null, solText = '';
                var attempts = [eqSimplified];
                if (eqSimplified !== eqRaw) attempts.push(eqRaw);
                for (var ai = 0; ai < attempts.length; ai++) {
                    try {
                        sols = nerdamer.solve(attempts[ai], v);
                        solText = sols.text ? sols.text() : String(sols);
                        if (solText && solText !== '[]') break;
                    } catch(e) { solText = ''; }
                }
                if (solText && solText !== '[]' && solText.length > 0) {
                    var resultExpr = solText.replace(/^\[|\]$/g, '').trim();
                    if (resultExpr) {
                        var solutions = resultExpr.split(',').map(function(s){ return s.trim(); }).filter(Boolean);
                        var latexParts = solutions.map(function(sol) {
                            try { return v + ' = ' + nerdamer(sol).toTeX(); }
                            catch(e) { return v + ' = ' + sol; }
                        });
                        var textParts = solutions.map(function(sol) { return v + ' = ' + sol; });
                        var latex = latexParts.join(' \\quad \\text{or} \\quad ');
                        var resultText = textParts.join('  or  ');
                        return { success: true, result: resultText, latex: latex, method: 'Solve Equation' };
                    }
                }
            } else if (currentMode === 'solve' && expr.indexOf('=') < 0) {
                var ev0 = nerdamer(expr).evaluate();
                var evText0 = ev0.text ? ev0.text() : String(ev0);
                var num0 = parseFloat(evText0);
                if (!isNaN(num0)) {
                    return { success: true, result: evText0, latex: (ev0.toTeX ? ev0.toTeX() : evText0), method: 'Evaluate', numeric: num0 };
                }
            } else if (currentMode === 'expand') {
                var expanded = nerdamer('expand(' + expr + ')');
                var expText = expanded.text();
                if (expText && expText !== expr) {
                    return { success: true, result: expText, latex: exprToLatex(expText), method: 'Expand' };
                }
                return { success: true, result: expr, latex: exprToLatex(expr), method: 'Expand (already expanded)' };
            } else if (currentMode === 'condense') {
                var simplified = nerdamer('simplify(' + expr + ')');
                var res = simplified.text();
                if (res && res !== expr) {
                    return { success: true, result: res, latex: exprToLatex(res), method: 'Condense' };
                }
                return { success: true, result: expr, latex: exprToLatex(expr), method: 'Condense (already condensed)' };
            } else if (currentMode === 'simplify') {
                var simplified2 = nerdamer('simplify(' + expr + ')');
                var simText = simplified2.text();
                var evText = '';
                try {
                    var ev = nerdamer(expr).evaluate();
                    evText = ev.text ? ev.text() : String(ev);
                } catch(e2) {}
                var evNum = parseFloat(evText);
                if (!isNaN(evNum) && evNum === Math.round(evNum * 1e10) / 1e10) {
                    return { success: true, result: evText, latex: evText, method: 'Simplify', numeric: evNum };
                }
                if (simText && simText !== expr) {
                    return { success: true, result: simText, latex: exprToLatex(simText), method: 'Simplify' };
                }
                return { success: true, result: expr, latex: exprToLatex(expr), method: 'Simplify (already simplified)' };
            } else if (currentMode === 'evaluate') {
                var ev2 = nerdamer(expr).evaluate();
                var evText2 = ev2.text ? ev2.text() : String(ev2);
                var num = parseFloat(evText2);
                if (!isNaN(num) || evText2 && evText2.indexOf('log') === -1) {
                    return { success: true, result: evText2, latex: (ev2.toTeX ? ev2.toTeX() : evText2), method: 'Evaluate', numeric: num };
                }
            }
        } catch (e) {
            console.warn('Formula solve failed:', e);
        }
        return null;
    }

    // Render a successful nerdamer result with the "Formula" badge.  Pulled
    // out of doSolve so the SymPy / extraneous-filter branches can also use
    // it without duplicating the KaTeX wiring.
    function _renderFormulaResult(formulaResult, raw) {
        lastSolvedBy = 'formula';
        lastResultLatex = formulaResult.latex || '';
        lastExtraneous = formulaResult.extraneous || [];

        var badge = '<span class="lc-badge">Formula</span>';
        var html = '<div style="text-align:center;padding:1.5rem">';
        html += '<div style="font-size:0.78rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--ms-muted, #78716c);margin-bottom:0.5rem">Result ' + badge + '</div>';
        html += '<div id="lc-result-math" style="font-size:1.3rem;margin:1rem 0"></div>';
        html += '<div style="font-size:0.85rem;color:var(--ms-ink-soft, #44403c);margin-top:0.5rem">' + formulaResult.method + '</div>';
        html += '</div>';

        if (lastExtraneous.length) {
            html += '<div style="border-top:1px solid var(--ms-line, rgba(0,0,0,0.08));padding:0.85rem 1rem;background:rgba(245,158,11,0.06);">' +
                '<div style="font-size:0.72rem;font-weight:600;color:#b45309;text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.4rem;">Extraneous (rejected, log argument &le; 0)</div>';
            lastExtraneous.forEach(function (ex, i) {
                html += '<div id="lc-ext-' + i + '" style="font-family:var(--ms-font-mono, monospace);font-size:0.85rem;margin:0.25rem 0;color:#92400e;"></div>';
            });
            html += '</div>';
        }

        resultContent.innerHTML = html;
        try {
            katex.render(formulaResult.latex, document.getElementById('lc-result-math'),
                { displayMode: true, throwOnError: false });
        } catch (e) {
            document.getElementById('lc-result-math').textContent = formulaResult.result;
        }
        lastExtraneous.forEach(function (ex, i) {
            var el = document.getElementById('lc-ext-' + i);
            if (el && window.katex) {
                try { katex.render(ex, el, { displayMode: false, throwOnError: false }); }
                catch (e) { el.textContent = ex; }
            }
        });

        resultActions.style.display = 'flex';
        if (emptyState) emptyState.style.display = 'none';
        stepsArea.innerHTML = '';
        lastResult = {
            result: formulaResult.result,
            method: formulaResult.method,
            raw: raw,
            steps: []  // nerdamer path has no rule trace; legacy fallback used
        };

        var normExpr = normalizeInput(raw);
        prepareGraph(normExpr, varSelect.value);
    }

    function doSolve() {
        var raw = inputEl.value.trim();
        if (!raw) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter a problem.', 2000, 'warning');
            return;
        }

        // ── Expand / Condense / Rewrite ALWAYS go to SymPy.  Nerdamer's
        //    expand() is polynomial expansion and `simplify()` does not
        //    apply log rules; Rewrite is a notation conversion that has
        //    no nerdamer counterpart. ──────────────────────────────────
        if (currentMode === 'expand' || currentMode === 'condense' || currentMode === 'rewrite') {
            var pendingMsg = (currentMode === 'rewrite')
                ? 'Converting notation with SymPy.'
                : 'Applying log rules with SymPy.';
            _showSympyPending(pendingMsg);
            _sympyLogSolve(currentMode, raw, varSelect.value, function (payload) {
                if (payload.ok) {
                    _renderSympyResult(payload, raw);
                } else if (payload.error) {
                    showError(payload.error);
                } else {
                    requestAISolve(raw);
                }
            });
            return;
        }

        // ── For Solve / Simplify / Evaluate, try the fast nerdamer path
        //    first.  Apply JS-side extraneous filter on Solve results, and
        //    fall back to SymPy when nerdamer "(already simplified)" or
        //    returns nothing useful. ──────────────────────────────────────
        var formulaResult = tryFormulaSolve();

        if (formulaResult && formulaResult.success) {
            // Detect the no-op fall-throughs and route to SymPy instead.
            if (/\(already /.test(formulaResult.method)) {
                _showSympyPending('Trying SymPy for a deeper transform.');
                _sympyLogSolve(currentMode, raw, varSelect.value, function (payload) {
                    if (payload.ok && !payload.nosol) _renderSympyResult(payload, raw);
                    else _renderFormulaResult(formulaResult, raw); // accept "already" as-is
                });
                return;
            }

            // Solve mode: extraneous-solution filter on the candidates.
            if (currentMode === 'solve' && formulaResult.method === 'Solve Equation' && raw.indexOf('=') >= 0) {
                var v = varSelect.value;
                var prefix = v + ' = ';
                var solutions = (formulaResult.result || '').split(/  or  /)
                    .map(function (s) { return s.indexOf(prefix) === 0 ? s.substring(prefix.length) : s; })
                    .filter(Boolean);
                var filtered = _filterExtraneousJs(raw, v, solutions);
                if (filtered.extraneous.length > 0) {
                    if (filtered.valid.length === 0) {
                        // All nerdamer roots were extraneous — let SymPy
                        // decide.  Maybe it can find different real roots.
                        _showSympyPending('Verifying with SymPy &mdash; nerdamer roots failed the domain check.');
                        _sympyLogSolve('solve', raw, v, function (payload) {
                            if (payload.ok) _renderSympyResult(payload, raw);
                            else _renderFormulaResult(formulaResult, raw);
                        });
                        return;
                    }
                    // Re-build the formula result with valid solutions only.
                    var validLatexParts = filtered.valid.map(function (sol) {
                        try { return v + ' = ' + nerdamer(sol).toTeX(); }
                        catch (e) { return v + ' = ' + sol; }
                    });
                    var validTextParts = filtered.valid.map(function (sol) { return v + ' = ' + sol; });
                    formulaResult.result = validTextParts.join('  or  ');
                    formulaResult.latex = validLatexParts.join(' \\quad \\text{or} \\quad ');
                    formulaResult.extraneous = filtered.extraneous.map(function (sol) { return v + ' = ' + sol; });
                }
            }

            _renderFormulaResult(formulaResult, raw);
            return;
        }

        // Nerdamer found nothing — try SymPy before AI.  AI is slow and
        // unreliable; SymPy nails most algebraic log problems.
        _showSympyPending('Computing with SymPy.');
        _sympyLogSolve(currentMode, raw, varSelect.value, function (payload) {
            if (payload.ok) _renderSympyResult(payload, raw);
            else if (payload.error) requestAISolve(raw);
            else requestAISolve(raw);
        });
    }

    function requestAISolve(raw) {
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem"><span style="opacity:0.7">⏳</span> Using AI to solve…</div>';
        resultActions.style.display = 'none';

        var payload = {
            operation: 'logarithm',
            expression: raw,
            answer: 'unknown',
            mode: currentMode,
            variable: varSelect.value
        };

        fetch('<%=request.getContextPath()%>/CFExamMarkerFunctionality?action=math_steps', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success && data.steps && data.steps.length > 0) {
                lastSolvedBy = 'ai';
                var html = '<div style="padding:1rem">';
                html += '<span class="lc-badge">AI Generated</span>';
                for (var i = 0; i < data.steps.length; i++) {
                    html += '<div style="margin:0.75rem 0">';
                    html += '<div style="font-size:0.78rem;font-weight:600;color:var(--ms-muted, #78716c);margin-bottom:0.25rem">' + (data.steps[i].title || 'Step '+(i+1)) + '</div>';
                    html += '<div id="lc-ai-step-' + i + '" style="font-size:1rem"></div>';
                    html += '</div>';
                }
                html += '</div>';
                resultContent.innerHTML = html;
                for (var j = 0; j < data.steps.length; j++) {
                    var el = document.getElementById('lc-ai-step-' + j);
                    if (el && data.steps[j].latex) {
                        var ltx = data.steps[j].latex;
                        var wordCount = (ltx.match(/[a-zA-Z]{2,}/g) || []).length;
                        var isSentence = wordCount >= 4 && ltx.indexOf(' ') >= 0;
                        if (isSentence) {
                            el.style.color = 'var(--ms-ink-soft, #44403c)';
                            el.style.fontSize = '0.9rem';
                            el.style.lineHeight = '1.6';
                            el.textContent = ltx.replace(/\\\\/g, '\\');
                        } else {
                            try {
                                katex.render(ltx, el, { displayMode: true, throwOnError: false });
                            } catch (e) { el.textContent = ltx; }
                        }
                    }
                }
                resultActions.style.display = 'flex';
            } else {
                showError(data.error || 'AI could not solve this problem.');
            }
        })
        .catch(function(err) {
            showError('Network error. Falling back: formula solver did not recognize this. Try: log(x)=2, log(x)+log(y), log(e^2)');
        });
    }

    solveBtn.addEventListener('click', doSolve);
    inputEl.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') doSolve();
    });

    var tabBtns = document.querySelectorAll('.lc-output-tab');
    var panels  = document.querySelectorAll('.lc-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('lc-panel-' + panel).classList.add('active');

            if (panel === 'graph' && pendingGraph) {
                loadPlotly(function() { renderGraph(pendingGraph); });
            }
            if (panel === 'python' && !compilerLoaded) {
                loadCompilerWithTemplate();
                compilerLoaded = true;
            }
        });
    });

    document.getElementById('lc-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultLatex || '', 'LaTeX copied!');
        } else {
            navigator.clipboard.writeText(lastResultLatex || '');
        }
    });
    document.getElementById('lc-copy-text-btn').addEventListener('click', function() {
        var text = (lastResult && lastResult.result) || '';
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(text, 'Copied!');
        } else {
            navigator.clipboard.writeText(text);
        }
    });
    document.getElementById('lc-share-btn').addEventListener('click', function() {
        var expr = inputEl.value.trim();
        if (!expr) return;
        var url = window.location.origin + window.location.pathname + '?q=' + encodeURIComponent(expr);
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(url, 'Share link copied!');
        } else {
            navigator.clipboard.writeText(url);
        }
    });

    stepsBtn.addEventListener('click', function() {
        if (!lastResult) return;

        // Prefer SymPy's rule-annotated steps when available.  Each step
        // has { rule, label, before_latex, after_latex }.
        var steps = (lastResult.steps && lastResult.steps.length)
            ? lastResult.steps
            : null;

        // Fall back to a 2-step legacy stub if no SymPy trace exists
        // (i.e. nerdamer-only formula path with no STEPS line).
        if (!steps && lastSolvedBy === 'formula') {
            steps = [];
            if (lastResult.method === 'Solve Equation') {
                steps.push({ rule: 'rewrite', label: 'Rewrite equation',
                             before_latex: '', after_latex: '\\text{Move terms to one side}' });
                steps.push({ rule: 'solve', label: 'Solve',
                             before_latex: '', after_latex: lastResult.result });
            } else {
                steps.push({ rule: 'apply', label: lastResult.method,
                             before_latex: '', after_latex: lastResult.result });
            }
        }
        if (!steps || !steps.length) {
            stepsArea.innerHTML =
                '<div style="padding:0.75rem 1rem;font-size:0.85rem;color:var(--ms-muted, #78716c);">' +
                'No step-by-step trace available for this result.</div>';
            return;
        }

        var html =
            '<div style="border:1px solid var(--ms-line, rgba(0,0,0,0.08));border-radius:var(--ms-radius, 14px);overflow:hidden;margin-top:1rem;">' +
                '<div style="padding:0.75rem 1rem;background:var(--ms-accent-soft, rgba(21,128,61,0.08));font-weight:600;font-size:0.85rem;color:var(--ms-accent, #15803d);">' +
                    'Step-by-step derivation' +
                '</div>';
        for (var i = 0; i < steps.length; i++) {
            var s = steps[i];
            html +=
                '<div style="padding:0.75rem 1rem;border-top:1px solid var(--ms-line, rgba(0,0,0,0.08));display:flex;gap:0.75rem;align-items:flex-start;">' +
                    '<span style="width:24px;height:24px;background:var(--ms-accent, #15803d);color:#fff;border-radius:50%;font-size:0.75rem;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;">' + (i+1) + '</span>' +
                    '<div style="flex:1;min-width:0;">' +
                        '<div style="font-size:0.78rem;font-weight:600;color:var(--ms-ink-soft, #44403c);margin-bottom:0.4rem;">' +
                            (s.label ? s.label.replace(/</g, '&lt;') : (s.rule || 'Step ' + (i+1))) +
                        '</div>';
            if (s.before_latex) {
                html += '<div id="lc-step-before-' + i + '" style="font-size:0.95rem;margin:0.25rem 0;color:var(--ms-muted, #78716c);"></div>' +
                        '<div style="font-size:0.78rem;color:var(--ms-muted, #78716c);margin:0.15rem 0;">↓</div>';
            }
            html += '<div id="lc-step-after-' + i + '" style="font-size:1rem;margin:0.25rem 0;color:var(--ms-ink, #1c1917);"></div>' +
                    '</div>' +
                '</div>';
        }
        html += '</div>';
        stepsArea.innerHTML = html;

        // Render KaTeX for before/after of each step.
        for (var k = 0; k < steps.length; k++) {
            var sk = steps[k];
            if (sk.before_latex) {
                var bel = document.getElementById('lc-step-before-' + k);
                if (bel) {
                    try { katex.render(sk.before_latex, bel,
                            { displayMode: true, throwOnError: false }); }
                    catch (e) { bel.textContent = sk.before_latex; }
                }
            }
            var ael = document.getElementById('lc-step-after-' + k);
            if (ael) {
                var ltx = sk.after_latex || sk.latex || '';
                try { katex.render(ltx, ael,
                        { displayMode: true, throwOnError: false }); }
                catch (e) { ael.textContent = ltx; }
            }
        }
    });

    function prepareGraph(exprStr, v) {
        pendingGraph = { expr: exprStr, v: v };
        if (graphHint) graphHint.style.display = 'none';
        var graphPanel = document.getElementById('lc-panel-graph');
        if (graphPanel.classList.contains('active')) {
            loadPlotly(function() { renderGraph(pendingGraph); });
        }
    }

    function renderGraph(cfg) {
        if (!window.Plotly) return;
        var container = document.getElementById('lc-graph-container');
        var v = cfg.v;
        var expr = cfg.expr;

        var hasEq = expr.indexOf('=') >= 0;
        var lhsExpr, rhsExpr;
        if (hasEq) {
            var parts = expr.split('=');
            lhsExpr = parts[0].trim();
            rhsExpr = parts[1].trim();
        } else {
            lhsExpr = expr;
        }

        var xMin = 0.01, xMax = 20;
        var n = 500;
        var xs = [], ysLhs = [], ysRhs = [];
        var step = (xMax - xMin) / n;

        for (var i = 0; i <= n; i++) {
            var xVal = xMin + i * step;
            xs.push(xVal);
            ysLhs.push(evalAtPoint(lhsExpr, v, xVal));
            if (hasEq) ysRhs.push(evalAtPoint(rhsExpr, v, xVal));
        }

        var traces = [];
        traces.push({
            x: xs, y: ysLhs,
            type: 'scatter', mode: 'lines',
            name: hasEq ? 'LHS: ' + cfg.expr.split('=')[0].trim() : 'f(' + v + ')',
            line: { color: '#15803d', width: 2.5 }
        });

        if (hasEq) {
            traces.push({
                x: xs, y: ysRhs,
                type: 'scatter', mode: 'lines',
                name: 'RHS: ' + cfg.expr.split('=')[1].trim(),
                line: { color: '#f59e0b', width: 2, dash: 'dash' }
            });
        }

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var layout = {
            margin: { t: 30, r: 20, b: 40, l: 50 },
            xaxis: { title: v, gridcolor: isDark ? '#334155' : '#e7e5e4', zerolinecolor: isDark ? '#475569' : '#d6d3d1', color: isDark ? '#d6d3d1' : '#44403c' },
            yaxis: { gridcolor: isDark ? '#334155' : '#e7e5e4', zerolinecolor: isDark ? '#475569' : '#d6d3d1', color: isDark ? '#d6d3d1' : '#44403c' },
            paper_bgcolor: isDark ? '#1c1917' : '#fefdfb',
            plot_bgcolor: isDark ? '#1c1917' : '#fefdfb',
            font: { family: 'Inter, sans-serif', size: 12, color: isDark ? '#d6d3d1' : '#44403c' },
            legend: { x: 0, y: 1.12, orientation: 'h', font: { size: 11 } },
            showlegend: true
        };

        Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
    }

    function evalAtPoint(exprStr, v, xVal) {
        try {
            var scope = {};
            scope[v] = xVal;
            var val = parseFloat(nerdamer(exprStr).evaluate(scope).text('decimals'));
            if (!isFinite(val) || Math.abs(val) > 1e6) return null;
            return val;
        } catch (e) {
            return null;
        }
    }

    function nerdamerToPython(expr) {
        return expr
            .replace(/e\^(\([^)]+\))/g, 'exp$1')
            .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
            .replace(/\^/g, '**');
    }

    function buildCompilerCode(template) {
        var raw = inputEl.value.trim() || 'log(x)';
        var v = varSelect.value;
        var pyExpr = raw
            .replace(/\bln\s*\(/g, 'log(')
            .replace(/\blog(\d+)\s*\(([^)]*)\)/g, function(m,b,inner) { return 'log('+inner+','+b+')'; })
            .replace(/\blog_(\d+)\s*\(([^)]*)\)/g, function(m,b,inner) { return 'log('+inner+','+b+')'; })
            .replace(/\blogb\s*\(/g, 'log(');
        pyExpr = nerdamerToPython(pyExpr);

        if (template === 'sympy-solve') {
            var hasEq = raw.indexOf('=') >= 0;
            if (hasEq) {
                var sides = pyExpr.split('=');
                return 'from sympy import *\n\n' + v + ' = symbols(\'' + v + '\')\n\n# Solve: ' + raw + '\nlhs = ' + sides[0].trim() + '\nrhs = ' + sides[1].trim() + '\n\nresult = solve(lhs - rhs, ' + v + ')\nprint("Solutions:")\nfor sol in result:\n    pprint(sol)\nprint("\\nLaTeX:", [latex(s) for s in result])';
            }
            return 'from sympy import *\n\n' + v + ' = symbols(\'' + v + '\')\nexpr = ' + pyExpr + '\n\nresult = simplify(expr)\nprint("Result:")\npprint(result)\nprint("\\nNumeric:", float(result) if result.is_number else "symbolic")';
        } else if (template === 'sympy-simplify') {
            return 'from sympy import *\n\n' + v + ' = symbols(\'' + v + '\')\nexpr = ' + pyExpr.split('=')[0].trim() + '\n\nresult = simplify(expr)\nprint("Simplified:")\npprint(result)\nprint("\\nExpanded:")\npprint(expand_log(expr, force=True))\nprint("\\nLaTeX:", latex(result))';
        } else {
            return 'from sympy import *\n\n' + v + ' = symbols(\'' + v + '\')\nexpr = ' + pyExpr.split('=')[0].trim() + '\n\nexpanded = expand_log(expr, force=True)\nprint("Expanded:")\npprint(expanded)\n\ncondensed = logcombine(expanded, force=True)\nprint("\\nCondensed:")\npprint(condensed)\nprint("\\nLaTeX:", latex(expanded))';
        }
    }

    function loadCompilerWithTemplate() {
        var template = document.getElementById('lc-compiler-template').value;
        var code = buildCompilerCode(template);
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('lc-compiler-iframe');
        iframe.src = '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    document.getElementById('lc-compiler-template').addEventListener('change', function() {
        loadCompilerWithTemplate();
    });

    var urlParams = new URLSearchParams(window.location.search);
    var q = urlParams.get('q') || urlParams.get('expr');
    if (q) {
        inputEl.value = decodeURIComponent(q);
        // dispatch input so the bridge IIFE mirrors into MathLive too
        inputEl.dispatchEvent(new Event('input', { bubbles: true }));
        updatePreview();
        setTimeout(doSolve, 300);
    }

    // ── Test-hook export: when `window._LC_TEST_HOOK = true` is set BEFORE
    //    this IIFE runs (e.g. from the unit-test sandbox), expose the pure
    //    helpers under `window.LogarithmCalculator.__test` so they can be
    //    asserted on in isolation.  No effect in normal page load. ─────
    if (typeof window !== 'undefined' && window._LC_TEST_HOOK) {
        window.LogarithmCalculator = {
            __test: {
                findMatchingParen: findMatchingParen,
                convertLogBases: convertLogBases,
                convertLogb: convertLogb,
                normalizeInput: normalizeInput,
                exprToLatex: exprToLatex,
                eliminateLogBase: eliminateLogBase,
                filterExtraneousJs: _filterExtraneousJs,
                buildSympyCode: _buildSympyCode
            }
        };
    }
    })();
    </script>

    <!-- ─── Worksheet engine + button binding (uses the existing
            worksheet/math/algebra/logarithms.json — 2,000+ problems) ─── -->
    <script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>
    <script>
    (function(){
        function openLogWorksheet() {
            if (typeof WorksheetEngine !== 'undefined') {
                WorksheetEngine.open({
                    jsonUrl: '<%=request.getContextPath()%>/worksheet/math/algebra/logarithms.json',
                    title: 'Logarithms',
                    accentColor: '#15803d',
                    branding: '8gwifi.org',
                    defaultCount: 20
                });
            }
        }
        var btn = document.getElementById('log-worksheet-btn');
        if (btn) btn.addEventListener('click', openLogWorksheet);
    })();
    </script>

    <!-- ─── MathLive primary input (mode toggle, virtual keyboard, ic-expr↔mathfield wiring) ─── -->
    <jsp:include page="/math/partials/math-input-setup.jsp" />

    <!-- ─── Bridge: MathLive (#ic-expr) ↔ legacy (#lc-input)
            The legacy IIFE reads from #lc-input.  MathLive writes ascii-math to
            #ic-expr.  This bridge mirrors values both directions and re-fires
            input events so the legacy KaTeX preview, formula solver, and example
            chip handlers keep working without modification. ─── -->
    <script>
    (function () {
        'use strict';

        var icExpr  = document.getElementById('ic-expr');
        var lcInput = document.getElementById('lc-input');
        if (!icExpr || !lcInput) return;

        // Native HTMLInputElement.value setter — bypass any property hooks
        // that might be installed on these inputs.
        var nativeSetter = (function () {
            try {
                var d = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value');
                return d && typeof d.set === 'function' ? d.set : null;
            } catch (e) { return null; }
        })();
        function setRaw(el, v) {
            if (nativeSetter) nativeSetter.call(el, v);
            else el.value = v;
        }

        // ic-expr → lc-input (forward, MathLive-driven typing)
        icExpr.addEventListener('input', function () {
            if (lcInput.value === icExpr.value) return;
            setRaw(lcInput, icExpr.value);
            lcInput.dispatchEvent(new Event('input', { bubbles: true }));
        });

        // lc-input → ic-expr (reverse, for example chips and URL-param boot)
        // Hook lc-input.value setter so any programmatic write mirrors back.
        if (nativeSetter) {
            try {
                var nativeGetter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').get;
                Object.defineProperty(lcInput, 'value', {
                    configurable: true,
                    enumerable: true,
                    get: function () { return nativeGetter.call(this); },
                    set: function (v) {
                        nativeSetter.call(this, v);
                        if (icExpr.value !== v) {
                            // Use a separate write through ic-expr's own setter so
                            // the math-input-setup partial picks it up and seeds
                            // the math-field.
                            icExpr.value = v;
                        }
                    }
                });
            } catch (e) { /* non-fatal */ }
        }

        // Boot: if lc-input already has a value (from URL ?q=…) or ic-expr has
        // a placeholder pre-fill, do a one-shot sync now.
        if (lcInput.value && lcInput.value !== icExpr.value) {
            icExpr.value = lcInput.value;
        } else if (icExpr.value && icExpr.value !== lcInput.value) {
            setRaw(lcInput, icExpr.value);
            lcInput.dispatchEvent(new Event('input', { bubbles: true }));
        }
    })();
    </script>

    <!-- ─── AI image-scan — logarithm-specific extraction prompt ─── -->
    <script>
    (function () {
        if (typeof ImageToMath === 'undefined') return;
        var CTX = '<%=request.getContextPath()%>';
        ImageToMath.init({
            buttonId: 'lc-image-btn',
            aiUrl: CTX + '/ai',
            toolName: 'Logarithm Calculator',
            extractionPrompt:
                'You are a math problem extractor for a logarithm calculator.\n' +
                'Given OCR text from a math image, extract logarithm problems.\n' +
                'Return a JSON array. Each object has:\n' +
                '  - "expr": the logarithm problem in plain ASCII (e.g. "log2(x) = 5", "ln(x*y)", "log10(1000)")\n' +
                '  - "latex": the LaTeX form (e.g. "\\log_2(x) = 5", "\\ln(xy)")\n' +
                '  - "mode": one of "solve" (has =), "expand" (single log of product/quotient/power),\n' +
                '            "condense" (sum or difference of logs), "simplify", "evaluate" (numeric only)\n' +
                '  - "display": pretty unicode form for preview\n\n' +
                'Notation rules:\n' +
                '- ln(x) → natural log\n' +
                '- log(x) → natural log (calculator convention)\n' +
                '- log_b(x), log b(x), log_{b}(x) → log base b\n' +
                '- Subscripts may appear as small digits or LaTeX \\log_{2}\n' +
                '- log10, log_{10} → common log; log2, log_{2} → binary log\n' +
                '- Multi-term equations (sum/difference of logs equals constant) → mode "solve"\n' +
                '- Products and quotients inside a single log → mode "expand"\n' +
                '- Multiple separate log terms with + or − → mode "condense"\n' +
                'Return ONLY valid JSON array, no markdown fences.\n' +
                'If no problems found, return [].',
            onSelect: function (problem) {
                if (!problem) return;
                var mf = document.getElementById('ic-mathfield');
                if (mf && typeof mf.setValue === 'function' && problem.latex) {
                    try { mf.setValue(problem.latex, { format: 'latex' }); } catch (e) {}
                } else if (problem.expr) {
                    var lcInput = document.getElementById('lc-input');
                    if (lcInput) {
                        lcInput.value = problem.expr;
                        lcInput.dispatchEvent(new Event('input', { bubbles: true }));
                    }
                }
                // Click the matching mode pill so the solver runs in the right mode.
                if (problem.mode) {
                    var pill = document.querySelector('.lc-mode-btn[data-mode="' + problem.mode + '"]');
                    if (pill) pill.click();
                }
                // Trigger solve once MathLive settles.
                setTimeout(function () {
                    var cta = document.getElementById('lc-solve-btn');
                    if (cta) cta.click();
                }, 350);
            }
        });
    })();
    </script>

    <!-- ─── FAQ accordion ─── -->
    <script>
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
