<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Exponent Calculator - Power Rules, Laws of Exponents | 8gwifi.org</title>
  <meta name="description" content="Advanced exponent calculator with all laws of exponents: product rule, quotient rule, power rule, negative exponents, zero exponents, fractional exponents. Step-by-step simplification with detailed explanations.">
  <meta name="keywords" content="exponent calculator, power calculator, laws of exponents, exponent rules, product rule, quotient rule, power rule, negative exponents, zero exponent, fractional exponents, simplify exponents, exponential expressions">
  <link rel="canonical" href="https://8gwifi.org/exponent-calculator.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/exponent-calculator.jsp">
  <meta property="og:title" content="Exponent Calculator - All Power Rules & Laws">
  <meta property="og:description" content="Calculate and simplify exponential expressions using all laws of exponents with step-by-step solutions.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/exponent-calculator.jsp">
  <meta property="twitter:title" content="Exponent Calculator - Power Rules">
  <meta property="twitter:description" content="Simplify exponential expressions with product, quotient, power rules and more. Step-by-step solutions.">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Exponent Calculator",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Advanced exponent calculator demonstrating all laws of exponents including product rule, quotient rule, power rule, negative exponents, zero exponents, and fractional exponents with step-by-step solutions.",
    "url": "https://8gwifi.org/exponent-calculator.jsp",
    "featureList": [
      "Product Rule: aᵐ × aⁿ = aᵐ⁺ⁿ",
      "Quotient Rule: aᵐ ÷ aⁿ = aᵐ⁻ⁿ",
      "Power Rule: (aᵐ)ⁿ = aᵐⁿ",
      "Power of Product: (ab)ⁿ = aⁿbⁿ",
      "Power of Quotient: (a/b)ⁿ = aⁿ/bⁿ",
      "Negative Exponents: a⁻ⁿ = 1/aⁿ",
      "Zero Exponent: a⁰ = 1",
      "Fractional Exponents: aᵐ/ⁿ = ⁿ√(aᵐ)",
      "Complex expression simplification",
      "Scientific notation",
      "Step-by-step solutions",
      "All laws comparison"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "ratingCount": "2043",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --exp-primary: #f59e0b;
    --exp-secondary: #d97706;
    --exp-light: #fef3c7;
    --exp-dark: #92400e;
  }

  .exp-card {
    border-left: 4px solid var(--exp-primary);
    transition: all 0.3s ease;
  }

  .exp-card:hover {
    box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);
    transform: translateY(-2px);
  }

  .result-box {
    background: linear-gradient(135deg, var(--exp-light), white);
    border: 2px solid var(--exp-primary);
    border-radius: 10px;
    padding: 1.5rem;
    margin-top: 1rem;
  }

  .exp-result {
    font-size: 1.8rem;
    font-weight: bold;
    color: var(--exp-dark);
    background-color: #fffbeb;
    padding: 1.5rem;
    border-radius: 8px;
    margin: 1rem 0;
    text-align: center;
    font-family: 'Times New Roman', serif;
  }

  .expression-display {
    font-size: 1.4rem;
    font-family: 'Times New Roman', serif;
    background: #f9fafb;
    padding: 1rem;
    border-left: 3px solid var(--exp-primary);
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
    border-left: 2px solid var(--exp-secondary);
    padding-left: 1rem;
  }

  .law-box {
    background: #dbeafe;
    border: 1px solid #3b82f6;
    padding: 0.75rem;
    border-radius: 6px;
    margin: 0.5rem 0;
    font-family: 'Times New Roman', serif;
  }

  .info-card {
    background: #eff6ff;
    border-left: 4px solid #3b82f6;
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 4px;
  }

  .method-badge {
    background: linear-gradient(135deg, var(--exp-primary), var(--exp-secondary));
    color: white;
    padding: 0.4rem 0.8rem;
    border-radius: 15px;
    font-size: 0.9rem;
    font-weight: 600;
    display: inline-block;
  }

  .example-box {
    background: #f3f4f6;
    border: 1px solid #d1d5db;
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 6px;
  }

  sup {
    font-size: 0.75em;
    vertical-align: super;
  }
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1 class="mb-2"><i class="fas fa-superscript" style="color: var(--exp-primary);"></i> Exponent Calculator</h1>
  <p class="text-muted mb-3">Master all laws of exponents: product, quotient, power, negative, zero, and fractional</p>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header"><i class="fas fa-superscript"></i> Exponent Tools</h5>
        <div class="card-body">

          <!-- Tab Navigation -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="basic-tab" data-toggle="tab" href="#basic-panel" role="tab">
                <i class="fas fa-calculator"></i> Basic Powers
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="rules-tab" data-toggle="tab" href="#rules-panel" role="tab">
                <i class="fas fa-book"></i> Apply Rules
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="simplify-tab" data-toggle="tab" href="#simplify-panel" role="tab">
                <i class="fas fa-compress"></i> Simplify
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="compare-tab" data-toggle="tab" href="#compare-panel" role="tab">
                <i class="fas fa-list"></i> All Laws
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- Basic Powers Panel -->
            <div class="tab-pane fade show active" id="basic-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Calculate basic powers:</strong><br>
                Compute a<sup>n</sup> where a is the base and n is the exponent
              </div>

              <div class="form-group">
                <label><strong>Base (a)</strong></label>
                <input type="number" class="form-control" id="basicBase" value="2" step="any">
              </div>

              <div class="form-group">
                <label><strong>Exponent (n)</strong></label>
                <input type="number" class="form-control" id="basicExponent" value="5" step="any">
                <small class="form-text text-muted">Can be negative, zero, or fractional</small>
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--exp-primary); color: white;" onclick="calculateBasicPower()">
                <i class="fas fa-calculator"></i> Calculate a<sup>n</sup>
              </button>

              <div class="example-box">
                <strong>Examples:</strong><br>
                2<sup>5</sup> = 32<br>
                3<sup>-2</sup> = 1/9 ≈ 0.111<br>
                16<sup>1/2</sup> = √16 = 4<br>
                5<sup>0</sup> = 1
              </div>
            </div>

            <!-- Apply Rules Panel -->
            <div class="tab-pane fade" id="rules-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Apply exponent laws:</strong><br>
                Choose a rule and see step-by-step application
              </div>

              <div class="form-group">
                <label><strong>Exponent Rule</strong></label>
                <select class="form-control" id="ruleType" onchange="updateRuleInputs()">
                  <option value="product">Product Rule: aᵐ × aⁿ = aᵐ⁺ⁿ</option>
                  <option value="quotient">Quotient Rule: aᵐ ÷ aⁿ = aᵐ⁻ⁿ</option>
                  <option value="power">Power Rule: (aᵐ)ⁿ = aᵐⁿ</option>
                  <option value="product-power">Power of Product: (ab)ⁿ = aⁿbⁿ</option>
                  <option value="quotient-power">Power of Quotient: (a/b)ⁿ = aⁿ/bⁿ</option>
                  <option value="negative">Negative Exponent: a⁻ⁿ = 1/aⁿ</option>
                  <option value="zero">Zero Exponent: a⁰ = 1</option>
                  <option value="fractional">Fractional Exponent: aᵐ/ⁿ = ⁿ√(aᵐ)</option>
                </select>
              </div>

              <div id="ruleInputs">
                <!-- Product/Quotient Rules -->
                <div id="productQuotientInputs">
                  <div class="form-group">
                    <label><strong>Base (a)</strong></label>
                    <input type="number" class="form-control" id="ruleBase" value="3" step="any">
                  </div>
                  <div class="form-group">
                    <label><strong>First Exponent (m)</strong></label>
                    <input type="number" class="form-control" id="ruleExp1" value="4" step="any">
                  </div>
                  <div class="form-group">
                    <label><strong>Second Exponent (n)</strong></label>
                    <input type="number" class="form-control" id="ruleExp2" value="3" step="any">
                  </div>
                </div>

                <!-- Power Rule -->
                <div id="powerRuleInputs" style="display: none;">
                  <div class="form-group">
                    <label><strong>Base (a)</strong></label>
                    <input type="number" class="form-control" id="powerBase" value="2" step="any">
                  </div>
                  <div class="form-group">
                    <label><strong>Inner Exponent (m)</strong></label>
                    <input type="number" class="form-control" id="powerExp1" value="3" step="any">
                  </div>
                  <div class="form-group">
                    <label><strong>Outer Exponent (n)</strong></label>
                    <input type="number" class="form-control" id="powerExp2" value="2" step="any">
                  </div>
                </div>

                <!-- Product/Quotient Power -->
                <div id="prodQuotPowerInputs" style="display: none;">
                  <div class="form-group">
                    <label><strong>First Base (a)</strong></label>
                    <input type="number" class="form-control" id="prodBase1" value="2" step="any">
                  </div>
                  <div class="form-group">
                    <label><strong>Second Base (b)</strong></label>
                    <input type="number" class="form-control" id="prodBase2" value="3" step="any">
                  </div>
                  <div class="form-group">
                    <label><strong>Exponent (n)</strong></label>
                    <input type="number" class="form-control" id="prodPowerExp" value="2" step="any">
                  </div>
                </div>

                <!-- Negative/Zero/Fractional -->
                <div id="specialInputs" style="display: none;">
                  <div class="form-group">
                    <label><strong>Base (a)</strong></label>
                    <input type="number" class="form-control" id="specialBase" value="5" step="any">
                  </div>
                  <div class="form-group" id="specialExpDiv">
                    <label><strong>Exponent</strong></label>
                    <input type="number" class="form-control" id="specialExp" value="-3" step="any">
                  </div>
                  <div id="fractionalExpDiv" style="display: none;">
                    <div class="form-group">
                      <label><strong>Numerator (m)</strong></label>
                      <input type="number" class="form-control" id="fracNum" value="3" step="1">
                    </div>
                    <div class="form-group">
                      <label><strong>Denominator (n)</strong></label>
                      <input type="number" class="form-control" id="fracDenom" value="2" step="1" min="1">
                    </div>
                  </div>
                </div>
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--exp-primary); color: white;" onclick="applyRule()">
                <i class="fas fa-magic"></i> Apply Rule
              </button>
            </div>

            <!-- Simplify Panel -->
            <div class="tab-pane fade" id="simplify-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Simplify complex expressions:</strong><br>
                Enter an expression with multiple exponent operations
              </div>

              <div class="form-group">
                <label><strong>Expression Type</strong></label>
                <select class="form-control" id="simplifyType">
                  <option value="combo1">(a²)³ × a⁴</option>
                  <option value="combo2">a⁸ ÷ (a²)³</option>
                  <option value="combo3">(a³b²)⁴</option>
                  <option value="combo4">a⁻² × a⁵</option>
                </select>
              </div>

              <div class="form-group">
                <label><strong>Value of a</strong></label>
                <input type="number" class="form-control" id="simplifyA" value="2" step="any">
              </div>

              <div class="form-group" id="simplifyBDiv">
                <label><strong>Value of b (if applicable)</strong></label>
                <input type="number" class="form-control" id="simplifyB" value="3" step="any">
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--exp-primary); color: white;" onclick="simplifyExpression()">
                <i class="fas fa-compress"></i> Simplify Expression
              </button>

              <div class="example-box">
                <strong>Simplification Examples:</strong><br>
                (a²)³ × a⁴ = a⁶ × a⁴ = a¹⁰<br>
                a⁸ ÷ (a²)³ = a⁸ ÷ a⁶ = a²<br>
                (a³b²)⁴ = a¹²b⁸
              </div>
            </div>

            <!-- All Laws Panel -->
            <div class="tab-pane fade" id="compare-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> See all exponent laws with examples</strong>
              </div>

              <div class="form-group">
                <label><strong>Example Base</strong></label>
                <input type="number" class="form-control" id="compareBase" value="2" step="any">
              </div>

              <button class="btn btn-lg btn-block" style="background: var(--exp-primary); color: white;" onclick="showAllLaws()">
                <i class="fas fa-list"></i> Show All Laws
              </button>
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
                <p style="font-size: 0.85rem; margin-bottom: 0.5rem;"><strong>The 8 Laws:</strong></p>
                <p style="font-size: 0.8rem; line-height: 1.4;">
                    <strong>1. Product:</strong> aᵐ × aⁿ = aᵐ⁺ⁿ<br>
                    <strong>2. Quotient:</strong> aᵐ ÷ aⁿ = aᵐ⁻ⁿ<br>
                    <strong>3. Power:</strong> (aᵐ)ⁿ = aᵐⁿ<br>
                    <strong>4. Product Power:</strong> (ab)ⁿ = aⁿbⁿ<br>
                    <strong>5. Quotient Power:</strong> (a/b)ⁿ = aⁿ/bⁿ<br>
                    <strong>6. Negative:</strong> a⁻ⁿ = 1/aⁿ<br>
                    <strong>7. Zero:</strong> a⁰ = 1<br>
                    <strong>8. Fractional:</strong> aᵐ/ⁿ = ⁿ√(aᵐ)
                </p>
            </div>
        </div>
    </div>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
