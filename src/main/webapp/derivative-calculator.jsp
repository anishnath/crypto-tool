<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Derivative Calculator — reference template for math tool migration.
        Follows integral-calculator2.jsp / integral-calculator.jsp pattern.

        Build contract:
          · SEO params: ported VERBATIM from original derivative-calculator.jsp
            (same 8 FAQ pairs, same 25+ structured-data signals)
          · Shared infrastructure loaded by the three partials in canonical order
          · Math input uses the ic-* contract (expr, mathfield, expr-wrap,
            input-mode-toggle) so math-input-setup.jsp wires it for free
          · Derivative-specific widgets (order toggle, eval point) keep dc-*

        See math/MIGRATION_TEMPLATE.md for the full playbook.
    --%>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Derivative Calculator • With Steps!" />
        <jsp:param name="toolDescription" value="Free derivative calculator with step-by-step solutions. Find 1st through 5th derivatives using power, product, quotient, chain rules. Graph, LaTeX, PDF export. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="derivative-calculator.jsp" />
        <jsp:param name="toolKeywords" value="derivative calculator, derivative calculator with steps, 2nd derivative calculator, implicit derivative calculator, partial derivative calculator, differentiation calculator, derivative solver, second derivative calculator, chain rule calculator, power rule calculator, derivative at a point calculator, critical points calculator, quotient rule calculator" />
        <jsp:param name="educationalLevel" value="High School, College" />
        <jsp:param name="teaches" value="Calculus, differentiation, derivatives, chain rule, product rule" />
        <jsp:param name="howToSteps" value="Enter your function|Type your expression (e.g. x^2, sin(x), e^x) in the function input field,Select derivative order|Choose 1st, 2nd, 3rd, 4th, or 5th derivative,Click Differentiate|Click the button to compute the derivative,View steps &amp; graph|See step-by-step solution with rule identification, interactive graph, and optional point evaluation" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Step-by-step with rule identification,1st through 5th derivatives,Live KaTeX preview,Interactive Plotly graph,Critical points detection,Point evaluation f prime(a),Download PDF,Copy LaTeX,Share URL,Python SymPy compiler,Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a derivative in calculus?" />
        <jsp:param name="faq1a" value="A derivative measures the instantaneous rate of change of a function. Geometrically, f'(a) equals the slope of the tangent line to y = f(x) at the point (a, f(a)). The derivative is defined as f'(x) = lim(h to 0) [f(x+h) - f(x)] / h. Derivatives are fundamental to calculus, physics, engineering, and optimization." />
        <jsp:param name="faq2q" value="How do you find the derivative of a function step by step?" />
        <jsp:param name="faq2a" value="To find a derivative step by step: (1) Identify the function type - polynomial, trigonometric, exponential, or composite. (2) Apply the matching rule - power rule for x^n, product rule for f*g, quotient rule for f/g, or chain rule for f(g(x)). (3) Simplify the result. (4) Verify by checking at specific points." />
        <jsp:param name="faq3q" value="What is the chain rule and when do you use it?" />
        <jsp:param name="faq3a" value="The chain rule states d/dx[f(g(x))] = f'(g(x)) * g'(x). Use it when differentiating composite functions - a function inside another function. For example, d/dx[sin(x^2)] = cos(x^2) * 2x. The outer function is sin and the inner function is x^2. The chain rule is the most frequently used differentiation rule in calculus." />
        <jsp:param name="faq4q" value="What is the difference between first and second derivative?" />
        <jsp:param name="faq4a" value="The first derivative f'(x) gives the rate of change and slope of the tangent line. The second derivative f''(x) measures how the rate of change itself is changing - it determines concavity. If f''(x) > 0, the graph is concave up. If f''(x) < 0, it is concave down. In physics, if f is position, f' is velocity and f'' is acceleration." />
        <jsp:param name="faq5q" value="How do you find critical points using derivatives?" />
        <jsp:param name="faq5a" value="To find critical points: (1) Compute f'(x). (2) Set f'(x) = 0 and solve for x. (3) Also check where f'(x) is undefined. These x-values are critical points. Use the second derivative test: if f''(c) > 0 the critical point is a local minimum, if f''(c) < 0 it is a local maximum, if f''(c) = 0 the test is inconclusive." />
        <jsp:param name="faq6q" value="What are the basic rules of differentiation?" />
        <jsp:param name="faq6a" value="The five basic differentiation rules are: Power Rule d/dx[x^n] = nx^(n-1), Product Rule d/dx[fg] = f'g + fg', Quotient Rule d/dx[f/g] = (f'g - fg')/g^2, Chain Rule d/dx[f(g(x))] = f'(g(x))g'(x), and Sum Rule d/dx[f+g] = f'+g'. Most derivatives can be computed by combining these rules." />
        <jsp:param name="faq7q" value="Does this derivative calculator support 2nd derivative and higher?" />
        <jsp:param name="faq7a" value="Yes. Use the order toggle to compute 1st, 2nd, 3rd, 4th, or 5th derivatives. For f(x)=x^4, the 2nd derivative is 12x^2, the 3rd is 24x, and the 4th is 24. Each order shows full step-by-step solutions. The second derivative reveals concavity; higher derivatives appear in Taylor series and physics (jerk, snap)." />
        <jsp:param name="faq8q" value="What is implicit differentiation and does this calculator support it?" />
        <jsp:param name="faq8a" value="Implicit differentiation finds dy/dx when y is defined implicitly by an equation like x^2+y^2=25. You differentiate both sides with respect to x, treating y as a function of x. This calculator differentiates expressions with respect to any variable (x, y, t, etc.). Enter expressions involving multiple variables like x^2*y or sin(x)*cos(y) and select the variable to differentiate with respect to. The built-in Python compiler supports full implicit differentiation via SymPy." />
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

    <!-- New math shell (sidebar tree + workspace layout + dc-* parallel rules) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <!-- Image-to-math scanner modal -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css?v=<%=v%>">

    <!-- KaTeX + MathLive -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Decorative physics backdrop (shared across all math pages) -->
    <jsp:include page="/math/partials/matter-bg.jsp" />

    <!-- Hero banner ad -->
    <div class="ms-hero">
        <%@ include file="modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="ms-main">

        <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
            &#9776; Math tools
        </button>

        <% request.setAttribute("activeService", "derivative"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <!-- Slim title row -->
            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Derivative</span>
                </nav>
                <h1>Derivative Calculator</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="ic-hero" data-input-mode="visual">

                    <!-- Top row: dc-order toggle ← → visual/text + scan -->
                    <div class="ic-hero-top">
                        <div class="dc-order-toggle" role="radiogroup" aria-label="Derivative order">
                            <button type="button" class="dc-order-btn active" data-order="1" role="radio" aria-checked="true" title="First derivative f'(x)">1st</button>
                            <button type="button" class="dc-order-btn" data-order="2" role="radio" aria-checked="false" title="Second derivative f''(x)">2nd</button>
                            <button type="button" class="dc-order-btn" data-order="3" role="radio" aria-checked="false">3rd</button>
                            <button type="button" class="dc-order-btn" data-order="4" role="radio" aria-checked="false">4th</button>
                            <button type="button" class="dc-order-btn" data-order="5" role="radio" aria-checked="false">5th</button>
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
                            <button type="button" class="ic-image-btn" id="dc-image-btn" title="Scan problem from image">&#128247; Scan</button>
                        </div>
                    </div>

                    <!-- Function input (visual + text). ic-* IDs match the
                         math-input contract so math-input-setup.jsp wires it. -->
                    <div class="ic-expr-wrap" id="ic-expr-wrap">
                        <math-field id="ic-mathfield" class="ic-mathfield" aria-label="Function to differentiate"
                                    placeholder="x^{2} \sin(x)"
                                    smart-mode="on" smart-fence="on" smart-superscript="on"
                                    remove-extraneous-parentheses="on" math-mode-space="\:"></math-field>

                        <input type="text" class="tool-input tool-input-mono" id="ic-expr"
                               placeholder="e.g.  x^2 * sin(x)   or   e^x"
                               autocomplete="off" spellcheck="false" aria-label="Function to differentiate">

                        <span class="tool-form-hint ic-expr-hint">
                            <span class="ic-hint-visual">Type <code>sin</code>, <code>sqrt</code>, <code>^</code>, <code>/</code> naturally.</span>
                            <span class="ic-hint-text">Shorthand like <code>sin3x</code> works; use <code>*</code> for products.</span>
                        </span>
                    </div>

                    <!-- Live preview strip (hidden in visual mode via CSS) -->
                    <div class="ic-preview-strip">
                        <span class="ic-preview-label">Preview</span>
                        <span class="ic-preview" id="dc-preview">type a function above&hellip;</span>
                    </div>

                    <!-- Params: variable (always) + evaluation point (optional) -->
                    <div class="ic-hero-params visible">
                        <div class="tool-form-group">
                            <label for="dc-var">Variable</label>
                            <select class="tool-select" id="dc-var">
                                <option value="x" selected>x</option>
                                <option value="y">y</option>
                                <option value="z">z</option>
                                <option value="t">t</option>
                                <option value="u">u</option>
                                <option value="theta">&theta;</option>
                            </select>
                        </div>
                        <div class="tool-form-group">
                            <label for="dc-eval-point">Evaluate at x = (optional)</label>
                            <input type="text" class="tool-input tool-input-mono" id="dc-eval-point" placeholder="e.g. 0, pi/4, 2">
                        </div>
                    </div>

                    <!-- Primary CTA -->
                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta is-disabled" id="dc-differentiate-btn" aria-disabled="true">Differentiate</button>
                        <span class="ic-hero-warn" id="dc-differentiate-warn" role="alert" aria-live="polite"></span>
                    </div>

                    <!-- Examples by method — collapsed by default -->
                    <details class="ic-hero-methods" id="dc-examples">
                        <summary class="ic-hero-methods-summary">
                            <span>Examples by rule</span>
                            <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </summary>
                        <div class="ic-hero-methods-body">
                            <div class="ic-method-row">
                                <span class="ic-method-label">Power</span>
                                <button type="button" class="ic-example-chip" data-expr="x^5">x⁵</button>
                                <button type="button" class="ic-example-chip" data-expr="3*x^4 + 2*x^2">3x⁴&nbsp;+&nbsp;2x²</button>
                                <button type="button" class="ic-example-chip" data-expr="sqrt(x)">√x</button>
                            </div>
                            <div class="ic-method-row">
                                <span class="ic-method-label">Product</span>
                                <button type="button" class="ic-example-chip" data-expr="x^2 * sin(x)">x²·sin(x)</button>
                                <button type="button" class="ic-example-chip" data-expr="x * e^x">x·eˣ</button>
                                <button type="button" class="ic-example-chip" data-expr="x * ln(x)">x·ln(x)</button>
                            </div>
                            <div class="ic-method-row">
                                <span class="ic-method-label">Quotient</span>
                                <button type="button" class="ic-example-chip" data-expr="sin(x)/x">sin(x)/x</button>
                                <button type="button" class="ic-example-chip" data-expr="(x^2+1)/(x-1)">(x²+1)/(x−1)</button>
                                <button type="button" class="ic-example-chip" data-expr="ln(x)/x">ln(x)/x</button>
                            </div>
                            <div class="ic-method-row">
                                <span class="ic-method-label">Chain</span>
                                <button type="button" class="ic-example-chip" data-expr="sin(x^2)">sin(x²)</button>
                                <button type="button" class="ic-example-chip" data-expr="e^(x^2)">e^(x²)</button>
                                <button type="button" class="ic-example-chip" data-expr="sqrt(1 + x^2)">√(1+x²)</button>
                            </div>
                            <div class="ic-method-row">
                                <span class="ic-method-label">Trig / log</span>
                                <button type="button" class="ic-example-chip" data-expr="tan(x)">tan(x)</button>
                                <button type="button" class="ic-example-chip" data-expr="ln(sin(x))">ln(sin(x))</button>
                                <button type="button" class="ic-example-chip" data-expr="arctan(x)">arctan(x)</button>
                            </div>
                        </div>
                    </details>

                    <!-- Collapsible syntax help -->
                    <div class="ic-hero-syntax" id="dc-syntax-wrap">
                        <button type="button" class="ic-syntax-toggle" id="dc-syntax-btn">
                            Syntax help
                            <svg class="ic-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </button>
                        <div class="ic-syntax-content" id="dc-syntax-content">
                            <strong>Functions:</strong> <code>sin</code>, <code>cos</code>, <code>tan</code>, <code>ln</code> (or <code>log</code>), <code>sqrt</code>, <code>e^x</code>.<br>
                            <strong>Arc trig:</strong> <code>arcsin(x)</code>, <code>arccos(x)</code>, <code>arctan(x)</code>.<br>
                            <strong>Operators:</strong> use <code>*</code> for multiplication, <code>/</code> for division, <code>^</code> for powers.<br>
                            <strong>Shorthand:</strong> <code>sin3x</code> is accepted (same as <code>sin(3*x)</code>).<br>
                            Leave "Evaluate at" blank for a symbolic derivative; fill it to also get f<sup>(n)</sup>(a).
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

                    <div class="ic-panel active" id="dc-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="dc-result-content">
                                <div class="tool-empty-state ic-empty-state" id="dc-empty-state">
                                    <div class="ic-empty-illustration">d/dx</div>
                                    <h3>Ready when you are</h3>
                                    <p>Type a function above and hit <strong>Differentiate</strong>.</p>
                                </div>
                            </div>

                            <div class="tool-result-actions" id="dc-result-actions">
                                <button type="button" class="tool-action-btn" id="dc-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="dc-copy-text-btn">Copy Text</button>
                                <button type="button" class="tool-action-btn" id="dc-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="dc-download-pdf-btn">Download PDF</button>
                            </div>

                            <div class="ic-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="dc-worksheet-btn">
                                    Practice Derivative Worksheet — 1000+ problems
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel" id="dc-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:360px;">
                                <div id="dc-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                                <p id="dc-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Differentiate a function to see its graph.</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel" id="dc-panel-python" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="display:flex;align-items:center;gap:0.5rem;padding:0.6rem 0.25rem;">
                                <span style="font-size:0.78rem;color:var(--ms-muted);font-weight:600;">Template:</span>
                                <select id="dc-compiler-template" style="padding:0.35rem 0.6rem;border:1px solid var(--ms-panel-border);border-radius:6px;font-size:0.8rem;background:var(--ms-panel-bg);color:var(--ms-ink);">
                                    <option value="symbolic">Symbolic (SymPy)</option>
                                    <option value="numerical">Numerical (SciPy)</option>
                                </select>
                            </div>
                            <div style="flex:1;min-height:0;">
                                <iframe id="dc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
            <section class="ic-learn" aria-label="Differentiation rules">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Power rule</span>
                    <code class="ic-learn-formula">d/dx[x<sup>n</sup>] = n&middot;x<sup>n−1</sup></code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Product rule</span>
                    <code class="ic-learn-formula">(fg)&prime; = f&prime;g + fg&prime;</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Chain rule</span>
                    <code class="ic-learn-formula">d/dx[f(g(x))] = f&prime;(g)&middot;g&prime;(x)</code>
                </article>
            </section>

        </section>

        <!-- Right ad rail (desktop ≥1280px) -->
        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- Visible FAQ — keep in sync with faqNq/faqNa jsp:params above.
         Rendered markup reinforces the schema signal. -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Derivative calculator FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">
                    What is a derivative in calculus?
                    <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
                <div class="ms-faq-a">A derivative measures the instantaneous rate of change of a function. Geometrically, <em>f'(a)</em> equals the slope of the tangent line to <em>y = f(x)</em> at the point <em>(a, f(a))</em>. The derivative is defined as <em>f'(x) = lim<sub>h&rarr;0</sub> [f(x+h) &minus; f(x)] / h</em>. Derivatives are fundamental to calculus, physics, engineering, and optimization.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">
                    How do you find the derivative of a function step by step?
                    <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
                <div class="ms-faq-a">(1) Identify the function type &mdash; polynomial, trig, exponential, or composite. (2) Apply the matching rule: power rule for <code>x^n</code>, product rule for <code>fg</code>, quotient rule for <code>f/g</code>, or chain rule for <code>f(g(x))</code>. (3) Simplify the result. (4) Verify by checking at specific points.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">
                    What is the chain rule and when do you use it?
                    <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
                <div class="ms-faq-a">The chain rule states <em>d/dx[f(g(x))] = f'(g(x)) &middot; g'(x)</em>. Use it when differentiating composite functions &mdash; a function inside another function. For example, <em>d/dx[sin(x&sup2;)] = cos(x&sup2;) &middot; 2x</em>. The outer function is sin and the inner is <em>x&sup2;</em>. Most used rule in calculus.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">
                    What is the difference between first and second derivative?
                    <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
                <div class="ms-faq-a">The <strong>first derivative</strong> <em>f'(x)</em> gives the rate of change and slope of the tangent line. The <strong>second derivative</strong> <em>f''(x)</em> measures how the rate of change itself is changing &mdash; it determines concavity. If <em>f''(x) &gt; 0</em> the graph is concave up; if <em>&lt; 0</em> concave down. In physics, if f is position, f' is velocity and f'' is acceleration.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">
                    How do you find critical points using derivatives?
                    <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
                <div class="ms-faq-a">(1) Compute <em>f'(x)</em>. (2) Set <em>f'(x) = 0</em> and solve for x. (3) Also check where <em>f'(x)</em> is undefined. These x-values are critical points. Use the second-derivative test: if <em>f''(c) &gt; 0</em> it's a local min, if <em>&lt; 0</em> a local max, if <em>= 0</em> the test is inconclusive.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">
                    What are the basic rules of differentiation?
                    <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
                <div class="ms-faq-a">The five basics: <strong>Power</strong> <em>d/dx[x<sup>n</sup>] = nx<sup>n&minus;1</sup></em>, <strong>Product</strong> <em>d/dx[fg] = f'g + fg'</em>, <strong>Quotient</strong> <em>d/dx[f/g] = (f'g − fg')/g&sup2;</em>, <strong>Chain</strong> <em>d/dx[f(g)] = f'(g)g'</em>, <strong>Sum</strong> <em>d/dx[f+g] = f' + g'</em>. Most derivatives are combinations of these.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">
                    Does this derivative calculator support 2nd derivative and higher?
                    <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
                <div class="ms-faq-a">Yes. Use the order toggle at the top to compute 1st, 2nd, 3rd, 4th, or 5th derivatives. For <em>f(x) = x<sup>4</sup></em>, f'' is <em>12x&sup2;</em>, f''' is <em>24x</em>, f'''' is <em>24</em>. Each order shows full step-by-step solutions. The second derivative reveals concavity; higher derivatives show up in Taylor series and physics (jerk, snap).</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">
                    What is implicit differentiation and does this calculator support it?
                    <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
                <div class="ms-faq-a">Implicit differentiation finds <em>dy/dx</em> when y is defined implicitly by an equation like <em>x&sup2;+y&sup2;=25</em>. Differentiate both sides with respect to x, treating y as a function of x. This calculator differentiates expressions with respect to any variable (x, y, t, &hellip;). Enter expressions involving multiple variables like <em>x&sup2;y</em> or <em>sin(x)cos(y)</em> and select the variable. The built-in Python compiler supports full implicit differentiation via SymPy.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <%--
        Canonical 3-partial load order, same as integral-calculator.jsp:
          1. math-libs                  — CDN deps, shared libs
          2. derivative-calculator-scripts — tool-specific (integral-core dep, deriv-core, deriv.js, image-scan)
          3. math-input-setup           — MathLive + mode toggle (reads DOM)
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />
    <jsp:include page="/math/partials/derivative-calculator-scripts.jsp" />
    <jsp:include page="/math/partials/math-input-setup.jsp" />

    <!-- UX layer: empty-input validation, auto-scroll, busy lock, disabled-until-typed.
         Same IIFE as integral-calculator.jsp, adapted for dc-differentiate-btn. -->
    <script>
    (function () {
        // Debug toggle: window.__DC_DEBUG = true OR ?dc_debug=1.
        if (/[?&]dc_debug=1/.test(window.location.search)) window.__DC_DEBUG = true;
        if (window.__DC_DEBUG) console.log('[dc-debug] IIFE starting');

        var btn = document.getElementById('dc-differentiate-btn');
        var scrollTarget = document.getElementById('dc-panel-result');
        var resultContent = document.getElementById('dc-result-content');
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

        var exprInput = document.getElementById('ic-expr');
        var mathField = document.getElementById('ic-mathfield');
        var warnEl    = document.getElementById('dc-differentiate-warn');

        function currentExpression() {
            return exprInput ? (exprInput.value || '').trim() : '';
        }
        function showWarn(msg) {
            if (!warnEl) return;
            warnEl.textContent = msg;
            warnEl.classList.remove('show');
            void warnEl.offsetWidth;
            warnEl.classList.add('show');
        }
        function clearWarn() {
            if (warnEl) { warnEl.classList.remove('show'); warnEl.textContent = ''; }
        }

        function updateEnableState() {
            var hasValue = !!currentExpression();
            btn.classList.toggle('is-disabled', !hasValue);
            btn.setAttribute('aria-disabled', hasValue ? 'false' : 'true');
        }
        function onInput() { clearWarn(); updateEnableState(); }
        if (exprInput) exprInput.addEventListener('input', onInput);
        if (mathField) mathField.addEventListener('input', onInput);

        document.addEventListener('click', function (e) {
            if (!e.target || !e.target.closest) return;
            if (e.target.closest('.ic-example-chip')) setTimeout(updateEnableState, 30);
        }, true);

        document.querySelectorAll('.dc-order-btn, .ic-input-mode-btn').forEach(function (b) {
            b.addEventListener('click', function () { setTimeout(updateEnableState, 40); });
        });
        updateEnableState();

        document.addEventListener('click', function (e) {
            var target = e.target && e.target.closest ? e.target.closest('#dc-differentiate-btn') : null;
            if (!target) return;
            if (btn.classList.contains('is-busy')) { e.preventDefault(); e.stopImmediatePropagation(); return; }
            if (!currentExpression()) {
                e.preventDefault(); e.stopImmediatePropagation();
                showWarn('Enter a function first — try a chip below.');
                var focusEl = mathField && mathField.offsetParent !== null ? mathField : exprInput;
                if (focusEl && typeof focusEl.focus === 'function') focusEl.focus();
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
