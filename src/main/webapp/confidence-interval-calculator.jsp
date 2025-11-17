<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Confidence Interval Calculator — Mean, Proportion, Difference CI</title>
<meta name="description" content="Calculate confidence intervals for means, proportions, and differences. Supports one-sample and two-sample confidence intervals with visualization. Free statistical CI calculator.">
<meta name="keywords" content="confidence interval calculator, CI calculator, mean confidence interval, proportion confidence interval, 95% confidence interval, statistical confidence interval, margin of error">
<link rel="canonical" href="https://8gwifi.org/confidence-interval-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Confidence Interval Calculator — Statistical Analysis Tool">
<meta property="og:description" content="Calculate confidence intervals for means and proportions with interactive visualization.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/confidence-interval-calculator.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Confidence Interval Calculator">
<meta name="twitter:description" content="Free online confidence interval calculator for statistical analysis.">

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
    background: linear-gradient(135deg, #0891b2, #06b6d4);
    border-radius: 12px;
    margin-bottom: 1.5rem;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  }
  .result-hero .ci-value {
    font-size: 2rem;
    font-weight: 800;
    color: white;
    margin: 0;
    line-height: 1.2;
  }
  .result-hero .ci-label {
    color: rgba(255,255,255,0.9);
    margin-top: 0.5rem;
    font-size: 0.95rem;
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
  .conf-pill:hover { border-color: #06b6d4; }
  .conf-pill.active { border-color: #06b6d4; background: #ecfeff; color: #0891b2; }

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
    border-color: #06b6d4;
    box-shadow: 0 0 0 3px rgba(6,182,212,0.1);
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
    background: #06b6d4;
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    font-size: 1.05rem;
    cursor: pointer;
    transition: all 0.2s;
  }
  .btn-calc:hover { background: #0891b2; transform: translateY(-1px); }

  .stats-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 0.75rem;
    margin-bottom: 1rem;
  }
  .stat-item {
    background: #f0fdfa;
    padding: 0.75rem;
    border-radius: 6px;
    text-align: center;
  }
  .stat-item label {
    display: block;
    font-size: 0.75rem;
    color: #0891b2;
    margin-bottom: 0.25rem;
    font-weight: 600;
  }
  .stat-item .value {
    font-size: 1.25rem;
    font-weight: 800;
    color: #0e7490;
  }

  .interpretation {
    background: #f0fdfa;
    border-left: 4px solid #06b6d4;
    padding: 1rem;
    border-radius: 4px;
    margin: 1rem 0;
    line-height: 1.6;
    font-size: 0.9rem;
  }

  #customConfInput {
    width: 70px;
    padding: 0.25rem;
    border: 1px solid #d1d5db;
    border-radius: 4px;
    margin-left: 0.5rem;
  }

  #ciChart {
    width: 100%;
    max-height: 200px;
  }

  /* Educational section */
  .edu-card {
    background: #ecfeff;
    border-left: 4px solid #06b6d4;
    padding: 1rem;
    border-radius: 6px;
    margin-bottom: 1rem;
  }
  .edu-card h6 {
    color: #0e7490;
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
    .result-hero .ci-value { font-size: 1.5rem; }
    .stats-grid { grid-template-columns: 1fr; }
  }
</style>

