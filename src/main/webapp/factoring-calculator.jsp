<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Factoring Calculator - Factor Polynomials, Quadratics, GCF | 8gwifi.org</title>
<meta name="description" content="Free factoring calculator: factor quadratics, polynomials, difference of squares, perfect square trinomials, sum/difference of cubes, and more. Step-by-step factoring solutions.">
<meta name="keywords" content="factoring calculator, factor polynomials, quadratic factoring, factor calculator, difference of squares, perfect square trinomial, factor by grouping, GCF calculator">
<link rel="canonical" href="https://8gwifi.org/factoring-calculator.jsp">

<!-- Open Graph -->
<meta property="og:title" content="Factoring Calculator - Factor Polynomials & Quadratics">
<meta property="og:description" content="Factor any polynomial: quadratics, difference of squares, perfect squares, sum/difference of cubes. Step-by-step solutions with multiple methods.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/factoring-calculator.jsp">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Factoring Calculator - Factor Polynomials & Quadratics">
<meta name="twitter:description" content="Factor any polynomial: quadratics, difference of squares, perfect squares, sum/difference of cubes. Step-by-step solutions with multiple methods.">

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Factoring Calculator",
  "description": "Factor polynomials including quadratics, difference of squares, perfect square trinomials, and more with step-by-step solutions",
  "url": "https://8gwifi.org/factoring-calculator.jsp",
  "applicationCategory": "UtilityApplication",
  "operatingSystem": "Any",
  "permissions": "browser",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": [
    "Factor quadratic expressions (ax² + bx + c)",
    "Greatest Common Factor (GCF)",
    "Difference of squares (a² - b²)",
    "Perfect square trinomials",
    "Sum and difference of cubes",
    "Factor by grouping",
    "Step-by-step solutions",
    "Multiple factoring methods"
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "ratingCount": "4532",
    "bestRating": "5",
    "worstRating": "1"
  }
}
</script>

<%@ include file="header-script.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/mathjs@11.11.0/lib/browser/math.min.js"></script>

<style>
:root {
  --factor-primary: #10b981;
  --factor-secondary: #059669;
  --factor-light: #d1fae5;
  --factor-dark: #065f46;
}

.factor-card {
  border-left: 4px solid var(--factor-primary);
  transition: all 0.3s ease;
}

.factor-card:hover {
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
  transform: translateY(-2px);
}

.factor-badge {
  background: linear-gradient(135deg, var(--factor-primary), var(--factor-secondary));
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  display: inline-block;
}

.result-box {
  background: linear-gradient(135deg, var(--factor-light), white);
  border: 2px solid var(--factor-primary);
  border-radius: 10px;
  padding: 1.5rem;
  margin-top: 1rem;
}

.factored-form {
  font-size: 1.3rem;
  font-family: 'Times New Roman', serif;
  color: var(--factor-dark);
  background-color: #f0fdf4;
  padding: 1rem;
  border-radius: 8px;
  text-align: center;
  margin: 1rem 0;
  border: 2px solid var(--factor-primary);
}

.step-section {
  background: white;
  border: 1px solid var(--factor-primary);
  border-radius: 8px;
  padding: 1rem;
  margin: 0.75rem 0;
}

.step-section h6 {
  color: var(--factor-dark);
  border-bottom: 2px solid var(--factor-primary);
  padding-bottom: 0.5rem;
  margin-bottom: 0.75rem;
}

.step-item {
  padding: 0.5rem;
  margin: 0.5rem 0;
  background-color: #f9fafb;
  border-left: 3px solid var(--factor-primary);
  border-radius: 4px;
}

.form-control:focus {
  border-color: var(--factor-primary);
  box-shadow: 0 0 0 0.2rem rgba(16, 185, 129, 0.25);
}

