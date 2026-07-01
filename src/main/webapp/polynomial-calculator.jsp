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
        Polynomial Calculator — migrated to math-studio shell.
        Mirror of quadratic-solver.jsp / limit-calculator.jsp pattern.

        Operations: Add, Subtract, Multiply, Divide, Factor, Roots, Evaluate.
        Binary ops (add/sub/mul/div) need Q(x); evaluate needs an x-value;
        factor/roots need only P(x). The visible "Operation" pill bar
        toggles which secondary inputs appear.

        Bridge: modern/js/polynomial-calculator-input-bridge.js reads from
        the visible MathLive surfaces and writes to the legacy hidden
        text inputs (#poly-p1, #poly-p2, #poly-eval-x). The unmodified
        polynomial-calculator-{render,graph,export,core}.js carries the
        rest unchanged.

        SEO params PORTED VERBATIM from the original (5 FAQ pairs +
        howToSteps + educationalLevel + teaches).

        Positioning note: this page emphasizes polynomial OPERATIONS
        (add/subtract/multiply/divide/factor/long-division) over root
        finding so it doesn't fight quadratic-solver.jsp for degree-2
        root SEO. See math/MIGRATION_TEMPLATE.md.
    --%>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Polynomial Calculator with Steps — AI Scan &amp; Worksheets" />
        <jsp:param name="toolDescription" value="Free polynomial calculator with AI photo scan + 1,500 practice problems. Add, multiply, divide, factor any-degree polynomials with steps." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="polynomial-calculator.jsp" />
        <jsp:param name="toolKeywords" value="polynomial calculator, polynomial calculator with steps, factor polynomial, polynomial long division calculator, find roots of polynomial, polynomial addition calculator, polynomial multiplication, polynomial solver, polynomial graphing calculator, algebra calculator, polynomial division with remainder, ai polynomial solver, photo math solver, scan polynomial from photo, ai math homework helper, polynomial photo solver, math problem photo scanner, polynomial worksheet, polynomial worksheet pdf, polynomial worksheet with answers, polynomial practice problems, factoring polynomials worksheet, polynomial worksheet for class 9, polynomial worksheet for class 10, printable polynomial worksheet, polynomial practice problems with answers" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Add subtract multiply divide polynomials,Step-by-step solutions with LaTeX rendering,Factor polynomials of any degree,Find all real and complex roots,Polynomial long division with remainder,Interactive graph with Plotly,Python code generation,LaTeX and share URL export,AI photo scanner extracts polynomials from images,1500+ SymPy-verified practice problems with answer key,26 problem types from basic to scholar level,Printable polynomial worksheet,Photo math problem solver,Auto-detect polynomial operation from image,Free with no signup or limits" />
        <jsp:param name="teaches" value="Polynomial arithmetic, polynomial long division, polynomial factoring, root finding, Rational Root Theorem, synthetic division" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter polynomial P(x)|Type your polynomial expression like x^3+2x^2-5x+3 in the P(x) input field,Choose operation|Select an operation: Add Subtract Multiply Divide Factor Roots or Evaluate,Enter Q(x) if needed|For two-polynomial operations enter the second polynomial Q(x),Click Calculate|Click the Calculate button to see the step-by-step solution with LaTeX rendering,View graph|Switch to the Graph tab to see an interactive plot of your polynomial with roots marked,Export result|Copy the LaTeX formula or share your calculation via URL" />
        <jsp:param name="faq1q" value="How do you add and subtract polynomials?" />
        <jsp:param name="faq1a" value="To add polynomials, align like terms (same power of x) and add their coefficients. Example: (x^3+2x^2-5x+3) + (x^2-4) = x^3+3x^2-5x-1. To subtract, distribute the negative sign across the second polynomial first, then combine like terms. Our calculator shows each step." />
        <jsp:param name="faq2q" value="How does polynomial long division work?" />
        <jsp:param name="faq2a" value="Polynomial long division follows the same algorithm as numerical long division. Divide the leading term of the dividend by the leading term of the divisor to get the first quotient term. Multiply the entire divisor by that term, subtract from the dividend, then repeat with the remainder. Continue until the remainder degree is less than the divisor degree." />
        <jsp:param name="faq3q" value="How do you factor a polynomial?" />
        <jsp:param name="faq3a" value="Start by factoring out the greatest common factor (GCF). For quadratics, find two numbers that multiply to ac and add to b, or use the quadratic formula. For higher degrees, try the Rational Root Theorem, synthetic division, or special patterns like difference of squares a^2-b^2=(a+b)(a-b) and sum/difference of cubes." />
        <jsp:param name="faq4q" value="Can this calculator find complex roots?" />
        <jsp:param name="faq4a" value="Yes. The Fundamental Theorem of Algebra guarantees a degree-n polynomial has exactly n roots (counted with multiplicity) over the complex numbers. Our calculator uses the Nerdamer algebra engine to find both real and complex roots. For example, x^2+1=0 returns the roots i and -i." />
        <jsp:param name="faq5q" value="What is the Rational Root Theorem?" />
        <jsp:param name="faq5a" value="The Rational Root Theorem states that any rational root p/q of a polynomial with integer coefficients must have p dividing the constant term and q dividing the leading coefficient. For x^3-6x^2+11x-6, possible rational roots are plus or minus 1, 2, 3, 6. Testing these finds roots at x=1, x=2, and x=3." />
        <jsp:param name="faq6q" value="Can I take a photo of my polynomial homework to get the answer?" />
        <jsp:param name="faq6a" value="Yes. Click the camera Scan button to upload a photo or take a picture of your polynomial problem. The AI extracts the polynomial(s) from the image, auto-detects the operation (factor, multiply, divide, etc.), and runs them through the calculator. Works for textbook pages, homework photos, or whiteboard captures." />
        <jsp:param name="faq7q" value="Where can I find polynomial practice problems with answers?" />
        <jsp:param name="faq7a" value="Click the Practice Worksheet button below the result panel for 1,500+ SymPy-verified polynomial problems with full answer keys. Problems are organized by 26 types and 4 difficulty levels (basic, medium, hard, scholar). Suitable for class 9, class 10, AP precalculus, and college algebra." />
        <jsp:param name="faq8q" value="What types of problems are in the polynomial worksheet?" />
        <jsp:param name="faq8a" value="26 types: addition, subtraction, multiplication including binomial expansion, long division, synthetic division, factoring (quadratic, special patterns, grouping, high-degree), Rational Root Theorem, polynomial from given roots, Vieta's symmetric functions, polynomial inequalities, partial fractions, and parametric problems (find k for factor, common-factor parameters, multi-divisibility, double roots, radical roots)." />
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

    <!-- Math shell + poly-* legacy rules -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/polynomial-calculator.css?v=<%=v%>">

    <!-- Image-to-math + KaTeX + MathLive -->
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
        /* Polynomial-specific overrides on the math-studio shell. */
        .poly-bridge-op-bar {
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
            padding: 0.4rem 0.5rem;
            background: var(--ms-panel-bg-soft, #faf8f4);
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius, 14px);
            margin-bottom: 0.75rem;
        }
        .poly-op-group {
            display: flex;
            flex-wrap: wrap;
            gap: 0.3rem;
            align-items: center;
        }
        .poly-op-label {
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            min-width: 64px;
        }
        .poly-bridge-op {
            flex: 1 1 auto;
            min-width: 70px;
            padding: 0.4rem 0.7rem;
            font-size: 0.78rem;
            font-weight: 500;
            border: none;
            border-radius: var(--ms-radius-pill, 999px);
            background: transparent;
            color: var(--ms-ink-soft, #44403c);
            cursor: pointer;
            font-family: var(--ms-font-sans, Inter, sans-serif);
            transition: background 200ms, color 200ms;
        }
        .poly-bridge-op:hover { background: var(--ms-accent-soft, rgba(21,128,61,0.08)); color: var(--ms-accent, #15803d); }
        .poly-bridge-op.active {
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-accent, #15803d);
            box-shadow: 0 1px 2px rgba(0,0,0,0.06);
            font-weight: 600;
        }
        .poly-q-row { margin-top: 0.6rem; }
        .poly-eval-label {
            display: block;
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.35rem;
        }
        .poly-eval-input {
            width: 100%;
            padding: 0.55rem 0.75rem;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-sm, 8px);
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            font-size: 0.9rem;
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-ink, #1c1917);
        }
        .poly-eval-input:focus {
            outline: none;
            border-color: var(--ms-accent, #15803d);
            box-shadow: var(--ms-ring, 0 0 0 3px rgba(21,128,61,0.22));
        }
        .poly-var-row {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0.5rem 0 0.75rem;
        }
        .poly-var-row label {
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .poly-var-row select {
            padding: 0.3rem 0.55rem;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-sm, 8px);
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            font-size: 0.85rem;
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-ink, #1c1917);
            cursor: pointer;
        }
        .poly-section-label {
            display: block;
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin: 0.4rem 0 0.35rem;
        }
        .ic-hero-cta-row .ic-clear-btn {
            padding: 0.5rem 0.9rem;
            font-size: 0.82rem;
            font-weight: 500;
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
        .qs-empty-chips { /* reuse the quadratic empty-chip grid styling */
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 0.45rem 0.75rem;
            align-items: center;
            max-width: 460px;
            margin: 1rem auto 0;
            text-align: left;
        }
        .qs-empty-chips .qs-chip-label {
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .qs-empty-chips .ic-example-chip {
            justify-self: start;
            text-align: left;
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            font-size: 0.85rem;
        }
        .qs-empty-hint {
            color: var(--ms-muted, #78716c);
            font-size: 0.8rem;
            margin: 1.25rem 0 0;
            text-align: center;
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

        <% request.setAttribute("activeService", "polynomial"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Polynomial</span>
                </nav>
                <h1>Polynomial Calculator &mdash; Add, Multiply, Factor &amp; Divide</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="ic-hero" data-input-mode="visual">

                    <!-- Operation pill bar — split into Combine (binary) and
                         Analyze (unary) for a clearer mental model. -->
                    <div class="poly-bridge-op-bar" role="radiogroup" aria-label="Operation">
                        <div class="poly-op-group">
                            <span class="poly-op-label">Combine</span>
                            <button type="button" class="poly-bridge-op active" data-mode="add"      role="radio" aria-checked="true">Add</button>
                            <button type="button" class="poly-bridge-op"        data-mode="subtract" role="radio" aria-checked="false">Subtract</button>
                            <button type="button" class="poly-bridge-op"        data-mode="multiply" role="radio" aria-checked="false">Multiply</button>
                            <button type="button" class="poly-bridge-op"        data-mode="divide"   role="radio" aria-checked="false">Divide</button>
                        </div>
                        <div class="poly-op-group">
                            <span class="poly-op-label">Analyze</span>
                            <button type="button" class="poly-bridge-op" data-mode="expand"   role="radio" aria-checked="false">Expand</button>
                            <button type="button" class="poly-bridge-op" data-mode="factor"   role="radio" aria-checked="false">Factor</button>
                            <button type="button" class="poly-bridge-op" data-mode="roots"    role="radio" aria-checked="false">Roots</button>
                            <button type="button" class="poly-bridge-op" data-mode="evaluate" role="radio" aria-checked="false">Evaluate</button>
                        </div>
                    </div>

                    <!-- Top row: Visual/Text + Scan -->
                    <div class="ic-hero-top">
                        <div class="ic-expr-label-actions" style="display:flex;gap:0.5rem;align-items:center;margin-left:auto;">
                            <div class="ic-input-mode-toggle" id="ic-input-mode-toggle" role="radiogroup" aria-label="Input mode">
                                <button type="button" class="ic-input-mode-btn active" data-input-mode="visual" role="radio" aria-checked="true" title="Write math visually">
                                    <span aria-hidden="true" style="font-family:'Times New Roman',serif;font-style:italic;">&fnof;</span><span class="ic-mode-label"> Visual</span>
                                </button>
                                <button type="button" class="ic-input-mode-btn" data-input-mode="text" role="radio" aria-checked="false" title="Type a plain-text polynomial">
                                    <span aria-hidden="true" style="font-family:var(--font-mono,monospace);">&lt;/&gt;</span><span class="ic-mode-label"> Text</span>
                                </button>
                            </div>
                            <button type="button" class="ic-image-btn" id="poly-image-btn" title="Scan a polynomial from an image">&#128247; Scan</button>
                            <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — solve in chat (Ctrl+Shift+A)">&#10024; AI</button>
                        </div>
                    </div>

                    <!-- P(x) — primary polynomial. math-input-setup.jsp wires
                         the math-field + plain input pair under #ic-expr-wrap. -->
                    <span class="poly-section-label">P(x)</span>
                    <div class="ic-expr-wrap" id="ic-expr-wrap">
                        <math-field id="ic-mathfield" class="ic-mathfield" aria-label="Polynomial P(x)"
                                    placeholder="x^3 + 2x^2 - 5x + 3"
                                    math-virtual-keyboard-policy="manual"
                                    smart-mode="on" smart-fence="on" smart-superscript="on"
                                    remove-extraneous-parentheses="on" math-mode-space="\:"></math-field>

                        <input type="text" class="tool-input tool-input-mono" id="ic-expr"
                               placeholder="e.g.  x^3 + 2x^2 - 5x + 3"
                               autocomplete="off" spellcheck="false" aria-label="Polynomial P(x)">

                        <span class="tool-form-hint ic-expr-hint">
                            <span class="ic-hint-visual">Use <code>^</code> for powers (or <code>x²</code> visually). Implicit multiplication is fine: <code>5x</code>, <code>(x+1)(x-2)</code>.</span>
                            <span class="ic-hint-text"><code>x^3 + 2x^2 - 5x + 3</code> &middot; <code>(x+1)(x-2)</code> &middot; <code>x^4 - 16</code></span>
                        </span>
                    </div>

                    <!-- Q(x) — secondary polynomial (binary ops only).
                         Uses the same .ic-mathfield class as P so the visual
                         appearance is identical. The Visual/Text hide rule is
                         keyed to ID #ic-mathfield, not to the class, so Q
                         won't be hidden in Text mode. -->
                    <div class="poly-q-row" id="poly-q-wrap">
                        <span class="poly-section-label" style="margin-top:0;">Q(x)</span>
                        <math-field id="ic-mathfield2" class="ic-mathfield" aria-label="Polynomial Q(x)"
                                    placeholder="x^2 - 4"
                                    math-virtual-keyboard-policy="manual"
                                    smart-mode="on" smart-fence="on" smart-superscript="on"
                                    remove-extraneous-parentheses="on" math-mode-space="\:"></math-field>
                    </div>

                    <!-- Evaluate at x = ... (replace x with chosen variable label dynamically) -->
                    <div class="poly-q-row" id="poly-eval-wrap" style="display:none;">
                        <span class="poly-eval-label">Evaluate at <span id="poly-eval-var">x</span></span>
                        <input type="text" class="poly-eval-input" id="poly-bridge-eval-x"
                               placeholder="e.g.  2" autocomplete="off" spellcheck="false">
                    </div>

                    <!-- Variable selector (defaults x; nerdamer auto-detects but explicit
                         is clearer for AI fallback and labels). -->
                    <div class="poly-var-row">
                        <label for="poly-var">Variable</label>
                        <select id="poly-var">
                            <option value="x" selected>x</option>
                            <option value="y">y</option>
                            <option value="z">z</option>
                            <option value="t">t</option>
                            <option value="w">w</option>
                            <option value="n">n</option>
                        </select>
                    </div>

                    <!-- Primary CTA + Clear -->
                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta is-disabled" id="poly-calculate-btn" aria-disabled="true">Calculate</button>
                        <button type="button" class="ic-clear-btn" id="poly-reset-btn" title="Clear inputs and start over">Clear</button>
                        <span class="ic-hero-warn" id="poly-calculate-warn" role="alert" aria-live="polite"></span>
                    </div>

                    <!-- Syntax help -->
                    <div class="ic-hero-syntax" id="poly-syntax-wrap">
                        <button type="button" class="ic-syntax-toggle" id="poly-syntax-btn">
                            Syntax help
                            <svg class="ic-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </button>
                        <div class="ic-syntax-content" id="poly-syntax-content">
                            <strong>Powers:</strong> <code>x^2</code> or visual <code>x²</code>. Higher: <code>x^5</code>, <code>x^{10}</code>.<br>
                            <strong>Coefficients:</strong> <code>3x^2</code> = <em>3 &middot; x²</em>. Negatives: <code>-2x</code>. Fractions: <code>x/2</code>.<br>
                            <strong>Operations:</strong> Add / Subtract / Multiply / Divide need both <em>P(x)</em> and <em>Q(x)</em>. Expand / Factor / Roots use only <em>P(x)</em>. Evaluate also takes a value for x.<br>
                            <strong>Factored input:</strong> <code>(x-1)(x+2)(x-3)</code> works just as well as the expanded form.<br>
                            <strong>Equations:</strong> for <em>Factor</em>, <em>Roots</em>, or <em>Expand</em>, you can paste an equation with <code>=</code>: <code>x^5 + 9x = 10x^3</code> auto-rearranges to <em>x⁵ − 10x³ + 9x = 0</em> before solving.
                        </div>
                    </div>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs" role="tablist">
                        <button type="button" class="ic-output-tab poly-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                        <button type="button" class="ic-output-tab poly-output-tab" data-panel="graph" role="tab" aria-selected="false">Graph</button>
                        <button type="button" class="ic-output-tab poly-output-tab" data-panel="python" role="tab" aria-selected="false">Python</button>
                    </div>

                    <div class="ic-panel poly-panel active" id="poly-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="poly-result-content">
                                <div class="tool-empty-state ic-empty-state" id="poly-empty-state">
                                    <div class="ic-empty-illustration">P(x)</div>
                                    <h3>Try an example</h3>
                                    <div class="qs-empty-chips">
                                        <span class="qs-chip-label">Add</span>
                                        <button type="button" class="ic-example-chip" data-mode="add" data-p1="x^3 + 2x^2 - 5x + 3" data-p2="x^2 - 4">(x³+2x²−5x+3) + (x²−4)</button>

                                        <span class="qs-chip-label">Subtract</span>
                                        <button type="button" class="ic-example-chip" data-mode="subtract" data-p1="2x^3 + x^2 - 4" data-p2="x^3 - x + 1">(2x³+x²−4) − (x³−x+1)</button>

                                        <span class="qs-chip-label">Multiply</span>
                                        <button type="button" class="ic-example-chip" data-mode="multiply" data-p1="x + 1" data-p2="x^2 - x + 1">(x+1) &middot; (x²−x+1)</button>

                                        <span class="qs-chip-label">Divide</span>
                                        <button type="button" class="ic-example-chip" data-mode="divide" data-p1="x^3 - 6x^2 + 11x - 6" data-p2="x - 1">(x³−6x²+11x−6) &divide; (x−1)</button>

                                        <span class="qs-chip-label">Factor</span>
                                        <button type="button" class="ic-example-chip" data-mode="factor" data-p1="x^3 - 6x^2 + 11x - 6">factor x³−6x²+11x−6</button>

                                        <span class="qs-chip-label">Roots</span>
                                        <button type="button" class="ic-example-chip" data-mode="roots" data-p1="x^4 - 16">roots of x⁴−16</button>

                                        <span class="qs-chip-label">Evaluate</span>
                                        <button type="button" class="ic-example-chip" data-mode="evaluate" data-p1="x^3 - 2x + 5" data-eval-x="2">P(2) for x³−2x+5</button>
                                    </div>
                                    <p class="qs-empty-hint">or pick an operation and type your own</p>
                                </div>
                            </div>

                            <div class="tool-result-actions" id="poly-result-actions" style="display:none;">
                                <button type="button" class="tool-action-btn" id="poly-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="poly-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="poly-toolbar-worksheet-btn">Worksheet</button>
                            </div>

                            <!-- Prominent worksheet CTA — always visible, drives the
                                 WorksheetEngine modal (1,500+ SymPy-verified problems
                                 across 26 polynomial types, basic→scholar). -->
                            <div class="ic-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="poly-worksheet-btn">
                                    Practice Worksheet &mdash; 1,500+ polynomial problems with answer key
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel poly-panel" id="poly-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:360px;padding:0.75rem;">
                                <div id="poly-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                                <p id="poly-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Calculate a polynomial to see its graph with roots marked.</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel poly-panel" id="poly-panel-python" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="display:flex;align-items:center;gap:0.5rem;padding:0.6rem 0.25rem;">
                                <span style="font-size:0.78rem;color:var(--ms-muted);font-weight:600;">Template:</span>
                                <select id="poly-compiler-template" style="padding:0.35rem 0.6rem;border:1px solid var(--ms-panel-border);border-radius:6px;font-size:0.8rem;background:var(--ms-panel-bg);color:var(--ms-ink);">
                                    <option value="numpy">NumPy</option>
                                    <option value="sympy">SymPy</option>
                                </select>
                            </div>
                            <div style="flex:1;min-height:0;">
                                <iframe id="poly-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- In-content ad -->
            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- Methods reference band — emphasize OPERATIONS, not roots
                 (root-finding is quadratic-solver's territory). -->
            <section class="ic-learn" aria-label="Polynomial operations">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Long division</span>
                    <code class="ic-learn-formula">P(x) = Q(x)&middot;D(x) + R(x), &nbsp; deg R &lt; deg D</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Factoring</span>
                    <code class="ic-learn-formula">x&sup3; &minus; 6x&sup2; + 11x &minus; 6 = (x&minus;1)(x&minus;2)(x&minus;3)</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Rational Root Thm</span>
                    <code class="ic-learn-formula">root p/q &rArr; p &mid; constant, &nbsp; q &mid; leading coefficient</code>
                </article>
            </section>

            <!-- Cross-links to sibling tools — reduce SEO cannibalization
                 by making each tool's distinct purpose explicit. -->
            <section class="ic-related-strip" style="margin-top:2rem;display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:0.75rem;">
                <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Working with degree-2?</div>
                    <div style="font-weight:600;">Quadratic Formula Calculator &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">Step-by-step formula, completing the square, factoring, inequalities, and a 50-problem worksheet.</div>
                </a>
                <a href="<%=request.getContextPath()%>/inequality-solver.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Have an inequality?</div>
                    <div style="font-weight:600;">Inequality Solver &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">Linear, polynomial, rational, absolute-value, and compound inequalities with sign chart and interval notation.</div>
                </a>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- ═══ HIDDEN LEGACY STATE (read by polynomial-calculator-core.js) ═══
         #poly-var is now visible (above) so the user can switch variables.
         Everything else stays hidden — the bridge writes to these inputs
         and "clicks" the hidden mode/calc buttons. -->
    <div aria-hidden="true" style="display:none">
        <div class="poly-mode-toggle">
            <button type="button" class="poly-mode-btn active" data-mode="add">Add</button>
            <button type="button" class="poly-mode-btn"        data-mode="subtract">Subtract</button>
            <button type="button" class="poly-mode-btn"        data-mode="multiply">Multiply</button>
            <button type="button" class="poly-mode-btn"        data-mode="divide">Divide</button>
            <button type="button" class="poly-mode-btn"        data-mode="expand">Expand</button>
            <button type="button" class="poly-mode-btn"        data-mode="factor">Factor</button>
            <button type="button" class="poly-mode-btn"        data-mode="roots">Roots</button>
            <button type="button" class="poly-mode-btn"        data-mode="evaluate">Evaluate</button>
        </div>
        <input type="text" id="poly-p1" value="">
        <div id="poly-p2-group">
            <input type="text" id="poly-p2" value="">
        </div>
        <div id="poly-eval-x-group">
            <input type="text" id="poly-eval-x" value="">
        </div>
        <div id="poly-preview"></div>
        <div id="poly-steps-area"></div>
        <button type="button" id="poly-calc-btn">Calculate (legacy)</button>
        <button type="button" id="poly-clear-btn">Clear (legacy)</button>
    </div>

    <!-- Visible FAQ — keep in sync with faqNq/faqNa jsp:params. -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Polynomial calculator FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you add and subtract polynomials?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">To <strong>add polynomials</strong>, align like terms (same power of <em>x</em>) and add their coefficients. Example: <em>(x&sup3; + 2x&sup2; &minus; 5x + 3) + (x&sup2; &minus; 4) = x&sup3; + 3x&sup2; &minus; 5x &minus; 1</em>. To <strong>subtract</strong>, distribute the negative sign across the second polynomial first, then combine like terms. The calculator shows each step.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How does polynomial long division work?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a"><strong>Polynomial long division</strong> follows the same algorithm as numerical long division. Divide the leading term of the dividend by the leading term of the divisor to get the first quotient term. Multiply the entire divisor by that term, subtract from the dividend, then repeat with the remainder. Continue until the remainder degree is less than the divisor degree.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you factor a polynomial?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Start by factoring out the <strong>greatest common factor (GCF)</strong>. For quadratics, find two numbers that multiply to <em>ac</em> and add to <em>b</em>, or use the quadratic formula. For higher degrees, try the <strong>Rational Root Theorem</strong>, synthetic division, or special patterns like difference of squares <em>a&sup2; &minus; b&sup2; = (a + b)(a &minus; b)</em> and sum/difference of cubes.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can this calculator find complex roots?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. The <strong>Fundamental Theorem of Algebra</strong> guarantees a degree-<em>n</em> polynomial has exactly <em>n</em> roots (counted with multiplicity) over the complex numbers. The calculator uses the Nerdamer algebra engine to find both real and complex roots. For example, <em>x&sup2; + 1 = 0</em> returns the roots <em>i</em> and <em>&minus;i</em>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the Rational Root Theorem?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The <strong>Rational Root Theorem</strong> states that any rational root <em>p/q</em> of a polynomial with integer coefficients must have <em>p</em> dividing the constant term and <em>q</em> dividing the leading coefficient. For <em>x&sup3; &minus; 6x&sup2; + 11x &minus; 6</em>, possible rational roots are &plusmn;1, &plusmn;2, &plusmn;3, &plusmn;6. Testing these finds roots at <em>x = 1, 2, 3</em>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can I take a photo of my polynomial homework to get the answer?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Click the <strong>&#128247; Scan</strong> button to upload a photo or take a picture of your polynomial problem. The <strong>AI extracts</strong> the polynomial(s) from the image, auto-detects the operation (factor, multiply, divide, etc.), and runs them through the calculator. Works for textbook pages, homework photos, or whiteboard captures.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Where can I find polynomial practice problems with answers?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Click the <strong>Practice Worksheet</strong> button below the result panel for <strong>1,500+ SymPy-verified polynomial problems</strong> with full answer keys. Problems are organized by 26 types and 4 difficulty levels (basic, medium, hard, scholar). Suitable for class 9, class 10, AP precalculus, and college algebra.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What types of problems are in the polynomial worksheet?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a"><strong>26 types</strong>: addition, subtraction, multiplication (incl. binomial expansion), long division, synthetic division, factoring (quadratic, special patterns, grouping, high-degree), Rational Root Theorem, polynomial from given roots, Vieta's symmetric functions, polynomial inequalities, partial fractions, and parametric problems (find <em>k</em> for factor, common-factor parameters, multi-divisibility, double roots, radical roots).</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <jsp:include page="/math/partials/math-libs.jsp" />
    <jsp:include page="/math/partials/polynomial-calculator-scripts.jsp" />
    <jsp:include page="/math/partials/math-input-setup.jsp" />

    <%@ include file="/modern/components/math-calculus-cores.inc.jsp" %>
    <%
        request.setAttribute("mathAiButtonId", "btnMathAI");
        request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
        request.setAttribute("mathAiProfileExport", "configurePolynomialMathShell");
    %>
    <%@ include file="/modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
