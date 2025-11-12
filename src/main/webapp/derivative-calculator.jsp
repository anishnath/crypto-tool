<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FREE Derivative Calculator - Step-by-Step Solutions | Symbolic Differentiation</title>
    <meta name="description" content="Free online derivative calculator with step-by-step solutions. Calculate derivatives symbolically using power rule, product rule, quotient rule, and chain rule. Supports polynomials, trigonometric, exponential, and logarithmic functions. Interactive graphs and LaTeX output.">
    <meta name="keywords" content="derivative calculator, differentiation calculator, calculus calculator, derivative solver, symbolic differentiation, step by step derivatives, power rule, product rule, quotient rule, chain rule, calculus tool, math calculator">
    <link rel="canonical" href="https://8gwifi.org/derivative-calculator.jsp">

    <!-- Open Graph -->
    <meta property="og:title" content="FREE Derivative Calculator - Step-by-Step Solutions">
    <meta property="og:description" content="Calculate derivatives with detailed step-by-step solutions. Supports all differentiation rules and function types.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/derivative-calculator.jsp">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="FREE Derivative Calculator - Step-by-Step Solutions">
    <meta name="twitter:description" content="Calculate derivatives with detailed step-by-step solutions. Supports all differentiation rules and function types.">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Derivative Calculator",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "description": "Free online derivative calculator with step-by-step solutions for symbolic differentiation",
      "featureList": [
        "Symbolic differentiation",
        "Step-by-step solutions",
        "Power rule differentiation",
        "Product rule differentiation",
        "Quotient rule differentiation",
        "Chain rule differentiation",
        "Trigonometric functions (sin, cos, tan, sec, csc, cot)",
        "Exponential functions (e^x, a^x)",
        "Logarithmic functions (ln, log)",
        "Hyperbolic functions (sinh, cosh, tanh)",
        "Inverse trigonometric functions (arcsin, arccos, arctan)",
        "Higher-order derivatives",
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
          "name": "How do I calculate derivatives step by step?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Enter your function (e.g., x^2 + 3*x + 5) and click Calculate. The calculator will show each differentiation step, applying the power rule, product rule, quotient rule, or chain rule as needed."
          }
        },
        {
          "@type": "Question",
          "name": "What functions can I differentiate?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The calculator supports polynomials, trigonometric functions (sin, cos, tan), exponential functions (e^x, exp(x)), logarithmic functions (ln, log), hyperbolic functions, inverse trig functions, and compositions of these functions."
          }
        },
        {
          "@type": "Question",
          "name": "Can I calculate higher-order derivatives?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Yes! Set the derivative order (n) to calculate the nth derivative. For example, order 2 gives the second derivative f''(x), order 3 gives f'''(x), etc."
          }
        },
        {
          "@type": "Question",
          "name": "What differentiation rules are supported?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "All standard rules: Power Rule (d/dx[x^n] = n*x^(n-1)), Product Rule (d/dx[f*g] = f'*g + f*g'), Quotient Rule (d/dx[f/g] = (f'*g - f*g')/g^2), Chain Rule (d/dx[f(g(x))] = f'(g(x))*g'(x)), and special function derivatives."
          }
        },
        {
          "@type": "Question",
          "name": "How accurate is the derivative calculator?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The calculator uses symbolic differentiation, which means it applies mathematical rules exactly without numerical approximation. Results are mathematically exact, not approximate."
          }
        }
      ]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Calculate Derivatives",
      "description": "Step-by-step guide to using the derivative calculator",
      "step": [
        {
          "@type": "HowToStep",
          "position": 1,
          "name": "Enter Function",
          "text": "Type your function using standard notation (e.g., x^2, sin(x), e^x, ln(x))"
        },
        {
          "@type": "HowToStep",
          "position": 2,
          "name": "Select Variable",
          "text": "Choose the variable to differentiate with respect to (default: x)"
        },
        {
          "@type": "HowToStep",
          "position": 3,
          "name": "Set Derivative Order",
          "text": "Choose the order of derivative (1 for first derivative, 2 for second, etc.)"
        },
        {
          "@type": "HowToStep",
          "position": 4,
          "name": "Calculate",
          "text": "Click Calculate to see the derivative with step-by-step solution"
        },
        {
          "@type": "HowToStep",
          "position": 5,
          "name": "View Results",
          "text": "Review the derivative, steps, and interactive graph"
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
          "name": "Derivative Calculator",
          "item": "https://8gwifi.org/derivative-calculator.jsp"
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
            border-left: 3px solid #48bb78;
        }
        .step-number {
            display: inline-block;
            background: #48bb78;
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            text-align: center;
            line-height: 28px;
            font-weight: 600;
            margin-right: 10px;
        }
        .rule-badge {
            display: inline-block;
            background: #667eea;
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
        .error-message {
            background: #fff5f5;
            border-left: 4px solid #f56565;
            padding: 15px;
            border-radius: 8px;
            color: #c53030;
            margin: 15px 0;
        }
        #historySection {
            background: #f7fafc;
            border-radius: 8px;
            padding: 15px;
            border: 1px solid #e2e8f0;
        }
        #historySection h6 {
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 10px;
        }
        #historyList .list-group-item {
            border-radius: 6px;
            margin-bottom: 5px;
            transition: all 0.2s;
            border: 1px solid #e2e8f0;
        }
        #historyList .list-group-item:hover {
            background: #edf2f7;
            border-color: #667eea;
            transform: translateX(5px);
        }
        .btn-outline-secondary {
            border: 2px solid #e2e8f0;
            color: #4a5568;
            transition: all 0.3s;
        }
        .btn-outline-secondary:hover {
            background: #4a5568;
            border-color: #4a5568;
            color: white;
        }
        #graphCanvas {
            cursor: crosshair;
        }
        .graph-controls {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            margin-top: 15px;
        }
        .graph-controls label {
            margin: 0;
        }
        #pointEval {
            background: #f0f9ff;
            border-radius: 8px;
            border: 2px solid #3b82f6;
            padding: 15px;
            margin-top: 15px;
            display: none;
        }
        #pointEval strong {
            color: #1e40af;
            font-size: 1.1rem;
        }
        #pointEval > div {
            margin-top: 8px;
            color: #2d3748;
            font-weight: 500;
        }
        #pointEval span {
            color: #3b82f6;
            font-weight: 600;
        }
        #criticalPointsList {
            background: white;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
            border: 2px solid #e2e8f0;
        }
        .critical-point-item {
            padding: 8px 12px;
            margin: 5px 0;
            border-radius: 6px;
            border-left: 4px solid;
        }
        .critical-point-item.max {
            border-left-color: #ef4444;
            background: #fee2e2;
        }
        .critical-point-item.min {
            border-left-color: #10b981;
            background: #d1fae5;
        }
        .critical-point-item.saddle {
            border-left-color: #f59e0b;
            background: #fef3c7;
        }
    </style>
    <%@ include file="header-script.jsp"%>
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
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4">
        <div class="calc-card">
            <div class="calc-header">
                <h1>Derivative Calculator</h1>
                <p>Calculate derivatives step-by-step with symbolic differentiation</p>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="mb-4">
                        <label for="functionInput" class="form-label">Function f(x)</label>
                        <input type="text" class="form-control" id="functionInput"
                               placeholder="e.g., x^2 + 3*x + 5, sin(x)*cos(x), e^x/x"
                               value="x^3 + 2*x^2 - 5*x + 1">
                        <small class="text-muted">Supported: +, -, *, /, ^, sin, cos, tan, exp, ln, log, sqrt, abs</small>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label for="variableSelect" class="form-label">Variable</label>
                            <select class="form-select" id="variableSelect">
                                <option value="x" selected>x</option>
                                <option value="y">y</option>
                                <option value="t">t</option>
                                <option value="u">u</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="orderInput" class="form-label">Derivative Order (n)</label>
                            <input type="number" class="form-control" id="orderInput"
                                   min="1" max="10" value="1">
                        </div>
                    </div>

                    <button class="btn btn-calculate" onclick="calculateDerivative()">
                        Calculate Derivative
                    </button>

                    <div class="mt-3">
                        <button class="btn btn-outline-secondary btn-sm" onclick="shareCalculation()">
                            <i class="fas fa-share-alt"></i> Share
                        </button>
                        <button class="btn btn-outline-secondary btn-sm" onclick="clearHistory()">
                            <i class="fas fa-trash"></i> Clear History
                        </button>
                    </div>

                    <div id="historySection" class="mt-3" style="display: none;">
                        <h6>Recent Calculations</h6>
                        <div id="historyList" class="list-group small"></div>
                    </div>

                    <div class="example-buttons">
                        <button class="btn-example" onclick="loadExample('x^2 + 3*x + 5')">Polynomial</button>
                        <button class="btn-example" onclick="loadExample('sin(x)*cos(x)')">Trig Product</button>
                        <button class="btn-example" onclick="loadExample('e^x/x')">Quotient</button>
                        <button class="btn-example" onclick="loadExample('sin(x^2)')">Chain Rule</button>
                        <button class="btn-example" onclick="loadExample('ln(x)*x^2')">Logarithmic</button>
                        <button class="btn-example" onclick="loadExample('x*e^x')">Exponential</button>
                        <button class="btn-example" onclick="generateRandom()">Random</button>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="info-box">
                        <h4 style="cursor: pointer; margin-bottom: 10px;" onclick="toggleDerivSyntax()">
                            Function Syntax Reference
                            <span id="derivSyntaxToggle" style="float: right; font-size: 0.8em;">▼</span>
                        </h4>
                        <div id="derivSyntaxContent" style="font-size: 0.85rem;">
                            <strong>Basic:</strong> <code>x^2</code>, <code>2*x</code>, <code>x/2</code>, <code>sqrt(x)</code>, <code>abs(x)</code><br>
                            <strong>Trig:</strong> <code>sin(x)</code>, <code>cos(x)</code>, <code>tan(x)</code>, <code>sec(x)</code>, <code>asin(x)</code><br>
                            <strong>Exp/Log:</strong> <code>e^x</code>, <code>exp(x)</code>, <code>2^x</code>, <code>ln(x)</code>, <code>log(x,10)</code><br>
                            <strong>Hyperbolic:</strong> <code>sinh(x)</code>, <code>cosh(x)</code>, <code>tanh(x)</code>, <code>asinh(x)</code>
                        </div>
                    </div>
                </div>
            </div>

            <div id="resultsContainer" style="display: none;">
                <div class="result-section">
                    <h3>Derivative Result</h3>
                    <div class="latex-output" id="originalFunction"></div>
                    <div id="unsimplifiedResult" style="display: none;">
                        <div style="background: #fef3c7; padding: 15px; border-radius: 8px; border-left: 3px solid #f59e0b; margin-bottom: 15px;">
                            <strong style="color: #92400e;">Unsimplified:</strong>
                            <div class="latex-output" id="derivativeUnsimplified" style="background: white; margin-top: 10px;"></div>
                        </div>
                    </div>
                    <div style="background: #d1fae5; padding: 15px; border-radius: 8px; border-left: 3px solid #10b981;">
                        <strong style="color: #065f46;">Simplified:</strong>
                        <div class="latex-output" id="derivativeResult" style="background: white; margin-top: 10px;"></div>
                    </div>
                    <div class="mt-3">
                        <label style="display: flex; align-items: center; cursor: pointer; margin-bottom: 10px;">
                            <input type="checkbox" id="showUnsimplified" style="margin-right: 8px;">
                            <span style="font-weight: 600;">Show unsimplified form</span>
                        </label>
                        <button class="btn btn-secondary btn-sm" onclick="copyResult()">Copy Result</button>
                        <button class="btn btn-secondary btn-sm ms-2" onclick="copyLatex()">Copy LaTeX</button>
                    </div>
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
                    <div class="mt-2">
                        <small class="text-muted">
                            <span style="color: #667eea; font-weight: 600;">■</span> Original Function &nbsp;&nbsp;
                            <span style="color: #48bb78; font-weight: 600;">■</span> Derivative &nbsp;&nbsp;
                            <span style="color: #ef4444; font-weight: 600;">■</span> Tangent Line &nbsp;&nbsp;
                            <span style="color: #3b82f6; font-weight: 600;">●</span> Clicked Point
                        </small>
                    </div>

                    <!-- Interactive Controls -->
                    <div class="graph-controls">
                        <label>
                            <input type="checkbox" id="showTangent"> Show Tangent Line
                        </label>
                        <button class="btn btn-sm btn-outline-primary" onclick="findCriticalPoints()">Find Critical Points</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="zoomIn()">Zoom In</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="zoomOut()">Zoom Out</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="resetZoom()">Reset View</button>
                    </div>

                    <!-- Point Evaluation Display -->
                    <div id="pointEval">
                        <strong>Point Evaluation:</strong>
                        <div>x = <span id="evalX">-</span></div>
                        <div>f(x) = <span id="evalFX">-</span></div>
                        <div>f'(x) = <span id="evalFPrimeX">-</span></div>
                    </div>

                    <!-- Critical Points List -->
                    <div id="criticalPointsList" style="display: none;">
                        <strong style="color: #2d3748;">Critical Points:</strong>
                        <div id="criticalPointsContent"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Educational Content Section - Always Visible -->
        <div class="calc-card">
            <div class="result-section" style="background: #fefce8; border-left-color: #eab308;">
                <h3 style="color: #713f12;">📚 Understanding Derivatives</h3>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">What is a Derivative?</h4>
                        <p style="line-height: 1.7; color: #3f3f46;">
                            A <strong>derivative</strong> measures how a function changes as its input changes. Geometrically,
                            the derivative at a point represents the <strong>slope of the tangent line</strong> to the function's graph
                            at that point. In physics, derivatives represent rates of change: velocity is the derivative of position,
                            and acceleration is the derivative of velocity.
                        </p>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Mathematical Notation</h4>
                        <p style="line-height: 1.7; color: #3f3f46;">
                            The derivative of f(x) can be written in multiple ways:
                        </p>
                        <ul style="line-height: 1.8; color: #3f3f46;">
                            <li><strong>f'(x)</strong> - Lagrange's notation (most common)</li>
                            <li><strong>df/dx</strong> - Leibniz's notation (emphasizes the ratio)</li>
                            <li><strong>Df(x)</strong> - Euler's notation</li>
                            <li><strong>ḟ(x)</strong> - Newton's notation (dot notation, often used in physics)</li>
                        </ul>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Essential Differentiation Rules</h4>

                        <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong style="color: #7c2d12;">1. Power Rule:</strong>
                            <p style="margin: 5px 0; color: #3f3f46;">If f(x) = x<sup>n</sup>, then f'(x) = n·x<sup>n-1</sup></p>
                            <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: d/dx[x³] = 3x²</em></p>
                        </div>

                        <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong style="color: #7c2d12;">2. Product Rule:</strong>
                            <p style="margin: 5px 0; color: #3f3f46;">If f(x) = g(x)·h(x), then f'(x) = g'(x)·h(x) + g(x)·h'(x)</p>
                            <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: d/dx[x²·sin(x)] = 2x·sin(x) + x²·cos(x)</em></p>
                        </div>

                        <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong style="color: #7c2d12;">3. Quotient Rule:</strong>
                            <p style="margin: 5px 0; color: #3f3f46;">If f(x) = g(x)/h(x), then f'(x) = [g'(x)·h(x) - g(x)·h'(x)] / [h(x)]²</p>
                            <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: d/dx[x/sin(x)] = [sin(x) - x·cos(x)] / sin²(x)</em></p>
                        </div>

                        <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong style="color: #7c2d12;">4. Chain Rule:</strong>
                            <p style="margin: 5px 0; color: #3f3f46;">If f(x) = g(h(x)), then f'(x) = g'(h(x))·h'(x)</p>
                            <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: d/dx[sin(x²)] = cos(x²)·2x</em></p>
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Common Function Derivatives</h4>
                        <div style="background: white; padding: 15px; border-radius: 8px;">
                            <table style="width: 100%; border-collapse: collapse;">
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 8px; font-weight: 600; color: #7c2d12;">Function</td>
                                    <td style="padding: 8px; font-weight: 600; color: #7c2d12;">Derivative</td>
                                </tr>
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 8px; color: #3f3f46;">sin(x)</td>
                                    <td style="padding: 8px; color: #3f3f46;">cos(x)</td>
                                </tr>
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 8px; color: #3f3f46;">cos(x)</td>
                                    <td style="padding: 8px; color: #3f3f46;">-sin(x)</td>
                                </tr>
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 8px; color: #3f3f46;">tan(x)</td>
                                    <td style="padding: 8px; color: #3f3f46;">sec²(x) = 1/cos²(x)</td>
                                </tr>
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 8px; color: #3f3f46;">e<sup>x</sup></td>
                                    <td style="padding: 8px; color: #3f3f46;">e<sup>x</sup></td>
                                </tr>
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 8px; color: #3f3f46;">a<sup>x</sup></td>
                                    <td style="padding: 8px; color: #3f3f46;">a<sup>x</sup>·ln(a)</td>
                                </tr>
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 8px; color: #3f3f46;">ln(x)</td>
                                    <td style="padding: 8px; color: #3f3f46;">1/x</td>
                                </tr>
                                <tr>
                                    <td style="padding: 8px; color: #3f3f46;">log<sub>a</sub>(x)</td>
                                    <td style="padding: 8px; color: #3f3f46;">1/(x·ln(a))</td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Applications of Derivatives</h4>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
                            <div style="background: white; padding: 15px; border-radius: 8px; border-left: 3px solid #3b82f6;">
                                <strong style="color: #1e40af;">📈 Optimization</strong>
                                <p style="margin: 5px 0; font-size: 0.9rem; color: #3f3f46;">
                                    Find maximum and minimum values of functions. Critical points occur where f'(x) = 0 or f'(x) is undefined.
                                </p>
                            </div>
                            <div style="background: white; padding: 15px; border-radius: 8px; border-left: 3px solid #10b981;">
                                <strong style="color: #065f46;">🚗 Motion & Physics</strong>
                                <p style="margin: 5px 0; font-size: 0.9rem; color: #3f3f46;">
                                    Velocity is the derivative of position: v(t) = ds/dt. Acceleration is the derivative of velocity: a(t) = dv/dt.
                                </p>
                            </div>
                            <div style="background: white; padding: 15px; border-radius: 8px; border-left: 3px solid #f59e0b;">
                                <strong style="color: #92400e;">📐 Curve Analysis</strong>
                                <p style="margin: 5px 0; font-size: 0.9rem; color: #3f3f46;">
                                    Determine where functions are increasing (f'(x) > 0) or decreasing (f'(x) < 0), and find inflection points using f''(x).
                                </p>
                            </div>
                            <div style="background: white; padding: 15px; border-radius: 8px; border-left: 3px solid #ef4444;">
                                <strong style="color: #991b1b;">💰 Economics</strong>
                                <p style="margin: 5px 0; font-size: 0.9rem; color: #3f3f46;">
                                    Marginal cost, marginal revenue, and marginal profit are all derivatives. They show how these quantities change with production level.
                                </p>
                            </div>
                        </div>
                    </div>

                    <div>
                        <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Higher-Order Derivatives</h4>
                        <p style="line-height: 1.7; color: #3f3f46; margin-bottom: 10px;">
                            The <strong>second derivative</strong> f''(x) measures how the rate of change itself is changing (concavity):
                        </p>
                        <ul style="line-height: 1.8; color: #3f3f46;">
                            <li>If f''(x) > 0, the function is <strong>concave up</strong> (curves upward like ∪)</li>
                            <li>If f''(x) < 0, the function is <strong>concave down</strong> (curves downward like ∩)</li>
                            <li>If f''(x) = 0, there may be an <strong>inflection point</strong> where concavity changes</li>
                        </ul>
                        <p style="line-height: 1.7; color: #3f3f46; margin-top: 10px;">
                            In physics, the second derivative represents acceleration, while the third derivative (jerk) describes how acceleration changes over time.
                        </p>
                    </div>
                </div>

                <div class="result-section" style="background: #f0f9ff; border-left-color: #3b82f6;">
                    <h3 style="color: #1e40af;">Related Calculus Tools</h3>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="integral-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Integral Calculator</a>
                        <a href="limit-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Limit Calculator</a>
                        <a href="series-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Taylor Series</a>
                        <a href="math-art-gallery.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Math Art Gallery</a>
                        <a href="linear-equations-solver.jsp" class="btn btn-sm btn-outline-primary mb-2">Equation Solver</a>
                    </div>
                    <p class="text-muted small mb-0 mt-2">Explore more calculus tools for complete mathematical analysis.</p>
                </div>
            </div>
        </div>




    <script src="js/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/mathjs@11.11.0/lib/browser/math.min.js"></script>
    <script>
        // Global variables for interactive features
        let currentXMin = -10, currentXMax = 10;
        let clickedPoint = null;
        let criticalPoints = [];
        let originalExpr = null;
        let derivativeExpr = null;
        let currentVariable = 'x';
        let graphCanvas = null;
        let graphContext = null;

        function calculateDerivative() {
            const funcInput = document.getElementById('functionInput').value.trim();
            const variable = document.getElementById('variableSelect').value;
            const order = parseInt(document.getElementById('orderInput').value);

            if (!funcInput) {
                alert('Please enter a function');
                return;
            }

            try {
                // Parse the function
                const expr = math.parse(funcInput);

                // Calculate derivative
                let derivative = expr;
                const steps = [];

                for (let i = 0; i < order; i++) {
                    const orderSuffix = i === 0 ? '' : `^{(${i})}`;
                    steps.push({
                        step: i + 1,
                        description: i === 0 ? 'Original function' : `Derivative of order ${i}`,
                        expression: derivative,
                        latex: `f${orderSuffix}(${variable}) = ${toLatex(derivative)}`
                    });

                    derivative = math.derivative(derivative, variable);

                    // Add differentiation step
                    const rule = identifyRule(derivative, expr);
                    steps.push({
                        step: i + 1,
                        description: `Apply differentiation rules`,
                        expression: derivative,
                        latex: `f'${orderSuffix}(${variable}) = ${toLatex(derivative)}`,
                        rule: rule
                    });
                }

                // Store unsimplified and simplified versions
                const unsimplified = derivative;
                const simplified = math.simplify(derivative);

                // Store globally for interactive features
                originalExpr = expr;
                derivativeExpr = simplified;
                currentVariable = variable;

                // Reset interactive state
                clickedPoint = null;
                criticalPoints = [];
                currentXMin = -10;
                currentXMax = 10;
                document.getElementById('pointEval').style.display = 'none';
                document.getElementById('criticalPointsList').style.display = 'none';
                document.getElementById('showTangent').checked = false;

                // Display results
                displayResults(expr, unsimplified, simplified, steps, variable, order);

                // Draw graph
                drawGraph(expr, simplified, variable);

                document.getElementById('resultsContainer').style.display = 'block';

                // Save to history
                saveToHistory(funcInput, variable, order, toLatex(simplified));

            } catch (error) {
                showError('Error calculating derivative: ' + error.message);
            }
        }

        function toLatex(expr) {
            try {
                let latex = expr.toTex ? expr.toTex() : expr.toString();
                // Clean up common issues
                latex = latex.replace(/\\cdot/g, '\\times');
                latex = latex.replace(/\*\*/g, '^');
                return latex;
            } catch (e) {
                return expr.toString();
            }
        }

        function identifyRule(derivative, original) {
            const derivStr = derivative.toString();
            const origStr = original.toString();

            if (derivStr.includes('+') || derivStr.includes('-')) {
                if (origStr.includes('*') && !origStr.includes('/')) return 'Product Rule';
                return 'Sum/Difference Rule';
            }
            if (origStr.includes('/')) return 'Quotient Rule';
            if (origStr.includes('sin') || origStr.includes('cos')) {
                if (origStr.match(/sin\([^x)]+\)/) || origStr.match(/cos\([^x)]+\)/)) {
                    return 'Chain Rule';
                }
                return 'Trigonometric Rule';
            }
            if (origStr.includes('^')) return 'Power Rule';
            if (origStr.includes('exp') || origStr.includes('e^')) return 'Exponential Rule';
            if (origStr.includes('ln') || origStr.includes('log')) return 'Logarithmic Rule';

            return 'Basic Rule';
        }

        function displayResults(original, unsimplified, simplified, steps, variable, order) {
            const orderNotation = order === 1 ? "'" : order === 2 ? "''" : order === 3 ? "'''" : `^{(${order})}`;

            // Display original function
            document.getElementById('originalFunction').innerHTML =
                `$$f(${variable}) = ${toLatex(original)}$$`;

            // Display unsimplified derivative (if different from simplified)
            const unsimplifiedLatex = toLatex(unsimplified);
            const simplifiedLatex = toLatex(simplified);

            if (unsimplifiedLatex !== simplifiedLatex) {
                document.getElementById('derivativeUnsimplified').innerHTML =
                    `$$f${orderNotation}(${variable}) = ${unsimplifiedLatex}$$`;
                // Show checkbox since there's a difference
                document.getElementById('showUnsimplified').parentElement.style.display = 'flex';
            } else {
                // Hide checkbox if there's no difference
                document.getElementById('showUnsimplified').parentElement.style.display = 'none';
            }

            // Display simplified derivative
            document.getElementById('derivativeResult').innerHTML =
                `$$f${orderNotation}(${variable}) = ${simplifiedLatex}$$`;

            // Display steps
            let stepsHtml = '';
            for (let i = 0; i < steps.length; i++) {
                const step = steps[i];
                const ruleHtml = step.rule ? `<span class="rule-badge">${step.rule}</span>` : '';
                stepsHtml += `
                    <div class="step-item">
                        <span class="step-number">${Math.floor(i/2) + 1}</span>
                        <strong>${step.description}</strong>
                        ${ruleHtml}
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

        function drawGraph(original, derivative, variable) {
            const canvas = document.getElementById('graphCanvas');
            const ctx = canvas.getContext('2d');
            const width = canvas.width = canvas.offsetWidth;
            const height = canvas.height = canvas.offsetHeight;

            // Store for click handler
            graphCanvas = canvas;
            graphContext = ctx;

            ctx.clearRect(0, 0, width, height);

            // Setup coordinate system using current zoom values
            const xMin = currentXMin, xMax = currentXMax;
            const padding = 40;
            const graphWidth = width - 2 * padding;
            const graphHeight = height - 2 * padding;

            // Compile functions
            const f = original.compile();
            const fPrime = derivative.compile();

            // Find y range
            let yMin = Infinity, yMax = -Infinity;
            const points = 200;
            for (let i = 0; i < points; i++) {
                const x = xMin + (xMax - xMin) * i / points;
                try {
                    const scope = {};
                    scope[variable] = x;
                    const y1 = f.evaluate(scope);
                    const y2 = fPrime.evaluate(scope);
                    if (isFinite(y1)) {
                        yMin = Math.min(yMin, y1);
                        yMax = Math.max(yMax, y1);
                    }
                    if (isFinite(y2)) {
                        yMin = Math.min(yMin, y2);
                        yMax = Math.max(yMax, y2);
                    }
                } catch (e) {}
            }

            // Add padding to y range
            const yPadding = (yMax - yMin) * 0.1;
            yMin -= yPadding;
            yMax += yPadding;

            if (!isFinite(yMin) || !isFinite(yMax)) {
                yMin = -10;
                yMax = 10;
            }

            // Draw axes
            ctx.strokeStyle = '#cbd5e0';
            ctx.lineWidth = 2;

            // X-axis
            const yZero = padding + graphHeight * (yMax) / (yMax - yMin);
            if (yZero >= padding && yZero <= height - padding) {
                ctx.beginPath();
                ctx.moveTo(padding, yZero);
                ctx.lineTo(width - padding, yZero);
                ctx.stroke();
            }

            // Y-axis
            const xZero = padding + graphWidth * (0 - xMin) / (xMax - xMin);
            if (xZero >= padding && xZero <= width - padding) {
                ctx.beginPath();
                ctx.moveTo(xZero, padding);
                ctx.lineTo(xZero, height - padding);
                ctx.stroke();
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

            // Helper function to transform coordinates
            function toScreenX(x) {
                return padding + graphWidth * (x - xMin) / (xMax - xMin);
            }

            function toScreenY(y) {
                return padding + graphHeight * (yMax - y) / (yMax - yMin);
            }

            // Draw original function
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

            // Draw derivative
            ctx.strokeStyle = '#48bb78';
            ctx.lineWidth = 3;
            ctx.beginPath();
            started = false;
            for (let i = 0; i < points; i++) {
                const x = xMin + (xMax - xMin) * i / points;
                try {
                    const scope = {};
                    scope[variable] = x;
                    const y = fPrime.evaluate(scope);
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

            // Draw tangent line if checkbox is checked and point is clicked
            if (document.getElementById('showTangent').checked && clickedPoint) {
                ctx.strokeStyle = '#ef4444';
                ctx.lineWidth = 2;
                ctx.setLineDash([5, 5]);
                ctx.beginPath();

                const x0 = clickedPoint.x;
                const y0 = clickedPoint.fx;
                const slope = clickedPoint.fpx;

                // Draw tangent line across the visible range
                const x1 = xMin;
                const y1 = y0 + slope * (x1 - x0);
                const x2 = xMax;
                const y2 = y0 + slope * (x2 - x0);

                ctx.moveTo(toScreenX(x1), toScreenY(y1));
                ctx.lineTo(toScreenX(x2), toScreenY(y2));
                ctx.stroke();
                ctx.setLineDash([]);
            }

            // Draw critical points if found
            for (const cp of criticalPoints) {
                let color;
                if (cp.type === 'max') color = '#ef4444';
                else if (cp.type === 'min') color = '#10b981';
                else color = '#f59e0b';

                ctx.fillStyle = color;
                ctx.beginPath();

                try {
                    const scope = {};
                    scope[variable] = cp.x;
                    const y = f.evaluate(scope);

                    if (isFinite(y) && y >= yMin && y <= yMax) {
                        ctx.arc(toScreenX(cp.x), toScreenY(y), 6, 0, Math.PI * 2);
                        ctx.fill();

                        // Add white border
                        ctx.strokeStyle = 'white';
                        ctx.lineWidth = 2;
                        ctx.stroke();
                    }
                } catch (e) {}
            }

            // Draw clicked point marker
            if (clickedPoint) {
                ctx.fillStyle = '#3b82f6';
                ctx.beginPath();
                ctx.arc(toScreenX(clickedPoint.x), toScreenY(clickedPoint.fx), 5, 0, Math.PI * 2);
                ctx.fill();

                // Add white border
                ctx.strokeStyle = 'white';
                ctx.lineWidth = 2;
                ctx.stroke();
            }

            // Draw axis labels
            ctx.fillStyle = '#2d3748';
            ctx.font = '14px sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText(xMin.toFixed(1), padding, height - padding + 20);
            ctx.fillText(xMax.toFixed(1), width - padding, height - padding + 20);
            if (xZero >= padding && xZero <= width - padding) {
                ctx.fillText('0', xZero, height - padding + 20);
            }

            ctx.textAlign = 'right';
            ctx.fillText(yMax.toFixed(1), padding - 10, padding + 5);
            ctx.fillText(yMin.toFixed(1), padding - 10, height - padding + 5);

            // Add click handler (only once)
            if (!canvas.hasClickHandler) {
                canvas.hasClickHandler = true;
                canvas.addEventListener('click', handleCanvasClick);

                // Add change handler for tangent line checkbox
                document.getElementById('showTangent').addEventListener('change', () => {
                    if (originalExpr && derivativeExpr) {
                        drawGraph(originalExpr, derivativeExpr, currentVariable);
                    }
                });
            }
        }

        function loadExample(func) {
            document.getElementById('functionInput').value = func;
        }

        function generateRandom() {
            const examples = [
                'x^4 - 3*x^2 + 2',
                '5*x^3 + 2*x^2 - x + 7',
                'sin(2*x)',
                'cos(x)^2',
                'e^(2*x)',
                'ln(x^2)',
                'x*sin(x)',
                'e^x*cos(x)',
                '(x^2 + 1)/(x - 1)',
                'sqrt(x^2 + 1)',
                'tan(x)',
                'x^2*e^x',
                'sin(x)/x',
                'ln(x)/x',
                'x^3*cos(x)'
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
            const result = document.getElementById('derivativeResult').textContent;
            navigator.clipboard.writeText(result).then(() => {
                alert('Copied to clipboard!');
            });
        }

        function showError(message) {
            const container = document.getElementById('resultsContainer');
            container.innerHTML = `<div class="error-message">${message}</div>`;
            container.style.display = 'block';
        }

        // History Management
        function saveToHistory(func, variable, order, result) {
            let history = JSON.parse(localStorage.getItem('derivativeHistory') || '[]');
            history.unshift({
                function: func,
                variable: variable,
                order: order,
                result: result,
                timestamp: new Date().toISOString()
            });
            history = history.slice(0, 10); // Keep last 10
            localStorage.setItem('derivativeHistory', JSON.stringify(history));
            displayHistory();
        }

        function displayHistory() {
            const history = JSON.parse(localStorage.getItem('derivativeHistory') || '[]');
            const historyList = document.getElementById('historyList');
            const historySection = document.getElementById('historySection');

            if (history.length === 0) {
                historySection.style.display = 'none';
                return;
            }

            historySection.style.display = 'block';
            historyList.innerHTML = history.map((item, idx) => `
                <a href="#" class="list-group-item list-group-item-action" onclick="loadFromHistory(${idx}); return false;">
                    <strong>${escapeHtml(item.function)}</strong> → ${escapeHtml(item.result)}
                    <small class="text-muted d-block">${new Date(item.timestamp).toLocaleString()}</small>
                </a>
            `).join('');
        }

        function loadFromHistory(index) {
            const history = JSON.parse(localStorage.getItem('derivativeHistory') || '[]');
            const item = history[index];
            if (item) {
                document.getElementById('functionInput').value = item.function;
                document.getElementById('variableSelect').value = item.variable;
                document.getElementById('orderInput').value = item.order;
                calculateDerivative();
            }
        }

        function clearHistory() {
            if (confirm('Clear all calculation history?')) {
                localStorage.removeItem('derivativeHistory');
                displayHistory();
            }
        }

        // Copy LaTeX
        function copyLatex() {
            const resultElem = document.getElementById('derivativeResult');
            if (!resultElem) {
                alert('Please calculate a derivative first!');
                return;
            }

            // Extract LaTeX from the MathJax-rendered element
            let latex = resultElem.textContent.replace(/^\$\$|\$\$/g, '').trim();

            navigator.clipboard.writeText(latex).then(() => {
                alert('LaTeX code copied to clipboard!');
            }).catch(err => {
                console.error('Failed to copy:', err);
                alert('Failed to copy to clipboard');
            });
        }

        // Shareable URLs
        function shareCalculation() {
            const func = document.getElementById('functionInput').value;
            const variable = document.getElementById('variableSelect').value;
            const order = document.getElementById('orderInput').value;

            if (!func) {
                alert('Please enter a function first!');
                return;
            }

            const params = new URLSearchParams({
                f: func,
                v: variable,
                o: order
            });

            const shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();

            navigator.clipboard.writeText(shareUrl).then(() => {
                alert('Share link copied to clipboard!\n\n' + shareUrl);
            }).catch(err => {
                prompt('Copy this link:', shareUrl);
            });
        }

        // Load from URL on page load
        function loadFromURL() {
            const params = new URLSearchParams(window.location.search);
            if (params.has('f')) {
                document.getElementById('functionInput').value = params.get('f') || '';
                document.getElementById('variableSelect').value = params.get('v') || 'x';
                document.getElementById('orderInput').value = params.get('o') || '1';

                // Auto-calculate
                setTimeout(() => {
                    calculateDerivative();
                    // Show message
                    const msg = document.createElement('div');
                    msg.className = 'alert alert-info mt-3';
                    msg.innerHTML = '<i class="fas fa-link"></i> Loaded from shared link';
                    document.querySelector('.calc-card').insertBefore(msg, document.querySelector('.calc-card').firstChild);
                    setTimeout(() => msg.remove(), 3000);
                }, 500);
            }
        }

        // Helper function to escape HTML
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Handle canvas click for point evaluation
        function handleCanvasClick(e) {
            if (!originalExpr || !derivativeExpr) return;

            const canvas = graphCanvas;
            const rect = canvas.getBoundingClientRect();
            const padding = 40;
            const graphWidth = canvas.width - 2 * padding;

            // Convert click position to graph x coordinate
            const clickX = e.clientX - rect.left;
            const x = (clickX - padding) / graphWidth * (currentXMax - currentXMin) + currentXMin;

            try {
                const scope = {};
                scope[currentVariable] = x;
                const fx = originalExpr.compile().evaluate(scope);
                const fpx = derivativeExpr.compile().evaluate(scope);

                if (isFinite(fx) && isFinite(fpx)) {
                    clickedPoint = { x, fx, fpx };

                    // Update evaluation display
                    document.getElementById('evalX').textContent = x.toFixed(4);
                    document.getElementById('evalFX').textContent = fx.toFixed(4);
                    document.getElementById('evalFPrimeX').textContent = fpx.toFixed(4);
                    document.getElementById('pointEval').style.display = 'block';

                    // Redraw with point marker and tangent
                    drawGraph(originalExpr, derivativeExpr, currentVariable);
                }
            } catch (err) {
                console.error('Error evaluating point:', err);
            }
        }

        // Find critical points where f'(x) = 0
        function findCriticalPoints() {
            if (!originalExpr || !derivativeExpr) {
                alert('Please calculate a derivative first!');
                return;
            }

            const points = [];
            const step = (currentXMax - currentXMin) / 500;
            let prevFpx = null;

            // Find where derivative crosses zero or changes sign
            for (let x = currentXMin; x <= currentXMax; x += step) {
                try {
                    const scope = {};
                    scope[currentVariable] = x;
                    const fpx = derivativeExpr.compile().evaluate(scope);

                    if (isFinite(fpx)) {
                        // Check if very close to zero
                        if (Math.abs(fpx) < 0.01) {
                            // Verify it's not a duplicate
                            const isDuplicate = points.some(p => Math.abs(p.x - x) < step * 3);
                            if (!isDuplicate) {
                                // Calculate second derivative to classify
                                let type = 'saddle';
                                try {
                                    const secondDeriv = math.derivative(derivativeExpr, currentVariable);
                                    const fppx = secondDeriv.compile().evaluate(scope);
                                    if (isFinite(fppx)) {
                                        if (fppx > 0.01) type = 'min';
                                        else if (fppx < -0.01) type = 'max';
                                    }
                                } catch (e) {
                                    // Use first derivative sign change to classify
                                    if (prevFpx !== null) {
                                        if (prevFpx > 0 && fpx < 0) type = 'max';
                                        else if (prevFpx < 0 && fpx > 0) type = 'min';
                                    }
                                }

                                const fx = originalExpr.compile().evaluate(scope);
                                points.push({ x, fx, type });
                            }
                        }
                        // Check for sign change
                        else if (prevFpx !== null && prevFpx * fpx < 0) {
                            // Refine the zero crossing point
                            let x0 = x - step;
                            let x1 = x;
                            for (let i = 0; i < 10; i++) {
                                const xMid = (x0 + x1) / 2;
                                const scopeMid = {};
                                scopeMid[currentVariable] = xMid;
                                const fpxMid = derivativeExpr.compile().evaluate(scopeMid);
                                if (prevFpx * fpxMid < 0) {
                                    x1 = xMid;
                                } else {
                                    x0 = xMid;
                                }
                            }
                            const xCritical = (x0 + x1) / 2;

                            // Check not duplicate
                            const isDuplicate = points.some(p => Math.abs(p.x - xCritical) < step * 3);
                            if (!isDuplicate) {
                                const scopeCritical = {};
                                scopeCritical[currentVariable] = xCritical;
                                const fx = originalExpr.compile().evaluate(scopeCritical);

                                // Classify using second derivative
                                let type = 'saddle';
                                try {
                                    const secondDeriv = math.derivative(derivativeExpr, currentVariable);
                                    const fppx = secondDeriv.compile().evaluate(scopeCritical);
                                    if (isFinite(fppx)) {
                                        if (fppx > 0.01) type = 'min';
                                        else if (fppx < -0.01) type = 'max';
                                    }
                                } catch (e) {}

                                points.push({ x: xCritical, fx, type });
                            }
                        }

                        prevFpx = fpx;
                    }
                } catch (e) {
                    prevFpx = null;
                }
            }

            criticalPoints = points;

            // Display results
            if (points.length > 0) {
                const content = points.map(p => {
                    const typeLabel = p.type === 'max' ? 'Local Maximum' :
                                     p.type === 'min' ? 'Local Minimum' : 'Saddle Point';
                    return `<div class="critical-point-item ${p.type}">
                        <strong>${typeLabel}</strong><br>
                        x = ${p.x.toFixed(4)}, f(x) = ${p.fx.toFixed(4)}
                    </div>`;
                }).join('');

                document.getElementById('criticalPointsContent').innerHTML = content;
                document.getElementById('criticalPointsList').style.display = 'block';
            } else {
                document.getElementById('criticalPointsContent').innerHTML =
                    '<div class="text-muted">No critical points found in current view</div>';
                document.getElementById('criticalPointsList').style.display = 'block';
            }

            // Redraw graph with critical points
            drawGraph(originalExpr, derivativeExpr, currentVariable);
        }

        // Zoom functions
        function zoomIn() {
            if (!originalExpr || !derivativeExpr) return;

            const range = currentXMax - currentXMin;
            const center = (currentXMax + currentXMin) / 2;
            const newRange = range * 0.7; // Zoom in by 30%

            currentXMin = center - newRange / 2;
            currentXMax = center + newRange / 2;

            drawGraph(originalExpr, derivativeExpr, currentVariable);
        }

        function zoomOut() {
            if (!originalExpr || !derivativeExpr) return;

            const range = currentXMax - currentXMin;
            const center = (currentXMax + currentXMin) / 2;
            const newRange = range * 1.4; // Zoom out by 40%

            currentXMin = center - newRange / 2;
            currentXMax = center + newRange / 2;

            drawGraph(originalExpr, derivativeExpr, currentVariable);
        }

        function resetZoom() {
            if (!originalExpr || !derivativeExpr) return;

            currentXMin = -10;
            currentXMax = 10;

            drawGraph(originalExpr, derivativeExpr, currentVariable);
        }

        // Toggle syntax reference
        function toggleDerivSyntax() {
            const content = document.getElementById('derivSyntaxContent');
            const toggle = document.getElementById('derivSyntaxToggle');
            if (content.style.display === 'none') {
                content.style.display = 'block';
                toggle.textContent = '▼';
            } else {
                content.style.display = 'none';
                toggle.textContent = '▶';
            }
        }

        // Initialize on page load
        window.addEventListener('DOMContentLoaded', () => {
            displayHistory();
            loadFromURL();

            // Setup unsimplified toggle
            const showUnsimplifiedCheckbox = document.getElementById('showUnsimplified');
            if (showUnsimplifiedCheckbox) {
                showUnsimplifiedCheckbox.addEventListener('change', function() {
                    const unsimplifiedDiv = document.getElementById('unsimplifiedResult');
                    if (this.checked) {
                        unsimplifiedDiv.style.display = 'block';
                    } else {
                        unsimplifiedDiv.style.display = 'none';
                    }
                    // Re-render MathJax if needed
                    if (window.MathJax) {
                        MathJax.typesetPromise();
                    }
                });
            }
        });
    </script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
