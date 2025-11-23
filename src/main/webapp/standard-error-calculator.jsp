<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Standard Error Calculator Online – Free | 8gwifi.org</title>
<meta name="description" content="Free standard error calculator: SE for mean, proportion, difference of means/proportions — with margin of error and confidence intervals.">
<meta name="keywords" content="standard error calculator, SE calculator, standard error of mean, standard error of proportion, margin of error, confidence interval, sampling error">
<link rel="canonical" href="https://8gwifi.org/standard-error-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Standard Error Calculator Online – Free | 8gwifi.org">
<meta property="og:description" content="SE for means, proportions, and differences — with margin of error and CIs.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/standard-error-calculator.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Standard Error Calculator Online – Free | 8gwifi.org">
<meta name="twitter:description" content="Free SE calculator with margin of error and confidence intervals.">

<!-- jStat -->
<script src="https://cdn.jsdelivr.net/npm/jstat@latest/dist/jstat.min.js"></script>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Standard Error Calculator",
  "url": "https://8gwifi.org/standard-error-calculator.jsp",
  "description": "Comprehensive Standard Error Calculator for mean, proportion, difference of means, and difference of proportions. Calculate SE, margin of error, and confidence intervals.",
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "browserRequirements": "Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Standard error of mean, Standard error of proportion, Standard error of difference of means, Standard error of difference of proportions, Margin of error, Confidence intervals, Critical values"
}
</script>

