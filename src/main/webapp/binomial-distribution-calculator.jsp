<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Binomial Distribution Calculator Online – Free | 8gwifi.org</title>
<meta name="description" content="Free online Binomial Distribution Calculator. Calculate probabilities, cumulative probabilities, mean, variance, and visualize binomial distributions for any n and p.">
<meta name="keywords" content="binomial distribution calculator, binomial probability, binomial theorem, probability mass function, success probability, bernoulli trial">
<link rel="canonical" href="https://8gwifi.org/binomial-distribution-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Binomial Distribution Calculator Online – Free | 8gwifi.org">
<meta property="og:description" content="Calculate binomial probabilities, cumulative probabilities, and statistics with interactive visualization.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/binomial-distribution-calculator.jsp">
<meta property="og:image" content="https://8gwifi.org/images/binomial-distribution-calculator.png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Binomial Distribution Calculator Online – Free | 8gwifi.org">
<meta name="twitter:description" content="Calculate binomial probabilities and statistics with PMF visualization.">
<meta name="twitter:image" content="https://8gwifi.org/images/binomial-distribution-calculator.png">

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
  "name": "Binomial Distribution Calculator",
  "url": "https://8gwifi.org/binomial-distribution-calculator.jsp",
  "description": "Comprehensive Binomial Distribution Calculator. Calculate probabilities, cumulative probabilities, mean, variance, standard deviation, and visualize probability mass functions.",
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "browserRequirements": "Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Binomial probability P(X=k), Cumulative probability P(X≤k), Mean calculation, Variance calculation, Standard deviation, PMF visualization, Success probability, Number of trials",
  "screenshot": "https://8gwifi.org/images/binomial-distribution-calculator.png",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.7",
    "ratingCount": "1450"
  }
}
</script>

