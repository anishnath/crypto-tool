<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- SEO (competitive targeting: integral-calculator.com #1, Symbolab, Wolfram, Mathway).
         Ported verbatim from the original integral-calculator.jsp so the new template
         inherits every long-tail keyword, FAQ schema entry, HowTo schema, and
         LearningResource/Course schema signal. DO NOT trim this without checking
         Search Console impact first. -->
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <!-- Fonts: Inter (UI body), JetBrains Mono (code/math), Instrument Serif (display) -->
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

    <!-- New math shell (sidebar tree + workspace layout) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <!-- Tool-specific CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/integral-calculator.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css?v=<%=v%>">

    <!-- KaTeX + MathLive -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- All stacked-layout + tool-header styles now live in math-studio.css -->

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

    <% request.setAttribute("activeService", "integral-calculator"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Slim title row — no card, just type -->
        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Integral</span>
            </nav>
            <h1>Integral Calculator</h1>
        </header>

        <!-- Stacked layout: compact input hero on top, result card below.
             All IDs match the originals so the script partial binds cleanly. -->
        <div class="ic-stack">

            <!-- ═══ INPUT HERO ═══ -->
            <!-- data-input-mode="visual" pre-seeded so the preview block
                 stays hidden on first paint; the IIFE re-applies this
                 (and may switch to text) once scripts load. -->
            <div class="ic-hero" id="ic-hero" data-input-mode="visual">

                <!-- Top row: Indef/Def toggle ← → Visual/Text + Scan -->
                <div class="ic-hero-top">
                    <div class="ic-mode-toggle" role="radiogroup" aria-label="Integral mode">
                        <button type="button" class="ic-mode-btn active" data-mode="indefinite" role="radio" aria-checked="true" title="Antiderivative: result is a family of functions + C">Indefinite</button>
                        <button type="button" class="ic-mode-btn" data-mode="definite" role="radio" aria-checked="false" title="Signed area under the curve between bounds a and b">Definite</button>
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
                        <button type="button" class="ic-image-btn" id="ic-image-btn" title="Scan problem from image">&#128247; Scan</button>
                    </div>
                </div>

                <!-- Function input.  No explicit label / hint — the
                     placeholder and the Integrate button carry the job. -->
                <div class="ic-expr-wrap" id="ic-expr-wrap">
                    <math-field id="ic-mathfield" class="ic-mathfield" aria-label="Function to integrate"
                                placeholder="\frac{1}{x^2+1}"
                                smart-mode="on" smart-fence="on" smart-superscript="on"
                                remove-extraneous-parentheses="on" math-mode-space="\:"></math-field>

                    <input type="text" class="tool-input tool-input-mono" id="ic-expr"
                           placeholder="e.g.  sin(3*x)   or   x^2 + 3*x"
                           autocomplete="off" spellcheck="false" aria-label="Function to integrate">
                    <div class="ic-autocomplete" id="ic-autocomplete"></div>

                    <!-- Hints kept but only the mode-matching span is
                         shown by integral-calculator.css; together they
                         render as one line. -->
                    <span class="tool-form-hint ic-expr-hint">
                            <span class="ic-hint-visual">Type <code>sin</code>, <code>sqrt</code>, <code>^</code>, <code>/</code> naturally.</span>
                            <span class="ic-hint-text">Shorthand like <code>sin3x</code> works.</span>
                        </span>
                </div>

                <!-- Live preview strip -->
                <div class="ic-preview-strip">
                    <span class="ic-preview-label">Preview</span>
                    <span class="ic-preview" id="ic-preview">type a function above&hellip;</span>
                </div>

                <!-- Params row: variable always, bounds only for definite -->
                <div class="ic-hero-params" id="ic-bounds">
                    <div class="tool-form-group">
                        <label for="ic-var">Variable</label>
                        <select class="tool-select" id="ic-var">
                            <option value="x" selected>x</option>
                            <option value="y">y</option>
                            <option value="z">z</option>
                            <option value="t">t</option>
                            <option value="u">u</option>
                            <option value="theta">&theta;</option>
                        </select>
                    </div>
                    <div class="tool-form-group ic-bounds-group">
                        <label for="ic-lower">Lower (a)</label>
                        <input type="text" class="tool-input tool-input-mono" id="ic-lower" value="0" placeholder="0">
                    </div>
                    <div class="tool-form-group ic-bounds-group">
                        <label for="ic-upper">Upper (b)</label>
                        <input type="text" class="tool-input tool-input-mono" id="ic-upper" value="1" placeholder="1">
                    </div>
                </div>

                <!-- Primary CTA -->
                <button type="button" class="ic-hero-cta" id="ic-integrate-btn">Integrate</button>

                <!-- Examples by method — collapsed by default.  Native
                     <details> is the simplest, accessible choice; the
                     .ic-example-chip buttons inside stay in the DOM so
                     the script's click bindings fire regardless. -->
                <details class="ic-hero-methods" id="ic-examples">
                    <summary class="ic-hero-methods-summary">
                        <span>Examples by method</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body">
                        <div class="ic-method-row">
                            <span class="ic-method-label">Power rule</span>
                            <button type="button" class="ic-example-chip" data-expr="x^2+3*x">x²&nbsp;+&nbsp;3x</button>
                            <button type="button" class="ic-example-chip" data-expr="x^5">x⁵</button>
                            <button type="button" class="ic-example-chip" data-expr="sqrt(x)">√x</button>
                        </div>
                        <div class="ic-method-row">
                            <span class="ic-method-label">u-sub</span>
                            <button type="button" class="ic-example-chip" data-expr="sin(3*x)">sin(3x)</button>
                            <button type="button" class="ic-example-chip" data-expr="sin(x)*cos(x)">sin·cos</button>
                            <button type="button" class="ic-example-chip" data-expr="x*e^(x^2)">x·e^(x²)</button>
                        </div>
                        <div class="ic-method-row">
                            <span class="ic-method-label">By parts</span>
                            <button type="button" class="ic-example-chip" data-expr="x*e^(-x)">x·e⁻ˣ</button>
                            <button type="button" class="ic-example-chip" data-expr="x^2*log(x)">x²·ln(x)</button>
                            <button type="button" class="ic-example-chip" data-expr="x*cos(x)">x·cos(x)</button>
                        </div>
                        <div class="ic-method-row">
                            <span class="ic-method-label">Rational</span>
                            <button type="button" class="ic-example-chip" data-expr="1/(x^2+1)">1/(x²+1)</button>
                            <button type="button" class="ic-example-chip" data-expr="1/((x-1)*(x+2))">1/((x−1)(x+2))</button>
                            <button type="button" class="ic-example-chip" data-expr="1/sqrt(1-x^2)">1/√(1−x²)</button>
                        </div>
                        <div class="ic-method-row">
                            <span class="ic-method-label">Trig / log</span>
                            <button type="button" class="ic-example-chip" data-expr="sec(x)^2">sec²(x)</button>
                            <button type="button" class="ic-example-chip" data-expr="log(x)">ln(x)</button>
                            <button type="button" class="ic-example-chip" data-expr="e^x*x^2">eˣ·x²</button>
                        </div>
                    </div>
                </details>

                <!-- Collapsible syntax help.  Plain <button>+<div>
                     because the main script binds click on #ic-syntax-btn
                     and toggles .open on #ic-syntax-content. -->
                <div class="ic-hero-syntax" id="ic-syntax-wrap">
                    <button type="button" class="ic-syntax-toggle" id="ic-syntax-btn">
                        Syntax help
                        <svg class="ic-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="ic-syntax-content" id="ic-syntax-content">
                        <strong>Trig:</strong> <code>sin(3*x)</code> or shorthand <code>sin3x</code>.<br>
                        x^2, sin(x), cos(x), tan(x), e^x, log(x)=ln(x), sqrt(x)<br>
                        sec(x), csc(x), cot(x), sinh(x), cosh(x), tanh(x)<br>
                        asin(x), acos(x), atan(x), pi, e, abs(x), 1/x<br>
                        <strong>SymPy one-liner:</strong> <code>integrand, (variable, a, b)</code>
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

                <div class="ic-panel active" id="ic-panel-result" role="tabpanel">
                    <div class="tool-card tool-result-card">
                        <div class="tool-result-content" id="ic-result-content">
                            <div class="tool-empty-state ic-empty-state" id="ic-empty-state">
                                <div class="ic-empty-illustration">&#8747;</div>
                                <h3>Ready when you are</h3>
                                <p>Type a function above and hit <strong>Integrate</strong>.</p>
                            </div>
                        </div>
                        <!-- Secondary actions — uniform pill buttons, no emoji
                             (clean text reads more premium and guarantees the
                             four buttons look identical). -->
                        <div class="tool-result-actions" id="ic-result-actions">
                            <button type="button" class="tool-action-btn" id="ic-copy-latex-btn">Copy LaTeX</button>
                            <button type="button" class="tool-action-btn" id="ic-copy-text-btn">Copy Text</button>
                            <button type="button" class="tool-action-btn" id="ic-share-btn">Share</button>
                            <button type="button" class="tool-action-btn" id="ic-download-pdf-btn">Download PDF</button>
                        </div>

                        <!-- Primary next-step CTA — full-width gradient so it
                             reads as the "what to do after you understand
                             the solution" affordance. -->
                        <div class="ic-worksheet-cta">
                            <button type="button" class="tool-action-btn" id="ic-worksheet-btn">
                                Practice Integration Worksheet — 1000+ problems
                            </button>
                        </div>
                    </div>
                </div>

                <div class="ic-panel" id="ic-panel-graph" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                        <div style="flex:1;min-height:360px;">
                            <div id="ic-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                            <p id="ic-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Integrate a function to see its graph.</p>
                        </div>
                    </div>
                </div>

                <div class="ic-panel" id="ic-panel-python" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                        <div style="display:flex;align-items:center;gap:0.5rem;padding:0.6rem 0.25rem;">
                            <span style="font-size:0.78rem;color:var(--ms-muted);font-weight:600;">Template:</span>
                            <select id="ic-compiler-template" style="padding:0.35rem 0.6rem;border:1px solid var(--ms-panel-border);border-radius:6px;font-size:0.8rem;background:var(--ms-panel-bg);color:var(--ms-text);">
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
        </div>

        <!-- In-content ad (mobile/tablet) -->
        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Methods band.  Lighter treatment than the hero/result —
             reads as supporting reference, not competing panels. -->
        <section class="ic-learn" aria-label="Integration methods">
            <article class="ic-learn-card">
                <span class="ic-learn-method">Power rule</span>
                <code class="ic-learn-formula">&#8747; x<sup>n</sup> dx = x<sup>n+1</sup>/(n+1) + C</code>
            </article>
            <article class="ic-learn-card">
                <span class="ic-learn-method">u-substitution</span>
                <code class="ic-learn-formula">&#8747; f(g(x))&middot;g&prime;(x) dx = &#8747; f(u) du</code>
            </article>
            <article class="ic-learn-card">
                <span class="ic-learn-method">By parts</span>
                <code class="ic-learn-formula">&#8747; u dv = uv &minus; &#8747; v du</code>
            </article>
        </section>

    </section>

    <!-- Right ad rail (desktop ≥1280px) -->
    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<!-- Visible FAQ — same 8 Q&A the FAQPage schema emits via jsp:param,
     rendered as an accordion so users find answers AND Google sees the
     content in the DOM (not just in structured data).  Keep in sync
     with the faqNq/faqNa params in <head>. -->
<section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
    <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
    <div class="ms-faq" aria-label="Integral calculator FAQ">
        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">
                Does this integral calculator have a printable practice worksheet?
                <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="ms-faq-a">Yes. Click the Print Worksheet button to open a bank of 1,000+ integration practice problems with full answer keys. Problems are organised by type (power rule, u-substitution, integration by parts, partial fractions, trig substitution, definite integrals) and four difficulty levels (basic, medium, hard, scholar). Filter, print, or work through them on screen &mdash; perfect for AP Calculus, college calculus, or self-study.</div>
        </div>
        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">
                What types of integrals can this calculator solve?
                <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="ms-faq-a">Indefinite integrals (antiderivatives) and definite integrals for polynomials, trigonometric functions (sin, cos, tan, sec, csc, cot), exponentials (e^x), logarithms (ln x), rational functions, hyperbolic functions (sinh, cosh, tanh), inverse trig (arctan, arcsin), and products solved by integration by parts. Handles power rule, u-substitution, and partial fractions.</div>
        </div>
        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">
                Does this integral calculator show step-by-step solutions?
                <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="ms-faq-a">Yes. After computing a result, click <strong>Show Steps</strong> to see a detailed step-by-step solution. For common integrals (power rule, basic trig, exponential), steps are generated instantly in your browser. For complex integrals like integration by parts or partial fractions, the advanced solver explains each algebraic manipulation, substitution, and simplification in 5&ndash;8 clear steps with full LaTeX math rendering.</div>
        </div>
        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">
                Can I use this for AP Calculus or college exam prep?
                <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="ms-faq-a">Absolutely. The built-in worksheet has 1,000+ curated problems covering every integration topic on the AP Calculus AB/BC exam and standard college Calculus II courses: power rule, u-substitution, integration by parts, partial fractions, trig substitution, improper integrals, and area/volume applications. Each problem includes a verified answer. Use the difficulty filter to ramp from easy to exam-level.</div>
        </div>
        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">
                Can I download or share my integral solution?
                <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="ms-faq-a">Yes &mdash; four ways: (1) <strong>Download PDF</strong> with the question, answer, method, and step-by-step solution beautifully formatted, (2) <strong>Copy LaTeX</strong> for papers and documents, (3) <strong>Copy Text</strong> for plain email/chat, or (4) <strong>Share</strong> to generate a URL that re-loads your exact integral with one click.</div>
        </div>
        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">
                What&rsquo;s the difference between indefinite and definite integrals?
                <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="ms-faq-a">An <strong>indefinite</strong> integral finds the antiderivative F(x) + C &mdash; a family of functions whose derivative equals f(x). A <strong>definite</strong> integral evaluates the net signed area under the curve between bounds [a, b] using the Fundamental Theorem of Calculus: F(b) &minus; F(a). This calculator supports both modes via a simple toggle; the interactive graph shades the area for definite integrals.</div>
        </div>
        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">
                Is this integral calculator free? Do I need to sign up?
                <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="ms-faq-a">Completely free with no signup, no account, and no limits. You get symbolic integration, step-by-step solutions, interactive graphs, PDF download, LaTeX export, a 1,000+ problem worksheet, and a built-in Python compiler. All computation runs in your browser for instant results.</div>
        </div>
        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">
                How does u-substitution work in this integral calculator?
                <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </button>
            <div class="ms-faq-a">U-substitution (change of variables) rewrites &int; f(g(x))&middot;g&prime;(x) dx as &int; f(u) du by letting u = g(x). The calculator auto-detects when u-sub applies and shows the substitution step. Example: &int; 2x&middot;cos(x&sup2;) dx becomes &int; cos(u) du with u = x&sup2;. Click <strong>Show Steps</strong> to see the full u-sub workflow.</div>
        </div>
    </div>
</section>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<!-- All tool scripts (KaTeX + MathLive ES module + nerdamer CAS + the
     785-line inline IIFEs for mode-toggle/math-field sync + image-to-math
     scanner) live in a shared partial so integral-calculator.jsp and this
     file stay in lockstep.  Do NOT inline any of these scripts here —
     the partial is the single source of truth. -->
<jsp:include page="/math/partials/integral-calculator-scripts.jsp" />

<!-- Integrate-button UX: prevent double-fire during compute + auto-scroll
     the result into view.
       · Click → lock the button (.is-busy adds spinner + pointer-events:none).
       · MutationObserver watches #ic-result-content for the script's
         injected result HTML; as soon as something changes, we unlock.
       · Safety timeout (30 s) unlocks in case the compute errors out
         without mutating the DOM.
     Zero change to the shared integral-calculator.js — pure UI layer. -->
<script>
    (function () {
        var btn = document.getElementById('ic-integrate-btn');
        var target = document.getElementById('ic-panel-result');
        var resultContent = document.getElementById('ic-result-content');
        if (!btn || !target || !resultContent) return;

        var safetyTimer = null;
        var resultObserver = null;

        function unlock() {
            btn.classList.remove('is-busy');
            if (safetyTimer) { clearTimeout(safetyTimer); safetyTimer = null; }
            if (resultObserver) { resultObserver.disconnect(); resultObserver = null; }
        }

        function lock() {
            if (btn.classList.contains('is-busy')) return false; // already locked
            btn.classList.add('is-busy');
            // Watch for the result script to replace / mutate the content.
            if ('MutationObserver' in window) {
                resultObserver = new MutationObserver(function () { unlock(); });
                resultObserver.observe(resultContent, { childList: true, subtree: true, characterData: true });
            }
            // Safety: unlock after 30 s no matter what.
            safetyTimer = setTimeout(unlock, 30000);
            return true;
        }

        // Intercept click in the CAPTURE phase so we short-circuit if
        // another handler is already running.  The button has no native
        // `disabled` state because we don't want the label to change —
        // just the visual busy indicator.
        btn.addEventListener('click', function (e) {
            if (btn.classList.contains('is-busy')) {
                e.preventDefault();
                e.stopImmediatePropagation();
                return false;
            }
            lock();
            // Scroll AFTER render, not immediately, so the result is in place.
            if (target.scrollIntoView) {
                setTimeout(function () {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }, 140);
            }
        }, true);
    })();

    // FAQ accordion — single click handler, class toggle.
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