<script type="application/ld+json">
{
  "@context":"https://schema.org",
  "@type":"WebApplication",
  "name":"Confidence Interval Calculator",
  "url":"https://8gwifi.org/confidence-interval-calculator.jsp",
  "description":"Calculate confidence intervals for means, proportions, and differences. Free online statistical tool with visualization for one-sample and two-sample confidence intervals.",
  "applicationCategory":"EducationalApplication",
  "operatingSystem":"Any",
  "browserRequirements":"Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Mean confidence interval, Proportion confidence interval, Two-sample CI, Difference CI, 90-99% confidence levels, Visual CI display, Margin of error calculation",
  "screenshot": "https://8gwifi.org/images/confidence-interval-calculator.png",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "1580"
  }
}
</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1>Confidence Interval Calculator</h1>
  <p class="text-muted">Calculate confidence intervals for means, proportions, and differences with interactive visualization.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column - Input Forms -->
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h5 class="card-title mb-3">Confidence Interval Parameters</h5>

          <!-- CI Type Tabs -->
          <ul class="nav nav-tabs mb-3" id="ciTypeTabs" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="mean-tab" data-toggle="tab" href="#meanTab" role="tab">Mean (1-Sample)</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="proportion-tab" data-toggle="tab" href="#proportionTab" role="tab">Proportion</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="two-mean-tab" data-toggle="tab" href="#twoMeanTab" role="tab">2-Sample Mean</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="two-prop-tab" data-toggle="tab" href="#twoPropTab" role="tab">2-Sample Prop</a>
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

          <div class="tab-content" id="ciTypeTabContent">
            <!-- Mean Tab -->
            <div class="tab-pane fade show active" id="meanTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>One-sample mean CI:</strong> Estimate the population mean from sample data.
              </div>
              <div class="form-group">
                <label>Sample Mean (x̄)</label>
                <input type="number" id="meanSample" value="50" step="0.01" class="form-control">
                <small>Average of your sample data</small>
              </div>
              <div class="form-group">
                <label>Standard Deviation (s)</label>
                <input type="number" id="stdDevSample" value="10" step="0.01" min="0" class="form-control">
                <small>Sample standard deviation</small>
              </div>
              <div class="form-group">
                <label>Sample Size (n)</label>
                <input type="number" id="sampleSize" value="30" step="1" min="2" class="form-control">
                <small>Number of observations in sample</small>
              </div>
            </div>

            <!-- Proportion Tab -->
            <div class="tab-pane fade" id="proportionTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>Proportion CI:</strong> Estimate the population proportion (percentage).
              </div>
              <div class="form-group">
                <label>Number of Successes (x)</label>
                <input type="number" id="successes" value="45" step="1" min="0" class="form-control">
                <small>Count of favorable outcomes</small>
              </div>
              <div class="form-group">
                <label>Sample Size (n)</label>
                <input type="number" id="sampleSizeProp" value="100" step="1" min="1" class="form-control">
                <small>Total number of trials</small>
              </div>
            </div>

            <!-- Two-Sample Mean Tab -->
            <div class="tab-pane fade" id="twoMeanTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>Two-sample mean CI:</strong> Compare two population means.
              </div>
              <div class="row">
                <div class="col-md-6">
                  <h6 class="text-muted mb-2">Sample 1</h6>
                  <div class="form-group">
                    <label>Mean (x̄₁)</label>
                    <input type="number" id="mean1" value="50" step="0.01" class="form-control">
                  </div>
                  <div class="form-group">
                    <label>Std Dev (s₁)</label>
                    <input type="number" id="sd1" value="10" step="0.01" min="0" class="form-control">
                  </div>
                  <div class="form-group">
                    <label>Size (n₁)</label>
                    <input type="number" id="n1" value="30" step="1" min="2" class="form-control">
                  </div>
                </div>
                <div class="col-md-6">
                  <h6 class="text-muted mb-2">Sample 2</h6>
                  <div class="form-group">
                    <label>Mean (x̄₂)</label>
                    <input type="number" id="mean2" value="55" step="0.01" class="form-control">
                  </div>
                  <div class="form-group">
                    <label>Std Dev (s₂)</label>
                    <input type="number" id="sd2" value="12" step="0.01" min="0" class="form-control">
                  </div>
                  <div class="form-group">
                    <label>Size (n₂)</label>
                    <input type="number" id="n2" value="30" step="1" min="2" class="form-control">
                  </div>
                </div>
              </div>
            </div>

            <!-- Two-Sample Proportion Tab -->
            <div class="tab-pane fade" id="twoPropTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>Two-sample proportion CI:</strong> Compare two population proportions.
              </div>
              <div class="row">
                <div class="col-md-6">
                  <h6 class="text-muted mb-2">Sample 1</h6>
                  <div class="form-group">
                    <label>Successes (x₁)</label>
                    <input type="number" id="x1" value="45" step="1" min="0" class="form-control">
                  </div>
                  <div class="form-group">
                    <label>Size (n₁)</label>
                    <input type="number" id="np1" value="100" step="1" min="1" class="form-control">
                  </div>
                </div>
                <div class="col-md-6">
                  <h6 class="text-muted mb-2">Sample 2</h6>
                  <div class="form-group">
                    <label>Successes (x₂)</label>
                    <input type="number" id="x2" value="60" step="1" min="0" class="form-control">
                  </div>
                  <div class="form-group">
                    <label>Size (n₂)</label>
                    <input type="number" id="np2" value="100" step="1" min="1" class="form-control">
                  </div>
                </div>
              </div>
            </div>
          </div>

          <button class="btn-calc mt-3" id="btnCalc">Calculate Confidence Interval</button>
        </div>
      </div>
    </div>

    <!-- Right Column - Results -->
    <div class="col-lg-5 mb-4">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title">Results</h5>
          <div id="resultDisplay">
            <p class="text-muted">Enter your parameters and click "Calculate Confidence Interval" to see results.</p>
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
          <h5 class="mb-0">Understanding Confidence Intervals</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6">
              <div class="edu-card">
                <h6>What is a Confidence Interval?</h6>
                <p>A confidence interval (CI) is a range of values that likely contains the true population parameter with a specified level of confidence. For example, a 95% CI means we're 95% confident the true value lies within this range.</p>
              </div>

              <div class="edu-card">
                <h6>Why Use Confidence Intervals?</h6>
                <p><strong>Point estimates alone are insufficient:</strong> A single sample statistic (like a mean) doesn't tell us about uncertainty.<br><br>
                <strong>CI provides a range:</strong> Shows precision of our estimate and accounts for sampling variability.<br><br>
                <strong>Better decision making:</strong> Helps assess practical significance beyond just statistical significance.</p>
              </div>

              <div class="edu-card">
                <h6>Interpreting Confidence Intervals</h6>
                <p><strong>Correct:</strong> "We are 95% confident that the true population mean lies between 45 and 55."<br><br>
                <strong>Incorrect:</strong> "There's a 95% probability the true mean is in this interval." (The true mean is fixed, not random)<br><br>
                <strong>Width matters:</strong> Narrower CI = more precise estimate. Wider CI = more uncertainty.</p>
              </div>

              <h6 class="mt-3">Common Confidence Levels</h6>
              <div class="table-responsive">
                <table class="table table-sm table-bordered">
                  <thead class="thead-light">
                    <tr>
                      <th>Confidence Level</th>
                      <th>Critical Value (Z)</th>
                      <th>Use Case</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>90%</td>
                      <td>1.645</td>
                      <td>Quick estimates, exploratory analysis</td>
                    </tr>
                    <tr>
                      <td>95%</td>
                      <td>1.96</td>
                      <td>Standard for most research</td>
                    </tr>
                    <tr>
                      <td>99%</td>
                      <td>2.576</td>
                      <td>High-stakes decisions, critical applications</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div class="col-md-6">
              <h6>Formulas for Confidence Intervals</h6>

              <div class="card mb-3" style="border-left: 4px solid #06b6d4;">
                <div class="card-body">
                  <h6 class="card-title text-info">One-Sample Mean</h6>
                  <p class="card-text small mb-1"><strong>Formula:</strong> CI = x̄ ± t × (s/√n)</p>
                  <p class="card-text small mb-1">Where: t = t-critical value for (n-1) degrees of freedom</p>
                  <p class="card-text small mb-0"><strong>Example:</strong> Mean = 50, s = 10, n = 30, 95% CI → [46.24, 53.76]</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #10b981;">
                <div class="card-body">
                  <h6 class="card-title text-success">Proportion</h6>
                  <p class="card-text small mb-1"><strong>Formula:</strong> CI = p̂ ± Z × √(p̂(1-p̂)/n)</p>
                  <p class="card-text small mb-1">Where: p̂ = x/n (sample proportion)</p>
                  <p class="card-text small mb-0"><strong>Example:</strong> x = 45, n = 100, 95% CI → [35.3%, 54.7%]</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #f59e0b;">
                <div class="card-body">
                  <h6 class="card-title text-warning">Difference in Means</h6>
                  <p class="card-text small mb-1"><strong>Formula:</strong> CI = (x̄₁ - x̄₂) ± t × SE</p>
                  <p class="card-text small mb-1">Where: SE = √(s₁²/n₁ + s₂²/n₂)</p>
                  <p class="card-text small mb-0"><strong>Use:</strong> Comparing two groups (e.g., treatment vs control)</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #8b5cf6;">
                <div class="card-body">
                  <h6 class="card-title text-purple">Difference in Proportions</h6>
                  <p class="card-text small mb-1"><strong>Formula:</strong> CI = (p̂₁ - p̂₂) ± Z × SE</p>
                  <p class="card-text small mb-1">Where: SE = √(p̂₁(1-p̂₁)/n₁ + p̂₂(1-p̂₂)/n₂)</p>
                  <p class="card-text small mb-0"><strong>Use:</strong> A/B testing, comparing success rates</p>
                </div>
              </div>

              <h6 class="mt-3">Factors Affecting CI Width</h6>
              <div class="alert alert-warning" style="font-size: 0.9rem;">
                <strong>1. Confidence Level:</strong> Higher confidence → Wider interval<br>
                <strong>2. Sample Size:</strong> Larger n → Narrower interval<br>
                <strong>3. Variability:</strong> Larger standard deviation → Wider interval<br>
                <strong>4. Population Size:</strong> (Only matters for small populations with finite correction)
              </div>

              <h6 class="mt-3">CI Visualization Example</h6>
              <canvas id="ciExampleChart" height="120"></canvas>
              <div class="text-center mt-2">
                <small class="text-muted">Example: Different confidence levels for the same data</small>
              </div>
            </div>
          </div>

          <hr class="my-4">

          <h6>Common Mistakes to Avoid</h6>
          <div class="row">
            <div class="col-md-4">
              <div class="alert alert-danger" style="font-size: 0.85rem;">
                <strong>Misinterpretation:</strong><br>
                "95% probability the true value is in the interval" is WRONG. The CI either contains the true value or it doesn't.
              </div>
            </div>
            <div class="col-md-4">
              <div class="alert alert-warning" style="font-size: 0.85rem;">
                <strong>Small Sample Sizes:</strong><br>
                Use t-distribution (not Z) for small samples (n < 30). Assumptions matter more with small n.
              </div>
            </div>
            <div class="col-md-4">
              <div class="alert alert-info" style="font-size: 0.85rem;">
                <strong>Overlapping CIs:</strong><br>
                Overlapping confidence intervals don't necessarily mean no significant difference. Use proper hypothesis tests.
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
  let ciType = 'mean', confidence = 95;
  let ciChartInstance = null, exampleChartInstance = null;

  const confPills = document.querySelectorAll('.conf-pill');
  const customInput = document.getElementById('customConfInput');
  const btnCalc = document.getElementById('btnCalc');

  // Tab switching
  $('#ciTypeTabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    const target = $(e.target).attr('href');
    if(target === '#meanTab') ciType = 'mean';
    else if(target === '#proportionTab') ciType = 'proportion';
    else if(target === '#twoMeanTab') ciType = 'twoMean';
    else if(target === '#twoPropTab') ciType = 'twoProp';
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
    return 1.96;
  }

  function getTScore(conf, df){
    const alpha = (100 - conf) / 100;
    return jStat.studentt.inv(1 - alpha/2, df);
  }

  function drawCIChart(lower, upper, estimate, label){
    const ctx = document.getElementById('ciChart');
    if(!ctx) return;
    if(ciChartInstance) ciChartInstance.destroy();

    const range = upper - lower;
    const padding = range * 0.2;

    ciChartInstance = new Chart(ctx, {
      type: 'scatter',
      data: {
        datasets: [{
          label: 'Confidence Interval',
          data: [{x: lower, y: 1}, {x: upper, y: 1}],
          showLine: true,
          borderColor: 'rgba(8, 145, 178, 1)',
          borderWidth: 4,
          pointRadius: 8,
          pointBackgroundColor: 'rgba(8, 145, 178, 0.8)'
        }, {
          label: 'Point Estimate',
          data: [{x: estimate, y: 1}],
          pointRadius: 10,
          pointBackgroundColor: 'rgba(239, 68, 68, 1)',
          pointBorderColor: 'white',
          pointBorderWidth: 2
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 3,
        plugins: {
          legend: {display: true, position: 'top', labels: {boxWidth: 12, font: {size: 10}}},
          title: {
            display: true,
            text: confidence + '% Confidence Interval',
            font: {size: 12, weight: 'bold'}
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                return context.dataset.label + ': ' + context.parsed.x.toFixed(4);
              }
            }
          }
        },
        scales: {
          x: {
            title: {display: true, text: label, font: {size: 10}},
            min: lower - padding,
            max: upper + padding
          },
          y: {
            display: false,
            min: 0.5,
            max: 1.5
          }
        }
      }
    });
  }

  function calculate(){
    let lower, upper, estimate, marginError, statsHTML = '', interp = '', label = '';

    try {
      if(ciType === 'mean'){
        const xbar = parseFloat(document.getElementById('meanSample').value);
        const s = parseFloat(document.getElementById('stdDevSample').value);
        const n = parseFloat(document.getElementById('sampleSize').value);

        if(isNaN(xbar) || isNaN(s) || isNaN(n) || s <= 0 || n < 2)
          return alert('Enter valid parameters');

        const t = getTScore(confidence, n - 1);
        const se = s / Math.sqrt(n);
        marginError = t * se;
        lower = xbar - marginError;
        upper = xbar + marginError;
        estimate = xbar;
        label = 'Population Mean (μ)';

        statsHTML = `
          <div class="stat-item"><label>Point Estimate</label><div class="value">${xbar.toFixed(4)}</div></div>
          <div class="stat-item"><label>Margin of Error</label><div class="value">±${marginError.toFixed(4)}</div></div>
          <div class="stat-item"><label>Standard Error</label><div class="value">${se.toFixed(4)}</div></div>
          <div class="stat-item"><label>Sample Size</label><div class="value">${n}</div></div>
        `;

        interp = `We are <strong>${confidence}% confident</strong> that the true population mean lies between <strong>${lower.toFixed(4)}</strong> and <strong>${upper.toFixed(4)}</strong>. The margin of error is ±${marginError.toFixed(4)}.`;

      } else if(ciType === 'proportion'){
        const x = parseFloat(document.getElementById('successes').value);
        const n = parseFloat(document.getElementById('sampleSizeProp').value);

        if(isNaN(x) || isNaN(n) || x < 0 || n < 1 || x > n)
          return alert('Enter valid parameters (0 ≤ x ≤ n)');

        const p = x / n;
        const z = getZScore(confidence);
        const se = Math.sqrt(p * (1 - p) / n);
        marginError = z * se;
        lower = Math.max(0, p - marginError);
        upper = Math.min(1, p + marginError);
        estimate = p;
        label = 'Population Proportion (p)';

        statsHTML = `
          <div class="stat-item"><label>Sample Proportion</label><div class="value">${(p*100).toFixed(2)}%</div></div>
          <div class="stat-item"><label>Margin of Error</label><div class="value">±${(marginError*100).toFixed(2)}%</div></div>
          <div class="stat-item"><label>Successes</label><div class="value">${x}/${n}</div></div>
          <div class="stat-item"><label>Standard Error</label><div class="value">${se.toFixed(4)}</div></div>
        `;

        interp = `We are <strong>${confidence}% confident</strong> that the true population proportion lies between <strong>${(lower*100).toFixed(2)}%</strong> and <strong>${(upper*100).toFixed(2)}%</strong>. The sample proportion is ${(p*100).toFixed(2)}% with margin of error ±${(marginError*100).toFixed(2)}%.`;

      } else if(ciType === 'twoMean'){
        const x1 = parseFloat(document.getElementById('mean1').value);
        const s1 = parseFloat(document.getElementById('sd1').value);
        const n1 = parseFloat(document.getElementById('n1').value);
        const x2 = parseFloat(document.getElementById('mean2').value);
        const s2 = parseFloat(document.getElementById('sd2').value);
        const n2 = parseFloat(document.getElementById('n2').value);

        if(isNaN(x1) || isNaN(s1) || isNaN(n1) || isNaN(x2) || isNaN(s2) || isNaN(n2) || s1 <= 0 || s2 <= 0 || n1 < 2 || n2 < 2)
          return alert('Enter valid parameters');

        const diff = x1 - x2;
        const se = Math.sqrt((s1*s1)/n1 + (s2*s2)/n2);
        const df = Math.min(n1 - 1, n2 - 1); // Conservative df
        const t = getTScore(confidence, df);
        marginError = t * se;
        lower = diff - marginError;
        upper = diff + marginError;
        estimate = diff;
        label = 'Difference in Means (μ₁ - μ₂)';

        statsHTML = `
          <div class="stat-item"><label>Difference</label><div class="value">${diff.toFixed(4)}</div></div>
          <div class="stat-item"><label>Margin of Error</label><div class="value">±${marginError.toFixed(4)}</div></div>
          <div class="stat-item"><label>Standard Error</label><div class="value">${se.toFixed(4)}</div></div>
          <div class="stat-item"><label>Degrees of Freedom</label><div class="value">${df}</div></div>
        `;

        interp = `We are <strong>${confidence}% confident</strong> that the difference between the two population means lies between <strong>${lower.toFixed(4)}</strong> and <strong>${upper.toFixed(4)}</strong>. `;
        if(lower > 0) interp += '<br><strong>Conclusion:</strong> Mean 1 is significantly greater than Mean 2.';
        else if(upper < 0) interp += '<br><strong>Conclusion:</strong> Mean 1 is significantly less than Mean 2.';
        else interp += '<br><strong>Conclusion:</strong> No significant difference (CI includes 0).';

      } else if(ciType === 'twoProp'){
        const x1 = parseFloat(document.getElementById('x1').value);
        const n1 = parseFloat(document.getElementById('np1').value);
        const x2 = parseFloat(document.getElementById('x2').value);
        const n2 = parseFloat(document.getElementById('np2').value);

        if(isNaN(x1) || isNaN(n1) || isNaN(x2) || isNaN(n2) || x1 < 0 || x2 < 0 || x1 > n1 || x2 > n2)
          return alert('Enter valid parameters');

        const p1 = x1 / n1;
        const p2 = x2 / n2;
        const diff = p1 - p2;
        const se = Math.sqrt(p1*(1-p1)/n1 + p2*(1-p2)/n2);
        const z = getZScore(confidence);
        marginError = z * se;
        lower = diff - marginError;
        upper = diff + marginError;
        estimate = diff;
        label = 'Difference in Proportions (p₁ - p₂)';

        statsHTML = `
          <div class="stat-item"><label>Proportion 1</label><div class="value">${(p1*100).toFixed(2)}%</div></div>
          <div class="stat-item"><label>Proportion 2</label><div class="value">${(p2*100).toFixed(2)}%</div></div>
          <div class="stat-item"><label>Difference</label><div class="value">${(diff*100).toFixed(2)}%</div></div>
          <div class="stat-item"><label>Margin of Error</label><div class="value">±${(marginError*100).toFixed(2)}%</div></div>
        `;

        interp = `We are <strong>${confidence}% confident</strong> that the difference between the two population proportions lies between <strong>${(lower*100).toFixed(2)}%</strong> and <strong>${(upper*100).toFixed(2)}%</strong>. `;
        if(lower > 0) interp += '<br><strong>Conclusion:</strong> Proportion 1 is significantly greater than Proportion 2.';
        else if(upper < 0) interp += '<br><strong>Conclusion:</strong> Proportion 1 is significantly less than Proportion 2.';
        else interp += '<br><strong>Conclusion:</strong> No significant difference (CI includes 0).';
      }

      // Display results
      const html = `
        <div class="result-hero">
          <div class="ci-value">[${lower.toFixed(4)}, ${upper.toFixed(4)}]</div>
          <div class="ci-label">${confidence}% Confidence Interval</div>
        </div>

        <h6 class="mt-3">Statistical Summary</h6>
        <div class="stats-grid">
          ${statsHTML}
        </div>

        <div class="interpretation">
          ${interp}
        </div>

        <hr class="my-3">

        <h6 class="mt-3">Visual Display</h6>
        <canvas id="ciChart"></canvas>
      `;

      document.getElementById('resultDisplay').innerHTML = html;
      drawCIChart(lower, upper, estimate, label);

    } catch(e){
      console.error(e);
      alert('Error calculating confidence interval');
    }
  }

  // Draw educational example chart
  function drawExampleChart(){
    const ctx = document.getElementById('ciExampleChart');
    if(!ctx) return;

    const mean = 50;
    const se = 2;

    const ci90 = [mean - 1.645*se, mean + 1.645*se];
    const ci95 = [mean - 1.96*se, mean + 1.96*se];
    const ci99 = [mean - 2.576*se, mean + 2.576*se];

    exampleChartInstance = new Chart(ctx, {
      type: 'scatter',
      data: {
        datasets: [
          {
            label: '90% CI',
            data: [{x: ci90[0], y: 3}, {x: ci90[1], y: 3}],
            showLine: true,
            borderColor: 'rgba(16, 185, 129, 1)',
            borderWidth: 3,
            pointRadius: 6
          },
          {
            label: '95% CI',
            data: [{x: ci95[0], y: 2}, {x: ci95[1], y: 2}],
            showLine: true,
            borderColor: 'rgba(59, 130, 246, 1)',
            borderWidth: 3,
            pointRadius: 6
          },
          {
            label: '99% CI',
            data: [{x: ci99[0], y: 1}, {x: ci99[1], y: 1}],
            showLine: true,
            borderColor: 'rgba(239, 68, 68, 1)',
            borderWidth: 3,
            pointRadius: 6
          },
          {
            label: 'True Mean',
            data: [{x: mean, y: 1}, {x: mean, y: 3}],
            showLine: true,
            borderColor: 'rgba(107, 114, 128, 0.5)',
            borderWidth: 2,
            borderDash: [5, 5],
            pointRadius: 0
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: {display: true, position: 'top', labels: {boxWidth: 8, font: {size: 10}}},
          title: {
            display: true,
            text: 'Same Data, Different Confidence Levels',
            font: {size: 11, weight: 'bold'}
          }
        },
        scales: {
          x: {
            title: {display: true, text: 'Value', font: {size: 9}},
            ticks: {font: {size: 9}}
          },
          y: {
            display: false,
            min: 0,
            max: 4
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
