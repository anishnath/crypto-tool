<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Normal Distribution Calculator Online – Free | 8gwifi.org</title>
<meta name="description" content="Free normal distribution calculator: probabilities, Z‑scores, and percentiles for any μ and σ — with interactive bell curve visualization.">
<meta name="keywords" content="normal distribution calculator, gaussian distribution, bell curve calculator, normal probability calculator, z-score, percentile, standard deviation">
<link rel="canonical" href="https://8gwifi.org/normal-distribution-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Normal Distribution Calculator Online – Free | 8gwifi.org">
<meta property="og:description" content="Probabilities, Z‑scores, percentiles for any normal distribution (μ, σ) with a bell curve chart.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/normal-distribution-calculator.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Normal Distribution Calculator Online – Free | 8gwifi.org">
<meta name="twitter:description" content="Free normal distribution tool: probabilities, Z‑scores, percentiles with bell curve visualization.">

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
  "name": "Normal Distribution Calculator",
  "url": "https://8gwifi.org/normal-distribution-calculator.jsp",
  "description": "Comprehensive Normal Distribution Calculator with custom mean and standard deviation. Calculate probabilities, z-scores, percentiles, and visualize the normal curve with shaded regions.",
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "browserRequirements": "Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Normal distribution probabilities, Z-score calculation, Percentile calculation, Custom mean and standard deviation, Interactive bell curve visualization, Area calculations, Probability ranges"
}
</script>

