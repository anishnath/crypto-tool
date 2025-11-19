<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Hypothesis Test Calculator Online – Free | 8gwifi.org</title>
<meta name="description" content="Free online Hypothesis Test Calculator. Perform Z-tests, T-tests, and proportion tests. Calculate test statistics, p-values, and make statistical decisions with confidence.">
<meta name="keywords" content="hypothesis test calculator, z-test calculator, t-test calculator, proportion test, statistical significance, p-value, null hypothesis, alternative hypothesis">
<link rel="canonical" href="https://8gwifi.org/hypothesis-test-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Hypothesis Test Calculator Online – Free | 8gwifi.org">
<meta property="og:description" content="Perform Z-tests, T-tests, and proportion tests with automatic statistical decision making.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/hypothesis-test-calculator.jsp">
<meta property="og:image" content="https://8gwifi.org/images/hypothesis-test-calculator.png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Hypothesis Test Calculator Online – Free | 8gwifi.org">
<meta name="twitter:description" content="All-in-one hypothesis testing: Z-test, T-test, proportion test with p-value calculation.">
<meta name="twitter:image" content="https://8gwifi.org/images/hypothesis-test-calculator.png">

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<!-- jStat -->
<script src="https://cdn.jsdelivr.net/npm/jstat@latest/dist/jstat.min.js"></script>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Hypothesis Test Calculator",
  "url": "https://8gwifi.org/hypothesis-test-calculator.jsp",
  "description": "Comprehensive Hypothesis Test Calculator for Z-tests, T-tests, and proportion tests. Calculate test statistics, p-values, critical values, and make statistical decisions automatically.",
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "browserRequirements": "Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Z-test for means, T-test for means, One-proportion Z-test, Two-proportion Z-test, Test statistic calculation, P-value calculation, Critical values, Statistical decision making, Confidence intervals, Two-tailed and one-tailed tests",
  "screenshot": "https://8gwifi.org/images/hypothesis-test-calculator.png",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "1730"
  }
}
</script>

