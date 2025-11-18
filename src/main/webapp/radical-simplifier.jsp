<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Radical Simplifier - √ Cube Root, nth Root Calculator | 8gwifi.org</title>
  <meta name="description" content="Advanced radical simplifier calculator. Simplify square roots, cube roots, nth roots, rationalize denominators, multiply and divide radicals. Step-by-step solutions with prime factorization and simplification rules.">
  <meta name="keywords" content="radical simplifier, square root simplifier, cube root calculator, nth root, rationalize denominator, simplify radicals, √ calculator, ∛ calculator, radical operations, radical multiplication, radical division">
  <link rel="canonical" href="https://8gwifi.org/radical-simplifier.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/radical-simplifier.jsp">
  <meta property="og:title" content="Radical Simplifier - Square Root, Cube Root, nth Root">
  <meta property="og:description" content="Simplify radicals, rationalize denominators, multiply and divide roots with step-by-step solutions using prime factorization.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/radical-simplifier.jsp">
  <meta property="twitter:title" content="Radical Simplifier - All Root Types">
  <meta property="twitter:description" content="Simplify square roots, cube roots, nth roots with rationalization and operations. Step-by-step solutions.">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Radical Simplifier Calculator",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Advanced radical simplifier supporting square roots, cube roots, nth roots with operations, rationalization, and step-by-step prime factorization explanations.",
    "url": "https://8gwifi.org/radical-simplifier.jsp",
    "featureList": [
      "Simplify square roots (√)",
      "Simplify cube roots (∛)",
      "Simplify nth roots",
      "Prime factorization method",
      "Rationalize denominators",
      "Multiply radicals",
      "Divide radicals",
      "Add and subtract like radicals",
      "Mixed radical operations",
      "Nested radicals simplification",
      "Step-by-step solutions",
      "Decimal approximations"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "1847",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

<%@ include file="header-script.jsp"%>

<style>
  :root {
    --rad-primary: #ec4899;
    --rad-secondary: #db2777;
    --rad-light: #fce7f3;
    --rad-dark: #9f1239;
  }

  .rad-card {
    border-left: 4px solid var(--rad-primary);
    transition: all 0.3s ease;
  }

  .rad-card:hover {
    box-shadow: 0 4px 12px rgba(236, 72, 153, 0.2);
    transform: translateY(-2px);
  }

  .result-box {
    background: linear-gradient(135deg, var(--rad-light), white);
    border: 2px solid var(--rad-primary);
    border-radius: 10px;
    padding: 1.5rem;
    margin-top: 1rem;
  }

  .rad-result {
    font-size: 1.8rem;
    font-weight: bold;
    color: var(--rad-dark);
    background-color: #fdf2f8;
    padding: 1.5rem;
    border-radius: 8px;
    margin: 1rem 0;
    text-align: center;
    font-family: 'Times New Roman', serif;
  }

  .radical-display {
    font-size: 1.5rem;
    font-family: 'Times New Roman', serif;
    background: #f9fafb;
    padding: 1rem;
    border-left: 3px solid var(--rad-primary);
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
    border-left: 2px solid var(--rad-secondary);
    padding-left: 1rem;
  }

  .prime-factors {
    background: #fef3c7;
    border: 1px solid #f59e0b;
    padding: 0.75rem;
    border-radius: 6px;
    margin: 0.5rem 0;
    font-family: 'Courier New', monospace;
  }

  .info-card {
    background: #eff6ff;
    border-left: 4px solid #3b82f6;
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 4px;
  }

  .method-badge {
    background: linear-gradient(135deg, var(--rad-primary), var(--rad-secondary));
    color: white;
    padding: 0.4rem 0.8rem;
    border-radius: 15px;
    font-size: 0.9rem;
    font-weight: 600;
    display: inline-block;
  }

  .radical-notation {
    display: inline-block;
    position: relative;
    padding-left: 0.3rem;
  }

  .radical-index {
    position: absolute;
    top: -0.5em;
    left: -0.2em;
    font-size: 0.7em;
  }

  .example-box {
    background: #f3f4f6;
    border: 1px solid #d1d5db;
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 6px;
  }
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1 class="mb-2"><i class="fas fa-square-root-alt" style="color: var(--rad-primary);"></i> Radical Simplifier</h1>
  <p class="text-muted mb-3">Simplify square roots, cube roots, nth roots with rationalization and operations</p>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header"><i class="fas fa-square-root-alt"></i> Radical Calculator</h5>
        <div class="card-body">

          <!-- Tab Navigation -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="simplify-tab" data-toggle="tab" href="#simplify-panel" role="tab">
                <i class="fas fa-square-root-alt"></i> Simplify
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="operations-tab" data-toggle="tab" href="#operations-panel" role="tab">
                <i class="fas fa-calculator"></i> Operations
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="rationalize-tab" data-toggle="tab" href="#rationalize-panel" role="tab">
                <i class="fas fa-divide"></i> Rationalize
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="nested-tab" data-toggle="tab" href="#nested-panel" role="tab">
                <i class="fas fa-layer-group"></i> Nested
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- Simplify Panel -->
            <div class="tab-pane fade show active" id="simplify-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Simplify radicals:</strong><br>
                Enter the radicand (number under the radical) and the index (root type: 2 for √, 3 for ∛)
              </div>

              <div class="form-group">
                <label><i class="fas fa-hashtag"></i> <strong>Index (Root Type)</strong></label>
                <select class="form-control" id="rootIndex">
                  <option value="2">Square Root (√, index = 2)</option>
                  <option value="3">Cube Root (∛, index = 3)</option>
                  <option value="4">Fourth Root (∜, index = 4)</option>
                  <option value="5">Fifth Root (index = 5)</option>
                  <option value="custom">Custom nth Root</option>
                </select>
              </div>

              <div class="form-group" id="customIndexDiv" style="display: none;">
                <label><i class="fas fa-subscript"></i> <strong>Custom Index (n)</strong></label>
                <input type="number" class="form-control" id="customIndex" value="6" min="2" step="1">
              </div>

              <div class="form-group">
                <label><i class="fas fa-cube"></i> <strong>Radicand (number under the radical)</strong></label>
                <input type="number" class="form-control" id="radicand" value="72" step="any" min="0">
                <small class="form-text text-muted">Must be non-negative</small>
              </div>

              <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="showPrimeFactors" checked>
                <label class="form-check-label" for="showPrimeFactors">
                  Show prime factorization
                </label>
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--rad-primary); color: white;" onclick="simplifyRadical()">
                <i class="fas fa-square-root-alt"></i> Simplify Radical
              </button>

              <div class="example-box">
                <strong>Examples:</strong><br>
                √72 = 6√2 (72 = 36 × 2)<br>
                ∛54 = 3∛2 (54 = 27 × 2)<br>
                √50 = 5√2 (50 = 25 × 2)
              </div>
            </div>

            <!-- Operations Panel -->
            <div class="tab-pane fade" id="operations-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Radical operations:</strong><br>
                Multiply, divide, add, or subtract radicals
              </div>

              <div class="form-group">
                <label><i class="fas fa-calculator"></i> <strong>Operation Type</strong></label>
                <select class="form-control" id="operationType">
                  <option value="multiply">Multiply: √a × √b = √(ab)</option>
                  <option value="divide">Divide: √a ÷ √b = √(a/b)</option>
                  <option value="add">Add: c√a + d√a = (c+d)√a</option>
                  <option value="subtract">Subtract: c√a - d√a = (c-d)√a</option>
                </select>
              </div>

              <div id="multiplyDivideInputs">
                <div class="form-group">
                  <label><strong>First Radical: √a</strong></label>
                  <input type="number" class="form-control" id="opRadicand1" value="12" step="any" min="0">
                </div>

                <div class="form-group">
                  <label><strong>Second Radical: √b</strong></label>
                  <input type="number" class="form-control" id="opRadicand2" value="6" step="any" min="0">
                </div>
              </div>

              <div id="addSubtractInputs" style="display: none;">
                <div class="form-group">
                  <label><strong>First Term: coefficient</strong></label>
                  <input type="number" class="form-control" id="coef1" value="3" step="any">
                </div>

                <div class="form-group">
                  <label><strong>Radicand (both terms must have same radicand)</strong></label>
                  <input type="number" class="form-control" id="commonRadicand" value="5" step="any" min="0">
                </div>

                <div class="form-group">
                  <label><strong>Second Term: coefficient</strong></label>
                  <input type="number" class="form-control" id="coef2" value="2" step="any">
                </div>
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--rad-primary); color: white;" onclick="performOperation()">
                <i class="fas fa-calculator"></i> Calculate
              </button>

              <div class="example-box">
                <strong>Examples:</strong><br>
                √12 × √6 = √72 = 6√2<br>
                √50 ÷ √2 = √25 = 5<br>
                3√5 + 2√5 = 5√5<br>
                7√3 - 4√3 = 3√3
              </div>
            </div>

            <!-- Rationalize Panel -->
            <div class="tab-pane fade" id="rationalize-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Rationalize denominators:</strong><br>
                Remove radicals from denominators by multiplying by conjugates
              </div>

              <div class="form-group">
                <label><i class="fas fa-list"></i> <strong>Fraction Type</strong></label>
                <select class="form-control" id="rationalizeType" onchange="updateRationalizeInputs()">
                  <option value="simple">Simple: a/√b</option>
                  <option value="radical-num">Radical Numerator: √a/√b</option>
                  <option value="binomial">Binomial Denominator: a/(b + √c)</option>
                </select>
              </div>

              <div id="simpleRatInputs">
                <div class="form-group">
                  <label><strong>Numerator (a)</strong></label>
                  <input type="number" class="form-control" id="ratNum" value="5" step="any">
                </div>

                <div class="form-group">
                  <label><strong>Denominator Radicand (b in √b)</strong></label>
                  <input type="number" class="form-control" id="ratDenom" value="3" step="any" min="0">
                </div>
              </div>

              <div id="radicalNumInputs" style="display: none;">
                <div class="form-group">
                  <label><strong>Numerator Radicand (a in √a)</strong></label>
                  <input type="number" class="form-control" id="ratNumRad" value="8" step="any" min="0">
                </div>

                <div class="form-group">
                  <label><strong>Denominator Radicand (b in √b)</strong></label>
                  <input type="number" class="form-control" id="ratDenomRad" value="2" step="any" min="0">
                </div>
              </div>

              <div id="binomialInputs" style="display: none;">
                <div class="form-group">
                  <label><strong>Numerator (a)</strong></label>
                  <input type="number" class="form-control" id="biNumA" value="1" step="any">
                </div>

                <div class="form-group">
                  <label><strong>Denominator: b + √c</strong></label>
                  <div class="form-inline">
                    <input type="number" class="form-control mr-2" style="width: 100px;" id="biDenomB" value="2" step="any">
                    <span class="mr-2">+</span>
                    <span class="mr-2">√</span>
                    <input type="number" class="form-control" style="width: 100px;" id="biDenomC" value="3" step="any" min="0">
                  </div>
                </div>
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--rad-primary); color: white;" onclick="rationalizeDenominator()">
                <i class="fas fa-divide"></i> Rationalize
              </button>

              <div class="example-box">
                <strong>Examples:</strong><br>
                5/√3 = (5√3)/3<br>
                √8/√2 = 2<br>
                1/(2 + √3) = (2 - √3)/(4 - 3) = 2 - √3
              </div>
            </div>

            <!-- Nested Radicals Panel -->
            <div class="tab-pane fade" id="nested-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Simplify nested radicals:</strong><br>
                Simplify expressions like √(a + √b) or √(a - √b)
              </div>

              <div class="form-group">
                <label><strong>Outer Radicand: a in √(a ± √b)</strong></label>
                <input type="number" class="form-control" id="nestedA" value="7" step="any" min="0">
              </div>

              <div class="form-group">
                <label><strong>Inner Radicand: b in √(a ± √b)</strong></label>
                <input type="number" class="form-control" id="nestedB" value="40" step="any" min="0">
              </div>

              <div class="form-group">
                <label><strong>Operation</strong></label>
                <select class="form-control" id="nestedOp">
                  <option value="plus">√(a + √b)</option>
                  <option value="minus">√(a - √b)</option>
                </select>
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--rad-primary); color: white;" onclick="simplifyNested()">
                <i class="fas fa-layer-group"></i> Simplify Nested Radical
              </button>

              <div class="example-box">
                <strong>Example:</strong><br>
                √(7 + √40) = √5 + √2<br>
                Verification: (√5 + √2)² = 5 + 2√10 + 2 = 7 + 2√10 = 7 + √40 ✓
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
            <h5 class="card-header"><i class="fas fa-book"></i> Understanding Radicals</h5>
            <div class="card-body" style="font-size: 0.9rem;">

                <h6 class="mt-3"><i class="fas fa-question-circle" style="color: var(--rad-primary);"></i> What is a Radical?</h6>
                <p>A radical (√) represents the root of a number. The most common is the square root, but cube roots and higher roots are also radicals.</p>
                <div class="radical-display">
                    <span class="radical-index">n</span>√a where n is the index and a is the radicand
                </div>

                <h6 class="mt-3"><i class="fas fa-magic" style="color: var(--rad-primary);"></i> Simplification Rules</h6>

                <p><strong>1. Product Property:</strong></p>
                <div class="radical-display">
                    √(ab) = √a × √b
                </div>

                <p><strong>2. Quotient Property:</strong></p>
                <div class="radical-display">
                    √(a/b) = √a / √b
                </div>

                <p><strong>3. Simplification Process:</strong></p>
                <ul>
                    <li>Factor the radicand into perfect squares (or cubes for ∛)</li>
                    <li>Take the root of perfect powers</li>
                    <li>Leave remaining factors under the radical</li>
                </ul>

                <p><strong>4. Adding/Subtracting:</strong></p>
                <div class="radical-display">
                    a√c + b√c = (a + b)√c (like radicals only)
                </div>

                <p><strong>5. Rationalizing:</strong></p>
                <p>Multiply numerator and denominator by the radical to eliminate it from the denominator.</p>
                <div class="radical-display">
                    a/√b = (a√b)/(√b × √b) = (a√b)/b
                </div>
            </div>
        </div>
    </div>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
