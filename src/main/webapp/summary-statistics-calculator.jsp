<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Summary Statistics Calculator Online – Free | 8gwifi.org</title>
<meta name="description" content="Free summary statistics calculator: mean, median, mode, variance, SD, range, quartiles, IQR, skewness, kurtosis. Paste data for instant results.">
<meta name="keywords" content="summary statistics calculator, descriptive statistics, mean median mode, standard deviation, variance, skewness, kurtosis, quartiles, range, statistical analysis">
<link rel="canonical" href="https://8gwifi.org/summary-statistics-calculator.jsp">

<!-- Open Graph -->
<meta property="og:title" content="Summary Statistics Calculator Online – Free | 8gwifi.org">
<meta property="og:description" content="Descriptive stats: mean, median, mode, variance, SD, range, quartiles, IQR, skewness, kurtosis.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/summary-statistics-calculator.jsp">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Summary Statistics Calculator Online – Free | 8gwifi.org">
<meta name="twitter:description" content="Compute mean, median, mode, variance, SD, range, quartiles, IQR, skewness, kurtosis.">

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Summary Statistics Calculator",
  "description": "Calculate complete descriptive statistics including mean, median, mode, standard deviation, variance, range, quartiles, skewness, and kurtosis",
  "url": "https://8gwifi.org/summary-statistics-calculator.jsp",
  "applicationCategory": "UtilityApplication",
  "operatingSystem": "Any",
  "permissions": "browser",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": [
    "Central tendency (mean, median, mode)",
    "Dispersion (range, variance, standard deviation)",
    "Quartiles and five-number summary",
    "Skewness and kurtosis",
    "Coefficient of variation",
    "Standard error of mean",
    "Frequency distribution",
    "Histogram visualization"
  ]
}
</script>

<%@ include file="header-script.jsp"%>

<style>
:root {
  --summary-primary: #0891b2;
  --summary-secondary: #0e7490;
  --summary-light: #cffafe;
  --summary-dark: #164e63;
}

.summary-card {
  border-left: 4px solid var(--summary-primary);
  transition: all 0.3s ease;
}

.summary-card:hover {
  box-shadow: 0 4px 12px rgba(8, 145, 178, 0.2);
  transform: translateY(-2px);
}

.summary-badge {
  background: linear-gradient(135deg, var(--summary-primary), var(--summary-secondary));
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  display: inline-block;
}

.result-box {
  background: linear-gradient(135deg, var(--summary-light), white);
  border: 2px solid var(--summary-primary);
  border-radius: 10px;
  padding: 1.5rem;
  margin-top: 1rem;
}

.stat-section {
  background: white;
  border: 1px solid var(--summary-primary);
  border-radius: 8px;
  padding: 1rem;
  margin: 0.75rem 0;
}

.stat-section h6 {
  color: var(--summary-dark);
  border-bottom: 2px solid var(--summary-primary);
  padding-bottom: 0.5rem;
  margin-bottom: 0.75rem;
}

.form-control:focus {
  border-color: var(--summary-primary);
  box-shadow: 0 0 0 0.2rem rgba(8, 145, 178, 0.25);
}

