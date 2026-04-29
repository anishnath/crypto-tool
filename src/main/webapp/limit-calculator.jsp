<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Limit Calculator — third tool migrated to math-studio shell.
        Mirror of integral-calculator.jsp / derivative-calculator.jsp.

        Build contract:
          · SEO params: ported VERBATIM from limit-calculator.jsp
            (29 schema entries incl. 8 FAQ pairs)
          · Math input uses ic-* contract → MathLive Visual/Text via
            math-input-setup.jsp
          · Limit-specific widgets (lc-dir-toggle, lc-point) keep lc-*

        See math/MIGRATION_TEMPLATE.md.
    --%>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Limit Calculator with Steps" />
        <jsp:param name="toolDescription" value="Free limit calculator with step-by-step solutions and 2,000+ practice worksheet problems. Solve one-sided, two-sided, and infinity limits using L'Hopital's rule, factoring, and squeeze theorem. Generate printable limit worksheets with answer keys for exam prep." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="limit-calculator.jsp" />
        <jsp:param name="toolKeywords" value="limit calculator, limit calculator with steps, limit solver, limit calculator online free, calculus limit calculator, l'hopital rule calculator, evaluate limit calculator, one sided limit calculator, two sided limit calculator, limit at infinity calculator, indeterminate form calculator, find limit calculator, limit finder, squeeze theorem calculator, how to find limit of a function, left hand limit calculator, right hand limit calculator, 0/0 limit, limit practice problems, limit worksheet, limit worksheet with answers, calculus limits worksheet, limits practice worksheet pdf, limit problems with solutions, l'hopital's rule practice problems, one sided limit practice, limits exam practice, AP calculus limits worksheet, limit quiz generator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Step-by-step solutions,Direct substitution,L'Hopital's Rule,Factoring and cancellation,One-sided limits (left and right),Two-sided limits,Limits at infinity,Indeterminate form detection (0/0 and infinity/infinity),Numerical approximation table,Squeeze theorem,2000+ practice worksheet problems,Printable worksheet with answer key,11 question types,4 difficulty levels,Live KaTeX math preview,Interactive Plotly graph,Download PDF,Copy LaTeX,Share URL,Python SymPy compiler,Dark mode,Free with no signup" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="College, AP Calculus, University, High School Calculus" />
        <jsp:param name="teaches" value="Calculus, Limits, L'Hopital's Rule, One-sided limits, Limits at infinity, Indeterminate forms, Squeeze theorem, Continuity, Direct substitution" />
        <jsp:param name="faq1q" value="What is a limit in calculus?" />
        <jsp:param name="faq1a" value="A limit describes the value a function f(x) approaches as x gets closer to a specific point. Written as lim(x approaches a) f(x) = L, limits are the foundation of calculus used to define derivatives, integrals, and continuity. For example, lim(x approaches 0) sin(x)/x = 1, even though sin(0)/0 is undefined." />
        <jsp:param name="faq2q" value="How to find the limit of a function step by step?" />
        <jsp:param name="faq2a" value="To find a limit step by step: 1) Try direct substitution by plugging in the value. 2) If you get an indeterminate form like 0/0, try factoring and canceling common factors. 3) If factoring fails, apply L'Hopital's Rule by differentiating the numerator and denominator separately. 4) For limits at infinity, divide by the highest power of x. This calculator automates all these steps." />
        <jsp:param name="faq3q" value="What is L'Hopital's Rule and when do you use it?" />
        <jsp:param name="faq3a" value="L'Hopital's Rule states that for indeterminate forms 0/0 or infinity/infinity, lim f(x)/g(x) = lim f'(x)/g'(x). Use it when direct substitution gives 0/0 or infinity/infinity. Differentiate the numerator and denominator separately (not using the quotient rule), then re-evaluate. You can apply it repeatedly if the result is still indeterminate." />
        <jsp:param name="faq4q" value="What are the seven indeterminate forms?" />
        <jsp:param name="faq4a" value="The seven indeterminate forms are 0/0, infinity/infinity, 0 times infinity, infinity minus infinity, 0^0, 1^infinity, and infinity^0. For 0/0 and infinity/infinity use L'Hopital's Rule or factoring. For 0 times infinity, rewrite as a fraction. For exponential forms (0^0, 1^infinity, infinity^0), take the natural logarithm first, then apply L'Hopital's Rule." />
        <jsp:param name="faq5q" value="How to calculate one-sided limits?" />
        <jsp:param name="faq5a" value="A one-sided limit evaluates a function as x approaches a value from only one direction. The left-hand limit (x approaches a from the left, written a-minus) uses values slightly less than a. The right-hand limit (x approaches a from the right, written a-plus) uses values slightly greater than a. A two-sided limit exists only if both one-sided limits are equal. Use the direction toggle in this calculator to choose left, right, or two-sided." />
        <jsp:param name="faq6q" value="How to evaluate limits at infinity?" />
        <jsp:param name="faq6a" value="To evaluate limits at infinity for rational functions: divide every term by the highest power of x in the denominator. If the degree of the numerator equals the denominator, the limit is the ratio of leading coefficients. If the numerator degree is less, the limit is 0. If greater, the limit is infinity. For exponential functions like e^x, the limit as x approaches infinity is infinity. Type infinity or -infinity as the limit point in this calculator." />
        <jsp:param name="faq7q" value="Does this limit calculator include practice worksheets?" />
        <jsp:param name="faq7a" value="Yes. This calculator includes a built-in worksheet generator with over 2,000 limit practice problems. You can filter by 11 question types (standard limits, one-sided, infinity, L'Hopital's Rule, squeeze theorem, continuity, and more) and 4 difficulty levels (basic, medium, hard, scholar). Each worksheet is randomly generated with a full answer key, perfect for exam prep, self-study, or classroom quizzes." />
        <jsp:param name="faq8q" value="What types of limit problems are in the worksheet?" />
        <jsp:param name="faq8a" value="The worksheet covers 11 limit problem types: standard limits (direct substitution, factoring), one-sided limits with asymptotes, limits at infinity, L'Hopital's Rule problems (basic and advanced), difference quotient limits, exponential indeterminate forms (0^0, 1^infinity), continuity problems, DNE with absolute value, and squeeze theorem problems. Problems range from basic textbook style to scholar-level exam questions." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <!-- Shared site CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=v%>">

    <!-- Math shell + lc-* parallel rules -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <!-- Image-to-math + KaTeX + MathLive -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css?v=<%=v%>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>

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

        <% request.setAttribute("activeService", "limit"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Limit</span>
                </nav>
                <h1>Limit Calculator</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="ic-hero" data-input-mode="visual">

                    <!-- Top row: lc-direction toggle ← → visual/text + scan -->
                    <div class="ic-hero-top">
                        <div class="lc-dir-toggle" role="radiogroup" aria-label="Limit direction">
                            <button type="button" class="lc-dir-btn" data-dir="left"  role="radio" aria-checked="false" title="Left-hand limit (x → a&minus;)">Left</button>
                            <button type="button" class="lc-dir-btn active" data-dir="two-sided" role="radio" aria-checked="true" title="Two-sided limit (default)">Two-sided</button>
                            <button type="button" class="lc-dir-btn" data-dir="right" role="radio" aria-checked="false" title="Right-hand limit (x → a+)">Right</button>
                        </div>
                        <div class="ic-expr-label-actions" style="display:flex;gap:0.5rem;align-items:center;">
                            <div class="ic-input-mode-toggle" id="ic-input-mode-toggle" role="radiogroup" aria-label="Input mode">
                                <button type="button" class="ic-input-mode-btn active" data-input-mode="visual" role="radio" aria-checked="true" title="Write math visually">
                                    <span aria-hidden="true" style="font-family:'Times New Roman',serif;font-style:italic;">&fnof;</span><span class="ic-mode-label"> Visual</span>
                                </button>
                                <button type="button" class="ic-input-mode-btn" data-input-mode="text" role="radio" aria-checked="false" title="Type a plain-text expression">
                                    <span aria-hidden="true" style="font-family:var(--font-mono,monospace);">&lt;/&gt;</span><span class="ic-mode-label"> Text</span>
                                </button>
                            </div>
                            <button type="button" class="ic-image-btn" id="lc-image-btn" title="Scan limit problems from image">&#128247; Scan</button>
                        </div>
                    </div>

                    <!-- Function input (visual + text). ic-* IDs match the
                         math-input contract so math-input-setup.jsp wires it. -->
                    <div class="ic-expr-wrap" id="ic-expr-wrap">
                        <math-field id="ic-mathfield" class="ic-mathfield" aria-label="Function whose limit to take"
                                    placeholder="\frac{\sin(x)}{x}"
                                    smart-mode="on" smart-fence="on" smart-superscript="on"
                                    remove-extraneous-parentheses="on" math-mode-space="\:"></math-field>

                        <input type="text" class="tool-input tool-input-mono" id="ic-expr"
                               placeholder="e.g.  sin(x)/x   or   (x^2-1)/(x-1)"
                               autocomplete="off" spellcheck="false" aria-label="Function whose limit to take">

                        <span class="tool-form-hint ic-expr-hint">
                            <span class="ic-hint-visual">Use <code>infinity</code> for &infin; and <code>-infinity</code> for &minus;&infin;.</span>
                            <span class="ic-hint-text">Both <code>sin3x</code> and <code>sin(3*x)</code> work; <code>oo</code> is also accepted as &infin;.</span>
                        </span>
                    </div>

                    <!-- Live preview strip (hidden in visual mode via CSS) -->
                    <div class="ic-preview-strip">
                        <span class="ic-preview-label">Preview</span>
                        <span class="ic-preview" id="lc-preview">type a function above&hellip;</span>
                    </div>

                    <!-- Params: variable + limit point (the point is REQUIRED) -->
                    <div class="ic-hero-params visible">
                        <div class="tool-form-group">
                            <label for="lc-var">Variable</label>
                            <select class="tool-select" id="lc-var">
                                <option value="x" selected>x</option>
                                <option value="y">y</option>
                                <option value="z">z</option>
                                <option value="t">t</option>
                                <option value="u">u</option>
                                <option value="theta">&theta;</option>
                            </select>
                        </div>
                        <div class="tool-form-group" style="grid-column: span 2;">
                            <label for="lc-point">Approaches</label>
                            <input type="text" class="tool-input tool-input-mono" id="lc-point"
                                   placeholder="e.g.  0,  1,  pi,  infinity,  -infinity">
                        </div>
                    </div>

                    <!-- Primary CTA -->
                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta is-disabled" id="lc-calculate-btn" aria-disabled="true">Calculate Limit</button>
                        <span class="ic-hero-warn" id="lc-calculate-warn" role="alert" aria-live="polite"></span>
                    </div>

                    <!-- Examples by method — collapsed -->
                    <details class="ic-hero-methods" id="lc-examples">
                        <summary class="ic-hero-methods-summary">
                            <span>Examples by method</span>
                            <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </summary>
                        <div class="ic-hero-methods-body">
                            <div class="ic-method-row">
                                <span class="ic-method-label">Direct sub</span>
                                <button type="button" class="ic-example-chip" data-expr="x^2 + 3*x" data-point="2">x²+3x at 2</button>
                                <button type="button" class="ic-example-chip" data-expr="cos(x)" data-point="0">cos(x) at 0</button>
                                <button type="button" class="ic-example-chip" data-expr="sqrt(x+4)" data-point="5">√(x+4) at 5</button>
                            </div>
                            <div class="ic-method-row">
                                <span class="ic-method-label">L'H&ocirc;pital</span>
                                <button type="button" class="ic-example-chip" data-expr="sin(x)/x" data-point="0">sin(x)/x at 0</button>
                                <button type="button" class="ic-example-chip" data-expr="(1-cos(x))/x^2" data-point="0">(1−cos x)/x² at 0</button>
                                <button type="button" class="ic-example-chip" data-expr="e^x/x^2" data-point="infinity">eˣ/x² at &infin;</button>
                            </div>
                            <div class="ic-method-row">
                                <span class="ic-method-label">Factoring</span>
                                <button type="button" class="ic-example-chip" data-expr="(x^2-1)/(x-1)" data-point="1">(x²−1)/(x−1) at 1</button>
                                <button type="button" class="ic-example-chip" data-expr="(x^3-8)/(x-2)" data-point="2">(x³−8)/(x−2) at 2</button>
                            </div>
                            <div class="ic-method-row">
                                <span class="ic-method-label">At infinity</span>
                                <button type="button" class="ic-example-chip" data-expr="(2*x^2 + 3)/(x^2 - 1)" data-point="infinity">rational at &infin;</button>
                                <button type="button" class="ic-example-chip" data-expr="x/sqrt(x^2+1)" data-point="infinity">x/√(x²+1) at &infin;</button>
                                <button type="button" class="ic-example-chip" data-expr="(1 + 1/x)^x" data-point="infinity">(1+1/x)ˣ at &infin;</button>
                            </div>
                            <div class="ic-method-row">
                                <span class="ic-method-label">One-sided</span>
                                <button type="button" class="ic-example-chip" data-expr="abs(x)/x" data-point="0" data-dir="left">|x|/x from left</button>
                                <button type="button" class="ic-example-chip" data-expr="1/x" data-point="0" data-dir="right">1/x from right</button>
                            </div>
                        </div>
                    </details>

                    <!-- Collapsible syntax help -->
                    <div class="ic-hero-syntax" id="lc-syntax-wrap">
                        <button type="button" class="ic-syntax-toggle" id="lc-syntax-btn">
                            Syntax help
                            <svg class="ic-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </button>
                        <div class="ic-syntax-content" id="lc-syntax-content">
                            <strong>Functions:</strong> <code>sin</code>, <code>cos</code>, <code>tan</code>, <code>ln</code> (or <code>log</code>), <code>sqrt</code>, <code>e^x</code>, <code>abs(x)</code>.<br>
                            <strong>Special points:</strong> <code>infinity</code> (or <code>oo</code>) for &infin;; <code>-infinity</code> for &minus;&infin;; <code>pi</code>, <code>e</code> as constants.<br>
                            <strong>One-sided:</strong> use the <strong>Left</strong>/<strong>Right</strong> toggle above; default is two-sided.<br>
                            <strong>Operators:</strong> <code>*</code> for multiplication, <code>/</code> for division, <code>^</code> for powers.
                        </div>
                    </div>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs" role="tablist">
                        <button type="button" class="ic-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                        <button type="button" class="ic-output-tab" data-panel="graph" role="tab" aria-selected="false">Graph</button>
                        <button type="button" class="ic-output-tab" data-panel="python" role="tab" aria-selected="false">Python Compiler</button>
                    </div>

                    <div class="ic-panel active" id="lc-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="lc-result-content">
                                <div class="tool-empty-state ic-empty-state" id="lc-empty-state">
                                    <div class="ic-empty-illustration">lim</div>
                                    <h3>Ready when you are</h3>
                                    <p>Type a function, set the point it approaches, and hit <strong>Calculate Limit</strong>.</p>
                                </div>
                            </div>

                            <div class="tool-result-actions" id="lc-result-actions">
                                <button type="button" class="tool-action-btn" id="lc-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="lc-copy-text-btn">Copy Text</button>
                                <button type="button" class="tool-action-btn" id="lc-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="lc-download-pdf-btn">Download PDF</button>
                                <button type="button" class="tool-action-btn" id="lc-toolbar-worksheet-btn" title="Print Worksheet">Worksheet</button>
                            </div>

                            <div class="ic-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="lc-worksheet-btn">
                                    Practice Limit Worksheet — 2,000+ problems
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel" id="lc-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:360px;">
                                <div id="lc-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                                <p id="lc-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Calculate a limit to see its graph.</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel" id="lc-panel-python" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="display:flex;align-items:center;gap:0.5rem;padding:0.6rem 0.25rem;">
                                <span style="font-size:0.78rem;color:var(--ms-muted);font-weight:600;">Template:</span>
                                <select id="lc-compiler-template" style="padding:0.35rem 0.6rem;border:1px solid var(--ms-panel-border);border-radius:6px;font-size:0.8rem;background:var(--ms-panel-bg);color:var(--ms-ink);">
                                    <option value="symbolic">Symbolic (SymPy)</option>
                                    <option value="numerical">Numerical</option>
                                </select>
                            </div>
                            <div style="flex:1;min-height:0;">
                                <iframe id="lc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- In-content ad (mobile/tablet) -->
            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- Methods reference band (lighter treatment) -->
            <section class="ic-learn" aria-label="Limit techniques">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Direct substitution</span>
                    <code class="ic-learn-formula">lim<sub>x&rarr;a</sub> f(x) = f(a)  &nbsp;(if continuous)</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">L'H&ocirc;pital</span>
                    <code class="ic-learn-formula">lim f(x)/g(x) = lim f&prime;(x)/g&prime;(x)</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Squeeze</span>
                    <code class="ic-learn-formula">if g &le; f &le; h and lim g = lim h = L &rArr; lim f = L</code>
                </article>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- Visible FAQ — keep in sync with faqNq/faqNa jsp:params above. -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Limit calculator FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is a limit in calculus?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">A <strong>limit</strong> describes the value a function <em>f(x)</em> approaches as <em>x</em> gets closer to a specific point. Written as <em>lim<sub>x&rarr;a</sub> f(x) = L</em>, limits are the foundation of calculus &mdash; used to define derivatives, integrals, and continuity. For example, <em>lim<sub>x&rarr;0</sub> sin(x)/x = 1</em>, even though <em>sin(0)/0</em> is undefined.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How to find the limit of a function step by step?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">(1) Try direct substitution &mdash; plug in the value. (2) If you get an indeterminate form like <em>0/0</em>, factor and cancel common factors. (3) If factoring fails, apply <strong>L'H&ocirc;pital's Rule</strong> by differentiating numerator and denominator separately. (4) For limits at infinity, divide by the highest power of <em>x</em>. This calculator automates all four.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is L'H&ocirc;pital's Rule and when do you use it?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">L'H&ocirc;pital's Rule states that for indeterminate forms <em>0/0</em> or <em>&infin;/&infin;</em>: <em>lim f(x)/g(x) = lim f&prime;(x)/g&prime;(x)</em>. Use it when direct substitution gives <em>0/0</em> or <em>&infin;/&infin;</em>. Differentiate numerator and denominator separately (NOT via the quotient rule), then re-evaluate. Apply repeatedly if the result is still indeterminate.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What are the seven indeterminate forms?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The seven indeterminate forms are <em>0/0</em>, <em>&infin;/&infin;</em>, <em>0&middot;&infin;</em>, <em>&infin;&minus;&infin;</em>, <em>0<sup>0</sup></em>, <em>1<sup>&infin;</sup></em>, and <em>&infin;<sup>0</sup></em>. For <em>0/0</em> and <em>&infin;/&infin;</em> use L'H&ocirc;pital or factoring. For <em>0&middot;&infin;</em> rewrite as a fraction. For exponential forms (<em>0<sup>0</sup></em>, <em>1<sup>&infin;</sup></em>, <em>&infin;<sup>0</sup></em>) take the natural log first, then apply L'H&ocirc;pital.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How to calculate one-sided limits?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">A <strong>one-sided limit</strong> evaluates a function as <em>x</em> approaches a value from only one direction. The <strong>left-hand</strong> limit (<em>x&rarr;a&minus;</em>) uses values slightly less than <em>a</em>; the <strong>right-hand</strong> limit (<em>x&rarr;a+</em>) uses values slightly greater. A two-sided limit exists only if both one-sided limits agree. Use the <strong>Left / Two-sided / Right</strong> toggle in this calculator to choose.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How to evaluate limits at infinity?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">For rational functions: divide every term by the highest power of <em>x</em> in the denominator. If degrees are equal, the limit is the ratio of leading coefficients. If numerator degree is less, the limit is <em>0</em>. If greater, the limit is <em>&plusmn;&infin;</em>. For exponentials like <em>e<sup>x</sup></em>, the limit as <em>x &rarr; &infin;</em> is <em>&infin;</em>. Type <code>infinity</code> or <code>-infinity</code> in the Approaches field.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Does this limit calculator include practice worksheets?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes &mdash; over <strong>2,000 limit practice problems</strong> with full answer keys. Filter by 11 question types (standard limits, one-sided, infinity, L'H&ocirc;pital, squeeze, continuity, &hellip;) and 4 difficulty levels (basic, medium, hard, scholar). Each worksheet is randomly generated &mdash; perfect for exam prep, self-study, or classroom quizzes.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What types of limit problems are in the worksheet?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">11 question types: standard limits (direct sub, factoring), one-sided with asymptotes, limits at infinity, L'H&ocirc;pital (basic and advanced), difference-quotient limits, exponential indeterminate forms (<em>0<sup>0</sup></em>, <em>1<sup>&infin;</sup></em>), continuity problems, DNE with absolute value, and squeeze theorem. Range: textbook-style up to scholar-level exam questions.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <%--
        Canonical 3-partial load order:
          1. math-libs                  — CDN deps, shared libs
          2. limit-calculator-scripts   — tool-specific (integral-core dep, limit-core, limit.js, image-scan)
          3. math-input-setup           — MathLive + mode toggle (reads DOM)
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />
    <jsp:include page="/math/partials/limit-calculator-scripts.jsp" />
    <jsp:include page="/math/partials/math-input-setup.jsp" />

    <!-- UX layer: empty-input validation (BOTH expr AND point required for limits),
         auto-scroll, busy lock, disabled-until-ready.  Same pattern as integral
         and derivative; only the empty-check differs. -->
    <script>
    (function () {
        if (/[?&]lc_debug=1/.test(window.location.search)) window.__LC_DEBUG = true;
        if (window.__LC_DEBUG) console.log('[lc-debug] IIFE starting');

        var btn = document.getElementById('lc-calculate-btn');
        var scrollTarget = document.getElementById('lc-panel-result');
        var resultContent = document.getElementById('lc-result-content');
        if (!btn || !scrollTarget || !resultContent) return;

        var safetyTimer = null;
        var resultObserver = null;

        function unlock() {
            btn.classList.remove('is-busy');
            if (safetyTimer) { clearTimeout(safetyTimer); safetyTimer = null; }
            if (resultObserver) { resultObserver.disconnect(); resultObserver = null; }
        }
        function lock() {
            if (btn.classList.contains('is-busy')) return false;
            btn.classList.add('is-busy');
            if ('MutationObserver' in window) {
                resultObserver = new MutationObserver(function () { unlock(); });
                resultObserver.observe(resultContent, { childList: true, subtree: true, characterData: true });
            }
            safetyTimer = setTimeout(unlock, 30000);
            return true;
        }

        var exprInput  = document.getElementById('ic-expr');
        var mathField  = document.getElementById('ic-mathfield');
        var pointInput = document.getElementById('lc-point');
        var warnEl     = document.getElementById('lc-calculate-warn');

        function currentExpression() { return exprInput ? (exprInput.value || '').trim() : ''; }
        function currentPoint()      { return pointInput ? (pointInput.value || '').trim() : ''; }

        function showWarn(msg) {
            if (!warnEl) return;
            warnEl.textContent = msg;
            warnEl.classList.remove('show');
            void warnEl.offsetWidth;
            warnEl.classList.add('show');
        }
        function clearWarn() { if (warnEl) { warnEl.classList.remove('show'); warnEl.textContent = ''; } }

        function updateEnableState() {
            // Limits need BOTH a function AND an approach point.
            var ready = !!currentExpression() && !!currentPoint();
            btn.classList.toggle('is-disabled', !ready);
            btn.setAttribute('aria-disabled', ready ? 'false' : 'true');
        }
        function onInput() { clearWarn(); updateEnableState(); }
        if (exprInput)  exprInput.addEventListener('input', onInput);
        if (mathField)  mathField.addEventListener('input', onInput);
        if (pointInput) pointInput.addEventListener('input', onInput);

        // Chip click populates expr (and may set point + dir via data-*).
        document.addEventListener('click', function (e) {
            if (!e.target || !e.target.closest) return;
            var chip = e.target.closest('.ic-example-chip');
            if (chip) {
                // The shared script already wires data-expr → exprInput.
                // We additionally honour data-point and data-dir if present.
                var pt = chip.getAttribute('data-point');
                if (pt && pointInput) pointInput.value = pt;
                var dir = chip.getAttribute('data-dir');
                if (dir) {
                    // Click the matching dir button (rather than just toggling
                    // .active) so limit-calculator.js's own listener fires and
                    // updates the IIFE-private `currentDir` — otherwise the
                    // visual selection drifts out of sync with the value used
                    // by computeLimit().
                    var dirBtn = document.querySelector('.lc-dir-btn[data-dir="' + dir + '"]');
                    if (dirBtn) dirBtn.click();
                }
                setTimeout(updateEnableState, 30);
            }
        }, true);

        document.querySelectorAll('.lc-dir-btn, .ic-input-mode-btn').forEach(function (b) {
            b.addEventListener('click', function () { setTimeout(updateEnableState, 40); });
        });
        updateEnableState();

        document.addEventListener('click', function (e) {
            var target = e.target && e.target.closest ? e.target.closest('#lc-calculate-btn') : null;
            if (!target) return;
            if (btn.classList.contains('is-busy')) { e.preventDefault(); e.stopImmediatePropagation(); return; }

            if (!currentExpression()) {
                e.preventDefault(); e.stopImmediatePropagation();
                showWarn('Enter a function first.');
                var fEl = mathField && mathField.offsetParent !== null ? mathField : exprInput;
                if (fEl && typeof fEl.focus === 'function') fEl.focus();
                return;
            }
            if (!currentPoint()) {
                e.preventDefault(); e.stopImmediatePropagation();
                showWarn('Set the point the variable approaches (e.g. 0, infinity).');
                if (pointInput && typeof pointInput.focus === 'function') pointInput.focus();
                return;
            }
            clearWarn();
            lock();
            if (scrollTarget.scrollIntoView) {
                setTimeout(function () { scrollTarget.scrollIntoView({ behavior: 'smooth', block: 'start' }); }, 140);
            }
        }, true);
    })();

    // FAQ accordion
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
