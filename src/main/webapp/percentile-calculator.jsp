<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Percentile Calculator Online – Free | 8gwifi.org</title>
<meta name="description" content="Free percentile calculator: calculate percentile rank, find values at percentiles, quartiles (Q1, Q2, Q3), IQR, five-number summary, and visualize with box plots. Perfect for test scores, salaries, and rankings.">
<meta name="keywords" content="percentile calculator, quartile calculator, percentile rank, IQR calculator, box plot, five number summary, Q1 Q2 Q3, test score percentile, salary percentile, statistics calculator">
<link rel="canonical" href="https://8gwifi.org/percentile-calculator.jsp">

<!-- Open Graph -->
<meta property="og:title" content="Percentile Calculator Online – Free | 8gwifi.org">
<meta property="og:description" content="Calculate percentile rank, quartiles, IQR, and visualize with box plots. Essential for analyzing test scores, salaries, and rankings.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/percentile-calculator.jsp">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Percentile Calculator Online – Free | 8gwifi.org">
<meta name="twitter:description" content="Calculate percentile rank, quartiles, IQR, and visualize with box plots. Essential for analyzing test scores, salaries, and rankings.">

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Percentile Calculator",
  "description": "Calculate percentile rank, find values at percentiles, quartiles, IQR, five-number summary, and visualize with box plots",
  "url": "https://8gwifi.org/percentile-calculator.jsp",
  "applicationCategory": "UtilityApplication",
  "operatingSystem": "Any",
  "permissions": "browser",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": [
    "Percentile rank calculation (value to percentile)",
    "Value at percentile calculation (percentile to value)",
    "Quartiles (Q1, Q2/median, Q3)",
    "Interquartile Range (IQR)",
    "Five-number summary",
    "Box plot visualization",
    "Outlier detection",
    "Descriptive statistics"
  ]
}
</script>

<%@ include file="header-script.jsp"%>

<style>
:root {
  --percentile-primary: #10b981;
  --percentile-secondary: #059669;
  --percentile-light: #d1fae5;
  --percentile-dark: #065f46;
}

.percentile-card {
  border-left: 4px solid var(--percentile-primary);
  transition: all 0.3s ease;
}

.percentile-card:hover {
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
  transform: translateY(-2px);
}

.percentile-badge {
  background: linear-gradient(135deg, var(--percentile-primary), var(--percentile-secondary));
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  display: inline-block;
}

.result-box {
  background: linear-gradient(135deg, var(--percentile-light), white);
  border: 2px solid var(--percentile-primary);
  border-radius: 10px;
  padding: 1.5rem;
  margin-top: 1rem;
}

.quartile-box {
  background: white;
  border: 1px solid var(--percentile-primary);
  border-radius: 8px;
  padding: 1rem;
  margin: 0.5rem 0;
}

.outlier-badge {
  background-color: #ef4444;
  color: white;
  padding: 0.25rem 0.5rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
}

.form-control:focus {
  border-color: var(--percentile-primary);
  box-shadow: 0 0 0 0.2rem rgba(16, 185, 129, 0.25);
}