.btn-summary {
  background: linear-gradient(135deg, var(--summary-primary), var(--summary-secondary));
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-summary:hover {
  background: linear-gradient(135deg, var(--summary-secondary), var(--summary-dark));
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(8, 145, 178, 0.3);
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
  background-color: var(--summary-light);
  border-left: 4px solid var(--summary-primary);
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
  color: var(--summary-dark);
}

.stat-value {
  color: var(--summary-secondary);
  font-weight: 500;
  font-family: 'Courier New', monospace;
}

.frequency-table {
  font-size: 0.9rem;
}

.frequency-table th {
  background-color: var(--summary-primary);
  color: white;
}

.interpretation-normal {
  background: linear-gradient(135deg, #d1fae5, white);
  border-left: 4px solid #10b981;
  padding: 0.75rem;
  border-radius: 6px;
  margin: 0.5rem 0;
}

.interpretation-skewed {
  background: linear-gradient(135deg, #fef3c7, white);
  border-left: 4px solid #f59e0b;
  padding: 0.75rem;
  border-radius: 6px;
  margin: 0.5rem 0;
}
</style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1><i class="fas fa-chart-pie text-info"></i> Summary Statistics Calculator</h1>
  <p class="lead">Complete descriptive statistics analysis: mean, median, mode, SD, variance, quartiles, skewness, kurtosis</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="card summary-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title">
            <i class="fas fa-database text-info"></i> Data Input
          </h5>

          <div class="form-group">
            <label for="dataInput"><i class="fas fa-list-ol"></i> Enter Data (comma or space separated)</label>
            <textarea class="form-control" id="dataInput" rows="8" placeholder="85, 90, 78, 92, 88, 76, 95, 82, 87, 91, 89, 84, 93, 79, 86">85, 90, 78, 92, 88, 76, 95, 82, 87, 91, 89, 84, 93, 79, 86</textarea>
            <small class="form-text text-muted">Enter numbers separated by commas, spaces, or newlines</small>
          </div>

          <div class="form-check mb-3">
            <input type="checkbox" class="form-check-input" id="showHistogram" checked>
            <label class="form-check-label" for="showHistogram">
              Show Histogram
            </label>
          </div>

          <div class="form-check mb-3">
            <input type="checkbox" class="form-check-input" id="showFrequency" checked>
            <label class="form-check-label" for="showFrequency">
              Show Frequency Distribution
            </label>
          </div>

          <button class="btn btn-summary btn-block" onclick="calculateSummary()">
            <i class="fas fa-calculator"></i> Calculate Summary Statistics
          </button>
        </div>
      </div>

      <!-- Educational Content -->
      <div class="card summary-card shadow-sm mb-4">
        <div class="card-body">
          <h5 class="card-title"><i class="fas fa-book text-info"></i> Understanding Summary Statistics</h5>

          <h6 class="mt-3"><i class="fas fa-bullseye text-info"></i> Measures of Central Tendency</h6>
          <ul>
            <li><strong>Mean (Average):</strong> Sum of all values divided by count. Sensitive to outliers.</li>
            <li><strong>Median:</strong> Middle value when sorted. Resistant to outliers.</li>
            <li><strong>Mode:</strong> Most frequently occurring value(s). Can have multiple modes or none.</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-arrows-alt-h text-info"></i> Measures of Dispersion</h6>
          <ul>
            <li><strong>Range:</strong> Max - Min. Simple measure of spread.</li>
            <li><strong>Variance (σ²):</strong> Average squared deviation from mean. In squared units.</li>
            <li><strong>Standard Deviation (σ):</strong> Square root of variance. In original units.</li>
            <li><strong>Coefficient of Variation (CV):</strong> (SD / Mean) × 100%. Relative variability.</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-chart-area text-info"></i> Distribution Shape</h6>
          <ul>
            <li><strong>Skewness:</strong> Measures asymmetry
              <ul>
                <li>0 = Symmetric (normal distribution)</li>
                <li>&gt; 0 = Right-skewed (tail on right)</li>
                <li>&lt; 0 = Left-skewed (tail on left)</li>
              </ul>
            </li>
            <li><strong>Kurtosis:</strong> Measures tailedness
              <ul>
                <li>3 = Normal distribution (mesokurtic)</li>
                <li>&gt; 3 = Heavy tails (leptokurtic)</li>
                <li>&lt; 3 = Light tails (platykurtic)</li>
              </ul>
            </li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-chart-box text-info"></i> Quartiles</h6>
          <ul>
            <li><strong>Q1 (25th percentile):</strong> 25% of data below this value</li>
            <li><strong>Q2 (50th percentile):</strong> Median - divides data in half</li>
            <li><strong>Q3 (75th percentile):</strong> 75% of data below this value</li>
            <li><strong>IQR (Q3 - Q1):</strong> Spread of middle 50% of data</li>
          </ul>

          <h6 class="mt-3"><i class="fas fa-lightbulb text-info"></i> When to Use</h6>
          <ul>
            <li><strong>Data Exploration:</strong> Initial analysis of any dataset</li>
            <li><strong>Report Writing:</strong> Standard descriptive statistics section</li>
            <li><strong>Quality Control:</strong> Monitor process stability</li>
            <li><strong>Comparison:</strong> Compare different datasets or groups</li>
            <li><strong>Assumption Checking:</strong> Verify normality for parametric tests</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-5">
      <div class="sticky-results">
        <div class="card summary-card shadow-sm">
          <div class="card-body">
            <h5 class="card-title">
              <i class="fas fa-chart-line text-info"></i> Results
            </h5>
            <div id="results">
              <div class="text-center text-muted py-5">
                <i class="fas fa-chart-pie fa-3x mb-3"></i>
                <p>Enter your data and click calculate to see complete summary statistics</p>
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
    <h2 class="h5">Summary Statistics: FAQ</h2>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">What are the most useful summaries?</h3>
      <p class="mb-0">Report central tendency (mean/median), spread (SD/IQR), shape (skewness/kurtosis) and range/five‑number summary depending on your data and audience.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Mean vs median — which to trust?</h3>
      <p class="mb-0">Median is robust for skewed/heavy‑tailed data; mean is efficient for symmetric distributions without outliers.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">When to use IQR or SD?</h3>
      <p class="mb-0">Use IQR for robust spread (resistant to outliers). Use SD when the normal model is reasonable or you need variance‑based methods.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How to deal with outliers?</h3>
      <p class="mb-0">Investigate first. Consider robust stats (median/IQR), transformations, or trimming only with justification.</p>
    </div></div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"What are the most useful summaries?","acceptedAnswer":{"@type":"Answer","text":"Report central tendency (mean/median), spread (SD/IQR), shape (skewness/kurtosis) and range/five‑number summary depending on context."}},
      {"@type":"Question","name":"Mean vs median — which to trust?","acceptedAnswer":{"@type":"Answer","text":"Median is robust for skewed/heavy‑tailed data; mean is efficient for symmetric distributions without outliers."}},
      {"@type":"Question","name":"When to use IQR or SD?","acceptedAnswer":{"@type":"Answer","text":"Use IQR for robustness; SD for normal‑like data or variance‑based methods."}},
      {"@type":"Question","name":"How to deal with outliers?","acceptedAnswer":{"@type":"Answer","text":"Investigate; use robust stats, transformations, or trimming with justification."}}
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
      {"@type":"ListItem","position":2,"name":"Summary Statistics Calculator","item":"https://8gwifi.org/summary-statistics-calculator.jsp"}
    ]
  }
  </script>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

