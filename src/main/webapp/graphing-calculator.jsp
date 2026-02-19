<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free Online Graphing Calculator - Plot Equations & Functions" />
        <jsp:param name="toolDescription" value="Free online graphing calculator. Plot multiple functions, equations, and inequalities with interactive pan/zoom. Graph y=f(x), parabolas, trig, polar, and parametric equations. No download needed." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="graphing-calculator.jsp" />
        <jsp:param name="toolKeywords" value="graphing calculator, online graphing calculator, graphing calculator online free, function plotter, equation grapher, graph equations online, plot function online, math graphing tool, interactive graph plotter, free graphing calculator no download, graph y=f(x), graph parabola calculator, plot multiple functions, desmos alternative, graph inequalities online, polar graph, parametric equations, implicit functions, calculus calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Cartesian function plotting y=f(x),Parametric equations x(t) y(t),Polar coordinates r=f(theta),Implicit functions like x^2+y^2=25,Piecewise function support,Statistical distribution plotting,Derivative visualization and integration shading,Parameter sliders with animation,Trace mode with slope calculation,Equation solver and intersection finder,Export graphs as PNG or SVG,Save share and load graph sets,35+ built-in presets for math physics and ML,Text-to-graph converter,Regression analysis" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What kinds of expressions can I plot?" />
        <jsp:param name="faq1a" value="You can plot standard Cartesian functions y=f(x) such as sin(x) or x^2, parametric curves x(t) and y(t), polar graphs r=f(theta), implicit equations like x^2+y^2=25, piecewise functions, inequalities, data tables, and statistical distributions including Normal and Chi-squared." />
        <jsp:param name="faq2q" value="How do I add multiple functions and compare them?" />
        <jsp:param name="faq2a" value="Click the Add Expression button to insert more functions. Each expression gets its own color, type selector, and controls. You can overlay Cartesian, parametric, polar, and implicit curves on the same graph. Use the preset chips for instant multi-expression demos." />
        <jsp:param name="faq3q" value="Does the graphing calculator support calculus tools?" />
        <jsp:param name="faq3a" value="Yes. For any Cartesian function you can enable the derivative overlay to see the slope curve, shade the area under the curve with adjustable integration bounds, find roots where f(x)=0, and locate intersections between two functions. Trace mode shows coordinates and slope at any point." />
        <jsp:param name="faq4q" value="Can I use parameter sliders and animation?" />
        <jsp:param name="faq4a" value="Absolutely. Include letters like a, b, or c in your expression and sliders are created automatically. Click the play button on any slider to animate the parameter and watch the graph evolve in real time. Adjust animation speed with the dropdown." />
        <jsp:param name="faq5q" value="Is this graphing calculator free and does it work offline?" />
        <jsp:param name="faq5a" value="Yes, 100 percent free with no signup or limits. All computation runs in your browser using Math.js and Plotly.js. You can export graphs as PNG or SVG, save expression sets to local storage, and generate shareable URLs. It works on desktop, tablet, and mobile." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/graphing-calculator.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- Font Awesome (engine.js generates fas fa-* icons) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- KaTeX -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <script data-cfasync="false" src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script data-cfasync="false" src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js"></script>

    <!-- Math.js & Plotly (eager — graph renders immediately) -->
    <script data-cfasync="false" src="https://cdnjs.cloudflare.com/ajax/libs/mathjs/12.4.1/math.min.js"></script>
    <script data-cfasync="false" src="https://cdn.plot.ly/plotly-2.27.0.min.js"></script>

    <style>
        .tool-action-btn { background: var(--gc-gradient) !important; }
        .tool-badge { background: var(--gc-light); color: var(--gc-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<!-- ==================== PAGE HEADER ==================== -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Graphing Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                Graphing Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">Interactive</span>
            <span class="tool-badge">35+ Presets</span>
        </div>
    </div>
</header>

<!-- ==================== DESCRIPTION ==================== -->
<section class="tool-description-section" style="background:var(--gc-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>online graphing calculator</strong> for plotting <strong>Cartesian, parametric, polar, and implicit</strong> equations. Trace slopes, find intersections, shade integrals, animate parameter sliders, and export as PNG/SVG.</p>
        </div>
    </div>
</section>

<!-- ==================== THREE-COLUMN LAYOUT ==================== -->
<main class="tool-page-container gc-page-container">

    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">

        <!-- Expressions Card -->
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--gc-gradient);"><i class="fas fa-chart-line" style="margin-right:0.375rem;"></i> Expressions</div>
            <div class="tool-card-body">
                <div id="expressions-list"></div>
                <button class="gc-btn-add" onclick="addExpression()">
                    <i class="fas fa-plus"></i> Add Expression
                </button>
            </div>
        </div>

        <!-- Presets Card (collapsible) -->
        <div class="tool-card" style="margin-top:0.75rem;">
            <div class="tool-section-header collapsed" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('hidden');" style="color:var(--gc-tool);">
                <span><i class="fas fa-wand-magic-sparkles" style="margin-right:0.375rem;"></i> Presets &amp; Examples</span>
                <span class="chevron">&#9660;</span>
            </div>
            <div class="tool-section-content hidden">
                <!-- Quick Samples -->
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Quick Samples</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickSample('cartesian')">sin(x)</button>
                        <button class="gc-preset-chip" onclick="gcQuickSample('parametric')">Parametric</button>
                        <button class="gc-preset-chip" onclick="gcQuickSample('polar')">Polar</button>
                        <button class="gc-preset-chip" onclick="gcQuickSample('implicit')">Implicit</button>
                    </div>
                </div>
                <!-- Multi-Expression -->
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Multi-Expression</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickPreset('sin_cos')">Sin + Cos</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('circle_line')">Circle + Line</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('polar_flowers')">Polar Flowers</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('band_inequality')">Inequality</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('data_vs_fit')">Data + Fit</button>
                    </div>
                </div>
                <!-- Parametric & Growth -->
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Parametric &amp; Growth</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickPreset('lissajous')">Lissajous</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('hypotrochoid')">Hypotrochoid</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('logistic_exp')">Logistic vs Exp</button>
                    </div>
                </div>
                <!-- Advanced -->
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Advanced</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickPreset('rose_curves')">Rose Curves</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('piece_deriv_integral')">Piecewise+Calc</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('quad_regression')">Regression</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('fourier_square')">Fourier Square</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('spirals')">Spirals</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('distributions_overlay')">Distributions</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('deltoid')">Deltoid</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('lemniscate')">Lemniscate</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('butterfly')">Butterfly</button>
                    </div>
                </div>
                <!-- Creative Curves -->
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Creative Curves</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickPreset('heart')">Heart</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('spirograph')">Spirograph</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('astroid')">Astroid</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('cardioid')">Cardioid</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('golden_spiral')">Golden Spiral</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('cycloid')">Cycloid</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('nephroid')">Nephroid</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('limacon')">Lima&ccedil;on</button>
                    </div>
                </div>
                <!-- Physics & Science -->
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Physics &amp; Science</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickPreset('damped_oscillation')">Damped Osc.</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('catenary')">Catenary</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('wave_interference')">Wave Interf.</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('projectile')">Projectile</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('pendulum_phase')">Pendulum</button>
                    </div>
                </div>
                <!-- Classic & Historical -->
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Classic &amp; Historical</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickPreset('witch_agnesi')">Witch of Agnesi</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('folium')">Folium</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('cissoid')">Cissoid</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('tractrix')">Tractrix</button>
                    </div>
                </div>
                <!-- Machine Learning -->
                <div class="gc-preset-category">
                    <div class="gc-preset-category-label">Machine Learning</div>
                    <div class="gc-preset-chips">
                        <button class="gc-preset-chip" onclick="gcQuickPreset('activation_functions')">Activations</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('sigmoid_tanh')">Sigmoid/Tanh</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('relu_variants')">ReLU Variants</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('loss_functions')">Loss Fns</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('softmax')">Softmax</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('gradient_descent')">Grad Descent</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('learning_rates')">Learn Rates</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('regularization')">L1 vs L2</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('decision_boundary')">Decision Bnd</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('gaussian_distributions')">Gaussians</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('bias_variance')">Bias-Variance</button>
                        <button class="gc-preset-chip" onclick="gcQuickPreset('vanishing_gradient')">Vanish Grad</button>
                    </div>
                </div>
                <button class="gc-preset-chip" style="margin-top:0.5rem;border-color:#dc3545;color:#dc3545;" onclick="gcClearAll()"><i class="fas fa-broom"></i> Clear All</button>
            </div>
        </div>

        <!-- Graph Settings Card (collapsible) -->
        <div class="tool-card" style="margin-top:0.75rem;">
            <div class="tool-section-header" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('hidden');" style="color:var(--gc-tool);">
                <span><i class="fas fa-cog" style="margin-right:0.375rem;"></i> Graph Settings</span>
                <span class="chevron">&#9660;</span>
            </div>
            <div class="tool-section-content">
                <div class="tool-form-group" style="margin-bottom:0.5rem;">
                    <label class="tool-form-label">X Range</label>
                    <div style="display:flex;gap:0.5rem;">
                        <input type="number" class="tool-input" id="xMin" value="-10" placeholder="Min" style="text-align:center;">
                        <input type="number" class="tool-input" id="xMax" value="10" placeholder="Max" style="text-align:center;">
                    </div>
                </div>
                <div class="tool-form-group" style="margin-bottom:0.5rem;">
                    <label class="tool-form-label">Y Range</label>
                    <div style="display:flex;gap:0.5rem;">
                        <input type="number" class="tool-input" id="yMin" value="-10" placeholder="Min" style="text-align:center;">
                        <input type="number" class="tool-input" id="yMax" value="10" placeholder="Max" style="text-align:center;">
                    </div>
                </div>
                <div style="display:flex;gap:1rem;margin-bottom:0.5rem;">
                    <label class="tool-checkbox">
                        <input type="checkbox" id="showGrid" checked onchange="updateGraph()"> Show Grid
                    </label>
                    <label class="tool-checkbox">
                        <input type="checkbox" id="showLegend" checked onchange="updateGraph()"> Legend
                    </label>
                </div>
                <div class="gc-sidebar-actions" style="margin-top:0.5rem;">
                    <button class="gc-action-btn" onclick="findIntersections()"><i class="fas fa-project-diagram"></i> Intersections</button>
                    <button class="gc-action-btn" onclick="solveEquation()"><i class="fas fa-calculator"></i> Solve f(x)=0</button>
                    <button class="gc-action-btn" onclick="textToGraph()"><i class="fas fa-font"></i> Text to Graph</button>
                    <button class="gc-action-btn" onclick="updateGraph()"><i class="fas fa-refresh"></i> Apply Range</button>
                </div>
            </div>
        </div>

        <!-- Export & Save Card (collapsible, collapsed by default) -->
        <div class="tool-card" style="margin-top:0.75rem;">
            <div class="tool-section-header collapsed" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('hidden');" style="color:var(--gc-tool);">
                <span><i class="fas fa-download" style="margin-right:0.375rem;"></i> Export &amp; Save</span>
                <span class="chevron">&#9660;</span>
            </div>
            <div class="tool-section-content hidden">
                <div class="gc-sidebar-actions">
                    <button class="gc-action-btn" onclick="exportAsPNG()"><i class="fas fa-image"></i> Export as PNG</button>
                    <button class="gc-action-btn" onclick="exportAsSVG()"><i class="fas fa-file-image"></i> Export as SVG</button>
                    <button class="gc-action-btn" onclick="saveExpressionSet()"><i class="fas fa-save"></i> Save Expression Set</button>
                    <button class="gc-action-btn" onclick="loadExpressionSet()"><i class="fas fa-folder-open"></i> Load Expression Set</button>
                    <button class="gc-action-btn" onclick="manageSavedSets()"><i class="fas fa-trash"></i> Manage Saved Sets</button>
                    <button class="gc-action-btn" onclick="generateShareableLink()"><i class="fas fa-share-alt"></i> Generate Share Link</button>
                </div>
            </div>
        </div>

        <!-- Quick Guide Card (collapsible, collapsed by default) -->
        <div class="tool-card" style="margin-top:0.75rem;">
            <div class="tool-section-header collapsed" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('hidden');" style="color:var(--gc-tool);">
                <span><i class="fas fa-info-circle" style="margin-right:0.375rem;"></i> Quick Guide</span>
                <span class="chevron">&#9660;</span>
            </div>
            <div class="tool-section-content hidden">
                <div class="gc-quick-guide">
                    <strong>Plot Types:</strong><br>
                    Cartesian: y = x^2, sin(x)<br>
                    Parametric: cos(t), sin(t)<br>
                    Polar: r = 2 + 2*cos(&theta;)<br>
                    Inequality: y &gt; x^2<br>
                    Table: x,y pairs (one per line)<br>
                    Regression: Fit line to data<br>
                    Distribution: Normal, Chi&sup2;, etc.<br><br>
                    <strong>Advanced Features:</strong><br>
                    Use a,b,c in expressions for auto-sliders<br>
                    Click play to animate parameters<br>
                    Check &ldquo;Show f'(x)&rdquo; for derivatives<br>
                    Trace Mode: hover for coordinates &amp; slope<br><br>
                    <strong>Functions:</strong><br>
                    Trig: sin, cos, tan, asin, acos, atan<br>
                    Logs: log (ln), log10, exp<br>
                    Powers: sqrt, cbrt, x^n<br>
                    Other: abs, ceil, floor, round, sign<br>
                    Constants: pi, e
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <div class="gc-graph-card">
            <div class="gc-graph-toolbar">
                <span class="gc-graph-toolbar-title"><i class="fas fa-chart-line"></i> Graph</span>
                <div class="gc-graph-toolbar-actions">
                    <button class="gc-toolbar-btn" onclick="resetView()" title="Reset View"><i class="fas fa-sync"></i></button>
                    <button class="gc-toolbar-btn" onclick="toggleTraceMode()" title="Trace Mode"><i class="fas fa-crosshairs"></i></button>
                    <button class="gc-toolbar-btn" onclick="exportAsPNG()" title="Export PNG"><i class="fas fa-image"></i></button>
                </div>
            </div>
            <div id="graph"></div>
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
    <jsp:param name="currentToolUrl" value="graphing-calculator.jsp"/>
    <jsp:param name="keyword" value="math"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ==================== VISIBLE FAQ SECTION ==================== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What kinds of expressions can I plot?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">You can plot standard Cartesian functions y=f(x) such as sin(x) or x&sup2;, parametric curves x(t) and y(t), polar graphs r=f(&theta;), implicit equations like x&sup2;+y&sup2;=25, piecewise functions, inequalities, data tables, and statistical distributions including Normal and Chi-squared.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I add multiple functions and compare them?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Click the Add Expression button to insert more functions. Each expression gets its own color, type selector, and controls. You can overlay Cartesian, parametric, polar, and implicit curves on the same graph. Use the preset chips for instant multi-expression demos.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Does the graphing calculator support calculus tools?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes. For any Cartesian function you can enable the derivative overlay to see the slope curve, shade the area under the curve with adjustable integration bounds, find roots where f(x)=0, and locate intersections between two functions. Trace mode shows coordinates and slope at any point.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can I use parameter sliders and animation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Absolutely. Include letters like a, b, or c in your expression and sliders are created automatically. Click the play button on any slider to animate the parameter and watch the graph evolve in real time. Adjust animation speed with the dropdown.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this graphing calculator free and does it work offline?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, 100% free with no signup. All computation runs in your browser using Math.js and Plotly.js. You can export graphs as PNG or SVG, save expression sets to local storage, and generate shareable URLs. It works on desktop, tablet, and mobile.</div>
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

<!-- Dark mode bridge: sync [data-theme="dark"] -> window.GC_DARK + replot -->
<script>
(function(){
  function syncDark(){
    var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    window.GC_DARK = isDark;
    try{ if (typeof updateGraph === 'function') updateGraph(); }catch(_){}
  }
  new MutationObserver(syncDark).observe(document.documentElement, {attributes:true, attributeFilter:['data-theme']});
  document.addEventListener('DOMContentLoaded', syncDark);
})();
</script>

<!-- Library load check -->
<script>
document.addEventListener('DOMContentLoaded', function(){
  if (typeof math === 'undefined' || typeof Plotly === 'undefined'){
    var w = document.createElement('div');
    w.className = 'tool-alert tool-alert-error';
    w.style.margin = '1rem';
    w.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Required libraries failed to load. If you use script optimizers (e.g., Rocket Loader), disable them for this page.';
    var main = document.querySelector('.gc-page-container');
    if (main) main.parentNode.insertBefore(w, main);
  }
});
</script>

<!-- Engine (synchronous) -->
<script data-cfasync="false" src="<%=request.getContextPath()%>/js/graphing-tool-engine.js"></script>

<!-- Presets (after engine) -->
<script data-cfasync="false" src="<%=request.getContextPath()%>/js/graphing-calculator-presets.js?v=<%=cacheVersion%>"></script>

<!-- Plotly auto-resize -->
<script>
(function(){
  var g = document.getElementById('graph');
  if (g && typeof ResizeObserver !== 'undefined') {
    new ResizeObserver(function(){ try{ Plotly.Plots.resize('graph'); }catch(_){} }).observe(g);
  }
})();
</script>

<!-- Share URL backward compat -->
<script>
document.addEventListener('DOMContentLoaded', function(){
  try{ if (typeof loadFromURL === 'function') loadFromURL(); }catch(_){}
});
</script>

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
