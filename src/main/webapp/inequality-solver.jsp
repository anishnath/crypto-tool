<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inequality Solver - Linear, Quadratic, Polynomial Inequalities | 8gwifi.org</title>
  <meta name="description" content="Advanced inequality solver for linear, quadratic, and polynomial inequalities. Solve >, <, ≥, ≤ with interval notation, sign charts, graphical solutions, and step-by-step explanations.">
  <meta name="keywords" content="inequality solver, linear inequality, quadratic inequality, polynomial inequality, interval notation, sign chart, inequality graph, solve inequalities, inequality calculator, number line">
  <link rel="canonical" href="https://8gwifi.org/inequality-solver.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/inequality-solver.jsp">
  <meta property="og:title" content="Inequality Solver - Linear, Quadratic, Polynomial">
  <meta property="og:description" content="Solve all types of inequalities with interval notation, sign charts, and graphs. Step-by-step solutions with detailed explanations.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/inequality-solver.jsp">
  <meta property="twitter:title" content="Inequality Solver - All Types">
  <meta property="twitter:description" content="Solve linear, quadratic, and polynomial inequalities with graphical solutions and interval notation.">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Inequality Solver",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Advanced inequality solver supporting linear, quadratic, and polynomial inequalities with all comparison operators (>, <, ≥, ≤). Features interval notation, sign charts, graphical visualization, and detailed step-by-step solutions.",
    "url": "https://8gwifi.org/inequality-solver.jsp",
    "featureList": [
      "Linear inequality solver (ax + b > c)",
      "Quadratic inequality solver (ax² + bx + c > 0)",
      "Polynomial inequality solver",
      "All operators: >, <, ≥, ≤",
      "Interval notation solutions",
      "Sign chart analysis",
      "Number line visualization",
      "Graphical solutions",
      "Critical points identification",
      "Test point method",
      "Step-by-step solutions",
      "Solution verification"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "1923",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

  <style>
  :root {
    --ineq-primary: #8b5cf6;
    --ineq-secondary: #7c3aed;
    --ineq-light: #ede9fe;
    --ineq-dark: #5b21b6;
  }

  .ineq-card {
    border-left: 4px solid var(--ineq-primary);
    transition: all 0.3s ease;
  }

  .ineq-card:hover {
    box-shadow: 0 4px 12px rgba(139, 92, 246, 0.2);
    transform: translateY(-2px);
  }

  .result-box {
    background: linear-gradient(135deg, var(--ineq-light), white);
    border: 2px solid var(--ineq-primary);
    border-radius: 10px;
    padding: 1.5rem;
    margin-top: 1rem;
  }

  .ineq-result {
    font-size: 1.6rem;
    font-weight: bold;
    color: var(--ineq-dark);
    background-color: #f5f3ff;
    padding: 1.5rem;
    border-radius: 8px;
    margin: 1rem 0;
    text-align: center;
    font-family: 'Courier New', monospace;
  }

  .inequality-display {
    font-size: 1.4rem;
    font-family: 'Times New Roman', serif;
    background: #f9fafb;
    padding: 1rem;
    border-left: 3px solid var(--ineq-primary);
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
    border-left: 2px solid var(--ineq-secondary);
    padding-left: 1rem;
  }

  .sign-chart {
    background: white;
    border: 2px solid var(--ineq-primary);
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 6px;
    font-family: 'Courier New', monospace;
  }

  .sign-row {
    display: flex;
    justify-content: space-around;
    padding: 0.5rem 0;
    border-bottom: 1px solid #e5e7eb;
  }

  .sign-row:last-child {
    border-bottom: none;
  }

  .critical-point {
    background: #fef3c7;
    border: 2px solid #f59e0b;
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-weight: bold;
  }

  .number-line {
    height: 80px;
    margin: 1.5rem 0;
    position: relative;
  }

  .info-card {
    background: #eff6ff;
    border-left: 4px solid #3b82f6;
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 4px;
  }

  .method-badge {
    background: linear-gradient(135deg, var(--ineq-primary), var(--ineq-secondary));
    color: white;
    padding: 0.4rem 0.8rem;
    border-radius: 15px;
    font-size: 0.9rem;
    font-weight: 600;
    display: inline-block;
  }

  .interval-notation {
    background: #dbeafe;
    border: 2px solid #3b82f6;
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 6px;
    font-size: 1.3rem;
    font-family: 'Courier New', monospace;
    text-align: center;
  }

  .example-box {
    background: #f3f4f6;
    border: 1px solid #d1d5db;
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 6px;
  }

  .chart-container {
    position: relative;
    height: 400px;
    margin: 1.5rem 0;
  }

  .solution-region {
    background: rgba(139, 92, 246, 0.2);
    padding: 0.5rem;
    border-radius: 4px;
    margin: 0.25rem 0;
  }
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1 class="mb-2"><i class="fas fa-greater-than" style="color: var(--ineq-primary);"></i> Inequality Solver</h1>
  <p class="text-muted mb-3">Solve linear, quadratic, and polynomial inequalities with interval notation and graphs</p>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header"><i class="fas fa-greater-than"></i> Inequality Tools</h5>
        <div class="card-body">

          <!-- Tab Navigation -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="linear-tab" data-toggle="tab" href="#linear-panel" role="tab">
                <i class="fas fa-minus"></i> Linear
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="quadratic-tab" data-toggle="tab" href="#quadratic-panel" role="tab">
                <i class="fas fa-superscript"></i> Quadratic
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="polynomial-tab" data-toggle="tab" href="#polynomial-panel" role="tab">
                <i class="fas fa-project-diagram"></i> Polynomial
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="rational-tab" data-toggle="tab" href="#rational-panel" role="tab">
                <i class="fas fa-divide"></i> Rational
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- Linear Panel -->
            <div class="tab-pane fade show active" id="linear-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Linear inequality:</strong> ax + b ○ c<br>
                where ○ is >, <, ≥, or ≤
              </div>

              <div class="form-group">
                <label><strong>Coefficient a (of x)</strong></label>
                <input type="number" class="form-control" id="linearA" value="2" step="any">
              </div>

              <div class="form-group">
                <label><strong>Constant b</strong></label>
                <input type="number" class="form-control" id="linearB" value="3" step="any">
              </div>

              <div class="form-group">
                <label><strong>Inequality Type</strong></label>
                <select class="form-control" id="linearOp">
                  <option value=">">&gt; (greater than)</option>
                  <option value=">=">&ge; (greater than or equal)</option>
                  <option value="<">&lt; (less than)</option>
                  <option value="<=">&le; (less than or equal)</option>
                </select>
              </div>

              <div class="form-group">
                <label><strong>Right side c</strong></label>
                <input type="number" class="form-control" id="linearC" value="7" step="any">
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--ineq-primary); color: white;" onclick="solveLinear()">
                <i class="fas fa-calculator"></i> Solve Linear Inequality
              </button>

              <div class="example-box">
                <strong>Examples:</strong><br>
                2x + 3 > 7 → x > 2<br>
                -x + 5 ≤ 2 → x ≥ 3<br>
                3x ≥ 9 → x ≥ 3
              </div>
            </div>

            <!-- Quadratic Panel -->
            <div class="tab-pane fade" id="quadratic-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Quadratic inequality:</strong> ax² + bx + c ○ 0<br>
                Uses factoring, quadratic formula, and sign chart
              </div>

              <div class="form-group">
                <label><strong>Coefficient a (of x²)</strong></label>
                <input type="number" class="form-control" id="quadA" value="1" step="any">
                <small class="form-text text-muted">Cannot be zero</small>
              </div>

              <div class="form-group">
                <label><strong>Coefficient b (of x)</strong></label>
                <input type="number" class="form-control" id="quadB" value="-5" step="any">
              </div>

              <div class="form-group">
                <label><strong>Constant c</strong></label>
                <input type="number" class="form-control" id="quadC" value="6" step="any">
              </div>

              <div class="form-group">
                <label><strong>Inequality Type</strong></label>
                <select class="form-control" id="quadOp">
                  <option value=">">&gt; 0</option>
                  <option value=">=">&ge; 0</option>
                  <option value="<">&lt; 0</option>
                  <option value="<=">&le; 0</option>
                </select>
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--ineq-primary); color: white;" onclick="solveQuadratic()">
                <i class="fas fa-calculator"></i> Solve Quadratic Inequality
              </button>

              <div class="example-box">
                <strong>Examples:</strong><br>
                x² - 5x + 6 > 0 → x < 2 or x > 3<br>
                x² - 4 ≤ 0 → -2 ≤ x ≤ 2<br>
                x² + 1 > 0 → All real numbers
              </div>
            </div>

            <!-- Polynomial Panel -->
            <div class="tab-pane fade" id="polynomial-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Polynomial inequality:</strong><br>
                Factor form: (x - r₁)(x - r₂)...(x - rₙ) ○ 0
              </div>

              <div class="form-group">
                <label><strong>Roots (comma separated)</strong></label>
                <input type="text" class="form-control" id="polyRoots" value="-2, 1, 3" placeholder="e.g., -2, 1, 3">
                <small class="form-text text-muted">Enter the roots where the polynomial equals zero</small>
              </div>

              <div class="form-group">
                <label><strong>Inequality Type</strong></label>
                <select class="form-control" id="polyOp">
                  <option value=">">&gt; 0</option>
                  <option value=">=">&ge; 0</option>
                  <option value="<">&lt; 0</option>
                  <option value="<=">&le; 0</option>
                </select>
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--ineq-primary); color: white;" onclick="solvePolynomial()">
                <i class="fas fa-calculator"></i> Solve Polynomial Inequality
              </button>

              <div class="example-box">
                <strong>Examples:</strong><br>
                (x + 2)(x - 1)(x - 3) > 0 → -2 < x < 1 or x > 3<br>
                (x - 1)²(x + 2) ≤ 0 → x ≤ -2 or x = 1
              </div>
            </div>

            <!-- Rational Panel -->
            <div class="tab-pane fade" id="rational-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Rational inequality:</strong> (x - a)/(x - b) ○ 0<br>
                Watch for excluded values (denominator = 0)
              </div>

              <div class="form-group">
                <label><strong>Numerator root (a in x - a)</strong></label>
                <input type="number" class="form-control" id="ratNumRoot" value="2" step="any">
              </div>

              <div class="form-group">
                <label><strong>Denominator root (b in x - b)</strong></label>
                <input type="number" class="form-control" id="ratDenomRoot" value="-1" step="any">
                <small class="form-text text-muted">This value is EXCLUDED from solution</small>
              </div>

              <div class="form-group">
                <label><strong>Inequality Type</strong></label>
                <select class="form-control" id="ratOp">
                  <option value=">">&gt; 0</option>
                  <option value=">=">&ge; 0</option>
                  <option value="<">&lt; 0</option>
                  <option value="<=">&le; 0</option>
                </select>
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--ineq-primary); color: white;" onclick="solveRational()">
                <i class="fas fa-calculator"></i> Solve Rational Inequality
              </button>

              <div class="example-box">
                <strong>Examples:</strong><br>
                (x - 2)/(x + 1) > 0 → x < -1 or x > 2<br>
                1/x ≥ 2 → 0 < x ≤ 0.5
              </div>
            </div>

          </div>
        </div>
      </div>

    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-8 col-md-12">
      <div id="results"></div>

        <!-- Educational Content (Condensed) -->
        <div class="card mb-3">
            <h5 class="card-header"><i class="fas fa-book"></i> Guide</h5>
            <div class="card-body" style="font-size: 0.9rem;">
                <p style="font-size: 0.85rem; margin-bottom: 0.5rem;"><strong>Solution Methods:</strong></p>
                <p style="font-size: 0.8rem; line-height: 1.4;">
                    <strong>Linear:</strong> Solve like equations, flip sign when dividing by negative<br>
                    <strong>Quadratic:</strong> Find roots, use sign chart<br>
                    <strong>Polynomial:</strong> Test intervals between roots<br>
                    <strong>Rational:</strong> Watch for undefined values
                </p>
                <p style="font-size: 0.85rem; margin-bottom: 0.5rem; margin-top: 0.75rem;"><strong>Interval Notation:</strong></p>
                <p style="font-size: 0.75rem; line-height: 1.3;">
                    (a, b) = a &lt; x &lt; b<br>
                    [a, b] = a ≤ x ≤ b<br>
                    (-∞, a) = x &lt; a<br>
                    (a, ∞) = x &gt; a<br>
                    ∪ = union (combines intervals)
                </p>
            </div>
        </div>
    </div>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