<script>
let histogramChart = null;

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

// Calculate mode
function calculateMode(data) {
  const frequency = {};
  let maxFreq = 0;

  data.forEach(value => {
    frequency[value] = (frequency[value] || 0) + 1;
    maxFreq = Math.max(maxFreq, frequency[value]);
  });

  if (maxFreq === 1) {
    return { modes: [], maxFreq: 1, description: 'No mode (all values unique)' };
  }

  const modes = Object.keys(frequency)
    .filter(key => frequency[key] === maxFreq)
    .map(key => parseFloat(key))
    .sort((a, b) => a - b);

  const description = modes.length === 1 ?
    `Unimodal: ${modes[0]}` :
    modes.length === 2 ?
    `Bimodal: ${modes.join(', ')}` :
    `Multimodal: ${modes.join(', ')}`;

  return { modes, maxFreq, description };
}

// Calculate skewness
function calculateSkewness(data, mean, stdDev) {
  if (stdDev === 0) return 0;
  const n = data.length;
  const m3 = data.reduce((sum, x) => sum + Math.pow((x - mean) / stdDev, 3), 0) / n;
  return m3;
}

// Calculate kurtosis (excess kurtosis)
function calculateKurtosis(data, mean, stdDev) {
  if (stdDev === 0) return 0;
  const n = data.length;
  const m4 = data.reduce((sum, x) => sum + Math.pow((x - mean) / stdDev, 4), 0) / n;
  return m4 - 3; // Excess kurtosis (normal distribution = 0)
}

