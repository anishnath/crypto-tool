<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Sample Size Calculator — Surveys, A/B Testing, Research Studies</title>
<meta name="description" content="Calculate required sample size for surveys, experiments, and research. Supports proportion estimation, mean estimation, and A/B testing with confidence levels.">
<meta name="keywords" content="sample size calculator, survey sample size, a/b test sample size, statistical power, confidence level, margin of error, research sample size">
<link rel="canonical" href="https://8gwifi.org/sample-size-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Sample Size Calculator — Statistical Power Analysis">
<meta property="og:description" content="Determine optimal sample size for surveys, A/B tests, and research studies.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/sample-size-calculator.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Sample Size Calculator">
<meta name="twitter:description" content="Calculate sample size for statistical studies with confidence.">

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
    background: linear-gradient(135deg, #065f46, #059669);
    border-radius: 12px;
    margin-bottom: 1.5rem;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  }
  .result-hero .sample-size {
    font-size: 3rem;
    font-weight: 800;
    color: white;
    margin: 0;
    line-height: 1;
  }
  .result-hero .subtitle {
    color: rgba(255,255,255,0.9);
    margin-top: 0.5rem;
    font-size: 1rem;
  }

  /* Confidence Pills */
  .conf-selector {
    display: flex;
    gap: 0.5rem;
    margin: 1rem 0;
    flex-wrap: wrap;
  }
  .conf-pill {
    padding: 0.5rem 1rem;
    border: 2px solid #e5e7eb;
    border-radius: 20px;
    background: white;
    cursor: pointer;
    font-weight: 600;
    color: #6b7280;
    transition: all 0.2s;
  }
  .conf-pill:hover { border-color: #10b981; }
  .conf-pill.active { border-color: #10b981; background: #ecfdf5; color: #10b981; }

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
    border-color: #10b981;
    box-shadow: 0 0 0 3px rgba(16,185,129,0.1);
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
    background: #10b981;
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    font-size: 1.05rem;
    cursor: pointer;
    transition: all 0.2s;
  }
  .btn-calc:hover { background: #059669; transform: translateY(-1px); }

  .formula-line {
    padding: 0.4rem 0;
    font-family: 'Courier New', monospace;
    font-size: 0.9rem;
    line-height: 1.7;
  }
  .formula-line strong { color: #10b981; }

  .interpretation {
    background: #f9fafb;
    border-left: 4px solid #10b981;
    padding: 1rem;
    border-radius: 4px;
    margin: 1rem 0;
    line-height: 1.6;
  }

  #customConfInput {
    width: 70px;
    padding: 0.25rem;
    border: 1px solid #d1d5db;
    border-radius: 4px;
    margin-left: 0.5rem;
  }

  /* Educational section */
  .edu-card {
    background: #f0fdf4;
    border-left: 4px solid #10b981;
    padding: 1rem;
    border-radius: 6px;
    margin-bottom: 1rem;
  }
  .edu-card h6 {
    color: #065f46;
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
    .result-hero .sample-size { font-size: 2.5rem; }
  }
</style>

<script type="application/ld+json">
{
  "@context":"https://schema.org",
  "@type":"WebApplication",
  "name":"Sample Size Calculator",
  "url":"https://8gwifi.org/sample-size-calculator.jsp",
  "description":"Calculate required sample size for surveys, experiments, and statistical studies with confidence intervals. Free online tool for researchers, statisticians, and data scientists.",
  "applicationCategory":"EducationalApplication",
  "operatingSystem":"Any",
  "browserRequirements":"Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Survey sample size, Mean estimation, A/B test calculator, Two-sample comparison, Confidence interval calculation, Statistical power analysis",
  "screenshot": "https://8gwifi.org/images/sample-size-calculator.png",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.7",
    "ratingCount": "980"
  }
}
</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1>Sample Size Calculator</h1>
  <p class="text-muted">Determine the optimal sample size for your surveys, experiments, and research studies.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column - Input Forms -->
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h5 class="card-title mb-3">Sample Size Parameters</h5>

          <!-- Calculation Type Tabs -->
          <ul class="nav nav-tabs mb-3" id="calcTypeTabs" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="prop-tab" data-toggle="tab" href="#propTab" role="tab">Survey</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="mean-tab" data-toggle="tab" href="#meanTab" role="tab">Mean</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="ab-tab" data-toggle="tab" href="#abTab" role="tab">A/B Test</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="compare-tab" data-toggle="tab" href="#compareTab" role="tab">Compare</a>
            </li>
          </ul>

          <!-- Confidence Level -->
          <div class="mb-3">
            <label style="display:block; margin-bottom:0.5rem; font-weight:600; color:#374151;">Confidence Level:</label>
            <div class="conf-selector">
              <div class="conf-pill" data-conf="90">90%</div>
              <div class="conf-pill active" data-conf="95">95%</div>
              <div class="conf-pill" data-conf="99">99%</div>
              <div class="conf-pill" data-conf="custom">Custom
                <input type="number" id="customConfInput" value="95" step="0.1" min="50" max="99.99" style="display:none;">
              </div>
            </div>
          </div>

          <div class="tab-content" id="calcTypeTabContent">
            <!-- Proportion Tab -->
            <div class="tab-pane fade show active" id="propTab" role="tabpanel">
              <div class="form-group">
                <label>Expected Proportion (p)</label>
                <input type="number" id="proportion" value="0.5" step="0.01" min="0" max="1" class="form-control">
                <small>Use 0.5 for maximum (most conservative)</small>
              </div>
              <div class="form-group">
                <label>Margin of Error (E)</label>
                <input type="number" id="marginError" value="0.05" step="0.01" min="0.001" max="1" class="form-control">
                <small>e.g., ±5% = 0.05</small>
              </div>
              <div class="form-group">
                <label>Population Size (optional)</label>
                <input type="number" id="popSize" placeholder="Leave blank if large" class="form-control">
                <small>For finite population correction</small>
              </div>
            </div>

            <!-- Mean Tab -->
            <div class="tab-pane fade" id="meanTab" role="tabpanel">
              <div class="form-group">
                <label>Standard Deviation (σ)</label>
                <input type="number" id="stdDev" value="15" step="0.1" min="0" class="form-control">
                <small>From pilot study or historical data</small>
              </div>
              <div class="form-group">
                <label>Margin of Error (E)</label>
                <input type="number" id="marginErrorMean" value="5" step="0.1" min="0" class="form-control">
                <small>Desired precision</small>
              </div>
              <div class="form-group">
                <label>Population Size (optional)</label>
                <input type="number" id="popSizeMean" placeholder="Leave blank if large" class="form-control">
                <small>For finite population correction</small>
              </div>
            </div>

            <!-- A/B Test Tab -->
            <div class="tab-pane fade" id="abTab" role="tabpanel">
              <div class="form-group">
                <label>Baseline Proportion (p1)</label>
                <input type="number" id="p1" value="0.10" step="0.01" min="0" max="1" class="form-control">
                <small>Control group rate</small>
              </div>
              <div class="form-group">
                <label>Expected Proportion (p2)</label>
                <input type="number" id="p2" value="0.15" step="0.01" min="0" max="1" class="form-control">
                <small>Treatment group rate</small>
              </div>
              <div class="form-group">
                <label>Statistical Power (%)</label>
                <input type="number" id="power" value="80" step="1" min="50" max="99" class="form-control">
                <small>Usually 80% or 90%</small>
              </div>
            </div>

            <!-- Compare Means Tab -->
            <div class="tab-pane fade" id="compareTab" role="tabpanel">
              <div class="form-group">
                <label>Pooled Std Dev (σ)</label>
                <input type="number" id="stdDevBoth" value="10" step="0.1" min="0" class="form-control">
                <small>Assumed equal for both groups</small>
              </div>
              <div class="form-group">
                <label>Effect Size (|μ1 - μ2|)</label>
                <input type="number" id="effectSize" value="5" step="0.1" min="0" class="form-control">
                <small>Minimum detectable difference</small>
              </div>
              <div class="form-group">
                <label>Statistical Power (%)</label>
                <input type="number" id="powerMeans" value="80" step="1" min="50" max="99" class="form-control">
                <small>Usually 80% or 90%</small>
              </div>
            </div>
          </div>

          <button class="btn-calc mt-3" id="btnCalc">Calculate Sample Size</button>
        </div>
      </div>
    </div>

    <!-- Right Column - Results -->
    <div class="col-lg-5 mb-4">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title">Results</h5>
          <div id="resultDisplay">
            <p class="text-muted">Enter your parameters and click "Calculate Sample Size" to see results.</p>
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
          <h5 class="mb-0">Understanding Sample Size & Statistical Power</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6">
              <div class="edu-card">
                <h6>What is Sample Size?</h6>
                <p>Sample size (n) is the number of observations or participants needed in a study to draw reliable conclusions about a population. Larger samples generally provide more accurate estimates but cost more to collect.</p>
              </div>

              <div class="edu-card">
                <h6>Why Sample Size Matters</h6>
                <p><strong>Too Small:</strong> Results may be unreliable, missing important effects (Type II error)<br>
                <strong>Too Large:</strong> Wastes resources, time, and money<br>
                <strong>Just Right:</strong> Balances statistical power with practical constraints</p>
              </div>

              <div class="edu-card">
                <h6>Key Factors Affecting Sample Size</h6>
                <p>
                  <strong>Confidence Level:</strong> How certain you want to be (95% is standard)<br>
                  <strong>Margin of Error:</strong> Acceptable uncertainty in your estimate<br>
                  <strong>Expected Variability:</strong> Standard deviation or proportion<br>
                  <strong>Effect Size:</strong> The minimum difference you want to detect
                </p>
              </div>

              <h6 class="mt-3">Common Confidence Levels</h6>
              <div class="table-responsive">
                <table class="table table-sm table-bordered">
                  <thead class="thead-light">
                    <tr>
                      <th>Confidence Level</th>
                      <th>Z-Score</th>
                      <th>Use Case</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>90%</td>
                      <td>1.645</td>
                      <td>Quick surveys, preliminary studies</td>
                    </tr>
                    <tr>
                      <td>95%</td>
                      <td>1.96</td>
                      <td>Standard for most research</td>
                    </tr>
                    <tr>
                      <td>99%</td>
                      <td>2.576</td>
                      <td>High-stakes decisions, medical studies</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div class="col-md-6">
              <h6>Interpretation Guide</h6>

              <div class="card mb-3" style="border-left: 4px solid #10b981;">
                <div class="card-body">
                  <h6 class="card-title text-success">Survey / Proportion</h6>
                  <p class="card-text small mb-1"><strong>Formula:</strong> n = (Z² × p × (1-p)) / E²</p>
                  <p class="card-text small mb-0"><strong>Example:</strong> To estimate election results within ±3% at 95% confidence, you need ~1,067 voters</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #3b82f6;">
                <div class="card-body">
                  <h6 class="card-title text-primary">Mean Estimation</h6>
                  <p class="card-text small mb-1"><strong>Formula:</strong> n = (Z² × σ²) / E²</p>
                  <p class="card-text small mb-0"><strong>Example:</strong> To estimate average height within ±2cm (σ=10cm) at 95% confidence, you need ~97 people</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #f59e0b;">
                <div class="card-body">
                  <h6 class="card-title text-warning">A/B Testing</h6>
                  <p class="card-text small mb-1"><strong>Formula:</strong> n = 2 × (Z + Z_β)² × p̄(1-p̄) / Δ²</p>
                  <p class="card-text small mb-0"><strong>Example:</strong> To detect a 5% improvement (10%→15%) with 80% power, you need ~620 per group</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #8b5cf6;">
                <div class="card-body">
                  <h6 class="card-title text-purple">Comparing Means</h6>
                  <p class="card-text small mb-1"><strong>Formula:</strong> n = 2 × [(Z + Z_β) × σ / Δ]²</p>
                  <p class="card-text small mb-0"><strong>Example:</strong> To detect a 5-point difference (σ=10) with 80% power, you need ~64 per group</p>
                </div>
              </div>

              <h6 class="mt-3">Statistical Power</h6>
              <div class="alert alert-info" style="font-size: 0.9rem;">
                <strong>Power = 1 - β</strong> is the probability of detecting an effect when it truly exists.<br>
                <strong>80% Power:</strong> Standard for most studies (20% chance of missing a real effect)<br>
                <strong>90% Power:</strong> More conservative, requires larger samples
              </div>

              <h6 class="mt-3">Sample Size Visualization</h6>
              <canvas id="sampleSizeChart" height="200"></canvas>
              <div class="text-center mt-2">
                <small class="text-muted">Shows how sample size increases with confidence level (for a typical survey)</small>
              </div>
            </div>
          </div>

          <hr class="my-4">

          <h6>Practical Tips</h6>
          <div class="row">
            <div class="col-md-4">
              <div class="alert alert-success" style="font-size: 0.85rem;">
                <strong>For Surveys:</strong><br>
                • Use p=0.5 if unsure (most conservative)<br>
                • ±3-5% margin is typical<br>
                • Consider response rates
              </div>
            </div>
            <div class="col-md-4">
              <div class="alert alert-warning" style="font-size: 0.85rem;">
                <strong>For A/B Tests:</strong><br>
                • Smaller effects need larger samples<br>
                • 80% power is standard<br>
                • Account for conversion rates
              </div>
            </div>
            <div class="col-md-4">
              <div class="alert alert-info" style="font-size: 0.85rem;">
                <strong>For Experiments:</strong><br>
                • Pilot studies help estimate σ<br>
                • Consider practical significance<br>
                • Budget and time constraints
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
<script>
(function(){
  let calcType = 'proportion', confidence = 95;
  let sampleSizeChartInstance = null;

  const confPills = document.querySelectorAll('.conf-pill');
  const customInput = document.getElementById('customConfInput');
  const btnCalc = document.getElementById('btnCalc');

  // Tab switching - determine calc type based on active tab
  $('#calcTypeTabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    const target = $(e.target).attr('href');
    if(target === '#propTab') calcType = 'proportion';
    else if(target === '#meanTab') calcType = 'mean';
    else if(target === '#abTab') calcType = 'twoProps';
    else if(target === '#compareTab') calcType = 'twoMeans';
  });

  // Confidence switching
  confPills.forEach(pill => {
    pill.addEventListener('click', () => {
      confPills.forEach(p => p.classList.remove('active'));
      pill.classList.add('active');

      if(pill.dataset.conf === 'custom'){
        customInput.style.display = 'inline-block';
        confidence = parseFloat(customInput.value);
      } else {
        customInput.style.display = 'none';
        confidence = parseFloat(pill.dataset.conf);
      }
    });
  });

  customInput.addEventListener('input', () => confidence = parseFloat(customInput.value));

  function getZScore(conf){
    if(conf >= 99.9) return 3.291;
    if(conf >= 99.5) return 2.807;
    if(conf >= 99) return 2.576;
    if(conf >= 98) return 2.326;
    if(conf >= 95) return 1.96;
    if(conf >= 90) return 1.645;
    if(conf >= 85) return 1.44;
    if(conf >= 80) return 1.28;
    return Math.sqrt(-2 * Math.log(1 - (conf / 100 + 1) / 2));
  }

  function calculate(){
    const z = getZScore(confidence);
    let n = 0, formula = '', interp = '', subtitle = '';

    try {
      if(calcType === 'proportion'){
        const p = parseFloat(document.getElementById('proportion').value);
        const e = parseFloat(document.getElementById('marginError').value);
        const N = document.getElementById('popSize').value;

        if(isNaN(p) || isNaN(e) || p < 0 || p > 1 || e <= 0)
          return alert('Enter valid proportion and margin of error');

        let n0 = (z * z * p * (1 - p)) / (e * e);

        if(N && !isNaN(N) && N > 0){
          const Nval = parseFloat(N);
          n = Math.ceil(n0 / (1 + (n0 - 1) / Nval));
          formula = `<div class="formula-line">n₀ = (Z² × p × (1-p)) / E² = ${Math.ceil(n0)}</div>`;
          formula += `<div class="formula-line">n = n₀ / (1 + (n₀-1) / N) = <strong>${n}</strong></div>`;
        } else {
          n = Math.ceil(n0);
          formula = `<div class="formula-line">n = (Z² × p × (1-p)) / E²</div>`;
          formula += `<div class="formula-line">n = (${z.toFixed(3)}² × ${p} × ${1-p}) / ${e}²</div>`;
          formula += `<div class="formula-line"><strong>n = ${n}</strong></div>`;
        }

        interp = `For <strong>${confidence}% confidence</strong> with <strong>±${(e*100).toFixed(1)}% margin of error</strong>, you need <strong>${n} respondents</strong>.`;
        subtitle = 'respondents needed';

      } else if(calcType === 'mean'){
        const sigma = parseFloat(document.getElementById('stdDev').value);
        const e = parseFloat(document.getElementById('marginErrorMean').value);
        const N = document.getElementById('popSizeMean').value;

        if(isNaN(sigma) || isNaN(e) || sigma <= 0 || e <= 0)
          return alert('Enter valid standard deviation and margin of error');

        let n0 = (z * z * sigma * sigma) / (e * e);

        if(N && !isNaN(N) && N > 0){
          const Nval = parseFloat(N);
          n = Math.ceil(n0 / (1 + (n0 - 1) / Nval));
          formula = `<div class="formula-line">n₀ = (Z² × σ²) / E² = ${Math.ceil(n0)}</div>`;
          formula += `<div class="formula-line">n = n₀ / (1 + (n₀-1) / N) = <strong>${n}</strong></div>`;
        } else {
          n = Math.ceil(n0);
          formula = `<div class="formula-line">n = (Z² × σ²) / E²</div>`;
          formula += `<div class="formula-line">n = (${z.toFixed(3)}² × ${sigma}²) / ${e}²</div>`;
          formula += `<div class="formula-line"><strong>n = ${n}</strong></div>`;
        }

        interp = `For <strong>${confidence}% confidence</strong> with <strong>±${e} margin of error</strong>, you need <strong>${n} observations</strong>.`;
        subtitle = 'observations needed';

      } else if(calcType === 'twoProps'){
        const p1 = parseFloat(document.getElementById('p1').value);
        const p2 = parseFloat(document.getElementById('p2').value);
        const power = parseFloat(document.getElementById('power').value);

        if(isNaN(p1) || isNaN(p2) || isNaN(power) || p1 < 0 || p1 > 1 || p2 < 0 || p2 > 1)
          return alert('Enter valid proportions and power');

        const zBeta = getZScore(power);
        const pAvg = (p1 + p2) / 2;
        const delta = Math.abs(p2 - p1);

        n = Math.ceil(2 * Math.pow((z + zBeta), 2) * pAvg * (1 - pAvg) / Math.pow(delta, 2));

        formula = `<div class="formula-line">n per group = 2 × (Z + Z_β)² × p̄(1-p̄) / Δ²</div>`;
        formula += `<div class="formula-line">p̄ = ${pAvg.toFixed(4)}, Δ = ${delta.toFixed(4)}</div>`;
        formula += `<div class="formula-line"><strong>n per group = ${n}</strong></div>`;
        formula += `<div class="formula-line"><strong>Total = ${n * 2}</strong></div>`;

        interp = `To detect a difference from <strong>${(p1*100).toFixed(1)}%</strong> to <strong>${(p2*100).toFixed(1)}%</strong> with <strong>${power}% power</strong>, you need <strong>${n} per group</strong> (total: ${n*2}).`;
        subtitle = `per group (total: ${n * 2})`;

      } else if(calcType === 'twoMeans'){
        const sigma = parseFloat(document.getElementById('stdDevBoth').value);
        const delta = parseFloat(document.getElementById('effectSize').value);
        const power = parseFloat(document.getElementById('powerMeans').value);

        if(isNaN(sigma) || isNaN(delta) || isNaN(power) || sigma <= 0 || delta <= 0)
          return alert('Enter valid parameters');

        const zBeta = getZScore(power);
        n = Math.ceil(2 * Math.pow((z + zBeta) * sigma / delta, 2));

        formula = `<div class="formula-line">n per group = 2 × [(Z + Z_β) × σ / Δ]²</div>`;
        formula += `<div class="formula-line">Z = ${z.toFixed(3)}, Z_β = ${zBeta.toFixed(3)}</div>`;
        formula += `<div class="formula-line"><strong>n per group = ${n}</strong></div>`;
        formula += `<div class="formula-line"><strong>Total = ${n * 2}</strong></div>`;

        interp = `To detect a difference of <strong>${delta}</strong> with <strong>${power}% power</strong>, you need <strong>${n} per group</strong> (total: ${n*2}).`;
        subtitle = `per group (total: ${n * 2})`;
      }

      // Display results in right panel
      const html = `
        <div class="result-hero">
          <div class="sample-size">n = ${n.toLocaleString()}</div>
          <div class="subtitle">${subtitle}</div>
        </div>

        <h6 class="mt-3">Calculation Details</h6>
        ${formula}

        <div class="interpretation">
          ${interp}
        </div>
      `;

      document.getElementById('resultDisplay').innerHTML = html;

    } catch(e){
      console.error(e);
      alert('Error calculating sample size');
    }
  }

  // Draw static educational chart showing relationship between confidence and sample size
  function drawEducationalChart(){
    const ctx = document.getElementById('sampleSizeChart');
    if(!ctx) return;

    if(sampleSizeChartInstance){
      sampleSizeChartInstance.destroy();
    }

    // Calculate sample sizes for different confidence levels (p=0.5, E=0.05)
    const confLevels = [80, 85, 90, 95, 98, 99, 99.5];
    const sampleSizes = confLevels.map(conf => {
      const z = getZScore(conf);
      return Math.ceil((z * z * 0.5 * 0.5) / (0.05 * 0.05));
    });

    sampleSizeChartInstance = new Chart(ctx, {
      type: 'line',
      data: {
        labels: confLevels.map(c => c + '%'),
        datasets: [{
          label: 'Sample Size Required',
          data: sampleSizes,
          borderColor: 'rgba(16, 185, 129, 1)',
          backgroundColor: 'rgba(16, 185, 129, 0.1)',
          borderWidth: 3,
          fill: true,
          tension: 0.4,
          pointRadius: 5,
          pointHoverRadius: 7
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          },
          title: {
            display: true,
            text: 'Sample Size vs Confidence Level (p=0.5, E=±5%)',
            font: { size: 14, weight: 'bold' }
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                return 'n = ' + context.parsed.y.toLocaleString();
              }
            }
          }
        },
        scales: {
          x: {
            title: {
              display: true,
              text: 'Confidence Level',
              font: { weight: 'bold' }
            }
          },
          y: {
            title: {
              display: true,
              text: 'Sample Size (n)',
              font: { weight: 'bold' }
            },
            beginAtZero: true
          }
        }
      }
    });
  }

  btnCalc.addEventListener('click', calculate);
  document.addEventListener('keypress', e => e.key === 'Enter' && calculate());

  // Draw educational chart on page load
  window.addEventListener('load', drawEducationalChart);
})();
</script>
