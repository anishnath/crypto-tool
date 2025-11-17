<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Matrix Transpose Calculator A^T | Symmetric Matrix Checker & Properties Verifier</title>
  <meta name="description" content="Calculate matrix transpose A^T instantly with our free calculator. Check symmetric and skew-symmetric matrices, verify transpose properties like (AB)^T = B^T A^T, and get detailed step-by-step solutions.">
  <meta name="keywords" content="matrix transpose calculator, A^T calculator, transpose matrix, symmetric matrix checker, skew-symmetric matrix, transpose properties, matrix transposition, (A^T)^T = A, orthogonal matrix, linear algebra calculator">
  <link rel="canonical" href="https://8gwifi.org/matrix-transpose-calculator.jsp">

  <!-- Open Graph Meta Tags -->
  <meta property="og:title" content="FREE Matrix Transpose Calculator A^T | Symmetric Matrix Checker">
  <meta property="og:description" content="Calculate matrix transpose A^T and check for symmetric and skew-symmetric properties. Verify transpose rules with detailed step-by-step solutions.">
  <meta property="og:url" content="https://8gwifi.org/matrix-transpose-calculator.jsp">
  <meta property="og:type" content="website">

  <!-- JSON-LD WebApplication Schema -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Matrix Transpose Calculator (A^T)",
    "applicationCategory": "UtilitiesApplication",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free online matrix transpose calculator that computes A^T by swapping rows and columns. Includes automatic detection of symmetric and skew-symmetric matrices with property verification.",
    "url": "https://8gwifi.org/matrix-transpose-calculator.jsp",
    "featureList": [
      "Calculate transpose A^T for any matrix dimensions",
      "Automatic symmetric matrix detection (A = A^T)",
      "Skew-symmetric matrix identification (A = -A^T)",
      "Verify double transpose property (A^T)^T = A",
      "Step-by-step element swapping visualization",
      "Support for rectangular and square matrices up to 10×10",
      "Visual representation of row-column interchange",
      "Property badges showing matrix characteristics"
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
        "name": "What is a matrix transpose and how do you calculate A^T?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "The transpose of a matrix A, denoted A^T, is formed by interchanging its rows and columns. If A is an m×n matrix, then A^T is an n×m matrix where (A^T)(i,j) = A(j,i). For example, if A = [[1,2,3],[4,5,6]], then A^T = [[1,4],[2,5],[3,6]]. Key properties include: (A^T)^T = A (double transpose returns original), (A+B)^T = A^T + B^T (transpose distributes over addition), and (AB)^T = B^T A^T (note the order reversal for products). A matrix is symmetric if A = A^T and skew-symmetric if A = -A^T."
        }
      },
      {
        "@type": "Question",
        "name": "What are symmetric and skew-symmetric matrices and their properties?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "A symmetric matrix satisfies A = A^T, meaning it's equal to its own transpose. This occurs when a(i,j) = a(j,i) for all elements. Symmetric matrices appear in: covariance matrices in statistics, adjacency matrices of undirected graphs, moment of inertia tensors in physics, and quadratic forms. A skew-symmetric (or antisymmetric) matrix satisfies A = -A^T, meaning a(i,j) = -a(j,i). All diagonal elements must be zero. These appear in: cross product operations, infinitesimal rotations in mechanics, and electromagnetic field tensors. Every square matrix can be uniquely decomposed as the sum of a symmetric and skew-symmetric matrix: A = (A+A^T)/2 + (A-A^T)/2."
        }
      }
    ]
  }
  </script>

  <%@ include file="header-script.jsp"%>
    <%@ include file="math-menu-nav.jsp"%>
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
    .transpose-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .transpose-calc .card-body{padding:.7rem .9rem}
    .transpose-calc .result-card{border-left:4px solid #10b981;background:linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(16,185,129,0.1)}
    .transpose-calc .property-card{border-left:4px solid #8b5cf6;background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(139,92,246,0.1)}
    .transpose-calc .property-badge{
      display:inline-flex;
      align-items:center;
      padding:0.4rem 0.8rem;
      border-radius:999px;
      font-size:0.9rem;
      font-weight:600;
      margin:0.25rem;
    }
    .property-badge.true{background:#d1fae5;color:#065f46}
    .property-badge.false{background:#fee2e2;color:#991b1b}
    .transpose-calc .step-card{
      border-left:4px solid #6366f1;
      background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);
      padding:1rem 1.25rem;
      margin:0.75rem 0;
      border-radius:8px;
      box-shadow:0 1px 3px rgba(99,102,241,0.08);
      transition:all 0.2s ease;
    }
    .transpose-calc .step-card:hover{
      box-shadow:0 4px 12px rgba(99,102,241,0.15);
      transform:translateX(2px);
    }
    .transpose-calc .matrix-display{
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
      .transpose-calc h1{font-size:1.5rem}
      .transpose-calc .card-header{font-size:0.95rem}
      .transpose-calc button{width:100%;margin:0.25rem 0}
      .transpose-calc .step-card{padding:0.75rem}
      .transpose-calc .matrix-display{padding:0.5rem;font-size:0.9em}
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 transpose-calc">
  <h1 class="mb-2">Matrix Transpose Calculator (A^T)</h1>
  <p class="text-muted mb-3">Calculate matrix transpose, check symmetry, and verify transpose properties.</p>

  <div class="row">
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header">Matrix Input</h5>
        <div class="card-body">
          <div class="form-group">
            <label>Dimensions (m × n)</label>
            <div class="d-flex">
              <input id="rows" type="number" min="1" max="10" class="form-control mr-1" value="3" placeholder="rows">
              <span class="mx-1 mt-2">×</span>
              <input id="cols" type="number" min="1" max="10" class="form-control ml-1" value="2" placeholder="cols">
            </div>
          </div>

          <div class="form-group">
            <label for="matrixInput">Matrix Entries</label>
            <textarea id="matrixInput" class="form-control" rows="6" placeholder="1 2
3 4
5 6"></textarea>
            <small class="text-muted">One row per line, space separated</small>
          </div>

          <button id="btnRandom" class="btn btn-outline-info btn-sm btn-block mb-2">
            <i class="fas fa-random"></i> Random Matrix
          </button>
        </div>
      </div>

      <div class="card mb-3">
        <div class="card-body">
          <div class="form-group">
            <div class="custom-control custom-checkbox">
              <input type="checkbox" class="custom-control-input" id="showProperties" checked>
              <label class="custom-control-label" for="showProperties">Show matrix properties</label>
            </div>
            <div class="custom-control custom-checkbox">
              <input type="checkbox" class="custom-control-input" id="showSteps" checked>
              <label class="custom-control-label" for="showSteps">Show detailed steps</label>
            </div>
          </div>

          <div class="d-flex flex-wrap">
            <button id="btnCalculate" class="btn btn-primary btn-sm mr-2 mb-2">
              <i class="fas fa-exchange-alt"></i> Calculate A^T
            </button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm mb-2">Clear</button>
          </div>
          <div id="inputError" class="text-danger small mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Quick Examples</h5>
        <div class="card-body">
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="rect">Rectangular (3×2)</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="symmetric">Symmetric (3×3)</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="skew">Skew-Symmetric (3×3)</button>
          <button class="btn btn-outline-primary btn-sm btn-block" data-example="square">Square (4×4)</button>
        </div>
      </div>
    </div>

    <div class="col-lg-8 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header d-flex flex-wrap justify-content-between align-items-center">
          <span class="mb-1 mb-sm-0">Result: A^T</span>
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
            Enter a matrix and click "Calculate A^T" to see the transpose.
          </div>
        </div>
      </div>

      <div class="card mb-3" id="propertiesCard" style="display:none">
        <h5 class="card-header">🔍 Matrix Properties</h5>
        <div class="card-body">
          <div id="propertiesArea"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">📋 Computation Steps</h5>
        <div class="card-body">
          <div id="stepsArea" class="text-muted">
            Detailed transpose computation steps will appear here.
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
            <a href="matrix-addition-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-plus"></i> Matrix Addition
            </a>
            <a href="matrix-power-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-superscript"></i> Matrix Powers
            </a>
            <a href="matrix-inverse-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-sync"></i> Matrix Inverse
            </a>
            <a href="matrix-type-classifier.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-tag"></i> Matrix Types
            </a>
            <a href="matrix-determinant-calculator.jsp" class="btn btn-sm btn-outline-primary mb-2">
              <i class="fas fa-calculator"></i> Determinant
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
  const matrixInput = document.getElementById('matrixInput');
  const showProperties = document.getElementById('showProperties');
  const showSteps = document.getElementById('showSteps');
  const btnCalculate = document.getElementById('btnCalculate');
  const btnClear = document.getElementById('btnClear');
  const btnRandom = document.getElementById('btnRandom');
  const resultArea = document.getElementById('resultArea');
  const propertiesCard = document.getElementById('propertiesCard');
  const propertiesArea = document.getElementById('propertiesArea');
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

  function formatPartialTranspose(AT, currentRow, currentCol, n, m) {
    const rows = [];
    for(let j = 0; j < n; j++) {
      const row = [];
      for(let i = 0; i < m; i++) {
        if(j < currentRow || (j === currentRow && i <= currentCol)) {
          if(AT[j] && AT[j][i] !== undefined) {
            row.push('\\textcolor{purple}{' + smartFormat(AT[j][i]) + '}');
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

  function transposeMatrix(A, withSteps = false) {
    const m = A.length;
    const n = A[0].length;
    const AT = Array(n).fill(0).map(() => Array(m).fill(undefined));
    const steps = [];

    if(withSteps) {
      steps.push(`<div class="text-primary">Transposing ${m}×${n} matrix A</div>`);
      steps.push(`<div class="mb-2"><strong>Original Matrix A:</strong></div><div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>`);
      steps.push(`<div class="text-primary">Creating A^T (${n}×${m}) by swapping rows and columns:</div><div class="matrix-display">$$(A^T)_{ij} = A_{ji}$$</div>`);
    }

    for(let j = 0; j < n; j++) {
      for(let i = 0; i < m; i++) {
        AT[j][i] = A[i][j];
        if(withSteps) {
          steps.push(`<div class="text-secondary matrix-display">$$(A^T)_{${j+1},${i+1}} = A_{${i+1},${j+1}} = ${smartFormat(A[i][j])}$$</div>`);

          // Show partial transpose matrix periodically
          const totalElements = n * m;
          const showFrequency = totalElements <= 9 ? 1 : (totalElements <= 16 ? 2 : 4);
          if((j * m + i + 1) % showFrequency === 0 || (j === n - 1 && i === m - 1)) {
            steps.push(`<div class="mt-2 mb-3"><strong>Transpose A^T so far:</strong></div><div class="matrix-display">$$A^T = ${formatPartialTranspose(AT, j, i, n, m)}$$</div>`);
          }
        }
      }
    }

    return { transpose: AT, steps };
  }

  function checkProperties(A, AT) {
    const m = A.length;
    const n = A[0].length;
    const properties = [];

    // Check if symmetric
    if(m === n) {
      let isSymmetric = true;
      for(let i = 0; i < m && isSymmetric; i++) {
        for(let j = 0; j < n; j++) {
          if(Math.abs(A[i][j] - A[j][i]) > EPS) {
            isSymmetric = false;
            break;
          }
        }
      }
      properties.push({
        name: 'Symmetric',
        value: isSymmetric,
        description: isSymmetric ? 'A = A^T' : 'A ≠ A^T'
      });

      // Check if skew-symmetric
      let isSkewSymmetric = true;
      for(let i = 0; i < m && isSkewSymmetric; i++) {
        for(let j = 0; j < n; j++) {
          if(Math.abs(A[i][j] + A[j][i]) > EPS) {
            isSkewSymmetric = false;
            break;
          }
        }
      }
      properties.push({
        name: 'Skew-Symmetric',
        value: isSkewSymmetric,
        description: isSkewSymmetric ? 'A = -A^T' : 'A ≠ -A^T'
      });
    }

    // Check if (A^T)^T = A
    let doubleTransposeCorrect = true;
    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        if(Math.abs(AT[j][i] - A[i][j]) > EPS) {
          doubleTransposeCorrect = false;
          break;
        }
      }
    }
    properties.push({
      name: '(A^T)^T = A',
      value: doubleTransposeCorrect,
      description: doubleTransposeCorrect ? 'Double transpose property holds' : 'Error in transpose'
    });

    return properties;
  }

  function calculate() {
    try {
      inputError.style.display = 'none';

      const m = parseInt(rows.value);
      const n = parseInt(cols.value);

      if(m < 1 || m > 10 || n < 1 || n > 10) {
        throw new Error('Matrix dimensions must be between 1 and 10');
      }

      const A = parseMatrix(matrixInput.value, m, n);
      const { transpose, steps } = transposeMatrix(A, showSteps.checked);

      let html = `
        <div class="result-card">
          <div class="mb-3">
            <span class="property-badge" style="background:#dbeafe;color:#1e40af">Original: ${m}×${n}</span>
            <span class="property-badge" style="background:#fef3c7;color:#92400e">Transpose: ${n}×${m}</span>
          </div>
          <div class="mb-2"><strong>Matrix A:</strong></div>
          <div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>
          <div class="mb-2 mt-4"><strong>Transpose A^T:</strong></div>
          <div class="matrix-display">$$A^T = ${formatMatrix(transpose)}$$</div>
        </div>
      `;

      resultArea.innerHTML = html;

      // Show properties
      if(showProperties.checked) {
        const properties = checkProperties(A, transpose);
        let propHtml = '<div class="property-card">';
        properties.forEach(prop => {
          const badgeClass = prop.value ? 'true' : 'false';
          const icon = prop.value ? '✓' : '✗';
          propHtml += `
            <div class="d-flex justify-content-between align-items-center mb-2">
              <span><strong>${prop.name}:</strong> ${prop.description}</span>
              <span class="property-badge ${badgeClass}">${icon} ${prop.value ? 'True' : 'False'}</span>
            </div>
          `;
        });
        propHtml += '</div>';
        propertiesArea.innerHTML = propHtml;
        propertiesCard.style.display = 'block';
      } else {
        propertiesCard.style.display = 'none';
      }

      // Show steps
      if(showSteps.checked && steps.length > 0) {
        let stepsHtml = '<div class="mb-4"><h5 class="text-dark">📋 Transpose Process</h5></div>';
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
        stepsArea.innerHTML = '<div class="text-muted">Enable "Show detailed steps" to see the transpose process.</div>';
      }

      if(window.MathJax && window.MathJax.typesetPromise) {
        MathJax.typesetPromise([resultArea, propertiesArea, stepsArea]).catch(err => console.error(err));
      }

    } catch(err) {
      inputError.textContent = err.message;
      inputError.style.display = 'block';
      resultArea.innerHTML = '<div class="alert alert-danger">Error: ' + err.message + '</div>';
      stepsArea.innerHTML = '';
      propertiesCard.style.display = 'none';
    }
  }

  function clear() {
    matrixInput.value = '';
    resultArea.innerHTML = '<div class="text-center text-muted">Enter a matrix and click "Calculate A^T" to see the transpose.</div>';
    stepsArea.innerHTML = '<div class="text-muted">Detailed transpose computation steps will appear here.</div>';
    propertiesCard.style.display = 'none';
    inputError.style.display = 'none';
  }

  function generateRandom() {
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
    matrixInput.value = rowsData.join('\n');
    setTimeout(() => calculate(), 100);
  }

  function loadExample(type) {
    if(type === 'rect') {
      rows.value = 3; cols.value = 2;
      matrixInput.value = '1 2\n3 4\n5 6';
    } else if(type === 'symmetric') {
      rows.value = 3; cols.value = 3;
      matrixInput.value = '4 1 2\n1 5 3\n2 3 6';
    } else if(type === 'skew') {
      rows.value = 3; cols.value = 3;
      matrixInput.value = '0 2 -3\n-2 0 4\n3 -4 0';
    } else if(type === 'square') {
      rows.value = 4; cols.value = 4;
      matrixInput.value = '1 2 3 4\n5 6 7 8\n9 10 11 12\n13 14 15 16';
    }
    calculate();
  }

  btnCalculate.addEventListener('click', calculate);
  btnClear.addEventListener('click', clear);
  btnRandom.addEventListener('click', generateRandom);
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
        params.set('m', rows.value);
        params.set('n', cols.value);
        params.set('matrix', btoa(encodeURIComponent(matrixInput.value.trim())));

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
        alert('No result to download. Please calculate transpose first.');
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
        link.download = `matrix-transpose-${timestamp}.png`;
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
    if(urlParams.has('matrix')) {
      try {
        rows.value = urlParams.get('m') || 3;
        cols.value = urlParams.get('n') || 2;
        matrixInput.value = decodeURIComponent(atob(urlParams.get('matrix')));
        setTimeout(() => calculate(), 100);
        return true;
      } catch(err) {
        console.error('Error loading from URL:', err);
      }
    }
    return false;
  }

  if(!loadFromURL()) {
    loadExample('rect');
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
</html>
