<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Chi-Square Calculator Online – Free | 8gwifi.org</title>
<meta name="description" content="Free online Chi‑square calculator: independence and goodness‑of‑fit. Compute χ², expected counts, p‑value, degrees of freedom, and critical values with visuals.">
<meta name="keywords" content="chi-square calculator, chi square test, test of independence, goodness of fit, contingency table, chi-square statistic, categorical data analysis">
<link rel="canonical" href="https://8gwifi.org/chi-square-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Chi-Square Calculator Online – Free | 8gwifi.org">
<meta property="og:description" content="Chi‑square tests: independence & goodness‑of‑fit. χ², expected counts, p‑value, df, and visualizations.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/chi-square-calculator.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Chi-Square Calculator Online – Free | 8gwifi.org">
<meta name="twitter:description" content="Free Chi‑square calculator: independence & goodness‑of‑fit with χ², p‑value, df, and charts.">

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<!-- jStat for statistical functions -->
<script src="https://cdn.jsdelivr.net/npm/jstat@latest/dist/jstat.min.js"></script>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Chi-Square Calculator",
  "url": "https://8gwifi.org/chi-square-calculator.jsp",
  "description": "Comprehensive Chi-Square Calculator for test of independence and goodness of fit. Analyze categorical data with contingency tables, calculate chi-square statistics, expected frequencies, and p-values.",
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "browserRequirements": "Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Chi-square test of independence, Goodness of fit test, Contingency table analysis, Expected frequency calculation, Chi-square statistic, P-value calculation, Degrees of freedom, Chi-square distribution visualization"
}
</script>