.btn-percentile {
  background: linear-gradient(135deg, var(--percentile-primary), var(--percentile-secondary));
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-percentile:hover {
  background: linear-gradient(135deg, var(--percentile-secondary), var(--percentile-dark));
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

.chart-container {
  position: relative;
  height: 300px;
  margin: 1rem 0;
}

.nav-tabs .nav-link {
  color: var(--percentile-secondary);
  border: 2px solid transparent;
}

.nav-tabs .nav-link.active {
  color: white;
  background: linear-gradient(135deg, var(--percentile-primary), var(--percentile-secondary));
  border-color: var(--percentile-primary);
}

.nav-tabs .nav-link:hover {
  border-color: var(--percentile-light);
}

.info-card {
  background-color: var(--percentile-light);
  border-left: 4px solid var(--percentile-primary);
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

.stat-label {
  font-weight: 600;
  color: var(--percentile-dark);
}

.stat-value {
  color: var(--percentile-secondary);
  font-weight: 500;
}
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1><i class="fas fa-chart-box text-success"></i> Percentile Calculator</h1>
  <p class="lead">Calculate percentile rank, quartiles, IQR, and visualize with box plots</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="card percentile-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title">
            <i class="fas fa-list-ol text-success"></i> Data Input
          </h5>

          <!-- Tab Navigation -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="rank-tab" data-toggle="tab" href="#rank-panel" role="tab">
                <i class="fas fa-percentage"></i> Find Percentile Rank
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="value-tab" data-toggle="tab" href="#value-panel" role="tab">
                <i class="fas fa-search"></i> Find Value at Percentile
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="summary-tab" data-toggle="tab" href="#summary-panel" role="tab">
                <i class="fas fa-chart-bar"></i> Full Summary
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- Find Percentile Rank -->
            <div class="tab-pane fade show active" id="rank-panel" role="tabpanel">
              <div class="form-group">
                <label for="rankData"><i class="fas fa-database"></i> Enter Data (comma or space separated)</label>
                <textarea class="form-control" id="rankData" rows="4" placeholder="85, 90, 78, 92, 88, 76, 95, 82, 87, 91">85, 90, 78, 92, 88, 76, 95, 82, 87, 91</textarea>
                <small class="form-text text-muted">Enter numbers separated by commas or spaces</small>
              </div>

              <div class="form-group">
                <label for="rankValue"><i class="fas fa-bullseye"></i> Value to Find Rank For</label>
                <input type="number" class="form-control" id="rankValue" value="88" step="any">
                <small class="form-text text-muted">What percentile is this value at?</small>
              </div>

              <button class="btn btn-percentile btn-block" onclick="calculateRank()">
                <i class="fas fa-calculator"></i> Calculate Percentile Rank
              </button>
            </div>

            <!-- Find Value at Percentile -->
            <div class="tab-pane fade" id="value-panel" role="tabpanel">
              <div class="form-group">
                <label for="valueData"><i class="fas fa-database"></i> Enter Data (comma or space separated)</label>
                <textarea class="form-control" id="valueData" rows="4" placeholder="85, 90, 78, 92, 88, 76, 95, 82, 87, 91">85, 90, 78, 92, 88, 76, 95, 82, 87, 91</textarea>
                <small class="form-text text-muted">Enter numbers separated by commas or spaces</small>
              </div>

              <div class="form-group">
                <label for="valuePercentile"><i class="fas fa-percentage"></i> Target Percentile (0-100)</label>
                <input type="number" class="form-control" id="valuePercentile" value="75" min="0" max="100" step="0.1">
                <small class="form-text text-muted">Find the value at this percentile (e.g., 75th percentile)</small>
              </div>

              <button class="btn btn-percentile btn-block" onclick="calculateValue()">
                <i class="fas fa-search"></i> Find Value at Percentile
              </button>
            </div>

            <!-- Full Summary -->
            <div class="tab-pane fade" id="summary-panel" role="tabpanel">
              <div class="form-group">
                <label for="summaryData"><i class="fas fa-database"></i> Enter Data (comma or space separated)</label>
                <textarea class="form-control" id="summaryData" rows="6" placeholder="85, 90, 78, 92, 88, 76, 95, 82, 87, 91">85, 90, 78, 92, 88, 76, 95, 82, 87, 91</textarea>
                <small class="form-text text-muted">Enter numbers separated by commas or spaces</small>
              </div>

              <button class="btn btn-percentile btn-block" onclick="calculateSummary()">
                <i class="fas fa-chart-bar"></i> Calculate Full Summary
              </button>
            </div>

          </div>
        </div>
      </div>

      <!-- Educational Content -->
      <div class="card percentile-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title"><i class="fas fa-book text-success"></i> Understanding Percentiles</h5>

          <h6 class="mt-3"><i class="fas fa-question-circle text-success"></i> What is a Percentile?</h6>
          <p>A percentile is a value below which a certain percentage of observations fall. For example, if you scored in the 75th percentile on a test, you scored better than 75% of test takers.</p>

          <h6 class="mt-3"><i class="fas fa-cube text-success"></i> Quartiles (Q1, Q2, Q3)</h6>
          <ul>
            <li><strong>Q1 (25th percentile):</strong> The first quartile - 25% of data falls below this value</li>
            <li><strong>Q2 (50th percentile):</strong> The median - the middle value that divides data in half</li>
            <li><strong>Q3 (75th percentile):</strong> The third quartile - 75% of data falls below this value</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-arrows-alt-h text-success"></i> Interquartile Range (IQR)</h6>
          <p><strong>IQR = Q3 - Q1</strong></p>
          <p>The IQR measures the spread of the middle 50% of the data. It's resistant to outliers and is commonly used to identify outliers:</p>
          <ul>
            <li><strong>Lower Outlier:</strong> Value &lt; Q1 - 1.5×IQR</li>
            <li><strong>Upper Outlier:</strong> Value &gt; Q3 + 1.5×IQR</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-chart-box text-success"></i> Five-Number Summary</h6>
          <p>A concise summary of data distribution consisting of:</p>
          <ol>
            <li><strong>Minimum:</strong> The smallest value (excluding outliers)</li>
            <li><strong>Q1:</strong> The 25th percentile</li>
            <li><strong>Median (Q2):</strong> The 50th percentile</li>
            <li><strong>Q3:</strong> The 75th percentile</li>
            <li><strong>Maximum:</strong> The largest value (excluding outliers)</li>
          </ol>

          <h6 class="mt-3"><i class="fas fa-lightbulb text-success"></i> Common Applications</h6>
          <ul>
            <li><strong>Test Scores:</strong> SAT, GRE, IQ tests report percentile ranks</li>
            <li><strong>Salary Comparison:</strong> Compare your salary to industry standards</li>
            <li><strong>Growth Charts:</strong> Track children's height/weight percentiles</li>
            <li><strong>Performance Metrics:</strong> Rank employees, students, or athletes</li>
            <li><strong>Quality Control:</strong> Identify outliers in manufacturing</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-calculator text-success"></i> Calculation Methods</h6>
          <p>This calculator uses the <strong>linear interpolation</strong> method (Excel/R method):</p>
          <div class="info-card">
            <strong>Percentile Position:</strong> P = (n + 1) × (percentile / 100)<br>
            <strong>Where:</strong>
            <ul class="mb-0 mt-2">
              <li>n = number of data points</li>
              <li>If P is a whole number, use that position's value</li>
              <li>If P is fractional, interpolate between adjacent values</li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-5">
      <div class="sticky-results">
        <div class="card percentile-card shadow-sm">
          <div class="card-body">
            <h5 class="card-title">
              <i class="fas fa-chart-line text-success"></i> Results
            </h5>
            <div id="results">
              <div class="text-center text-muted py-5">
                <i class="fas fa-chart-box fa-3x mb-3"></i>
                <p>Enter your data and click calculate to see results</p>
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
  <!-- FAQ: inlined (was jspf/faq/math/percentile-calculator-faq.jspf) -->
  <section id="faq" class="mt-5">
    <h2 class="h5">Percentile Calculator: FAQ</h2>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Percentile vs percentile rank?</h3>
      <p class="mb-0">A percentile (e.g., 90th) is the value below which a given percentage of observations fall; percentile rank is the percentage position of a given value within the data.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How is the value at a percentile computed?</h3>
      <p class="mb-0">Data are sorted ascending; index is typically (p/100)·(n+1). If non‑integer, interpolate. Methods vary; we use a common linear interpolation approach.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How are quartiles and IQR related?</h3>
      <p class="mb-0">Quartiles split data into four equal parts: Q1 (25th), Q2/median (50th), Q3 (75th). IQR = Q3 − Q1 is a robust spread measure used for outlier detection.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How are outliers flagged?</h3>
      <p class="mb-0">A common rule flags values below Q1 − 1.5·IQR or above Q3 + 1.5·IQR as potential outliers. Context matters — not all flagged points are errors.</p>
    </div></div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"Percentile vs percentile rank?","acceptedAnswer":{"@type":"Answer","text":"A percentile is the value below which a given percentage of observations fall; percentile rank is the percentage position of a given value within the data."}},
      {"@type":"Question","name":"How is the value at a percentile computed?","acceptedAnswer":{"@type":"Answer","text":"Data are sorted; index (p/100)·(n+1). Interpolate if non‑integer. Methods vary; we use linear interpolation."}},
      {"@type":"Question","name":"How are quartiles and IQR related?","acceptedAnswer":{"@type":"Answer","text":"Quartiles are 25th, 50th, 75th percentiles. IQR = Q3 − Q1, a robust spread used for outliers."}},
      {"@type":"Question","name":"How are outliers flagged?","acceptedAnswer":{"@type":"Answer","text":"Values outside Q1 − 1.5·IQR to Q3 + 1.5·IQR are often flagged. Domain context is important."}}
    ]
  }
  </script>
  <!-- Breadcrumbs: inlined (was jspf/breadcrumbs/math/percentile-calculator-breadcrumbs.jspf) -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"Percentile Calculator","item":"https://8gwifi.org/percentile-calculator.jsp"}
    ]
  }
  </script>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