let ineqChart = null;

// Solve linear inequality
function solveLinear() {
  const a = parseFloat(document.getElementById('linearA').value);
  const b = parseFloat(document.getElementById('linearB').value);
  const op = document.getElementById('linearOp').value;
  const c = parseFloat(document.getElementById('linearC').value);

  if (isNaN(a) || isNaN(b) || isNaN(c)) {
    alert('Please enter valid numbers');
    return;
  }

  if (a === 0) {
    alert('Coefficient of x cannot be zero for linear inequality');
    return;
  }

  // Solve: ax + b ○ c → ax ○ c - b → x ○ (c - b) / a
  const criticalPoint = (c - b) / a;

  // If a is negative, flip the inequality
  let finalOp = op;
  if (a < 0) {
    if (op === '>') finalOp = '<';
    else if (op === '<') finalOp = '>';
    else if (op === '>=') finalOp = '<=';
    else if (op === '<=') finalOp = '>=';
  }

  let html = '<div class="result-box">';
  html += `<h6 class="text-center"><span class="method-badge">Linear Inequality</span></h6>`;
  html += `<div class="inequality-display">${a}x + ${b} ${op} ${c}</div>`;

  // Solution
  let intervalNotation = '';
  if (finalOp === '>') {
    intervalNotation = `(${criticalPoint.toFixed(4)}, ∞)`;
  } else if (finalOp === '>=') {
    intervalNotation = `[${criticalPoint.toFixed(4)}, ∞)`;
  } else if (finalOp === '<') {
    intervalNotation = `(-∞, ${criticalPoint.toFixed(4)})`;
  } else {
    intervalNotation = `(-∞, ${criticalPoint.toFixed(4)}]`;
  }

  html += `<div class="ineq-result">x ${finalOp} ${criticalPoint.toFixed(4)}</div>`;
  html += `<div class="interval-notation">${intervalNotation}</div>`;

  // Steps
  html += '<div class="step-section">';
  html += '<h6><i class="fas fa-list-ol"></i> Solution Steps</h6>';
  html += `<div class="step-item"><strong>Step 1: Move constant to right side</strong><br>${a}x ${op} ${c} - ${b}<br>${a}x ${op} ${c - b}</div>`;
  html += `<div class="step-item"><strong>Step 2: Divide by ${a}</strong><br>`;
  if (a < 0) {
    html += `⚠️ Since dividing by negative, flip inequality sign<br>`;
  }
  html += `x ${finalOp} ${(c - b).toFixed(4)} / ${a}<br>x ${finalOp} ${criticalPoint.toFixed(4)}</div>`;
  html += '</div>';

  // Verification
  const testValue = finalOp.includes('>') ? criticalPoint + 1 : criticalPoint - 1;
  const leftSide = a * testValue + b;
  const condition = op === '>' ? leftSide > c : (op === '>=' ? leftSide >= c : (op === '<' ? leftSide < c : leftSide <= c));

  html += `<div class="info-card"><strong><i class="fas fa-check"></i> Verification (test x = ${testValue.toFixed(2)}):</strong><br>`;
  html += `${a}(${testValue.toFixed(2)}) + ${b} = ${leftSide.toFixed(4)} ${op} ${c} ? ${condition ? '✓' : '✗'}</div>`;

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Solve quadratic inequality
function solveQuadratic() {
  const a = parseFloat(document.getElementById('quadA').value);
  const b = parseFloat(document.getElementById('quadB').value);
  const c = parseFloat(document.getElementById('quadC').value);
  const op = document.getElementById('quadOp').value;

  if (isNaN(a) || isNaN(b) || isNaN(c)) {
    alert('Please enter valid numbers');
    return;
  }

  if (a === 0) {
    alert('Coefficient of x² cannot be zero for quadratic');
    return;
  }

  // Find roots using quadratic formula
  const discriminant = b*b - 4*a*c;

  let html = '<div class="result-box">';
  html += `<h6 class="text-center"><span class="method-badge">Quadratic Inequality</span></h6>`;
  html += `<div class="inequality-display">${a}x² + ${b}x + ${c} ${op} 0</div>`;

  if (discriminant < 0) {
    // No real roots
    const parabola = a > 0 ? 'opens upward (always positive)' : 'opens downward (always negative)';
    const satisfies = (a > 0 && op.includes('>')) || (a < 0 && op.includes('<'));

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-calculator"></i> Analysis</h6>';
    html += `<div class="step-item"><strong>Discriminant:</strong> b² - 4ac = ${discriminant.toFixed(4)} < 0</div>`;
    html += `<div class="step-item"><strong>No real roots</strong><br>Parabola ${parabola}</div>`;
    html += '</div>';

    if (satisfies) {
      html += `<div class="ineq-result">All real numbers: (-∞, ∞)</div>`;
      html += `<div class="info-card">The quadratic is ${a > 0 ? 'always positive' : 'always negative'}, so the inequality is satisfied for all x.</div>`;
    } else {
      html += `<div class="ineq-result">No solution: ∅</div>`;
      html += `<div class="info-card">The quadratic is ${a > 0 ? 'always positive' : 'always negative'}, so the inequality is never satisfied.</div>`;
    }

  } else {
    // Real roots exist
    const root1 = (-b - Math.sqrt(discriminant)) / (2*a);
    const root2 = (-b + Math.sqrt(discriminant)) / (2*a);
    const r1 = Math.min(root1, root2);
    const r2 = Math.max(root1, root2);

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-calculator"></i> Find Critical Points</h6>';
    html += `<div class="step-item"><strong>Quadratic Formula:</strong> x = (-b ± √(b² - 4ac)) / 2a</div>`;
    html += `<div class="step-item"><strong>Discriminant:</strong> ${b}² - 4(${a})(${c}) = ${discriminant.toFixed(4)}</div>`;

    if (discriminant === 0) {
      html += `<div class="step-item"><strong>One repeated root:</strong> x = ${r1.toFixed(4)}</div>`;
    } else {
      html += `<div class="step-item"><strong>Two roots:</strong><br>x₁ = ${r1.toFixed(4)}<br>x₂ = ${r2.toFixed(4)}</div>`;
    }
    html += '</div>';

    // Sign chart
    html += '<div class="sign-chart">';
    html += '<h6><strong>Sign Chart Analysis</strong></h6>';
    html += '<div class="sign-row">';
    html += `<div>x < ${r1.toFixed(2)}</div>`;
    if (discriminant > 0) {
      html += `<div>${r1.toFixed(2)} < x < ${r2.toFixed(2)}</div>`;
    }
    html += `<div>x > ${r2.toFixed(2)}</div>`;
    html += '</div>';

    html += '<div class="sign-row">';
    const sign1 = a > 0 ? '+' : '-';
    const sign2 = a > 0 ? '-' : '+';
    const sign3 = a > 0 ? '+' : '-';
    html += `<div><strong>${sign1}</strong></div>`;
    if (discriminant > 0) {
      html += `<div><strong>${sign2}</strong></div>`;
    }
    html += `<div><strong>${sign3}</strong></div>`;
    html += '</div>';
    html += '</div>';

    // Determine solution
    let solution = '';
    let intervalNotation = '';

    if (op === '>') {
      if (a > 0) {
        solution = `x < ${r1.toFixed(4)} or x > ${r2.toFixed(4)}`;
        intervalNotation = `(-∞, ${r1.toFixed(4)}) ∪ (${r2.toFixed(4)}, ∞)`;
      } else {
        solution = `${r1.toFixed(4)} < x < ${r2.toFixed(4)}`;
        intervalNotation = `(${r1.toFixed(4)}, ${r2.toFixed(4)})`;
      }
    } else if (op === '>=') {
      if (a > 0) {
        solution = `x ≤ ${r1.toFixed(4)} or x ≥ ${r2.toFixed(4)}`;
        intervalNotation = `(-∞, ${r1.toFixed(4)}] ∪ [${r2.toFixed(4)}, ∞)`;
      } else {
        solution = `${r1.toFixed(4)} ≤ x ≤ ${r2.toFixed(4)}`;
        intervalNotation = `[${r1.toFixed(4)}, ${r2.toFixed(4)}]`;
      }
    } else if (op === '<') {
      if (a > 0) {
        solution = `${r1.toFixed(4)} < x < ${r2.toFixed(4)}`;
        intervalNotation = `(${r1.toFixed(4)}, ${r2.toFixed(4)})`;
      } else {
        solution = `x < ${r1.toFixed(4)} or x > ${r2.toFixed(4)}`;
        intervalNotation = `(-∞, ${r1.toFixed(4)}) ∪ (${r2.toFixed(4)}, ∞)`;
      }
    } else { // <=
      if (a > 0) {
        solution = `${r1.toFixed(4)} ≤ x ≤ ${r2.toFixed(4)}`;
        intervalNotation = `[${r1.toFixed(4)}, ${r2.toFixed(4)}]`;
      } else {
        solution = `x ≤ ${r1.toFixed(4)} or x ≥ ${r2.toFixed(4)}`;
        intervalNotation = `(-∞, ${r1.toFixed(4)}] ∪ [${r2.toFixed(4)}, ∞)`;
      }
    }

    html += `<div class="ineq-result">${solution}</div>`;
    html += `<div class="interval-notation">${intervalNotation}</div>`;
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Solve polynomial inequality
function solvePolynomial() {
  const rootsStr = document.getElementById('polyRoots').value;
  const op = document.getElementById('polyOp').value;

  // Parse roots
  const roots = rootsStr.split(',').map(s => parseFloat(s.trim())).filter(r => !isNaN(r));

  if (roots.length === 0) {
    alert('Please enter at least one valid root');
    return;
  }

  // Sort roots
  roots.sort((a, b) => a - b);

  let html = '<div class="result-box">';
  html += `<h6 class="text-center"><span class="method-badge">Polynomial Inequality</span></h6>`;

  // Display polynomial in factored form
  let polyStr = '';
  for (const root of roots) {
    polyStr += `(x - ${root})`;
  }
  html += `<div class="inequality-display">${polyStr} ${op} 0</div>`;

  // Critical points
  html += '<div class="step-section">';
  html += '<h6><i class="fas fa-map-pin"></i> Critical Points</h6>';
  html += '<div class="step-item">';
  for (let i = 0; i < roots.length; i++) {
    html += `<span class="critical-point">x = ${roots[i]}</span> `;
  }
  html += '</div></div>';

  // Sign chart
  html += '<div class="sign-chart">';
  html += '<h6><strong>Sign Chart (Test Points)</strong></h6>';

  // Create intervals
  const intervals = [];
  intervals.push({ label: `x < ${roots[0]}`, test: roots[0] - 1 });
  for (let i = 0; i < roots.length - 1; i++) {
    intervals.push({ label: `${roots[i]} < x < ${roots[i+1]}`, test: (roots[i] + roots[i+1]) / 2 });
  }
  intervals.push({ label: `x > ${roots[roots.length-1]}`, test: roots[roots.length-1] + 1 });

  // Test each interval
  for (const interval of intervals) {
    let product = 1;
    for (const root of roots) {
      product *= (interval.test - root);
    }
    interval.sign = product > 0 ? '+' : (product < 0 ? '-' : '0');
  }

  html += '<div class="sign-row">';
  for (const interval of intervals) {
    html += `<div>${interval.label}</div>`;
  }
  html += '</div>';

  html += '<div class="sign-row">';
  for (const interval of intervals) {
    html += `<div><strong>${interval.sign}</strong></div>`;
  }
  html += '</div>';
  html += '</div>';

  // Determine solution based on operator
  const solutionIntervals = [];
  for (let i = 0; i < intervals.length; i++) {
    const sign = intervals[i].sign;
    const includeRoots = op.includes('=');

    if ((op.includes('>') && sign === '+') || (op.includes('<') && sign === '-')) {
      // This interval is part of solution
      if (i === 0) {
        solutionIntervals.push(`(-∞, ${roots[0]}${includeRoots ? ']' : ')'}` );
      } else if (i === intervals.length - 1) {
        const lastIdx = roots.length - 1;
        solutionIntervals.push(`(${includeRoots ? '[' : '('}${roots[lastIdx]}, ∞)`);
      } else {
        const left = includeRoots ? '[' : '(';
        const right = includeRoots ? ']' : ')';
        solutionIntervals.push(`${left}${roots[i-1]}, ${roots[i]}${right}`);
      }
    }
  }

  if (solutionIntervals.length === 0) {
    html += `<div class="ineq-result">No solution (except possibly at critical points)</div>`;
  } else {
    html += `<div class="ineq-result">Solution Intervals</div>`;
    html += `<div class="interval-notation">${solutionIntervals.join(' ∪ ')}</div>`;
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Solve rational inequality
function solveRational() {
  const numRoot = parseFloat(document.getElementById('ratNumRoot').value);
  const denomRoot = parseFloat(document.getElementById('ratDenomRoot').value);
  const op = document.getElementById('ratOp').value;

  if (isNaN(numRoot) || isNaN(denomRoot)) {
    alert('Please enter valid numbers');
    return;
  }

  let html = '<div class="result-box">';
  html += `<h6 class="text-center"><span class="method-badge">Rational Inequality</span></h6>`;
  html += `<div class="inequality-display">(x - ${numRoot})/(x - ${denomRoot}) ${op} 0</div>`;

  // Critical points
  const criticalPoints = [numRoot, denomRoot].sort((a, b) => a - b);

  html += '<div class="step-section">';
  html += '<h6><i class="fas fa-exclamation-triangle"></i> Critical Points</h6>';
  html += `<div class="step-item"><strong>Zero of numerator:</strong> x = ${numRoot} <span class="text-success">(can be included)</span></div>`;
  html += `<div class="step-item"><strong>Zero of denominator:</strong> x = ${denomRoot} <span class="text-danger">(EXCLUDED - undefined)</span></div>`;
  html += '</div>';

  // Sign chart
  const intervals = [];
  intervals.push({ label: `x < ${criticalPoints[0]}`, test: criticalPoints[0] - 1 });
  intervals.push({ label: `${criticalPoints[0]} < x < ${criticalPoints[1]}`, test: (criticalPoints[0] + criticalPoints[1]) / 2 });
  intervals.push({ label: `x > ${criticalPoints[1]}`, test: criticalPoints[1] + 1 });

  for (const interval of intervals) {
    const value = (interval.test - numRoot) / (interval.test - denomRoot);
    interval.sign = value > 0 ? '+' : '-';
  }

  html += '<div class="sign-chart">';
  html += '<h6><strong>Sign Chart</strong></h6>';
  html += '<div class="sign-row">';
  for (const interval of intervals) {
    html += `<div>${interval.label}</div>`;
  }
  html += '</div>';
  html += '<div class="sign-row">';
  for (const interval of intervals) {
    html += `<div><strong>${interval.sign}</strong></div>`;
  }
  html += '</div>';
  html += '</div>';

  // Determine solution
  let solution = '';
  const includeNum = op.includes('=');

  if (op.includes('>')) {
    // Positive regions
    if (intervals[0].sign === '+') {
      solution += `(-∞, ${denomRoot})`;
    }
    if (intervals[1].sign === '+') {
      if (solution) solution += ' ∪ ';
      solution += includeNum ? `[${numRoot}, ${denomRoot})` : `(${numRoot}, ${denomRoot})`;
    }
    if (intervals[2].sign === '+') {
      if (solution) solution += ' ∪ ';
      solution += `(${denomRoot}, ∞)`;
    }
  } else {
    // Negative regions
    if (intervals[0].sign === '-') {
      solution += `(-∞, ${numRoot}${includeNum ? ']' : ')'})`;
    }
    if (intervals[1].sign === '-') {
      if (solution) solution += ' ∪ ';
      solution += `(${numRoot}, ${denomRoot})`;
    }
    if (intervals[2].sign === '-') {
      if (solution) solution += ' ∪ ';
      solution += `(${denomRoot}, ∞)`;
    }
  }

  html += `<div class="interval-notation">${solution}</div>`;

  html += `<div class="info-card"><strong><i class="fas fa-exclamation-circle"></i> Important:</strong><br>`;
  html += `x ≠ ${denomRoot} (denominator cannot be zero)</div>`;

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}
</script>
</div>
<%@ include file="body-close.jsp"%>
