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
        <jsp:param name="toolName" value="Taylor & Maclaurin Series Calculator - Free with Steps" />
        <jsp:param name="toolDescription" value="Free Taylor series calculator with step-by-step derivatives. Expand any function as a Maclaurin or Taylor series. Interactive graph shows convergence in real time." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="series-calculator.jsp" />
        <jsp:param name="toolKeywords" value="taylor series calculator, maclaurin series calculator, taylor series expansion calculator, power series calculator, taylor polynomial calculator, radius of convergence calculator, maclaurin series formula, series approximation calculator, step by step taylor series, function series expansion online free" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Taylor series expansion around any point,Maclaurin series centered at zero,Step-by-step derivative calculations with KaTeX,Interactive Plotly convergence graph,Term slider for real-time approximation,Radius of convergence analysis,Built-in Python SymPy compiler,LaTeX export and shareable URLs,7 common function presets,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a Taylor series in simple terms?" />
        <jsp:param name="faq1a" value="A Taylor series rewrites any smooth function as an infinite polynomial by using the function's derivatives at a single point. The formula is f(x) = sum of f^(n)(a)/n! times (x-a)^n. When the center is a=0 it is called a Maclaurin series. This calculator computes each derivative step by step and assembles the polynomial automatically." />
        <jsp:param name="faq2q" value="What is the Taylor series of e^x, sin(x), and cos(x)?" />
        <jsp:param name="faq2a" value="The three most important Maclaurin series are: e^x = 1 + x + x^2/2! + x^3/3! + ..., sin(x) = x - x^3/3! + x^5/5! - ..., and cos(x) = 1 - x^2/2! + x^4/4! - ... All three converge for every real number (radius of convergence R = infinity). Enter any of these functions and click Calculate to see the full derivation." />
        <jsp:param name="faq3q" value="How do you find the radius of convergence of a Taylor series?" />
        <jsp:param name="faq3a" value="Use the ratio test: R = lim |a_n / a_(n+1)| as n approaches infinity. The series converges for |x-a| less than R and diverges beyond. Common results: e^x and trig functions have R = infinity, ln(1+x) has R = 1, 1/(1-x) has R = 1. This calculator shows the convergence interval for every function." />
        <jsp:param name="faq4q" value="How many terms do you need for a good Taylor approximation?" />
        <jsp:param name="faq4a" value="It depends on the function and distance from the center point. Near the center, 5 to 7 terms often give 6+ digits of accuracy. Farther away or for functions with small convergence radius you may need 15 to 20 terms. Use the interactive graph with the term slider to see exactly how the approximation improves." />
        <jsp:param name="faq5q" value="Is this Taylor series calculator really free?" />
        <jsp:param name="faq5a" value="Yes, 100 percent free with no signup or limits. Features include step-by-step derivative calculations, interactive Plotly convergence graph with term slider, radius of convergence analysis, a Python SymPy compiler, LaTeX copy, and shareable URLs. All computation runs in your browser with no server calls." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/series-calculator.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <style>
        .tool-action-btn { background: var(--sc-gradient) !important; }
        .tool-badge { background: var(--sc-light); color: var(--sc-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Taylor & Maclaurin Series Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                Series Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">Up to 20 Terms</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--sc-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>Taylor and Maclaurin series calculator</strong> with <strong>step-by-step derivative solutions</strong>. Expand any function into a <strong>power series</strong> around any point. Interactive convergence graph, <strong>radius of convergence</strong> analysis, and built-in Python compiler.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--sc-gradient);">Series Expansion</div>
            <div class="tool-card-body">

                <!-- Series Type Toggle -->
                <div class="tool-form-group" style="margin-bottom:0.5rem;">
                    <label class="tool-form-label">Series Type</label>
                    <div class="sc-type-toggle">
                        <button type="button" class="sc-type-btn active" data-type="maclaurin">Maclaurin (a=0)</button>
                        <button type="button" class="sc-type-btn" data-type="taylor">Taylor (custom a)</button>
                    </div>
                </div>

                <!-- Function Input -->
                <div class="tool-form-group">
                    <label class="tool-form-label" for="sc-func-input">Function f(x)</label>
                    <input type="text" class="sc-func-input" id="sc-func-input" placeholder="e.g., e^x, sin(x), cos(x), ln(1+x)" value="e^x">
                    <!-- Function Palette -->
                    <div class="sc-func-palette" id="sc-func-palette">
                        <button type="button" class="sc-palette-btn" data-insert="sin(" title="sine">sin</button>
                        <button type="button" class="sc-palette-btn" data-insert="cos(" title="cosine">cos</button>
                        <button type="button" class="sc-palette-btn" data-insert="tan(" title="tangent">tan</button>
                        <button type="button" class="sc-palette-btn" data-insert="e^(" title="exponential">e<sup>x</sup></button>
                        <button type="button" class="sc-palette-btn" data-insert="ln(" title="natural log">ln</button>
                        <button type="button" class="sc-palette-btn" data-insert="log(" title="logarithm">log</button>
                        <button type="button" class="sc-palette-btn" data-insert="sqrt(" title="square root">&radic;</button>
                        <button type="button" class="sc-palette-btn" data-insert="^" title="power">x<sup>n</sup></button>
                        <button type="button" class="sc-palette-btn" data-insert="pi" title="pi">&pi;</button>
                        <button type="button" class="sc-palette-btn" data-insert="(" title="open paren">(</button>
                        <button type="button" class="sc-palette-btn" data-insert=")" title="close paren">)</button>
                        <button type="button" class="sc-palette-btn" data-insert="1/(" title="reciprocal">1/x</button>
                    </div>
                    <div class="tool-form-hint">Click buttons above or type directly. Use ^ for powers, e.g. x^2</div>
                </div>

                <!-- Parameters -->
                <div class="sc-param-row">
                    <div class="sc-param-group" id="sc-center-group" style="display:none;">
                        <label class="sc-param-label" for="sc-center-point">Center (a)</label>
                        <input type="text" class="sc-param-input" id="sc-center-point" placeholder="e.g., 0, 1, pi" value="0">
                    </div>
                    <div class="sc-param-group">
                        <label class="sc-param-label" for="sc-num-terms">Terms (n)</label>
                        <input type="number" class="sc-param-input" id="sc-num-terms" min="1" max="20" value="5">
                    </div>
                </div>

                <!-- Live Preview -->
                <div class="tool-form-group" style="margin-top:0.75rem;">
                    <label class="tool-form-label">Series Preview</label>
                    <div class="sc-preview" id="sc-preview"></div>
                </div>

                <!-- Action Buttons -->
                <div style="display:flex;gap:0.5rem;">
                    <button type="button" class="tool-action-btn" id="sc-solve-btn" style="flex:1">Calculate Series</button>
                    <button type="button" class="tool-action-btn" id="sc-clear-btn" style="flex:0;min-width:60px;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Clear</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Quick Examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="sc-examples">
                        <button type="button" class="sc-example-chip" data-example="exp">e^x</button>
                        <button type="button" class="sc-example-chip" data-example="sin">sin(x)</button>
                        <button type="button" class="sc-example-chip" data-example="cos">cos(x)</button>
                        <button type="button" class="sc-example-chip" data-example="ln">ln(1+x)</button>
                        <button type="button" class="sc-example-chip" data-example="geo">1/(1-x)</button>
                        <button type="button" class="sc-example-chip" data-example="sqrt">&radic;(1+x)</button>
                        <button type="button" class="sc-example-chip" data-example="tan">tan(x)</button>
                        <button type="button" class="sc-example-chip" data-example="taylor">sin(x) @ &pi;</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="sc-output-tabs">
            <button type="button" class="sc-output-tab active" data-panel="result">Result</button>
            <button type="button" class="sc-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="sc-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="sc-panel active" id="sc-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--sc-tool);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Series Expansion</h4>
                </div>
                <div class="tool-result-content" id="sc-result-content">
                    <div class="tool-empty-state" id="sc-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&Sigma;</div>
                        <h3>Enter a function</h3>
                        <p>Calculate Taylor or Maclaurin series expansion with step-by-step solutions.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="sc-result-actions" style="display:none;gap:0.5rem;padding:1rem;border-top:1px solid var(--border);flex-wrap:wrap">
                    <button type="button" class="tool-action-btn" id="sc-copy-latex-btn">Copy LaTeX</button>
                    <button type="button" class="tool-action-btn" id="sc-share-btn">Share</button>
                </div>
            </div>

            <div id="sc-steps-area" style="margin-top:1rem"></div>
            <div id="sc-convergence-area" style="margin-top:0.5rem"></div>
        </div>

        <!-- Graph Panel -->
        <div class="sc-panel" id="sc-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--sc-tool);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>Convergence Graph</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="sc-graph-container"></div>
                    <p id="sc-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Calculate a series to see the function vs approximation graph.</p>

                    <!-- Term Slider -->
                    <div class="sc-slider-group">
                        <span class="sc-slider-label">Terms:</span>
                        <input type="range" class="sc-slider" id="sc-term-slider" min="1" max="20" value="5">
                        <span class="sc-slider-value" id="sc-term-slider-value">5</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="sc-panel" id="sc-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--sc-tool);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                    <select id="sc-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                        <option value="sympy-series">SymPy (Series Expansion)</option>
                        <option value="numpy-approx">NumPy (Numeric Approx)</option>
                        <option value="sympy-convergence">SymPy (Convergence)</option>
                    </select>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="sc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
    <jsp:param name="currentToolUrl" value="series-calculator.jsp"/>
    <jsp:param name="keyword" value="calculus"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- ===== 1. WHAT IS A TAYLOR SERIES? ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">What is a Taylor Series?</h2>
        <p class="sc-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            A <strong>Taylor series</strong> represents a function as an infinite sum of polynomial terms calculated from the function's <strong>derivatives at a single point</strong>. It is one of the most powerful tools in calculus &mdash; enabling us to approximate complex functions like sin(x), e<sup>x</sup>, and ln(x) using simple polynomials.
        </p>

        <!-- Taylor Series Formula Breakdown -->
        <div class="sc-concept-hero">
            <div class="sc-concept-block">
                <div class="sc-concept-symbol sc-c-fn">f(x)</div>
                <div class="sc-concept-label sc-c-fn">Function</div>
            </div>
            <div class="sc-concept-block">
                <div class="sc-concept-symbol sc-c-eq">=</div>
            </div>
            <div class="sc-concept-block">
                <div class="sc-concept-symbol sc-c-eq">&Sigma;</div>
            </div>
            <div class="sc-concept-block">
                <div class="sc-concept-symbol sc-c-deriv">f<sup>(n)</sup>(a)</div>
                <div class="sc-concept-label sc-c-deriv">nth Derivative</div>
            </div>
            <div class="sc-concept-block">
                <div class="sc-concept-symbol sc-c-eq">/</div>
            </div>
            <div class="sc-concept-block">
                <div class="sc-concept-symbol sc-c-fact">n!</div>
                <div class="sc-concept-label sc-c-fact">Factorial</div>
            </div>
            <div class="sc-concept-block">
                <div class="sc-concept-symbol sc-c-eq">&middot;</div>
            </div>
            <div class="sc-concept-block">
                <div class="sc-concept-symbol sc-c-power">(x&minus;a)<sup>n</sup></div>
                <div class="sc-concept-label sc-c-power">Power Term</div>
            </div>
        </div>

        <div class="sc-callout sc-callout-insight sc-anim sc-anim-d2">
            <span class="sc-callout-icon">&#128161;</span>
            <div class="sc-callout-text">
                <strong>Why does it work?</strong>
                Each term matches one more derivative of the original function at the center point. With enough terms, the polynomial approximation becomes indistinguishable from the original function &mdash; at least within the <strong>radius of convergence</strong>.
            </div>
        </div>
    </div>

    <!-- ===== 2. COMMON SERIES ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Common Maclaurin Series</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.5rem;">
            These series are used so frequently in mathematics and physics that they are worth memorizing.
        </p>

        <div class="sc-series-grid">
            <div class="sc-series-card sc-anim sc-anim-d1" style="border-left-color:#2563eb;">
                <h4><span style="color:#2563eb;">&#9679;</span> Exponential</h4>
                <p>e<sup>x</sup> = 1 + x + x&sup2;/2! + x&sup3;/3! + &hellip;</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = &infin;</p>
            </div>
            <div class="sc-series-card sc-anim sc-anim-d2" style="border-left-color:#dc2626;">
                <h4><span style="color:#dc2626;">&#9679;</span> Sine</h4>
                <p>sin(x) = x &minus; x&sup3;/3! + x<sup>5</sup>/5! &minus; &hellip;</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = &infin;</p>
            </div>
            <div class="sc-series-card sc-anim sc-anim-d3" style="border-left-color:#059669;">
                <h4><span style="color:#059669;">&#9679;</span> Cosine</h4>
                <p>cos(x) = 1 &minus; x&sup2;/2! + x<sup>4</sup>/4! &minus; &hellip;</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = &infin;</p>
            </div>
            <div class="sc-series-card sc-anim sc-anim-d4" style="border-left-color:#d97706;">
                <h4><span style="color:#d97706;">&#9679;</span> Natural Log</h4>
                <p>ln(1+x) = x &minus; x&sup2;/2 + x&sup3;/3 &minus; &hellip;</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = 1</p>
            </div>
            <div class="sc-series-card sc-anim sc-anim-d5" style="border-left-color:#7c3aed;">
                <h4><span style="color:#7c3aed;">&#9679;</span> Geometric</h4>
                <p>1/(1&minus;x) = 1 + x + x&sup2; + x&sup3; + &hellip;</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = 1</p>
            </div>
            <div class="sc-series-card sc-anim sc-anim-d5" style="border-left-color:#0891b2;">
                <h4><span style="color:#0891b2;">&#9679;</span> Square Root</h4>
                <p>&radic;(1+x) = 1 + x/2 &minus; x&sup2;/8 + &hellip;</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;margin-top:0.25rem;">R = 1</p>
            </div>
        </div>
    </div>

    <!-- ===== 3. CONVERGENCE EXPLAINED ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">Understanding Convergence</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:1rem;">
            Not every Taylor series converges everywhere. The <strong>radius of convergence R</strong> tells you how far from the center point the series reliably approximates the function.
        </p>

        <div class="sc-edu-grid">
            <div class="sc-edu-card sc-anim sc-anim-d1" style="border-left:3px solid #22c55e;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#22c55e;">&#9679;</span> R = &infin;</h4>
                <p>Functions like e<sup>x</sup>, sin(x), and cos(x) converge for all real x. Their series approximation works everywhere.</p>
            </div>
            <div class="sc-edu-card sc-anim sc-anim-d2" style="border-left:3px solid #f59e0b;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#f59e0b;">&#9679;</span> Finite R</h4>
                <p>Functions like ln(1+x) and 1/(1&minus;x) only converge within a limited interval around the center. Beyond that, the series diverges.</p>
            </div>
            <div class="sc-edu-card sc-anim sc-anim-d3" style="border-left:3px solid #ef4444;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#ef4444;">&#9679;</span> Singularities</h4>
                <p>The radius of convergence equals the distance to the nearest singularity (point where the function is undefined), even in the complex plane.</p>
            </div>
        </div>

        <div class="sc-callout sc-callout-tip sc-anim sc-anim-d4">
            <span class="sc-callout-icon">&#128073;</span>
            <div class="sc-callout-text">
                <strong>Try it!</strong> Enter <code style="background:var(--bg-tertiary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-size:0.8125rem;">ln(1+x)</code> and increase terms to 15. Watch how the graph matches well for |x| &lt; 1 but diverges wildly beyond x = 1.
            </div>
        </div>
    </div>

    <!-- ===== 4. REAL-WORLD APPLICATIONS ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Real-World Applications</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            Taylor series aren&rsquo;t just theoretical &mdash; they power real technology and science every day.
        </p>
        <div class="sc-edu-grid">
            <div class="sc-edu-card" style="border-left:3px solid #2563eb;">
                <h4>Calculator Chips</h4>
                <p>Your calculator computes sin(x) and cos(x) using polynomial approximations derived from Taylor series. Hardware implements these as fast multiplications and additions.</p>
            </div>
            <div class="sc-edu-card" style="border-left:3px solid #7c3aed;">
                <h4>Physics Approximations</h4>
                <p>sin(&theta;) &approx; &theta; for small angles simplifies pendulum equations. Many physics formulas are first-order Taylor approximations.</p>
            </div>
            <div class="sc-edu-card" style="border-left:3px solid #059669;">
                <h4>Machine Learning</h4>
                <p>Gradient descent uses first-order Taylor approximation. Newton&rsquo;s method uses second-order. Higher-order optimization uses more terms.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between Taylor and Maclaurin series?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A Taylor series expands a function f(x) around any point a: f(x) = &Sigma; f<sup>(n)</sup>(a)/n! &middot; (x&minus;a)<sup>n</sup>. A Maclaurin series is the special case where a = 0: f(x) = &Sigma; f<sup>(n)</sup>(0)/n! &middot; x<sup>n</sup>. Both represent functions as infinite polynomial sums.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How many terms do I need for a good approximation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">It depends on the function and how far from the center you evaluate. Near the center, 5&ndash;7 terms often give excellent accuracy. For points farther away, or for functions with small convergence radii, you may need 15&ndash;20 terms. Use the interactive graph with the term slider to see convergence in real time.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the radius of convergence?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The radius of convergence R is the distance from the center point within which the series converges to the actual function. For |x&minus;a| &lt; R, adding more terms gets closer to the true value. For |x&minus;a| &gt; R, the series diverges. Common values: e<sup>x</sup> has R = &infin;, ln(1+x) has R = 1, tan(x) has R = &pi;/2.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What functions can I expand?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Any function built from supported operations: arithmetic (+, -, *, /, ^), trigonometric (sin, cos, tan), exponential (exp, e^x), logarithmic (ln, log), and square root (sqrt). You can compose them freely, e.g., sin(x)*e^x or ln(1+x^2). The calculator uses math.js for symbolic differentiation.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this series calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, 100% free with no signup. Features include step-by-step derivative calculations, interactive Plotly convergence graph with term slider, radius of convergence analysis, Python SymPy compiler, LaTeX export, and shareable URLs. All computation runs in your browser.</div>
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
            <a href="<%=request.getContextPath()%>/derivative-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#dc2626,#ef4444);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.2rem;color:#fff;font-weight:700;">d/dx</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Derivative Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Step-by-step differentiation with graphs</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/integral-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#4f46e5,#6366f1);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;color:#fff;">&#8747;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Integral Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Step-by-step integration with graphs and PDF export</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#7c3aed,#a78bfa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">x&sup2;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Quadratic Solver</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Solve quadratic equations with 3 methods and graphs</p>
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
    var els = document.querySelectorAll('.sc-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        els.forEach(function(el){ el.classList.add('sc-visible'); });
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        entries.forEach(function(e){
            if (e.isIntersecting) {
                e.target.classList.add('sc-visible');
                obs.unobserve(e.target);
            }
        });
    }, { threshold: 0.15 });
    els.forEach(function(el){ obs.observe(el); });
})();
</script>

<!-- Core Scripts -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/mathjs@11.11.0/lib/browser/math.min.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/series-calculator-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/series-calculator-graph.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/series-calculator-export.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/series-calculator-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
