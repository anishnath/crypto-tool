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

    <!-- Finite Difference Calculator styles -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/finite-difference-calculator.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/finite-difference-calculator.css?v=<%=cacheVersion%>"></noscript>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Finite Difference Calculator with Steps - Forward, Central & Backward | Free Online Tool" />
        <jsp:param name="toolDescription" value="Free finite difference calculator computes forward, backward, and central difference approximations with step-by-step solutions, graphs, and Python code. Supports symbolic expressions and numerical data." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="finite-difference-calculator.jsp" />
        <jsp:param name="toolKeywords" value="finite difference calculator, numerical differentiation calculator, forward difference, backward difference, central difference, finite difference method, finite difference weights, numerical derivative, finite difference approximation, difference quotient calculator, Richardson extrapolation, finite difference stencil" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Symbolic finite difference with steps,Numerical approximation from data points,Finite difference weights computation,Forward backward central differences,Interactive 2D graphs,Live KaTeX math preview,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is the finite difference method?" />
        <jsp:param name="faq1a" value="The finite difference method is a numerical technique to approximate derivatives using discrete data points. Forward, backward, and central formulas use nearby function values to estimate slopes. It is fundamental in numerical analysis and scientific computing." />
        <jsp:param name="faq2q" value="What is the difference between forward, backward, and central differences?" />
        <jsp:param name="faq2a" value="Forward difference uses f(x+h)-f(x), backward uses f(x)-f(x-h), central uses (f(x+h)-f(x-h))/2h. Central differences are more accurate with O(h squared) error vs O(h) for forward and backward." />
        <jsp:param name="faq3q" value="How do I choose the step size h?" />
        <jsp:param name="faq3a" value="Smaller h increases accuracy but amplifies round-off error. The optimal h balances truncation and round-off errors. For first derivatives, h is typically around the square root of machine epsilon, about 1e-8 for double precision." />
        <jsp:param name="faq4q" value="What are finite difference weights?" />
        <jsp:param name="faq4a" value="Weights are coefficients that multiply function values at grid points to approximate derivatives. SymPy finite_diff_weights computes these for arbitrary stencils and derivative orders, giving exact rational coefficients." />
        <jsp:param name="faq5q" value="How accurate are finite difference approximations?" />
        <jsp:param name="faq5a" value="Accuracy depends on stencil width and type. Central differences are O(h squared), 5-point central is O(h to the fourth). More points generally give higher accuracy but require more function evaluations." />
        <jsp:param name="faq6q" value="Is this finite difference calculator free?" />
        <jsp:param name="faq6a" value="Yes, completely free with no registration required. Includes step-by-step solutions, interactive graphs, exportable Python code, and a built-in compiler." />
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
            <h1 class="tool-page-title">Finite Difference Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math">Math Tools</a> /
                Finite Difference Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">3 Modes</span>
            <span class="tool-badge">Symbolic CAS</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<!-- Tool Description -->
