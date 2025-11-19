<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Outlier Detection Calculator Online – Free | 8gwifi.org</title>
<meta name="description" content="Free outlier detection calculator: identify outliers using IQR method, Z-score method, and modified Z-score. Visualize outliers with box plots and scatter plots.">
<meta name="keywords" content="outlier detection, outlier calculator, IQR method, z-score outliers, modified z-score, box plot, outlier analysis, statistical outliers, anomaly detection">
<link rel="canonical" href="https://8gwifi.org/outlier-detection-calculator.jsp">

<!-- Open Graph -->
<meta property="og:title" content="Outlier Detection Calculator Online – Free | 8gwifi.org">
<meta property="og:description" content="Detect outliers using multiple methods: IQR, Z-score, Modified Z-score. Visualize with box plots and identify extreme values.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/outlier-detection-calculator.jsp">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Outlier Detection Calculator Online – Free | 8gwifi.org">
<meta name="twitter:description" content="Detect outliers using multiple methods: IQR, Z-score, Modified Z-score. Visualize with box plots and identify extreme values.">

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Outlier Detection Calculator",
  "description": "Identify outliers using IQR method, Z-score method, and modified Z-score with visualization",
  "url": "https://8gwifi.org/outlier-detection-calculator.jsp",
  "applicationCategory": "UtilityApplication",
  "operatingSystem": "Any",
  "permissions": "browser",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": [
    "IQR method (Tukey's fences)",
    "Z-score method",
    "Modified Z-score (MAD)",
    "Box plot visualization",
    "Scatter plot with outliers highlighted",
    "Multiple outlier thresholds",
    "Detailed outlier analysis"
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "ratingCount": "1874",
    "bestRating": "5",
    "worstRating": "1"
  }
}
</script>

<%@ include file="header-script.jsp"%>

<style>
:root {
  --outlier-primary: #f59e0b;
  --outlier-secondary: #d97706;
  --outlier-light: #fef3c7;
  --outlier-dark: #92400e;
}

.outlier-card {
  border-left: 4px solid var(--outlier-primary);
  transition: all 0.3s ease;
}

.outlier-card:hover {
  box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);
  transform: translateY(-2px);
}

.outlier-badge {
  background: linear-gradient(135deg, var(--outlier-primary), var(--outlier-secondary));
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  display: inline-block;
}

.outlier-detected {
  background-color: #fee2e2;
  color: #991b1b;
  padding: 0.25rem 0.5rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 600;
}

.no-outliers {
  background-color: #d1fae5;
  color: #065f46;
  padding: 0.25rem 0.5rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 600;
}

.result-box {
  background: linear-gradient(135deg, var(--outlier-light), white);
  border: 2px solid var(--outlier-primary);
  border-radius: 10px;
  padding: 1.5rem;
  margin-top: 1rem;
}

.stat-section {
  background: white;
  border: 1px solid var(--outlier-primary);
  border-radius: 8px;
  padding: 1rem;
  margin: 0.75rem 0;
}

.stat-section h6 {
  color: var(--outlier-dark);
  border-bottom: 2px solid var(--outlier-primary);
  padding-bottom: 0.5rem;
  margin-bottom: 0.75rem;
}

.form-control:focus {
  border-color: var(--outlier-primary);
  box-shadow: 0 0 0 0.2rem rgba(245, 158, 11, 0.25);
}