<style>
  :root {
    --primary-color: #3b82f6;
    --primary-dark: #2563eb;
    --primary-light: #93c5fd;
    --bg-light: #eff6ff;
    --border-color: #bfdbfe;
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
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
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
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
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
    background: #dbeafe;
    border-left: 4px solid #3b82f6;
    padding: 0.75rem;
    border-radius: 4px;
    font-size: 0.85rem;
    margin-top: 0.5rem;
    color: #1e3a8a;
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

  #normalCurve {
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
  <h1>Normal Distribution Calculator</h1>
  <p class="text-muted">Calculate probabilities, z-scores, and percentiles for any normal distribution</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="calculator-section">
        <h2 class="section-title"><i class="fas fa-chart-bell"></i> Distribution Parameters</h2>

        <div class="mb-3">
          <label for="mean" class="form-label">Mean (μ)</label>
          <input type="number" class="form-control" id="mean" value="100" step="0.01">
        </div>

        <div class="mb-3">
          <label for="stdDev" class="form-label">Standard Deviation (σ)</label>
          <input type="number" class="form-control" id="stdDev" value="15" step="0.01" min="0.01">
        </div>

        <hr>

        <h2 class="section-title"><i class="fas fa-calculator"></i> Calculation Type</h2>

        <!-- Calculation Type Tabs -->
        <ul class="nav nav-tabs mb-3" id="calcTabs" role="tablist">
          <li class="nav-item">
            <a class="nav-link active" id="prob-tab" data-toggle="tab" href="#prob" role="tab">X → Probability</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="percentile-tab" data-toggle="tab" href="#percentile" role="tab">Percentile → X</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="range-tab" data-toggle="tab" href="#range" role="tab">Range</a>
          </li>
        </ul>

        <div class="tab-content" id="calcTabContent">
          <!-- X to Probability -->
          <div class="tab-pane fade show active" id="prob" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Find probability:</strong> Calculate P(X ≤ x) or P(X ≥ x)
            </div>

            <div class="mb-3">
              <label for="xValue" class="form-label">X Value</label>
              <input type="number" class="form-control" id="xValue" value="115" step="0.01">
            </div>

            <div class="mb-3">
              <label class="form-label">Probability Type</label>
              <select class="form-control" id="probType">
                <option value="less">P(X ≤ x) - Left tail</option>
                <option value="greater">P(X ≥ x) - Right tail</option>
              </select>
            </div>
          </div>

          <!-- Percentile to X -->
          <div class="tab-pane fade" id="percentile" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Find x-value:</strong> Given percentile, find corresponding x
            </div>

            <div class="mb-3">
              <label for="percentile" class="form-label">Percentile (%)</label>
              <input type="number" class="form-control" id="percentile" value="84.13" step="0.01" min="0" max="100">
            </div>
          </div>

          <!-- Range Probability -->
          <div class="tab-pane fade" id="range" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Find probability in range:</strong> Calculate P(a ≤ X ≤ b)
            </div>

            <div class="mb-3">
              <label for="rangeA" class="form-label">Lower Bound (a)</label>
              <input type="number" class="form-control" id="rangeA" value="85" step="0.01">
            </div>

            <div class="mb-3">
              <label for="rangeB" class="form-label">Upper Bound (b)</label>
              <input type="number" class="form-control" id="rangeB" value="115" step="0.01">
            </div>
          </div>
        </div>

        <button class="btn btn-calculate mt-3" onclick="calculate()">
          <i class="fas fa-calculator"></i> Calculate
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
            <p class="mt-2">Enter parameters and calculate</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Educational Content -->
  <div class="educational-section">
    <h3><i class="fas fa-graduation-cap"></i> Understanding Normal Distribution</h3>

    <p>The <strong>normal distribution</strong> (also called Gaussian distribution or bell curve) is the most important probability distribution in statistics.</p>

    <h4>Probability Density Function</h4>
    <div class="formula-box">
      f(x) = (1 / (σ√(2π))) × e^(-(x-μ)²/(2σ²))
    </div>

    <h4>Key Properties</h4>
    <ul>
      <li><strong>Symmetric:</strong> Bell-shaped curve centered at mean (μ)</li>
      <li><strong>Mean = Median = Mode:</strong> All at center of distribution</li>
      <li><strong>Total Area = 1:</strong> Represents 100% probability</li>
      <li><strong>Asymptotic:</strong> Tails approach but never touch x-axis</li>
    </ul>

    <h4>68-95-99.7 Rule (Empirical Rule)</h4>
    <ul>
      <li><strong>68%</strong> of data falls within μ ± 1σ</li>
      <li><strong>95%</strong> of data falls within μ ± 2σ</li>
      <li><strong>99.7%</strong> of data falls within μ ± 3σ</li>
    </ul>

    <h4>Z-Score</h4>
    <p>Standardize any normal distribution to standard normal (μ=0, σ=1):</p>
    <div class="formula-box">
      Z = (X - μ) / σ
    </div>

    <h4>Real-World Applications</h4>
    <ul>
      <li><strong>IQ Scores:</strong> μ = 100, σ = 15</li>
      <li><strong>SAT Scores:</strong> μ = 1050, σ = 200 (approx)</li>
      <li><strong>Heights:</strong> Adult male heights (varies by population)</li>
      <li><strong>Measurement Errors:</strong> Random errors in scientific measurements</li>
      <li><strong>Stock Returns:</strong> Daily returns often approximate normal</li>
      <li><strong>Quality Control:</strong> Manufacturing tolerances</li>
    </ul>

    <h4>Central Limit Theorem</h4>
    <p>The distribution of sample means approaches normal as sample size increases, regardless of the population distribution. This makes the normal distribution fundamental to inferential statistics.</p>

    <div class="info-box">
      <i class="fas fa-lightbulb"></i>
      <strong>Tip:</strong> The normal distribution is completely determined by two parameters: mean (μ) and standard deviation (σ). Many statistical tests assume normality.
    </div>
  </div>
</div>

<%@ include file="thanks.jsp"%>

  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="addcomments.jsp"%>
  <!-- FAQ: inlined (was jspf/faq/math/normal-distribution-calculator-faq.jspf) -->
  <section id="faq" class="mt-5">
    <h2 class="h5">Normal Distribution Calculator: FAQ</h2>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">What do μ and σ represent?</h3>
      <p class="mb-0">μ is the mean (center) and σ is the standard deviation (spread) of the normal distribution.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How do I find tail probabilities?</h3>
      <p class="mb-0">Enter a value and choose left tail P(X ≤ x), right tail P(X ≥ x), or between/outside ranges to shade the curve and compute areas.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How do I get a percentile?</h3>
      <p class="mb-0">Use the inverse option to enter a percentile and get the corresponding x value for your specified μ and σ.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">What if data aren’t normal?</h3>
      <p class="mb-0">Consider transformations or non‑parametric methods; the normal model assumptions may not apply to heavily skewed or multimodal data.</p>
    </div></div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"What do μ and σ represent?","acceptedAnswer":{"@type":"Answer","text":"μ is the mean and σ is the standard deviation of the normal distribution."}},
      {"@type":"Question","name":"How do I find tail probabilities?","acceptedAnswer":{"@type":"Answer","text":"Choose left/right tail or between/outside ranges to compute shaded areas."}},
      {"@type":"Question","name":"How do I get a percentile?","acceptedAnswer":{"@type":"Answer","text":"Use inverse normal to input percentile and get the corresponding x."}},
      {"@type":"Question","name":"What if data aren’t normal?","acceptedAnswer":{"@type":"Answer","text":"Consider transformations or non‑parametric methods when normality is violated."}}
    ]
  }
  </script>
  <!-- Breadcrumbs: inlined (was jspf/breadcrumbs/math/normal-distribution-calculator-breadcrumbs.jspf) -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"Normal Distribution Calculator","item":"https://8gwifi.org/normal-distribution-calculator.jsp"}
    ]
  }
  </script>