<style>
  :root {
    --primary-color: #8b5cf6;
    --primary-dark: #7c3aed;
    --primary-light: #c4b5fd;
    --bg-light: #f5f3ff;
    --border-color: #ddd6fe;
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
    box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
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
    box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
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

  .decision-box {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    color: white;
    padding: 1.5rem;
    border-radius: 8px;
    margin: 1rem 0;
    font-weight: 600;
    font-size: 1.1rem;
    text-align: center;
  }

  .decision-box.reject {
    background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  }

  .decision-box.fail-reject {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  }

  .interpretation {
    background: #ede9fe;
    border-left: 4px solid #8b5cf6;
    padding: 0.75rem;
    border-radius: 4px;
    font-size: 0.85rem;
    margin-top: 0.5rem;
    color: #5b21b6;
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

  #testDistribution {
    width: 100%;
    max-height: 250px;
    border-radius: 8px;
  }

  .chart-container {
    background: white;
    padding: 1rem;
    border-radius: 8px;
    margin-top: 1rem;
  }

  .info-box {
    background: #fef3c7;
    border-left: 4px solid #f59e0b;
    padding: 1rem;
    border-radius: 6px;
    margin: 1rem 0;
  }

  .info-box i {
    color: #f59e0b;
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
  <h1>Hypothesis Test Calculator</h1>
  <p class="text-muted">Perform Z-tests, T-tests, and proportion tests with automatic statistical decision making</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="calculator-section">
        <h2 class="section-title"><i class="fas fa-vial"></i> Test Type</h2>

        <!-- Test Type Tabs -->
        <ul class="nav nav-tabs mb-3" id="testTabs" role="tablist">
          <li class="nav-item">
            <a class="nav-link active" id="z-mean-tab" data-toggle="tab" href="#zMean" role="tab">Z-Test (Mean)</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="t-mean-tab" data-toggle="tab" href="#tMean" role="tab">T-Test (Mean)</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="z-prop-tab" data-toggle="tab" href="#zProp" role="tab">Z-Test (Proportion)</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="two-prop-tab" data-toggle="tab" href="#twoProp" role="tab">Two Proportions</a>
          </li>
        </ul>

        <div class="tab-content" id="testTabContent">
          <!-- Z-Test for Mean -->
          <div class="tab-pane fade show active" id="zMean" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Z-Test for Mean:</strong> When population σ is known (large sample: n ≥ 30)
            </div>

            <div class="mb-3">
              <label for="zMeanSample" class="form-label">Sample Mean (x̄)</label>
              <input type="number" class="form-control" id="zMeanSample" value="105" step="0.01">
            </div>

            <div class="mb-3">
              <label for="zMeanPop" class="form-label">Population Mean (μ₀) - Null Hypothesis</label>
              <input type="number" class="form-control" id="zMeanPop" value="100" step="0.01">
            </div>

            <div class="mb-3">
              <label for="zMeanSigma" class="form-label">Population Std Dev (σ)</label>
              <input type="number" class="form-control" id="zMeanSigma" value="15" step="0.01" min="0.01">
            </div>

            <div class="mb-3">
              <label for="zMeanN" class="form-label">Sample Size (n)</label>
              <input type="number" class="form-control" id="zMeanN" value="36" step="1" min="1">
            </div>

            <div class="mb-3">
              <label for="zMeanAlpha" class="form-label">Significance Level (α)</label>
              <select class="form-control" id="zMeanAlpha">
                <option value="0.01">0.01</option>
                <option value="0.05" selected>0.05</option>
                <option value="0.10">0.10</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Alternative Hypothesis</label>
              <select class="form-control" id="zMeanAlt">
                <option value="two-tailed" selected>Two-tailed (μ ≠ μ₀)</option>
                <option value="greater">Right-tailed (μ > μ₀)</option>
                <option value="less">Left-tailed (μ < μ₀)</option>
              </select>
            </div>
          </div>

          <!-- T-Test for Mean -->
          <div class="tab-pane fade" id="tMean" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>T-Test for Mean:</strong> When population σ is unknown (small sample: n < 30)
            </div>

            <div class="mb-3">
              <label for="tMeanSample" class="form-label">Sample Mean (x̄)</label>
              <input type="number" class="form-control" id="tMeanSample" value="105" step="0.01">
            </div>

            <div class="mb-3">
              <label for="tMeanPop" class="form-label">Population Mean (μ₀) - Null Hypothesis</label>
              <input type="number" class="form-control" id="tMeanPop" value="100" step="0.01">
            </div>

            <div class="mb-3">
              <label for="tMeanS" class="form-label">Sample Std Dev (s)</label>
              <input type="number" class="form-control" id="tMeanS" value="12" step="0.01" min="0.01">
            </div>

            <div class="mb-3">
              <label for="tMeanN" class="form-label">Sample Size (n)</label>
              <input type="number" class="form-control" id="tMeanN" value="16" step="1" min="2">
            </div>

            <div class="mb-3">
              <label for="tMeanAlpha" class="form-label">Significance Level (α)</label>
              <select class="form-control" id="tMeanAlpha">
                <option value="0.01">0.01</option>
                <option value="0.05" selected>0.05</option>
                <option value="0.10">0.10</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Alternative Hypothesis</label>
              <select class="form-control" id="tMeanAlt">
                <option value="two-tailed" selected>Two-tailed (μ ≠ μ₀)</option>
                <option value="greater">Right-tailed (μ > μ₀)</option>
                <option value="less">Left-tailed (μ < μ₀)</option>
              </select>
            </div>
          </div>

          <!-- Z-Test for Proportion -->
          <div class="tab-pane fade" id="zProp" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Z-Test for Proportion:</strong> Test if sample proportion differs from claimed proportion
            </div>

            <div class="mb-3">
              <label for="zPropX" class="form-label">Number of Successes (x)</label>
              <input type="number" class="form-control" id="zPropX" value="55" step="1" min="0">
            </div>

            <div class="mb-3">
              <label for="zPropN" class="form-label">Sample Size (n)</label>
              <input type="number" class="form-control" id="zPropN" value="100" step="1" min="1">
            </div>

            <div class="mb-3">
              <label for="zPropP0" class="form-label">Claimed Proportion (p₀)</label>
              <input type="number" class="form-control" id="zPropP0" value="0.50" step="0.01" min="0" max="1">
            </div>

            <div class="mb-3">
              <label for="zPropAlpha" class="form-label">Significance Level (α)</label>
              <select class="form-control" id="zPropAlpha">
                <option value="0.01">0.01</option>
                <option value="0.05" selected>0.05</option>
                <option value="0.10">0.10</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Alternative Hypothesis</label>
              <select class="form-control" id="zPropAlt">
                <option value="two-tailed" selected>Two-tailed (p ≠ p₀)</option>
                <option value="greater">Right-tailed (p > p₀)</option>
                <option value="less">Left-tailed (p < p₀)</option>
              </select>
            </div>
          </div>

          <!-- Two-Proportion Z-Test -->
          <div class="tab-pane fade" id="twoProp" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Two-Proportion Z-Test:</strong> Compare proportions from two independent samples
            </div>

            <div class="row">
              <div class="col-md-6">
                <h6 class="text-primary">Sample 1</h6>
                <div class="mb-3">
                  <label for="twoPropX1" class="form-label">Successes (x₁)</label>
                  <input type="number" class="form-control" id="twoPropX1" value="45" step="1" min="0">
                </div>
                <div class="mb-3">
                  <label for="twoPropN1" class="form-label">Size (n₁)</label>
                  <input type="number" class="form-control" id="twoPropN1" value="100" step="1" min="1">
                </div>
              </div>
              <div class="col-md-6">
                <h6 class="text-primary">Sample 2</h6>
                <div class="mb-3">
                  <label for="twoPropX2" class="form-label">Successes (x₂)</label>
                  <input type="number" class="form-control" id="twoPropX2" value="60" step="1" min="0">
                </div>
                <div class="mb-3">
                  <label for="twoPropN2" class="form-label">Size (n₂)</label>
                  <input type="number" class="form-control" id="twoPropN2" value="120" step="1" min="1">
                </div>
              </div>
            </div>

            <div class="mb-3">
              <label for="twoPropAlpha" class="form-label">Significance Level (α)</label>
              <select class="form-control" id="twoPropAlpha">
                <option value="0.01">0.01</option>
                <option value="0.05" selected>0.05</option>
                <option value="0.10">0.10</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Alternative Hypothesis</label>
              <select class="form-control" id="twoPropAlt">
                <option value="two-tailed" selected>Two-tailed (p₁ ≠ p₂)</option>
                <option value="greater">Right-tailed (p₁ > p₂)</option>
                <option value="less">Left-tailed (p₁ < p₂)</option>
              </select>
            </div>
          </div>
        </div>

        <button class="btn btn-calculate mt-3" onclick="calculateTest()">
          <i class="fas fa-calculator"></i> Perform Hypothesis Test
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
            <p class="mt-2">Select test type and enter data</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Educational Content -->
  <div class="educational-section">
    <h3><i class="fas fa-graduation-cap"></i> Understanding Hypothesis Testing</h3>

    <p><strong>Hypothesis testing</strong> is a statistical method for making decisions about population parameters based on sample data.</p>

    <h4>The Five Steps of Hypothesis Testing</h4>
    <ol>
      <li><strong>State the hypotheses:</strong> H₀ (null) and H₁ (alternative)</li>
      <li><strong>Choose significance level:</strong> α (typically 0.05)</li>
      <li><strong>Calculate test statistic:</strong> Z or T value</li>
      <li><strong>Find p-value:</strong> Probability of observing results if H₀ is true</li>
      <li><strong>Make decision:</strong> Reject or fail to reject H₀</li>
    </ol>

    <h4>Types of Hypotheses</h4>
    <ul>
      <li><strong>Null Hypothesis (H₀):</strong> No effect, no difference, status quo</li>
      <li><strong>Alternative Hypothesis (H₁):</strong> What we're testing for</li>
      <li><strong>Two-tailed:</strong> μ ≠ μ₀ (difference in either direction)</li>
      <li><strong>Right-tailed:</strong> μ > μ₀ (increase)</li>
      <li><strong>Left-tailed:</strong> μ < μ₀ (decrease)</li>
    </ul>

    <h4>Test Statistics</h4>

    <div class="formula-box">
      <strong>Z-test for mean:</strong> Z = (x̄ - μ₀) / (σ / √n)
    </div>

    <div class="formula-box">
      <strong>T-test for mean:</strong> t = (x̄ - μ₀) / (s / √n)
    </div>

    <div class="formula-box">
      <strong>Z-test for proportion:</strong> Z = (p̂ - p₀) / √(p₀(1-p₀) / n)
    </div>

    <div class="formula-box">
      <strong>Two-proportion Z-test:</strong> Z = (p̂₁ - p̂₂) / √(p̂(1-p̂)(1/n₁ + 1/n₂))
    </div>

    <h4>Decision Making</h4>
    <div class="example-table">
      <table class="table">
        <thead>
          <tr>
            <th>Condition</th>
            <th>Decision</th>
            <th>Interpretation</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>p-value ≤ α</td>
            <td><strong style="color: #ef4444;">Reject H₀</strong></td>
            <td>Statistically significant result</td>
          </tr>
          <tr>
            <td>p-value > α</td>
            <td><strong style="color: #10b981;">Fail to reject H₀</strong></td>
            <td>Not statistically significant</td>
          </tr>
        </tbody>
      </table>
    </div>

    <h4>Type I and Type II Errors</h4>
    <ul>
      <li><strong>Type I Error (α):</strong> Rejecting H₀ when it's actually true (false positive)</li>
      <li><strong>Type II Error (β):</strong> Failing to reject H₀ when it's actually false (false negative)</li>
      <li><strong>Power (1-β):</strong> Probability of correctly rejecting false H₀</li>
    </ul>

    <h4>When to Use Each Test</h4>
    <div class="example-table">
      <table class="table">
        <thead>
          <tr>
            <th>Test</th>
            <th>Use When</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>Z-test (mean)</strong></td>
            <td>σ is known OR n ≥ 30</td>
          </tr>
          <tr>
            <td><strong>T-test (mean)</strong></td>
            <td>σ is unknown AND n < 30</td>
          </tr>
          <tr>
            <td><strong>Z-test (proportion)</strong></td>
            <td>np₀ ≥ 5 AND n(1-p₀) ≥ 5</td>
          </tr>
          <tr>
            <td><strong>Two-proportion</strong></td>
            <td>Comparing two independent proportions</td>
          </tr>
        </tbody>
      </table>
    </div>

    <h4>Real-World Applications</h4>
    <ul>
      <li><strong>Medicine:</strong> Testing if new drug is more effective than placebo</li>
      <li><strong>Business:</strong> A/B testing website conversion rates</li>
      <li><strong>Quality Control:</strong> Testing if defect rate exceeds threshold</li>
      <li><strong>Education:</strong> Comparing teaching methods</li>
      <li><strong>Marketing:</strong> Testing if ad campaign increased sales</li>
    </ul>

    <div class="info-box">
      <i class="fas fa-lightbulb"></i>
      <strong>Important:</strong> "Fail to reject H₀" is NOT the same as "accepting H₀." We never prove the null hypothesis true; we only find insufficient evidence against it.
    </div>
  </div>
</div>

<%@ include file="thanks.jsp"%>

<%@ include file="footer_adsense.jsp"%>
  <%@ include file="addcomments.jsp"%>
  <!-- FAQ: inline -->
  <section id="faq" class="mt-5">
    <h2 class="h5">Hypothesis Testing: FAQ</h2>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Which test should I choose?</h3>
      <p class="mb-0">Use z‑test for large samples/known σ, t‑test for small samples unknown σ, proportion tests for binary data, and chi‑square/F tests for categorical/variance comparisons.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">One‑tailed or two‑tailed?</h3>
      <p class="mb-0">Decide before looking at data based on your research question: directional claims use one‑tailed; non‑directional use two‑tailed.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How to interpret p‑value and α?</h3>
      <p class="mb-0">If p ≤ α, reject H₀; if p > α, do not reject H₀. Statistical significance does not guarantee practical importance.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Assumptions matter?</h3>
      <p class="mb-0">Yes: independence, distributional assumptions, variance equality, etc. Check diagnostics or use robust alternatives when violated.</p>
    </div></div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"Which test should I choose?","acceptedAnswer":{"@type":"Answer","text":"z‑test for large/known σ; t‑test for small/unknown σ; proportion tests for binary data; chi‑square/F for categorical/variance comparisons."}},
      {"@type":"Question","name":"One‑tailed or two‑tailed?","acceptedAnswer":{"@type":"Answer","text":"Choose based on directional vs non‑directional hypotheses decided a priori."}},
      {"@type":"Question","name":"How to interpret p‑value and α?","acceptedAnswer":{"@type":"Answer","text":"If p ≤ α, reject H₀; if p > α, do not reject H₀. Practical significance may differ."}},
      {"@type":"Question","name":"Assumptions matter?","acceptedAnswer":{"@type":"Answer","text":"Check independence, distribution, variance equality; consider robust alternatives if violated."}}
    ]
  }
  </script>
  <!-- Breadcrumbs: inline -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"Hypothesis Test Calculator","item":"https://8gwifi.org/hypothesis-test-calculator.jsp"}
    ]
  }
  </script>