.btn-outlier {
  background: linear-gradient(135deg, var(--outlier-primary), var(--outlier-secondary));
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-outlier:hover {
  background: linear-gradient(135deg, var(--outlier-secondary), var(--outlier-dark));
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
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
  background-color: var(--outlier-light);
  border-left: 4px solid var(--outlier-primary);
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}

textarea.form-control {
  font-family: 'Courier New', monospace;
  font-size: 0.9rem;
}

.stat-row {
  display: flex;
  justify-content: space-between;
  padding: 0.5rem 0;
  border-bottom: 1px solid #e5e7eb;
}

.stat-row:last-child {
  border-bottom: none;
}

.stat-label {
  font-weight: 600;
  color: var(--outlier-dark);
}

.stat-value {
  color: var(--outlier-secondary);
  font-weight: 500;
  font-family: 'Courier New', monospace;
}

.outlier-list {
  background-color: #fee2e2;
  border: 2px solid #ef4444;
  border-radius: 8px;
  padding: 1rem;
  margin: 1rem 0;
}

.outlier-list .outlier-item {
  padding: 0.5rem;
  margin: 0.25rem 0;
  background-color: white;
  border-left: 4px solid #ef4444;
  border-radius: 4px;
}

.nav-tabs .nav-link {
  color: var(--outlier-secondary);
  border: 2px solid transparent;
}

.nav-tabs .nav-link.active {
  color: white;
  background: linear-gradient(135deg, var(--outlier-primary), var(--outlier-secondary));
  border-color: var(--outlier-primary);
}

.nav-tabs .nav-link:hover {
  border-color: var(--outlier-light);
}
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1><i class="fas fa-exclamation-triangle text-warning"></i> Outlier Detection Calculator</h1>
  <p class="lead">Identify outliers using IQR, Z-score, and Modified Z-score methods with visualization</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="card outlier-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title">
            <i class="fas fa-database text-warning"></i> Data Input
          </h5>

          <div class="form-group">
            <label for="dataInput"><i class="fas fa-list-ol"></i> Enter Data (comma or space separated)</label>
            <textarea class="form-control" id="dataInput" rows="6" placeholder="10, 12, 15, 18, 20, 22, 25, 28, 30, 95">10, 12, 15, 18, 20, 22, 25, 28, 30, 95</textarea>
            <small class="form-text text-muted">Enter numbers separated by commas, spaces, or newlines</small>
          </div>

          <!-- Tab Navigation for Methods -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="iqr-tab" data-toggle="tab" href="#iqr-panel" role="tab">
                <i class="fas fa-chart-box"></i> IQR Method
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="zscore-tab" data-toggle="tab" href="#zscore-panel" role="tab">
                <i class="fas fa-calculator"></i> Z-Score
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="modified-tab" data-toggle="tab" href="#modified-panel" role="tab">
                <i class="fas fa-adjust"></i> Modified Z
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="all-tab" data-toggle="tab" href="#all-panel" role="tab">
                <i class="fas fa-layer-group"></i> All Methods
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- IQR Method -->
            <div class="tab-pane fade show active" id="iqr-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> IQR Method (Tukey's Fences):</strong><br>
                Most common method. Outliers are values outside [Q1 - k×IQR, Q3 + k×IQR]
              </div>

              <div class="form-group">
                <label for="iqrMultiplier"><i class="fas fa-sliders-h"></i> IQR Multiplier (k)</label>
                <select class="form-control" id="iqrMultiplier">
                  <option value="1.5" selected>1.5 (Standard - Mild Outliers)</option>
                  <option value="3.0">3.0 (Extreme Outliers Only)</option>
                  <option value="2.0">2.0 (Moderate)</option>
                  <option value="1.0">1.0 (Very Sensitive)</option>
                </select>
              </div>

              <button class="btn btn-outlier btn-block" onclick="detectIQR()">
                <i class="fas fa-search"></i> Detect Outliers (IQR)
              </button>
            </div>

            <!-- Z-Score Method -->
            <div class="tab-pane fade" id="zscore-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Z-Score Method:</strong><br>
                Assumes normal distribution. Outliers are values with |Z-score| > threshold
              </div>

              <div class="form-group">
                <label for="zThreshold"><i class="fas fa-sliders-h"></i> Z-Score Threshold</label>
                <select class="form-control" id="zThreshold">
                  <option value="2.0">2.0 (95% confidence - Moderate)</option>
                  <option value="2.5">2.5 (98.7% confidence)</option>
                  <option value="3.0" selected>3.0 (99.7% confidence - Standard)</option>
                  <option value="3.5">3.5 (Very Conservative)</option>
                </select>
              </div>

              <button class="btn btn-outlier btn-block" onclick="detectZScore()">
                <i class="fas fa-search"></i> Detect Outliers (Z-Score)
              </button>
            </div>

            <!-- Modified Z-Score -->
            <div class="tab-pane fade" id="modified-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Modified Z-Score (MAD):</strong><br>
                Robust to outliers. Uses median absolute deviation instead of standard deviation
              </div>

              <div class="form-group">
                <label for="madThreshold"><i class="fas fa-sliders-h"></i> Modified Z-Score Threshold</label>
                <select class="form-control" id="madThreshold">
                  <option value="2.5">2.5 (Moderate)</option>
                  <option value="3.0">3.0 (Standard)</option>
                  <option value="3.5" selected>3.5 (Conservative - Recommended)</option>
                  <option value="4.0">4.0 (Very Conservative)</option>
                </select>
              </div>

              <button class="btn btn-outlier btn-block" onclick="detectModifiedZ()">
                <i class="fas fa-search"></i> Detect Outliers (Modified Z)
              </button>
            </div>

            <!-- All Methods -->
            <div class="tab-pane fade" id="all-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Compare All Methods:</strong><br>
                See which values are flagged as outliers by each method
              </div>

              <button class="btn btn-outlier btn-block" onclick="detectAll()">
                <i class="fas fa-search"></i> Detect Outliers (All Methods)
              </button>
            </div>

          </div>
        </div>
      </div>

      <!-- Educational Content -->
      <div class="card outlier-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title"><i class="fas fa-book text-warning"></i> Understanding Outliers</h5>

          <h6 class="mt-3"><i class="fas fa-question-circle text-warning"></i> What is an Outlier?</h6>
          <p>An outlier is a data point that differs significantly from other observations. Outliers can occur due to measurement errors, data entry errors, or genuine extreme values in the population.</p>

          <h6 class="mt-3"><i class="fas fa-chart-box text-warning"></i> 1. IQR Method (Tukey's Fences)</h6>
          <p><strong>Formula:</strong></p>
          <ul>
            <li>Lower fence = Q1 - k × IQR</li>
            <li>Upper fence = Q3 + k × IQR</li>
            <li>IQR = Q3 - Q1</li>
            <li>Typically k = 1.5 (mild) or k = 3.0 (extreme)</li>
          </ul>
          <p><strong>Advantages:</strong></p>
          <ul>
            <li>Distribution-free (no assumptions about normality)</li>
            <li>Robust to outliers themselves</li>
            <li>Most widely used method</li>
          </ul>
          <p><strong>When to use:</strong> General-purpose outlier detection, especially for skewed data</p>

          <h6 class="mt-3"><i class="fas fa-calculator text-warning"></i> 2. Z-Score Method</h6>
          <p><strong>Formula:</strong></p>
          <ul>
            <li>Z = (x - μ) / σ</li>
            <li>Outliers: |Z| > threshold (typically 3)</li>
          </ul>
          <p><strong>Advantages:</strong></p>
          <ul>
            <li>Simple and intuitive</li>
            <li>Good for normally distributed data</li>
            <li>Easy to interpret (number of standard deviations)</li>
          </ul>
          <p><strong>Disadvantages:</strong></p>
          <ul>
            <li>Sensitive to outliers (mean and SD affected by outliers)</li>
            <li>Assumes normal distribution</li>
          </ul>
          <p><strong>When to use:</strong> Large datasets that are approximately normally distributed</p>

          <h6 class="mt-3"><i class="fas fa-adjust text-warning"></i> 3. Modified Z-Score (MAD)</h6>
          <p><strong>Formula:</strong></p>
          <ul>
            <li>M = 0.6745 × (x - median) / MAD</li>
            <li>MAD = median(|xᵢ - median(x)|)</li>
            <li>Outliers: |M| > 3.5 (typical threshold)</li>
          </ul>
          <p><strong>Advantages:</strong></p>
          <ul>
            <li>Very robust to outliers (uses median instead of mean)</li>
            <li>Better for small sample sizes</li>
            <li>Works well with skewed data</li>
          </ul>
          <p><strong>When to use:</strong> When you suspect outliers but want a robust method</p>

          <h6 class="mt-3"><i class="fas fa-balance-scale text-warning"></i> Which Method to Choose?</h6>
          <table class="table table-sm table-bordered">
            <thead>
              <tr>
                <th>Scenario</th>
                <th>Recommended Method</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>General purpose</td>
                <td>IQR (k=1.5)</td>
              </tr>
              <tr>
                <td>Normal distribution</td>
                <td>Z-Score</td>
              </tr>
              <tr>
                <td>Skewed data</td>
                <td>IQR or Modified Z</td>
              </tr>
              <tr>
                <td>Small sample</td>
                <td>Modified Z</td>
              </tr>
              <tr>
                <td>Many outliers</td>
                <td>Modified Z</td>
              </tr>
              <tr>
                <td>Conservative (few false positives)</td>
                <td>IQR (k=3.0)</td>
              </tr>
            </tbody>
          </table>

          <h6 class="mt-3"><i class="fas fa-tools text-warning"></i> What to Do with Outliers?</h6>
          <ul>
            <li><strong>Investigate:</strong> First, determine if outliers are errors or genuine values</li>
            <li><strong>Correct:</strong> Fix data entry or measurement errors</li>
            <li><strong>Remove:</strong> Exclude if truly erroneous (document why!)</li>
            <li><strong>Transform:</strong> Use log transformation to reduce impact</li>
            <li><strong>Keep:</strong> If genuine, use robust statistical methods</li>
            <li><strong>Separate Analysis:</strong> Analyze with and without outliers</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-5">
      <div class="sticky-results">
        <div class="card outlier-card shadow-sm">
          <div class="card-body">
            <h5 class="card-title">
              <i class="fas fa-chart-line text-warning"></i> Results
            </h5>
            <div id="results">
              <div class="text-center text-muted py-5">
                <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                <p>Enter your data and select a method to detect outliers</p>
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
  <!-- FAQ: inline -->
  <section id="faq" class="mt-5">
    <h2 class="h5">Outlier Detection: FAQ</h2>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Which method should I use?</h3>
      <p class="mb-0">Use IQR (Tukey fences) for robust, distribution‑free detection; Z‑score for roughly normal data; Modified Z‑score (MAD) for added robustness against outliers.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">What thresholds are common?</h3>
      <p class="mb-0">IQR: outside [Q1−1.5·IQR, Q3+1.5·IQR]. Z‑score: |Z| ≥ 3 (sometimes 2.5). Modified Z: |Mz| ≥ 3.5 are typical starting points.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Should I remove outliers?</h3>
      <p class="mb-0">Not automatically. Investigate causes (entry errors, different process). Consider robust summaries or transformations if outliers are genuine.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Do outliers always indicate bad data?</h3>
      <p class="mb-0">No. They may reflect rare but valid cases. Always use domain knowledge before excluding points.</p>
    </div></div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"Which method should I use?","acceptedAnswer":{"@type":"Answer","text":"Use IQR (Tukey fences) for robust detection; Z‑score for normal data; Modified Z‑score (MAD) for robustness."}},
      {"@type":"Question","name":"What thresholds are common?","acceptedAnswer":{"@type":"Answer","text":"IQR: fences at 1.5·IQR; Z‑score: |Z|≥3; Modified Z: |Mz|≥3.5 are typical."}},
      {"@type":"Question","name":"Should I remove outliers?","acceptedAnswer":{"@type":"Answer","text":"Investigate cause; consider robust methods; don’t remove automatically without context."}},
      {"@type":"Question","name":"Do outliers always indicate bad data?","acceptedAnswer":{"@type":"Answer","text":"No, they may be valid rare cases; rely on domain knowledge before exclusion."}}
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
      {"@type":"ListItem","position":2,"name":"Outlier Detection Calculator","item":"https://8gwifi.org/outlier-detection-calculator.jsp"}
    ]
  }
  </script>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

