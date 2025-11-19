<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Matrix Addition Calculator Online – Free | 8gwifi.org</title>
  <meta name="description" content="Perform matrix addition A+B, subtraction A-B, scalar multiplication cA, and linear combinations aA+bB instantly. Free calculator with step-by-step solutions and detailed element-wise computations.">
  <meta name="keywords" content="matrix addition calculator, matrix subtraction, A+B calculator, A-B calculator, scalar multiplication, linear combination, matrix arithmetic, element-wise operations, matrix calculator, cA scalar multiply">
  <link rel="canonical" href="https://8gwifi.org/matrix-addition-calculator.jsp">

  <!-- Open Graph Meta Tags -->
  <meta property="og:type" content="website">
  <meta property="og:title" content="Matrix Addition Calculator Online – Free | 8gwifi.org">
  <meta property="og:description" content="Add/subtract matrices, do scalar multiplication and linear combinations with step-by-step element-wise calculations.">
  <meta property="og:url" content="https://8gwifi.org/matrix-addition-calculator.jsp">

  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Matrix Addition Calculator Online – Free | 8gwifi.org">
  <meta name="twitter:description" content="Perform A+B, A−B, cA, and aA+bB with detailed element-wise steps.">

  <!-- JSON-LD WebApplication Schema -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Matrix Addition & Subtraction Calculator",
    "applicationCategory": "UtilitiesApplication",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free online calculator for matrix addition, subtraction, scalar multiplication, and linear combinations. Perform element-wise operations with detailed step-by-step solutions.",
    "url": "https://8gwifi.org/matrix-addition-calculator.jsp",
    "featureList": [
      "Matrix addition (A + B) with element-wise computation",
      "Matrix subtraction (A - B) with detailed steps",
      "Scalar multiplication (cA) for any scalar value",
      "Linear combinations (aA + bB) with multiple scalars",
      "Support for matrices up to 10×10 dimensions",
      "Step-by-step element-wise calculations",
      "Visual progress tracking during computation",
      "Random matrix generation for testing operations"
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
    .matadd-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .matadd-calc .card-body{padding:.7rem .9rem}
    .matadd-calc .result-card{border-left:4px solid #10b981;background:linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(16,185,129,0.1)}
    .matadd-calc .operation-badge{
      display:inline-flex;
      align-items:center;
      padding:0.4rem 0.8rem;
      border-radius:999px;
      font-size:0.95rem;
      font-weight:600;
      background:#dbeafe;
      color:#1e40af;
      margin:0.25rem;
    }
    .matadd-calc .step-card{
      border-left:4px solid #6366f1;
      background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);
      padding:1rem 1.25rem;
      margin:0.75rem 0;
      border-radius:8px;
      box-shadow:0 1px 3px rgba(99,102,241,0.08);
      transition:all 0.2s ease;
    }
    .matadd-calc .step-card:hover{
      box-shadow:0 4px 12px rgba(99,102,241,0.15);
      transform:translateX(2px);
    }
    .matadd-calc .matrix-display{
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
      .matadd-calc h1{font-size:1.5rem}
      .matadd-calc .card-header{font-size:0.95rem}
      .matadd-calc button{width:100%;margin:0.25rem 0}
      .matadd-calc .step-card{padding:0.75rem}
      .matadd-calc .matrix-display{padding:0.5rem;font-size:0.9em}
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
<div class="container mt-4 matadd-calc">
  <h1 class="mb-2">Matrix Addition & Subtraction Calculator</h1>
  <p class="text-muted mb-3">Add, subtract matrices, and perform scalar multiplication with step-by-step solutions.</p>

  <div class="row">
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header">Operation</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="operation">Choose Operation</label>
            <select id="operation" class="form-control">
              <option value="add">A + B</option>
              <option value="subtract">A - B</option>
              <option value="scalar">Scalar × A (cA)</option>
              <option value="linear">Linear Combination (aA + bB)</option>
            </select>
          </div>

          <div id="scalarInputs" style="display:none">
            <div class="form-group">
              <label for="scalarValue">Scalar c</label>
              <input id="scalarValue" type="number" step="any" class="form-control" value="2">
            </div>
          </div>

          <div id="linearInputs" style="display:none">
            <div class="row">
              <div class="col-6">
                <div class="form-group">
                  <label for="scalarA">Scalar a</label>
                  <input id="scalarA" type="number" step="any" class="form-control" value="2">
                </div>
              </div>
              <div class="col-6">
                <div class="form-group">
                  <label for="scalarB">Scalar b</label>
                  <input id="scalarB" type="number" step="any" class="form-control" value="3">
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Matrix A</h5>
        <div class="card-body">
          <div class="form-group">
            <label>Dimensions (m × n)</label>
            <div class="d-flex">
              <input id="rows" type="number" min="1" max="10" class="form-control mr-1" value="2" placeholder="rows">
              <span class="mx-1 mt-2">×</span>
              <input id="cols" type="number" min="1" max="10" class="form-control ml-1" value="2" placeholder="cols">
            </div>
          </div>

          <div class="form-group">
            <label for="matrixA">Matrix A Entries</label>
            <textarea id="matrixA" class="form-control" rows="4" placeholder="1 2
3 4"></textarea>
            <small class="text-muted">One row per line, space separated</small>
          </div>

          <button id="btnRandomA" class="btn btn-outline-info btn-sm btn-block mb-2">
            <i class="fas fa-random"></i> Random Matrix A
          </button>
        </div>
      </div>

      <div class="card mb-3" id="matrixBCard">
        <h5 class="card-header">Matrix B</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="matrixB">Matrix B Entries (same dimensions as A)</label>
            <textarea id="matrixB" class="form-control" rows="4" placeholder="5 6
7 8"></textarea>
            <small class="text-muted">One row per line, space separated</small>
          </div>

          <button id="btnRandomB" class="btn btn-outline-info btn-sm btn-block mb-2">
            <i class="fas fa-random"></i> Random Matrix B
          </button>
        </div>
      </div>

      <div class="card mb-3">
        <div class="card-body">
          <div class="form-group">
            <div class="custom-control custom-checkbox">
              <input type="checkbox" class="custom-control-input" id="showSteps" checked>
              <label class="custom-control-label" for="showSteps">Show detailed steps</label>
            </div>
          </div>

          <div class="d-flex flex-wrap">
            <button id="btnCalculate" class="btn btn-primary btn-sm mr-2 mb-2">
              <i class="fas fa-calculator"></i> Calculate
            </button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm mb-2">Clear</button>
          </div>
          <div id="inputError" class="text-danger small mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Quick Examples</h5>
        <div class="card-body">
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="add">Addition (2×2)</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="subtract">Subtraction (3×3)</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="scalar">Scalar Multiply</button>
          <button class="btn btn-outline-primary btn-sm btn-block" data-example="linear">Linear Combination</button>
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
            Select an operation and enter matrices to see the result.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">📋 Computation Steps</h5>
        <div class="card-body">
          <div id="stepsArea" class="text-muted">
            Detailed computation steps will appear here.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">📚 Related Matrix Tools</h5>
        <div class="card-body">
          <div class="d-flex flex-wrap">
            <a href="matrix-multiplication-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-times"></i> Matrix Multiplication
            </a>
            <a href="matrix-transpose-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-exchange-alt"></i> Transpose
            </a>
            <a href="matrix-power-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-superscript"></i> Matrix Powers
            </a>
            <a href="matrix-inverse-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-sync"></i> Matrix Inverse
            </a>
            <a href="matrix-determinant-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-calculator"></i> Determinant
            </a>
            <a href="linear-equations-solver.jsp" class="btn btn-sm btn-outline-primary mb-2">
              <i class="fas fa-equals"></i> Linear Equations
            </a>
          </div>
          <div class="text-muted mt-2">
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
  const rows = document.getElementById('rows');
  const cols = document.getElementById('cols');
  const matrixA = document.getElementById('matrixA');
  const matrixB = document.getElementById('matrixB');
  const matrixBCard = document.getElementById('matrixBCard');
  const operation = document.getElementById('operation');
  const scalarInputs = document.getElementById('scalarInputs');
  const linearInputs = document.getElementById('linearInputs');
  const scalarValue = document.getElementById('scalarValue');
  const scalarA = document.getElementById('scalarA');
  const scalarB = document.getElementById('scalarB');
  const showSteps = document.getElementById('showSteps');
  const btnCalculate = document.getElementById('btnCalculate');
  const btnClear = document.getElementById('btnClear');
  const btnRandomA = document.getElementById('btnRandomA');
  const btnRandomB = document.getElementById('btnRandomB');
  const resultArea = document.getElementById('resultArea');
  const stepsArea = document.getElementById('stepsArea');
  const inputError = document.getElementById('inputError');
  const exampleButtons = document.querySelectorAll('[data-example]');

  const EPS = 1e-10;

  function smartFormat(num) {
    if(Math.abs(num) < EPS) return '0';
    if(Math.abs(num - Math.round(num)) < EPS) return Math.round(num).toString();
    return parseFloat(num.toFixed(3)).toString();
  }

  function parseMatrix(text, m, n) {
    const lines = text.trim().split('\n').filter(r => r.trim());
    if(lines.length !== m) {
      throw new Error(`Expected ${m} rows, got ${lines.length}`);
    }
    const matrix = [];
    for(let i = 0; i < m; i++) {
      const entries = lines[i].trim().split(/[\s,]+/).filter(Boolean);
      if(entries.length !== n) {
        throw new Error(`Row ${i+1}: Expected ${n} columns, got ${entries.length}`);
      }
      matrix[i] = entries.map(e => {
        const num = parseFloat(e);
        if(isNaN(num)) throw new Error(`Invalid number: "${e}"`);
        return num;
      });
    }
    return matrix;
  }

  function formatMatrix(mat) {
    if(!mat || mat.length === 0) return '';
    const rows = mat.map(row =>
      row.map(val => smartFormat(val)).join(' & ')
    );
    return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}';
  }

  function formatPartialMatrix(C, currentRow, currentCol) {
    const m = C.length;
    const n = C[0] ? C[0].length : 0;
    const rows = [];
    for(let i = 0; i < m; i++) {
      const row = [];
      for(let j = 0; j < n; j++) {
        if(i < currentRow || (i === currentRow && j <= currentCol)) {
          if(C[i] && C[i][j] !== undefined) {
            row.push('\\textcolor{green}{' + smartFormat(C[i][j]) + '}');
          } else {
            row.push('?');
          }
        } else {
          row.push('?');
        }
      }
      rows.push(row.join(' & '));
    }
    return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}';
  }

  function addMatrices(A, B, withSteps = false) {
    const m = A.length;
    const n = A[0].length;
    const C = Array(m).fill(0).map(() => Array(n).fill(undefined));
    const steps = [];

    if(withSteps) {
      steps.push(`<div class="mb-2"><strong>Matrix A:</strong></div><div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>`);
      steps.push(`<div class="mb-2"><strong>Matrix B:</strong></div><div class="matrix-display">$$B = ${formatMatrix(B)}$$</div>`);
      steps.push(`<div class="text-primary">Adding element-wise:</div><div class="matrix-display">$$c_{ij} = a_{ij} + b_{ij}$$</div>`);
    }

    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        C[i][j] = A[i][j] + B[i][j];
        if(withSteps) {
          steps.push(`<div class="text-secondary matrix-display">$$c_{${i+1},${j+1}} = ${smartFormat(A[i][j])} + ${smartFormat(B[i][j])} = ${smartFormat(C[i][j])}$$</div>`);

          // Show partial result matrix periodically
          const totalElements = m * n;
          const showFrequency = totalElements <= 9 ? 1 : (totalElements <= 16 ? 2 : 4);
          if((i * n + j + 1) % showFrequency === 0 || (i === m - 1 && j === n - 1)) {
            steps.push(`<div class="mt-2 mb-3"><strong>Result C so far:</strong></div><div class="matrix-display">$$C = ${formatPartialMatrix(C, i, j)}$$</div>`);
          }
        }
      }
    }

    return { result: C, steps };
  }

  function subtractMatrices(A, B, withSteps = false) {
    const m = A.length;
    const n = A[0].length;
    const C = Array(m).fill(0).map(() => Array(n).fill(undefined));
    const steps = [];

    if(withSteps) {
      steps.push(`<div class="mb-2"><strong>Matrix A:</strong></div><div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>`);
      steps.push(`<div class="mb-2"><strong>Matrix B:</strong></div><div class="matrix-display">$$B = ${formatMatrix(B)}$$</div>`);
      steps.push(`<div class="text-primary">Subtracting element-wise:</div><div class="matrix-display">$$c_{ij} = a_{ij} - b_{ij}$$</div>`);
    }

    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        C[i][j] = A[i][j] - B[i][j];
        if(withSteps) {
          steps.push(`<div class="text-secondary matrix-display">$$c_{${i+1},${j+1}} = ${smartFormat(A[i][j])} - ${smartFormat(B[i][j])} = ${smartFormat(C[i][j])}$$</div>`);

          const totalElements = m * n;
          const showFrequency = totalElements <= 9 ? 1 : (totalElements <= 16 ? 2 : 4);
          if((i * n + j + 1) % showFrequency === 0 || (i === m - 1 && j === n - 1)) {
            steps.push(`<div class="mt-2 mb-3"><strong>Result C so far:</strong></div><div class="matrix-display">$$C = ${formatPartialMatrix(C, i, j)}$$</div>`);
          }
        }
      }
    }

    return { result: C, steps };
  }

  function scalarMultiply(c, A, withSteps = false) {
    const m = A.length;
    const n = A[0].length;
    const C = Array(m).fill(0).map(() => Array(n).fill(undefined));
    const steps = [];

    if(withSteps) {
      steps.push(`<div class="text-primary">Scalar: c = ${smartFormat(c)}</div>`);
      steps.push(`<div class="mb-2"><strong>Matrix A:</strong></div><div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>`);
      steps.push(`<div class="text-primary">Multiplying each element by ${smartFormat(c)}:</div><div class="matrix-display">$$c_{ij} = ${smartFormat(c)} \\times a_{ij}$$</div>`);
    }

    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        C[i][j] = c * A[i][j];
        if(withSteps) {
          steps.push(`<div class="text-secondary matrix-display">$$c_{${i+1},${j+1}} = ${smartFormat(c)} \\times ${smartFormat(A[i][j])} = ${smartFormat(C[i][j])}$$</div>`);

          const totalElements = m * n;
          const showFrequency = totalElements <= 9 ? 1 : (totalElements <= 16 ? 2 : 4);
          if((i * n + j + 1) % showFrequency === 0 || (i === m - 1 && j === n - 1)) {
            steps.push(`<div class="mt-2 mb-3"><strong>Result C so far:</strong></div><div class="matrix-display">$$C = ${formatPartialMatrix(C, i, j)}$$</div>`);
          }
        }
      }
    }

    return { result: C, steps };
  }

  function linearCombination(a, A, b, B, withSteps = false) {
    const m = A.length;
    const n = A[0].length;
    const C = Array(m).fill(0).map(() => Array(n).fill(undefined));
    const steps = [];

    if(withSteps) {
      steps.push(`<div class="text-primary">Linear Combination: ${smartFormat(a)}A + ${smartFormat(b)}B</div>`);
      steps.push(`<div class="mb-2"><strong>Matrix A:</strong></div><div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>`);
      steps.push(`<div class="mb-2"><strong>Matrix B:</strong></div><div class="matrix-display">$$B = ${formatMatrix(B)}$$</div>`);
      steps.push(`<div class="text-primary">Computing:</div><div class="matrix-display">$$c_{ij} = ${smartFormat(a)} \\times a_{ij} + ${smartFormat(b)} \\times b_{ij}$$</div>`);
    }

    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        C[i][j] = a * A[i][j] + b * B[i][j];
        if(withSteps) {
          steps.push(`<div class="text-secondary matrix-display">$$c_{${i+1},${j+1}} = ${smartFormat(a)} \\times ${smartFormat(A[i][j])} + ${smartFormat(b)} \\times ${smartFormat(B[i][j])} = ${smartFormat(C[i][j])}$$</div>`);

          const totalElements = m * n;
          const showFrequency = totalElements <= 9 ? 1 : (totalElements <= 16 ? 2 : 4);
          if((i * n + j + 1) % showFrequency === 0 || (i === m - 1 && j === n - 1)) {
            steps.push(`<div class="mt-2 mb-3"><strong>Result C so far:</strong></div><div class="matrix-display">$$C = ${formatPartialMatrix(C, i, j)}$$</div>`);
          }
        }
      }
    }

    return { result: C, steps };
  }

  function calculate() {
    try {
      inputError.style.display = 'none';

      const m = parseInt(rows.value);
      const n = parseInt(cols.value);
      const op = operation.value;

      if(m < 1 || m > 10 || n < 1 || n > 10) {
        throw new Error('Matrix dimensions must be between 1 and 10');
      }

      const A = parseMatrix(matrixA.value, m, n);
      let result, steps, opLabel;

      if(op === 'add') {
        const B = parseMatrix(matrixB.value, m, n);
        ({ result, steps } = addMatrices(A, B, showSteps.checked));
        opLabel = 'A + B';
      } else if(op === 'subtract') {
        const B = parseMatrix(matrixB.value, m, n);
        ({ result, steps } = subtractMatrices(A, B, showSteps.checked));
        opLabel = 'A - B';
      } else if(op === 'scalar') {
        const c = parseFloat(scalarValue.value);
        if(isNaN(c)) throw new Error('Invalid scalar value');
        ({ result, steps } = scalarMultiply(c, A, showSteps.checked));
        opLabel = `${smartFormat(c)}A`;
      } else if(op === 'linear') {
        const B = parseMatrix(matrixB.value, m, n);
        const a = parseFloat(scalarA.value);
        const b = parseFloat(scalarB.value);
        if(isNaN(a) || isNaN(b)) throw new Error('Invalid scalar values');
        ({ result, steps } = linearCombination(a, A, b, B, showSteps.checked));
        opLabel = `${smartFormat(a)}A + ${smartFormat(b)}B`;
      }

      let html = `
        <div class="result-card">
          <div class="mb-3">
            <span class="operation-badge">${opLabel}</span>
            <span class="operation-badge">Dimensions: ${m}×${n}</span>
          </div>
          <div class="mb-2"><strong>Result:</strong></div>
          <div class="matrix-display">$$${formatMatrix(result)}$$</div>
        </div>
      `;

      resultArea.innerHTML = html;

      if(showSteps.checked && steps.length > 0) {
        let stepsHtml = '<div class="mb-4"><h5 class="text-dark">📋 Computation Process</h5></div>';
        steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card">
            <div class="d-flex align-items-start">
              <span class="step-number">${idx + 1}</span>
              <div class="step-description">${step}</div>
            </div>
          </div>`;
        });
        stepsArea.innerHTML = stepsHtml;
      } else {
        stepsArea.innerHTML = '<div class="text-muted">Enable "Show detailed steps" to see the computation process.</div>';
      }

      if(window.MathJax && window.MathJax.typesetPromise) {
        MathJax.typesetPromise([resultArea, stepsArea]).catch(err => console.error(err));
      }

    } catch(err) {
      inputError.textContent = err.message;
      inputError.style.display = 'block';
      resultArea.innerHTML = '<div class="alert alert-danger">Error: ' + err.message + '</div>';
      stepsArea.innerHTML = '';
    }
  }

  function clear() {
    matrixA.value = '';
    matrixB.value = '';
    resultArea.innerHTML = '<div class="text-center text-muted">Select an operation and enter matrices to see the result.</div>';
    stepsArea.innerHTML = '<div class="text-muted">Detailed computation steps will appear here.</div>';
    inputError.style.display = 'none';
  }

  function generateRandomA() {
    const m = parseInt(rows.value);
    const n = parseInt(cols.value);
    const rowsData = [];
    for(let i = 0; i < m; i++) {
      const row = [];
      for(let j = 0; j < n; j++) {
        row.push(Math.floor(Math.random() * 21 - 10));
      }
      rowsData.push(row.join(' '));
    }
    matrixA.value = rowsData.join('\n');
  }

  function generateRandomB() {
    const m = parseInt(rows.value);
    const n = parseInt(cols.value);
    const rowsData = [];
    for(let i = 0; i < m; i++) {
      const row = [];
      for(let j = 0; j < n; j++) {
        row.push(Math.floor(Math.random() * 21 - 10));
      }
      rowsData.push(row.join(' '));
    }
    matrixB.value = rowsData.join('\n');
  }

  function loadExample(type) {
    if(type === 'add') {
      operation.value = 'add';
      rows.value = 2; cols.value = 2;
      matrixA.value = '1 2\n3 4';
      matrixB.value = '5 6\n7 8';
    } else if(type === 'subtract') {
      operation.value = 'subtract';
      rows.value = 3; cols.value = 3;
      matrixA.value = '9 8 7\n6 5 4\n3 2 1';
      matrixB.value = '1 2 3\n4 5 6\n7 8 9';
    } else if(type === 'scalar') {
      operation.value = 'scalar';
      rows.value = 2; cols.value = 3;
      matrixA.value = '1 2 3\n4 5 6';
      scalarValue.value = '3';
    } else if(type === 'linear') {
      operation.value = 'linear';
      rows.value = 2; cols.value = 2;
      matrixA.value = '1 2\n3 4';
      matrixB.value = '5 6\n7 8';
      scalarA.value = '2';
      scalarB.value = '3';
    }
    updateOperationVisibility();
    calculate();
  }

  function updateOperationVisibility() {
    const op = operation.value;
    matrixBCard.style.display = (op === 'scalar') ? 'none' : 'block';
    scalarInputs.style.display = (op === 'scalar') ? 'block' : 'none';
    linearInputs.style.display = (op === 'linear') ? 'block' : 'none';
  }

  btnCalculate.addEventListener('click', calculate);
  btnClear.addEventListener('click', clear);
  btnRandomA.addEventListener('click', generateRandomA);
  btnRandomB.addEventListener('click', generateRandomB);
  operation.addEventListener('change', updateOperationVisibility);
  exampleButtons.forEach(btn => {
    btn.addEventListener('click', () => loadExample(btn.dataset.example));
  });

  // Share URL functionality
  const btnShareURL = document.getElementById('btnShareURL');
  if(btnShareURL) {
    btnShareURL.addEventListener('click', function() {
      try {
        const baseUrl = window.location.origin + window.location.pathname;
        const params = new URLSearchParams();
        params.set('op', operation.value);
        params.set('m', rows.value);
        params.set('n', cols.value);
        params.set('A', btoa(encodeURIComponent(matrixA.value.trim())));
        if(operation.value !== 'scalar') {
          params.set('B', btoa(encodeURIComponent(matrixB.value.trim())));
        }
        if(operation.value === 'scalar') {
          params.set('c', scalarValue.value);
        }
        if(operation.value === 'linear') {
          params.set('a', scalarA.value);
          params.set('b', scalarB.value);
        }

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
          });
        }
      } catch(err) {
        console.error('Error creating share URL:', err);
        alert('Failed to create share URL');
      }
    });
  }

  // Download Image functionality
  const btnDownloadImage = document.getElementById('btnDownloadImage');
  if(btnDownloadImage) {
    btnDownloadImage.addEventListener('click', async function() {
      const resultCard = document.querySelector('.card-body #resultArea').closest('.card');
      if(!resultCard || !resultCard.querySelector('.result-card')) {
        alert('No result to download. Please calculate first.');
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
          filter: (node) => {
            if(node.tagName === 'SCRIPT') return false;
            if(node.classList && node.classList.contains('MathJax_Preview')) return false;
            return true;
          }
        });

        const link = document.createElement('a');
        const timestamp = new Date().toISOString().slice(0, 10);
        link.download = `matrix-addition-${timestamp}.png`;
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
    if(urlParams.has('A')) {
      try {
        operation.value = urlParams.get('op') || 'add';
        rows.value = urlParams.get('m') || 2;
        cols.value = urlParams.get('n') || 2;
        matrixA.value = decodeURIComponent(atob(urlParams.get('A')));
        if(urlParams.has('B')) {
          matrixB.value = decodeURIComponent(atob(urlParams.get('B')));
        }
        if(urlParams.has('c')) scalarValue.value = urlParams.get('c');
        if(urlParams.has('a')) scalarA.value = urlParams.get('a');
        if(urlParams.has('b')) scalarB.value = urlParams.get('b');
        updateOperationVisibility();
        setTimeout(() => calculate(), 100);
        return true;
      } catch(err) {
        console.error('Error loading from URL:', err);
      }
    }
    return false;
  }

  if(!loadFromURL()) {
    loadExample('add');
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
  <h2 class="h5">Matrix Addition & Subtraction: FAQ</h2>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">How do you add and subtract matrices?</h3>
    <p class="mb-0">Addition and subtraction are element‑wise and require the same dimensions. For result C, c<sub>i,j</sub> = a<sub>i,j</sub> ± b<sub>i,j</sub>. Addition is commutative and associative.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What is scalar multiplication and a linear combination?</h3>
    <p class="mb-0">Scalar multiplication multiplies each entry by a constant c. Linear combinations have the form aA + bB with matching dimensions, fundamental for many linear algebra applications.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What sizes are supported?</h3>
    <p class="mb-0">This tool supports matrices up to 10×10 and shows element‑wise steps for A+B, A−B, cA, and aA+bB.</p>
  </div></div>
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"How do you add and subtract matrices?","acceptedAnswer":{"@type":"Answer","text":"Addition and subtraction are element‑wise and require the same dimensions. For result C, c i,j = a i,j ± b i,j. Addition is commutative and associative."}},
    {"@type":"Question","name":"What is scalar multiplication and a linear combination?","acceptedAnswer":{"@type":"Answer","text":"Scalar multiplication multiplies each entry by a constant c. Linear combinations have the form aA + bB with matching dimensions, fundamental for many linear algebra applications."}},
    {"@type":"Question","name":"What sizes are supported?","acceptedAnswer":{"@type":"Answer","text":"This tool supports matrices up to 10×10 and shows element‑wise steps for A+B, A−B, cA, and aA+bB."}}
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Matrix Addition Calculator","item":"https://8gwifi.org/matrix-addition-calculator.jsp"}
  ]
}
</script>
</div>
<%@ include file="body-close.jsp"%>
</html>