<style>
  :root {
    --primary-color: #14b8a6;
    --primary-dark: #0f766e;
    --primary-light: #5eead4;
    --bg-light: #f0fdfa;
    --border-color: #99f6e4;
  }

  .calculator-section {
    background: white;
    border-radius: 12px;
    padding: 1.5rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    margin-bottom: 1.5rem;
  }

  .section-title {
    color: var(--primary-color);
    font-size: 1.25rem;
    font-weight: 600;
    margin-bottom: 1rem;
    padding-bottom: 0.5rem;
    border-bottom: 2px solid var(--border-color);
  }

  .form-label {
    font-weight: 500;
    color: #374151;
    margin-bottom: 0.5rem;
  }

  .form-control {
    border: 1.5px solid #e5e7eb;
    border-radius: 6px;
    padding: 0.5rem 0.75rem;
    transition: all 0.2s;
  }

  .form-control:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
  }

  .btn-calculate {
    background: var(--primary-color);
    color: white;
    border: none;
    padding: 0.75rem 2rem;
    font-size: 1rem;
    font-weight: 500;
    border-radius: 6px;
    transition: all 0.2s;
    width: 100%;
  }

  .btn-calculate:hover {
    background: var(--primary-dark);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(20, 184, 166, 0.3);
  }

  .results-panel {
    background: var(--bg-light);
    border-radius: 12px;
    padding: 1.5rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    position: sticky;
    top: 20px;
  }

  .result-item {
    background: white;
    border-left: 4px solid var(--primary-color);
    padding: 1rem;
    margin-bottom: 1rem;
    border-radius: 6px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  }

  .result-label {
    font-size: 0.85rem;
    color: #6b7280;
    font-weight: 500;
    margin-bottom: 0.25rem;
  }

  .result-value {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--primary-color);
    font-family: 'Courier New', monospace;
  }

  .interpretation {
    background: #ccfbf1;
    border-left: 4px solid #14b8a6;
    padding: 0.75rem;
    border-radius: 4px;
    font-size: 0.85rem;
    margin-top: 0.5rem;
    color: #115e59;
  }

  .nav-tabs .nav-link {
    color: #6b7280;
    border: none;
    border-bottom: 2px solid transparent;
  }

  .nav-tabs .nav-link.active {
    color: var(--primary-color);
    border-bottom: 2px solid var(--primary-color);
    background: transparent;
  }

  .nav-tabs .nav-link:hover {
    border-bottom: 2px solid var(--primary-light);
  }

  .info-box {
    background: #eff6ff;
    border-left: 4px solid #3b82f6;
    padding: 1rem;
    border-radius: 6px;
    margin: 1rem 0;
  }

  .info-box i {
    color: #3b82f6;
    margin-right: 0.5rem;
  }

  .educational-section {
    background: white;
    border-radius: 12px;
    padding: 2rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    margin-top: 2rem;
  }

  .educational-section h3 {
    color: var(--primary-color);
    font-size: 1.5rem;
    font-weight: 600;
    margin-bottom: 1rem;
  }

  .educational-section h4 {
    color: var(--primary-dark);
    font-size: 1.1rem;
    font-weight: 600;
    margin-top: 1.5rem;
    margin-bottom: 0.75rem;
  }

  .formula-box {
    background: var(--bg-light);
    border: 2px solid var(--border-color);
    border-radius: 8px;
    padding: 1rem;
    font-family: 'Courier New', monospace;
    font-size: 1rem;
    margin: 1rem 0;
    text-align: center;
  }

  .example-table {
    background: white;
    border-radius: 8px;
    overflow: hidden;
    margin: 1rem 0;
  }

  .example-table table {
    margin-bottom: 0;
  }

  .example-table th {
    background: var(--primary-color);
    color: white;
    font-weight: 500;
    padding: 0.75rem;
  }

  .example-table td {
    padding: 0.5rem 0.75rem;
    border-bottom: 1px solid #e5e7eb;
  }

  @media (max-width: 991px) {
    .results-panel {
      position: static;
      margin-top: 1.5rem;
    }
  }

  @media (max-width: 768px) {
    .result-value {
      font-size: 1.25rem;
    }
  }
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1>Standard Error Calculator</h1>
  <p class="text-muted">Calculate standard error, margin of error, and confidence intervals for statistical analysis</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="calculator-section">
        <h2 class="section-title"><i class="fas fa-calculator"></i> Calculation Type</h2>

        <!-- Calculation Type Tabs -->
        <ul class="nav nav-tabs mb-3" id="calcTabs" role="tablist">
          <li class="nav-item">
            <a class="nav-link active" id="mean-tab" data-toggle="tab" href="#mean" role="tab">SE of Mean</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="prop-tab" data-toggle="tab" href="#proportion" role="tab">SE of Proportion</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="diff-mean-tab" data-toggle="tab" href="#diffMean" role="tab">SE of Diff (Means)</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="diff-prop-tab" data-toggle="tab" href="#diffProp" role="tab">SE of Diff (Props)</a>
          </li>
        </ul>

        <div class="tab-content" id="calcTabContent">
          <!-- SE of Mean -->
          <div class="tab-pane fade show active" id="mean" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Standard Error of Mean:</strong> Measures variability of sample mean from population mean
            </div>

            <div class="mb-3">
              <label for="meanSD" class="form-label">Standard Deviation (σ or s)</label>
              <input type="number" class="form-control" id="meanSD" value="15" step="0.01" min="0.01">
              <small class="text-muted">Population or sample standard deviation</small>
            </div>

            <div class="mb-3">
              <label for="meanN" class="form-label">Sample Size (n)</label>
              <input type="number" class="form-control" id="meanN" value="36" step="1" min="1">
            </div>

            <div class="mb-3">
              <label for="meanConfidence" class="form-label">Confidence Level</label>
              <select class="form-control" id="meanConfidence">
                <option value="0.90">90%</option>
                <option value="0.95" selected>95%</option>
                <option value="0.99">99%</option>
              </select>
            </div>
          </div>

          <!-- SE of Proportion -->
          <div class="tab-pane fade" id="proportion" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Standard Error of Proportion:</strong> Measures variability of sample proportion
            </div>

            <div class="mb-3">
              <label for="propP" class="form-label">Sample Proportion (p)</label>
              <input type="number" class="form-control" id="propP" value="0.60" step="0.01" min="0" max="1">
              <small class="text-muted">Enter as decimal (e.g., 0.60 for 60%)</small>
            </div>

            <div class="mb-3">
              <label for="propN" class="form-label">Sample Size (n)</label>
              <input type="number" class="form-control" id="propN" value="100" step="1" min="1">
            </div>

            <div class="mb-3">
              <label for="propConfidence" class="form-label">Confidence Level</label>
              <select class="form-control" id="propConfidence">
                <option value="0.90">90%</option>
                <option value="0.95" selected>95%</option>
                <option value="0.99">99%</option>
              </select>
            </div>
          </div>

          <!-- SE of Difference of Means -->
          <div class="tab-pane fade" id="diffMean" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>SE of Difference of Means:</strong> For two independent samples
            </div>

            <div class="row">
              <div class="col-md-6">
                <h6 class="text-primary">Sample 1</h6>
                <div class="mb-3">
                  <label for="diffMeanSD1" class="form-label">Std Dev (s₁)</label>
                  <input type="number" class="form-control" id="diffMeanSD1" value="10" step="0.01" min="0.01">
                </div>
                <div class="mb-3">
                  <label for="diffMeanN1" class="form-label">Size (n₁)</label>
                  <input type="number" class="form-control" id="diffMeanN1" value="30" step="1" min="1">
                </div>
              </div>
              <div class="col-md-6">
                <h6 class="text-primary">Sample 2</h6>
                <div class="mb-3">
                  <label for="diffMeanSD2" class="form-label">Std Dev (s₂)</label>
                  <input type="number" class="form-control" id="diffMeanSD2" value="12" step="0.01" min="0.01">
                </div>
                <div class="mb-3">
                  <label for="diffMeanN2" class="form-label">Size (n₂)</label>
                  <input type="number" class="form-control" id="diffMeanN2" value="35" step="1" min="1">
                </div>
              </div>
            </div>

            <div class="mb-3">
              <label for="diffMeanConfidence" class="form-label">Confidence Level</label>
              <select class="form-control" id="diffMeanConfidence">
                <option value="0.90">90%</option>
                <option value="0.95" selected>95%</option>
                <option value="0.99">99%</option>
              </select>
            </div>
          </div>

          <!-- SE of Difference of Proportions -->
          <div class="tab-pane fade" id="diffProp" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>SE of Difference of Proportions:</strong> For two independent samples
            </div>

            <div class="row">
              <div class="col-md-6">
                <h6 class="text-primary">Sample 1</h6>
                <div class="mb-3">
                  <label for="diffPropP1" class="form-label">Proportion (p₁)</label>
                  <input type="number" class="form-control" id="diffPropP1" value="0.55" step="0.01" min="0" max="1">
                </div>
                <div class="mb-3">
                  <label for="diffPropN1" class="form-label">Size (n₁)</label>
                  <input type="number" class="form-control" id="diffPropN1" value="80" step="1" min="1">
                </div>
              </div>
              <div class="col-md-6">
                <h6 class="text-primary">Sample 2</h6>
                <div class="mb-3">
                  <label for="diffPropP2" class="form-label">Proportion (p₂)</label>
                  <input type="number" class="form-control" id="diffPropP2" value="0.45" step="0.01" min="0" max="1">
                </div>
                <div class="mb-3">
                  <label for="diffPropN2" class="form-label">Size (n₂)</label>
                  <input type="number" class="form-control" id="diffPropN2" value="90" step="1" min="1">
                </div>
              </div>
            </div>

            <div class="mb-3">
              <label for="diffPropConfidence" class="form-label">Confidence Level</label>
              <select class="form-control" id="diffPropConfidence">
                <option value="0.90">90%</option>
                <option value="0.95" selected>95%</option>
                <option value="0.99">99%</option>
              </select>
            </div>
          </div>
        </div>

        <button class="btn btn-calculate mt-3" onclick="calculate()">
          <i class="fas fa-calculator"></i> Calculate Standard Error
        </button>
      </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-5">
      <div class="results-panel">
        <h2 class="section-title"><i class="fas fa-chart-area"></i> Results</h2>
        <div id="resultsContent">
          <div class="text-center text-muted py-4">
            <i class="fas fa-arrow-left" style="font-size: 2rem; opacity: 0.3;"></i>
            <p class="mt-2">Select calculation type and enter data</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Educational Content -->
  <div class="educational-section">
    <h3><i class="fas fa-graduation-cap"></i> Understanding Standard Error</h3>

    <p><strong>Standard error (SE)</strong> measures the precision of a sample statistic as an estimate of the population parameter. It quantifies how much the statistic varies from sample to sample.</p>

    <h4>Standard Error Formulas</h4>

    <h5>1. Standard Error of Mean</h5>
    <div class="formula-box">
      SE = σ / √n
    </div>
    <p>Where: σ = population standard deviation, n = sample size</p>
    <p>When σ is unknown, use sample standard deviation (s)</p>

    <h5>2. Standard Error of Proportion</h5>
    <div class="formula-box">
      SE = √[p(1-p) / n]
    </div>
    <p>Where: p = sample proportion, n = sample size</p>

    <h5>3. Standard Error of Difference of Means</h5>
    <div class="formula-box">
      SE = √[(s₁²/n₁) + (s₂²/n₂)]
    </div>
    <p>For two independent samples with standard deviations s₁ and s₂</p>

    <h5>4. Standard Error of Difference of Proportions</h5>
    <div class="formula-box">
      SE = √[p₁(1-p₁)/n₁ + p₂(1-p₂)/n₂]
    </div>
    <p>For two independent sample proportions</p>

    <h4>Margin of Error</h4>
    <p>The margin of error (ME) is the maximum expected difference between the true population parameter and sample estimate:</p>
    <div class="formula-box">
      ME = Critical Value × SE
    </div>
    <ul>
      <li><strong>90% confidence:</strong> Z = 1.645</li>
      <li><strong>95% confidence:</strong> Z = 1.96</li>
      <li><strong>99% confidence:</strong> Z = 2.576</li>
    </ul>

    <h4>Confidence Intervals</h4>
    <p>Confidence intervals provide a range likely to contain the true population parameter:</p>
    <div class="formula-box">
      CI = Point Estimate ± Margin of Error
    </div>

    <div class="example-table">
      <table class="table">
        <thead>
          <tr>
            <th>Statistic</th>
            <th>Confidence Interval Formula</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>Mean</strong></td>
            <td>x̄ ± (Z × SE)</td>
          </tr>
          <tr>
            <td><strong>Proportion</strong></td>
            <td>p ± (Z × SE)</td>
          </tr>
          <tr>
            <td><strong>Difference (Means)</strong></td>
            <td>(x̄₁ - x̄₂) ± (Z × SE)</td>
          </tr>
          <tr>
            <td><strong>Difference (Props)</strong></td>
            <td>(p₁ - p₂) ± (Z × SE)</td>
          </tr>
        </tbody>
      </table>
    </div>

    <h4>Key Relationships</h4>
    <ul>
      <li><strong>Larger sample size (n):</strong> Smaller SE (more precise estimate)</li>
      <li><strong>Higher variability (σ or s):</strong> Larger SE (less precise)</li>
      <li><strong>SE decreases</strong> proportional to √n (doubling sample size reduces SE by √2)</li>
      <li><strong>Smaller SE:</strong> Narrower confidence intervals (more precise)</li>
    </ul>

    <h4>Standard Error vs. Standard Deviation</h4>
    <div class="example-table">
      <table class="table">
        <thead>
          <tr>
            <th>Measure</th>
            <th>What It Measures</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>Standard Deviation (σ, s)</strong></td>
            <td>Spread of individual data points around the mean</td>
          </tr>
          <tr>
            <td><strong>Standard Error (SE)</strong></td>
            <td>Variability of sample statistic across different samples</td>
          </tr>
        </tbody>
      </table>
    </div>

    <h4>Real-World Applications</h4>
    <ul>
      <li><strong>Polling:</strong> Margin of error in election polls (±3% means SE ≈ 1.5%)</li>
      <li><strong>Clinical Trials:</strong> Precision of treatment effect estimates</li>
      <li><strong>Quality Control:</strong> Variability in manufacturing processes</li>
      <li><strong>A/B Testing:</strong> Confidence in conversion rate differences</li>
      <li><strong>Economics:</strong> Uncertainty in economic indicators</li>
    </ul>

    <h4>Example Interpretation</h4>
    <p><strong>Scenario:</strong> Sample mean = 105, SE = 2.5, 95% CI</p>
    <p><strong>Margin of Error:</strong> 1.96 × 2.5 = 4.9</p>
    <p><strong>95% CI:</strong> [100.1, 109.9]</p>
    <p><strong>Interpretation:</strong> We are 95% confident the true population mean lies between 100.1 and 109.9</p>

    <div class="info-box">
      <i class="fas fa-lightbulb"></i>
      <strong>Tip:</strong> To reduce the margin of error by half, you need to quadruple the sample size (because SE ∝ 1/√n). This is why larger samples provide more precise estimates.
    </div>
  </div>
