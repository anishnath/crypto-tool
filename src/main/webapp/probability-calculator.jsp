<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Probability Calculator - Bayes' Theorem, AND, OR, Conditional Probability | Free Tool</title>
<meta name="description" content="Free online Probability Calculator. Calculate basic probabilities, conditional probability, Bayes' theorem, AND/OR probability, and multiple event probabilities with step-by-step solutions.">
<meta name="keywords" content="probability calculator, bayes theorem calculator, conditional probability, probability of events, AND OR probability, independent events, probability rules">
<link rel="canonical" href="https://8gwifi.org/probability-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Probability Calculator - Statistical Tool">
<meta property="og:description" content="Calculate probabilities using Bayes' theorem, conditional probability, AND/OR rules with detailed explanations.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/probability-calculator.jsp">
<meta property="og:image" content="https://8gwifi.org/images/probability-calculator.png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Probability Calculator">
<meta name="twitter:description" content="Calculate basic and conditional probabilities with Bayes' theorem.">
<meta name="twitter:image" content="https://8gwifi.org/images/probability-calculator.png">

<%@ include file="header-script.jsp"%>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Probability Calculator",
  "url": "https://8gwifi.org/probability-calculator.jsp",
  "description": "Comprehensive Probability Calculator for basic probability, conditional probability, Bayes' theorem, AND/OR probability rules, and multiple event calculations.",
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "browserRequirements": "Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Basic probability, Conditional probability, Bayes' theorem, AND probability, OR probability, NOT probability, Independent events, Mutually exclusive events, Complement rule, Multiple event probability",
  "screenshot": "https://8gwifi.org/images/probability-calculator.png",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "2150"
  }
}
</script>