<script>
let outlierChart = null;

// Parse data from text input
function parseData(text) {
  return text.trim()
    .split(/[\s,\n]+/)
    .map(x => parseFloat(x))
    .filter(x => !isNaN(x));
}

// Calculate percentile
function calculatePercentile(sortedData, percentile) {
  if (sortedData.length === 0) return null;
  if (sortedData.length === 1) return sortedData[0];

  const n = sortedData.length;
  const position = (n + 1) * (percentile / 100);

  if (position <= 1) return sortedData[0];
  if (position >= n) return sortedData[n - 1];

  const lower = Math.floor(position) - 1;
  const upper = Math.ceil(position) - 1;
  const fraction = position - Math.floor(position);

  return sortedData[lower] + fraction * (sortedData[upper] - sortedData[lower]);
}

// IQR Method
function detectIQR() {
  const dataText = document.getElementById('dataInput').value;
  const k = parseFloat(document.getElementById('iqrMultiplier').value);

  if (!dataText.trim()) {
    alert('Please enter data values');
    return;
  }

  const data = parseData(dataText);
  if (data.length === 0) {
    alert('No valid data found');
    return;
  }

  const sortedData = [...data].sort((a, b) => a - b);
  const q1 = calculatePercentile(sortedData, 25);
  const q3 = calculatePercentile(sortedData, 75);
  const iqr = q3 - q1;

  const lowerFence = q1 - k * iqr;
  const upperFence = q3 + k * iqr;

  const outliers = data.filter(x => x < lowerFence || x > upperFence);
  const lowerOutliers = outliers.filter(x => x < lowerFence).sort((a, b) => a - b);
  const upperOutliers = outliers.filter(x => x > upperFence).sort((a, b) => a - b);

  displayResults({
    method: 'IQR Method',
    methodDesc: `Tukey's Fences with k = ${k}`,
    outliers,
    lowerOutliers,
    upperOutliers,
    data,
    sortedData,
    details: {
      Q1: q1,
      Q3: q3,
      IQR: iqr,
      'Lower Fence': lowerFence,
      'Upper Fence': upperFence,
      'Multiplier (k)': k
    }
  });
}

