<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Variance Calculator - Sample & Population Variance | 8gwifi.org</title>
<meta name="description" content="Free variance calculator: calculate sample variance, population variance, standard deviation, and variance properties. Understand the relationship between variance and standard deviation.">
<meta name="keywords" content="variance calculator, sample variance, population variance, variance formula, standard deviation, variance analysis, statistical variance, variance calculation">
<link rel="canonical" href="https://8gwifi.org/variance-calculator.jsp">

<!-- Open Graph -->
<meta property="og:title" content="Variance Calculator - Sample & Population Variance">
<meta property="og:description" content="Calculate sample and population variance with step-by-step breakdown. Includes standard deviation, coefficient of variation, and visualization.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/variance-calculator.jsp">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Variance Calculator - Sample & Population Variance">
<meta name="twitter:description" content="Calculate sample and population variance with step-by-step breakdown. Includes standard deviation, coefficient of variation, and visualization.">

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Variance Calculator",
  "description": "Calculate sample variance, population variance, standard deviation, and understand variance properties with step-by-step explanations",
  "url": "https://8gwifi.org/variance-calculator.jsp",
  "applicationCategory": "UtilityApplication",
  "operatingSystem": "Any",
  "permissions": "browser",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": [
    "Sample variance (s²)",
    "Population variance (σ²)",
    "Standard deviation",
    "Coefficient of variation",
    "Step-by-step calculation",
    "Deviation visualization",
    "Sum of squares breakdown"
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "2156",
    "bestRating": "5",
    "worstRating": "1"
  }
}
</script>

<%@ include file="header-script.jsp"%>

<style>
:root {
  --variance-primary: #ec4899;
  --variance-secondary: #db2777;
  --variance-light: #fce7f3;
  --variance-dark: #9f1239;
}

.variance-card {
  border-left: 4px solid var(--variance-primary);
  transition: all 0.3s ease;
}

.variance-card:hover {
  box-shadow: 0 4px 12px rgba(236, 72, 153, 0.2);
  transform: translateY(-2px);
}

.variance-badge {
  background: linear-gradient(135deg, var(--variance-primary), var(--variance-secondary));
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  display: inline-block;
}

.result-box {
  background: linear-gradient(135deg, var(--variance-light), white);
  border: 2px solid var(--variance-primary);
  border-radius: 10px;
  padding: 1.5rem;
  margin-top: 1rem;
}

.stat-section {
  background: white;
  border: 1px solid var(--variance-primary);
  border-radius: 8px;
  padding: 1rem;
  margin: 0.75rem 0;
}

.stat-section h6 {
  color: var(--variance-dark);
  border-bottom: 2px solid var(--variance-primary);
  padding-bottom: 0.5rem;
  margin-bottom: 0.75rem;
}

.form-control:focus {
  border-color: var(--variance-primary);
  box-shadow: 0 0 0 0.2rem rgba(236, 72, 153, 0.25);
}