// Create frequency distribution
function createFrequencyDistribution(sortedData) {
  const n = sortedData.length;
  const range = sortedData[n - 1] - sortedData[0];

  // Sturges' rule for number of bins
  const numBins = Math.ceil(Math.log2(n) + 1);
  const binWidth = range / numBins;

  const bins = [];
  const min = sortedData[0];

  for (let i = 0; i < numBins; i++) {
    const lower = min + i * binWidth;
    const upper = min + (i + 1) * binWidth;
    bins.push({
      lower,
      upper,
      midpoint: (lower + upper) / 2,
      frequency: 0,
      relativeFreq: 0,
      cumulativeFreq: 0
    });
  }

  // Count frequencies
  sortedData.forEach(value => {
    for (let i = 0; i < bins.length; i++) {
      if (i === bins.length - 1) {
        // Last bin includes upper bound
        if (value >= bins[i].lower && value <= bins[i].upper) {
          bins[i].frequency++;
          break;
        }
      } else {
        if (value >= bins[i].lower && value < bins[i].upper) {
          bins[i].frequency++;
          break;
        }
      }
    }
  });

  // Calculate relative and cumulative frequencies
  let cumulative = 0;
  bins.forEach(bin => {
    bin.relativeFreq = bin.frequency / n;
    cumulative += bin.frequency;
    bin.cumulativeFreq = cumulative;
  });

  return bins;
}

// Interpret skewness
function interpretSkewness(skew) {
  const absSkew = Math.abs(skew);
  if (absSkew < 0.5) return 'Approximately symmetric';
  if (absSkew < 1) return skew > 0 ? 'Moderately right-skewed' : 'Moderately left-skewed';
  return skew > 0 ? 'Highly right-skewed' : 'Highly left-skewed';
}

// Interpret kurtosis
function interpretKurtosis(kurt) {
  if (Math.abs(kurt) < 0.5) return 'Approximately normal (mesokurtic)';
  if (kurt > 0) return 'Heavy-tailed (leptokurtic)';
  return 'Light-tailed (platykurtic)';
}

