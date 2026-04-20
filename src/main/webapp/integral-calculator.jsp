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
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/integral-calculator.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/image-to-math.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/integral-calculator.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css">
    </noscript>

    <!-- SEO (competitive targeting: integral-calculator.com #1, Symbolab, Wolfram, Mathway) -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free Integral Calculator With Steps" />
        <jsp:param name="toolDescription" value="Free integral calculator with step-by-step solutions. Snap a photo of your homework or type any integral &mdash; get the answer with every step explained. Power rule, u-sub, by parts, partial fractions, trig sub. Interactive graph, PDF &amp; LaTeX export, 1,000+ practice worksheets. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="integral-calculator.jsp" />
        <jsp:param name="toolKeywords" value="integral calculator, integral calculator with steps, definite integral calculator, antiderivative calculator, indefinite integral calculator, integration by parts calculator, symbolic integration, solve integrals online free, calculus calculator with steps, u substitution calculator, trig integral calculator, download integral solution pdf, integral worksheet, integration practice problems, integral practice problems with solutions, integration worksheet with answers, calculus integration worksheet, u-substitution practice, integration by parts worksheet, partial fractions practice, trig substitution worksheet, AP calculus integral practice, integral quiz generator, definite integral practice, indefinite integral worksheet, power rule integration practice, improper integral calculator, double integral calculator, area under curve calculator, fundamental theorem of calculus calculator, photo integral solver, scan math homework, image to math, math photo solver, OCR integral calculator, snap photo integral, homework scanner math, screenshot to integral, picture to equation solver" />
        <jsp:param name="educationalLevel" value="High School, AP Calculus, College, University, Graduate" />
        <jsp:param name="teaches" value="Calculus, integration, antiderivatives, definite integrals, indefinite integrals, power rule, u-substitution, integration by parts, partial fractions, trigonometric substitution, improper integrals, area under curves, Fundamental Theorem of Calculus, numerical integration, Riemann sums, exponential integrals, logarithmic integrals, hyperbolic integrals" />
        <jsp:param name="howToSteps" value="Enter your function|Type your integral using math notation (e.g. sin(x), x^2, e^x) in the function input field,Select indefinite or definite mode|Toggle between indefinite (antiderivative) and definite (with bounds) integral,Click Integrate|Click the Integrate button to compute the result,View steps &amp; result|See the symbolic answer, step-by-step solution with AI explanations, and interactive graph" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Scan a photo or screenshot to solve integrals instantly,Batch solve multiple problems from one image,Step-by-step solutions with AI explanations,Indefinite and definite integral evaluation,Live LaTeX math preview as you type,Interactive Plotly graph with shaded area,AI-powered detailed solution steps,Download result as PDF,Polynomials and rational functions,Trigonometric and hyperbolic integration,Exponential and logarithmic functions,Integration by parts and substitution,U-substitution with automatic detection,Partial fractions decomposition,Trig substitution solver,Copy LaTeX or plain text output,Share results via URL,Built-in Python compiler,1000+ integration practice worksheet problems,Printable worksheet with answer key,Filter by question type and 4 difficulty levels,Dark mode support,Free and no signup required" />
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
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- KaTeX -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <!-- MathLive (visual math input). Loaded async: static CSS first, element ESM on demand. -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>

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
            <p>Stuck on an integral? Type it in or <strong>snap a photo of your homework</strong> &mdash; get the full solution with every step explained: power rule, u-substitution, integration by parts, partial fractions, and more. Works for polynomials, trig, exponential, log, and hyperbolic functions. <strong>Graph the result</strong>, export to LaTeX or PDF, and verify in the built-in Python sandbox. Free, instant, no signup.</p>
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

                <!-- Function input.
                     Single row. The Visual/Text toggle lives inline with the label,
                     so there's no separate "Input Mode" section. In Visual mode the
                     <math-field> is the editor AND the live preview; in Text mode
                     the plain <input> is shown and the preview below renders it. -->
                <div class="tool-form-group ic-expr-wrap" id="ic-expr-wrap">
                    <div class="ic-expr-label-row">
                        <label class="tool-form-label ic-expr-label" for="ic-expr">Function f(x)</label>
                        <div class="ic-expr-label-actions">
                            <div class="ic-input-mode-toggle" id="ic-input-mode-toggle" role="radiogroup" aria-label="Input mode">
                                <button type="button" class="ic-input-mode-btn active" data-input-mode="visual" role="radio" aria-checked="true" title="Write math visually (like a textbook)">
                                    <span aria-hidden="true" style="font-family:'Times New Roman',serif;font-style:italic;">&fnof;</span><span class="ic-mode-label"> Visual</span>
                                </button>
                                <button type="button" class="ic-input-mode-btn" data-input-mode="text" role="radio" aria-checked="false" title="Type a plain-text expression (e.g. sin(3*x))">
                                    <span aria-hidden="true" style="font-family:var(--font-mono);">&lt;/&gt;</span><span class="ic-mode-label"> Text</span>
                                </button>
                            </div>
                            <button type="button" class="ic-image-btn" id="ic-image-btn" title="Scan problem from image">&#128247; Scan</button>
                        </div>
                    </div>

                    <!-- Visual math input (MathLive). Placeholder is rendered as LaTeX.
                         The virtual keyboard layout is configured in JS below with a
                         calculus-first custom layer (see "Calc" layout registration).
                         No `math-virtual-keyboard-policy` is set, so MathLive uses its
                         default "auto": the virtual keyboard appears on focus on touch
                         devices, and desktop users summon it via the keyboard toggle
                         in the field's chrome. -->
                    <math-field id="ic-mathfield" class="ic-mathfield" aria-label="Function, visual math input"
                                placeholder="\frac{1}{x^2+1}"
                                smart-mode="on"
                                smart-fence="on"
                                smart-superscript="on"
                                remove-extraneous-parentheses="on"
                                math-mode-space="\:"></math-field>

                    <!-- Plain text input — ALSO the canonical buffer read by the solver,
                         chips, URL loader, image-scan and share. In Visual mode it's
                         hidden but kept in sync (one-way) from the math-field. -->
                    <input type="text" class="tool-input tool-input-mono" id="ic-expr" placeholder="e.g. sin(3*x), x^2, e^x" autocomplete="off" spellcheck="false">
                    <div class="ic-autocomplete" id="ic-autocomplete"></div>

                    <span class="tool-form-hint ic-expr-hint">
                        <span class="ic-hint-visual">Enter just the integrand f(x) &mdash; the &#8747; and dx are added automatically. Type <code>sin</code>, <code>cos</code>, <code>sqrt</code>, <code>/</code>, <code>^</code> naturally.</span>
                        <span class="ic-hint-text">Both <code>sin3x</code> and <code>sin(3*x)</code> work. Definite one-liner: <code>expr, (x, 0, oo)</code>.</span>
                    </span>
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
                        <button type="button" class="ic-example-chip" data-expr="Max(0, sqrt(1-x^2)-1/2), (x, -1, 1)" title="Semicircle cap: max(0, sqrt(1-x^2)-1/2) on [-1,1] — SymPy Max">&radic; cap on [&minus;1,1]</button>
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
                        pi &nbsp;&nbsp; e &nbsp;&nbsp; abs(x) &nbsp;&nbsp; 1/x<br>
                        <strong>SymPy one-liner:</strong> <code>integrand, (variable, a, b)</code> &mdash; use <code>Max</code>, <code>Sum</code>, <code>Rational(1,2)</code> in bounds; commas inside the integrand are fine.
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
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator-core.js"></script>

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

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

<script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>
<script>window.INTEGRAL_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator.js"></script>

<!-- MathLive visual math input.

     Data model (deliberately minimal):
       * #ic-expr is the ONE canonical buffer read by the solver, chips,
         autocomplete, URL loader, image-scan and share.
       * The <math-field> is a visual editor that, in Visual mode, writes
         one-way into #ic-expr on every input (via MathLive's native
         `ascii-math` format — which is already our calculator's dialect:
         sin(x), sqrt(x), ^, *, /, pi, implicit multiplication).
       * No bidirectional sync, no loop-guards, no custom LaTeX regex.
       * Programmatic writes to #ic-expr (chips/URL/scan) are mirrored into
         the math-field via a value-setter hook that calls MathLive's own
         ascii-math parser. If that parse fails (e.g. SymPy Sum(...)), we
         auto-switch to Text mode so the user still sees their expression. -->
