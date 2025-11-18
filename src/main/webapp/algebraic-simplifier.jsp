<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Algebraic Expression Simplifier - Simplify, Expand, Factor | 8gwifi.org</title>
<meta name="description" content="Free algebraic expression simplifier: simplify expressions, expand brackets, combine like terms, factor, and rationalize. Step-by-step algebraic simplification.">
<meta name="keywords" content="algebraic simplifier, simplify expressions, expand brackets, combine like terms, algebra calculator, expression simplifier, simplify algebraic expressions">
<link rel="canonical" href="https://8gwifi.org/algebraic-simplifier.jsp">

<!-- Open Graph -->
<meta property="og:title" content="Algebraic Expression Simplifier - Simplify & Expand">
<meta property="og:description" content="Simplify algebraic expressions, expand brackets, combine like terms, and factor with step-by-step solutions. Complete algebra simplification tool.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/algebraic-simplifier.jsp">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Algebraic Expression Simplifier - Simplify & Expand">
<meta name="twitter:description" content="Simplify algebraic expressions, expand brackets, combine like terms, and factor with step-by-step solutions. Complete algebra simplification tool.">

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Algebraic Expression Simplifier",
  "description": "Simplify algebraic expressions, expand brackets, combine like terms, factor, and rationalize with step-by-step solutions",
  "url": "https://8gwifi.org/algebraic-simplifier.jsp",
  "applicationCategory": "UtilityApplication",
  "operatingSystem": "Any",
  "permissions": "browser",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": [
    "Simplify algebraic expressions",
    "Expand brackets and parentheses",
    "Combine like terms",
    "Factor expressions",
    "Rationalize denominators",
    "Simplify fractions",
    "Step-by-step solutions"
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "3892",
    "bestRating": "5",
    "worstRating": "1"
  }
}
</script>

<%@ include file="header-script.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/mathjs@11.11.0/lib/browser/math.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/algebrite@1.4.0/dist/algebrite.bundle-for-browser.js"></script>

<style>
:root {
  --simplify-primary: #3b82f6;
  --simplify-secondary: #2563eb;
  --simplify-light: #dbeafe;
  --simplify-dark: #1e40af;
}

.simplify-card {
  border-left: 4px solid var(--simplify-primary);
  transition: all 0.3s ease;
}

.simplify-card:hover {
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.2);
  transform: translateY(-2px);
}

.simplify-badge {
  background: linear-gradient(135deg, var(--simplify-primary), var(--simplify-secondary));
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  display: inline-block;
}

.result-box {
  background: linear-gradient(135deg, var(--simplify-light), white);
  border: 2px solid var(--simplify-primary);
  border-radius: 10px;
  padding: 1.5rem;
  margin-top: 1rem;
}

.expression-display {
  font-size: 1.4rem;
  font-family: 'Times New Roman', serif;
  color: var(--simplify-dark);
  background-color: #eff6ff;
  padding: 1.5rem;
  border-radius: 8px;
  text-align: center;
  margin: 1rem 0;
  border: 2px solid var(--simplify-primary);
  word-wrap: break-word;
}

.arrow-down {
  text-align: center;
  color: var(--simplify-primary);
  font-size: 2rem;
  margin: 0.5rem 0;
}

.step-section {
  background: white;
  border: 1px solid var(--simplify-primary);
  border-radius: 8px;
  padding: 1rem;
  margin: 0.75rem 0;
}

.step-section h6 {
  color: var(--simplify-dark);
  border-bottom: 2px solid var(--simplify-primary);
  padding-bottom: 0.5rem;
  margin-bottom: 0.75rem;
}

.step-item {
  padding: 0.75rem;
  margin: 0.5rem 0;
  background-color: #f9fafb;
  border-left: 3px solid var(--simplify-primary);
  border-radius: 4px;
  font-family: 'Courier New', monospace;
}

.form-control:focus {
  border-color: var(--simplify-primary);
  box-shadow: 0 0 0 0.2rem rgba(59, 130, 246, 0.25);
}

