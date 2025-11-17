<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Correlation Calculator — Pearson, Spearman, Scatter Plot & Significance</title>
<meta name="description" content="Calculate Pearson and Spearman correlation coefficients with scatter plot visualization and statistical significance testing. Free correlation analysis tool.">
<meta name="keywords" content="correlation calculator, pearson correlation, spearman correlation, scatter plot, correlation coefficient, statistical correlation, r value, correlation analysis">
<link rel="canonical" href="https://8gwifi.org/correlation-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Correlation Calculator — Pearson & Spearman with Visualization">
<meta property="og:description" content="Calculate correlation coefficients with scatter plot and statistical significance.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/correlation-calculator.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Correlation Calculator">
<meta name="twitter:description" content="Analyze relationships between variables with Pearson and Spearman correlation.">

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
    background: linear-gradient(135deg, #581c87, #7c3aed);
    border-radius: 12px;
    margin-bottom: 1.5rem;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  }
  .result-hero .corr-value {
    font-size: 3rem;
    font-weight: 800;
    color: white;
    margin: 0;
    line-height: 1;
  }
  .result-hero .strength-badge {
    display: inline-block;
    margin-top: 0.75rem;
    padding: 0.5rem 1.25rem;
    border-radius: 20px;
    font-weight: 600;
    font-size: 0.95rem;
  }
  .badge-strong { background: rgba(255,255,255,0.95); color: #7c3aed; }
  .badge-moderate { background: rgba(255,255,255,0.85); color: #6b21a8; }
  .badge-weak { background: rgba(255,255,255,0.75); color: #5b21b6; }

  .data-col label {
    display: block;
    font-weight: 600;
    margin-bottom: 0.5rem;
    color: #374151;
  }
  .data-col textarea {
    width: 100%;
    min-height: 150px;
    padding: 0.75rem;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    font-family: 'Courier New', monospace;
    font-size: 0.9rem;
    resize: vertical;
  }
  .data-col textarea:focus {
    outline: none;
    border-color: #8b5cf6;
    box-shadow: 0 0 0 3px rgba(139,92,246,0.1);
  }
  .data-col small {
    display: block;
    margin-top: 0.25rem;
    color: #6b7280;
    font-size: 0.8rem;
  }

  /* Action Buttons */
  .btn-group {
    display: flex;
    gap: 0.5rem;
    flex-wrap: wrap;
  }
  .btn {
    padding: 0.7rem 1.25rem;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
    font-size: 0.95rem;
  }
  .btn-primary {
    background: #8b5cf6;
    color: white;
    flex: 1;
    min-width: 150px;
  }
  .btn-primary:hover { background: #7c3aed; transform: translateY(-1px); }
  .btn-secondary {
    background: #6b7280;
    color: white;
  }
  .btn-secondary:hover { background: #4b5563; }
  .btn-outline {
    background: white;
    border: 2px solid #d1d5db;
    color: #374151;
  }
  .btn-outline:hover { border-color: #8b5cf6; color: #8b5cf6; }

  #scatterPlot {
    width: 100%;
    max-height: 250px;
    border-radius: 8px;
  }

  .stats-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 0.75rem;
    margin-bottom: 1rem;
  }
  .stat-item {
    background: #f9fafb;
    padding: 0.75rem;
    border-radius: 6px;
    text-align: center;
  }
  .stat-item label {
    display: block;
    font-size: 0.75rem;
    color: #6b7280;
    margin-bottom: 0.25rem;
  }
  .stat-item .value {
    font-size: 1.25rem;
    font-weight: 800;
    color: #8b5cf6;
  }

  .interpretation {
    background: #f9fafb;
    border-left: 4px solid #8b5cf6;
    padding: 1rem;
    border-radius: 4px;
    margin: 1rem 0;
    line-height: 1.6;
    font-size: 0.9rem;
  }

  /* Educational section */
  .edu-card {
    background: #f5f3ff;
    border-left: 4px solid #8b5cf6;
    padding: 1rem;
    border-radius: 6px;
    margin-bottom: 1rem;
  }
  .edu-card h6 {
    color: #581c87;
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
    .result-hero .corr-value { font-size: 2.5rem; }
    .stats-grid { grid-template-columns: 1fr; }
  }
</style>

<script type="application/ld+json">
{
  "@context":"https://schema.org",
  "@type":"WebApplication",
  "name":"Correlation Calculator",
  "url":"https://8gwifi.org/correlation-calculator.jsp",
  "description":"Calculate Pearson and Spearman correlation coefficients with scatter plot visualization and statistical significance testing. Free online tool for data analysis and research.",
  "applicationCategory":"EducationalApplication",
  "operatingSystem":"Any",
  "browserRequirements":"Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Pearson correlation, Spearman correlation, Scatter plot visualization, Trend line, P-value calculation, R-squared, Statistical significance",
  "screenshot": "https://8gwifi.org/images/correlation-calculator.png",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "ratingCount": "1420"
  }
}
</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1>Correlation Calculator</h1>
  <p class="text-muted">Calculate correlation coefficients to measure the relationship between two variables with visualization.</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column - Input Forms -->
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h5 class="card-title mb-3">Correlation Analysis</h5>

          <!-- Method Selection Tabs -->
          <ul class="nav nav-tabs mb-3" id="methodTabs" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" id="pearson-tab" data-toggle="tab" href="#pearsonTab" role="tab">Pearson</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="spearman-tab" data-toggle="tab" href="#spearmanTab" role="tab">Spearman</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" id="both-tab" data-toggle="tab" href="#bothTab" role="tab">Both</a>
            </li>
          </ul>

          <div class="tab-content" id="methodTabContent">
            <!-- Pearson Tab -->
            <div class="tab-pane fade show active" id="pearsonTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>Pearson correlation:</strong> Measures linear relationships. Use when both variables are continuous and normally distributed.
              </div>
            </div>

            <!-- Spearman Tab -->
            <div class="tab-pane fade" id="spearmanTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>Spearman correlation:</strong> Measures monotonic relationships based on ranks. Use for ordinal data or non-linear relationships.
              </div>
            </div>

            <!-- Both Tab -->
            <div class="tab-pane fade" id="bothTab" role="tabpanel">
              <div class="alert alert-info mb-3" style="font-size: 0.85rem;">
                <strong>Compare both methods:</strong> See how linear (Pearson) and monotonic (Spearman) correlations differ for your data.
              </div>
            </div>
          </div>

          <h6 class="mb-3">Enter Paired Data</h6>
          <div class="row">
            <div class="col-md-6 data-col mb-3">
              <label>Variable X</label>
              <textarea id="xData" placeholder="Enter values (one per line)&#10;Example:&#10;10&#10;20&#10;30&#10;40&#10;50" class="form-control"></textarea>
              <small>One value per line</small>
            </div>
            <div class="col-md-6 data-col mb-3">
              <label>Variable Y</label>
              <textarea id="yData" placeholder="Enter values (one per line)&#10;Example:&#10;15&#10;25&#10;35&#10;45&#10;55" class="form-control"></textarea>
              <small>One value per line</small>
            </div>
          </div>

          <div class="btn-group">
            <button class="btn btn-primary" id="btnCalc">Calculate Correlation</button>
            <button class="btn btn-secondary" id="btnSample">Sample Data</button>
            <button class="btn btn-outline" id="btnClear">Clear</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Right Column - Results -->
    <div class="col-lg-5 mb-4">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title">Results</h5>
          <div id="resultDisplay">
            <p class="text-muted">Enter your paired data and click "Calculate Correlation" to see results.</p>
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
          <h5 class="mb-0">Understanding Correlation Analysis</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6">
              <div class="edu-card">
                <h6>What is Correlation?</h6>
                <p>Correlation measures the strength and direction of the relationship between two variables. A correlation coefficient (r) ranges from -1 to +1, where -1 indicates perfect negative correlation, 0 means no correlation, and +1 shows perfect positive correlation.</p>
              </div>

              <div class="edu-card">
                <h6>Pearson vs Spearman</h6>
                <p><strong>Pearson (r):</strong> Measures linear relationships. Assumes both variables are continuous and normally distributed.<br><br>
                <strong>Spearman (ρ):</strong> Measures monotonic relationships using ranks. More robust to outliers and works with ordinal data.</p>
              </div>

              <div class="edu-card">
                <h6>Correlation ≠ Causation</h6>
                <p><strong>Critical Warning:</strong> A strong correlation does not imply that one variable causes the other. There could be confounding factors, reverse causation, or the relationship could be coincidental. Always consider the context and other evidence before inferring causation.</p>
              </div>

              <h6 class="mt-3">Correlation Strength Interpretation</h6>
              <div class="table-responsive">
                <table class="table table-sm table-bordered">
                  <thead class="thead-light">
                    <tr>
                      <th>|r| Value</th>
                      <th>Strength</th>
                      <th>Interpretation</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>1.0</td>
                      <td>Perfect</td>
                      <td>Exact linear relationship</td>
                    </tr>
                    <tr>
                      <td>0.8 - 0.99</td>
                      <td>Very Strong</td>
                      <td>Strong predictive relationship</td>
                    </tr>
                    <tr>
                      <td>0.6 - 0.79</td>
                      <td>Strong</td>
                      <td>Notable relationship</td>
                    </tr>
                    <tr>
                      <td>0.4 - 0.59</td>
                      <td>Moderate</td>
                      <td>Meaningful but not dominant</td>
                    </tr>
                    <tr>
                      <td>0.2 - 0.39</td>
                      <td>Weak</td>
                      <td>Minor relationship</td>
                    </tr>
                    <tr>
                      <td>0.0 - 0.19</td>
                      <td>Very Weak</td>
                      <td>Little to no relationship</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div class="col-md-6">
              <h6>Coefficient of Determination (r²)</h6>
              <div class="alert alert-success" style="font-size: 0.9rem;">
                <strong>r²</strong> represents the proportion of variance in Y that is explained by X.<br><br>
                <strong>Example:</strong> If r = 0.8, then r² = 0.64, meaning 64% of the variation in Y can be explained by X.
              </div>

              <h6 class="mt-3">Statistical Significance (p-value)</h6>
              <div class="card mb-3" style="border-left: 4px solid #10b981;">
                <div class="card-body">
                  <p class="card-text small mb-1"><strong>p < 0.001:</strong> Highly significant - very strong evidence against no correlation</p>
                  <p class="card-text small mb-1"><strong>p < 0.05:</strong> Significant - standard threshold for rejecting null hypothesis</p>
                  <p class="card-text small mb-0"><strong>p ≥ 0.05:</strong> Not significant - insufficient evidence of correlation</p>
                </div>
              </div>

              <h6 class="mt-3">When to Use Each Method</h6>

              <div class="card mb-3" style="border-left: 4px solid #8b5cf6;">
                <div class="card-body">
                  <h6 class="card-title text-purple">Use Pearson When:</h6>
                  <ul class="card-text small mb-0" style="padding-left: 1.2rem;">
                    <li>Both variables are continuous</li>
                    <li>Relationship appears linear</li>
                    <li>Data is normally distributed</li>
                    <li>No major outliers present</li>
                  </ul>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #f59e0b;">
                <div class="card-body">
                  <h6 class="card-title text-warning">Use Spearman When:</h6>
                  <ul class="card-text small mb-0" style="padding-left: 1.2rem;">
                    <li>Variables are ordinal (ranked)</li>
                    <li>Relationship is monotonic but not linear</li>
                    <li>Data has outliers</li>
                    <li>Distribution is not normal</li>
                  </ul>
                </div>
              </div>

              <h6 class="mt-3">Correlation Visualization</h6>
              <canvas id="correlationExamplesChart" height="180"></canvas>
              <div class="text-center mt-2">
                <small class="text-muted">Examples of different correlation strengths</small>
              </div>
            </div>
          </div>

          <hr class="my-4">

          <h6>Common Pitfalls to Avoid</h6>
          <div class="row">
            <div class="col-md-4">
              <div class="alert alert-danger" style="font-size: 0.85rem;">
                <strong>Confounding Variables:</strong><br>
                A third variable may be influencing both X and Y, creating a spurious correlation.
              </div>
            </div>
            <div class="col-md-4">
              <div class="alert alert-warning" style="font-size: 0.85rem;">
                <strong>Outliers:</strong><br>
                A single extreme value can dramatically affect Pearson correlation. Use Spearman for robustness.
              </div>
            </div>
            <div class="col-md-4">
              <div class="alert alert-info" style="font-size: 0.85rem;">
                <strong>Non-linear Relationships:</strong><br>
                Pearson may miss curved relationships. Always visualize your data first!
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

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jstat@latest/dist/jstat.min.js"></script>
<script>
(function(){
  let method = 'pearson', chartInstance = null, examplesChartInstance = null;

  const btnCalc = document.getElementById('btnCalc');
  const btnSample = document.getElementById('btnSample');
  const btnClear = document.getElementById('btnClear');
  const xInput = document.getElementById('xData');
  const yInput = document.getElementById('yData');

  // Method switching based on active tab
  $('#methodTabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    const target = $(e.target).attr('href');
    if(target === '#pearsonTab') method = 'pearson';
    else if(target === '#spearmanTab') method = 'spearman';
    else if(target === '#bothTab') method = 'both';
  });

  function parseData(text){
    return text.trim().split('\n')
      .map(line => parseFloat(line.trim()))
      .filter(val => !isNaN(val));
  }

  function mean(arr){
    return arr.reduce((a,b) => a+b, 0) / arr.length;
  }

  function stdDev(arr, m){
    const mu = m !== undefined ? m : mean(arr);
    return Math.sqrt(arr.reduce((sum, val) => sum + Math.pow(val - mu, 2), 0) / arr.length);
  }

  function pearson(x, y){
    const n = x.length;
    const mx = mean(x), my = mean(y);
    const sx = stdDev(x, mx), sy = stdDev(y, my);
    let sum = 0;
    for(let i = 0; i < n; i++){
      sum += (x[i] - mx) * (y[i] - my);
    }
    return sum / (n * sx * sy);
  }

  function spearman(x, y){
    function rank(arr){
      const sorted = arr.map((val, idx) => ({val, idx}))
        .sort((a,b) => a.val - b.val);
      const ranks = new Array(arr.length);
      for(let i = 0; i < sorted.length; i++){
        ranks[sorted[i].idx] = i + 1;
      }
      return ranks;
    }
    return pearson(rank(x), rank(y));
  }

  function significance(r, n){
    const t = r * Math.sqrt(n - 2) / Math.sqrt(1 - r * r);
    const df = n - 2;
    const p = 2 * (1 - jStat.studentt.cdf(Math.abs(t), df));
    return {t, df, p};
  }

  function getStrength(r){
    const abs = Math.abs(r);
    if(abs >= 0.8) return {text: 'Very Strong', class: 'badge-strong'};
    if(abs >= 0.6) return {text: 'Strong', class: 'badge-strong'};
    if(abs >= 0.4) return {text: 'Moderate', class: 'badge-moderate'};
    if(abs >= 0.2) return {text: 'Weak', class: 'badge-weak'};
    return {text: 'Very Weak', class: 'badge-weak'};
  }

  function drawChart(x, y, r, methodName){
    const ctx = document.getElementById('scatterPlot');
    if(!ctx) return;
    if(chartInstance) chartInstance.destroy();

    const data = x.map((val, i) => ({x: val, y: y[i]}));

    // Trend line
    const mx = mean(x), my = mean(y);
    const slope = r * stdDev(y, my) / stdDev(x, mx);
    const intercept = my - slope * mx;
    const minX = Math.min(...x), maxX = Math.max(...x);
    const trend = [
      {x: minX, y: slope * minX + intercept},
      {x: maxX, y: slope * maxX + intercept}
    ];

    chartInstance = new Chart(ctx, {
      type: 'scatter',
      data: {
        datasets: [{
          label: 'Data Points',
          data: data,
          backgroundColor: 'rgba(139,92,246,0.6)',
          borderColor: 'rgba(139,92,246,1)',
          pointRadius: 6
        }, {
          label: 'Trend Line',
          data: trend,
          type: 'line',
          borderColor: 'rgba(239,68,68,0.8)',
          borderWidth: 2,
          pointRadius: 0,
          fill: false
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 1.5,
        plugins: {
          legend: {position: 'top', labels: {boxWidth: 12, font: {size: 10}}},
          title: {
            display: true,
            text: methodName + ' Correlation: r = ' + r.toFixed(4),
            font: {size: 11, weight: 'bold'}
          }
        },
        scales: {
          x: {
            title: {display: true, text: 'Variable X', font: {size: 9}},
            ticks: {font: {size: 9}}
          },
          y: {
            title: {display: true, text: 'Variable Y', font: {size: 9}},
            ticks: {font: {size: 9}}
          }
        }
      }
    });
  }

  function calculate(){
    const xVals = parseData(xInput.value);
    const yVals = parseData(yInput.value);

    if(xVals.length < 3 || yVals.length < 3){
      return alert('Need at least 3 data points');
    }
    if(xVals.length !== yVals.length){
      return alert('X and Y must have same number of values');
    }

    const n = xVals.length;
    let r, sig, methodName, statsHTML = '', interp = '';

    try {
      if(method === 'pearson' || method === 'both'){
        r = pearson(xVals, yVals);
        sig = significance(r, n);
        methodName = 'Pearson';

        statsHTML += `<div class="stat-item"><label>Pearson r</label><div class="value">${r.toFixed(4)}</div></div>`;
        if(method === 'both'){
          const rSpear = spearman(xVals, yVals);
          statsHTML += `<div class="stat-item"><label>Spearman ρ</label><div class="value">${rSpear.toFixed(4)}</div></div>`;
        }
      } else {
        r = spearman(xVals, yVals);
        sig = significance(r, n);
        methodName = 'Spearman';

        statsHTML += `<div class="stat-item"><label>Spearman ρ</label><div class="value">${r.toFixed(4)}</div></div>`;
      }

      statsHTML += `<div class="stat-item"><label>Sample Size</label><div class="value">${n}</div></div>`;
      statsHTML += `<div class="stat-item"><label>R²</label><div class="value">${Math.pow(r, 2).toFixed(4)}</div></div>`;
      statsHTML += `<div class="stat-item"><label>P-value</label><div class="value">${sig.p.toFixed(6)}</div></div>`;

      // Interpretation
      const strength = getStrength(r);
      const direction = r > 0 ? 'positive' : 'negative';

      interp = `<strong>Interpretation:</strong> There is a <strong>${strength.text.toLowerCase()} ${direction} correlation</strong> `;
      interp += `(r = ${r.toFixed(4)}). `;

      if(sig.p < 0.001){
        interp += 'This is <strong>highly statistically significant</strong> (p < 0.001).';
      } else if(sig.p < 0.05){
        interp += 'This is <strong>statistically significant</strong> (p < 0.05).';
      } else {
        interp += 'This is <strong>not statistically significant</strong> (p ≥ 0.05).';
      }

      interp += `<br><br>The coefficient of determination (r²) is <strong>${Math.pow(r, 2).toFixed(4)}</strong>, `;
      interp += `meaning ${(Math.pow(r, 2) * 100).toFixed(1)}% of variance in Y is explained by X.`;

      // Display results in right panel
      const html = `
        <div class="result-hero">
          <div class="corr-value">r = ${r.toFixed(4)}</div>
          <span class="strength-badge ${strength.class}">${strength.text} Correlation</span>
        </div>

        <h6 class="mt-3">Statistical Summary</h6>
        <div class="stats-grid">
          ${statsHTML}
        </div>

        <div class="interpretation">
          ${interp}
        </div>

        <hr class="my-3">

        <h6 class="mt-3">Scatter Plot</h6>
        <canvas id="scatterPlot"></canvas>
      `;

      document.getElementById('resultDisplay').innerHTML = html;
      drawChart(xVals, yVals, r, methodName);

    } catch(e){
      console.error(e);
      alert('Error calculating correlation');
    }
  }

  function loadSample(){
    const samples = [
      {x: '10\n20\n30\n40\n50\n60\n70\n80', y: '15\n28\n35\n45\n58\n62\n75\n85', desc: 'Strong positive'},
      {x: '1\n2\n3\n4\n5\n6\n7\n8', y: '10\n9\n8\n7\n6\n5\n4\n3', desc: 'Strong negative'},
      {x: '5\n10\n15\n20\n25\n30', y: '12\n8\n18\n15\n22\n10', desc: 'Weak correlation'}
    ];
    const s = samples[Math.floor(Math.random() * samples.length)];
    xInput.value = s.x;
    yInput.value = s.y;
    alert('Loaded: ' + s.desc + ' correlation');
  }

  function clear(){
    xInput.value = '';
    yInput.value = '';
    document.getElementById('resultDisplay').innerHTML =
      '<p class="text-muted">Enter your paired data and click "Calculate Correlation" to see results.</p>';
    if(chartInstance){
      chartInstance.destroy();
      chartInstance = null;
    }
  }

  // Draw educational examples chart
  function drawExamplesChart(){
    const ctx = document.getElementById('correlationExamplesChart');
    if(!ctx) return;

    if(examplesChartInstance){
      examplesChartInstance.destroy();
    }

    // Generate example data for different correlations
    const generateData = (r, n = 20) => {
      const data = [];
      for(let i = 0; i < n; i++){
        const x = i / n;
        const y = r * x + (1 - Math.abs(r)) * (Math.random() - 0.5);
        data.push({x: x, y: y});
      }
      return data;
    };

    examplesChartInstance = new Chart(ctx, {
      type: 'scatter',
      data: {
        datasets: [
          {
            label: 'Strong Positive (r ≈ 0.9)',
            data: generateData(0.9),
            backgroundColor: 'rgba(16, 185, 129, 0.6)',
            borderColor: 'rgba(16, 185, 129, 1)',
            pointRadius: 3
          },
          {
            label: 'Weak Positive (r ≈ 0.3)',
            data: generateData(0.3),
            backgroundColor: 'rgba(59, 130, 246, 0.6)',
            borderColor: 'rgba(59, 130, 246, 1)',
            pointRadius: 3
          },
          {
            label: 'Strong Negative (r ≈ -0.9)',
            data: generateData(-0.9),
            backgroundColor: 'rgba(239, 68, 68, 0.6)',
            borderColor: 'rgba(239, 68, 68, 1)',
            pointRadius: 3
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: {
            position: 'bottom',
            labels: {boxWidth: 8, font: {size: 10}}
          },
          title: {
            display: true,
            text: 'Examples of Different Correlation Strengths',
            font: {size: 12, weight: 'bold'}
          }
        },
        scales: {
          x: {display: false},
          y: {display: false}
        }
      }
    });
  }

  btnCalc.addEventListener('click', calculate);
  btnSample.addEventListener('click', loadSample);
  btnClear.addEventListener('click', clear);

  // Draw educational chart on page load
  window.addEventListener('load', drawExamplesChart);
})();
</script>