<script type="module">
    import 'https://cdn.jsdelivr.net/npm/mathlive/+esm';
    if (window.MathfieldElement) {
        window.MathfieldElement.fontsDirectory = 'https://cdn.jsdelivr.net/npm/mathlive/dist/fonts';
        try { window.MathfieldElement.soundsDirectory = null; } catch (e) {}
    }

    /*
     * Calculus-first virtual keyboard.
     *
     * The default MathLive keyboards are great for general math input, but a
     * student writing an integrand spends ~all their time in a narrow alphabet:
     * variables, constants (pi / e / infinity), powers, fractions, roots, a
     * handful of trig/log/exp functions, and parentheses. So we define a "Calc"
     * layer up front and relegate the stock `numeric` / `symbols` / `greek`
     * layouts to the layer switcher for the long tail.
     *
     * Layout shape (4 rows × 10 keycaps, following MathLive's row-size advice):
     *   Row 1:  vars (x y t n) · constants (pi e ∞) · nav (← → ⌫)
     *   Row 2:  digits 1-5 · + − · / · frac · x^n
     *   Row 3:  digits 6-9,0 · ( ) · x² · √ · 1/x · undo
     *   Row 4:  sin cos tan · ln log e^x · arctan arcsin arccos · ↵
     *
     * Long-press variants pack the related-but-rare symbols in without
     * cluttering the primary surface (x → a,b,u,v,θ; sin → sinh,csc; √ → ∛,ⁿ√;
     * ∞ → -∞,0⁺,0⁻; + → ±,∓; e^x → e^-x, a^x; etc.). This mirrors how the stock
     * MathLive layouts hide depth behind long-press.
     */
    if (window.mathVirtualKeyboard) {
        window.mathVirtualKeyboard.layouts = [
            {
                label: 'Calc',
                tooltip: 'Calculus integrands',
                rows: [
                    [
                        { latex: 'x', variants: ['a', 'b', 'u', 'v', 'r', 's', '\\theta'] },
                        { latex: 'y', variants: ['z'] },
                        { latex: 't', variants: ['\\tau'] },
                        { latex: 'n', variants: ['m', 'k', 'p', 'q'] },
                        { latex: '\\pi', variants: ['\\Pi'] },
                        { latex: 'e', variants: ['\\mathrm{e}'] },
                        { latex: '\\infty', variants: ['-\\infty', '0^{+}', '0^{-}'] },
                        '[left]', '[right]', '[backspace]'
                    ],
                    [
                        '[1]', '[2]', '[3]', '[4]', '[5]',
                        { latex: '+', variants: ['\\pm', '\\mp'] },
                        { latex: '-', variants: ['\\mp', '\\pm'] },
                        { latex: '\\cdot', variants: ['\\times', '*'] },
                        { class: 'small', latex: '\\frac{#@}{#?}',
                          variants: [{ latex: '\\frac{#?}{#?}' }, { latex: '#@/#?' }] },
                        { class: 'small', latex: '#@^{#?}', label: 'x<sup>n</sup>',
                          variants: ['#@^{-1}', '#@^{1/2}'] }
                    ],
                    [
                        '[6]', '[7]', '[8]', '[9]', '[0]',
                        '[(]', '[)]',
                        { latex: '#@^{2}', label: 'x<sup>2</sup>',
                          variants: ['#@^{3}', '#@^{-1}', '#@^{1/2}'] },
                        { latex: '\\sqrt{#@}', label: '&radic;',
                          variants: ['\\sqrt[3]{#@}', '\\sqrt[#?]{#@}'] },
                        { class: 'small', latex: '\\frac{1}{#?}', label: '1/x',
                          variants: ['\\frac{1}{#?^{2}}', '\\frac{#?}{#?+1}'] }
                    ],
                    [
                        { latex: '\\sin', variants: ['\\sinh', '\\csc', '\\operatorname{csch}'] },
                        { latex: '\\cos', variants: ['\\cosh', '\\sec', '\\operatorname{sech}'] },
                        { latex: '\\tan', variants: ['\\tanh', '\\cot', '\\coth'] },
                        { latex: '\\ln', variants: ['\\log_{#?}'] },
                        { latex: '\\log' },
                        { class: 'small', latex: 'e^{#?}', label: 'e<sup>x</sup>',
                          variants: ['e^{-#?}', 'a^{#?}', 'e^{-#?^{2}}'] },
                        { latex: '\\arctan', variants: ['\\operatorname{arccot}'] },
                        { latex: '\\arcsin', variants: ['\\operatorname{arccsc}'] },
                        { latex: '\\arccos', variants: ['\\operatorname{arcsec}'] },
                        '[return]'
                    ]
                ]
            },
            'numeric',
            'symbols',
            'greek'
        ];
    }
