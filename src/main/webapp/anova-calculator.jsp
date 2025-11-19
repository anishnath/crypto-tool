<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>ANOVA Calculator Online – Free | 8gwifi.org</title>
<meta name="description" content="Free ANOVA calculator: one‑way analysis of variance. Compute F‑statistic, p‑value, sums of squares, degrees of freedom, and visualize the F‑distribution.">
<meta name="keywords" content="anova calculator, analysis of variance, f-test, f-statistic, one-way anova, compare means, sum of squares, statistical analysis">
<link rel="canonical" href="https://8gwifi.org/anova-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="ANOVA Calculator Online – Free | 8gwifi.org">
<meta property="og:description" content="One‑way ANOVA: F‑statistic, p‑value, sums of squares, df, and charts.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/anova-calculator.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="ANOVA Calculator Online – Free | 8gwifi.org">
<meta name="twitter:description" content="Free one‑way ANOVA: F, p‑value, sums of squares, df, and visualization.">

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
  "name": "ANOVA Calculator",
  "url": "https://8gwifi.org/anova-calculator.jsp",
  "description": "Comprehensive ANOVA Calculator for one-way analysis of variance. Compare means of multiple groups, calculate F-statistic, p-value, sum of squares (SST, SSB, SSW), and visualize F-distribution.",
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "browserRequirements": "Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "One-way ANOVA, F-statistic calculation, P-value calculation, Sum of squares (SST, SSB, SSW), Mean squares, Degrees of freedom, F-distribution visualization, Multiple group comparison"
}
</script>

