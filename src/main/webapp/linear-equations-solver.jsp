<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Equation Solver - Linear, Matrix & Polynomial Systems | Step-by-Step</title>
  <meta name="description" content="Free online equation solver with step-by-step solutions. Solve Ax=b, AX=B, XA=B matrix equations, polynomial systems, least squares, overdetermined & underdetermined systems. Supports Gaussian elimination, LU decomposition, Newton-Raphson.">
  <meta name="keywords" content="equation solver, linear equations solver, matrix equation solver, polynomial system solver, system of equations, Gaussian elimination, matrix equations, Ax=b solver, AX=B solver, XA=B solver, least squares, Newton-Raphson, overdetermined, underdetermined, multiple right hand sides">
  <link rel="canonical" href="https://8gwifi.org/linear-equations-solver.jsp">

  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/linear-equations-solver.jsp">
  <meta property="og:title" content="FREE Equation Solver - Linear, Matrix & Polynomial Systems">
  <meta property="og:description" content="Solve Ax=b, AX=B, XA=B matrix equations and polynomial systems with step-by-step solutions. Free online tool with Gaussian elimination, least squares, and Newton-Raphson methods.">
  <meta property="og:image" content="https://8gwifi.org/images/equation-solver-preview.png">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/linear-equations-solver.jsp">
  <meta property="twitter:title" content="FREE Equation Solver - Linear, Matrix & Polynomial Systems">
  <meta property="twitter:description" content="Solve Ax=b, AX=B, XA=B matrix equations and polynomial systems with step-by-step solutions.">
  <meta property="twitter:image" content="https://8gwifi.org/images/equation-solver-preview.png">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Equation Solver - Linear, Matrix & Polynomial Systems",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free online equation solver supporting Ax=b linear systems, AX=B and XA=B matrix equations, and polynomial systems. Features step-by-step solutions using Gaussian elimination, LU decomposition, Cramer's rule, least squares, and Newton-Raphson methods.",
    "url": "https://8gwifi.org/linear-equations-solver.jsp",
    "featureList": [
      "Linear system solver (Ax = b)",
      "Matrix equation solver (AX = B, XA = B)",
      "Polynomial system solver (Newton-Raphson)",
      "Gaussian elimination with steps",
      "Gauss-Jordan RREF",
      "LU decomposition",
      "Cramer's rule",
      "Matrix inverse method",
      "Least squares for overdetermined systems",
      "Support for underdetermined systems",
      "Step-by-step solutions",
      "LaTeX mathematical notation",
      "Random example generator",
      "Share URL functionality",
      "2D visualization for 2×2 systems"
    ],
    "screenshot": "https://8gwifi.org/images/equation-solver-screenshot.png",
    "softwareVersion": "2.0",
    "datePublished": "2024-01-15",
    "dateModified": "2025-01-12",
    "author": {
      "@type": "Organization",
      "name": "8gwifi.org",
      "url": "https://8gwifi.org"
    },
    "publisher": {
      "@type": "Organization",
      "name": "8gwifi.org",
      "logo": {
        "@type": "ImageObject",
        "url": "https://8gwifi.org/images/logo.png"
      }
    },
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "ratingCount": "2547",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "HowTo",
    "name": "How to Solve Systems of Equations Online",
    "description": "Step-by-step guide to solving linear systems, matrix equations, and polynomial systems using our free online calculator.",
    "step": [
      {
        "@type": "HowToStep",
        "position": 1,
        "name": "Select Equation Type",
        "text": "Choose the type of equation to solve: Ax=b (linear system), AX=B (matrix equation), XA=B (left multiplication), or Polynomial System.",
        "url": "https://8gwifi.org/linear-equations-solver.jsp#step1"
      },
      {
        "@type": "HowToStep",
        "position": 2,
        "name": "Enter Matrix Dimensions",
        "text": "For linear/matrix equations, set the number of equations (m) and variables (n). For polynomial systems, select 2 or 3 variables.",
        "url": "https://8gwifi.org/linear-equations-solver.jsp#step2"
      },
      {
        "@type": "HowToStep",
        "position": 3,
        "name": "Input Your Equations",
        "text": "Enter your coefficient matrix A and constants b. Use text mode or grid mode for easy input. For polynomials, enter equations with =, one per line.",
        "url": "https://8gwifi.org/linear-equations-solver.jsp#step3"
      },
      {
        "@type": "HowToStep",
        "position": 4,
        "name": "Choose Solution Method",
        "text": "Select from Gaussian elimination, Gauss-Jordan, LU decomposition, Cramer's rule, matrix inverse, or least squares methods.",
        "url": "https://8gwifi.org/linear-equations-solver.jsp#step4"
      },
      {
        "@type": "HowToStep",
        "position": 5,
        "name": "Solve and View Steps",
        "text": "Click 'Solve System' to get the solution with detailed step-by-step explanations showing all intermediate calculations.",
        "url": "https://8gwifi.org/linear-equations-solver.jsp#step5"
      }
    ],
    "totalTime": "PT2M"
  }
  </script>

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": "What types of equations can this solver handle?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "This solver handles: (1) Linear systems Ax=b with square, overdetermined, or underdetermined matrices, (2) Matrix equations AX=B with multiple right-hand sides, (3) Left multiplication equations XA=B, and (4) Polynomial systems with 2-3 variables using Newton-Raphson method."
        }
      },
      {
        "@type": "Question",
        "name": "What solution methods are supported?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Available methods include: Gaussian elimination, Gauss-Jordan (RREF), LU decomposition, Cramer's rule, matrix inverse method, least squares for overdetermined systems, and Newton-Raphson for polynomial systems. Each method shows complete step-by-step solutions."
        }
      },
      {
        "@type": "Question",
        "name": "How do I solve an overdetermined system?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "For overdetermined systems (more equations than unknowns, m>n), use the Least Squares method. This finds the best fit solution that minimizes ||Ax-b||². The solver computes the normal equations A^T A x = A^T b and shows residual analysis."
        }
      },
      {
        "@type": "Question",
        "name": "Can I solve matrix equations with multiple right-hand sides?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Yes! Select 'AX = B (Matrix Equation)' type. Enter coefficient matrix A and right-hand side matrix B. The solver treats each column of B separately and combines results into solution matrix X."
        }
      },
      {
        "@type": "Question",
        "name": "How do polynomial systems work?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Select 'Polynomial System' type, enter equations like 'x^2 + y^2 = 25' and 'x + y = 7', provide an initial guess, and the solver uses Newton-Raphson method with numerical Jacobian to find solutions. Shows convergence progress and final verification."
        }
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
        "item": "https://8gwifi.org/math-tools"
      },
      {
        "@type": "ListItem",
        "position": 3,
        "name": "Equation Solver",
        "item": "https://8gwifi.org/linear-equations-solver.jsp"
      }
    ]
  }
  </script>
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
  <style>
    .lineq-solver .card-header{padding:.6rem .9rem;font-weight:600}
    .lineq-solver .card-body{padding:.7rem .9rem}
    .lineq-solver .result-card{border-left:4px solid #10b981;background:linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(16,185,129,0.1)}
    .lineq-solver .warning-card{border-left:4px solid #f59e0b;background:linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(245,158,11,0.1)}
    .lineq-solver .step-card{
      border-left:4px solid #6366f1;
      background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);
      padding:1rem 1.25rem;
      margin:0.75rem 0;
      border-radius:8px;
      box-shadow:0 1px 3px rgba(99,102,241,0.08);
      transition:all 0.2s ease;
    }
    .lineq-solver .step-card:hover{
      box-shadow:0 4px 12px rgba(99,102,241,0.15);
      transform:translateX(2px);
    }
    .lineq-solver .matrix-display{
      display:block;
      text-align:center;
      padding:0.75rem;
      margin:0.5rem 0;
      background:white;
      border-radius:6px;
      border:1px solid #e0e7ff;
    }
    .solution-badge{display:inline-flex;align-items:center;padding:0.3rem 0.8rem;border-radius:999px;font-size:0.9rem;margin:0.25rem;font-weight:600;background:#10b981;color:white}
    .step-number{
      display:inline-block;
      background:#6366f1;
      color:white;
      padding:0.2rem 0.6rem;
      border-radius:12px;
      font-size:0.85rem;
      font-weight:600;
      margin-right:0.5rem;
    }
    .step-description{
      font-size:0.95rem;
      color:#4b5563;
      line-height:1.6;
    }
    .matrix-display .MathJax_Preview,
    .matrix-display script[type^="math/tex"] {
      display: none !important;
    }

    .matrix-grid{
      display:inline-block;
      border:2px solid #6366f1;
      border-radius:8px;
      padding:12px;
      background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);
      box-shadow:0 2px 8px rgba(99,102,241,0.1);
    }
    .matrix-grid table{
      border-collapse:separate;
      border-spacing:4px;
      margin:0;
    }
    .matrix-grid input{
      width:60px;
      height:40px;
      text-align:center;
      border:2px solid #e0e7ff;
      border-radius:6px;
      font-size:0.95rem;
      font-weight:500;
      background:white;
      transition:all 0.2s ease;
    }
    .matrix-grid input:focus{
      outline:none;
      border-color:#6366f1;
      box-shadow:0 0 0 3px rgba(99,102,241,0.1);
      transform:scale(1.05);
    }
    .matrix-grid .grid-divider{
      border-left:2px solid #6366f1;
      padding-left:8px;
    }
    .matrix-grid .grid-label{
      font-weight:600;
      color:#6366f1;
      font-size:0.85rem;
      padding:4px 8px;
      background:white;
      border-radius:4px;
      margin-bottom:4px;
      display:inline-block;
    }

    @media (max-width: 767px) {
      .lineq-solver h1{font-size:1.5rem}
      .lineq-solver .card-header{font-size:0.95rem}
      .lineq-solver button{width:100%;margin:0.25rem 0}
      .lineq-solver .step-card{padding:0.75rem}
      .lineq-solver .matrix-display{padding:0.5rem;font-size:0.9em}
      .matrix-grid input{width:50px;height:36px;font-size:0.85rem}
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
<div class="container mt-4 lineq-solver">
  <h1 class="mb-2">Equation Solver (Ax = b, AX = B, XA = B, Polynomials)</h1>
  <p class="text-muted mb-3">Solve linear systems, matrix equations, and polynomial systems with step-by-step solutions.</p>

  <div class="row">
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header">Equation Input</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="equationType">Equation Type</label>
            <select id="equationType" class="form-control">
              <option value="Ax=b">Ax = b (Linear System)</option>
              <option value="AX=B">AX = B (Matrix Equation)</option>
              <option value="XA=B">XA = B (Left Multiplication)</option>
              <option value="polynomial">Polynomial System (2-3 vars)</option>
            </select>
            <small class="text-muted">Choose the type of equation to solve</small>
          </div>

          <div id="linearSystemInputs">
            <div class="form-group">
              <label>System Dimensions (m equations × n variables)</label>
              <div class="d-flex align-items-center">
                <input id="numEquations" type="number" min="1" max="8" class="form-control mr-1" value="3" style="flex:1" placeholder="m">
                <span class="mx-1">×</span>
                <input id="numVariables" type="number" min="1" max="8" class="form-control ml-1" value="3" style="flex:1" placeholder="n">
                <button id="btnRandom" class="btn btn-outline-info btn-sm ml-2" title="Generate random example">
                  <i class="fas fa-random"></i> Random
                </button>
              </div>
              <small class="text-muted" id="systemTypeHint">Square system (m = n)</small>
            </div>

          <div class="form-group">
            <div class="d-flex justify-content-between align-items-center mb-2">
              <label class="mb-0">Input Mode</label>
              <div class="btn-group btn-group-sm" role="group">
                <button type="button" id="btnTextMode" class="btn btn-outline-secondary active">
                  <i class="fas fa-keyboard"></i> Text
                </button>
                <button type="button" id="btnGridMode" class="btn btn-outline-secondary">
                  <i class="fas fa-th"></i> Grid
                </button>
              </div>
            </div>
          </div>

          <!-- Text Input Mode -->
          <div id="textInputMode">
            <div class="form-group">
              <label for="matrixA" id="labelMatrixA">Coefficient Matrix A</label>
              <textarea id="matrixA" class="form-control" rows="5" placeholder="Enter coefficients:
2 1 -1
-3 -1 2
-2 1 2"></textarea>
              <small class="text-muted" id="hintMatrixA">One row per line, space separated</small>
            </div>

            <div class="form-group" id="matrixBGroup">
              <label for="vectorB" id="labelMatrixB">Constants Vector b</label>
              <textarea id="vectorB" class="form-control" rows="3" placeholder="8
-11
-3"></textarea>
              <small class="text-muted" id="hintMatrixB">One value per line</small>
            </div>
          </div>

          <!-- Grid Input Mode -->
          <div id="gridInputMode" style="display:none">
            <div class="form-group">
              <label>Coefficient Matrix A and Vector b</label>
              <div id="matrixGrid" class="matrix-grid" style="overflow-x:auto"></div>
              <small class="text-muted">Enter values directly into the grid [A | b]</small>
            </div>
          </div>
          </div>

          <!-- Polynomial System Input -->
          <div id="polynomialInputs" style="display:none">
            <div class="form-group">
              <label for="numPolyVars">Number of Variables</label>
              <div class="d-flex align-items-center">
                <select id="numPolyVars" class="form-control mr-2" style="flex:1">
                  <option value="2">2 variables (x, y)</option>
                  <option value="3">3 variables (x, y, z)</option>
                </select>
                <button id="btnRandomPoly" class="btn btn-outline-info btn-sm" title="Generate random polynomial system">
                  <i class="fas fa-random"></i> Random
                </button>
              </div>
            </div>

            <div class="form-group">
              <label>Equations (one per line)</label>
              <textarea id="polynomialEquations" class="form-control" rows="6" placeholder="Enter equations like:
x^2 + y^2 = 25
x + y = 7

Supported: +, -, *, ^, parentheses
Examples: x^2, 2*x*y, (x+1)^2"></textarea>
              <small class="text-muted">Polynomial equations with =, one per line</small>
            </div>

            <div class="form-group">
              <label>Initial Guess</label>
              <input id="initialGuess" type="text" class="form-control" placeholder="1, 1 (comma separated)" value="1, 1">
              <small class="text-muted">Starting point for Newton-Raphson (comma separated)</small>
            </div>
          </div>

          <div class="form-group">
            <label for="methodSelect">Solution Method</label>
            <select id="methodSelect" class="form-control">
              <option value="gaussian">Gaussian Elimination (All systems)</option>
              <option value="gauss-jordan">Gauss-Jordan RREF (All systems)</option>
              <option value="least-squares">Least Squares (m > n)</option>
              <option value="lu">LU Decomposition (Square only)</option>
              <option value="cramer">Cramer's Rule (Square, n ≤ 3)</option>
              <option value="inverse">Matrix Inverse (Square only)</option>
            </select>
            <small class="text-muted" id="methodHint"></small>
          </div>

          <div class="form-group">
            <div class="custom-control custom-checkbox">
              <input type="checkbox" class="custom-control-input" id="showVerification" checked>
              <label class="custom-control-label" for="showVerification">Verify solution</label>
            </div>
            <div class="custom-control custom-checkbox">
              <input type="checkbox" class="custom-control-input" id="showVisualization" checked>
              <label class="custom-control-label" for="showVisualization">Show visualization (2D/3D)</label>
            </div>
          </div>

          <div class="d-flex flex-wrap">
            <button id="btnSolve" class="btn btn-primary btn-sm mr-2 mb-2">Solve System</button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm mb-2">Clear</button>
          </div>
          <div id="inputError" class="text-danger small mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Quick Examples</h5>
        <div class="card-body" id="examplesContainer">
          <!-- Examples will be shown/hidden based on equation type -->
          <div class="examples-group" id="examplesAxb">
            <strong class="d-block mb-2 text-primary">Ax = b Examples:</strong>
            <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="unique">Unique Solution (3×3)</button>
            <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="2d">2D System (Lines)</button>
            <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="overdetermined">Overdetermined (4×3)</button>
            <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="underdetermined">Underdetermined (2×3)</button>
          </div>
          <div class="examples-group" id="examplesAXB" style="display:none">
            <strong class="d-block mb-2 text-primary">AX = B Examples:</strong>
            <button class="btn btn-outline-success btn-sm btn-block mb-2" data-example="axb-multiple">Multiple RHS (3×3)</button>
            <button class="btn btn-outline-success btn-sm btn-block mb-2" data-example="axb-2rhs">Two Solutions (2×2)</button>
          </div>
          <div class="examples-group" id="examplesXAB" style="display:none">
            <strong class="d-block mb-2 text-primary">XA = B Examples:</strong>
            <button class="btn btn-outline-info btn-sm btn-block mb-2" data-example="xab-basic">Basic (3×3)</button>
            <button class="btn btn-outline-info btn-sm btn-block mb-2" data-example="xab-rect">Rectangular (2×3)</button>
          </div>
          <div class="examples-group" id="examplesPoly" style="display:none">
            <strong class="d-block mb-2 text-primary">Polynomial Examples:</strong>
            <button class="btn btn-outline-warning btn-sm btn-block mb-2" data-example="poly-circle">Circle & Line</button>
            <button class="btn btn-outline-warning btn-sm btn-block mb-2" data-example="poly-parabola">Two Parabolas</button>
            <button class="btn btn-outline-warning btn-sm btn-block mb-2" data-example="poly-3d">3D System</button>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-8 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header d-flex flex-wrap justify-content-between align-items-center">
          <span class="mb-1 mb-sm-0">Solution</span>
          <div>
            <button id="btnShareURL" class="btn btn-outline-primary btn-sm mr-1 mb-1" title="Copy URL to clipboard">
              <i class="fas fa-share-alt"></i> Share URL
            </button>
            <button id="btnDownloadImage" class="btn btn-outline-success btn-sm mb-1" title="Download result as image">
              <i class="fas fa-download"></i> Download Image
            </button>
          </div>
        </h5>
        <div class="card-body">
          <div id="resultArea" class="text-center text-muted">
            Enter a system of equations and click "Solve System" to see the solution.
          </div>
        </div>
      </div>

      <div class="card mb-3" id="visualizationCard" style="display:none">
        <h5 class="card-header">📊 Geometric Visualization</h5>
        <div class="card-body">
          <div id="visualizationArea" class="text-center">
            <canvas id="solutionCanvas" width="600" height="600" style="max-width:100%;border:1px solid #e5e7eb;border-radius:8px;background:#fff"></canvas>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Step-by-Step Solution</h5>
        <div class="card-body">
          <div id="stepsArea" class="text-muted">
            Detailed solution steps will appear here.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">About Linear Systems</h5>
        <div class="card-body small">
          <p><strong>System of Linear Equations:</strong><br>
          A system Ax = b where A is an m×n matrix, x is the unknown vector, and b is the constants vector.</p>

          <p><strong>System Types:</strong></p>
          <ul>
            <li><strong>Square (m = n):</strong> Same number of equations and variables</li>
            <li><strong>Overdetermined (m &gt; n):</strong> More equations than variables (use least squares)</li>
            <li><strong>Underdetermined (m &lt; n):</strong> Fewer equations than variables (infinite solutions)</li>
          </ul>

          <p><strong>Solution Types:</strong></p>
          <ul>
            <li><strong>Unique Solution:</strong> Exactly one solution exists</li>
            <li><strong>No Solution (Inconsistent):</strong> System has no solution (contradictory equations)</li>
            <li><strong>Infinite Solutions:</strong> System has infinitely many solutions (dependent equations)</li>
            <li><strong>Least Squares:</strong> Best fit solution minimizing ||Ax - b||² for overdetermined systems</li>
          </ul>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Calculus Tools</h5>
        <div class="card-body small">
          <div class="d-flex flex-wrap mb-2">
            <a href="derivative-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Derivative Calculator</a>
            <a href="integral-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Integral Calculator</a>
            <a href="limit-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Limit Calculator</a>
            <a href="series-calculator.jsp" class="btn btn-sm btn-outline-primary mb-2">Taylor Series</a>
          </div>
          <div class="text-muted">
            Explore calculus tools for derivatives, integrals, limits, and series expansion.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Matrix Tools</h5>
        <div class="card-body small">
          <div class="d-flex flex-wrap mb-2">
            <a href="matrix-rank-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-layer-group"></i> Matrix Rank
            </a>
            <a href="matrix-determinant-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-calculator"></i> Determinant
            </a>
            <a href="matrix-inverse-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-sync"></i> Matrix Inverse
            </a>
            <a href="matrix-power-calculator.jsp" class="btn btn-sm btn-outline-primary mb-2">
              <i class="fas fa-superscript"></i> Matrix Powers
            </a>
          </div>
          <div class="text-muted">
            Explore more matrix computation tools for complete linear algebra analysis.
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/dom-to-image-more@2.8.0/dist/dom-to-image-more.min.js"></script>
<script>
(function(){
  const equationType = document.getElementById('equationType');
  const linearSystemInputs = document.getElementById('linearSystemInputs');
  const polynomialInputs = document.getElementById('polynomialInputs');
  const numEquations = document.getElementById('numEquations');
  const numVariables = document.getElementById('numVariables');
  const systemTypeHint = document.getElementById('systemTypeHint');
  const methodHint = document.getElementById('methodHint');
  const labelMatrixA = document.getElementById('labelMatrixA');
  const labelMatrixB = document.getElementById('labelMatrixB');
  const hintMatrixA = document.getElementById('hintMatrixA');
  const hintMatrixB = document.getElementById('hintMatrixB');
  const matrixBGroup = document.getElementById('matrixBGroup');
  const matrixA = document.getElementById('matrixA');
  const vectorB = document.getElementById('vectorB');
  const polynomialEquations = document.getElementById('polynomialEquations');
  const numPolyVars = document.getElementById('numPolyVars');
  const initialGuess = document.getElementById('initialGuess');
  const methodSelect = document.getElementById('methodSelect');
  const verifyCheckbox = document.getElementById('showVerification');
  const visualizeCheckbox = document.getElementById('showVisualization');
  const btnSolve = document.getElementById('btnSolve');
  const btnClear = document.getElementById('btnClear');
  const btnRandom = document.getElementById('btnRandom');
  const btnRandomPoly = document.getElementById('btnRandomPoly');
  const btnTextMode = document.getElementById('btnTextMode');
  const btnGridMode = document.getElementById('btnGridMode');
  const textInputMode = document.getElementById('textInputMode');
  const gridInputMode = document.getElementById('gridInputMode');
  const matrixGrid = document.getElementById('matrixGrid');
  const resultArea = document.getElementById('resultArea');
  const stepsArea = document.getElementById('stepsArea');
  const visualizationCard = document.getElementById('visualizationCard');
  const solutionCanvas = document.getElementById('solutionCanvas');
  const inputError = document.getElementById('inputError');

  // Example containers
  const examplesAxb = document.getElementById('examplesAxb');
  const examplesAXB = document.getElementById('examplesAXB');
  const examplesXAB = document.getElementById('examplesXAB');
  const examplesPoly = document.getElementById('examplesPoly');

  let currentMode = 'text'; // 'text' or 'grid'
  let gridInputs = [];

  const EPS = 1e-10;

  // Switch between equation types
  function switchEquationType() {
    const eqType = equationType.value;

    // Hide all input sections
    linearSystemInputs.style.display = 'none';
    polynomialInputs.style.display = 'none';

    // Hide all example groups
    examplesAxb.style.display = 'none';
    examplesAXB.style.display = 'none';
    examplesXAB.style.display = 'none';
    examplesPoly.style.display = 'none';

    if(eqType === 'Ax=b') {
      linearSystemInputs.style.display = 'block';
      examplesAxb.style.display = 'block';
      labelMatrixA.textContent = 'Coefficient Matrix A';
      labelMatrixB.textContent = 'Constants Vector b';
      hintMatrixA.textContent = 'One row per line, space separated';
      hintMatrixB.textContent = 'One value per line';
      matrixA.rows = 5;
      vectorB.rows = 3;
      matrixA.placeholder = 'Enter coefficients:\n2 1 -1\n-3 -1 2\n-2 1 2';
      vectorB.placeholder = '8\n-11\n-3';
    } else if(eqType === 'AX=B') {
      linearSystemInputs.style.display = 'block';
      examplesAXB.style.display = 'block';
      labelMatrixA.textContent = 'Coefficient Matrix A';
      labelMatrixB.textContent = 'Right-Hand Matrix B';
      hintMatrixA.textContent = 'One row per line, space separated';
      hintMatrixB.textContent = 'Matrix B: one row per line, space separated';
      matrixA.rows = 5;
      vectorB.rows = 5;
      matrixA.placeholder = 'Enter matrix A:\n2 1 -1\n-3 -1 2\n-2 1 2';
      vectorB.placeholder = 'Enter matrix B:\n8 1\n-11 2\n-3 3';
    } else if(eqType === 'XA=B') {
      linearSystemInputs.style.display = 'block';
      examplesXAB.style.display = 'block';
      labelMatrixA.textContent = 'Matrix A (right side)';
      labelMatrixB.textContent = 'Matrix B (result)';
      hintMatrixA.textContent = 'Matrix A: one row per line';
      hintMatrixB.textContent = 'Matrix B: one row per line';
      matrixA.rows = 5;
      vectorB.rows = 5;
      matrixA.placeholder = 'Enter matrix A:\n2 1 -1\n-3 -1 2\n-2 1 2';
      vectorB.placeholder = 'Enter matrix B:\n5 2\n3 1';
    } else if(eqType === 'polynomial') {
      polynomialInputs.style.display = 'block';
      examplesPoly.style.display = 'block';
    }

    updateSystemTypeHint();
  }

  equationType.addEventListener('change', switchEquationType);

  // Update system type hint based on dimensions
  function updateSystemTypeHint() {
    const m = parseInt(numEquations.value);
    const n = parseInt(numVariables.value);

    if(m === n) {
      systemTypeHint.textContent = 'Square system (m = n) - may have unique, no, or infinite solutions';
      systemTypeHint.style.color = '#059669';
    } else if(m > n) {
      systemTypeHint.textContent = 'Overdetermined system (m > n) - use least squares for best fit';
      systemTypeHint.style.color = '#dc2626';
    } else {
      systemTypeHint.textContent = 'Underdetermined system (m < n) - infinite solutions expected';
      systemTypeHint.style.color = '#2563eb';
    }

    updateMethodHint();
  }

  // Update method hint based on system type and selected method
  function updateMethodHint() {
    const m = parseInt(numEquations.value);
    const n = parseInt(numVariables.value);
    const method = methodSelect.value;

    if(method === 'lu' || method === 'cramer' || method === 'inverse') {
      if(m !== n) {
        methodHint.textContent = '⚠ This method only works for square systems (m = n)';
        methodHint.style.color = '#dc2626';
      } else if(method === 'cramer' && n > 3) {
        methodHint.textContent = '⚠ Cramer\'s rule is only efficient for n ≤ 3';
        methodHint.style.color = '#d97706';
      } else {
        methodHint.textContent = '✓ Compatible with this system';
        methodHint.style.color = '#059669';
      }
    } else if(method === 'least-squares') {
      if(m <= n) {
        methodHint.textContent = '⚠ Least squares is typically used for overdetermined systems (m > n)';
        methodHint.style.color = '#d97706';
      } else {
        methodHint.textContent = '✓ Compatible with this overdetermined system';
        methodHint.style.color = '#059669';
      }
    } else {
      methodHint.textContent = '✓ Works with any system type';
      methodHint.style.color = '#059669';
    }
  }

  numEquations.addEventListener('change', updateSystemTypeHint);
  numEquations.addEventListener('input', updateSystemTypeHint);
  numVariables.addEventListener('change', updateSystemTypeHint);
  numVariables.addEventListener('input', updateSystemTypeHint);
  methodSelect.addEventListener('change', updateMethodHint);

  function smartFormat(num) {
    if(num === undefined || num === null || isNaN(num)) return '0';
    if(Math.abs(num) < EPS) return '0';
    if(Math.abs(num - Math.round(num)) < EPS) return Math.round(num).toString();
    return parseFloat(num.toFixed(3)).toString();
  }

  function parseMatrix(text, rows, cols) {
    const lines = text.trim().split('\n').filter(r => r.trim());

    // If rows is -1, infer from input
    if(rows === -1) {
      rows = lines.length;
    }

    if(lines.length !== rows) {
      throw new Error(`Expected ${rows} rows, got ${lines.length}`);
    }

    const matrix = [];
    for(let i = 0; i < rows; i++) {
      const entries = lines[i].trim().split(/[\s,]+/).filter(Boolean);

      // If cols is -1, infer from first row
      if(i === 0 && cols === -1) {
        cols = entries.length;
      }

      if(entries.length !== cols) {
        throw new Error(`Row ${i+1}: expected ${cols} entries, got ${entries.length}`);
      }

      const row = entries.map(e => {
        const num = parseFloat(e);
        if(!isFinite(num)) throw new Error(`Invalid number: ${e}`);
        return num;
      });
      matrix.push(row);
    }
    return matrix;
  }

  function parseVector(text, size) {
    const entries = text.trim().split(/[\s\n,]+/).filter(Boolean);
    if(entries.length !== size) {
      throw new Error(`Expected ${size} values, got ${entries.length}`);
    }
    return entries.map(e => {
      const num = parseFloat(e);
      if(!isFinite(num)) throw new Error(`Invalid number: ${e}`);
      return num;
    });
  }

  function formatAugmentedMatrix(aug) {
    const m = aug.length;
    const n = aug[0].length - 1;
    const rows = aug.map(row => {
      const left = row.slice(0, n).map(v => smartFormat(v));
      const right = smartFormat(row[n]);
      return [...left, '|', right].join(' & ');
    });
    return '\\left[\\begin{array}{' + 'c'.repeat(n) + '|c}' + rows.join(' \\\\ ') + '\\end{array}\\right]';
  }

  function formatVector(vec) {
    return '\\begin{bmatrix}' + vec.map(v => smartFormat(v)).join(' \\\\ ') + '\\end{bmatrix}';
  }

  function formatMatrix(mat) {
    const rows = mat.map(row => row.map(v => smartFormat(v)).join(' & '));
    return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}';
  }

  function cloneMatrix(mat) {
    return mat.map(row => [...row]);
  }

  function multiplyMatrices(A, B) {
    const m = A.length, n = B[0].length, p = B.length;
    const result = [];
    for(let i = 0; i < m; i++) {
      result[i] = [];
      for(let j = 0; j < n; j++) {
        let sum = 0;
        for(let k = 0; k < p; k++) {
          sum += A[i][k] * B[k][j];
        }
        result[i][j] = sum;
      }
    }
    return result;
  }

  function determinant(mat) {
    const n = mat.length;
    if(n === 1) return mat[0][0];
    if(n === 2) return mat[0][0] * mat[1][1] - mat[0][1] * mat[1][0];
    if(n === 3) {
      return mat[0][0] * (mat[1][1] * mat[2][2] - mat[1][2] * mat[2][1]) -
             mat[0][1] * (mat[1][0] * mat[2][2] - mat[1][2] * mat[2][0]) +
             mat[0][2] * (mat[1][0] * mat[2][1] - mat[1][1] * mat[2][0]);
    }
    return 0;
  }

  function invertMatrix(mat) {
    const n = mat.length;
    const A = cloneMatrix(mat);
    const I = [];
    for(let i = 0; i < n; i++) {
      I[i] = [];
      for(let j = 0; j < n; j++) {
        I[i][j] = i === j ? 1 : 0;
      }
    }

    for(let i = 0; i < n; i++) {
      let pivot = i;
      for(let k = i + 1; k < n; k++) {
        if(Math.abs(A[k][i]) > Math.abs(A[pivot][i])) pivot = k;
      }
      if(Math.abs(A[pivot][i]) < EPS) return null;

      if(pivot !== i) {
        [A[i], A[pivot]] = [A[pivot], A[i]];
        [I[i], I[pivot]] = [I[pivot], I[i]];
      }

      const pivotVal = A[i][i];
      for(let j = 0; j < n; j++) {
        A[i][j] /= pivotVal;
        I[i][j] /= pivotVal;
      }

      for(let k = 0; k < n; k++) {
        if(k !== i) {
          const factor = A[k][i];
          for(let j = 0; j < n; j++) {
            A[k][j] -= factor * A[i][j];
            I[k][j] -= factor * I[i][j];
          }
        }
      }
    }
    return I;
  }

  function verifySolution(A, x, b) {
    const result = [];
    for(let i = 0; i < A.length; i++) {
      let sum = 0;
      for(let j = 0; j < x.length; j++) {
        sum += A[i][j] * x[j];
      }
      result.push(sum);
    }

    let maxError = 0;
    for(let i = 0; i < b.length; i++) {
      maxError = Math.max(maxError, Math.abs(result[i] - b[i]));
    }

    return {computed: result, error: maxError};
  }

  function draw2DVisualization(A, b, solution) {
    const ctx = solutionCanvas.getContext('2d');
    const width = solutionCanvas.width;
    const height = solutionCanvas.height;
    const scale = 40;
    const centerX = width / 2;
    const centerY = height / 2;

    ctx.clearRect(0, 0, width, height);

    // Draw grid
    ctx.strokeStyle = '#e5e7eb';
    ctx.lineWidth = 1;
    for(let i = -10; i <= 10; i++) {
      ctx.beginPath();
      ctx.moveTo(centerX + i * scale, 0);
      ctx.lineTo(centerX + i * scale, height);
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo(0, centerY + i * scale);
      ctx.lineTo(width, centerY + i * scale);
      ctx.stroke();
    }

    // Draw axes
    ctx.strokeStyle = '#000';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(0, centerY);
    ctx.lineTo(width, centerY);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(centerX, 0);
    ctx.lineTo(centerX, height);
    ctx.stroke();

    // Draw lines
    const colors = ['#3b82f6', '#ef4444', '#10b981'];
    for(let i = 0; i < Math.min(A.length, 3); i++) {
      const [a, b_coef] = A[i];
      const c = b[i];

      ctx.strokeStyle = colors[i];
      ctx.lineWidth = 3;
      ctx.beginPath();

      if(Math.abs(b_coef) < EPS) {
        const x = c / a;
        ctx.moveTo(centerX + x * scale, 0);
        ctx.lineTo(centerX + x * scale, height);
      } else {
        for(let x = -15; x <= 15; x += 0.5) {
          const y = (c - a * x) / b_coef;
          const screenX = centerX + x * scale;
          const screenY = centerY - y * scale;
          if(x === -15) {
            ctx.moveTo(screenX, screenY);
          } else {
            ctx.lineTo(screenX, screenY);
          }
        }
      }
      ctx.stroke();
    }

    // Draw solution point
    if(solution) {
      ctx.fillStyle = '#7c3aed';
      ctx.beginPath();
      ctx.arc(centerX + solution[0] * scale, centerY - solution[1] * scale, 8, 0, 2 * Math.PI);
      ctx.fill();

      ctx.fillStyle = '#000';
      ctx.font = '14px sans-serif';
      ctx.fillText(`(${smartFormat(solution[0])}, ${smartFormat(solution[1])})`,
                   centerX + solution[0] * scale + 12,
                   centerY - solution[1] * scale - 12);
    }

    // Add legend
    ctx.font = '12px sans-serif';
    for(let i = 0; i < Math.min(A.length, 3); i++) {
      ctx.fillStyle = colors[i];
      ctx.fillText(`Equation ${i+1}`, 10, 20 + i * 20);
    }
  }

  // Build grid input interface for m×n systems
  function buildGrid(m, n) {
    gridInputs = [];
    let html = '<div class="text-center mb-2">';
    html += '<span class="grid-label">Matrix A (' + m + '×' + n + ')</span>';
    html += '<span class="grid-label ml-2">Vector b</span>';
    html += '</div>';
    html += '<table><tbody>';

    for(let i = 0; i < m; i++) {
      html += '<tr>';
      for(let j = 0; j < n; j++) {
        html += `<td><input type="number" step="any" id="grid_${i}_${j}" value="0" class="grid-input"></td>`;
      }
      html += `<td class="grid-divider"><input type="number" step="any" id="grid_${i}_b" value="0" class="grid-input"></td>`;
      html += '</tr>';
    }
    html += '</tbody></table>';
    matrixGrid.innerHTML = html;

    // Store references
    for(let i = 0; i < m; i++) {
      gridInputs[i] = [];
      for(let j = 0; j < n; j++) {
        gridInputs[i][j] = document.getElementById(`grid_${i}_${j}`);
      }
      gridInputs[i].push(document.getElementById(`grid_${i}_b`));
    }
  }

  // Sync grid to text
  function syncGridToText() {
    const m = parseInt(numEquations.value);
    const n = parseInt(numVariables.value);
    let aText = '';
    let bText = '';

    for(let i = 0; i < m; i++) {
      const row = [];
      for(let j = 0; j < n; j++) {
        row.push(gridInputs[i][j].value || '0');
      }
      aText += row.join(' ') + '\n';
      bText += (gridInputs[i][n].value || '0') + '\n';
    }

    matrixA.value = aText.trim();
    vectorB.value = bText.trim();
  }

  // Sync text to grid
  function syncTextToGrid() {
    const m = parseInt(numEquations.value);
    const n = parseInt(numVariables.value);
    try {
      const A = parseMatrix(matrixA.value, m, n);
      const b = parseVector(vectorB.value, m);

      for(let i = 0; i < m; i++) {
        for(let j = 0; j < n; j++) {
          if(gridInputs[i] && gridInputs[i][j]) {
            gridInputs[i][j].value = A[i][j];
          }
        }
        if(gridInputs[i] && gridInputs[i][n]) {
          gridInputs[i][n].value = b[i];
        }
      }
    } catch(err) {
      // Ignore parsing errors during sync
    }
  }

  // Random example generator for linear systems
  function generateRandom() {
    const m = parseInt(numEquations.value);
    const n = parseInt(numVariables.value);
    const A = [];
    const b = [];

    // Generate random coefficients between -10 and 10
    for(let i = 0; i < m; i++) {
      A[i] = [];
      for(let j = 0; j < n; j++) {
        A[i][j] = Math.floor(Math.random() * 21) - 10;
      }
      b[i] = Math.floor(Math.random() * 21) - 10;
    }

    // Update text inputs
    matrixA.value = A.map(row => row.join(' ')).join('\n');
    vectorB.value = b.join('\n');

    // Update grid if in grid mode
    if(currentMode === 'grid') {
      syncTextToGrid();
    }

    // Auto-solve
    setTimeout(() => solve(), 100);
  }

  // Random polynomial system generator
  function generateRandomPolynomial() {
    const numVars = parseInt(numPolyVars.value);
    const varNames = ['x', 'y', 'z'];
    const equations = [];

    if(numVars === 2) {
      // Generate 2D polynomial systems
      const patterns = [
        // Circle and line
        () => {
          const r = Math.floor(Math.random() * 10) + 10; // radius 10-20
          const a = Math.floor(Math.random() * 5) + 1;
          const b = Math.floor(Math.random() * 5) + 1;
          const c = Math.floor(Math.random() * 10) + 5;
          return [
            `x^2 + y^2 = ${r}`,
            `${a}*x + ${b}*y = ${c}`
          ];
        },
        // Two parabolas
        () => {
          const a1 = Math.floor(Math.random() * 3) + 1;
          const b1 = Math.floor(Math.random() * 5) - 2;
          const c1 = Math.floor(Math.random() * 5) + 1;
          const a2 = Math.floor(Math.random() * 3) + 1;
          const b2 = Math.floor(Math.random() * 5) + 1;
          return [
            `y = ${a1}*x^2 + ${b1}*x + ${c1}`,
            `y = ${a2}*x + ${b2}`
          ];
        },
        // Hyperbola and line
        () => {
          const k = Math.floor(Math.random() * 10) + 5;
          const a = Math.floor(Math.random() * 3) + 1;
          const b = Math.floor(Math.random() * 5) + 2;
          return [
            `x*y = ${k}`,
            `x + y = ${a + b}`
          ];
        }
      ];

      const pattern = patterns[Math.floor(Math.random() * patterns.length)];
      const eqs = pattern();
      polynomialEquations.value = eqs.join('\n');

      // Set initial guess based on expected solution range
      const guess = [Math.floor(Math.random() * 5) + 1, Math.floor(Math.random() * 5) + 1];
      initialGuess.value = guess.join(', ');

    } else if(numVars === 3) {
      // Generate 3D polynomial systems
      const patterns = [
        // Sphere, plane, and product
        () => {
          const r2 = Math.floor(Math.random() * 20) + 20; // r^2
          const a = Math.floor(Math.random() * 5) + 1;
          const b = Math.floor(Math.random() * 5) + 1;
          const c = Math.floor(Math.random() * 5) + 1;
          const d = Math.floor(Math.random() * 10) + 8;
          const k = Math.floor(Math.random() * 10) + 5;
          return [
            `x^2 + y^2 + z^2 = ${r2}`,
            `${a}*x + ${b}*y + ${c}*z = ${d}`,
            `x*y = ${k}`
          ];
        },
        // Three planes (simpler)
        () => {
          const a1 = Math.floor(Math.random() * 3) + 1;
          const b1 = Math.floor(Math.random() * 3) + 1;
          const c1 = Math.floor(Math.random() * 3) + 1;
          const d1 = Math.floor(Math.random() * 10) + 5;

          const a2 = Math.floor(Math.random() * 3) + 1;
          const b2 = Math.floor(Math.random() * 3) + 1;
          const c2 = Math.floor(Math.random() * 3) + 1;
          const d2 = Math.floor(Math.random() * 10) + 5;

          const k = Math.floor(Math.random() * 8) + 4;
          return [
            `${a1}*x + ${b1}*y + ${c1}*z = ${d1}`,
            `${a2}*x^2 + ${b2}*y = ${d2}`,
            `y*z = ${k}`
          ];
        }
      ];

      const pattern = patterns[Math.floor(Math.random() * patterns.length)];
      const eqs = pattern();
      polynomialEquations.value = eqs.join('\n');

      // Set initial guess
      const guess = [
        Math.floor(Math.random() * 3) + 1,
        Math.floor(Math.random() * 3) + 1,
        Math.floor(Math.random() * 3) + 1
      ];
      initialGuess.value = guess.join(', ');
    }

    // Auto-solve
    setTimeout(() => solve(), 100);
  }

  // Mode toggle functions
  function switchToTextMode() {
    if(currentMode === 'text') return;

    // Sync grid to text before switching
    syncGridToText();

    currentMode = 'text';
    textInputMode.style.display = 'block';
    gridInputMode.style.display = 'none';
    btnTextMode.classList.add('active');
    btnGridMode.classList.remove('active');
  }

  function switchToGridMode() {
    if(currentMode === 'grid') return;

    const m = parseInt(numEquations.value);
    const n = parseInt(numVariables.value);
    buildGrid(m, n);

    // Sync text to grid after building
    syncTextToGrid();

    currentMode = 'grid';
    textInputMode.style.display = 'none';
    gridInputMode.style.display = 'block';
    btnTextMode.classList.remove('active');
    btnGridMode.classList.add('active');
  }

  // Gauss-Jordan elimination (RREF)
  function solveGaussJordan(A, b) {
    const m = A.length;
    const n = A[0].length;
    const steps = [];
    const aug = A.map((row, i) => [...row, b[i]]);

    steps.push(`<span class="text-primary">Starting Gauss-Jordan Elimination (RREF)</span>`);
    steps.push(`<div class="matrix-display mt-2">$$${formatAugmentedMatrix(aug)}$$</div>`);

    let pivotRow = 0;
    for(let col = 0; col < n && pivotRow < m; col++) {
      let maxRow = pivotRow;
      for(let i = pivotRow + 1; i < m; i++) {
        if(Math.abs(aug[i][col]) > Math.abs(aug[maxRow][col])) maxRow = i;
      }
      if(Math.abs(aug[maxRow][col]) < EPS) continue;

      if(maxRow !== pivotRow) {
        [aug[maxRow], aug[pivotRow]] = [aug[pivotRow], aug[maxRow]];
        steps.push(`<span class="text-info">R${pivotRow+1} ↔ R${maxRow+1}</span>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatAugmentedMatrix(aug)}$$</div>`);
      }

      const pivotVal = aug[pivotRow][col];
      for(let j = 0; j <= n; j++) aug[pivotRow][j] /= pivotVal;
      steps.push(`<span class="text-secondary">R${pivotRow+1} = R${pivotRow+1}/${smartFormat(pivotVal)}</span>`);
      steps.push(`<div class="matrix-display mt-2">$$${formatAugmentedMatrix(aug)}$$</div>`);

      // Eliminate all rows (above and below)
      for(let i = 0; i < m; i++) {
        if(i === pivotRow) continue;
        const factor = aug[i][col];
        if(Math.abs(factor) > EPS) {
          for(let j = 0; j <= n; j++) aug[i][j] -= factor * aug[pivotRow][j];
          steps.push(`<span class="text-secondary">R${i+1} = R${i+1} - (${smartFormat(factor)})R${pivotRow+1}</span>`);
        }
      }
      steps.push(`<div class="matrix-display mt-2">$$${formatAugmentedMatrix(aug)}$$</div>`);
      pivotRow++;
    }

    steps.push(`<span class="text-success">Reduced Row Echelon Form (RREF) achieved</span>`);

    // Check inconsistency and determine solution type
    for(let i = 0; i < m; i++) {
      let allZeros = true;
      for(let j = 0; j < n; j++) {
        if(Math.abs(aug[i][j]) > EPS) { allZeros = false; break; }
      }
      if(allZeros && Math.abs(aug[i][n]) > EPS) {
        return { type: 'inconsistent', steps, message: `Row ${i+1}: 0 = ${smartFormat(aug[i][n])}` };
      }
    }

    const x = new Array(n).fill(0);
    for(let i = 0; i < Math.min(m, n); i++) {
      for(let j = 0; j < n; j++) {
        if(Math.abs(aug[i][j]) > EPS) {
          x[j] = aug[i][n];
          break;
        }
      }
    }

    return { type: 'unique', solution: x, steps };
  }

  // LU Decomposition method
  function solveLU(A, b) {
    const n = A.length;
    const steps = [];
    const L = Array(n).fill(0).map(() => Array(n).fill(0));
    const U = cloneMatrix(A);

    steps.push(`<span class="text-primary">LU Decomposition: A = LU</span>`);
    steps.push(`<div class="matrix-display mt-2">$$A = ${formatMatrix(A)}$$</div>`);

    for(let i = 0; i < n; i++) L[i][i] = 1;

    for(let k = 0; k < n; k++) {
      if(Math.abs(U[k][k]) < EPS) {
        return { type: 'inconsistent', steps: [], message: 'LU decomposition failed (zero pivot)' };
      }
      for(let i = k + 1; i < n; i++) {
        L[i][k] = U[i][k] / U[k][k];
        for(let j = k; j < n; j++) {
          U[i][j] -= L[i][k] * U[k][j];
        }
      }
    }

    steps.push(`<div class="matrix-display mt-2">$$L = ${formatMatrix(L)}$$</div>`);
    steps.push(`<div class="matrix-display mt-2">$$U = ${formatMatrix(U)}$$</div>`);

    // Forward substitution: Ly = b
    const y = new Array(n).fill(0);
    for(let i = 0; i < n; i++) {
      y[i] = b[i];
      for(let j = 0; j < i; j++) y[i] -= L[i][j] * y[j];
    }
    steps.push(`<span class="text-secondary">Forward substitution (Ly = b): y = ${formatVector(y)}</span>`);

    // Back substitution: Ux = y
    const x = new Array(n).fill(0);
    for(let i = n - 1; i >= 0; i--) {
      x[i] = y[i];
      for(let j = i + 1; j < n; j++) x[i] -= U[i][j] * x[j];
      x[i] /= U[i][i];
    }
    steps.push(`<span class="text-secondary">Back substitution (Ux = y): x = ${formatVector(x)}</span>`);

    return { type: 'unique', solution: x, steps };
  }

  // Cramer's Rule
  function solveCramer(A, b) {
    const n = A.length;
    const steps = [];

    if(n > 3) {
      return { type: 'inconsistent', steps: [], message: "Cramer's rule is only efficient for n ≤ 3" };
    }

    steps.push(`<span class="text-primary">Using Cramer's Rule</span>`);
    const detA = determinant(A);
    steps.push(`<div class="matrix-display mt-2">$$\\det(A) = ${smartFormat(detA)}$$</div>`);

    if(Math.abs(detA) < EPS) {
      return { type: 'inconsistent', steps, message: 'det(A) = 0, system has no unique solution' };
    }

    const x = [];
    for(let i = 0; i < n; i++) {
      const Ai = cloneMatrix(A);
      for(let j = 0; j < n; j++) Ai[j][i] = b[j];
      const detAi = determinant(Ai);
      x[i] = detAi / detA;
      steps.push(`<span class="text-secondary">x${i+1} = det(A${i+1})/det(A) = ${smartFormat(detAi)}/${smartFormat(detA)} = ${smartFormat(x[i])}</span>`);
    }

    return { type: 'unique', solution: x, steps };
  }

  // Matrix Inverse method
  function solveInverse(A, b) {
    const n = A.length;
    const steps = [];

    steps.push(`<span class="text-primary">Matrix Inverse Method: x = A⁻¹b</span>`);

    const detA = determinant(A);
    if(Math.abs(detA) < EPS) {
      return { type: 'inconsistent', steps, message: 'Matrix A is singular (det = 0)' };
    }

    const invA = invertMatrix(A);
    steps.push(`<div class="matrix-display mt-2">$$A^{-1} = ${formatMatrix(invA)}$$</div>`);

    const x = [];
    for(let i = 0; i < n; i++) {
      x[i] = 0;
      for(let j = 0; j < n; j++) {
        x[i] += invA[i][j] * b[j];
      }
    }

    steps.push(`<div class="matrix-display mt-2">$$x = A^{-1}b = ${formatVector(x)}$$</div>`);
    return { type: 'unique', solution: x, steps };
  }

  // Solve AX = B (matrix equation with multiple RHS)
  function solveAXB(A, B) {
    const m = A.length;    // rows of A
    const n = A[0].length; // cols of A = rows of X
    const p = B[0].length; // cols of B = cols of X
    const steps = [];

    steps.push(`<span class="text-primary">Solving AX = B (Matrix Equation)</span>`);
    steps.push(`<div class="text-secondary mt-2">A is ${m}×${n}, B is ${m}×${p}, solving for X (${n}×${p})</div>`);
    steps.push(`<div class="matrix-display mt-2">$$A = ${formatMatrix(A)}$$</div>`);
    steps.push(`<div class="matrix-display mt-2">$$B = ${formatMatrix(B)}$$</div>`);

    // Solve column by column: AX = B means A[x1 x2 ... xp] = [b1 b2 ... bp]
    // So we solve Ax_i = b_i for each column
    steps.push(`<div class="text-primary mt-3">Strategy: Solve Ax = b for each column of B</div>`);

    const X = Array(n).fill(0).map(() => Array(p).fill(0));
    const allSolutions = [];

    for(let col = 0; col < p; col++) {
      const b_col = B.map(row => row[col]);
      steps.push(`<div class="text-secondary mt-3"><strong>Column ${col + 1}:</strong> Solving Ax = b${col + 1}</div>`);
      steps.push(`<div class="matrix-display mt-2">$$b_{${col + 1}} = ${formatVector(b_col)}$$</div>`);

      const result = solveSystem(A, b_col);

      if(result.type !== 'unique') {
        return { type: 'inconsistent', steps, message: `Column ${col + 1} has no unique solution` };
      }

      // Store solution in column of X
      for(let row = 0; row < n; row++) {
        X[row][col] = result.solution[row];
      }

      allSolutions.push(result.solution);
      steps.push(`<div class="text-success mt-2">x${col + 1} = ${formatVector(result.solution)}</div>`);
    }

    steps.push(`<div class="text-success mt-4"><strong>Final Solution Matrix X:</strong></div>`);
    steps.push(`<div class="matrix-display mt-2">$$X = ${formatMatrix(X)}$$</div>`);

    return { type: 'matrix-solution', solution: X, steps };
  }

  // Solve XA = B (left multiplication)
  function solveXAB(A, B) {
    const nA = A.length;    // rows of A
    const kA = A[0].length; // cols of A
    const mB = B.length;    // rows of B = rows of X
    const pB = B[0].length; // cols of B = cols of A (required)
    const steps = [];

    steps.push(`<span class="text-primary">Solving XA = B (Left Multiplication)</span>`);
    steps.push(`<div class="text-secondary mt-2">A is ${nA}×${kA}, B is ${mB}×${pB}, solving for X (${mB}×${nA})</div>`);
    steps.push(`<div class="matrix-display mt-2">$$A = ${formatMatrix(A)}$$</div>`);
    steps.push(`<div class="matrix-display mt-2">$$B = ${formatMatrix(B)}$$</div>`);

    // Check dimension compatibility: For XA = B, we need X(m×n)·A(n×k) = B(m×k)
    // So cols of A must equal cols of B
    if(kA !== pB) {
      return { type: 'inconsistent', steps, message: `Dimension mismatch: A has ${kA} columns but B has ${pB} columns. For XA=B, cols(A) must equal cols(B).` };
    }

    // Strategy: Solve row by row
    // XA = B means each row of X multiplied by A gives corresponding row of B
    // For row i: x_i · A = b_i (where x_i is row i of X, b_i is row i of B)
    // This is equivalent to: A^T · x_i^T = b_i^T
    // So we solve: A^T · y = b_i for each row, where y = x_i^T

    steps.push(`<div class="text-primary mt-3">Strategy: Solve row-by-row</div>`);
    steps.push(`<div class="text-secondary">For each row i of X: x_i · A = b_i</div>`);
    steps.push(`<div class="text-secondary">Equivalent to: A^T · (x_i)^T = (b_i)^T</div>`);

    // Compute A^T
    const AT = Array(kA).fill(0).map(() => Array(nA).fill(0));
    for(let i = 0; i < nA; i++) {
      for(let j = 0; j < kA; j++) {
        AT[j][i] = A[i][j];
      }
    }
    steps.push(`<div class="matrix-display mt-2">$$A^T = ${formatMatrix(AT)}$$</div>`);

    const X = Array(mB).fill(0).map(() => Array(nA).fill(0));

    // Solve for each row of X
    for(let i = 0; i < mB; i++) {
      const b_row = B[i]; // row i of B as a vector
      steps.push(`<div class="text-secondary mt-3"><strong>Row ${i + 1}:</strong> Solving A^T y = b_{${i+1}}</div>`);
      steps.push(`<div class="matrix-display mt-2">$$b_{${i+1}} = ${formatVector(b_row)}$$</div>`);

      // Solve A^T · y = b_row
      const result = solveSystem(AT, b_row);

      if(result.type !== 'unique') {
        return { type: 'inconsistent', steps, message: `Row ${i + 1} has no unique solution` };
      }

      // Store solution as row i of X
      for(let j = 0; j < nA; j++) {
        X[i][j] = result.solution[j];
      }

      steps.push(`<div class="text-success mt-2">Row ${i+1} of X: (${result.solution.map(v => smartFormat(v)).join(', ')})</div>`);
    }

    steps.push(`<div class="text-success mt-4"><strong>Final Solution Matrix X:</strong></div>`);
    steps.push(`<div class="matrix-display mt-2">$$X = ${formatMatrix(X)}$$</div>`);

    return { type: 'matrix-solution', solution: X, steps };
  }

  // Polynomial system solver using Newton-Raphson
  function solvePolynomialSystem(equations, numVars, guess) {
    const steps = [];
    const varNames = ['x', 'y', 'z'];
    const maxIter = 20;
    const tolerance = 1e-8;

    steps.push(`<span class="text-primary">Solving Polynomial System using Newton-Raphson Method</span>`);
    steps.push(`<div class="text-secondary mt-2">Variables: ${varNames.slice(0, numVars).join(', ')}</div>`);
    steps.push(`<div class="text-secondary">Maximum iterations: ${maxIter}, Tolerance: ${tolerance}</div>`);

    // Parse equations into f(x) = 0 form
    const functions = [];
    steps.push(`<div class="text-primary mt-3"><strong>Equations (converted to f = 0 form):</strong></div>`);

    for(let i = 0; i < equations.length; i++) {
      const eq = equations[i];
      steps.push(`<div class="text-secondary">f${i+1}(${varNames.slice(0, numVars).join(',')}) = ${eq.left} - (${eq.right}) = 0</div>`);
      functions.push(eq);
    }

    // Initial guess
    let x = [...guess];
    steps.push(`<div class="text-primary mt-3"><strong>Initial Guess:</strong></div>`);
    steps.push(`<div class="matrix-display">$$(${varNames.slice(0, numVars).join(', ')}) = (${x.map(v => smartFormat(v)).join(', ')})$$</div>`);

    // Newton-Raphson iterations
    let converged = false;

    for(let iter = 0; iter < maxIter; iter++) {
      // Evaluate functions at current point
      const f = functions.map(eq => evaluatePolynomial(eq.left, x, numVars) - evaluatePolynomial(eq.right, x, numVars));

      // Check convergence
      const norm = Math.sqrt(f.reduce((sum, val) => sum + val * val, 0));

      if(iter % 3 === 0 || norm < tolerance || iter === maxIter - 1) {
        steps.push(`<div class="step-card mt-2"><strong>Iteration ${iter + 1}:</strong><br>` +
          `Current point: (${x.map(v => smartFormat(v)).join(', ')})<br>` +
          `Function values: (${f.map(v => smartFormat(v)).join(', ')})<br>` +
          `||f|| = ${smartFormat(norm)}</div>`);
      }

      if(norm < tolerance) {
        converged = true;
        steps.push(`<div class="text-success mt-3">✓ Converged after ${iter + 1} iterations!</div>`);
        break;
      }

      // Compute Jacobian matrix numerically
      const J = computeJacobian(functions, x, numVars);

      // Solve J * delta = -f
      const negF = f.map(v => -v);
      const deltaResult = solveSystem(J, negF);

      if(deltaResult.type !== 'unique') {
        return { type: 'inconsistent', steps, message: `Jacobian singular at iteration ${iter + 1}` };
      }

      // Update: x = x + delta
      const delta = deltaResult.solution;
      for(let i = 0; i < numVars; i++) {
        x[i] += delta[i];
      }
    }

    if(!converged) {
      steps.push(`<div class="text-warning mt-3">⚠ Did not converge after ${maxIter} iterations. Solution may be approximate.</div>`);
    }

    steps.push(`<div class="text-success mt-4"><strong>Final Solution:</strong></div>`);
    for(let i = 0; i < numVars; i++) {
      steps.push(`<div class="text-secondary">${varNames[i]} = ${smartFormat(x[i])}</div>`);
    }

    // Verify solution
    steps.push(`<div class="text-primary mt-3"><strong>Verification:</strong></div>`);
    for(let i = 0; i < functions.length; i++) {
      const left = evaluatePolynomial(functions[i].left, x, numVars);
      const right = evaluatePolynomial(functions[i].right, x, numVars);
      const residual = Math.abs(left - right);
      steps.push(`<div class="text-secondary">Equation ${i+1}: ${smartFormat(left)} ≈ ${smartFormat(right)} (error: ${residual.toExponential(3)})</div>`);
    }

    return { type: 'polynomial-solution', solution: x, converged, steps };
  }

  // Helper: Evaluate polynomial expression
  function evaluatePolynomial(expr, x, numVars) {
    const varNames = ['x', 'y', 'z'];
    let str = expr.toString();

    // Replace variables with values
    for(let i = 0; i < numVars; i++) {
      const regex = new RegExp(`\\b${varNames[i]}\\b`, 'g');
      str = str.replace(regex, `(${x[i]})`);
    }

    // Handle power operator
    str = str.replace(/\^/g, '**');

    // Evaluate
    try {
      return eval(str);
    } catch(e) {
      return NaN;
    }
  }

  // Helper: Compute Jacobian matrix numerically
  function computeJacobian(functions, x, numVars) {
    const n = functions.length;
    const J = Array(n).fill(0).map(() => Array(numVars).fill(0));
    const h = 1e-7;

    for(let i = 0; i < n; i++) {
      for(let j = 0; j < numVars; j++) {
        const xPlus = [...x];
        const xMinus = [...x];
        xPlus[j] += h;
        xMinus[j] -= h;

        const fPlus = evaluatePolynomial(functions[i].left, xPlus, numVars) - evaluatePolynomial(functions[i].right, xPlus, numVars);
        const fMinus = evaluatePolynomial(functions[i].left, xMinus, numVars) - evaluatePolynomial(functions[i].right, xMinus, numVars);

        J[i][j] = (fPlus - fMinus) / (2 * h);
      }
    }

    return J;
  }

  // Parse polynomial equations
  function parsePolynomialEquations(text, numVars) {
    const lines = text.trim().split('\n').filter(l => l.trim());
    const equations = [];

    for(const line of lines) {
      if(!line.includes('=')) {
        throw new Error(`Equation must contain '=': ${line}`);
      }

      const parts = line.split('=');
      if(parts.length !== 2) {
        throw new Error(`Invalid equation format: ${line}`);
      }

      equations.push({
        left: parts[0].trim(),
        right: parts[1].trim(),
        original: line.trim()
      });
    }

    if(equations.length < numVars) {
      throw new Error(`Need at least ${numVars} equations for ${numVars} variables`);
    }

    return equations.slice(0, numVars); // Use first numVars equations
  }

  // Least Squares method: solve A^T A x = A^T b
  function solveLeastSquares(A, b) {
    const m = A.length;  // number of equations
    const n = A[0].length;  // number of variables
    const steps = [];

    steps.push(`<span class="text-primary">Least Squares Solution: Minimizing ||Ax - b||²</span>`);
    steps.push(`<div class="text-secondary mt-2">System is overdetermined: ${m} equations, ${n} variables</div>`);
    steps.push(`<div class="matrix-display mt-2">$$A = ${formatMatrix(A)}$$</div>`);
    steps.push(`<div class="matrix-display mt-2">$$b = ${formatVector(b)}$$</div>`);

    // Compute A^T (transpose of A)
    const AT = Array(n).fill(0).map(() => Array(m).fill(0));
    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        AT[j][i] = A[i][j];
      }
    }
    steps.push(`<div class="text-primary mt-3">Step 1: Compute A^T (transpose)</div>`);
    steps.push(`<div class="matrix-display mt-2">$$A^T = ${formatMatrix(AT)}$$</div>`);

    // Compute A^T A (normal equations matrix)
    const ATA = Array(n).fill(0).map(() => Array(n).fill(0));
    for(let i = 0; i < n; i++) {
      for(let j = 0; j < n; j++) {
        for(let k = 0; k < m; k++) {
          ATA[i][j] += AT[i][k] * AT[j][k];
        }
      }
    }
    steps.push(`<div class="text-primary mt-3">Step 2: Compute A^T A (${n}×${n} normal matrix)</div>`);
    steps.push(`<div class="matrix-display mt-2">$$A^T A = ${formatMatrix(ATA)}$$</div>`);

    // Compute A^T b
    const ATb = Array(n).fill(0);
    for(let i = 0; i < n; i++) {
      for(let j = 0; j < m; j++) {
        ATb[i] += AT[i][j] * b[j];
      }
    }
    steps.push(`<div class="text-primary mt-3">Step 3: Compute A^T b</div>`);
    steps.push(`<div class="matrix-display mt-2">$$A^T b = ${formatVector(ATb)}$$</div>`);

    // Solve (A^T A) x = A^T b using Gaussian elimination
    steps.push(`<div class="text-primary mt-3">Step 4: Solve normal equations (A^T A)x = A^T b</div>`);

    const result = solveSystem(ATA, ATb);

    if(result.type !== 'unique') {
      return { type: 'inconsistent', steps, message: 'Normal equations could not be solved (A^T A may be singular)' };
    }

    const x = result.solution;
    steps.push(`<div class="text-success mt-2">Least squares solution found:</div>`);
    steps.push(`<div class="matrix-display mt-2">$$x = ${formatVector(x)}$$</div>`);

    // Compute residual ||Ax - b||
    const Ax = Array(m).fill(0);
    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        Ax[i] += A[i][j] * x[j];
      }
    }

    const residuals = Array(m).fill(0);
    let residualNorm = 0;
    for(let i = 0; i < m; i++) {
      residuals[i] = Ax[i] - b[i];
      residualNorm += residuals[i] * residuals[i];
    }
    residualNorm = Math.sqrt(residualNorm);

    steps.push(`<div class="text-primary mt-3">Step 5: Compute residual ||Ax - b||</div>`);
    steps.push(`<div class="matrix-display mt-2">$$Ax = ${formatVector(Ax)}$$</div>`);
    steps.push(`<div class="matrix-display mt-2">$$\\text{Residual} = Ax - b = ${formatVector(residuals)}$$</div>`);
    steps.push(`<div class="text-success mt-2">||Ax - b|| = ${smartFormat(residualNorm)}</div>`);

    return { type: 'least-squares', solution: x, residual: residualNorm, residuals, Ax, steps };
  }

  function solveSystem(A, b) {
    const m = A.length;
    const n = A[0].length;
    const steps = [];

    // Create augmented matrix [A | b]
    const aug = A.map((row, i) => [...row, b[i]]);

    steps.push(`<span class="text-primary">Starting with augmented matrix [A | b]</span>`);
    steps.push(`<div class="matrix-display mt-2">$$${formatAugmentedMatrix(aug)}$$</div>`);

    let pivotRow = 0;

    // Forward elimination
    for(let col = 0; col < n && pivotRow < m; col++) {
      // Find pivot
      let maxRow = pivotRow;
      for(let i = pivotRow + 1; i < m; i++) {
        if(Math.abs(aug[i][col]) > Math.abs(aug[maxRow][col])) {
          maxRow = i;
        }
      }

      // Skip if pivot is zero
      if(Math.abs(aug[maxRow][col]) < EPS) {
        steps.push(`<span class="text-secondary">Column ${col+1} has no pivot, skipping...</span>`);
        continue;
      }

      // Swap rows if needed
      if(maxRow !== pivotRow) {
        [aug[maxRow], aug[pivotRow]] = [aug[pivotRow], aug[maxRow]];
        steps.push(`<span class="text-info">Row swap: R${pivotRow+1} ↔ R${maxRow+1}</span>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatAugmentedMatrix(aug)}$$</div>`);
      }

      // Scale pivot row
      const pivotVal = aug[pivotRow][col];
      if(Math.abs(pivotVal - 1) > EPS) {
        for(let j = 0; j <= n; j++) {
          aug[pivotRow][j] /= pivotVal;
        }
        steps.push(`<span class="text-secondary">Scale R${pivotRow+1} by 1/${smartFormat(pivotVal)}</span>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatAugmentedMatrix(aug)}$$</div>`);
      }

      // Eliminate below
      let eliminated = [];
      for(let i = pivotRow + 1; i < m; i++) {
        const factor = aug[i][col];
        if(Math.abs(factor) > EPS) {
          eliminated.push(`R${i+1} = R${i+1} - (${smartFormat(factor)})R${pivotRow+1}`);
          for(let j = 0; j <= n; j++) {
            aug[i][j] -= factor * aug[pivotRow][j];
          }
        }
      }

      if(eliminated.length > 0) {
        steps.push(`<div class="text-secondary">${eliminated.join(', ')}</div>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatAugmentedMatrix(aug)}$$</div>`);
      }

      pivotRow++;
    }

    steps.push(`<span class="text-success">Row echelon form achieved</span>`);
    steps.push(`<div class="matrix-display mt-2 mb-3">$$${formatAugmentedMatrix(aug)}$$</div>`);

    // Check for inconsistency
    for(let i = 0; i < m; i++) {
      let allZeros = true;
      for(let j = 0; j < n; j++) {
        if(Math.abs(aug[i][j]) > EPS) {
          allZeros = false;
          break;
        }
      }
      if(allZeros && Math.abs(aug[i][n]) > EPS) {
        return {
          type: 'inconsistent',
          steps,
          message: `Row ${i+1} shows 0 = ${smartFormat(aug[i][n])}, which is impossible`
        };
      }
    }

    // Count pivots to determine solution type
    let pivotCount = 0;
    const pivotCols = [];
    for(let i = 0; i < m && i < n; i++) {
      for(let j = 0; j < n; j++) {
        if(Math.abs(aug[i][j]) > EPS) {
          pivotCount++;
          pivotCols.push(j);
          break;
        }
      }
    }

    if(pivotCount < n) {
      const freeCols = [];
      for(let j = 0; j < n; j++) {
        if(!pivotCols.includes(j)) freeCols.push(j);
      }
      return {
        type: 'infinite',
        steps,
        pivotCount,
        freeCols,
        aug
      };
    }

    // Back substitution for unique solution
    const x = new Array(n).fill(0);
    steps.push(`<span class="text-primary">Back substitution to find unique solution:</span>`);

    for(let i = Math.min(m, n) - 1; i >= 0; i--) {
      let pivotCol = -1;
      for(let j = 0; j < n; j++) {
        if(Math.abs(aug[i][j]) > EPS) {
          pivotCol = j;
          break;
        }
      }
      if(pivotCol === -1) continue;

      x[pivotCol] = aug[i][n];
      for(let j = pivotCol + 1; j < n; j++) {
        x[pivotCol] -= aug[i][j] * x[j];
      }

      steps.push(`<div class="text-secondary">x${pivotCol+1} = ${smartFormat(x[pivotCol])}</div>`);
    }

    return {
      type: 'unique',
      solution: x,
      steps
    };
  }

  function solve() {
    try {
      inputError.style.display = 'none';
      const eqType = equationType.value;

      // Handle polynomial systems differently
      if(eqType === 'polynomial') {
        const numVars = parseInt(numPolyVars.value);
        const guessText = initialGuess.value;
        const guess = guessText.split(',').map(v => parseFloat(v.trim()));

        if(guess.length !== numVars || guess.some(isNaN)) {
          throw new Error(`Initial guess must have ${numVars} numbers`);
        }

        const equations = parsePolynomialEquations(polynomialEquations.value, numVars);
        const result = solvePolynomialSystem(equations, numVars, guess);

        let html = '';
        if(result.type === 'polynomial-solution') {
          const varNames = ['x', 'y', 'z'];
          html = `
            <div class="result-card">
              <div class="mb-3">
                <span class="solution-badge" style="background:#f59e0b">${result.converged ? '✓' : '⚠'} Polynomial Solution</span>
              </div>
              <div class="mb-2"><strong>Solution:</strong></div>`;

          for(let i = 0; i < numVars; i++) {
            html += `<div class="text-secondary ml-3">${varNames[i]} = ${smartFormat(result.solution[i])}</div>`;
          }

          html += `</div>`;
        } else {
          html = `<div class="warning-card"><div class="mb-3"><span class="solution-badge" style="background:#f59e0b">⚠ Error</span></div><p>${result.message}</p></div>`;
        }

        resultArea.innerHTML = html;

        let stepsHtml = `<div class="mb-4"><h5 class="text-dark">📋 Newton-Raphson Method Steps</h5></div>`;
        result.steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card"><div class="d-flex align-items-start"><span class="step-number">${idx + 1}</span><div class="step-description">${step}</div></div></div>`;
        });
        stepsArea.innerHTML = stepsHtml;

        if(window.MathJax && window.MathJax.typesetPromise) {
          MathJax.typesetPromise([resultArea, stepsArea]).catch(err => console.error(err));
        }

        return;
      }

      // Handle matrix equations (Ax=b, AX=B, XA=B)
      const m = parseInt(numEquations.value);
      const n = parseInt(numVariables.value);

      if(m < 1 || m > 8 || n < 1 || n > 8) {
        throw new Error('Dimensions must be between 1 and 8');
      }

      const A = parseMatrix(matrixA.value, m, n);
      let B, result, b;
      let methodName = 'Solution';
      const method = methodSelect.value;

      if(eqType === 'Ax=b') {
        b = parseVector(vectorB.value, m);

        // Validate method compatibility with system type
        if((method === 'lu' || method === 'cramer' || method === 'inverse') && m !== n) {
          throw new Error(`${method.toUpperCase()} method requires a square system (m = n). Current system is ${m}×${n}.`);
        }

        if(method === 'cramer' && n > 3) {
          throw new Error("Cramer's rule is only efficient for n ≤ 3");
        }

        // Choose solving method
        methodName = 'Gaussian Elimination';

        if(method === 'gaussian') {
          result = solveSystem(A, b);
          methodName = 'Gaussian Elimination';
        } else if(method === 'gauss-jordan') {
          result = solveGaussJordan(A, b);
          methodName = 'Gauss-Jordan (RREF)';
        } else if(method === 'least-squares') {
          result = solveLeastSquares(A, b);
          methodName = 'Least Squares Method';
        } else if(method === 'lu') {
          result = solveLU(A, b);
          methodName = 'LU Decomposition';
        } else if(method === 'cramer') {
          result = solveCramer(A, b);
          methodName = "Cramer's Rule";
        } else if(method === 'inverse') {
          result = solveInverse(A, b);
          methodName = 'Matrix Inverse Method';
        }
      } else if(eqType === 'AX=B') {
        // Parse B as a matrix
        B = parseMatrix(vectorB.value, m, -1); // -1 means unknown columns
        result = solveAXB(A, B);
        methodName = 'Matrix Equation Solver';
      } else if(eqType === 'XA=B') {
        // For XA=B, we need A to be n×k, and B to be some m×p
        // User enters A in matrixA, B in vectorB
        B = parseMatrix(vectorB.value, -1, -1); // Parse as unknown dimensions
        result = solveXAB(A, B);
        methodName = 'Left Multiplication Solver';
      }

      let html = '';
      if(result.type === 'unique') {
        html = `
          <div class="result-card">
            <div class="mb-3">
              <span class="solution-badge">✓ Unique Solution</span>
            </div>
            <div class="mb-2"><strong>Solution Vector x:</strong></div>
            <div class="matrix-display">$$x = ${formatVector(result.solution)}$$</div>
          </div>
        `;

        // Add verification if enabled (only for Ax=b)
        if(verifyCheckbox.checked && eqType === 'Ax=b') {
          const verification = verifySolution(A, result.solution, b);
          html += `
            <div class="result-card mt-3">
              <h6 class="text-dark mb-3">✓ Verification: Ax ${m === n ? '=' : '≈'} b</h6>
              <div class="mb-2"><strong>Computed Ax:</strong></div>
              <div class="matrix-display">$$Ax = ${formatVector(verification.computed)}$$</div>
              <div class="mb-2 mt-3"><strong>Expected b:</strong></div>
              <div class="matrix-display">$$b = ${formatVector(b)}$$</div>
              <div class="mt-3">
                <strong>Maximum Error:</strong> <span class="text-success">${verification.error.toExponential(3)}</span>
                ${verification.error < 0.0001 ? '<span class="text-success ml-2">✓ Solution verified!</span>' : ''}
              </div>
            </div>
          `;
        }

        // Add visualization if enabled and n=2
        if(visualizeCheckbox.checked && n === 2 && m === 2) {
          draw2DVisualization(A, b, result.solution);
          solutionCanvas.style.display = 'block';
        } else {
          solutionCanvas.style.display = 'none';
        }

      } else if(result.type === 'least-squares') {
        html = `
          <div class="result-card">
            <div class="mb-3">
              <span class="solution-badge" style="background:#3b82f6">⊕ Least Squares Solution</span>
            </div>
            <div class="mb-2"><strong>Best Fit Solution Vector x:</strong></div>
            <div class="matrix-display">$$x = ${formatVector(result.solution)}$$</div>
            <div class="mt-3">
              <strong>Residual Norm ||Ax - b||:</strong> <span class="text-primary">${smartFormat(result.residual)}</span>
            </div>
            <p class="text-muted mt-2 small">This is the solution that minimizes the sum of squared residuals.</p>
          </div>
        `;

        // Add verification showing the residuals
        if(verifyCheckbox.checked) {
          html += `
            <div class="result-card mt-3">
              <h6 class="text-dark mb-3">📊 Residual Analysis</h6>
              <div class="mb-2"><strong>Computed Ax:</strong></div>
              <div class="matrix-display">$$Ax = ${formatVector(result.Ax)}$$</div>
              <div class="mb-2 mt-3"><strong>Target b:</strong></div>
              <div class="matrix-display">$$b = ${formatVector(b)}$$</div>
              <div class="mb-2 mt-3"><strong>Residuals (Ax - b):</strong></div>
              <div class="matrix-display">$$r = ${formatVector(result.residuals)}$$</div>
              <div class="mt-3">
                <strong>||r||² = </strong> ${result.residuals.map((r, i) => `(${smartFormat(r)})²`).join(' + ')}
                <strong> = ${smartFormat(result.residual * result.residual)}</strong>
              </div>
            </div>
          `;
        }
        solutionCanvas.style.display = 'none';

      } else if(result.type === 'matrix-solution') {
        html = `
          <div class="result-card">
            <div class="mb-3">
              <span class="solution-badge" style="background:#10b981">✓ Matrix Solution</span>
            </div>
            <div class="mb-2"><strong>Solution Matrix X:</strong></div>
            <div class="matrix-display">$$X = ${formatMatrix(result.solution)}$$</div>
            <div class="mt-3 text-muted small">
              ${result.solution.length}×${result.solution[0].length} solution matrix
            </div>
          </div>
        `;
        solutionCanvas.style.display = 'none';

      } else if(result.type === 'inconsistent') {
        html = `
          <div class="warning-card">
            <div class="mb-3">
              <span class="solution-badge" style="background:#f59e0b">⚠ No Solution (Inconsistent)</span>
            </div>
            <p class="mb-0">${result.message}</p>
            <p class="mt-2 mb-0 text-muted small">The system has contradictory equations and cannot be solved.</p>
          </div>
        `;
        solutionCanvas.style.display = 'none';
      } else if(result.type === 'infinite') {
        const freeVars = result.freeCols.map(c => `x${c+1}`).join(', ');

        // Generate parametric form
        let parametricHtml = '<div class="mt-3"><strong>Parametric Solution:</strong></div>';
        const paramNames = ['t', 's', 'r', 'u'];
        const params = result.freeCols.map((col, idx) => ({ col, name: paramNames[idx] }));

        parametricHtml += '<div class="matrix-display mt-2">$$\\begin{cases}';
        for(let j = 0; j < result.aug[0].length - 1; j++) {
          if(result.freeCols.includes(j)) {
            const paramIdx = result.freeCols.indexOf(j);
            parametricHtml += `x_{${j+1}} = ${params[paramIdx].name} \\\\`;
          } else {
            // Find the row with pivot in column j
            let rowIdx = -1;
            for(let i = 0; i < result.aug.length; i++) {
              if(Math.abs(result.aug[i][j]) > EPS) {
                rowIdx = i;
                break;
              }
            }
            if(rowIdx !== -1) {
              let expr = smartFormat(result.aug[rowIdx][result.aug[0].length - 1]);
              for(let k = j + 1; k < result.aug[0].length - 1; k++) {
                const coeff = -result.aug[rowIdx][k];
                if(Math.abs(coeff) > EPS) {
                  if(result.freeCols.includes(k)) {
                    const paramIdx = result.freeCols.indexOf(k);
                    expr += ` + ${smartFormat(coeff)}${params[paramIdx].name}`;
                  }
                }
              }
              parametricHtml += `x_{${j+1}} = ${expr} \\\\`;
            }
          }
        }
        parametricHtml += '\\end{cases}$$</div>';

        html = `
          <div class="warning-card">
            <div class="mb-3">
              <span class="solution-badge" style="background:#3b82f6">∞ Infinite Solutions</span>
            </div>
            <p><strong>Free variables:</strong> ${freeVars}</p>
            <p class="mb-0 text-muted small">The system has infinitely many solutions. ${result.freeCols.length} variable(s) can take any value.</p>
            ${parametricHtml}
          </div>
        `;
        solutionCanvas.style.display = 'none';
      }

      resultArea.innerHTML = html;

      if(result.steps && result.steps.length > 0) {
        let stepsHtml = `<div class="mb-4"><h5 class="text-dark">📋 ${methodName || 'Solution'} Steps</h5></div>`;
        stepsHtml += '<p class="text-muted mb-4" style="font-size:0.95rem">Watch the solution process:</p>';
        result.steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card">
            <div class="d-flex align-items-start">
              <span class="step-number">${idx + 1}</span>
              <div class="step-description">${step}</div>
            </div>
          </div>`;
        });
        stepsArea.innerHTML = stepsHtml;
      } else {
        stepsArea.innerHTML = '<div class="text-muted">No detailed steps available for this solution.</div>';
      }

      if(window.MathJax && window.MathJax.typesetPromise) {
        MathJax.typesetPromise([resultArea, stepsArea]).catch(err => console.error(err));
      }

    } catch(err) {
      inputError.textContent = err.message;
      inputError.style.display = 'block';
      resultArea.innerHTML = '<div class="text-danger">Error: ' + err.message + '</div>';
      solutionCanvas.style.display = 'none';
    }
  }

  function clear() {
    matrixA.value = '';
    vectorB.value = '';

    // Clear grid if in grid mode
    if(currentMode === 'grid' && gridInputs.length > 0) {
      const m = parseInt(numEquations.value);
      const n = parseInt(numVariables.value);
      for(let i = 0; i < m; i++) {
        for(let j = 0; j <= n; j++) {
          if(gridInputs[i] && gridInputs[i][j]) {
            gridInputs[i][j].value = '0';
          }
        }
      }
    }

    resultArea.innerHTML = '<div class="text-center text-muted">Enter a system of equations and click "Solve System" to see the solution.</div>';
    stepsArea.innerHTML = '<div class="text-muted">Detailed solution steps will appear here.</div>';
    inputError.style.display = 'none';
    solutionCanvas.style.display = 'none';
  }

  function loadExample(type) {
    // Ax=b examples
    if(type === 'unique') {
      equationType.value = 'Ax=b';
      switchEquationType();
      numEquations.value = 3;
      numVariables.value = 3;
      matrixA.value = '2 1 -1\n-3 -1 2\n-2 1 2';
      vectorB.value = '8\n-11\n-3';
      methodSelect.value = 'gaussian';
    } else if(type === '2d') {
      equationType.value = 'Ax=b';
      switchEquationType();
      numEquations.value = 2;
      numVariables.value = 2;
      matrixA.value = '2 -1\n1 1';
      vectorB.value = '1\n3';
      visualizeCheckbox.checked = true;
      methodSelect.value = 'gaussian';
    } else if(type === 'overdetermined') {
      equationType.value = 'Ax=b';
      switchEquationType();
      numEquations.value = 4;
      numVariables.value = 3;
      matrixA.value = '1 1 1\n2 1 0\n1 2 1\n1 0 2';
      vectorB.value = '6\n5\n8\n7';
      methodSelect.value = 'least-squares';
    } else if(type === 'underdetermined') {
      equationType.value = 'Ax=b';
      switchEquationType();
      numEquations.value = 2;
      numVariables.value = 3;
      matrixA.value = '1 2 1\n2 1 3';
      vectorB.value = '4\n7';
      methodSelect.value = 'gaussian';
    // AX=B examples
    } else if(type === 'axb-multiple') {
      equationType.value = 'AX=B';
      switchEquationType();
      numEquations.value = 3;
      numVariables.value = 3;
      matrixA.value = '2 1 -1\n-3 -1 2\n-2 1 2';
      vectorB.value = '8 1\n-11 2\n-3 3';
      methodSelect.value = 'gaussian';
    } else if(type === 'axb-2rhs') {
      equationType.value = 'AX=B';
      switchEquationType();
      numEquations.value = 2;
      numVariables.value = 2;
      matrixA.value = '3 2\n1 4';
      vectorB.value = '7 10\n6 8';
      methodSelect.value = 'gaussian';
    // XA=B examples
    } else if(type === 'xab-basic') {
      equationType.value = 'XA=B';
      switchEquationType();
      numEquations.value = 3;
      numVariables.value = 3;
      matrixA.value = '2 1 -1\n-3 -1 2\n-2 1 2';
      vectorB.value = '5 2 1\n3 1 2';
      methodSelect.value = 'gaussian';
    } else if(type === 'xab-rect') {
      equationType.value = 'XA=B';
      switchEquationType();
      numEquations.value = 2;
      numVariables.value = 3;
      matrixA.value = '1 2\n3 1\n2 2';
      vectorB.value = '7 6\n9 7';
      methodSelect.value = 'gaussian';
    // Polynomial examples
    } else if(type === 'poly-circle') {
      equationType.value = 'polynomial';
      switchEquationType();
      numPolyVars.value = 2;
      polynomialEquations.value = 'x^2 + y^2 = 25\nx + y = 7';
      initialGuess.value = '3, 3';
    } else if(type === 'poly-parabola') {
      equationType.value = 'polynomial';
      switchEquationType();
      numPolyVars.value = 2;
      polynomialEquations.value = 'y = x^2 - 2*x + 1\ny = 2*x - 1';
      initialGuess.value = '2, 3';
    } else if(type === 'poly-3d') {
      equationType.value = 'polynomial';
      switchEquationType();
      numPolyVars.value = 3;
      polynomialEquations.value = 'x^2 + y^2 + z^2 = 14\nx + y + z = 6\nx*y = 8';
      initialGuess.value = '2, 2, 2';
    }

    updateSystemTypeHint();

    // Sync to grid if in grid mode
    if(currentMode === 'grid') {
      const m = parseInt(numEquations.value);
      const n = parseInt(numVariables.value);
      if(gridInputs.length === 0 || gridInputs.length !== m) {
        buildGrid(m, n);
      }
      syncTextToGrid();
    }

    solve();
  }

  // Event handlers for solve and clear
  btnSolve.addEventListener('click', () => {
    if(currentMode === 'grid') syncGridToText();
    solve();
  });

  btnClear.addEventListener('click', clear);

  // Random generators
  btnRandom.addEventListener('click', generateRandom);
  btnRandomPoly.addEventListener('click', generateRandomPolynomial);

  // Mode toggle
  btnTextMode.addEventListener('click', switchToTextMode);
  btnGridMode.addEventListener('click', switchToGridMode);

  // System dimensions change - rebuild grid if in grid mode
  numEquations.addEventListener('change', () => {
    if(currentMode === 'grid') {
      const m = parseInt(numEquations.value);
      const n = parseInt(numVariables.value);
      buildGrid(m, n);
    }
  });

  numVariables.addEventListener('change', () => {
    if(currentMode === 'grid') {
      const m = parseInt(numEquations.value);
      const n = parseInt(numVariables.value);
      buildGrid(m, n);
    }
  });

  // Example buttons - attach dynamically since they change based on equation type
  function attachExampleListeners() {
    const exampleButtons = document.querySelectorAll('[data-example]');
    exampleButtons.forEach(btn => {
      btn.addEventListener('click', () => loadExample(btn.dataset.example));
    });
  }

  attachExampleListeners();

  matrixA.addEventListener('keydown', e => {
    if(e.key === 'Enter' && (e.metaKey || e.ctrlKey)) solve();
  });

  // Share URL functionality
  const btnShareURL = document.getElementById('btnShareURL');
  if(btnShareURL) {
    btnShareURL.addEventListener('click', function() {
      try {
        const m = parseInt(numEquations.value);
        const n = parseInt(numVariables.value);
        const aText = matrixA.value.trim();
        const bText = vectorB.value.trim();
        if(!aText || !bText) {
          alert('Please enter a system first!');
          return;
        }

        const baseUrl = window.location.origin + window.location.pathname;
        const params = new URLSearchParams();
        params.set('m', m);
        params.set('n', n);
        params.set('matrixA', btoa(encodeURIComponent(aText)));
        params.set('vectorB', btoa(encodeURIComponent(bText)));

        const shareUrl = baseUrl + '?' + params.toString();

        if(navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(shareUrl).then(() => {
            const originalHTML = btnShareURL.innerHTML;
            btnShareURL.innerHTML = '<i class="fas fa-check"></i> Copied!';
            btnShareURL.classList.remove('btn-outline-primary');
            btnShareURL.classList.add('btn-success');
            setTimeout(() => {
              btnShareURL.innerHTML = originalHTML;
              btnShareURL.classList.remove('btn-success');
              btnShareURL.classList.add('btn-outline-primary');
            }, 2000);
          }).catch(err => {
            alert('Failed to copy URL: ' + err);
          });
        } else {
          const textarea = document.createElement('textarea');
          textarea.value = shareUrl;
          document.body.appendChild(textarea);
          textarea.select();
          document.execCommand('copy');
          document.body.removeChild(textarea);
          alert('URL copied to clipboard!');
        }
      } catch(err) {
        console.error('Error creating share URL:', err);
        alert('Failed to create share URL');
      }
    });
  }

  // Download as Image functionality
  const btnDownloadImage = document.getElementById('btnDownloadImage');
  if(btnDownloadImage) {
    btnDownloadImage.addEventListener('click', async function() {
      const resultCard = document.querySelector('.card-body #resultArea').closest('.card');
      if(!resultCard || !resultCard.querySelector('.result-card, .warning-card')) {
        alert('No result to download. Please solve a system first.');
        return;
      }

      const originalHTML = btnDownloadImage.innerHTML;
      btnDownloadImage.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
      btnDownloadImage.disabled = true;

      try {
        if(window.MathJax && window.MathJax.typesetPromise) {
          await MathJax.typesetPromise([resultCard]);
          await new Promise(resolve => setTimeout(resolve, 800));
        }

        const dataUrl = await domtoimage.toPng(resultCard, {
          quality: 1,
          bgcolor: '#ffffff',
          width: resultCard.offsetWidth,
          height: resultCard.offsetHeight,
          style: {
            margin: '0',
            padding: '20px'
          },
          filter: (node) => {
            if(node.tagName === 'SCRIPT') return false;
            if(node.classList && node.classList.contains('MathJax_Preview')) return false;
            if(node.nodeType === Node.TEXT_NODE) {
              const text = node.textContent || '';
              if(text.includes('$$') || text.includes('\\begin{bmatrix}')) {
                return false;
              }
            }
            return true;
          }
        });

        const link = document.createElement('a');
        const timestamp = new Date().toISOString().slice(0, 10);
        link.download = `linear-equations-${timestamp}.png`;
        link.href = dataUrl;
        link.click();

        btnDownloadImage.innerHTML = '<i class="fas fa-check"></i> Downloaded!';
        btnDownloadImage.classList.remove('btn-outline-success');
        btnDownloadImage.classList.add('btn-success');
        setTimeout(() => {
          btnDownloadImage.innerHTML = originalHTML;
          btnDownloadImage.classList.remove('btn-success');
          btnDownloadImage.classList.add('btn-outline-success');
          btnDownloadImage.disabled = false;
        }, 2000);

      } catch(err) {
        console.error('Error generating image:', err);
        alert('Failed to generate image: ' + err.message);
        btnDownloadImage.innerHTML = originalHTML;
        btnDownloadImage.disabled = false;
      }
    });
  }

  // Load from URL parameters
  function loadFromURL() {
    const urlParams = new URLSearchParams(window.location.search);

    // Try new format (m, n parameters)
    if(urlParams.has('matrixA') && urlParams.has('vectorB') && urlParams.has('m') && urlParams.has('n')) {
      try {
        const m = parseInt(urlParams.get('m'));
        const n = parseInt(urlParams.get('n'));
        const aData = decodeURIComponent(atob(urlParams.get('matrixA')));
        const bData = decodeURIComponent(atob(urlParams.get('vectorB')));

        numEquations.value = m;
        numVariables.value = n;
        matrixA.value = aData;
        vectorB.value = bData;

        updateSystemTypeHint();
        setTimeout(() => solve(), 100);
        return true;
      } catch(err) {
        console.error('Error loading from URL:', err);
      }
    }

    // Try old format (size parameter for backward compatibility)
    if(urlParams.has('matrixA') && urlParams.has('vectorB') && urlParams.has('size')) {
      try {
        const size = parseInt(urlParams.get('size'));
        const aData = decodeURIComponent(atob(urlParams.get('matrixA')));
        const bData = decodeURIComponent(atob(urlParams.get('vectorB')));

        numEquations.value = size;
        numVariables.value = size;
        matrixA.value = aData;
        vectorB.value = bData;

        updateSystemTypeHint();
        setTimeout(() => solve(), 100);
        return true;
      } catch(err) {
        console.error('Error loading from URL:', err);
      }
    }

    return false;
  }

  // Initialize hints
  updateSystemTypeHint();

  if(!loadFromURL()) {
    loadExample('unique');
  }
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