<style>
  :root {
    --primary-color: #10b981;
    --primary-dark: #059669;
    --primary-light: #6ee7b7;
    --bg-light: #f0fdf4;
    --border-color: #a7f3d0;
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
    box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
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
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
  }

  .btn-sample {
    background: white;
    color: var(--primary-color);
    border: 1.5px solid var(--primary-color);
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
    border-radius: 6px;
    transition: all 0.2s;
  }

  .btn-sample:hover {
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
    background: #d1fae5;
    border-left: 4px solid #10b981;
    padding: 0.75rem;
    border-radius: 4px;
    font-size: 0.85rem;
    margin-top: 0.5rem;
    color: #065f46;
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

  #chiSquareDist {
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

  .contingency-table {
    width: 100%;
    overflow-x: auto;
    margin: 1rem 0;
  }

  .contingency-table table {
    width: 100%;
    border-collapse: collapse;
  }

  .contingency-table input {
    width: 80px;
    padding: 0.25rem;
    border: 1px solid #d1d5db;
    border-radius: 4px;
    text-align: center;
  }

  .contingency-table th,
  .contingency-table td {
    padding: 0.5rem;
    border: 1px solid #d1d5db;
    text-align: center;
  }

  .contingency-table th {
    background: var(--primary-color);
    color: white;
    font-weight: 500;
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

  .example-table {
    background: white;
    border-radius: 8px;
    overflow: hidden;
    margin: 1rem 0;
  }

  .example-table table {
    margin-bottom: 0;
  }

  .example-table th {
    background: var(--primary-color);
    color: white;
    font-weight: 500;
    padding: 0.75rem;
  }

  .example-table td {
    padding: 0.5rem 0.75rem;
    border-bottom: 1px solid #e5e7eb;
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
  <h1>Chi-Square Calculator</h1>
  <p class="text-muted">Perform chi-square tests of independence and goodness of fit for categorical data analysis</p>

  
  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="calculator-section">
        <h2 class="section-title"><i class="fas fa-table"></i> Test Type</h2>

        <!-- Test Type Tabs -->
        <ul class="nav nav-tabs mb-3" id="testTabs" role="tablist">
          <li class="nav-item">
            <a class="nav-link active" id="independence-tab" data-toggle="tab" href="#independence" role="tab">Test of Independence</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="goodness-tab" data-toggle="tab" href="#goodness" role="tab">Goodness of Fit</a>
          </li>
        </ul>

        <div class="tab-content" id="testTabContent">
          <!-- Test of Independence -->
          <div class="tab-pane fade show active" id="independence" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Test of Independence:</strong> Determine if two categorical variables are independent using a contingency table
            </div>

            <div class="mb-3">
              <label class="form-label">Table Dimensions</label>
              <div class="row">
                <div class="col-6">
                  <select class="form-control" id="numRows" onchange="updateContingencyTable()">
                    <option value="2" selected>2 Rows</option>
                    <option value="3">3 Rows</option>
                    <option value="4">4 Rows</option>
                    <option value="5">5 Rows</option>
                  </select>
                </div>
                <div class="col-6">
                  <select class="form-control" id="numCols" onchange="updateContingencyTable()">
                    <option value="2" selected>2 Columns</option>
                    <option value="3">3 Columns</option>
                    <option value="4">4 Columns</option>
                    <option value="5">5 Columns</option>
                  </select>
                </div>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label">Contingency Table (Observed Frequencies)</label>
              <div class="contingency-table" id="contingencyTableContainer"></div>
              <button class="btn btn-sample mt-2" onclick="loadSampleContingency()">
                <i class="fas fa-flask"></i> Load Sample Data
              </button>
            </div>

            <div class="mb-3">
              <label for="independenceAlpha" class="form-label">Significance Level (α)</label>
              <select class="form-control" id="independenceAlpha">
                <option value="0.01">0.01 (99% confidence)</option>
                <option value="0.05" selected>0.05 (95% confidence)</option>
                <option value="0.10">0.10 (90% confidence)</option>
              </select>
            </div>
          </div>

          <!-- Goodness of Fit -->
          <div class="tab-pane fade" id="goodness" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Goodness of Fit:</strong> Test if observed frequencies match expected distribution
            </div>

            <div class="mb-3">
              <label for="observedFreq" class="form-label">Observed Frequencies (comma separated)</label>
              <input type="text" class="form-control" id="observedFreq" value="30, 20, 25, 25" placeholder="e.g., 30, 20, 25, 25">
            </div>

            <div class="mb-3">
              <label for="expectedFreq" class="form-label">Expected Frequencies (comma separated)</label>
              <input type="text" class="form-control" id="expectedFreq" value="25, 25, 25, 25" placeholder="e.g., 25, 25, 25, 25">
              <small class="text-muted">Leave blank for equal expected frequencies</small>
            </div>

            <div class="mb-3">
              <label for="goodnessAlpha" class="form-label">Significance Level (α)</label>
              <select class="form-control" id="goodnessAlpha">
                <option value="0.01">0.01 (99% confidence)</option>
                <option value="0.05" selected>0.05 (95% confidence)</option>
                <option value="0.10">0.10 (90% confidence)</option>
              </select>
            </div>
          </div>
        </div>

        <button class="btn btn-calculate mt-3" onclick="calculateChiSquare()">
          <i class="fas fa-calculator"></i> Calculate Chi-Square
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
            <p class="mt-2">Select a test type and enter data to see results</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Educational Content -->
  <div class="educational-section">
    <h3><i class="fas fa-graduation-cap"></i> Understanding Chi-Square Tests</h3>

    <p>The <strong>chi-square (χ²) test</strong> is a statistical method used to analyze categorical data. It tests whether observed frequencies differ significantly from expected frequencies.</p>

    <h4>Chi-Square Formula</h4>
    <div class="formula-box">
      χ² = Σ [(O - E)² / E]
    </div>
    <p>Where: O = Observed frequency, E = Expected frequency</p>

    <h4>1. Test of Independence</h4>
    <p>Tests whether two categorical variables are independent or associated.</p>

    <p><strong>Hypotheses:</strong></p>
    <ul>
      <li><strong>H₀ (Null):</strong> Variables are independent (no association)</li>
      <li><strong>H₁ (Alternative):</strong> Variables are dependent (associated)</li>
    </ul>

    <p><strong>Expected Frequency Formula:</strong></p>
    <div class="formula-box">
      E = (Row Total × Column Total) / Grand Total
    </div>

    <p><strong>Degrees of Freedom:</strong></p>
    <div class="formula-box">
      df = (rows - 1) × (columns - 1)
    </div>

    <h4>2. Goodness of Fit Test</h4>
    <p>Tests whether observed sample distribution matches an expected theoretical distribution.</p>

    <p><strong>Hypotheses:</strong></p>
    <ul>
      <li><strong>H₀ (Null):</strong> Data follows the expected distribution</li>
      <li><strong>H₁ (Alternative):</strong> Data does NOT follow the expected distribution</li>
    </ul>

    <p><strong>Degrees of Freedom:</strong></p>
    <div class="formula-box">
      df = k - 1
    </div>
    <p>Where k = number of categories</p>

    <h4>Interpreting Results</h4>
    <ul>
      <li><strong>If p-value ≤ α:</strong> Reject H₀ (significant association/difference exists)</li>
      <li><strong>If p-value > α:</strong> Fail to reject H₀ (no significant association/difference)</li>
      <li><strong>Larger χ²:</strong> Indicates greater difference between observed and expected</li>
    </ul>

    <h4>Assumptions</h4>
    <ul>
      <li><strong>Independence:</strong> Observations must be independent</li>
      <li><strong>Sample Size:</strong> Expected frequency ≥ 5 in at least 80% of cells</li>
      <li><strong>Random Sampling:</strong> Data should come from random samples</li>
      <li><strong>Categorical Data:</strong> Variables must be categorical (not continuous)</li>
    </ul>

    <h4>Real-World Applications</h4>

    <div class="example-table">
      <table class="table">
        <thead>
          <tr>
            <th>Field</th>
            <th>Application</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>Medicine</strong></td>
            <td>Test relationship between treatment and outcome</td>
          </tr>
          <tr>
            <td><strong>Marketing</strong></td>
            <td>Analyze customer preferences across demographics</td>
          </tr>
          <tr>
            <td><strong>Genetics</strong></td>
            <td>Test if observed ratios match Mendelian predictions</td>
          </tr>
          <tr>
            <td><strong>Education</strong></td>
            <td>Examine relationship between teaching method and performance</td>
          </tr>
          <tr>
            <td><strong>Social Sciences</strong></td>
            <td>Study associations between social factors</td>
          </tr>
          <tr>
            <td><strong>Quality Control</strong></td>
            <td>Test if defect rates match expected distributions</td>
          </tr>
        </tbody>
      </table>
    </div>

    <h4>Example: Test of Independence</h4>
    <p><strong>Scenario:</strong> Testing if gender is independent of product preference</p>

    <div class="example-table">
      <table class="table">
        <thead>
          <tr>
            <th></th>
            <th>Product A</th>
            <th>Product B</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>Male</strong></td>
            <td>30</td>
            <td>20</td>
            <td>50</td>
          </tr>
          <tr>
            <td><strong>Female</strong></td>
            <td>15</td>
            <td>35</td>
            <td>50</td>
          </tr>
          <tr>
            <td><strong>Total</strong></td>
            <td>45</td>
            <td>55</td>
            <td>100</td>
          </tr>
        </tbody>
      </table>
    </div>

    <p>Expected frequency for Male/Product A: (50 × 45) / 100 = 22.5</p>
    <p>If χ² is large and p-value < 0.05, we conclude gender and product preference are associated.</p>

    <h4>Effect Size: Cramér's V</h4>
    <p>Measures strength of association (ranges from 0 to 1):</p>
    <div class="formula-box">
      V = √(χ² / (n × (min(rows, cols) - 1)))
    </div>
    <ul>
      <li><strong>Small effect:</strong> V ≈ 0.1</li>
      <li><strong>Medium effect:</strong> V ≈ 0.3</li>
      <li><strong>Large effect:</strong> V ≈ 0.5</li>
    </ul>

    <div class="info-box">
      <i class="fas fa-lightbulb"></i>
      <strong>Tip:</strong> Chi-square tests are sensitive to sample size. With very large samples, even trivial differences can be statistically significant. Always consider practical significance alongside statistical significance.
    </div>
  </div>
</div>

<%@ include file="thanks.jsp"%>

  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="addcomments.jsp"%>
  <!-- FAQ: inlined (was jspf/faq/math/chi-square-calculator-faq.jspf) -->
  <section id="faq" class="mt-5">
    <h2 class="h5">Chi‑Square Calculator: Frequently Asked Questions</h2>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">When do I use a chi‑square test?</h3>
      <p class="mb-0">Use goodness‑of‑fit to test if observed counts match expected proportions; use test of independence to check association between two categorical variables.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">What are the assumptions?</h3>
      <p class="mb-0">Data are counts in categories, observations are independent, and expected cell counts are not too small (rule of thumb ≥ 5 for most cells).</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How are expected counts computed?</h3>
      <p class="mb-0">For independence, expected = (row total × column total) ÷ grand total. For goodness‑of‑fit, expected = total × hypothesized proportion.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How do I interpret χ² and p‑value?</h3>
      <p class="mb-0">Larger χ² suggests bigger deviation from expectation. The p‑value quantifies how unusual the observed deviations are under the null hypothesis.</p>
    </div></div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"When do I use a chi‑square test?","acceptedAnswer":{"@type":"Answer","text":"Use goodness‑of‑fit to test if observed counts match expected proportions; use test of independence to check association between two categorical variables."}},
      {"@type":"Question","name":"What are the assumptions?","acceptedAnswer":{"@type":"Answer","text":"Data are counts in categories, observations are independent, and expected cell counts are not too small (rule of thumb ≥ 5 for most cells)."}},
      {"@type":"Question","name":"How are expected counts computed?","acceptedAnswer":{"@type":"Answer","text":"For independence, expected = (row total × column total) ÷ grand total. For goodness‑of‑fit, expected = total × hypothesized proportion."}},
      {"@type":"Question","name":"How do I interpret χ² and p‑value?","acceptedAnswer":{"@type":"Answer","text":"Larger χ² suggests bigger deviation from expectation. The p‑value quantifies how unusual the observed deviations are under the null hypothesis."}}
    ]
  }
  </script>
  <!-- Breadcrumbs: inlined (was jspf/breadcrumbs/math/chi-square-calculator-breadcrumbs.jspf) -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"Chi-Square Calculator","item":"https://8gwifi.org/chi-square-calculator.jsp"}
    ]
  }
  </script>
