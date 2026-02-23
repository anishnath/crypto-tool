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

    <!-- Laplace Transform Calculator styles -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/laplace-transform-calculator.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/laplace-transform-calculator.css?v=<%=cacheVersion%>"></noscript>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Laplace Transform Calculator with Steps - Forward & Inverse | Free" />
        <jsp:param name="toolDescription" value="Free online Laplace transform calculator. Compute forward and inverse Laplace transforms with detailed step-by-step solutions. Features partial fractions, region of convergence, common Laplace pairs table, 2D graph, and built-in Python compiler. No signup required." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="laplace-transform-calculator.jsp" />
        <jsp:param name="toolKeywords" value="laplace transform calculator, inverse laplace transform calculator, laplace transform with steps, laplace transform table, laplace transform of e^at, transfer function, differential equations, control systems, region of convergence, partial fractions" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Forward Laplace transform with steps,Inverse Laplace transform with steps,Common Laplace pairs reference table,Region of convergence (ROC),Partial fraction decomposition,2D function graph,Live KaTeX math preview,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Dark mode support,Free and no signup required" />
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
        <jsp:param name="faq5a" value="The Heaviside step function theta(t) equals 0 for t < 0 and 1 for t >= 0. In Laplace transform results, it indicates that the solution is valid only for t >= 0. SymPy includes it automatically since the Laplace transform is defined for causal (one-sided) signals." />
        <jsp:param name="faq6q" value="Is this Laplace transform calculator free?" />
        <jsp:param name="faq6a" value="Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, 2D graphs, LaTeX export, and a built-in Python compiler." />
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
            <h1 class="tool-page-title">Laplace Transform Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math">Math Tools</a> /
                Laplace Transform Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">Forward &amp; Inverse</span>
            <span class="tool-badge">Symbolic CAS</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<!-- Tool Description -->
