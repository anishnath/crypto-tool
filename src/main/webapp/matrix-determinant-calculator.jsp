<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Matrix Determinant Calculator - Step-by-Step | 2×2 to 10×10</title>
  <meta name="description" content="Free online matrix determinant calculator with step-by-step solutions. Calculate det(A) for square matrices 2×2 to 10×10. Cofactor expansion, row operations, LU decomposition. Random generator, LaTeX display, share URL.">
  <meta name="keywords" content="determinant calculator, matrix determinant, det calculator, cofactor expansion, matrix algebra, linear algebra calculator, det(A), 2x2 determinant, 3x3 determinant, 4x4 determinant">
  <link rel="canonical" href="https://8gwifi.org/matrix-determinant-calculator.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/matrix-determinant-calculator.jsp">
  <meta property="og:title" content="FREE Matrix Determinant Calculator with Step-by-Step Solutions">
  <meta property="og:description" content="Calculate determinant of square matrices (2×2 to 10×10) with detailed steps. Cofactor expansion, row operations, LU decomposition methods.">
  <meta property="og:image" content="https://8gwifi.org/images/matrix-determinant-preview.png">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/matrix-determinant-calculator.jsp">
  <meta property="twitter:title" content="FREE Matrix Determinant Calculator - Step-by-Step">
  <meta property="twitter:description" content="Calculate det(A) for square matrices 2×2 to 10×10 with cofactor expansion and step-by-step solutions.">

  <!-- JSON-LD -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Matrix Determinant Calculator",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
    "description": "Calculate matrix determinant with step-by-step cofactor expansion. Supports 2×2 to 10×10 square matrices. Shows row operations and LU decomposition method.",
    "url": "https://8gwifi.org/matrix-determinant-calculator.jsp",
    "featureList": ["Cofactor expansion method", "Row operations", "LU decomposition", "2×2 to 10×10 matrices", "Step-by-step solutions", "LaTeX notation", "Random matrix generator", "Share URL", "Download image"],
    "screenshot": "https://8gwifi.org/images/matrix-determinant-screenshot.png"
  }
  </script>

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [{
      "@type": "Question",
      "name": "How do I calculate the determinant of a matrix?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Enter your square matrix (same number of rows and columns), select size, input values, and click Calculate. The calculator shows step-by-step cofactor expansion or row operations to compute det(A)."
      }
    }, {
      "@type": "Question",
      "name": "What size matrices are supported?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This calculator supports square matrices from 2×2 up to 10×10. For larger matrices, the calculator uses efficient LU decomposition method."
      }
    }]
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
    .det-calculator .card-header{padding:.6rem .9rem;font-weight:600}
    .det-calculator .card-body{padding:.7rem .9rem}
    .det-calculator .result-card{border-left:4px solid #10b981;background:linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(16,185,129,0.1)}
    .det-calculator .result-value{font-size:2rem;font-weight:700;color:#059669;font-family:monospace}
    .det-calculator .step-card{
      border-left:4px solid #6366f1;
      background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);
      padding:1rem 1.25rem;
      margin:0.75rem 0;
      border-radius:8px;
      box-shadow:0 1px 3px rgba(99,102,241,0.08);
      transition:all 0.2s ease;
    }
    .det-calculator .step-card:hover{
      box-shadow:0 4px 12px rgba(99,102,241,0.15);
      transform:translateX(2px);
    }
    .det-calculator .matrix-display{
      display:block;
      text-align:center;
      padding:0.75rem;
      margin:0.5rem 0;
      background:white;
      border-radius:6px;
      border:1px solid #e0e7ff;
    }
    .method-badge{display:inline-flex;align-items:center;padding:0.3rem 0.6rem;border-radius:999px;font-size:0.85rem;margin:0.25rem;font-weight:500;background:#dbeafe;color:#1d4ed8}

    .step-description{
      font-size:0.95rem;
      color:#4b5563;
      line-height:1.6;
      margin-bottom:0.5rem;
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

    /* Hide LaTeX source when MathJax has rendered */
    .matrix-display .MathJax_Preview,
    .matrix-display script[type^="math/tex"] {
      display: none !important;
    }

    @media (max-width: 767px) {
      .det-calculator h1{font-size:1.5rem}
      .det-calculator .result-value{font-size:1.5rem}
      .det-calculator .card-header{font-size:0.95rem}
      .det-calculator button{width:100%;margin:0.25rem 0}
      .det-calculator .step-card{padding:0.75rem}
      .det-calculator .matrix-display{padding:0.5rem;font-size:0.9em}
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 det-calculator">
  <h1 class="mb-2">Matrix Determinant Calculator</h1>
  <p class="text-muted mb-3">Calculate the determinant of any square matrix with detailed step-by-step solutions.</p>

  <div class="row">
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header">Matrix Input</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="matrixSize">Matrix Size (n×n)</label>
            <div class="d-flex align-items-center">
              <input id="matrixSize" type="number" min="2" max="10" class="form-control mr-2" value="3" style="flex:1">
              <button id="btnRandom" class="btn btn-outline-info btn-sm" title="Generate random matrix">
                <i class="fas fa-random"></i> Random
              </button>
            </div>
            <small class="text-muted">Supports 2×2 up to 10×10 square matrices</small>
          </div>

          <div class="form-group">
            <label for="matrixInput">Matrix Entries</label>
            <textarea id="matrixInput" class="form-control" rows="8" placeholder="Enter matrix entries:
1 2 3
4 5 6
7 8 9"></textarea>
            <small class="text-muted">One row per line, space or comma separated</small>
          </div>

          <div class="form-group">
            <label for="methodSelect">Computation Method</label>
            <select id="methodSelect" class="form-control">
              <option value="lu">LU Decomposition (Fastest)</option>
              <option value="cofactor">Cofactor Expansion</option>
              <option value="gaussian">Gaussian Elimination</option>
            </select>
          </div>

          <div class="d-flex flex-wrap">
            <button id="btnCalculate" class="btn btn-primary btn-sm mr-2 mb-2">Calculate Determinant</button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm mb-2">Clear</button>
          </div>
          <div id="inputError" class="text-danger small mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Quick Presets</h5>
        <div class="card-body">
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-preset="identity">Identity Matrix (3×3)</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-preset="diagonal">Diagonal Matrix</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-preset="triangular">Triangular Matrix</button>
          <button class="btn btn-outline-primary btn-sm btn-block" data-preset="random">Random Matrix</button>
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
            Enter a square matrix and click "Calculate Determinant" to see the result.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Step-by-Step Solution</h5>
        <div class="card-body">
          <div id="stepsArea" class="text-muted">
            Detailed steps will appear here after calculation.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">About Determinants</h5>
        <div class="card-body small">
          <p><strong>What is a Determinant?</strong><br>
          The determinant is a scalar value that can be computed from a square matrix. It provides important information about the matrix, including whether it's invertible.</p>

          <p><strong>Properties:</strong></p>
          <ul>
            <li>det(I) = 1 (identity matrix)</li>
            <li>det(AB) = det(A) × det(B)</li>
            <li>det(A<sup>T</sup>) = det(A)</li>
            <li>det(kA) = k<sup>n</sup> × det(A) for n×n matrix</li>
            <li>If det(A) = 0, the matrix is singular (not invertible)</li>
          </ul>

          <p><strong>Methods:</strong></p>
          <ul>
            <li><strong>LU Decomposition:</strong> Fastest for large matrices, O(n³) complexity</li>
            <li><strong>Cofactor Expansion:</strong> Educational, shows formula clearly, O(n!) complexity</li>
            <li><strong>Gaussian Elimination:</strong> Row reduction method, O(n³) complexity</li>
          </ul>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Matrix Tools</h5>
        <div class="card-body small">
          <div class="d-flex flex-wrap mb-2">
            <a href="matrix-type-classifier.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-list"></i> Matrix Type Classifier
            </a>
            <a href="matrix-inverse-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-sync"></i> Matrix Inverse
            </a>
            <a href="matrix-eigenvalue-calculator.jsp" class="btn btn-sm btn-outline-primary mb-2">
              <i class="fas fa-wave-square"></i> Eigenvalues &amp; Eigenvectors
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

  function cloneMatrix(mat) {
    return mat.map(row => [...row]);
  }

  function smartFormat(num) {
    // Smart formatting: show integers without decimals, floats with minimal decimals
    if(Math.abs(num) < EPS) return '0';
    if(Math.abs(num - Math.round(num)) < EPS) return Math.round(num).toString();
    // For decimals, show up to 3 significant decimal places, removing trailing zeros
    return parseFloat(num.toFixed(3)).toString();
  }

  function formatMatrix(mat, highlightDiag = false) {
    const rows = mat.map((row, i) =>
      row.map((val, j) => {
        const num = Math.abs(val) < EPS ? 0 : val;
        const formatted = smartFormat(num);
        // Highlight diagonal or pivot elements
        if(highlightDiag && i === j) {
          return '\\textcolor{blue}{' + formatted + '}';
        }
        // Highlight zeros in lower triangle
        if(i > j && Math.abs(num) < EPS) {
          return '\\textcolor{gray}{0}';
        }
        return formatted;
      }).join(' & ')
    );
    return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}';
  }

  function determinantLU(mat) {
    const n = mat.length;
    const A = cloneMatrix(mat);
    let det = 1;
    let swaps = 0;
    const steps = [];

    steps.push(`<span class="text-primary">Starting LU decomposition for ${n}×${n} matrix</span>`);
    steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A)}$$</div>`);

    for(let i = 0; i < n; i++) {
      let pivot = i;
      for(let r = i + 1; r < n; r++) {
        if(Math.abs(A[r][i]) > Math.abs(A[pivot][i])) pivot = r;
      }

      if(Math.abs(A[pivot][i]) < EPS) {
        steps.push(`<span class="text-danger">Zero pivot found at row ${i+1}, determinant = 0</span>`);
        return {det: 0, steps};
      }

      if(pivot !== i) {
        [A[pivot], A[i]] = [A[i], A[pivot]];
        swaps++;
        steps.push(`<span class="text-info">Row swap: R${i+1} ↔ R${pivot+1}</span>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A, true)}$$</div>`);
      }

      const pivotVal = A[i][i];
      det *= pivotVal;

      for(let r = i + 1; r < n; r++) {
        const factor = A[r][i] / pivotVal;
        for(let c = i; c < n; c++) {
          A[r][c] -= factor * A[i][c];
        }
      }

      // Show matrix after each column elimination for small matrices, or every few steps for large ones
      const showInterval = n <= 4 ? 1 : Math.max(1, Math.floor(n/3));
      if(i < n - 1 && (n <= 4 || i % showInterval === 0)) {
        steps.push(`Eliminated column ${i+1} below pivot`);
        steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A, true)}$$</div>`);
      }
    }

    steps.push(`<span class="text-success">Final upper triangular form (diagonal in blue, zeros in gray):</span>`);
    steps.push(`<div class="matrix-display mt-2 mb-3">$$${formatMatrix(A, true)}$$</div>`);
    det = swaps % 2 === 0 ? det : -det;
    steps.push(`<strong>det(A) = ${swaps % 2 === 0 ? '+' : '−'}(product of diagonal)</strong> = ${det.toFixed(6)}`);

    return {det, steps};
  }

  function determinantCofactor(mat) {
    const n = mat.length;
    const steps = [];

    if(n === 1) return {det: mat[0][0], steps: ['1×1 matrix: det = ' + mat[0][0]]};

    if(n === 2) {
      const det = mat[0][0] * mat[1][1] - mat[0][1] * mat[1][0];
      steps.push(`2×2 formula: (${mat[0][0]})(${mat[1][1]}) - (${mat[0][1]})(${mat[1][0]}) = ${det.toFixed(4)}`);
      return {det, steps};
    }

    steps.push(`Expanding along row 1 using cofactors...`);

    let det = 0;
    for(let j = 0; j < n; j++) {
      const sign = (j % 2 === 0) ? 1 : -1;
      const minor = getMinor(mat, 0, j);
      const minorDet = determinantCofactor(minor).det;
      const term = sign * mat[0][j] * minorDet;
      det += term;

      if(Math.abs(mat[0][j]) > EPS) {
        steps.push(`C₁${j+1} = ${sign > 0 ? '+' : '-'}(${mat[0][j].toFixed(2)}) × det(M₁${j+1}) = ${term.toFixed(4)}`);
      }
    }

    return {det, steps};
  }

  function getMinor(mat, row, col) {
    return mat.filter((_, i) => i !== row).map(r => r.filter((_, j) => j !== col));
  }

  function determinantGaussian(mat) {
    const n = mat.length;
    const A = cloneMatrix(mat);
    let det = 1;
    let swaps = 0;
    const steps = [];

    steps.push(`<span class="text-primary">Using Gaussian elimination to reduce to upper triangular form</span>`);
    steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A)}$$</div>`);

    for(let i = 0; i < n; i++) {
      let pivot = i;
      for(let r = i + 1; r < n; r++) {
        if(Math.abs(A[r][i]) > Math.abs(A[pivot][i])) pivot = r;
      }

      if(Math.abs(A[pivot][i]) < EPS) {
        steps.push(`<span class="text-danger">Zero column at position ${i+1}, determinant = 0</span>`);
        return {det: 0, steps};
      }

      if(pivot !== i) {
        [A[pivot], A[i]] = [A[i], A[pivot]];
        swaps++;
        det *= -1;
        steps.push(`<span class="text-info">Row swap: R${i+1} ↔ R${pivot+1}</span>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A, true)}$$</div>`);
      }

      let rowOpsInStep = [];
      for(let r = i + 1; r < n; r++) {
        const factor = A[r][i] / A[i][i];
        if(Math.abs(factor) > EPS) {
          rowOpsInStep.push(`R${r+1} = R${r+1} - (${factor.toFixed(2)})R${i+1}`);
          for(let c = i; c < n; c++) {
            A[r][c] -= factor * A[i][c];
          }
        } else {
          for(let c = i; c < n; c++) {
            A[r][c] -= factor * A[i][c];
          }
        }
      }

      if(rowOpsInStep.length > 0) {
        steps.push(`<div class="text-secondary">${rowOpsInStep.join(', ')}</div>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A, true)}$$</div>`);
      }
    }

    for(let i = 0; i < n; i++) {
      det *= A[i][i];
    }

    steps.push(`<span class="text-success">Upper triangular matrix achieved (diagonal in blue):</span>`);
    steps.push(`<div class="matrix-display mt-2 mb-3">$$${formatMatrix(A, true)}$$</div>`);
    steps.push(`<strong>det(A) = product of diagonal</strong> = ${det.toFixed(6)}`);

    return {det, steps};
  }

  function calculate() {
    try {
      inputError.style.display = 'none';
      const n = parseInt(matrixSize.value);
      if(n < 2 || n > 10) {
        throw new Error('Matrix size must be between 2 and 10');
      }

      const matrix = parseMatrix(matrixInput.value, n);
      const method = methodSelect.value;

      let result;
      if(method === 'lu') {
        result = determinantLU(matrix);
      } else if(method === 'cofactor') {
        result = determinantCofactor(matrix);
      } else {
        result = determinantGaussian(matrix);
      }

      const methodName = method === 'lu' ? 'LU Decomposition' :
                         method === 'cofactor' ? 'Cofactor Expansion' :
                         'Gaussian Elimination';

      resultArea.innerHTML = `
        <div class="result-card">
          <div class="mb-2">Original Matrix:</div>
          <div class="matrix-display mb-3">$$${formatMatrix(matrix)}$$</div>
          <div class="mb-2"><span class="method-badge">${methodName}</span></div>
          <div class="mt-3">
            <div style="font-size:1.1rem;color:#64748b">Determinant:</div>
            <div class="result-value">${result.det.toFixed(6)}</div>
          </div>
          ${Math.abs(result.det) < EPS ? '<div class="text-warning mt-2"><i class="fas fa-exclamation-triangle"></i> Matrix is singular (not invertible)</div>' : ''}
        </div>
      `;

      let stepsHtml = '<div class="mb-4"><h5 class="text-dark">📋 Computation Steps</h5></div>';
      stepsHtml += '<p class="text-muted mb-4" style="font-size:0.95rem">Watch how the matrix transforms at each step:</p>';
      result.steps.forEach((step, idx) => {
        stepsHtml += `<div class="step-card">
          <div class="d-flex align-items-center mb-2">
            <span class="step-number">${idx + 1}</span>
            <div class="step-description">${step}</div>
          </div>
        </div>`;
      });
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
    resultArea.innerHTML = '<div class="text-center text-muted">Enter a square matrix and click "Calculate Determinant" to see the result.</div>';
    stepsArea.innerHTML = '<div class="text-muted">Detailed steps will appear here after calculation.</div>';
    inputError.style.display = 'none';
  }

  function loadPreset(preset) {
    if(preset === 'identity') {
      matrixSize.value = 3;
      matrixInput.value = '1 0 0\n0 1 0\n0 0 1';
    } else if(preset === 'diagonal') {
      matrixSize.value = 3;
      matrixInput.value = '5 0 0\n0 -3 0\n0 0 2';
    } else if(preset === 'triangular') {
      matrixSize.value = 4;
      matrixInput.value = '2 1 3 4\n0 5 2 1\n0 0 3 6\n0 0 0 7';
    } else if(preset === 'random') {
      const n = 3;
      matrixSize.value = n;
      const rows = [];
      for(let i = 0; i < n; i++) {
        const row = [];
        for(let j = 0; j < n; j++) {
          row.push(Math.floor(Math.random() * 20 - 10));
        }
        rows.push(row.join(' '));
      }
      matrixInput.value = rows.join('\n');
    }
    calculate();
  }

  // Random matrix generator
  function generateRandom() {
    const n = parseInt(matrixSize.value);
    if(n < 2 || n > 10) {
      alert('Please set matrix size between 2 and 10');
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

        // Create URL with matrix data
        const baseUrl = window.location.origin + window.location.pathname;
        const params = new URLSearchParams();
        params.set('size', n);
        params.set('matrix', btoa(encodeURIComponent(matrixText))); // Base64 encode to handle special chars
        params.set('method', methodSelect.value);

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
          // Fallback for older browsers
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
              alert('No result to download. Please calculate a determinant first.');
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
              link.download = `matrix-determinant-${timestamp}.png`;
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
        const method = urlParams.get('method') || 'lu';

        matrixSize.value = size;
        matrixInput.value = matrixData;
        methodSelect.value = method;

        // Auto-calculate if valid data
        setTimeout(() => calculate(), 100);
        return true;
      } catch(err) {
        console.error('Error loading from URL:', err);
      }
    }
    return false;
  }

  // Load identity matrix by default or from URL
  if(!loadFromURL()) {
    loadPreset('identity');
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
