<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Z-Score Calculator — Standard Score, Percentile, Probability</title>
<meta name="description" content="Calculate Z-scores, percentiles, and probabilities from the standard normal distribution. Convert between raw scores, Z-scores, and percentiles with visualization.">
<meta name="keywords" content="z-score calculator, standard score, z score, percentile calculator, normal distribution calculator, standardization, z-table calculator, standard normal">
<link rel="canonical" href="https://8gwifi.org/z-score-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Z-Score Calculator — Standard Normal Distribution">
<meta property="og:description" content="Calculate Z-scores, percentiles, and probabilities with interactive normal distribution visualization.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/z-score-calculator.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Z-Score Calculator">
<meta name="twitter:description" content="Free online Z-score calculator with normal distribution visualization.">

<%@ include file="header-script.jsp"%>

<style>
  /* Sticky results panel */
  .sticky-side {
    position: sticky;
    top: 80px;
    max-height: calc(100vh - 100px);
    overflow-y: auto;
  }

  /* Hero Result */
  .result-hero {
    text-align: center;
    padding: 2rem 1rem;
    background: linear-gradient(135deg, #7c3aed, #a78bfa);
    border-radius: 12px;
    margin-bottom: 1.5rem;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  }
  .result-hero .z-value {
    font-size: 3rem;
    font-weight: 800;
    color: white;
    margin: 0;
    line-height: 1;
  }
  .result-hero .z-label {
    color: rgba(255,255,255,0.9);
    margin-top: 0.5rem;
    font-size: 0.95rem;
  }

  .form-group { margin-bottom: 1rem; }
  .form-group label {
    display: block;
    font-weight: 600;
    margin-bottom: 0.25rem;
    color: #374151;
    font-size: 0.9rem;
  }
  .form-group input {
    width: 100%;
    padding: 0.6rem;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    font-size: 1rem;
  }
  .form-group input:focus {
    outline: none;
    border-color: #7c3aed;
    box-shadow: 0 0 0 3px rgba(124,58,237,0.1);
  }
  .form-group small {
    display: block;
    margin-top: 0.25rem;
    color: #6b7280;
    font-size: 0.8rem;
  }

  /* Action Button */
  .btn-calc {
    width: 100%;
    padding: 0.9rem;
    background: #7c3aed;
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    font-size: 1.05rem;
    cursor: pointer;
    transition: all 0.2s;
  }
  .btn-calc:hover { background: #6d28d9; transform: translateY(-1px); }

  .stats-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 0.75rem;
    margin-bottom: 1rem;
  }
  .stat-item {
    background: #faf5ff;
    padding: 0.75rem;
    border-radius: 6px;
    text-align: center;
  }
  .stat-item label {
    display: block;
    font-size: 0.75rem;
    color: #7c3aed;
    margin-bottom: 0.25rem;
    font-weight: 600;
  }
  .stat-item .value {
    font-size: 1.25rem;
    font-weight: 800;
    color: #6d28d9;
  }

  .interpretation {
    background: #faf5ff;
    border-left: 4px solid #7c3aed;
    padding: 1rem;
    border-radius: 4px;
    margin: 1rem 0;
    line-height: 1.6;
    font-size: 0.9rem;
  }

  #normalCurve {
    width: 100%;
    max-height: 250px;
  }

  /* Educational section */
  .edu-card {
    background: #f5f3ff;
    border-left: 4px solid #7c3aed;
    padding: 1rem;
    border-radius: 6px;
    margin-bottom: 1rem;
  }
  .edu-card h6 {
    color: #5b21b6;
    margin: 0 0 0.5rem 0;
    font-weight: 700;
  }
  .edu-card p {
    margin: 0;
    line-height: 1.6;
    color: #374151;
  }

  .table-responsive {
    overflow-x: auto;
  }
  .table-sm th, .table-sm td {
    padding: 0.5rem;
    font-size: 0.9rem;
  }

  @media (max-width: 768px) {
    .result-hero .z-value { font-size: 2rem; }
    .stats-grid { grid-template-columns: 1fr; }
  }
</style>

