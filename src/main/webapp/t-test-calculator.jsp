<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>T-Test Calculator - One Sample, Two Sample, Paired, Welch's T-Test | Free Statistical Tool</title>
<meta name="description" content="Free online T-Test Calculator for one-sample, two-sample independent, paired, and Welch's t-tests. Calculate t-statistic, p-value, confidence intervals, and degrees of freedom with t-distribution visualization.">
<meta name="keywords" content="t-test calculator, t test, student t test, paired t test, independent t test, welch's t test, t statistic calculator, hypothesis testing, statistical significance">
<link rel="canonical" href="https://8gwifi.org/t-test-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="T-Test Calculator - Statistical Hypothesis Testing Tool">
<meta property="og:description" content="Calculate t-statistics, p-values, and confidence intervals for all types of t-tests with interactive visualization.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/t-test-calculator.jsp">
<meta property="og:image" content="https://8gwifi.org/images/t-test-calculator.png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="T-Test Calculator - Free Statistical Tool">
<meta name="twitter:description" content="Perform one-sample, two-sample, paired, and Welch's t-tests with p-value calculation and visualization.">
<meta name="twitter:image" content="https://8gwifi.org/images/t-test-calculator.png">

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<!-- jStat for statistical functions -->
<script src="https://cdn.jsdelivr.net/npm/jstat@latest/dist/jstat.min.js"></script>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "T-Test Calculator",
  "url": "https://8gwifi.org/t-test-calculator.jsp",
  "description": "Comprehensive T-Test Calculator for one-sample, two-sample independent, paired, and Welch's t-tests. Calculate t-statistics, p-values, confidence intervals, and visualize t-distributions.",
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "browserRequirements": "Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "One-sample t-test, Two-sample independent t-test, Paired t-test, Welch's t-test, T-statistic calculation, P-value calculation, Confidence intervals, Degrees of freedom, T-distribution visualization, Critical values",
  "screenshot": "https://8gwifi.org/images/t-test-calculator.png",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "ratingCount": "2340"
  }
}
</script>