<style>
  :root {
    --primary-color: #e11d48;
    --primary-dark: #be123c;
    --primary-light: #fb7185;
    --bg-light: #fff1f2;
    --border-color: #fecdd3;
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
    box-shadow: 0 0 0 3px rgba(225, 29, 72, 0.1);
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
    box-shadow: 0 4px 12px rgba(225, 29, 72, 0.3);
  }

  .btn-sample, .btn-add {
    background: white;
    color: var(--primary-color);
    border: 1.5px solid var(--primary-color);
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
    border-radius: 6px;
    transition: all 0.2s;
  }

  .btn-sample:hover, .btn-add:hover {
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
    background: #fecdd3;
    border-left: 4px solid #e11d48;
    padding: 0.75rem;
    border-radius: 4px;
    font-size: 0.85rem;
    margin-top: 0.5rem;
    color: #881337;
  }

  .group-input {
    background: #f9fafb;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    padding: 1rem;
    margin-bottom: 1rem;
  }

  .group-input h6 {
    color: var(--primary-color);
    font-weight: 600;
    margin-bottom: 0.5rem;
  }

  #fDistribution {
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

  .anova-table {
    width: 100%;
    border-collapse: collapse;
    margin: 1rem 0;
  }

  .anova-table th,
  .anova-table td {
    border: 1px solid #e5e7eb;
    padding: 0.75rem;
    text-align: left;
  }

  .anova-table th {
    background: var(--primary-color);
    color: white;
    font-weight: 500;
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
  <h1>ANOVA Calculator</h1>
  <p class="text-muted">One-way analysis of variance to compare means of multiple groups</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="calculator-section">
        <h2 class="section-title"><i class="fas fa-layer-group"></i> Group Data</h2>

        <div class="info-box">
          <i class="fas fa-info-circle"></i>
          <strong>One-Way ANOVA:</strong> Compare means of 3 or more independent groups
        </div>

        <div id="groupsContainer">
          <div class="group-input">
            <h6>Group 1</h6>
            <textarea class="form-control" id="group_0" rows="2" placeholder="Enter values: 23, 25, 27">23, 25, 27, 22, 24</textarea>
          </div>
          <div class="group-input">
            <h6>Group 2</h6>
            <textarea class="form-control" id="group_1" rows="2" placeholder="Enter values: 28, 30, 32">28, 30, 32, 29, 31</textarea>
          </div>
          <div class="group-input">
            <h6>Group 3</h6>
            <textarea class="form-control" id="group_2" rows="2" placeholder="Enter values: 33, 35, 37">33, 35, 37, 34, 36</textarea>
          </div>
        </div>

        <button class="btn btn-add mb-3" onclick="addGroup()">
          <i class="fas fa-plus"></i> Add Group
        </button>

        <div class="mb-3">
          <label for="anovaAlpha" class="form-label">Significance Level (α)</label>
          <select class="form-control" id="anovaAlpha">
            <option value="0.01">0.01 (99% confidence)</option>
            <option value="0.05" selected>0.05 (95% confidence)</option>
            <option value="0.10">0.10 (90% confidence)</option>
          </select>
        </div>

        <button class="btn btn-sample mb-3" onclick="loadSampleData()">
          <i class="fas fa-flask"></i> Load Sample Data
        </button>

        <button class="btn btn-calculate" onclick="calculateANOVA()">
          <i class="fas fa-calculator"></i> Calculate ANOVA
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
            <p class="mt-2">Enter group data to see ANOVA results</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Educational Content -->
  <div class="educational-section">
    <h3><i class="fas fa-graduation-cap"></i> Understanding ANOVA</h3>

    <p><strong>Analysis of Variance (ANOVA)</strong> is a statistical method used to compare means of three or more groups simultaneously.</p>

    <h4>One-Way ANOVA</h4>
    <p>Tests whether there are significant differences between group means for a single independent variable.</p>

    <p><strong>Hypotheses:</strong></p>
    <ul>
      <li><strong>H₀ (Null):</strong> μ₁ = μ₂ = μ₃ = ... (all group means are equal)</li>
      <li><strong>H₁ (Alternative):</strong> At least one group mean differs</li>
    </ul>

    <h4>ANOVA Table Components</h4>
    <table class="anova-table">
      <thead>
        <tr>
          <th>Source</th>
          <th>SS (Sum of Squares)</th>
          <th>df</th>
          <th>MS (Mean Square)</th>
          <th>F-statistic</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><strong>Between Groups</strong></td>
          <td>SSB</td>
          <td>k - 1</td>
          <td>MSB = SSB / (k-1)</td>
          <td>F = MSB / MSW</td>
        </tr>
        <tr>
          <td><strong>Within Groups</strong></td>
          <td>SSW</td>
          <td>N - k</td>
          <td>MSW = SSW / (N-k)</td>
          <td></td>
        </tr>
        <tr>
          <td><strong>Total</strong></td>
          <td>SST</td>
          <td>N - 1</td>
          <td></td>
          <td></td>
        </tr>
      </tbody>
    </table>

    <p>Where: k = number of groups, N = total sample size</p>

    <h4>Key Formulas</h4>
    <div class="formula-box">
      SST = Σ(xᵢ - x̄)²  (Total variation)
    </div>
    <div class="formula-box">
      SSB = Σnⱼ(x̄ⱼ - x̄)²  (Between-group variation)
    </div>
    <div class="formula-box">
      SSW = Σ(xᵢⱼ - x̄ⱼ)²  (Within-group variation)
    </div>
    <div class="formula-box">
      F = MSB / MSW
    </div>

    <h4>Interpreting Results</h4>
    <ul>
      <li><strong>If p-value ≤ α:</strong> Reject H₀ (at least one group mean differs significantly)</li>
      <li><strong>If p-value > α:</strong> Fail to reject H₀ (no significant differences between group means)</li>
      <li><strong>Larger F-statistic:</strong> Indicates greater variation between groups relative to within groups</li>
    </ul>

    <h4>Assumptions</h4>
    <ul>
      <li><strong>Independence:</strong> Observations are independent within and between groups</li>
      <li><strong>Normality:</strong> Data in each group are approximately normally distributed</li>
      <li><strong>Homogeneity of Variance:</strong> All groups have equal variances (Levene's test can check this)</li>
    </ul>

    <h4>Post-Hoc Tests</h4>
    <p>If ANOVA is significant, conduct post-hoc tests to determine which specific groups differ:</p>
    <ul>
      <li><strong>Tukey HSD:</strong> Controls family-wise error rate, compares all pairs</li>
      <li><strong>Bonferroni:</strong> Conservative, adjusts α for multiple comparisons</li>
      <li><strong>Scheffé:</strong> Most conservative, allows any contrast</li>
    </ul>

    <h4>Effect Size: Eta-Squared (η²)</h4>
    <div class="formula-box">
      η² = SSB / SST
    </div>
    <ul>
      <li><strong>Small effect:</strong> η² ≈ 0.01</li>
      <li><strong>Medium effect:</strong> η² ≈ 0.06</li>
      <li><strong>Large effect:</strong> η² ≈ 0.14</li>
    </ul>

    <h4>Real-World Applications</h4>
    <ul>
      <li><strong>Medicine:</strong> Compare effectiveness of multiple treatments</li>
      <li><strong>Psychology:</strong> Test differences across experimental conditions</li>
      <li><strong>Agriculture:</strong> Compare crop yields under different fertilizers</li>
      <li><strong>Education:</strong> Evaluate teaching methods across multiple classrooms</li>
      <li><strong>Manufacturing:</strong> Compare product quality from different production lines</li>
    </ul>

    <div class="info-box">
      <i class="fas fa-lightbulb"></i>
      <strong>Tip:</strong> If ANOVA assumptions are violated, consider non-parametric alternatives like the Kruskal-Wallis test. Always visualize your data with box plots before running ANOVA.
    </div>
  </div>
</div>

<%@ include file="thanks.jsp"%>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
  <!-- FAQ: inline -->
  <section id="faq" class="mt-5">
    <h2 class="h5">ANOVA Calculator: FAQ</h2>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">One‑way vs two‑way ANOVA?</h3>
      <p class="mb-0">One‑way compares means across levels of a single factor; two‑way adds a second factor and can test interaction between factors.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Key assumptions?</h3>
      <p class="mb-0">Independence, normality of residuals, and homogeneity of variances. Inspect residual plots and use Levene’s test when needed.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">What about post‑hoc tests?</h3>
      <p class="mb-0">If ANOVA is significant, use post‑hoc comparisons (e.g., Tukey HSD) to find which group means differ while controlling family‑wise error.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How to interpret effect size?</h3>
      <p class="mb-0">Report η² or partial η² to quantify practical significance (e.g., ~0.01 small, ~0.06 medium, ~0.14 large), alongside F and p‑value.</p>
    </div></div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"One‑way vs two‑way ANOVA?","acceptedAnswer":{"@type":"Answer","text":"One‑way tests one factor; two‑way adds a second factor and tests interaction."}},
      {"@type":"Question","name":"Key assumptions?","acceptedAnswer":{"@type":"Answer","text":"Independence, normal residuals, homogeneous variances; verify with diagnostics."}},
      {"@type":"Question","name":"What about post‑hoc tests?","acceptedAnswer":{"@type":"Answer","text":"Use Tukey HSD (or similar) after significant ANOVA to locate pairwise differences."}},
      {"@type":"Question","name":"How to interpret effect size?","acceptedAnswer":{"@type":"Answer","text":"Report η²/partial η² (e.g., ~0.01 small, ~0.06 medium, ~0.14 large) with F and p."}}
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
      {"@type":"ListItem","position":2,"name":"ANOVA Calculator","item":"https://8gwifi.org/anova-calculator.jsp"}
    ]
  }
  </script>