<script type="application/ld+json">
{
  "@context":"https://schema.org",
  "@type":"WebApplication",
  "name":"Z-Score Calculator",
  "url":"https://8gwifi.org/z-score-calculator.jsp",
  "description":"Calculate Z-scores, percentiles, and probabilities from the standard normal distribution. Free online tool with interactive visualization for standardization and statistical analysis.",
  "applicationCategory":"EducationalApplication",
  "operatingSystem":"Any",
  "browserRequirements":"Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Z-score calculation, Percentile calculation, Probability from Z-score, Raw score from Z-score, Normal distribution visualization, Z-table lookup, Area under curve",
  "screenshot": "https://8gwifi.org/images/z-score-calculator.png",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "ratingCount": "2150"
  }
}
</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1>Z-Score Calculator</h1>
  <p class="text-muted">Calculate Z-scores, percentiles, and probabilities from the standard normal distribution.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column - Input Forms -->
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h5 class="card-title mb-3">Z-Score Calculations</h5>

          <!-- Calculation Mode Tabs -->
          <ul class="nav nav-tabs mb-3" id="modeTabs" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="score-tab" data-toggle="tab" href="#scoreTab" role="tab">Score → Z</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="prob-tab" data-toggle="tab" href="#probTab" role="tab">Z → Probability</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="percentile-tab" data-toggle="tab" href="#percentileTab" role="tab">Percentile → Z</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="reverse-tab" data-toggle="tab" href="#reverseTab" role="tab">Z → Score</a>
            </li>
          </ul>

          <div class="tab-content" id="modeTabContent">
            <!-- Score to Z-Score Tab -->
            <div class="tab-pane fade show active" id="scoreTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>Standardization:</strong> Convert a raw score to a Z-score (standard score).
              </div>
              <div class="form-group">
                <label>Raw Score (x)</label>
                <input type="number" id="rawScore" value="85" step="0.01" class="form-control">
                <small>The value you want to standardize</small>
              </div>
              <div class="form-group">
                <label>Mean (μ)</label>
                <input type="number" id="mean" value="75" step="0.01" class="form-control">
                <small>Population or sample mean</small>
              </div>
              <div class="form-group">
                <label>Standard Deviation (σ)</label>
                <input type="number" id="stdDev" value="10" step="0.01" min="0.01" class="form-control">
                <small>Population or sample standard deviation</small>
              </div>
            </div>

            <!-- Z-Score to Probability Tab -->
            <div class="tab-pane fade" id="probTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>Probability:</strong> Find the area under the normal curve for a given Z-score.
              </div>
              <div class="form-group">
                <label>Z-Score</label>
                <input type="number" id="zScoreProb" value="1.96" step="0.01" class="form-control">
                <small>Standard score (positive or negative)</small>
              </div>
              <div class="form-group">
                <label>Area Type</label>
                <select id="areaType" class="form-control">
                  <option value="left">Left tail (P(Z ≤ z))</option>
                  <option value="right">Right tail (P(Z ≥ z))</option>
                  <option value="between">Between ±z</option>
                  <option value="outside">Outside ±z</option>
                </select>
                <small>Which area to calculate</small>
              </div>
            </div>

            <!-- Percentile to Z-Score Tab -->
            <div class="tab-pane fade" id="percentileTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>Inverse Normal:</strong> Find the Z-score for a given percentile/probability.
              </div>
              <div class="form-group">
                <label>Percentile (%)</label>
                <input type="number" id="percentile" value="95" step="0.01" min="0.01" max="99.99" class="form-control">
                <small>Enter percentile (e.g., 95 for 95th percentile)</small>
              </div>
            </div>

            <!-- Z-Score to Raw Score Tab -->
            <div class="tab-pane fade" id="reverseTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>Denormalization:</strong> Convert a Z-score back to the original scale.
              </div>
              <div class="form-group">
                <label>Z-Score</label>
                <input type="number" id="zScoreReverse" value="1.5" step="0.01" class="form-control">
                <small>Standard score to convert</small>
              </div>
              <div class="form-group">
                <label>Mean (μ)</label>
                <input type="number" id="meanReverse" value="100" step="0.01" class="form-control">
                <small>Population or sample mean</small>
              </div>
              <div class="form-group">
                <label>Standard Deviation (σ)</label>
                <input type="number" id="stdDevReverse" value="15" step="0.01" min="0.01" class="form-control">
                <small>Population or sample standard deviation</small>
              </div>
            </div>
          </div>

          <button class="btn-calc mt-3" id="btnCalc">Calculate</button>
        </div>
      </div>
    </div>

    <!-- Right Column - Results -->
    <div class="col-lg-5 mb-4">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title">Results</h5>
          <div id="resultDisplay">
            <p class="text-muted">Select a calculation mode and enter your values to see results.</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Educational Content -->
  <div class="row mt-5">
    <div class="col-12">
      <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
          <h5 class="mb-0">Understanding Z-Scores & the Standard Normal Distribution</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6">
              <div class="edu-card">
                <h6>What is a Z-Score?</h6>
                <p>A Z-score (standard score) measures how many standard deviations a data point is from the mean. It standardizes values from different distributions onto a common scale, making comparisons possible.</p>
                <p class="mt-2"><strong>Formula:</strong> Z = (x - μ) / σ</p>
              </div>

              <div class="edu-card">
                <h6>Why Use Z-Scores?</h6>
                <p><strong>Standardization:</strong> Compare values from different distributions (e.g., SAT vs ACT scores)<br><br>
                <strong>Outlier Detection:</strong> Identify unusual values (typically |Z| > 3)<br><br>
                <strong>Probability:</strong> Calculate probabilities using the standard normal distribution<br><br>
                <strong>Hypothesis Testing:</strong> Foundation for many statistical tests</p>
              </div>

              <div class="edu-card">
                <h6>The 68-95-99.7 Rule (Empirical Rule)</h6>
                <p>For normal distributions:<br>
                <strong>68%</strong> of data falls within ±1 standard deviation (|Z| ≤ 1)<br>
                <strong>95%</strong> of data falls within ±2 standard deviations (|Z| ≤ 2)<br>
                <strong>99.7%</strong> of data falls within ±3 standard deviations (|Z| ≤ 3)</p>
              </div>

              <h6 class="mt-3">Common Z-Scores & Percentiles</h6>
              <div class="table-responsive">
                <table class="table table-sm table-bordered">
                  <thead class="thead-light">
                    <tr>
                      <th>Z-Score</th>
                      <th>Percentile</th>
                      <th>Interpretation</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>-3.0</td>
                      <td>0.13%</td>
                      <td>Extremely low</td>
                    </tr>
                    <tr>
                      <td>-2.0</td>
                      <td>2.28%</td>
                      <td>Significantly low</td>
                    </tr>
                    <tr>
                      <td>-1.0</td>
                      <td>15.87%</td>
                      <td>Below average</td>
                    </tr>
                    <tr>
                      <td>0.0</td>
                      <td>50%</td>
                      <td>Mean/Average</td>
                    </tr>
                    <tr>
                      <td>1.0</td>
                      <td>84.13%</td>
                      <td>Above average</td>
                    </tr>
                    <tr>
                      <td>1.645</td>
                      <td>95%</td>
                      <td>90% CI critical value</td>
                    </tr>
                    <tr>
                      <td>1.96</td>
                      <td>97.5%</td>
                      <td>95% CI critical value</td>
                    </tr>
                    <tr>
                      <td>2.0</td>
                      <td>97.72%</td>
                      <td>Significantly high</td>
                    </tr>
                    <tr>
                      <td>2.576</td>
                      <td>99.5%</td>
                      <td>99% CI critical value</td>
                    </tr>
                    <tr>
                      <td>3.0</td>
                      <td>99.87%</td>
                      <td>Extremely high</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div class="col-md-6">
              <h6>Interpreting Z-Scores</h6>

              <div class="card mb-3" style="border-left: 4px solid #7c3aed;">
                <div class="card-body">
                  <h6 class="card-title text-purple">Positive Z-Score</h6>
                  <p class="card-text small mb-1">Value is <strong>above</strong> the mean</p>
                  <p class="card-text small mb-0"><strong>Example:</strong> Z = 1.5 means the score is 1.5 standard deviations above average</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #ef4444;">
                <div class="card-body">
                  <h6 class="card-title text-danger">Negative Z-Score</h6>
                  <p class="card-text small mb-1">Value is <strong>below</strong> the mean</p>
                  <p class="card-text small mb-0"><strong>Example:</strong> Z = -1.5 means the score is 1.5 standard deviations below average</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #6b7280;">
                <div class="card-body">
                  <h6 class="card-title text-secondary">Zero Z-Score</h6>
                  <p class="card-text small mb-1">Value equals the mean</p>
                  <p class="card-text small mb-0"><strong>Example:</strong> Z = 0 means the score is exactly average</p>
                </div>
              </div>

              <h6 class="mt-3">Real-World Applications</h6>
              <div class="alert alert-success" style="font-size: 0.9rem;">
                <strong>Standardized Testing:</strong> SAT, ACT, IQ scores use Z-scores to compare performance<br>
                <strong>Quality Control:</strong> Manufacturing uses Z-scores to detect defects<br>
                <strong>Finance:</strong> Stock returns are standardized for risk comparison<br>
                <strong>Medical:</strong> Growth charts, lab results use percentiles from Z-scores<br>
                <strong>Research:</strong> Standardizing variables before analysis
              </div>

              <h6 class="mt-3">Normal Distribution Visualization</h6>
              <canvas id="normalExample" height="180"></canvas>
              <div class="text-center mt-2">
                <small class="text-muted">Standard normal distribution with key Z-scores marked</small>
              </div>

              <h6 class="mt-3">Key Formulas</h6>
              <div class="card" style="background: #f9fafb;">
                <div class="card-body" style="font-family: monospace; font-size: 0.85rem;">
                  <strong>Z-Score:</strong> Z = (x - μ) / σ<br>
                  <strong>Raw Score:</strong> x = μ + Z × σ<br>
                  <strong>Percentile:</strong> P = Φ(Z) × 100%<br>
                  <strong>Z from Percentile:</strong> Z = Φ⁻¹(P/100)
                </div>
              </div>
            </div>
          </div>

          <hr class="my-4">

          <h6>Common Mistakes to Avoid</h6>
          <div class="row">
            <div class="col-md-4">
              <div class="alert alert-danger" style="font-size: 0.85rem;">
                <strong>Wrong Distribution:</strong><br>
                Z-scores assume normal distribution. Non-normal data needs transformation first.
              </div>
            </div>
            <div class="col-md-4">
              <div class="alert alert-warning" style="font-size: 0.85rem;">
                <strong>Sample vs Population:</strong><br>
                Use sample SD (s) for sample data, population SD (σ) for population data.
              </div>
            </div>
            <div class="col-md-4">
              <div class="alert alert-info" style="font-size: 0.85rem;">
                <strong>Interpretation:</strong><br>
                Z-score tells position relative to mean, not absolute quality or performance.
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="mt-4">
    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>
  </div>
  <hr>
  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>