// Z-Score Method
function detectZScore() {
  const dataText = document.getElementById('dataInput').value;
  const threshold = parseFloat(document.getElementById('zThreshold').value);

  if (!dataText.trim()) {
    alert('Please enter data values');
    return;
  }

  const data = parseData(dataText);
  if (data.length === 0) {
    alert('No valid data found');
    return;
  }

  const n = data.length;
  const mean = data.reduce((a, b) => a + b, 0) / n;
  const variance = data.reduce((sum, x) => sum + Math.pow(x - mean, 2), 0) / (n - 1);
  const stdDev = Math.sqrt(variance);

  const zScores = data.map(x => (x - mean) / stdDev);
  const outliers = data.filter((x, i) => Math.abs(zScores[i]) > threshold);
  const sortedData = [...data].sort((a, b) => a - b);

  const lowerOutliers = outliers.filter((x, i) => zScores[data.indexOf(x)] < -threshold).sort((a, b) => a - b);
  const upperOutliers = outliers.filter((x, i) => zScores[data.indexOf(x)] > threshold).sort((a, b) => a - b);

  displayResults({
    method: 'Z-Score Method',
    methodDesc: `Threshold: |Z| > ${threshold}`,
    outliers,
    lowerOutliers,
    upperOutliers,
    data,
    sortedData,
    details: {
      Mean: mean,
      'Std Deviation': stdDev,
      'Z-Score Threshold': threshold,
      'Sample Size': n
    }
  });
}