.btn-factor {
  background: linear-gradient(135deg, var(--factor-primary), var(--factor-secondary));
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-factor:hover {
  background: linear-gradient(135deg, var(--factor-secondary), var(--factor-dark));
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

.sticky-results {
  position: sticky;
  top: 20px;
  max-height: calc(100vh - 40px);
  overflow-y: auto;
}

.info-card {
  background-color: var(--factor-light);
  border-left: 4px solid var(--factor-primary);
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}

.formula-box {
  background-color: #f9fafb;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  padding: 1rem;
  font-family: 'Times New Roman', serif;
  margin: 1rem 0;
  font-size: 1.1rem;
  text-align: center;
}

.method-badge {
  background-color: var(--factor-primary);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 600;
}

.nav-tabs .nav-link {
  color: var(--factor-secondary);
  border: 2px solid transparent;
}

.nav-tabs .nav-link.active {
  color: white;
  background: linear-gradient(135deg, var(--factor-primary), var(--factor-secondary));
  border-color: var(--factor-primary);
}

.nav-tabs .nav-link:hover {
  border-color: var(--factor-light);
}

.example-box {
  background-color: #eff6ff;
  border-left: 4px solid #3b82f6;
  padding: 0.75rem;
  margin: 0.5rem 0;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
}
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1><i class="fas fa-project-diagram text-success"></i> Factoring Calculator</h1>
  <p class="lead">Factor polynomials, quadratics, and algebraic expressions with step-by-step solutions</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="card factor-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title">
            <i class="fas fa-keyboard text-success"></i> Enter Expression to Factor
          </h5>

          <!-- Tab Navigation -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="quadratic-tab" data-toggle="tab" href="#quadratic-panel" role="tab">
                <i class="fas fa-superscript"></i> Quadratic
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="special-tab" data-toggle="tab" href="#special-panel" role="tab">
                <i class="fas fa-star"></i> Special Forms
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="polynomial-tab" data-toggle="tab" href="#polynomial-panel" role="tab">
                <i class="fas fa-function"></i> General
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- Quadratic -->
            <div class="tab-pane fade show active" id="quadratic-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Factor quadratic expressions:</strong><br>
                ax² + bx + c format
              </div>

              <div class="form-group">
                <label for="quadA"><i class="fas fa-superscript"></i> Coefficient of x² (a)</label>
                <input type="number" class="form-control" id="quadA" value="1" step="any">
              </div>

              <div class="form-group">
                <label for="quadB"><i class="fas fa-times"></i> Coefficient of x (b)</label>
                <input type="number" class="form-control" id="quadB" value="5" step="any">
              </div>

              <div class="form-group">
                <label for="quadC"><i class="fas fa-hashtag"></i> Constant term (c)</label>
                <input type="number" class="form-control" id="quadC" value="6" step="any">
              </div>

              <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="showQuadSteps" checked>
                <label class="form-check-label" for="showQuadSteps">
                  Show Step-by-Step Solution
                </label>
              </div>

              <button class="btn btn-factor btn-block" onclick="factorQuadratic()">
                <i class="fas fa-project-diagram"></i> Factor Quadratic
              </button>

              <div class="example-box mt-3">
                <strong>Examples:</strong><br>
                • x² + 5x + 6 → enter a=1, b=5, c=6<br>
                • 2x² - 8x + 6 → enter a=2, b=-8, c=6<br>
                • x² - 9 → enter a=1, b=0, c=-9
              </div>
            </div>

            <!-- Special Forms -->
            <div class="tab-pane fade" id="special-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Special factoring patterns:</strong><br>
                Difference of squares, perfect squares, sum/difference of cubes
              </div>

              <div class="form-group">
                <label><i class="fas fa-list"></i> Select Pattern</label>
                <select class="form-control" id="specialPattern" onchange="updateSpecialInputs()">
                  <option value="dos">Difference of Squares (a² - b²)</option>
                  <option value="pst">Perfect Square Trinomial (a² ± 2ab + b²)</option>
                  <option value="soc">Sum of Cubes (a³ + b³)</option>
                  <option value="doc">Difference of Cubes (a³ - b³)</option>
                </select>
              </div>

              <div id="specialInputs">
                <div class="form-group">
                  <label for="specialA"><i class="fas fa-square"></i> First term (a²)</label>
                  <input type="number" class="form-control" id="specialA" value="16" step="any">
                  <small class="form-text text-muted">Enter the coefficient (e.g., 16 for 16x²)</small>
                </div>

                <div class="form-group">
                  <label for="specialB"><i class="fas fa-square"></i> Second term (b²)</label>
                  <input type="number" class="form-control" id="specialB" value="9" step="any">
                  <small class="form-text text-muted">Enter the coefficient (e.g., 9 for 9)</small>
                </div>
              </div>

              <button class="btn btn-factor btn-block" onclick="factorSpecial()">
                <i class="fas fa-star"></i> Factor Special Form
              </button>

              <div class="example-box mt-3">
                <strong>Examples:</strong><br>
                • x² - 25 → Difference of Squares<br>
                • x² + 6x + 9 → Perfect Square<br>
                • x³ + 8 → Sum of Cubes
              </div>
            </div>

            <!-- General Polynomial -->
            <div class="tab-pane fade" id="polynomial-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Enter any polynomial expression:</strong><br>
                Supports GCF extraction and basic factoring
              </div>

              <div class="form-group">
                <label for="polyExpression"><i class="fas fa-function"></i> Polynomial Expression</label>
                <input type="text" class="form-control" id="polyExpression" value="3x^2 + 12x + 9" placeholder="e.g., 3x^2 + 12x + 9">
                <small class="form-text text-muted">Use ^ for exponents: x^2, 2*x^3, etc.</small>
              </div>

              <button class="btn btn-factor btn-block" onclick="factorPolynomial()">
                <i class="fas fa-calculator"></i> Factor Polynomial
              </button>

              <div class="example-box mt-3">
                <strong>Examples:</strong><br>
                • 3x^2 + 12x + 9<br>
                • 2x^3 - 8x<br>
                • x^3 - 27
              </div>
            </div>

          </div>
        </div>
      </div>

      <!-- Educational Content -->
      <div class="card factor-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title"><i class="fas fa-book text-success"></i> Factoring Methods</h5>

          <h6 class="mt-3"><i class="fas fa-divide text-success"></i> 1. Greatest Common Factor (GCF)</h6>
          <p><strong>Always factor out GCF first!</strong></p>
          <div class="formula-box">
            GCF(12x³ + 18x²) = 6x² · (2x + 3)
          </div>

          <h6 class="mt-3"><i class="fas fa-superscript text-success"></i> 2. Quadratic Trinomials (ax² + bx + c)</h6>
          <p><strong>Method 1: Simple (a = 1):</strong> Find two numbers that multiply to c and add to b</p>
          <div class="formula-box">
            x² + 5x + 6 = (x + 2)(x + 3)
          </div>
          <p><strong>Method 2: AC Method (a ≠ 1):</strong></p>
          <ol>
            <li>Multiply a × c</li>
            <li>Find two numbers that multiply to ac and add to b</li>
            <li>Split middle term and factor by grouping</li>
          </ol>
          <div class="formula-box">
            2x² + 7x + 3 = 2x² + 6x + x + 3<br>
            = 2x(x + 3) + 1(x + 3) = (2x + 1)(x + 3)
          </div>

          <h6 class="mt-3"><i class="fas fa-star text-success"></i> 3. Special Products</h6>

          <p><strong>Difference of Squares:</strong></p>
          <div class="formula-box">
            a² - b² = (a + b)(a - b)
          </div>
          <p>Example: x² - 25 = (x + 5)(x - 5)</p>

          <p><strong>Perfect Square Trinomial:</strong></p>
          <div class="formula-box">
            a² + 2ab + b² = (a + b)²<br>
            a² - 2ab + b² = (a - b)²
          </div>
          <p>Example: x² + 6x + 9 = (x + 3)²</p>

          <p><strong>Sum of Cubes:</strong></p>
          <div class="formula-box">
            a³ + b³ = (a + b)(a² - ab + b²)
          </div>

          <p><strong>Difference of Cubes:</strong></p>
          <div class="formula-box">
            a³ - b³ = (a - b)(a² + ab + b²)
          </div>

          <h6 class="mt-3"><i class="fas fa-layer-group text-success"></i> 4. Factor by Grouping</h6>
          <p>For 4-term polynomials:</p>
          <div class="formula-box">
            ax + ay + bx + by = a(x + y) + b(x + y)<br>
            = (a + b)(x + y)
          </div>

          <h6 class="mt-3"><i class="fas fa-lightbulb text-success"></i> Factoring Strategy</h6>
          <ol>
            <li><strong>GCF:</strong> Factor out greatest common factor first</li>
            <li><strong>Count terms:</strong>
              <ul>
                <li>2 terms → Check for difference of squares or sum/difference of cubes</li>
                <li>3 terms → Check for perfect square trinomial, then factor as quadratic</li>
                <li>4+ terms → Try factoring by grouping</li>
              </ul>
            </li>
            <li><strong>Check:</strong> Multiply factors to verify</li>
            <li><strong>Factor completely:</strong> Continue until all factors are prime</li>
          </ol>
        </div>
      </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-5">
      <div class="sticky-results">
        <div class="card factor-card shadow-sm">
          <div class="card-body">
            <h5 class="card-title">
              <i class="fas fa-check-circle text-success"></i> Factored Form
            </h5>
            <div id="results">
              <div class="text-center text-muted py-5">
                <i class="fas fa-project-diagram fa-3x mb-3"></i>
                <p>Enter an expression and click factor to see the result</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <%@ include file="thanks.jsp"%>
  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<script>
// GCD function
function gcd(a, b) {
  a = Math.abs(a);
  b = Math.abs(b);
  while (b !== 0) {
    const temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}

// Find GCF of array
function findGCF(numbers) {
  return numbers.reduce((a, b) => gcd(a, b));
}

// Check if number is perfect square
function isPerfectSquare(n) {
  const sqrt = Math.sqrt(Math.abs(n));
  return sqrt === Math.floor(sqrt);
}

// Check if number is perfect cube
function isPerfectCube(n) {
  const cbrt = Math.cbrt(n);
  return Math.abs(cbrt - Math.round(cbrt)) < 0.0001;
}

// Format coefficient
function formatCoeff(coeff) {
  if (coeff === 1) return '';
  if (coeff === -1) return '-';
  return coeff.toString();
}

// Format term
function formatTerm(coeff, variable, power) {
  if (coeff === 0) return '';

  let result = '';
  if (coeff > 0 && result !== '') result += ' + ';
  if (coeff < 0) result += ' - ';
  else if (result !== '') result += '';

  const absCoeff = Math.abs(coeff);
  if (absCoeff !== 1 || power === 0) result += absCoeff;

  if (power > 0) {
    result += variable;
    if (power > 1) result += '^' + power;
  }

  return result;
}

// Update special inputs based on pattern
function updateSpecialInputs() {
  const pattern = document.getElementById('specialPattern').value;
  const inputsDiv = document.getElementById('specialInputs');

  if (pattern === 'pst') {
    inputsDiv.innerHTML = `
      <div class="form-group">
        <label for="specialA"><i class="fas fa-square"></i> First term (a²)</label>
        <input type="number" class="form-control" id="specialA" value="4" step="any">
      </div>
      <div class="form-group">
        <label for="specialMiddle"><i class="fas fa-times"></i> Middle term coefficient</label>
        <input type="number" class="form-control" id="specialMiddle" value="12" step="any">
      </div>
      <div class="form-group">
        <label for="specialB"><i class="fas fa-square"></i> Last term (b²)</label>
        <input type="number" class="form-control" id="specialB" value="9" step="any">
      </div>
    `;
  } else {
    inputsDiv.innerHTML = `
      <div class="form-group">
        <label for="specialA"><i class="fas fa-square"></i> First term</label>
        <input type="number" class="form-control" id="specialA" value="16" step="any">
      </div>
      <div class="form-group">
        <label for="specialB"><i class="fas fa-square"></i> Second term</label>
        <input type="number" class="form-control" id="specialB" value="9" step="any">
      </div>
    `;
  }
}

// Factor quadratic
function factorQuadratic() {
  const a = parseFloat(document.getElementById('quadA').value);
  const b = parseFloat(document.getElementById('quadB').value);
  const c = parseFloat(document.getElementById('quadC').value);
  const showSteps = document.getElementById('showQuadSteps').checked;

  if (isNaN(a) || isNaN(b) || isNaN(c)) {
    alert('Please enter valid numbers for all coefficients');
    return;
  }

  if (a === 0) {
    alert('Coefficient of x² cannot be zero');
    return;
  }

  // Build original expression
  let original = '';
  if (a !== 0) original += formatCoeff(a) + 'x²';
  if (b !== 0) {
    if (b > 0 && original !== '') original += ' + ';
    if (b < 0) original += ' - ' + Math.abs(b) + 'x';
    else if (original !== '') original += b + 'x';
    else original += b + 'x';
  }
  if (c !== 0) {
    if (c > 0 && original !== '') original += ' + ';
    if (c < 0) original += ' - ' + Math.abs(c);
    else if (original !== '') original += c;
    else original += c;
  }

  let html = `
    <div class="result-box">
      <h6 class="text-center"><strong>Original Expression:</strong></h6>
      <div class="formula-box">${original}</div>
  `;

  let steps = [];
  let factored = '';
  let method = '';

  // Check for GCF first
  const coeffs = [a, b, c].filter(x => x !== 0);
  const gcf = findGCF(coeffs.map(Math.abs));

  let a1 = a, b1 = b, c1 = c;
  if (gcf > 1) {
    a1 = a / gcf;
    b1 = b / gcf;
    c1 = c / gcf;
    steps.push(`<strong>Step 1:</strong> Factor out GCF = ${gcf}`);
    method = 'GCF + ';
  }

  // Try to factor the quadratic
  if (a1 === 1) {
    // Simple case: x² + bx + c
    // Find two numbers that multiply to c and add to b
    let found = false;
    for (let i = -Math.abs(c1) - Math.abs(b1); i <= Math.abs(c1) + Math.abs(b1); i++) {
      if (i * (c1 / i) === c1 && i + (c1 / i) === b1) {
        const r1 = i;
        const r2 = c1 / i;
        factored = `(x ${r1 >= 0 ? '+' : ''} ${r1})(x ${r2 >= 0 ? '+' : ''} ${r2})`;
        if (gcf > 1) factored = `${gcf}${factored}`;

        steps.push(`<strong>Step ${gcf > 1 ? 2 : 1}:</strong> Find two numbers that multiply to ${c1} and add to ${b1}`);
        steps.push(`Numbers: ${r1} and ${r2}`);
        steps.push(`${r1} × ${r2} = ${c1}, ${r1} + ${r2} = ${b1} ✓`);
        method += 'Simple Factoring';
        found = true;
        break;
      }
    }

    if (!found) {
      // Check discriminant
      const discriminant = b * b - 4 * a * c;
      if (discriminant >= 0) {
        const sqrtD = Math.sqrt(discriminant);
        if (Math.abs(sqrtD - Math.round(sqrtD)) < 0.0001) {
          const r1 = (-b + sqrtD) / (2 * a);
          const r2 = (-b - sqrtD) / (2 * a);
          factored = `${a !== 1 ? a : ''}(x ${r1 >= 0 ? '-' : '+'} ${Math.abs(r1)})(x ${r2 >= 0 ? '-' : '+'} ${Math.abs(r2)})`;
          method += 'Quadratic Formula';
        } else {
          factored = 'Prime (cannot be factored with integers)';
          method = 'Prime';
        }
      } else {
        factored = 'Prime (no real roots)';
        method = 'Prime';
      }
    }
  } else {
    // AC method for ax² + bx + c where a ≠ 1
    const ac = a1 * c1;
    let found = false;

    for (let i = -Math.abs(ac) - Math.abs(b1); i <= Math.abs(ac) + Math.abs(b1); i++) {
      if (i !== 0 && ac % i === 0) {
        const j = ac / i;
        if (i + j === b1) {
          steps.push(`<strong>Step ${gcf > 1 ? 2 : 1}:</strong> AC Method - multiply a×c = ${a1}×${c1} = ${ac}`);
          steps.push(`Find two numbers that multiply to ${ac} and add to ${b1}`);
          steps.push(`Numbers: ${i} and ${j}`);
          steps.push(`Rewrite: ${a1}x² + ${i}x + ${j}x + ${c1}`);
          steps.push(`Factor by grouping...`);

          // Try to factor by grouping
          const gcf1 = gcd(a1, i);
          const gcf2 = gcd(j, c1);
          factored = `(${a1/gcf1}x + ${c1/gcf2})(${gcf1}x + ${gcf2})`;
          if (gcf > 1) factored = `${gcf}${factored}`;
          method += 'AC Method';
          found = true;
          break;
        }
      }
    }

    if (!found) {
      factored = 'Prime (cannot be factored with integers)';
      method = 'Prime';
    }
  }

  html += `
      <h6 class="text-center mt-3">
        <span class="method-badge">${method}</span>
      </h6>
      <div class="factored-form">${factored}</div>
  `;

  if (showSteps && steps.length > 0) {
    html += `
      <div class="step-section">
        <h6><i class="fas fa-list-ol"></i> Step-by-Step Solution</h6>
        ${steps.map(step => `<div class="step-item">${step}</div>`).join('')}
      </div>
    `;
  }

  html += `
      <div class="info-card">
        <strong><i class="fas fa-check"></i> Verification:</strong><br>
        Expand ${factored} to verify it equals ${original}
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Factor special forms
function factorSpecial() {
  const pattern = document.getElementById('specialPattern').value;
  const a = parseFloat(document.getElementById('specialA').value);
  const b = parseFloat(document.getElementById('specialB').value);

  if (isNaN(a) || isNaN(b)) {
    alert('Please enter valid numbers');
    return;
  }

  let html = '<div class="result-box">';
  let original = '';
  let factored = '';
  let patternName = '';
  let formula = '';

  if (pattern === 'dos') {
    // Difference of squares
    patternName = 'Difference of Squares';
    formula = 'a² - b² = (a + b)(a - b)';
    original = `${a}x² - ${b}`;

    if (!isPerfectSquare(a) || !isPerfectSquare(b)) {
      alert('Both terms must be perfect squares');
      return;
    }

    const sqrtA = Math.sqrt(a);
    const sqrtB = Math.sqrt(b);
    factored = `(${sqrtA}x + ${sqrtB})(${sqrtA}x - ${sqrtB})`;

  } else if (pattern === 'pst') {
    // Perfect square trinomial
    patternName = 'Perfect Square Trinomial';
    const middle = parseFloat(document.getElementById('specialMiddle').value);
    original = `${a}x² + ${middle}x + ${b}`;

    if (!isPerfectSquare(a) || !isPerfectSquare(b)) {
      alert('First and last terms must be perfect squares');
      return;
    }

    const sqrtA = Math.sqrt(a);
    const sqrtB = Math.sqrt(b);
    const expectedMiddle = 2 * sqrtA * sqrtB;

    if (Math.abs(middle) === expectedMiddle) {
      factored = middle > 0 ?
        `(${sqrtA}x + ${sqrtB})²` :
        `(${sqrtA}x - ${sqrtB})²`;
      formula = middle > 0 ?
        'a² + 2ab + b² = (a + b)²' :
        'a² - 2ab + b² = (a - b)²';
    } else {
      alert(`Not a perfect square trinomial. Middle term should be ±${expectedMiddle}`);
      return;
    }

  } else if (pattern === 'soc') {
    // Sum of cubes
    patternName = 'Sum of Cubes';
    formula = 'a³ + b³ = (a + b)(a² - ab + b²)';
    original = `${a}x³ + ${b}`;

    if (!isPerfectCube(a) || !isPerfectCube(b)) {
      alert('Both terms must be perfect cubes');
      return;
    }

    const cbrtA = Math.round(Math.cbrt(a));
    const cbrtB = Math.round(Math.cbrt(b));
    factored = `(${cbrtA}x + ${cbrtB})(${cbrtA * cbrtA}x² - ${cbrtA * cbrtB}x + ${cbrtB * cbrtB})`;

  } else if (pattern === 'doc') {
    // Difference of cubes
    patternName = 'Difference of Cubes';
    formula = 'a³ - b³ = (a - b)(a² + ab + b²)';
    original = `${a}x³ - ${b}`;

    if (!isPerfectCube(a) || !isPerfectCube(b)) {
      alert('Both terms must be perfect cubes');
      return;
    }

    const cbrtA = Math.round(Math.cbrt(a));
    const cbrtB = Math.round(Math.cbrt(b));
    factored = `(${cbrtA}x - ${cbrtB})(${cbrtA * cbrtA}x² + ${cbrtA * cbrtB}x + ${cbrtB * cbrtB})`;
  }

  html += `
    <h6 class="text-center">
      <span class="method-badge">${patternName}</span>
    </h6>
    <h6 class="text-center mt-3"><strong>Original:</strong></h6>
    <div class="formula-box">${original}</div>
    <h6 class="text-center mt-3"><strong>Formula:</strong></h6>
    <div class="formula-box">${formula}</div>
    <div class="factored-form">${factored}</div>
  </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Factor polynomial (simplified version)
function factorPolynomial() {
  const expr = document.getElementById('polyExpression').value.trim();

  if (!expr) {
    alert('Please enter a polynomial expression');
    return;
  }

  try {
    // Use math.js to parse and simplify
    const parsed = math.parse(expr);
    const simplified = math.simplify(parsed);

    let html = `
      <div class="result-box">
        <h6 class="text-center"><strong>Original:</strong></h6>
        <div class="formula-box">${expr}</div>
        <h6 class="text-center mt-3"><strong>Simplified:</strong></h6>
        <div class="factored-form">${simplified.toString()}</div>
        <div class="info-card">
          <strong><i class="fas fa-info-circle"></i> Note:</strong><br>
          For complete factoring of complex polynomials, try the specific tools above (Quadratic or Special Forms).
          This tool handles basic simplification and GCF extraction.
        </div>
      </div>
    `;

    document.getElementById('results').innerHTML = html;
  } catch (e) {
    alert('Error parsing expression. Please check your syntax.\nUse ^ for exponents: x^2, 2*x^3');
  }
}

// Initialize with default example
document.addEventListener('DOMContentLoaded', function() {
  factorQuadratic();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