<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Compute <strong>forward</strong> and <strong>inverse Laplace transforms</strong> with <strong>detailed step-by-step solutions</strong>. Features partial fraction decomposition, region of convergence, a complete Laplace pairs reference table, 2D graphs, and a built-in Python compiler. Essential for differential equations, control systems, and signal processing.</p>
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
                    <path d="M12 2L2 7l10 5 10-5-10-5z"/>
                    <path d="M2 17l10 5 10-5"/>
                    <path d="M2 12l10 5 10-5"/>
                </svg>
                Laplace Transform
            </div>
            <div class="tool-card-body">
                <!-- Mode toggle -->
                <div class="lt-mode-toggle">
                    <button type="button" class="lt-mode-btn active" data-mode="forward">L{f(t)} Forward</button>
                    <button type="button" class="lt-mode-btn" data-mode="inverse">L&#8315;&#185;{F(s)} Inverse</button>
                </div>

                <!-- Forward mode input -->
                <div id="lt-forward-wrap">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="lt-forward-expr">f(t) &mdash; time-domain function</label>
                        <input type="text" class="tool-input tool-input-mono" id="lt-forward-expr" placeholder="e.g. t^2*e^(-3*t)" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a function of t</span>
                    </div>
                </div>

                <!-- Inverse mode input -->
                <div id="lt-inverse-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="lt-inverse-expr">F(s) &mdash; frequency-domain function</label>
                        <input type="text" class="tool-input tool-input-mono" id="lt-inverse-expr" placeholder="e.g. 1/(s^2+1)" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a function of s</span>
                    </div>
                </div>

                <!-- Live preview -->
                <div class="tool-form-group" style="margin-top:0.875rem;">
                    <label class="tool-form-label">Live Preview</label>
                    <div class="lt-preview" id="lt-preview">
                        <span style="color:var(--text-muted);font-size:0.8125rem;">Type an expression above&hellip;</span>
                    </div>
                </div>

                <!-- Action buttons -->
                <div class="lt-action-row">
                    <button type="button" class="tool-action-btn lt-compute-btn" id="lt-compute-btn">Compute</button>
                    <button type="button" class="lt-random-btn" id="lt-random-btn" title="Random example">&#127922; Random</button>
                </div>

                <hr class="lt-sep">

                <!-- Quick examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="lt-examples" id="lt-examples"></div>
                </div>

                <hr class="lt-sep">

                <!-- Common Laplace Pairs (collapsible) -->
                <div id="lt-pairs-wrap">
                    <button type="button" class="lt-pairs-toggle" id="lt-pairs-btn">
                        Common Laplace Pairs
                        <svg class="lt-pairs-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="lt-pairs-content" id="lt-pairs-content">
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
                </div>

                <hr class="lt-sep">

                <!-- Syntax help (collapsible) -->
                <div id="lt-syntax-wrap">
                    <button type="button" class="lt-syntax-toggle" id="lt-syntax-btn">
                        Syntax Help
                        <svg class="lt-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="lt-syntax-content" id="lt-syntax-content">
                        t^2 &nbsp;&nbsp; s^3 &nbsp;&nbsp; (s+1)^2<br>
                        sin(2*t) &nbsp;&nbsp; cos(5*t)<br>
                        e^(-3*t) &nbsp;&nbsp; exp(-t)<br>
                        sinh(t) &nbsp;&nbsp; cosh(t)<br>
                        Heaviside(t-2) &nbsp;&nbsp; DiracDelta(t)<br>
                        1/(s^2+1) &nbsp;&nbsp; s/(s^2+9)<br>
                        <strong>Multiplication:</strong> Use * explicitly: <code>t*e^(-t)</code> not <code>te^(-t)</code><br>
                        <strong>Powers:</strong> <code>t^2</code> or <code>(s+1)^2</code><br>
                        <strong>Constants:</strong> pi, e
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== OUTPUT COLUMN ========== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="lt-output-tabs">
            <button type="button" class="lt-output-tab active" data-panel="result">Result</button>
            <button type="button" class="lt-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="lt-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="lt-panel active" id="lt-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="lt-result-content">
                    <div class="tool-empty-state" id="lt-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#8466;</div>
                        <h3>Enter an expression and click Compute</h3>
                        <p>Compute forward or inverse Laplace transforms with step-by-step solutions.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="lt-result-actions">
                    <button type="button" class="tool-action-btn" id="lt-copy-latex-btn">
                        <span>&#128203;</span> Copy LaTeX
                    </button>
                    <button type="button" class="tool-action-btn" id="lt-download-pdf-btn">
                        <span>&#128196;</span> Download PDF
                    </button>
                    <button type="button" class="tool-action-btn" id="lt-share-btn">
                        <span>&#128279;</span> Share
                    </button>
                    <button type="button" class="tool-action-btn" id="lt-worksheet-btn">
                        <span>&#128218;</span> Print Worksheet
                    </button>
                </div>
            </div>
        </div>

        <!-- Graph Panel -->
        <div class="lt-panel" id="lt-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>f(t) vs t</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="lt-graph-container"></div>
                    <p id="lt-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Compute a transform to see the time-domain plot.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="lt-panel" id="lt-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="lt-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
    <jsp:param name="currentToolUrl" value="laplace-transform-calculator.jsp"/>
    <jsp:param name="keyword" value="calculus"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

    <!-- What is the Laplace Transform? -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is the Laplace Transform?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">The Laplace transform is an integral transform that converts a function of time f(t) into a function of complex frequency F(s). It is defined as <strong>L{f(t)} = &int;<sub>0</sub><sup>&infin;</sup> f(t) e<sup>&minus;st</sup> dt</strong>, where s = &sigma; + j&omega; is a complex variable.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">The transform is essential in engineering and physics for solving ordinary differential equations, analyzing linear time-invariant (LTI) systems, and designing control systems and electrical circuits.</p>
    </div>

    <!-- Key Properties -->
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

    <!-- Applications -->
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

    <!-- FAQ Section -->
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
            <div class="faq-answer">Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, 2D graphs, LaTeX export, and a built-in Python compiler.</div>
        </div>
    </div>
</section>

<!-- Explore More Math -->
<section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
    <div class="tool-card" style="padding: 1.5rem 2rem;">
        <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; color: var(--text-primary);">
            <span style="font-size: 1.3rem;">&#128293;</span> Explore More Math
        </h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
            <a href="<%=request.getContextPath()%>/ode-solver-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(8,145,178,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #db2777, #f472b6); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.1rem; font-weight: 700; color: #fff;">y'</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">ODE Solver Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Solve first &amp; second-order ODEs with steps and direction fields</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/z-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(8,145,178,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #059669, #10b981); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">Z</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Z-Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Z-transforms for discrete-time signals</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/finite-difference-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(8,145,178,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #0d9488, #14b8a6); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#916;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Finite Difference Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward, central &amp; backward differences with steps</p>
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

<script>window.LT_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/laplace-transform-calculator.js?v=<%=cacheVersion%>"></script>

</body>
</html>