<script>
let boxPlotChart = null;

// Parse data from text input
function parseData(text) {
  return text.trim()
    .split(/[\s,]+/)
    .map(x => parseFloat(x))
    .filter(x => !isNaN(x));
}

// Calculate percentile using linear interpolation (Excel/R method)
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

// Calculate percentile rank for a given value
function getPercentileRank(sortedData, value) {
  const n = sortedData.length;
  let below = 0;
  let equal = 0;

  for (let i = 0; i < n; i++) {
    if (sortedData[i] < value) below++;
    else if (sortedData[i] === value) equal++;
  }

  // Use midpoint formula for percentile rank
  return ((below + 0.5 * equal) / n) * 100;
}

// Calculate quartiles and five-number summary
function calculateQuartiles(sortedData) {
  return {
    min: sortedData[0],
    q1: calculatePercentile(sortedData, 25),
    median: calculatePercentile(sortedData, 50),
    q3: calculatePercentile(sortedData, 75),
    max: sortedData[sortedData.length - 1]
  };
}

// Identify outliers using IQR method
function findOutliers(sortedData, q1, q3) {
  const iqr = q3 - q1;
  const lowerFence = q1 - 1.5 * iqr;
  const upperFence = q3 + 1.5 * iqr;

  return {
    lower: sortedData.filter(x => x < lowerFence),
    upper: sortedData.filter(x => x > upperFence),
    lowerFence,
    upperFence
  };
}

