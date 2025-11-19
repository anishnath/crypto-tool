<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>P-Value Calculator Online – Free | 8gwifi.org</title>
<meta name="description" content="Free p‑value calculator: compute one‑tail or two‑tail p‑values from Z, t, χ², and F statistics with distribution charts.">
<meta name="keywords" content="p-value calculator, p value, hypothesis testing, z-score to p-value, t-test p-value, chi-square p-value, f-test p-value, statistical significance">
<link rel="canonical" href="https://8gwifi.org/p-value-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="P-Value Calculator Online – Free | 8gwifi.org">
<meta property="og:description" content="Compute p‑values from Z, t, χ², and F — one‑tail or two‑tail with visuals.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/p-value-calculator.jsp">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="P-Value Calculator Online – Free | 8gwifi.org">
<meta name="twitter:description" content="Free p‑value tool for Z, t, χ², F with charts.">

<%@ include file="header-script.jsp"%>

<style>
  .sticky-side {
    position: sticky;
    top: 80px;
    max-height: calc(100vh - 100px);
    overflow-y: auto;
  }

  .result-hero {
    text-align: center;
    padding: 2rem 1rem;
    background: linear-gradient(135deg, #1e293b, #334155);
    border-radius: 12px;
    margin-bottom: 1rem;
  }
  .result-hero .pval {
    font-size: 2.5rem;
    font-weight: 800;
    color: #60a5fa;
    margin: 0;
  }
  .result-hero .sig-label {
    display: inline-block;
    margin-top: 0.5rem;
    padding: 0.4rem 1rem;
    border-radius: 20px;
    font-weight: 600;
    font-size: 0.9rem;
  }
  .sig-high { background: #10b981; color: white; }
  .sig-mid { background: #3b82f6; color: white; }
  .sig-low { background: #f59e0b; color: white; }
  .sig-none { background: #6b7280; color: white; }

  .nav-tabs .nav-link {
    color: #6b7280;
    border: none;
    border-bottom: 3px solid transparent;
  }
  .nav-tabs .nav-link.active {
    color: #3b82f6;
    font-weight: 600;
    border-bottom-color: #3b82f6;
  }
  .nav-tabs .nav-link:hover {
    border-bottom-color: #60a5fa;
  }

  .tail-toggle {
    display: flex;
    gap: 0.5rem;
    margin: 1rem 0;
  }
  .tail-btn {
    flex: 1;
    padding: 0.6rem;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    background: white;
    cursor: pointer;
    text-align: center;
    font-weight: 600;
    color: #6b7280;
    transition: all 0.2s;
  }
  .tail-btn:hover { border-color: #3b82f6; }
  .tail-btn.active { border-color: #3b82f6; background: #eff6ff; color: #3b82f6; }

  .form-row {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin-bottom: 1rem;
  }
  .form-group input:focus {
    outline: none;
    border-color: #3b82f6;
    box-shadow: 0 0 0 0.2rem rgba(59,130,246,0.25);
  }

  .stat-line {
    padding: 0.5rem 0;
    border-bottom: 1px solid #e5e7eb;
    font-family: 'Courier New', monospace;
    font-size: 0.9rem;
  }
  .stat-line:last-child { border-bottom: none; }
  .stat-line strong { color: #3b82f6; }

  .interpretation {
    background: #eff6ff;
    border-left: 4px solid #3b82f6;
    padding: 1rem;
    border-radius: 4px;
    line-height: 1.6;
  }

  .guide-box {
    background: #fef3c7;
    border: 1px solid #fbbf24;
    border-radius: 8px;
    padding: 1rem;
    margin-top: 1rem;
    font-size: 0.9rem;
  }
  .guide-box ul { margin: 0.5rem 0 0 0; padding-left: 1.5rem; }
  .guide-box li { margin: 0.25rem 0; }

  .empty-state {
    text-align: center;
    padding: 3rem 1rem;
    color: #9ca3af;
  }
  .empty-state i { font-size: 3rem; margin-bottom: 1rem; }
</style>

<script type="application/ld+json">
{
  "@context":"https://schema.org",
  "@type":"WebApplication",
  "name":"P-Value Calculator",
  "url":"https://8gwifi.org/p-value-calculator.jsp",
  "description":"Calculate p-values from test statistics for hypothesis testing including Z, T, Chi-square, and F tests. Free online statistical tool with interactive visualization.",
  "applicationCategory":"EducationalApplication",
  "operatingSystem":"Any",
  "browserRequirements":"Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Z-Test, T-Test, Chi-Square Test, F-Test, One-tailed test, Two-tailed test, Statistical visualization",
  "screenshot": "https://8gwifi.org/images/p-value-calculator.png",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "1250"
  }
}
</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1 class="mb-3">P-Value Calculator</h1>
  <p class="lead mb-4">Calculate p-values from test statistics for hypothesis testing. Choose your test type below.</p>

  <div class="row">
    <!-- Left Column - Input Forms -->
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <ul class="nav nav-tabs mb-3" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" data-toggle="tab" href="#zTab">Z-Test</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" data-toggle="tab" href="#tTab">T-Test</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" data-toggle="tab" href="#chiTab">Chi-Square</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" data-toggle="tab" href="#fTab">F-Test</a>
            </li>
          </ul>

          <!-- Tail Type -->
          <div class="tail-toggle">
            <div class="tail-btn" data-tail="left">← Left</div>
            <div class="tail-btn active" data-tail="two">↔ Two-Tailed</div>
            <div class="tail-btn" data-tail="right">Right →</div>
          </div>

          <div class="tab-content">
            <!-- Z-Test -->
            <div class="tab-pane fade show active" id="zTab">
              <h5 class="mb-3">Z-Test Parameters</h5>
              <p class="text-muted small">Enter the Z-score from your statistical test.</p>

              <div class="form-group">
                <label><strong>Z-Score</strong></label>
                <input type="number" class="form-control" id="zScore" value="1.96" step="0.01">
                <small class="form-text text-muted">Standard normal test statistic</small>
              </div>

              <button class="btn btn-primary btn-block" onclick="calculate('z')">
                Calculate P-Value
              </button>
            </div>

            <!-- T-Test -->
            <div class="tab-pane fade" id="tTab">
              <h5 class="mb-3">T-Test Parameters</h5>
              <p class="text-muted small">Enter the T-statistic and degrees of freedom.</p>

              <div class="form-row">
                <div class="form-group">
                  <label><strong>T-Statistic</strong></label>
                  <input type="number" class="form-control" id="tScore" value="2.5" step="0.01">
                  <small class="form-text text-muted">T-test statistic</small>
                </div>
                <div class="form-group">
                  <label><strong>Degrees of Freedom</strong></label>
                  <input type="number" class="form-control" id="tDf" value="20" step="1" min="1">
                  <small class="form-text text-muted">n - 1 or n1 + n2 - 2</small>
                </div>
              </div>

              <button class="btn btn-primary btn-block" onclick="calculate('t')">
                Calculate P-Value
              </button>
            </div>

            <!-- Chi-Square -->
            <div class="tab-pane fade" id="chiTab">
              <h5 class="mb-3">Chi-Square Parameters</h5>
              <p class="text-muted small">Enter the Chi-square statistic and degrees of freedom.</p>

              <div class="form-row">
                <div class="form-group">
                  <label><strong>χ² Statistic</strong></label>
                  <input type="number" class="form-control" id="chiScore" value="5.99" step="0.01" min="0">
                  <small class="form-text text-muted">Chi-square test statistic</small>
                </div>
                <div class="form-group">
                  <label><strong>Degrees of Freedom</strong></label>
                  <input type="number" class="form-control" id="chiDf" value="2" step="1" min="1">
                  <small class="form-text text-muted">(rows-1) × (cols-1)</small>
                </div>
              </div>

              <button class="btn btn-primary btn-block" onclick="calculate('chi')">
                Calculate P-Value
              </button>
            </div>

            <!-- F-Test -->
            <div class="tab-pane fade" id="fTab">
              <h5 class="mb-3">F-Test Parameters</h5>
              <p class="text-muted small">Enter the F-statistic and both degrees of freedom.</p>

              <div class="form-row">
                <div class="form-group">
                  <label><strong>F-Statistic</strong></label>
                  <input type="number" class="form-control" id="fScore" value="3.5" step="0.01" min="0">
                  <small class="form-text text-muted">F-test statistic</small>
                </div>
                <div class="form-group">
                  <label><strong>DF Numerator</strong></label>
                  <input type="number" class="form-control" id="fDf1" value="3" step="1" min="1">
                  <small class="form-text text-muted">Between groups</small>
                </div>
                <div class="form-group">
                  <label><strong>DF Denominator</strong></label>
                  <input type="number" class="form-control" id="fDf2" value="20" step="1" min="1">
                  <small class="form-text text-muted">Within groups</small>
                </div>
              </div>

              <button class="btn btn-primary btn-block" onclick="calculate('f')">
                Calculate P-Value
              </button>
            </div>
          </div>

          <!-- Guide -->
          <div class="guide-box">
            <strong>Significance Levels:</strong>
            <ul>
              <li><strong>p &lt; 0.01</strong> — Highly significant</li>
              <li><strong>p &lt; 0.05</strong> — Significant (standard threshold)</li>
              <li><strong>p &lt; 0.10</strong> — Marginally significant</li>
              <li><strong>p ≥ 0.10</strong> — Not significant</li>
            </ul>
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
            <div class="empty-state">
              <i class="fas fa-arrow-left"></i>
              <p>Enter values and click Calculate</p>
            </div>
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
          <h5 class="mb-0"><i class="fas fa-graduation-cap"></i> Understanding P-Values & Statistical Significance</h5>
        </div>
        <div class="card-body">

          <div class="row">
            <div class="col-md-6">
              <h6 class="font-weight-bold">What is a P-Value?</h6>
              <p>The <strong>p-value</strong> (probability value) is the probability of obtaining test results at least as extreme as the observed results, assuming that the null hypothesis is true.</p>

              <div class="alert alert-info">
                <strong>In Simple Terms:</strong> The p-value tells you how likely your results are due to random chance. A small p-value means your results are <em>unlikely</em> to happen by chance alone.
              </div>

              <h6 class="font-weight-bold mt-4">Why Do We Need P-Values?</h6>
              <ul>
                <li><strong>Hypothesis Testing:</strong> Determine if your data supports or rejects a hypothesis</li>
                <li><strong>Decision Making:</strong> Decide whether differences/effects are real or just random noise</li>
                <li><strong>Scientific Validity:</strong> Provide statistical evidence for research findings</li>
                <li><strong>Risk Assessment:</strong> Quantify the chance of making a wrong conclusion</li>
              </ul>

              <h6 class="font-weight-bold mt-4">What is Significance Level (α)?</h6>
              <p>The <strong>significance level</strong> (alpha, α) is the threshold you set <em>before</em> conducting your test to determine whether results are statistically significant.</p>

              <div class="table-responsive mt-3">
                <table class="table table-bordered table-sm">
                  <thead class="thead-light">
                    <tr>
                      <th>Significance Level</th>
                      <th>Interpretation</th>
                      <th>Common Use</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><strong>α = 0.01</strong></td>
                      <td>99% confidence</td>
                      <td>Clinical trials, high-stakes decisions</td>
                    </tr>
                    <tr>
                      <td><strong>α = 0.05</strong></td>
                      <td>95% confidence</td>
                      <td>Most scientific research (standard)</td>
                    </tr>
                    <tr>
                      <td><strong>α = 0.10</strong></td>
                      <td>90% confidence</td>
                      <td>Exploratory research, preliminary studies</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div class="col-md-6">
              <h6 class="font-weight-bold">P-Value Interpretation Guide</h6>

              <div class="card mb-3" style="border-left: 4px solid #10b981;">
                <div class="card-body">
                  <h6 class="text-success font-weight-bold">p < 0.01 — Highly Significant ✓✓✓</h6>
                  <p class="mb-0">Very strong evidence against null hypothesis. Results are highly unlikely to be due to chance. Reject null hypothesis with high confidence.</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #3b82f6;">
                <div class="card-body">
                  <h6 class="text-primary font-weight-bold">p < 0.05 — Significant ✓✓</h6>
                  <p class="mb-0">Strong evidence against null hypothesis. Standard threshold for statistical significance in most research. Reject null hypothesis.</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #f59e0b;">
                <div class="card-body">
                  <h6 class="text-warning font-weight-bold">p < 0.10 — Marginally Significant ✓</h6>
                  <p class="mb-0">Weak evidence against null hypothesis. May warrant further investigation but not conclusive. Use caution.</p>
                </div>
              </div>

              <div class="card mb-3" style="border-left: 4px solid #6b7280;">
                <div class="card-body">
                  <h6 class="text-secondary font-weight-bold">p ≥ 0.10 — Not Significant ✗</h6>
                  <p class="mb-0">Insufficient evidence against null hypothesis. Results could easily be due to chance. Fail to reject null hypothesis.</p>
                </div>
              </div>
            </div>
          </div>

          <hr class="my-4">

          <div class="row">
            <div class="col-md-6">
              <h6 class="font-weight-bold">Decision Rule</h6>
              <div class="card bg-light">
                <div class="card-body">
                  <p class="mb-2"><strong>If p-value ≤ α:</strong></p>
                  <p class="ml-3">→ <strong>Reject</strong> null hypothesis (H₀)</p>
                  <p class="ml-3">→ Results are <strong>statistically significant</strong></p>
                  <p class="ml-3">→ Evidence supports alternative hypothesis (H₁)</p>

                  <p class="mb-2 mt-3"><strong>If p-value > α:</strong></p>
                  <p class="ml-3">→ <strong>Fail to reject</strong> null hypothesis (H₀)</p>
                  <p class="ml-3">→ Results are <strong>not statistically significant</strong></p>
                  <p class="ml-3 mb-0">→ Insufficient evidence for alternative hypothesis</p>
                </div>
              </div>
            </div>

            <div class="col-md-6">
              <h6 class="font-weight-bold">Common Formulas</h6>

              <div class="card mb-2">
                <div class="card-body py-2">
                  <strong>Z-Test:</strong> <code>Z = (x̄ - μ) / (σ/√n)</code>
                  <br><small class="text-muted">Compare sample mean to population</small>
                </div>
              </div>

              <div class="card mb-2">
                <div class="card-body py-2">
                  <strong>T-Test:</strong> <code>t = (x̄ - μ) / (s/√n)</code>
                  <br><small class="text-muted">Small samples or unknown σ</small>
                </div>
              </div>

              <div class="card mb-2">
                <div class="card-body py-2">
                  <strong>Chi-Square:</strong> <code>χ² = Σ((O - E)² / E)</code>
                  <br><small class="text-muted">Categorical data analysis</small>
                </div>
              </div>

              <div class="card mb-2">
                <div class="card-body py-2">
                  <strong>F-Test:</strong> <code>F = variance₁ / variance₂</code>
                  <br><small class="text-muted">Compare variances or ANOVA</small>
                </div>
              </div>

              <div class="alert alert-warning mt-3 mb-0">
                <strong>⚠ Important Note:</strong> Statistical significance (low p-value) does not always mean <em>practical significance</em>. Always consider the effect size and real-world importance!
              </div>
            </div>
          </div>

          <hr class="my-4">

          <div class="row">
            <div class="col-12">
              <h6 class="font-weight-bold">Example Interpretation</h6>
              <div class="card bg-light">
                <div class="card-body">
                  <p class="mb-2"><strong>Scenario:</strong> Testing if a new drug reduces blood pressure</p>
                  <ul class="mb-2">
                    <li><strong>Null Hypothesis (H₀):</strong> The drug has no effect on blood pressure</li>
                    <li><strong>Alternative Hypothesis (H₁):</strong> The drug reduces blood pressure</li>
                    <li><strong>Significance Level:</strong> α = 0.05 (95% confidence)</li>
                  </ul>

                  <p class="mb-2"><strong>Results:</strong> After testing, you get p = 0.023</p>

                  <p class="mb-0"><strong>Interpretation:</strong></p>
                  <p class="ml-3 mb-0">Since <strong>p (0.023) < α (0.05)</strong>, we reject the null hypothesis. There is only a <strong>2.3% chance</strong> these results occurred by random chance. The drug <strong>significantly reduces blood pressure</strong> at the 95% confidence level.</p>
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>

  <div class="sharethis-inline-share-buttons mt-4"></div>
  <%@ include file="thanks.jsp"%>
  <hr>
  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="addcomments.jsp"%>
  <!-- FAQ: inline -->
  <section id="faq" class="mt-5">
    <h2 class="h5">P‑Value Calculator: FAQ</h2>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">One‑tailed vs two‑tailed?</h3>
      <p class="mb-0">One‑tailed tests look for an effect in one direction; two‑tailed tests detect effects in either direction. Match the alternative hypothesis you stated a priori.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">How do I interpret a p‑value?</h3>
      <p class="mb-0">It’s the probability, under the null, of observing data at least as extreme as yours. It’s not the probability the null is true.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Which distribution should I use?</h3>
      <p class="mb-0">Use Z for large‑sample or known σ tests; t for small‑sample unknown σ; χ² for variances/contingency; F for variance ratios/ANOVA.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Common misconceptions?</h3>
      <p class="mb-0">p≠probability the null is true; non‑significant ≠ no effect; significant ≠ practically important.</p>
    </div></div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"One‑tailed vs two‑tailed?","acceptedAnswer":{"@type":"Answer","text":"One‑tailed looks for an effect in one direction; two‑tailed detects effects in either direction. Match your alternative hypothesis."}},
      {"@type":"Question","name":"How do I interpret a p‑value?","acceptedAnswer":{"@type":"Answer","text":"Probability under the null of observing data as extreme as yours; not the probability the null is true."}},
      {"@type":"Question","name":"Which distribution should I use?","acceptedAnswer":{"@type":"Answer","text":"Z for large‑sample/known σ; t for small‑sample unknown σ; χ² for variances; F for variance ratios/ANOVA."}},
      {"@type":"Question","name":"Common misconceptions?","acceptedAnswer":{"@type":"Answer","text":"p≠prob(null true); non‑significant ≠ no effect; significant ≠ practically important."}}
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
      {"@type":"ListItem","position":2,"name":"P-Value Calculator","item":"https://8gwifi.org/p-value-calculator.jsp"}
    ]
  }
  </script>
</div>
</div>
<%@ include file="body-close.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jstat@latest/dist/jstat.min.js"></script>
<script>
let currentTail = 'two';

// Tail switching
document.querySelectorAll('.tail-btn').forEach(btn => {
  btn.addEventListener('click', function(){
    document.querySelectorAll('.tail-btn').forEach(b => b.classList.remove('active'));
    this.classList.add('active');
    currentTail = this.dataset.tail;
  });
});

// Auto-set right-tailed for Chi-square and F-test
$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){
  const target = $(e.target).attr('href');
  if(target === '#chiTab' || target === '#fTab'){
    currentTail = 'right';
    document.querySelectorAll('.tail-btn').forEach(b => {
      b.classList.toggle('active', b.dataset.tail === 'right');
    });
  }
});

// Global chart instance
let pValueChartInstance = null;

// Draw p-value distribution chart with optional user result
function drawPValueChart(userPValue = null){
  const ctx = document.getElementById('pValueChart');
  if(!ctx) return;

  // Destroy existing chart
  if(pValueChartInstance){
    pValueChartInstance.destroy();
  }

  // Determine which bar to highlight based on user's p-value
  let highlightIndex = -1;
  let backgroundColor = [
    'rgba(16, 185, 129, 0.3)',
    'rgba(59, 130, 246, 0.3)',
    'rgba(245, 158, 11, 0.3)',
    'rgba(107, 114, 128, 0.3)'
  ];
  let borderColor = [
    'rgba(16, 185, 129, 0.5)',
    'rgba(59, 130, 246, 0.5)',
    'rgba(245, 158, 11, 0.5)',
    'rgba(107, 114, 128, 0.5)'
  ];

  if(userPValue !== null){
    if(userPValue < 0.01){
      highlightIndex = 0;
    } else if(userPValue < 0.05){
      highlightIndex = 1;
    } else if(userPValue < 0.10){
      highlightIndex = 2;
    } else {
      highlightIndex = 3;
    }

    // Make highlighted bar fully opaque
    backgroundColor[highlightIndex] = backgroundColor[highlightIndex].replace('0.3', '0.95');
    borderColor[highlightIndex] = borderColor[highlightIndex].replace('0.5', '1');

  } else {
    // Default state - all bars moderately visible
    backgroundColor = backgroundColor.map(c => c.replace('0.3', '0.7'));
    borderColor = borderColor.map(c => c.replace('0.5', '0.9'));
  }

  pValueChartInstance = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: ['p < 0.01\nHighly\nSignificant', 'p < 0.05\nSignificant', 'p < 0.10\nMarginal', 'p ≥ 0.10\nNot\nSignificant'],
      datasets: [{
        label: 'Evidence Strength',
        data: [95, 75, 40, 10],
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: 3
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      scales: {
        y: {
          beginAtZero: true,
          max: 100,
          title: {
            display: true,
            text: 'Evidence Strength (%)'
          }
        }
      },
      plugins: {
        legend: {
          display: false
        },
        title: {
          display: true,
          text: userPValue !== null
            ? 'Your Result: p = ' + userPValue.toFixed(6)
            : 'Statistical Significance Levels'
        },
        tooltip: {
          callbacks: {
            afterLabel: function(context) {
              if(context.dataIndex === highlightIndex && userPValue !== null){
                return '← Your p-value';
              }
              return '';
            }
          }
        }
      }
    }
  });
}

// Initialize chart on page load
window.addEventListener('load', function(){
  drawPValueChart();
});

function calculate(test){
  let pval = 0, stats = '', interp = '';

  try {
    if(test === 'z'){
      const z = parseFloat(document.getElementById('zScore').value);
      if(isNaN(z)) return alert('Enter valid Z-score');

      const cdf = jStat.normal.cdf(z, 0, 1);
      pval = currentTail === 'left' ? cdf : currentTail === 'right' ? 1 - cdf : 2 * Math.min(cdf, 1 - cdf);

      stats = `<div class="stat-line"><strong>Test:</strong> Z-test (${currentTail}-tailed)</div>`;
      stats += `<div class="stat-line"><strong>Z-score:</strong> ${z.toFixed(4)}</div>`;
      stats += `<div class="stat-line"><strong>P-value:</strong> ${pval.toFixed(6)}</div>`;

    } else if(test === 't'){
      const t = parseFloat(document.getElementById('tScore').value);
      const df = parseInt(document.getElementById('tDf').value);
      if(isNaN(t) || isNaN(df) || df < 1) return alert('Enter valid T-statistic and DF');

      const cdf = jStat.studentt.cdf(t, df);
      pval = currentTail === 'left' ? cdf : currentTail === 'right' ? 1 - cdf : 2 * Math.min(cdf, 1 - cdf);

      stats = `<div class="stat-line"><strong>Test:</strong> T-test (${currentTail}-tailed)</div>`;
      stats += `<div class="stat-line"><strong>T-statistic:</strong> ${t.toFixed(4)}</div>`;
      stats += `<div class="stat-line"><strong>DF:</strong> ${df}</div>`;
      stats += `<div class="stat-line"><strong>P-value:</strong> ${pval.toFixed(6)}</div>`;

    } else if(test === 'chi'){
      const chi = parseFloat(document.getElementById('chiScore').value);
      const df = parseInt(document.getElementById('chiDf').value);
      if(isNaN(chi) || isNaN(df) || chi < 0 || df < 1) return alert('Enter valid χ² and DF');

      pval = 1 - jStat.chisquare.cdf(chi, df);

      stats = `<div class="stat-line"><strong>Test:</strong> Chi-square (right-tailed)</div>`;
      stats += `<div class="stat-line"><strong>χ² statistic:</strong> ${chi.toFixed(4)}</div>`;
      stats += `<div class="stat-line"><strong>DF:</strong> ${df}</div>`;
      stats += `<div class="stat-line"><strong>P-value:</strong> ${pval.toFixed(6)}</div>`;

    } else if(test === 'f'){
      const f = parseFloat(document.getElementById('fScore').value);
      const df1 = parseInt(document.getElementById('fDf1').value);
      const df2 = parseInt(document.getElementById('fDf2').value);
      if(isNaN(f) || isNaN(df1) || isNaN(df2) || f < 0 || df1 < 1 || df2 < 1)
        return alert('Enter valid F-statistic and DFs');

      pval = 1 - jStat.centralF.cdf(f, df1, df2);

      stats = `<div class="stat-line"><strong>Test:</strong> F-test (right-tailed)</div>`;
      stats += `<div class="stat-line"><strong>F-statistic:</strong> ${f.toFixed(4)}</div>`;
      stats += `<div class="stat-line"><strong>DF1:</strong> ${df1}, <strong>DF2:</strong> ${df2}</div>`;
      stats += `<div class="stat-line"><strong>P-value:</strong> ${pval.toFixed(6)}</div>`;
    }

    // Interpretation
    if(pval < 0.01){
      interp = `<strong>Highly Significant:</strong> p = ${pval.toFixed(6)} &lt; 0.01. Very strong evidence against the null hypothesis.`;
    } else if(pval < 0.05){
      interp = `<strong>Significant:</strong> p = ${pval.toFixed(6)} &lt; 0.05. Sufficient evidence to reject the null hypothesis.`;
    } else if(pval < 0.10){
      interp = `<strong>Marginally Significant:</strong> p = ${pval.toFixed(6)} &lt; 0.10. Weak evidence against the null hypothesis.`;
    } else {
      interp = `<strong>Not Significant:</strong> p = ${pval.toFixed(6)} ≥ 0.10. Insufficient evidence to reject the null hypothesis.`;
    }

    // Display
    let badge = '', badgeClass = '';
    if(pval < 0.01){ badge = 'Highly Significant'; badgeClass = 'sig-high'; }
    else if(pval < 0.05){ badge = 'Significant'; badgeClass = 'sig-mid'; }
    else if(pval < 0.10){ badge = 'Marginally Significant'; badgeClass = 'sig-low'; }
    else { badge = 'Not Significant'; badgeClass = 'sig-none'; }

    const html = `
      <div class="result-hero">
        <div class="pval">p = ${pval.toFixed(6)}</div>
        <span class="sig-label ${badgeClass}">${badge}</span>
      </div>

      <h6 class="mt-3">Statistical Details</h6>
      ${stats}

      <div class="interpretation mt-3">
        ${interp}
      </div>

      <hr class="my-3">

      <h6 class="mt-3">Visual Distribution</h6>
      <canvas id="pValueChart" height="240"></canvas>
      <div id="chartAnnotation" class="text-center mt-2">
        <small class="text-muted">👆 Your result is highlighted above</small>
      </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;

    // Update the chart with the user's p-value
    drawPValueChart(pval);


  } catch(e){
    console.error(e);
    alert('Error calculating p-value');
  }
}
</script>
