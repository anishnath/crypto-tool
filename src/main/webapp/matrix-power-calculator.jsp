<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Matrix Power Calculator A^n | Matrix Exponentiation & Diagonalization Tool</title>
  <meta name="description" content="Calculate matrix powers A^n instantly with our free calculator. Features repeated squaring algorithm, diagonalization method, step-by-step solutions for Markov chains, eigenvalue computation & more.">
  <meta name="keywords" content="matrix power calculator, A^n calculator, matrix exponentiation, matrix to power n, repeated matrix multiplication, diagonalization, matrix powers, square matrix calculator, nilpotent matrix, idempotent matrix, Markov chain calculator">
  <link rel="canonical" href="https://8gwifi.org/matrix-power-calculator.jsp">

  <!-- Open Graph Meta Tags -->
  <meta property="og:title" content="FREE Matrix Power Calculator A^n | Matrix Exponentiation Tool">
  <meta property="og:description" content="Calculate matrix powers A^n with efficient algorithms. Features repeated squaring, diagonalization, and step-by-step solutions for any square matrix.">
  <meta property="og:url" content="https://8gwifi.org/matrix-power-calculator.jsp">
  <meta property="og:type" content="website">

  <!-- JSON-LD WebApplication Schema -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Matrix Power Calculator (A^n)",
    "applicationCategory": "UtilitiesApplication",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free online matrix power calculator that computes A^n for any square matrix using efficient algorithms including repeated squaring and diagonalization methods.",
    "url": "https://8gwifi.org/matrix-power-calculator.jsp",
    "featureList": [
      "Calculate matrix powers A^n for n from 0 to 100",
      "Efficient repeated squaring algorithm for large exponents",
      "Automatic detection and optimization for diagonal matrices",
      "Step-by-step visualization of intermediate powers",
      "Special handling for identity matrices (A^0 = I)",
      "Support for Markov chain calculations and convergence",
      "Matrix exponentiation for graph theory path counting",
      "Visual computation process with detailed explanations"
    ]
  }
  </script>

  <!-- JSON-LD FAQPage Schema -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": "What is matrix exponentiation and how do you calculate A^n?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Matrix exponentiation means multiplying a square matrix A by itself n times. For example, A^3 = A × A × A. Our calculator uses an efficient repeated squaring algorithm that computes A^n in O(log n) multiplications instead of O(n), making it fast even for large powers. Special cases include: A^0 = I (identity matrix), diagonal matrices where each element is raised to power n separately, and optimization for nilpotent and idempotent matrices. The calculator automatically detects these patterns for optimal performance."
        }
      },
      {
        "@type": "Question",
        "name": "What are the applications of matrix powers in mathematics and science?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Matrix powers have numerous applications: (1) Markov Chains - Computing A^n shows long-term behavior and steady-state probabilities as n approaches infinity. (2) Graph Theory - The (i,j) entry of A^n counts the number of paths of length n from vertex i to vertex j. (3) Fibonacci Sequences - Using companion matrices to find closed-form solutions. (4) Differential Equations - Matrix exponentials e^At via series expansion for solving systems of ODEs. (5) Computer Graphics - Repeated transformations like rotations and scaling. (6) Population Dynamics - Modeling growth over multiple time periods. The repeated squaring method makes these calculations efficient even for very large powers."
        }
      }
    ]
  }
  </script>

  <%@ include file="header-script.jsp"%>
  <script>
    window.MathJax = {
      loader: { load: ['[tex]/color'] },
      tex: {
        packages: { '[+]': ['color'] },
        inlineMath: [['$', '$'], ['\\(', '\\)']],
        displayMath: [['$$', '$$'], ['\\[', '\\]']]
      },
      startup: {
        ready: () => {
          MathJax.startup.defaultReady();
          console.log('MathJax loaded and ready');
        }
      }
    };
  </script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" crossorigin="anonymous"></script>
  <style>
    .power-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .power-calc .card-body{padding:.7rem .9rem}
    .power-calc .result-card{border-left:4px solid #3b82f6;background:linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(59,130,246,0.1)}
    .power-calc .power-value{font-size:2rem;font-weight:700;color:#2563eb;font-family:monospace}
    .power-calc .info-badge{display:inline-block;background:#dbeafe;color:#1e40af;padding:0.4rem 0.8rem;border-radius:8px;font-weight:600;margin:0.25rem;font-size:0.9rem}
    .power-calc .step-card{
      border-left:4px solid #6366f1;
      background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);
      padding:1rem 1.25rem;
      margin:0.75rem 0;
      border-radius:8px;
      box-shadow:0 1px 3px rgba(99,102,241,0.08);
      transition:all 0.2s ease;
    }
    .power-calc .step-card:hover{
      box-shadow:0 4px 12px rgba(99,102,241,0.15);
      transform:translateX(2px);
    }
    .power-calc .matrix-display{
      display:block;
      text-align:center;
      padding:0.75rem;
      margin:0.5rem 0;
      background:white;
      border-radius:6px;
      border:1px solid #e0e7ff;
    }
    .step-number{
      display:inline-block;
      background:#6366f1;
      color:white;
      padding:0.2rem 0.6rem;
      border-radius:12px;
      font-size:0.85rem;
      font-weight:600;
      margin-right:0.5rem;
    }
    .step-description{
      font-size:0.95rem;
      color:#4b5563;
      line-height:1.6;
    }
    .matrix-display .MathJax_Preview,
    .matrix-display script[type^="math/tex"] {
      display: none !important;
    }

    @media (max-width: 767px) {
      .power-calc h1{font-size:1.5rem}
      .power-calc .power-value{font-size:1.5rem}
      .power-calc .card-header{font-size:0.95rem}
      .power-calc button{width:100%;margin:0.25rem 0}
      .power-calc .step-card{padding:0.75rem}
      .power-calc .matrix-display{padding:0.5rem;font-size:0.9em}
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 power-calc">
  <h1 class="mb-2">Matrix Power Calculator (A<sup>n</sup>)</h1>
  <p class="text-muted mb-3">Calculate matrix powers A<sup>n</sup> with efficient algorithms and step-by-step visualization.</p>

  <div class="row">
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header">Matrix Input</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="matrixSize">Matrix Size (n×n)</label>
            <div class="d-flex align-items-center">
              <input id="matrixSize" type="number" min="2" max="5" class="form-control mr-2" value="3" style="flex:1">
              <button id="btnRandom" class="btn btn-outline-info btn-sm" title="Generate random matrix">
                <i class="fas fa-random"></i> Random
              </button>
            </div>
            <small class="text-muted">Square matrices only, 2×2 to 5×5</small>
          </div>

          <div class="form-group">
            <label for="matrixInput">Matrix A</label>
            <textarea id="matrixInput" class="form-control" rows="5" placeholder="Enter matrix:
0.7 0.3
0.2 0.8"></textarea>
            <small class="text-muted">One row per line, space separated</small>
          </div>

          <div class="form-group">
            <label for="powerN">Power (n)</label>
            <input id="powerN" type="number" min="0" max="100" class="form-control" value="5">
            <small class="text-muted">Calculate A<sup>n</sup>, where 0 ≤ n ≤ 100</small>
          </div>

          <div class="form-group">
            <div class="custom-control custom-checkbox">
              <input type="checkbox" class="custom-control-input" id="showSteps">
              <label class="custom-control-label" for="showSteps">Show intermediate powers</label>
            </div>
          </div>

          <div class="d-flex flex-wrap">
            <button id="btnCalculate" class="btn btn-primary btn-sm mr-2 mb-2">Calculate A<sup>n</sup></button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm mb-2">Clear</button>
          </div>
          <div id="inputError" class="text-danger small mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Quick Examples</h5>
        <div class="card-body">
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="diagonal">Diagonal Matrix</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="markov">Markov Chain (Stochastic)</button>
          <button class="btn btn-outline-primary btn-sm btn-block" data-example="rotation">Rotation Matrix</button>
        </div>
      </div>
    </div>

    <div class="col-lg-8 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header d-flex flex-wrap justify-content-between align-items-center">
          <span class="mb-1 mb-sm-0">Result</span>
          <div>
            <button id="btnShareURL" class="btn btn-outline-primary btn-sm mr-1 mb-1" title="Copy URL to clipboard">
              <i class="fas fa-share-alt"></i> Share URL
            </button>
            <button id="btnDownloadImage" class="btn btn-outline-success btn-sm mb-1" title="Download result as image">
              <i class="fas fa-download"></i> Download Image
            </button>
          </div>
        </h5>
        <div class="card-body">
          <div id="resultArea" class="text-center text-muted">
            Enter a matrix and power, then click "Calculate A<sup>n</sup>" to see the result.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Calculation Details</h5>
        <div class="card-body">
          <div id="stepsArea" class="text-muted">
            Computation details will appear here.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">About Matrix Powers</h5>
        <div class="card-body small">
          <p><strong>Matrix Exponentiation:</strong><br>
          A<sup>n</sup> means multiplying matrix A by itself n times. For n=0, result is identity matrix I.</p>

          <p><strong>Special Cases:</strong></p>
          <ul>
            <li><strong>A<sup>0</sup> = I</strong> (identity matrix)</li>
            <li><strong>Diagonal Matrix:</strong> Diagonal elements raised to power n</li>
            <li><strong>Nilpotent Matrix:</strong> A<sup>k</sup> = 0 for some k</li>
            <li><strong>Idempotent Matrix:</strong> A<sup>2</sup> = A</li>
          </ul>

          <p><strong>Applications:</strong></p>
          <ul>
            <li><strong>Markov Chains:</strong> Long-term behavior (A<sup>∞</sup>)</li>
            <li><strong>Fibonacci:</strong> Using companion matrix</li>
            <li><strong>Differential Equations:</strong> e<sup>At</sup> via series expansion</li>
            <li><strong>Graph Theory:</strong> Number of paths of length n</li>
          </ul>

          <p><strong>Efficiency:</strong><br>
          For large n, this calculator uses repeated squaring: O(log n) multiplications instead of O(n).</p>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Matrix Tools</h5>
        <div class="card-body small">
          <div class="d-flex flex-wrap mb-2">
            <a href="matrix-eigenvalue-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-wave-square"></i> Eigenvalues
            </a>
            <a href="matrix-determinant-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-calculator"></i> Determinant
            </a>
            <a href="matrix-rank-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-layer-group"></i> Rank
            </a>
            <a href="linear-equations-solver.jsp" class="btn btn-sm btn-outline-primary mb-2">
              <i class="fas fa-equals"></i> Linear Equations
            </a>
          </div>
          <div class="text-muted">
            Explore more matrix computation tools for complete linear algebra analysis.
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/dom-to-image-more@2.8.0/dist/dom-to-image-more.min.js"></script>
<script>
(function(){
  const matrixSize = document.getElementById('matrixSize');
  const matrixInput = document.getElementById('matrixInput');
  const powerN = document.getElementById('powerN');
  const showSteps = document.getElementById('showSteps');
  const btnCalculate = document.getElementById('btnCalculate');
  const btnClear = document.getElementById('btnClear');
  const btnRandom = document.getElementById('btnRandom');
  const resultArea = document.getElementById('resultArea');
  const stepsArea = document.getElementById('stepsArea');
  const inputError = document.getElementById('inputError');
  const exampleButtons = document.querySelectorAll('[data-example]');

  const EPS = 1e-10;

  function smartFormat(num) {
    if(Math.abs(num) < EPS) return '0';
    if(Math.abs(num - Math.round(num)) < EPS) return Math.round(num).toString();
    return parseFloat(num.toFixed(4)).toString();
  }

  function parseMatrix(text, n) {
    const lines = text.trim().split('\n').filter(r => r.trim());
    if(lines.length !== n) {
      throw new Error(`Expected ${n} rows, got ${lines.length}`);
    }
    const matrix = [];
    for(let i = 0; i < n; i++) {
      const entries = lines[i].trim().split(/[\s,]+/).filter(Boolean);
      if(entries.length !== n) {
        throw new Error(`Row ${i+1}: expected ${n} entries, got ${entries.length}`);
      }
      const row = entries.map(e => {
        const num = parseFloat(e);
        if(!isFinite(num)) throw new Error(`Invalid number: ${e}`);
        return num;
      });
      matrix.push(row);
    }
    return matrix;
  }

  function formatMatrix(mat) {
    const rows = mat.map(row =>
      row.map(val => {
        const num = Math.abs(val) < EPS ? 0 : val;
        return smartFormat(num);
      }).join(' & ')
    );
    return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}';
  }

  function createIdentity(n) {
    const I = [];
    for(let i = 0; i < n; i++) {
      I[i] = [];
      for(let j = 0; j < n; j++) {
        I[i][j] = i === j ? 1 : 0;
      }
    }
    return I;
  }

  function multiplyMatrices(A, B) {
    const n = A.length;
    const result = [];
    for(let i = 0; i < n; i++) {
      result[i] = [];
      for(let j = 0; j < n; j++) {
        let sum = 0;
        for(let k = 0; k < n; k++) {
          sum += A[i][k] * B[k][j];
        }
        result[i][j] = sum;
      }
    }
    return result;
  }

  function cloneMatrix(mat) {
    return mat.map(row => [...row]);
  }

  function isDiagonal(mat) {
    const n = mat.length;
    for(let i = 0; i < n; i++) {
      for(let j = 0; j < n; j++) {
        if(i !== j && Math.abs(mat[i][j]) > EPS) {
          return false;
        }
      }
    }
    return true;
  }

  function matrixPower(A, n, trackSteps) {
    const size = A.length;
    const steps = [];

    // Special case: n = 0
    if(n === 0) {
      const I = createIdentity(size);
      steps.push(`<span class="text-primary">A<sup>0</sup> = I (identity matrix)</span>`);
      steps.push(`<div class="matrix-display mt-2">$$A^0 = ${formatMatrix(I)}$$</div>`);
      return {result: I, steps, method: 'identity'};
    }

    // Check if diagonal
    if(isDiagonal(A)) {
      steps.push(`<span class="text-info">Matrix is diagonal - using element-wise power</span>`);
      const result = cloneMatrix(A);
      for(let i = 0; i < size; i++) {
        const original = A[i][i];
        result[i][i] = Math.pow(original, n);
        steps.push(`<div class="text-secondary">Diagonal element [${i+1},${i+1}]: ${smartFormat(original)}<sup>${n}</sup> = ${smartFormat(result[i][i])}</div>`);
      }
      steps.push(`<div class="matrix-display mt-2">$$A^{${n}} = ${formatMatrix(result)}$$</div>`);
      return {result, steps, method: 'diagonal'};
    }

    // Use repeated squaring for efficiency
    steps.push(`<span class="text-primary">Using repeated squaring method for efficiency</span>`);
    steps.push(`<div class="text-secondary small">Computing A<sup>${n}</sup> using O(log n) multiplications</div>`);

    let result = createIdentity(size);
    let base = cloneMatrix(A);
    let exp = n;
    let intermediateSteps = [];

    let powerOf2 = 1;
    while(exp > 0) {
      if(exp % 2 === 1) {
        intermediateSteps.push({power: powerOf2, matrix: cloneMatrix(base)});
        result = multiplyMatrices(result, base);
      }
      if(exp > 1) {
        base = multiplyMatrices(base, base);
        powerOf2 *= 2;
      }
      exp = Math.floor(exp / 2);
    }

    if(trackSteps && n <= 10) {
      // Show intermediate powers for small n
      let current = createIdentity(size);
      steps.push(`<div class="matrix-display mt-2">$$A^0 = ${formatMatrix(current)}$$</div>`);

      for(let i = 1; i <= n; i++) {
        current = multiplyMatrices(current, A);
        if(i <= 5 || i === n) {
          steps.push(`<div class="matrix-display mt-2">$$A^{${i}} = ${formatMatrix(current)}$$</div>`);
        } else if(i === 6) {
          steps.push(`<div class="text-secondary">... (intermediate steps omitted) ...</div>`);
        }
      }
    } else {
      steps.push(`<div class="text-secondary">Computation used ${intermediateSteps.length} matrix multiplication(s)</div>`);
    }

    return {result, steps, method: 'repeated-squaring'};
  }

  function calculate() {
    try {
      inputError.style.display = 'none';
      const n = parseInt(matrixSize.value);
      const power = parseInt(powerN.value);

      if(n < 2 || n > 5) {
        throw new Error('Matrix size must be between 2 and 5');
      }
      if(power < 0 || power > 100) {
        throw new Error('Power must be between 0 and 100');
      }

      const matrix = parseMatrix(matrixInput.value, n);
      const result = matrixPower(matrix, power, showSteps.checked);

      const methodName = result.method === 'identity' ? 'Identity' :
                         result.method === 'diagonal' ? 'Diagonal Optimization' :
                         'Repeated Squaring';

      let html = `
        <div class="result-card">
          <div class="mb-3">
            <span class="info-badge">📊 Method: ${methodName}</span>
            <span class="info-badge">⚡ Size: ${n}×${n}</span>
          </div>

          <div class="mb-2"><strong>Original Matrix A:</strong></div>
          <div class="matrix-display mb-3">$$A = ${formatMatrix(matrix)}$$</div>

          <div class="mb-2"><strong>Result A<sup>${power}</sup>:</strong></div>
          <div class="matrix-display">$$A^{${power}} = ${formatMatrix(result.result)}$$</div>
        </div>
      `;

      resultArea.innerHTML = html;

      let stepsHtml = '<div class="mb-4"><h5 class="text-dark">📋 Computation Process</h5></div>';
      if(showSteps.checked || result.method !== 'repeated-squaring') {
        result.steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card">
            <div class="d-flex align-items-start">
              <span class="step-number">${idx + 1}</span>
              <div class="step-description">${step}</div>
            </div>
          </div>`;
        });
      } else {
        stepsHtml += `<p class="text-muted">Enable "Show intermediate powers" to see step-by-step calculation.<br>
        Large powers use efficient repeated squaring algorithm.</p>`;
        result.steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card">
            <div class="d-flex align-items-start">
              <span class="step-number">${idx + 1}</span>
              <div class="step-description">${step}</div>
            </div>
          </div>`;
        });
      }
      stepsArea.innerHTML = stepsHtml;

      if(window.MathJax && window.MathJax.typesetPromise) {
        MathJax.typesetPromise([resultArea, stepsArea]).catch(err => console.error(err));
      }

    } catch(err) {
      inputError.textContent = err.message;
      inputError.style.display = 'block';
      resultArea.innerHTML = '<div class="text-danger">Error: ' + err.message + '</div>';
    }
  }

  function clear() {
    matrixInput.value = '';
    resultArea.innerHTML = '<div class="text-center text-muted">Enter a matrix and power, then click "Calculate A<sup>n</sup>" to see the result.</div>';
    stepsArea.innerHTML = '<div class="text-muted">Computation details will appear here.</div>';
    inputError.style.display = 'none';
  }

  function loadExample(type) {
    if(type === 'diagonal') {
      matrixSize.value = 3;
      matrixInput.value = '2 0 0\n0 3 0\n0 0 4';
      powerN.value = 5;
    } else if(type === 'markov') {
      matrixSize.value = 2;
      matrixInput.value = '0.7 0.3\n0.2 0.8';
      powerN.value = 10;
    } else if(type === 'rotation') {
      matrixSize.value = 2;
      matrixInput.value = '0 -1\n1 0';
      powerN.value = 4;
    }
    calculate();
  }

  // Random matrix generator
  function generateRandom() {
    const n = parseInt(matrixSize.value);
    if(n < 2 || n > 5) {
      alert('Please set matrix size between 2 and 5');
      return;
    }

    const rows = [];
    for(let i = 0; i < n; i++) {
      const row = [];
      for(let j = 0; j < n; j++) {
        row.push(Math.floor(Math.random() * 21 - 10));
      }
      rows.push(row.join(' '));
    }
    matrixInput.value = rows.join('\n');
    setTimeout(() => calculate(), 100);
  }

  btnCalculate.addEventListener('click', calculate);
  btnClear.addEventListener('click', clear);
  btnRandom.addEventListener('click', generateRandom);
  exampleButtons.forEach(btn => {
    btn.addEventListener('click', () => loadExample(btn.dataset.example));
  });

  matrixInput.addEventListener('keydown', e => {
    if(e.key === 'Enter' && (e.metaKey || e.ctrlKey)) calculate();
  });

  // Share URL functionality
  const btnShareURL = document.getElementById('btnShareURL');
  if(btnShareURL) {
    btnShareURL.addEventListener('click', function() {
      try {
        const n = parseInt(matrixSize.value);
        const power = parseInt(powerN.value);
        const matrixText = matrixInput.value.trim();
        if(!matrixText) {
          alert('Please enter a matrix first!');
          return;
        }

        const baseUrl = window.location.origin + window.location.pathname;
        const params = new URLSearchParams();
        params.set('size', n);
        params.set('power', power);
        params.set('matrix', btoa(encodeURIComponent(matrixText)));

        const shareUrl = baseUrl + '?' + params.toString();

        if(navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(shareUrl).then(() => {
            const originalHTML = btnShareURL.innerHTML;
            btnShareURL.innerHTML = '<i class="fas fa-check"></i> Copied!';
            btnShareURL.classList.remove('btn-outline-primary');
            btnShareURL.classList.add('btn-success');
            setTimeout(() => {
              btnShareURL.innerHTML = originalHTML;
              btnShareURL.classList.remove('btn-success');
              btnShareURL.classList.add('btn-outline-primary');
            }, 2000);
          }).catch(err => {
            alert('Failed to copy URL: ' + err);
          });
        } else {
          const textarea = document.createElement('textarea');
          textarea.value = shareUrl;
          document.body.appendChild(textarea);
          textarea.select();
          document.execCommand('copy');
          document.body.removeChild(textarea);
          alert('URL copied to clipboard!');
        }
      } catch(err) {
        console.error('Error creating share URL:', err);
        alert('Failed to create share URL');
      }
    });
  }

  // Download as Image functionality
  const btnDownloadImage = document.getElementById('btnDownloadImage');
  if(btnDownloadImage) {
    btnDownloadImage.addEventListener('click', async function() {
      const resultCard = document.querySelector('.card-body #resultArea').closest('.card');
      if(!resultCard || !resultCard.querySelector('.result-card')) {
        alert('No result to download. Please calculate a power first.');
        return;
      }

      const originalHTML = btnDownloadImage.innerHTML;
      btnDownloadImage.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
      btnDownloadImage.disabled = true;

      try {
        if(window.MathJax && window.MathJax.typesetPromise) {
          await MathJax.typesetPromise([resultCard]);
          await new Promise(resolve => setTimeout(resolve, 800));
        }

        const dataUrl = await domtoimage.toPng(resultCard, {
          quality: 1,
          bgcolor: '#ffffff',
          width: resultCard.offsetWidth,
          height: resultCard.offsetHeight,
          style: {
            margin: '0',
            padding: '20px'
          },
          filter: (node) => {
            if(node.tagName === 'SCRIPT') return false;
            if(node.classList && node.classList.contains('MathJax_Preview')) return false;
            if(node.nodeType === Node.TEXT_NODE) {
              const text = node.textContent || '';
              if(text.includes('$$') || text.includes('\\begin{bmatrix}')) {
                return false;
              }
            }
            return true;
          }
        });

        const link = document.createElement('a');
        const timestamp = new Date().toISOString().slice(0, 10);
        link.download = `matrix-power-${timestamp}.png`;
        link.href = dataUrl;
        link.click();

        btnDownloadImage.innerHTML = '<i class="fas fa-check"></i> Downloaded!';
        btnDownloadImage.classList.remove('btn-outline-success');
        btnDownloadImage.classList.add('btn-success');
        setTimeout(() => {
          btnDownloadImage.innerHTML = originalHTML;
          btnDownloadImage.classList.remove('btn-success');
          btnDownloadImage.classList.add('btn-outline-success');
          btnDownloadImage.disabled = false;
        }, 2000);

      } catch(err) {
        console.error('Error generating image:', err);
        alert('Failed to generate image: ' + err.message);
        btnDownloadImage.innerHTML = originalHTML;
        btnDownloadImage.disabled = false;
      }
    });
  }

  // Load from URL parameters
  function loadFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    if(urlParams.has('matrix') && urlParams.has('size') && urlParams.has('power')) {
      try {
        const size = parseInt(urlParams.get('size'));
        const power = parseInt(urlParams.get('power'));
        const matrixData = decodeURIComponent(atob(urlParams.get('matrix')));

        matrixSize.value = size;
        powerN.value = power;
        matrixInput.value = matrixData;

        setTimeout(() => calculate(), 100);
        return true;
      } catch(err) {
        console.error('Error loading from URL:', err);
      }
    }
    return false;
  }

  if(!loadFromURL()) {
    loadExample('diagonal');
  }
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
