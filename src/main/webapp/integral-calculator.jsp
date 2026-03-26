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
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <!-- Integral Calculator styles -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/integral-calculator.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/integral-calculator.css?v=<%=cacheVersion%>"></noscript>

    <!-- SEO (competitive targeting: integral-calculator.com #1, Symbolab, Wolfram, Mathway) -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Integral Calculator • With Steps!" />
        <jsp:param name="toolDescription" value="Free integral calculator with step-by-step solutions and 1,000+ practice worksheet problems. Solve indefinite &amp; definite integrals instantly. Power rule, u-substitution, integration by parts, partial fractions, trig substitution. AI explanations, interactive graph, PDF &amp; LaTeX export. Generate printable integration worksheets with answer keys for exam prep. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="integral-calculator.jsp" />
        <jsp:param name="toolKeywords" value="integral calculator, integral calculator with steps, definite integral calculator, antiderivative calculator, indefinite integral calculator, integration by parts calculator, symbolic integration, solve integrals online free, calculus calculator with steps, u substitution calculator, trig integral calculator, download integral solution pdf, integral worksheet, integration practice problems, integral practice problems with solutions, integration worksheet with answers, calculus integration worksheet, u-substitution practice, integration by parts worksheet, partial fractions practice, trig substitution worksheet, AP calculus integral practice, integral quiz generator, definite integral practice, indefinite integral worksheet, power rule integration practice, improper integral calculator, double integral calculator, area under curve calculator, fundamental theorem of calculus calculator" />
        <jsp:param name="educationalLevel" value="High School, AP Calculus, College, University, Graduate" />
        <jsp:param name="teaches" value="Calculus, integration, antiderivatives, definite integrals, indefinite integrals, power rule, u-substitution, integration by parts, partial fractions, trigonometric substitution, improper integrals, area under curves, Fundamental Theorem of Calculus, numerical integration, Riemann sums, exponential integrals, logarithmic integrals, hyperbolic integrals" />
        <jsp:param name="howToSteps" value="Enter your function|Type your integral using math notation (e.g. sin(x), x^2, e^x) in the function input field,Select indefinite or definite mode|Toggle between indefinite (antiderivative) and definite (with bounds) integral,Click Integrate|Click the Integrate button to compute the result,View steps &amp; result|See the symbolic answer, step-by-step solution with AI explanations, and interactive graph" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Step-by-step solutions with AI explanations,Indefinite and definite integral evaluation,Live LaTeX math preview as you type,Interactive Plotly graph with shaded area,AI-powered detailed solution steps,Download result as PDF,Polynomials and rational functions,Trigonometric and hyperbolic integration,Exponential and logarithmic functions,Integration by parts and substitution,U-substitution with automatic detection,Partial fractions decomposition,Trig substitution solver,Copy LaTeX or plain text output,Share results via URL,Built-in Python compiler,1000+ integration practice worksheet problems,Printable worksheet with answer key,Filter by question type and 4 difficulty levels,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="Does this integral calculator have a printable practice worksheet?" />
        <jsp:param name="faq1a" value="Yes. Click the Print Worksheet button to open a bank of 1,000+ integration practice problems with full answer keys. Problems are organized by type (power rule, u-substitution, integration by parts, partial fractions, trig substitution, definite integrals) and four difficulty levels (basic, medium, hard, scholar). You can filter, print, or work through them on screen. New problems are generated with step-by-step solutions, perfect for AP Calculus, college calculus, or self-study." />
        <jsp:param name="faq2q" value="What types of integrals can this calculator solve?" />
        <jsp:param name="faq2a" value="This calculator solves indefinite integrals (antiderivatives) and definite integrals for polynomials, trigonometric functions (sin, cos, tan, sec, csc, cot), exponential functions (e^x), logarithmic functions (ln x), rational functions, hyperbolic functions (sinh, cosh, tanh), inverse trig (arctan, arcsin), and products solved by integration by parts. It handles power rule, u-substitution, partial fractions, and more." />
        <jsp:param name="faq3q" value="Does this integral calculator show step-by-step solutions?" />
        <jsp:param name="faq3a" value="Yes. After computing a result, click Show Steps to see a detailed step-by-step solution. For common integrals (power rule, basic trig, exponential), steps are generated instantly in your browser. For complex integrals like integration by parts or partial fractions, the advanced solver explains each algebraic manipulation, substitution, and simplification in 5-8 clear steps with full LaTeX math rendering." />
        <jsp:param name="faq4q" value="Can I use this for AP Calculus or college exam prep?" />
        <jsp:param name="faq4a" value="Absolutely. The built-in worksheet has 1,000+ curated problems covering every integration topic on the AP Calculus AB/BC exam and standard college Calculus II courses: power rule, u-substitution, integration by parts, partial fractions, trig substitution, improper integrals, and area/volume applications. Each problem includes a verified answer. Use the difficulty filter to start easy and work up to exam-level questions." />
        <jsp:param name="faq5q" value="Can I download or share my integral solution?" />
        <jsp:param name="faq5a" value="Yes. After computing a result you can: (1) Download as PDF with the question, answer, method, and step-by-step solution beautifully formatted, (2) Copy the result as LaTeX for use in papers and documents, (3) Copy as plain text, or (4) Generate a shareable URL that loads your exact integral with one click." />
        <jsp:param name="faq6q" value="What is the difference between indefinite and definite integrals?" />
        <jsp:param name="faq6a" value="An indefinite integral finds the antiderivative F(x) + C, a family of functions whose derivative equals f(x). A definite integral evaluates the net signed area under the curve between bounds [a, b] using the Fundamental Theorem of Calculus: F(b) - F(a). This calculator supports both modes with a simple toggle, and the interactive graph shows the shaded area for definite integrals." />
        <jsp:param name="faq7q" value="Is this integral calculator free? Do I need to sign up?" />
        <jsp:param name="faq7a" value="This integral calculator is completely free with no signup, no account, and no limits. You get symbolic integration, step-by-step solutions, interactive graphs, PDF download, LaTeX export, a 1,000+ problem practice worksheet, and a built-in Python compiler. All computation runs in your browser for instant results." />
        <jsp:param name="faq8q" value="How does u-substitution work in this integral calculator?" />
        <jsp:param name="faq8a" value="U-substitution (or change of variables) rewrites an integral of the form integral f(g(x))g'(x)dx as integral f(u)du by letting u=g(x). This calculator automatically detects when u-substitution applies and shows the substitution step. For example, integral 2x*cos(x^2)dx becomes integral cos(u)du with u=x^2. Click Show Steps after integrating to see the full u-sub workflow." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS - all async -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- KaTeX -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

</head>
<body>
<!-- Navigation -->
<%@ include file="modern/components/nav-header.jsp" %>

<!-- Page Header -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Integral Calculator with Steps</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                Integral Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">Symbolic CAS</span>
            <span class="tool-badge">PDF Export</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<!-- Tool Description -->
<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Solve indefinite and definite integrals with <strong>detailed step-by-step solutions</strong>. Supports polynomials, trig, exponential, logarithmic, hyperbolic, and rational functions. Includes <strong>AI-powered explanations</strong>, interactive graph, <strong>PDF download</strong>, LaTeX export, and a built-in Python compiler. Free, instant, no signup.</p>
        </div>
    </div>
</section>

<!-- Main Content -->
<main class="tool-page-container">
    <!-- ========== INPUT COLUMN ========== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z" stroke="none" fill="none"/>
                    <text x="5" y="18" font-size="16" font-weight="700" fill="currentColor" font-family="serif">&#8747;</text>
                </svg>
                Integral Calculator
            </div>
            <div class="tool-card-body">
                <!-- Mode toggle -->
                <div class="ic-mode-toggle">
                    <button type="button" class="ic-mode-btn active" data-mode="indefinite">Indefinite</button>
                    <button type="button" class="ic-mode-btn" data-mode="definite">Definite</button>
                </div>

                <!-- Function input -->
                <div class="tool-form-group ic-expr-wrap">
                    <label class="tool-form-label" for="ic-expr">Function f(x)</label>
                    <input type="text" class="tool-input tool-input-mono" id="ic-expr" placeholder="e.g. sin(3*x), x^2, e^x" autocomplete="off" spellcheck="false">
                    <div class="ic-autocomplete" id="ic-autocomplete"></div>
                    <span class="tool-form-hint">Both sin3x and sin(3*x) work. Definite: <code>expr, (x, 0, oo)</code> accepted</span>
                </div>

                <!-- Live preview -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Live Preview</label>
                    <div class="ic-preview" id="ic-preview">
                        <span style="color:var(--text-muted);font-size:0.8125rem;">Type a function above&hellip;</span>
                    </div>
                </div>

                <!-- Variable -->
                <div class="tool-form-group">
                    <label class="tool-form-label" for="ic-var">Variable</label>
                    <select class="tool-select" id="ic-var">
                        <option value="x" selected>x</option>
                        <option value="y">y</option>
                        <option value="z">z</option>
                        <option value="t">t</option>
                        <option value="u">u</option>
                        <option value="v">v</option>
                        <option value="w">w</option>
                        <option value="r">r</option>
                        <option value="s">s</option>
                        <option value="theta">θ</option>
                        <option value="k">k</option>
                        <option value="m">m</option>
                        <option value="n">n</option>
                        <option value="p">p</option>
                        <option value="q">q</option>
                    </select>
                </div>

                <!-- Bounds (definite only) -->
                <div class="ic-bounds" id="ic-bounds">
                    <div class="tool-form-group" style="margin-bottom:0;">
                        <label class="tool-form-label" for="ic-lower">Lower bound (a)</label>
                        <input type="text" class="tool-input tool-input-mono" id="ic-lower" value="0" placeholder="0">
                    </div>
                    <div class="tool-form-group" style="margin-bottom:0;">
                        <label class="tool-form-label" for="ic-upper">Upper bound (b)</label>
                        <input type="text" class="tool-input tool-input-mono" id="ic-upper" value="1" placeholder="1">
                    </div>
                </div>

                <!-- Integrate button -->
                <button type="button" class="tool-action-btn" id="ic-integrate-btn">Integrate</button>

                <hr class="ic-sep">

                <!-- Quick examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="ic-examples" id="ic-examples">
                        <button type="button" class="ic-example-chip" data-expr="sin(3*x)">sin(3x)</button>
                        <button type="button" class="ic-example-chip" data-expr="x^2+3*x">x&sup2;+3x</button>
                        <button type="button" class="ic-example-chip" data-expr="sin(x)*cos(x)">sin&middot;cos</button>
                        <button type="button" class="ic-example-chip" data-expr="e^x*x^2">e^x&middot;x&sup2;</button>
                        <button type="button" class="ic-example-chip" data-expr="1/(x^2+1)">1/(x&sup2;+1)</button>
                        <button type="button" class="ic-example-chip" data-expr="log(x)">ln(x)</button>
                        <button type="button" class="ic-example-chip" data-expr="sec(x)^2">sec&sup2;(x)</button>
                        <button type="button" class="ic-example-chip" data-expr="x*e^(-x)">x&middot;e^(-x)</button>
                        <button type="button" class="ic-example-chip" data-expr="1/sqrt(1-x^2)">1/&radic;(1-x&sup2;)</button>
                        <button type="button" class="ic-example-chip" data-expr="Sum(x^n, (n, 2, oo)), (x, 0, 1/2)" title="SymPy Sum: integral of sum x^n (n=2 to infinity) from 0 to 1/2 — MIT Integration Bee style">&Sigma; x<sup>n</sup> [0,&frac12;]</button>
                    </div>
                </div>

                <hr class="ic-sep">

                <!-- Syntax help (collapsible) -->
                <div id="ic-syntax-wrap">
                    <button type="button" class="ic-syntax-toggle" id="ic-syntax-btn">
                        Syntax Help
                        <svg class="ic-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="ic-syntax-content" id="ic-syntax-content">
                        <strong>Trig:</strong> Use parentheses. <code>sin(3*x)</code> for sin&nbsp;3x, <code>cos(2*t)</code> for cos&nbsp;2t.<br>
                        Shorthand works too: <code>sin3x</code> &rarr; sin(3x), <code>sinx</code> &rarr; sin(x)<br>
                        x^2 &nbsp;&nbsp; sin(x) &nbsp;&nbsp; cos(x) &nbsp;&nbsp; tan(x)<br>
                        e^x &nbsp;&nbsp; log(x)=ln(x) &nbsp;&nbsp; sqrt(x)<br>
                        sec(x) &nbsp;&nbsp; csc(x) &nbsp;&nbsp; cot(x)<br>
                        sinh(x) &nbsp;&nbsp; cosh(x) &nbsp;&nbsp; tanh(x) &nbsp;&nbsp; coth(x) &nbsp;&nbsp; csch(x) &nbsp;&nbsp; sech(x)<br>
                        asin(x) &nbsp;&nbsp; acos(x) &nbsp;&nbsp; atan(x)<br>
                        pi &nbsp;&nbsp; e &nbsp;&nbsp; abs(x) &nbsp;&nbsp; 1/x
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== OUTPUT COLUMN ========== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="ic-output-tabs">
            <button type="button" class="ic-output-tab active" data-panel="result">Result</button>
            <button type="button" class="ic-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="ic-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="ic-panel active" id="ic-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="ic-result-content">
                    <div class="tool-empty-state" id="ic-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#8747;</div>
                        <h3>Enter a function and click Integrate</h3>
                        <p>Supports polynomials, trig, exponential, logarithmic, and rational functions.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="ic-result-actions">
                    <button type="button" class="tool-action-btn" id="ic-copy-latex-btn">
                        <span>&#128203;</span> Copy LaTeX
                    </button>
                    <button type="button" class="tool-action-btn" id="ic-copy-text-btn">
                        <span>&#128196;</span> Copy Text
                    </button>
                    <button type="button" class="tool-action-btn" id="ic-share-btn">
                        <span>&#128279;</span> Share
                    </button>
                    <button type="button" class="tool-action-btn" id="ic-download-pdf-btn">
                        <span>&#128196;</span> Download PDF
                    </button>
                </div>
                <!-- Print Worksheet — always visible, not gated on result -->
                <div style="padding:0.75rem 1.25rem;border-top:1px solid var(--border,#e2e8f0);background:var(--bg-secondary,#f8fafc);border-radius:0 0 0.75rem 0.75rem;">
                    <button type="button" class="tool-action-btn" id="ic-worksheet-btn" style="width:100%;background:linear-gradient(135deg,#4f46e5,#6366f1);color:#fff;border:none;font-weight:600;padding:0.625rem 1rem;font-size:0.875rem;">
                        <span>&#128218;</span> Practice Integration Worksheet (1000+ Problems)
                    </button>
                </div>
            </div>
        </div>

        <!-- Graph Panel -->
        <div class="ic-panel" id="ic-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>Interactive Graph</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="ic-graph-container"></div>
                    <p id="ic-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Integrate a function to see its graph.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="ic-panel" id="ic-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                    <select id="ic-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                        <option value="symbolic-indef">Symbolic Indefinite</option>
                        <option value="symbolic-def">Symbolic Definite</option>
                        <option value="scipy-numerical">Numerical</option>
                    </select>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="ic-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== ADS COLUMN ========== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-three-column.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="integral-calculator.jsp"/>
    <jsp:param name="keyword" value="calculus"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

    <!-- What is an Integral? -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is an Integral?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">An <strong>integral</strong> is the reverse operation of differentiation. The <strong>indefinite integral</strong> (antiderivative) of a function f(x) is a family of functions F(x) + C whose derivative equals f(x). The <strong>definite integral</strong> computes the net signed area under the curve of f(x) between two bounds [a, b].</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">In physics, integrals represent accumulation: distance is the integral of velocity, work is the integral of force, and charge is the integral of current. In probability, integrals compute areas under density curves.</p>

        <!-- Area under curve SVG diagram -->
        <svg class="ic-diagram" viewBox="0 0 500 220" xmlns="http://www.w3.org/2000/svg" style="max-width:460px;">
            <defs>
                <linearGradient id="areaGrad" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stop-color="#4f46e5" stop-opacity="0.3"/>
                    <stop offset="100%" stop-color="#4f46e5" stop-opacity="0.05"/>
                </linearGradient>
            </defs>
            <!-- Axes -->
            <line x1="50" y1="180" x2="470" y2="180" stroke="#94a3b8" stroke-width="1.5"/>
            <line x1="50" y1="20" x2="50" y2="180" stroke="#94a3b8" stroke-width="1.5"/>
            <!-- Shaded area -->
            <path d="M120,180 L120,100 C160,60 200,40 240,55 C280,70 320,50 360,80 L360,180 Z" fill="url(#areaGrad)" stroke="none"/>
            <!-- Curve -->
            <path d="M60,140 C80,120 100,105 120,100 C160,60 200,40 240,55 C280,70 320,50 360,80 C400,100 440,130 460,150" fill="none" stroke="#4f46e5" stroke-width="2.5" stroke-linecap="round"/>
            <!-- Bounds -->
            <line x1="120" y1="100" x2="120" y2="180" stroke="#4338ca" stroke-width="1" stroke-dasharray="4,3"/>
            <line x1="360" y1="80" x2="360" y2="180" stroke="#4338ca" stroke-width="1" stroke-dasharray="4,3"/>
            <!-- Labels -->
            <text x="116" y="198" font-size="13" fill="#4338ca" font-weight="600" text-anchor="middle">a</text>
            <text x="356" y="198" font-size="13" fill="#4338ca" font-weight="600" text-anchor="middle">b</text>
            <text x="240" y="140" font-size="12" fill="#4f46e5" font-weight="600" text-anchor="middle">Area = &#8747; f(x) dx</text>
            <text x="460" y="160" font-size="12" fill="#94a3b8" font-style="italic">f(x)</text>
            <text x="480" y="185" font-size="12" fill="#94a3b8">x</text>
            <text x="40" y="25" font-size="12" fill="#94a3b8">y</text>
        </svg>
    </div>

    <!-- Common Integration Rules -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">Common Integration Rules</h2>
        <table class="ic-rules-table">
            <thead>
            <tr><th style="width:40%;">Rule</th><th style="width:35%;">Formula</th><th>Example</th></tr>
            </thead>
            <tbody>
            <tr><td style="font-family:var(--font-sans);font-weight:500;">Power Rule</td><td>&#8747;x^n dx = x^(n+1)/(n+1)+C</td><td>&#8747;x&sup3; dx = x&sup4;/4+C</td></tr>
            <tr><td style="font-family:var(--font-sans);font-weight:500;">Constant</td><td>&#8747;k dx = kx + C</td><td>&#8747;5 dx = 5x + C</td></tr>
            <tr><td style="font-family:var(--font-sans);font-weight:500;">Sine</td><td>&#8747;sin(x) dx = -cos(x)+C</td><td></td></tr>
            <tr><td style="font-family:var(--font-sans);font-weight:500;">Cosine</td><td>&#8747;cos(x) dx = sin(x)+C</td><td></td></tr>
            <tr><td style="font-family:var(--font-sans);font-weight:500;">Exponential</td><td>&#8747;e^x dx = e^x + C</td><td></td></tr>
            <tr><td style="font-family:var(--font-sans);font-weight:500;">Reciprocal</td><td>&#8747;1/x dx = ln|x| + C</td><td></td></tr>
            <tr><td style="font-family:var(--font-sans);font-weight:500;">Sec&sup2;</td><td>&#8747;sec&sup2;(x) dx = tan(x)+C</td><td></td></tr>
            <tr><td style="font-family:var(--font-sans);font-weight:500;">Inverse trig</td><td>&#8747;1/(1+x&sup2;) dx = arctan(x)+C</td><td></td></tr>
            </tbody>
        </table>
    </div>

    <!-- Integration Techniques -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Integration Techniques</h2>
        <div class="ic-edu-grid">
            <div class="ic-edu-card" style="border-left: 3px solid #4f46e5;">
                <h4>U-Substitution</h4>
                <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">&#8747;f(g(x))&middot;g'(x) dx = &#8747;f(u) du</p>
                <p>Example: &#8747;2x&middot;cos(x&sup2;) dx &rarr; let u = x&sup2;</p>
            </div>
            <div class="ic-edu-card" style="border-left: 3px solid #6366f1;">
                <h4>Integration by Parts</h4>
                <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">&#8747;u dv = uv - &#8747;v du</p>
                <p>Example: &#8747;x&middot;e^x dx &rarr; u=x, dv=e^x dx</p>
            </div>
            <div class="ic-edu-card" style="border-left: 3px solid #818cf8;">
                <h4>Partial Fractions</h4>
                <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">Decompose P(x)/Q(x) into simpler fractions</p>
                <p>Example: &#8747;1/(x&sup2;-1) dx &rarr; split into A/(x-1) + B/(x+1)</p>
            </div>
            <div class="ic-edu-card" style="border-left: 3px solid #a5b4fc;">
                <h4>Trig Substitution</h4>
                <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">Substitute x = a&middot;sin(&theta;), etc.</p>
                <p>Example: &#8747;1/&radic;(1-x&sup2;) dx &rarr; x=sin(&theta;)</p>
            </div>
        </div>
    </div>

    <!-- Fundamental Theorem of Calculus -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Fundamental Theorem of Calculus</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">The Fundamental Theorem connects differentiation and integration as inverse operations.</p>
        <div style="background: var(--tool-light); border-left: 3px solid var(--tool-primary); padding: 1rem; border-radius: 0 var(--radius-md) var(--radius-md) 0; margin-bottom: 0.75rem;">
            <p style="color: var(--text-primary); font-weight: 600; margin-bottom: 0.5rem; font-size: 0.875rem;">Part 1: If F(x) = &#8747;<sub>a</sub><sup>x</sup> f(t) dt, then F'(x) = f(x)</p>
            <p style="color: var(--text-primary); font-weight: 600; margin: 0; font-size: 0.875rem;">Part 2: &#8747;<sub>a</sub><sup>b</sup> f(x) dx = F(b) - F(a), where F'(x) = f(x)</p>
        </div>

        <!-- FTC SVG diagram -->
        <svg class="ic-diagram" viewBox="0 0 500 180" xmlns="http://www.w3.org/2000/svg" style="max-width:460px;">
            <defs>
                <linearGradient id="ftcGrad" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stop-color="#6366f1" stop-opacity="0.25"/>
                    <stop offset="100%" stop-color="#6366f1" stop-opacity="0.05"/>
                </linearGradient>
            </defs>
            <line x1="40" y1="140" x2="460" y2="140" stroke="#94a3b8" stroke-width="1.5"/>
            <line x1="40" y1="10" x2="40" y2="140" stroke="#94a3b8" stroke-width="1.5"/>
            <path d="M100,140 L100,70 Q180,30 260,50 Q340,70 380,60 L380,140 Z" fill="url(#ftcGrad)"/>
            <path d="M50,110 Q100,70 180,40 Q260,50 340,60 Q380,55 440,80" fill="none" stroke="#4f46e5" stroke-width="2.5"/>
            <line x1="100" y1="70" x2="100" y2="140" stroke="#4338ca" stroke-width="1.5" stroke-dasharray="4,3"/>
            <line x1="380" y1="60" x2="380" y2="140" stroke="#4338ca" stroke-width="1.5" stroke-dasharray="4,3"/>
            <text x="100" y="158" font-size="13" fill="#4338ca" font-weight="600" text-anchor="middle">a</text>
            <text x="380" y="158" font-size="13" fill="#4338ca" font-weight="600" text-anchor="middle">b</text>
            <!-- F(b) and F(a) labels -->
            <circle cx="100" cy="70" r="4" fill="#4f46e5"/>
            <circle cx="380" cy="60" r="4" fill="#4f46e5"/>
            <text x="75" y="63" font-size="11" fill="#4f46e5" font-weight="600">F(a)</text>
            <text x="388" y="53" font-size="11" fill="#4f46e5" font-weight="600">F(b)</text>
            <text x="240" y="115" font-size="12" fill="#4f46e5" font-weight="600" text-anchor="middle">F(b) - F(a)</text>
        </svg>
        <p style="color: var(--text-secondary); margin: 0; line-height: 1.7; font-size: 0.875rem;">This theorem provides a systematic way to evaluate definite integrals: find any antiderivative F(x) of f(x), then compute F(b) - F(a).</p>
    </div>

    <!-- Applications -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Applications of Integrals</h2>
        <div class="ic-edu-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));">
            <div class="ic-edu-card" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128207;</div>
                <h4>Area Between Curves</h4>
                <p>Find the area enclosed between two functions over an interval.</p>
            </div>
            <div class="ic-edu-card" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127758;</div>
                <h4>Volume of Revolution</h4>
                <p>Calculate volumes by rotating curves around axes (disk/shell methods).</p>
            </div>
            <div class="ic-edu-card" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9889;</div>
                <h4>Work &amp; Energy</h4>
                <p>Work = &#8747;F&middot;dx. Compute energy in physics problems.</p>
            </div>
            <div class="ic-edu-card" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128200;</div>
                <h4>Probability</h4>
                <p>P(a &le; X &le; b) = &#8747; f(x) dx for continuous distributions.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" id="faqs" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Frequently Asked Questions</h2>

        <div class="faq-item open">
            <button class="faq-question" onclick="toggleFaq(this)">
                Does this integral calculator have a printable practice worksheet?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer" style="display:block;">Yes. Click the <strong>Print Worksheet</strong> button to open a bank of <strong>1,000+ integration practice problems</strong> with full answer keys. Problems are organized by type (power rule, u-substitution, integration by parts, partial fractions, trig substitution, definite integrals) and four difficulty levels (basic, medium, hard, scholar). You can filter, print, or work through them on screen. New problems are generated with step-by-step solutions &mdash; perfect for AP Calculus, college calculus, or self-study.</div>
        </div>

        <div class="faq-item open">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can I use this for AP Calculus or college exam prep?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer" style="display:block;">Absolutely. The built-in worksheet has <strong>1,000+ curated problems</strong> covering every integration topic on the AP Calculus AB/BC exam and standard college Calculus&nbsp;II courses: power rule, u-substitution, integration by parts, partial fractions, trig substitution, improper integrals, and area/volume applications. Each problem includes a verified answer. Use the difficulty filter to start easy and work up to exam-level questions.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What types of integrals can this calculator solve?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">This calculator solves indefinite integrals (antiderivatives) and definite integrals for polynomials, trigonometric functions (sin, cos, tan, sec, csc, cot), exponential functions (e^x), logarithmic functions (ln&nbsp;x), rational functions, hyperbolic functions (sinh, cosh, tanh), inverse trig (arctan, arcsin), and products solved by integration by parts. It handles power rule, u-substitution, partial fractions, and more.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Does this integral calculator show step-by-step solutions?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes. After computing a result, click the <strong>Show Steps</strong> button to see a detailed step-by-step solution. For common integrals (power rule, basic trig, exponential), steps are generated instantly in your browser. For complex integrals like integration by parts or partial fractions, the advanced solver explains each algebraic manipulation, substitution, and simplification in 5&ndash;8 clear steps with full LaTeX math rendering.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can I download or share my integral solution?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes. After computing a result you can: (1) Download as PDF with the question, answer, method, and step-by-step solution beautifully formatted, (2) Copy the result as LaTeX for use in papers and documents, (3) Copy as plain text, or (4) Generate a shareable URL that loads your exact integral with one click.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between indefinite and definite integrals?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">An indefinite integral finds the antiderivative F(x)&nbsp;+&nbsp;C, a family of functions whose derivative equals f(x). A definite integral evaluates the net signed area under the curve between bounds [a,&nbsp;b] using the Fundamental Theorem of Calculus: F(b)&nbsp;&minus;&nbsp;F(a). This calculator supports both modes with a simple toggle, and the interactive graph shows the shaded area for definite integrals.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this integral calculator free? Do I need to sign up?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">This integral calculator is completely free with no signup, no account, and no limits. You get symbolic integration, step-by-step solutions, interactive graphs, PDF download, LaTeX export, a 1,000+ problem practice worksheet, and a built-in Python compiler. All computation runs in your browser for instant results.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How does u-substitution work in this integral calculator?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">U-substitution (or change of variables) rewrites an integral of the form &#8747;f(g(x))g'(x)dx as &#8747;f(u)du by letting u=g(x). This calculator automatically detects when u-substitution applies and shows the substitution step. For example, &#8747;2x&#183;cos(x&#178;)dx becomes &#8747;cos(u)du with u=x&#178;. Click Show Steps after integrating to see the full u-sub workflow.</div>
        </div>
    </div>
</section>

<!-- Explore More Math: Quick Math, Visual Math, Math Memory -->
<section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
    <div class="tool-card" style="padding: 1.5rem 2rem;">
        <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; color: var(--text-primary);">
            <span style="font-size: 1.3rem;">&#128293;</span> Explore More Math
        </h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
            <a href="<%=request.getContextPath()%>/exams/quick-math/" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #f59e0b, #d97706); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem;">&#9889;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Quick Math</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">150+ mental math tricks and Vedic math shortcuts for speed calculation</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #8b5cf6, #7c3aed); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem;">&#128202;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Visual Math Lab</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">35 interactive visualizations for algebra, calculus, trigonometry and statistics</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/math-memory/" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(99,102,241,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #10b981, #059669); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem;">&#129504;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Math Memory Games</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">16 free brain training games to improve memory and mental calculation</p>
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
<%@ include file="modern/components/analytics.jsp" %>

<!-- KaTeX JS -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>

<!-- Nerdamer -->
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator-core.js?v=<%=cacheVersion%>"></script>

<!-- Plotly (deferred until graph tab clicked) -->
<script>
    var __plotlyLoaded = false;
    function loadPlotly(cb) {
        if (__plotlyLoaded) { if (cb) cb(); return; }
        var s = document.createElement('script');
        s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
        s.onload = function() { __plotlyLoaded = true; if (cb) cb(); };
        document.head.appendChild(s);
    }
</script>

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<script src="<%=request.getContextPath()%>/js/worksheet-engine.js?v=<%=cacheVersion%>"></script>
<script>window.INTEGRAL_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator.js?v=<%=cacheVersion%>"></script>

</body>
</html>
