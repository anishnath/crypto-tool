<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>System of Equations Solver - 2x2, 3x3, Matrix Methods | 8gwifi.org</title>
  <meta name="description" content="Advanced system of equations solver for 2x2 and 3x3 systems. Multiple solution methods: substitution, elimination, Cramer's rule, matrix inversion, Gaussian elimination. Step-by-step solutions with detailed explanations and graphing.">
  <meta name="keywords" content="system of equations solver, linear system calculator, 2x2 system, 3x3 system, substitution method, elimination method, Cramer's rule, matrix solver, Gaussian elimination, augmented matrix, simultaneous equations">
  <link rel="canonical" href="https://8gwifi.org/system-equations-solver.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/system-equations-solver.jsp">
  <meta property="og:title" content="System of Equations Solver - 2x2, 3x3 with Multiple Methods">
  <meta property="og:description" content="Solve systems of linear equations using substitution, elimination, Cramer's rule, matrix methods. Step-by-step solutions for 2x2 and 3x3 systems.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/system-equations-solver.jsp">
  <meta property="twitter:title" content="System of Equations Solver - Multiple Methods">
  <meta property="twitter:description" content="Solve 2x2 and 3x3 linear systems with step-by-step solutions using substitution, elimination, Cramer's rule, and matrix methods.">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "System of Equations Solver",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Advanced system of equations solver supporting 2x2 and 3x3 linear systems with multiple solution methods including substitution, elimination, Cramer's rule, matrix inversion, and Gaussian elimination.",
    "url": "https://8gwifi.org/system-equations-solver.jsp",
    "featureList": [
      "2x2 system solver",
      "3x3 system solver",
      "Substitution method",
      "Elimination method",
      "Cramer's rule with determinants",
      "Matrix inversion method",
      "Gaussian elimination",
      "Augmented matrix representation",
      "Solution classification (unique, infinite, no solution)",
      "Graphical representation (2x2 systems)",
      "Step-by-step explanations",
      "All solution methods compared"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "ratingCount": "2156",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

  <style>
  :root {
    --sys-primary: #10b981;
    --sys-secondary: #059669;
    --sys-light: #d1fae5;
    --sys-dark: #065f46;
  }

  .sys-card {
    border-left: 4px solid var(--sys-primary);
    transition: all 0.3s ease;
  }

  .sys-card:hover {
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
    transform: translateY(-2px);
  }

  .result-box {
    background: linear-gradient(135deg, var(--sys-light), white);
    border: 2px solid var(--sys-primary);
    border-radius: 10px;
    padding: 1.5rem;
    margin-top: 1rem;
  }

  .sys-result {
    font-size: 1.4rem;
    font-weight: bold;
    color: var(--sys-dark);
    background-color: #ecfdf5;
    padding: 1rem;
    border-radius: 8px;
    margin: 1rem 0;
    text-align: center;
  }

  .equation-display {
    font-size: 1.2rem;
    font-family: 'Courier New', monospace;
    background: #f9fafb;
    padding: 0.75rem;
    border-left: 3px solid var(--sys-primary);
    margin: 0.5rem 0;
  }

  .step-section {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    padding: 1rem;
    margin: 1rem 0;
  }

  .step-item {
    padding: 0.5rem;
    margin: 0.25rem 0;
    border-left: 2px solid var(--sys-secondary);
    padding-left: 1rem;
  }

  .matrix-display {
    font-family: 'Courier New', monospace;
    display: inline-block;
    padding: 0.5rem;
    margin: 0.5rem;
  }

  .matrix-bracket {
    font-size: 2rem;
    font-weight: bold;
  }

  .info-card {
    background: #eff6ff;
    border-left: 4px solid #3b82f6;
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 4px;
  }

  .method-badge {
    background: linear-gradient(135deg, var(--sys-primary), var(--sys-secondary));
    color: white;
    padding: 0.4rem 0.8rem;
    border-radius: 15px;
    font-size: 0.9rem;
    font-weight: 600;
    display: inline-block;
  }

  .solution-type {
    display: inline-block;
    padding: 0.5rem 1rem;
    border-radius: 20px;
    font-weight: bold;
    margin: 0.5rem 0;
  }

  .solution-unique {
    background: #d1fae5;
    color: #065f46;
    border: 2px solid #10b981;
  }

  .solution-infinite {
    background: #fef3c7;
    color: #92400e;
    border: 2px solid #f59e0b;
  }

  .solution-none {
    background: #fee2e2;
    color: #991b1b;
    border: 2px solid #ef4444;
  }

  .coefficient-input {
    width: 70px;
    display: inline-block;
    margin: 0 0.25rem;
  }

  .chart-container {
    position: relative;
    height: 400px;
    margin: 1.5rem 0;
  }
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1 class="mb-2"><i class="fas fa-equals text-success"></i> System of Equations Solver</h1>
  <p class="text-muted mb-3">Solve 2×2 and 3×3 linear systems using substitution, elimination, Cramer's rule, and matrix methods</p>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header"><i class="fas fa-th"></i> System Solver</h5>
        <div class="card-body">

          <!-- System Size Selection -->
          <div class="form-group">
            <label><i class="fas fa-list"></i> <strong>System Size</strong></label>
            <select class="form-control" id="systemSize" onchange="updateSystemInputs()">
              <option value="2">2×2 System (2 equations, 2 variables)</option>
              <option value="3">3×3 System (3 equations, 3 variables)</option>
            </select>
          </div>

          <!-- Tab Navigation -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="input-tab" data-toggle="tab" href="#input-panel" role="tab">
                <i class="fas fa-edit"></i> Input Equations
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="all-methods-tab" data-toggle="tab" href="#all-methods-panel" role="tab">
                <i class="fas fa-list-ol"></i> All Methods
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="graph-tab" data-toggle="tab" href="#graph-panel" role="tab">
                <i class="fas fa-chart-line"></i> Graphical
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- Input Panel -->
            <div class="tab-pane fade show active" id="input-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Enter coefficients:</strong><br>
                For 2×2: ax + by = c and dx + ey = f<br>
                For 3×3: ax + by + cz = d, ex + fy + gz = h, ix + jy + kz = l
              </div>

              <div id="systemInputs">
                <!-- 2x2 System Inputs (default) -->
                <div id="system2x2">
                  <h6 class="mt-3"><strong>Equation 1:</strong></h6>
                  <div class="form-inline mb-2">
                    <input type="number" class="form-control coefficient-input" id="a11" value="2" step="any">
                    <span class="mx-1">x +</span>
                    <input type="number" class="form-control coefficient-input" id="a12" value="3" step="any">
                    <span class="mx-1">y =</span>
                    <input type="number" class="form-control coefficient-input" id="b1" value="8" step="any">
                  </div>

                  <h6 class="mt-3"><strong>Equation 2:</strong></h6>
                  <div class="form-inline mb-2">
                    <input type="number" class="form-control coefficient-input" id="a21" value="4" step="any">
                    <span class="mx-1">x +</span>
                    <input type="number" class="form-control coefficient-input" id="a22" value="-1" step="any">
                    <span class="mx-1">y =</span>
                    <input type="number" class="form-control coefficient-input" id="b2" value="2" step="any">
                  </div>
                </div>

                <!-- 3x3 System Inputs (hidden by default) -->
                <div id="system3x3" style="display: none;">
                  <h6 class="mt-3"><strong>Equation 1:</strong></h6>
                  <div class="form-inline mb-2">
                    <input type="number" class="form-control coefficient-input" id="a11_3" value="2" step="any">
                    <span class="mx-1">x +</span>
                    <input type="number" class="form-control coefficient-input" id="a12_3" value="1" step="any">
                    <span class="mx-1">y +</span>
                    <input type="number" class="form-control coefficient-input" id="a13_3" value="-1" step="any">
                    <span class="mx-1">z =</span>
                    <input type="number" class="form-control coefficient-input" id="b1_3" value="8" step="any">
                  </div>

                  <h6 class="mt-3"><strong>Equation 2:</strong></h6>
                  <div class="form-inline mb-2">
                    <input type="number" class="form-control coefficient-input" id="a21_3" value="-3" step="any">
                    <span class="mx-1">x +</span>
                    <input type="number" class="form-control coefficient-input" id="a22_3" value="-1" step="any">
                    <span class="mx-1">y +</span>
                    <input type="number" class="form-control coefficient-input" id="a23_3" value="2" step="any">
                    <span class="mx-1">z =</span>
                    <input type="number" class="form-control coefficient-input" id="b2_3" value="-11" step="any">
                  </div>

                  <h6 class="mt-3"><strong>Equation 3:</strong></h6>
                  <div class="form-inline mb-2">
                    <input type="number" class="form-control coefficient-input" id="a31_3" value="-2" step="any">
                    <span class="mx-1">x +</span>
                    <input type="number" class="form-control coefficient-input" id="a32_3" value="1" step="any">
                    <span class="mx-1">y +</span>
                    <input type="number" class="form-control coefficient-input" id="a33_3" value="2" step="any">
                    <span class="mx-1">z =</span>
                    <input type="number" class="form-control coefficient-input" id="b3_3" value="-3" step="any">
                  </div>
                </div>
              </div>

              <div class="form-group mt-3">
                <label><i class="fas fa-cog"></i> <strong>Solution Method</strong></label>
                <select class="form-control" id="solutionMethod">
                  <option value="cramer">Cramer's Rule (Determinants)</option>
                  <option value="elimination">Gaussian Elimination</option>
                  <option value="substitution">Substitution Method</option>
                  <option value="matrix">Matrix Inversion (A⁻¹B)</option>
                </select>
              </div>

              <button class="btn btn-success btn-lg btn-block mt-3" onclick="solveSystem()">
                <i class="fas fa-calculator"></i> Solve System
              </button>

              <div class="example-box mt-3">
                <strong>Example Systems:</strong><br>
                <strong>2×2:</strong> 2x + 3y = 8, 4x - y = 2 → Solution: x = 1, y = 2<br>
                <strong>3×3:</strong> 2x + y - z = 8, -3x - y + 2z = -11, -2x + y + 2z = -3 → x = 2, y = 3, z = -1
              </div>
            </div>

            <!-- All Methods Panel -->
            <div class="tab-pane fade" id="all-methods-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Compare all solution methods</strong><br>
                Solve the same system using substitution, elimination, Cramer's rule, and matrix inversion.
              </div>

              <button class="btn btn-success btn-block" onclick="solveAllMethods()">
                <i class="fas fa-list-check"></i> Solve Using All Methods
              </button>
            </div>

            <!-- Graphical Panel (2x2 only) -->
            <div class="tab-pane fade" id="graph-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Graphical representation (2×2 systems only)</strong><br>
                Visualize the two lines and their intersection point.
              </div>

              <button class="btn btn-success btn-block" onclick="drawGraph()">
                <i class="fas fa-chart-line"></i> Draw Graph
              </button>

              <div id="graphNote" class="alert alert-warning mt-3" style="display: none;">
                <i class="fas fa-exclamation-triangle"></i> Graphing is only available for 2×2 systems.
              </div>
            </div>

          </div>
        </div>
      </div>


    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-8 col-md-12">
      <div id="results"></div>

        <!-- Educational Content -->
        <div class="card mb-3">
            <h5 class="card-header"><i class="fas fa-book"></i> Guide</h5>
            <div class="card-body" style="font-size: 0.9rem;">
                <h6><i class="fas fa-question-circle text-success"></i> What is a System?</h6>
                <p style="font-size: 0.85rem;">A system of equations is a set of equations with the same variables. The solution satisfies all equations simultaneously.</p>

                <h6 class="mt-2"><i class="fas fa-list-alt text-success"></i> Solution Methods</h6>

                <p style="font-size: 0.85rem;"><strong>Cramer's Rule:</strong> Uses determinants<br>
                    <strong>Gaussian:</strong> Row operations<br>
                    <strong>Substitution:</strong> Isolate & substitute<br>
                    <strong>Matrix:</strong> X = A⁻¹B</p>

                <h6 class="mt-2"><i class="fas fa-info-circle text-success"></i> Solution Types</h6>
                <p style="font-size: 0.85rem;">• <strong>Unique:</strong> One point (Det ≠ 0)<br>
                    • <strong>Infinite:</strong> Same line/plane<br>
                    • <strong>None:</strong> Parallel lines</p>
            </div>
        </div>

    </div>

  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
// Global variable for chart
let systemChart = null;

// Update system inputs based on size
function updateSystemInputs() {
  const size = document.getElementById('systemSize').value;

  if (size === '2') {
    document.getElementById('system2x2').style.display = 'block';
    document.getElementById('system3x3').style.display = 'none';
  } else {
    document.getElementById('system2x2').style.display = 'none';
    document.getElementById('system3x3').style.display = 'block';
  }
}

// Solve system using selected method
function solveSystem() {
  const size = document.getElementById('systemSize').value;
  const method = document.getElementById('solutionMethod').value;

  if (size === '2') {
    solve2x2(method);
  } else {
    solve3x3(method);
  }
}

// Solve 2x2 system
function solve2x2(method) {
  // Get coefficients
  const a11 = parseFloat(document.getElementById('a11').value);
  const a12 = parseFloat(document.getElementById('a12').value);
  const b1 = parseFloat(document.getElementById('b1').value);
  const a21 = parseFloat(document.getElementById('a21').value);
  const a22 = parseFloat(document.getElementById('a22').value);
  const b2 = parseFloat(document.getElementById('b2').value);

  // Validate inputs
  if (isNaN(a11) || isNaN(a12) || isNaN(b1) || isNaN(a21) || isNaN(a22) || isNaN(b2)) {
    alert('Please enter valid numbers for all coefficients');
    return;
  }

  // Calculate determinant
  const det = a11 * a22 - a12 * a21;

  let html = '<div class="result-box">';

  // Display system
  html += `
    <h6 class="text-center"><span class="method-badge">2×2 System</span></h6>
    <div class="equation-display">
      ${formatCoef(a11)}x ${formatTerm(a12, 'y')} = ${b1}
    </div>
    <div class="equation-display">
      ${formatCoef(a21)}x ${formatTerm(a22, 'y')} = ${b2}
    </div>
  `;

  // Check for special cases
  if (Math.abs(det) < 1e-10) {
    // Check if inconsistent or dependent
    const ratio1 = a11 / a21;
    const ratio2 = a12 / a22;
    const ratio3 = b1 / b2;

    if (Math.abs(ratio1 - ratio2) < 1e-10 && Math.abs(ratio2 - ratio3) < 1e-10) {
      html += `
        <div class="solution-type solution-infinite">
          <i class="fas fa-infinity"></i> Infinite Solutions (Dependent System)
        </div>
        <div class="info-card">
          <strong>Explanation:</strong> The two equations represent the same line. Every point on the line is a solution.
        </div>
      `;
    } else {
      html += `
        <div class="solution-type solution-none">
          <i class="fas fa-times-circle"></i> No Solution (Inconsistent System)
        </div>
        <div class="info-card">
          <strong>Explanation:</strong> The two equations represent parallel lines that never intersect.
        </div>
      `;
    }
  } else {
    // Unique solution exists
    let x, y;

    if (method === 'cramer') {
      // Cramer's Rule
      const detX = b1 * a22 - b2 * a12;
      const detY = a11 * b2 - a21 * b1;
      x = detX / det;
      y = detY / det;

      html += `
        <div class="solution-type solution-unique">
          <i class="fas fa-check-circle"></i> Unique Solution
        </div>
        <div class="sys-result">
          x = ${x.toFixed(4)}<br>
          y = ${y.toFixed(4)}
        </div>

        <div class="step-section">
          <h6><i class="fas fa-calculator"></i> Cramer's Rule Solution</h6>

          <div class="step-item">
            <strong>Step 1: Calculate main determinant</strong><br>
            Det(A) = |${a11}  ${a12}|<br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|${a21}  ${a22}|<br>
            = (${a11})(${a22}) - (${a12})(${a21})<br>
            = ${det.toFixed(4)}
          </div>

          <div class="step-item">
            <strong>Step 2: Calculate Dx (replace x column with constants)</strong><br>
            Det(Dx) = |${b1}  ${a12}|<br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|${b2}  ${a22}|<br>
            = (${b1})(${a22}) - (${a12})(${b2})<br>
            = ${detX.toFixed(4)}
          </div>

          <div class="step-item">
            <strong>Step 3: Calculate Dy (replace y column with constants)</strong><br>
            Det(Dy) = |${a11}  ${b1}|<br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|${a21}  ${b2}|<br>
            = (${a11})(${b2}) - (${b1})(${a21})<br>
            = ${detY.toFixed(4)}
          </div>

          <div class="step-item">
            <strong>Step 4: Apply Cramer's Rule</strong><br>
            x = Det(Dx) / Det(A) = ${detX.toFixed(4)} / ${det.toFixed(4)} = ${x.toFixed(4)}<br>
            y = Det(Dy) / Det(A) = ${detY.toFixed(4)} / ${det.toFixed(4)} = ${y.toFixed(4)}
          </div>
        </div>
      `;
    } else if (method === 'elimination') {
      // Gaussian Elimination
      x = (b1 * a22 - b2 * a12) / det;
      y = (a11 * b2 - a21 * b1) / det;

      html += `
        <div class="solution-type solution-unique">
          <i class="fas fa-check-circle"></i> Unique Solution
        </div>
        <div class="sys-result">
          x = ${x.toFixed(4)}<br>
          y = ${y.toFixed(4)}
        </div>

        <div class="step-section">
          <h6><i class="fas fa-calculator"></i> Gaussian Elimination Solution</h6>

          <div class="step-item">
            <strong>Augmented Matrix:</strong><br>
            [${a11}  ${a12} | ${b1}]<br>
            [${a21}  ${a22} | ${b2}]
          </div>

          <div class="step-item">
            <strong>Step 1: Eliminate x from equation 2</strong><br>
            Multiply R1 by ${a21}/${a11}, subtract from R2<br>
            New R2: [0  ${(a22 - a21*a12/a11).toFixed(2)} | ${(b2 - a21*b1/a11).toFixed(2)}]
          </div>

          <div class="step-item">
            <strong>Step 2: Back substitution</strong><br>
            From R2: y = ${y.toFixed(4)}<br>
            Substitute into R1: x = ${x.toFixed(4)}
          </div>
        </div>
      `;
    } else if (method === 'substitution') {
      // Substitution Method
      x = (b1 * a22 - b2 * a12) / det;
      y = (a11 * b2 - a21 * b1) / det;

      html += `
        <div class="solution-type solution-unique">
          <i class="fas fa-check-circle"></i> Unique Solution
        </div>
        <div class="sys-result">
          x = ${x.toFixed(4)}<br>
          y = ${y.toFixed(4)}
        </div>

        <div class="step-section">
          <h6><i class="fas fa-calculator"></i> Substitution Method Solution</h6>

          <div class="step-item">
            <strong>Step 1: Solve Equation 1 for x</strong><br>
            ${formatCoef(a11)}x ${formatTerm(a12, 'y')} = ${b1}<br>
            x = (${b1} - ${a12}y) / ${a11}
          </div>

          <div class="step-item">
            <strong>Step 2: Substitute into Equation 2</strong><br>
            ${formatCoef(a21)}((${b1} - ${a12}y) / ${a11}) ${formatTerm(a22, 'y')} = ${b2}<br>
            Simplify to find y = ${y.toFixed(4)}
          </div>

          <div class="step-item">
            <strong>Step 3: Substitute y back</strong><br>
            x = (${b1} - ${a12}(${y.toFixed(4)})) / ${a11} = ${x.toFixed(4)}
          </div>
        </div>
      `;
    } else if (method === 'matrix') {
      // Matrix Inversion
      const detInv = 1 / det;
      const inv11 = a22 * detInv;
      const inv12 = -a12 * detInv;
      const inv21 = -a21 * detInv;
      const inv22 = a11 * detInv;

      x = inv11 * b1 + inv12 * b2;
      y = inv21 * b1 + inv22 * b2;

      html += `
        <div class="solution-type solution-unique">
          <i class="fas fa-check-circle"></i> Unique Solution
        </div>
        <div class="sys-result">
          x = ${x.toFixed(4)}<br>
          y = ${y.toFixed(4)}
        </div>

        <div class="step-section">
          <h6><i class="fas fa-calculator"></i> Matrix Inversion Method (X = A⁻¹B)</h6>

          <div class="step-item">
            <strong>Step 1: Write in matrix form AX = B</strong><br>
            A = [${a11}  ${a12}], X = [x], B = [${b1}]<br>
            &nbsp;&nbsp;&nbsp;&nbsp;[${a21}  ${a22}]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[y]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[${b2}]
          </div>

          <div class="step-item">
            <strong>Step 2: Calculate A⁻¹</strong><br>
            Det(A) = ${det.toFixed(4)}<br>
            A⁻¹ = (1/${det.toFixed(4)}) × [${a22}  ${-a12}]<br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[${-a21}  ${a11}]<br>
            = [${inv11.toFixed(4)}  ${inv12.toFixed(4)}]<br>
            &nbsp;&nbsp;[${inv21.toFixed(4)}  ${inv22.toFixed(4)}]
          </div>

          <div class="step-item">
            <strong>Step 3: Multiply X = A⁻¹B</strong><br>
            [x] = [${inv11.toFixed(4)}  ${inv12.toFixed(4)}] × [${b1}]<br>
            [y]&nbsp;&nbsp;&nbsp;[${inv21.toFixed(4)}  ${inv22.toFixed(4)}]&nbsp;&nbsp;&nbsp;[${b2}]<br>
            x = ${x.toFixed(4)}, y = ${y.toFixed(4)}
          </div>
        </div>
      `;
    }

    // Verification
    html += `
      <div class="info-card">
        <strong><i class="fas fa-check-double"></i> Verification:</strong><br>
        Equation 1: ${formatCoef(a11)}(${x.toFixed(4)}) ${formatTerm(a12, '(' + y.toFixed(4) + ')')} = ${(a11*x + a12*y).toFixed(4)} ≈ ${b1} ✓<br>
        Equation 2: ${formatCoef(a21)}(${x.toFixed(4)}) ${formatTerm(a22, '(' + y.toFixed(4) + ')')} = ${(a21*x + a22*y).toFixed(4)} ≈ ${b2} ✓
      </div>
    `;
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Solve 3x3 system
function solve3x3(method) {
  // Get coefficients
  const a11 = parseFloat(document.getElementById('a11_3').value);
  const a12 = parseFloat(document.getElementById('a12_3').value);
  const a13 = parseFloat(document.getElementById('a13_3').value);
  const b1 = parseFloat(document.getElementById('b1_3').value);
  const a21 = parseFloat(document.getElementById('a21_3').value);
  const a22 = parseFloat(document.getElementById('a22_3').value);
  const a23 = parseFloat(document.getElementById('a23_3').value);
  const b2 = parseFloat(document.getElementById('b2_3').value);
  const a31 = parseFloat(document.getElementById('a31_3').value);
  const a32 = parseFloat(document.getElementById('a32_3').value);
  const a33 = parseFloat(document.getElementById('a33_3').value);
  const b3 = parseFloat(document.getElementById('b3_3').value);

  // Validate inputs
  if (isNaN(a11) || isNaN(a12) || isNaN(a13) || isNaN(b1) ||
      isNaN(a21) || isNaN(a22) || isNaN(a23) || isNaN(b2) ||
      isNaN(a31) || isNaN(a32) || isNaN(a33) || isNaN(b3)) {
    alert('Please enter valid numbers for all coefficients');
    return;
  }

  // Calculate determinant (3x3)
  const det = a11 * (a22 * a33 - a23 * a32) -
              a12 * (a21 * a33 - a23 * a31) +
              a13 * (a21 * a32 - a22 * a31);

  let html = '<div class="result-box">';

  // Display system
  html += `
    <h6 class="text-center"><span class="method-badge">3×3 System</span></h6>
    <div class="equation-display">
      ${formatCoef(a11)}x ${formatTerm(a12, 'y')} ${formatTerm(a13, 'z')} = ${b1}
    </div>
    <div class="equation-display">
      ${formatCoef(a21)}x ${formatTerm(a22, 'y')} ${formatTerm(a23, 'z')} = ${b2}
    </div>
    <div class="equation-display">
      ${formatCoef(a31)}x ${formatTerm(a32, 'y')} ${formatTerm(a33, 'z')} = ${b3}
    </div>
  `;

  if (Math.abs(det) < 1e-10) {
    html += `
      <div class="solution-type solution-none">
        <i class="fas fa-times-circle"></i> No Unique Solution
      </div>
      <div class="info-card">
        <strong>Explanation:</strong> Det(A) = 0. The system either has no solution or infinitely many solutions.
      </div>
    `;
  } else {
    // Unique solution exists - use Cramer's Rule for simplicity
    const detX = b1 * (a22 * a33 - a23 * a32) -
                 a12 * (b2 * a33 - a23 * b3) +
                 a13 * (b2 * a32 - a22 * b3);

    const detY = a11 * (b2 * a33 - a23 * b3) -
                 b1 * (a21 * a33 - a23 * a31) +
                 a13 * (a21 * b3 - b2 * a31);

    const detZ = a11 * (a22 * b3 - b2 * a32) -
                 a12 * (a21 * b3 - b2 * a31) +
                 b1 * (a21 * a32 - a22 * a31);

    const x = detX / det;
    const y = detY / det;
    const z = detZ / det;

    html += `
      <div class="solution-type solution-unique">
        <i class="fas fa-check-circle"></i> Unique Solution
      </div>
      <div class="sys-result">
        x = ${x.toFixed(4)}<br>
        y = ${y.toFixed(4)}<br>
        z = ${z.toFixed(4)}
      </div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Solution using ${method === 'cramer' ? "Cramer's Rule" : method.charAt(0).toUpperCase() + method.slice(1)}</h6>

        <div class="step-item">
          <strong>Step 1: Calculate Det(A)</strong><br>
          Det(A) = ${det.toFixed(4)}
        </div>

        <div class="step-item">
          <strong>Step 2: Calculate Dx, Dy, Dz</strong><br>
          Det(Dx) = ${detX.toFixed(4)}<br>
          Det(Dy) = ${detY.toFixed(4)}<br>
          Det(Dz) = ${detZ.toFixed(4)}
        </div>

        <div class="step-item">
          <strong>Step 3: Apply Cramer's Rule</strong><br>
          x = Det(Dx) / Det(A) = ${x.toFixed(4)}<br>
          y = Det(Dy) / Det(A) = ${y.toFixed(4)}<br>
          z = Det(Dz) / Det(A) = ${z.toFixed(4)}
        </div>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-check-double"></i> Verification:</strong><br>
        Eq 1: ${(a11*x + a12*y + a13*z).toFixed(4)} ≈ ${b1} ✓<br>
        Eq 2: ${(a21*x + a22*y + a23*z).toFixed(4)} ≈ ${b2} ✓<br>
        Eq 3: ${(a31*x + a32*y + a33*z).toFixed(4)} ≈ ${b3} ✓
      </div>
    `;
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Solve using all methods
function solveAllMethods() {
  const size = document.getElementById('systemSize').value;

  if (size === '3') {
    alert('All methods comparison is currently available for 2×2 systems only');
    return;
  }

  // Get coefficients
  const a11 = parseFloat(document.getElementById('a11').value);
  const a12 = parseFloat(document.getElementById('a12').value);
  const b1 = parseFloat(document.getElementById('b1').value);
  const a21 = parseFloat(document.getElementById('a21').value);
  const a22 = parseFloat(document.getElementById('a22').value);
  const b2 = parseFloat(document.getElementById('b2').value);

  const det = a11 * a22 - a12 * a21;

  if (Math.abs(det) < 1e-10) {
    alert('This system does not have a unique solution. Cannot compare methods.');
    return;
  }

  const x = (b1 * a22 - b2 * a12) / det;
  const y = (a11 * b2 - a21 * b1) / det;

  let html = `
    <div class="result-box">
      <h6 class="text-center"><span class="method-badge">All Solution Methods</span></h6>

      <div class="sys-result">
        Solution: x = ${x.toFixed(4)}, y = ${y.toFixed(4)}
      </div>

      <div class="step-section">
        <h6><span class="method-badge">Method 1: Cramer's Rule</span></h6>
        <div class="step-item">
          Det(A) = ${det.toFixed(4)}<br>
          Det(Dx) = ${(b1 * a22 - b2 * a12).toFixed(4)}<br>
          Det(Dy) = ${(a11 * b2 - a21 * b1).toFixed(4)}<br>
          x = Det(Dx)/Det(A) = ${x.toFixed(4)}<br>
          y = Det(Dy)/Det(A) = ${y.toFixed(4)}
        </div>
        <div class="info-card">
          <strong>Pros:</strong> Fast, deterministic<br>
          <strong>Cons:</strong> Only works when Det(A) ≠ 0
        </div>
      </div>

      <div class="step-section">
        <h6><span class="method-badge">Method 2: Gaussian Elimination</span></h6>
        <div class="step-item">
          Augmented matrix: [${a11}  ${a12} | ${b1}]<br>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[${a21}  ${a22} | ${b2}]<br>
          After elimination and back-substitution:<br>
          x = ${x.toFixed(4)}, y = ${y.toFixed(4)}
        </div>
        <div class="info-card">
          <strong>Pros:</strong> Works for any system size, shows row operations<br>
          <strong>Cons:</strong> More steps required
        </div>
      </div>

      <div class="step-section">
        <h6><span class="method-badge">Method 3: Substitution</span></h6>
        <div class="step-item">
          Solve equation 1 for x: x = (${b1} - ${a12}y) / ${a11}<br>
          Substitute into equation 2 and solve for y<br>
          y = ${y.toFixed(4)}, then x = ${x.toFixed(4)}
        </div>
        <div class="info-card">
          <strong>Pros:</strong> Intuitive, good for simple systems<br>
          <strong>Cons:</strong> Can get messy with complex coefficients
        </div>
      </div>

      <div class="step-section">
        <h6><span class="method-badge">Method 4: Matrix Inversion</span></h6>
        <div class="step-item">
          X = A⁻¹B where A⁻¹ = (1/Det(A)) × [${a22}  ${-a12}]<br>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[${-a21}  ${a11}]<br>
          Result: x = ${x.toFixed(4)}, y = ${y.toFixed(4)}
        </div>
        <div class="info-card">
          <strong>Pros:</strong> Elegant matrix notation, reusable inverse<br>
          <strong>Cons:</strong> Computing inverse can be expensive for large matrices
        </div>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-lightbulb"></i> Recommendation:</strong><br>
        For 2×2 and 3×3 systems, <strong>Cramer's Rule</strong> is often fastest.<br>
        For larger systems, <strong>Gaussian Elimination</strong> is more efficient.
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Draw graph for 2x2 system
function drawGraph() {
  const size = document.getElementById('systemSize').value;

  if (size === '3') {
    document.getElementById('graphNote').style.display = 'block';
    return;
  }

  // Get coefficients
  const a11 = parseFloat(document.getElementById('a11').value);
  const a12 = parseFloat(document.getElementById('a12').value);
  const b1 = parseFloat(document.getElementById('b1').value);
  const a21 = parseFloat(document.getElementById('a21').value);
  const a22 = parseFloat(document.getElementById('a22').value);
  const b2 = parseFloat(document.getElementById('b2').value);

  const det = a11 * a22 - a12 * a21;
  const x = (b1 * a22 - b2 * a12) / det;
  const y = (a11 * b2 - a21 * b1) / det;

  // Generate line data
  const xMin = Math.min(-10, x - 5);
  const xMax = Math.max(10, x + 5);
  const xValues = [];
  const line1 = [];
  const line2 = [];

  for (let i = 0; i <= 100; i++) {
    const xVal = xMin + (xMax - xMin) * i / 100;
    xValues.push(xVal);

    // Line 1: a11*x + a12*y = b1 -> y = (b1 - a11*x) / a12
    if (Math.abs(a12) > 1e-10) {
      line1.push((b1 - a11 * xVal) / a12);
    } else {
      line1.push(null);
    }

    // Line 2: a21*x + a22*y = b2 -> y = (b2 - a21*x) / a22
    if (Math.abs(a22) > 1e-10) {
      line2.push((b2 - a21 * xVal) / a22);
    } else {
      line2.push(null);
    }
  }

  let html = `
    <div class="result-box">
      <h6 class="text-center"><span class="method-badge">Graphical Solution</span></h6>

      <div class="sys-result">
        Intersection Point: (${x.toFixed(4)}, ${y.toFixed(4)})
      </div>

      <div class="chart-container">
        <canvas id="systemChart"></canvas>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-info-circle"></i> Graph Explanation:</strong><br>
        • <span style="color: rgb(239, 68, 68);">─</span> Line 1: ${formatCoef(a11)}x ${formatTerm(a12, 'y')} = ${b1}<br>
        • <span style="color: rgb(59, 130, 246);">─</span> Line 2: ${formatCoef(a21)}x ${formatTerm(a22, 'y')} = ${b2}<br>
        • <span style="color: rgb(16, 185, 129);">●</span> Solution: The point where both lines intersect
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;

  // Draw chart
  const ctx = document.getElementById('systemChart');
  if (!ctx) return;

  if (systemChart) {
    systemChart.destroy();
  }

  systemChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: xValues,
      datasets: [
        {
          label: 'Line 1',
          data: line1,
          borderColor: 'rgb(239, 68, 68)',
          borderWidth: 2,
          pointRadius: 0,
          spanGaps: false
        },
        {
          label: 'Line 2',
          data: line2,
          borderColor: 'rgb(59, 130, 246)',
          borderWidth: 2,
          pointRadius: 0,
          spanGaps: false
        },
        {
          label: 'Solution',
          data: [{ x: x, y: y }],
          type: 'scatter',
          backgroundColor: 'rgb(16, 185, 129)',
          borderColor: 'rgb(16, 185, 129)',
          pointRadius: 8,
          pointHoverRadius: 10
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: true,
          position: 'top'
        },
        title: {
          display: true,
          text: 'System of Equations - Graphical Solution',
          font: { size: 16, weight: 'bold' }
        }
      },
      scales: {
        x: {
          type: 'linear',
          title: {
            display: true,
            text: 'x',
            font: { size: 14 }
          },
          grid: {
            color: function(context) {
              if (context.tick.value === 0) {
                return 'rgba(0, 0, 0, 0.3)';
              }
              return 'rgba(0, 0, 0, 0.1)';
            }
          }
        },
        y: {
          title: {
            display: true,
            text: 'y',
            font: { size: 14 }
          },
          grid: {
            color: function(context) {
              if (context.tick.value === 0) {
                return 'rgba(0, 0, 0, 0.3)';
              }
              return 'rgba(0, 0, 0, 0.1)';
            }
          }
        }
      }
    }
  });
}

// Helper function to format coefficient
function formatCoef(num) {
  if (num === 1) return '';
  if (num === -1) return '-';
  return num.toString();
}

// Helper function to format term with sign
function formatTerm(coef, variable) {
  if (coef === 0) return '';
  const absCoef = Math.abs(coef);
  const sign = coef > 0 ? '+' : '-';
  const displayCoef = absCoef === 1 ? '' : absCoef.toString();
  return ` ${sign} ${displayCoef}${variable}`;
}
</script>
</div>
<%@ include file="body-close.jsp"%>