<style>
  :root {
    --primary-color: #6366f1;
    --primary-dark: #4f46e5;
    --primary-light: #a5b4fc;
    --bg-light: #eef2ff;
    --border-color: #c7d2fe;
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
    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
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
    box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
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
    background: #e0e7ff;
    border-left: 4px solid #6366f1;
    padding: 0.75rem;
    border-radius: 4px;
    font-size: 0.85rem;
    margin-top: 0.5rem;
    color: #312e81;
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

  #binomialPMF {
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
  <h1>Binomial Distribution Calculator</h1>
  <p class="text-muted">Calculate binomial probabilities, cumulative probabilities, and statistics</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="calculator-section">
        <h2 class="section-title"><i class="fas fa-dice"></i> Parameters</h2>

        <div class="mb-3">
          <label for="n" class="form-label">Number of Trials (n)</label>
          <input type="number" class="form-control" id="n" value="10" min="1" step="1">
          <small class="text-muted">Number of independent trials</small>
        </div>

        <div class="mb-3">
          <label for="p" class="form-label">Probability of Success (p)</label>
          <input type="number" class="form-control" id="p" value="0.5" min="0" max="1" step="0.01">
          <small class="text-muted">Probability of success on each trial (0 to 1)</small>
        </div>

        <hr>

        <h2 class="section-title"><i class="fas fa-calculator"></i> Calculation Type</h2>

        <!-- Calculation Type Tabs -->
        <ul class="nav nav-tabs mb-3" id="calcTabs" role="tablist">
          <li class="nav-item">
            <a class="nav-link active" id="exact-tab" data-toggle="tab" href="#exact" role="tab">P(X = k)</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="cumulative-tab" data-toggle="tab" href="#cumulative" role="tab">P(X ≤ k)</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="range-tab" data-toggle="tab" href="#range" role="tab">Range</a>
          </li>
        </ul>

        <div class="tab-content" id="calcTabContent">
          <!-- Exact Probability -->
          <div class="tab-pane fade show active" id="exact" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Exact probability:</strong> P(X = k) - Probability of exactly k successes
            </div>

            <div class="mb-3">
              <label for="kExact" class="form-label">Number of Successes (k)</label>
              <input type="number" class="form-control" id="kExact" value="5" min="0" step="1">
            </div>
          </div>

          <!-- Cumulative Probability -->
          <div class="tab-pane fade" id="cumulative" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Cumulative probability:</strong> P(X ≤ k) - At most k successes
            </div>

            <div class="mb-3">
              <label for="kCumulative" class="form-label">Number of Successes (k)</label>
              <input type="number" class="form-control" id="kCumulative" value="5" min="0" step="1">
            </div>
          </div>

          <!-- Range Probability -->
          <div class="tab-pane fade" id="range" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Range probability:</strong> P(a ≤ X ≤ b)
            </div>

            <div class="mb-3">
              <label for="kMin" class="form-label">Minimum Successes (a)</label>
              <input type="number" class="form-control" id="kMin" value="3" min="0" step="1">
            </div>

            <div class="mb-3">
              <label for="kMax" class="form-label">Maximum Successes (b)</label>
              <input type="number" class="form-control" id="kMax" value="7" min="0" step="1">
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
    <h3><i class="fas fa-graduation-cap"></i> Understanding Binomial Distribution</h3>

    <p>The <strong>binomial distribution</strong> models the number of successes in a fixed number of independent Bernoulli trials.</p>

    <h4>Requirements</h4>
    <ul>
      <li><strong>Fixed number of trials (n)</strong></li>
      <li><strong>Each trial has two outcomes:</strong> success or failure</li>
      <li><strong>Constant probability (p)</strong> of success on each trial</li>
      <li><strong>Trials are independent</strong></li>
    </ul>

    <h4>Probability Mass Function</h4>
    <div class="formula-box">
      P(X = k) = C(n,k) × p^k × (1-p)^(n-k)
    </div>
    <p>Where C(n,k) = n! / (k!(n-k)!) is the binomial coefficient</p>

    <h4>Parameters & Statistics</h4>
    <div class="formula-box">
      Mean (μ) = n × p
    </div>
    <div class="formula-box">
      Variance (σ²) = n × p × (1-p)
    </div>
    <div class="formula-box">
      Standard Deviation (σ) = √(n × p × (1-p))
    </div>

    <h4>Real-World Applications</h4>
    <ul>
      <li><strong>Quality Control:</strong> Number of defective items in sample</li>
      <li><strong>Medicine:</strong> Number of patients responding to treatment</li>
      <li><strong>Marketing:</strong> Number of customers making a purchase</li>
      <li><strong>Gambling:</strong> Number of wins in coin flips or dice rolls</li>
      <li><strong>Surveys:</strong> Number of "yes" responses</li>
      <li><strong>Genetics:</strong> Number of offspring with trait</li>
    </ul>

    <h4>Examples</h4>
    <p><strong>Example 1:</strong> Flip a fair coin 10 times. What's the probability of getting exactly 6 heads?</p>
    <p>Solution: n=10, p=0.5, k=6 → P(X=6) = C(10,6) × 0.5^6 × 0.5^4 = 0.2051</p>

    <p><strong>Example 2:</strong> 20% of students prefer online learning. In a class of 30, what's the probability that at most 5 prefer online?</p>
    <p>Solution: n=30, p=0.2, P(X≤5) = cumulative probability</p>

    <h4>Normal Approximation</h4>
    <p>When n is large and p is not too close to 0 or 1, the binomial distribution can be approximated by a normal distribution:</p>
    <div class="formula-box">
      X ~ N(np, np(1-p))
    </div>
    <p><strong>Rule of thumb:</strong> Use when np ≥ 5 and n(1-p) ≥ 5</p>

    <div class="info-box">
      <i class="fas fa-lightbulb"></i>
      <strong>Tip:</strong> The binomial distribution is discrete (counts), unlike the normal distribution which is continuous. As n increases and p stays moderate, the binomial approaches normal.
    </div>
  </div>
</div>

<%@ include file="thanks.jsp"%>

<%@ include file="footer_adsense.jsp"%>
  <%@ include file="addcomments.jsp"%>
  <!-- FAQ: inline -->
  <section id="faq" class="mt-5">
    <h2 class="h5">Binomial Distribution: FAQ</h2>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">When is the binomial model appropriate?</h3>
      <p class="mb-0">Use when there are n independent trials, each with two outcomes (success/failure) and constant success probability p.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">What are mean and variance?</h3>
      <p class="mb-0">Mean = n·p, variance = n·p·(1−p), SD = √(n·p·(1−p)).</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">Normal approximation conditions?</h3>
      <p class="mb-0">When n·p ≥ 10 and n·(1−p) ≥ 10, a normal approximation with continuity correction is often reasonable.</p>
    </div></div>
    <div class="card mb-3"><div class="card-body">
      <h3 class="h6">PMF vs CDF?</h3>
      <p class="mb-0">PMF gives P(X=k); CDF gives cumulative P(X≤k). Use CDF for ranges and tail probabilities.</p>
    </div></div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"When is the binomial model appropriate?","acceptedAnswer":{"@type":"Answer","text":"n independent trials, binary outcomes, constant success probability p."}},
      {"@type":"Question","name":"What are mean and variance?","acceptedAnswer":{"@type":"Answer","text":"Mean=n·p, variance=n·p·(1−p), SD=√(n·p·(1−p))."}},
      {"@type":"Question","name":"Normal approximation conditions?","acceptedAnswer":{"@type":"Answer","text":"Use normal approx with continuity correction when n·p and n·(1−p) ≥ 10."}},
      {"@type":"Question","name":"PMF vs CDF?","acceptedAnswer":{"@type":"Answer","text":"PMF P(X=k); CDF P(X≤k). Use CDF for ranges/tails."}}
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
      {"@type":"ListItem","position":2,"name":"Binomial Distribution Calculator","item":"https://8gwifi.org/binomial-distribution-calculator.jsp"}
    ]
  }
  </script>