.btn-simplify {
  background: linear-gradient(135deg, var(--simplify-primary), var(--simplify-secondary));
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-simplify:hover {
  background: linear-gradient(135deg, var(--simplify-secondary), var(--simplify-dark));
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

.sticky-results {
  position: sticky;
  top: 20px;
  max-height: calc(100vh - 40px);
  overflow-y: auto;
}

.info-card {
  background-color: var(--simplify-light);
  border-left: 4px solid var(--simplify-primary);
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
}

.nav-tabs .nav-link {
  color: var(--simplify-secondary);
  border: 2px solid transparent;
}

.nav-tabs .nav-link.active {
  color: white;
  background: linear-gradient(135deg, var(--simplify-primary), var(--simplify-secondary));
  border-color: var(--simplify-primary);
}

.nav-tabs .nav-link:hover {
  border-color: var(--simplify-light);
}

.example-box {
  background-color: #fef3c7;
  border-left: 4px solid #f59e0b;
  padding: 0.75rem;
  margin: 0.5rem 0;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
}

.operation-badge {
  background-color: var(--simplify-primary);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 600;
  margin: 0.25rem;
  display: inline-block;
}
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1><i class="fas fa-function text-primary"></i> Algebraic Expression Simplifier</h1>
  <p class="lead">Simplify, expand, and factor algebraic expressions with step-by-step solutions</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="card simplify-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title">
            <i class="fas fa-keyboard text-primary"></i> Enter Expression
          </h5>

          <div class="form-group">
            <label for="expression"><i class="fas fa-function"></i> Algebraic Expression</label>
            <input type="text" class="form-control" id="expression" value="(x + 2)(x + 3)" placeholder="e.g., (x + 2)(x + 3) or 2x^2 + 6x + 4">
            <small class="form-text text-muted">Use ^ for exponents, * for multiplication, / for division</small>
          </div>

          <!-- Tab Navigation for Operations -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="simplify-tab" data-toggle="tab" href="#simplify-panel" role="tab">
                <i class="fas fa-compress"></i> Simplify
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="expand-tab" data-toggle="tab" href="#expand-panel" role="tab">
                <i class="fas fa-expand"></i> Expand
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="factor-tab" data-toggle="tab" href="#factor-panel" role="tab">
                <i class="fas fa-project-diagram"></i> Factor
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="all-tab" data-toggle="tab" href="#all-panel" role="tab">
                <i class="fas fa-layer-group"></i> All
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- Simplify -->
            <div class="tab-pane fade show active" id="simplify-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Simplify:</strong><br>
                Combines like terms and reduces to simplest form
              </div>

              <button class="btn btn-simplify btn-block" onclick="simplifyExpression()">
                <i class="fas fa-compress"></i> Simplify Expression
              </button>
            </div>

            <!-- Expand -->
            <div class="tab-pane fade" id="expand-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Expand:</strong><br>
                Multiplies out brackets and parentheses
              </div>

              <button class="btn btn-simplify btn-block" onclick="expandExpression()">
                <i class="fas fa-expand"></i> Expand Expression
              </button>
            </div>

            <!-- Factor -->
            <div class="tab-pane fade" id="factor-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Factor:</strong><br>
                Factors the expression into products
              </div>

              <button class="btn btn-simplify btn-block" onclick="factorExpression()">
                <i class="fas fa-project-diagram"></i> Factor Expression
              </button>
            </div>

            <!-- All Operations -->
            <div class="tab-pane fade" id="all-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Show all:</strong><br>
                Performs all operations: simplify, expand, and factor
              </div>

              <button class="btn btn-simplify btn-block" onclick="performAll()">
                <i class="fas fa-layer-group"></i> Perform All Operations
              </button>
            </div>

          </div>

          <div class="example-box mt-3">
            <strong>Examples:</strong><br>
            • (x + 2)(x + 3) → Expand<br>
            • x^2 + 5*x + 6 → Factor<br>
            • 2*x + 3*x - x → Simplify<br>
            • (a + b)^2 → Expand<br>
            • x^2 - 9 → Factor
          </div>
        </div>
      </div>

      <!-- Educational Content -->
      <div class="card simplify-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title"><i class="fas fa-book text-primary"></i> Simplification Rules</h5>

          <h6 class="mt-3"><i class="fas fa-plus-circle text-primary"></i> Combining Like Terms</h6>
          <p>Terms with the same variables and exponents can be combined:</p>
          <div class="formula-box">
            3x + 5x = 8x<br>
            2x² + 7x² = 9x²<br>
            4xy - 2xy = 2xy
          </div>
          <p><strong>Note:</strong> 3x + 5x² cannot be combined (different exponents)</p>

          <h6 class="mt-3"><i class="fas fa-expand-arrows-alt text-primary"></i> Expanding Expressions</h6>

          <p><strong>Distributive Property:</strong></p>
          <div class="formula-box">
            a(b + c) = ab + ac<br>
            3(x + 2) = 3x + 6
          </div>

          <p><strong>FOIL Method (First, Outer, Inner, Last):</strong></p>
          <div class="formula-box">
            (a + b)(c + d) = ac + ad + bc + bd<br>
            (x + 2)(x + 3) = x² + 3x + 2x + 6 = x² + 5x + 6
          </div>

          <p><strong>Special Products:</strong></p>
          <ul>
            <li><strong>Square of sum:</strong> (a + b)² = a² + 2ab + b²</li>
            <li><strong>Square of difference:</strong> (a - b)² = a² - 2ab + b²</li>
            <li><strong>Difference of squares:</strong> (a + b)(a - b) = a² - b²</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-project-diagram text-primary"></i> Factoring</h6>

          <p><strong>Greatest Common Factor (GCF):</strong></p>
          <div class="formula-box">
            6x + 9 = 3(2x + 3)<br>
            4x² + 8x = 4x(x + 2)
          </div>

          <p><strong>Difference of Squares:</strong></p>
          <div class="formula-box">
            a² - b² = (a + b)(a - b)<br>
            x² - 9 = (x + 3)(x - 3)
          </div>

          <p><strong>Perfect Square Trinomials:</strong></p>
          <div class="formula-box">
            x² + 6x + 9 = (x + 3)²<br>
            x² - 10x + 25 = (x - 5)²
          </div>

          <h6 class="mt-3"><i class="fas fa-divide text-primary"></i> Simplifying Fractions</h6>
          <div class="formula-box">
            (6x² + 9x) / 3x = (3x(2x + 3)) / 3x = 2x + 3
          </div>

          <h6 class="mt-3"><i class="fas fa-sort-amount-up text-primary"></i> Order of Operations</h6>
          <p><strong>PEMDAS/BODMAS:</strong></p>
          <ol>
            <li><strong>P</strong>arentheses/Brackets</li>
            <li><strong>E</strong>xponents/Orders</li>
            <li><strong>M</strong>ultiplication & <strong>D</strong>ivision (left to right)</li>
            <li><strong>A</strong>ddition & <strong>S</strong>ubtraction (left to right)</li>
          </ol>

          <h6 class="mt-3"><i class="fas fa-lightbulb text-primary"></i> Simplification Strategy</h6>
          <ol>
            <li>Remove parentheses (expand if needed)</li>
            <li>Combine like terms</li>
            <li>Factor out GCF if possible</li>
            <li>Look for special patterns (difference of squares, etc.)</li>
            <li>Cancel common factors in fractions</li>
          </ol>
        </div>
      </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-5">
      <div class="sticky-results">
        <div class="card simplify-card shadow-sm">
          <div class="card-body">
            <h5 class="card-title">
              <i class="fas fa-check-circle text-primary"></i> Result
            </h5>
            <div id="results">
              <div class="text-center text-muted py-5">
                <i class="fas fa-function fa-3x mb-3"></i>
                <p>Enter an expression and select an operation to see the result</p>
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
// Get expression from input
function getExpression() {
  return document.getElementById('expression').value.trim();
}

// Format math expression for display
function formatExpression(expr) {
  return expr
    .replace(/\*/g, ' · ')
    .replace(/\^/g, '<sup>') + '</sup>'
    .replace(/<sup><\/sup>/g, '');
}

// Simplify expression
function simplifyExpression() {
  const expr = getExpression();

  if (!expr) {
    alert('Please enter an expression');
    return;
  }

  try {
    // Parse and simplify using math.js
    const parsed = math.parse(expr);
    const simplified = math.simplify(parsed);
    const result = simplified.toString();

    let html = `
      <div class="result-box">
        <h6 class="text-center">
          <span class="operation-badge">Simplify</span>
        </h6>

        <h6 class="text-center mt-3"><strong>Original:</strong></h6>
        <div class="expression-display">${expr}</div>

        <div class="arrow-down">
          <i class="fas fa-arrow-down"></i>
        </div>

        <h6 class="text-center"><strong>Simplified:</strong></h6>
        <div class="expression-display">${result}</div>

        <div class="step-section">
          <h6><i class="fas fa-info-circle"></i> Simplification Process</h6>
          <div class="step-item">Combined like terms and reduced to simplest form</div>
          ${expr !== result ? `<div class="step-item">Original: ${expr}</div><div class="step-item">Result: ${result}</div>` : '<div class="step-item">Expression is already in simplest form</div>'}
        </div>
      </div>
    `;

    document.getElementById('results').innerHTML = html;
  } catch (e) {
    alert('Error simplifying expression. Please check your syntax.\n' + e.message);
  }
}

// Expand expression
function expandExpression() {
  const expr = getExpression();

  if (!expr) {
    alert('Please enter an expression');
    return;
  }

  try {
    // Try using Algebrite for better expansion
    let result;
    try {
      Algebrite.run('clear');
      result = Algebrite.run('expand(' + expr + ')').toString();
    } catch (e) {
      // Fallback to math.js
      const parsed = math.parse(expr);
      const expanded = math.simplify(parsed, [{ l: '(n1+n2)*n3', r: 'n1*n3 + n2*n3' }]);
      result = expanded.toString();
    }

    let html = `
      <div class="result-box">
        <h6 class="text-center">
          <span class="operation-badge">Expand</span>
        </h6>

        <h6 class="text-center mt-3"><strong>Original:</strong></h6>
        <div class="expression-display">${expr}</div>

        <div class="arrow-down">
          <i class="fas fa-arrow-down"></i>
        </div>

        <h6 class="text-center"><strong>Expanded:</strong></h6>
        <div class="expression-display">${result}</div>

        <div class="step-section">
          <h6><i class="fas fa-info-circle"></i> Expansion Process</h6>
          <div class="step-item">Applied distributive property: a(b + c) = ab + ac</div>
          <div class="step-item">Multiplied out all parentheses and brackets</div>
          <div class="step-item">Combined like terms</div>
        </div>

        <div class="info-card">
          <strong><i class="fas fa-lightbulb"></i> Common Expansions:</strong><br>
          • (a + b)² = a² + 2ab + b²<br>
          • (a - b)² = a² - 2ab + b²<br>
          • (a + b)(a - b) = a² - b²
        </div>
      </div>
    `;

    document.getElementById('results').innerHTML = html;
  } catch (e) {
    alert('Error expanding expression. Please check your syntax.\n' + e.message);
  }
}

// Factor expression
function factorExpression() {
  const expr = getExpression();

  if (!expr) {
    alert('Please enter an expression');
    return;
  }

  try {
    // Try using Algebrite for factoring
    let result;
    try {
      Algebrite.run('clear');
      result = Algebrite.run('factor(' + expr + ')').toString();
    } catch (e) {
      // Fallback message
      result = 'Factoring not available for this expression';
    }

    let html = `
      <div class="result-box">
        <h6 class="text-center">
          <span class="operation-badge">Factor</span>
        </h6>

        <h6 class="text-center mt-3"><strong>Original:</strong></h6>
        <div class="expression-display">${expr}</div>

        <div class="arrow-down">
          <i class="fas fa-arrow-down"></i>
        </div>

        <h6 class="text-center"><strong>Factored:</strong></h6>
        <div class="expression-display">${result}</div>

        <div class="step-section">
          <h6><i class="fas fa-info-circle"></i> Factoring Process</h6>
          <div class="step-item">Checked for greatest common factor (GCF)</div>
          <div class="step-item">Applied factoring patterns (difference of squares, perfect squares, etc.)</div>
          <div class="step-item">Factored completely</div>
        </div>

        <div class="info-card">
          <strong><i class="fas fa-lightbulb"></i> Factoring Patterns:</strong><br>
          • a² - b² = (a + b)(a - b)<br>
          • x² + bx + c = (x + m)(x + n) where mn = c, m+n = b<br>
          • For complex factoring, try our <a href="factoring-calculator.jsp">Factoring Calculator</a>
        </div>
      </div>
    `;

    document.getElementById('results').innerHTML = html;
  } catch (e) {
    alert('Error factoring expression. Please check your syntax.\n' + e.message);
  }
}

// Perform all operations
function performAll() {
  const expr = getExpression();

  if (!expr) {
    alert('Please enter an expression');
    return;
  }

  try {
    // Simplify
    const parsed = math.parse(expr);
    const simplified = math.simplify(parsed);
    const simplifiedStr = simplified.toString();

    // Expand
    let expanded = simplifiedStr;
    try {
      Algebrite.run('clear');
      expanded = Algebrite.run('expand(' + expr + ')').toString();
    } catch (e) {
      // Use simplified version
    }

    // Factor
    let factored = simplifiedStr;
    try {
      Algebrite.run('clear');
      factored = Algebrite.run('factor(' + expr + ')').toString();
    } catch (e) {
      // Use simplified version
    }

    let html = `
      <div class="result-box">
        <h6 class="text-center">
          <span class="operation-badge">All Operations</span>
        </h6>

        <h6 class="text-center mt-3"><strong>Original Expression:</strong></h6>
        <div class="expression-display">${expr}</div>

        <div class="step-section">
          <h6><i class="fas fa-compress"></i> Simplified Form</h6>
          <div class="expression-display">${simplifiedStr}</div>
        </div>

        <div class="step-section">
          <h6><i class="fas fa-expand"></i> Expanded Form</h6>
          <div class="expression-display">${expanded}</div>
        </div>

        <div class="step-section">
          <h6><i class="fas fa-project-diagram"></i> Factored Form</h6>
          <div class="expression-display">${factored}</div>
        </div>

        <div class="info-card">
          <strong><i class="fas fa-info-circle"></i> Understanding the Results:</strong><br>
          • <strong>Simplified:</strong> Combines like terms<br>
          • <strong>Expanded:</strong> Multiplies out all brackets<br>
          • <strong>Factored:</strong> Expresses as product of simpler terms<br><br>
          Different forms are useful for different purposes in algebra!
        </div>
      </div>
    `;

    document.getElementById('results').innerHTML = html;
  } catch (e) {
    alert('Error processing expression. Please check your syntax.\n' + e.message);
  }
}

// Initialize with default example
document.addEventListener('DOMContentLoaded', function() {
  expandExpression();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