</script>

<script>
(function () {
    'use strict';

    var mf        = document.getElementById('ic-mathfield');
    var exprInput = document.getElementById('ic-expr');
    var wrap      = document.getElementById('ic-expr-wrap');
    var toggle    = document.getElementById('ic-input-mode-toggle');
    if (!mf || !exprInput || !toggle) return;

    var STORAGE_KEY = 'ic.inputMode';
    var cardBody = wrap.closest('.tool-card-body') || wrap.parentNode;

    // Native <input>.value setter — used to bypass our own property hook
    // when mirroring math-field → #ic-expr (so we don't re-enter the hook).
    var nativeInputValueSetter = (function () {
        try {
            var d = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value');
            return d && typeof d.set === 'function' ? d.set : null;
        } catch (e) { return null; }
    })();
    function setExprRaw(v) {
        if (nativeInputValueSetter) nativeInputValueSetter.call(exprInput, v);
        else exprInput.value = v;
    }

    // ---------- Mode control ----------
    function getMode() { return wrap.getAttribute('data-input-mode') || 'visual'; }
    function setMode(mode) {
        if (mode !== 'visual' && mode !== 'text') mode = 'visual';
        wrap.setAttribute('data-input-mode', mode);
        if (cardBody) cardBody.setAttribute('data-input-mode', mode);
        toggle.querySelectorAll('.ic-input-mode-btn').forEach(function (btn) {
            var active = btn.getAttribute('data-input-mode') === mode;
            btn.classList.toggle('active', active);
            btn.setAttribute('aria-checked', active ? 'true' : 'false');
        });
        try { localStorage.setItem(STORAGE_KEY, mode); } catch (e) {}
    }

    // Initial mode (default visual; migrate legacy 'both').
    var initial = 'visual';
    try {
        var stored = localStorage.getItem(STORAGE_KEY);
        if (stored === 'text') initial = 'text';
    } catch (e) {}
    setMode(initial);

    // SymPy-style constructs that have no visual math representation.
    // Fast-reject these before handing them to MathLive — its ascii-math
    // parser will otherwise happily emit unreadable garbage.
    function isAdvancedSympy(expr) {
        if (!expr) return false;
        if (/^\s*(Sum|Max|Min|Integral|Product|Rational)\s*\(/i.test(expr)) return true;
        if (/,\s*\([^)]*\)\s*$/.test(expr)) return true;
        return false;
    }

    // Seed the math-field from a calculator-format expression via MathLive's
    // own ascii-math parser. Returns true on success, false if the expression
    // cannot be meaningfully represented visually (caller should switch to Text).
    function seedMathField(expr) {
        expr = (expr == null ? '' : String(expr)).trim();
        if (!expr) {
            try { mf.setValue('', { silenceNotifications: true }); } catch (_) {}
            return true;
        }
        if (isAdvancedSympy(expr)) return false;
        if (typeof mf.setValue !== 'function') return false;
        try {
            mf.setValue(expr, { format: 'ascii-math', silenceNotifications: true });
            var back = '';
            try { back = (mf.getValue('ascii-math') || '').trim(); } catch (_) {}
            return !!back;
        } catch (_) {
            try { mf.setValue('', { silenceNotifications: true }); } catch (_) {}
            return false;
        }
    }

    // ---------- Mode toggle click ----------
    toggle.addEventListener('click', function (e) {
        var btn = e.target.closest('.ic-input-mode-btn');
        if (!btn || btn.disabled) return;
        var next = btn.getAttribute('data-input-mode');
        if (next === getMode()) return;

        if (next === 'visual') {
            if (!seedMathField(exprInput.value)) {
                // Can't render (e.g. SymPy Sum) — refuse the switch.
                return;
            }
            setMode('visual');
            try { mf.focus(); } catch (_) {}
        } else {
            // #ic-expr is already current (unidirectional flow). Just flip.
            setMode('text');
            // Nudge the preview & autocomplete once.
            exprInput.dispatchEvent(new Event('input', { bubbles: true }));
            try { exprInput.focus(); } catch (_) {}
        }
    });

    // ---------- Programmatic #ic-expr writes mirror into math-field ----------
    // Chips, URL loader, image-scan, autocomplete-accept all do
    //   exprInput.value = '...';
    // We hook the setter to seed the math-field when in Visual mode.
    // No dispatchEvent here: that's the caller's job.
    (function hookExprSetter() {
        if (!nativeInputValueSetter) return;
        try {
            var nativeGetter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').get;
            Object.defineProperty(exprInput, 'value', {
                configurable: true,
                enumerable: true,
                get: function () { return nativeGetter.call(this); },
                set: function (v) {
                    nativeInputValueSetter.call(this, v);
                    if (getMode() === 'visual') {
                        if (!seedMathField(v)) setMode('text');
                    }
                }
            });
        } catch (e) { /* non-fatal */ }
    })();

    // ---------- Wire events once the <math-field> custom element upgrades ----------
    function wire() {
        // Calculus-focused inline shortcuts layered on top of MathLive's
        // defaults. MathLive already ships `pi`, `oo`, `inf`, `int`, `sum`,
        // `sin`/`cos`/`tan`, `sqrt`, `lim`, Greek letters, etc. — we only add
        // what calculus students actually reach for and the defaults miss:
        //   • "atan", "asin", "acos", "acot", "asec", "acsc"  → arc-trig
        //     aliases (matches our normalizeExpr()'s `arcsin`→`asin` rewrite
        //     and what students typically type)
        //   • "exp" → e^{…}
        //   • "abs" → |…|
        //   • "cbrt" → ∛
        //   • "dx", "dt", "dy", "du", "dn" → upright differential (visual
        //     cue for students who paste a full integral and include the
        //     differential — the doIntegrate() pre-pass then extracts it)
        try {
            mf.inlineShortcuts = Object.assign({}, mf.inlineShortcuts || {}, {
                'atan':  '\\arctan',
                'asin':  '\\arcsin',
                'acos':  '\\arccos',
                'acot':  '\\operatorname{arccot}',
                'asec':  '\\operatorname{arcsec}',
                'acsc':  '\\operatorname{arccsc}',
                'exp':   'e^{#?}',
                'abs':   '\\left|#?\\right|',
                'cbrt':  '\\sqrt[3]{#?}',
                'dx':    '\\,\\mathrm{d}x',
                'dt':    '\\,\\mathrm{d}t',
                'dy':    '\\,\\mathrm{d}y',
                'du':    '\\,\\mathrm{d}u',
                'dn':    '\\,\\mathrm{d}n'
            });
        } catch (_) { /* MathLive version without inlineShortcuts setter */ }

        // Visual -> Text, one-way. Use the NATIVE setter + dispatch 'input'
        // so every downstream listener (preview, autocomplete, ...) sees it
        // exactly once, without re-entering our value-setter hook.
        mf.addEventListener('input', function () {
            if (getMode() !== 'visual') return;
            var ascii = '';
            try { ascii = (mf.getValue('ascii-math') || '').trim(); } catch (_) {}
            if (exprInput.value === ascii) return;
            setExprRaw(ascii);
            exprInput.dispatchEvent(new Event('input', { bubbles: true }));
        });

        // Enter submits.
        mf.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                var btn = document.getElementById('ic-integrate-btn');
                if (btn) btn.click();
            }
        });

        // Seed from any pre-existing text (URL param, server-rendered value).
        if (getMode() === 'visual' && exprInput.value) {
            if (!seedMathField(exprInput.value)) setMode('text');
        }
    }

    if (window.customElements && customElements.get('math-field')) {
        wire();
    } else if (window.customElements && customElements.whenDefined) {
        customElements.whenDefined('math-field').then(wire).catch(function () {
            // MathLive failed to load — force Text mode, disable Visual button.
            setMode('text');
            if (mf && mf.parentNode) mf.parentNode.removeChild(mf);
            toggle.querySelectorAll('.ic-input-mode-btn').forEach(function (btn) {
                if (btn.getAttribute('data-input-mode') === 'visual') {
                    btn.disabled = true;
                    btn.style.opacity = '0.5';
                    btn.style.cursor = 'not-allowed';
                    btn.title = 'Visual math input failed to load';
                }
            });
        });
    } else {
        setMode('text');
    }
})();
</script>

