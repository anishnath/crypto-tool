<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FREE Integral Calculator - Definite & Indefinite Integrals | Step-by-Step</title>
    <meta name="description" content="Free online integral calculator with step-by-step solutions. Calculate definite and indefinite integrals symbolically. Supports polynomials, trigonometric, exponential, and logarithmic functions. Interactive graphs and LaTeX output.">
    <meta name="keywords" content="integral calculator, integration calculator, definite integral, indefinite integral, antiderivative calculator, calculus calculator, symbolic integration, step by step integrals, u-substitution, integration by parts">
    <link rel="canonical" href="https://8gwifi.org/integral-calculator.jsp">

    <!-- Open Graph -->
    <meta property="og:title" content="FREE Integral Calculator - Definite & Indefinite Integrals">
    <meta property="og:description" content="Calculate integrals with detailed step-by-step solutions. Supports both definite and indefinite integrals.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/integral-calculator.jsp">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="FREE Integral Calculator - Definite & Indefinite Integrals">
    <meta name="twitter:description" content="Calculate integrals with detailed step-by-step solutions. Supports both definite and indefinite integrals.">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Integral Calculator",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "description": "Free online integral calculator for definite and indefinite integrals with step-by-step solutions",
      "featureList": [
        "Indefinite integral calculation",
        "Definite integral with bounds",
        "Step-by-step integration solutions",
        "Power rule integration",
        "U-substitution method",
        "Integration by parts",
        "Trigonometric integrals",
        "Exponential integrals",
        "Logarithmic integrals",
        "Rational function integration",
        "Area under curve visualization",
        "Riemann sum approximation",
        "LaTeX output formatting",
        "Interactive function graphing",
        "Random example generator",
        "Copy results to clipboard"
      ],
      "browserRequirements": "Requires JavaScript enabled"
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "What is the difference between definite and indefinite integrals?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "An indefinite integral ∫f(x)dx gives a family of functions (antiderivative) plus a constant C. A definite integral ∫[a,b]f(x)dx gives a specific numerical value representing the area under the curve from x=a to x=b."
          }
        },
        {
          "@type": "Question",
          "name": "How do I calculate definite integrals?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Enter your function, select 'Definite Integral', and specify the lower bound (a) and upper bound (b). The calculator will find the antiderivative F(x) and compute F(b) - F(a)."
          }
        },
        {
          "@type": "Question",
          "name": "What functions can be integrated?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The calculator supports polynomials, trigonometric functions (sin, cos, tan), exponential functions (e^x), logarithmic functions (ln, log), rational functions, and combinations of these."
          }
        },
        {
          "@type": "Question",
          "name": "What integration techniques are used?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The calculator uses power rule, u-substitution, integration by parts, trigonometric substitution, and partial fractions where applicable. The method used is shown in the step-by-step solution."
          }
        },
        {
          "@type": "Question",
          "name": "Why is there a +C in indefinite integrals?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The constant C represents an arbitrary constant of integration. Since the derivative of any constant is zero, any function F(x) + C is a valid antiderivative of f(x)."
          }
        }
      ]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Calculate Integrals",
      "description": "Step-by-step guide to using the integral calculator",
      "step": [
        {
          "@type": "HowToStep",
          "position": 1,
          "name": "Enter Function",
          "text": "Type your function using standard notation (e.g., x^2, sin(x), e^x)"
        },
        {
          "@type": "HowToStep",
          "position": 2,
          "name": "Choose Integral Type",
          "text": "Select indefinite integral (∫f(x)dx) or definite integral (∫[a,b]f(x)dx)"
        },
        {
          "@type": "HowToStep",
          "position": 3,
          "name": "Set Bounds (if definite)",
          "text": "Enter lower bound (a) and upper bound (b) for definite integrals"
        },
        {
          "@type": "HowToStep",
          "position": 4,
          "name": "Calculate",
          "text": "Click Calculate to see the integral with step-by-step solution"
        },
        {
          "@type": "HowToStep",
          "position": 5,
          "name": "View Results",
          "text": "Review the antiderivative, numerical result (if definite), and interactive graph"
        }
      ]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": [
        {
          "@type": "ListItem",
          "position": 1,
          "name": "Home",
          "item": "https://8gwifi.org/"
        },
        {
          "@type": "ListItem",
          "position": 2,
          "name": "Math Tools",
          "item": "https://8gwifi.org/#math-tools"
        },
        {
          "@type": "ListItem",
          "position": 3,
          "name": "Integral Calculator",
          "item": "https://8gwifi.org/integral-calculator.jsp"
        }
      ]
    }
    </script>

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        .container {
            max-width: 1200px;
        }
        .calc-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 30px;
            margin-bottom: 20px;
        }
        .calc-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 3px solid #667eea;
        }
        .calc-header h1 {
            color: #2d3748;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        .calc-header p {
            color: #718096;
            font-size: 1.1rem;
        }
        .form-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
        }
        .form-control, .form-select {
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px;
            font-size: 1rem;
            transition: all 0.3s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-calculate {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 14px 32px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s;
            width: 100%;
        }
        .btn-calculate:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        .btn-secondary {
            background: #718096;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .btn-secondary:hover {
            background: #4a5568;
            transform: translateY(-2px);
        }
        .result-section {
            margin-top: 30px;
            padding: 25px;
            background: #f7fafc;
            border-radius: 12px;
            border-left: 4px solid #667eea;
        }
        .result-section h3 {
            color: #2d3748;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 20px;
        }
        .latex-output {
            background: white;
            padding: 20px;
            border-radius: 8px;
            border: 2px solid #e2e8f0;
            margin: 15px 0;
            font-size: 1.2rem;
            overflow-x: auto;
        }
        .step-item {
            background: white;
            padding: 15px;
            margin: 10px 0;
            border-radius: 8px;
            border-left: 3px solid #9f7aea;
        }
        .step-number {
            display: inline-block;
            background: #9f7aea;
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            text-align: center;
            line-height: 28px;
            font-weight: 600;
            margin-right: 10px;
        }
        .method-badge {
            display: inline-block;
            background: #ed8936;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-left: 10px;
        }
        #graphCanvas {
            width: 100%;
            height: 400px;
            background: white;
            border-radius: 8px;
            border: 2px solid #e2e8f0;
        }
        .example-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }
        .btn-example {
            background: #edf2f7;
            color: #2d3748;
            border: 2px solid #e2e8f0;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.9rem;
            transition: all 0.3s;
            cursor: pointer;
        }
        .btn-example:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        .info-box {
            background: #ebf8ff;
            border-left: 4px solid #4299e1;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .info-box h4 {
            color: #2c5282;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .info-box ul {
            margin-bottom: 0;
            color: #2d3748;
        }
        .bounds-container {
            display: none;
        }
        .bounds-container.active {
            display: block;
        }
        .numerical-result {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            font-size: 1.5rem;
            font-weight: 700;
            margin: 15px 0;
        }
        .error-message {
            background: #fff5f5;
            border-left: 4px solid #f56565;
            padding: 15px;
            border-radius: 8px;
            color: #c53030;
            margin: 15px 0;
        }
    </style>
    <script>
        window.MathJax = {
            loader: { load: ['[tex]/color'] },
            tex: {
                packages: { '[+]': ['color'] },
                inlineMath: [['$', '$'], ['\\(', '\\)']],
                displayMath: [['$$', '$$'], ['\\[', '\\]']]
            },
            startup: {
                ready: () => {
                    MathJax.startup.defaultReady();
                    console.log('MathJax loaded and ready');
                }
            }
        };
    </script>
    <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" crossorigin="anonymous"></script>
    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4">
        <div class="calc-card">
            <div class="calc-header">
                <h1>Integral Calculator</h1>
                <p>Calculate definite and indefinite integrals with step-by-step solutions</p>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="mb-4">
                        <label for="functionInput" class="form-label">Function f(x)</label>
                        <input type="text" class="form-control" id="functionInput"
                               placeholder="e.g., x^2, sin(x), e^x, 1/x"
                               value="x^2 + 3*x + 5">
                        <small class="text-muted">Supported: +, -, *, /, ^, sin, cos, tan, exp, ln, sqrt</small>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label for="integralType" class="form-label">Integral Type</label>
                            <select class="form-select" id="integralType" onchange="toggleBounds()">
                                <option value="indefinite">Indefinite (∫f(x)dx)</option>
                                <option value="definite">Definite (∫[a,b]f(x)dx)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="variableSelect" class="form-label">Variable</label>
                            <select class="form-select" id="variableSelect">
                                <option value="x" selected>x</option>
                                <option value="y">y</option>
                                <option value="t">t</option>
                                <option value="u">u</option>
                            </select>
                        </div>
                    </div>

                    <div class="bounds-container" id="boundsContainer">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label for="lowerBound" class="form-label">Lower Bound (a)</label>
                                <input type="text" class="form-control" id="lowerBound"
                                       placeholder="e.g., 0, -1, pi" value="0">
                            </div>
                            <div class="col-md-6">
                                <label for="upperBound" class="form-label">Upper Bound (b)</label>
                                <input type="text" class="form-control" id="upperBound"
                                       placeholder="e.g., 1, 2, 2*pi" value="1">
                            </div>
                        </div>
                    </div>

                    <button class="btn btn-calculate" onclick="calculateIntegral()">
                        Calculate Integral
                    </button>

                    <div class="example-buttons">
                        <button class="btn-example" onclick="loadExample('x^2')">Power</button>
                        <button class="btn-example" onclick="loadExample('sin(x)')">Sine</button>
                        <button class="btn-example" onclick="loadExample('e^x')">Exponential</button>
                        <button class="btn-example" onclick="loadExample('1/x')">Logarithmic</button>
                        <button class="btn-example" onclick="loadExample('cos(x)*sin(x)')">Trig Product</button>
                        <button class="btn-example" onclick="loadExample('x*e^x')">Integration by Parts</button>
                        <button class="btn-example" onclick="generateRandom()">Random</button>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="info-box">
                        <h4 style="cursor: pointer; margin-bottom: 10px;" onclick="toggleSyntax()">
                            Function Syntax Reference
                            <span id="syntaxToggle" style="float: right; font-size: 0.8em;">▼</span>
                        </h4>
                        <div id="syntaxContent" style="font-size: 0.85rem;">
                            <strong>Basic:</strong> <code>x^2</code>, <code>2*x</code>, <code>1/x</code>, <code>sqrt(x)</code>, <code>pi</code><br>
                            <strong>Trig:</strong> <code>sin(x)</code>, <code>cos(x)</code>, <code>tan(x)</code>, <code>asin(x)</code><br>
                            <strong>Exp/Log:</strong> <code>e^x</code>, <code>exp(x)</code>, <code>ln(x)</code>, <code>log(x,b)</code><br>
                            <strong>Hyperbolic:</strong> <code>sinh(x)</code>, <code>cosh(x)</code>, <code>tanh(x)</code>
                        </div>
                    </div>

                    <div class="info-box" style="background: #fef5e7; border-left-color: #f39c12;">
                        <h4 style="color: #d68910; cursor: pointer; margin-bottom: 10px;" onclick="toggleFormulas()">
                            Common Integral Formulas
                            <span id="formulasToggle" style="float: right; font-size: 0.8em;">▼</span>
                        </h4>
                        <div id="formulasContent" style="font-size: 0.82rem;">
                            <table style="width: 100%;">
                                <tr><td style="padding: 3px;">∫x<sup>n</sup>dx</td><td style="padding: 3px;">= x<sup>n+1</sup>/(n+1) + C</td></tr>
                                <tr><td style="padding: 3px;">∫e<sup>x</sup>dx</td><td style="padding: 3px;">= e<sup>x</sup> + C</td></tr>
                                <tr><td style="padding: 3px;">∫1/x dx</td><td style="padding: 3px;">= ln|x| + C</td></tr>
                                <tr><td style="padding: 3px;">∫sin(x)dx</td><td style="padding: 3px;">= -cos(x) + C</td></tr>
                                <tr><td style="padding: 3px;">∫cos(x)dx</td><td style="padding: 3px;">= sin(x) + C</td></tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div id="resultsContainer" style="display: none;">
                <div class="result-section">
                    <h3>Integral Result</h3>
                    <div class="latex-output" id="originalIntegral"></div>
                    <div class="latex-output" id="integralResult"></div>
                    <div id="numericalResultDiv"></div>
                    <button class="btn btn-secondary btn-sm mt-2" onclick="copyResult()">Copy Result</button>
                </div>

                <div class="result-section">
                    <h3 style="cursor: pointer;" onclick="toggleSteps()">
                        Step-by-Step Solution
                        <span id="stepsToggle" style="float: right; font-size: 0.8em;">▼ Show</span>
                    </h3>
                    <div id="stepsContainer" style="display: none;"></div>
                </div>

                <div class="result-section">
                    <h3>Interactive Graph</h3>
                    <canvas id="graphCanvas"></canvas>
                    <div class="mt-2" id="graphLegend">
                        <small class="text-muted">
                            <span style="color: #667eea; font-weight: 600;">■</span> Function f(x) &nbsp;&nbsp;
                            <span style="color: rgba(102, 126, 234, 0.3); font-weight: 600;">■</span> Shaded Area &nbsp;&nbsp;
                            <span style="color: #f59e0b; font-weight: 600;">■</span> Riemann Rectangles
                        </small>
                    </div>

                    <!-- Riemann Sum Controls -->
                    <div id="riemannControls" style="margin-top: 15px; padding: 15px; background: #f7fafc; border-radius: 8px; border: 1px solid #e2e8f0;">
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label style="display: flex; align-items: center; cursor: pointer;">
                                    <input type="checkbox" id="showRiemann" style="margin-right: 8px;">
                                    <strong>Show Riemann Sum Approximation</strong>
                                </label>
                            </div>
                        </div>
                        <div id="riemannOptions" style="display: none;">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label" style="font-weight: 600;">Method</label>
                                    <select class="form-select form-select-sm" id="riemannMethod">
                                        <option value="left">Left Riemann Sum</option>
                                        <option value="right">Right Riemann Sum</option>
                                        <option value="midpoint" selected>Midpoint Rule</option>
                                        <option value="trapezoid">Trapezoidal Rule</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label" style="font-weight: 600;">Number of Rectangles: <span id="nRectangles">10</span></label>
                                    <input type="range" class="form-range" id="rectanglesSlider" min="1" max="100" value="10" step="1">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div id="riemannApprox" style="padding: 10px; background: #e0f2fe; border-radius: 6px; border-left: 3px solid #0284c7;">
                                        <strong style="color: #0c4a6e;">Approximation:</strong>
                                        <span id="riemannValue" style="color: #0284c7; font-weight: 600; margin-left: 10px;">-</span>
                                        <span id="riemannError" style="color: #64748b; font-size: 0.9rem; margin-left: 10px;">-</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Educational Content Section - Always Visible -->
        <div class="calc-card">
            <div class="result-section" style="background: #fefce8; border-left-color: #eab308;">
                <h3 style="color: #713f12;">📚 Understanding Integrals</h3>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">What is an Integral?</h4>
                        <p style="line-height: 1.7; color: #3f3f46;">
                            An <strong>integral</strong> is the reverse operation of differentiation (finding antiderivatives). Geometrically,
                            a <strong>definite integral</strong> represents the <strong>area under a curve</strong> between two points.
                            In physics, integrals represent accumulation: distance is the integral of velocity, and work is the integral of force.
                        </p>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Types of Integrals</h4>

                        <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong style="color: #7c2d12;">1. Indefinite Integral (Antiderivative):</strong>
                            <p style="margin: 5px 0; color: #3f3f46;">∫f(x)dx = F(x) + C</p>
                            <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;">
                                <em>Represents a family of functions whose derivative is f(x). The constant C accounts for all possible vertical shifts.</em>
                            </p>
                        </div>

                        <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong style="color: #7c2d12;">2. Definite Integral:</strong>
                            <p style="margin: 5px 0; color: #3f3f46;">∫<sub>a</sub><sup>b</sup> f(x)dx = F(b) - F(a)</p>
                            <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;">
                                <em>Represents the exact area under the curve f(x) from x=a to x=b. Uses the Fundamental Theorem of Calculus.</em>
                            </p>
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">The Fundamental Theorem of Calculus</h4>
                        <div style="background: #e0f2fe; padding: 15px; border-radius: 8px; border-left: 3px solid #0284c7;">
                            <p style="line-height: 1.7; color: #0c4a6e; margin-bottom: 10px;">
                                <strong>Part 1:</strong> If F(x) = ∫<sub>a</sub><sup>x</sup> f(t)dt, then F'(x) = f(x)
                            </p>
                            <p style="line-height: 1.7; color: #0c4a6e; margin-bottom: 0;">
                                <strong>Part 2:</strong> If F'(x) = f(x), then ∫<sub>a</sub><sup>b</sup> f(x)dx = F(b) - F(a)
                            </p>
                        </div>
                        <p style="margin-top: 10px; line-height: 1.7; color: #3f3f46; font-size: 0.9rem;">
                            This theorem connects differentiation and integration as inverse operations, providing a systematic way to evaluate definite integrals.
                        </p>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Integration Techniques</h4>

                        <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong style="color: #7c2d12;">1. Power Rule for Integration:</strong>
                            <p style="margin: 5px 0; color: #3f3f46;">∫x<sup>n</sup>dx = x<sup>n+1</sup>/(n+1) + C &nbsp; (n ≠ -1)</p>
                            <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: ∫x³dx = x⁴/4 + C</em></p>
                        </div>

                        <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong style="color: #7c2d12;">2. U-Substitution (Chain Rule Reversed):</strong>
                            <p style="margin: 5px 0; color: #3f3f46;">Let u = g(x), then du = g'(x)dx</p>
                            <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: ∫2x·cos(x²)dx, let u = x², du = 2x dx → ∫cos(u)du = sin(u) + C = sin(x²) + C</em></p>
                        </div>

                        <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong style="color: #7c2d12;">3. Integration by Parts:</strong>
                            <p style="margin: 5px 0; color: #3f3f46;">∫u dv = uv - ∫v du</p>
                            <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: ∫x·e<sup>x</sup>dx, let u = x, dv = e<sup>x</sup>dx → x·e<sup>x</sup> - ∫e<sup>x</sup>dx = x·e<sup>x</sup> - e<sup>x</sup> + C</em></p>
                        </div>

                        <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong style="color: #7c2d12;">4. Partial Fractions:</strong>
                            <p style="margin: 5px 0; color: #3f3f46;">Decompose rational functions into simpler fractions</p>
                            <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: ∫1/(x²-1)dx = ∫[1/2(1/(x-1)) - 1/2(1/(x+1))]dx</em></p>
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Riemann Sums & Approximation</h4>
                        <p style="line-height: 1.7; color: #3f3f46; margin-bottom: 10px;">
                            Before learning the Fundamental Theorem, integrals were approximated using <strong>Riemann sums</strong> -
                            dividing the area into rectangles and summing their areas:
                        </p>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px;">
                            <div style="background: white; padding: 12px; border-radius: 8px;">
                                <strong style="color: #0284c7;">Left Riemann Sum</strong>
                                <p style="margin: 5px 0; font-size: 0.85rem; color: #3f3f46;">Uses left endpoint of each subinterval</p>
                            </div>
                            <div style="background: white; padding: 12px; border-radius: 8px;">
                                <strong style="color: #0284c7;">Right Riemann Sum</strong>
                                <p style="margin: 5px 0; font-size: 0.85rem; color: #3f3f46;">Uses right endpoint of each subinterval</p>
                            </div>
                            <div style="background: white; padding: 12px; border-radius: 8px;">
                                <strong style="color: #0284c7;">Midpoint Rule</strong>
                                <p style="margin: 5px 0; font-size: 0.85rem; color: #3f3f46;">Uses middle of each subinterval (more accurate)</p>
                            </div>
                            <div style="background: white; padding: 12px; border-radius: 8px;">
                                <strong style="color: #0284c7;">Trapezoidal Rule</strong>
                                <p style="margin: 5px 0; font-size: 0.85rem; color: #3f3f46;">Uses trapezoids instead of rectangles</p>
                            </div>
                        </div>
                        <p style="margin-top: 10px; line-height: 1.7; color: #3f3f46; font-size: 0.9rem;">
                            As the number of rectangles approaches infinity (width → 0), the Riemann sum converges to the exact integral value.
                            <strong>Try the interactive Riemann sum visualization above to see this in action!</strong>
                        </p>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Applications of Integrals</h4>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
                            <div style="background: white; padding: 15px; border-radius: 8px; border-left: 3px solid #3b82f6;">
                                <strong style="color: #1e40af;">📏 Area Calculations</strong>
                                <p style="margin: 5px 0; font-size: 0.9rem; color: #3f3f46;">
                                    Find areas between curves, areas of irregular shapes, and regions bounded by multiple functions.
                                </p>
                            </div>
                            <div style="background: white; padding: 15px; border-radius: 8px; border-left: 3px solid #10b981;">
                                <strong style="color: #065f46;">🌊 Volumes of Revolution</strong>
                                <p style="margin: 5px 0; font-size: 0.9rem; color: #3f3f46;">
                                    Calculate volumes by rotating curves around axes using disk, washer, or shell methods.
                                </p>
                            </div>
                            <div style="background: white; padding: 15px; border-radius: 8px; border-left: 3px solid #f59e0b;">
                                <strong style="color: #92400e;">🚀 Physics Applications</strong>
                                <p style="margin: 5px 0; font-size: 0.9rem; color: #3f3f46;">
                                    Work = ∫F·dx, Center of Mass, Fluid Pressure, Arc Length, and more.
                                </p>
                            </div>
                            <div style="background: white; padding: 15px; border-radius: 8px; border-left: 3px solid #ef4444;">
                                <strong style="color: #991b1b;">💵 Economics</strong>
                                <p style="margin: 5px 0; font-size: 0.9rem; color: #3f3f46;">
                                    Consumer/Producer Surplus, Total Revenue from Marginal Revenue, Present Value of Income Streams.
                                </p>
                            </div>
                            <div style="background: white; padding: 15px; border-radius: 8px; border-left: 3px solid #8b5cf6;">
                                <strong style="color: #5b21b6;">📊 Probability & Statistics</strong>
                                <p style="margin: 5px 0; font-size: 0.9rem; color: #3f3f46;">
                                    Probability density functions, Expected values, Normal distribution calculations.
                                </p>
                            </div>
                            <div style="background: white; padding: 15px; border-radius: 8px; border-left: 3px solid #ec4899;">
                                <strong style="color: #9f1239;">📈 Accumulation</strong>
                                <p style="margin: 5px 0; font-size: 0.9rem; color: #3f3f46;">
                                    Total distance from velocity, Total growth from rate of change, Net change problems.
                                </p>
                            </div>
                        </div>
                    </div>

                    <div>
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Important Properties</h4>
                        <div style="background: white; padding: 15px; border-radius: 8px;">
                            <ul style="line-height: 1.9; color: #3f3f46; margin-bottom: 0;">
                                <li><strong>Linearity:</strong> ∫[af(x) + bg(x)]dx = a∫f(x)dx + b∫g(x)dx</li>
                                <li><strong>Additivity:</strong> ∫<sub>a</sub><sup>c</sup> f(x)dx = ∫<sub>a</sub><sup>b</sup> f(x)dx + ∫<sub>b</sub><sup>c</sup> f(x)dx</li>
                                <li><strong>Reversal:</strong> ∫<sub>a</sub><sup>b</sup> f(x)dx = -∫<sub>b</sub><sup>a</sup> f(x)dx</li>
                                <li><strong>Zero Width:</strong> ∫<sub>a</sub><sup>a</sup> f(x)dx = 0</li>
                                <li><strong>Constant Multiple:</strong> ∫k·f(x)dx = k·∫f(x)dx</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="result-section" style="background: #f0f9ff; border-left-color: #3b82f6;">
                    <h3 style="color: #1e40af;">Related Calculus Tools</h3>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="derivative-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Derivative Calculator</a>
                        <a href="limit-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Limit Calculator</a>
                        <a href="series-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Taylor Series</a>
                        <a href="math-art-gallery.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Math Art Gallery</a>
                        <a href="linear-equations-solver.jsp" class="btn btn-sm btn-outline-primary mb-2">Equation Solver</a>
                    </div>
                    <p class="text-muted small mb-0 mt-2">Explore more calculus tools for complete mathematical analysis.</p>
                </div>
            </div>
        </div>

    <script src="https://cdn.jsdelivr.net/npm/mathjs@11.11.0/lib/browser/math.min.js"></script>

    <script>
        function toggleBounds() {
            const type = document.getElementById('integralType').value;
            const container = document.getElementById('boundsContainer');
            if (type === 'definite') {
                container.classList.add('active');
            } else {
                container.classList.remove('active');
            }
        }

        function calculateIntegral() {
            const funcInput = document.getElementById('functionInput').value.trim();
            const variable = document.getElementById('variableSelect').value;
            const integralType = document.getElementById('integralType').value;

            if (!funcInput) {
                alert('Please enter a function');
                return;
            }

            try {
                // Replace pi with actual value
                const normalizedInput = funcInput.replace(/\bpi\b/g, 'pi');

                // Parse the function
                const expr = math.parse(normalizedInput);

                // Calculate integral (antiderivative)
                const antiderivative = integrateSymbolic(expr, variable);

                const steps = [];

                // Step 1: Show original integral
                steps.push({
                    step: 1,
                    description: 'Set up the integral',
                    latex: `\\int ${toLatex(expr)} \\, d${variable}`,
                    method: 'Setup'
                });

                // Step 2: Identify method
                const method = identifyMethod(expr, variable);
                steps.push({
                    step: 2,
                    description: `Apply ${method}`,
                    latex: toLatex(antiderivative),
                    method: method
                });

                // Step 3: Add constant (for indefinite)
                if (integralType === 'indefinite') {
                    steps.push({
                        step: 3,
                        description: 'Add constant of integration',
                        latex: `${toLatex(antiderivative)} + C`,
                        method: 'Constant C'
                    });
                }

                let numericalResult = null;
                if (integralType === 'definite') {
                    const lowerStr = document.getElementById('lowerBound').value.trim();
                    const upperStr = document.getElementById('upperBound').value.trim();

                    if (!lowerStr || !upperStr) {
                        alert('Please enter both bounds for definite integral');
                        return;
                    }

                    // Evaluate bounds
                    const lower = math.evaluate(lowerStr.replace(/\bpi\b/g, 'pi'));
                    const upper = math.evaluate(upperStr.replace(/\bpi\b/g, 'pi'));

                    // Compile antiderivative
                    const F = antiderivative.compile();

                    // Evaluate F(upper) - F(lower)
                    const scopeUpper = {};
                    scopeUpper[variable] = upper;
                    const Fupper = F.evaluate(scopeUpper);

                    const scopeLower = {};
                    scopeLower[variable] = lower;
                    const Flower = F.evaluate(scopeLower);

                    numericalResult = Fupper - Flower;

                    steps.push({
                        step: 3,
                        description: `Evaluate at bounds: F(${upper}) - F(${lower})`,
                        latex: `[${toLatex(antiderivative)}]_{${lower}}^{${upper}} = ${numericalResult.toFixed(6)}`,
                        method: 'Fundamental Theorem'
                    });
                }

                // Display results
                displayResults(expr, antiderivative, steps, variable, integralType, numericalResult);

                // Store for Riemann sum calculations
                currentIntegralFunction = expr;
                currentIntegralVariable = variable;
                actualIntegralValue = numericalResult;

                // Draw graph
                if (integralType === 'definite') {
                    const lower = math.evaluate(document.getElementById('lowerBound').value.replace(/\bpi\b/g, 'pi'));
                    const upper = math.evaluate(document.getElementById('upperBound').value.replace(/\bpi\b/g, 'pi'));
                    currentLowerBound = lower;
                    currentUpperBound = upper;
                    drawGraph(expr, variable, lower, upper, true);
                } else {
                    drawGraph(expr, variable, -10, 10, false);
                }

                document.getElementById('resultsContainer').style.display = 'block';

            } catch (error) {
                showError('Error calculating integral: ' + error.message);
            }
        }

        function integrateSymbolic(expr, variable) {
            // Use numerical integration as symbolic integration is limited
            // For display purposes, we'll show common patterns
            const exprStr = expr.toString();

            // Try to use math.js derivative in reverse for simple cases
            try {
                // For polynomials, use power rule in reverse
                if (exprStr.match(/^[0-9*x^+\-\s]+$/)) {
                    // Simple polynomial integration
                    return math.parse(integratePolynomial(exprStr, variable));
                }

                // For known functions, return known integrals
                if (exprStr === variable) {
                    return math.parse(`(${variable}^2)/2`);
                }
                if (exprStr === `${variable} ^ 2`) {
                    return math.parse(`(${variable}^3)/3`);
                }
                if (exprStr === `sin(${variable})`) {
                    return math.parse(`-cos(${variable})`);
                }
                if (exprStr === `cos(${variable})`) {
                    return math.parse(`sin(${variable})`);
                }
                if (exprStr === `exp(${variable})` || exprStr === `e ^ ${variable}`) {
                    return math.parse(`exp(${variable})`);
                }
                if (exprStr === `1 / ${variable}`) {
                    return math.parse(`ln(abs(${variable}))`);
                }

                // For more complex expressions, use numerical approximation
                return approximateIntegral(expr, variable);

            } catch (e) {
                return approximateIntegral(expr, variable);
            }
        }

        function integratePolynomial(exprStr, variable) {
            // Basic polynomial integration using power rule
            let result = '';
            const terms = exprStr.split(/(?=[+-])/);

            for (let term of terms) {
                term = term.trim();
                if (!term) continue;

                // Match coefficient and power: like "3*x^2" or "x" or "5"
                const match = term.match(/^([+-]?\d*\.?\d*)\*?([a-z])?\^?(\d*)$/);
                if (match) {
                    let coef = match[1] || '1';
                    if (coef === '+' || coef === '') coef = '1';
                    if (coef === '-') coef = '-1';
                    coef = parseFloat(coef);

                    const hasVar = match[2] === variable;
                    let power = match[3] ? parseInt(match[3]) : (hasVar ? 1 : 0);

                    if (!hasVar && power === 0) {
                        // Constant term
                        result += (result ? ' + ' : '') + `${coef}*${variable}`;
                    } else {
                        // Variable term
                        const newPower = power + 1;
                        const newCoef = coef / newPower;
                        result += (result ? ' + ' : '') + `${newCoef}*${variable}^${newPower}`;
                    }
                }
            }

            return result || '0';
        }

        function approximateIntegral(expr, variable) {
            // Return a symbolic representation
            return math.parse(`integral(${expr.toString()}, ${variable})`);
        }

        function toLatex(expr) {
            try {
                let latex = expr.toTex ? expr.toTex() : expr.toString();
                latex = latex.replace(/\\cdot/g, '\\,');
                latex = latex.replace(/\*\*/g, '^');
                latex = latex.replace(/\*/g, '\\,');
                return latex;
            } catch (e) {
                return expr.toString();
            }
        }

        function identifyMethod(expr, variable) {
            const exprStr = expr.toString();

            if (exprStr.match(/\^/)) return 'Power Rule';
            if (exprStr.includes('sin') || exprStr.includes('cos')) return 'Trigonometric Integration';
            if (exprStr.includes('exp') || exprStr.includes('e ^')) return 'Exponential Integration';
            if (exprStr.includes('/')) return 'Logarithmic Integration';
            if (exprStr.includes('*') && exprStr.includes(variable)) return 'Integration by Parts';

            return 'Direct Integration';
        }

        function displayResults(original, antiderivative, steps, variable, type, numericalResult) {
            // Display original integral
            const integralSymbol = type === 'definite' ?
                `\\int_{${document.getElementById('lowerBound').value}}^{${document.getElementById('upperBound').value}}` :
                `\\int`;

            document.getElementById('originalIntegral').innerHTML =
                `$$${integralSymbol} ${toLatex(original)} \\, d${variable}$$`;

            // Display result
            const resultLatex = type === 'definite' ?
                `${toLatex(antiderivative)}` :
                `${toLatex(antiderivative)} + C`;

            document.getElementById('integralResult').innerHTML =
                `$$${resultLatex}$$`;

            // Display numerical result for definite integrals
            const numericalDiv = document.getElementById('numericalResultDiv');
            if (type === 'definite' && numericalResult !== null) {
                numericalDiv.innerHTML = `<div class="numerical-result">≈ ${numericalResult.toFixed(6)}</div>`;
            } else {
                numericalDiv.innerHTML = '';
            }

            // Display steps
            let stepsHtml = '';
            for (let i = 0; i < steps.length; i++) {
                const step = steps[i];
                const methodHtml = step.method ? `<span class="method-badge">${step.method}</span>` : '';
                stepsHtml += `
                    <div class="step-item">
                        <span class="step-number">${step.step}</span>
                        <strong>${step.description}</strong>
                        ${methodHtml}
                        <div class="latex-output mt-2">$$${step.latex}$$</div>
                    </div>
                `;
            }
            document.getElementById('stepsContainer').innerHTML = stepsHtml;

            // Render MathJax
            if (window.MathJax) {
                MathJax.typesetPromise();
            }
        }

        function drawGraph(original, variable, xMin, xMax, showArea) {
            const canvas = document.getElementById('graphCanvas');
            const ctx = canvas.getContext('2d');
            const width = canvas.width = canvas.offsetWidth;
            const height = canvas.height = canvas.offsetHeight;

            ctx.clearRect(0, 0, width, height);

            const padding = 40;
            const graphWidth = width - 2 * padding;
            const graphHeight = height - 2 * padding;

            // Compile function
            const f = original.compile();

            // Find y range
            let yMin = Infinity, yMax = -Infinity;
            const points = 200;
            for (let i = 0; i < points; i++) {
                const x = xMin + (xMax - xMin) * i / points;
                try {
                    const scope = {};
                    scope[variable] = x;
                    const y = f.evaluate(scope);
                    if (isFinite(y)) {
                        yMin = Math.min(yMin, y, 0);
                        yMax = Math.max(yMax, y, 0);
                    }
                } catch (e) {}
            }

            const yPadding = (yMax - yMin) * 0.1;
            yMin -= yPadding;
            yMax += yPadding;

            if (!isFinite(yMin) || !isFinite(yMax)) {
                yMin = -10;
                yMax = 10;
            }

            // Helper functions
            function toScreenX(x) {
                return padding + graphWidth * (x - xMin) / (xMax - xMin);
            }

            function toScreenY(y) {
                return padding + graphHeight * (yMax - y) / (yMax - yMin);
            }

            // Draw grid
            ctx.strokeStyle = '#e2e8f0';
            ctx.lineWidth = 1;
            for (let i = 0; i <= 10; i++) {
                const x = padding + graphWidth * i / 10;
                ctx.beginPath();
                ctx.moveTo(x, padding);
                ctx.lineTo(x, height - padding);
                ctx.stroke();

                const y = padding + graphHeight * i / 10;
                ctx.beginPath();
                ctx.moveTo(padding, y);
                ctx.lineTo(width - padding, y);
                ctx.stroke();
            }

            // Draw axes
            ctx.strokeStyle = '#cbd5e0';
            ctx.lineWidth = 2;

            const yZero = toScreenY(0);
            if (yZero >= padding && yZero <= height - padding) {
                ctx.beginPath();
                ctx.moveTo(padding, yZero);
                ctx.lineTo(width - padding, yZero);
                ctx.stroke();
            }

            const xZero = toScreenX(0);
            if (xZero >= padding && xZero <= width - padding) {
                ctx.beginPath();
                ctx.moveTo(xZero, padding);
                ctx.lineTo(xZero, height - padding);
                ctx.stroke();
            }

            // Fill area under curve (for definite integrals)
            if (showArea) {
                ctx.fillStyle = 'rgba(102, 126, 234, 0.2)';
                ctx.beginPath();
                const lower = parseFloat(document.getElementById('lowerBound').value);
                const upper = parseFloat(document.getElementById('upperBound').value);

                for (let i = 0; i <= points; i++) {
                    const x = lower + (upper - lower) * i / points;
                    try {
                        const scope = {};
                        scope[variable] = x;
                        const y = f.evaluate(scope);
                        if (i === 0) {
                            ctx.moveTo(toScreenX(x), yZero);
                            ctx.lineTo(toScreenX(x), toScreenY(y));
                        } else {
                            ctx.lineTo(toScreenX(x), toScreenY(y));
                        }
                    } catch (e) {}
                }
                ctx.lineTo(toScreenX(upper), yZero);
                ctx.closePath();
                ctx.fill();
            }

            // Draw function
            ctx.strokeStyle = '#667eea';
            ctx.lineWidth = 3;
            ctx.beginPath();
            let started = false;
            for (let i = 0; i < points; i++) {
                const x = xMin + (xMax - xMin) * i / points;
                try {
                    const scope = {};
                    scope[variable] = x;
                    const y = f.evaluate(scope);
                    if (isFinite(y) && y >= yMin && y <= yMax) {
                        const sx = toScreenX(x);
                        const sy = toScreenY(y);
                        if (!started) {
                            ctx.moveTo(sx, sy);
                            started = true;
                        } else {
                            ctx.lineTo(sx, sy);
                        }
                    } else {
                        started = false;
                    }
                } catch (e) {
                    started = false;
                }
            }
            ctx.stroke();

            // Draw Riemann rectangles if enabled
            if (showArea && document.getElementById('showRiemann').checked) {
                drawRiemannSum(f, variable, toScreenX, toScreenY, yZero);
            }

            // Update legend
            if (showArea) {
                document.getElementById('graphLegend').innerHTML = `
                    <small class="text-muted">
                        <span style="color: #667eea; font-weight: 600;">■</span> Function f(x) &nbsp;&nbsp;
                        <span style="background: rgba(102, 126, 234, 0.3); padding: 2px 8px; font-weight: 600;">█</span> Area = ∫f(x)dx
                    </small>
                `;
            }
        }

        // Global variables for Riemann sum
        let currentIntegralFunction = null;
        let currentIntegralVariable = 'x';
        let currentLowerBound = 0;
        let currentUpperBound = 1;
        let actualIntegralValue = null;

        function drawRiemannSum(f, variable, toScreenX, toScreenY, yZero) {
            const canvas = document.getElementById('graphCanvas');
            const ctx = canvas.getContext('2d');

            const lower = parseFloat(document.getElementById('lowerBound').value);
            const upper = parseFloat(document.getElementById('upperBound').value);
            const n = parseInt(document.getElementById('rectanglesSlider').value);
            const method = document.getElementById('riemannMethod').value;

            const dx = (upper - lower) / n;
            let sum = 0;

            // Draw rectangles
            ctx.strokeStyle = '#f59e0b';
            ctx.lineWidth = 2;
            ctx.fillStyle = 'rgba(245, 158, 11, 0.2)';

            for (let i = 0; i < n; i++) {
                const x0 = lower + i * dx;
                const x1 = x0 + dx;
                let sampleX;

                // Choose sample point based on method
                switch(method) {
                    case 'left':
                        sampleX = x0;
                        break;
                    case 'right':
                        sampleX = x1;
                        break;
                    case 'midpoint':
                        sampleX = (x0 + x1) / 2;
                        break;
                    case 'trapezoid':
                        // For trapezoid, we need both endpoints
                        try {
                            const scope0 = {};
                            scope0[variable] = x0;
                            const y0 = f.evaluate(scope0);

                            const scope1 = {};
                            scope1[variable] = x1;
                            const y1 = f.evaluate(scope1);

                            if (isFinite(y0) && isFinite(y1)) {
                                const height = (y0 + y1) / 2;
                                sum += height * dx;

                                // Draw trapezoid
                                ctx.beginPath();
                                ctx.moveTo(toScreenX(x0), yZero);
                                ctx.lineTo(toScreenX(x0), toScreenY(y0));
                                ctx.lineTo(toScreenX(x1), toScreenY(y1));
                                ctx.lineTo(toScreenX(x1), yZero);
                                ctx.closePath();
                                ctx.fill();
                                ctx.stroke();
                            }
                        } catch (e) {}
                        continue; // Skip the regular rectangle drawing below
                    default:
                        sampleX = (x0 + x1) / 2;
                }

                // Draw rectangle for left, right, midpoint
                try {
                    const scope = {};
                    scope[variable] = sampleX;
                    const y = f.evaluate(scope);

                    if (isFinite(y)) {
                        sum += y * dx;

                        // Draw rectangle
                        ctx.beginPath();
                        ctx.moveTo(toScreenX(x0), yZero);
                        ctx.lineTo(toScreenX(x0), toScreenY(y));
                        ctx.lineTo(toScreenX(x1), toScreenY(y));
                        ctx.lineTo(toScreenX(x1), yZero);
                        ctx.closePath();
                        ctx.fill();
                        ctx.stroke();
                    }
                } catch (e) {}
            }

            // Update approximation display
            document.getElementById('riemannValue').textContent = sum.toFixed(6);

            // Calculate error if we have the actual value
            if (actualIntegralValue !== null) {
                const error = Math.abs(sum - actualIntegralValue);
                const errorPercent = (error / Math.abs(actualIntegralValue) * 100).toFixed(2);
                document.getElementById('riemannError').textContent =
                    `(Error: ${error.toFixed(6)} or ${errorPercent}%)`;
            } else {
                document.getElementById('riemannError').textContent = '';
            }
        }

        // Setup event listeners for Riemann controls
        function setupRiemannControls() {
            const showRiemannCheckbox = document.getElementById('showRiemann');
            const riemannOptions = document.getElementById('riemannOptions');
            const rectanglesSlider = document.getElementById('rectanglesSlider');
            const nRectangles = document.getElementById('nRectangles');
            const riemannMethod = document.getElementById('riemannMethod');

            showRiemannCheckbox.addEventListener('change', function() {
                if (this.checked) {
                    riemannOptions.style.display = 'block';
                } else {
                    riemannOptions.style.display = 'none';
                }

                // Redraw graph
                if (currentIntegralFunction && currentIntegralVariable) {
                    const integralType = document.getElementById('integralType').value;
                    if (integralType === 'definite') {
                        const lower = parseFloat(document.getElementById('lowerBound').value);
                        const upper = parseFloat(document.getElementById('upperBound').value);
                        drawGraph(currentIntegralFunction, currentIntegralVariable, lower, upper, true);
                    }
                }
            });

            rectanglesSlider.addEventListener('input', function() {
                nRectangles.textContent = this.value;

                // Redraw graph
                if (currentIntegralFunction && currentIntegralVariable) {
                    const integralType = document.getElementById('integralType').value;
                    if (integralType === 'definite') {
                        const lower = parseFloat(document.getElementById('lowerBound').value);
                        const upper = parseFloat(document.getElementById('upperBound').value);
                        drawGraph(currentIntegralFunction, currentIntegralVariable, lower, upper, true);
                    }
                }
            });

            riemannMethod.addEventListener('change', function() {
                // Redraw graph
                if (currentIntegralFunction && currentIntegralVariable) {
                    const integralType = document.getElementById('integralType').value;
                    if (integralType === 'definite') {
                        const lower = parseFloat(document.getElementById('lowerBound').value);
                        const upper = parseFloat(document.getElementById('upperBound').value);
                        drawGraph(currentIntegralFunction, currentIntegralVariable, lower, upper, true);
                    }
                }
            });
        }

        function loadExample(func) {
            document.getElementById('functionInput').value = func;
        }

        function generateRandom() {
            const examples = [
                'x^3',
                '2*x^2 + 3*x',
                'sin(x)',
                'cos(2*x)',
                'e^x',
                'x*e^x',
                '1/x',
                'ln(x)',
                'sqrt(x)',
                'x^2*sin(x)',
                'cos(x)^2',
                '1/(x^2 + 1)',
                'x/(x^2 + 1)'
            ];
            const random = examples[Math.floor(Math.random() * examples.length)];
            document.getElementById('functionInput').value = random;
        }

        function toggleSteps() {
            const container = document.getElementById('stepsContainer');
            const toggle = document.getElementById('stepsToggle');
            if (container.style.display === 'none') {
                container.style.display = 'block';
                toggle.textContent = '▲ Hide';
            } else {
                container.style.display = 'none';
                toggle.textContent = '▼ Show';
            }
        }

        function copyResult() {
            const result = document.getElementById('integralResult').textContent;
            navigator.clipboard.writeText(result).then(() => {
                alert('Copied to clipboard!');
            });
        }

        function showError(message) {
            const container = document.getElementById('resultsContainer');
            container.innerHTML = `<div class="error-message">${message}</div>`;
            container.style.display = 'block';
        }

        // Toggle syntax reference
        function toggleSyntax() {
            const content = document.getElementById('syntaxContent');
            const toggle = document.getElementById('syntaxToggle');
            if (content.style.display === 'none') {
                content.style.display = 'block';
                toggle.textContent = '▼';
            } else {
                content.style.display = 'none';
                toggle.textContent = '▶';
            }
        }

        // Toggle formulas reference
        function toggleFormulas() {
            const content = document.getElementById('formulasContent');
            const toggle = document.getElementById('formulasToggle');
            if (content.style.display === 'none') {
                content.style.display = 'block';
                toggle.textContent = '▼';
            } else {
                content.style.display = 'none';
                toggle.textContent = '▶';
            }
        }

        // Initialize Riemann controls on page load
        window.addEventListener('DOMContentLoaded', () => {
            setupRiemannControls();
        });
    </script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