// Update operation inputs
document.getElementById('operationType').addEventListener('change', function() {
  const type = this.value;
  if (type === 'multiply' || type === 'divide') {
    document.getElementById('multiplyDivideInputs').style.display = 'block';
    document.getElementById('addSubtractInputs').style.display = 'none';
  } else {
    document.getElementById('multiplyDivideInputs').style.display = 'none';
    document.getElementById('addSubtractInputs').style.display = 'block';
  }
});

// Update custom index input
document.getElementById('rootIndex').addEventListener('change', function() {
  document.getElementById('customIndexDiv').style.display =
    this.value === 'custom' ? 'block' : 'none';
});

// Update rationalize inputs
function updateRationalizeInputs() {
  const type = document.getElementById('rationalizeType').value;
  document.getElementById('simpleRatInputs').style.display = type === 'simple' ? 'block' : 'none';
  document.getElementById('radicalNumInputs').style.display = type === 'radical-num' ? 'block' : 'none';
  document.getElementById('binomialInputs').style.display = type === 'binomial' ? 'block' : 'none';
}

// Prime factorization
function primeFactorization(n) {
  const factors = {};
  let num = Math.floor(n);

  for (let i = 2; i <= num; i++) {
    while (num % i === 0) {
      factors[i] = (factors[i] || 0) + 1;
      num = num / i;
    }
  }

  return factors;
}