</div>

<%@ include file="body-close.jsp"%>

<script>
  let binomialChart = null;

  function binomialCoeff(n, k) {
    if (k > n) return 0;
    if (k === 0 || k === n) return 1;

    let result = 1;
    for (let i = 0; i < k; i++) {
      result *= (n - i) / (i + 1);
    }
    return result;
  }

  function binomialPMF(n, p, k) {
    return binomialCoeff(n, k) * Math.pow(p, k) * Math.pow(1 - p, n - k);
  }

  function binomialCDF(n, p, k) {
    let sum = 0;
    for (let i = 0; i <= k; i++) {
      sum += binomialPMF(n, p, i);
    }
    return sum;
  }

  function calculate() {
    const n = parseInt(document.getElementById('n').value);
    const p = parseFloat(document.getElementById('p').value);

    if (isNaN(n) || n < 1 || isNaN(p) || p < 0 || p > 1) {
      alert('Invalid parameters');
      return;
    }

    const activeTab = document.querySelector('#calcTabs .nav-link.active').id;

    const mean = n * p;
    const variance = n * p * (1 - p);
    const stdDev = Math.sqrt(variance);

    if (activeTab === 'exact-tab') {
      const k = parseInt(document.getElementById('kExact').value);
      if (isNaN(k) || k < 0 || k > n) {
        alert(`k must be between 0 and ${n}`);
        return;
      }

      const prob = binomialPMF(n, p, k);

      displayResults({
        type: 'exact',
        n: n,
        p: p,
        k: k,
        prob: prob,
        mean: mean,
        variance: variance,
        stdDev: stdDev
      });

      drawPMF(n, p, k, null, 'exact');
    } else if (activeTab === 'cumulative-tab') {
      const k = parseInt(document.getElementById('kCumulative').value);
      if (isNaN(k) || k < 0 || k > n) {
        alert(`k must be between 0 and ${n}`);
        return;
      }

      const prob = binomialCDF(n, p, k);

      displayResults({
        type: 'cumulative',
        n: n,
        p: p,
        k: k,
        prob: prob,
        mean: mean,
        variance: variance,
        stdDev: stdDev
      });

      drawPMF(n, p, k, null, 'cumulative');
    } else if (activeTab === 'range-tab') {
      const kMin = parseInt(document.getElementById('kMin').value);
      const kMax = parseInt(document.getElementById('kMax').value);

      if (isNaN(kMin) || isNaN(kMax) || kMin < 0 || kMax > n || kMin > kMax) {
        alert('Invalid range');
        return;
      }

      let prob = 0;
      for (let i = kMin; i <= kMax; i++) {
        prob += binomialPMF(n, p, i);
      }

      displayResults({
        type: 'range',
        n: n,
        p: p,
        kMin: kMin,
        kMax: kMax,
        prob: prob,
        mean: mean,
        variance: variance,
        stdDev: stdDev
      });

      drawPMF(n, p, kMin, kMax, 'range');
    }
  }

  function displayResults(results) {
    let html = `
      <div class="result-item">
        <div class="result-label">Parameters</div>
        <div style="font-size: 0.9rem; margin-top: 0.5rem;">
          <div>n = ${results.n}</div>
          <div>p = ${results.p.toFixed(4)}</div>
        </div>
      </div>

      <div class="result-item">
        <div class="result-label">Mean (μ)</div>
        <div class="result-value">${results.mean.toFixed(4)}</div>
      </div>

      <div class="result-item">
        <div class="result-label">Std Dev (σ)</div>
        <div class="result-value">${results.stdDev.toFixed(4)}</div>
      </div>
    `;

    if (results.type === 'exact') {
      html += `
        <div class="result-item">
          <div class="result-label">P(X = ${results.k})</div>
          <div class="result-value">${results.prob.toFixed(6)}</div>
          <div class="interpretation">
            Probability of exactly ${results.k} success${results.k !== 1 ? 'es' : ''} in ${results.n} trials
          </div>
        </div>
      `;
    } else if (results.type === 'cumulative') {
      html += `
        <div class="result-item">
          <div class="result-label">P(X ≤ ${results.k})</div>
          <div class="result-value">${results.prob.toFixed(6)}</div>
          <div class="interpretation">
            Probability of at most ${results.k} success${results.k !== 1 ? 'es' : ''} in ${results.n} trials
          </div>
        </div>
      `;
    } else if (results.type === 'range') {
      html += `
        <div class="result-item">
          <div class="result-label">P(${results.kMin} ≤ X ≤ ${results.kMax})</div>
          <div class="result-value">${results.prob.toFixed(6)}</div>
          <div class="interpretation">
            Probability of ${results.kMin} to ${results.kMax} successes in ${results.n} trials
          </div>
        </div>
      `;
    }

    document.getElementById('resultsContent').innerHTML = html;
  }

  function drawPMF(n, p, k1, k2, type) {
    const container = document.getElementById('resultsContent');

    let canvas = document.getElementById('binomialPMF');
    if (!canvas) {
      const chartHtml = `
        <div class="chart-container">
          <h5 style="color: var(--primary-color); margin-bottom: 1rem; font-size: 0.95rem;">
            <i class="fas fa-chart-bar"></i> Probability Mass Function
          </h5>
          <canvas id="binomialPMF"></canvas>
        </div>
      `;
      container.insertAdjacentHTML('beforeend', chartHtml);
      canvas = document.getElementById('binomialPMF');
    }

    if (binomialChart) {
      binomialChart.destroy();
    }

    const labels = [];
    const probs = [];
    const colors = [];

    for (let k = 0; k <= n; k++) {
      labels.push(k);
      const prob = binomialPMF(n, p, k);
      probs.push(prob);

      if (type === 'exact' && k === k1) {
        colors.push('rgba(99, 102, 241, 0.8)');
      } else if (type === 'cumulative' && k <= k1) {
        colors.push('rgba(99, 102, 241, 0.8)');
      } else if (type === 'range' && k >= k1 && k <= k2) {
        colors.push('rgba(99, 102, 241, 0.8)');
      } else {
        colors.push('rgba(156, 163, 175, 0.3)');
      }
    }

    binomialChart = new Chart(canvas, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'P(X = k)',
          data: probs,
          backgroundColor: colors,
          borderColor: colors.map(c => c.replace('0.8', '1').replace('0.3', '0.5')),
          borderWidth: 1
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
            text: `Binomial Distribution (n=${n}, p=${p.toFixed(2)})`,
            font: { size: 11, weight: 'bold' }
          }
        },
        scales: {
          x: {
            title: { display: true, text: 'Number of Successes (k)', font: { size: 10, weight: 'bold' } },
            ticks: { font: { size: 9 } }
          },
          y: {
            title: { display: true, text: 'Probability', font: { size: 10, weight: 'bold' } },
            ticks: { font: { size: 9 } }
          }
        }
      }
    });
  }
</script>