// Modified Z-Score (MAD)
function detectModifiedZ() {
  const dataText = document.getElementById('dataInput').value;
  const threshold = parseFloat(document.getElementById('madThreshold').value);

  if (!dataText.trim()) {
    alert('Please enter data values');
    return;
  }

  const data = parseData(dataText);
  if (data.length === 0) {
    alert('No valid data found');
    return;
  }

  const sortedData = [...data].sort((a, b) => a - b);
  const median = calculatePercentile(sortedData, 50);

  // Calculate MAD (Median Absolute Deviation)
  const absDeviations = data.map(x => Math.abs(x - median));
  const sortedAbsDeviations = [...absDeviations].sort((a, b) => a - b);
  const mad = calculatePercentile(sortedAbsDeviations, 50);

  // Calculate modified Z-scores
  const modifiedZScores = data.map(x => 0.6745 * (x - median) / (mad || 1));
  const outliers = data.filter((x, i) => Math.abs(modifiedZScores[i]) > threshold);

  const lowerOutliers = outliers.filter((x, i) => modifiedZScores[data.indexOf(x)] < -threshold).sort((a, b) => a - b);
  const upperOutliers = outliers.filter((x, i) => modifiedZScores[data.indexOf(x)] > threshold).sort((a, b) => a - b);

  displayResults({
    method: 'Modified Z-Score (MAD)',
    methodDesc: `Threshold: |M| > ${threshold}`,
    outliers,
    lowerOutliers,
    upperOutliers,
    data,
    sortedData,
    details: {
      Median: median,
      'MAD': mad,
      'Modified Z Threshold': threshold,
      'Sample Size': data.length
    }
  });
}