// Update rule inputs based on selected rule
function updateRuleInputs() {
  const ruleType = document.getElementById('ruleType').value;

  // Hide all input groups
  document.getElementById('productQuotientInputs').style.display = 'none';
  document.getElementById('powerRuleInputs').style.display = 'none';
  document.getElementById('prodQuotPowerInputs').style.display = 'none';
  document.getElementById('specialInputs').style.display = 'none';
  document.getElementById('fractionalExpDiv').style.display = 'none';

  // Show relevant inputs
  if (ruleType === 'product' || ruleType === 'quotient') {
    document.getElementById('productQuotientInputs').style.display = 'block';
  } else if (ruleType === 'power') {
    document.getElementById('powerRuleInputs').style.display = 'block';
  } else if (ruleType === 'product-power' || ruleType === 'quotient-power') {
    document.getElementById('prodQuotPowerInputs').style.display = 'block';
  } else {
    document.getElementById('specialInputs').style.display = 'block';
    if (ruleType === 'zero') {
      document.getElementById('specialExpDiv').style.display = 'none';
    } else if (ruleType === 'fractional') {
      document.getElementById('specialExpDiv').style.display = 'none';
      document.getElementById('fractionalExpDiv').style.display = 'block';
    } else {
      document.getElementById('specialExpDiv').style.display = 'block';
    }
  }
}

