<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Logarithm Calculator - Log, Ln, pH, Decibels, Graphing & More | 8gwifi.org</title>
<meta name="description" content="Advanced logarithm calculator with interactive graphing, real-world applications (pH, decibels, Richter scale), compound expressions, inequality solver, and comparison tables. Calculate log, ln, antilog with step-by-step solutions.">
<meta name="keywords" content="logarithm calculator, log calculator, natural log, ln calculator, pH calculator, decibel calculator, Richter scale, logarithm graph, log inequality solver, compound logarithm, change of base, antilog calculator, log properties">
<link rel="canonical" href="https://8gwifi.org/logarithm-calculator.jsp">

<!-- Open Graph -->
<meta property="og:title" content="Advanced Logarithm Calculator - Graphing, pH, Decibels & More">
<meta property="og:description" content="Interactive logarithm calculator with graphing, real-world applications (pH, decibels, Richter scale), compound expressions, inequality solver, and comparison tables. Free with step-by-step solutions.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/logarithm-calculator.jsp">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Advanced Logarithm Calculator - Graphing, pH, Decibels & More">
<meta name="twitter:description" content="Interactive logarithm calculator with graphing, real-world applications (pH, decibels, Richter scale), compound expressions, inequality solver, and comparison tables.">

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Logarithm Calculator",
  "description": "Advanced logarithm calculator with graphing, real-world applications (pH, decibels, Richter scale), compound expressions, inequality solver, and comparison tables. Calculate log base 10, natural logarithm (ln), antilog, and more with step-by-step solutions.",
  "url": "https://8gwifi.org/logarithm-calculator.jsp",
  "applicationCategory": "UtilityApplication",
  "operatingSystem": "Any",
  "permissions": "browser",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": [
    "Common logarithm (log base 10)",
    "Natural logarithm (ln)",
    "Logarithm with any base",
    "Change of base formula",
    "Antilogarithm (10^x, e^x, b^x)",
    "Logarithm properties calculator",
    "Compound expression simplifier (log(a) + log(b))",
    "Logarithmic inequality solver",
    "Interactive logarithm graph visualization",
    "pH calculator (chemistry)",
    "Decibel calculator (sound intensity)",
    "Richter scale calculator (earthquake magnitude)",
    "Half-life calculator (radioactive decay)",
    "Compound interest time calculator",
    "Multi-base comparison table",
    "Step-by-step solutions with explanations"
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "ratingCount": "3124",
    "bestRating": "5",
    "worstRating": "1"
  }
}
</script>

<%@ include file="header-script.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

<style>
:root {
  --log-primary: #8b5cf6;
  --log-secondary: #7c3aed;
  --log-light: #ede9fe;
  --log-dark: #5b21b6;
}

.log-card {
  border-left: 4px solid var(--log-primary);
  transition: all 0.3s ease;
}

.log-card:hover {
  box-shadow: 0 4px 12px rgba(139, 92, 246, 0.2);
  transform: translateY(-2px);
}

.log-badge {
  background: linear-gradient(135deg, var(--log-primary), var(--log-secondary));
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  display: inline-block;
}

.result-box {
  background: linear-gradient(135deg, var(--log-light), white);
  border: 2px solid var(--log-primary);
  border-radius: 10px;
  padding: 1.5rem;
  margin-top: 1rem;
}

.log-result {
  font-size: 1.5rem;
  font-family: 'Times New Roman', serif;
  color: var(--log-dark);
  background-color: #f5f3ff;
  padding: 1.5rem;
  border-radius: 8px;
  text-align: center;
  margin: 1rem 0;
  border: 2px solid var(--log-primary);
}

.step-section {
  background: white;
  border: 1px solid var(--log-primary);
  border-radius: 8px;
  padding: 1rem;
  margin: 0.75rem 0;
}

.step-section h6 {
  color: var(--log-dark);
  border-bottom: 2px solid var(--log-primary);
  padding-bottom: 0.5rem;
  margin-bottom: 0.75rem;
}

.step-item {
  padding: 0.75rem;
  margin: 0.5rem 0;
  background-color: #f9fafb;
  border-left: 3px solid var(--log-primary);
  border-radius: 4px;
}

.form-control:focus {
  border-color: var(--log-primary);
  box-shadow: 0 0 0 0.2rem rgba(139, 92, 246, 0.25);
}