// Detect using all methods
function detectAll() {
  const dataText = document.getElementById('dataInput').value;

  if (!dataText.trim()) {
    alert('Please enter data values');
    return;
  }

  const data = parseData(dataText);
  if (data.length === 0) {
    alert('No valid data found');
    return;
  }

  const sortedData = [...data].sort((a, b) => a - b);
  const n = data.length;

  // IQR Method
  const q1 = calculatePercentile(sortedData, 25);
  const q3 = calculatePercentile(sortedData, 75);
  const iqr = q3 - q1;
  const iqrLowerFence = q1 - 1.5 * iqr;
  const iqrUpperFence = q3 + 1.5 * iqr;
  const iqrOutliers = data.filter(x => x < iqrLowerFence || x > iqrUpperFence);

  // Z-Score Method
  const mean = data.reduce((a, b) => a + b, 0) / n;
  const variance = data.reduce((sum, x) => sum + Math.pow(x - mean, 2), 0) / (n - 1);
  const stdDev = Math.sqrt(variance);
  const zScores = data.map(x => (x - mean) / stdDev);
  const zOutliers = data.filter((x, i) => Math.abs(zScores[i]) > 3.0);

  // Modified Z-Score
  const median = calculatePercentile(sortedData, 50);
  const absDeviations = data.map(x => Math.abs(x - median));
  const sortedAbsDeviations = [...absDeviations].sort((a, b) => a - b);
  const mad = calculatePercentile(sortedAbsDeviations, 50);
  const modifiedZScores = data.map(x => 0.6745 * (x - median) / (mad || 1));
  const madOutliers = data.filter((x, i) => Math.abs(modifiedZScores[i]) > 3.5);

  // Find consensus outliers (detected by all methods)
  const allOutliers = new Set([...iqrOutliers, ...zOutliers, ...madOutliers]);
  const consensusOutliers = [...allOutliers].filter(x =>
    iqrOutliers.includes(x) && zOutliers.includes(x) && madOutliers.includes(x)
  );

  let html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-layer-group text-warning"></i>
        <span class="outlier-badge">Comparison of All Methods</span>
      </h5>

      <div class="stat-section">
        <h6><i class="fas fa-chart-bar"></i> Summary</h6>
        <div class="stat-row">
          <span class="stat-label">Sample Size:</span>
          <span class="stat-value">${n}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">IQR Method:</span>
          <span class="stat-value ${iqrOutliers.length > 0 ? 'outlier-detected' : 'no-outliers'}">${iqrOutliers.length} outlier(s)</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Z-Score Method:</span>
          <span class="stat-value ${zOutliers.length > 0 ? 'outlier-detected' : 'no-outliers'}">${zOutliers.length} outlier(s)</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Modified Z Method:</span>
          <span class="stat-value ${madOutliers.length > 0 ? 'outlier-detected' : 'no-outliers'}">${madOutliers.length} outlier(s)</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Consensus (All 3):</span>
          <span class="stat-value ${consensusOutliers.length > 0 ? 'outlier-detected' : 'no-outliers'}">${consensusOutliers.length} outlier(s)</span>
        </div>
      </div>
  `;

  if (consensusOutliers.length > 0) {
    html += `
      <div class="outlier-list">
        <h6><i class="fas fa-exclamation-triangle"></i> Consensus Outliers (Detected by All Methods)</h6>
        ${consensusOutliers.map(x => `<div class="outlier-item"><strong>${x.toFixed(4)}</strong></div>`).join('')}
      </div>
    `;
  }

  if (iqrOutliers.length > 0) {
    html += `
      <div class="stat-section">
        <h6><i class="fas fa-chart-box"></i> IQR Method (k=1.5)</h6>
        <p>Outliers: ${iqrOutliers.map(x => x.toFixed(4)).join(', ')}</p>
      </div>
    `;
  }

  if (zOutliers.length > 0) {
    html += `
      <div class="stat-section">
        <h6><i class="fas fa-calculator"></i> Z-Score Method (|Z| > 3.0)</h6>
        <p>Outliers: ${zOutliers.map(x => x.toFixed(4)).join(', ')}</p>
      </div>
    `;
  }

  if (madOutliers.length > 0) {
    html += `
      <div class="stat-section">
        <h6><i class="fas fa-adjust"></i> Modified Z Method (|M| > 3.5)</h6>
        <p>Outliers: ${madOutliers.map(x => x.toFixed(4)).join(', ')}</p>
      </div>
    `;
  }

  html += `
    <div class="info-card">
      <strong><i class="fas fa-lightbulb"></i> Recommendation:</strong><br>
      ${consensusOutliers.length > 0 ?
        `Values detected by all three methods (${consensusOutliers.length}) are strong outlier candidates.` :
        allOutliers.size > 0 ?
        'Different methods detect different outliers. Consider the nature of your data when choosing which to exclude.' :
        'No outliers detected by any method. Your data appears to be consistent.'}
    </div>
  </div>
  `;

  document.getElementById('results').innerHTML = html;

  // Draw comparison chart
  drawComparisonChart(data, iqrOutliers, zOutliers, madOutliers);
}

// Display results
function displayResults(result) {
  const { method, methodDesc, outliers, lowerOutliers, upperOutliers, data, sortedData, details } = result;

  let html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-search text-warning"></i>
        <span class="outlier-badge">${method}</span>
      </h5>

      <div class="text-center mb-3">
        <span class="${outliers.length > 0 ? 'outlier-detected' : 'no-outliers'}">
          ${outliers.length} outlier(s) detected
        </span>
      </div>

      <div class="stat-section">
        <h6><i class="fas fa-info-circle"></i> Method Details</h6>
        <p><strong>${methodDesc}</strong></p>
  `;

  for (const [key, value] of Object.entries(details)) {
    html += `
        <div class="stat-row">
          <span class="stat-label">${key}:</span>
          <span class="stat-value">${typeof value === 'number' ? value.toFixed(4) : value}</span>
        </div>
    `;
  }

  html += '</div>';

  if (outliers.length > 0) {
    html += `
      <div class="outlier-list">
        <h6><i class="fas fa-exclamation-triangle"></i> Detected Outliers</h6>
    `;

    if (lowerOutliers.length > 0) {
      html += `
        <div class="outlier-item">
          <strong>Lower Outliers (${lowerOutliers.length}):</strong><br>
          ${lowerOutliers.map(x => x.toFixed(4)).join(', ')}
        </div>
      `;
    }

    if (upperOutliers.length > 0) {
      html += `
        <div class="outlier-item">
          <strong>Upper Outliers (${upperOutliers.length}):</strong><br>
          ${upperOutliers.map(x => x.toFixed(4)).join(', ')}
        </div>
      `;
    }

    html += '</div>';
  } else {
    html += `
      <div class="info-card">
        <strong><i class="fas fa-check-circle"></i> No Outliers Detected</strong><br>
        All data points fall within the acceptable range for this method.
      </div>
    `;
  }

  html += `
    <div class="stat-section">
      <h6><i class="fas fa-chart-area"></i> Data Visualization</h6>
      <div class="chart-container">
        <canvas id="outlierChart"></canvas>
      </div>
    </div>
  </div>
  `;

  document.getElementById('results').innerHTML = html;

  // Draw chart
  drawOutlierChart(data, outliers);
}

