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
        Quadratic Solver — migrated to math-studio shell.
        Mirror of limit-calculator.jsp. The 5 legacy form-types (Standard /
        Vertex / Factored / Inequality / Horizontal) are GONE as visible
        UI — a single MathLive equation input replaces them. The same
        forms are now reachable via Examples chips. Parsing happens in
        modern/js/quadratic-solver-input-bridge.js, which feeds the
        unmodified quadratic-solver-{render,graph,export,core}.js via
        hidden legacy inputs.

        SEO params: PORTED VERBATIM from the original (29 schema entries
        including 8 FAQ pairs + howToSteps + educationalLevel + teaches).

        See math/MIGRATION_TEMPLATE.md.
    --%>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Quadratic Formula Calculator — AI Scan &amp; Worksheet" />
        <jsp:param name="toolDescription" value="Free quadratic formula calculator with AI photo scan + 1,500 practice problems. Solve ax²+bx+c=0 with full steps, graph, factoring, and inequalities." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="quadratic-solver.jsp" />
        <jsp:param name="toolKeywords" value="quadratic formula calculator, quadratic equation solver, quadratic equation worksheet, quadratic formula worksheet printable, algebra 2 quadratic worksheet, solve quadratic equation step by step, quadratic practice problems with answers, completing the square calculator, factoring quadratics calculator, vertex form calculator, discriminant calculator, parabola graph calculator, ai quadratic solver, photo math solver, scan quadratic equation from photo, ai math homework helper, quadratic photo solver, math problem photo scanner, quadratic equation photo solver, quadratic worksheet pdf, quadratic worksheet for class 9, quadratic worksheet for class 10, printable quadratic worksheet" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="AI photo scanner extracts quadratics from images,1500+ CAS-verified practice problems with answer key,26 question types from basic to scholar level,NCERT Class 10 Ch 4 word problems (age, speed, geometry),JEE Advanced parameter and transformed-roots problems,Quadratic formula with full substitution steps,Completing the square method,Factoring method,5 input forms including vertex factored and horizontal parabola,Quadratic inequality solver with interval notation,Interactive Plotly parabola graph,Discriminant and root classification,LaTeX export and PDF download,Shareable URLs,Photo math problem solver,Auto-detect quadratic form from image,Free with no signup or limits" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="High School, College" />
        <jsp:param name="teaches" value="quadratic equations, quadratic formula, discriminant, parabola, vertex form, completing the square, factoring" />
        <jsp:param name="howToSteps" value="Type the equation|Use the math field to type any quadratic equation or inequality|Pick a method|Choose Quadratic Formula Completing the Square Factoring or All|Click Solve|See discriminant roots vertex and step-by-step derivation|Download PDF|Export the full solution with one click" />
        <jsp:param name="faq1q" value="What is the quadratic formula and how do you use it?" />
        <jsp:param name="faq1a" value="The quadratic formula is x = (-b ± √(b² - 4ac)) / 2a. It solves any quadratic equation ax² + bx + c = 0. Type the equation into the math field, then click Solve to see every substitution step, discriminant, and roots. Handles real, repeated, and complex roots." />
        <jsp:param name="faq2q" value="How do you find the discriminant of a quadratic equation?" />
        <jsp:param name="faq2a" value="The discriminant Δ = b² - 4ac is under the square root in the quadratic formula. Δ > 0: two real roots. Δ = 0: one repeated root. Δ < 0: complex conjugate roots. This calculator computes it automatically and classifies the roots." />
        <jsp:param name="faq3q" value="How do you solve a quadratic equation by completing the square?" />
        <jsp:param name="faq3a" value="Completing the square rewrites ax² + bx + c = 0 as a(x - h)² + k = 0. Steps: divide by a, add (b/2a)² to both sides, factor as a perfect square, then take the square root. This calculator shows every step with formatted math." />
        <jsp:param name="faq4q" value="How do you solve quadratic inequalities with interval notation?" />
        <jsp:param name="faq4a" value="Type the inequality directly — e.g. x² - 5x + 6 < 0 — and the solver finds roots, uses a sign chart, and writes the answer in interval notation. Example: x² - 5x + 6 < 0 gives x ∈ (2, 3)." />
        <jsp:param name="faq5q" value="Is this quadratic formula calculator really free?" />
        <jsp:param name="faq5a" value="Yes, 100% free with no signup. You get 3 methods (formula, completing the square, factoring), interactive parabola graph, inequality solving, LaTeX export, PDF download, and shareable URLs. All computation runs in your browser." />
        <jsp:param name="faq6q" value="How do I solve using the quadratic formula?" />
        <jsp:param name="faq6a" value="Type your equation as ax² + bx + c = 0 in the math field. Click Solve. You'll see the discriminant, then x = (-b ± √Δ) / 2a with every substitution step shown. Works for fractions and decimals." />
        <jsp:param name="faq7q" value="Can this calculator solve horizontal parabolas (x = ay² + by + c)?" />
        <jsp:param name="faq7a" value="Yes. Type the equation as x = y² - 4y + 2 (using y on the right). The solver finds the vertex, focus, directrix, and axis of symmetry. You get a step-by-step derivation and interactive graph of the horizontal parabola." />
        <jsp:param name="faq8q" value="Where can I get a free quadratic equation worksheet with answers?" />
        <jsp:param name="faq8a" value="Click the Practice Worksheet — 1,500+ quadratics with answer key button below the result. The worksheet engine opens a printable problem set across 4 difficulty tiers (basic, medium, hard, scholar) and 26 question types — factoring, quadratic formula, completing the square, discriminant, Vieta's identities, vertex form, NCERT Class 10 word problems (age, speed, rectangle, consecutive integers), parameter problems (real/equal/opposite-sign roots, common root), transformed roots, biquadratic, and JEE Advanced classics. Every problem and answer is CAS-verified." />
        <jsp:param name="faq9q" value="Can I scan a quadratic equation from a photo or textbook?" />
        <jsp:param name="faq9a" value="Yes. Click the Scan button and upload (or drop in) a photo of a handwritten or printed quadratic equation. The AI vision model extracts the equation, fills the math field automatically, and detects the form (standard, vertex, factored, or inequality). Works on phone snapshots, textbook pages, whiteboard photos, and worksheet scans." />
        <jsp:param name="faq10q" value="What grade levels and curricula does this cover?" />
        <jsp:param name="faq10a" value="Covers Algebra 1 (factoring, basic quadratic formula), Algebra 2 (discriminant, complex roots, vertex form), Precalculus (parabola conic-section properties, horizontal parabolas), and college algebra. Aligned with Common Core HSA-REI.B.4 and CBSE/ICSE class 9-10 quadratic equations chapter. SAT, ACT, and JEE Mains practice covered." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <!-- Shared site CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">

    <!-- Math shell + qs-* legacy rules (kept for hidden form/coeff inputs and result KaTeX) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/quadratic-solver.css">

    <!-- Image-to-math + KaTeX + MathLive -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>

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

        <% request.setAttribute("activeService", "quadratic"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Quadratic</span>
                </nav>
                <h1>Quadratic Formula Calculator</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="ic-hero" data-input-mode="visual">

                    <!-- Top row: Visual/Text + Scan -->
                    <div class="ic-hero-top">
                        <div class="ic-expr-label-actions" style="display:flex;gap:0.5rem;align-items:center;margin-left:auto;">
                            <div class="ic-input-mode-toggle" id="ic-input-mode-toggle" role="radiogroup" aria-label="Input mode">
                                <button type="button" class="ic-input-mode-btn active" data-input-mode="visual" role="radio" aria-checked="true" title="Write math visually">
                                    <span aria-hidden="true" style="font-family:'Times New Roman',serif;font-style:italic;">&fnof;</span><span class="ic-mode-label"> Visual</span>
                                </button>
                                <button type="button" class="ic-input-mode-btn" data-input-mode="text" role="radio" aria-checked="false" title="Type a plain-text equation">
                                    <span aria-hidden="true" style="font-family:var(--font-mono,monospace);">&lt;/&gt;</span><span class="ic-mode-label"> Text</span>
                                </button>
                            </div>
                            <button type="button" class="ic-image-btn" id="qs-image-btn" title="Scan a quadratic equation from an image">&#128247; Scan</button>
                            <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — solve in chat (Ctrl+Shift+A)">&#10024; AI</button>
                        </div>
                    </div>

                    <!-- Equation input — math-input-setup.jsp wires both surfaces -->
                    <div class="ic-expr-wrap" id="ic-expr-wrap">
                        <math-field id="ic-mathfield" class="ic-mathfield" aria-label="Quadratic equation"
                                    placeholder="x^2 + 5x + 6 = 0"
                                    smart-mode="on" smart-fence="on" smart-superscript="on"
                                    remove-extraneous-parentheses="on" math-mode-space="\:"></math-field>

                        <input type="text" class="tool-input tool-input-mono" id="ic-expr"
                               placeholder="e.g.  x^2 + 5x + 6 = 0   or   (x-2)(x+3) = 0"
                               autocomplete="off" spellcheck="false" aria-label="Quadratic equation">

                        <span class="tool-form-hint ic-expr-hint">
                            <span class="ic-hint-visual">Type the full equation with <code>=</code>. For inequalities use <code>&lt;</code> <code>&gt;</code> <code>&lt;=</code> <code>&gt;=</code>. For horizontal parabolas use <code>x = ay&sup2; + by + c</code>.</span>
                            <span class="ic-hint-text"><code>x^2 + 5x + 6 = 0</code> · <code>(x-2)(x+3) = 0</code> · <code>2(x-3)^2 - 8 = 0</code> · <code>x^2 - 5x + 6 &lt; 0</code></span>
                        </span>
                    </div>

                    <!-- Method selector + Primary CTA -->
                    <div class="ic-hero-params visible">
                        <div class="tool-form-group" style="grid-column: span 3;">
                            <label for="qs-method">Solution Method</label>
                            <select class="tool-select" id="qs-method">
                                <option value="all">Show All Methods</option>
                                <option value="formula">Quadratic Formula</option>
                                <option value="completing">Completing the Square</option>
                                <option value="factoring">Factoring</option>
                            </select>
                        </div>
                    </div>

                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta is-disabled" id="qs-calculate-btn" aria-disabled="true">Solve Equation</button>
                        <span class="ic-hero-warn" id="qs-calculate-warn" role="alert" aria-live="polite"></span>
                    </div>

                    <!-- Syntax help -->
                    <div class="ic-hero-syntax" id="qs-syntax-wrap">
                        <button type="button" class="ic-syntax-toggle" id="qs-syntax-btn">
                            Syntax help
                            <svg class="ic-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </button>
                        <div class="ic-syntax-content" id="qs-syntax-content">
                            <strong>Standard:</strong> <code>ax^2 + bx + c = 0</code> &mdash; e.g. <code>2x^2 - 5x + 3 = 0</code>.<br>
                            <strong>Factored:</strong> just type the factored form &mdash; <code>(x - 2)(x + 3) = 0</code>.<br>
                            <strong>Vertex:</strong> <code>a(x - h)^2 + k = 0</code> &mdash; e.g. <code>2(x - 3)^2 - 8 = 0</code>.<br>
                            <strong>Inequality:</strong> use <code>&lt;</code> <code>&gt;</code> <code>&lt;=</code> <code>&gt;=</code> instead of <code>=</code>.<br>
                            <strong>Horizontal parabola:</strong> <code>x = ay^2 + by + c</code> with <em>y</em> on the right.<br>
                            <strong>Operators:</strong> <code>*</code> for multiplication, <code>/</code> for division, <code>^</code> for powers (or <code>x²</code> visually).
                        </div>
                    </div>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs" role="tablist">
                        <button type="button" class="ic-output-tab qs-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                        <button type="button" class="ic-output-tab qs-output-tab" data-panel="graph" role="tab" aria-selected="false">Graph</button>
                    </div>

                    <div class="ic-panel qs-panel active" id="qs-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="qs-result-content">
                                <div class="tool-empty-state ic-empty-state" id="qs-empty-state">
                                    <div class="ic-empty-illustration">ax&sup2;+bx+c</div>
                                    <h3>Try an example</h3>
                                    <div class="qs-empty-chips">
                                        <span class="qs-chip-label">Standard</span>
                                        <button type="button" class="ic-example-chip" data-equation="x^2 + 5x + 6 = 0">x&sup2; + 5x + 6 = 0</button>

                                        <span class="qs-chip-label">Factored</span>
                                        <button type="button" class="ic-example-chip" data-equation="(x - 2)(x + 3) = 0">(x &minus; 2)(x + 3) = 0</button>

                                        <span class="qs-chip-label">Vertex</span>
                                        <button type="button" class="ic-example-chip" data-equation="2(x - 3)^2 - 8 = 0">2(x &minus; 3)&sup2; &minus; 8 = 0</button>

                                        <span class="qs-chip-label">Inequality</span>
                                        <button type="button" class="ic-example-chip" data-equation="x^2 - 5x + 6 < 0">x&sup2; &minus; 5x + 6 &lt; 0</button>

                                        <span class="qs-chip-label">Horizontal</span>
                                        <button type="button" class="ic-example-chip" data-equation="x = y^2 - 4y + 2">x = y&sup2; &minus; 4y + 2</button>
                                    </div>
                                    <p class="qs-empty-hint">or type your own equation above</p>
                                </div>
                            </div>
                            <div id="qs-steps-area" style="margin-top:1rem"></div>

                            <div class="tool-result-actions" id="qs-result-actions" style="display:none;">
                                <button type="button" class="tool-action-btn" id="qs-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="qs-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="qs-download-pdf-btn">Download PDF</button>
                            </div>

                            <!-- Practice worksheet CTA — opens the WorksheetEngine
                                 modal with the SymPy-verified 1500-problem bank
                                 (quadratic.json). The legacy qs-print-worksheet-btn
                                 id is retained on a hidden span only so the legacy
                                 quadratic-solver-core.js lookup doesn't throw. -->
                            <span id="qs-print-worksheet-btn" style="display:none;"></span>
                            <div class="ic-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="qs-worksheet-btn">
                                    Practice Worksheet &mdash; 1,500+ quadratics with answer key
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel qs-panel" id="qs-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:360px;padding:0.75rem;">
                                <div id="qs-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                                <p id="qs-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Solve an equation to see the parabola with vertex, roots, and axis of symmetry.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- In-content ad (mobile/tablet) -->
            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- Methods reference band -->
            <section class="ic-learn" aria-label="Quadratic solution methods">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Quadratic formula</span>
                    <code class="ic-learn-formula">x = (&minus;b &plusmn; &radic;(b&sup2;&minus;4ac)) / 2a</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Discriminant</span>
                    <code class="ic-learn-formula">&Delta; = b&sup2; &minus; 4ac &nbsp;(roots: &Delta;&gt;0 real, =0 repeated, &lt;0 complex)</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Vertex</span>
                    <code class="ic-learn-formula">x = &minus;b/2a, &nbsp; y = c &minus; b&sup2;/4a</code>
                </article>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- ═══ HIDDEN LEGACY STATE (read by quadratic-solver-core.js) ═══
         The bridge writes parsed coefficients here, then "clicks" the
         hidden #qs-solve-btn to invoke the unmodified core flow. None
         of these elements are user-visible. -->
    <div aria-hidden="true" style="display:none">
        <!-- Form-type buttons — the bridge .click()s the matching one
             so the core's switchFormType() runs. -->
        <div class="qs-form-toggle">
            <button type="button" class="qs-form-btn active" data-type="standard">Standard</button>
            <button type="button" class="qs-form-btn" data-type="vertex">Vertex</button>
            <button type="button" class="qs-form-btn" data-type="factored">Factored</button>
            <button type="button" class="qs-form-btn" data-type="inequality">Inequality</button>
            <button type="button" class="qs-form-btn" data-type="horizontal">Horizontal</button>
        </div>
        <div id="qs-form-hint"></div>
        <div id="qs-form-standard">
            <input type="number" id="qs-coeff-a" value="1" step="any">
            <input type="number" id="qs-coeff-b" value="0" step="any">
            <input type="number" id="qs-coeff-c" value="0" step="any">
        </div>
        <div id="qs-form-vertex">
            <input type="number" id="qs-vertex-a" value="1" step="any">
            <input type="number" id="qs-vertex-h" value="0" step="any">
            <input type="number" id="qs-vertex-k" value="0" step="any">
        </div>
        <div id="qs-form-factored">
            <input type="number" id="qs-factor-a" value="1" step="any">
            <input type="number" id="qs-factor-r1" value="0" step="any">
            <input type="number" id="qs-factor-r2" value="0" step="any">
        </div>
        <div id="qs-form-inequality">
            <input type="number" id="qs-ineq-a" value="1" step="any">
            <input type="number" id="qs-ineq-b" value="0" step="any">
            <input type="number" id="qs-ineq-c" value="0" step="any">
            <select id="qs-ineq-op"><option value=">">&gt;</option><option value="<">&lt;</option><option value=">=">&ge;</option><option value="<=">&le;</option></select>
        </div>
        <div id="qs-form-horizontal">
            <input type="number" id="qs-horiz-a" value="1" step="any">
            <input type="number" id="qs-horiz-b" value="0" step="any">
            <input type="number" id="qs-horiz-c" value="0" step="any">
        </div>
        <div id="qs-preview"></div>
        <div id="qs-method-group"></div>
        <button type="button" id="qs-solve-btn">Solve (legacy)</button>
        <button type="button" id="qs-clear-btn">Clear (legacy)</button>
    </div>

    <!-- Visible FAQ — keep in sync with faqNq/faqNa jsp:params above. -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Quadratic calculator FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the quadratic formula and how do you use it?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The <strong>quadratic formula</strong> is <em>x = (&minus;b &plusmn; &radic;(b&sup2; &minus; 4ac)) / 2a</em>. It solves any quadratic equation <em>ax&sup2; + bx + c = 0</em>. Type the equation into the math field, then click <strong>Solve</strong> to see every substitution step, the discriminant, and the roots. Handles real, repeated, and complex roots.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you find the discriminant of a quadratic equation?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The <strong>discriminant</strong> &Delta; = <em>b&sup2; &minus; 4ac</em> is the expression under the square root in the quadratic formula. <em>&Delta; &gt; 0</em>: two real roots. <em>&Delta; = 0</em>: one repeated root. <em>&Delta; &lt; 0</em>: complex conjugate roots. This calculator computes it automatically and classifies the roots.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you solve a quadratic equation by completing the square?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a"><strong>Completing the square</strong> rewrites <em>ax&sup2; + bx + c = 0</em> as <em>a(x &minus; h)&sup2; + k = 0</em>. Steps: divide by <em>a</em>, add <em>(b/2a)&sup2;</em> to both sides, factor as a perfect square, then take the square root. Pick <strong>Completing the Square</strong> from the method dropdown to see every step.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you solve quadratic inequalities with interval notation?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Type the inequality directly &mdash; e.g. <code>x^2 - 5x + 6 &lt; 0</code> &mdash; and click <strong>Solve</strong>. The solver finds roots, uses a sign chart, and writes the answer in interval notation. Example: <em>x&sup2; &minus; 5x + 6 &lt; 0</em> gives <em>x &isin; (2, 3)</em>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Is this quadratic formula calculator really free?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes &mdash; 100% free with no signup. You get 3 solving methods, an interactive Plotly parabola graph, inequality solving with interval notation, LaTeX export, PDF download, image scanning, and shareable URLs. All computation runs in your browser.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do I solve using the quadratic formula?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Type your equation as <em>ax&sup2; + bx + c = 0</em> in the math field &mdash; the calculator extracts <em>a</em>, <em>b</em>, <em>c</em> automatically. Click <strong>Solve</strong>. You'll see the discriminant, then <em>x = (&minus;b &plusmn; &radic;&Delta;) / 2a</em> with every substitution step. Works for fractions and decimals.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can this calculator solve horizontal parabolas (x = ay&sup2; + by + c)?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Type the equation as <code>x = y^2 - 4y + 2</code> with <em>y</em> on the right. The solver finds the vertex, focus, directrix, and axis of symmetry. You get a step-by-step derivation and an interactive graph of the horizontal parabola.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Where can I get a free quadratic equation worksheet with answers?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Click the <strong>Practice Worksheet &mdash; 1,500+ quadratics with answer key</strong> button below the result. The worksheet engine generates printable problem sets across 4 difficulty tiers (basic, medium, hard, scholar) and <strong>26 question types</strong> &mdash; factoring, quadratic formula, completing the square, discriminant, Vieta's identities, vertex form, NCERT Class 10 word problems (age, speed, rectangle, consecutive integers), parameter problems (real/equal/opposite-sign roots, common root), transformed roots, biquadratic, and JEE Advanced classics (high-power roots via recursion, AM-GM bounds, common-root puzzles). Every problem and answer is <em>CAS-verified</em>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can I scan a quadratic equation from a photo or textbook?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Click the <strong>&#128247; Scan</strong> button and upload (or drop in) a photo of a handwritten or printed quadratic equation. The AI vision model extracts the equation, fills the math field automatically, and detects the form (standard, vertex, factored, or inequality). Works on phone snapshots, textbook pages, whiteboard photos, and worksheet scans.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What grade levels and curricula does this cover?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Covers <strong>Algebra 1</strong> (factoring, basic quadratic formula), <strong>Algebra 2</strong> (discriminant, complex roots, vertex form), <strong>Precalculus</strong> (parabola conic-section properties, horizontal parabolas), and college algebra. Aligned with Common Core HSA-REI.B.4 and CBSE/ICSE class 9&ndash;10 quadratic equations chapter. SAT, ACT, and JEE Mains practice covered.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <%--
        Canonical 3-partial load order:
          1. math-libs                     — CDN deps, shared libs
          2. quadratic-solver-scripts      — render/graph/export/bridge/core + image-scan
          3. math-input-setup              — MathLive + visual/text mode toggle
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />
    <jsp:include page="/math/partials/quadratic-solver-scripts.jsp" />
    <jsp:include page="/math/partials/math-input-setup.jsp" />

    <!-- ─── Worksheet engine + button binding (1,500-problem CAS-verified
            bank at worksheet/math/algebra/quadratic.json — replaces the
            legacy inline 50-problem JS bank). ─── -->
    <script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>
    <script>
    (function () {
        function openQuadraticWorksheet() {
            if (!window.WorksheetEngine || typeof window.WorksheetEngine.open !== 'function') {
                if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
                    ToolUtils.showToast('Worksheet engine not loaded', 2500, 'warning');
                }
                return;
            }
            window.WorksheetEngine.open({
                jsonUrl: '<%=request.getContextPath()%>/worksheet/math/algebra/quadratic.json',
                title: 'Quadratic Equations',
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
            var btn = document.getElementById('qs-worksheet-btn');
            if (btn) btn.addEventListener('click', openQuadraticWorksheet);
        });
    })();
    </script>
    <%@ include file="/modern/components/algebra-cores.inc.jsp" %>
    <%
        request.setAttribute("mathAiButtonId", "btnMathAI");
        request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
        request.setAttribute("mathAiProfileExport", "configureQuadraticMathShell");
    %>
    <%@ include file="/modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