</div>
<%@ include file="body-close.jsp"%>

<script>
  let chiSquareChart = null;

  function updateContingencyTable() {
    const rows = parseInt(document.getElementById('numRows').value);
    const cols = parseInt(document.getElementById('numCols').value);

    let html = '<table><thead><tr><th></th>';
    for (let c = 0; c < cols; c++) {
      html += `<th>Column ${c + 1}</th>`;
    }
    html += '</tr></thead><tbody>';

    for (let r = 0; r < rows; r++) {
      html += `<tr><th>Row ${r + 1}</th>`;
      for (let c = 0; c < cols; c++) {
        html += `<td><input type="number" id="cell_${r}_${c}" value="10" min="0" step="1"></td>`;
      }
      html += '</tr>';
    }
    html += '</tbody></table>';

    document.getElementById('contingencyTableContainer').innerHTML = html;
  }

  function loadSampleContingency() {
    document.getElementById('numRows').value = '2';
    document.getElementById('numCols').value = '2';
    updateContingencyTable();

    document.getElementById('cell_0_0').value = '30';
    document.getElementById('cell_0_1').value = '20';
    document.getElementById('cell_1_0').value = '15';
    document.getElementById('cell_1_1').value = '35';
  }

  function calculateChiSquare() {
    const activeTab = document.querySelector('#testTabs .nav-link.active').id;

    try {
      if (activeTab === 'independence-tab') {
        calculateIndependence();
      } else if (activeTab === 'goodness-tab') {
        calculateGoodnessOfFit();
      }
    } catch (error) {
      alert('Error: ' + error.message);
    }
  }

  function calculateIndependence() {
    const rows = parseInt(document.getElementById('numRows').value);
    const cols = parseInt(document.getElementById('numCols').value);
    const alpha = parseFloat(document.getElementById('independenceAlpha').value);

    // Get observed frequencies
    const observed = [];
    for (let r = 0; r < rows; r++) {
      const row = [];
      for (let c = 0; c < cols; c++) {
        const val = parseFloat(document.getElementById(`cell_${r}_${c}`).value);
        if (isNaN(val) || val < 0) throw new Error('All cell values must be non-negative numbers');
        row.push(val);
      }
      observed.push(row);
    }

    // Calculate row totals, column totals, and grand total
    const rowTotals = observed.map(row => row.reduce((a, b) => a + b, 0));
    const colTotals = [];
    for (let c = 0; c < cols; c++) {
      colTotals.push(observed.reduce((sum, row) => sum + row[c], 0));
    }
    const grandTotal = rowTotals.reduce((a, b) => a + b, 0);

    if (grandTotal === 0) throw new Error('Total frequency cannot be zero');

    // Calculate expected frequencies
    const expected = [];
    for (let r = 0; r < rows; r++) {
      const row = [];
      for (let c = 0; c < cols; c++) {
        const exp = (rowTotals[r] * colTotals[c]) / grandTotal;
        row.push(exp);
      }
      expected.push(row);
    }

    // Calculate chi-square statistic
    let chiSquare = 0;
    for (let r = 0; r < rows; r++) {
      for (let c = 0; c < cols; c++) {
        const o = observed[r][c];
        const e = expected[r][c];
        chiSquare += Math.pow(o - e, 2) / e;
      }
    }

    // Degrees of freedom
    const df = (rows - 1) * (cols - 1);

    // P-value
    const pValue = 1 - jStat.chisquare.cdf(chiSquare, df);

    // Critical value
    const criticalValue = jStat.chisquare.inv(1 - alpha, df);

    // Cramér's V effect size
    const cramersV = Math.sqrt(chiSquare / (grandTotal * (Math.min(rows, cols) - 1)));

    displayResults({
      testType: 'Chi-Square Test of Independence',
      chiSquare: chiSquare,
      df: df,
      pValue: pValue,
      alpha: alpha,
      criticalValue: criticalValue,
      significant: pValue < alpha,
      cramersV: cramersV,
      observed: observed,
      expected: expected
    });

    drawChiSquareDistribution(chiSquare, df, criticalValue);
  }

  function calculateGoodnessOfFit() {
    const obsStr = document.getElementById('observedFreq').value;
    const expStr = document.getElementById('expectedFreq').value.trim();
    const alpha = parseFloat(document.getElementById('goodnessAlpha').value);

    const observed = obsStr.split(',').map(x => parseFloat(x.trim())).filter(x => !isNaN(x));

    if (observed.length < 2) throw new Error('Need at least 2 categories');
    if (observed.some(x => x < 0)) throw new Error('Frequencies must be non-negative');

    const total = observed.reduce((a, b) => a + b, 0);
    if (total === 0) throw new Error('Total frequency cannot be zero');

    // Expected frequencies
    let expected;
    if (expStr === '') {
      // Equal expected frequencies
      const equalFreq = total / observed.length;
      expected = observed.map(() => equalFreq);
    } else {
      expected = expStr.split(',').map(x => parseFloat(x.trim())).filter(x => !isNaN(x));
      if (expected.length !== observed.length) {
        throw new Error('Observed and expected must have same number of categories');
      }
      if (expected.some(x => x < 0)) throw new Error('Expected frequencies must be non-negative');
    }

    // Calculate chi-square statistic
    let chiSquare = 0;
    for (let i = 0; i < observed.length; i++) {
      chiSquare += Math.pow(observed[i] - expected[i], 2) / expected[i];
    }

    // Degrees of freedom
    const df = observed.length - 1;

    // P-value
    const pValue = 1 - jStat.chisquare.cdf(chiSquare, df);

    // Critical value
    const criticalValue = jStat.chisquare.inv(1 - alpha, df);

    displayResults({
      testType: 'Chi-Square Goodness of Fit Test',
      chiSquare: chiSquare,
      df: df,
      pValue: pValue,
      alpha: alpha,
      criticalValue: criticalValue,
      significant: pValue < alpha,
      observed: [observed],
      expected: [expected]
    });

    drawChiSquareDistribution(chiSquare, df, criticalValue);
  }

  function displayResults(results) {
    let html = `
      <div class="result-item">
        <div class="result-label">${results.testType}</div>
      </div>

      <div class="result-item">
        <div class="result-label">χ² Statistic</div>
        <div class="result-value">${results.chiSquare.toFixed(4)}</div>
      </div>

      <div class="result-item">
        <div class="result-label">Degrees of Freedom</div>
        <div class="result-value">${results.df}</div>
      </div>

      <div class="result-item">
        <div class="result-label">P-Value</div>
        <div class="result-value">${results.pValue.toFixed(6)}</div>
        <div class="interpretation">
          ${results.significant
            ? `<strong style="color: #dc2626;">Significant!</strong> p < α (${results.alpha}). Reject null hypothesis.`
            : `<strong style="color: #16a34a;">Not Significant.</strong> p ≥ α (${results.alpha}). Fail to reject null hypothesis.`
          }
        </div>
      </div>

      <div class="result-item">
        <div class="result-label">Critical Value (α = ${results.alpha})</div>
        <div class="result-value">${results.criticalValue.toFixed(4)}</div>
      </div>
    `;

    if (results.cramersV !== undefined) {
      let effectSize = 'small';
      if (results.cramersV >= 0.5) effectSize = 'large';
      else if (results.cramersV >= 0.3) effectSize = 'medium';

      html += `
        <div class="result-item">
          <div class="result-label">Cramér's V (Effect Size)</div>
          <div class="result-value">${results.cramersV.toFixed(4)}</div>
          <div class="interpretation">
            <strong>${effectSize.charAt(0).toUpperCase() + effectSize.slice(1)}</strong> effect size
          </div>
        </div>
      `;
    }

    document.getElementById('resultsContent').innerHTML = html;
  }

  function drawChiSquareDistribution(chiStat, df, criticalValue) {
    const container = document.getElementById('resultsContent');

    let canvas = document.getElementById('chiSquareDist');
    if (!canvas) {
      const chartHtml = `
        <div class="chart-container">
          <h5 style="color: var(--primary-color); margin-bottom: 1rem; font-size: 0.95rem;">
            <i class="fas fa-chart-area"></i> Chi-Square Distribution (df = ${df})
          </h5>
          <canvas id="chiSquareDist"></canvas>
        </div>
      `;
      container.insertAdjacentHTML('beforeend', chartHtml);
      canvas = document.getElementById('chiSquareDist');
    }

    if (chiSquareChart) {
      chiSquareChart.destroy();
    }

    // Generate chi-square distribution curve
    const xValues = [];
    const yValues = [];
    const maxX = Math.max(chiStat + 5, criticalValue + 5, df + 10);

    for (let x = 0; x <= maxX; x += 0.2) {
      xValues.push(x);
      yValues.push(jStat.chisquare.pdf(x, df));
    }

    // Shaded rejection region
    const rejectRegion = xValues.map((x, i) => x >= criticalValue ? yValues[i] : null);

    chiSquareChart = new Chart(canvas, {
      type: 'line',
      data: {
        labels: xValues,
        datasets: [
          {
            label: 'χ² Distribution',
            data: yValues,
            borderColor: 'rgba(16, 185, 129, 1)',
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
            text: `Chi-Square Distribution (χ² = ${chiStat.toFixed(3)}, df = ${df})`,
            font: { size: 11, weight: 'bold' }
          }
        },
        scales: {
          x: {
            title: {
              display: true,
              text: 'χ² value',
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

  // Initialize contingency table on load
  window.addEventListener('load', () => {
    updateContingencyTable();
  });
</script>
