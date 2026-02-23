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

    <!-- Z-Transform Calculator styles -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/z-transform-calculator.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/z-transform-calculator.css?v=<%=cacheVersion%>"></noscript>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Z-Transform Calculator with Steps - Forward & Inverse | Free" />
        <jsp:param name="toolDescription" value="Free online Z-transform calculator. Compute forward and inverse Z-transforms with detailed step-by-step solutions. Features common Z-transform pairs table, region of convergence, stem plots, and built-in Python compiler. No signup required." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="z-transform-calculator.jsp" />
        <jsp:param name="toolKeywords" value="z-transform calculator, inverse z-transform calculator, z-transform with steps, z-transform table, discrete-time signals, digital signal processing, transfer function, difference equations, region of convergence, partial fractions" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Forward Z-transform with steps,Inverse Z-transform with steps,Common Z-transform pairs reference table,Region of convergence (ROC),Partial fraction decomposition,Discrete stem plot graph,Live KaTeX math preview,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Dark mode support,Free and no signup required" />
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
        <jsp:param name="faq6a" value="Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, discrete stem plots, LaTeX export, and a built-in Python compiler." />
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
            <h1 class="tool-page-title">Z-Transform Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math">Math Tools</a> /
                Z-Transform Calculator
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
            <p>Compute <strong>forward</strong> and <strong>inverse Z-transforms</strong> with <strong>detailed step-by-step solutions</strong>. Features a complete Z-transform pairs reference table, region of convergence, discrete stem plots, and a built-in Python compiler. Essential for digital signal processing, control systems, and difference equations.</p>
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
                Z-Transform
            </div>
            <div class="tool-card-body">
                <!-- Mode toggle -->
                <div class="zt-mode-toggle">
                    <button type="button" class="zt-mode-btn active" data-mode="forward">Z{x[n]} Forward</button>
                    <button type="button" class="zt-mode-btn" data-mode="inverse">Z&#8315;&#185;{X(z)} Inverse</button>
                </div>

                <!-- Forward mode input -->
                <div id="zt-forward-wrap">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="zt-forward-expr">x[n] &mdash; discrete-time sequence</label>
                        <input type="text" class="tool-input tool-input-mono" id="zt-forward-expr" placeholder="e.g. (1/2)^n" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a function of n (n &ge; 0)</span>
                    </div>
                </div>

                <!-- Inverse mode input -->
                <div id="zt-inverse-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="zt-inverse-expr">X(z) &mdash; Z-domain function</label>
                        <input type="text" class="tool-input tool-input-mono" id="zt-inverse-expr" placeholder="e.g. z/(z-1)" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a function of z</span>
                    </div>
                </div>

                <!-- Live preview -->
                <div class="tool-form-group" style="margin-top:0.875rem;">
                    <label class="tool-form-label">Live Preview</label>
                    <div class="zt-preview" id="zt-preview">
                        <span style="color:var(--text-muted);font-size:0.8125rem;">Type an expression above&hellip;</span>
                    </div>
                </div>

                <!-- Action buttons -->
                <div class="zt-action-row">
                    <button type="button" class="tool-action-btn zt-compute-btn" id="zt-compute-btn">Compute</button>
                    <button type="button" class="zt-random-btn" id="zt-random-btn" title="Random example">&#127922; Random</button>
                </div>

                <hr class="zt-sep">

                <!-- Quick examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="zt-examples" id="zt-examples"></div>
                </div>

                <hr class="zt-sep">

                <!-- Common Z-Transform Pairs (collapsible) -->
                <div id="zt-pairs-wrap">
                    <button type="button" class="zt-pairs-toggle" id="zt-pairs-btn">
                        Common Z-Transform Pairs
                        <svg class="zt-pairs-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="zt-pairs-content" id="zt-pairs-content">
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
                </div>

                <hr class="zt-sep">

                <!-- Syntax help (collapsible) -->
                <div id="zt-syntax-wrap">
                    <button type="button" class="zt-syntax-toggle" id="zt-syntax-btn">
                        Syntax Help
                        <svg class="zt-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="zt-syntax-content" id="zt-syntax-content">
                        n^2 &nbsp;&nbsp; z^3 &nbsp;&nbsp; (z-1)^2<br>
                        (1/2)^n &nbsp;&nbsp; (3/4)^n &nbsp;&nbsp; (-1)^n<br>
                        n*(1/2)^n &nbsp;&nbsp; 2^n<br>
                        sin(pi*n/3) &nbsp;&nbsp; cos(pi*n/4)<br>
                        z/(z-1) &nbsp;&nbsp; z/(z-1)^2<br>
                        z^2/((z-1)*(z-1/2))<br>
                        <strong>Multiplication:</strong> Use * explicitly: <code>n*(1/2)**n</code><br>
                        <strong>Powers:</strong> <code>n^2</code> or <code>(1/2)^n</code><br>
                        <strong>Fractions:</strong> <code>1/2</code>, <code>3/4</code>, <code>Rational(1,3)</code>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== OUTPUT COLUMN ========== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="zt-output-tabs">
            <button type="button" class="zt-output-tab active" data-panel="result">Result</button>
            <button type="button" class="zt-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="zt-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="zt-panel active" id="zt-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="zt-result-content">
                    <div class="tool-empty-state" id="zt-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">Z</div>
                        <h3>Enter an expression and click Compute</h3>
                        <p>Compute forward or inverse Z-transforms with step-by-step solutions.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="zt-result-actions">
                    <button type="button" class="tool-action-btn" id="zt-copy-latex-btn">
                        <span>&#128203;</span> Copy LaTeX
                    </button>
                    <button type="button" class="tool-action-btn" id="zt-download-pdf-btn">
                        <span>&#128196;</span> Download PDF
                    </button>
                    <button type="button" class="tool-action-btn" id="zt-share-btn">
                        <span>&#128279;</span> Share
                    </button>
                    <button type="button" class="tool-action-btn" id="zt-worksheet-btn">
                        <span>&#128218;</span> Print Worksheet
                    </button>
                </div>
            </div>
        </div>

        <!-- Graph Panel -->
        <div class="zt-panel" id="zt-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>x[n] vs n (Stem Plot)</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="zt-graph-container"></div>
                    <p id="zt-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Compute a transform to see the discrete stem plot.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="zt-panel" id="zt-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="zt-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
    <jsp:param name="currentToolUrl" value="z-transform-calculator.jsp"/>
    <jsp:param name="keyword" value="calculus"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

    <!-- What is the Z-Transform? -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is the Z-Transform?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">The Z-transform converts a discrete-time sequence x[n] into a complex function X(z). It is defined as <strong>Z{x[n]} = &Sigma;<sub>n=0</sub><sup>&infin;</sup> x[n] &middot; z<sup>&minus;n</sup></strong>, where z is a complex variable. It is the discrete-time counterpart of the Laplace transform.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">The Z-transform is fundamental in digital signal processing, discrete-time control systems, and the analysis of difference equations and digital filters.</p>
    </div>

    <!-- Key Properties -->
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

    <!-- Applications -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Applications</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128295;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Digital Filters</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Design and analyze FIR and IIR filters using transfer functions H(z) in the Z-domain.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9881;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Control Systems</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Discrete-time control system design, stability analysis via pole-zero placement in the z-plane.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127908;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Audio &amp; Speech</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Audio codec design, speech synthesis, echo cancellation, and adaptive filtering algorithms.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128225;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Communications</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Channel equalization, error correction coding, and digital modulation/demodulation systems.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
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
                What is a transfer function in Z-domain?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A transfer function H(z) = Y(z)/X(z) describes the input-output relationship of a discrete-time linear system. It characterizes digital filters and is used to analyze stability (all poles inside the unit circle), frequency response, and system behavior.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this Z-transform calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, discrete stem plots, LaTeX export, and a built-in Python compiler.</div>
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
            <a href="<%=request.getContextPath()%>/laplace-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(5,150,105,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #0891b2, #06b6d4); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8466;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Laplace Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Laplace transforms with steps and ROC</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/fourier-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(5,150,105,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #7c3aed, #a855f7); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8497;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Fourier Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Fourier transforms for signal analysis</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/integral-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(5,150,105,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #4f46e5, #6366f1); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8747;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Integral Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Solve integrals with step-by-step solutions, graphs, and PDF export</p>
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

<script>window.ZT_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/z-transform-calculator.js?v=<%=cacheVersion%>"></script>

</body>
</html>
