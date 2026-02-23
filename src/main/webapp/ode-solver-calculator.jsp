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

    <!-- ODE Solver Calculator styles -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ode-solver-calculator.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ode-solver-calculator.css?v=<%=cacheVersion%>"></noscript>

    <!-- SEO (competitive targeting: Symbolab, mathdf, eMathHelp) -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="ODE Solver Calculator • With Steps!" />
        <jsp:param name="toolDescription" value="Free ODE solver with step-by-step solutions. Solve first-order and higher-order ODEs. Separable, linear, Bernoulli, exact. IVP with initial conditions, direction field. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="ode-solver-calculator.jsp" />
        <jsp:param name="toolKeywords" value="differential equation calculator, ODE solver, ODE solver with steps, differential equation calculator with steps, ordinary differential equation solver, first order differential equation calculator, 2nd order ODE solver, differential equation solver with initial conditions, initial value problem solver, homogeneous differential equation calculator, direction field calculator, separable ODE, Bernoulli equation, exact equation, IVP solver" />
        <jsp:param name="educationalLevel" value="High School, College" />
        <jsp:param name="teaches" value="Ordinary differential equations, ODEs, initial value problems, separable equations" />
        <jsp:param name="howToSteps" value="Select ODE mode|Choose first-order, higher-order, or direction field mode,Enter your ODE|Type your differential equation (e.g. y'=x*y, y''+y=0) with optional initial conditions,Click Solve|Click Solve to compute the step-by-step solution,View result &amp; graph|See the solution, method used, verification, and interactive graph" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="First-order ODE solver with steps,Second-order ODE solver with steps,Higher-order ODE solver (3rd 4th 5th order),Direction field (slope field) plotter,ODE classification (separable linear Bernoulli exact),Initial value problem (IVP) support,Solution verification with checkodesol,Interactive solution curve graphs,Live KaTeX math preview with Leibniz notation,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="How do you solve a first-order ODE?" />
        <jsp:param name="faq1a" value="First identify the ODE type: separable, linear, Bernoulli, exact, or homogeneous. Then apply the appropriate method. For separable ODEs, separate variables and integrate both sides. For linear ODEs y'+P(x)y=Q(x), multiply by the integrating factor mu=e^(integral P dx). This calculator automatically classifies and solves first-order ODEs using SymPy dsolve." />
        <jsp:param name="faq2q" value="Does this ODE solver support initial conditions (IVP)?" />
        <jsp:param name="faq2a" value="Yes. This calculator solves initial value problems (IVPs)—ODEs with initial conditions at a specific point. For first-order: y(x0)=y0. For second-order: y(x0)=y0 and y'(x0)=dy0. Initial conditions determine the unique particular solution from the general solution family." />
        <jsp:param name="faq3q" value="What is a direction field (slope field)?" />
        <jsp:param name="faq3a" value="A direction field is a graphical representation of a first-order ODE dy/dx=f(x,y). At each point (x,y) in the plane, a short line segment shows the slope f(x,y). The pattern of these segments reveals the qualitative behavior of solutions without solving the equation analytically." />
        <jsp:param name="faq4q" value="What ODE types can this calculator solve?" />
        <jsp:param name="faq4a" value="This calculator solves: separable, first-order linear, Bernoulli, exact, homogeneous, second-order constant coefficient (homogeneous and non-homogeneous), Cauchy-Euler, and many other types that SymPy dsolve supports. It automatically classifies the ODE type and applies the appropriate solution method." />
        <jsp:param name="faq5q" value="What is the difference between general and particular solutions?" />
        <jsp:param name="faq5a" value="A general solution contains arbitrary constants (C1, C2, etc.) and represents all possible solutions. A particular solution is obtained by applying initial conditions to determine specific values of these constants. First-order ODEs have one constant (C1), second-order have two (C1, C2)." />
        <jsp:param name="faq6q" value="Is this ODE solver calculator free?" />
        <jsp:param name="faq6a" value="Yes, completely free with no registration required. Includes step-by-step solutions, ODE classification, solution verification, interactive graphs, direction field plots, exportable Python code, and a built-in SymPy compiler." />
        <jsp:param name="faq7q" value="What is a separable differential equation?" />
        <jsp:param name="faq7a" value="A separable ODE has the form dy/dx = g(x)h(y), where the right-hand side factors into a function of x times a function of y. To solve, rewrite as dy/h(y) = g(x)dx and integrate both sides. Examples include y'=xy, y'=y/x, and logistic growth dy/dt=ry(1-y/K). This calculator automatically detects separable ODEs and applies separation of variables with full steps." />
        <jsp:param name="faq8q" value="What is a homogeneous differential equation?" />
        <jsp:param name="faq8a" value="A homogeneous ODE has every term of the same degree in y and its derivatives. For first-order: M(x,y)dx + N(x,y)dy = 0 where M and N are homogeneous of the same degree. For second-order constant-coefficient: ay''+by'+cy=0 with no forcing term. This calculator solves homogeneous ODEs (and non-homogeneous with undetermined coefficients) and shows the characteristic equation and solution form in the steps." />
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
            <h1 class="tool-page-title">ODE Solver Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math">Math Tools</a> /
                ODE Solver Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">3 Modes</span>
            <span class="tool-badge">SymPy CAS</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<!-- Tool Description -->