<style>
  :root {
    --primary-color: #f59e0b;
    --primary-dark: #d97706;
    --primary-light: #fbbf24;
    --bg-light: #fffbeb;
    --border-color: #fde68a;
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
    box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1);
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
    box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
  }

  .btn-sample {
    background: white;
    color: var(--primary-color);
    border: 1.5px solid var(--primary-color);
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
    border-radius: 6px;
    transition: all 0.2s;
  }

  .btn-sample:hover {
    background: var(--bg-light);
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
    background: #fef3c7;
    border-left: 4px solid #f59e0b;
    padding: 0.75rem;
    border-radius: 4px;
    font-size: 0.85rem;
    margin-top: 0.5rem;
    color: #92400e;
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

  #tDistribution {
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
  <h1>T-Test Calculator</h1>
  <p class="text-muted">Perform one-sample, two-sample, paired, and Welch's t-tests with p-value calculation and visualization</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="calculator-section">
        <h2 class="section-title"><i class="fas fa-vial"></i> T-Test Type</h2>

        <!-- Test Type Tabs -->
        <ul class="nav nav-tabs mb-3" id="testTabs" role="tablist">
          <li class="nav-item">
            <a class="nav-link active" id="one-sample-tab" data-toggle="tab" href="#oneSample" role="tab">One-Sample</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="two-sample-tab" data-toggle="tab" href="#twoSample" role="tab">Two-Sample</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="paired-tab" data-toggle="tab" href="#paired" role="tab">Paired</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="welch-tab" data-toggle="tab" href="#welch" role="tab">Welch's</a>
          </li>
        </ul>

        <div class="tab-content" id="testTabContent">
          <!-- One-Sample T-Test -->
          <div class="tab-pane fade show active" id="oneSample" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>One-Sample T-Test:</strong> Compare sample mean to a known population mean
            </div>

            <div class="mb-3">
              <label for="oneSampleData" class="form-label">Sample Data (comma or space separated)</label>
              <textarea class="form-control" id="oneSampleData" rows="3" placeholder="e.g., 23, 25, 27, 22, 24, 26">23, 25, 27, 22, 24, 26, 28, 21, 25, 24</textarea>
            </div>

            <div class="mb-3">
              <label for="populationMean" class="form-label">Population Mean (μ₀)</label>
              <input type="number" class="form-control" id="populationMean" value="25" step="0.01">
            </div>

            <div class="mb-3">
              <label for="oneSampleAlpha" class="form-label">Significance Level (α)</label>
              <select class="form-control" id="oneSampleAlpha">
                <option value="0.01">0.01 (99% confidence)</option>
                <option value="0.05" selected>0.05 (95% confidence)</option>
                <option value="0.10">0.10 (90% confidence)</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Alternative Hypothesis</label>
              <select class="form-control" id="oneSampleAlt">
                <option value="two-tailed" selected>Two-tailed (μ ≠ μ₀)</option>
                <option value="greater">Right-tailed (μ > μ₀)</option>
                <option value="less">Left-tailed (μ < μ₀)</option>
              </select>
            </div>
          </div>

          <!-- Two-Sample Independent T-Test -->
          <div class="tab-pane fade" id="twoSample" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Two-Sample T-Test:</strong> Compare means of two independent groups (assumes equal variances)
            </div>

            <div class="mb-3">
              <label for="group1Data" class="form-label">Group 1 Data</label>
              <textarea class="form-control" id="group1Data" rows="2" placeholder="e.g., 23, 25, 27">23, 25, 27, 22, 24, 26</textarea>
            </div>

            <div class="mb-3">
              <label for="group2Data" class="form-label">Group 2 Data</label>
              <textarea class="form-control" id="group2Data" rows="2" placeholder="e.g., 28, 30, 32">28, 30, 32, 29, 31, 33</textarea>
            </div>

            <div class="mb-3">
              <label for="twoSampleAlpha" class="form-label">Significance Level (α)</label>
              <select class="form-control" id="twoSampleAlpha">
                <option value="0.01">0.01 (99% confidence)</option>
                <option value="0.05" selected>0.05 (95% confidence)</option>
                <option value="0.10">0.10 (90% confidence)</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Alternative Hypothesis</label>
              <select class="form-control" id="twoSampleAlt">
                <option value="two-tailed" selected>Two-tailed (μ₁ ≠ μ₂)</option>
                <option value="greater">Right-tailed (μ₁ > μ₂)</option>
                <option value="less">Left-tailed (μ₁ < μ₂)</option>
              </select>
            </div>
          </div>

          <!-- Paired T-Test -->
          <div class="tab-pane fade" id="paired" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Paired T-Test:</strong> Compare means of two related groups (before/after, matched pairs)
            </div>

            <div class="mb-3">
              <label for="pairedBefore" class="form-label">Before / Group A Data</label>
              <textarea class="form-control" id="pairedBefore" rows="2" placeholder="e.g., 120, 125, 130">120, 125, 130, 118, 122, 128</textarea>
            </div>

            <div class="mb-3">
              <label for="pairedAfter" class="form-label">After / Group B Data</label>
              <textarea class="form-control" id="pairedAfter" rows="2" placeholder="e.g., 115, 120, 125">115, 120, 125, 113, 118, 123</textarea>
            </div>

            <div class="mb-3">
              <label for="pairedAlpha" class="form-label">Significance Level (α)</label>
              <select class="form-control" id="pairedAlpha">
                <option value="0.01">0.01 (99% confidence)</option>
                <option value="0.05" selected>0.05 (95% confidence)</option>
                <option value="0.10">0.10 (90% confidence)</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Alternative Hypothesis</label>
              <select class="form-control" id="pairedAlt">
                <option value="two-tailed" selected>Two-tailed (μd ≠ 0)</option>
                <option value="greater">Right-tailed (μd > 0)</option>
                <option value="less">Left-tailed (μd < 0)</option>
              </select>
            </div>
          </div>

          <!-- Welch's T-Test -->
          <div class="tab-pane fade" id="welch" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Welch's T-Test:</strong> Compare means of two independent groups (does NOT assume equal variances)
            </div>

            <div class="mb-3">
              <label for="welchGroup1Data" class="form-label">Group 1 Data</label>
              <textarea class="form-control" id="welchGroup1Data" rows="2" placeholder="e.g., 23, 25, 27">23, 25, 27, 22, 24, 26, 25</textarea>
            </div>

            <div class="mb-3">
              <label for="welchGroup2Data" class="form-label">Group 2 Data</label>
              <textarea class="form-control" id="welchGroup2Data" rows="2" placeholder="e.g., 28, 30, 32">28, 30, 32, 29, 31, 33, 30, 31</textarea>
            </div>

            <div class="mb-3">
              <label for="welchAlpha" class="form-label">Significance Level (α)</label>
              <select class="form-control" id="welchAlpha">
                <option value="0.01">0.01 (99% confidence)</option>
                <option value="0.05" selected>0.05 (95% confidence)</option>
                <option value="0.10">0.10 (90% confidence)</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Alternative Hypothesis</label>
              <select class="form-control" id="welchAlt">
                <option value="two-tailed" selected>Two-tailed (μ₁ ≠ μ₂)</option>
                <option value="greater">Right-tailed (μ₁ > μ₂)</option>
                <option value="less">Left-tailed (μ₁ < μ₂)</option>
              </select>
            </div>
          </div>
        </div>

        <button class="btn btn-calculate mt-3" onclick="calculateTTest()">
          <i class="fas fa-calculator"></i> Calculate T-Test
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
            <p class="mt-2">Select a test type and enter data to see results</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Educational Content -->
  <div class="educational-section">
    <h3><i class="fas fa-graduation-cap"></i> Understanding T-Tests</h3>

    <p>A <strong>t-test</strong> is a statistical hypothesis test used to determine whether there is a significant difference between means. It's used when the population standard deviation is unknown and the sample size is small to moderate.</p>

    <h4>Types of T-Tests</h4>

    <h5>1. One-Sample T-Test</h5>
    <p>Tests whether a sample mean differs from a known population mean.</p>
    <div class="formula-box">
      t = (x̄ - μ₀) / (s / √n)
    </div>
    <p>Where: x̄ = sample mean, μ₀ = population mean, s = sample standard deviation, n = sample size</p>

    <h5>2. Two-Sample (Independent) T-Test</h5>
    <p>Compares means of two independent groups assuming equal variances.</p>
    <div class="formula-box">
      t = (x̄₁ - x̄₂) / (sp × √(1/n₁ + 1/n₂))
    </div>
    <p>Where: sp = pooled standard deviation, df = n₁ + n₂ - 2</p>

    <h5>3. Paired T-Test</h5>
    <p>Compares means of two related groups (before/after, matched pairs).</p>
    <div class="formula-box">
      t = d̄ / (sd / √n)
    </div>
    <p>Where: d̄ = mean of differences, sd = standard deviation of differences, df = n - 1</p>

    <h5>4. Welch's T-Test</h5>
    <p>Compares means of two independent groups WITHOUT assuming equal variances.</p>
    <div class="formula-box">
      t = (x̄₁ - x̄₂) / √(s₁²/n₁ + s₂²/n₂)
    </div>
    <p>Uses Welch-Satterthwaite equation for degrees of freedom.</p>

    <h4>Key Components</h4>

    <div class="example-table">
      <table class="table">
        <thead>
          <tr>
            <th>Component</th>
            <th>Description</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>t-statistic</strong></td>
            <td>Measures how many standard errors the sample mean is from the population mean</td>
          </tr>
          <tr>
            <td><strong>p-value</strong></td>
            <td>Probability of observing this result if the null hypothesis is true</td>
          </tr>
          <tr>
            <td><strong>Degrees of Freedom (df)</strong></td>
            <td>Number of values free to vary: n-1 (one-sample), n₁+n₂-2 (two-sample)</td>
          </tr>
          <tr>
            <td><strong>Critical Value</strong></td>
            <td>Threshold t-value for rejecting the null hypothesis at significance level α</td>
          </tr>
          <tr>
            <td><strong>Confidence Interval</strong></td>
            <td>Range likely to contain the true population parameter</td>
          </tr>
        </tbody>
      </table>
    </div>

    <h4>Hypothesis Testing</h4>
    <ul>
      <li><strong>Null Hypothesis (H₀):</strong> No difference between means (e.g., μ = μ₀, μ₁ = μ₂)</li>
      <li><strong>Alternative Hypothesis (H₁):</strong>
        <ul>
          <li><strong>Two-tailed:</strong> μ ≠ μ₀ (difference exists, either direction)</li>
          <li><strong>Right-tailed:</strong> μ > μ₀ (sample mean is greater)</li>
          <li><strong>Left-tailed:</strong> μ < μ₀ (sample mean is less)</li>
        </ul>
      </li>
    </ul>

    <h4>Interpreting Results</h4>
    <ul>
      <li><strong>If p-value ≤ α:</strong> Reject H₀ (statistically significant difference)</li>
      <li><strong>If p-value > α:</strong> Fail to reject H₀ (no significant difference)</li>
      <li><strong>Common α levels:</strong> 0.05 (95% confidence), 0.01 (99% confidence), 0.10 (90% confidence)</li>
    </ul>

    <h4>Assumptions</h4>
    <ul>
      <li><strong>Normality:</strong> Data should be approximately normally distributed (less critical for large samples due to Central Limit Theorem)</li>
      <li><strong>Independence:</strong> Observations should be independent</li>
      <li><strong>Equal Variances:</strong> Required for standard two-sample t-test (use Welch's if violated)</li>
      <li><strong>Random Sampling:</strong> Data should come from random samples</li>
    </ul>

    <h4>Real-World Applications</h4>
    <ul>
      <li><strong>Medicine:</strong> Compare treatment effects (drug vs. placebo)</li>
      <li><strong>Psychology:</strong> Test differences in behavior or cognition</li>
      <li><strong>Education:</strong> Compare teaching methods or test scores</li>
      <li><strong>Business:</strong> A/B testing, comparing sales strategies</li>
      <li><strong>Agriculture:</strong> Compare crop yields under different conditions</li>
      <li><strong>Quality Control:</strong> Test if manufacturing process meets specifications</li>
    </ul>

    <h4>Effect Size</h4>
    <p>Beyond statistical significance, consider <strong>Cohen's d</strong> to measure practical significance:</p>
    <div class="formula-box">
      d = (x̄₁ - x̄₂) / s_pooled
    </div>
    <ul>
      <li><strong>Small effect:</strong> |d| ≈ 0.2</li>
      <li><strong>Medium effect:</strong> |d| ≈ 0.5</li>
      <li><strong>Large effect:</strong> |d| ≈ 0.8</li>
    </ul>

    <div class="info-box">
      <i class="fas fa-lightbulb"></i>
      <strong>Tip:</strong> Always check assumptions before running a t-test. If data are not normally distributed and sample size is small, consider non-parametric alternatives like the Mann-Whitney U test or Wilcoxon signed-rank test.
    </div>
  </div>
</div>

<%@ include file="thanks.jsp"%>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

<script>
  let tDistChart = null;

  function parseDataString(str) {
    return str.trim().split(/[,\s]+/).map(x => parseFloat(x)).filter(x => !isNaN(x));
  }

  function mean(arr) {
    return arr.reduce((a, b) => a + b, 0) / arr.length;
  }

  function variance(arr, ddof = 0) {
    const m = mean(arr);
    const sumSq = arr.reduce((sum, x) => sum + Math.pow(x - m, 2), 0);
    return sumSq / (arr.length - ddof);
  }

  function stdDev(arr, ddof = 0) {
    return Math.sqrt(variance(arr, ddof));
  }

  function calculateTTest() {
    const activeTab = document.querySelector('#testTabs .nav-link.active').id;

    try {
      if (activeTab === 'one-sample-tab') {
        calculateOneSampleTTest();
      } else if (activeTab === 'two-sample-tab') {
        calculateTwoSampleTTest();
      } else if (activeTab === 'paired-tab') {
        calculatePairedTTest();
      } else if (activeTab === 'welch-tab') {
        calculateWelchTTest();
      }
    } catch (error) {
      alert('Error: ' + error.message);
    }
  }

  function calculateOneSampleTTest() {
    const data = parseDataString(document.getElementById('oneSampleData').value);
    const mu0 = parseFloat(document.getElementById('populationMean').value);
    const alpha = parseFloat(document.getElementById('oneSampleAlpha').value);
    const alternative = document.getElementById('oneSampleAlt').value;

    if (data.length < 2) throw new Error('Need at least 2 data points');
    if (isNaN(mu0)) throw new Error('Invalid population mean');

    const n = data.length;
    const xbar = mean(data);
    const s = stdDev(data, 1);
    const se = s / Math.sqrt(n);
    const t = (xbar - mu0) / se;
    const df = n - 1;

    // Calculate p-value
    let pValue;
    if (alternative === 'two-tailed') {
      pValue = 2 * (1 - jStat.studentt.cdf(Math.abs(t), df));
    } else if (alternative === 'greater') {
      pValue = 1 - jStat.studentt.cdf(t, df);
    } else {
      pValue = jStat.studentt.cdf(t, df);
    }

    // Critical value
    const criticalValue = alternative === 'two-tailed'
      ? jStat.studentt.inv(1 - alpha/2, df)
      : jStat.studentt.inv(1 - alpha, df);

    // Confidence interval
    const tCrit = jStat.studentt.inv(1 - alpha/2, df);
    const margin = tCrit * se;
    const ciLower = xbar - margin;
    const ciUpper = xbar + margin;

    displayResults({
      testType: 'One-Sample T-Test',
      t: t,
      df: df,
      pValue: pValue,
      alpha: alpha,
      alternative: alternative,
      mean: xbar,
      sd: s,
      n: n,
      criticalValue: criticalValue,
      ciLower: ciLower,
      ciUpper: ciUpper,
      significant: pValue < alpha
    });

    drawTDistribution(t, df, alternative, criticalValue);
  }

  function calculateTwoSampleTTest() {
    const data1 = parseDataString(document.getElementById('group1Data').value);
    const data2 = parseDataString(document.getElementById('group2Data').value);
    const alpha = parseFloat(document.getElementById('twoSampleAlpha').value);
    const alternative = document.getElementById('twoSampleAlt').value;

    if (data1.length < 2 || data2.length < 2) throw new Error('Need at least 2 data points in each group');

    const n1 = data1.length;
    const n2 = data2.length;
    const m1 = mean(data1);
    const m2 = mean(data2);
    const v1 = variance(data1, 1);
    const v2 = variance(data2, 1);

    // Pooled variance
    const pooledVar = ((n1 - 1) * v1 + (n2 - 1) * v2) / (n1 + n2 - 2);
    const se = Math.sqrt(pooledVar * (1/n1 + 1/n2));
    const t = (m1 - m2) / se;
    const df = n1 + n2 - 2;

    // Calculate p-value
    let pValue;
    if (alternative === 'two-tailed') {
      pValue = 2 * (1 - jStat.studentt.cdf(Math.abs(t), df));
    } else if (alternative === 'greater') {
      pValue = 1 - jStat.studentt.cdf(t, df);
    } else {
      pValue = jStat.studentt.cdf(t, df);
    }

    // Critical value
    const criticalValue = alternative === 'two-tailed'
      ? jStat.studentt.inv(1 - alpha/2, df)
      : jStat.studentt.inv(1 - alpha, df);

    // Confidence interval for difference
    const tCrit = jStat.studentt.inv(1 - alpha/2, df);
    const margin = tCrit * se;
    const diffMeans = m1 - m2;
    const ciLower = diffMeans - margin;
    const ciUpper = diffMeans + margin;

    displayResults({
      testType: 'Two-Sample Independent T-Test',
      t: t,
      df: df,
      pValue: pValue,
      alpha: alpha,
      alternative: alternative,
      mean1: m1,
      mean2: m2,
      n1: n1,
      n2: n2,
      criticalValue: criticalValue,
      ciLower: ciLower,
      ciUpper: ciUpper,
      significant: pValue < alpha
    });

    drawTDistribution(t, df, alternative, criticalValue);
  }

  function calculatePairedTTest() {
    const before = parseDataString(document.getElementById('pairedBefore').value);
    const after = parseDataString(document.getElementById('pairedAfter').value);
    const alpha = parseFloat(document.getElementById('pairedAlpha').value);
    const alternative = document.getElementById('pairedAlt').value;

    if (before.length !== after.length) throw new Error('Before and After data must have same length');
    if (before.length < 2) throw new Error('Need at least 2 pairs');

    // Calculate differences
    const differences = before.map((b, i) => b - after[i]);
    const n = differences.length;
    const dbar = mean(differences);
    const sd = stdDev(differences, 1);
    const se = sd / Math.sqrt(n);
    const t = dbar / se;
    const df = n - 1;

    // Calculate p-value
    let pValue;
    if (alternative === 'two-tailed') {
      pValue = 2 * (1 - jStat.studentt.cdf(Math.abs(t), df));
    } else if (alternative === 'greater') {
      pValue = 1 - jStat.studentt.cdf(t, df);
    } else {
      pValue = jStat.studentt.cdf(t, df);
    }

    // Critical value
    const criticalValue = alternative === 'two-tailed'
      ? jStat.studentt.inv(1 - alpha/2, df)
      : jStat.studentt.inv(1 - alpha, df);

    // Confidence interval
    const tCrit = jStat.studentt.inv(1 - alpha/2, df);
    const margin = tCrit * se;
    const ciLower = dbar - margin;
    const ciUpper = dbar + margin;

    displayResults({
      testType: 'Paired T-Test',
      t: t,
      df: df,
      pValue: pValue,
      alpha: alpha,
      alternative: alternative,
      meanDiff: dbar,
      sdDiff: sd,
      n: n,
      criticalValue: criticalValue,
      ciLower: ciLower,
      ciUpper: ciUpper,
      significant: pValue < alpha
    });

    drawTDistribution(t, df, alternative, criticalValue);
  }

  function calculateWelchTTest() {
    const data1 = parseDataString(document.getElementById('welchGroup1Data').value);
    const data2 = parseDataString(document.getElementById('welchGroup2Data').value);
    const alpha = parseFloat(document.getElementById('welchAlpha').value);
    const alternative = document.getElementById('welchAlt').value;

    if (data1.length < 2 || data2.length < 2) throw new Error('Need at least 2 data points in each group');

    const n1 = data1.length;
    const n2 = data2.length;
    const m1 = mean(data1);
    const m2 = mean(data2);
    const v1 = variance(data1, 1);
    const v2 = variance(data2, 1);

    // Welch's t-statistic
    const se = Math.sqrt(v1/n1 + v2/n2);
    const t = (m1 - m2) / se;

    // Welch-Satterthwaite degrees of freedom
    const df = Math.pow(v1/n1 + v2/n2, 2) /
               (Math.pow(v1/n1, 2)/(n1-1) + Math.pow(v2/n2, 2)/(n2-1));

    // Calculate p-value
    let pValue;
    if (alternative === 'two-tailed') {
      pValue = 2 * (1 - jStat.studentt.cdf(Math.abs(t), df));
    } else if (alternative === 'greater') {
      pValue = 1 - jStat.studentt.cdf(t, df);
    } else {
      pValue = jStat.studentt.cdf(t, df);
    }

    // Critical value
    const criticalValue = alternative === 'two-tailed'
      ? jStat.studentt.inv(1 - alpha/2, df)
      : jStat.studentt.inv(1 - alpha, df);

    // Confidence interval
    const tCrit = jStat.studentt.inv(1 - alpha/2, df);
    const margin = tCrit * se;
    const diffMeans = m1 - m2;
    const ciLower = diffMeans - margin;
    const ciUpper = diffMeans + margin;

    displayResults({
      testType: "Welch's T-Test (Unequal Variances)",
      t: t,
      df: df,
      pValue: pValue,
      alpha: alpha,
      alternative: alternative,
      mean1: m1,
      mean2: m2,
      n1: n1,
      n2: n2,
      criticalValue: criticalValue,
      ciLower: ciLower,
      ciUpper: ciUpper,
      significant: pValue < alpha
    });

    drawTDistribution(t, df, alternative, criticalValue);
  }

  function displayResults(results) {
    let html = `
      <div class="result-item">
        <div class="result-label">${results.testType}</div>
      </div>

      <div class="result-item">
        <div class="result-label">T-Statistic</div>
        <div class="result-value">${results.t.toFixed(4)}</div>
      </div>

      <div class="result-item">
        <div class="result-label">Degrees of Freedom</div>
        <div class="result-value">${results.df.toFixed(2)}</div>
      </div>

      <div class="result-item">
        <div class="result-label">P-Value</div>
        <div class="result-value">${results.pValue.toFixed(6)}</div>
        <div class="interpretation">
          ${results.significant
            ? `<strong style="color: #dc2626;">Significant!</strong> p < α (${results.alpha}). Reject null hypothesis.`
            : `<strong style="color: #16a34a;">Not Significant.</strong> p ≥ α (${results.alpha}). Fail to reject null hypothesis.`
          }
        </div>
      </div>

      <div class="result-item">
        <div class="result-label">Critical Value (${results.alternative})</div>
        <div class="result-value">±${Math.abs(results.criticalValue).toFixed(4)}</div>
      </div>

      <div class="result-item">
        <div class="result-label">${(1 - results.alpha) * 100}% Confidence Interval</div>
        <div class="result-value">[${results.ciLower.toFixed(4)}, ${results.ciUpper.toFixed(4)}]</div>
      </div>
    `;

    if (results.mean !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Sample Mean</div>
          <div class="result-value">${results.mean.toFixed(4)}</div>
        </div>
      `;
    }

    if (results.mean1 !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Mean Difference (μ₁ - μ₂)</div>
          <div class="result-value">${(results.mean1 - results.mean2).toFixed(4)}</div>
        </div>
      `;
    }

    if (results.meanDiff !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Mean Difference</div>
          <div class="result-value">${results.meanDiff.toFixed(4)}</div>
        </div>
      `;
    }

    document.getElementById('resultsContent').innerHTML = html;
  }

  function drawTDistribution(tStat, df, alternative, criticalValue) {
    const container = document.getElementById('resultsContent');

    let canvas = document.getElementById('tDistribution');
    if (!canvas) {
      const chartHtml = `
        <div class="chart-container">
          <h5 style="color: var(--primary-color); margin-bottom: 1rem; font-size: 0.95rem;">
            <i class="fas fa-chart-area"></i> T-Distribution (df = ${df.toFixed(1)})
          </h5>
          <canvas id="tDistribution"></canvas>
        </div>
      `;
      container.insertAdjacentHTML('beforeend', chartHtml);
      canvas = document.getElementById('tDistribution');
    }

    if (tDistChart) {
      tDistChart.destroy();
    }

    // Generate t-distribution curve
    const xValues = [];
    const yValues = [];
    const range = Math.max(5, Math.abs(tStat) + 2);

    for (let x = -range; x <= range; x += 0.1) {
      xValues.push(x);
      yValues.push(jStat.studentt.pdf(x, df));
    }

    // Create shaded regions based on alternative hypothesis
    let datasets = [{
      label: 'T-Distribution',
      data: yValues,
      borderColor: 'rgba(245, 158, 11, 1)',
      borderWidth: 2,
      fill: false,
      pointRadius: 0
    }];

    // Add shaded rejection regions
    if (alternative === 'two-tailed') {
      const leftReject = xValues.map((x, i) => x <= -Math.abs(criticalValue) ? yValues[i] : null);
      const rightReject = xValues.map((x, i) => x >= Math.abs(criticalValue) ? yValues[i] : null);

      datasets.push({
        label: 'Rejection Region',
        data: leftReject,
        backgroundColor: 'rgba(239, 68, 68, 0.3)',
        borderColor: 'rgba(239, 68, 68, 1)',
        borderWidth: 0,
        fill: true,
        pointRadius: 0
      });

      datasets.push({
        label: 'Rejection Region',
        data: rightReject,
        backgroundColor: 'rgba(239, 68, 68, 0.3)',
        borderColor: 'rgba(239, 68, 68, 1)',
        borderWidth: 0,
        fill: true,
        pointRadius: 0,
        showInLegend: false
      });
    } else if (alternative === 'greater') {
      const rightReject = xValues.map((x, i) => x >= criticalValue ? yValues[i] : null);
      datasets.push({
        label: 'Rejection Region',
        data: rightReject,
        backgroundColor: 'rgba(239, 68, 68, 0.3)',
        borderColor: 'rgba(239, 68, 68, 1)',
        borderWidth: 0,
        fill: true,
        pointRadius: 0
      });
    } else {
      const leftReject = xValues.map((x, i) => x <= -criticalValue ? yValues[i] : null);
      datasets.push({
        label: 'Rejection Region',
        data: leftReject,
        backgroundColor: 'rgba(239, 68, 68, 0.3)',
        borderColor: 'rgba(239, 68, 68, 1)',
        borderWidth: 0,
        fill: true,
        pointRadius: 0
      });
    }

    tDistChart = new Chart(canvas, {
      type: 'line',
      data: {
        labels: xValues,
        datasets: datasets
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 1.5,
        plugins: {
          legend: {
            position: 'top',
            labels: {
              boxWidth: 12,
              font: { size: 10 },
              filter: function(item) {
                return item.text !== undefined;
              }
            }
          },
          title: {
            display: true,
            text: `T-Distribution (t = ${tStat.toFixed(3)}, df = ${df.toFixed(1)})`,
            font: { size: 11, weight: 'bold' }
          },
          annotation: {
            annotations: {
              line1: {
                type: 'line',
                xMin: tStat,
                xMax: tStat,
                borderColor: 'rgba(16, 185, 129, 0.8)',
                borderWidth: 2,
                label: {
                  display: true,
                  content: `t = ${tStat.toFixed(3)}`,
                  position: 'top'
                }
              }
            }
          }
        },
        scales: {
          x: {
            title: {
              display: true,
              text: 't-value',
              font: { size: 10, weight: 'bold' }
            },
            ticks: { font: { size: 9 } }
          },
          y: {
            title: {
              display: true,
              text: 'Density',
              font: { size: 10, weight: 'bold' }
            },
            ticks: { font: { size: 9 } }
          }
        }
      }
    });
  }
</script>