</div>
<%@ include file="body-close.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jstat@latest/dist/jstat.min.js"></script>
<script>
(function(){
  let mode = 'score';
  let normalChartInstance = null, exampleChartInstance = null;

  const btnCalc = document.getElementById('btnCalc');

  // Tab switching
  $('#modeTabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    const target = $(e.target).attr('href');
    if(target === '#scoreTab') mode = 'score';
    else if(target === '#probTab') mode = 'prob';
    else if(target === '#percentileTab') mode = 'percentile';
    else if(target === '#reverseTab') mode = 'reverse';
  });

  // Standard normal CDF
  function normalCDF(z){
    return jStat.normal.cdf(z, 0, 1);
  }

  // Inverse normal (quantile)
  function normalInv(p){
    return jStat.normal.inv(p, 0, 1);
  }

  // Normal PDF for visualization
  function normalPDF(z){
    return jStat.normal.pdf(z, 0, 1);
  }

  function drawNormalCurve(z, areaType = 'left'){
    const ctx = document.getElementById('normalCurve');
    if(!ctx) return;
    if(normalChartInstance) normalChartInstance.destroy();

    // Generate normal curve data
    const xValues = [];
    const yValues = [];
    for(let x = -4; x <= 4; x += 0.1){
      xValues.push(x);
      yValues.push(normalPDF(x));
    }

    // Determine shaded area
    let fillData = [];
    if(areaType === 'left'){
      fillData = xValues.map((x, i) => x <= z ? yValues[i] : null);
    } else if(areaType === 'right'){
      fillData = xValues.map((x, i) => x >= z ? yValues[i] : null);
    } else if(areaType === 'between'){
      fillData = xValues.map((x, i) => (x >= -Math.abs(z) && x <= Math.abs(z)) ? yValues[i] : null);
    } else if(areaType === 'outside'){
      fillData = xValues.map((x, i) => (x <= -Math.abs(z) || x >= Math.abs(z)) ? yValues[i] : null);
    }

    normalChartInstance = new Chart(ctx, {
      type: 'line',
      data: {
        labels: xValues,
        datasets: [{
          label: 'Normal Distribution',
          data: yValues,
          borderColor: 'rgba(124, 58, 237, 1)',
          borderWidth: 2,
          fill: false,
          pointRadius: 0
        }, {
          label: 'Shaded Area',
          data: fillData,
          backgroundColor: 'rgba(124, 58, 237, 0.3)',
          borderColor: 'rgba(124, 58, 237, 1)',
          borderWidth: 0,
          fill: true,
          pointRadius: 0
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 2,
        plugins: {
          legend: {display: false},
          title: {
            display: true,
            text: 'Standard Normal Distribution',
            font: {size: 12, weight: 'bold'}
          }
        },
        scales: {
          x: {
            type: 'linear',
            title: {display: true, text: 'Z-Score', font: {size: 10}},
            ticks: {font: {size: 9}}
          },
          y: {
            title: {display: true, text: 'Density', font: {size: 10}},
            ticks: {font: {size: 9}}
          }
        }
      }
    });
  }

  function calculate(){
    let statsHTML = '', interp = '';

    try {
      if(mode === 'score'){
        const x = parseFloat(document.getElementById('rawScore').value);
        const mu = parseFloat(document.getElementById('mean').value);
        const sigma = parseFloat(document.getElementById('stdDev').value);

        if(isNaN(x) || isNaN(mu) || isNaN(sigma) || sigma <= 0)
          return alert('Enter valid parameters (σ > 0)');

        const z = (x - mu) / sigma;
        const percentile = normalCDF(z) * 100;

        statsHTML = `
          <div class="stat-item"><label>Z-Score</label><div class="value">${z.toFixed(4)}</div></div>
          <div class="stat-item"><label>Percentile</label><div class="value">${percentile.toFixed(2)}%</div></div>
          <div class="stat-item"><label>Left Tail P</label><div class="value">${(normalCDF(z)).toFixed(4)}</div></div>
          <div class="stat-item"><label>Right Tail P</label><div class="value">${(1 - normalCDF(z)).toFixed(4)}</div></div>
        `;

        interp = `The raw score of <strong>${x}</strong> is <strong>${Math.abs(z).toFixed(2)} standard deviations ${z >= 0 ? 'above' : 'below'}</strong> the mean. `;
        interp += `This corresponds to the <strong>${percentile.toFixed(2)}th percentile</strong>. `;

        if(Math.abs(z) < 1) interp += 'This is within 1 SD of the mean (typical/average range).';
        else if(Math.abs(z) < 2) interp += 'This is between 1-2 SD from the mean (somewhat unusual).';
        else if(Math.abs(z) < 3) interp += 'This is between 2-3 SD from the mean (unusual/outlier).';
        else interp += 'This is more than 3 SD from the mean (extreme outlier).';

        const html = `
          <div class="result-hero">
            <div class="z-value">Z = ${z.toFixed(4)}</div>
            <div class="z-label">${percentile.toFixed(2)}th Percentile</div>
          </div>

          <h6 class="mt-3">Statistics</h6>
          <div class="stats-grid">
            ${statsHTML}
          </div>

          <div class="interpretation">
            ${interp}
          </div>

          <hr class="my-3">

          <h6 class="mt-3">Normal Distribution</h6>
          <canvas id="normalCurve"></canvas>
        `;

        document.getElementById('resultDisplay').innerHTML = html;
        drawNormalCurve(z, 'left');

      } else if(mode === 'prob'){
        const z = parseFloat(document.getElementById('zScoreProb').value);
        const areaType = document.getElementById('areaType').value;

        if(isNaN(z))
          return alert('Enter valid Z-score');

        let prob, probText;
        if(areaType === 'left'){
          prob = normalCDF(z);
          probText = `P(Z ≤ ${z.toFixed(2)})`;
        } else if(areaType === 'right'){
          prob = 1 - normalCDF(z);
          probText = `P(Z ≥ ${z.toFixed(2)})`;
        } else if(areaType === 'between'){
          prob = normalCDF(Math.abs(z)) - normalCDF(-Math.abs(z));
          probText = `P(-${Math.abs(z).toFixed(2)} ≤ Z ≤ ${Math.abs(z).toFixed(2)})`;
        } else {
          prob = (1 - normalCDF(Math.abs(z))) + normalCDF(-Math.abs(z));
          probText = `P(Z ≤ -${Math.abs(z).toFixed(2)} or Z ≥ ${Math.abs(z).toFixed(2)})`;
        }

        const percentile = prob * 100;

        statsHTML = `
          <div class="stat-item"><label>Probability</label><div class="value">${prob.toFixed(4)}</div></div>
          <div class="stat-item"><label>Percentage</label><div class="value">${percentile.toFixed(2)}%</div></div>
        `;

        interp = `The probability ${probText} = <strong>${prob.toFixed(4)}</strong> or <strong>${percentile.toFixed(2)}%</strong>.`;

        const html = `
          <div class="result-hero">
            <div class="z-value">${prob.toFixed(4)}</div>
            <div class="z-label">${probText}</div>
          </div>

          <h6 class="mt-3">Statistics</h6>
          <div class="stats-grid">
            ${statsHTML}
          </div>

          <div class="interpretation">
            ${interp}
          </div>

          <hr class="my-3">

          <h6 class="mt-3">Normal Distribution</h6>
          <canvas id="normalCurve"></canvas>
        `;

        document.getElementById('resultDisplay').innerHTML = html;
        drawNormalCurve(z, areaType);

      } else if(mode === 'percentile'){
        const percentile = parseFloat(document.getElementById('percentile').value);

        if(isNaN(percentile) || percentile <= 0 || percentile >= 100)
          return alert('Enter valid percentile (0 < p < 100)');

        const p = percentile / 100;
        const z = normalInv(p);

        statsHTML = `
          <div class="stat-item"><label>Z-Score</label><div class="value">${z.toFixed(4)}</div></div>
          <div class="stat-item"><label>Percentile</label><div class="value">${percentile.toFixed(2)}%</div></div>
          <div class="stat-item"><label>Probability</label><div class="value">${p.toFixed(4)}</div></div>
          <div class="stat-item"><label>Area Left</label><div class="value">${p.toFixed(4)}</div></div>
        `;

        interp = `The <strong>${percentile.toFixed(2)}th percentile</strong> corresponds to a Z-score of <strong>${z.toFixed(4)}</strong>. `;
        interp += `This means ${percentile.toFixed(2)}% of values fall below this point.`;

        const html = `
          <div class="result-hero">
            <div class="z-value">Z = ${z.toFixed(4)}</div>
            <div class="z-label">${percentile.toFixed(2)}th Percentile</div>
          </div>

          <h6 class="mt-3">Statistics</h6>
          <div class="stats-grid">
            ${statsHTML}
          </div>

          <div class="interpretation">
            ${interp}
          </div>

          <hr class="my-3">

          <h6 class="mt-3">Normal Distribution</h6>
          <canvas id="normalCurve"></canvas>
        `;

        document.getElementById('resultDisplay').innerHTML = html;
        drawNormalCurve(z, 'left');

      } else if(mode === 'reverse'){
        const z = parseFloat(document.getElementById('zScoreReverse').value);
        const mu = parseFloat(document.getElementById('meanReverse').value);
        const sigma = parseFloat(document.getElementById('stdDevReverse').value);

        if(isNaN(z) || isNaN(mu) || isNaN(sigma) || sigma <= 0)
          return alert('Enter valid parameters (σ > 0)');

        const x = mu + z * sigma;
        const percentile = normalCDF(z) * 100;

        statsHTML = `
          <div class="stat-item"><label>Raw Score</label><div class="value">${x.toFixed(4)}</div></div>
          <div class="stat-item"><label>Z-Score</label><div class="value">${z.toFixed(4)}</div></div>
          <div class="stat-item"><label>Percentile</label><div class="value">${percentile.toFixed(2)}%</div></div>
          <div class="stat-item"><label>Distance from Mean</label><div class="value">${Math.abs(x - mu).toFixed(2)}</div></div>
        `;

        interp = `A Z-score of <strong>${z.toFixed(4)}</strong> converts to a raw score of <strong>${x.toFixed(4)}</strong> `;
        interp += `on a scale with mean = ${mu} and SD = ${sigma}. `;
        interp += `This is at the <strong>${percentile.toFixed(2)}th percentile</strong>.`;

        const html = `
          <div class="result-hero">
            <div class="z-value">x = ${x.toFixed(4)}</div>
            <div class="z-label">Raw Score</div>
          </div>

          <h6 class="mt-3">Statistics</h6>
          <div class="stats-grid">
            ${statsHTML}
          </div>

          <div class="interpretation">
            ${interp}
          </div>

          <hr class="my-3">

          <h6 class="mt-3">Normal Distribution</h6>
          <canvas id="normalCurve"></canvas>
        `;

        document.getElementById('resultDisplay').innerHTML = html;
        drawNormalCurve(z, 'left');
      }

    } catch(e){
      console.error(e);
      alert('Error in calculation');
    }
  }

  // Draw educational example chart
  function drawExampleChart(){
    const ctx = document.getElementById('normalExample');
    if(!ctx) return;

    const xValues = [];
    const yValues = [];
    for(let x = -4; x <= 4; x += 0.1){
      xValues.push(x);
      yValues.push(normalPDF(x));
    }

    exampleChartInstance = new Chart(ctx, {
      type: 'line',
      data: {
        labels: xValues,
        datasets: [{
          label: 'Standard Normal',
          data: yValues,
          borderColor: 'rgba(124, 58, 237, 1)',
          backgroundColor: 'rgba(124, 58, 237, 0.1)',
          borderWidth: 2,
          fill: true,
          pointRadius: 0
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: {display: false},
          title: {
            display: true,
            text: 'Standard Normal Distribution (μ=0, σ=1)',
            font: {size: 11, weight: 'bold'}
          },
          annotation: {
            annotations: {
              line1: {
                type: 'line',
                xMin: -1.96,
                xMax: -1.96,
                borderColor: 'rgba(239, 68, 68, 0.5)',
                borderWidth: 2,
                borderDash: [5, 5],
                label: {
                  content: 'Z=-1.96',
                  enabled: true,
                  position: 'start'
                }
              },
              line2: {
                type: 'line',
                xMin: 1.96,
                xMax: 1.96,
                borderColor: 'rgba(239, 68, 68, 0.5)',
                borderWidth: 2,
                borderDash: [5, 5]
              }
            }
          }
        },
        scales: {
          x: {
            type: 'linear',
            title: {display: true, text: 'Z-Score', font: {size: 9}},
            ticks: {font: {size: 9}}
          },
          y: {
            title: {display: true, text: 'Density', font: {size: 9}},
            ticks: {font: {size: 9}}
          }
        }
      }
    });
  }

  btnCalc.addEventListener('click', calculate);
  document.addEventListener('keypress', e => e.key === 'Enter' && calculate());
  window.addEventListener('load', drawExampleChart);
})();
</script>