// Calculate basic power
function calculateBasicPower() {
  const base = parseFloat(document.getElementById('basicBase').value);
  const exp = parseFloat(document.getElementById('basicExponent').value);

  if (isNaN(base) || isNaN(exp)) {
    alert('Please enter valid numbers');
    return;
  }

  if (base === 0 && exp <= 0) {
    alert('0^0 and 0 to negative powers are undefined');
    return;
  }

  const result = Math.pow(base, exp);

  let html = '<div class="result-box">';
  html += `<h6 class="text-center"><span class="method-badge">Calculate ${base}<sup>${exp}</sup></span></h6>`;
  html += `<div class="exp-result">${base}<sup>${exp}</sup> = ${result.toFixed(6)}</div>`;

  html += '<div class="step-section">';
  html += '<h6><i class="fas fa-calculator"></i> Explanation</h6>';

  if (exp === 0) {
    html += `<div class="step-item"><strong>Zero Exponent Rule:</strong> Any non-zero number to the power of 0 equals 1<br>${base}<sup>0</sup> = 1</div>`;
  } else if (exp < 0) {
    html += `<div class="step-item"><strong>Negative Exponent Rule:</strong> a<sup>-n</sup> = 1/a<sup>n</sup><br>${base}<sup>${exp}</sup> = 1/${base}<sup>${-exp}</sup> = 1/${Math.pow(base, -exp).toFixed(6)} = ${result.toFixed(6)}</div>`;
  } else if (exp % 1 !== 0) {
    html += `<div class="step-item"><strong>Fractional Exponent:</strong> ${base}<sup>${exp}</sup> represents the ${exp}th power<br>Result: ${result.toFixed(6)}</div>`;
  } else if (Number.isInteger(exp) && exp > 0 && exp <= 10) {
    html += `<div class="step-item"><strong>Repeated Multiplication:</strong><br>${base}<sup>${exp}</sup> = `;
    const parts = [];
    for (let i = 0; i < exp; i++) {
      parts.push(base.toString());
    }
    html += parts.join(' × ') + ' = ' + result.toFixed(6) + '</div>';
  } else {
    html += `<div class="step-item"><strong>Calculation:</strong> ${base}<sup>${exp}</sup> = ${result.toFixed(6)}</div>`;
  }

  html += '</div>';

  // Scientific notation for very large/small numbers
  if (Math.abs(result) >= 1000 || (Math.abs(result) < 0.001 && result !== 0)) {
    html += `<div class="info-card"><strong><i class="fas fa-flask"></i> Scientific Notation:</strong> ${result.toExponential(4)}</div>`;
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Apply exponent rule
function applyRule() {
  const ruleType = document.getElementById('ruleType').value;
  let html = '<div class="result-box">';

  if (ruleType === 'product') {
    const base = parseFloat(document.getElementById('ruleBase').value);
    const m = parseFloat(document.getElementById('ruleExp1').value);
    const n = parseFloat(document.getElementById('ruleExp2').value);

    const result = Math.pow(base, m + n);

    html += `<h6 class="text-center"><span class="method-badge">Product Rule</span></h6>`;
    html += `<div class="exp-result">${base}<sup>${m}</sup> × ${base}<sup>${n}</sup> = ${base}<sup>${m+n}</sup></div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-book"></i> Product Rule: a<sup>m</sup> × a<sup>n</sup> = a<sup>m+n</sup></h6>';
    html += `<div class="step-item"><strong>Step 1: Identify same base</strong><br>Base = ${base}</div>`;
    html += `<div class="step-item"><strong>Step 2: Add exponents</strong><br>${m} + ${n} = ${m+n}</div>`;
    html += `<div class="step-item"><strong>Step 3: Write result</strong><br>${base}<sup>${m}</sup> × ${base}<sup>${n}</sup> = ${base}<sup>${m+n}</sup></div>`;
    html += `<div class="step-item"><strong>Numerical value:</strong> ${result.toFixed(6)}</div>`;
    html += '</div>';

  } else if (ruleType === 'quotient') {
    const base = parseFloat(document.getElementById('ruleBase').value);
    const m = parseFloat(document.getElementById('ruleExp1').value);
    const n = parseFloat(document.getElementById('ruleExp2').value);

    const result = Math.pow(base, m - n);

    html += `<h6 class="text-center"><span class="method-badge">Quotient Rule</span></h6>`;
    html += `<div class="exp-result">${base}<sup>${m}</sup> ÷ ${base}<sup>${n}</sup> = ${base}<sup>${m-n}</sup></div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-book"></i> Quotient Rule: a<sup>m</sup> ÷ a<sup>n</sup> = a<sup>m-n</sup></h6>';
    html += `<div class="step-item"><strong>Step 1: Identify same base</strong><br>Base = ${base}</div>`;
    html += `<div class="step-item"><strong>Step 2: Subtract exponents</strong><br>${m} - ${n} = ${m-n}</div>`;
    html += `<div class="step-item"><strong>Step 3: Write result</strong><br>${base}<sup>${m}</sup> ÷ ${base}<sup>${n}</sup> = ${base}<sup>${m-n}</sup></div>`;
    html += `<div class="step-item"><strong>Numerical value:</strong> ${result.toFixed(6)}</div>`;
    html += '</div>';

  } else if (ruleType === 'power') {
    const base = parseFloat(document.getElementById('powerBase').value);
    const m = parseFloat(document.getElementById('powerExp1').value);
    const n = parseFloat(document.getElementById('powerExp2').value);

    const result = Math.pow(base, m * n);

    html += `<h6 class="text-center"><span class="method-badge">Power Rule</span></h6>`;
    html += `<div class="exp-result">(${base}<sup>${m}</sup>)<sup>${n}</sup> = ${base}<sup>${m*n}</sup></div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-book"></i> Power Rule: (a<sup>m</sup>)<sup>n</sup> = a<sup>mn</sup></h6>';
    html += `<div class="step-item"><strong>Step 1: Identify base and exponents</strong><br>Base = ${base}, m = ${m}, n = ${n}</div>`;
    html += `<div class="step-item"><strong>Step 2: Multiply exponents</strong><br>${m} × ${n} = ${m*n}</div>`;
    html += `<div class="step-item"><strong>Step 3: Write result</strong><br>(${base}<sup>${m}</sup>)<sup>${n}</sup> = ${base}<sup>${m*n}</sup></div>`;
    html += `<div class="step-item"><strong>Numerical value:</strong> ${result.toFixed(6)}</div>`;
    html += '</div>';

  } else if (ruleType === 'product-power') {
    const a = parseFloat(document.getElementById('prodBase1').value);
    const b = parseFloat(document.getElementById('prodBase2').value);
    const n = parseFloat(document.getElementById('prodPowerExp').value);

    const result = Math.pow(a, n) * Math.pow(b, n);

    html += `<h6 class="text-center"><span class="method-badge">Power of a Product</span></h6>`;
    html += `<div class="exp-result">(${a} × ${b})<sup>${n}</sup> = ${a}<sup>${n}</sup> × ${b}<sup>${n}</sup></div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-book"></i> Power of Product: (ab)<sup>n</sup> = a<sup>n</sup>b<sup>n</sup></h6>';
    html += `<div class="step-item"><strong>Step 1: Distribute exponent to each base</strong><br>(${a} × ${b})<sup>${n}</sup> = ${a}<sup>${n}</sup> × ${b}<sup>${n}</sup></div>`;
    html += `<div class="step-item"><strong>Step 2: Calculate each power</strong><br>${a}<sup>${n}</sup> = ${Math.pow(a,n).toFixed(4)}<br>${b}<sup>${n}</sup> = ${Math.pow(b,n).toFixed(4)}</div>`;
    html += `<div class="step-item"><strong>Step 3: Multiply results</strong><br>${Math.pow(a,n).toFixed(4)} × ${Math.pow(b,n).toFixed(4)} = ${result.toFixed(6)}</div>`;
    html += '</div>';

  } else if (ruleType === 'quotient-power') {
    const a = parseFloat(document.getElementById('prodBase1').value);
    const b = parseFloat(document.getElementById('prodBase2').value);
    const n = parseFloat(document.getElementById('prodPowerExp').value);

    if (b === 0) {
      alert('Denominator cannot be zero');
      return;
    }

    const result = Math.pow(a, n) / Math.pow(b, n);

    html += `<h6 class="text-center"><span class="method-badge">Power of a Quotient</span></h6>`;
    html += `<div class="exp-result">(${a}/${b})<sup>${n}</sup> = ${a}<sup>${n}</sup>/${b}<sup>${n}</sup></div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-book"></i> Power of Quotient: (a/b)<sup>n</sup> = a<sup>n</sup>/b<sup>n</sup></h6>';
    html += `<div class="step-item"><strong>Step 1: Distribute exponent</strong><br>(${a}/${b})<sup>${n}</sup> = ${a}<sup>${n}</sup>/${b}<sup>${n}</sup></div>`;
    html += `<div class="step-item"><strong>Step 2: Calculate each power</strong><br>${a}<sup>${n}</sup> = ${Math.pow(a,n).toFixed(4)}<br>${b}<sup>${n}</sup> = ${Math.pow(b,n).toFixed(4)}</div>`;
    html += `<div class="step-item"><strong>Step 3: Divide</strong><br>${Math.pow(a,n).toFixed(4)} ÷ ${Math.pow(b,n).toFixed(4)} = ${result.toFixed(6)}</div>`;
    html += '</div>';

  } else if (ruleType === 'negative') {
    const base = parseFloat(document.getElementById('specialBase').value);
    const exp = parseFloat(document.getElementById('specialExp').value);

    if (base === 0) {
      alert('Base cannot be zero for negative exponents');
      return;
    }

    const result = Math.pow(base, exp);
    const positive = Math.pow(base, Math.abs(exp));

    html += `<h6 class="text-center"><span class="method-badge">Negative Exponent</span></h6>`;
    html += `<div class="exp-result">${base}<sup>${exp}</sup> = 1/${base}<sup>${Math.abs(exp)}</sup> = ${result.toFixed(6)}</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-book"></i> Negative Exponent: a<sup>-n</sup> = 1/a<sup>n</sup></h6>';
    html += `<div class="step-item"><strong>Step 1: Convert to reciprocal</strong><br>${base}<sup>${exp}</sup> = 1/${base}<sup>${Math.abs(exp)}</sup></div>`;
    html += `<div class="step-item"><strong>Step 2: Calculate positive power</strong><br>${base}<sup>${Math.abs(exp)}</sup> = ${positive.toFixed(6)}</div>`;
    html += `<div class="step-item"><strong>Step 3: Take reciprocal</strong><br>1/${positive.toFixed(6)} = ${result.toFixed(6)}</div>`;
    html += '</div>';

  } else if (ruleType === 'zero') {
    const base = parseFloat(document.getElementById('specialBase').value);

    if (base === 0) {
      alert('0⁰ is undefined');
      return;
    }

    html += `<h6 class="text-center"><span class="method-badge">Zero Exponent</span></h6>`;
    html += `<div class="exp-result">${base}<sup>0</sup> = 1</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-book"></i> Zero Exponent: a<sup>0</sup> = 1 (where a ≠ 0)</h6>';
    html += `<div class="step-item"><strong>Rule:</strong> Any non-zero number raised to the power of 0 equals 1</div>`;
    html += `<div class="step-item"><strong>Why?</strong> Using quotient rule: a<sup>n</sup> ÷ a<sup>n</sup> = a<sup>n-n</sup> = a<sup>0</sup><br>But a<sup>n</sup> ÷ a<sup>n</sup> = 1, therefore a<sup>0</sup> = 1</div>`;
    html += '</div>';

  } else if (ruleType === 'fractional') {
    const base = parseFloat(document.getElementById('specialBase').value);
    const m = parseInt(document.getElementById('fracNum').value);
    const n = parseInt(document.getElementById('fracDenom').value);

    if (isNaN(m) || isNaN(n) || n === 0) {
      alert('Please enter valid integers for numerator and denominator');
      return;
    }

    const result = Math.pow(base, m/n);
    const root = Math.pow(base, 1/n);
    const rootPower = Math.pow(base, m/n);

    html += `<h6 class="text-center"><span class="method-badge">Fractional Exponent</span></h6>`;
    html += `<div class="exp-result">${base}<sup>${m}/${n}</sup> = <sup>${n}</sup>√(${base}<sup>${m}</sup>) = ${result.toFixed(6)}</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-book"></i> Fractional Exponent: a<sup>m/n</sup> = <sup>n</sup>√(a<sup>m</sup>)</h6>';
    html += `<div class="step-item"><strong>Step 1: Understand the fraction</strong><br>Numerator (${m}) = power<br>Denominator (${n}) = root</div>`;
    html += `<div class="step-item"><strong>Step 2: Method 1 - Power first</strong><br>${base}<sup>${m}</sup> = ${Math.pow(base,m).toFixed(4)}<br><sup>${n}</sup>√${Math.pow(base,m).toFixed(4)} = ${result.toFixed(6)}</div>`;
    html += `<div class="step-item"><strong>Alternative: Root first</strong><br><sup>${n}</sup>√${base} = ${Math.pow(base, 1/n).toFixed(4)}<br>(${Math.pow(base, 1/n).toFixed(4)})<sup>${m}</sup> = ${result.toFixed(6)}</div>`;
    html += '</div>';
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Simplify complex expression
function simplifyExpression() {
  const type = document.getElementById('simplifyType').value;
  const a = parseFloat(document.getElementById('simplifyA').value);
  const b = parseFloat(document.getElementById('simplifyB').value);

  let html = '<div class="result-box">';

  if (type === 'combo1') {
    // (a²)³ × a⁴
    html += `<h6 class="text-center"><span class="method-badge">Simplify (a²)³ × a⁴</span></h6>`;
    html += `<div class="exp-result">(${a}²)³ × ${a}⁴ = ${a}¹⁰</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-list-ol"></i> Step-by-Step Solution</h6>';
    html += `<div class="step-item"><strong>Step 1: Apply power rule to (a²)³</strong><br>(${a}²)³ = ${a}²ˣ³ = ${a}⁶</div>`;
    html += `<div class="step-item"><strong>Step 2: Apply product rule</strong><br>${a}⁶ × ${a}⁴ = ${a}⁶⁺⁴ = ${a}¹⁰</div>`;
    html += `<div class="step-item"><strong>Numerical result:</strong> ${Math.pow(a, 10).toExponential(4)}</div>`;
    html += '</div>';

  } else if (type === 'combo2') {
    // a⁸ ÷ (a²)³
    html += `<h6 class="text-center"><span class="method-badge">Simplify a⁸ ÷ (a²)³</span></h6>`;
    html += `<div class="exp-result">${a}⁸ ÷ (${a}²)³ = ${a}²</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-list-ol"></i> Step-by-Step Solution</h6>';
    html += `<div class="step-item"><strong>Step 1: Apply power rule to (a²)³</strong><br>(${a}²)³ = ${a}²ˣ³ = ${a}⁶</div>`;
    html += `<div class="step-item"><strong>Step 2: Apply quotient rule</strong><br>${a}⁸ ÷ ${a}⁶ = ${a}⁸⁻⁶ = ${a}²</div>`;
    html += `<div class="step-item"><strong>Numerical result:</strong> ${Math.pow(a, 2).toFixed(4)}</div>`;
    html += '</div>';

  } else if (type === 'combo3') {
    // (a³b²)⁴
    html += `<h6 class="text-center"><span class="method-badge">Simplify (a³b²)⁴</span></h6>`;
    html += `<div class="exp-result">(${a}³ × ${b}²)⁴ = ${a}¹² × ${b}⁸</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-list-ol"></i> Step-by-Step Solution</h6>';
    html += `<div class="step-item"><strong>Step 1: Apply power of product</strong><br>(a³b²)⁴ = (a³)⁴ × (b²)⁴</div>`;
    html += `<div class="step-item"><strong>Step 2: Apply power rule to each</strong><br>(a³)⁴ = a³ˣ⁴ = a¹²<br>(b²)⁴ = b²ˣ⁴ = b⁸</div>`;
    html += `<div class="step-item"><strong>Step 3: Write result</strong><br>a¹²b⁸</div>`;
    html += `<div class="step-item"><strong>Numerical result:</strong> ${(Math.pow(a, 12) * Math.pow(b, 8)).toExponential(4)}</div>`;
    html += '</div>';

  } else if (type === 'combo4') {
    // a⁻² × a⁵
    html += `<h6 class="text-center"><span class="method-badge">Simplify a⁻² × a⁵</span></h6>`;
    html += `<div class="exp-result">${a}⁻² × ${a}⁵ = ${a}³</div>`;

    html += '<div class="step-section">';
    html += '<h6><i class="fas fa-list-ol"></i> Step-by-Step Solution</h6>';
    html += `<div class="step-item"><strong>Step 1: Apply product rule</strong><br>a⁻² × a⁵ = a⁻²⁺⁵ = a³</div>`;
    html += `<div class="step-item"><strong>Alternative view:</strong><br>a⁻² = 1/a²<br>1/a² × a⁵ = a⁵/a² = a³</div>`;
    html += `<div class="step-item"><strong>Numerical result:</strong> ${Math.pow(a, 3).toFixed(4)}</div>`;
    html += '</div>';
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Show all laws
function showAllLaws() {
  const a = parseFloat(document.getElementById('compareBase').value);

  let html = '<div class="result-box">';
  html += `<h6 class="text-center"><span class="method-badge">All 8 Laws of Exponents (with a = ${a})</span></h6>`;

  const laws = [
    {
      title: '1. Product Rule',
      formula: 'aᵐ × aⁿ = aᵐ⁺ⁿ',
      example: `${a}³ × ${a}² = ${a}⁵`,
      value: Math.pow(a, 5)
    },
    {
      title: '2. Quotient Rule',
      formula: 'aᵐ ÷ aⁿ = aᵐ⁻ⁿ',
      example: `${a}⁷ ÷ ${a}⁴ = ${a}³`,
      value: Math.pow(a, 3)
    },
    {
      title: '3. Power Rule',
      formula: '(aᵐ)ⁿ = aᵐⁿ',
      example: `(${a}²)³ = ${a}⁶`,
      value: Math.pow(a, 6)
    },
    {
      title: '4. Power of Product',
      formula: '(ab)ⁿ = aⁿbⁿ',
      example: `(${a} × 3)² = ${a}² × 9`,
      value: Math.pow(a, 2) * 9
    },
    {
      title: '5. Power of Quotient',
      formula: '(a/b)ⁿ = aⁿ/bⁿ',
      example: `(${a}/2)² = ${a}²/4`,
      value: Math.pow(a, 2) / 4
    },
    {
      title: '6. Negative Exponent',
      formula: 'a⁻ⁿ = 1/aⁿ',
      example: `${a}⁻² = 1/${a}²`,
      value: Math.pow(a, -2)
    },
    {
      title: '7. Zero Exponent',
      formula: 'a⁰ = 1',
      example: `${a}⁰ = 1`,
      value: 1
    },
    {
      title: '8. Fractional Exponent',
      formula: 'aᵐ/ⁿ = ⁿ√(aᵐ)',
      example: `${a}³/² = √(${a}³)`,
      value: Math.pow(a, 1.5)
    }
  ];

  for (const law of laws) {
    html += '<div class="step-section">';
    html += `<h6><span class="method-badge">${law.title}</span></h6>`;
    html += `<div class="law-box">${law.formula}</div>`;
    html += `<div class="step-item"><strong>Example:</strong> ${law.example} = ${law.value.toFixed(4)}</div>`;
    html += '</div>';
  }

  html += '<div class="info-card">';
  html += '<strong><i class="fas fa-lightbulb"></i> Mastery Tips:</strong><br>';
  html += '• Product/Quotient: Add/subtract exponents when bases are the same<br>';
  html += '• Powers: Multiply exponents when raising to a power<br>';
  html += '• Negative: Move to reciprocal and make positive<br>';
  html += '• Fractional: Numerator = power, Denominator = root';
  html += '</div>';

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Initialize
document.addEventListener('DOMContentLoaded', function() {
  // Update simplify b visibility
  document.getElementById('simplifyType').addEventListener('change', function() {
    const needsB = this.value === 'combo3';
    document.getElementById('simplifyBDiv').style.display = needsB ? 'block' : 'none';
  });
});
</script>
</div>
<%@ include file="body-close.jsp"%>