</div>

<%@ include file="thanks.jsp"%>

  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="addcomments.jsp"%>
  <!-- FAQ: inlined (was jspf/faq/math/standard-error-calculator-faq.jspf) -->
  <section id="faq" class="mt-5">
    <h2 class="h5">Standard Error (SE): FAQ</h2>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">SE vs SD?</h3>
      <p class="mb-0">SD measures variability of data; SE measures variability of a statistic (e.g., mean) across repeated samples and shrinks with larger n.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How does SE relate to CIs?</h3>
      <p class="mb-0">Confidence intervals are built from estimates ± critical value × SE (e.g., mean ± t*·SE).</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">When to use pooled SE?</h3>
      <p class="mb-0">For differences in means under equal variance assumptions; otherwise use Welch’s (unpooled) approach.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Why does larger n reduce SE?</h3>
      <p class="mb-0">SE typically scales like SD/√n, so it decreases as sample size grows, reflecting more precise estimates.</p>
    </div></div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"SE vs SD?","acceptedAnswer":{"@type":"Answer","text":"SD measures data spread; SE measures estimator spread, shrinking with n."}},
      {"@type":"Question","name":"How does SE relate to CIs?","acceptedAnswer":{"@type":"Answer","text":"CIs use estimate ± critical value × SE (e.g., mean ± t*·SE)."}},
      {"@type":"Question","name":"When to use pooled SE?","acceptedAnswer":{"@type":"Answer","text":"For equal variance assumptions in two‑sample means; else use Welch (unpooled)."}},
      {"@type":"Question","name":"Why does larger n reduce SE?","acceptedAnswer":{"@type":"Answer","text":"SE often scales as SD/√n, decreasing with larger samples."}}
    ]
  }
  </script>
  <!-- Breadcrumbs: inlined (was jspf/breadcrumbs/math/standard-error-calculator-breadcrumbs.jspf) -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"Standard Error Calculator","item":"https://8gwifi.org/standard-error-calculator.jsp"}
    ]
  }
  </script>