// Calculate summary statistics
function calculateSummary() {
  const dataText = document.getElementById('dataInput').value;
  const showHistogram = document.getElementById('showHistogram').checked;
  const showFrequency = document.getElementById('showFrequency').checked;

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

  // Central tendency
  const sum = data.reduce((a, b) => a + b, 0);
  const mean = sum / n;
  const median = calculatePercentile(sortedData, 50);
  const modeInfo = calculateMode(data);

  // Dispersion
  const min = sortedData[0];
  const max = sortedData[n - 1];
  const range = max - min;
  const variance = data.reduce((sum, x) => sum + Math.pow(x - mean, 2), 0) / (n - 1);
  const stdDev = Math.sqrt(variance);
  const cv = mean !== 0 ? (stdDev / Math.abs(mean)) * 100 : 0;
  const sem = stdDev / Math.sqrt(n);

  // Quartiles
  const q1 = calculatePercentile(sortedData, 25);
  const q3 = calculatePercentile(sortedData, 75);
  const iqr = q3 - q1;

  // Shape
  const skewness = calculateSkewness(data, mean, stdDev);
  const kurtosis = calculateKurtosis(data, mean, stdDev);

  // Frequency distribution
  const freqDist = createFrequencyDistribution(sortedData);

  // Build HTML
  let html = `
    <div class="result-box">
      <h5 class="text-center mb-3">
        <i class="fas fa-chart-pie text-warning"></i>
        <span class="summary-badge">n = ${n}</span>
      </h5>

      <!-- Central Tendency -->
      <div class="stat-section">
        <h6><i class="fas fa-bullseye"></i> Central Tendency</h6>
        <div class="stat-row">
          <span class="stat-label">Mean (Average):</span>
          <span class="stat-value">${mean.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Median:</span>
          <span class="stat-value">${median.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Mode:</span>
          <span class="stat-value">${modeInfo.description}</span>
        </div>
      </div>

      <!-- Dispersion -->
      <div class="stat-section">
        <h6><i class="fas fa-arrows-alt-h"></i> Dispersion (Spread)</h6>
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
        <div class="stat-row">
          <span class="stat-label">Variance (s²):</span>
          <span class="stat-value">${variance.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Std Deviation (s):</span>
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

      <!-- Quartiles -->
      <div class="stat-section">
        <h6><i class="fas fa-chart-box"></i> Quartiles & Five-Number Summary</h6>
        <div class="stat-row">
          <span class="stat-label">Q1 (25th percentile):</span>
          <span class="stat-value">${q1.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Q2 (50th percentile):</span>
          <span class="stat-value">${median.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Q3 (75th percentile):</span>
          <span class="stat-value">${q3.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">IQR (Q3 - Q1):</span>
          <span class="stat-value">${iqr.toFixed(4)}</span>
        </div>
      </div>

      <!-- Distribution Shape -->
      <div class="stat-section">
        <h6><i class="fas fa-chart-area"></i> Distribution Shape</h6>
        <div class="stat-row">
          <span class="stat-label">Skewness:</span>
          <span class="stat-value">${skewness.toFixed(4)}</span>
        </div>
        <div class="stat-row">
          <span class="stat-label">Kurtosis (excess):</span>
          <span class="stat-value">${kurtosis.toFixed(4)}</span>
        </div>
      </div>

      <div class="${Math.abs(skewness) < 0.5 && Math.abs(kurtosis) < 0.5 ? 'interpretation-normal' : 'interpretation-skewed'}">
        <strong><i class="fas fa-info-circle"></i> Distribution:</strong><br>
        <strong>Skewness:</strong> ${interpretSkewness(skewness)}<br>
        <strong>Kurtosis:</strong> ${interpretKurtosis(kurtosis)}
      </div>
  `;

  // Frequency Distribution Table
  if (showFrequency) {
    html += `
      <div class="stat-section">
        <h6><i class="fas fa-table"></i> Frequency Distribution</h6>
        <div class="table-responsive">
          <table class="table table-sm table-bordered frequency-table">
            <thead>
              <tr>
                <th>Class Interval</th>
                <th>Frequency</th>
                <th>Relative</th>
                <th>Cumulative</th>
              </tr>
            </thead>
            <tbody>
    `;

    freqDist.forEach(bin => {
      html += `
        <tr>
          <td>${bin.lower.toFixed(2)} - ${bin.upper.toFixed(2)}</td>
          <td>${bin.frequency}</td>
          <td>${(bin.relativeFreq * 100).toFixed(1)}%</td>
          <td>${bin.cumulativeFreq}</td>
        </tr>
      `;
    });

    html += `
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  // Histogram
  if (showHistogram) {
    html += `
      <div class="stat-section">
        <h6><i class="fas fa-chart-bar"></i> Histogram</h6>
        <div class="chart-container">
          <canvas id="histogramChart"></canvas>
        </div>
      </div>
    `;
  }

  html += '</div>'; // Close result-box

  document.getElementById('results').innerHTML = html;

  // Draw histogram
  if (showHistogram) {
    drawHistogram(freqDist);
  }
}

// Draw histogram
function drawHistogram(freqDist) {
  const ctx = document.getElementById('histogramChart');
  if (!ctx) return;

  if (histogramChart) {
    histogramChart.destroy();
  }

  const labels = freqDist.map(bin => `${bin.lower.toFixed(1)}-${bin.upper.toFixed(1)}`);
  const frequencies = freqDist.map(bin => bin.frequency);

  histogramChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [{
        label: 'Frequency',
        data: frequencies,
        backgroundColor: 'rgba(8, 145, 178, 0.6)',
        borderColor: 'rgba(8, 145, 178, 1)',
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
          text: 'Frequency Histogram',
          font: { size: 16, weight: 'bold' }
        }
      },
      scales: {
        x: {
          title: {
            display: true,
            text: 'Class Intervals',
            font: { size: 14 }
          }
        },
        y: {
          title: {
            display: true,
            text: 'Frequency',
            font: { size: 14 }
          },
          beginAtZero: true,
          ticks: {
            stepSize: 1
          }
        }
      }
    }
  });
}

// Initialize with default example on page load
document.addEventListener('DOMContentLoaded', function() {
  calculateSummary();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