</div>

<%@ include file="body-close.jsp"%>

<script>
  let testChart = null;

  function calculateTest() {
    const activeTab = document.querySelector('#testTabs .nav-link.active').id;

    try {
      if (activeTab === 'z-mean-tab') {
        calculateZMean();
      } else if (activeTab === 't-mean-tab') {
        calculateTMean();
      } else if (activeTab === 'z-prop-tab') {
        calculateZProp();
      } else if (activeTab === 'two-prop-tab') {
        calculateTwoProp();
      }
    } catch (error) {
      alert('Error: ' + error.message);
    }
  }

  function calculateZMean() {
    const xbar = parseFloat(document.getElementById('zMeanSample').value);
    const mu0 = parseFloat(document.getElementById('zMeanPop').value);
    const sigma = parseFloat(document.getElementById('zMeanSigma').value);
    const n = parseInt(document.getElementById('zMeanN').value);
    const alpha = parseFloat(document.getElementById('zMeanAlpha').value);
    const alternative = document.getElementById('zMeanAlt').value;

    if (isNaN(xbar) || isNaN(mu0) || isNaN(sigma) || isNaN(n) || sigma <= 0 || n < 1) {
      throw new Error('Invalid input parameters');
    }

    const se = sigma / Math.sqrt(n);
    const z = (xbar - mu0) / se;

    let pValue;
    if (alternative === 'two-tailed') {
      pValue = 2 * (1 - jStat.normal.cdf(Math.abs(z), 0, 1));
    } else if (alternative === 'greater') {
      pValue = 1 - jStat.normal.cdf(z, 0, 1);
    } else {
      pValue = jStat.normal.cdf(z, 0, 1);
    }

    const criticalValue = alternative === 'two-tailed'
      ? jStat.normal.inv(1 - alpha/2, 0, 1)
      : jStat.normal.inv(1 - alpha, 0, 1);

    displayResults({
      testType: 'Z-Test for Mean',
      statistic: z,
      statisticName: 'Z',
      pValue: pValue,
      alpha: alpha,
      alternative: alternative,
      criticalValue: criticalValue,
      significant: pValue < alpha,
      nullHypothesis: `μ = ${mu0}`,
      distribution: 'normal'
    });

    drawDistribution(z, alternative, criticalValue, 'normal', null);
  }

  function calculateTMean() {
    const xbar = parseFloat(document.getElementById('tMeanSample').value);
    const mu0 = parseFloat(document.getElementById('tMeanPop').value);
    const s = parseFloat(document.getElementById('tMeanS').value);
    const n = parseInt(document.getElementById('tMeanN').value);
    const alpha = parseFloat(document.getElementById('tMeanAlpha').value);
    const alternative = document.getElementById('tMeanAlt').value;

    if (isNaN(xbar) || isNaN(mu0) || isNaN(s) || isNaN(n) || s <= 0 || n < 2) {
      throw new Error('Invalid input parameters');
    }

    const df = n - 1;
    const se = s / Math.sqrt(n);
    const t = (xbar - mu0) / se;

    let pValue;
    if (alternative === 'two-tailed') {
      pValue = 2 * (1 - jStat.studentt.cdf(Math.abs(t), df));
    } else if (alternative === 'greater') {
      pValue = 1 - jStat.studentt.cdf(t, df);
    } else {
      pValue = jStat.studentt.cdf(t, df);
    }

    const criticalValue = alternative === 'two-tailed'
      ? jStat.studentt.inv(1 - alpha/2, df)
      : jStat.studentt.inv(1 - alpha, df);

    displayResults({
      testType: 'T-Test for Mean',
      statistic: t,
      statisticName: 't',
      pValue: pValue,
      alpha: alpha,
      alternative: alternative,
      criticalValue: criticalValue,
      significant: pValue < alpha,
      nullHypothesis: `μ = ${mu0}`,
      df: df,
      distribution: 't'
    });

    drawDistribution(t, alternative, criticalValue, 't', df);
  }

  function calculateZProp() {
    const x = parseInt(document.getElementById('zPropX').value);
    const n = parseInt(document.getElementById('zPropN').value);
    const p0 = parseFloat(document.getElementById('zPropP0').value);
    const alpha = parseFloat(document.getElementById('zPropAlpha').value);
    const alternative = document.getElementById('zPropAlt').value;

    if (isNaN(x) || isNaN(n) || isNaN(p0) || x < 0 || n < 1 || p0 < 0 || p0 > 1 || x > n) {
      throw new Error('Invalid input parameters');
    }

    // Check conditions
    if (n * p0 < 5 || n * (1 - p0) < 5) {
      alert('Warning: Sample size may be too small for normal approximation (np₀ < 5 or n(1-p₀) < 5)');
    }

    const phat = x / n;
    const se = Math.sqrt(p0 * (1 - p0) / n);
    const z = (phat - p0) / se;

    let pValue;
    if (alternative === 'two-tailed') {
      pValue = 2 * (1 - jStat.normal.cdf(Math.abs(z), 0, 1));
    } else if (alternative === 'greater') {
      pValue = 1 - jStat.normal.cdf(z, 0, 1);
    } else {
      pValue = jStat.normal.cdf(z, 0, 1);
    }

    const criticalValue = alternative === 'two-tailed'
      ? jStat.normal.inv(1 - alpha/2, 0, 1)
      : jStat.normal.inv(1 - alpha, 0, 1);

    displayResults({
      testType: 'Z-Test for Proportion',
      statistic: z,
      statisticName: 'Z',
      pValue: pValue,
      alpha: alpha,
      alternative: alternative,
      criticalValue: criticalValue,
      significant: pValue < alpha,
      nullHypothesis: `p = ${p0}`,
      sampleProp: phat,
      distribution: 'normal'
    });

    drawDistribution(z, alternative, criticalValue, 'normal', null);
  }

  function calculateTwoProp() {
    const x1 = parseInt(document.getElementById('twoPropX1').value);
    const n1 = parseInt(document.getElementById('twoPropN1').value);
    const x2 = parseInt(document.getElementById('twoPropX2').value);
    const n2 = parseInt(document.getElementById('twoPropN2').value);
    const alpha = parseFloat(document.getElementById('twoPropAlpha').value);
    const alternative = document.getElementById('twoPropAlt').value;

    if (isNaN(x1) || isNaN(n1) || isNaN(x2) || isNaN(n2) ||
        x1 < 0 || n1 < 1 || x2 < 0 || n2 < 1 || x1 > n1 || x2 > n2) {
      throw new Error('Invalid input parameters');
    }

    const p1 = x1 / n1;
    const p2 = x2 / n2;
    const pPooled = (x1 + x2) / (n1 + n2);

    const se = Math.sqrt(pPooled * (1 - pPooled) * (1/n1 + 1/n2));
    const z = (p1 - p2) / se;

    let pValue;
    if (alternative === 'two-tailed') {
      pValue = 2 * (1 - jStat.normal.cdf(Math.abs(z), 0, 1));
    } else if (alternative === 'greater') {
      pValue = 1 - jStat.normal.cdf(z, 0, 1);
    } else {
      pValue = jStat.normal.cdf(z, 0, 1);
    }

    const criticalValue = alternative === 'two-tailed'
      ? jStat.normal.inv(1 - alpha/2, 0, 1)
      : jStat.normal.inv(1 - alpha, 0, 1);

    displayResults({
      testType: 'Two-Proportion Z-Test',
      statistic: z,
      statisticName: 'Z',
      pValue: pValue,
      alpha: alpha,
      alternative: alternative,
      criticalValue: criticalValue,
      significant: pValue < alpha,
      nullHypothesis: 'p₁ = p₂',
      prop1: p1,
      prop2: p2,
      distribution: 'normal'
    });

    drawDistribution(z, alternative, criticalValue, 'normal', null);
  }

  function displayResults(results) {
    const decision = results.significant ? 'Reject H₀' : 'Fail to Reject H₀';
    const decisionClass = results.significant ? 'reject' : 'fail-reject';

    let html = `
      <div class="decision-box ${decisionClass}">
        <i class="fas fa-${results.significant ? 'times-circle' : 'check-circle'}"></i> ${decision}
      </div>

      <div class="result-item">
        <div class="result-label">${results.testType}</div>
      </div>

      <div class="result-item">
        <div class="result-label">Null Hypothesis (H₀)</div>
        <div style="font-size: 1.1rem; font-weight: 600; margin-top: 0.5rem;">${results.nullHypothesis}</div>
      </div>

      <div class="result-item">
        <div class="result-label">Test Statistic (${results.statisticName})</div>
        <div class="result-value">${results.statistic.toFixed(4)}</div>
      </div>

      <div class="result-item">
        <div class="result-label">P-Value</div>
        <div class="result-value">${results.pValue.toFixed(6)}</div>
        <div class="interpretation">
          ${results.significant
            ? `<strong style="color: #dc2626;">p < α (${results.alpha})</strong><br>Result is statistically significant.`
            : `<strong style="color: #16a34a;">p ≥ α (${results.alpha})</strong><br>Result is not statistically significant.`
          }
        </div>
      </div>

      <div class="result-item">
        <div class="result-label">Critical Value (${results.alternative})</div>
        <div class="result-value">±${Math.abs(results.criticalValue).toFixed(4)}</div>
      </div>
    `;

    if (results.df !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Degrees of Freedom</div>
          <div class="result-value">${results.df}</div>
        </div>
      `;
    }

    if (results.sampleProp !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Sample Proportion (p̂)</div>
          <div class="result-value">${results.sampleProp.toFixed(4)}</div>
        </div>
      `;
    }

    if (results.prop1 !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Sample Proportions</div>
          <div style="font-size: 0.9rem; margin-top: 0.5rem;">
            <div>p̂₁ = ${results.prop1.toFixed(4)}</div>
            <div>p̂₂ = ${results.prop2.toFixed(4)}</div>
            <div>Difference = ${(results.prop1 - results.prop2).toFixed(4)}</div>
          </div>
        </div>
      `;
    }

    document.getElementById('resultsContent').innerHTML = html;
  }

  function drawDistribution(stat, alternative, criticalValue, distType, df) {
    const container = document.getElementById('resultsContent');

    let canvas = document.getElementById('testDistribution');
    if (!canvas) {
      const chartHtml = `
        <div class="chart-container">
          <h5 style="color: var(--primary-color); margin-bottom: 1rem; font-size: 0.95rem;">
            <i class="fas fa-chart-area"></i> ${distType === 'normal' ? 'Standard Normal' : 'T'} Distribution
          </h5>
          <canvas id="testDistribution"></canvas>
        </div>
      `;
      container.insertAdjacentHTML('beforeend', chartHtml);
      canvas = document.getElementById('testDistribution');
    }

    if (testChart) {
      testChart.destroy();
    }

    const xValues = [];
    const yValues = [];
    const range = 4;

    for (let x = -range; x <= range; x += 0.1) {
      xValues.push(x);
      if (distType === 'normal') {
        yValues.push(jStat.normal.pdf(x, 0, 1));
      } else {
        yValues.push(jStat.studentt.pdf(x, df));
      }
    }

    let rejectData;
    if (alternative === 'two-tailed') {
      rejectData = xValues.map((x, i) =>
        (x <= -Math.abs(criticalValue) || x >= Math.abs(criticalValue)) ? yValues[i] : null
      );
    } else if (alternative === 'greater') {
      rejectData = xValues.map((x, i) => x >= criticalValue ? yValues[i] : null);
    } else {
      rejectData = xValues.map((x, i) => x <= -criticalValue ? yValues[i] : null);
    }

    testChart = new Chart(canvas, {
      type: 'line',
      data: {
        labels: xValues,
        datasets: [{
          label: 'Distribution',
          data: yValues,
          borderColor: 'rgba(139, 92, 246, 1)',
          borderWidth: 2,
          fill: false,
          pointRadius: 0
        }, {
          label: 'Rejection Region',
          data: rejectData,
          backgroundColor: 'rgba(239, 68, 68, 0.3)',
          borderColor: 'rgba(239, 68, 68, 1)',
          borderWidth: 0,
          fill: true,
          pointRadius: 0
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 1.5,
        plugins: {
          legend: {
            position: 'top',
            labels: { boxWidth: 12, font: { size: 10 } }
          },
          title: {
            display: true,
            text: `Test Statistic = ${stat.toFixed(3)}`,
            font: { size: 11, weight: 'bold' }
          }
        },
        scales: {
          x: {
            title: { display: true, text: 'Test Statistic', font: { size: 10, weight: 'bold' } },
            ticks: { font: { size: 9 } }
          },
          y: {
            title: { display: true, text: 'Density', font: { size: 10, weight: 'bold' } },
            ticks: { font: { size: 9 } }
          }
        }
      }
    });
  }
</script>