<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Solve <strong>ordinary differential equations</strong> with <strong>step-by-step solutions</strong>. Three modes: <strong>first-order ODE</strong> solver (separable, linear, Bernoulli, exact), <strong>higher-order ODE</strong> solver (2nd through 5th order, constant coefficient, non-homogeneous), and <strong>direction field</strong> (slope field) plotter. Powered by SymPy with solution verification, interactive graphs, and a built-in Python compiler.</p>
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
                ODE Solver
            </div>
            <div class="tool-card-body">
                <!-- Mode toggle -->
                <div class="ode-mode-toggle">
                    <button type="button" class="ode-mode-btn active" data-mode="first">1st Order</button>
                    <button type="button" class="ode-mode-btn" data-mode="second">Higher-Order</button>
                    <button type="button" class="ode-mode-btn" data-mode="field">Direction Field</button>
                </div>

                <!-- First-order mode input -->
                <div id="ode-first-wrap">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ode-first-expr">dy/dx = f(x, y) &mdash; enter the RHS</label>
                        <input type="text" class="tool-input tool-input-mono" id="ode-first-expr" placeholder="e.g. -2*x*y" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Use <code>y</code> for y(x), e.g. <code>y*(1-y)</code></span>
                    </div>
                    <div class="ode-ic-row">
                        <input type="checkbox" id="ode-first-ic-check"> <label for="ode-first-ic-check">Initial condition y(x&#8320;)=y&#8320;</label>
                    </div>
                    <div class="ode-ic-fields" id="ode-first-ic-fields">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-first-ic-x0">x&#8320;</label>
                            <input type="text" class="tool-input tool-input-mono" id="ode-first-ic-x0" value="0" style="width:100%;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-first-ic-y0">y&#8320;</label>
                            <input type="text" class="tool-input tool-input-mono" id="ode-first-ic-y0" value="1" style="width:100%;">
                        </div>
                    </div>
                </div>

                <!-- Second-order mode input -->
                <div id="ode-second-wrap" style="display:none;">
                    <!-- Order selector -->
                    <div class="ode-order-selector" id="ode-order-selector">
                        <button type="button" class="ode-order-btn active" data-order="2">2nd</button>
                        <button type="button" class="ode-order-btn" data-order="3">3rd</button>
                        <button type="button" class="ode-order-btn" data-order="4">4th</button>
                        <button type="button" class="ode-order-btn" data-order="5">5th</button>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ode-second-expr" id="ode-second-label">d&sup2;y/dx&sup2; = f(x, y, y') &mdash; enter the RHS</label>
                        <input type="text" class="tool-input tool-input-mono" id="ode-second-expr" placeholder="e.g. -2*yp - y" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint" id="ode-second-hint">Use <code>y</code> for y(x), <code>yp</code> for y'(x)</span>
                    </div>
                    <div class="ode-ic-row">
                        <input type="checkbox" id="ode-second-ic-check"> <label for="ode-second-ic-check" id="ode-second-ic-label">Initial conditions y(x&#8320;)=y&#8320;, y'(x&#8320;)=y'&#8320;</label>
                    </div>
                    <div class="ode-ic-fields" id="ode-second-ic-fields">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-second-ic-x0">x&#8320;</label>
                            <input type="text" class="tool-input tool-input-mono" id="ode-second-ic-x0" value="0" style="width:100%;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-second-ic-y0">y&#8320;</label>
                            <input type="text" class="tool-input tool-input-mono" id="ode-second-ic-y0" value="0" style="width:100%;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-second-ic-dy0">y'&#8320;</label>
                            <input type="text" class="tool-input tool-input-mono" id="ode-second-ic-dy0" value="0" style="width:100%;">
                        </div>
                        <div id="ode-extra-ic-fields"></div>
                    </div>
                </div>

                <!-- Direction field mode input -->
                <div id="ode-field-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ode-field-expr">dy/dx = f(x, y) &mdash; enter the RHS</label>
                        <input type="text" class="tool-input tool-input-mono" id="ode-field-expr" placeholder="e.g. x + y" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Direction field for dy/dx = f(x, y)</span>
                    </div>
                    <div style="display:grid;grid-template-columns:1fr 1fr 1fr 1fr;gap:0.5rem;margin-top:0.5rem;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-field-xmin">x min</label>
                            <input type="number" class="tool-input" id="ode-field-xmin" value="-5" style="width:100%;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-field-xmax">x max</label>
                            <input type="number" class="tool-input" id="ode-field-xmax" value="5" style="width:100%;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-field-ymin">y min</label>
                            <input type="number" class="tool-input" id="ode-field-ymin" value="-5" style="width:100%;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-field-ymax">y max</label>
                            <input type="number" class="tool-input" id="ode-field-ymax" value="5" style="width:100%;">
                        </div>
                    </div>
                    <div class="ode-ic-row">
                        <input type="checkbox" id="ode-field-curve-check"> <label for="ode-field-curve-check">Overlay solution curve through (x&#8320;, y&#8320;)</label>
                    </div>
                    <div class="ode-ic-fields" id="ode-field-curve-fields">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-field-curve-x0">x&#8320;</label>
                            <input type="text" class="tool-input tool-input-mono" id="ode-field-curve-x0" value="0" style="width:100%;">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="ode-field-curve-y0">y&#8320;</label>
                            <input type="text" class="tool-input tool-input-mono" id="ode-field-curve-y0" value="1" style="width:100%;">
                        </div>
                    </div>
                </div>

                <!-- Live preview -->
                <div class="tool-form-group" style="margin-top:0.875rem;">
                    <label class="tool-form-label">Live Preview</label>
                    <div class="ode-preview" id="ode-preview">
                        <span style="color:var(--text-muted);font-size:0.8125rem;">Enter an ODE above&hellip;</span>
                    </div>
                </div>

                <!-- Action buttons -->
                <div class="ode-action-row">
                    <button type="button" class="tool-action-btn ode-compute-btn" id="ode-compute-btn">Solve ODE</button>
                    <button type="button" class="ode-random-btn" id="ode-random-btn" title="Random example">&#127922; Random</button>
                </div>

                <hr class="ode-sep">

                <!-- Quick examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="ode-examples" id="ode-examples"></div>
                </div>

                <hr class="ode-sep">

                <!-- ODE Reference Table (collapsible) -->
                <div id="ode-formulas-wrap">
                    <button type="button" class="ode-formulas-toggle" id="ode-formulas-btn">
                        ODE Reference Table
                        <svg class="ode-formulas-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="ode-formulas-content" id="ode-formulas-content">
                        <table class="ode-formulas-table">
                            <thead><tr><th>Type</th><th>Form</th><th>Method</th></tr></thead>
                            <tbody>
                                <tr><td>Separable</td><td id="ode-formula-f0"></td><td id="ode-formula-m0"></td></tr>
                                <tr><td>1st Linear</td><td id="ode-formula-f1"></td><td id="ode-formula-m1"></td></tr>
                                <tr><td>Bernoulli</td><td id="ode-formula-f2"></td><td id="ode-formula-m2"></td></tr>
                                <tr><td>Exact</td><td id="ode-formula-f3"></td><td id="ode-formula-m3"></td></tr>
                                <tr><td>Homogeneous</td><td id="ode-formula-f4"></td><td id="ode-formula-m4"></td></tr>
                                <tr><td>2nd Const Coeff</td><td id="ode-formula-f5"></td><td id="ode-formula-m5"></td></tr>
                                <tr><td>Non-Homogeneous</td><td id="ode-formula-f6"></td><td id="ode-formula-m6"></td></tr>
                                <tr><td>Cauchy-Euler</td><td id="ode-formula-f7"></td><td id="ode-formula-m7"></td></tr>
                                <tr><td>3rd Const Coeff</td><td id="ode-formula-f8"></td><td id="ode-formula-m8"></td></tr>
                                <tr><td>4th Order (Beam)</td><td id="ode-formula-f9"></td><td id="ode-formula-m9"></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <hr class="ode-sep">

                <!-- Syntax help (collapsible) -->
                <div id="ode-syntax-wrap">
                    <button type="button" class="ode-syntax-toggle" id="ode-syntax-btn">
                        Syntax Help
                        <svg class="ode-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="ode-syntax-content" id="ode-syntax-content">
                        <strong>Variable:</strong> <code>y</code> represents y(x)<br>
                        <strong>Derivatives:</strong> <code>yp</code> = y', <code>ypp</code> = y'', <code>yppp</code> = y''', <code>y4</code> = y&#8308;, <code>y5</code> = y&#8309;<br>
                        sin(x) &nbsp;&nbsp; cos(x) &nbsp;&nbsp; tan(x) &nbsp;&nbsp; exp(x)<br>
                        log(x) &nbsp;&nbsp; sqrt(x) &nbsp;&nbsp; asin(x) &nbsp;&nbsp; acos(x)<br>
                        <strong>Powers:</strong> <code>x^2</code> or <code>x**2</code><br>
                        <strong>Multiplication:</strong> Use * explicitly: <code>2*x*y</code><br>
                        <strong>Constants:</strong> pi, e<br>
                        <strong>Examples:</strong> <code>y*(1-y)</code>, <code>-2*yp-y</code>, <code>6*ypp-11*yp+6*y</code>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== OUTPUT COLUMN ========== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="ode-output-tabs">
            <button type="button" class="ode-output-tab active" data-panel="result">Result</button>
            <button type="button" class="ode-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="ode-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="ode-panel active" id="ode-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="ode-result-content">
                    <div class="tool-empty-state" id="ode-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">dy/dx</div>
                        <h3>Enter an ODE and click Solve</h3>
                        <p>Solve ordinary differential equations with step-by-step solutions and graphs.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="ode-result-actions">
                    <button type="button" class="tool-action-btn" id="ode-copy-latex-btn">
                        <span>&#128203;</span> Copy LaTeX
                    </button>
                    <button type="button" class="tool-action-btn" id="ode-download-pdf-btn">
                        <span>&#128196;</span> Download PDF
                    </button>
                    <button type="button" class="tool-action-btn" id="ode-share-btn">
                        <span>&#128279;</span> Share
                    </button>
                    <button type="button" class="tool-action-btn" id="ode-worksheet-btn">
                        <span>&#128218;</span> Print Worksheet
                    </button>
                </div>
            </div>
        </div>

        <!-- Graph Panel -->
        <div class="ode-panel" id="ode-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>Graph</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="ode-graph-container"></div>
                    <p id="ode-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve an ODE to see the graph.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="ode-panel" id="ode-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="ode-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
    <jsp:param name="currentToolUrl" value="ode-solver-calculator.jsp"/>
    <jsp:param name="keyword" value="calculus"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

    <!-- What is an ODE? -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is an Ordinary Differential Equation (ODE)?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">An <strong>ordinary differential equation (ODE)</strong> is an equation involving a function y(x) and its derivatives. The <strong>order</strong> of an ODE is the highest derivative that appears. A first-order ODE has the form y' = f(x,y), while a second-order ODE involves y''. An ODE is <strong>linear</strong> if y and its derivatives appear only to the first power and are not multiplied together.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">ODEs are fundamental in mathematics, physics, engineering, and biology. They model everything from population growth and radioactive decay to spring-mass systems and electrical circuits.</p>
    </div>

    <!-- ODE Solution Methods -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">ODE Solution Methods</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin-top: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #db2777;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Separation of Variables</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">For separable ODEs y'=f(x)g(y), move all y-terms to one side and x-terms to the other, then integrate both sides independently.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #f472b6;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Integrating Factor</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">For linear ODEs y'+P(x)y=Q(x), multiply by &mu;=e<sup>&int;P dx</sup> to make the left side an exact derivative d(&mu;y)/dx.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #be185d;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Characteristic Equation</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">For constant-coefficient ODEs ay''+by'+cy=0, substitute y=e<sup>rx</sup> to get ar&sup2;+br+c=0. Roots determine the solution form.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #fda4af;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Direction Fields</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Visualize ODE behavior by plotting slope segments at grid points. Reveals equilibria, stability, and long-term solution behavior without solving.</p>
            </div>
        </div>
    </div>

    <!-- Applications -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Applications</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9881;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Physics</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Newton's second law F=ma, harmonic oscillators, pendulums, and orbital mechanics are all described by ODEs.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127793;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Population Dynamics</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Exponential growth, logistic models, predator-prey (Lotka-Volterra), and SIR epidemic models.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9889;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Circuit Analysis</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">RC, RL, and RLC circuits are modeled by first and second-order ODEs using Kirchhoff's laws.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128293;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Heat &amp; Diffusion</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Newton's law of cooling, Fick's law of diffusion, and chemical reaction kinetics.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you solve a first-order ODE?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">First identify the ODE type: separable, linear, Bernoulli, exact, or homogeneous. Then apply the appropriate method. For separable ODEs, separate variables and integrate both sides. For linear ODEs y'+P(x)y=Q(x), multiply by the integrating factor &mu;=e<sup>&int;P dx</sup>. This calculator automatically classifies and solves first-order ODEs using SymPy's dsolve.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Does this ODE solver support initial conditions (IVP)?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes. This calculator solves initial value problems (IVPs)—ODEs with initial conditions at a specific point. For first-order: y(x&#8320;)=y&#8320;. For second-order: y(x&#8320;)=y&#8320; and y'(x&#8320;)=y'&#8320;. Initial conditions determine the unique particular solution from the general solution family.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is a direction field (slope field)?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A direction field is a graphical representation of a first-order ODE dy/dx=f(x,y). At each point (x,y) in the plane, a short line segment shows the slope f(x,y). The pattern of these segments reveals the qualitative behavior of solutions without solving the equation analytically.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What ODE types can this calculator solve?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">This calculator solves: separable, first-order linear, Bernoulli, exact, homogeneous, second-order constant coefficient (homogeneous and non-homogeneous), Cauchy-Euler, and many other types that SymPy's dsolve supports. It automatically classifies the ODE type and applies the appropriate solution method.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between general and particular solutions?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A general solution contains arbitrary constants (C1, C2, etc.) and represents all possible solutions. A particular solution is obtained by applying initial conditions to determine specific values of these constants. First-order ODEs have one constant (C1), second-order have two (C1, C2).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this ODE solver calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, completely free with no registration required. Includes step-by-step solutions, ODE classification, solution verification, interactive graphs, direction field plots, exportable Python code, and a built-in SymPy compiler.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is a separable differential equation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A separable ODE has the form dy/dx = g(x)h(y), where the right-hand side factors into a function of x times a function of y. To solve, rewrite as dy/h(y) = g(x)dx and integrate both sides. Examples include y'=xy, y'=y/x, and logistic growth dy/dt=ry(1-y/K). This calculator automatically detects separable ODEs and applies separation of variables with full steps.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is a homogeneous differential equation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A homogeneous ODE has every term of the same degree in y and its derivatives. For first-order: M(x,y)dx + N(x,y)dy = 0 where M and N are homogeneous of the same degree. For second-order constant-coefficient: ay''+by'+cy=0 with no forcing term. This calculator solves homogeneous ODEs (and non-homogeneous with undetermined coefficients) and shows the characteristic equation and solution form in the steps.</div>
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
            <a href="<%=request.getContextPath()%>/laplace-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(219,39,119,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #0891b2, #06b6d4); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8466;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Laplace Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Laplace transforms with steps and ROC</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/finite-difference-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(219,39,119,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #0d9488, #14b8a6); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#916;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Finite Difference Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward, central &amp; backward differences with steps</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/convolution-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(219,39,119,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #d97706, #f59e0b); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&ast;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Convolution Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Continuous &amp; discrete convolution with steps and graphs</p>
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

<script>window.ODE_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/ode-solver-calculator.js?v=<%=cacheVersion%>"></script>

</body>
</html>
