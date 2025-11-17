<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FREE Limit Calculator - Step-by-Step Solutions | L'Hospital's Rule</title>
    <meta name="description" content="Free online limit calculator with step-by-step solutions. Calculate limits using direct substitution, L'Hospital's rule, and algebraic simplification. Supports one-sided and two-sided limits, including limits at infinity. Interactive graphs and LaTeX output.">
    <meta name="keywords" content="limit calculator, calculus limit, limit solver, L'Hospital's rule, indeterminate forms, one-sided limits, two-sided limits, limits at infinity, calculus calculator, step by step limits">
    <link rel="canonical" href="https://8gwifi.org/limit-calculator.jsp">

    <!-- Open Graph -->
    <meta property="og:title" content="FREE Limit Calculator - Step-by-Step Solutions">
    <meta property="og:description" content="Calculate limits with detailed step-by-step solutions. Supports L'Hospital's rule, algebraic simplification, and numerical approximation.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/limit-calculator.jsp">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="FREE Limit Calculator - Step-by-Step Solutions">
    <meta name="twitter:description" content="Calculate limits with detailed step-by-step solutions. Supports L'Hospital's rule, algebraic simplification, and numerical approximation.">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Limit Calculator",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "description": "Free online limit calculator with step-by-step solutions using direct substitution, L'Hospital's rule, and algebraic methods",
      "featureList": [
        "Two-sided limit calculation",
        "One-sided limits (left and right)",
        "Limits at infinity",
        "Direct substitution method",
        "L'Hospital's rule for indeterminate forms",
        "Algebraic simplification",
        "Factoring and cancellation",
        "Numerical approximation tables",
        "Indeterminate form detection (0/0, ∞/∞, etc.)",
        "Trigonometric limits",
        "Exponential and logarithmic limits",
        "Rational function limits",
        "Interactive function graphing",
        "LaTeX output formatting",
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
          "name": "How do I calculate limits step by step?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Enter your function (e.g., (x^2-1)/(x-1)), specify the limit point, and choose direction (two-sided, left, or right). The calculator will first try direct substitution. If it results in an indeterminate form like 0/0, it will apply algebraic simplification or L'Hospital's rule."
          }
        },
        {
          "@type": "Question",
          "name": "What are one-sided limits?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "A one-sided limit approaches from only one direction. Left limit (x→a⁻) approaches from values less than a. Right limit (x→a⁺) approaches from values greater than a. A two-sided limit exists only if both one-sided limits exist and are equal."
          }
        },
        {
          "@type": "Question",
          "name": "What is L'Hospital's rule?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "L'Hospital's rule states that for indeterminate forms 0/0 or ∞/∞, lim[f(x)/g(x)] = lim[f'(x)/g'(x)], where f'(x) and g'(x) are the derivatives of f(x) and g(x). The rule can be applied repeatedly until the limit can be evaluated."
          }
        },
        {
          "@type": "Question",
          "name": "What are indeterminate forms?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Indeterminate forms occur when direct substitution yields ambiguous results: 0/0, ∞/∞, 0·∞, ∞-∞, 0^0, 1^∞, or ∞^0. These require special techniques like algebraic manipulation, L'Hospital's rule, or series expansion to evaluate."
          }
        },
        {
          "@type": "Question",
          "name": "How do I calculate limits at infinity?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "For limits as x→∞ or x→-∞, enter 'infinity' or '-infinity' as the limit point. For rational functions, divide numerator and denominator by the highest power of x. Terms like 1/x approach 0 as x→∞."
          }
        }
      ]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Calculate Limits",
      "description": "Step-by-step guide to using the limit calculator",
      "step": [
        {
          "@type": "HowToStep",
          "position": 1,
          "name": "Enter Function",
          "text": "Type your function using standard notation (e.g., (x^2-1)/(x-1), sin(x)/x)"
        },
        {
          "@type": "HowToStep",
          "position": 2,
          "name": "Select Variable",
          "text": "Choose the variable (x, y, t, or u) that approaches the limit"
        },
        {
          "@type": "HowToStep",
          "position": 3,
          "name": "Enter Limit Point",
          "text": "Specify where the variable approaches (number, infinity, or -infinity)"
        },
        {
          "@type": "HowToStep",
          "position": 4,
          "name": "Choose Direction",
          "text": "Select two-sided, left (x→a⁻), or right (x→a⁺) limit"
        },
        {
          "@type": "HowToStep",
          "position": 5,
          "name": "Calculate",
          "text": "Click Calculate to see the limit with step-by-step solution"
        },
        {
          "@type": "HowToStep",
          "position": 6,
          "name": "View Results",
          "text": "Review direct substitution, indeterminate forms, simplification steps, and graph"
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
          "name": "Limit Calculator",
          "item": "https://8gwifi.org/limit-calculator.jsp"
        }
      ]
    }
    </script>

    <link href="css/bootstrap.min.css" rel="stylesheet">
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
            border-left: 3px solid #805ad5;
        }
        .step-number {
            display: inline-block;
            background: #805ad5;
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
            background: #667eea;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-left: 10px;
        }
        .indeterminate-badge {
            display: inline-block;
            background: #f56565;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-left: 10px;
        }
        .limit-result {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            font-size: 1.8rem;
            font-weight: 700;
            margin: 15px 0;
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
        .approximation-table {
            width: 100%;
            margin-top: 15px;
            border-collapse: collapse;
        }
        .approximation-table th {
            background: #667eea;
            color: white;
            padding: 10px;
            text-align: center;
            font-weight: 600;
        }
        .approximation-table td {
            padding: 8px;
            text-align: center;
            border: 1px solid #e2e8f0;
        }
        .approximation-table tr:nth-child(even) {
            background: #f7fafc;
        }
        .error-message {
            background: #fff5f5;
            border-left: 4px solid #f56565;
            padding: 15px;
            border-radius: 8px;
            color: #c53030;
            margin: 15px 0;
        }
        .direction-info {
            background: #fef5e7;
            border-left: 4px solid #f39c12;
            padding: 10px 15px;
            border-radius: 8px;
            margin: 10px 0;
            font-size: 0.95rem;
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
<%@ include file="math-menu-nav.jsp"%>
<div class="container mt-4">
        <div class="calc-card">
            <div class="calc-header">
                <h1>Limit Calculator</h1>
                <p>Calculate limits step-by-step with L'Hospital's rule and algebraic simplification</p>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="mb-4">
                        <label for="functionInput" class="form-label">Function f(x)</label>
                        <input type="text" class="form-control" id="functionInput"
                               placeholder="e.g., (x^2-1)/(x-1), sin(x)/x, (e^x-1)/x"
                               value="(x^2 - 1)/(x - 1)">
                        <small class="text-muted">Supported: +, -, *, /, ^, sin, cos, tan, exp, ln, log, sqrt, abs</small>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-4">
                            <label for="variableSelect" class="form-label">Variable</label>
                            <select class="form-select" id="variableSelect">
                                <option value="x" selected>x</option>
                                <option value="y">y</option>
                                <option value="t">t</option>
                                <option value="u">u</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="limitPoint" class="form-label">Limit Point</label>
                            <input type="text" class="form-control" id="limitPoint"
                                   placeholder="e.g., 0, 1, infinity" value="1">
                            <small class="text-muted">Use 'infinity' or '-infinity'</small>
                        </div>
                        <div class="col-md-4">
                            <label for="directionSelect" class="form-label">Direction</label>
                            <select class="form-select" id="directionSelect">
                                <option value="two-sided" selected>Two-sided</option>
                                <option value="left">Left (x→a⁻)</option>
                                <option value="right">Right (x→a⁺)</option>
                            </select>
                        </div>
                    </div>

                    <button class="btn btn-calculate" onclick="calculateLimit()">
                        Calculate Limit
                    </button>

                    <div class="example-buttons">
                        <button class="btn-example" onclick="loadExample('(x^2-1)/(x-1)', '1')">Factoring</button>
                        <button class="btn-example" onclick="loadExample('sin(x)/x', '0')">sin(x)/x</button>
                        <button class="btn-example" onclick="loadExample('(e^x-1)/x', '0')">Exponential</button>
                        <button class="btn-example" onclick="loadExample('(1-cos(x))/x^2', '0')">Trigonometric</button>
                        <button class="btn-example" onclick="loadExample('(x^2+3*x+2)/(x+1)', '-1')">Rational</button>
                        <button class="btn-example" onclick="loadExample('x^2/e^x', 'infinity')">Infinity</button>
                        <button class="btn-example" onclick="loadExample('(sqrt(x+1)-1)/x', '0')">Radical</button>
                        <button class="btn-example" onclick="generateRandom()">Random</button>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="info-box">
                        <h4 style="cursor: pointer; margin-bottom: 10px;" onclick="toggleLimitSyntax()">
                            Function Syntax Reference
                            <span id="limitSyntaxToggle" style="float: right; font-size: 0.8em;">▼</span>
                        </h4>
                        <div id="limitSyntaxContent" style="font-size: 0.85rem;">
                            <strong>Basic:</strong> <code>x^2</code>, <code>(x-1)/(x+1)</code>, <code>sqrt(x)</code>, <code>abs(x)</code><br>
                            <strong>Trig:</strong> <code>sin(x)</code>, <code>cos(x)</code>, <code>tan(x)</code>, <code>asin(x)</code><br>
                            <strong>Exp/Log:</strong> <code>e^x</code>, <code>exp(x)</code>, <code>ln(x)</code>, <code>log(x,b)</code><br>
                            <strong>Special:</strong> <code>infinity</code>, <code>-infinity</code>, <code>pi</code>
                        </div>
                    </div>

                    <div class="info-box" style="background: #fef5e7; border-left-color: #f39c12;">
                        <h4 style="color: #d68910; cursor: pointer; margin-bottom: 10px;" onclick="toggleIndeterminate()">
                            Indeterminate Forms
                            <span id="indeterminateToggle" style="float: right; font-size: 0.8em;">▼</span>
                        </h4>
                        <div id="indeterminateContent" style="font-size: 0.82rem;">
                            <strong>0/0</strong> - L'Hospital or factoring<br>
                            <strong>∞/∞</strong> - L'Hospital's rule<br>
                            <strong>0·∞</strong> - Rewrite as fraction<br>
                            <strong>∞-∞</strong> - Algebraic manipulation<br>
                            <strong>1^∞, 0^0, ∞^0</strong> - Use logarithms
                        </div>
                    </div>
                </div>
            </div>

            <div id="resultsContainer" style="display: none;">
                <div class="result-section">
                    <h3>Limit Result</h3>
                    <div class="latex-output" id="limitExpression"></div>
                    <div class="limit-result" id="limitValue"></div>
                    <button class="btn btn-secondary btn-sm mt-2" onclick="copyResult()">Copy Result</button>
                </div>

                <div class="result-section">
                    <h3 style="cursor: pointer;" onclick="toggleSteps()">
                        Step-by-Step Solution
                        <span id="stepsToggle" style="float: right; font-size: 0.8em;">▼ Show</span>
                    </h3>
                    <div id="stepsContainer" style="display: none;"></div>
                </div>

                <div class="result-section" id="approximationSection" style="display: none;">
                    <h3>Numerical Approximation</h3>
                    <p>Values of f(x) as x approaches the limit:</p>
                    <table class="approximation-table" id="approximationTable">
                        <thead>
                            <tr>
                                <th>x</th>
                                <th>f(x)</th>
                            </tr>
                        </thead>
                        <tbody id="approximationBody">
                        </tbody>
                    </table>
                </div>

                <div class="result-section">
                    <h3>Graph</h3>
                    <canvas id="graphCanvas"></canvas>
                    <div class="mt-2">
                        <small class="text-muted">
                            <span style="color: #667eea; font-weight: 600;">■</span> Function f(x) &nbsp;&nbsp;
                            <span style="color: #f56565; font-weight: 600;">●</span> Limit Point &nbsp;&nbsp;
                            <span style="color: #48bb78; font-weight: 600;">●</span> Limit Value
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Educational Content Section - Always Visible -->
        <div class="calc-card">
            <div class="result-section" style="background: #fefce8; border-left-color: #eab308;">
                <h3 style="color: #713f12;">📚 Understanding Limits</h3>

                <div style="margin-bottom: 20px;">
                    <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">What is a Limit?</h4>
                    <p style="line-height: 1.7; color: #3f3f46;">
                        A <strong>limit</strong> describes the value that a function approaches as the input approaches some value.
                        Limits are fundamental to calculus - they're the foundation for derivatives, integrals, and continuity.
                        The notation lim<sub>x→a</sub> f(x) = L means "as x gets closer to a, f(x) gets closer to L."
                    </p>
                </div>

                <div style="margin-bottom: 20px;">
                    <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Types of Limits</h4>

                    <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                        <strong style="color: #7c2d12;">1. Two-Sided Limit:</strong>
                        <p style="margin: 5px 0; color: #3f3f46;">lim<sub>x→a</sub> f(x) - Approaches from both left and right</p>
                        <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;">
                            <em>Exists only if left and right limits are equal. Example: lim<sub>x→2</sub> x² = 4</em>
                        </p>
                    </div>

                    <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                        <strong style="color: #7c2d12;">2. One-Sided Limits:</strong>
                        <p style="margin: 5px 0; color: #3f3f46;">
                            <strong>Left:</strong> lim<sub>x→a⁻</sub> f(x) - Approaches from values less than a<br>
                            <strong>Right:</strong> lim<sub>x→a⁺</sub> f(x) - Approaches from values greater than a
                        </p>
                        <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;">
                            <em>Useful for piecewise functions and discontinuities. Example: lim<sub>x→0⁻</sub> 1/x = -∞</em>
                        </p>
                    </div>

                    <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                        <strong style="color: #7c2d12;">3. Limits at Infinity:</strong>
                        <p style="margin: 5px 0; color: #3f3f46;">lim<sub>x→∞</sub> f(x) or lim<sub>x→-∞</sub> f(x)</p>
                        <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;">
                            <em>Describes end behavior. Example: lim<sub>x→∞</sub> 1/x = 0</em>
                        </p>
                    </div>
                </div>

                <div style="margin-bottom: 20px;">
                    <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Indeterminate Forms</h4>
                    <p style="line-height: 1.7; color: #3f3f46; margin-bottom: 10px;">
                        When direct substitution produces these forms, special techniques are required:
                    </p>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; margin-bottom: 10px;">
                        <div style="background: #fee2e2; padding: 12px; border-radius: 8px; border-left: 3px solid #ef4444;">
                            <strong style="color: #991b1b;">0/0</strong>
                            <p style="margin: 5px 0; font-size: 0.85rem; color: #7f1d1d;">Most common. Use factoring or L'Hospital</p>
                        </div>
                        <div style="background: #fed7aa; padding: 12px; border-radius: 8px; border-left: 3px solid #f59e0b;">
                            <strong style="color: #92400e;">∞/∞</strong>
                            <p style="margin: 5px 0; font-size: 0.85rem; color: #78350f;">Use L'Hospital's rule</p>
                        </div>
                        <div style="background: #fef3c7; padding: 12px; border-radius: 8px; border-left: 3px solid #eab308;">
                            <strong style="color: #854d0e;">0·∞</strong>
                            <p style="margin: 5px 0; font-size: 0.85rem; color: #713f12;">Rewrite as 0/0 or ∞/∞</p>
                        </div>
                        <div style="background: #e0e7ff; padding: 12px; border-radius: 8px; border-left: 3px solid #6366f1;">
                            <strong style="color: #3730a3;">∞-∞</strong>
                            <p style="margin: 5px 0; font-size: 0.85rem; color: #312e81;">Combine fractions or factor</p>
                        </div>
                        <div style="background: #ddd6fe; padding: 12px; border-radius: 8px; border-left: 3px solid #8b5cf6;">
                            <strong style="color: #5b21b6;">1^∞</strong>
                            <p style="margin: 5px 0; font-size: 0.85rem; color: #4c1d95;">Use e and logarithms</p>
                        </div>
                        <div style="background: #fbcfe8; padding: 12px; border-radius: 8px; border-left: 3px solid #ec4899;">
                            <strong style="color: #9f1239;">0^0, ∞^0</strong>
                            <p style="margin: 5px 0; font-size: 0.85rem; color: #881337;">Take logarithm</p>
                        </div>
                    </div>
                </div>

                <div style="margin-bottom: 20px;">
                    <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">L'Hospital's Rule</h4>
                    <div style="background: #e0f2fe; padding: 15px; border-radius: 8px; border-left: 3px solid #0284c7;">
                        <p style="line-height: 1.7; color: #0c4a6e; margin-bottom: 10px;">
                            <strong>If lim f(x)/g(x) gives 0/0 or ∞/∞, then:</strong><br>
                            lim<sub>x→a</sub> f(x)/g(x) = lim<sub>x→a</sub> f'(x)/g'(x)
                        </p>
                        <p style="line-height: 1.7; color: #0c4a6e; font-size: 0.9rem;">
                            Take derivatives of numerator and denominator separately (not quotient rule!). Can be applied repeatedly if needed.
                        </p>
                    </div>
                    <div style="background: white; padding: 15px; border-radius: 8px; margin-top: 10px;">
                        <strong style="color: #7c2d12;">Example:</strong>
                        <p style="margin: 5px 0; color: #3f3f46;">
                            lim<sub>x→0</sub> sin(x)/x = lim<sub>x→0</sub> cos(x)/1 = cos(0) = 1
                        </p>
                    </div>
                </div>

                <div style="margin-bottom: 20px;">
                    <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Limit Techniques</h4>

                    <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                        <strong style="color: #7c2d12;">1. Direct Substitution</strong>
                        <p style="margin: 5px 0; color: #3f3f46;">Simply plug in the value. Works if function is continuous at that point.</p>
                    </div>

                    <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                        <strong style="color: #7c2d12;">2. Factoring & Cancellation</strong>
                        <p style="margin: 5px 0; color: #3f3f46;">Factor numerator and denominator, cancel common terms.</p>
                        <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: (x²-1)/(x-1) = (x+1)(x-1)/(x-1) = x+1</em></p>
                    </div>

                    <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                        <strong style="color: #7c2d12;">3. Conjugate Multiplication</strong>
                        <p style="margin: 5px 0; color: #3f3f46;">Multiply by conjugate to eliminate radicals.</p>
                        <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: (√(x+1)-1)/x × (√(x+1)+1)/(√(x+1)+1)</em></p>
                    </div>

                    <div style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                        <strong style="color: #7c2d12;">4. Divide by Highest Power</strong>
                        <p style="margin: 5px 0; color: #3f3f46;">For limits at infinity, divide all terms by highest power of x.</p>
                        <p style="margin: 5px 0; font-size: 0.9rem; color: #71717a;"><em>Example: lim<sub>x→∞</sub> (3x²+5)/(2x²-1) → divide by x²</em></p>
                    </div>
                </div>

                <div style="margin-bottom: 20px;">
                    <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Special Limits to Remember</h4>
                    <div style="background: white; padding: 15px; border-radius: 8px;">
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 8px; font-weight: 600; color: #7c2d12;">Limit</td>
                                <td style="padding: 8px; font-weight: 600; color: #7c2d12;">Value</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 8px; color: #3f3f46;">lim<sub>x→0</sub> sin(x)/x</td>
                                <td style="padding: 8px; color: #3f3f46;">1</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 8px; color: #3f3f46;">lim<sub>x→0</sub> (1-cos(x))/x</td>
                                <td style="padding: 8px; color: #3f3f46;">0</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 8px; color: #3f3f46;">lim<sub>x→0</sub> (e<sup>x</sup>-1)/x</td>
                                <td style="padding: 8px; color: #3f3f46;">1</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 8px; color: #3f3f46;">lim<sub>x→∞</sub> (1 + 1/x)<sup>x</sup></td>
                                <td style="padding: 8px; color: #3f3f46;">e</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; color: #3f3f46;">lim<sub>x→∞</sub> (1 + k/x)<sup>x</sup></td>
                                <td style="padding: 8px; color: #3f3f46;">e<sup>k</sup></td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div>
                    <h4 style="color: #854d0e; font-size: 1.1rem; margin-bottom: 10px;">Continuity & Limits</h4>
                    <p style="line-height: 1.7; color: #3f3f46; margin-bottom: 10px;">
                        A function f(x) is <strong>continuous at x = a</strong> if:
                    </p>
                    <ul style="line-height: 1.8; color: #3f3f46;">
                        <li>f(a) exists (the function is defined at a)</li>
                        <li>lim<sub>x→a</sub> f(x) exists (the limit exists)</li>
                        <li>lim<sub>x→a</sub> f(x) = f(a) (the limit equals the function value)</li>
                    </ul>
                    <p style="line-height: 1.7; color: #3f3f46; margin-top: 10px;">
                        <strong>Types of Discontinuities:</strong>
                    </p>
                    <ul style="line-height: 1.8; color: #3f3f46;">
                        <li><strong>Removable:</strong> Hole in graph (limit exists but ≠ f(a))</li>
                        <li><strong>Jump:</strong> Left and right limits exist but aren't equal</li>
                        <li><strong>Infinite:</strong> Function goes to ±∞ (vertical asymptote)</li>
                    </ul>
                </div>
            </div>

            <div class="result-section" style="background: #f0f9ff; border-left-color: #3b82f6;">
                <h3 style="color: #1e40af;">Related Calculus Tools</h3>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="derivative-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Derivative Calculator</a>
                        <a href="integral-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Integral Calculator</a>
                        <a href="series-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Taylor Series</a>
                        <a href="math-art-gallery.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Math Art Gallery</a>
                        <a href="linear-equations-solver.jsp" class="btn btn-sm btn-outline-primary mb-2">Equation Solver</a>
                    </div>
                    <p class="text-muted small mb-0 mt-2">Explore more calculus tools for complete mathematical analysis.</p>
                </div>
            </div>
        </div>

    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/mathjs@11.11.0/lib/browser/math.min.js"></script>

    <script>
        function calculateLimit() {
            const funcInput = document.getElementById('functionInput').value.trim();
            const variable = document.getElementById('variableSelect').value;
            const limitPointStr = document.getElementById('limitPoint').value.trim();
            const direction = document.getElementById('directionSelect').value;

            if (!funcInput) {
                alert('Please enter a function');
                return;
            }

            if (!limitPointStr) {
                alert('Please enter a limit point');
                return;
            }

            try {
                // Parse the function
                const expr = math.parse(funcInput);

                // Parse limit point
                let limitPoint;
                let isInfinity = false;
                let isNegInfinity = false;

                if (limitPointStr.toLowerCase() === 'infinity' || limitPointStr.toLowerCase() === 'inf') {
                    limitPoint = Infinity;
                    isInfinity = true;
                } else if (limitPointStr.toLowerCase() === '-infinity' || limitPointStr.toLowerCase() === '-inf') {
                    limitPoint = -Infinity;
                    isNegInfinity = true;
                } else {
                    limitPoint = math.evaluate(limitPointStr);
                }

                const steps = [];

                // Step 1: Show the limit expression
                const limitNotation = getLimitNotation(variable, limitPoint, isInfinity, isNegInfinity, direction);
                steps.push({
                    step: 1,
                    description: 'Set up the limit',
                    latex: `${limitNotation} ${toLatex(expr)}`,
                    method: 'Setup'
                });

                // Step 2: Try direct substitution
                let directSubResult = null;
                let isIndeterminate = false;
                let indeterminateForm = null;

                try {
                    if (!isInfinity && !isNegInfinity) {
                        const scope = {};
                        scope[variable] = limitPoint;
                        directSubResult = expr.evaluate(scope);

                        if (isFinite(directSubResult)) {
                            steps.push({
                                step: 2,
                                description: `Direct substitution: substitute ${variable} = ${limitPoint}`,
                                latex: `f(${limitPoint}) = ${directSubResult.toFixed(6)}`,
                                method: 'Direct Substitution'
                            });
                        } else {
                            isIndeterminate = true;
                            indeterminateForm = classifyIndeterminate(directSubResult);
                        }
                    }
                } catch (e) {
                    isIndeterminate = true;
                    indeterminateForm = '0/0';
                }

                // Step 3: Handle indeterminate forms
                let limitValue = directSubResult;

                if (isIndeterminate || isInfinity || isNegInfinity) {
                    steps.push({
                        step: steps.length + 1,
                        description: `Indeterminate form detected: ${indeterminateForm || 'Limit at infinity'}`,
                        latex: indeterminateForm ? `\\text{Form: } ${indeterminateForm}` : '\\text{Evaluating at infinity}',
                        method: 'Indeterminate',
                        isIndeterminate: true
                    });

                    // Try to simplify algebraically
                    const simplified = tryAlgebraicSimplification(expr, variable, limitPoint);
                    if (simplified.success) {
                        steps.push({
                            step: steps.length + 1,
                            description: 'Algebraic simplification',
                            latex: `${toLatex(simplified.expr)}`,
                            method: 'Factoring/Cancellation'
                        });

                        // Try direct substitution on simplified expression
                        try {
                            const scope = {};
                            scope[variable] = limitPoint;
                            limitValue = simplified.expr.evaluate(scope);

                            steps.push({
                                step: steps.length + 1,
                                description: 'Substitute after simplification',
                                latex: `= ${isFinite(limitValue) ? limitValue.toFixed(6) : limitValue}`,
                                method: 'Evaluation'
                            });
                        } catch (e) {
                            limitValue = null;
                        }
                    }

                    // Try L'Hospital's rule for 0/0 or ∞/∞
                    if ((indeterminateForm === '0/0' || indeterminateForm === '\\infty/\\infty') && !simplified.success) {
                        try {
                            const lhospitalResult = applyLHospital(expr, variable, limitPoint);
                            if (lhospitalResult.success) {
                                steps.push({
                                    step: steps.length + 1,
                                    description: "Apply L'Hospital's rule: differentiate numerator and denominator",
                                    latex: `\\lim_{${variable} \\to ${formatLimitPoint(limitPoint, isInfinity, isNegInfinity)}} \\frac{f'(${variable})}{g'(${variable})} = ${toLatex(lhospitalResult.expr)}`,
                                    method: "L'Hospital's Rule"
                                });

                                // Evaluate the new limit
                                const scope = {};
                                scope[variable] = limitPoint;
                                limitValue = lhospitalResult.expr.evaluate(scope);

                                steps.push({
                                    step: steps.length + 1,
                                    description: 'Evaluate after L\'Hospital\'s rule',
                                    latex: `= ${isFinite(limitValue) ? limitValue.toFixed(6) : limitValue}`,
                                    method: 'Evaluation'
                                });
                            }
                        } catch (e) {
                            console.error('L\'Hospital failed:', e);
                        }
                    }

                    // If still can't compute, use numerical approximation
                    if (limitValue === null || !isFinite(limitValue)) {
                        limitValue = numericalLimit(expr, variable, limitPoint, direction, isInfinity, isNegInfinity);
                        steps.push({
                            step: steps.length + 1,
                            description: 'Numerical approximation',
                            latex: `\\approx ${limitValue.toFixed(6)}`,
                            method: 'Numerical Method'
                        });
                    }
                }

                // Create numerical approximation table
                const approximationData = createApproximationTable(expr, variable, limitPoint, direction, isInfinity, isNegInfinity);

                // Display results
                displayResults(expr, limitValue, steps, variable, limitPoint, direction, isInfinity, isNegInfinity, approximationData);

                // Draw graph
                drawGraph(expr, variable, limitPoint, limitValue, direction, isInfinity, isNegInfinity);

                document.getElementById('resultsContainer').style.display = 'block';

            } catch (error) {
                showError('Error calculating limit: ' + error.message);
            }
        }

        function getLimitNotation(variable, limitPoint, isInfinity, isNegInfinity, direction) {
            let arrow = '\\to';
            let point = formatLimitPoint(limitPoint, isInfinity, isNegInfinity);

            if (direction === 'left') {
                arrow = '\\to';
                point = point + '^-';
            } else if (direction === 'right') {
                arrow = '\\to';
                point = point + '^+';
            }

            return `\\lim_{${variable} ${arrow} ${point}}`;
        }

        function formatLimitPoint(point, isInfinity, isNegInfinity) {
            if (isInfinity) return '\\infty';
            if (isNegInfinity) return '-\\infty';
            return point;
        }

        function classifyIndeterminate(result) {
            if (isNaN(result)) return '0/0';
            if (!isFinite(result)) return '\\infty/\\infty';
            return 'Indeterminate';
        }

        function tryAlgebraicSimplification(expr, variable, limitPoint) {
            try {
                // Try to simplify the expression
                const simplified = math.simplify(expr);

                // Check if it's different from original
                if (simplified.toString() !== expr.toString()) {
                    return { success: true, expr: simplified };
                }
            } catch (e) {
                console.error('Simplification failed:', e);
            }

            return { success: false, expr: expr };
        }

        function applyLHospital(expr, variable, limitPoint) {
            try {
                const exprStr = expr.toString();

                // Check if it's a fraction
                if (exprStr.includes('/')) {
                    // Try to extract numerator and denominator
                    const parts = extractFraction(expr);
                    if (parts) {
                        // Differentiate numerator and denominator
                        const numeratorDerivative = math.derivative(parts.numerator, variable);
                        const denominatorDerivative = math.derivative(parts.denominator, variable);

                        // Create new fraction
                        const newExpr = math.parse(`(${numeratorDerivative.toString()}) / (${denominatorDerivative.toString()})`);
                        const simplified = math.simplify(newExpr);

                        return { success: true, expr: simplified };
                    }
                }
            } catch (e) {
                console.error('L\'Hospital application failed:', e);
            }

            return { success: false, expr: expr };
        }

        function extractFraction(expr) {
            try {
                if (expr.type === 'OperatorNode' && expr.op === '/') {
                    return {
                        numerator: expr.args[0],
                        denominator: expr.args[1]
                    };
                }
            } catch (e) {
                console.error('Fraction extraction failed:', e);
            }
            return null;
        }

        function numericalLimit(expr, variable, limitPoint, direction, isInfinity, isNegInfinity) {
            const f = expr.compile();
            let testPoints = [];

            if (isInfinity) {
                testPoints = [100, 1000, 10000, 100000];
            } else if (isNegInfinity) {
                testPoints = [-100, -1000, -10000, -100000];
            } else {
                const delta = 0.0001;
                if (direction === 'left') {
                    testPoints = [limitPoint - delta, limitPoint - delta/10, limitPoint - delta/100];
                } else if (direction === 'right') {
                    testPoints = [limitPoint + delta/100, limitPoint + delta/10, limitPoint + delta];
                } else {
                    testPoints = [
                        limitPoint - delta,
                        limitPoint - delta/10,
                        limitPoint + delta/10,
                        limitPoint + delta
                    ];
                }
            }

            let sum = 0;
            let count = 0;

            for (const point of testPoints) {
                try {
                    const scope = {};
                    scope[variable] = point;
                    const value = f.evaluate(scope);
                    if (isFinite(value)) {
                        sum += value;
                        count++;
                    }
                } catch (e) {
                    // Skip invalid points
                }
            }

            return count > 0 ? sum / count : NaN;
        }

        function createApproximationTable(expr, variable, limitPoint, direction, isInfinity, isNegInfinity) {
            const f = expr.compile();
            const data = [];

            let testPoints = [];
            if (isInfinity) {
                testPoints = [10, 50, 100, 500, 1000, 5000];
            } else if (isNegInfinity) {
                testPoints = [-10, -50, -100, -500, -1000, -5000];
            } else {
                const deltas = [0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001];
                if (direction === 'left') {
                    testPoints = deltas.map(d => limitPoint - d);
                } else if (direction === 'right') {
                    testPoints = deltas.map(d => limitPoint + d);
                } else {
                    // Two-sided: alternate between left and right
                    testPoints = [];
                    for (const d of deltas) {
                        testPoints.push(limitPoint - d);
                        testPoints.push(limitPoint + d);
                    }
                }
            }

            for (const point of testPoints) {
                try {
                    const scope = {};
                    scope[variable] = point;
                    const value = f.evaluate(scope);
                    data.push({ x: point, fx: value });
                } catch (e) {
                    data.push({ x: point, fx: 'undefined' });
                }
            }

            return data;
        }

        function toLatex(expr) {
            try {
                let latex = expr.toTex ? expr.toTex() : expr.toString();
                latex = latex.replace(/\\cdot/g, '\\,');
                latex = latex.replace(/\*\*/g, '^');
                return latex;
            } catch (e) {
                return expr.toString();
            }
        }

        function displayResults(expr, limitValue, steps, variable, limitPoint, direction, isInfinity, isNegInfinity, approximationData) {
            // Display limit expression
            const limitNotation = getLimitNotation(variable, limitPoint, isInfinity, isNegInfinity, direction);
            document.getElementById('limitExpression').innerHTML =
                `$$${limitNotation} ${toLatex(expr)}$$`;

            // Display limit value
            let limitDisplay = '';
            if (isFinite(limitValue)) {
                limitDisplay = limitValue.toFixed(6);
            } else if (limitValue === Infinity) {
                limitDisplay = '∞';
            } else if (limitValue === -Infinity) {
                limitDisplay = '-∞';
            } else {
                limitDisplay = 'Does Not Exist';
            }
            document.getElementById('limitValue').textContent = limitDisplay;

            // Display steps
            let stepsHtml = '';
            for (let i = 0; i < steps.length; i++) {
                const step = steps[i];
                const methodHtml = step.method ?
                    (step.isIndeterminate ?
                        `<span class="indeterminate-badge">${step.method}</span>` :
                        `<span class="method-badge">${step.method}</span>`) : '';
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

            // Display approximation table
            if (approximationData && approximationData.length > 0) {
                let tableHtml = '';
                for (const row of approximationData) {
                    const xFormatted = typeof row.x === 'number' ? row.x.toFixed(6) : row.x;
                    const fxFormatted = typeof row.fx === 'number' ?
                        (isFinite(row.fx) ? row.fx.toFixed(6) : row.fx.toString()) :
                        row.fx;
                    tableHtml += `
                        <tr>
                            <td>${xFormatted}</td>
                            <td>${fxFormatted}</td>
                        </tr>
                    `;
                }
                document.getElementById('approximationBody').innerHTML = tableHtml;
                document.getElementById('approximationSection').style.display = 'block';
            }

            // Add direction info if one-sided
            if (direction !== 'two-sided') {
                const directionText = direction === 'left' ?
                    `Approaching from the left (${variable} → ${formatLimitPoint(limitPoint, isInfinity, isNegInfinity)}⁻)` :
                    `Approaching from the right (${variable} → ${formatLimitPoint(limitPoint, isInfinity, isNegInfinity)}⁺)`;

                const directionInfo = `<div class="direction-info">${directionText}</div>`;
                document.getElementById('stepsContainer').insertAdjacentHTML('afterbegin', directionInfo);
            }

            // Render MathJax
            if (window.MathJax) {
                MathJax.typesetPromise();
            }
        }

        function drawGraph(expr, variable, limitPoint, limitValue, direction, isInfinity, isNegInfinity) {
            const canvas = document.getElementById('graphCanvas');
            const ctx = canvas.getContext('2d');
            const width = canvas.width = canvas.offsetWidth;
            const height = canvas.height = canvas.offsetHeight;

            ctx.clearRect(0, 0, width, height);

            // Setup coordinate system
            let xMin, xMax;
            if (isInfinity) {
                xMin = 0;
                xMax = 20;
            } else if (isNegInfinity) {
                xMin = -20;
                xMax = 0;
            } else {
                const range = Math.max(Math.abs(limitPoint) * 2, 10);
                xMin = limitPoint - range;
                xMax = limitPoint + range;
            }

            const padding = 40;
            const graphWidth = width - 2 * padding;
            const graphHeight = height - 2 * padding;

            // Compile function
            const f = expr.compile();

            // Find y range
            let yMin = Infinity, yMax = -Infinity;
            const points = 200;
            for (let i = 0; i < points; i++) {
                const x = xMin + (xMax - xMin) * i / points;
                // Skip the limit point to avoid discontinuity affecting scale
                if (!isInfinity && !isNegInfinity && Math.abs(x - limitPoint) < 0.01) continue;

                try {
                    const scope = {};
                    scope[variable] = x;
                    const y = f.evaluate(scope);
                    if (isFinite(y)) {
                        yMin = Math.min(yMin, y);
                        yMax = Math.max(yMax, y);
                    }
                } catch (e) {}
            }

            // Include limit value in range
            if (isFinite(limitValue)) {
                yMin = Math.min(yMin, limitValue);
                yMax = Math.max(yMax, limitValue);
            }

            // Add padding to y range
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

            // Draw limit point (vertical dashed line)
            if (!isInfinity && !isNegInfinity) {
                ctx.strokeStyle = '#f56565';
                ctx.lineWidth = 2;
                ctx.setLineDash([5, 5]);
                const xLimit = toScreenX(limitPoint);
                ctx.beginPath();
                ctx.moveTo(xLimit, padding);
                ctx.lineTo(xLimit, height - padding);
                ctx.stroke();
                ctx.setLineDash([]);
            }

            // Draw limit value point
            if (isFinite(limitValue) && !isInfinity && !isNegInfinity) {
                ctx.fillStyle = '#48bb78';
                ctx.beginPath();
                ctx.arc(toScreenX(limitPoint), toScreenY(limitValue), 6, 0, 2 * Math.PI);
                ctx.fill();
                ctx.strokeStyle = 'white';
                ctx.lineWidth = 2;
                ctx.stroke();
            }

            // Draw axis labels
            ctx.fillStyle = '#2d3748';
            ctx.font = '12px sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText(xMin.toFixed(1), padding, height - padding + 20);
            ctx.fillText(xMax.toFixed(1), width - padding, height - padding + 20);

            if (!isInfinity && !isNegInfinity) {
                ctx.fillText(limitPoint.toString(), toScreenX(limitPoint), height - padding + 20);
            }

            ctx.textAlign = 'right';
            ctx.fillText(yMax.toFixed(1), padding - 10, padding + 5);
            ctx.fillText(yMin.toFixed(1), padding - 10, height - padding + 5);
        }

        function loadExample(func, point) {
            document.getElementById('functionInput').value = func;
            document.getElementById('limitPoint').value = point;
        }

        function generateRandom() {
            const examples = [
                { func: '(x^2 - 4)/(x - 2)', point: '2' },
                { func: 'sin(x)/x', point: '0' },
                { func: '(e^x - 1)/x', point: '0' },
                { func: '(1 - cos(x))/x', point: '0' },
                { func: '(x^3 - 8)/(x - 2)', point: '2' },
                { func: '(sqrt(x + 1) - 1)/x', point: '0' },
                { func: 'tan(x)/x', point: '0' },
                { func: '(ln(x + 1))/x', point: '0' },
                { func: 'x/e^x', point: 'infinity' },
                { func: '(2*x^2 + 3)/(x^2 + 1)', point: 'infinity' },
                { func: '(x^2 + x - 2)/(x - 1)', point: '1' },
                { func: '(sin(2*x))/x', point: '0' },
                { func: 'x*ln(x)', point: '0' },
                { func: '(cos(x) - 1)/x^2', point: '0' }
            ];
            const random = examples[Math.floor(Math.random() * examples.length)];
            document.getElementById('functionInput').value = random.func;
            document.getElementById('limitPoint').value = random.point;
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
            const result = document.getElementById('limitValue').textContent;
            navigator.clipboard.writeText(result).then(() => {
                alert('Copied to clipboard!');
            });
        }

        function showError(message) {
            const container = document.getElementById('resultsContainer');
            container.innerHTML = `<div class="error-message">${message}</div>`;
            container.style.display = 'block';
        }

        // Toggle limit syntax reference
        function toggleLimitSyntax() {
            const content = document.getElementById('limitSyntaxContent');
            const toggle = document.getElementById('limitSyntaxToggle');
            if (content.style.display === 'none') {
                content.style.display = 'block';
                toggle.textContent = '▼';
            } else {
                content.style.display = 'none';
                toggle.textContent = '▶';
            }
        }

        // Toggle indeterminate forms reference
        function toggleIndeterminate() {
            const content = document.getElementById('indeterminateContent');
            const toggle = document.getElementById('indeterminateToggle');
            if (content.style.display === 'none') {
                content.style.display = 'block';
                toggle.textContent = '▼';
            } else {
                content.style.display = 'none';
                toggle.textContent = '▶';
            }
        }
    </script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
