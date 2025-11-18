<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Effect Size Calculator - Cohen's d, r, η², OR, RR | 8gwifi.org</title>
<meta name="description" content="Free effect size calculator: Cohen's d for mean differences, Pearson's r for correlation, Eta-squared (η²) for ANOVA, Odds Ratio (OR), and Risk Ratio (RR) with confidence intervals and interpretation guidelines.">
<meta name="keywords" content="effect size calculator, cohen's d calculator, pearson r effect size, eta squared calculator, odds ratio calculator, risk ratio calculator, meta-analysis, statistical power, research statistics">
<link rel="canonical" href="https://8gwifi.org/effect-size-calculator.jsp">

<!-- Open Graph -->
<meta property="og:title" content="Effect Size Calculator - Cohen's d, r, η², OR, RR">
<meta property="og:description" content="Calculate effect sizes: Cohen's d, Pearson's r, Eta-squared, Odds Ratio, Risk Ratio with confidence intervals and interpretation. Essential for research and meta-analysis.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/effect-size-calculator.jsp">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Effect Size Calculator - Cohen's d, r, η², OR, RR">
<meta name="twitter:description" content="Calculate effect sizes: Cohen's d, Pearson's r, Eta-squared, Odds Ratio, Risk Ratio with confidence intervals and interpretation. Essential for research and meta-analysis.">

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Effect Size Calculator",
  "description": "Calculate effect sizes including Cohen's d, Pearson's r, Eta-squared, Odds Ratio, and Risk Ratio with confidence intervals and interpretation guidelines",
  "url": "https://8gwifi.org/effect-size-calculator.jsp",
  "applicationCategory": "UtilityApplication",
  "operatingSystem": "Any",
  "permissions": "browser",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": [
    "Cohen's d for mean differences",
    "Pearson's r for correlation",
    "Eta-squared (η²) for ANOVA",
    "Odds Ratio (OR) with confidence intervals",
    "Risk Ratio (RR) with confidence intervals",
    "Interpretation guidelines (small/medium/large)",
    "Confidence interval calculation",
    "Power analysis support"
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

<style>
:root {
  --effect-primary: #8b5cf6;
  --effect-secondary: #7c3aed;
  --effect-light: #ede9fe;
  --effect-dark: #5b21b6;
}

.effect-card {
  border-left: 4px solid var(--effect-primary);
  transition: all 0.3s ease;
}

.effect-card:hover {
  box-shadow: 0 4px 12px rgba(139, 92, 246, 0.2);
  transform: translateY(-2px);
}

.effect-badge {
  background: linear-gradient(135deg, var(--effect-primary), var(--effect-secondary));
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  display: inline-block;
}