</div>
<%@ include file="body-close.jsp"%>

<script>
  let normalChart = null;

  function calculate() {
    const mu = parseFloat(document.getElementById('mean').value);
    const sigma = parseFloat(document.getElementById('stdDev').value);

    if (isNaN(mu) || isNaN(sigma) || sigma <= 0) {
      alert('Invalid parameters');
      return;
    }

    const activeTab = document.querySelector('#calcTabs .nav-link.active').id;

    if (activeTab === 'prob-tab') {
      calculateProbability(mu, sigma);
    } else if (activeTab === 'percentile-tab') {
      calculatePercentile(mu, sigma);
    } else if (activeTab === 'range-tab') {
      calculateRange(mu, sigma);
    }
  }

  function calculateProbability(mu, sigma) {
    const x = parseFloat(document.getElementById('xValue').value);
    const probType = document.getElementById('probType').value;

    if (isNaN(x)) {
      alert('Invalid x value');
      return;
    }

    const z = (x - mu) / sigma;
    let prob;

    if (probType === 'less') {
      prob = jStat.normal.cdf(x, mu, sigma);
    } else {
      prob = 1 - jStat.normal.cdf(x, mu, sigma);
    }

    const percentile = jStat.normal.cdf(x, mu, sigma) * 100;

    displayResults({
      type: 'probability',
      x: x,
      z: z,
      prob: prob,
      percentile: percentile,
      probType: probType
    });

    drawNormalCurve(mu, sigma, x, null, probType);
  }

  function calculatePercentile(mu, sigma) {
    const p = parseFloat(document.getElementById('percentile').value);

    if (isNaN(p) || p < 0 || p > 100) {
      alert('Percentile must be between 0 and 100');
      return;
    }

    const x = jStat.normal.inv(p / 100, mu, sigma);
    const z = (x - mu) / sigma;

    displayResults({
      type: 'percentile',
      x: x,
      z: z,
      percentile: p
    });

    drawNormalCurve(mu, sigma, x, null, 'less');
  }

  function calculateRange(mu, sigma) {
    const a = parseFloat(document.getElementById('rangeA').value);
    const b = parseFloat(document.getElementById('rangeB').value);

    if (isNaN(a) || isNaN(b) || a >= b) {
      alert('Invalid range (a must be < b)');
      return;
    }

    const probA = jStat.normal.cdf(a, mu, sigma);
    const probB = jStat.normal.cdf(b, mu, sigma);
    const prob = probB - probA;

    const zA = (a - mu) / sigma;
    const zB = (b - mu) / sigma;

    displayResults({
      type: 'range',
      a: a,
      b: b,
      zA: zA,
      zB: zB,
      prob: prob,
      percentileA: probA * 100,
      percentileB: probB * 100
    });

    drawNormalCurve(mu, sigma, a, b, 'range');
  }

  function displayResults(results) {
    let html = '';

    if (results.type === 'probability') {
      html = `
        <div class="result-item">
          <div class="result-label">X Value</div>
          <div class="result-value">${results.x.toFixed(4)}</div>
        </div>

        <div class="result-item">
          <div class="result-label">Z-Score</div>
          <div class="result-value">${results.z.toFixed(4)}</div>
        </div>

        <div class="result-item">
          <div class="result-label">Probability</div>
          <div class="result-value">${results.prob.toFixed(6)}</div>
          <div class="interpretation">
            ${results.probType === 'less'
              ? `P(X ≤ ${results.x.toFixed(2)}) = ${results.prob.toFixed(4)}<br>Percentile: ${results.percentile.toFixed(2)}%`
              : `P(X ≥ ${results.x.toFixed(2)}) = ${results.prob.toFixed(4)}`
            }
          </div>
        </div>
      `;
    } else if (results.type === 'percentile') {
      html = `
        <div class="result-item">
          <div class="result-label">Percentile</div>
          <div class="result-value">${results.percentile.toFixed(2)}%</div>
        </div>

        <div class="result-item">
          <div class="result-label">X Value</div>
          <div class="result-value">${results.x.toFixed(4)}</div>
          <div class="interpretation">
            ${results.percentile.toFixed(2)}% of values are below ${results.x.toFixed(4)}
          </div>
        </div>

        <div class="result-item">
          <div class="result-label">Z-Score</div>
          <div class="result-value">${results.z.toFixed(4)}</div>
        </div>
      `;
    } else if (results.type === 'range') {
      html = `
        <div class="result-item">
          <div class="result-label">Range</div>
          <div class="result-value">[${results.a.toFixed(2)}, ${results.b.toFixed(2)}]</div>
        </div>

        <div class="result-item">
          <div class="result-label">Probability</div>
          <div class="result-value">${results.prob.toFixed(6)}</div>
          <div class="interpretation">
            P(${results.a.toFixed(2)} ≤ X ≤ ${results.b.toFixed(2)}) = ${(results.prob * 100).toFixed(2)}%
          </div>
        </div>

        <div class="result-item">
          <div class="result-label">Z-Scores</div>
          <div style="font-size: 0.9rem; margin-top: 0.5rem;">
            <div>Z(a) = ${results.zA.toFixed(4)}</div>
            <div>Z(b) = ${results.zB.toFixed(4)}</div>
          </div>
        </div>
      `;
    }

    document.getElementById('resultsContent').innerHTML = html;
  }

  function drawNormalCurve(mu, sigma, x1, x2, type) {
    const container = document.getElementById('resultsContent');

    let canvas = document.getElementById('normalCurve');
    if (!canvas) {
      const chartHtml = `
        <div class="chart-container">
          <h5 style="color: var(--primary-color); margin-bottom: 1rem; font-size: 0.95rem;">
            <i class="fas fa-chart-line"></i> Normal Distribution (μ=${mu}, σ=${sigma})
          </h5>
          <canvas id="normalCurve"></canvas>
        </div>
      `;
      container.insertAdjacentHTML('beforeend', chartHtml);
      canvas = document.getElementById('normalCurve');
    }

    if (normalChart) {
      normalChart.destroy();
    }

    const xValues = [];
    const yValues = [];
    const range = sigma * 4;

    for (let x = mu - range; x <= mu + range; x += sigma / 20) {
      xValues.push(x);
      yValues.push(jStat.normal.pdf(x, mu, sigma));
    }

    let fillData;
    if (type === 'less') {
      fillData = xValues.map((x, i) => x <= x1 ? yValues[i] : null);
    } else if (type === 'greater') {
      fillData = xValues.map((x, i) => x >= x1 ? yValues[i] : null);
    } else if (type === 'range') {
      fillData = xValues.map((x, i) => (x >= x1 && x <= x2) ? yValues[i] : null);
    }

    normalChart = new Chart(canvas, {
      type: 'line',
      data: {
        labels: xValues,
        datasets: [{
          label: 'Normal Distribution',
          data: yValues,
          borderColor: 'rgba(59, 130, 246, 1)',
          borderWidth: 2,
          fill: false,
          pointRadius: 0
        }, {
          label: 'Shaded Area',
          data: fillData,
          backgroundColor: 'rgba(59, 130, 246, 0.3)',
          borderColor: 'rgba(59, 130, 246, 1)',
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
          legend: { display: false },
          title: {
            display: true,
            text: `Normal Distribution (μ=${mu}, σ=${sigma})`,
            font: { size: 11, weight: 'bold' }
          }
        },
        scales: {
          x: {
            title: { display: true, text: 'X', font: { size: 10, weight: 'bold' } },
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
