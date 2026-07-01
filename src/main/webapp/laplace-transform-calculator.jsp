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
        <jsp:param name="toolName" value="Laplace Transform Calculator with Steps - Forward & Inverse | Free" />
        <jsp:param name="toolDescription" value="Free online Laplace transform calculator. Compute forward and inverse Laplace transforms with detailed step-by-step solutions. Features partial fractions, region of convergence, common Laplace pairs table, 2D graph, Math AI tutor, and built-in Python compiler. No signup required." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="laplace-transform-calculator.jsp" />
        <jsp:param name="toolKeywords" value="laplace transform calculator, inverse laplace transform calculator, laplace transform with steps, laplace transform table, laplace transform of e^at, transfer function, differential equations, control systems, region of convergence, partial fractions" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Forward Laplace transform with steps,Inverse Laplace transform with steps,Common Laplace pairs reference table,Region of convergence (ROC),Partial fraction decomposition,2D function graph,Live KaTeX math preview,Math AI tutor in chat,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is the Laplace transform?" />
        <jsp:param name="faq1a" value="The Laplace transform converts a time-domain function f(t) into a complex frequency-domain function F(s) using the integral L{f(t)} = integral from 0 to infinity of f(t)*e^(-st) dt. It is widely used to solve differential equations, analyze control systems, and study circuit behavior." />
        <jsp:param name="faq2q" value="How do you compute the inverse Laplace transform?" />
        <jsp:param name="faq2a" value="The inverse Laplace transform converts F(s) back to f(t). The most common method is partial fraction decomposition: break F(s) into simpler fractions, then look up each fraction in a table of known Laplace pairs. For example, 1/(s+a) transforms back to e^(-at)." />
        <jsp:param name="faq3q" value="What is the region of convergence (ROC)?" />
        <jsp:param name="faq3a" value="The region of convergence is the set of complex values of s for which the Laplace transform integral converges. For causal signals (t >= 0), the ROC is a right half-plane Re(s) > sigma. For example, L{e^(-at)} = 1/(s+a) with ROC Re(s) > -a." />
        <jsp:param name="faq4q" value="When should I use partial fractions for inverse Laplace?" />
        <jsp:param name="faq4a" value="Use partial fractions when F(s) is a rational function (ratio of polynomials) that does not directly match a standard Laplace pair. Decomposing into simpler terms like A/(s+a) + B/(s+b) makes it easy to look up each term in the transform table." />
        <jsp:param name="faq5q" value="What is the Heaviside step function in Laplace transforms?" />
        <jsp:param name="faq5a" value="The Heaviside step function theta(t) equals 0 for t &lt; 0 and 1 for t >= 0. In Laplace transform results, it indicates that the solution is valid only for t >= 0. SymPy includes it automatically since the Laplace transform is defined for causal (one-sided) signals." />
        <jsp:param name="faq6q" value="Is this Laplace transform calculator free?" />
        <jsp:param name="faq6a" value="Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, 2D graphs, LaTeX export, Math AI help, and a built-in Python compiler." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/laplace-transform-calculator.css?v=<%=v%>">

    <%@ include file="modern/components/math-ai-head.inc.jsp" %>

    <style>
        .ic-hero .math-ai-tab-btn {
            display: inline-flex; align-items: center; gap: 0.35rem;
            padding: 0.35rem 0.75rem; border-radius: 999px; border: 1px solid rgba(8,145,178,0.35);
            background: rgba(8,145,178,0.08); color: var(--ms-text, #1e1b4b); font-size: 0.8125rem;
            font-weight: 600; cursor: pointer; transition: background 0.15s, transform 0.15s, box-shadow 0.15s;
            white-space: nowrap;
        }
        .ic-hero .math-ai-tab-btn:hover {
            background: rgba(8,145,178,0.18); transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(8,145,178,0.15);
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

    <% request.setAttribute("activeService", "laplace"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Laplace Transform</span>
            </nav>
            <h1>Laplace Transform Calculator</h1>
            <p class="ms-subtitle">Forward &amp; inverse L{f(t)} &middot; partial fractions &middot; ROC &middot; step-by-step</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact" id="lt-hero">
                <div class="ic-hero-top">
                    <div class="lt-mode-toggle" role="radiogroup" aria-label="Transform mode">
                        <button type="button" class="lt-mode-btn active" data-mode="forward" role="radio" aria-checked="true">Forward L{f}</button>
                        <button type="button" class="lt-mode-btn" data-mode="inverse" role="radio" aria-checked="false">Inverse L&#8315;&#185;</button>
                    </div>
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — Laplace tutor + calculus in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>

                <div class="lt-hero-core">
                    <div id="lt-forward-wrap" class="lt-mode-panel">
                        <label class="lt-field-label" for="lt-forward-expr">f(t)</label>
                        <input type="text" class="tool-input tool-input-mono lt-main-input" id="lt-forward-expr" placeholder="e.g. t^2*e^(-3*t)" autocomplete="off" spellcheck="false">
                    </div>

                    <div id="lt-inverse-wrap" class="lt-mode-panel" style="display:none;">
                        <label class="lt-field-label" for="lt-inverse-expr">F(s)</label>
                        <input type="text" class="tool-input tool-input-mono lt-main-input" id="lt-inverse-expr" placeholder="e.g. 1/(s^2+1)" autocomplete="off" spellcheck="false">
                    </div>

                    <div class="lt-preview-strip">
                        <span class="lt-preview-label">Preview</span>
                        <div class="lt-preview" id="lt-preview">
                            <span class="lt-preview-placeholder">Type above&hellip;</span>
                        </div>
                    </div>

                    <div class="ic-hero-cta-row lt-hero-cta-row">
                        <button type="button" class="ic-hero-cta" id="lt-compute-btn">Compute Transform</button>
                        <button type="button" class="lt-random-btn" id="lt-random-btn" title="Random example">&#127922;</button>
                    </div>
                </div>

                <details class="ic-hero-methods" id="lt-examples-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Quick examples</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body lt-examples-body">
                        <div class="lt-examples" id="lt-examples"></div>
                    </div>
                </details>

                <details class="ic-hero-methods" id="lt-pairs-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Common Laplace pairs</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body">
                        <table class="lt-pairs-table">
                            <thead><tr><th>f(t)</th><th>F(s)</th><th>ROC</th></tr></thead>
                            <tbody>
                                <tr><td id="lt-pair-f0"></td><td id="lt-pair-F0"></td><td>Re(s) &gt; 0</td></tr>
                                <tr><td id="lt-pair-f1"></td><td id="lt-pair-F1"></td><td>Re(s) &gt; 0</td></tr>
                                <tr><td id="lt-pair-f2"></td><td id="lt-pair-F2"></td><td>Re(s) &gt; &minus;a</td></tr>
                                <tr><td id="lt-pair-f3"></td><td id="lt-pair-F3"></td><td>Re(s) &gt; 0</td></tr>
                                <tr><td id="lt-pair-f4"></td><td id="lt-pair-F4"></td><td>Re(s) &gt; 0</td></tr>
                                <tr><td id="lt-pair-f5"></td><td id="lt-pair-F5"></td><td>Re(s) &gt; &minus;a</td></tr>
                                <tr><td id="lt-pair-f6"></td><td id="lt-pair-F6"></td><td>Re(s) &gt; &minus;a</td></tr>
                                <tr><td id="lt-pair-f7"></td><td id="lt-pair-F7"></td><td>all s</td></tr>
                                <tr><td id="lt-pair-f8"></td><td id="lt-pair-F8"></td><td>Re(s) &gt; 0</td></tr>
                            </tbody>
                        </table>
                    </div>
                </details>

                <details class="ic-hero-methods" id="lt-syntax-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Syntax help</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body lt-syntax-body">
                        t^2 &nbsp;&nbsp; s^3 &nbsp;&nbsp; (s+1)^2<br>
                        sin(2*t) &nbsp;&nbsp; cos(5*t)<br>
                        e^(-3*t) &nbsp;&nbsp; exp(-t)<br>
                        sinh(t) &nbsp;&nbsp; cosh(t)<br>
                        Heaviside(t-2) &nbsp;&nbsp; DiracDelta(t)<br>
                        1/(s^2+1) &nbsp;&nbsp; s/(s^2+9)<br>
                        <strong>Multiply:</strong> <code>t*e^(-t)</code> not <code>te^(-t)</code> &nbsp;
                        <strong>Powers:</strong> <code>t^2</code> &nbsp; <strong>Constants:</strong> pi, e
                    </div>
                </details>
            </div>

            <div class="ic-result-card">
                <div class="ic-output-tabs" role="tablist">
                    <button type="button" class="ic-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                    <button type="button" class="ic-output-tab" data-panel="graph" role="tab" aria-selected="false">Graph</button>
                    <button type="button" class="ic-output-tab" data-panel="python" role="tab" aria-selected="false">Python Compiler</button>
                </div>

                <div class="ic-panel active" id="lt-panel-result" role="tabpanel">
                    <div class="tool-card tool-result-card">
                        <div class="tool-result-content" id="lt-result-content">
                            <div class="tool-empty-state" id="lt-empty-state">
                                <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#8466;</div>
                                <h3>Enter an expression and click Compute</h3>
                                <p>Compute forward or inverse Laplace transforms with step-by-step solutions.</p>
                            </div>
                        </div>
                        <div class="tool-result-actions" id="lt-result-actions">
                            <button type="button" class="tool-action-btn" id="lt-copy-latex-btn">Copy LaTeX</button>
                            <button type="button" class="tool-action-btn" id="lt-download-pdf-btn">Download PDF</button>
                            <button type="button" class="tool-action-btn" id="lt-share-btn">Share</button>
                            <button type="button" class="tool-action-btn" id="lt-worksheet-btn">Print Worksheet</button>
                        </div>
                    </div>
                </div>

                <div class="ic-panel" id="lt-panel-graph" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                        <div style="flex:1;min-height:360px;padding:0.75rem;">
                            <div id="lt-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                            <p id="lt-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Compute a transform to see the time-domain plot.</p>
                        </div>
                    </div>
                </div>

                <div class="ic-panel" id="lt-panel-python" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                        <div style="flex:1;min-height:0;">
                            <iframe id="lt-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is the Laplace Transform?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">The Laplace transform is an integral transform that converts a function of time f(t) into a function of complex frequency F(s). It is defined as <strong>L{f(t)} = &int;<sub>0</sub><sup>&infin;</sup> f(t) e<sup>&minus;st</sup> dt</strong>, where s = &sigma; + j&omega; is a complex variable.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">The transform is essential in engineering and physics for solving ordinary differential equations, analyzing linear time-invariant (LTI) systems, and designing control systems and electrical circuits.</p>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">Key Properties</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin-top: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #0891b2;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Linearity</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">L{af(t) + bg(t)} = aF(s) + bG(s). The transform distributes over addition and scalar multiplication.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #06b6d4;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">First Shifting Theorem</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">L{e<sup>&minus;at</sup>f(t)} = F(s+a). Multiplication by an exponential shifts the s-domain by a.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #0e7490;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Derivative Property</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">L{f'(t)} = sF(s) &minus; f(0). Differentiation becomes multiplication by s, converting ODEs to algebra.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #22d3ee;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Convolution Theorem</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">L{f*g} = F(s)&middot;G(s). Convolution in the time domain becomes multiplication in the s-domain.</p>
            </div>
        </div>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Applications</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9889;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Circuit Analysis</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Analyze RLC circuits by transforming differential equations into algebraic equations in the s-domain.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9881;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Control Systems</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Transfer functions H(s) describe system input-output relationships. Used for stability and feedback analysis.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128200;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Signal Processing</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Filter design and frequency response analysis of continuous-time linear systems.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128218;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Differential Equations</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Solve initial-value problems by converting ODEs to algebraic equations, solving for F(s), then inverting.</p>
            </div>
        </div>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the Laplace transform?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The Laplace transform converts a time-domain function f(t) into a complex frequency-domain function F(s) using the integral L{f(t)} = integral from 0 to infinity of f(t)*e^(-st) dt. It is widely used to solve differential equations, analyze control systems, and study circuit behavior.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you compute the inverse Laplace transform?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The inverse Laplace transform converts F(s) back to f(t). The most common method is partial fraction decomposition: break F(s) into simpler fractions, then look up each fraction in a table of known Laplace pairs. For example, 1/(s+a) transforms back to e^(-at).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the region of convergence (ROC)?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The region of convergence is the set of complex values of s for which the Laplace transform integral converges. For causal signals (t >= 0), the ROC is a right half-plane Re(s) > sigma. For example, L{e^(-at)} = 1/(s+a) with ROC Re(s) > -a.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                When should I use partial fractions for inverse Laplace?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Use partial fractions when F(s) is a rational function (ratio of polynomials) that does not directly match a standard Laplace pair. Decomposing into simpler terms like A/(s+a) + B/(s+b) makes it easy to look up each term in the transform table.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the Heaviside step function in Laplace transforms?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The Heaviside step function theta(t) equals 0 for t &lt; 0 and 1 for t >= 0. In Laplace transform results, it indicates that the solution is valid only for t >= 0. SymPy includes it automatically since the Laplace transform is defined for causal (one-sided) signals.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this Laplace transform calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, 2D graphs, LaTeX export, Math AI help, and a built-in Python compiler.</div>
        </div>
    </div>
</section>

<section class="ms-below-fold" style="max-width: 100%; margin: 2rem 0 0; padding: 0;">
    <div class="tool-card" style="padding: 1.5rem 2rem;">
        <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; color: var(--text-primary);">
            <span style="font-size: 1.3rem;">&#128293;</span> Explore More Math
        </h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
            <a href="<%=request.getContextPath()%>/ode-solver-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #db2777, #f472b6); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.1rem; font-weight: 700; color: #fff;">y'</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">ODE Solver Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Solve first &amp; second-order ODEs with steps and direction fields</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/z-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #059669, #10b981); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">Z</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Z-Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Z-transforms for discrete-time signals</p>
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

<script>window.LT_CALC_CTX = "<%=request.getContextPath()%>";</script>
<%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/laplace-transform-calculator.js?v=<%=v%>"></script>

<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureLaplaceMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