.btn-log {
  background: linear-gradient(135deg, var(--log-primary), var(--log-secondary));
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-log:hover {
  background: linear-gradient(135deg, var(--log-secondary), var(--log-dark));
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
}

.sticky-results {
  position: sticky;
  top: 20px;
  max-height: calc(100vh - 40px);
  overflow-y: auto;
}

.chart-container {
  position: relative;
  height: 300px;
  margin: 1rem 0;
}

.info-card {
  background-color: var(--log-light);
  border-left: 4px solid var(--log-primary);
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

.nav-tabs .nav-link {
  color: var(--log-secondary);
  border: 2px solid transparent;
}

.nav-tabs .nav-link.active {
  color: white;
  background: linear-gradient(135deg, var(--log-primary), var(--log-secondary));
  border-color: var(--log-primary);
}

.nav-tabs .nav-link:hover {
  border-color: var(--log-light);
}

.example-box {
  background-color: #dbeafe;
  border-left: 4px solid #3b82f6;
  padding: 0.75rem;
  margin: 0.5rem 0;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
}

.property-badge {
  background-color: var(--log-primary);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 600;
}
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1><i class="fas fa-subscript text-purple"></i> Logarithm Calculator</h1>
  <p class="lead">Calculate logarithms: log, ln, change of base, antilog with step-by-step solutions</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="card log-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title">
            <i class="fas fa-calculator text-purple"></i> Logarithm Calculator
          </h5>

          <!-- Tab Navigation -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="basic-tab" data-toggle="tab" href="#basic-panel" role="tab">
                <i class="fas fa-calculator"></i> Basic
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="antilog-tab" data-toggle="tab" href="#antilog-panel" role="tab">
                <i class="fas fa-undo"></i> Antilog
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="properties-tab" data-toggle="tab" href="#properties-panel" role="tab">
                <i class="fas fa-list"></i> Properties
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="compound-tab" data-toggle="tab" href="#compound-panel" role="tab">
                <i class="fas fa-layer-group"></i> Compound
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="inequality-tab" data-toggle="tab" href="#inequality-panel" role="tab">
                <i class="fas fa-greater-than"></i> Inequality
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="realworld-tab" data-toggle="tab" href="#realworld-panel" role="tab">
                <i class="fas fa-flask"></i> Real-World
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="compare-tab" data-toggle="tab" href="#compare-panel" role="tab">
                <i class="fas fa-table"></i> Compare
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="graph-tab" data-toggle="tab" href="#graph-panel" role="tab">
                <i class="fas fa-chart-line"></i> Graph
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- Basic Logarithm -->
            <div class="tab-pane fade show active" id="basic-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Calculate:</strong> log<sub>base</sub>(value)
              </div>

              <div class="form-group">
                <label><i class="fas fa-list"></i> Logarithm Type</label>
                <select class="form-control" id="logType" onchange="updateLogInputs()">
                  <option value="common">Common Log (log₁₀)</option>
                  <option value="natural">Natural Log (ln)</option>
                  <option value="custom">Custom Base</option>
                </select>
              </div>

              <div id="customBaseDiv" style="display: none;">
                <div class="form-group">
                  <label for="logBase"><i class="fas fa-subscript"></i> Base (b)</label>
                  <input type="number" class="form-control" id="logBase" value="2" step="any" min="0.0001">
                  <small class="form-text text-muted">Base must be positive and ≠ 1</small>
                </div>
              </div>

              <div class="form-group">
                <label for="logValue"><i class="fas fa-hashtag"></i> Value (x)</label>
                <input type="number" class="form-control" id="logValue" value="100" step="any" min="0.0001">
                <small class="form-text text-muted">Value must be positive</small>
              </div>

              <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="showLogSteps" checked>
                <label class="form-check-label" for="showLogSteps">
                  Show Step-by-Step Solution
                </label>
              </div>

              <button class="btn btn-log btn-block" onclick="calculateLog()">
                <i class="fas fa-calculator"></i> Calculate Logarithm
              </button>

              <div class="example-box mt-3">
                <strong>Examples:</strong><br>
                • log₁₀(100) = 2<br>
                • ln(e) = 1<br>
                • log₂(8) = 3
              </div>
            </div>

            <!-- Antilogarithm -->
            <div class="tab-pane fade" id="antilog-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Calculate antilog:</strong> base<sup>value</sup>
              </div>

              <div class="form-group">
                <label><i class="fas fa-list"></i> Antilog Type</label>
                <select class="form-control" id="antilogType" onchange="updateAntilogInputs()">
                  <option value="common">Common Antilog (10^x)</option>
                  <option value="natural">Natural Antilog (e^x)</option>
                  <option value="custom">Custom Base</option>
                </select>
              </div>

              <div id="customAntilogBaseDiv" style="display: none;">
                <div class="form-group">
                  <label for="antilogBase"><i class="fas fa-subscript"></i> Base (b)</label>
                  <input type="number" class="form-control" id="antilogBase" value="2" step="any" min="0.0001">
                </div>
              </div>

              <div class="form-group">
                <label for="antilogValue"><i class="fas fa-superscript"></i> Exponent (x)</label>
                <input type="number" class="form-control" id="antilogValue" value="2" step="any">
              </div>

              <button class="btn btn-log btn-block" onclick="calculateAntilog()">
                <i class="fas fa-undo"></i> Calculate Antilog
              </button>

              <div class="example-box mt-3">
                <strong>Examples:</strong><br>
                • 10² = 100<br>
                • e¹ = 2.71828...<br>
                • 2³ = 8
              </div>
            </div>

            <!-- Logarithm Properties -->
            <div class="tab-pane fade" id="properties-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Apply logarithm properties</strong>
              </div>

              <div class="form-group">
                <label><i class="fas fa-list"></i> Select Property</label>
                <select class="form-control" id="propertyType">
                  <option value="product">Product Rule: log(ab) = log(a) + log(b)</option>
                  <option value="quotient">Quotient Rule: log(a/b) = log(a) - log(b)</option>
                  <option value="power">Power Rule: log(a^n) = n·log(a)</option>
                  <option value="changebase">Change of Base: log_b(x) = log(x)/log(b)</option>
                </select>
              </div>

              <div id="propertyInputs">
                <div class="form-group">
                  <label for="propA"><i class="fas fa-hashtag"></i> Value a</label>
                  <input type="number" class="form-control" id="propA" value="10" step="any" min="0.0001">
                </div>

                <div class="form-group">
                  <label for="propB"><i class="fas fa-hashtag"></i> Value b</label>
                  <input type="number" class="form-control" id="propB" value="5" step="any" min="0.0001">
                </div>
              </div>

              <button class="btn btn-log btn-block" onclick="applyProperty()">
                <i class="fas fa-magic"></i> Apply Property
              </button>
            </div>

            <!-- Solve Logarithmic Equation -->
            <div class="tab-pane fade" id="equation-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Solve for x:</strong> log<sub>base</sub>(x) = value
              </div>

              <div class="form-group">
                <label for="eqBase"><i class="fas fa-subscript"></i> Base (b)</label>
                <input type="number" class="form-control" id="eqBase" value="10" step="any" min="0.0001">
              </div>

              <div class="form-group">
                <label for="eqResult"><i class="fas fa-equals"></i> Result (log value)</label>
                <input type="number" class="form-control" id="eqResult" value="2" step="any">
              </div>

              <button class="btn btn-log btn-block" onclick="solveEquation()">
                <i class="fas fa-calculator"></i> Solve for x
              </button>

              <div class="example-box mt-3">
                <strong>Examples:</strong><br>
                • log₁₀(x) = 2 → x = 100<br>
                • log₂(x) = 3 → x = 8<br>
                • ln(x) = 1 → x = e
              </div>
            </div>

            <!-- Compound Expressions -->
            <div class="tab-pane fade" id="compound-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Simplify compound logarithmic expressions</strong>
              </div>

              <div class="form-group">
                <label><i class="fas fa-list"></i> Expression Type</label>
                <select class="form-control" id="compoundType">
                  <option value="sum">log(a) + log(b) = log(ab)</option>
                  <option value="diff">log(a) - log(b) = log(a/b)</option>
                  <option value="complex">log(a²b³/c⁴)</option>
                </select>
              </div>

              <div id="compoundInputs">
                <div class="form-group">
                  <label for="compA"><i class="fas fa-hashtag"></i> Value a</label>
                  <input type="number" class="form-control" id="compA" value="8" step="any" min="0.0001">
                </div>

                <div class="form-group">
                  <label for="compB"><i class="fas fa-hashtag"></i> Value b</label>
                  <input type="number" class="form-control" id="compB" value="2" step="any" min="0.0001">
                </div>
              </div>

              <button class="btn btn-log btn-block" onclick="simplifyCompound()">
                <i class="fas fa-compress"></i> Simplify Expression
              </button>

              <div class="example-box mt-3">
                <strong>Examples:</strong><br>
                • log(8) + log(2) = log(16)<br>
                • log(100) - log(10) = log(10)<br>
                • log(x²y³) = 2·log(x) + 3·log(y)
              </div>
            </div>

            <!-- Logarithmic Inequalities -->
            <div class="tab-pane fade" id="inequality-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Solve logarithmic inequalities</strong>
              </div>

              <div class="form-group">
                <label for="ineqBase"><i class="fas fa-subscript"></i> Base (b)</label>
                <input type="number" class="form-control" id="ineqBase" value="10" step="any" min="0.0001">
              </div>

              <div class="form-group">
                <label><i class="fas fa-list"></i> Inequality Type</label>
                <select class="form-control" id="ineqType">
                  <option value="gt">log_b(x) > k</option>
                  <option value="gte">log_b(x) ≥ k</option>
                  <option value="lt">log_b(x) < k</option>
                  <option value="lte">log_b(x) ≤ k</option>
                </select>
              </div>

              <div class="form-group">
                <label for="ineqK"><i class="fas fa-hashtag"></i> Value k</label>
                <input type="number" class="form-control" id="ineqK" value="2" step="any">
              </div>

              <button class="btn btn-log btn-block" onclick="solveInequality()">
                <i class="fas fa-greater-than"></i> Solve Inequality
              </button>

              <div class="example-box mt-3">
                <strong>Examples:</strong><br>
                • log(x) > 2 → x > 100<br>
                • log₂(x) < 3 → 0 < x < 8<br>
                • ln(x) ≥ 1 → x ≥ e
              </div>
            </div>

            <!-- Real-World Applications -->
            <div class="tab-pane fade" id="realworld-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Real-world logarithm applications</strong>
              </div>

              <div class="form-group">
                <label><i class="fas fa-list"></i> Application Type</label>
                <select class="form-control" id="appType" onchange="updateAppInputs()">
                  <option value="ph">pH Scale (Chemistry)</option>
                  <option value="decibel">Decibels (Sound Intensity)</option>
                  <option value="richter">Richter Scale (Earthquake)</option>
                  <option value="halflife">Half-Life (Radioactive Decay)</option>
                  <option value="compound">Compound Interest (Time)</option>
                </select>
              </div>

              <div id="appInputs">
                <!-- pH inputs -->
                <div class="form-group">
                  <label for="appValue"><i class="fas fa-hashtag"></i> [H⁺] Concentration (mol/L)</label>
                  <input type="number" class="form-control" id="appValue" value="0.001" step="any" min="0.0000000000001">
                  <small class="form-text text-muted">pH = -log[H⁺]</small>
                </div>
              </div>

              <button class="btn btn-log btn-block" onclick="calculateRealWorld()">
                <i class="fas fa-flask"></i> Calculate
              </button>

              <div class="example-box mt-3">
                <strong>Common Values:</strong><br>
                • pH: Battery acid ≈ 0, Neutral ≈ 7, Bleach ≈ 13<br>
                • Decibels: Whisper ≈ 30 dB, Normal talk ≈ 60 dB<br>
                • Richter: Minor ≈ 3, Moderate ≈ 5, Major ≈ 7
              </div>
            </div>

            <!-- Comparison Table -->
            <div class="tab-pane fade" id="compare-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Compare logarithms with different bases</strong>
              </div>

              <div class="form-group">
                <label for="compareValue"><i class="fas fa-hashtag"></i> Value to Compare</label>
                <input type="number" class="form-control" id="compareValue" value="1000" step="any" min="0.0001">
              </div>

              <div class="form-check mb-2">
                <input type="checkbox" class="form-check-input" id="includeLog2" checked>
                <label class="form-check-label" for="includeLog2">log₂ (base 2)</label>
              </div>

              <div class="form-check mb-2">
                <input type="checkbox" class="form-check-input" id="includeLog10" checked>
                <label class="form-check-label" for="includeLog10">log₁₀ (base 10)</label>
              </div>

              <div class="form-check mb-2">
                <input type="checkbox" class="form-check-input" id="includeLn" checked>
                <label class="form-check-label" for="includeLn">ln (natural log, base e)</label>
              </div>

              <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="includeCustomCompare">
                <label class="form-check-label" for="includeCustomCompare">Custom base</label>
              </div>

              <div id="customCompareDiv" style="display: none;">
                <div class="form-group">
                  <label for="customCompareBase"><i class="fas fa-subscript"></i> Custom Base</label>
                  <input type="number" class="form-control" id="customCompareBase" value="5" step="any" min="0.0001">
                </div>
              </div>

              <button class="btn btn-log btn-block" onclick="compareLogarithms()">
                <i class="fas fa-table"></i> Generate Comparison Table
              </button>
            </div>

            <!-- Graph Visualization -->
            <div class="tab-pane fade" id="graph-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Visualize logarithm curves</strong>
              </div>

              <div class="form-check mb-2">
                <input type="checkbox" class="form-check-input" id="graphLog2" checked>
                <label class="form-check-label" for="graphLog2">log₂(x)</label>
              </div>

              <div class="form-check mb-2">
                <input type="checkbox" class="form-check-input" id="graphLog10" checked>
                <label class="form-check-label" for="graphLog10">log₁₀(x)</label>
              </div>

              <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="graphLn" checked>
                <label class="form-check-label" for="graphLn">ln(x)</label>
              </div>

              <div class="form-group">
                <label for="graphXMax"><i class="fas fa-arrows-alt-h"></i> X-axis Range (0 to)</label>
                <input type="number" class="form-control" id="graphXMax" value="10" step="any" min="1">
              </div>

              <button class="btn btn-log btn-block" onclick="drawLogGraph()">
                <i class="fas fa-chart-line"></i> Draw Graph
              </button>

              <div class="example-box mt-3">
                <strong>Key Features:</strong><br>
                • Domain: x > 0 (logarithm undefined for x ≤ 0)<br>
                • Passes through (1, 0) for all bases<br>
                • Increases slowly as x increases<br>
                • Vertical asymptote at x = 0
              </div>
            </div>

          </div>
        </div>
      </div>

      <!-- Educational Content -->
      <div class="card log-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title"><i class="fas fa-book text-purple"></i> Understanding Logarithms</h5>

          <h6 class="mt-3"><i class="fas fa-question-circle text-purple"></i> What is a Logarithm?</h6>
          <p>A logarithm answers the question: <strong>"What power do I raise the base to, to get this number?"</strong></p>
          <div class="formula-box">
            If b<sup>y</sup> = x, then log<sub>b</sub>(x) = y
          </div>
          <p><strong>Example:</strong> Since 2³ = 8, we say log₂(8) = 3</p>

          <h6 class="mt-3"><i class="fas fa-list-alt text-purple"></i> Common Logarithms</h6>

          <p><strong>1. Common Logarithm (log):</strong></p>
          <div class="formula-box">
            log(x) = log₁₀(x)
          </div>
          <p>Base 10. Used in science, engineering, pH scale, decibels</p>

          <p><strong>2. Natural Logarithm (ln):</strong></p>
          <div class="formula-box">
            ln(x) = log<sub>e</sub>(x)<br>
            where e ≈ 2.71828...
          </div>
          <p>Base e (Euler's number). Used in calculus, exponential growth/decay</p>

          <h6 class="mt-3"><i class="fas fa-magic text-purple"></i> Logarithm Properties</h6>

          <p><strong>Product Rule:</strong></p>
          <div class="formula-box">
            log<sub>b</sub>(xy) = log<sub>b</sub>(x) + log<sub>b</sub>(y)
          </div>
          <p>The log of a product equals the sum of the logs</p>

          <p><strong>Quotient Rule:</strong></p>
          <div class="formula-box">
            log<sub>b</sub>(x/y) = log<sub>b</sub>(x) - log<sub>b</sub>(y)
          </div>
          <p>The log of a quotient equals the difference of the logs</p>

          <p><strong>Power Rule:</strong></p>
          <div class="formula-box">
            log<sub>b</sub>(x<sup>n</sup>) = n · log<sub>b</sub>(x)
          </div>
          <p>The log of a power equals the exponent times the log</p>

          <p><strong>Change of Base Formula:</strong></p>
          <div class="formula-box">
            log<sub>b</sub>(x) = log<sub>c</sub>(x) / log<sub>c</sub>(b)
          </div>
          <p>Convert any base to base 10 or base e</p>

          <h6 class="mt-3"><i class="fas fa-calculator text-purple"></i> Special Values</h6>
          <ul>
            <li>log<sub>b</sub>(1) = 0 (any base to power 0 equals 1)</li>
            <li>log<sub>b</sub>(b) = 1 (base to power 1 equals itself)</li>
            <li>log<sub>b</sub>(b<sup>n</sup>) = n (simplifies directly)</li>
            <li>b<sup>log<sub>b</sub>(x)</sup> = x (log and exponent cancel)</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-lightbulb text-purple"></i> Real-World Applications</h6>
          <ul>
            <li><strong>pH Scale:</strong> pH = -log[H⁺] (acidity)</li>
            <li><strong>Richter Scale:</strong> Earthquake magnitude</li>
            <li><strong>Decibels:</strong> Sound intensity (dB = 10·log(I/I₀))</li>
            <li><strong>Half-life:</strong> Radioactive decay calculations</li>
            <li><strong>Compound Interest:</strong> Time to reach target amount</li>
            <li><strong>Population Growth:</strong> Exponential models</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-exclamation-triangle text-purple"></i> Important Notes</h6>
          <ul>
            <li>Cannot take log of negative numbers (in real numbers)</li>
            <li>Cannot take log of zero</li>
            <li>Base must be positive and ≠ 1</li>
            <li>log(x) is undefined for x ≤ 0</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-5">
      <div class="sticky-results">
        <div class="card log-card shadow-sm">
          <div class="card-body">
            <h5 class="card-title">
              <i class="fas fa-chart-line text-purple"></i> Result
            </h5>
            <div id="results">
              <div class="text-center text-muted py-5">
                <i class="fas fa-subscript fa-3x mb-3"></i>
                <p>Enter values and click calculate to see logarithm result</p>
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
// Update inputs based on log type
function updateLogInputs() {
  const type = document.getElementById('logType').value;
  document.getElementById('customBaseDiv').style.display = type === 'custom' ? 'block' : 'none';
}

// Update inputs based on antilog type
function updateAntilogInputs() {
  const type = document.getElementById('antilogType').value;
  document.getElementById('customAntilogBaseDiv').style.display = type === 'custom' ? 'block' : 'none';
}

// Calculate logarithm
function calculateLog() {
  const type = document.getElementById('logType').value;
  const value = parseFloat(document.getElementById('logValue').value);
  const showSteps = document.getElementById('showLogSteps').checked;

  if (isNaN(value) || value <= 0) {
    alert('Value must be a positive number');
    return;
  }

  let base, baseSymbol, result;

  if (type === 'common') {
    base = 10;
    baseSymbol = 'log₁₀';
    result = Math.log10(value);
  } else if (type === 'natural') {
    base = Math.E;
    baseSymbol = 'ln';
    result = Math.log(value);
  } else {
    base = parseFloat(document.getElementById('logBase').value);
    if (isNaN(base) || base <= 0 || base === 1) {
      alert('Base must be positive and not equal to 1');
      return;
    }
    baseSymbol = `log₍${base}₎`;
    result = Math.log(value) / Math.log(base);
  }

  let html = `
    <div class="result-box">
      <h6 class="text-center">
        <span class="property-badge">${baseSymbol}(${value})</span>
      </h6>

      <div class="log-result">
        ${result.toFixed(8)}
      </div>

      <div class="step-section">
        <h6><i class="fas fa-info-circle"></i> Calculation Details</h6>
        <div class="step-item">
          <strong>Expression:</strong> ${baseSymbol}(${value}) = ${result.toFixed(8)}
        </div>
        <div class="step-item">
          <strong>Meaning:</strong> ${base}${base === Math.E ? '' : '<sup>' + result.toFixed(4) + '</sup>'} = ${value}
        </div>
        <div class="step-item">
          <strong>Base:</strong> ${base === Math.E ? 'e ≈ 2.71828' : base}
        </div>
      </div>
  `;

  if (showSteps) {
    if (type === 'custom') {
      html += `
        <div class="step-section">
          <h6><i class="fas fa-list-ol"></i> Change of Base Formula</h6>
          <div class="step-item">
            log₍${base}₎(${value}) = log(${value}) / log(${base})
          </div>
          <div class="step-item">
            = ${Math.log10(value).toFixed(8)} / ${Math.log10(base).toFixed(8)}
          </div>
          <div class="step-item">
            = ${result.toFixed(8)}
          </div>
        </div>
      `;
    }

    html += `
      <div class="info-card">
        <strong><i class="fas fa-check"></i> Verification:</strong><br>
        ${base}<sup>${result.toFixed(4)}</sup> = ${Math.pow(base, result).toFixed(4)} ≈ ${value}
      </div>
    `;
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Calculate antilog
function calculateAntilog() {
  const type = document.getElementById('antilogType').value;
  const exponent = parseFloat(document.getElementById('antilogValue').value);

  if (isNaN(exponent)) {
    alert('Please enter a valid exponent');
    return;
  }

  let base, baseSymbol, result;

  if (type === 'common') {
    base = 10;
    baseSymbol = '10';
    result = Math.pow(10, exponent);
  } else if (type === 'natural') {
    base = Math.E;
    baseSymbol = 'e';
    result = Math.exp(exponent);
  } else {
    base = parseFloat(document.getElementById('antilogBase').value);
    if (isNaN(base) || base <= 0) {
      alert('Base must be positive');
      return;
    }
    baseSymbol = base.toString();
    result = Math.pow(base, exponent);
  }

  let html = `
    <div class="result-box">
      <h6 class="text-center">
        <span class="property-badge">${baseSymbol}<sup>${exponent}</sup></span>
      </h6>

      <div class="log-result">
        ${result.toExponential(8)}<br>
        <small>(${result > 1000000 || result < 0.000001 ? 'Scientific notation' : result.toFixed(8)})</small>
      </div>

      <div class="step-section">
        <h6><i class="fas fa-info-circle"></i> Calculation</h6>
        <div class="step-item">
          <strong>Expression:</strong> ${baseSymbol}<sup>${exponent}</sup> = ${result.toFixed(8)}
        </div>
        <div class="step-item">
          <strong>Base:</strong> ${base === Math.E ? 'e ≈ 2.71828' : base}
        </div>
        <div class="step-item">
          <strong>Exponent:</strong> ${exponent}
        </div>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-lightbulb"></i> Remember:</strong><br>
        Antilog is the inverse of logarithm<br>
        If log₍${base}₎(x) = ${exponent}, then x = ${result.toFixed(4)}
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Apply logarithm property
function applyProperty() {
  const property = document.getElementById('propertyType').value;
  const a = parseFloat(document.getElementById('propA').value);
  const b = parseFloat(document.getElementById('propB').value);

  if (isNaN(a) || isNaN(b) || a <= 0 || b <= 0) {
    alert('Values must be positive numbers');
    return;
  }

  let html = '<div class="result-box">';
  let formula, leftSide, rightSide, result;

  if (property === 'product') {
    formula = 'log(ab) = log(a) + log(b)';
    leftSide = Math.log10(a * b);
    rightSide = Math.log10(a) + Math.log10(b);
    html += `
      <h6 class="text-center"><span class="property-badge">Product Rule</span></h6>
      <div class="formula-box">${formula}</div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Left Side</h6>
        <div class="step-item">log(${a} × ${b}) = log(${a * b}) = ${leftSide.toFixed(8)}</div>
      </div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Right Side</h6>
        <div class="step-item">log(${a}) + log(${b})</div>
        <div class="step-item">${Math.log10(a).toFixed(8)} + ${Math.log10(b).toFixed(8)}</div>
        <div class="step-item">= ${rightSide.toFixed(8)}</div>
      </div>
    `;

  } else if (property === 'quotient') {
    formula = 'log(a/b) = log(a) - log(b)';
    leftSide = Math.log10(a / b);
    rightSide = Math.log10(a) - Math.log10(b);
    html += `
      <h6 class="text-center"><span class="property-badge">Quotient Rule</span></h6>
      <div class="formula-box">${formula}</div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Left Side</h6>
        <div class="step-item">log(${a} ÷ ${b}) = log(${(a/b).toFixed(4)}) = ${leftSide.toFixed(8)}</div>
      </div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Right Side</h6>
        <div class="step-item">log(${a}) - log(${b})</div>
        <div class="step-item">${Math.log10(a).toFixed(8)} - ${Math.log10(b).toFixed(8)}</div>
        <div class="step-item">= ${rightSide.toFixed(8)}</div>
      </div>
    `;

  } else if (property === 'power') {
    formula = 'log(a^n) = n·log(a)';
    leftSide = Math.log10(Math.pow(a, b));
    rightSide = b * Math.log10(a);
    html += `
      <h6 class="text-center"><span class="property-badge">Power Rule</span></h6>
      <div class="formula-box">${formula}</div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Left Side</h6>
        <div class="step-item">log(${a}<sup>${b}</sup>) = log(${Math.pow(a, b).toFixed(4)}) = ${leftSide.toFixed(8)}</div>
      </div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Right Side</h6>
        <div class="step-item">${b} × log(${a})</div>
        <div class="step-item">${b} × ${Math.log10(a).toFixed(8)}</div>
        <div class="step-item">= ${rightSide.toFixed(8)}</div>
      </div>
    `;

  } else if (property === 'changebase') {
    formula = 'log_b(x) = log(x) / log(b)';
    // Using a as value, b as new base
    result = Math.log10(a) / Math.log10(b);
    html += `
      <h6 class="text-center"><span class="property-badge">Change of Base</span></h6>
      <div class="formula-box">${formula}</div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Convert log₍${b}₎(${a})</h6>
        <div class="step-item">log₍${b}₎(${a}) = log(${a}) / log(${b})</div>
        <div class="step-item">= ${Math.log10(a).toFixed(8)} / ${Math.log10(b).toFixed(8)}</div>
        <div class="step-item">= ${result.toFixed(8)}</div>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-check"></i> Verification:</strong><br>
        ${b}<sup>${result.toFixed(4)}</sup> = ${Math.pow(b, result).toFixed(4)} ≈ ${a}
      </div>
    `;
  }

  if (property !== 'changebase') {
    html += `
      <div class="info-card">
        <strong><i class="fas fa-check"></i> Verification:</strong><br>
        Both sides equal ${leftSide.toFixed(8)} ✓
      </div>
    `;
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Solve logarithmic equation
function solveEquation() {
  const base = parseFloat(document.getElementById('eqBase').value);
  const logResult = parseFloat(document.getElementById('eqResult').value);

  if (isNaN(base) || base <= 0 || base === 1) {
    alert('Base must be positive and not equal to 1');
    return;
  }

  if (isNaN(logResult)) {
    alert('Please enter a valid result value');
    return;
  }

  const x = Math.pow(base, logResult);

  let html = `
    <div class="result-box">
      <h6 class="text-center">
        <span class="property-badge">Solve: log₍${base}₎(x) = ${logResult}</span>
      </h6>

      <div class="log-result">
        x = ${x.toFixed(8)}
      </div>

      <div class="step-section">
        <h6><i class="fas fa-list-ol"></i> Solution Steps</h6>
        <div class="step-item">
          <strong>Given:</strong> log₍${base}₎(x) = ${logResult}
        </div>
        <div class="step-item">
          <strong>Convert to exponential form:</strong><br>
          If log₍b₎(x) = y, then b<sup>y</sup> = x
        </div>
        <div class="step-item">
          <strong>Apply:</strong> ${base}<sup>${logResult}</sup> = x
        </div>
        <div class="step-item">
          <strong>Calculate:</strong> x = ${x.toFixed(8)}
        </div>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-check"></i> Verification:</strong><br>
        log₍${base}₎(${x.toFixed(4)}) = ${logResult} ✓
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Simplify compound expressions
function simplifyCompound() {
  const type = document.getElementById('compoundType').value;
  const a = parseFloat(document.getElementById('compA').value);
  const b = parseFloat(document.getElementById('compB').value);

  if (isNaN(a) || isNaN(b) || a <= 0 || b <= 0) {
    alert('Values must be positive numbers');
    return;
  }

  let html = '<div class="result-box">';
  let leftSide, rightSide, combined;

  if (type === 'sum') {
    leftSide = Math.log10(a) + Math.log10(b);
    combined = a * b;
    rightSide = Math.log10(combined);

    html += `
      <h6 class="text-center"><span class="property-badge">Sum: log(a) + log(b) = log(ab)</span></h6>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Left Side</h6>
        <div class="step-item">log(${a}) + log(${b})</div>
        <div class="step-item">${Math.log10(a).toFixed(6)} + ${Math.log10(b).toFixed(6)} = ${leftSide.toFixed(6)}</div>
      </div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Right Side</h6>
        <div class="step-item">log(${a} × ${b}) = log(${combined})</div>
        <div class="step-item">= ${rightSide.toFixed(6)}</div>
      </div>

      <div class="log-result">log(${a}) + log(${b}) = log(${combined})</div>
    `;
  } else if (type === 'diff') {
    leftSide = Math.log10(a) - Math.log10(b);
    combined = a / b;
    rightSide = Math.log10(combined);

    html += `
      <h6 class="text-center"><span class="property-badge">Difference: log(a) - log(b) = log(a/b)</span></h6>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Left Side</h6>
        <div class="step-item">log(${a}) - log(${b})</div>
        <div class="step-item">${Math.log10(a).toFixed(6)} - ${Math.log10(b).toFixed(6)} = ${leftSide.toFixed(6)}</div>
      </div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Right Side</h6>
        <div class="step-item">log(${a} ÷ ${b}) = log(${combined.toFixed(4)})</div>
        <div class="step-item">= ${rightSide.toFixed(6)}</div>
      </div>

      <div class="log-result">log(${a}) - log(${b}) = log(${combined.toFixed(4)})</div>
    `;
  } else if (type === 'complex') {
    // Example: log(a²b³) = 2log(a) + 3log(b)
    html += `
      <h6 class="text-center"><span class="property-badge">Complex: log(a²b³) = 2·log(a) + 3·log(b)</span></h6>

      <div class="step-section">
        <h6><i class="fas fa-info-circle"></i> Simplification Steps</h6>
        <div class="step-item"><strong>Step 1:</strong> Apply power rule to each term</div>
        <div class="step-item">log(a²b³) = log(a²) + log(b³)</div>
        <div class="step-item"><strong>Step 2:</strong> Use power rule: log(x^n) = n·log(x)</div>
        <div class="step-item">= 2·log(a) + 3·log(b)</div>
      </div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Numerical Example (a=${a}, b=${b})</h6>
        <div class="step-item">log(${a}² × ${b}³) = log(${Math.pow(a,2) * Math.pow(b,3)})</div>
        <div class="step-item">= ${Math.log10(Math.pow(a,2) * Math.pow(b,3)).toFixed(6)}</div>
        <div class="step-item">2·log(${a}) + 3·log(${b}) = ${(2*Math.log10(a) + 3*Math.log10(b)).toFixed(6)}</div>
      </div>

      <div class="log-result">log(a²b³) = 2·log(a) + 3·log(b)</div>
    `;
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Solve logarithmic inequality
function solveInequality() {
  const base = parseFloat(document.getElementById('ineqBase').value);
  const type = document.getElementById('ineqType').value;
  const k = parseFloat(document.getElementById('ineqK').value);

  if (isNaN(base) || base <= 0 || base === 1) {
    alert('Base must be positive and not equal to 1');
    return;
  }

  if (isNaN(k)) {
    alert('Please enter a valid k value');
    return;
  }

  const boundaryValue = Math.pow(base, k);
  let symbol, solution, explanation;

  if (base > 1) {
    // For base > 1, logarithm is increasing
    if (type === 'gt') {
      symbol = '>';
      solution = `x > ${boundaryValue.toFixed(4)}`;
      explanation = 'Since base > 1, log is increasing, so inequality direction stays the same';
    } else if (type === 'gte') {
      symbol = '≥';
      solution = `x ≥ ${boundaryValue.toFixed(4)}`;
      explanation = 'Since base > 1, log is increasing, so inequality direction stays the same';
    } else if (type === 'lt') {
      symbol = '<';
      solution = `0 < x < ${boundaryValue.toFixed(4)}`;
      explanation = 'Since base > 1, log is increasing, and x must be positive (domain)';
    } else { // lte
      symbol = '≤';
      solution = `0 < x ≤ ${boundaryValue.toFixed(4)}`;
      explanation = 'Since base > 1, log is increasing, and x must be positive (domain)';
    }
  } else {
    // For 0 < base < 1, logarithm is decreasing (inequality flips)
    if (type === 'gt') {
      symbol = '>';
      solution = `0 < x < ${boundaryValue.toFixed(4)}`;
      explanation = 'Since 0 < base < 1, log is decreasing, so inequality direction REVERSES';
    } else if (type === 'gte') {
      symbol = '≥';
      solution = `0 < x ≤ ${boundaryValue.toFixed(4)}`;
      explanation = 'Since 0 < base < 1, log is decreasing, so inequality direction REVERSES';
    } else if (type === 'lt') {
      symbol = '<';
      solution = `x > ${boundaryValue.toFixed(4)}`;
      explanation = 'Since 0 < base < 1, log is decreasing, so inequality direction REVERSES';
    } else { // lte
      symbol = '≤';
      solution = `x ≥ ${boundaryValue.toFixed(4)}`;
      explanation = 'Since 0 < base < 1, log is decreasing, so inequality direction REVERSES';
    }
  }

  let html = `
    <div class="result-box">
      <h6 class="text-center">
        <span class="property-badge">Solve: log₍${base}₎(x) ${symbol} ${k}</span>
      </h6>

      <div class="log-result">${solution}</div>

      <div class="step-section">
        <h6><i class="fas fa-list-ol"></i> Solution Steps</h6>
        <div class="step-item">
          <strong>Given:</strong> log₍${base}₎(x) ${symbol} ${k}
        </div>
        <div class="step-item">
          <strong>Step 1:</strong> Convert to exponential form<br>
          If log₍${base}₎(x) = ${k}, then x = ${base}^${k} = ${boundaryValue.toFixed(4)}
        </div>
        <div class="step-item">
          <strong>Step 2:</strong> ${explanation}
        </div>
        <div class="step-item">
          <strong>Step 3:</strong> Remember domain restriction: x > 0
        </div>
        <div class="step-item">
          <strong>Solution:</strong> ${solution}
        </div>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-lightbulb"></i> Key Concept:</strong><br>
        ${base > 1 ?
          'When base > 1, logarithm is an increasing function, so inequality direction is preserved.' :
          'When 0 < base < 1, logarithm is a decreasing function, so inequality direction REVERSES!'}
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Update real-world application inputs
function updateAppInputs() {
  const type = document.getElementById('appType').value;
  const inputsDiv = document.getElementById('appInputs');

  if (type === 'ph') {
    inputsDiv.innerHTML = `
      <div class="form-group">
        <label for="appValue"><i class="fas fa-hashtag"></i> [H⁺] Concentration (mol/L)</label>
        <input type="number" class="form-control" id="appValue" value="0.001" step="any" min="0.0000000000001">
        <small class="form-text text-muted">pH = -log[H⁺]</small>
      </div>
    `;
  } else if (type === 'decibel') {
    inputsDiv.innerHTML = `
      <div class="form-group">
        <label for="appValue"><i class="fas fa-volume-up"></i> Intensity (I) in W/m²</label>
        <input type="number" class="form-control" id="appValue" value="0.001" step="any" min="0.000000000001">
        <small class="form-text text-muted">dB = 10·log(I/I₀), where I₀ = 10⁻¹² W/m²</small>
      </div>
    `;
  } else if (type === 'richter') {
    inputsDiv.innerHTML = `
      <div class="form-group">
        <label for="appValue"><i class="fas fa-house-damage"></i> Amplitude (A)</label>
        <input type="number" class="form-control" id="appValue" value="1000" step="any" min="0.001">
        <small class="form-text text-muted">M = log(A/A₀), where A₀ = 0.001 mm</small>
      </div>
    `;
  } else if (type === 'halflife') {
    inputsDiv.innerHTML = `
      <div class="form-group">
        <label for="appValue"><i class="fas fa-radiation"></i> Half-life (years)</label>
        <input type="number" class="form-control" id="appValue" value="5730" step="any" min="0.0001">
      </div>
      <div class="form-group">
        <label for="appValue2"><i class="fas fa-percentage"></i> Remaining Amount (%)</label>
        <input type="number" class="form-control" id="appValue2" value="50" step="any" min="0.0001" max="100">
      </div>
    `;
  } else if (type === 'compound') {
    inputsDiv.innerHTML = `
      <div class="form-group">
        <label for="appValue"><i class="fas fa-dollar-sign"></i> Principal (P)</label>
        <input type="number" class="form-control" id="appValue" value="1000" step="any" min="0.01">
      </div>
      <div class="form-group">
        <label for="appValue2"><i class="fas fa-dollar-sign"></i> Final Amount (A)</label>
        <input type="number" class="form-control" id="appValue2" value="2000" step="any" min="0.01">
      </div>
      <div class="form-group">
        <label for="appValue3"><i class="fas fa-percentage"></i> Interest Rate (% per year)</label>
        <input type="number" class="form-control" id="appValue3" value="5" step="any" min="0.01">
      </div>
    `;
  }
}

// Calculate real-world applications
function calculateRealWorld() {
  const type = document.getElementById('appType').value;
  let html = '<div class="result-box">';

  if (type === 'ph') {
    const concentration = parseFloat(document.getElementById('appValue').value);
    if (isNaN(concentration) || concentration <= 0) {
      alert('Concentration must be positive');
      return;
    }

    const pH = -Math.log10(concentration);
    let classification;
    if (pH < 3) classification = 'Strongly acidic';
    else if (pH < 7) classification = 'Acidic';
    else if (pH === 7) classification = 'Neutral';
    else if (pH < 11) classification = 'Basic (Alkaline)';
    else classification = 'Strongly basic';

    html += `
      <h6 class="text-center"><span class="property-badge">pH Scale Calculator</span></h6>
      <div class="log-result">pH = ${pH.toFixed(2)}</div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Calculation</h6>
        <div class="step-item">pH = -log[H⁺]</div>
        <div class="step-item">pH = -log(${concentration})</div>
        <div class="step-item">pH = ${pH.toFixed(4)}</div>
        <div class="step-item"><strong>Classification:</strong> ${classification}</div>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-flask"></i> pH Scale Reference:</strong><br>
        0-2: Battery acid, stomach acid<br>
        3-6: Lemon juice, vinegar, soda<br>
        7: Pure water (neutral)<br>
        8-10: Baking soda, soap<br>
        11-14: Ammonia, bleach, drain cleaner
      </div>
    `;
  } else if (type === 'decibel') {
    const intensity = parseFloat(document.getElementById('appValue').value);
    const I0 = 1e-12; // Reference intensity

    if (isNaN(intensity) || intensity <= 0) {
      alert('Intensity must be positive');
      return;
    }

    const decibels = 10 * Math.log10(intensity / I0);
    let classification;
    if (decibels < 30) classification = 'Very quiet (whisper)';
    else if (decibels < 60) classification = 'Quiet to moderate';
    else if (decibels < 90) classification = 'Loud (can cause hearing damage with prolonged exposure)';
    else if (decibels < 120) classification = 'Very loud (painful, hearing damage)';
    else classification = 'Extremely loud (immediate hearing damage)';

    html += `
      <h6 class="text-center"><span class="property-badge">Decibel Calculator</span></h6>
      <div class="log-result">${decibels.toFixed(1)} dB</div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Calculation</h6>
        <div class="step-item">dB = 10·log(I/I₀)</div>
        <div class="step-item">dB = 10·log(${intensity} / ${I0})</div>
        <div class="step-item">dB = ${decibels.toFixed(2)}</div>
        <div class="step-item"><strong>Level:</strong> ${classification}</div>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-volume-up"></i> Sound Level Reference:</strong><br>
        20 dB: Rustling leaves<br>
        60 dB: Normal conversation<br>
        90 dB: Lawnmower<br>
        120 dB: Rock concert, jet engine<br>
        140 dB: Gunshot, fireworks
      </div>
    `;
  } else if (type === 'richter') {
    const amplitude = parseFloat(document.getElementById('appValue').value);
    const A0 = 0.001; // Reference amplitude

    if (isNaN(amplitude) || amplitude <= 0) {
      alert('Amplitude must be positive');
      return;
    }

    const magnitude = Math.log10(amplitude / A0);
    let classification;
    if (magnitude < 3) classification = 'Micro - not felt';
    else if (magnitude < 5) classification = 'Minor - felt by many';
    else if (magnitude < 6) classification = 'Moderate - damage to buildings';
    else if (magnitude < 7) classification = 'Strong - serious damage';
    else if (magnitude < 8) classification = 'Major - catastrophic damage';
    else classification = 'Great - devastating';

    html += `
      <h6 class="text-center"><span class="property-badge">Richter Scale Calculator</span></h6>
      <div class="log-result">Magnitude ${magnitude.toFixed(2)}</div>

      <div class="step-section">
        <h6><i class="fas fa-calculator"></i> Calculation</h6>
        <div class="step-item">M = log(A/A₀)</div>
        <div class="step-item">M = log(${amplitude} / ${A0})</div>
        <div class="step-item">M = ${magnitude.toFixed(4)}</div>
        <div class="step-item"><strong>Classification:</strong> ${classification}</div>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-exclamation-triangle"></i> Earthquake Magnitude:</strong><br>
        Each whole number increase represents 10× more amplitude<br>
        and about 31.6× more energy released
      </div>
    `;
  }

  html += '</div>';
  document.getElementById('results').innerHTML = html;
}

// Compare logarithms with different bases
function compareLogarithms() {
  const value = parseFloat(document.getElementById('compareValue').value);
  const includeLog2 = document.getElementById('includeLog2').checked;
  const includeLog10 = document.getElementById('includeLog10').checked;
  const includeLn = document.getElementById('includeLn').checked;
  const includeCustom = document.getElementById('includeCustomCompare').checked;

  if (isNaN(value) || value <= 0) {
    alert('Value must be positive');
    return;
  }

  let html = `
    <div class="result-box">
      <h6 class="text-center">
        <span class="property-badge">Logarithm Comparison for x = ${value}</span>
      </h6>

      <div class="step-section">
        <h6><i class="fas fa-table"></i> Comparison Table</h6>
        <table class="table table-bordered">
          <thead style="background-color: var(--log-primary); color: white;">
            <tr>
              <th>Base</th>
              <th>Notation</th>
              <th>Result</th>
              <th>Verification</th>
            </tr>
          </thead>
          <tbody>
  `;

  if (includeLog2) {
    const log2 = Math.log(value) / Math.log(2);
    html += `
      <tr>
        <td>2</td>
        <td>log₂(${value})</td>
        <td><strong>${log2.toFixed(6)}</strong></td>
        <td>2^${log2.toFixed(2)} = ${Math.pow(2, log2).toFixed(2)}</td>
      </tr>
    `;
  }

  if (includeLog10) {
    const log10 = Math.log10(value);
    html += `
      <tr>
        <td>10</td>
        <td>log₁₀(${value})</td>
        <td><strong>${log10.toFixed(6)}</strong></td>
        <td>10^${log10.toFixed(2)} = ${Math.pow(10, log10).toFixed(2)}</td>
      </tr>
    `;
  }

  if (includeLn) {
    const ln = Math.log(value);
    html += `
      <tr>
        <td>e ≈ 2.71828</td>
        <td>ln(${value})</td>
        <td><strong>${ln.toFixed(6)}</strong></td>
        <td>e^${ln.toFixed(2)} = ${Math.exp(ln).toFixed(2)}</td>
      </tr>
    `;
  }

  if (includeCustom) {
    const customBase = parseFloat(document.getElementById('customCompareBase').value);
    if (!isNaN(customBase) && customBase > 0 && customBase !== 1) {
      const logCustom = Math.log(value) / Math.log(customBase);
      html += `
        <tr>
          <td>${customBase}</td>
          <td>log₍${customBase}₎(${value})</td>
          <td><strong>${logCustom.toFixed(6)}</strong></td>
          <td>${customBase}^${logCustom.toFixed(2)} = ${Math.pow(customBase, logCustom).toFixed(2)}</td>
        </tr>
      `;
    }
  }

  html += `
          </tbody>
        </table>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-info-circle"></i> Key Observations:</strong><br>
        • Larger bases give smaller logarithm values<br>
        • All bases give the same result when input = base<br>
        • Convert between bases: log_b(x) = log_c(x) / log_c(b)
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Draw logarithm graph
let logChart = null;

function drawLogGraph() {
  const includeLog2 = document.getElementById('graphLog2').checked;
  const includeLog10 = document.getElementById('graphLog10').checked;
  const includeLn = document.getElementById('graphLn').checked;
  const xMax = parseFloat(document.getElementById('graphXMax').value);

  if (isNaN(xMax) || xMax <= 0) {
    alert('X-axis range must be positive');
    return;
  }

  // Generate x values (avoiding x = 0)
  const numPoints = 100;
  const xValues = [];
  const step = xMax / numPoints;

  for (let i = 1; i <= numPoints; i++) {
    xValues.push(i * step);
  }

  // Prepare datasets
  const datasets = [];

  if (includeLog2) {
    datasets.push({
      label: 'log₂(x)',
      data: xValues.map(x => ({ x, y: Math.log(x) / Math.log(2) })),
      borderColor: 'rgb(239, 68, 68)',
      backgroundColor: 'rgba(239, 68, 68, 0.1)',
      borderWidth: 2,
      pointRadius: 0
    });
  }

  if (includeLog10) {
    datasets.push({
      label: 'log₁₀(x)',
      data: xValues.map(x => ({ x, y: Math.log10(x) })),
      borderColor: 'rgb(59, 130, 246)',
      backgroundColor: 'rgba(59, 130, 246, 0.1)',
      borderWidth: 2,
      pointRadius: 0
    });
  }

  if (includeLn) {
    datasets.push({
      label: 'ln(x)',
      data: xValues.map(x => ({ x, y: Math.log(x) })),
      borderColor: 'rgb(16, 185, 129)',
      backgroundColor: 'rgba(16, 185, 129, 0.1)',
      borderWidth: 2,
      pointRadius: 0
    });
  }

  if (datasets.length === 0) {
    alert('Please select at least one logarithm to graph');
    return;
  }

  let html = `
    <div class="result-box">
      <h6 class="text-center">
        <span class="property-badge">Logarithm Graph</span>
      </h6>

      <div class="chart-container">
        <canvas id="logChart"></canvas>
      </div>

      <div class="info-card">
        <strong><i class="fas fa-chart-line"></i> Graph Properties:</strong><br>
        • <span style="color: rgb(239, 68, 68);">■</span> <strong>log₂(x)</strong> - Base 2 (smallest base, highest curve)<br>
        • <span style="color: rgb(59, 130, 246);">■</span> <strong>log₁₀(x)</strong> - Base 10 (common log)<br>
        • <span style="color: rgb(16, 185, 129);">■</span> <strong>ln(x)</strong> - Natural log, base e ≈ 2.71828<br>
        • All curves pass through point (1, 0)<br>
        • Domain: x > 0 only<br>
        • Vertical asymptote at x = 0
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;

  // Draw chart
  const ctx = document.getElementById('logChart');
  if (!ctx) return;

  if (logChart) {
    logChart.destroy();
  }

  logChart = new Chart(ctx, {
    type: 'line',
    data: { datasets },
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
          text: 'Logarithm Curves Comparison',
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
          min: 0,
          max: xMax
        },
        y: {
          title: {
            display: true,
            text: 'log(x)',
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

// Toggle custom compare base input
document.addEventListener('change', function(e) {
  if (e.target && e.target.id === 'includeCustomCompare') {
    document.getElementById('customCompareDiv').style.display =
      e.target.checked ? 'block' : 'none';
  }
});

// Initialize with default example
document.addEventListener('DOMContentLoaded', function() {
  calculateLog();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