<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Compute <strong>finite difference approximations</strong> with <strong>forward, central, and backward</strong> methods. Three modes: <strong>symbolic differentiation</strong> using SymPy, <strong>numerical approximation</strong> from data points, and <strong>difference weights</strong> computation. Features step-by-step solutions, interactive graphs, and a built-in Python compiler.</p>
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
                Finite Difference
            </div>
            <div class="tool-card-body">
                <!-- Mode toggle -->
                <div class="fd-mode-toggle">
                    <button type="button" class="fd-mode-btn active" data-mode="symbolic">&#916; Symbolic</button>
                    <button type="button" class="fd-mode-btn" data-mode="numerical">&#128202; Numerical</button>
                    <button type="button" class="fd-mode-btn" data-mode="weights">&#9878; Weights</button>
                </div>

                <!-- Symbolic mode input -->
                <div id="fd-symbolic-wrap">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="fd-symbolic-expr">f(x) &mdash; expression in x</label>
                        <input type="text" class="tool-input tool-input-mono" id="fd-symbolic-expr" placeholder="e.g. x^3 + sin(x)" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a function of x</span>
                    </div>
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.5rem;margin-top:0.5rem;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="fd-symbolic-order">Derivative order</label>
                            <input type="number" class="tool-input" id="fd-symbolic-order" value="1" min="1" max="4" style="width:100%;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="fd-symbolic-points"># Points (0=auto)</label>
                            <input type="number" class="tool-input" id="fd-symbolic-points" value="0" min="0" max="9" style="width:100%;">
                        </div>
                    </div>
                </div>

                <!-- Numerical mode input -->
                <div id="fd-numerical-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="fd-numerical-data">Data points (x,y pairs)</label>
                        <input type="text" class="tool-input tool-input-mono" id="fd-numerical-data" placeholder="e.g. 0,0; 1,1; 2,8; 3,27" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Semicolon-separated x,y pairs</span>
                    </div>
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.5rem;margin-top:0.5rem;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="fd-numerical-order">Derivative order</label>
                            <input type="number" class="tool-input" id="fd-numerical-order" value="1" min="1" max="4" style="width:100%;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="fd-numerical-eval">Eval point x&#8320;</label>
                            <input type="text" class="tool-input tool-input-mono" id="fd-numerical-eval" placeholder="e.g. 2" autocomplete="off">
                        </div>
                    </div>
                </div>

                <!-- Weights mode input -->
                <div id="fd-weights-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="fd-weights-points">Grid points (comma-separated)</label>
                        <input type="text" class="tool-input tool-input-mono" id="fd-weights-points" placeholder="e.g. -1,0,1" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">e.g. -2,-1,0,1,2 for 5-point central</span>
                    </div>
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.5rem;margin-top:0.5rem;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="fd-weights-order">Max derivative order</label>
                            <input type="number" class="tool-input" id="fd-weights-order" value="1" min="1" max="4" style="width:100%;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="fd-weights-center">Center x&#8320;</label>
                            <input type="text" class="tool-input tool-input-mono" id="fd-weights-center" value="0" placeholder="e.g. 0" autocomplete="off">
                        </div>
                    </div>
                </div>

                <!-- Live preview -->
                <div class="tool-form-group" style="margin-top:0.875rem;">
                    <label class="tool-form-label">Live Preview</label>
                    <div class="fd-preview" id="fd-preview">
                        <span style="color:var(--text-muted);font-size:0.8125rem;">Type an expression above&hellip;</span>
                    </div>
                </div>

                <!-- Action buttons -->
                <div class="fd-action-row">
                    <button type="button" class="tool-action-btn fd-compute-btn" id="fd-compute-btn">Compute</button>
                    <button type="button" class="fd-random-btn" id="fd-random-btn" title="Random example">&#127922; Random</button>
                </div>

                <hr class="fd-sep">

                <!-- Quick examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="fd-examples" id="fd-examples"></div>
                </div>

                <hr class="fd-sep">

                <!-- Finite Difference Formulas (collapsible) -->
                <div id="fd-formulas-wrap">
                    <button type="button" class="fd-formulas-toggle" id="fd-formulas-btn">
                        Common Finite Difference Formulas
                        <svg class="fd-formulas-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="fd-formulas-content" id="fd-formulas-content">
                        <table class="fd-formulas-table">
                            <thead><tr><th>Type</th><th>Formula</th><th>Accuracy</th></tr></thead>
                            <tbody>
                                <tr><td>Forward (1st)</td><td id="fd-formula-f0"></td><td id="fd-formula-a0"></td></tr>
                                <tr><td>Backward (1st)</td><td id="fd-formula-f1"></td><td id="fd-formula-a1"></td></tr>
                                <tr><td>Central (1st)</td><td id="fd-formula-f2"></td><td id="fd-formula-a2"></td></tr>
                                <tr><td>Central (2nd)</td><td id="fd-formula-f3"></td><td id="fd-formula-a3"></td></tr>
                                <tr><td>5-pt Central</td><td id="fd-formula-f4"></td><td id="fd-formula-a4"></td></tr>
                                <tr><td>Forward (2nd)</td><td id="fd-formula-f5"></td><td id="fd-formula-a5"></td></tr>
                                <tr><td>3-pt Forward</td><td id="fd-formula-f6"></td><td id="fd-formula-a6"></td></tr>
                                <tr><td>Richardson</td><td id="fd-formula-f7"></td><td id="fd-formula-a7"></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <hr class="fd-sep">

                <!-- Syntax help (collapsible) -->
                <div id="fd-syntax-wrap">
                    <button type="button" class="fd-syntax-toggle" id="fd-syntax-btn">
                        Syntax Help
                        <svg class="fd-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="fd-syntax-content" id="fd-syntax-content">
                        x^2 &nbsp;&nbsp; x**3 &nbsp;&nbsp; (x+1)^2<br>
                        sin(x) &nbsp;&nbsp; cos(x) &nbsp;&nbsp; tan(x)<br>
                        exp(x) &nbsp;&nbsp; e^(-x) &nbsp;&nbsp; log(x)<br>
                        sqrt(x) &nbsp;&nbsp; asin(x) &nbsp;&nbsp; acos(x)<br>
                        <strong>Multiplication:</strong> Use * explicitly: <code>2*x</code> not <code>2x</code><br>
                        <strong>Powers:</strong> <code>x^2</code> or <code>x**2</code><br>
                        <strong>Constants:</strong> pi, e<br>
                        <strong>Data points:</strong> <code>0,0; 1,1; 2,4; 3,9</code>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== OUTPUT COLUMN ========== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="fd-output-tabs">
            <button type="button" class="fd-output-tab active" data-panel="result">Result</button>
            <button type="button" class="fd-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="fd-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="fd-panel active" id="fd-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="fd-result-content">
                    <div class="tool-empty-state" id="fd-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#916;</div>
                        <h3>Enter an expression and click Compute</h3>
                        <p>Compute finite difference approximations with step-by-step solutions.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="fd-result-actions">
                    <button type="button" class="tool-action-btn" id="fd-copy-latex-btn">
                        <span>&#128203;</span> Copy LaTeX
                    </button>
                    <button type="button" class="tool-action-btn" id="fd-download-pdf-btn">
                        <span>&#128196;</span> Download PDF
                    </button>
                    <button type="button" class="tool-action-btn" id="fd-share-btn">
                        <span>&#128279;</span> Share
                    </button>
                    <button type="button" class="tool-action-btn" id="fd-worksheet-btn">
                        <span>&#128218;</span> Print Worksheet
                    </button>
                </div>
            </div>
        </div>

        <!-- Graph Panel -->
        <div class="fd-panel" id="fd-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>Graph</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="fd-graph-container"></div>
                    <p id="fd-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Compute a result to see the graph.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="fd-panel" id="fd-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="fd-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
    <jsp:param name="currentToolUrl" value="finite-difference-calculator.jsp"/>
    <jsp:param name="keyword" value="calculus"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

    <!-- What is the Finite Difference Method? -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is the Finite Difference Method?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">The finite difference method approximates derivatives using discrete data points. Instead of taking the limit as h&rarr;0, we use a small but finite step size h. The simplest example is the <strong>forward difference</strong>: f'(x) &approx; (f(x+h) &minus; f(x)) / h, which is the slope of the secant line through two nearby points.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">This technique is fundamental in numerical analysis, scientific computing, and engineering. It enables solving differential equations numerically when analytical solutions are impossible or impractical.</p>
    </div>

    <!-- Types of Finite Differences -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">Types of Finite Differences</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin-top: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #0d9488;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Forward Difference (&Delta;f)</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">&Delta;f = f(x+h) &minus; f(x). Uses the point ahead. First-order accurate O(h). Best at left boundary of a domain.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #14b8a6;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Backward Difference (&nabla;f)</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">&nabla;f = f(x) &minus; f(x&minus;h). Uses the point behind. First-order accurate O(h). Best at right boundary of a domain.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #0f766e;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Central Difference (&delta;f)</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">&delta;f = f(x+h/2) &minus; f(x&minus;h/2). Uses points on both sides. Second-order accurate O(h&sup2;). The most accurate 2-point formula.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #2dd4bf;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Higher-Order Stencils</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Using more grid points increases accuracy. A 5-point central stencil achieves O(h&sup4;) accuracy for first derivatives.</p>
            </div>
        </div>
    </div>

    <!-- Applications -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Applications</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128290;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Numerical Analysis</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Solving ODEs and PDEs numerically using finite difference discretization of derivatives.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128295;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Engineering</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Computational fluid dynamics (CFD), structural analysis, and heat transfer simulations.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128200;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Data Science</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Estimating rates of change from discrete measurements and time-series data.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128225;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Signal Processing</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Discrete derivative filters and numerical differentiation of sampled signals.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the finite difference method?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The finite difference method is a numerical technique to approximate derivatives using discrete data points. Forward, backward, and central formulas use nearby function values to estimate slopes. It is fundamental in numerical analysis and scientific computing.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between forward, backward, and central differences?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Forward difference uses f(x+h)-f(x), backward uses f(x)-f(x-h), central uses (f(x+h)-f(x-h))/2h. Central differences are more accurate with O(h&sup2;) error compared to O(h) for forward and backward.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I choose the step size h?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Smaller h increases accuracy but amplifies round-off error. The optimal h balances truncation and round-off errors. For first derivatives, h is typically around the square root of machine epsilon, about 1e-8 for double precision.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What are finite difference weights?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Weights are coefficients that multiply function values at grid points to approximate derivatives. SymPy's finite_diff_weights computes these for arbitrary stencils and derivative orders, giving exact rational coefficients.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How accurate are finite difference approximations?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Accuracy depends on stencil width and type. Central differences are O(h&sup2;), 5-point central is O(h&#8308;). More points generally give higher accuracy but require more function evaluations.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this finite difference calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, completely free with no registration required. Includes step-by-step solutions, interactive graphs, exportable Python code, and a built-in compiler.</div>
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
            <a href="<%=request.getContextPath()%>/laplace-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(13,148,136,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #0891b2, #06b6d4); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8466;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Laplace Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Laplace transforms with steps and ROC</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/fourier-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(13,148,136,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #7c3aed, #a855f7); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8497;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Fourier Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Fourier transforms for signal analysis</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/ode-solver-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(13,148,136,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #db2777, #f472b6); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.1rem; font-weight: 700; color: #fff;">y'</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">ODE Solver Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Solve first &amp; second-order ODEs with steps and direction fields</p>
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

<script>window.FD_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/finite-difference-calculator.js?v=<%=cacheVersion%>"></script>

</body>
</html>
