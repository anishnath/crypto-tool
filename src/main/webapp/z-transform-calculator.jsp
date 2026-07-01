<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String v = String.valueOf(System.currentTimeMillis());
    request.setAttribute("aiToolId", "math-ai");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />
    <meta name="robots" content="index,follow">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Z-Transform Calculator with Steps - Forward & Inverse | Free" />
        <jsp:param name="toolDescription" value="Free online Z-transform calculator. Compute forward and inverse Z-transforms with detailed step-by-step solutions. Features common Z-transform pairs table, region of convergence, discrete stem plots, Math AI tutor, and built-in Python compiler. No signup required." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="z-transform-calculator.jsp" />
        <jsp:param name="toolKeywords" value="z-transform calculator, inverse z-transform calculator, z-transform with steps, z-transform table, discrete-time signals, digital signal processing, transfer function, difference equations, region of convergence, partial fractions" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Forward Z-transform with steps,Inverse Z-transform with steps,Common Z-transform pairs reference table,Region of convergence (ROC),Partial fraction decomposition,Discrete stem plot graph,Live KaTeX math preview,Math AI tutor in chat,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is the Z-transform?" />
        <jsp:param name="faq1a" value="The Z-transform converts a discrete-time sequence x[n] into a complex function X(z) using the sum Z{x[n]} = sum from n=0 to infinity of x[n]*z^(-n). It is the discrete-time counterpart of the Laplace transform and is fundamental in digital signal processing and control systems." />
        <jsp:param name="faq2q" value="How do you compute the inverse Z-transform?" />
        <jsp:param name="faq2a" value="The most common method for computing the inverse Z-transform is the residue method: compute X(z)*z^(n-1), find the poles of the denominator, and sum the residues at each pole. Alternatively, use partial fraction decomposition on X(z)/z, then look up each term in a Z-transform table." />
        <jsp:param name="faq3q" value="What is the region of convergence (ROC)?" />
        <jsp:param name="faq3a" value="The region of convergence is the set of complex values of z for which the Z-transform sum converges. For causal sequences (n >= 0), the ROC is the exterior of a circle |z| > r. The ROC determines the uniqueness of the inverse Z-transform." />
        <jsp:param name="faq4q" value="What is the difference between Z-transform and Laplace transform?" />
        <jsp:param name="faq4a" value="The Laplace transform is for continuous-time signals f(t) and uses integration, while the Z-transform is for discrete-time sequences x[n] and uses summation. The relationship z = e^(sT) connects them, where T is the sampling period. The Z-transform is used in digital systems." />
        <jsp:param name="faq5q" value="What is a transfer function in Z-domain?" />
        <jsp:param name="faq5a" value="A transfer function H(z) = Y(z)/X(z) describes the input-output relationship of a discrete-time linear system. It characterizes digital filters and is used to analyze stability (all poles inside the unit circle), frequency response, and system behavior." />
        <jsp:param name="faq6q" value="Is this Z-transform calculator free?" />
        <jsp:param name="faq6a" value="Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, discrete stem plots, LaTeX export, Math AI help, and a built-in Python compiler." />
    </jsp:include>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/z-transform-calculator.css?v=<%=v%>">

    <%@ include file="modern/components/math-ai-head.inc.jsp" %>

    <style>
        .ic-hero .math-ai-tab-btn {
            display: inline-flex; align-items: center; gap: 0.35rem;
            padding: 0.35rem 0.75rem; border-radius: 999px; border: 1px solid rgba(5,150,105,0.35);
            background: rgba(5,150,105,0.08); color: var(--ms-text, #1e1b4b); font-size: 0.8125rem;
            font-weight: 600; cursor: pointer; transition: background 0.15s, transform 0.15s, box-shadow 0.15s;
            white-space: nowrap;
        }
        .ic-hero .math-ai-tab-btn:hover {
            background: rgba(5,150,105,0.18); transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(5,150,105,0.15);
        }
        .ic-hero .math-ai-tab-btn[aria-busy="true"] { opacity: 0.75; cursor: wait; }
    </style>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
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

    <% request.setAttribute("activeService", "ztransform"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Z-Transform</span>
            </nav>
            <h1>Z-Transform Calculator</h1>
            <p class="ms-subtitle">Forward &amp; inverse Z{x[n]} &middot; partial fractions &middot; ROC &middot; step-by-step</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact" id="zt-hero">
                <div class="ic-hero-top">
                    <div class="zt-mode-toggle" role="radiogroup" aria-label="Transform mode">
                        <button type="button" class="zt-mode-btn active" data-mode="forward" role="radio" aria-checked="true">Forward Z{x}</button>
                        <button type="button" class="zt-mode-btn" data-mode="inverse" role="radio" aria-checked="false">Inverse Z&#8315;&#185;</button>
                    </div>
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — Z-transform tutor + calculus in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>

                <div class="zt-hero-core">
                    <div id="zt-forward-wrap" class="zt-mode-panel">
                        <label class="zt-field-label" for="zt-forward-expr">x[n]</label>
                        <input type="text" class="tool-input tool-input-mono zt-main-input" id="zt-forward-expr" placeholder="e.g. (1/2)^n" autocomplete="off" spellcheck="false">
                    </div>

                    <div id="zt-inverse-wrap" class="zt-mode-panel" style="display:none;">
                        <label class="zt-field-label" for="zt-inverse-expr">X(z)</label>
                        <input type="text" class="tool-input tool-input-mono zt-main-input" id="zt-inverse-expr" placeholder="e.g. z/(z-1/2)" autocomplete="off" spellcheck="false">
                    </div>

                    <div class="zt-preview-strip">
                        <span class="zt-preview-label">Preview</span>
                        <div class="zt-preview" id="zt-preview">
                            <span class="zt-preview-placeholder">Type above&hellip;</span>
                        </div>
                    </div>

                    <div class="ic-hero-cta-row zt-hero-cta-row">
                        <button type="button" class="ic-hero-cta" id="zt-compute-btn">Compute Transform</button>
                        <button type="button" class="zt-random-btn" id="zt-random-btn" title="Random example">&#127922;</button>
                    </div>
                </div>

                <details class="ic-hero-methods" id="zt-examples-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Quick examples</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body zt-examples-body">
                        <div class="zt-examples" id="zt-examples"></div>
                    </div>
                </details>

                <details class="ic-hero-methods" id="zt-pairs-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Common Z-transform pairs</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body">
                        <table class="zt-pairs-table">
                            <thead><tr><th>x[n]</th><th>X(z)</th><th>ROC</th></tr></thead>
                            <tbody>
                                <tr><td id="zt-pair-x0"></td><td id="zt-pair-X0"></td><td>all z</td></tr>
                                <tr><td id="zt-pair-x1"></td><td id="zt-pair-X1"></td><td>|z| &gt; 1</td></tr>
                                <tr><td id="zt-pair-x2"></td><td id="zt-pair-X2"></td><td>|z| &gt; 1</td></tr>
                                <tr><td id="zt-pair-x3"></td><td id="zt-pair-X3"></td><td>|z| &gt; |a|</td></tr>
                                <tr><td id="zt-pair-x4"></td><td id="zt-pair-X4"></td><td>|z| &gt; |a|</td></tr>
                                <tr><td id="zt-pair-x5"></td><td id="zt-pair-X5"></td><td>|z| &gt; 1</td></tr>
                                <tr><td id="zt-pair-x6"></td><td id="zt-pair-X6"></td><td>|z| &gt; 1</td></tr>
                                <tr><td id="zt-pair-x7"></td><td id="zt-pair-X7"></td><td>|z| &gt; 1</td></tr>
                                <tr><td id="zt-pair-x8"></td><td id="zt-pair-X8"></td><td>|z| &gt; 1</td></tr>
                            </tbody>
                        </table>
                    </div>
                </details>

                <details class="ic-hero-methods" id="zt-syntax-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Syntax help</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body zt-syntax-body">
                        n^2 &nbsp;&nbsp; z^3 &nbsp;&nbsp; (z-1)^2<br>
                        (1/2)^n &nbsp;&nbsp; (3/4)^n &nbsp;&nbsp; (-1)^n<br>
                        n*(1/2)^n &nbsp;&nbsp; 2^n<br>
                        sin(pi*n/3) &nbsp;&nbsp; cos(pi*n/4)<br>
                        z/(z-1) &nbsp;&nbsp; z/(z-1)^2<br>
                        z^2/((z-1)*(z-1/2))<br>
                        <strong>Multiply:</strong> <code>n*(1/2)**n</code> &nbsp;
                        <strong>Powers:</strong> <code>n^2</code> or <code>(1/2)^n</code>
                    </div>
                </details>
            </div>

            <div class="ic-result-card">
                <div class="ic-output-tabs" role="tablist">
                    <button type="button" class="ic-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                    <button type="button" class="ic-output-tab" data-panel="graph" role="tab" aria-selected="false">Graph</button>
                    <button type="button" class="ic-output-tab" data-panel="python" role="tab" aria-selected="false">Python Compiler</button>
                </div>

                <div class="ic-panel active" id="zt-panel-result" role="tabpanel">
                    <div class="tool-card tool-result-card">
                        <div class="tool-result-content" id="zt-result-content">
                            <div class="tool-empty-state" id="zt-empty-state">
                                <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">Z</div>
                                <h3>Enter an expression and click Compute</h3>
                                <p>Compute forward or inverse Z-transforms with step-by-step solutions.</p>
                            </div>
                        </div>
                        <div class="tool-result-actions" id="zt-result-actions">
                            <button type="button" class="tool-action-btn" id="zt-copy-latex-btn">Copy LaTeX</button>
                            <button type="button" class="tool-action-btn" id="zt-download-pdf-btn">Download PDF</button>
                            <button type="button" class="tool-action-btn" id="zt-share-btn">Share</button>
                            <button type="button" class="tool-action-btn" id="zt-worksheet-btn">Print Worksheet</button>
                        </div>
                    </div>
                </div>

                <div class="ic-panel" id="zt-panel-graph" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                        <div style="flex:1;min-height:360px;padding:0.75rem;">
                            <div id="zt-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                            <p id="zt-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Compute a transform to see the discrete stem plot.</p>
                        </div>
                    </div>
                </div>

                <div class="ic-panel" id="zt-panel-python" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                        <div style="flex:1;min-height:0;">
                            <iframe id="zt-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<section class="tool-expertise-section ms-below-fold" style="max-width: 100%; margin: 2rem 0 0; padding: 0;">

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is the Z-Transform?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">The Z-transform converts a discrete-time sequence x[n] into a complex function X(z). It is defined as <strong>Z{x[n]} = &Sigma;<sub>n=0</sub><sup>&infin;</sup> x[n] &middot; z<sup>&minus;n</sup></strong>, where z is a complex variable. It is the discrete-time counterpart of the Laplace transform.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">The Z-transform is fundamental in digital signal processing, discrete-time control systems, and the analysis of difference equations and digital filters.</p>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">Key Properties</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin-top: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #059669;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Linearity</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Z{ax[n] + by[n]} = aX(z) + bY(z). The transform distributes over addition and scalar multiplication.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #10b981;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Time-Shifting</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Z{x[n&minus;k]} = z<sup>&minus;k</sup>X(z). A delay of k samples corresponds to multiplication by z<sup>&minus;k</sup>.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #047857;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Z-Domain Differentiation</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Z{n&middot;x[n]} = &minus;z&middot;dX(z)/dz. Multiplication by n in the time domain becomes differentiation in the z-domain.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #34d399;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Convolution</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Z{x[n]*y[n]} = X(z)&middot;Y(z). Convolution of sequences becomes multiplication of their Z-transforms.</p>
            </div>
        </div>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the Z-transform?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The Z-transform converts a discrete-time sequence x[n] into a complex function X(z) using the sum Z{x[n]} = sum from n=0 to infinity of x[n]*z^(-n). It is the discrete-time counterpart of the Laplace transform and is fundamental in digital signal processing and control systems.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you compute the inverse Z-transform?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The most common method for computing the inverse Z-transform is the residue method: compute X(z)*z^(n-1), find the poles of the denominator, and sum the residues at each pole. Alternatively, use partial fraction decomposition on X(z)/z, then look up each term in a Z-transform table.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the region of convergence (ROC)?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The region of convergence is the set of complex values of z for which the Z-transform sum converges. For causal sequences (n >= 0), the ROC is the exterior of a circle |z| > r. The ROC determines the uniqueness of the inverse Z-transform.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between Z-transform and Laplace transform?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The Laplace transform is for continuous-time signals f(t) and uses integration, while the Z-transform is for discrete-time sequences x[n] and uses summation. The relationship z = e^(sT) connects them, where T is the sampling period.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this Z-transform calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, discrete stem plots, LaTeX export, Math AI help, and a built-in Python compiler.</div>
        </div>
    </div>
</section>

<section class="ms-below-fold" style="max-width: 100%; margin: 2rem 0 0; padding: 0;">
    <div class="tool-card" style="padding: 1.5rem 2rem;">
        <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; color: var(--text-primary);">
            <span style="font-size: 1.3rem;">&#128293;</span> Explore More Math
        </h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
            <a href="<%=request.getContextPath()%>/laplace-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #0891b2, #06b6d4); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8466;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Laplace Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Laplace transforms with steps and ROC</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/fourier-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #7c3aed, #a855f7); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8497;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Fourier Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Fourier transforms for signal analysis</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/bode-plot-generator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #dc2626, #ef4444); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.1rem; font-weight: 700; color: #fff;">H(s)</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Bode Plot Generator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Magnitude &amp; phase for transfer functions</p>
                </div>
            </a>
        </div>
    </div>
</section>

<%@ include file="modern/components/support-section.jsp" %>

    </section><!-- /.ms-workspace -->

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>

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
<script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>

<script>window.ZT_CALC_CTX = "<%=request.getContextPath()%>";</script>
<%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/z-transform-calculator.js?v=<%=v%>"></script>

<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureZTransformMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
