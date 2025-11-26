<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- SEO Meta Tags -->
    <title>Graphing Calculator Online – Free | 8gwifi.org</title>
    <meta name="description" content="Free advanced graphing calculator online. Plot functions, parametric equations, polar curves, implicit functions, piecewise functions, statistical distributions, and more. Features derivatives, integrals, equation solver, and animation. No download required - works in browser like Desmos.">
    <meta name="keywords" content="graphing calculator, online graphing calculator, free graphing calculator, plot functions online, graph equations, math calculator, desmos alternative, equation plotter, function grapher, calculus calculator, derivative calculator, integral calculator, polar graph, parametric equations, implicit functions, piecewise functions, statistical graphs">
    <meta name="author" content="Advanced Math Tools">
    <meta name="robots" content="index, follow">
    <link rel="canonical" href="https://8gwifi.org/graphing-calculator.jsp">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/graphing-calculator.jsp">
    <meta property="og:title" content="Graphing Calculator Online – Free | 8gwifi.org">
    <meta property="og:description" content="Plot functions and equations (Cartesian, parametric, polar, implicit) with sliders, zoom, and calculus tools.">
    

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="https://8gwifi.org/graphing-calculator.jsp">
    <meta property="twitter:title" content="Graphing Calculator Online – Free | 8gwifi.org">
    <meta property="twitter:description" content="Plot functions (y=f(x)), parametric, polar, and implicit curves with interactive controls and analysis.">

    <!-- JSON-LD Schema Markup -->
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Advanced Graphing Calculator",
            "applicationCategory": "EducationalApplication",
            "operatingSystem": "Web Browser",
            "offers": {
                "@type": "Offer",
                "price": "0",
                "priceCurrency": "USD"
            },
            "description": "Free online graphing calculator for plotting mathematical functions, equations, and graphs. Features include derivatives, integrals, parametric equations, polar curves, implicit functions, piecewise functions, statistical distributions, equation solver, intersection finder, numerical integration, animation mode, and more. Perfect alternative to Desmos for students, teachers, and math enthusiasts.",
            "url": "https://8gwifi.org/graphing-calculator.jsp",
            "screenshot": "https://8gwifi.org/images/site/graphing-calculator-preview.png",
            "softwareVersion": "2.0",
            "featureList": [
                "Cartesian function plotting (y=f(x))",
                "Parametric equations (x(t), y(t))",
                "Polar coordinates (r=f(θ))",
                "Implicit functions (x²+y²=25)",
                "Piecewise functions",
                "Statistical distributions (Normal, Chi-squared, Poisson, etc.)",
                "Derivative visualization",
                "Numerical integration (area under curve)",
                "Equation solver (find roots)",
                "Intersection finder",
                "Parameter sliders with animation",
                "Trace mode with slope calculation",
                "Export graphs as PNG/SVG",
                "Save and share graphs",
                "Text-to-graph converter",
                "Regression analysis"
            ],
            "audience": {
                "@type": "EducationalAudience",
                "educationalRole": "student, teacher, researcher"
            },
            "keywords": "graphing calculator, function plotter, math visualization, calculus tool, equation grapher, desmos alternative, free online calculator",
            "inLanguage": "en-US",
            "isAccessibleForFree": true,
            "datePublished": "2025-01-22",
            "dateModified": "2025-01-22",
            "creator": {
                "@type": "Organization",
                "name": "Advanced Math Tools"
            }
        }
    </script>

    <!-- Math.js for expression parsing -->
    <script data-cfasync="false" src="https://cdnjs.cloudflare.com/ajax/libs/mathjs/12.4.1/math.min.js"></script>

    <!-- Plotly.js for graphing -->
    <script data-cfasync="false" src="https://cdn.plot.ly/plotly-2.27.0.min.js"></script>

    <!-- Bootstrap for UI -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- KaTeX for beautiful math rendering -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <script data-cfasync="false" src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script data-cfasync="false" src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js"></script>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .container-fluid {
            padding: 0;
        }

        .sidebar {
            background: white;
            height: calc(100vh - 80px);
            overflow-y: auto;
            padding: 20px;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
        }

        .graph-container {
            height: calc(100vh - 80px);
            background: white;
            padding: 20px;
        }

        #graph {
            width: 100%;
            height: 100%;
        }

        .expression-item {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 12px;
            margin-bottom: 10px;
            border-radius: 4px;
            position: relative;
        }

        .expression-item.active {
            background: #e7f3ff;
            border-left-color: #0066cc;
        }

        .expression-input {
            width: 100%;
            font-family: 'Courier New', monospace;
            font-size: 15px;
            padding: 10px 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            background: #ffffff;
            transition: border-color .2s ease, box-shadow .2s ease, background .2s ease;
        }

        .expression-input::placeholder { color:#7a7a7a; opacity:1; }

        .expression-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,.15);
            background: #ffffff;
        }

        .color-picker {
            width: 30px;
            height: 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-add {
            width: 100%;
            margin-top: 10px;
            background: #667eea;
            border: none;
        }

        .btn-add:hover {
            background: #5568d3;
        }

        .plot-type-select {
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 4px;
            border: 1px solid #ddd;
            background: white;
        }

        .delete-btn {
            position: absolute;
            right: 10px;
            top: 10px;
            border: none;
            background: #dc3545;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }

        .delete-btn:hover {
            background: #c82333;
        }

        .controls {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-top: 8px;
        }

        .table-input {
            width: 100%;
            margin-top: 5px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
        }

        .stats-output {
            background: #e7f3ff;
            padding: 10px;
            border-radius: 4px;
            margin-top: 10px;
            font-size: 12px;
            font-family: 'Courier New', monospace;
        }

        .settings-panel {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }

        .settings-panel h6 {
            color: #667eea;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .form-check-label {
            font-size: 14px;
        }

        .range-input {
            width: 100%;
            font-size: 12px;
            padding: 4px;
            margin-top: 5px;
        }

        .math-preview {
            background: white;
            padding: 8px 12px;
            border-radius: 4px;
            margin-top: 8px;
            border: 1px solid #e0e0e0;
            min-height: 40px;
            display: flex;
            align-items: center;
            font-size: 16px;
        }

        .math-preview .katex {
            font-size: 1.1em;
        }

        .preview-label {
            font-size: 11px;
            color: #666;
            margin-bottom: 4px;
            font-weight: 500;
        }

        /* Dark mode */
        body.gc-dark .header { background: linear-gradient(135deg, #0f172a 0%, #334155 100%); }
        body.gc-dark { background:#0b0f14; color:#e5e7eb; }
        body.gc-dark .sidebar { background:#0f172a; color:#e5e7eb; box-shadow: 2px 0 10px rgba(0,0,0,0.4); }
        body.gc-dark .settings-panel { background:#111827; }
        body.gc-dark .form-check-label, body.gc-dark label, body.gc-dark .text-muted { color:#94a3b8 !important; }
        body.gc-dark input, body.gc-dark textarea, body.gc-dark select { background:#0b1220; color:#e5e7eb; border-color:#1f2937; }
        body.gc-dark .expression-input { background:#0b1220; border-color:#334155; }
        body.gc-dark .expression-input:focus { border-color:#60a5fa; box-shadow:0 0 0 3px rgba(96,165,250,.15); }
        body.gc-dark .btn-add { background:#1e293b; }
        body.gc-dark .expression-item { background:#0b1220; border-left-color:#60a5fa; }
    </style>
    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
<div class="header">
    <div class="container-fluid">
        <h3><i class="fas fa-chart-line"></i> Advanced Graphing Calculator</h3>
        <p class="mb-0" style="font-size: 14px;">Graphing tool with multiple plot types</p>
        <div class="d-flex align-items-center mt-2" style="gap:12px;">
            <div class="form-check form-switch">
              <input class="form-check-input" type="checkbox" id="gcDarkToggle">
              <label class="form-check-label" for="gcDarkToggle">Dark mode</label>
            </div>
            <div class="btn-group">
              <button class="btn btn-sm btn-outline-light dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fas fa-wand-magic-sparkles"></i> Examples</button>
              <div class="dropdown-menu">
                <button class="dropdown-item" onclick="gcQuickSample('cartesian')">Cartesian: sin(x)</button>
                <button class="dropdown-item" onclick="gcQuickSample('parametric')">Parametric: Circle</button>
                <button class="dropdown-item" onclick="gcQuickSample('polar')">Polar: Spiral</button>
                <button class="dropdown-item" onclick="gcQuickSample('implicit')">Implicit: Circle</button>
                <div class="dropdown-divider"></div>
                <h6 class="dropdown-header">Multi‑Expression Presets</h6>
                <button class="dropdown-item" onclick="gcQuickPreset('sin_cos')">Sine + Cosine</button>
                <button class="dropdown-item" onclick="gcQuickPreset('circle_line')">Circle + Line</button>
                <button class="dropdown-item" onclick="gcQuickPreset('polar_flowers')">Polar Flowers</button>
                <button class="dropdown-item" onclick="gcQuickPreset('band_inequality')">Inequality Band</button>
                <button class="dropdown-item" onclick="gcQuickPreset('data_vs_fit')">Data Points + Fit Line</button>
                <div class="dropdown-divider"></div>
                <h6 class="dropdown-header">Parametric & Growth</h6>
                <button class="dropdown-item" onclick="gcQuickPreset('lissajous')">Lissajous Curve</button>
                <button class="dropdown-item" onclick="gcQuickPreset('hypotrochoid')">Hypotrochoid</button>
                <button class="dropdown-item" onclick="gcQuickPreset('logistic_exp')">Logistic vs Exponential</button>
                <div class="dropdown-divider"></div>
                <h6 class="dropdown-header">More</h6>
                <button class="dropdown-item" onclick="gcQuickPreset('rose_curves')">Rose Curves (k=3,4,5)</button>
                <button class="dropdown-item" onclick="gcQuickPreset('piece_deriv_integral')">Piecewise + Derivative + Integral</button>
                <button class="dropdown-item" onclick="gcQuickPreset('quad_regression')">Quadratic Regression (random data)</button>
                <button class="dropdown-item" onclick="gcQuickPreset('fourier_square')">Fourier Square Wave (partials)</button>
                <button class="dropdown-item" onclick="gcQuickPreset('spirals')">Spirals: Archimedean vs Log</button>
                <button class="dropdown-item" onclick="gcQuickPreset('distributions_overlay')">Normal vs Student's t (PDF)</button>
                <button class="dropdown-item" onclick="gcQuickPreset('deltoid')">Deltoid (Epicycloid)</button>
                <button class="dropdown-item" onclick="gcQuickPreset('lemniscate')">Lemniscate (Implicit)</button>
                <button class="dropdown-item" onclick="gcQuickPreset('butterfly')">Butterfly Curve (Polar)</button>
                <div class="dropdown-divider"></div>
                <h6 class="dropdown-header">Creative Curves</h6>
                <button class="dropdown-item" onclick="gcQuickPreset('heart')">❤️ Heart Curve</button>
                <button class="dropdown-item" onclick="gcQuickPreset('spirograph')">🎨 Spirograph Pattern</button>
                <button class="dropdown-item" onclick="gcQuickPreset('astroid')">⭐ Astroid (4-cusped Star)</button>
                <button class="dropdown-item" onclick="gcQuickPreset('cardioid')">💗 Cardioid</button>
                <button class="dropdown-item" onclick="gcQuickPreset('golden_spiral')">🐚 Golden Spiral</button>
                <button class="dropdown-item" onclick="gcQuickPreset('cycloid')">🔄 Cycloid</button>
                <button class="dropdown-item" onclick="gcQuickPreset('nephroid')">☕ Nephroid (Coffee Cup Caustic)</button>
                <button class="dropdown-item" onclick="gcQuickPreset('limacon')">🐌 Limaçon Family</button>
                <div class="dropdown-divider"></div>
                <h6 class="dropdown-header">Physics & Science</h6>
                <button class="dropdown-item" onclick="gcQuickPreset('damped_oscillation')">📉 Damped Oscillation</button>
                <button class="dropdown-item" onclick="gcQuickPreset('catenary')">⛓️ Catenary (Hanging Chain)</button>
                <button class="dropdown-item" onclick="gcQuickPreset('wave_interference')">🌊 Wave Interference</button>
                <button class="dropdown-item" onclick="gcQuickPreset('projectile')">🎯 Projectile Motion</button>
                <button class="dropdown-item" onclick="gcQuickPreset('pendulum_phase')">🕐 Pendulum Phase Space</button>
                <div class="dropdown-divider"></div>
                <h6 class="dropdown-header">Classic & Historical</h6>
                <button class="dropdown-item" onclick="gcQuickPreset('witch_agnesi')">🧙 Witch of Agnesi</button>
                <button class="dropdown-item" onclick="gcQuickPreset('folium')">🍀 Folium of Descartes</button>
                <button class="dropdown-item" onclick="gcQuickPreset('cissoid')">📐 Cissoid of Diocles</button>
                <button class="dropdown-item" onclick="gcQuickPreset('tractrix')">🛞 Tractrix</button>
              </div>
            </div>
            <button class="btn btn-sm btn-outline-light" onclick="gcClearAll()"><i class="fas fa-broom"></i> Clear All</button>
        </div>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-3 sidebar">
            <h5>Expressions</h5>
            <div id="expressions-list"></div>
            <button class="btn btn-primary btn-add" onclick="addExpression()">
                <i class="fas fa-plus"></i> Add Expression
            </button>

            <div class="settings-panel">
                <h6><i class="fas fa-cog"></i> Graph Settings</h6>

                <div class="mb-3">
                    <label class="form-label">X Range</label>
                    <div class="d-flex gap-2">
                        <input type="number" class="form-control form-control-sm" id="xMin" value="-10" placeholder="Min">
                        <input type="number" class="form-control form-control-sm" id="xMax" value="10" placeholder="Max">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Y Range</label>
                    <div class="d-flex gap-2">
                        <input type="number" class="form-control form-control-sm" id="yMin" value="-10" placeholder="Min">
                        <input type="number" class="form-control form-control-sm" id="yMax" value="10" placeholder="Max">
                    </div>
                </div>

                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="showGrid" checked onchange="updateGraph()">
                    <label class="form-check-label" for="showGrid">Show Grid</label>
                </div>

                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="showLegend" checked onchange="updateGraph()">
                    <label class="form-check-label" for="showLegend">Show Legend</label>
                </div>

                <button class="btn btn-sm btn-secondary mt-3 w-100" onclick="resetView()">
                    <i class="fas fa-sync"></i> Reset View
                </button>

                <button class="btn btn-sm btn-primary mt-2 w-100" onclick="findIntersections()">
                    <i class="fas fa-project-diagram"></i> Find Intersections
                </button>

                <button class="btn btn-sm btn-secondary mt-2 w-100" onclick="toggleTraceMode()">
                    <i class="fas fa-crosshairs"></i> Trace Mode
                </button>

                <button class="btn btn-sm btn-info mt-2 w-100" onclick="solveEquation()">
                    <i class="fas fa-calculator"></i> Solve Equation
                </button>

                <button class="btn btn-sm btn-warning mt-2 w-100" onclick="textToGraph()">
                    <i class="fas fa-font"></i> Text to Graph
                </button>
            </div>

            <div class="settings-panel">
                <h6><i class="fas fa-download"></i> Export & Save</h6>

                <div class="d-grid gap-2">
                    <button class="btn btn-sm btn-success" onclick="exportAsPNG()">
                        <i class="fas fa-image"></i> Export as PNG
                    </button>
                    <button class="btn btn-sm btn-success" onclick="exportAsSVG()">
                        <i class="fas fa-file-image"></i> Export as SVG
                    </button>
                    <button class="btn btn-sm btn-primary" onclick="saveExpressionSet()">
                        <i class="fas fa-save"></i> Save Expression Set
                    </button>
                    <button class="btn btn-sm btn-info" onclick="loadExpressionSet()">
                        <i class="fas fa-folder-open"></i> Load Expression Set
                    </button>
                    <button class="btn btn-sm btn-warning" onclick="manageSavedSets()">
                        <i class="fas fa-trash"></i> Manage Saved Sets
                    </button>
                    <button class="btn btn-sm btn-secondary" onclick="generateShareableLink()">
                        <i class="fas fa-share-alt"></i> Generate Share Link
                    </button>
                </div>
            </div>

            <div class="settings-panel">
                <h6><i class="fas fa-info-circle"></i> Help & Quick Guide</h6>
                <small>
                    <strong>📊 Plot Types:</strong><br>
                    • <strong>Cartesian:</strong> y = x^2, sin(x), 1/(1+e^(-x))<br>
                    • <strong>Parametric:</strong> cos(t), sin(t)<br>
                    • <strong>Polar:</strong> r = 2 + 2*cos(θ)<br>
                    • <strong>Inequality:</strong> y > x^2<br>
                    • <strong>Table:</strong> x,y pairs (one per line)<br>
                    • <strong>Regression:</strong> Fit line to data<br>
                    • <strong>Distribution:</strong> Normal, Chi², etc.<br>
                    <br>
                    <strong>🎯 Advanced Features:</strong><br>
                    • <strong>Parameters:</strong> Use a,b,c in expressions (auto-creates sliders)<br>
                    • <strong>Animation:</strong> Click play to animate parameters<br>
                    • <strong>Derivatives:</strong> Check "Show f'(x)" for any function<br>
                    • <strong>Trace Mode:</strong> Hover curves to see coordinates & slope<br>
                    • <strong>Intersections:</strong> Find where functions cross<br>
                    • <strong>Solve:</strong> Find roots (y=0) or any y-value<br>
                    • <strong>Text to Graph:</strong> Convert words to equations!<br>
                    <br>
                    <strong>🔢 Functions Available:</strong><br>
                    • Trig: sin, cos, tan, asin, acos, atan<br>
                    • Logs: log (ln), log10, exp<br>
                    • Powers: sqrt, cbrt, x^n<br>
                    • Other: abs, ceil, floor, round, sign<br>
                    • Constants: pi, e<br>
                    <br>
                    <strong>💡 Quick Tips:</strong><br>
                    • Use ^ for powers: x^2, e^x<br>
                    • Parentheses matter: 1/(1+x) not 1/1+x<br>
                    • Parameters auto-detect: a*sin(b*x+c)<br>
                    • Save & share your work!<br>
                </small>
            </div>

<%--            <div class="settings-panel">--%>
<%--                <h6><i class="fas fa-lightbulb"></i> Future Feature Ideas</h6>--%>
<%--                <small style="color: #666;">--%>
<%--                    <strong>Vote for next features:</strong><br>--%>
<%--                    □ 3D Surface Plots (z = f(x,y))<br>--%>
<%--                    □ Vector Fields & Gradients<br>--%>
<%--                    □ Differential Equations Solver<br>--%>
<%--                    □ Fourier Series Visualization<br>--%>
<%--                    □ Taylor/Maclaurin Series Approximation<br>--%>
<%--                    □ Contour Plots & Heat Maps<br>--%>
<%--                    □ Complex Number Plotting<br>--%>
<%--                    □ Data Import (CSV/JSON)<br>--%>
<%--                    □ Curve Fitting (polynomial, exponential)<br>--%>
<%--                    □ Zoom to Region<br>--%>
<%--                    □ Multiple Y-axes<br>--%>
<%--                    □ LaTeX Equation Editor<br>--%>
<%--                    <br>--%>
<%--                    <strong style="color: #28a745;">✓ Implemented:</strong><br>--%>
<%--                    <span style="color: #28a745;">✓ Numerical Integration (area under curve)<br>--%>
<%--                        ✓ Implicit Functions (x² + y² = 25)<br>--%>
<%--                        ✓ Piecewise Functions</span>--%>
<%--                </small>--%>
<%--            </div>--%>
        </div>

        <div class="col-md-9 graph-container">
            <div id="graph"></div>
        </div>
    </div>
</div>

<script data-cfasync="false" src="js/graphing-tool-engine.js"></script>
<div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- Visible FAQ section (must match JSON-LD below) -->
<section id="faq" class="mt-5">
  <h2 class="h5">Graphing Calculator: FAQ</h2>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What kinds of expressions can I plot?</h3>
    <p class="mb-0">Plot y=f(x) functions, parametric curves x(t), y(t), polar graphs r=f(θ), and simple implicit equations like x^2 + y^2 = 25.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">How do I add multiple functions and adjust the view?</h3>
    <p class="mb-0">Use the Add button to insert more expressions. Pan with drag, zoom with scroll or controls, and set axis ranges in Settings.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">Does it support calculus tools?</h3>
    <p class="mb-0">Yes. Enable derivative and area tools to view slopes and integrals, and use root/intersection finders for analysis.</p>
  </div></div>
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"What kinds of expressions can I plot?","acceptedAnswer":{"@type":"Answer","text":"Plot y=f(x) functions, parametric curves x(t), y(t), polar graphs r=f(θ), and simple implicit equations like x^2 + y^2 = 25."}},
    {"@type":"Question","name":"How do I add multiple functions and adjust the view?","acceptedAnswer":{"@type":"Answer","text":"Use the Add button to insert more expressions. Pan with drag, zoom with scroll or controls, and set axis ranges in Settings."}},
    {"@type":"Question","name":"Does it support calculus tools?","acceptedAnswer":{"@type":"Answer","text":"Yes. Enable derivative and area tools to view slopes and integrals, and use root/intersection finders for analysis."}}
  ]
}
</script>

<script>
// Dark mode + examples + error banner
(function(){
  function setDark(on){
    window.GC_DARK = !!on;
    document.body.classList.toggle('gc-dark', !!on);
    try{ localStorage.setItem('gc_dark', on? '1':'0'); }catch(_){ }
    // Replot to apply theme
    try{ if (typeof updateGraph === 'function') updateGraph(); }catch(_){ }
  }
  document.addEventListener('DOMContentLoaded', function(){
    // Missing libs banner
    if (typeof math === 'undefined' || typeof Plotly === 'undefined'){
      var alert = document.createElement('div');
      alert.className = 'alert alert-danger m-3';
      alert.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Required libraries failed to load. If you use script optimizers (e.g., Rocket Loader), disable them for this page.';
      document.body.insertBefore(alert, document.body.firstChild);
    }
    // Init dark from storage
    var pref = null; try { pref = localStorage.getItem('gc_dark'); } catch(_){ }
    var on = pref === '1';
    var toggle = document.getElementById('gcDarkToggle');
    if (toggle){ toggle.checked = on; toggle.addEventListener('change', function(){ setDark(this.checked); }); }
    setDark(on);
  });

  // Quick samples
  window.gcClearAll = function(){
    try{
      engine.expressions = [];
      var list = document.getElementById('expressions-list'); if (list) list.innerHTML='';
      window.expressionElements = {};
      if (typeof addExpression === 'function') addExpression();
      if (typeof updateGraph === 'function') updateGraph();
    }catch(_){ }
  };
  window.gcQuickSample = function(kind){
    gcClearAll();
    // Expect one default expression present
    var exprEls = document.querySelectorAll('[id^=expr-item-]');
    if (!exprEls.length) { if (typeof addExpression==='function') addExpression(); }
    var item = document.querySelector('[id^=expr-item-]');
    if (!item) return;
    var id = parseInt(item.id.replace('expr-item-',''));
    var typeSel = document.getElementById('type-'+id);
    switch(kind){
      case 'cartesian':
        if (typeSel){ typeSel.value='cartesian'; updateExpressionType(id); }
        var input = document.getElementById('expr-'+id); if (input){ input.value='sin(x)'; updateExpressionValue(id); }
        break;
      case 'parametric':
        if (typeSel){ typeSel.value='parametric'; updateExpressionType(id); }
        var input2 = document.getElementById('expr-'+id); if (input2){ input2.value='cos(t), sin(t)'; updateExpressionValue(id); }
        break;
      case 'polar':
        if (typeSel){ typeSel.value='polar'; updateExpressionType(id); }
        var input3 = document.getElementById('expr-'+id); if (input3){ input3.value='theta'; updateExpressionValue(id); }
        break;
      case 'implicit':
        if (typeSel){ typeSel.value='implicit'; updateExpressionType(id); }
        var input4 = document.getElementById('expr-'+id); if (input4){ input4.value='x^2 + y^2 = 9'; updateExpressionValue(id); }
        break;
    }
  };

  // Helper to set an expression by id
  function gcSetExpr(id, type, value, color){
    var typeSel = document.getElementById('type-'+id);
    if (typeSel){ typeSel.value = type; updateExpressionType(id); }
    var input = document.getElementById('expr-'+id);
    if (input){ input.value = value; updateExpressionValue(id); }
    if (color){ var c = document.getElementById('color-'+id); if (c){ c.value = color; updateExpressionColor(id); } }
  }

  // Helper to add a new expression and return its id
  function gcAdd(type, value, color){
    if (typeof addExpression==='function') addExpression();
    var items = document.querySelectorAll('[id^=expr-item-]');
    var last = items[items.length-1];
    if(!last) return null;
    var id = parseInt(last.id.replace('expr-item-',''));
    gcSetExpr(id, type, value, color);
    return id;
  }

  // Multi-expression presets
  window.gcQuickPreset = function(name){
    gcClearAll();
    // Modify the first default expression
    var firstEl = document.querySelector('[id^=expr-item-]');
    if (!firstEl) { if (typeof addExpression==='function') addExpression(); firstEl = document.querySelector('[id^=expr-item-]'); }
    var firstId = parseInt(firstEl.id.replace('expr-item-',''));
    // Defaults ranges
    var xMin = document.getElementById('xMin'), xMax = document.getElementById('xMax');
    var yMin = document.getElementById('yMin'), yMax = document.getElementById('yMax');
    function setRange(x0,x1,y0,y1){ if(xMin)xMin.value=x0; if(xMax)xMax.value=x1; if(yMin)yMin.value=y0; if(yMax)yMax.value=y1; }

    switch(name){
      case 'sin_cos':
        gcSetExpr(firstId, 'cartesian', 'sin(x)', '#2563eb');
        gcAdd('cartesian', 'cos(x)', '#f59e0b');
        setRange(-10,10,-2,2);
        break;
      case 'circle_line':
        gcSetExpr(firstId, 'implicit', 'x^2 + y^2 = 9', '#10b981');
        gcAdd('cartesian', 'y = x', '#ef4444');
        setRange(-5,5,-5,5);
        break;
      case 'polar_flowers':
        gcSetExpr(firstId, 'polar', '2*cos(5*theta)', '#a78bfa');
        gcAdd('polar', '2*sin(3*theta)', '#22d3ee');
        setRange(-3,3,-3,3);
        break;
      case 'band_inequality':
        gcSetExpr(firstId, 'inequality', 'y > x - 1', '#f43f5e');
        gcAdd('inequality', 'y < x + 1', '#22c55e');
        setRange(-10,10,-10,10);
        break;
      case 'data_vs_fit':
        // Data
        gcSetExpr(firstId, 'table', '1, 2\n2, 4.1\n3, 6.0\n4, 8.2\n5, 10.1', '#2563eb');
        // Fit
        gcAdd('cartesian', '2*x', '#f59e0b');
        setRange(0,6,0,12);
        break;
      case 'lissajous':
        // x = sin(3t), y = sin(4t)
        gcSetExpr(firstId, 'parametric', 'sin(3*t), sin(4*t)', '#10b981');
        setRange(-1.2, 1.2, -1.2, 1.2);
        break;
      case 'hypotrochoid':
        // (2*cos(t) + 5*cos((2/3)*t), 2*sin(t) - 5*sin((2/3)*t))
        gcSetExpr(firstId, 'parametric', '2*cos(t), 2*sin(t)', '#a78bfa');
        // Add second parametric as separate expression to overlay hypotrochoid path approximation
        gcAdd('parametric', '2*cos(t) + 5*cos((2/3)*t), 2*sin(t) - 5*sin((2/3)*t)', '#22d3ee');
        setRange(-8, 8, -8, 8);
        break;
      case 'logistic_exp':
        // Logistic curve vs Exponential growth
        gcSetExpr(firstId, 'cartesian', '1/(1+exp(-x))', '#22c55e');
        gcAdd('cartesian', '0.2*exp(0.3*x)', '#ef4444');
        setRange(-10, 10, 0, 5);
        break;
      case 'rose_curves':
        // r = cos(kθ) with k=3,4,5
        gcSetExpr(firstId, 'polar', '2*cos(3*theta)', '#ef4444');
        gcAdd('polar', '2*cos(4*theta)', '#22c55e');
        gcAdd('polar', '2*cos(5*theta)', '#2563eb');
        setRange(-3,3,-3,3);
        break;
      case 'piece_deriv_integral':
        // Base cartesian f(x) with derivative + shaded integral
        gcSetExpr(firstId, 'cartesian', 'x^2 - 2*x + 1', '#2563eb');
        // Turn on derivative
        (function(){
          var cb = document.getElementById('show-derivative-'+firstId);
          if (cb){ cb.checked = true; toggleDerivative(firstId); }
          var ci = document.getElementById('show-integration-'+firstId);
          if (ci){ ci.checked = true; toggleIntegration(firstId); }
          var a = document.getElementById('integration-a-'+firstId);
          var b = document.getElementById('integration-b-'+firstId);
          if (a && b){ a.value = 0; b.value = 2; updateIntegrationBounds(firstId); }
        })();
        // Add a piecewise function (defaults are prefilled: good demo)
        gcAdd('piecewise', '', '#10b981');
        setRange(-4,4,-2,6);
        break;
      case 'quad_regression':
        // Generate random quadratic data and fit a quadratic
        (function(){
          // Generate noisy data around y = 0.5x^2 - x + 2
          var xs = [], ys = [], pts = [];
          for (var x=-3; x<=3; x+=0.5){
            var noise = (Math.random()-0.5)*0.6;
            var y = 0.5*x*x - 1*x + 2 + noise;
            xs.push(x); ys.push(y);
            pts.push(x.toFixed(2) + ', ' + y.toFixed(2));
          }
          // Place data
          gcSetExpr(firstId, 'table', pts.join('\n'), '#2563eb');
          // Compute quadratic least squares fit using math.js
          function quadFit(xs, ys){
            var n = xs.length;
            var s1=0,s2=0,s3=0,s4=0, sx=0, sy=0, sxy=0, sx2y=0;
            for (var i=0;i<n;i++){
              var x=xs[i], y=ys[i];
              var x2=x*x; var x3=x2*x; var x4=x3*x;
              s1 += 1; sx += x; s2 += x2; s3 += x3; s4 += x4;
              sy += y; sxy += x*y; sx2y += x2*y;
            }
            var A = [ [s4, s3, s2], [s3, s2, sx], [s2, sx, s1] ];
            var b = [ sx2y, sxy, sy ];
            try{
              var sol = math.lusolve(A, b); // 3x1
              var a = sol[0][0], bb = sol[1][0], c = sol[2][0];
              return {a:a, b:bb, c:c};
            }catch(e){ return {a:0.5, b:-1, c:2}; }
          }
          var coeffs = quadFit(xs, ys);
          var expr = coeffs.a.toFixed(3)+'*x^2 + '+coeffs.b.toFixed(3)+'*x + '+coeffs.c.toFixed(3);
          gcAdd('cartesian', expr, '#f59e0b');
          setRange(-3.5,3.5, -1, 7);
        })();
        break;
      case 'fourier_square':
        // Partial sums for square wave approx: (4/pi) * sum_{n odd<=N} sin(n x)/n
        var pi = Math.PI;
        gcSetExpr(firstId, 'cartesian', '(4/'+pi.toFixed(3)+')*(sin(x))', '#ef4444');
        gcAdd('cartesian', '(4/'+pi.toFixed(3)+')*(sin(x) + (1/3)*sin(3*x))', '#22c55e');
        gcAdd('cartesian', '(4/'+pi.toFixed(3)+')*(sin(x) + (1/3)*sin(3*x) + (1/5)*sin(5*x))', '#2563eb');
        gcAdd('cartesian', '(4/'+pi.toFixed(3)+')*(sin(x) + (1/3)*sin(3*x) + (1/5)*sin(5*x) + (1/7)*sin(7*x))', '#a78bfa');
        setRange(-10,10, -2, 2);
        break;
      case 'spirals':
        // Archimedean: r = a + b*theta ; Logarithmic: r = a*exp(b*theta)
        gcSetExpr(firstId, 'polar', '0.1*theta', '#2563eb');
        gcAdd('polar', '0.1*exp(0.15*theta)', '#f59e0b');
        setRange(-6,6,-6,6);
        break;
      case 'distributions_overlay':
        // Overlay normal(0,1) and Student's t (v=3) pdfs as cartesian
        // normal pdf: (1/sqrt(2*pi))*exp(-x^2/2)
        // t pdf (v=3): gamma((v+1)/2)/(sqrt(v*pi)*gamma(v/2)) * (1 + x^2/v)^(-(v+1)/2)
        var norm = '(1/sqrt(2*pi))*exp(-x^2/2)';
        var t3 = '(gamma((3+1)/2)/(sqrt(3*pi)*gamma(3/2)))* (1 + x^2/3)^(- (3+1)/2)';
        gcSetExpr(firstId, 'cartesian', norm, '#2563eb');
        gcAdd('cartesian', t3, '#ef4444');
        setRange(-5,5, 0, 0.5);
        break;
      case 'deltoid':
        // Deltoid epicycloid
        gcSetExpr(firstId, 'parametric', '3*cos(t) - cos(3*t), 3*sin(t) - sin(3*t)', '#22c55e');
        setRange(-4,4,-4,4);
        break;
      case 'lemniscate':
        // Lemniscate of Bernoulli: (x^2 + y^2)^2 = 2a^2(x^2 - y^2), choose a=2 -> 8*(x^2 - y^2)
        gcSetExpr(firstId, 'implicit', '(x^2 + y^2)^2 = 8*(x^2 - y^2)', '#a78bfa');
        setRange(-4,4,-4,4);
        break;
      case 'butterfly':
        // Butterfly curve: r = e^{sin θ} − 2 cos 4θ + sin^5(θ/12)
        gcSetExpr(firstId, 'polar', 'exp(sin(theta)) - 2*cos(4*theta) + (sin(theta/12))^5', '#f43f5e');
        setRange(-4,4,-4,4);
        break;

      // ============ CREATIVE CURVES ============
      case 'heart':
        // Heart curve parametric: x = 16sin³(t), y = 13cos(t) - 5cos(2t) - 2cos(3t) - cos(4t)
        gcSetExpr(firstId, 'parametric', '16*(sin(t))^3, 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)', '#e11d48');
        setRange(-20, 20, -20, 18);
        break;
      case 'spirograph':
        // Epitrochoid: x = (R+r)cos(t) - d*cos((R+r)/r * t), y = (R+r)sin(t) - d*sin((R+r)/r * t)
        // Using R=5, r=3, d=5 for nice pattern
        gcSetExpr(firstId, 'parametric', '(5+3)*cos(t) - 5*cos((5+3)/3*t), (5+3)*sin(t) - 5*sin((5+3)/3*t)', '#8b5cf6');
        gcAdd('parametric', '(7+2)*cos(t) - 3*cos((7+2)/2*t), (7+2)*sin(t) - 3*sin((7+2)/2*t)', '#06b6d4');
        setRange(-15, 15, -15, 15);
        break;
      case 'astroid':
        // Astroid (hypocycloid with 4 cusps): x = a*cos³(t), y = a*sin³(t)
        gcSetExpr(firstId, 'parametric', '4*(cos(t))^3, 4*(sin(t))^3', '#f59e0b');
        // Also show circumscribed circle for reference
        gcAdd('parametric', '4*cos(t), 4*sin(t)', '#94a3b8');
        setRange(-5, 5, -5, 5);
        break;
      case 'cardioid':
        // Cardioid in polar: r = a(1 + cos(θ))
        gcSetExpr(firstId, 'polar', '2*(1 + cos(theta))', '#ec4899');
        // Add inner cardioid for comparison
        gcAdd('polar', '1*(1 - cos(theta))', '#f472b6');
        setRange(-1, 5, -3, 3);
        break;
      case 'golden_spiral':
        // Golden/Fibonacci spiral approximation: r = a * φ^(2θ/π), φ ≈ 1.618
        var phi = 1.618033988749895;
        gcSetExpr(firstId, 'polar', '0.3 * ' + phi.toFixed(6) + '^(2*theta/pi)', '#d97706');
        // Add golden rectangles as reference (approximate with lines)
        gcAdd('cartesian', '0', '#94a3b8');
        setRange(-8, 8, -8, 8);
        break;
      case 'cycloid':
        // Cycloid: x = r(t - sin(t)), y = r(1 - cos(t)) - path of point on rolling circle
        gcSetExpr(firstId, 'parametric', '2*(t - sin(t)), 2*(1 - cos(t))', '#3b82f6');
        // Curtate cycloid (point inside the circle)
        gcAdd('parametric', '2*t - 1*sin(t), 2 - 1*cos(t)', '#10b981');
        // Prolate cycloid (point outside the circle)
        gcAdd('parametric', '2*t - 3*sin(t), 2 - 3*cos(t)', '#f43f5e');
        setRange(-2, 15, -2, 8);
        break;
      case 'nephroid':
        // Nephroid (2-cusped epicycloid): x = 3cos(t) - cos(3t), y = 3sin(t) - sin(3t)
        // This is the caustic curve you see in a coffee cup!
        gcSetExpr(firstId, 'parametric', '3*cos(t) - cos(3*t), 3*sin(t) - sin(3*t)', '#7c3aed');
        // Add outer circle (coffee cup rim)
        gcAdd('parametric', '4*cos(t), 4*sin(t)', '#94a3b8');
        setRange(-5, 5, -5, 5);
        break;
      case 'limacon':
        // Limaçon family: r = a + b*cos(θ)
        // Cardioid (a=b), Limaçon with inner loop (a<b), Dimpled (a>b but a<2b), Convex (a≥2b)
        gcSetExpr(firstId, 'polar', '1 + 2*cos(theta)', '#ef4444');  // Inner loop (a<b)
        gcAdd('polar', '2 + 2*cos(theta)', '#22c55e');  // Cardioid (a=b)
        gcAdd('polar', '3 + 2*cos(theta)', '#3b82f6');  // Dimpled (a>b)
        gcAdd('polar', '4 + 2*cos(theta)', '#a855f7');  // Convex (a≥2b)
        setRange(-5, 7, -5, 5);
        break;

      // ============ PHYSICS & SCIENCE ============
      case 'damped_oscillation':
        // Damped harmonic motion: y = A*e^(-γt)*cos(ωt)
        gcSetExpr(firstId, 'cartesian', '5*exp(-0.15*x)*cos(2*x)', '#3b82f6');
        // Show envelope curves
        gcAdd('cartesian', '5*exp(-0.15*x)', '#94a3b8');
        gcAdd('cartesian', '-5*exp(-0.15*x)', '#94a3b8');
        // Critically damped for comparison
        gcAdd('cartesian', '5*(1 + 0.5*x)*exp(-0.5*x)', '#f59e0b');
        setRange(-1, 25, -6, 6);
        break;
      case 'catenary':
        // Catenary: y = a*cosh(x/a) - the shape of a hanging chain
        gcSetExpr(firstId, 'cartesian', '2*cosh(x/2)', '#0ea5e9');
        // Compare with parabola (often confused)
        gcAdd('cartesian', '0.25*x^2 + 2', '#f43f5e');
        setRange(-5, 5, 0, 8);
        break;
      case 'wave_interference':
        // Two waves interfering: constructive and destructive interference
        gcSetExpr(firstId, 'cartesian', 'sin(x)', '#3b82f6');  // Wave 1
        gcAdd('cartesian', 'sin(x + pi/4)', '#ef4444');  // Wave 2 (phase shifted)
        gcAdd('cartesian', 'sin(x) + sin(x + pi/4)', '#22c55e');  // Sum (interference)
        // Beating pattern: two close frequencies
        gcAdd('cartesian', 'sin(5*x) + sin(5.5*x)', '#a855f7');
        setRange(-10, 10, -3, 3);
        break;
      case 'projectile':
        // Projectile motion: y = x*tan(θ) - (g*x²)/(2*v₀²*cos²(θ))
        // Multiple launch angles showing optimal 45°
        gcSetExpr(firstId, 'cartesian', 'x*tan(pi/6) - (9.8*x^2)/(2*20^2*(cos(pi/6))^2)', '#ef4444');  // 30°
        gcAdd('cartesian', 'x*tan(pi/4) - (9.8*x^2)/(2*20^2*(cos(pi/4))^2)', '#22c55e');  // 45° (max range)
        gcAdd('cartesian', 'x*tan(pi/3) - (9.8*x^2)/(2*20^2*(cos(pi/3))^2)', '#3b82f6');  // 60°
        gcAdd('cartesian', 'x*tan(pi/4.5) - (9.8*x^2)/(2*20^2*(cos(pi/4.5))^2)', '#f59e0b');  // 40°
        setRange(-5, 50, -5, 25);
        break;
      case 'pendulum_phase':
        // Simple pendulum phase space: θ vs dθ/dt
        // For small angles: dθ/dt = ±ω*sqrt(θ₀² - θ²) (ellipse)
        // Plot multiple energy levels as ellipses
        gcSetExpr(firstId, 'parametric', '0.5*cos(t), 0.5*sin(t)', '#3b82f6');
        gcAdd('parametric', '1*cos(t), 1*sin(t)', '#22c55e');
        gcAdd('parametric', '1.5*cos(t), 1.5*sin(t)', '#f59e0b');
        gcAdd('parametric', '2*cos(t), 2*sin(t)', '#ef4444');
        // Add separatrix (critical energy level)
        gcAdd('cartesian', 'sqrt(4 - 2*(1 - cos(x)))', '#a855f7');
        gcAdd('cartesian', '-sqrt(4 - 2*(1 - cos(x)))', '#a855f7');
        setRange(-4, 4, -3, 3);
        break;

      // ============ CLASSIC & HISTORICAL ============
      case 'witch_agnesi':
        // Witch of Agnesi: y = 8a³/(x² + 4a²), using a=1
        gcSetExpr(firstId, 'cartesian', '8/(x^2 + 4)', '#7c3aed');
        // Show the generating circle
        gcAdd('parametric', '2*cos(t), 1 + sin(t)', '#94a3b8');
        setRange(-8, 8, -1, 4);
        break;
      case 'folium':
        // Folium of Descartes: x³ + y³ = 3axy (implicit)
        gcSetExpr(firstId, 'implicit', 'x^3 + y^3 = 3*2*x*y', '#10b981');
        // Add the asymptote: x + y + a = 0
        gcAdd('cartesian', '-x - 2', '#94a3b8');
        setRange(-4, 6, -4, 6);
        break;
      case 'cissoid':
        // Cissoid of Diocles: y² = x³/(2a - x) or parametric
        gcSetExpr(firstId, 'parametric', '2*(sin(t))^2, 2*(sin(t))^3/cos(t)', '#0891b2');
        // Add the generating circle
        gcAdd('parametric', '1 + cos(t), sin(t)', '#94a3b8');
        // Asymptote
        gcAdd('cartesian', 'x = 2', '#f43f5e');
        setRange(-1, 4, -4, 4);
        break;
      case 'tractrix':
        // Tractrix: x = sech⁻¹(y/a) - sqrt(a² - y²), parametric form is easier
        // x = a*(t - tanh(t)), y = a*sech(t)
        gcSetExpr(firstId, 'parametric', '2*(t - tanh(t)), 2/cosh(t)', '#dc2626');
        // Add the generating catenary for reference
        gcAdd('cartesian', '2*cosh((x-4)/2)', '#94a3b8');
        setRange(-2, 8, -1, 5);
        break;

      default:
        gcQuickSample('cartesian');
    }
    if (typeof updateGraph==='function') updateGraph();
  };
})();
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Graphing Calculator","item":"https://8gwifi.org/graphing-calculator.jsp"}
  ]
}
</script>
</div>

<%@ include file="body-close.jsp"%>
