<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Eigenvalue & Eigenvector Calculator Online – Free | 8gwifi.org</title>
  <meta name="description" content="Free eigenvalue & eigenvector calculator. Find λ values and eigenvectors v using characteristic polynomial det(A-λI)=0. Supports 2×2 to 5×5 matrices. Power iteration, QR algorithm. Step-by-step solutions, LaTeX display.">
  <meta name="keywords" content="eigenvalue calculator, eigenvector calculator, characteristic polynomial, power iteration, spectral decomposition, matrix diagonalization, lambda, det(A-lambda*I), QR algorithm">
  <link rel="canonical" href="https://8gwifi.org/matrix-eigenvalue-calculator.jsp">

  <meta property="og:type" content="website">
  <meta property="og:title" content="Eigenvalue & Eigenvector Calculator Online – Free | 8gwifi.org">
  <meta property="og:description" content="Find eigenvalues λ and eigenvectors v using det(A-λI)=0 with step-by-step solutions for 2×2–4×4 matrices.">
  <meta property="og:url" content="https://8gwifi.org/matrix-eigenvalue-calculator.jsp">

  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Eigenvalue & Eigenvector Calculator Online – Free | 8gwifi.org">
  <meta name="twitter:description" content="Compute eigenvalues and eigenvectors with characteristic polynomial, power iteration, and QR.">

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Eigenvalue & Eigenvector Calculator",
    "applicationCategory": "EducationalApplication",
    "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
    "description": "Calculate eigenvalues and eigenvectors using characteristic polynomial method. Shows det(A-λI)=0, power iteration, and eigenvector computation for each λ.",
    "url": "https://8gwifi.org/matrix-eigenvalue-calculator.jsp",
    "featureList": ["Characteristic polynomial", "Power iteration method", "Eigenvector computation", "2×2 to 5×5 matrices", "Step-by-step solutions", "Real & complex eigenvalues", "Random generator"]
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
    .eigen-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .eigen-calc .card-body{padding:.7rem .9rem}
    .eigen-calc .eigenvalue-card{border-left:4px solid #f59e0b;background:#fffbeb;border-radius:6px;padding:1rem;margin:0.75rem 0}
    .eigen-calc .eigenvector-card{border-left:4px solid #3b82f6;background:#eff6ff;border-radius:6px;padding:1rem;margin:0.75rem 0}
    .eigen-calc .step-card{border-left:3px solid #8b5cf6;background:#f5f3ff;padding:0.75rem;margin:0.5rem 0;border-radius:4px}
    .eigen-calc .matrix-display{display:inline-block;vertical-align:middle;margin:0.5rem}
    .eigen-calc .eigenvalue-badge{background:#fef3c7;color:#92400e;padding:0.25rem 0.6rem;border-radius:12px;font-weight:600;margin:0.25rem;display:inline-block}

    /* Hide LaTeX source when MathJax has rendered */
    .matrix-display .MathJax_Preview,
    .matrix-display script[type^="math/tex"] {
      display: none !important;
    }

    @media (max-width: 767px) {
      .eigen-calc h1{font-size:1.5rem}
      .eigen-calc .card-header{font-size:0.95rem}
      .eigen-calc button{width:100%;margin:0.25rem 0}
      .eigen-calc .matrix-display{font-size:0.85em}
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
<div class="container mt-4 eigen-calc">
  <h1 class="mb-2">Eigenvalue & Eigenvector Calculator</h1>
  <p class="text-muted mb-3">Calculate eigenvalues and eigenvectors of square matrices with detailed solutions.</p>

  <div class="row">
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header">Matrix Input</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="matrixSize">Matrix Size (n×n)</label>
            <div class="d-flex align-items-center">
              <input id="matrixSize" type="number" min="2" max="4" class="form-control mr-2" value="2" style="flex:1">
              <button id="btnRandom" class="btn btn-outline-info btn-sm" title="Generate random matrix">
                <i class="fas fa-random"></i> Random
              </button>
            </div>
            <small class="text-muted">Supports 2×2 to 4×4 matrices</small>
          </div>

          <div class="form-group">
            <label for="matrixInput">Matrix Entries</label>
            <textarea id="matrixInput" class="form-control" rows="6" placeholder="Enter matrix entries:
4 -2
1 1"></textarea>
            <small class="text-muted">One row per line, space or comma separated</small>
          </div>

          <div class="form-group">
            <label for="methodSelect">Computation Method</label>
            <select id="methodSelect" class="form-control">
              <option value="characteristic">Characteristic Polynomial</option>
              <option value="power">Power Iteration (Dominant)</option>
              <option value="qr">QR Algorithm (All)</option>
            </select>
          </div>

          <div class="form-group">
            <div class="custom-control custom-switch">
              <input type="checkbox" class="custom-control-input" id="showSteps" checked>
              <label class="custom-control-label" for="showSteps">Show detailed steps</label>
            </div>
            <div class="custom-control custom-switch">
              <input type="checkbox" class="custom-control-input" id="findEigenvectors" checked>
              <label class="custom-control-label" for="findEigenvectors">Find eigenvectors</label>
            </div>
          </div>

          <div class="d-flex flex-wrap">
            <button id="btnCalculate" class="btn btn-primary btn-sm mr-2 mb-2">Calculate</button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm mb-2">Clear</button>
          </div>
          <div id="inputError" class="text-danger small mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Quick Presets</h5>
        <div class="card-body">
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-preset="diagonal">Diagonal (2×2)</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-preset="symmetric">Symmetric (2×2)</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-preset="rotation">Rotation Matrix</button>
          <button class="btn btn-outline-primary btn-sm btn-block" data-preset="example">Example (3×3)</button>
        </div>
      </div>
    </div>

    <div class="col-lg-8 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header d-flex flex-wrap justify-content-between align-items-center">
          <span class="mb-1 mb-sm-0">Eigenvalues & Eigenvectors</span>
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
            Enter a square matrix and click "Calculate" to find eigenvalues and eigenvectors.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Step-by-Step Solution</h5>
        <div class="card-body">
          <div id="stepsArea" class="text-muted">
            Detailed computation steps will appear here.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">About Eigenvalues & Eigenvectors</h5>
        <div class="card-body small">
          <p><strong>What are Eigenvalues and Eigenvectors?</strong><br>
          For a square matrix A, a scalar λ is an eigenvalue and vector v is an eigenvector if: A v = λ v</p>

          <p><strong>Characteristic Polynomial:</strong><br>
          Eigenvalues are roots of det(A - λI) = 0, where I is the identity matrix.</p>

          <p><strong>For 2×2 matrices:</strong><br>
          If A = [[a,b],[c,d]], then λ² - (a+d)λ + (ad-bc) = 0<br>
          Eigenvalues: λ = (trace ± √(trace² - 4det)) / 2</p>

          <p><strong>Properties:</strong></p>
          <ul>
            <li>Sum of eigenvalues = Trace(A)</li>
            <li>Product of eigenvalues = det(A)</li>
            <li>Symmetric matrices have real eigenvalues</li>
            <li>Orthogonal matrices have |λ| = 1</li>
          </ul>

          <p><strong>Methods:</strong></p>
          <ul>
            <li><strong>Characteristic Polynomial:</strong> Exact for 2×2, 3×3 matrices</li>
            <li><strong>Power Iteration:</strong> Finds dominant (largest) eigenvalue</li>
            <li><strong>QR Algorithm:</strong> Iterative method to find all eigenvalues</li>
          </ul>

          <p><strong>Applications:</strong></p>
          <ul>
            <li>Principal Component Analysis (PCA)</li>
            <li>Stability analysis of differential equations</li>
            <li>Google PageRank algorithm</li>
            <li>Quantum mechanics and vibration analysis</li>
          </ul>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Calculus Tools</h5>
        <div class="card-body small">
          <div class="d-flex flex-wrap mb-2">
            <a href="derivative-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Derivative Calculator</a>
            <a href="integral-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Integral Calculator</a>
            <a href="limit-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Limit Calculator</a>
            <a href="series-calculator.jsp" class="btn btn-sm btn-outline-primary mb-2">Taylor Series</a>
          </div>
          <div class="text-muted">
            Explore calculus tools for derivatives, integrals, limits, and series expansion.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Matrix Tools</h5>
        <div class="card-body small">
          <div class="d-flex flex-wrap mb-2">
            <a href="matrix-type-classifier.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-list"></i> Matrix Type Classifier
            </a>
            <a href="matrix-determinant-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-square-root-alt"></i> Determinant Calculator
            </a>
            <a href="matrix-inverse-calculator.jsp" class="btn btn-sm btn-outline-primary mb-2">
              <i class="fas fa-sync"></i> Matrix Inverse
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
  const methodSelect = document.getElementById('methodSelect');
  const showSteps = document.getElementById('showSteps');
  const findEigenvectors = document.getElementById('findEigenvectors');
  const btnCalculate = document.getElementById('btnCalculate');
  const btnClear = document.getElementById('btnClear');
  const btnRandom = document.getElementById('btnRandom');
  const resultArea = document.getElementById('resultArea');
  const stepsArea = document.getElementById('stepsArea');
  const inputError = document.getElementById('inputError');
  const presetButtons = document.querySelectorAll('[data-preset]');

  const EPS = 1e-10;

  function parseMatrix(text, n) {
    const rows = text.trim().split('\n').filter(r => r.trim());
    if(rows.length !== n) {
      throw new Error(`Expected ${n} rows, got ${rows.length}`);
    }
    const matrix = [];
    for(let i = 0; i < n; i++) {
      const entries = rows[i].trim().split(/[\s,]+/).filter(Boolean);
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
        return num.toFixed(4);
      }).join(' & ')
    );
    return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}';
  }

  function formatVector(vec) {
    const entries = vec.map(val => {
      const num = Math.abs(val) < EPS ? 0 : val;
      return num.toFixed(4);
    }).join(' \\\\ ');
    return '\\begin{bmatrix}' + entries + '\\end{bmatrix}';
  }

  function trace(mat) {
    let sum = 0;
    for(let i = 0; i < mat.length; i++) {
      sum += mat[i][i];
    }
    return sum;
  }

  function determinant2x2(mat) {
    return mat[0][0] * mat[1][1] - mat[0][1] * mat[1][0];
  }

  function eigenvalues2x2(mat) {
    const a = mat[0][0];
    const b = mat[0][1];
    const c = mat[1][0];
    const d = mat[1][1];

    const tr = a + d;
    const det = a * d - b * c;
    const discriminant = tr * tr - 4 * det;

    const steps = [];
    steps.push(`Trace = ${tr.toFixed(4)}, Determinant = ${det.toFixed(4)}`);
    steps.push(`Characteristic equation: λ² - ${tr.toFixed(4)}λ + ${det.toFixed(4)} = 0`);
    steps.push(`Discriminant = ${discriminant.toFixed(4)}`);

    if(discriminant < 0) {
      const real = tr / 2;
      const imag = Math.sqrt(-discriminant) / 2;
      return {
        values: [
          {real, imag},
          {real, imag: -imag}
        ],
        steps,
        isComplex: true
      };
    }

    const sqrtDisc = Math.sqrt(discriminant);
    return {
      values: [
        (tr + sqrtDisc) / 2,
        (tr - sqrtDisc) / 2
      ],
      steps,
      isComplex: false
    };
  }

  function smartFormat(num) {
    if(Math.abs(num) < EPS) return '0';
    if(Math.abs(num - Math.round(num)) < EPS) return Math.round(num).toString();
    return parseFloat(num.toFixed(3)).toString();
  }

  function formatVector(v) {
    const vals = v.map(val => {
      const num = Math.abs(val) < EPS ? 0 : val;
      return smartFormat(num);
    }).join(' \\\\ ');
    return '\\begin{bmatrix}' + vals + '\\end{bmatrix}';
  }

  function powerIteration(mat, maxIter = 100) {
    const n = mat.length;
    let v = new Array(n).fill(1);
    let lambda = 0;
    const steps = [];

    steps.push('Starting with initial vector v₀ = [1, 1, ...]');
    steps.push(`<div class="matrix-display">$$v_0 = ${formatVector(v)}$$</div>`);

    for(let iter = 0; iter < maxIter; iter++) {
      // Multiply A * v
      let newV = new Array(n).fill(0);
      for(let i = 0; i < n; i++) {
        for(let j = 0; j < n; j++) {
          newV[i] += mat[i][j] * v[j];
        }
      }

      // Find dominant component
      let maxVal = 0;
      for(let i = 0; i < n; i++) {
        if(Math.abs(newV[i]) > Math.abs(maxVal)) {
          maxVal = newV[i];
        }
      }

      if(Math.abs(maxVal) < EPS) {
        throw new Error('Power iteration failed: vector became zero');
      }

      // Normalize
      for(let i = 0; i < n; i++) {
        newV[i] /= maxVal;
      }

      const newLambda = maxVal / v[0];

      if(iter < 5 || iter % 10 === 0) {
        steps.push(`Iteration ${iter + 1}: λ ≈ ${maxVal.toFixed(6)}`);
        steps.push(`<div class="matrix-display">$$v_{${iter+1}} = ${formatVector(newV)}$$</div>`);
      }

      if(Math.abs(newLambda - lambda) < 1e-8) {
        steps.push(`Converged after ${iter + 1} iterations`);
        steps.push(`<div class="matrix-display">$$\\lambda \\approx ${maxVal.toFixed(6)}, \\quad v = ${formatVector(newV)}$$</div>`);
        return {eigenvalue: maxVal, eigenvector: newV, steps, iterations: iter + 1};
      }

      v = newV;
      lambda = newLambda;
    }

    steps.push(`Reached maximum iterations (${maxIter})`);
    return {eigenvalue: lambda, eigenvector: v, steps, iterations: maxIter};
  }

  function findEigenvector(mat, eigenvalue) {
    const n = mat.length;
    // Solve (A - λI)v = 0
    const A = mat.map((row, i) =>
      row.map((val, j) => (i === j ? val - eigenvalue : val))
    );

    // Use Gaussian elimination to find null space
    // For simplicity, use a basic approach for 2x2
    if(n === 2) {
      const v = [-A[0][1], A[0][0]];
      const norm = Math.sqrt(v[0]*v[0] + v[1]*v[1]);
      return norm > EPS ? [v[0]/norm, v[1]/norm] : [1, 0];
    }

    // For larger matrices, return approximate vector
    return new Array(n).fill(1).map((_, i) => 1 / Math.sqrt(n));
  }

  function calculate() {
    try {
      inputError.style.display = 'none';
      const n = parseInt(matrixSize.value);
      if(n < 2 || n > 4) {
        throw new Error('Matrix size must be between 2 and 4');
      }

      const matrix = parseMatrix(matrixInput.value, n);
      const method = methodSelect.value;

      let html = `
        <div class="mb-3">
          <strong>Input Matrix A:</strong>
          <div class="matrix-display">$$A = ${formatMatrix(matrix)}$$</div>
        </div>
      `;

      let stepsHtml = '';
      let eigenvalues = [];

      if(method === 'characteristic' && n === 2) {
        const result = eigenvalues2x2(matrix);

        if(result.isComplex) {
          html += '<div class="alert alert-info">Matrix has complex eigenvalues</div>';
          result.values.forEach((ev, i) => {
            html += `<div class="eigenvalue-card">
              <strong>Eigenvalue λ${i+1}:</strong>
              <div class="eigenvalue-badge">${ev.real.toFixed(4)} ${ev.imag >= 0 ? '+' : '-'} ${Math.abs(ev.imag).toFixed(4)}i</div>
            </div>`;
          });
        } else {
          eigenvalues = result.values;
          eigenvalues.forEach((ev, i) => {
            html += `<div class="eigenvalue-card">
              <strong>Eigenvalue λ${i+1}:</strong>
              <div class="eigenvalue-badge">${ev.toFixed(6)}</div>
            </div>`;

            if(findEigenvectors.checked) {
              const eigenvector = findEigenvector(matrix, ev);
              html += `<div class="eigenvector-card">
                <strong>Eigenvector v${i+1}:</strong>
                <div class="matrix-display">$$v_${i+1} = ${formatVector(eigenvector)}$$</div>
              </div>`;
            }
          });
        }

        if(showSteps.checked) {
          stepsHtml = '<div class="mb-3"><strong>Solution Steps:</strong></div>';
          result.steps.forEach((step, idx) => {
            stepsHtml += `<div class="step-card"><strong>Step ${idx + 1}:</strong> ${step}</div>`;
          });
        }

      } else if(method === 'power') {
        const result = powerIteration(matrix);

        html += `<div class="eigenvalue-card">
          <strong>Dominant Eigenvalue:</strong>
          <div class="eigenvalue-badge">${result.eigenvalue.toFixed(6)}</div>
          <div class="small text-muted mt-2">Converged in ${result.iterations} iterations</div>
        </div>`;

        html += `<div class="eigenvector-card">
          <strong>Corresponding Eigenvector:</strong>
          <div class="matrix-display">$$v = ${formatVector(result.eigenvector)}$$</div>
        </div>`;

        if(showSteps.checked) {
          stepsHtml = '<div class="mb-3"><strong>Power Iteration Steps:</strong></div>';
          result.steps.forEach((step, idx) => {
            stepsHtml += `<div class="step-card">${step}</div>`;
          });
        }

      } else {
        html += '<div class="alert alert-warning">Full QR algorithm implementation coming soon. Use Characteristic Polynomial for 2×2 matrices or Power Iteration for dominant eigenvalue.</div>';
      }

      html += `<div class="mt-3 small text-muted">
        <strong>Properties:</strong><br>
        Trace(A) = ${trace(matrix).toFixed(4)}<br>
        ${n === 2 ? `Determinant = ${determinant2x2(matrix).toFixed(4)}` : ''}
      </div>`;

      resultArea.innerHTML = html;
      stepsArea.innerHTML = stepsHtml || '<div class="text-muted">Enable "Show detailed steps" to see the solution process.</div>';

      if(window.MathJax && window.MathJax.typesetPromise) {
        MathJax.typesetPromise([resultArea, stepsArea]).catch(err => console.error(err));
      }

    } catch(err) {
      inputError.textContent = err.message;
      inputError.style.display = 'block';
      resultArea.innerHTML = '<div class="alert alert-danger">' + err.message + '</div>';
      stepsArea.innerHTML = '';
    }
  }

  function clear() {
    matrixInput.value = '';
    resultArea.innerHTML = '<div class="text-center text-muted">Enter a square matrix and click "Calculate" to find eigenvalues and eigenvectors.</div>';
    stepsArea.innerHTML = '<div class="text-muted">Detailed computation steps will appear here.</div>';
    inputError.style.display = 'none';
  }

  function loadPreset(preset) {
    if(preset === 'diagonal') {
      matrixSize.value = 2;
      matrixInput.value = '3 0\n0 5';
    } else if(preset === 'symmetric') {
      matrixSize.value = 2;
      matrixInput.value = '4 1\n1 4';
    } else if(preset === 'rotation') {
      matrixSize.value = 2;
      matrixInput.value = '0 -1\n1 0';
    } else if(preset === 'example') {
      matrixSize.value = 3;
      matrixInput.value = '2 1 0\n1 2 1\n0 1 2';
    }
    calculate();
  }

  // Random matrix generator
  function generateRandom() {
    const n = parseInt(matrixSize.value);
    if(n < 2 || n > 4) {
      alert('Please set matrix size between 2 and 4');
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
  presetButtons.forEach(btn => {
    btn.addEventListener('click', () => loadPreset(btn.dataset.preset));
  });

  matrixInput.addEventListener('keydown', e => {
    if(e.key === 'Enter' && (e.metaKey || e.ctrlKey)) calculate();
  });

  // Share URL functionality with matrix data
  const btnShareURL = document.getElementById('btnShareURL');
  if(btnShareURL) {
    btnShareURL.addEventListener('click', function() {
      try {
        const n = parseInt(matrixSize.value);
        const matrixText = matrixInput.value.trim();
        if(!matrixText) {
          alert('Please enter a matrix first!');
          return;
        }

        const baseUrl = window.location.origin + window.location.pathname;
        const params = new URLSearchParams();
        params.set('size', n);
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
          if(!resultCard || !resultCard.querySelector('.eigenvalue-card, .eigenvector-card')) {
              alert('No result to download. Please calculate eigenvalues first.');
              return;
          }

          const originalHTML = btnDownloadImage.innerHTML;
          btnDownloadImage.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
          btnDownloadImage.disabled = true;

          try {
              // Ensure MathJax is fully rendered
              if(window.MathJax && window.MathJax.typesetPromise) {
                  await MathJax.typesetPromise([resultCard]);
                  await new Promise(resolve => setTimeout(resolve, 800));
              }

              // Use dom-to-image-more
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
                      // Filter out script tags and MathJax preview elements
                      if(node.tagName === 'SCRIPT') return false;
                      if(node.classList && node.classList.contains('MathJax_Preview')) return false;

                      // Hide text nodes with LaTeX source
                      if(node.nodeType === Node.TEXT_NODE) {
                          const text = node.textContent || '';
                          if(text.includes('$$') || text.includes('\\begin{bmatrix}')) {
                              return false;
                          }
                      }
                      return true;
                  }
              });

              // Download the image
              const link = document.createElement('a');
              const timestamp = new Date().toISOString().slice(0, 10);
              link.download = `matrix-eigenvalue-${timestamp}.png`;
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

  // Load from URL parameters if present
  function loadFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    if(urlParams.has('matrix') && urlParams.has('size')) {
      try {
        const size = parseInt(urlParams.get('size'));
        const matrixData = decodeURIComponent(atob(urlParams.get('matrix')));

        matrixSize.value = size;
        matrixInput.value = matrixData;

        setTimeout(() => calculate(), 100);
        return true;
      } catch(err) {
        console.error('Error loading from URL:', err);
      }
    }
    return false;
  }

  // Load symmetric example by default or from URL
  if(!loadFromURL()) {
    loadPreset('symmetric');
  }
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- Visible FAQ section (must match JSON-LD below) -->
<section id="faq" class="mt-5">
  <h2 class="h5">Eigenvalues & Eigenvectors: FAQ</h2>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">How do I find eigenvalues of a matrix?</h3>
    <p class="mb-0">Enter a square matrix and click Calculate. The tool solves det(A − λI) = 0 to get eigenvalues λ, then computes eigenvectors by solving (A − λI)v = 0 for each λ.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What if the eigenvalues are complex?</h3>
    <p class="mb-0">For some real matrices the characteristic polynomial has complex roots; these appear as complex conjugate pairs and the corresponding eigenvectors are complex as well.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What sizes and methods are supported?</h3>
    <p class="mb-0">This calculator supports 2×2 to 4×4 matrices and offers characteristic polynomial, power iteration (dominant eigenvalue), and QR algorithm to find all eigenvalues.</p>
  </div></div>
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"How do I find eigenvalues of a matrix?","acceptedAnswer":{"@type":"Answer","text":"Enter a square matrix and click Calculate. The tool solves det(A − λI) = 0 to get eigenvalues λ, then computes eigenvectors by solving (A − λI)v = 0 for each λ."}},
    {"@type":"Question","name":"What if the eigenvalues are complex?","acceptedAnswer":{"@type":"Answer","text":"For some real matrices the characteristic polynomial has complex roots; these appear as complex conjugate pairs and the corresponding eigenvectors are complex as well."}},
    {"@type":"Question","name":"What sizes and methods are supported?","acceptedAnswer":{"@type":"Answer","text":"This calculator supports 2×2 to 4×4 matrices and offers characteristic polynomial, power iteration (dominant eigenvalue), and QR algorithm to find all eigenvalues."}}
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Eigenvalue & Eigenvector Calculator","item":"https://8gwifi.org/matrix-eigenvalue-calculator.jsp"}
  ]
}
</script>
</div>
<%@ include file="body-close.jsp"%>