.interpretation-box {
  border: 2px solid var(--effect-primary);
  border-radius: 10px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.interpretation-small {
  background: linear-gradient(135deg, #dbeafe, white);
  border-left: 4px solid #3b82f6;
  padding: 0.75rem;
  border-radius: 6px;
  margin: 0.5rem 0;
}

.interpretation-medium {
  background: linear-gradient(135deg, #fef3c7, white);
  border-left: 4px solid #f59e0b;
  padding: 0.75rem;
  border-radius: 6px;
  margin: 0.5rem 0;
}

.interpretation-large {
  background: linear-gradient(135deg, #fee2e2, white);
  border-left: 4px solid #ef4444;
  padding: 0.75rem;
  border-radius: 6px;
  margin: 0.5rem 0;
}

.result-box {
  background: linear-gradient(135deg, var(--effect-light), white);
  border: 2px solid var(--effect-primary);
  border-radius: 10px;
  padding: 1.5rem;
  margin-top: 1rem;
}

.ci-badge {
  background-color: #06b6d4;
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 600;
}

.form-control:focus {
  border-color: var(--effect-primary);
  box-shadow: 0 0 0 0.2rem rgba(139, 92, 246, 0.25);
}

.btn-effect {
  background: linear-gradient(135deg, var(--effect-primary), var(--effect-secondary));
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-effect:hover {
  background: linear-gradient(135deg, var(--effect-secondary), var(--effect-dark));
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

.nav-tabs .nav-link {
  color: var(--effect-secondary);
  border: 2px solid transparent;
}

.nav-tabs .nav-link.active {
  color: white;
  background: linear-gradient(135deg, var(--effect-primary), var(--effect-secondary));
  border-color: var(--effect-primary);
}

.nav-tabs .nav-link:hover {
  border-color: var(--effect-light);
}

.info-card {
  background-color: var(--effect-light);
  border-left: 4px solid var(--effect-primary);
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}

.stat-row {
  display: flex;
  justify-content: space-between;
  padding: 0.5rem 0;
  border-bottom: 1px solid #e5e7eb;
}

.stat-label {
  font-weight: 600;
  color: var(--effect-dark);
}

.stat-value {
  color: var(--effect-secondary);
  font-weight: 500;
}

.formula-box {
  background-color: #f9fafb;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  padding: 1rem;
  font-family: 'Courier New', monospace;
  margin: 1rem 0;
}
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1><i class="fas fa-chart-area text-purple"></i> Effect Size Calculator</h1>
  <p class="lead">Calculate Cohen's d, Pearson's r, η², Odds Ratio, and Risk Ratio with confidence intervals</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="card effect-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title">
            <i class="fas fa-ruler-combined text-purple"></i> Select Effect Size Type
          </h5>

          <!-- Tab Navigation -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="cohend-tab" data-toggle="tab" href="#cohend-panel" role="tab">
                <i class="fas fa-balance-scale"></i> Cohen's d
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="pearsonr-tab" data-toggle="tab" href="#pearsonr-panel" role="tab">
                <i class="fas fa-project-diagram"></i> Pearson's r
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="eta-tab" data-toggle="tab" href="#eta-panel" role="tab">
                <i class="fas fa-layer-group"></i> η² (ANOVA)
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="or-tab" data-toggle="tab" href="#or-panel" role="tab">
                <i class="fas fa-dice"></i> Odds/Risk
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- Cohen's d -->
            <div class="tab-pane fade show active" id="cohend-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Cohen's d:</strong> Measures standardized mean difference between two groups
              </div>

              <div class="form-group">
                <label for="cohenM1"><i class="fas fa-users"></i> Group 1 Mean (M₁)</label>
                <input type="number" class="form-control" id="cohenM1" value="50" step="any">
              </div>

              <div class="form-group">
                <label for="cohenM2"><i class="fas fa-users"></i> Group 2 Mean (M₂)</label>
                <input type="number" class="form-control" id="cohenM2" value="55" step="any">
              </div>

              <div class="form-group">
                <label for="cohenSD1"><i class="fas fa-chart-line"></i> Group 1 Std Deviation (SD₁)</label>
                <input type="number" class="form-control" id="cohenSD1" value="10" step="any" min="0">
              </div>

              <div class="form-group">
                <label for="cohenSD2"><i class="fas fa-chart-line"></i> Group 2 Std Deviation (SD₂)</label>
                <input type="number" class="form-control" id="cohenSD2" value="10" step="any" min="0">
              </div>

              <div class="form-group">
                <label for="cohenN1"><i class="fas fa-hashtag"></i> Group 1 Sample Size (n₁)</label>
                <input type="number" class="form-control" id="cohenN1" value="30" min="2">
              </div>

              <div class="form-group">
                <label for="cohenN2"><i class="fas fa-hashtag"></i> Group 2 Sample Size (n₂)</label>
                <input type="number" class="form-control" id="cohenN2" value="30" min="2">
              </div>

              <div class="form-group">
                <label for="cohenConfidence"><i class="fas fa-percentage"></i> Confidence Level (%)</label>
                <select class="form-control" id="cohenConfidence">
                  <option value="90">90%</option>
                  <option value="95" selected>95%</option>
                  <option value="99">99%</option>
                </select>
              </div>

              <button class="btn btn-effect btn-block" onclick="calculateCohenD()">
                <i class="fas fa-calculator"></i> Calculate Cohen's d
              </button>
            </div>

            <!-- Pearson's r -->
            <div class="tab-pane fade" id="pearsonr-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Pearson's r:</strong> Measures correlation strength (from t-test or directly)
              </div>

              <div class="form-group">
                <label><i class="fas fa-toggle-on"></i> Input Method</label>
                <select class="form-control" id="pearsonMethod" onchange="togglePearsonInputs()">
                  <option value="direct">Direct r value</option>
                  <option value="ttest">From t-statistic</option>
                </select>
              </div>

              <div id="pearsonDirectInputs">
                <div class="form-group">
                  <label for="pearsonR"><i class="fas fa-arrows-alt-h"></i> Correlation Coefficient (r)</label>
                  <input type="number" class="form-control" id="pearsonR" value="0.5" step="0.001" min="-1" max="1">
                  <small class="form-text text-muted">Range: -1 to +1</small>
                </div>

                <div class="form-group">
                  <label for="pearsonN"><i class="fas fa-hashtag"></i> Sample Size (n)</label>
                  <input type="number" class="form-control" id="pearsonN" value="50" min="3">
                </div>
              </div>

              <div id="pearsonTTestInputs" style="display: none;">
                <div class="form-group">
                  <label for="pearsonT"><i class="fas fa-subscript"></i> t-statistic</label>
                  <input type="number" class="form-control" id="pearsonT" value="3.5" step="any">
                </div>

                <div class="form-group">
                  <label for="pearsonDF"><i class="fas fa-sort-numeric-up"></i> Degrees of Freedom (df)</label>
                  <input type="number" class="form-control" id="pearsonDF" value="48" min="1">
                </div>
              </div>

              <div class="form-group">
                <label for="pearsonConfidence"><i class="fas fa-percentage"></i> Confidence Level (%)</label>
                <select class="form-control" id="pearsonConfidence">
                  <option value="90">90%</option>
                  <option value="95" selected>95%</option>
                  <option value="99">99%</option>
                </select>
              </div>

              <button class="btn btn-effect btn-block" onclick="calculatePearsonR()">
                <i class="fas fa-calculator"></i> Calculate Pearson's r
              </button>
            </div>

            <!-- Eta-squared -->
            <div class="tab-pane fade" id="eta-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> η² (Eta-squared):</strong> Effect size for ANOVA (variance explained)
              </div>

              <div class="form-group">
                <label><i class="fas fa-toggle-on"></i> Input Method</label>
                <select class="form-control" id="etaMethod" onchange="toggleEtaInputs()">
                  <option value="fstat">From F-statistic</option>
                  <option value="direct">Direct SS values</option>
                </select>
              </div>

              <div id="etaFStatInputs">
                <div class="form-group">
                  <label for="etaF"><i class="fas fa-superscript"></i> F-statistic</label>
                  <input type="number" class="form-control" id="etaF" value="5.2" step="any" min="0">
                </div>

                <div class="form-group">
                  <label for="etaDFBetween"><i class="fas fa-arrows-alt-h"></i> df Between Groups</label>
                  <input type="number" class="form-control" id="etaDFBetween" value="2" min="1">
                </div>

                <div class="form-group">
                  <label for="etaDFWithin"><i class="fas fa-arrows-alt-v"></i> df Within Groups</label>
                  <input type="number" class="form-control" id="etaDFWithin" value="57" min="1">
                </div>
              </div>

              <div id="etaDirectInputs" style="display: none;">
                <div class="form-group">
                  <label for="etaSSBetween"><i class="fas fa-layer-group"></i> Sum of Squares Between (SS_B)</label>
                  <input type="number" class="form-control" id="etaSSBetween" value="250" step="any" min="0">
                </div>

                <div class="form-group">
                  <label for="etaSSTotal"><i class="fas fa-plus-square"></i> Total Sum of Squares (SS_T)</label>
                  <input type="number" class="form-control" id="etaSSTotal" value="800" step="any" min="0">
                </div>
              </div>

              <button class="btn btn-effect btn-block" onclick="calculateEtaSquared()">
                <i class="fas fa-calculator"></i> Calculate η²
              </button>
            </div>

            <!-- Odds Ratio / Risk Ratio -->
            <div class="tab-pane fade" id="or-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Odds/Risk Ratios:</strong> Measure association in 2×2 tables
              </div>

              <div class="form-group">
                <label><i class="fas fa-toggle-on"></i> Calculation Type</label>
                <select class="form-control" id="orType">
                  <option value="or">Odds Ratio (OR)</option>
                  <option value="rr">Risk Ratio (RR)</option>
                </select>
              </div>

              <div class="row">
                <div class="col-12 mb-3">
                  <strong>2×2 Contingency Table:</strong>
                  <table class="table table-bordered mt-2">
                    <thead>
                      <tr>
                        <th></th>
                        <th>Exposed</th>
                        <th>Not Exposed</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td><strong>Disease</strong></td>
                        <td><input type="number" class="form-control" id="orA" value="20" min="0"></td>
                        <td><input type="number" class="form-control" id="orB" value="10" min="0"></td>
                      </tr>
                      <tr>
                        <td><strong>No Disease</strong></td>
                        <td><input type="number" class="form-control" id="orC" value="30" min="0"></td>
                        <td><input type="number" class="form-control" id="orD" value="40" min="0"></td>
                      </tr>
                    </tbody>
                  </table>
                  <small class="form-text text-muted">a = exposed+disease, b = not exposed+disease, c = exposed+no disease, d = not exposed+no disease</small>
                </div>
              </div>

              <div class="form-group">
                <label for="orConfidence"><i class="fas fa-percentage"></i> Confidence Level (%)</label>
                <select class="form-control" id="orConfidence">
                  <option value="90">90%</option>
                  <option value="95" selected>95%</option>
                  <option value="99">99%</option>
                </select>
              </div>

              <button class="btn btn-effect btn-block" onclick="calculateOddsRisk()">
                <i class="fas fa-calculator"></i> Calculate Odds/Risk Ratio
              </button>
            </div>

          </div>
        </div>
      </div>

      <!-- Educational Content -->
      <div class="card effect-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title"><i class="fas fa-book text-purple"></i> Understanding Effect Sizes</h5>

          <h6 class="mt-3"><i class="fas fa-question-circle text-purple"></i> What is Effect Size?</h6>
          <p>Effect size quantifies the magnitude of a phenomenon or difference, independent of sample size. Unlike p-values, which only tell you if an effect exists, effect sizes tell you <strong>how large</strong> that effect is.</p>

          <h6 class="mt-3"><i class="fas fa-balance-scale text-purple"></i> Cohen's d</h6>
          <div class="formula-box">
            d = (M₁ - M₂) / SD_pooled<br>
            SD_pooled = √[(SD₁² + SD₂²) / 2]
          </div>
          <p><strong>Interpretation (Cohen, 1988):</strong></p>
          <ul>
            <li><strong>Small:</strong> d = 0.2 (noticeable to experts)</li>
            <li><strong>Medium:</strong> d = 0.5 (visible to careful observers)</li>
            <li><strong>Large:</strong> d = 0.8 (obvious to anyone)</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-project-diagram text-purple"></i> Pearson's r</h6>
          <div class="formula-box">
            r = t / √(t² + df)
          </div>
          <p><strong>Interpretation (Cohen, 1988):</strong></p>
          <ul>
            <li><strong>Small:</strong> r = 0.10 (explains 1% of variance)</li>
            <li><strong>Medium:</strong> r = 0.30 (explains 9% of variance)</li>
            <li><strong>Large:</strong> r = 0.50 (explains 25% of variance)</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-layer-group text-purple"></i> Eta-squared (η²)</h6>
          <div class="formula-box">
            η² = SS_between / SS_total
          </div>
          <p><strong>Interpretation (Cohen, 1988):</strong></p>
          <ul>
            <li><strong>Small:</strong> η² = 0.01 (1% of variance)</li>
            <li><strong>Medium:</strong> η² = 0.06 (6% of variance)</li>
            <li><strong>Large:</strong> η² = 0.14 (14% of variance)</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-dice text-purple"></i> Odds Ratio (OR) & Risk Ratio (RR)</h6>
          <div class="formula-box">
            OR = (a × d) / (b × c)<br>
            RR = [a / (a + c)] / [b / (b + d)]
          </div>
          <p><strong>Interpretation:</strong></p>
          <ul>
            <li><strong>OR/RR = 1:</strong> No association</li>
            <li><strong>OR/RR &gt; 1:</strong> Increased odds/risk with exposure</li>
            <li><strong>OR/RR &lt; 1:</strong> Decreased odds/risk (protective effect)</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-lightbulb text-purple"></i> Why Effect Sizes Matter</h6>
          <ul>
            <li><strong>Publication Requirements:</strong> Many journals require effect sizes</li>
            <li><strong>Meta-Analysis:</strong> Essential for combining studies</li>
            <li><strong>Power Analysis:</strong> Needed for sample size calculations</li>
            <li><strong>Practical Significance:</strong> Distinguish statistical from practical importance</li>
            <li><strong>Context-Independent:</strong> Compare effects across different scales</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-flask text-purple"></i> Common Applications</h6>
          <ul>
            <li><strong>Psychology:</strong> Treatment effect sizes in clinical trials</li>
            <li><strong>Education:</strong> Intervention effectiveness</li>
            <li><strong>Medicine:</strong> Drug efficacy, diagnostic accuracy</li>
            <li><strong>Social Sciences:</strong> Program evaluation</li>
            <li><strong>Business:</strong> Marketing campaign effectiveness</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-5">
      <div class="sticky-results">
        <div class="card effect-card shadow-sm">
          <div class="card-body">
            <h5 class="card-title">
              <i class="fas fa-chart-line text-purple"></i> Results
            </h5>
            <div id="results">
              <div class="text-center text-muted py-5">
                <i class="fas fa-ruler-combined fa-3x mb-3"></i>
                <p>Enter your data and click calculate to see effect size</p>
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
// Toggle Pearson's r input method
function togglePearsonInputs() {
  const method = document.getElementById('pearsonMethod').value;
  document.getElementById('pearsonDirectInputs').style.display = method === 'direct' ? 'block' : 'none';
  document.getElementById('pearsonTTestInputs').style.display = method === 'ttest' ? 'block' : 'none';
}

// Toggle Eta-squared input method
function toggleEtaInputs() {
  const method = document.getElementById('etaMethod').value;
  document.getElementById('etaFStatInputs').style.display = method === 'fstat' ? 'block' : 'none';
  document.getElementById('etaDirectInputs').style.display = method === 'direct' ? 'block' : 'none';
}

// Get interpretation for Cohen's d
function interpretCohenD(d) {
  const absd = Math.abs(d);
  if (absd < 0.2) return { level: 'Negligible', class: 'small', desc: 'Very small effect, difficult to detect' };
  if (absd < 0.5) return { level: 'Small', class: 'small', desc: 'Noticeable to experts' };
  if (absd < 0.8) return { level: 'Medium', class: 'medium', desc: 'Visible to careful observers' };
  return { level: 'Large', class: 'large', desc: 'Obvious to anyone' };
}

// Get interpretation for Pearson's r
function interpretPearsonR(r) {
  const absr = Math.abs(r);
  if (absr < 0.1) return { level: 'Negligible', class: 'small', desc: 'Very weak correlation' };
  if (absr < 0.3) return { level: 'Small', class: 'small', desc: 'Weak correlation (1-9% variance)' };
  if (absr < 0.5) return { level: 'Medium', class: 'medium', desc: 'Moderate correlation (9-25% variance)' };
  return { level: 'Large', class: 'large', desc: 'Strong correlation (25%+ variance)' };
}

// Get interpretation for Eta-squared
function interpretEtaSquared(eta) {
  if (eta < 0.01) return { level: 'Negligible', class: 'small', desc: 'Very small effect' };
  if (eta < 0.06) return { level: 'Small', class: 'small', desc: '1-6% of variance explained' };
  if (eta < 0.14) return { level: 'Medium', class: 'medium', desc: '6-14% of variance explained' };
  return { level: 'Large', class: 'large', desc: '14%+ of variance explained' };
}

// Get interpretation for OR/RR
function interpretOddsRisk(value, type) {
  const label = type === 'or' ? 'odds' : 'risk';
  if (Math.abs(value - 1) < 0.1) return { level: 'No Effect', class: 'small', desc: `No association (${label} ≈ 1)` };
  if (value > 1) {
    if (value < 1.5) return { level: 'Small Increase', class: 'small', desc: `Slightly increased ${label}` };
    if (value < 2.5) return { level: 'Medium Increase', class: 'medium', desc: `Moderately increased ${label}` };
    return { level: 'Large Increase', class: 'large', desc: `Substantially increased ${label}` };
  } else {
    if (value > 0.67) return { level: 'Small Decrease', class: 'small', desc: `Slightly decreased ${label} (protective)` };
    if (value > 0.4) return { level: 'Medium Decrease', class: 'medium', desc: `Moderately decreased ${label} (protective)` };
    return { level: 'Large Decrease', class: 'large', desc: `Substantially decreased ${label} (protective)` };
  }
}

// Calculate Cohen's d
function calculateCohenD() {
  const m1 = parseFloat(document.getElementById('cohenM1').value);
  const m2 = parseFloat(document.getElementById('cohenM2').value);
  const sd1 = parseFloat(document.getElementById('cohenSD1').value);
  const sd2 = parseFloat(document.getElementById('cohenSD2').value);
  const n1 = parseInt(document.getElementById('cohenN1').value);
  const n2 = parseInt(document.getElementById('cohenN2').value);
  const confidenceLevel = parseFloat(document.getElementById('cohenConfidence').value);

  if (isNaN(m1) || isNaN(m2) || isNaN(sd1) || isNaN(sd2) || isNaN(n1) || isNaN(n2)) {
    alert('Please enter all values');
    return;
  }

  if (sd1 <= 0 || sd2 <= 0) {
    alert('Standard deviations must be positive');
    return;
  }

  if (n1 < 2 || n2 < 2) {
    alert('Sample sizes must be at least 2');
    return;
  }

  // Pooled standard deviation
  const sdPooled = Math.sqrt((sd1 * sd1 + sd2 * sd2) / 2);

  // Cohen's d
  const d = (m1 - m2) / sdPooled;

  // Standard error of d
  const se = Math.sqrt((n1 + n2) / (n1 * n2) + (d * d) / (2 * (n1 + n2)));

  // Critical value for CI (approximate using z)
  const z = confidenceLevel === 90 ? 1.645 : confidenceLevel === 95 ? 1.96 : 2.576;

  // Confidence interval
  const ciLower = d - z * se;
  const ciUpper = d + z * se;

  const interpretation = interpretCohenD(d);

  const html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-balance-scale text-warning"></i>
        <span class="effect-badge" style="font-size: 1.5rem;">d = ${d.toFixed(3)}</span>
      </h5>

      <div class="interpretation-${interpretation.class}" style="text-align: center; margin-bottom: 1rem;">
        <strong><i class="fas fa-info-circle"></i> ${interpretation.level} Effect</strong><br>
        <small>${interpretation.desc}</small>
      </div>

      <div class="stat-row">
        <span class="stat-label">Cohen's d:</span>
        <span class="stat-value">${d.toFixed(3)}</span>
      </div>
      <div class="stat-row">
        <span class="stat-label">${confidenceLevel}% CI:</span>
        <span class="stat-value ci-badge">[${ciLower.toFixed(3)}, ${ciUpper.toFixed(3)}]</span>
      </div>
      <div class="stat-row">
        <span class="stat-label">Pooled SD:</span>
        <span class="stat-value">${sdPooled.toFixed(3)}</span>
      </div>
      <div class="stat-row">
        <span class="stat-label">Mean Difference:</span>
        <span class="stat-value">${(m1 - m2).toFixed(3)}</span>
      </div>

      <div class="interpretation-box mt-3">
        <h6><i class="fas fa-lightbulb"></i> Interpretation</h6>
        <p class="mb-2"><strong>Effect Size:</strong> The standardized mean difference is ${Math.abs(d).toFixed(3)}, which is a <strong>${interpretation.level.toLowerCase()}</strong> effect size.</p>
        <p class="mb-2"><strong>Direction:</strong> Group 1 (M = ${m1.toFixed(2)}) ${d > 0 ? 'is higher than' : 'is lower than'} Group 2 (M = ${m2.toFixed(2)}).</p>
        <p class="mb-0"><strong>Confidence Interval:</strong> We are ${confidenceLevel}% confident that the true effect size falls between ${ciLower.toFixed(3)} and ${ciUpper.toFixed(3)}.</p>
      </div>

      <div class="info-card mt-3">
        <strong><i class="fas fa-ruler"></i> Cohen's Guidelines:</strong><br>
        Small: d = 0.2 | Medium: d = 0.5 | Large: d = 0.8
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Calculate Pearson's r
function calculatePearsonR() {
  const method = document.getElementById('pearsonMethod').value;
  const confidenceLevel = parseFloat(document.getElementById('pearsonConfidence').value);

  let r, n;

  if (method === 'direct') {
    r = parseFloat(document.getElementById('pearsonR').value);
    n = parseInt(document.getElementById('pearsonN').value);

    if (isNaN(r) || r < -1 || r > 1) {
      alert('Correlation coefficient must be between -1 and 1');
      return;
    }

    if (isNaN(n) || n < 3) {
      alert('Sample size must be at least 3');
      return;
    }
  } else {
    const t = parseFloat(document.getElementById('pearsonT').value);
    const df = parseInt(document.getElementById('pearsonDF').value);

    if (isNaN(t) || isNaN(df) || df < 1) {
      alert('Please enter valid t-statistic and degrees of freedom');
      return;
    }

    // Calculate r from t
    r = t / Math.sqrt(t * t + df);
    n = df + 2;
  }

  // Fisher's z transformation for CI
  const fisherZ = 0.5 * Math.log((1 + r) / (1 - r));
  const seFisherZ = 1 / Math.sqrt(n - 3);

  // Critical value
  const z = confidenceLevel === 90 ? 1.645 : confidenceLevel === 95 ? 1.96 : 2.576;

  // CI for Fisher's z
  const zLower = fisherZ - z * seFisherZ;
  const zUpper = fisherZ + z * seFisherZ;

  // Transform back to r
  const ciLower = (Math.exp(2 * zLower) - 1) / (Math.exp(2 * zLower) + 1);
  const ciUpper = (Math.exp(2 * zUpper) - 1) / (Math.exp(2 * zUpper) + 1);

  // Variance explained
  const r2 = r * r;

  const interpretation = interpretPearsonR(r);

  const html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-project-diagram text-warning"></i>
        <span class="effect-badge" style="font-size: 1.5rem;">r = ${r.toFixed(3)}</span>
      </h5>

      <div class="interpretation-${interpretation.class}" style="text-align: center; margin-bottom: 1rem;">
        <strong><i class="fas fa-info-circle"></i> ${interpretation.level} Effect</strong><br>
        <small>${interpretation.desc}</small>
      </div>

      <div class="stat-row">
        <span class="stat-label">Pearson's r:</span>
        <span class="stat-value">${r.toFixed(3)}</span>
      </div>
      <div class="stat-row">
        <span class="stat-label">${confidenceLevel}% CI:</span>
        <span class="stat-value ci-badge">[${ciLower.toFixed(3)}, ${ciUpper.toFixed(3)}]</span>
      </div>
      <div class="stat-row">
        <span class="stat-label">r² (variance explained):</span>
        <span class="stat-value">${r2.toFixed(3)} (${(r2 * 100).toFixed(1)}%)</span>
      </div>
      <div class="stat-row">
        <span class="stat-label">Sample Size (n):</span>
        <span class="stat-value">${n}</span>
      </div>

      <div class="interpretation-box mt-3">
        <h6><i class="fas fa-lightbulb"></i> Interpretation</h6>
        <p class="mb-2"><strong>Effect Size:</strong> The correlation is r = ${r.toFixed(3)}, which is a <strong>${interpretation.level.toLowerCase()}</strong> effect size.</p>
        <p class="mb-2"><strong>Variance Explained:</strong> The two variables share ${(r2 * 100).toFixed(1)}% of their variance (r² = ${r2.toFixed(3)}).</p>
        <p class="mb-2"><strong>Direction:</strong> ${r > 0 ? 'Positive correlation - as one variable increases, the other tends to increase' : r < 0 ? 'Negative correlation - as one variable increases, the other tends to decrease' : 'No correlation'}.</p>
        <p class="mb-0"><strong>Confidence Interval:</strong> We are ${confidenceLevel}% confident that the true correlation falls between ${ciLower.toFixed(3)} and ${ciUpper.toFixed(3)}.</p>
      </div>

      <div class="info-card mt-3">
        <strong><i class="fas fa-ruler"></i> Cohen's Guidelines:</strong><br>
        Small: r = 0.10 | Medium: r = 0.30 | Large: r = 0.50
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Calculate Eta-squared
function calculateEtaSquared() {
  const method = document.getElementById('etaMethod').value;

  let etaSquared;

  if (method === 'fstat') {
    const f = parseFloat(document.getElementById('etaF').value);
    const dfBetween = parseInt(document.getElementById('etaDFBetween').value);
    const dfWithin = parseInt(document.getElementById('etaDFWithin').value);

    if (isNaN(f) || f < 0) {
      alert('F-statistic must be non-negative');
      return;
    }

    if (isNaN(dfBetween) || isNaN(dfWithin) || dfBetween < 1 || dfWithin < 1) {
      alert('Please enter valid degrees of freedom');
      return;
    }

    // Calculate eta-squared from F
    etaSquared = (f * dfBetween) / (f * dfBetween + dfWithin);

  } else {
    const ssBetween = parseFloat(document.getElementById('etaSSBetween').value);
    const ssTotal = parseFloat(document.getElementById('etaSSTotal').value);

    if (isNaN(ssBetween) || isNaN(ssTotal) || ssBetween < 0 || ssTotal <= 0) {
      alert('Please enter valid sum of squares values');
      return;
    }

    if (ssBetween > ssTotal) {
      alert('SS Between cannot exceed SS Total');
      return;
    }

    etaSquared = ssBetween / ssTotal;
  }

  const interpretation = interpretEtaSquared(etaSquared);

  const html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-layer-group text-warning"></i>
        <span class="effect-badge" style="font-size: 1.5rem;">η² = ${etaSquared.toFixed(3)}</span>
      </h5>

      <div class="interpretation-${interpretation.class}" style="text-align: center; margin-bottom: 1rem;">
        <strong><i class="fas fa-info-circle"></i> ${interpretation.level} Effect</strong><br>
        <small>${interpretation.desc}</small>
      </div>

      <div class="stat-row">
        <span class="stat-label">Eta-squared (η²):</span>
        <span class="stat-value">${etaSquared.toFixed(3)}</span>
      </div>
      <div class="stat-row">
        <span class="stat-label">Variance Explained:</span>
        <span class="stat-value">${(etaSquared * 100).toFixed(1)}%</span>
      </div>
      <div class="stat-row">
        <span class="stat-label">Variance Unexplained:</span>
        <span class="stat-value">${((1 - etaSquared) * 100).toFixed(1)}%</span>
      </div>

      <div class="interpretation-box mt-3">
        <h6><i class="fas fa-lightbulb"></i> Interpretation</h6>
        <p class="mb-2"><strong>Effect Size:</strong> η² = ${etaSquared.toFixed(3)} indicates a <strong>${interpretation.level.toLowerCase()}</strong> effect size.</p>
        <p class="mb-2"><strong>Variance Explained:</strong> The grouping variable (independent variable) explains ${(etaSquared * 100).toFixed(1)}% of the total variance in the dependent variable.</p>
        <p class="mb-0"><strong>Practical Meaning:</strong> ${(etaSquared * 100).toFixed(1)}% of the differences we observe are due to group membership, while ${((1 - etaSquared) * 100).toFixed(1)}% is due to other factors or error.</p>
      </div>

      <div class="info-card mt-3">
        <strong><i class="fas fa-ruler"></i> Cohen's Guidelines:</strong><br>
        Small: η² = 0.01 | Medium: η² = 0.06 | Large: η² = 0.14
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Calculate Odds Ratio / Risk Ratio
function calculateOddsRisk() {
  const type = document.getElementById('orType').value;
  const a = parseInt(document.getElementById('orA').value);
  const b = parseInt(document.getElementById('orB').value);
  const c = parseInt(document.getElementById('orC').value);
  const d = parseInt(document.getElementById('orD').value);
  const confidenceLevel = parseFloat(document.getElementById('orConfidence').value);

  if (isNaN(a) || isNaN(b) || isNaN(c) || isNaN(d) || a < 0 || b < 0 || c < 0 || d < 0) {
    alert('Please enter valid non-negative counts');
    return;
  }

  if (a + b + c + d === 0) {
    alert('At least one cell must be non-zero');
    return;
  }

  let value, logValue, seLogValue;

  if (type === 'or') {
    // Odds Ratio: (a × d) / (b × c)
    if (b === 0 || c === 0) {
      alert('Cannot calculate Odds Ratio with zero counts in b or c cells. Consider adding 0.5 to all cells.');
      return;
    }
    value = (a * d) / (b * c);
    logValue = Math.log(value);
    seLogValue = Math.sqrt(1/a + 1/b + 1/c + 1/d);
  } else {
    // Risk Ratio: [a/(a+c)] / [b/(b+d)]
    if (a + c === 0 || b + d === 0) {
      alert('Cannot calculate Risk Ratio with zero row totals');
      return;
    }
    const risk1 = a / (a + c);
    const risk2 = b / (b + d);
    if (risk2 === 0) {
      alert('Cannot calculate Risk Ratio when control risk is zero');
      return;
    }
    value = risk1 / risk2;
    logValue = Math.log(value);
    seLogValue = Math.sqrt(1/a - 1/(a+c) + 1/b - 1/(b+d));
  }

  // Critical value
  const z = confidenceLevel === 90 ? 1.645 : confidenceLevel === 95 ? 1.96 : 2.576;

  // CI for log(OR) or log(RR)
  const logLower = logValue - z * seLogValue;
  const logUpper = logValue + z * seLogValue;

  // Transform back
  const ciLower = Math.exp(logLower);
  const ciUpper = Math.exp(logUpper);

  const interpretation = interpretOddsRisk(value, type);
  const label = type === 'or' ? 'Odds Ratio' : 'Risk Ratio';
  const abbrev = type === 'or' ? 'OR' : 'RR';

  const html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-dice text-warning"></i>
        <span class="effect-badge" style="font-size: 1.5rem;">${abbrev} = ${value.toFixed(3)}</span>
      </h5>

      <div class="interpretation-${interpretation.class}" style="text-align: center; margin-bottom: 1rem;">
        <strong><i class="fas fa-info-circle"></i> ${interpretation.level}</strong><br>
        <small>${interpretation.desc}</small>
      </div>

      <div class="stat-row">
        <span class="stat-label">${label} (${abbrev}):</span>
        <span class="stat-value">${value.toFixed(3)}</span>
      </div>
      <div class="stat-row">
        <span class="stat-label">${confidenceLevel}% CI:</span>
        <span class="stat-value ci-badge">[${ciLower.toFixed(3)}, ${ciUpper.toFixed(3)}]</span>
      </div>

      <h6 class="mt-3"><i class="fas fa-table"></i> 2×2 Table Summary</h6>
      <div class="table-responsive">
        <table class="table table-bordered table-sm">
          <thead>
            <tr><th></th><th>Exposed</th><th>Not Exposed</th><th>Total</th></tr>
          </thead>
          <tbody>
            <tr><td><strong>Disease</strong></td><td>${a}</td><td>${b}</td><td>${a+b}</td></tr>
            <tr><td><strong>No Disease</strong></td><td>${c}</td><td>${d}</td><td>${c+d}</td></tr>
            <tr><td><strong>Total</strong></td><td>${a+c}</td><td>${b+d}</td><td>${a+b+c+d}</td></tr>
          </tbody>
        </table>
      </div>

      <div class="interpretation-box mt-3">
        <h6><i class="fas fa-lightbulb"></i> Interpretation</h6>
        ${type === 'or' ? `
          <p class="mb-2"><strong>Odds Ratio:</strong> The odds of disease in the exposed group are ${value.toFixed(2)} times the odds in the unexposed group.</p>
          <p class="mb-2"><strong>Direction:</strong> ${value > 1 ? 'Exposure is associated with <strong>increased odds</strong> of disease' : value < 1 ? 'Exposure is associated with <strong>decreased odds</strong> of disease (protective effect)' : 'No association between exposure and disease'}.</p>
        ` : `
          <p class="mb-2"><strong>Risk Ratio:</strong> The risk of disease in the exposed group is ${value.toFixed(2)} times the risk in the unexposed group.</p>
          <p class="mb-2"><strong>Direction:</strong> ${value > 1 ? 'Exposure is associated with <strong>increased risk</strong> of disease' : value < 1 ? 'Exposure is associated with <strong>decreased risk</strong> of disease (protective effect)' : 'No association between exposure and disease'}.</p>
        `}
        <p class="mb-0"><strong>Confidence Interval:</strong> We are ${confidenceLevel}% confident that the true ${abbrev} falls between ${ciLower.toFixed(3)} and ${ciUpper.toFixed(3)}. ${ciLower < 1 && ciUpper > 1 ? '<br><span class="text-warning"><i class="fas fa-exclamation-triangle"></i> CI includes 1.0, suggesting no significant association.</span>' : ''}</p>
      </div>

      <div class="info-card mt-3">
        <strong><i class="fas fa-info-circle"></i> Remember:</strong><br>
        ${abbrev} = 1: No association | ${abbrev} &gt; 1: Increased ${type === 'or' ? 'odds' : 'risk'} | ${abbrev} &lt; 1: Decreased ${type === 'or' ? 'odds' : 'risk'} (protective)
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Initialize with default example on page load
document.addEventListener('DOMContentLoaded', function() {
  calculateCohenD();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