</div>

<%@ include file="body-close.jsp"%>

<script>
  function calculate() {
    const activeTab = document.querySelector('#calcTabs .nav-link.active').id;

    try {
      if (activeTab === 'mean-tab') {
        calculateSEMean();
      } else if (activeTab === 'prop-tab') {
        calculateSEProportion();
      } else if (activeTab === 'diff-mean-tab') {
        calculateSEDiffMean();
      } else if (activeTab === 'diff-prop-tab') {
        calculateSEDiffProp();
      }
    } catch (error) {
      alert('Error: ' + error.message);
    }
  }

  function calculateSEMean() {
    const sd = parseFloat(document.getElementById('meanSD').value);
    const n = parseInt(document.getElementById('meanN').value);
    const confidence = parseFloat(document.getElementById('meanConfidence').value);

    if (isNaN(sd) || isNaN(n) || sd <= 0 || n < 1) {
      throw new Error('Invalid input parameters');
    }

    const se = sd / Math.sqrt(n);
    const z = jStat.normal.inv((1 + confidence) / 2, 0, 1);
    const me = z * se;

    displayResults({
      type: 'Standard Error of Mean',
      se: se,
      me: me,
      confidence: confidence,
      criticalValue: z,
      interpretation: `The sample mean is estimated to vary by ±${se.toFixed(4)} from the true population mean. With ${(confidence*100).toFixed(0)}% confidence, the margin of error is ±${me.toFixed(4)}.`
    });
  }

  function calculateSEProportion() {
    const p = parseFloat(document.getElementById('propP').value);
    const n = parseInt(document.getElementById('propN').value);
    const confidence = parseFloat(document.getElementById('propConfidence').value);

    if (isNaN(p) || isNaN(n) || p < 0 || p > 1 || n < 1) {
      throw new Error('Invalid input parameters');
    }

    const se = Math.sqrt(p * (1 - p) / n);
    const z = jStat.normal.inv((1 + confidence) / 2, 0, 1);
    const me = z * se;

    const ciLower = Math.max(0, p - me);
    const ciUpper = Math.min(1, p + me);

    displayResults({
      type: 'Standard Error of Proportion',
      se: se,
      me: me,
      confidence: confidence,
      criticalValue: z,
      ciLower: ciLower,
      ciUpper: ciUpper,
      sampleProp: p,
      interpretation: `The sample proportion (${(p*100).toFixed(1)}%) has a standard error of ${(se*100).toFixed(2)}%. The ${(confidence*100).toFixed(0)}% confidence interval is [${(ciLower*100).toFixed(2)}%, ${(ciUpper*100).toFixed(2)}%].`
    });
  }

  function calculateSEDiffMean() {
    const s1 = parseFloat(document.getElementById('diffMeanSD1').value);
    const n1 = parseInt(document.getElementById('diffMeanN1').value);
    const s2 = parseFloat(document.getElementById('diffMeanSD2').value);
    const n2 = parseInt(document.getElementById('diffMeanN2').value);
    const confidence = parseFloat(document.getElementById('diffMeanConfidence').value);

    if (isNaN(s1) || isNaN(n1) || isNaN(s2) || isNaN(n2) ||
        s1 <= 0 || n1 < 1 || s2 <= 0 || n2 < 1) {
      throw new Error('Invalid input parameters');
    }

    const se = Math.sqrt((s1*s1/n1) + (s2*s2/n2));
    const z = jStat.normal.inv((1 + confidence) / 2, 0, 1);
    const me = z * se;

    displayResults({
      type: 'Standard Error of Difference of Means',
      se: se,
      me: me,
      confidence: confidence,
      criticalValue: z,
      interpretation: `The difference between sample means has a standard error of ${se.toFixed(4)}. The ${(confidence*100).toFixed(0)}% margin of error for the difference is ±${me.toFixed(4)}.`
    });
  }

  function calculateSEDiffProp() {
    const p1 = parseFloat(document.getElementById('diffPropP1').value);
    const n1 = parseInt(document.getElementById('diffPropN1').value);
    const p2 = parseFloat(document.getElementById('diffPropP2').value);
    const n2 = parseInt(document.getElementById('diffPropN2').value);
    const confidence = parseFloat(document.getElementById('diffPropConfidence').value);

    if (isNaN(p1) || isNaN(n1) || isNaN(p2) || isNaN(n2) ||
        p1 < 0 || p1 > 1 || p2 < 0 || p2 > 1 || n1 < 1 || n2 < 1) {
      throw new Error('Invalid input parameters');
    }

    const se = Math.sqrt((p1*(1-p1)/n1) + (p2*(1-p2)/n2));
    const z = jStat.normal.inv((1 + confidence) / 2, 0, 1);
    const me = z * se;

    const diff = p1 - p2;
    const ciLower = diff - me;
    const ciUpper = diff + me;

    displayResults({
      type: 'Standard Error of Difference of Proportions',
      se: se,
      me: me,
      confidence: confidence,
      criticalValue: z,
      diff: diff,
      ciLower: ciLower,
      ciUpper: ciUpper,
      interpretation: `The difference between proportions (${(diff*100).toFixed(2)}%) has a standard error of ${(se*100).toFixed(2)}%. The ${(confidence*100).toFixed(0)}% confidence interval for the difference is [${(ciLower*100).toFixed(2)}%, ${(ciUpper*100).toFixed(2)}%].`
    });
  }

  function displayResults(results) {
    let html = `
      <div class="result-item">
        <div class="result-label">${results.type}</div>
      </div>

      <div class="result-item">
        <div class="result-label">Standard Error (SE)</div>
        <div class="result-value">${results.se.toFixed(6)}</div>
      </div>

      <div class="result-item">
        <div class="result-label">Margin of Error (ME)</div>
        <div class="result-value">±${results.me.toFixed(6)}</div>
        <div class="interpretation">
          At ${(results.confidence * 100).toFixed(0)}% confidence level
        </div>
      </div>

      <div class="result-item">
        <div class="result-label">Critical Value (Z)</div>
        <div class="result-value">${results.criticalValue.toFixed(4)}</div>
      </div>
    `;

    if (results.sampleProp !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Sample Proportion</div>
          <div class="result-value">${(results.sampleProp * 100).toFixed(2)}%</div>
        </div>
      `;
    }

    if (results.ciLower !== undefined && results.ciUpper !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">${(results.confidence * 100).toFixed(0)}% Confidence Interval</div>
          <div class="result-value">[${results.ciLower.toFixed(4)}, ${results.ciUpper.toFixed(4)}]</div>
        </div>
      `;
    }

    if (results.diff !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Difference (p₁ - p₂)</div>
          <div class="result-value">${(results.diff * 100).toFixed(2)}%</div>
        </div>
      `;
    }

    html += `
      <div class="result-item">
        <div class="result-label">Interpretation</div>
        <div class="interpretation">
          ${results.interpretation}
        </div>
      </div>
    `;

    document.getElementById('resultsContent').innerHTML = html;
  }
</script>