<style>
  :root {
    --primary-color: #f97316;
    --primary-dark: #ea580c;
    --primary-light: #fb923c;
    --bg-light: #fff7ed;
    --border-color: #fed7aa;
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
    box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
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
    box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3);
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
    background: #ffedd5;
    border-left: 4px solid #f97316;
    padding: 0.75rem;
    border-radius: 4px;
    font-size: 0.85rem;
    margin-top: 0.5rem;
    color: #7c2d12;
  }

  .formula-display {
    background: var(--bg-light);
    border: 2px solid var(--border-color);
    padding: 1rem;
    border-radius: 8px;
    font-family: 'Courier New', monospace;
    font-size: 1rem;
    margin: 1rem 0;
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
  <h1>Probability Calculator</h1>
  <p class="text-muted">Calculate probabilities using basic rules, conditional probability, and Bayes' theorem</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row mt-4">
    <!-- Left Column: Input -->
    <div class="col-lg-7">
      <div class="calculator-section">
        <h2 class="section-title"><i class="fas fa-dice"></i> Calculation Type</h2>

        <!-- Calculation Type Tabs -->
        <ul class="nav nav-tabs mb-3" id="calcTabs" role="tablist">
          <li class="nav-item">
            <a class="nav-link active" id="basic-tab" data-toggle="tab" href="#basic" role="tab">Basic</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="conditional-tab" data-toggle="tab" href="#conditional" role="tab">Conditional</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="bayes-tab" data-toggle="tab" href="#bayes" role="tab">Bayes' Theorem</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="multiple-tab" data-toggle="tab" href="#multiple" role="tab">Multiple Events</a>
          </li>
        </ul>

        <div class="tab-content" id="calcTabContent">
          <!-- Basic Probability -->
          <div class="tab-pane fade show active" id="basic" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Basic Probability:</strong> P(A) = Favorable Outcomes / Total Outcomes
            </div>

            <div class="mb-3">
              <label for="basicFavorable" class="form-label">Number of Favorable Outcomes</label>
              <input type="number" class="form-control" id="basicFavorable" value="3" step="1" min="0">
            </div>

            <div class="mb-3">
              <label for="basicTotal" class="form-label">Total Number of Outcomes</label>
              <input type="number" class="form-control" id="basicTotal" value="6" step="1" min="1">
            </div>
          </div>

          <!-- Conditional Probability -->
          <div class="tab-pane fade" id="conditional" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Conditional Probability:</strong> P(A|B) - Probability of A given B has occurred
            </div>

            <div class="mb-3">
              <label for="condAandB" class="form-label">P(A AND B) - Joint Probability</label>
              <input type="number" class="form-control" id="condAandB" value="0.15" step="0.01" min="0" max="1">
            </div>

            <div class="mb-3">
              <label for="condB" class="form-label">P(B) - Probability of B</label>
              <input type="number" class="form-control" id="condB" value="0.30" step="0.01" min="0.001" max="1">
            </div>
          </div>

          <!-- Bayes' Theorem -->
          <div class="tab-pane fade" id="bayes" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Bayes' Theorem:</strong> Update probability based on new evidence
            </div>

            <div class="mb-3">
              <label for="bayesPriorA" class="form-label">P(A) - Prior Probability</label>
              <input type="number" class="form-control" id="bayesPriorA" value="0.01" step="0.01" min="0" max="1">
              <small class="text-muted">Initial probability of event A</small>
            </div>

            <div class="mb-3">
              <label for="bayesBgivenA" class="form-label">P(B|A) - Likelihood</label>
              <input type="number" class="form-control" id="bayesBgivenA" value="0.90" step="0.01" min="0" max="1">
              <small class="text-muted">Probability of evidence B given A is true</small>
            </div>

            <div class="mb-3">
              <label for="bayesPriorNotA" class="form-label">P(¬A) - Prior Probability of NOT A</label>
              <input type="number" class="form-control" id="bayesPriorNotA" value="0.99" step="0.01" min="0" max="1">
            </div>

            <div class="mb-3">
              <label for="bayesBgivenNotA" class="form-label">P(B|¬A) - False Positive Rate</label>
              <input type="number" class="form-control" id="bayesBgivenNotA" value="0.05" step="0.01" min="0" max="1">
              <small class="text-muted">Probability of evidence B given A is false</small>
            </div>
          </div>

          <!-- Multiple Events -->
          <div class="tab-pane fade" id="multiple" role="tabpanel">
            <div class="info-box">
              <i class="fas fa-info-circle"></i>
              <strong>Multiple Events:</strong> AND, OR, NOT operations
            </div>

            <div class="mb-3">
              <label for="multiPA" class="form-label">P(A) - Probability of Event A</label>
              <input type="number" class="form-control" id="multiPA" value="0.60" step="0.01" min="0" max="1">
            </div>

            <div class="mb-3">
              <label for="multiPB" class="form-label">P(B) - Probability of Event B</label>
              <input type="number" class="form-control" id="multiPB" value="0.40" step="0.01" min="0" max="1">
            </div>

            <div class="mb-3">
              <label class="form-label">Events Relationship</label>
              <select class="form-control" id="multiRelation">
                <option value="independent" selected>Independent (unrelated)</option>
                <option value="mutually-exclusive">Mutually Exclusive (can't both occur)</option>
              </select>
            </div>

            <div class="mb-3" id="multiPAandBDiv" style="display: none;">
              <label for="multiPAandB" class="form-label">P(A AND B) - Joint Probability</label>
              <input type="number" class="form-control" id="multiPAandB" value="0.24" step="0.01" min="0" max="1">
              <small class="text-muted">Only needed if events are not independent</small>
            </div>
          </div>
        </div>

        <button class="btn btn-calculate mt-3" onclick="calculate()">
          <i class="fas fa-calculator"></i> Calculate Probability
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
            <p class="mt-2">Select calculation type and enter values</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Educational Content -->
  <div class="educational-section">
    <h3><i class="fas fa-graduation-cap"></i> Understanding Probability</h3>

    <p><strong>Probability</strong> measures the likelihood of an event occurring, expressed as a value between 0 (impossible) and 1 (certain), or 0% to 100%.</p>

    <h4>Basic Probability Rules</h4>

    <h5>1. Basic Probability</h5>
    <div class="formula-box">
      P(A) = Number of Favorable Outcomes / Total Number of Outcomes
    </div>
    <p><strong>Example:</strong> Rolling a die, P(rolling a 3) = 1/6 ≈ 0.167 or 16.7%</p>

    <h5>2. Complement Rule</h5>
    <div class="formula-box">
      P(NOT A) = P(¬A) = 1 - P(A)
    </div>
    <p>The probability an event doesn't occur is 1 minus the probability it does occur.</p>

    <h5>3. Addition Rule (OR)</h5>
    <div class="formula-box">
      P(A OR B) = P(A) + P(B) - P(A AND B)
    </div>
    <p><strong>For mutually exclusive events:</strong> P(A OR B) = P(A) + P(B)</p>
    <p><strong>Example:</strong> Drawing a heart OR a king from a deck</p>

    <h5>4. Multiplication Rule (AND)</h5>
    <div class="formula-box">
      P(A AND B) = P(A) × P(B|A)
    </div>
    <p><strong>For independent events:</strong> P(A AND B) = P(A) × P(B)</p>
    <p><strong>Example:</strong> Flipping heads AND rolling a 6</p>

    <h4>Conditional Probability</h4>
    <p>The probability of event A given that event B has occurred:</p>
    <div class="formula-box">
      P(A|B) = P(A AND B) / P(B)
    </div>
    <p><strong>Example:</strong> Probability of rain given cloudy sky</p>

    <h4>Bayes' Theorem</h4>
    <p>Update probabilities based on new evidence:</p>
    <div class="formula-box">
      P(A|B) = [P(B|A) × P(A)] / P(B)
    </div>
    <p>Where:</p>
    <ul>
      <li><strong>P(A|B):</strong> Posterior probability (what we want to find)</li>
      <li><strong>P(B|A):</strong> Likelihood (probability of evidence given hypothesis)</li>
      <li><strong>P(A):</strong> Prior probability (initial belief)</li>
      <li><strong>P(B):</strong> Marginal probability of evidence</li>
    </ul>

    <p><strong>Full Bayes' Formula:</strong></p>
    <div class="formula-box">
      P(A|B) = [P(B|A) × P(A)] / [P(B|A) × P(A) + P(B|¬A) × P(¬A)]
    </div>

    <h4>Key Concepts</h4>

    <div class="example-table">
      <table class="table">
        <thead>
          <tr>
            <th>Concept</th>
            <th>Definition</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>Independent Events</strong></td>
            <td>One event doesn't affect the other: P(A AND B) = P(A) × P(B)</td>
          </tr>
          <tr>
            <td><strong>Mutually Exclusive</strong></td>
            <td>Events cannot both occur: P(A AND B) = 0</td>
          </tr>
          <tr>
            <td><strong>Exhaustive Events</strong></td>
            <td>Cover all possibilities: P(A₁) + P(A₂) + ... = 1</td>
          </tr>
          <tr>
            <td><strong>Joint Probability</strong></td>
            <td>Both events occur: P(A AND B)</td>
          </tr>
        </tbody>
      </table>
    </div>

    <h4>Real-World Applications</h4>

    <h5>Medical Testing (Bayes' Theorem)</h5>
    <p><strong>Problem:</strong> Disease affects 1% of population. Test is 90% accurate (sensitivity). False positive rate is 5%.</p>
    <p><strong>Question:</strong> If you test positive, what's the probability you have the disease?</p>
    <p><strong>Solution:</strong> P(Disease|Positive) = (0.90 × 0.01) / [(0.90 × 0.01) + (0.05 × 0.99)] ≈ 0.154 or 15.4%</p>

    <h5>Other Applications</h5>
    <ul>
      <li><strong>Weather Forecasting:</strong> Probability of rain given cloud conditions</li>
      <li><strong>Spam Filtering:</strong> Probability email is spam given certain words</li>
      <li><strong>Quality Control:</strong> Probability of defect given inspection results</li>
      <li><strong>Sports:</strong> Win probabilities based on current score/time</li>
      <li><strong>Insurance:</strong> Risk assessment and premium calculation</li>
      <li><strong>Machine Learning:</strong> Classification and prediction algorithms</li>
    </ul>

    <h4>Common Probability Distributions</h4>
    <ul>
      <li><strong>Uniform:</strong> All outcomes equally likely (fair die)</li>
      <li><strong>Binomial:</strong> Number of successes in fixed trials</li>
      <li><strong>Normal:</strong> Bell curve, continuous outcomes</li>
      <li><strong>Poisson:</strong> Count of events in fixed interval</li>
    </ul>

    <div class="info-box">
      <i class="fas fa-lightbulb"></i>
      <strong>Tip:</strong> Always check if events are independent before using multiplication rule. Independence means P(A|B) = P(A), i.e., knowing B doesn't change probability of A.
    </div>
  </div>
</div>

<%@ include file="thanks.jsp"%>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>

<%@ include file="body-close.jsp"%>

<script>
  // Show/hide joint probability field based on relationship
  document.getElementById('multiRelation').addEventListener('change', function() {
    const div = document.getElementById('multiPAandBDiv');
    if (this.value === 'dependent') {
      div.style.display = 'block';
    } else {
      div.style.display = 'none';
    }
  });

  function calculate() {
    const activeTab = document.querySelector('#calcTabs .nav-link.active').id;

    try {
      if (activeTab === 'basic-tab') {
        calculateBasic();
      } else if (activeTab === 'conditional-tab') {
        calculateConditional();
      } else if (activeTab === 'bayes-tab') {
        calculateBayes();
      } else if (activeTab === 'multiple-tab') {
        calculateMultiple();
      }
    } catch (error) {
      alert('Error: ' + error.message);
    }
  }

  function calculateBasic() {
    const favorable = parseInt(document.getElementById('basicFavorable').value);
    const total = parseInt(document.getElementById('basicTotal').value);

    if (isNaN(favorable) || isNaN(total) || favorable < 0 || total < 1 || favorable > total) {
      throw new Error('Invalid input: favorable outcomes must be ≤ total outcomes');
    }

    const prob = favorable / total;
    const complement = 1 - prob;

    displayResults({
      type: 'Basic Probability',
      probability: prob,
      formula: `P(A) = ${favorable} / ${total}`,
      complement: complement,
      interpretation: `The probability of the event occurring is ${(prob * 100).toFixed(2)}%. The probability it does NOT occur is ${(complement * 100).toFixed(2)}%.`
    });
  }

  function calculateConditional() {
    const pAandB = parseFloat(document.getElementById('condAandB').value);
    const pB = parseFloat(document.getElementById('condB').value);

    if (isNaN(pAandB) || isNaN(pB) || pAandB < 0 || pAandB > 1 || pB <= 0 || pB > 1 || pAandB > pB) {
      throw new Error('Invalid probabilities (must be 0-1, and P(A AND B) ≤ P(B))');
    }

    const pAgivenB = pAandB / pB;

    displayResults({
      type: 'Conditional Probability',
      probability: pAgivenB,
      formula: `P(A|B) = P(A AND B) / P(B) = ${pAandB.toFixed(4)} / ${pB.toFixed(4)}`,
      interpretation: `Given that event B has occurred, the probability of event A is ${(pAgivenB * 100).toFixed(2)}%. This is ${pAgivenB > pB ? 'higher' : pAgivenB < pB ? 'lower' : 'the same as'} the marginal probability of A.`
    });
  }

  function calculateBayes() {
    const pA = parseFloat(document.getElementById('bayesPriorA').value);
    const pBgivenA = parseFloat(document.getElementById('bayesBgivenA').value);
    const pNotA = parseFloat(document.getElementById('bayesPriorNotA').value);
    const pBgivenNotA = parseFloat(document.getElementById('bayesBgivenNotA').value);

    if (isNaN(pA) || isNaN(pBgivenA) || isNaN(pNotA) || isNaN(pBgivenNotA) ||
        pA < 0 || pA > 1 || pBgivenA < 0 || pBgivenA > 1 ||
        pNotA < 0 || pNotA > 1 || pBgivenNotA < 0 || pBgivenNotA > 1) {
      throw new Error('All probabilities must be between 0 and 1');
    }

    // Calculate marginal probability P(B)
    const pB = (pBgivenA * pA) + (pBgivenNotA * pNotA);

    // Bayes' theorem
    const pAgivenB = (pBgivenA * pA) / pB;

    const formula = `P(A|B) = [P(B|A) × P(A)] / P(B)
  = [${pBgivenA.toFixed(4)} × ${pA.toFixed(4)}] / ${pB.toFixed(4)}`;

    let interp = `Given the evidence B, the posterior probability of A is ${(pAgivenB * 100).toFixed(2)}%. `;
    interp += `This ${pAgivenB > pA ? 'increased' : pAgivenB < pA ? 'decreased' : 'remained the same'} from the prior probability of ${(pA * 100).toFixed(2)}%.`;

    displayResults({
      type: "Bayes' Theorem",
      probability: pAgivenB,
      formula: formula,
      priorProb: pA,
      posteriorProb: pAgivenB,
      marginalB: pB,
      interpretation: interp
    });
  }

  function calculateMultiple() {
    const pA = parseFloat(document.getElementById('multiPA').value);
    const pB = parseFloat(document.getElementById('multiPB').value);
    const relation = document.getElementById('multiRelation').value;

    if (isNaN(pA) || isNaN(pB) || pA < 0 || pA > 1 || pB < 0 || pB > 1) {
      throw new Error('Probabilities must be between 0 and 1');
    }

    let pAandB, pAorB;

    if (relation === 'independent') {
      pAandB = pA * pB;
      pAorB = pA + pB - pAandB;
    } else if (relation === 'mutually-exclusive') {
      pAandB = 0;
      pAorB = pA + pB;
    }

    const pNotA = 1 - pA;
    const pNotB = 1 - pB;
    const pNotAorNotB = 1 - pAandB; // De Morgan's law

    displayResults({
      type: 'Multiple Events',
      pA: pA,
      pB: pB,
      pAandB: pAandB,
      pAorB: pAorB,
      pNotA: pNotA,
      pNotB: pNotB,
      relation: relation,
      interpretation: `P(A AND B) = ${(pAandB * 100).toFixed(2)}%, P(A OR B) = ${(pAorB * 100).toFixed(2)}%. Events are ${relation === 'independent' ? 'independent' : 'mutually exclusive'}.`
    });
  }

  function displayResults(results) {
    let html = `
      <div class="result-item">
        <div class="result-label">${results.type}</div>
      </div>
    `;

    if (results.formula) {
      html += `
        <div class="formula-display">
          ${results.formula.replace(/\n/g, '<br>')}
        </div>
      `;
    }

    if (results.probability !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Probability</div>
          <div class="result-value">${results.probability.toFixed(6)}</div>
          <div style="font-size: 0.9rem; margin-top: 0.5rem;">
            <strong>${(results.probability * 100).toFixed(2)}%</strong> or <strong>${results.probability.toFixed(4)}</strong>
          </div>
        </div>
      `;
    }

    if (results.complement !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Complement P(NOT A)</div>
          <div class="result-value">${results.complement.toFixed(6)}</div>
          <div style="font-size: 0.9rem; margin-top: 0.5rem;">
            <strong>${(results.complement * 100).toFixed(2)}%</strong>
          </div>
        </div>
      `;
    }

    if (results.priorProb !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Prior → Posterior</div>
          <div style="font-size: 1rem; margin-top: 0.5rem;">
            <div>Prior P(A): <strong>${(results.priorProb * 100).toFixed(2)}%</strong></div>
            <div style="margin: 0.5rem 0; font-size: 1.5rem; color: var(--primary-color);">↓</div>
            <div>Posterior P(A|B): <strong>${(results.posteriorProb * 100).toFixed(2)}%</strong></div>
          </div>
        </div>
      `;
    }

    if (results.pA !== undefined) {
      html += `
        <div class="result-item">
          <div class="result-label">Calculated Probabilities</div>
          <div style="font-size: 0.9rem; margin-top: 0.5rem;">
            <div>P(A) = <strong>${(results.pA * 100).toFixed(2)}%</strong></div>
            <div>P(B) = <strong>${(results.pB * 100).toFixed(2)}%</strong></div>
            <div>P(A AND B) = <strong>${(results.pAandB * 100).toFixed(2)}%</strong></div>
            <div>P(A OR B) = <strong>${(results.pAorB * 100).toFixed(2)}%</strong></div>
            <div>P(NOT A) = <strong>${(results.pNotA * 100).toFixed(2)}%</strong></div>
            <div>P(NOT B) = <strong>${(results.pNotB * 100).toFixed(2)}%</strong></div>
          </div>
        </div>
      `;
    }

    if (results.interpretation) {
      html += `
        <div class="result-item">
          <div class="result-label">Interpretation</div>
          <div class="interpretation">
            ${results.interpretation}
          </div>
        </div>
      `;
    }

    document.getElementById('resultsContent').innerHTML = html;
  }
</script>