.btn-variance {
  background: linear-gradient(135deg, var(--variance-primary), var(--variance-secondary));
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-variance:hover {
  background: linear-gradient(135deg, var(--variance-secondary), var(--variance-dark));
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(236, 72, 153, 0.3);
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
  background-color: var(--variance-light);
  border-left: 4px solid var(--variance-primary);
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
  color: var(--variance-dark);
}

.stat-value {
  color: var(--variance-secondary);
  font-weight: 500;
  font-family: 'Courier New', monospace;
}

.formula-box {
  background-color: #f9fafb;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  padding: 1rem;
  font-family: 'Courier New', monospace;
  margin: 1rem 0;
  font-size: 0.95rem;
}

.steps-table {
  font-size: 0.9rem;
}

.steps-table th {
  background-color: var(--variance-primary);
  color: white;
}

.nav-tabs .nav-link {
  color: var(--variance-secondary);
  border: 2px solid transparent;
}

.nav-tabs .nav-link.active {
  color: white;
  background: linear-gradient(135deg, var(--variance-primary), var(--variance-secondary));
  border-color: var(--variance-primary);
}

.nav-tabs .nav-link:hover {
  border-color: var(--variance-light);
}
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1><i class="fas fa-wave-square text-danger"></i> Variance Calculator</h1>
  <p class="lead">Calculate sample and population variance, standard deviation, and coefficient of variation</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="card variance-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title">
            <i class="fas fa-database text-danger"></i> Data Input
          </h5>

          <!-- Tab Navigation -->
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="data-tab" data-toggle="tab" href="#data-panel" role="tab">
                <i class="fas fa-list-ol"></i> From Data
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="stats-tab" data-toggle="tab" href="#stats-panel" role="tab">
                <i class="fas fa-calculator"></i> From Statistics
              </a>
            </li>
          </ul>

          <!-- Tab Content -->
          <div class="tab-content">

            <!-- From Data -->
            <div class="tab-pane fade show active" id="data-panel" role="tabpanel">
              <div class="form-group">
                <label for="dataInput"><i class="fas fa-list-ol"></i> Enter Data (comma or space separated)</label>
                <textarea class="form-control" id="dataInput" rows="6" placeholder="12, 15, 18, 20, 22, 25, 28">12, 15, 18, 20, 22, 25, 28</textarea>
                <small class="form-text text-muted">Enter numbers separated by commas, spaces, or newlines</small>
              </div>

              <div class="form-group">
                <label><i class="fas fa-toggle-on"></i> Variance Type</label>
                <select class="form-control" id="dataVarianceType">
                  <option value="sample">Sample Variance (s² with n-1)</option>
                  <option value="population">Population Variance (σ² with n)</option>
                </select>
                <small class="form-text text-muted">Use sample variance for data from a sample; population variance for entire population</small>
              </div>

              <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="showSteps" checked>
                <label class="form-check-label" for="showSteps">
                  Show Step-by-Step Calculation
                </label>
              </div>

              <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="showChart" checked>
                <label class="form-check-label" for="showChart">
                  Show Deviation Chart
                </label>
              </div>

              <button class="btn btn-variance btn-block" onclick="calculateFromData()">
                <i class="fas fa-calculator"></i> Calculate Variance
              </button>
            </div>

            <!-- From Statistics -->
            <div class="tab-pane fade" id="stats-panel" role="tabpanel">
              <div class="info-card">
                <strong><i class="fas fa-info-circle"></i> Calculate variance from summary statistics</strong><br>
                Useful when you have mean and standard deviation but not raw data
              </div>

              <div class="form-group">
                <label for="statsMean"><i class="fas fa-calculator"></i> Mean (μ or x̄)</label>
                <input type="number" class="form-control" id="statsMean" value="20" step="any">
              </div>

              <div class="form-group">
                <label for="statsSD"><i class="fas fa-sigma"></i> Standard Deviation (σ or s)</label>
                <input type="number" class="form-control" id="statsSD" value="5" step="any" min="0">
              </div>

              <div class="form-group">
                <label for="statsN"><i class="fas fa-hashtag"></i> Sample Size (n)</label>
                <input type="number" class="form-control" id="statsN" value="30" min="1">
                <small class="form-text text-muted">Optional: Used for calculating standard error</small>
              </div>

              <button class="btn btn-variance btn-block" onclick="calculateFromStats()">
                <i class="fas fa-calculator"></i> Calculate from Statistics
              </button>
            </div>

          </div>
        </div>
      </div>

      <!-- Educational Content -->
      <div class="card variance-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title"><i class="fas fa-book text-danger"></i> Understanding Variance</h5>

          <h6 class="mt-3"><i class="fas fa-question-circle text-danger"></i> What is Variance?</h6>
          <p>Variance measures how spread out data is from the mean. It's the average of the squared deviations from the mean. Larger variance means more spread; smaller variance means data is clustered closer to the mean.</p>

          <h6 class="mt-3"><i class="fas fa-calculator text-danger"></i> Formulas</h6>

          <p><strong>Sample Variance (s²):</strong></p>
          <div class="formula-box">
s² = Σ(xᵢ - x̄)² / (n - 1)

Where:
- xᵢ = each value
- x̄ = sample mean
- n = sample size
- (n - 1) = Bessel's correction for unbiased estimate
          </div>

          <p><strong>Population Variance (σ²):</strong></p>
          <div class="formula-box">
σ² = Σ(xᵢ - μ)² / n

Where:
- xᵢ = each value
- μ = population mean
- n = population size
          </div>

          <h6 class="mt-3"><i class="fas fa-arrows-alt-h text-danger"></i> Sample vs. Population Variance</h6>
          <ul>
            <li><strong>Sample Variance (s²):</strong>
              <ul>
                <li>Uses (n - 1) in denominator (Bessel's correction)</li>
                <li>Provides unbiased estimate of population variance</li>
                <li>Use when working with a sample from larger population</li>
              </ul>
            </li>
            <li><strong>Population Variance (σ²):</strong>
              <ul>
                <li>Uses n in denominator</li>
                <li>Exact variance of the population</li>
                <li>Use when you have data for entire population</li>
              </ul>
            </li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-link text-danger"></i> Variance vs. Standard Deviation</h6>
          <ul>
            <li><strong>Variance (s² or σ²):</strong>
              <ul>
                <li>In squared units (e.g., dollars²)</li>
                <li>Mathematically convenient for calculations</li>
                <li>Used in ANOVA, regression analysis</li>
              </ul>
            </li>
            <li><strong>Standard Deviation (s or σ):</strong>
              <ul>
                <li>Square root of variance: σ = √(σ²)</li>
                <li>In original units (e.g., dollars)</li>
                <li>More intuitive for interpretation</li>
              </ul>
            </li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-percentage text-danger"></i> Coefficient of Variation (CV)</h6>
          <div class="formula-box">
CV = (σ / μ) × 100%

- Relative measure of variability
- Useful for comparing variation across different scales
- Dimensionless (unit-free)
          </div>

          <h6 class="mt-3"><i class="fas fa-lightbulb text-danger"></i> When to Use Variance</h6>
          <ul>
            <li><strong>Quality Control:</strong> Monitor process consistency</li>
            <li><strong>Finance:</strong> Measure investment risk (volatility)</li>
            <li><strong>ANOVA:</strong> Compare variance between/within groups</li>
            <li><strong>Regression:</strong> Partition variance explained by model</li>
            <li><strong>Hypothesis Testing:</strong> F-tests for equality of variances</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-exclamation-triangle text-danger"></i> Properties of Variance</h6>
          <ul>
            <li>Always non-negative (≥ 0)</li>
            <li>Variance of constant = 0</li>
            <li>Adding constant doesn't change variance</li>
            <li>Multiplying by constant scales variance by constant²</li>
            <li>Sensitive to outliers (uses squared deviations)</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-5">
      <div class="sticky-results">
        <div class="card variance-card shadow-sm">
          <div class="card-body">
            <h5 class="card-title">
              <i class="fas fa-chart-line text-danger"></i> Results
            </h5>
            <div id="results">
              <div class="text-center text-muted py-5">
                <i class="fas fa-wave-square fa-3x mb-3"></i>
                <p>Enter your data and click calculate to see variance</p>
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

<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

<script>
let deviationChart = null;

// Parse data from text input
function parseData(text) {
  return text.trim()
    .split(/[\s,\n]+/)
    .map(x => parseFloat(x))
    .filter(x => !isNaN(x));
}

// Calculate from data
function calculateFromData() {
  const dataText = document.getElementById('dataInput').value;
  const varianceType = document.getElementById('dataVarianceType').value;
  const showSteps = document.getElementById('showSteps').checked;
  const showChart = document.getElementById('showChart').checked;

  if (!dataText.trim()) {
    alert('Please enter data values');
    return;
  }

  const data = parseData(dataText);
  if (data.length === 0) {
    alert('No valid data found');
    return;
  }

  if (data.length < 2 && varianceType === 'sample') {
    alert('Sample variance requires at least 2 data points');
    return;
  }

  const n = data.length;
  const sum = data.reduce((a, b) => a + b, 0);
  const mean = sum / n;

  // Calculate deviations and squared deviations
  const deviations = data.map(x => x - mean);
  const squaredDeviations = deviations.map(d => d * d);
  const sumSquares = squaredDeviations.reduce((a, b) => a + b, 0);

  // Calculate variance
  const divisor = varianceType === 'sample' ? n - 1 : n;
  const variance = sumSquares / divisor;
  const stdDev = Math.sqrt(variance);
  const cv = mean !== 0 ? (stdDev / Math.abs(mean)) * 100 : 0;
  const sem = stdDev / Math.sqrt(n);

  const sortedData = [...data].sort((a, b) => a - b);
  const min = sortedData[0];
  const max = sortedData[n - 1];
  const range = max - min;

  const varianceLabel = varianceType === 'sample' ? 'Sample Variance (s²)' : 'Population Variance (σ²)';
  const sdLabel = varianceType === 'sample' ? 'Sample Std Dev (s)' : 'Population Std Dev (σ)';
  const symbol = varianceType === 'sample' ? 's²' : 'σ²';

  let html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-wave-square text-warning"></i>
        <span class="variance-badge">${symbol} = ${variance.toFixed(4)}</span>
      </h5>

      <div class="stat-section">
        <h6><i class="fas fa-calculator"></i> Variance & Standard Deviation</h6>
        <div class="stat-row">
          <span class="stat-label">${varianceLabel}:</span>
          <span class="stat-value">${variance.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">${sdLabel}:</span>
          <span class="stat-value">${stdDev.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Coeff. of Variation:</span>
          <span class="stat-value">${cv.toFixed(2)}%</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Std Error (SEM):</span>
          <span class="stat-value">${sem.toFixed(4)}</span>
        </div>
      </div>

      <div class="stat-section">
        <h6><i class="fas fa-chart-bar"></i> Descriptive Statistics</h6>
        <div class="stat-row">
          <span class="stat-label">Sample Size (n):</span>
          <span class="stat-value">${n}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Mean:</span>
          <span class="stat-value">${mean.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Minimum:</span>
          <span class="stat-value">${min.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Maximum:</span>
          <span class="stat-value">${max.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Range:</span>
          <span class="stat-value">${range.toFixed(4)}</span>
        </div>
      </div>

      <div class="stat-section">
        <h6><i class="fas fa-sigma"></i> Sum of Squares</h6>
        <div class="stat-row">
          <span class="stat-label">Σ(xᵢ - x̄)²:</span>
          <span class="stat-value">${sumSquares.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Divisor (${varianceType === 'sample' ? 'n-1' : 'n'}):</span>
          <span class="stat-value">${divisor}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Variance:</span>
          <span class="stat-value">${variance.toFixed(4)}</span>
        </div>
      </div>
  `;

  // Step-by-step calculation
  if (showSteps) {
    html += `
      <div class="stat-section">
        <h6><i class="fas fa-list-ol"></i> Step-by-Step Calculation</h6>
        <div class="table-responsive">
          <table class="table table-sm table-bordered steps-table">
            <thead>
              <tr>
                <th>Value (xᵢ)</th>
                <th>Deviation (xᵢ - x̄)</th>
                <th>Squared Deviation (xᵢ - x̄)²</th>
              </tr>
            </thead>
            <tbody>
    `;

    data.forEach((value, i) => {
      html += `
        <tr>
          <td>${value.toFixed(4)}</td>
          <td>${deviations[i].toFixed(4)}</td>
          <td>${squaredDeviations[i].toFixed(4)}</td>
        </tr>
      `;
    });

    html += `
              <tr class="font-weight-bold">
                <td>Sum:</td>
                <td>${deviations.reduce((a, b) => a + b, 0).toFixed(4)}</td>
                <td>${sumSquares.toFixed(4)}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="info-card">
          <strong>Formula:</strong><br>
          ${symbol} = Σ(xᵢ - x̄)² / ${varianceType === 'sample' ? '(n-1)' : 'n'}<br>
          ${symbol} = ${sumSquares.toFixed(4)} / ${divisor} = ${variance.toFixed(4)}
        </div>
      </div>
    `;
  }

  // Deviation chart
  if (showChart) {
    html += `
      <div class="stat-section">
        <h6><i class="fas fa-chart-bar"></i> Deviation from Mean</h6>
        <div class="chart-container">
          <canvas id="deviationChart"></canvas>
        </div>
      </div>
    `;
  }

  html += `
    <div class="info-card">
      <strong><i class="fas fa-info-circle"></i> Interpretation:</strong><br>
      The ${varianceType} variance is ${variance.toFixed(4)}, which means the average squared deviation from the mean is ${variance.toFixed(4)} units².
      The standard deviation is ${stdDev.toFixed(4)}, representing the typical distance of values from the mean.
      ${cv < 20 ? 'The coefficient of variation is low, indicating low relative variability.' :
        cv < 50 ? 'The coefficient of variation is moderate.' :
        'The coefficient of variation is high, indicating high relative variability.'}
    </div>
  </div>
  `;

  document.getElementById('results').innerHTML = html;

  // Draw deviation chart
  if (showChart) {
    drawDeviationChart(data, mean, deviations);
  }
}

// Calculate from statistics
function calculateFromStats() {
  const mean = parseFloat(document.getElementById('statsMean').value);
  const stdDev = parseFloat(document.getElementById('statsSD').value);
  const n = parseInt(document.getElementById('statsN').value);

  if (isNaN(mean) || isNaN(stdDev)) {
    alert('Please enter valid mean and standard deviation');
    return;
  }

  if (stdDev < 0) {
    alert('Standard deviation must be non-negative');
    return;
  }

  const variance = stdDev * stdDev;
  const cv = mean !== 0 ? (stdDev / Math.abs(mean)) * 100 : 0;

  let html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-wave-square text-warning"></i>
        <span class="variance-badge">Variance = ${variance.toFixed(4)}</span>
      </h5>

      <div class="stat-section">
        <h6><i class="fas fa-calculator"></i> Calculated Variance</h6>
        <div class="stat-row">
          <span class="stat-label">Variance:</span>
          <span class="stat-value">${variance.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Std Deviation:</span>
          <span class="stat-value">${stdDev.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Mean:</span>
          <span class="stat-value">${mean.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Coeff. of Variation:</span>
          <span class="stat-value">${cv.toFixed(2)}%</span>
        </div>
  `;

  if (!isNaN(n) && n > 0) {
    const sem = stdDev / Math.sqrt(n);
    html += `
        <div class="stat-row">
          <span class="stat-label">Sample Size (n):</span>
          <span class="stat-value">${n}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Std Error (SEM):</span>
          <span class="stat-value">${sem.toFixed(4)}</span>
        </div>
    `;
  }

  html += `
      </div>

      <div class="info-card">
        <strong><i class="fas fa-calculator"></i> Calculation:</strong><br>
        Variance = (Standard Deviation)²<br>
        Variance = (${stdDev.toFixed(4)})² = ${variance.toFixed(4)}
      </div>

      <div class="info-card">
        <strong><i class="fas fa-info-circle"></i> Remember:</strong><br>
        Standard Deviation = √Variance<br>
        SD = √${variance.toFixed(4)} = ${stdDev.toFixed(4)}
      </div>
    </div>
  `;

  document.getElementById('results').innerHTML = html;
}

// Draw deviation chart
function drawDeviationChart(data, mean, deviations) {
  const ctx = document.getElementById('deviationChart');
  if (!ctx) return;

  if (deviationChart) {
    deviationChart.destroy();
  }

  const labels = data.map((_, i) => `x${i + 1}`);
  const colors = deviations.map(d => d >= 0 ? 'rgba(236, 72, 153, 0.6)' : 'rgba(59, 130, 246, 0.6)');
  const borderColors = deviations.map(d => d >= 0 ? 'rgba(236, 72, 153, 1)' : 'rgba(59, 130, 246, 1)');

  deviationChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [{
        label: 'Deviation from Mean',
        data: deviations,
        backgroundColor: colors,
        borderColor: borderColors,
        borderWidth: 1
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
          text: `Deviations from Mean (${mean.toFixed(2)})`,
          font: { size: 16, weight: 'bold' }
        }
      },
      scales: {
        x: {
          title: {
            display: true,
            text: 'Data Points',
            font: { size: 14 }
          }
        },
        y: {
          title: {
            display: true,
            text: 'Deviation (xᵢ - x̄)',
            font: { size: 14 }
          },
          grid: {
            color: function(context) {
              if (context.tick.value === 0) {
                return 'rgba(0, 0, 0, 0.3)';
              }
              return 'rgba(0, 0, 0, 0.1)';
            },
            lineWidth: function(context) {
              if (context.tick.value === 0) {
                return 2;
              }
              return 1;
            }
          }
        }
      }
    }
  });
}

// Initialize with default example on page load
document.addEventListener('DOMContentLoaded', function() {
  calculateFromData();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
