<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FREE Taylor & Maclaurin Series Calculator - Step-by-Step Expansion | Power Series</title>
    <meta name="description" content="Free online Taylor and Maclaurin series calculator with step-by-step solutions. Calculate power series expansions for any function around any point. Interactive graphs show approximation convergence. Includes radius of convergence and common series.">
    <meta name="keywords" content="taylor series calculator, maclaurin series calculator, power series expansion, series approximation, radius of convergence, taylor polynomial, calculus calculator, step by step series, function approximation, polynomial expansion">
    <link rel="canonical" href="https://8gwifi.org/series-calculator.jsp">

    <!-- Open Graph -->
    <meta property="og:title" content="FREE Taylor & Maclaurin Series Calculator - Step-by-Step">
    <meta property="og:description" content="Calculate Taylor and Maclaurin series expansions with detailed step-by-step solutions and interactive visualization.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/series-calculator.jsp">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="FREE Taylor & Maclaurin Series Calculator">
    <meta name="twitter:description" content="Calculate Taylor and Maclaurin series expansions with detailed step-by-step solutions and interactive visualization.">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Taylor & Maclaurin Series Calculator",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "description": "Free online calculator for Taylor and Maclaurin series expansions with step-by-step solutions",
      "featureList": [
        "Taylor series expansion around any point",
        "Maclaurin series expansion (centered at 0)",
        "Step-by-step derivative calculations",
        "Power series representation",
        "Radius of convergence calculation",
        "Interactive graph comparison",
        "Function vs approximation visualization",
        "Multiple terms support (up to 20 terms)",
        "Common series library (e^x, sin(x), cos(x), ln(1+x))",
        "LaTeX output formatting",
        "Convergence analysis",
        "Copy results to clipboard",
        "Example function templates"
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
          "name": "What is the difference between Taylor and Maclaurin series?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "A Taylor series expands a function around any point a: f(x) = f(a) + f'(a)(x-a) + f''(a)(x-a)²/2! + ... A Maclaurin series is a special case where a=0: f(x) = f(0) + f'(0)x + f''(0)x²/2! + ..."
          }
        },
        {
          "@type": "Question",
          "name": "How do I calculate a Taylor series expansion?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Enter your function, select Taylor series, choose the center point a, and specify the number of terms. The calculator will compute successive derivatives at point a and construct the series: Σ(f⁽ⁿ⁾(a)/n!)(x-a)ⁿ"
          }
        },
        {
          "@type": "Question",
          "name": "What is the radius of convergence?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The radius of convergence R is the distance from the center point within which the Taylor series converges to the actual function. For |x-a| < R, the series converges; for |x-a| > R, it diverges."
          }
        },
        {
          "@type": "Question",
          "name": "What functions have known series expansions?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Common functions with known series: e^x = Σ(xⁿ/n!), sin(x) = Σ((-1)ⁿx^(2n+1)/(2n+1)!), cos(x) = Σ((-1)ⁿx^(2n)/(2n)!), ln(1+x) = Σ((-1)^(n+1)xⁿ/n), 1/(1-x) = Σxⁿ for |x|<1"
          }
        },
        {
          "@type": "Question",
          "name": "How many terms do I need for a good approximation?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "It depends on the function and desired accuracy. Near the center point, fewer terms (5-10) often suffice. For points farther from center or complex functions, more terms (15-20) may be needed. Check the interactive graph to see convergence."
          }
        }
      ]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Calculate Taylor and Maclaurin Series",
      "description": "Step-by-step guide to computing power series expansions",
      "step": [
        {
          "@type": "HowToStep",
          "position": 1,
          "name": "Enter Function",
          "text": "Type your function f(x) using standard notation (e.g., e^x, sin(x), x^2)"
        },
        {
          "@type": "HowToStep",
          "position": 2,
          "name": "Select Series Type",
          "text": "Choose Taylor series (around point a) or Maclaurin series (around 0)"
        },
        {
          "@type": "HowToStep",
          "position": 3,
          "name": "Set Center Point",
          "text": "For Taylor series, specify the center point a where the series is expanded"
        },
        {
          "@type": "HowToStep",
          "position": 4,
          "name": "Choose Number of Terms",
          "text": "Select how many terms (n) to include in the expansion (more terms = better approximation)"
        },
        {
          "@type": "HowToStep",
          "position": 5,
          "name": "Calculate",
          "text": "Click Calculate to see the series expansion with step-by-step derivatives"
        },
        {
          "@type": "HowToStep",
          "position": 6,
          "name": "Analyze Results",
          "text": "Review the series representation, radius of convergence, and interactive graph showing how the approximation compares to the original function"
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
          "name": "Taylor & Maclaurin Series Calculator",
          "item": "https://8gwifi.org/series-calculator.jsp"
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
        .term-badge {
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
        .convergence-box {
            background: #f0fff4;
            border-left: 4px solid #48bb78;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
        }
        .convergence-box h4 {
            color: #22543d;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .error-message {
            background: #fff5f5;
            border-left: 4px solid #f56565;
            padding: 15px;
            border-radius: 8px;
            color: #c53030;
            margin: 15px 0;
        }
        .center-input-container {
            display: none;
        }
        .center-input-container.active {
            display: block;
        }
        .series-formula {
            background: #fefcbf;
            border: 2px solid #f6e05e;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
            text-align: center;
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
                <h1>Taylor & Maclaurin Series Calculator</h1>
                <p>Expand functions into power series with step-by-step solutions</p>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="mb-4">
                        <label for="functionInput" class="form-label">Function f(x)</label>
                        <input type="text" class="form-control" id="functionInput"
                               placeholder="e.g., e^x, sin(x), cos(x), ln(1+x)"
                               value="e^x">
                        <small class="text-muted">Supported: +, -, *, /, ^, sin, cos, tan, exp, ln, log, sqrt</small>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-4">
                            <label for="seriesType" class="form-label">Series Type</label>
                            <select class="form-select" id="seriesType" onchange="toggleCenterPoint()">
                                <option value="maclaurin" selected>Maclaurin (a=0)</option>
                                <option value="taylor">Taylor (custom a)</option>
                            </select>
                        </div>
                        <div class="col-md-4 center-input-container" id="centerContainer">
                            <label for="centerPoint" class="form-label">Center Point (a)</label>
                            <input type="text" class="form-control" id="centerPoint"
                                   placeholder="e.g., 0, 1, pi" value="0">
                        </div>
                        <div class="col-md-4">
                            <label for="numTerms" class="form-label">Number of Terms (n)</label>
                            <input type="number" class="form-control" id="numTerms"
                                   min="1" max="20" value="5">
                        </div>
                    </div>

                    <button class="btn btn-calculate" onclick="calculateSeries()">
                        Calculate Series
                    </button>

                    <div class="example-buttons">
                        <button class="btn-example" onclick="loadExample('e^x', 'maclaurin', 5)">e^x</button>
                        <button class="btn-example" onclick="loadExample('sin(x)', 'maclaurin', 7)">sin(x)</button>
                        <button class="btn-example" onclick="loadExample('cos(x)', 'maclaurin', 7)">cos(x)</button>
                        <button class="btn-example" onclick="loadExample('ln(1+x)', 'maclaurin', 6)">ln(1+x)</button>
                        <button class="btn-example" onclick="loadExample('1/(1-x)', 'maclaurin', 6)">1/(1-x)</button>
                        <button class="btn-example" onclick="loadExample('sqrt(1+x)', 'maclaurin', 6)">√(1+x)</button>
                        <button class="btn-example" onclick="loadExample('tan(x)', 'maclaurin', 5)">tan(x)</button>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="info-box">
                        <h4>Series Formula</h4>
                        <p style="font-size: 0.9rem; margin-bottom: 10px;">
                            <strong>Taylor Series:</strong><br>
                            f(x) = Σ [f⁽ⁿ⁾(a)/n!] · (x-a)ⁿ
                        </p>
                        <p style="font-size: 0.9rem; margin-bottom: 0;">
                            <strong>Maclaurin Series:</strong><br>
                            f(x) = Σ [f⁽ⁿ⁾(0)/n!] · xⁿ
                        </p>
                    </div>

                    <div class="info-box" style="background: #fef5e7; border-left-color: #f39c12;">
                        <h4 style="color: #d68910;">Common Series</h4>
                        <ul style="font-size: 0.85rem; padding-left: 20px;">
                            <li>e<sup>x</sup> = Σ x<sup>n</sup>/n!</li>
                            <li>sin(x) = Σ (-1)<sup>n</sup>x<sup>2n+1</sup>/(2n+1)!</li>
                            <li>cos(x) = Σ (-1)<sup>n</sup>x<sup>2n</sup>/(2n)!</li>
                            <li>ln(1+x) = Σ (-1)<sup>n+1</sup>x<sup>n</sup>/n</li>
                            <li>1/(1-x) = Σ x<sup>n</sup>, |x|&lt;1</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div id="resultsContainer" style="display: none;">
                <div class="result-section">
                    <h3>Series Expansion</h3>
                    <div class="latex-output" id="originalFunction"></div>
                    <div class="series-formula" id="seriesFormula"></div>
                    <div class="latex-output" id="seriesResult"></div>
                    <button class="btn btn-secondary btn-sm mt-2" onclick="copyResult()">Copy Result</button>
                </div>

                <div class="result-section">
                    <h3 style="cursor: pointer;" onclick="toggleSteps()">
                        Step-by-Step Solution
                        <span id="stepsToggle" style="float: right; font-size: 0.8em;">▼ Show</span>
                    </h3>
                    <div id="stepsContainer" style="display: none;"></div>
                </div>

                <div class="result-section" id="convergenceSection">
                    <h3>Convergence Analysis</h3>
                    <div id="convergenceContainer"></div>
                </div>

                <div class="result-section">
                    <h3>Graph Comparison</h3>
                    <canvas id="graphCanvas"></canvas>
                    <div class="mt-2">
                        <small class="text-muted">
                            <span style="color: #667eea; font-weight: 600;">■</span> Original Function &nbsp;&nbsp;
                            <span style="color: #f56565; font-weight: 600;">■</span> Series Approximation
                        </small>
                    </div>
                    <div class="mt-3">
                        <label for="termSlider" class="form-label">Adjust terms to see convergence: <span id="termCount">5</span></label>
                        <input type="range" class="form-range" id="termSlider" min="1" max="20" value="5"
                               oninput="updateGraph(parseInt(this.value))">
                    </div>
                </div>

                <div class="result-section" style="background: #f0f9ff; border-left-color: #3b82f6;">
                    <h3 style="color: #1e40af;">Related Calculus Tools</h3>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="derivative-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Derivative Calculator</a>
                        <a href="integral-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Integral Calculator</a>
                        <a href="limit-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Limit Calculator</a>
                        <a href="math-art-gallery.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Math Art Gallery</a>
                        <a href="linear-equations-solver.jsp" class="btn btn-sm btn-outline-primary mb-2">Equation Solver</a>
                    </div>
                    <p class="text-muted small mb-0 mt-2">Explore more calculus tools for complete mathematical analysis.</p>
                </div>
            </div>
        </div>
    </div>

    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/mathjs@11.11.0/lib/browser/math.min.js"></script>

    <script>
        let currentFunction = null;
        let currentCenter = 0;
        let currentVariable = 'x';
        let derivativesAtCenter = [];

        function toggleCenterPoint() {
            const type = document.getElementById('seriesType').value;
            const container = document.getElementById('centerContainer');
            if (type === 'taylor') {
                container.classList.add('active');
            } else {
                container.classList.remove('active');
                document.getElementById('centerPoint').value = '0';
            }
        }

        function factorial(n) {
            if (n === 0 || n === 1) return 1;
            let result = 1;
            for (let i = 2; i <= n; i++) {
                result *= i;
            }
            return result;
        }

        function calculateSeries() {
            const funcInput = document.getElementById('functionInput').value.trim();
            const seriesType = document.getElementById('seriesType').value;
            const numTerms = parseInt(document.getElementById('numTerms').value);
            const centerStr = document.getElementById('centerPoint').value.trim() || '0';

            if (!funcInput) {
                alert('Please enter a function');
                return;
            }

            try {
                // Parse center point
                currentCenter = math.evaluate(centerStr.replace(/\bpi\b/g, 'pi'));
                currentVariable = 'x';

                // Preprocess function input - convert ln to log for math.js
                const processedInput = funcInput
                    .replace(/\bln\(/g, 'log(')
                    .replace(/\bpi\b/g, 'pi');

                // Parse the function
                currentFunction = math.parse(processedInput);

                // Calculate derivatives at center point
                derivativesAtCenter = [];
                let derivative = currentFunction;

                for (let n = 0; n < numTerms; n++) {
                    // Evaluate derivative at center
                    const compiled = derivative.compile();
                    const scope = {};
                    scope[currentVariable] = currentCenter;
                    const value = compiled.evaluate(scope);
                    derivativesAtCenter.push(value);

                    // Calculate next derivative
                    if (n < numTerms - 1) {
                        derivative = math.derivative(derivative, currentVariable);
                    }
                }

                // Build steps
                const steps = buildSteps(numTerms);

                // Display results
                displayResults(funcInput, steps, numTerms, seriesType);

                // Draw graph
                drawGraph(numTerms);

                document.getElementById('resultsContainer').style.display = 'block';
                document.getElementById('termSlider').max = numTerms;
                document.getElementById('termSlider').value = numTerms;
                document.getElementById('termCount').textContent = numTerms;

            } catch (error) {
                showError('Error calculating series: ' + error.message);
            }
        }

        function buildSteps(numTerms) {
            const steps = [];
            let derivative = currentFunction;

            for (let n = 0; n < numTerms; n++) {
                const value = derivativesAtCenter[n];
                const factorialN = factorial(n);

                // Step: Show derivative calculation
                const derivativeNotation = n === 0 ? 'f' :
                                          n === 1 ? "f'" :
                                          n === 2 ? "f''" :
                                          n === 3 ? "f'''" :
                                          `f^{(${n})}`;

                steps.push({
                    step: n + 1,
                    description: n === 0 ?
                        `Evaluate function at x = ${currentCenter}` :
                        `Calculate ${getOrdinal(n)} derivative and evaluate at x = ${currentCenter}`,
                    latex: `${derivativeNotation}(${currentCenter}) = ${formatNumber(value)}`,
                    derivative: toLatex(derivative),
                    term: `\\frac{${formatNumber(value)}}{${factorialN}}${n === 0 ? '' : n === 1 ? '(x - ' + currentCenter + ')' : '(x - ' + currentCenter + ')^{' + n + '}'}`
                });

                // Calculate next derivative for display
                if (n < numTerms - 1) {
                    derivative = math.derivative(derivative, currentVariable);
                }
            }

            return steps;
        }

        function getOrdinal(n) {
            const ordinals = ['', '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th'];
            if (n < ordinals.length) return ordinals[n];
            return n + 'th';
        }

        function formatNumber(num) {
            if (Math.abs(num) < 0.0001 && num !== 0) {
                return num.toExponential(4);
            }
            if (Math.abs(num - Math.round(num)) < 0.0001) {
                return Math.round(num).toString();
            }
            return num.toFixed(6).replace(/\.?0+$/, '');
        }

        function toLatex(expr) {
            try {
                let latex = expr.toTex ? expr.toTex() : expr.toString();
                latex = latex.replace(/\\cdot/g, '\\,');
                latex = latex.replace(/\*\*/g, '^');
                // Convert log back to ln for display (math.js uses log for natural log)
                latex = latex.replace(/\\log/g, '\\ln');
                latex = latex.replace(/\blog\(/g, 'ln(');
                return latex;
            } catch (e) {
                return expr.toString();
            }
        }

        function displayResults(funcInput, steps, numTerms, seriesType) {
            // Display original function
            document.getElementById('originalFunction').innerHTML =
                `$$f(${currentVariable}) = ${toLatex(currentFunction)}$$`;

            // Display series formula
            const seriesName = seriesType === 'maclaurin' ? 'Maclaurin' : 'Taylor';
            const centerDisplay = currentCenter === 0 ? '0' : currentCenter;
            document.getElementById('seriesFormula').innerHTML = `
                <strong>${seriesName} Series around ${currentVariable} = ${centerDisplay}</strong>
            `;

            // Build series representation
            let seriesLatex = '';
            for (let n = 0; n < numTerms; n++) {
                const value = derivativesAtCenter[n];
                const factorialN = factorial(n);
                const coefficient = value / factorialN;

                if (n > 0 && coefficient >= 0) {
                    seriesLatex += ' + ';
                } else if (n > 0) {
                    seriesLatex += ' ';
                }

                if (n === 0) {
                    seriesLatex += formatNumber(coefficient);
                } else {
                    const coeffStr = Math.abs(coefficient) === 1 ? (coefficient < 0 ? '-' : '') : formatNumber(coefficient);
                    const xTerm = currentCenter === 0 ? currentVariable : `(${currentVariable} - ${currentCenter})`;
                    const power = n === 1 ? '' : `^{${n}}`;
                    seriesLatex += `${coeffStr}${xTerm}${power}`;
                }
            }

            seriesLatex += ' + \\cdots';

            // Display series result
            document.getElementById('seriesResult').innerHTML =
                `$$f(${currentVariable}) \\approx ${seriesLatex}$$`;

            // Display steps
            let stepsHtml = '';
            for (let step of steps) {
                const termHtml = `<span class="term-badge">Term ${step.step}</span>`;
                stepsHtml += `
                    <div class="step-item">
                        <span class="step-number">${step.step}</span>
                        <strong>${step.description}</strong>
                        ${termHtml}
                        <div class="latex-output mt-2">
                            $$${step.latex}$$
                        </div>
                        ${step.derivative ? `<div style="font-size: 0.9rem; color: #718096; margin-top: 8px;">
                            Derivative: $$${step.derivative}$$
                        </div>` : ''}
                    </div>
                `;
            }
            document.getElementById('stepsContainer').innerHTML = stepsHtml;

            // Display convergence analysis
            displayConvergence();

            // Render MathJax
            if (window.MathJax) {
                MathJax.typesetPromise();
            }
        }

        function displayConvergence() {
            const funcStr = currentFunction.toString();
            let convergenceInfo = '';

            // Determine radius of convergence based on function type
            if (funcStr.includes('exp') || funcStr === 'e ^ x') {
                convergenceInfo = `
                    <div class="convergence-box">
                        <h4>Radius of Convergence: R = ∞</h4>
                        <p>The exponential function e<sup>x</sup> converges for all real numbers.</p>
                    </div>
                `;
            } else if (funcStr.includes('sin') || funcStr.includes('cos')) {
                convergenceInfo = `
                    <div class="convergence-box">
                        <h4>Radius of Convergence: R = ∞</h4>
                        <p>Trigonometric functions sin(x) and cos(x) converge for all real numbers.</p>
                    </div>
                `;
            } else if (funcStr.includes('ln')) {
                convergenceInfo = `
                    <div class="convergence-box">
                        <h4>Radius of Convergence: R = 1 (for ln(1+x))</h4>
                        <p>The series converges for -1 &lt; x ≤ 1.</p>
                    </div>
                `;
            } else if (funcStr.includes('1 / (1 - x)')) {
                convergenceInfo = `
                    <div class="convergence-box">
                        <h4>Radius of Convergence: R = 1</h4>
                        <p>The geometric series converges for |x| &lt; 1.</p>
                    </div>
                `;
            } else if (funcStr.includes('tan')) {
                convergenceInfo = `
                    <div class="convergence-box">
                        <h4>Radius of Convergence: R = π/2</h4>
                        <p>The tangent series converges within (-π/2, π/2).</p>
                    </div>
                `;
            } else {
                convergenceInfo = `
                    <div class="convergence-box">
                        <h4>Convergence Analysis</h4>
                        <p>The radius of convergence depends on the nearest singularity of the function. Use the ratio test or root test to determine R.</p>
                        <p style="margin-top: 10px; font-size: 0.9rem;"><strong>Ratio Test:</strong> R = lim(n→∞) |a<sub>n</sub>/a<sub>n+1</sub>|</p>
                    </div>
                `;
            }

            document.getElementById('convergenceContainer').innerHTML = convergenceInfo;
        }

        function drawGraph(maxTerms) {
            const canvas = document.getElementById('graphCanvas');
            const ctx = canvas.getContext('2d');
            const width = canvas.width = canvas.offsetWidth;
            const height = canvas.height = canvas.offsetHeight;

            ctx.clearRect(0, 0, width, height);

            // Setup coordinate system
            const xMin = currentCenter - 5;
            const xMax = currentCenter + 5;
            const padding = 40;
            const graphWidth = width - 2 * padding;
            const graphHeight = height - 2 * padding;

            // Compile original function
            const f = currentFunction.compile();

            // Find y range
            let yMin = Infinity, yMax = -Infinity;
            const points = 200;
            for (let i = 0; i < points; i++) {
                const x = xMin + (xMax - xMin) * i / points;
                try {
                    const scope = {};
                    scope[currentVariable] = x;
                    const y = f.evaluate(scope);
                    if (isFinite(y)) {
                        yMin = Math.min(yMin, y);
                        yMax = Math.max(yMax, y);
                    }
                } catch (e) {}
            }

            // Also check series approximation
            for (let i = 0; i < points; i++) {
                const x = xMin + (xMax - xMin) * i / points;
                const y = evaluateSeries(x, maxTerms);
                if (isFinite(y)) {
                    yMin = Math.min(yMin, y);
                    yMax = Math.max(yMax, y);
                }
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

            // X-axis
            const yZero = toScreenY(0);
            if (yZero >= padding && yZero <= height - padding) {
                ctx.beginPath();
                ctx.moveTo(padding, yZero);
                ctx.lineTo(width - padding, yZero);
                ctx.stroke();
            }

            // Y-axis
            const xZero = toScreenX(0);
            if (xZero >= padding && xZero <= width - padding) {
                ctx.beginPath();
                ctx.moveTo(xZero, padding);
                ctx.lineTo(xZero, height - padding);
                ctx.stroke();
            }

            // Mark center point
            const xCenter = toScreenX(currentCenter);
            if (xCenter >= padding && xCenter <= width - padding) {
                ctx.strokeStyle = '#fbbf24';
                ctx.lineWidth = 2;
                ctx.setLineDash([5, 5]);
                ctx.beginPath();
                ctx.moveTo(xCenter, padding);
                ctx.lineTo(xCenter, height - padding);
                ctx.stroke();
                ctx.setLineDash([]);
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
                    scope[currentVariable] = x;
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

            // Draw series approximation
            ctx.strokeStyle = '#f56565';
            ctx.lineWidth = 3;
            ctx.beginPath();
            started = false;
            for (let i = 0; i < points; i++) {
                const x = xMin + (xMax - xMin) * i / points;
                const y = evaluateSeries(x, maxTerms);
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
            }
            ctx.stroke();

            // Draw axis labels
            ctx.fillStyle = '#2d3748';
            ctx.font = '14px sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText(xMin.toFixed(1), padding, height - padding + 20);
            ctx.fillText(xMax.toFixed(1), width - padding, height - padding + 20);
            ctx.fillText(currentCenter.toFixed(1), xCenter, height - padding + 20);

            ctx.textAlign = 'right';
            ctx.fillText(yMax.toFixed(1), padding - 10, padding + 5);
            ctx.fillText(yMin.toFixed(1), padding - 10, height - padding + 5);
        }

        function evaluateSeries(x, numTerms) {
            let sum = 0;
            for (let n = 0; n < numTerms; n++) {
                const coefficient = derivativesAtCenter[n] / factorial(n);
                const power = Math.pow(x - currentCenter, n);
                sum += coefficient * power;
            }
            return sum;
        }

        function updateGraph(numTerms) {
            document.getElementById('termCount').textContent = numTerms;
            drawGraph(numTerms);
        }

        function loadExample(func, type, terms) {
            document.getElementById('functionInput').value = func;
            document.getElementById('seriesType').value = type;
            document.getElementById('numTerms').value = terms;
            toggleCenterPoint();
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
            const result = document.getElementById('seriesResult').textContent;
            navigator.clipboard.writeText(result).then(() => {
                alert('Copied to clipboard!');
            });
        }

        function showError(message) {
            const container = document.getElementById('resultsContainer');
            container.innerHTML = `<div class="error-message">${message}</div>`;
            container.style.display = 'block';
        }
    </script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