</div>
<%@ include file="body-close.jsp"%>

<script>
  let fDistChart = null;
  let groupCount = 3;

  function parseData(str) {
    return str.trim().split(/[,\s]+/).map(x => parseFloat(x)).filter(x => !isNaN(x));
  }

  function mean(arr) {
    return arr.reduce((a, b) => a + b, 0) / arr.length;
  }

  function addGroup() {
    groupCount++;
    const html = `
      <div class="group-input">
        <h6>Group ${groupCount}</h6>
        <textarea class="form-control" id="group_${groupCount - 1}" rows="2" placeholder="Enter values"></textarea>
      </div>
    `;
    document.getElementById('groupsContainer').insertAdjacentHTML('beforeend', html);
  }

  function loadSampleData() {
    document.getElementById('group_0').value = '23, 25, 27, 22, 24';
    document.getElementById('group_1').value = '28, 30, 32, 29, 31';
    document.getElementById('group_2').value = '33, 35, 37, 34, 36';
  }

  function calculateANOVA() {
    const alpha = parseFloat(document.getElementById('anovaAlpha').value);

    // Collect all groups
    const groups = [];
    let i = 0;
    while (true) {
      const elem = document.getElementById(`group_${i}`);
      if (!elem) break;

      const data = parseData(elem.value);
      if (data.length > 0) {
        groups.push(data);
      }
      i++;
    }

    if (groups.length < 2) {
      alert('Need at least 2 groups with data');
      return;
    }

    if (groups.some(g => g.length < 2)) {
      alert('Each group needs at least 2 observations');
      return;
    }

    // Calculate group means and sizes
    const groupMeans = groups.map(g => mean(g));
    const groupSizes = groups.map(g => g.length);
    const N = groupSizes.reduce((a, b) => a + b, 0);
    const k = groups.length;

    // Grand mean
    const allData = groups.flat();
    const grandMean = mean(allData);

    // SSB (Sum of Squares Between)
    let ssb = 0;
    for (let j = 0; j < k; j++) {
      ssb += groupSizes[j] * Math.pow(groupMeans[j] - grandMean, 2);
    }

    // SSW (Sum of Squares Within)
    let ssw = 0;
    for (let j = 0; j < k; j++) {
      for (let val of groups[j]) {
        ssw += Math.pow(val - groupMeans[j], 2);
      }
    }

    // SST (Total Sum of Squares)
    const sst = ssb + ssw;

    // Degrees of freedom
    const dfb = k - 1;
    const dfw = N - k;
    const dft = N - 1;

    // Mean squares
    const msb = ssb / dfb;
    const msw = ssw / dfw;

    // F-statistic
    const F = msb / msw;

    // P-value
    const pValue = 1 - jStat.centralF.cdf(F, dfb, dfw);

    // Critical value
    const criticalValue = jStat.centralF.inv(1 - alpha, dfb, dfw);

    // Eta-squared (effect size)
    const etaSquared = ssb / sst;

    displayResults({
      F: F,
      dfb: dfb,
      dfw: dfw,
      pValue: pValue,
      alpha: alpha,
      criticalValue: criticalValue,
      ssb: ssb,
      ssw: ssw,
      sst: sst,
      msb: msb,
      msw: msw,
      etaSquared: etaSquared,
      significant: pValue < alpha,
      groupMeans: groupMeans,
      k: k,
      N: N
    });

    drawFDistribution(F, dfb, dfw, criticalValue);
  }

  function displayResults(results) {
    let effectSize = 'small';
    if (results.etaSquared >= 0.14) effectSize = 'large';
    else if (results.etaSquared >= 0.06) effectSize = 'medium';

    let html = `
      <div class="result-item">
        <div class="result-label">One-Way ANOVA</div>
      </div>

      <div class="result-item">
        <div class="result-label">F-Statistic</div>
        <div class="result-value">${results.F.toFixed(4)}</div>
      </div>

      <div class="result-item">
        <div class="result-label">Degrees of Freedom</div>
        <div class="result-value">df₁=${results.dfb}, df₂=${results.dfw}</div>
      </div>

      <div class="result-item">
        <div class="result-label">P-Value</div>
        <div class="result-value">${results.pValue.toFixed(6)}</div>
        <div class="interpretation">
          ${results.significant
            ? `<strong style="color: #dc2626;">Significant!</strong> p < α (${results.alpha}). At least one group mean differs.`
            : `<strong style="color: #16a34a;">Not Significant.</strong> p ≥ α (${results.alpha}). No significant differences.`
          }
        </div>
      </div>

      <div class="result-item">
        <div class="result-label">Critical F-Value</div>
        <div class="result-value">${results.criticalValue.toFixed(4)}</div>
      </div>

      <div class="result-item">
        <div class="result-label">Sum of Squares</div>
        <div style="font-size: 0.9rem; margin-top: 0.5rem;">
          <div>Between (SSB): ${results.ssb.toFixed(4)}</div>
          <div>Within (SSW): ${results.ssw.toFixed(4)}</div>
          <div>Total (SST): ${results.sst.toFixed(4)}</div>
        </div>
      </div>

      <div class="result-item">
        <div class="result-label">η² (Eta-Squared)</div>
        <div class="result-value">${results.etaSquared.toFixed(4)}</div>
        <div class="interpretation">
          <strong>${effectSize.charAt(0).toUpperCase() + effectSize.slice(1)}</strong> effect size
        </div>
      </div>
    `;

    document.getElementById('resultsContent').innerHTML = html;
  }

  function drawFDistribution(FStat, df1, df2, criticalValue) {
    const container = document.getElementById('resultsContent');

    let canvas = document.getElementById('fDistribution');
    if (!canvas) {
      const chartHtml = `
        <div class="chart-container">
          <h5 style="color: var(--primary-color); margin-bottom: 1rem; font-size: 0.95rem;">
            <i class="fas fa-chart-area"></i> F-Distribution (df₁=${df1}, df₂=${df2})
          </h5>
          <canvas id="fDistribution"></canvas>
        </div>
      `;
      container.insertAdjacentHTML('beforeend', chartHtml);
      canvas = document.getElementById('fDistribution');
    }

    if (fDistChart) {
      fDistChart.destroy();
    }

    const xValues = [];
    const yValues = [];
    const maxX = Math.max(FStat + 2, criticalValue + 2, 6);

    for (let x = 0; x <= maxX; x += 0.1) {
      xValues.push(x);
      yValues.push(jStat.centralF.pdf(x, df1, df2));
    }

    const rejectRegion = xValues.map((x, i) => x >= criticalValue ? yValues[i] : null);

    fDistChart = new Chart(canvas, {
      type: 'line',
      data: {
        labels: xValues,
        datasets: [
          {
            label: 'F-Distribution',
            data: yValues,
            borderColor: 'rgba(225, 29, 72, 1)',
            borderWidth: 2,
            fill: false,
            pointRadius: 0
          },
          {
            label: 'Rejection Region',
            data: rejectRegion,
            backgroundColor: 'rgba(239, 68, 68, 0.3)',
            borderColor: 'rgba(239, 68, 68, 1)',
            borderWidth: 0,
            fill: true,
            pointRadius: 0
          }
        ]
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
              font: { size: 10 }
            }
          },
          title: {
            display: true,
            text: `F-Distribution (F = ${FStat.toFixed(3)}, df₁=${df1}, df₂=${df2})`,
            font: { size: 11, weight: 'bold' }
          }
        },
        scales: {
          x: {
            title: {
              display: true,
              text: 'F-value',
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
