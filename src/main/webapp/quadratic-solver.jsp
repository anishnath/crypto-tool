<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Quadratic Equation Solver & Formula Calculator - Free Steps" />
        <jsp:param name="toolDescription" value="Solve any quadratic equation step by step using the quadratic formula, completing the square, or factoring. Free calculator with interactive parabola graph." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="quadratic-solver.jsp" />
        <jsp:param name="toolKeywords" value="quadratic equation solver, quadratic formula calculator, quadratic equation calculator, solve quadratic equation step by step, completing the square calculator, factoring quadratics calculator, vertex form calculator, quadratic inequality solver, discriminant calculator, parabola graph calculator, complex roots calculator, quadratic formula with steps free" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Solve quadratic equations step by step,Standard vertex and factored form input,Quadratic formula method,Completing the square method,Factoring method,Quadratic inequality solver with interval notation,Interactive Plotly parabola graph,Discriminant analysis and root classification,Built-in Python SymPy compiler,LaTeX export and shareable URLs,Live KaTeX equation preview,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is the quadratic formula and how do you use it?" />
        <jsp:param name="faq1a" value="The quadratic formula is x = (-b +/- sqrt(b^2 - 4ac)) / 2a. It solves any quadratic equation ax^2 + bx + c = 0. Enter your coefficients a, b, and c into this calculator and click Solve to see every substitution step, discriminant calculation, and final roots. Works for real, repeated, and complex roots." />
        <jsp:param name="faq2q" value="How do you find the discriminant of a quadratic equation?" />
        <jsp:param name="faq2a" value="The discriminant is Delta = b^2 - 4ac, the expression under the square root in the quadratic formula. If Delta > 0, the equation has two distinct real roots. If Delta = 0, it has one repeated root (the parabola touches the x-axis). If Delta < 0, it has two complex conjugate roots. This calculator computes it automatically." />
        <jsp:param name="faq3q" value="How do you solve a quadratic equation by completing the square?" />
        <jsp:param name="faq3a" value="Completing the square rewrites ax^2 + bx + c = 0 as a(x - h)^2 + k = 0, then solves by taking the square root. Steps: divide by a, move the constant, add (b/2a)^2 to both sides, factor the left side as a perfect square, then take the square root. This calculator shows every step with formatted math." />
        <jsp:param name="faq4q" value="How do you solve quadratic inequalities with interval notation?" />
        <jsp:param name="faq4a" value="Select the Inequality form, enter a, b, c and choose an operator (>, <, >=, <=). The solver finds the roots, determines where the parabola is above or below zero using a sign chart, and writes the answer in interval notation. For example, x^2 - 5x + 6 < 0 gives x in (2, 3)." />
        <jsp:param name="faq5q" value="Is this quadratic equation calculator really free?" />
        <jsp:param name="faq5a" value="Yes, 100% free with no signup or limits. You get 3 solving methods with step-by-step solutions, an interactive parabola graph, inequality solving, a Python SymPy compiler, LaTeX export, and shareable URLs. All computation runs in your browser — nothing is sent to a server." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/quadratic-solver.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <style>
        .tool-action-btn { background: var(--qs-gradient) !important; }
        .tool-badge { background: var(--qs-light); color: var(--qs-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Quadratic Equation Solver</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/index.jsp#mathematics">Mathematics</a> /
                Quadratic Equation Solver
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">4 Forms</span>
            <span class="tool-badge">Step-by-Step</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--qs-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>quadratic equation solver</strong> with <strong>step-by-step solutions</strong>. Solve in <strong>standard, vertex, and factored forms</strong>. Uses the <strong>quadratic formula</strong>, <strong>completing the square</strong>, and <strong>factoring</strong>. Interactive parabola graph, inequality solver with interval notation, and built-in Python compiler.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--qs-gradient);">Quadratic Equation</div>
            <div class="tool-card-body">

                <!-- Form Type Toggle -->
                <div class="tool-form-group" style="margin-bottom:0.5rem;">
                    <label class="tool-form-label">Equation Form</label>
                    <div class="qs-form-toggle">
                        <button type="button" class="qs-form-btn active" data-type="standard">Standard</button>
                        <button type="button" class="qs-form-btn" data-type="vertex">Vertex</button>
                        <button type="button" class="qs-form-btn" data-type="factored">Factored</button>
                        <button type="button" class="qs-form-btn" data-type="inequality">Inequality</button>
                    </div>
                    <div class="tool-form-hint" id="qs-form-hint">ax&sup2; + bx + c = 0</div>
                </div>

                <!-- Standard Form -->
                <div id="qs-form-standard">
                    <div class="qs-coeff-row">
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">a (x&sup2;)</label>
                            <input type="number" id="qs-coeff-a" class="qs-coeff-input" value="1" step="any">
                        </div>
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">b (x)</label>
                            <input type="number" id="qs-coeff-b" class="qs-coeff-input" value="5" step="any">
                        </div>
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">c</label>
                            <input type="number" id="qs-coeff-c" class="qs-coeff-input" value="6" step="any">
                        </div>
                    </div>
                </div>

                <!-- Vertex Form -->
                <div id="qs-form-vertex" style="display:none;">
                    <div class="qs-coeff-row">
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">a</label>
                            <input type="number" id="qs-vertex-a" class="qs-coeff-input" value="2" step="any">
                        </div>
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">h</label>
                            <input type="number" id="qs-vertex-h" class="qs-coeff-input" value="3" step="any">
                        </div>
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">k</label>
                            <input type="number" id="qs-vertex-k" class="qs-coeff-input" value="-8" step="any">
                        </div>
                    </div>
                </div>

                <!-- Factored Form -->
                <div id="qs-form-factored" style="display:none;">
                    <div class="qs-coeff-row">
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">a</label>
                            <input type="number" id="qs-factor-a" class="qs-coeff-input" value="1" step="any">
                        </div>
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">r&#8321;</label>
                            <input type="number" id="qs-factor-r1" class="qs-coeff-input" value="-2" step="any">
                        </div>
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">r&#8322;</label>
                            <input type="number" id="qs-factor-r2" class="qs-coeff-input" value="-3" step="any">
                        </div>
                    </div>
                </div>

                <!-- Inequality Form -->
                <div id="qs-form-inequality" style="display:none;">
                    <div class="qs-coeff-row">
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">a (x&sup2;)</label>
                            <input type="number" id="qs-ineq-a" class="qs-coeff-input" value="1" step="any">
                        </div>
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">b (x)</label>
                            <input type="number" id="qs-ineq-b" class="qs-coeff-input" value="-5" step="any">
                        </div>
                        <div class="qs-coeff-group">
                            <label class="qs-coeff-label">c</label>
                            <input type="number" id="qs-ineq-c" class="qs-coeff-input" value="6" step="any">
                        </div>
                    </div>
                    <div class="tool-form-group" style="margin-top:0.5rem;">
                        <label class="tool-form-label" for="qs-ineq-op">Operator</label>
                        <select id="qs-ineq-op" class="qs-method-select">
                            <option value=">">Greater than (&gt;)</option>
                            <option value="<">Less than (&lt;)</option>
                            <option value=">=">Greater or equal (&ge;)</option>
                            <option value="<=">Less or equal (&le;)</option>
                        </select>
                    </div>
                </div>

                <!-- Live Preview -->
                <div class="tool-form-group" style="margin-top:0.75rem;">
                    <label class="tool-form-label">Equation Preview</label>
                    <div class="qs-preview" id="qs-preview"></div>
                </div>

                <!-- Method Selector -->
                <div class="tool-form-group" id="qs-method-group">
                    <label class="tool-form-label" for="qs-method">Solution Method</label>
                    <select class="qs-method-select" id="qs-method">
                        <option value="all">Show All Methods</option>
                        <option value="formula">Quadratic Formula</option>
                        <option value="completing">Completing the Square</option>
                        <option value="factoring">Factoring</option>
                    </select>
                </div>

                <!-- Action Buttons -->
                <div style="display:flex;gap:0.5rem;">
                    <button type="button" class="tool-action-btn" id="qs-solve-btn" style="flex:1">Solve Equation</button>
                    <button type="button" class="tool-action-btn" id="qs-clear-btn" style="flex:0;min-width:60px;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Clear</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Quick Examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="qs-examples">
                        <button type="button" class="qs-example-chip" data-example="perfect-square">Perfect Square</button>
                        <button type="button" class="qs-example-chip" data-example="two-roots">Two Roots</button>
                        <button type="button" class="qs-example-chip" data-example="complex">Complex</button>
                        <button type="button" class="qs-example-chip" data-example="difference-squares">x&sup2;&minus;16</button>
                        <button type="button" class="qs-example-chip" data-example="vertex-form">Vertex Form</button>
                        <button type="button" class="qs-example-chip" data-example="inequality">Inequality</button>
                        <button type="button" class="qs-example-chip" data-example="random">Random</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="qs-output-tabs">
            <button type="button" class="qs-output-tab active" data-panel="result">Result</button>
            <button type="button" class="qs-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="qs-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="qs-panel active" id="qs-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--qs-tool);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="qs-result-content">
                    <div class="tool-empty-state" id="qs-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">ax&sup2;+bx+c</div>
                        <h3>Enter a quadratic equation</h3>
                        <p>Solve with 3 methods. Step-by-step solutions, interactive graph, Python code.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="qs-result-actions" style="display:none;gap:0.5rem;padding:1rem;border-top:1px solid var(--border);flex-wrap:wrap">
                    <button type="button" class="tool-action-btn" id="qs-copy-latex-btn">Copy LaTeX</button>
                    <button type="button" class="tool-action-btn" id="qs-share-btn">Share</button>
                </div>
            </div>
            <div id="qs-steps-area" style="margin-top:1rem"></div>
        </div>

        <!-- Graph Panel -->
        <div class="qs-panel" id="qs-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--qs-tool);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>Parabola Graph</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="qs-graph-container"></div>
                    <p id="qs-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve an equation to see the parabola with vertex, roots, and axis of symmetry.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="qs-panel" id="qs-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--qs-tool);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                    <select id="qs-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                        <option value="sympy-solve">SymPy (Symbolic Solver)</option>
                        <option value="numpy-plot">NumPy (Numeric Analysis)</option>
                        <option value="sympy-steps">SymPy (Step-by-Step)</option>
                    </select>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="qs-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="quadratic-solver.jsp"/>
    <jsp:param name="keyword" value="mathematics"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- ===== 1. WHAT IS A QUADRATIC EQUATION? ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">What is a Quadratic Equation?</h2>
        <p class="qs-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            A <strong>quadratic equation</strong> is a polynomial equation of degree 2, written as <strong style="color:var(--qs-tool);">ax&sup2; + bx + c = 0</strong> where a &ne; 0. The graph of a quadratic function is a <strong>parabola</strong> &mdash; a U-shaped curve that opens upward (when a &gt; 0) or downward (when a &lt; 0).
        </p>

        <!-- ax^2 + bx + c Animated Breakdown -->
        <div class="qs-concept-hero">
            <div class="qs-concept-block">
                <div class="qs-concept-symbol qs-c-a">ax&sup2;</div>
                <div class="qs-concept-label qs-c-a">Quadratic Term</div>
            </div>
            <div class="qs-concept-block">
                <div class="qs-concept-symbol qs-c-eq">+</div>
            </div>
            <div class="qs-concept-block">
                <div class="qs-concept-symbol qs-c-b">bx</div>
                <div class="qs-concept-label qs-c-b">Linear Term</div>
            </div>
            <div class="qs-concept-block">
                <div class="qs-concept-symbol qs-c-eq">+</div>
            </div>
            <div class="qs-concept-block">
                <div class="qs-concept-symbol qs-c-c">c</div>
                <div class="qs-concept-label qs-c-c">Constant</div>
            </div>
        </div>

        <div class="qs-callout qs-callout-insight qs-anim qs-anim-d2">
            <span class="qs-callout-icon">&#128161;</span>
            <div class="qs-callout-text">
                <strong>The coefficient &ldquo;a&rdquo; controls everything:</strong>
                If <strong>a &gt; 0</strong>, the parabola opens upward (has a minimum). If <strong>a &lt; 0</strong>, it opens downward (has a maximum). The larger |a|, the narrower the parabola. The vertex (turning point) is always at <span style="font-family:var(--font-mono);color:var(--qs-tool);">x = -b/2a</span>.
            </div>
        </div>
    </div>

    <!-- ===== 2. THE DISCRIMINANT ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">The Discriminant: How Many Solutions?</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.5rem;">
            The <strong>discriminant</strong> &Delta; = b&sup2; &minus; 4ac tells you immediately what kind of roots to expect. It&rsquo;s the expression under the square root in the quadratic formula.
        </p>

        <div class="qs-disc-viz">
            <!-- Two Real Roots -->
            <div class="qs-disc-card qs-anim qs-anim-d1">
                <div class="qs-disc-canvas">
                    <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg" style="width:100%;height:100%;">
                        <line x1="10" y1="140" x2="190" y2="140" stroke="var(--border)" stroke-width="1"/>
                        <line x1="100" y1="10" x2="100" y2="190" stroke="var(--border)" stroke-width="0.5"/>
                        <!-- Parabola: y = 0.02(x-100)^2 - 40 scaled -->
                        <path d="M 30,160 Q 60,40 100,20 Q 140,40 170,160" fill="none" stroke="#7c3aed" stroke-width="2.5" stroke-linecap="round" class="qs-disc-draw"/>
                        <!-- Root dots on x-axis -->
                        <circle cx="55" cy="140" r="5" fill="#ef4444" opacity="0.9"/>
                        <circle cx="145" cy="140" r="5" fill="#ef4444" opacity="0.9"/>
                        <!-- Vertex -->
                        <circle cx="100" cy="20" r="4" fill="#10b981"/>
                        <text x="50" y="158" font-size="10" fill="#ef4444" font-weight="600" font-family="monospace">x&#8321;</text>
                        <text x="140" y="158" font-size="10" fill="#ef4444" font-weight="600" font-family="monospace">x&#8322;</text>
                    </svg>
                </div>
                <div class="qs-disc-info" style="border-left:3px solid #7c3aed;">
                    <div class="qs-disc-title">&Delta; &gt; 0: Two Real Roots</div>
                    <div class="qs-disc-desc">Parabola crosses the x-axis at two points.</div>
                </div>
            </div>

            <!-- One Repeated Root -->
            <div class="qs-disc-card qs-anim qs-anim-d3">
                <div class="qs-disc-canvas">
                    <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg" style="width:100%;height:100%;">
                        <line x1="10" y1="140" x2="190" y2="140" stroke="var(--border)" stroke-width="1"/>
                        <line x1="100" y1="10" x2="100" y2="190" stroke="var(--border)" stroke-width="0.5"/>
                        <!-- Parabola touching x-axis -->
                        <path d="M 30,160 Q 60,80 100,140 Q 140,80 170,160" fill="none" stroke="#7c3aed" stroke-width="2.5" stroke-linecap="round" class="qs-disc-draw"/>
                        <!-- Single tangent point -->
                        <circle cx="100" cy="140" r="5" fill="#f59e0b" opacity="0.9"/>
                        <text x="88" y="158" font-size="10" fill="#f59e0b" font-weight="600" font-family="monospace">x</text>
                    </svg>
                </div>
                <div class="qs-disc-info" style="border-left:3px solid #f59e0b;">
                    <div class="qs-disc-title">&Delta; = 0: One Root</div>
                    <div class="qs-disc-desc">Parabola touches the x-axis at its vertex.</div>
                </div>
            </div>

            <!-- Complex Roots -->
            <div class="qs-disc-card qs-anim qs-anim-d5">
                <div class="qs-disc-canvas">
                    <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg" style="width:100%;height:100%;">
                        <line x1="10" y1="140" x2="190" y2="140" stroke="var(--border)" stroke-width="1"/>
                        <line x1="100" y1="10" x2="100" y2="190" stroke="var(--border)" stroke-width="0.5"/>
                        <!-- Parabola above x-axis -->
                        <path d="M 30,120 Q 60,40 100,30 Q 140,40 170,120" fill="none" stroke="#7c3aed" stroke-width="2.5" stroke-linecap="round" class="qs-disc-draw"/>
                        <!-- No intersection indicator -->
                        <text x="60" y="148" font-size="9" fill="var(--text-muted)" font-family="sans-serif">no real intersection</text>
                    </svg>
                </div>
                <div class="qs-disc-info" style="border-left:3px solid #3b82f6;">
                    <div class="qs-disc-title">&Delta; &lt; 0: Complex Roots</div>
                    <div class="qs-disc-desc">Parabola doesn&rsquo;t cross the x-axis.</div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== 3. REAL-WORLD EXAMPLE ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">Real-World Example: Projectile Motion</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0;">
            A ball is thrown upward from a 5-meter ledge with an initial velocity of 20 m/s. When does it hit the ground?
        </p>

        <div class="qs-real-world">
            <div class="qs-rw-header">&#127936; Setting Up the Equation</div>
            <div class="qs-rw-body">
                <div>
                    <p style="margin-bottom:0.75rem;">Height equation: <span style="font-family:var(--font-mono);color:var(--qs-tool);">h(t) = -4.9t&sup2; + 20t + 5</span></p>
                    <p style="margin-bottom:0.5rem;">When h = 0 (hits ground):</p>
                    <p style="font-family:var(--font-mono);color:var(--qs-tool);margin-bottom:0.5rem;">-4.9t&sup2; + 20t + 5 = 0</p>
                    <p style="font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">a = -4.9, b = 20, c = 5</p>
                </div>
                <div style="text-align:center;padding:0.75rem;background:var(--bg-primary);border:1px solid var(--border);border-radius:0.5rem;">
                    <div style="font-family:var(--font-mono);font-size:0.8125rem;color:var(--qs-tool);font-weight:600;margin-bottom:0.5rem;">
                        &Delta; = 20&sup2; &minus; 4(&minus;4.9)(5) = 498
                    </div>
                    <div style="color:#10b981;font-weight:700;font-size:0.9375rem;">
                        t &approx; 4.33 seconds
                    </div>
                    <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.25rem;">(negative root t &approx; -0.24 is rejected)</div>
                </div>
            </div>
        </div>

        <div class="qs-callout qs-callout-tip">
            <span class="qs-callout-icon">&#128073;</span>
            <div class="qs-callout-text">
                <strong>Try it!</strong> Enter a = -4.9, b = 20, c = 5 in the solver above to see the full step-by-step solution and parabola graph showing the trajectory.
            </div>
        </div>
    </div>

    <!-- ===== 4. METHODS COMPARISON ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Solution Methods Comparison</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            All three methods solve the same equation &mdash; they differ in approach and when they work best.
        </p>
        <table class="qs-methods-table">
            <thead>
                <tr><th>Method</th><th>Best For</th><th>Key Idea</th></tr>
            </thead>
            <tbody>
                <tr><td style="font-weight:500;">Quadratic Formula</td><td>Always works</td><td>x = (-b &pm; &radic;(b&sup2;-4ac)) / 2a &mdash; direct substitution</td></tr>
                <tr><td style="font-weight:500;">Completing the Square</td><td>Deriving vertex form</td><td>Rewrite as perfect square (x-h)&sup2; = k, then take square root</td></tr>
                <tr><td style="font-weight:500;">Factoring</td><td>Integer/rational roots</td><td>Find factors that multiply to ac and add to b</td></tr>
            </tbody>
        </table>
    </div>

    <!-- ===== 5. ANATOMY OF A PARABOLA ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Properties of Quadratic Functions</h2>
        <div class="qs-edu-grid">
            <div class="qs-edu-card qs-anim qs-anim-d1" style="border-left:3px solid #7c3aed;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#7c3aed;">&#9679;</span> Vertex</h4>
                <p>The turning point at <strong>(h, k)</strong> where h = -b/2a and k = f(h). It&rsquo;s the minimum (a &gt; 0) or maximum (a &lt; 0) value of the function.</p>
            </div>
            <div class="qs-edu-card qs-anim qs-anim-d2" style="border-left:3px solid #ef4444;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#ef4444;">&#9679;</span> Roots / Zeros</h4>
                <p>The x-values where f(x) = 0. A quadratic has 0, 1, or 2 real roots depending on the discriminant. These are where the parabola crosses the x-axis.</p>
            </div>
            <div class="qs-edu-card qs-anim qs-anim-d3" style="border-left:3px solid #10b981;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#10b981;">&#9679;</span> Axis of Symmetry</h4>
                <p>The vertical line <strong>x = -b/2a</strong> that passes through the vertex. The parabola is symmetric about this line.</p>
            </div>
            <div class="qs-edu-card qs-anim qs-anim-d4" style="border-left:3px solid #f59e0b;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#f59e0b;">&#9679;</span> Y-intercept</h4>
                <p>The point where the parabola crosses the y-axis, always at <strong>(0, c)</strong>. This is the constant term in standard form.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I solve a quadratic equation using the quadratic formula?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Enter coefficients a, b, and c from your equation ax&sup2;+bx+c=0, then click Solve. The calculator applies the quadratic formula x = (-b &pm; &radic;(b&sup2;-4ac)) / 2a, showing every substitution and simplification step. It handles real roots, repeated roots, and complex roots automatically.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What does the discriminant tell you about a quadratic equation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The discriminant &Delta; = b&sup2; &minus; 4ac determines the nature of roots. If &Delta; &gt; 0, there are two distinct real roots. If &Delta; = 0, there is exactly one repeated real root (the parabola just touches the x-axis). If &Delta; &lt; 0, there are two complex conjugate roots (the parabola doesn&rsquo;t cross the x-axis).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can this calculator solve quadratic inequalities?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes. Select the Inequality form, enter coefficients a, b, c and choose an operator (&gt;, &lt;, &ge;, &le;). The solver finds roots, analyzes the sign chart, and provides the solution in interval notation. For example, x&sup2;&minus;5x+6 &lt; 0 gives x &isin; (2, 3). The graph shows the solution region shaded.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I convert between standard, vertex, and factored forms?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Enter your equation in any form and the solver converts it to standard form ax&sup2;+bx+c=0 automatically. Vertex form a(x-h)&sup2;+k uses vertex coordinates. Factored form a(x-r&#8321;)(x-r&#8322;) uses the roots directly. The solution always shows the vertex form conversion and all key properties.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this quadratic equation solver free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, completely free with no signup. You get 3 solving methods with step-by-step solutions, an interactive Plotly parabola graph, inequality solving with interval notation, a Python SymPy compiler, LaTeX export, and shareable URLs. All computation runs entirely in your browser for instant results and privacy.</div>
        </div>
    </div>
</section>

<!-- Explore More Math -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            Explore More Math Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/linear-equations-solver.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#4f46e5,#6366f1);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">Ax</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">System of Equations</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Solve linear systems with 6 methods and interactive graphs</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/integral-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#4f46e5,#6366f1);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;color:#fff;">&#8747;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Integral Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Step-by-step integration with graphs and PDF export</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/logarithm-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#0d9488,#14b8a6);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;">log</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Logarithm Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Solve, expand, condense log equations with steps</p>
                </div>
            </a>
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
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<!-- Scroll-triggered animations -->
<script>
(function(){
    var els = document.querySelectorAll('.qs-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        els.forEach(function(el){ el.classList.add('qs-visible'); });
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        entries.forEach(function(e){
            if (e.isIntersecting) {
                e.target.classList.add('qs-visible');
                obs.unobserve(e.target);
            }
        });
    }, { threshold: 0.15 });
    els.forEach(function(el){ obs.observe(el); });
})();
</script>

<!-- Core Scripts -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/quadratic-solver-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/quadratic-solver-graph.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/quadratic-solver-export.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/quadratic-solver-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