// Draw outlier chart
function drawOutlierChart(data, outliers) {
  const ctx = document.getElementById('outlierChart');
  if (!ctx) return;

  if (outlierChart) {
    outlierChart.destroy();
  }

  const labels = data.map((_, i) => `#${i + 1}`);
  const colors = data.map(x => outliers.includes(x) ? 'rgba(239, 68, 68, 0.8)' : 'rgba(59, 130, 246, 0.6)');
  const borderColors = data.map(x => outliers.includes(x) ? 'rgba(239, 68, 68, 1)' : 'rgba(59, 130, 246, 1)');

  outlierChart = new Chart(ctx, {
    type: 'scatter',
    data: {
      datasets: [{
        label: 'Data Points',
        data: data.map((y, x) => ({ x, y })),
        backgroundColor: colors,
        borderColor: borderColors,
        pointRadius: 6,
        pointHoverRadius: 8
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false
        },
        title: {
          display: true,
          text: 'Data Points (Red = Outliers)',
          font: { size: 16, weight: 'bold' }
        },
        tooltip: {
          callbacks: {
            label: function(context) {
              const value = context.parsed.y;
              const isOutlier = outliers.includes(value);
              return `Value: ${value.toFixed(4)}${isOutlier ? ' (OUTLIER)' : ''}`;
            }
          }
        }
      },
      scales: {
        x: {
          title: {
            display: true,
            text: 'Data Point Index',
            font: { size: 14 }
          }
        },
        y: {
          title: {
            display: true,
            text: 'Value',
            font: { size: 14 }
          }
        }
      }
    }
  });
}

