<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- SEO Meta Tags -->
    <title>Free Online Graphing Calculator | Plot Functions, Equations & Graphs</title>
    <meta name="description" content="Free advanced graphing calculator online. Plot functions, parametric equations, polar curves, implicit functions, piecewise functions, statistical distributions, and more. Features derivatives, integrals, equation solver, and animation. No download required - works in browser like Desmos.">
    <meta name="keywords" content="graphing calculator, online graphing calculator, free graphing calculator, plot functions online, graph equations, math calculator, desmos alternative, equation plotter, function grapher, calculus calculator, derivative calculator, integral calculator, polar graph, parametric equations, implicit functions, piecewise functions, statistical graphs">
    <meta name="author" content="Advanced Math Tools">
    <meta name="robots" content="index, follow">
    <link rel="canonical" href="https://8gwifi.org/graphing-calculator.jsp">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/graphing-calculator.jsp">
    <meta property="og:title" content="Free Online Graphing Calculator - Advanced Math Plotter">
    <meta property="og:description" content="Plot any mathematical function online for free. Supports derivatives, integrals, parametric, polar, implicit functions and more. Best Desmos alternative.">
    <meta property="og:image" content="https://yourdomain.com/images/graphing-calculator-preview.png">

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="https://8gwifi.org/graphing-calculator.jsp">
    <meta property="twitter:title" content="Free Online Graphing Calculator - Advanced Math Plotter">
    <meta property="twitter:description" content="Plot any mathematical function online for free. Supports derivatives, integrals, parametric, polar, implicit functions and more.">
    <meta property="twitter:image" content="https://yourdomain.com/images/graphing-calculator-preview.png">

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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mathjs/12.4.1/math.min.js"></script>

    <!-- Plotly.js for graphing -->
    <script src="https://cdn.plot.ly/plotly-2.27.0.min.js"></script>

    <!-- Bootstrap for UI -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- KaTeX for beautiful math rendering -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js"></script>

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
            border: none;
            background: transparent;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            padding: 5px;
        }

        .expression-input:focus {
            outline: none;
            background: white;
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
    </style>
    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
<div class="header">
    <div class="container-fluid">
        <h3><i class="fas fa-chart-line"></i> Advanced Graphing Calculator</h3>
        <p class="mb-0" style="font-size: 14px;">Graphing tool with multiple plot types</p>
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

<script src="js/graphing-tool-engine.js"></script>
<div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>

<%@ include file="body-close.jsp"%>