// Calculate descriptive statistics
function calculateStats(data) {
  const n = data.length;
  const sum = data.reduce((a, b) => a + b, 0);
  const mean = sum / n;

  const variance = data.reduce((sum, x) => sum + Math.pow(x - mean, 2), 0) / (n - 1);
  const stdDev = Math.sqrt(variance);

  return { n, mean, stdDev, variance };
}

// Find Percentile Rank
function calculateRank() {
  const dataText = document.getElementById('rankData').value;
  const value = parseFloat(document.getElementById('rankValue').value);

  if (!dataText.trim()) {
    alert('Please enter data values');
    return;
  }

  if (isNaN(value)) {
    alert('Please enter a valid value');
    return;
  }

  const data = parseData(dataText);
  if (data.length === 0) {
    alert('No valid data found');
    return;
  }

  const sortedData = [...data].sort((a, b) => a - b);
  const rank = getPercentileRank(sortedData, value);
  const quartiles = calculateQuartiles(sortedData);
  const stats = calculateStats(data);

  // Determine which quartile the value falls into
  let quartileInfo = '';
  if (value < quartiles.q1) {
    quartileInfo = '<span class="percentile-badge">Below Q1 (Bottom 25%)</span>';
  } else if (value < quartiles.median) {
    quartileInfo = '<span class="percentile-badge">Between Q1 and Median (25th-50th)</span>';
  } else if (value < quartiles.q3) {
    quartileInfo = '<span class="percentile-badge">Between Median and Q3 (50th-75th)</span>';
  } else {
    quartileInfo = '<span class="percentile-badge">Above Q3 (Top 25%)</span>';
  }

  const html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-trophy text-warning"></i>
        <span class="percentile-badge" style="font-size: 1.5rem;">${rank.toFixed(2)}th Percentile</span>
      </h5>

      <div class="text-center mb-3">
        ${quartileInfo}
      </div>

      <div class="quartile-box">
        <div class="stat-row">
          <span class="stat-label">Your Value:</span>
          <span class="stat-value">${value.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Percentile Rank:</span>
          <span class="stat-value">${rank.toFixed(2)}%</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Better Than:</span>
          <span class="stat-value">${rank.toFixed(1)}% of values</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Worse Than:</span>
          <span class="stat-value">${(100 - rank).toFixed(1)}% of values</span>
        </div>
      </div>

      <h6 class="mt-3"><i class="fas fa-chart-bar"></i> Reference Quartiles</h6>
      <div class="quartile-box">
        <div class="stat-row">
          <span class="stat-label">Minimum:</span>
          <span class="stat-value">${quartiles.min.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Q1 (25th):</span>
          <span class="stat-value">${quartiles.q1.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Median (50th):</span>
          <span class="stat-value">${quartiles.median.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Q3 (75th):</span>
          <span class="stat-value">${quartiles.q3.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Maximum:</span>
          <span class="stat-value">${quartiles.max.toFixed(2)}</span>
        </div>
      </div>

      <h6 class="mt-3"><i class="fas fa-info-circle"></i> Dataset Statistics</h6>
      <div class="quartile-box">
        <div class="stat-row">
          <span class="stat-label">Sample Size (n):</span>
          <span class="stat-value">${stats.n}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Mean (Average):</span>
          <span class="stat-value">${stats.mean.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Std Deviation:</span>
          <span class="stat-value">${stats.stdDev.toFixed(2)}</span>
        </div>
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Find Value at Percentile
function calculateValue() {
  const dataText = document.getElementById('valueData').value;
  const percentile = parseFloat(document.getElementById('valuePercentile').value);

  if (!dataText.trim()) {
    alert('Please enter data values');
    return;
  }

  if (isNaN(percentile) || percentile < 0 || percentile > 100) {
    alert('Please enter a valid percentile between 0 and 100');
    return;
  }

  const data = parseData(dataText);
  if (data.length === 0) {
    alert('No valid data found');
    return;
  }

  const sortedData = [...data].sort((a, b) => a - b);
  const value = calculatePercentile(sortedData, percentile);
  const quartiles = calculateQuartiles(sortedData);
  const stats = calculateStats(data);

  // Count values below and above
  const below = sortedData.filter(x => x < value).length;
  const above = sortedData.filter(x => x > value).length;

  const html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-bullseye text-warning"></i>
        <span class="percentile-badge" style="font-size: 1.5rem;">${value.toFixed(2)}</span>
      </h5>

      <div class="text-center mb-3">
        <span class="percentile-badge">At ${percentile}th Percentile</span>
      </div>

      <div class="quartile-box">
        <div class="stat-row">
          <span class="stat-label">Target Percentile:</span>
          <span class="stat-value">${percentile}%</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Value at Percentile:</span>
          <span class="stat-value">${value.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Values Below:</span>
          <span class="stat-value">${below} (${((below/stats.n)*100).toFixed(1)}%)</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Values Above:</span>
          <span class="stat-value">${above} (${((above/stats.n)*100).toFixed(1)}%)</span>
        </div>
      </div>

      <h6 class="mt-3"><i class="fas fa-chart-bar"></i> Reference Quartiles</h6>
      <div class="quartile-box">
        <div class="stat-row">
          <span class="stat-label">Minimum:</span>
          <span class="stat-value">${quartiles.min.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Q1 (25th):</span>
          <span class="stat-value">${quartiles.q1.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Median (50th):</span>
          <span class="stat-value">${quartiles.median.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Q3 (75th):</span>
          <span class="stat-value">${quartiles.q3.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Maximum:</span>
          <span class="stat-value">${quartiles.max.toFixed(2)}</span>
        </div>
      </div>

      <div class="info-card mt-3">
        <i class="fas fa-info-circle"></i> <strong>Interpretation:</strong><br>
        ${percentile}% of values in the dataset are below ${value.toFixed(2)}, and ${(100-percentile)}% are above it.
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Calculate Full Summary with Box Plot
function calculateSummary() {
  const dataText = document.getElementById('summaryData').value;

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
  const quartiles = calculateQuartiles(sortedData);
  const stats = calculateStats(data);
  const iqr = quartiles.q3 - quartiles.q1;
  const outliers = findOutliers(sortedData, quartiles.q1, quartiles.q3);

  const outlierBadges = outliers.lower.length + outliers.upper.length > 0 ?
    `<span class="outlier-badge">${outliers.lower.length + outliers.upper.length} outlier(s)</span>` : '';

  let html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-chart-box text-warning"></i>
        Five-Number Summary ${outlierBadges}
      </h5>

      <div class="quartile-box">
        <div class="stat-row">
          <span class="stat-label">Minimum:</span>
          <span class="stat-value">${quartiles.min.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Q1 (25th percentile):</span>
          <span class="stat-value">${quartiles.q1.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Median (50th percentile):</span>
          <span class="stat-value">${quartiles.median.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Q3 (75th percentile):</span>
          <span class="stat-value">${quartiles.q3.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Maximum:</span>
          <span class="stat-value">${quartiles.max.toFixed(2)}</span>
        </div>
      </div>

      <h6 class="mt-3"><i class="fas fa-arrows-alt-h"></i> Spread Measures</h6>
      <div class="quartile-box">
        <div class="stat-row">
          <span class="stat-label">Range:</span>
          <span class="stat-value">${(quartiles.max - quartiles.min).toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">IQR (Q3 - Q1):</span>
          <span class="stat-value">${iqr.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Lower Fence:</span>
          <span class="stat-value">${outliers.lowerFence.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Upper Fence:</span>
          <span class="stat-value">${outliers.upperFence.toFixed(2)}</span>
        </div>
      </div>

      <h6 class="mt-3"><i class="fas fa-calculator"></i> Descriptive Statistics</h6>
      <div class="quartile-box">
        <div class="stat-row">
          <span class="stat-label">Sample Size (n):</span>
          <span class="stat-value">${stats.n}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Mean:</span>
          <span class="stat-value">${stats.mean.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Std Deviation:</span>
          <span class="stat-value">${stats.stdDev.toFixed(2)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Variance:</span>
          <span class="stat-value">${stats.variance.toFixed(2)}</span>
        </div>
      </div>
  `;

  if (outliers.lower.length > 0 || outliers.upper.length > 0) {
    html += `
      <h6 class="mt-3"><i class="fas fa-exclamation-triangle text-danger"></i> Outliers Detected</h6>
      <div class="quartile-box">
    `;

    if (outliers.lower.length > 0) {
      html += `
        <div class="stat-row">
          <span class="stat-label">Lower Outliers:</span>
          <span class="stat-value">${outliers.lower.map(x => x.toFixed(2)).join(', ')}</span>
        </div>
      `;
    }

    if (outliers.upper.length > 0) {
      html += `
        <div class="stat-row">
          <span class="stat-label">Upper Outliers:</span>
          <span class="stat-value">${outliers.upper.map(x => x.toFixed(2)).join(', ')}</span>
        </div>
      `;
    }

    html += '</div>';
  }

  html += `
      <h6 class="mt-3"><i class="fas fa-chart-box"></i> Box Plot Visualization</h6>
      <div class="chart-container">
        <canvas id="boxPlotChart"></canvas>
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;

  // Draw box plot
  drawBoxPlot(sortedData, quartiles, outliers);
}

// Draw box plot using Chart.js
function drawBoxPlot(sortedData, quartiles, outliers) {
  const ctx = document.getElementById('boxPlotChart');
  if (!ctx) return;

  if (boxPlotChart) {
    boxPlotChart.destroy();
  }

  // Prepare box plot data points
  const boxData = [
    { x: 1, y: quartiles.min },
    { x: 1, y: quartiles.q1 },
    { x: 1, y: quartiles.median },
    { x: 1, y: quartiles.q3 },
    { x: 1, y: quartiles.max }
  ];

  // Prepare outlier points
  const allOutliers = [...outliers.lower, ...outliers.upper];
  const outlierData = allOutliers.map(y => ({ x: 1, y }));

  boxPlotChart = new Chart(ctx, {
    type: 'scatter',
    data: {
      datasets: [
        {
          label: 'Box',
          data: [
            { x: 0.8, y: quartiles.q1 },
            { x: 1.2, y: quartiles.q1 },
            { x: 1.2, y: quartiles.q3 },
            { x: 0.8, y: quartiles.q3 },
            { x: 0.8, y: quartiles.q1 }
          ],
          borderColor: 'rgb(16, 185, 129)',
          backgroundColor: 'rgba(16, 185, 129, 0.1)',
          borderWidth: 2,
          showLine: true,
          fill: true,
          pointRadius: 0
        },
        {
          label: 'Median',
          data: [
            { x: 0.8, y: quartiles.median },
            { x: 1.2, y: quartiles.median }
          ],
          borderColor: 'rgb(5, 150, 105)',
          borderWidth: 3,
          showLine: true,
          pointRadius: 0
        },
        {
          label: 'Whiskers',
          data: [
            { x: 1, y: quartiles.min },
            { x: 1, y: quartiles.q1 },
            { x: null, y: null },
            { x: 1, y: quartiles.q3 },
            { x: 1, y: quartiles.max }
          ],
          borderColor: 'rgb(16, 185, 129)',
          borderWidth: 2,
          showLine: true,
          pointRadius: 0
        },
        {
          label: 'Min/Max',
          data: [
            { x: 0.9, y: quartiles.min },
            { x: 1.1, y: quartiles.min },
            { x: null, y: null },
            { x: 0.9, y: quartiles.max },
            { x: 1.1, y: quartiles.max }
          ],
          borderColor: 'rgb(16, 185, 129)',
          borderWidth: 2,
          showLine: true,
          pointRadius: 0
        },
        {
          label: 'Outliers',
          data: outlierData,
          backgroundColor: 'rgb(239, 68, 68)',
          borderColor: 'rgb(239, 68, 68)',
          pointRadius: 6,
          pointStyle: 'circle'
        }
      ]
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
          text: 'Box Plot',
          font: { size: 16, weight: 'bold' }
        },
        tooltip: {
          callbacks: {
            title: function(context) {
              if (context[0].datasetIndex === 4) return 'Outlier';
              if (context[0].datasetIndex === 1) return 'Median';
              return '';
            },
            label: function(context) {
              return 'Value: ' + context.parsed.y.toFixed(2);
            }
          }
        }
      },
      scales: {
        x: {
          display: false,
          min: 0.5,
          max: 1.5
        },
        y: {
          title: {
            display: true,
            text: 'Value',
            font: { size: 14 }
          },
          grid: {
            color: 'rgba(0, 0, 0, 0.1)'
          }
        }
      }
    }
  });
}

// Initialize with default example on page load
document.addEventListener('DOMContentLoaded', function() {
  calculateRank();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