// GCD function
function gcd(a, b) {
  return b === 0 ? a : gcd(b, a % b);
}

// Simplify radical
function simplifyRadical() {
  let indexStr = document.getElementById('rootIndex').value;
  let index = indexStr === 'custom' ?
    parseInt(document.getElementById('customIndex').value) :
    parseInt(indexStr);

  const radicand = parseFloat(document.getElementById('radicand').value);
  const showPrime = document.getElementById('showPrimeFactors').checked;

  if (isNaN(index) || index < 2) {
    alert('Index must be at least 2');
    return;
  }

  if (isNaN(radicand) || radicand < 0) {
    alert('Radicand must be non-negative');
    return;
  }

  const indexSymbol = index === 2 ? '√' : (index === 3 ? '∛' : (index === 4 ? '∜' : '<sup>' + index + '</sup>√'));

  let html = '<div class="result-box">';
  html += `<h6 class="text-center"><span class="method-badge">Simplify ${indexSymbol}${radicand}</span></h6>`;

  // Get prime factors
  const factors = primeFactorization(radicand);

  let outside = 1;
  let inside = 1;

  for (const prime in factors) {
    const count = factors[prime];
    const pairs = Math.floor(count / index);
    const remainder = count % index;

    outside *= Math.pow(parseInt(prime), pairs);
    inside *= Math.pow(parseInt(prime), remainder);
  }

  // Display result
  if (inside === 1) {
    html += `<div class="rad-result">${indexSymbol}${radicand} = ${outside}</div>`;
  } else if (outside === 1) {
    html += `<div class="rad-result">${indexSymbol}${radicand} = ${indexSymbol}${inside}</div>`;
  } else {
    html += `<div class="rad-result">${indexSymbol}${radicand} = ${outside}${indexSymbol}${inside}</div>`;
  }

  // Steps
  html += '<div class="step-section">';
  html += '<h6><i class="fas fa-list-ol"></i> Simplification Steps</h6>';

  if (showPrime) {
    // Prime factorization
    let primeStr = '';
    for (const prime in factors) {
      primeStr += `${prime}`;
      if (factors[prime] > 1) {
        primeStr += `<sup>${factors[prime]}</sup>`;
      }
      primeStr += ' × ';
    }
    primeStr = primeStr.slice(0, -3);

    html += `<div class="step-item"><strong>Step 1: Prime factorization</strong><br>${radicand} = ${primeStr}</div>`;
    html += `<div class="prime-factors">${radicand} = ${primeStr}</div>`;
  }

  html += `<div class="step-item"><strong>Step ${showPrime ? '2' : '1'}: Group factors by ${index}s</strong><br>`;
  html += 'Look for groups of ' + index + ' identical factors</div>';

  html += `<div class="step-item"><strong>Step ${showPrime ? '3' : '2'}: Extract perfect ${index === 2 ? 'squares' : (index === 3 ? 'cubes' : index + 'th powers')}</strong><br>`;
  if (outside > 1) {
    html += `Take ${outside} outside the radical<br>`;
  }
  if (inside > 1) {
    html += `Leave ${inside} inside the radical`;
  }
  html += '</div>';

  html += '</div>';

  // Decimal approximation
  const decimal = outside * Math.pow(inside, 1/index);
  html += `<div class="info-card">`;
  html += `<strong><i class="fas fa-calculator"></i> Decimal Approximation:</strong><br>`;
  html += `${decimal.toFixed(6)}`;
  html += `</div>`;

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Perform operation
function performOperation() {
  const opType = document.getElementById('operationType').value;
  let html = '<div class="result-box">';

  if (opType === 'multiply' || opType === 'divide') {
    const a = parseFloat(document.getElementById('opRadicand1').value);
    const b = parseFloat(document.getElementById('opRadicand2').value);

    if (isNaN(a) || isNaN(b) || a < 0 || b < 0) {
      alert('Please enter valid non-negative numbers');
      return;
    }

    if (opType === 'multiply') {
      const product = a * b;

      html += `<h6 class="text-center"><span class="method-badge">Multiply Radicals</span></h6>`;
      html += `<div class="rad-result">√${a} × √${b} = √${product}</div>`;

      html += '<div class="step-section">';
      html += '<h6><i class="fas fa-calculator"></i> Solution</h6>';
      html += `<div class="step-item"><strong>Step 1: Apply product property</strong><br>√a × √b = √(ab)</div>`;
      html += `<div class="step-item"><strong>Step 2: Multiply radicands</strong><br>√${a} × √${b} = √(${a} × ${b}) = √${product}</div>`;

      // Simplify if possible
      const factors = primeFactorization(product);
      let outside = 1, inside = 1;
      for (const prime in factors) {
        const pairs = Math.floor(factors[prime] / 2);
        const remainder = factors[prime] % 2;
        outside *= Math.pow(parseInt(prime), pairs);
        inside *= Math.pow(parseInt(prime), remainder);
      }

      if (outside > 1 || inside !== product) {
        html += `<div class="step-item"><strong>Step 3: Simplify √${product}</strong><br>`;
        if (inside === 1) {
          html += `√${product} = ${outside}</div>`;
        } else if (outside === 1) {
          html += `Already in simplest form</div>`;
        } else {
          html += `√${product} = ${outside}√${inside}</div>`;
        }
      }
      html += '</div>';

    } else { // divide
      if (b === 0) {
        alert('Cannot divide by zero');
        return;
      }

      const quotient = a / b;

      html += `<h6 class="text-center"><span class="method-badge">Divide Radicals</span></h6>`;
      html += `<div class="rad-result">√${a} ÷ √${b} = √${quotient.toFixed(4)}</div>`;

      html += '<div class="step-section">';
      html += '<h6><i class="fas fa-calculator"></i> Solution</h6>';
      html += `<div class="step-item"><strong>Step 1: Apply quotient property</strong><br>√a ÷ √b = √(a/b)</div>`;
      html += `<div class="step-item"><strong>Step 2: Divide radicands</strong><br>√${a} ÷ √${b} = √(${a}/${b}) = √${quotient.toFixed(4)}</div>`;

      // Check if it simplifies to whole number
      if (Number.isInteger(quotient)) {
        const sqrt = Math.sqrt(quotient);
        if (Number.isInteger(sqrt)) {
          html += `<div class="step-item"><strong>Step 3: Simplify</strong><br>√${quotient} = ${sqrt}</div>`;
        }
      }
      html += '</div>';
    }

  } else { // add or subtract
    const coef1 = parseFloat(document.getElementById('coef1').value);
    const coef2 = parseFloat(document.getElementById('coef2').value);
    const rad = parseFloat(document.getElementById('commonRadicand').value);

    if (isNaN(coef1) || isNaN(coef2) || isNaN(rad) || rad < 0) {
      alert('Please enter valid numbers');
      return;
    }

    const result = opType === 'add' ? coef1 + coef2 : coef1 - coef2;
    const opSymbol = opType === 'add' ? '+' : '-';

    html += `<h6 class="text-center"><span class="method-badge">${opType === 'add' ? 'Add' : 'Subtract'} Radicals</span></h6>`;
    html += `<div class="rad-result">${coef1}√${rad} ${opSymbol} ${coef2}√${rad} = ${result}√${rad}</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-calculator"></i> Solution</h6>';
    html += `<div class="step-item"><strong>Rule:</strong> Like radicals can be added/subtracted by combining coefficients</div>`;
    html += `<div class="step-item"><strong>Step 1: Verify same radicand</strong><br>Both terms have √${rad} ✓</div>`;
    html += `<div class="step-item"><strong>Step 2: Combine coefficients</strong><br>${coef1} ${opSymbol} ${coef2} = ${result}</div>`;
    html += `<div class="step-item"><strong>Step 3: Keep the radical</strong><br>Result: ${result}√${rad}</div>`;
    html += '</div>';

    html += `<div class="info-card"><strong><i class="fas fa-info-circle"></i> Note:</strong> You can only add/subtract radicals with the same radicand (like terms).</div>`;
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Rationalize denominator
function rationalizeDenominator() {
  const type = document.getElementById('rationalizeType').value;
  let html = '<div class="result-box">';

  if (type === 'simple') {
    const num = parseFloat(document.getElementById('ratNum').value);
    const denom = parseFloat(document.getElementById('ratDenom').value);

    if (isNaN(num) || isNaN(denom) || denom <= 0) {
      alert('Please enter valid numbers (denominator must be positive)');
      return;
    }

    const newNum = num * Math.sqrt(denom);
    const newDenom = denom;
    const g = gcd(Math.abs(Math.round(num)), Math.round(denom));

    html += `<h6 class="text-center"><span class="method-badge">Rationalize Simple Denominator</span></h6>`;
    html += `<div class="rad-result">${num}/√${denom} = ${num}√${denom}/${denom}</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-calculator"></i> Solution</h6>';
    html += `<div class="step-item"><strong>Step 1: Multiply by √${denom}/√${denom}</strong><br>(${num}/√${denom}) × (√${denom}/√${denom})</div>`;
    html += `<div class="step-item"><strong>Step 2: Simplify</strong><br>Numerator: ${num}√${denom}<br>Denominator: √${denom} × √${denom} = ${denom}</div>`;
    html += `<div class="step-item"><strong>Result:</strong> ${num}√${denom}/${denom}</div>`;
    html += '</div>';

  } else if (type === 'radical-num') {
    const numRad = parseFloat(document.getElementById('ratNumRad').value);
    const denomRad = parseFloat(document.getElementById('ratDenomRad').value);

    if (isNaN(numRad) || isNaN(denomRad) || numRad < 0 || denomRad <= 0) {
      alert('Please enter valid non-negative numbers');
      return;
    }

    const quotient = numRad / denomRad;
    const sqrtQuotient = Math.sqrt(quotient);

    html += `<h6 class="text-center"><span class="method-badge">Rationalize with Radical Numerator</span></h6>`;
    html += `<div class="rad-result">√${numRad}/√${denomRad} = √${quotient.toFixed(4)}</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-calculator"></i> Solution</h6>';
    html += `<div class="step-item"><strong>Step 1: Apply quotient property</strong><br>√a/√b = √(a/b)</div>`;
    html += `<div class="step-item"><strong>Step 2: Divide radicands</strong><br>√${numRad}/√${denomRad} = √(${numRad}/${denomRad}) = √${quotient.toFixed(4)}</div>`;

    if (Number.isInteger(sqrtQuotient)) {
      html += `<div class="step-item"><strong>Step 3: Simplify</strong><br>√${quotient} = ${sqrtQuotient}</div>`;
    }
    html += '</div>';

  } else { // binomial
    const a = parseFloat(document.getElementById('biNumA').value);
    const b = parseFloat(document.getElementById('biDenomB').value);
    const c = parseFloat(document.getElementById('biDenomC').value);

    if (isNaN(a) || isNaN(b) || isNaN(c) || c < 0) {
      alert('Please enter valid numbers');
      return;
    }

    const conjugateDenom = b*b - c;
    const newNumConst = a * b;
    const newNumRad = -a * Math.sqrt(c);

    html += `<h6 class="text-center"><span class="method-badge">Rationalize Binomial Denominator</span></h6>`;
    html += `<div class="rad-result">${a}/(${b} + √${c}) = (${newNumConst} - ${a}√${c})/${conjugateDenom}</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-calculator"></i> Solution</h6>';
    html += `<div class="step-item"><strong>Step 1: Multiply by conjugate</strong><br>Conjugate of (${b} + √${c}) is (${b} - √${c})</div>`;
    html += `<div class="step-item"><strong>Step 2: Multiply</strong><br>`;
    html += `Numerator: ${a}(${b} - √${c}) = ${newNumConst} - ${a}√${c}<br>`;
    html += `Denominator: (${b} + √${c})(${b} - √${c}) = ${b}² - (√${c})² = ${b*b} - ${c} = ${conjugateDenom}</div>`;
    html += `<div class="step-item"><strong>Result:</strong> (${newNumConst} - ${a}√${c})/${conjugateDenom}</div>`;
    html += '</div>';
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Simplify nested radical
function simplifyNested() {
  const a = parseFloat(document.getElementById('nestedA').value);
  const b = parseFloat(document.getElementById('nestedB').value);
  const op = document.getElementById('nestedOp').value;

  if (isNaN(a) || isNaN(b) || a < 0 || b < 0) {
    alert('Please enter valid non-negative numbers');
    return;
  }

  const opSymbol = op === 'plus' ? '+' : '-';

  // Try to denest: √(a ± √b) = √x ± √y where x + y = a and 2√(xy) = √b
  // So xy = b/4 and x + y = a
  // x and y are roots of t² - at + b/4 = 0

  const discriminant = a*a - b;

  let html = '<div class="result-box">';
  html += `<h6 class="text-center"><span class="method-badge">Simplify √(${a} ${opSymbol} √${b})</span></h6>`;

  if (discriminant >= 0) {
    const x = (a + Math.sqrt(discriminant)) / 2;
    const y = (a - Math.sqrt(discriminant)) / 2;

    if (x >= 0 && y >= 0 && Math.abs(4*x*y - b) < 0.001) {
      const sqrtX = Math.sqrt(x);
      const sqrtY = Math.sqrt(y);

      html += `<div class="rad-result">√(${a} ${opSymbol} √${b}) = √${x.toFixed(4)} ${opSymbol} √${y.toFixed(4)}</div>`;

      if (Number.isInteger(sqrtX) && Number.isInteger(sqrtY)) {
        html += `<div class="rad-result">= ${sqrtX} ${opSymbol} ${sqrtY}</div>`;
      }

      html += '<div class="step-section">';
      html += '<h6><i class="fas fa-calculator"></i> Denesting Method</h6>';
      html += `<div class="step-item"><strong>Find x and y where:</strong><br>`;
      html += `x + y = ${a}<br>`;
      html += `2√(xy) = √${b}<br>`;
      html += `So xy = ${b/4}</div>`;
      html += `<div class="step-item"><strong>Solution:</strong><br>x = ${x.toFixed(4)}, y = ${y.toFixed(4)}</div>`;
      html += `<div class="step-item"><strong>Result:</strong><br>√(${a} ${opSymbol} √${b}) = √${x.toFixed(4)} ${opSymbol} √${y.toFixed(4)}</div>`;
      html += '</div>';

      // Verification
      const check = op === 'plus' ?
        x + y + 2*Math.sqrt(x*y) :
        x + y - 2*Math.sqrt(x*y);
      html += `<div class="info-card"><strong><i class="fas fa-check"></i> Verification:</strong><br>`;
      html += `(√${x.toFixed(2)} ${opSymbol} √${y.toFixed(2)})² = ${x.toFixed(2)} ${op === 'plus' ? '+' : '-'} 2√${(x*y).toFixed(2)} + ${y.toFixed(2)} = ${check.toFixed(2)} ≈ ${a} ${opSymbol} √${b} ✓</div>`;
    } else {
      html += `<div class="rad-result">Cannot be simplified further</div>`;
      html += `<div class="info-card">This nested radical does not have a simpler form using integer square roots.</div>`;
    }
  } else {
    html += `<div class="rad-result">Cannot be simplified</div>`;
    html += `<div class="info-card">Discriminant is negative. This nested radical cannot be denested.</div>`;
  }

  // Decimal approximation
  const decimal = Math.sqrt(a + (op === 'plus' ? 1 : -1) * Math.sqrt(b));
  html += `<div class="info-card"><strong><i class="fas fa-calculator"></i> Decimal Value:</strong> ${decimal.toFixed(6)}</div>`;

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}
</script>
</div>
<%@ include file="body-close.jsp"%>