<script src="<%=request.getContextPath()%>/modern/js/image-to-math.js"></script>
<script>
    ImageToMath.init({
        buttonId: 'ic-image-btn',
        aiUrl: (window.INTEGRAL_CALC_CTX || '') + '/ai',
        toolName: 'Integral Calculator',
        extractionPrompt:
            'You are a math problem extractor for an integral calculator.\n' +
            'Given OCR text from a math image, extract ALL integration problems.\n' +
            'Return a JSON array. Each object has:\n' +
            '  - "latex": the integrand ONLY in LaTeX (NOT the full integral, just f(x)). Examples: "x^{2}", "\\sin(x)", "\\frac{1}{x}", "x e^{x}"\n' +
            '  - "variable": the integration variable (default "x")\n' +
            '  - "type": "definite" or "indefinite"\n' +
            '  - "lower": lower bound in LaTeX (only if definite, e.g. "0", "1", "\\pi", "\\infty")\n' +
            '  - "upper": upper bound in LaTeX (only if definite)\n' +
            '  - "display": the full integral in LaTeX for display (e.g. "\\int_0^1 x^{2} dx")\n\n' +
            'CRITICAL RULES:\n' +
            '- Extract ONLY the problems to solve, NOT the solutions.\n' +
            '- "latex" must be ONLY the integrand (the function being integrated), NOT the \\int or dx part.\n' +
            '- Keep LaTeX notation as-is: \\frac, \\sin, \\cos, \\sqrt, \\ln, \\pi, \\infty, ^{}, _{}.\n' +
            '- Do NOT convert to calculator format. Return raw LaTeX.\n' +
            '- Return ONLY valid JSON array, no markdown fences, no explanation.\n' +
            '- If no problems found, return []\n\n' +
            'Example:\n' +
            'Input: "Evaluate: $\\int_{0}^{1} x^{2} dx$ and $\\int \\sin(x) dx$"\n' +
            'Output: [{"latex":"x^{2}","variable":"x","type":"definite","lower":"0","upper":"1","display":"\\\\int_{0}^{1} x^{2} dx"},{"latex":"\\\\sin(x)","variable":"x","type":"indefinite","display":"\\\\int \\\\sin(x) dx"}]',
        onSelect: function (problem) {
            // Convert LaTeX integrand → calculator expression
            var expr = latexToCalcExpr(problem.latex || problem.expr || '');
            var lower = latexToCalcExpr(problem.lower || '');
            var upper = latexToCalcExpr(problem.upper || '');

            // Fill expression
            var exprInput = document.getElementById('ic-expr');
            if (exprInput && expr) {
                exprInput.value = expr;
                exprInput.dispatchEvent(new Event('input', { bubbles: true }));
            }

            // Set mode
            if (problem.type === 'definite') {
                var defBtn = document.querySelector('.ic-mode-btn[data-mode="definite"]');
                if (defBtn) defBtn.click();
                var lowerInput = document.getElementById('ic-lower');
                var upperInput = document.getElementById('ic-upper');
                if (lowerInput && lower) lowerInput.value = lower;
                if (upperInput && upper) upperInput.value = upper;
            } else {
                var indefBtn = document.querySelector('.ic-mode-btn[data-mode="indefinite"]');
                if (indefBtn) indefBtn.click();
            }

            // Set variable
            if (problem.variable && problem.variable !== 'x') {
                var varSelect = document.getElementById('ic-var');
                if (varSelect) varSelect.value = problem.variable;
            }

            // Auto-trigger integration
            setTimeout(function () {
                var intBtn = document.getElementById('ic-integrate-btn');
                if (intBtn) intBtn.click();
            }, 300);
        },
        onSolveAll: function (problems) {
            batchSolveIntegrals(problems);
        }
    });

    // ═══════════════════════════════════════════════════════════
    // Batch Solve — solves multiple integrals via SymPy and
    // displays results in a modal. No UI input required.
    // ═══════════════════════════════════════════════════════════

    function batchSolveIntegrals(problems) {
        var ic = window.IC;
        if (!ic) return;

        // Build the results modal
        var existing = document.getElementById('itm-results-overlay');
        if (existing) existing.remove();

        var ov = document.createElement('div');
        ov.id = 'itm-results-overlay';
        ov.className = 'itm-results-overlay';
        ov.innerHTML =
            '<div class="itm-results-modal">' +
            '  <div class="itm-results-header">' +
            '    <span class="itm-results-title">Solving ' + problems.length + ' Problem' + (problems.length > 1 ? 's' : '') + '</span>' +
            '    <button class="itm-close" id="itm-results-close">&times;</button>' +
            '  </div>' +
            '  <div class="itm-results-body" id="itm-results-body"></div>' +
            '  <div class="itm-results-footer">' +
            '    <button class="itm-btn" id="itm-results-done">Close</button>' +
            '  </div>' +
            '</div>';
        document.body.appendChild(ov);
        ov.style.display = 'flex';
        document.body.style.overflow = 'hidden';

        var closeResults = function () {
            ov.style.display = 'none';
            document.body.style.overflow = '';
            ov.remove();
        };
        document.getElementById('itm-results-close').addEventListener('click', closeResults);
        document.getElementById('itm-results-done').addEventListener('click', closeResults);
        ov.addEventListener('click', function (e) { if (e.target === ov) closeResults(); });

        var body = document.getElementById('itm-results-body');

        // Render cards (all pending)
        problems.forEach(function (p, i) {
            var display = p.display || p.latex || p.expr || '';
            var card = document.createElement('div');
            card.className = 'itm-result-card';
            card.id = 'itm-rc-' + i;
            card.innerHTML =
                '<div class="itm-result-card-header">' +
                '  <span class="itm-result-num">' + (i + 1) + '</span>' +
                '  <span class="itm-result-problem" id="itm-rp-' + i + '">' + ic.escapeHtml(display) + '</span>' +
                '  <span class="itm-result-status pending" id="itm-rs-' + i + '">Pending</span>' +
                '</div>' +
                '<div class="itm-result-card-body" id="itm-rb-' + i + '"></div>';
            body.appendChild(card);

            // Try KaTeX for the problem display
            if (window.katex) {
                try {
                    katex.render(display, document.getElementById('itm-rp-' + i), { throwOnError: false, displayMode: false });
                } catch (e) { /* keep text */ }
            }
        });

        // Solve sequentially
        solveNext(problems, 0, ic);
    }

    function solveNext(problems, idx, ic) {
        if (idx >= problems.length) return;

        var p = problems[idx];
        var card = document.getElementById('itm-rc-' + idx);
        var status = document.getElementById('itm-rs-' + idx);
        var bodyEl = document.getElementById('itm-rb-' + idx);

        // Mark solving
        card.className = 'itm-result-card solving';
        status.className = 'itm-result-status solving';
        status.textContent = 'Solving...';
        bodyEl.innerHTML = '<div class="itm-spinner"></div>';

        // Scroll card into view
        card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

        // We now send raw LaTeX to SymPy's parse_latex(backend='lark') and let
        // it derive the expr / variable / bounds / definite-ness. No more
        // client-side latexToCalcExpr → nerdamerToPython → boundToSympy chain
        // for the batch path. One authoritative LaTeX parser.
        //
        // Prefer p.display (full integral LaTeX from the AI). If the AI didn't
        // emit it, synthesise one from (latex, lower, upper, variable, type).
        var displayLatex = p.display;
        if (!displayLatex) {
            var _v = p.variable || 'x';
            var _l = p.latex || p.expr || 'x';
            if (p.type === 'definite' && p.lower != null && p.upper != null) {
                displayLatex = '\\int_{' + p.lower + '}^{' + p.upper + '} ' + _l + '\\, d' + _v;
            } else {
                displayLatex = '\\int ' + _l + '\\, d' + _v;
            }
        }
        var isDefinite = p.type === 'definite' && p.lower != null && p.upper != null;
        // Escape closing triple-quote for the Python raw-string literal.
        var pyLiteral = displayLatex.replace(/"""/g, '\\"\\"\\"');

        var code = ic.buildR2sPreamble(!isDefinite) +
            'from sympy.parsing.latex import parse_latex\n' +
            'import re, signal\n' +
            'LATEX = r"""' + pyLiteral + '"""\n' +
            '# Clean LaTeX for parse_latex: strip sizing commands it cannot handle\n' +
            'LATEX = re.sub(r"\\\\left\\s*([({\\\\[|])", r"\\1", LATEX)\n' +
            'LATEX = re.sub(r"\\\\right\\s*([)}\\\\]|])", r"\\1", LATEX)\n' +
            'LATEX = re.sub(r"\\\\(?:Big[lrg]?|bigl|bigr|Bigl|Bigr)\\s*", "", LATEX)\n' +
            'try:\n' +
            '    parsed = parse_latex(LATEX)\n' +
            'except Exception:\n' +
            '    try:\n' +
            '        parsed = parse_latex(LATEX, backend="lark")\n' +
            '    except Exception as e:\n' +
            '        raise ValueError("Could not parse LaTeX: " + str(e)[:80])\n' +
            'if getattr(parsed, "data", None) == "_ambig":\n' +
            '    cands = [c for c in parsed.children if isinstance(c, Integral)]\n' +
            '    parsed = cands[0] if cands else parsed.children[0]\n' +
            'if not isinstance(parsed, Integral):\n' +
            '    raise ValueError("Not a full integral expression")\n' +
            'expr = simplify(parsed.function)\n' +
            '# parse_latex treats e as Symbol; replace with Euler number E\n' +
            'expr = expr.subs(Symbol("e"), E)\n' +
            'limits = parsed.limits[0]\n' +
            'v = limits[0]\n' +
            'is_def = len(limits) == 3\n' +
            'try:\n' +
            '    if expr.has(Sum):\n' +
            '        expr = expr.doit(deep=True)\n' +
            'except Exception:\n' +
            '    pass\n' +
            'try:\n    _s_obj = integral_steps(expr, v)\nexcept:\n    _s_obj = None\n' +
            'def _timeout(s, f): raise TimeoutError\n' +
            'signal.signal(signal.SIGALRM, _timeout)\n' +
            'signal.alarm(10)\n' +
            'try:\n' +
            '    antideriv = integrate(expr, v)\n' +
            'except (TimeoutError, Exception):\n' +
            '    antideriv = Integral(expr, v)\n' +
            'finally:\n' +
            '    signal.alarm(0)\n' +
            'if is_def:\n' +
            '    a = limits[1]; b = limits[2]\n' +
            '    if isinstance(antideriv, Integral):\n' +
            '        result = Integral(expr, (v, a, b))\n' +
            '        print("LATEX:" + latex(result))\n' +
            '        print("TEXT:" + str(result))\n' +
            '        print("ANTIDERIV:")\n' +
            '        try:\n' +
            '            from scipy.integrate import quad as _quad\n' +
            '            from math import isfinite as _isf\n' +
            '            _f = lambdify(v, expr, "numpy")\n' +
            '            _val, _err = _quad(_f, float(a), float(b), limit=100)\n' +
            '            if not _isf(_val) or (abs(_val) > 1e-10 and abs(_err/_val) > 0.01):\n' +
            '                raise ValueError("divergent")\n' +
            '            print("NUMERIC:" + str(_val))\n' +
            '        except:\n' +
            '            print("NUMERIC:NaN")\n' +
            '        print("STEPS:" + json.dumps([\n' +
            '            {"title":"Integral","latex":"\\\\int_{"+latex(a)+"}^{"+latex(b)+"} "+latex(expr)+"\\\\,d"+str(v)},\n' +
            '            {"title":"No closed-form antiderivative","latex":"\\\\text{Evaluated numerically}"}\n' +
            '        ]))\n' +
            '    else:\n' +
            '        result = integrate(expr, (v, a, b))\n' +
            '        print("LATEX:" + latex(result))\n' +
            '        print("TEXT:" + str(result))\n' +
            '        print("ANTIDERIV:" + latex(antideriv))\n' +
            '        try:\n' +
            '            print("NUMERIC:" + str(float(result)))\n' +
            '        except:\n' +
            '            print("NUMERIC:NaN")\n' +
            '        st = []\n' +
            '        if _s_obj and not isinstance(_s_obj, DontKnowRule):\n' +
            '            st = r2s(_s_obj, v)\n' +
            '        if not st:\n' +
            '            st.append({"title":"Antiderivative","latex":"\\\\int "+latex(expr)+"\\\\,d"+str(v)+" = "+latex(antideriv)+" + C"})\n' +
            '        try:\n' +
            '            def _ev(bound):\n' +
            '                if bound == oo: return limit(antideriv, v, oo)\n' +
            '                if bound == -oo: return limit(antideriv, v, -oo)\n' +
            '                return antideriv.subs(v, bound)\n' +
            '            v_u = _ev(b); v_l = _ev(a)\n' +
            '            a_tex = "\\\\infty" if a == oo else ("-\\\\infty" if a == -oo else latex(a))\n' +
            '            b_tex = "\\\\infty" if b == oo else ("-\\\\infty" if b == -oo else latex(b))\n' +
            '            ev_latex = r"\\left[ " + latex(antideriv) + r" \\right]_{" + a_tex + "}^{" + b_tex + "} = " + latex(v_u) + " - (" + latex(v_l) + ") = " + latex(result)\n' +
            '            st.append({"title":"Evaluate at bounds","latex":ev_latex})\n' +
            '        except:\n' +
            '            st.append({"title":"Evaluate at bounds","latex":"\\\\left["+latex(antideriv)+"\\\\right]_{"+latex(a)+"}^{"+latex(b)+"} = "+latex(result)})\n' +
            '        print("STEPS:" + json.dumps(st))\n' +
            'else:\n' +
            '    result = antideriv\n' +
            '    print("LATEX:" + latex(result))\n' +
            '    print("TEXT:" + str(result))\n' +
            '    st = []\n' +
            '    if not isinstance(result, Integral) and not result.has(Integral):\n' +
            '        if _s_obj and not isinstance(_s_obj, DontKnowRule):\n' +
            '            st = r2s(_s_obj, v)\n' +
            '        if not st:\n' +
            '            st.append({"title":"Result","latex":"\\\\int "+latex(expr)+"\\\\,d"+str(v)+" = "+latex(result)+" + C"})\n' +
            '    elif isinstance(result, Integral) or result.has(Integral):\n' +
            '        st.append({"title":"Identify the integral","latex":"\\\\int "+latex(expr)+"\\\\,d"+str(v)})\n' +
            '        st.append({"title":"Conclusion","latex":"\\\\text{This integral cannot be expressed using elementary functions.}"})\n' +
            '    print("STEPS:" + json.dumps(st))\n';

        fetch((window.INTEGRAL_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();

            if (!stdout && stderr) throw new Error(stderr.split('\n').pop() || 'Solver error');
            if (!stdout) throw new Error('No result from solver');

            var latexMatch = stdout.match(/LATEX:([^\n]*)/);
            var textMatch = stdout.match(/TEXT:([^\n]*)/);
            var numericMatch = stdout.match(/NUMERIC:([^\n]*)/);
            var antiderivMatch = stdout.match(/ANTIDERIV:([^\n]*)/);
            var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?:\n|$)/);
            var resultTeX = latexMatch ? latexMatch[1].trim() : '';
            var resultText = textMatch ? textMatch[1].trim() : resultTeX;
            var antiderivLatex = antiderivMatch ? antiderivMatch[1].trim() : '';
            var hasNumeric = numericMatch && numericMatch[1].trim() !== 'NaN' && numericMatch[1].trim() !== '';

            // Check for unevaluated Integral — allow through if we have numeric value
            if (resultTeX.indexOf('Integral') !== -1 && !hasNumeric) {
                throw new Error('Could not solve this integral');
            }

            // Build result HTML
            var html = '';
            if (isDefinite) {
                var numVal = numericMatch ? parseFloat(numericMatch[1].trim()) : NaN;
                html += '<div class="itm-result-integral" id="itm-ri-' + idx + '"></div>';
                html += '<div class="itm-result-answer" id="itm-ra-' + idx + '"></div>';
                if (isFinite(numVal)) {
                    html += '<div style="font-size:0.8125rem;color:var(--text-secondary);margin-top:0.25rem;">&asymp; ' + ic.escapeHtml(numVal.toFixed(6)) + '</div>';
                }
            } else {
                html += '<div class="itm-result-integral" id="itm-ri-' + idx + '"></div>';
                html += '<div class="itm-result-answer" id="itm-ra-' + idx + '"></div>';
            }

            // Steps toggle
            var steps = [];
            if (stepsMatch) { try { steps = JSON.parse(stepsMatch[1]); } catch (e) {} }
            if (steps.length) {
                html += '<button class="itm-result-steps-btn" data-steps-idx="' + idx + '">Show Steps</button>';
                html += '<div class="itm-result-steps-area" id="itm-rsa-' + idx + '">';
                steps.forEach(function (s) {
                    html += '<div class="itm-result-step"><div class="itm-result-step-title">' + ic.escapeHtml(s.title) + '</div><div id="itm-rst-' + idx + '-' + Math.random().toString(36).substr(2, 5) + '" data-step-katex="' + ic.escapeHtml(s.latex).replace(/"/g, '&quot;') + '"></div></div>';
                });
                html += '</div>';
            }

            bodyEl.innerHTML = html;

            // KaTeX render
            if (window.katex) {
                var integralEl = document.getElementById('itm-ri-' + idx);
                var answerEl = document.getElementById('itm-ra-' + idx);
                if (integralEl) {
                    try {
                        var integralTeX = isDefinite
                            ? '\\int_{' + (latexToCalcExpr(p.lower)||'0') + '}^{' + (latexToCalcExpr(p.upper)||'1') + '} ' + ic.exprToLatex(expr) + ' \\, d' + v
                            : '\\int ' + ic.exprToLatex(expr) + ' \\, d' + v;
                        katex.render(integralTeX, integralEl, { throwOnError: false, displayMode: false });
                    } catch (e) {}
                }
                if (answerEl) {
                    try {
                        var ansTeX = isDefinite ? resultTeX : resultTeX + ' + C';
                        katex.render('= ' + ic.prepareLatexForKatex(ansTeX), answerEl, { throwOnError: false, displayMode: true });
                    } catch (e) { answerEl.textContent = '= ' + resultText; }
                }
                // Render step equations (normalize \\cmd → \cmd for KaTeX)
                bodyEl.querySelectorAll('[data-step-katex]').forEach(function (el) {
                    var raw = el.getAttribute('data-step-katex');
                    var tex = ic.prepareLatexForKatex(raw);
                    try { katex.render(tex, el, { throwOnError: false, displayMode: true }); }
                    catch (e) { el.textContent = raw; }
                });
            }

            // Wire steps toggle
            var stepsBtn = bodyEl.querySelector('[data-steps-idx="' + idx + '"]');
            if (stepsBtn) {
                stepsBtn.addEventListener('click', function () {
                    var area = document.getElementById('itm-rsa-' + idx);
                    if (area) {
                        area.classList.toggle('open');
                        stepsBtn.textContent = area.classList.contains('open') ? 'Hide Steps' : 'Show Steps';
                    }
                });
            }

            // Mark done
            card.className = 'itm-result-card solved';
            status.className = 'itm-result-status done';
            status.textContent = 'Solved';
        })
        .catch(function (err) {
            card.className = 'itm-result-card error';
            status.className = 'itm-result-status fail';
            status.textContent = 'Failed';
            bodyEl.innerHTML = '<div class="itm-result-error-msg">' + ic.escapeHtml(err.message) + '</div>';
        })
        .finally(function () {
            // Solve next
            solveNext(problems, idx + 1, ic);
        });
    }

    /**
     * Convert LaTeX → calculator expression.
     *
     * We no longer maintain a hand-rolled regex pipeline. MathLive (already
     * loaded on the page) ships a battle-tested LaTeX parser that can re-emit
     * its AST as AsciiMath, which is exactly the dialect our calculator
     * speaks. We use an off-screen read-only <math-field> as a thin adapter:
     *
     *     LaTeX  --(mf.setValue, format:'latex')-->  MathLive AST
     *     calc-expr  <--(mf.getValue, 'ascii-math')--+
     *
     * Then normalizeExpr canonicalises implicit multiplication, shorthand
     * forms, and the infty→Infinity mapping.
     *
     * Called from the image-scan flow (onSelect, batchSolveIntegrals) and
     * the batch KaTeX render for bounds. Gracefully degrades to a tiny
     * string-strip if MathLive hasn't upgraded yet (rare — ESM loads in <head>).
     */
    var _latexParserMF = null;
    function latexToCalcExpr(latex) {
        if (!latex || typeof latex !== 'string') return '';
        var tex = latex.trim();
        if (!tex) return '';

        if (!(window.customElements && customElements.get('math-field'))) {
            // Pre-upgrade fallback: cover the handful of symbols most AI
            // extractions emit for plain bounds ("0", "1", "\\pi", "\\infty").
            return tex.replace(/\\pi\b/g, 'pi')
                      .replace(/\\(?:infty|infinity)\b/g, 'Infinity')
                      .replace(/[{}\\]/g, '');
        }

        try {
            if (!_latexParserMF) {
                _latexParserMF = document.createElement('math-field');
                _latexParserMF.setAttribute('read-only', '');
                _latexParserMF.style.cssText =
                    'position:absolute;left:-9999px;top:-9999px;width:1px;height:1px;' +
                    'visibility:hidden;pointer-events:none;opacity:0;';
                document.body.appendChild(_latexParserMF);
            }
            _latexParserMF.setValue(tex, { format: 'latex', silenceNotifications: true });
            var ascii = '';
            try { ascii = (_latexParserMF.getValue('ascii-math') || '').trim(); } catch (_) {}
            if (!ascii) return '';

            if (typeof IntegralCalculatorCore !== 'undefined' && IntegralCalculatorCore.normalizeExpr) {
                ascii = IntegralCalculatorCore.normalizeExpr(ascii);
            }
            return ascii;
        } catch (_) {
            return '';
        }
    }

    /**
     * Parse a full-integral LaTeX or AsciiMath expression via the backend.
     *
     * No client-side regex. The backend runs SymPy's parse_latex(backend='lark')
     * which is the authoritative reference implementation — whatever shape the
     * user pastes (textbook LaTeX, MathLive export with \differentialD, ASCII
     * "int_0^10 ... dx"), if SymPy can parse it, we can use it.
     *
     * Callback receives { ok, integrand, variable, is_definite, lower?, upper? }
     * on success, or { ok: false, error } on parse failure. Integrand and bounds
     * are returned in calculator-friendly plain-text form (** → ^, so the
     * existing Nerdamer / normalizeExpr path consumes them unchanged).
     */
    function parseIntegralViaBackend(raw, callback) {
        var s = (raw || '').trim();
        if (!s) { callback({ ok: false, error: 'empty input' }); return; }

        // Escape for a Python raw-triple-quoted string literal. The only char
        // we have to fear is a closing triple-quote sequence, which SymPy's
        // integrand alphabet essentially never contains, but guard anyway.
        var pyLiteral = s.replace(/"""/g, '\\"\\"\\"');

        var code =
            'import json, re, sys\n' +
            'from sympy.parsing.latex import parse_latex\n' +
            'from sympy import Integral\n' +
            '\n' +
            'LATEX = r"""' + pyLiteral + '"""\n' +
            '# Strip sizing commands parse_latex cannot handle\n' +
            'LATEX = re.sub(r"\\\\left\\s*([({\\\\[|])", r"\\1", LATEX)\n' +
            'LATEX = re.sub(r"\\\\right\\s*([)}\\\\]|])", r"\\1", LATEX)\n' +
            'LATEX = re.sub(r"\\\\(?:Big[lrg]?|bigl|bigr|Bigl|Bigr)\\s*", "", LATEX)\n' +
            'out = {"ok": False}\n' +
            'try:\n' +
            '    try:\n' +
            '        parsed = parse_latex(LATEX)\n' +
            '    except Exception:\n' +
            '        parsed = parse_latex(LATEX, backend="lark")\n' +
            '    # lark can return a Tree(_ambig, [option1, option2, ...]) when\n' +
            '    # the grammar is ambiguous (e.g. f(x) could be call-or-product).\n' +
            '    # Pick the first Integral child if present, else the first child.\n' +
            '    if getattr(parsed, "data", None) == "_ambig":\n' +
            '        cands = [c for c in parsed.children if isinstance(c, Integral)]\n' +
            '        parsed = cands[0] if cands else parsed.children[0]\n' +
            '    if not isinstance(parsed, Integral):\n' +
            '        out["error"] = "Not a full integral expression"\n' +
            '    else:\n' +
            '        expr = parsed.function.subs(Symbol("e"), E)\n' +
            '        limits = parsed.limits[0]\n' +
            '        # SymPy str() uses **, Python-style; calculator uses ^.\n' +
            '        def asc(s): return str(s).replace("**", "^")\n' +
            '        out = {\n' +
            '            "ok": True,\n' +
            '            "integrand": asc(expr),\n' +
            '            "variable": str(limits[0]),\n' +
            '            "is_definite": len(limits) == 3,\n' +
            '        }\n' +
            '        if len(limits) == 3:\n' +
            '            out["lower"] = asc(limits[1])\n' +
            '            out["upper"] = asc(limits[2])\n' +
            'except Exception as e:\n' +
            '    out = {"ok": False, "error": type(e).__name__ + ": " + str(e)}\n' +
            'print("RESULT:" + json.dumps(out))\n';

        fetch((window.INTEGRAL_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            var stdout = (data.Stdout || data.stdout || '').trim();
            var m = stdout.match(/RESULT:(\{[\s\S]*\})/);
            if (!m) {
                callback({ ok: false, error: 'no backend response' });
                return;
            }
            try { callback(JSON.parse(m[1])); }
            catch (e) { callback({ ok: false, error: 'bad backend JSON' }); }
        })
        .catch(function (err) {
            callback({ ok: false, error: err.message || 'network error' });
        });
    }

    // Shape detector: "is this a full integral the user wants us to solve?"
    // Intentionally minimal — we don't PARSE here, just decide whether to
    // route the request to the backend parse_latex. Any shape this gate
    // misses stays on the normal (typed-integrand) path, which is fine.
    function looksLikeLatexIntegral(s) {
        if (!s || typeof s !== 'string') return false;
        return /\\int\b/.test(s)                 // LaTeX \int
            || /^\s*int(?=[_^\s(]|$)/i.test(s);  // AsciiMath int, int_, int^, int(
    }

    if (window.IC) {
        window.IC.parseIntegralViaBackend = parseIntegralViaBackend;
        window.IC.looksLikeLatexIntegral = looksLikeLatexIntegral;
    }
</script>

</body>
</html>