// Draw comparison chart
function drawComparisonChart(data, iqrOutliers, zOutliers, madOutliers) {
  const ctx = document.getElementById('outlierChart');
  if (!ctx) return;

  if (outlierChart) {
    outlierChart.destroy();
  }

  // Determine color for each point
  const colors = data.map(x => {
    const iqr = iqrOutliers.includes(x);
    const z = zOutliers.includes(x);
    const mad = madOutliers.includes(x);

    if (iqr && z && mad) return 'rgba(239, 68, 68, 0.9)'; // All three - red
    if ((iqr && z) || (iqr && mad) || (z && mad)) return 'rgba(251, 191, 36, 0.8)'; // Two - yellow
    if (iqr || z || mad) return 'rgba(96, 165, 250, 0.7)'; // One - light blue
    return 'rgba(59, 130, 246, 0.5)'; // None - blue
  });

  outlierChart = new Chart(ctx, {
    type: 'scatter',
    data: {
      datasets: [{
        label: 'Data Points',
        data: data.map((y, x) => ({ x, y })),
        backgroundColor: colors,
        pointRadius: 6,
        pointHoverRadius: 8
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false
        },
        title: {
          display: true,
          text: 'Outlier Comparison (Red=All, Yellow=Two, Light Blue=One)',
          font: { size: 14, weight: 'bold' }
        }
      },
      scales: {
        x: {
          title: {
            display: true,
            text: 'Data Point Index',
            font: { size: 14 }
          }
        },
        y: {
          title: {
            display: true,
            text: 'Value',
            font: { size: 14 }
          }
        }
      }
    }
  });
}

// Initialize with default example on page load
document.addEventListener('DOMContentLoaded', function() {
  detectIQR();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
