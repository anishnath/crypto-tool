<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Matrix Multiplication Calculator Online – Free | 8gwifi.org</title>
  <meta name="description" content="Multiply matrices A×B instantly with our free calculator. Features dimension compatibility checker, step-by-step solutions, visual computation process, and support for any matrix sizes up to 10×10.">
  <meta name="keywords" content="matrix multiplication calculator, A×B calculator, matrix multiply, matrix product, linear algebra calculator, step by step matrix multiplication, matrix dimensions, compatible matrices, dot product, matrix operations">
  <link rel="canonical" href="https://8gwifi.org/matrix-multiplication-calculator.jsp">

  <!-- Open Graph Meta Tags -->
  <meta property="og:title" content="Matrix Multiplication Calculator Online – Free | 8gwifi.org">
  <meta property="og:description" content="Multiply matrices A×B with detailed step-by-step solutions. Check dimension compatibility and visualize the entire computation process for any matrix sizes.">
  <meta property="og:url" content="https://8gwifi.org/matrix-multiplication-calculator.jsp">
  <meta property="og:type" content="website">

  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Matrix Multiplication Calculator Online – Free | 8gwifi.org">
  <meta name="twitter:description" content="Multiply matrices A×B with compatibility checks and step-by-step computations up to 10×10.">

  <!-- JSON-LD WebApplication Schema -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Matrix Multiplication Calculator (A×B)",
    "applicationCategory": "UtilitiesApplication",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free online matrix multiplication calculator that computes the product C = A×B with automatic dimension compatibility checking and step-by-step solutions.",
    "url": "https://8gwifi.org/matrix-multiplication-calculator.jsp",
    "featureList": [
      "Multiply matrices of any compatible dimensions up to 10×10",
      "Automatic dimension compatibility verification (columns of A = rows of B)",
      "Step-by-step computation showing each element calculation",
      "Visual representation of partial results during computation",
      "Support for rectangular and square matrices",
      "Detailed explanation of dot product calculations",
      "Random matrix generation for testing",
      "Export results as images for documentation"
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
    .matmul-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .matmul-calc .card-body{padding:.7rem .9rem}
    .matmul-calc .result-card{border-left:4px solid #10b981;background:linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(16,185,129,0.1)}
    .matmul-calc .dimension-badge{
      display:inline-flex;
      align-items:center;
      padding:0.4rem 0.8rem;
      border-radius:999px;
      font-size:0.9rem;
      font-weight:600;
      background:#dbeafe;
      color:#1e40af;
      margin:0.25rem;
    }
    .matmul-calc .compatible{background:#d1fae5;color:#065f46}
    .matmul-calc .incompatible{background:#fee2e2;color:#991b1b}
    .matmul-calc .step-card{
      border-left:4px solid #6366f1;
      background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);
      padding:1rem 1.25rem;
      margin:0.75rem 0;
      border-radius:8px;
      box-shadow:0 1px 3px rgba(99,102,241,0.08);
      transition:all 0.2s ease;
    }
    .matmul-calc .step-card:hover{
      box-shadow:0 4px 12px rgba(99,102,241,0.15);
      transform:translateX(2px);
    }
    .matmul-calc .matrix-display{
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
      .matmul-calc h1{font-size:1.5rem}
      .matmul-calc .card-header{font-size:0.95rem}
      .matmul-calc button{width:100%;margin:0.25rem 0}
      .matmul-calc .step-card{padding:0.75rem}
      .matmul-calc .matrix-display{padding:0.5rem;font-size:0.9em}
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
<div class="container mt-4 matmul-calc">
  <h1 class="mb-2">Matrix Multiplication Calculator (A × B)</h1>
  <p class="text-muted mb-3">Multiply two matrices with step-by-step visualization. Supports any compatible dimensions.</p>

  <div class="row">
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header">Matrix A</h5>
        <div class="card-body">
          <div class="form-group">
            <label>Dimensions (m × n)</label>
            <div class="d-flex">
              <input id="rowsA" type="number" min="1" max="10" class="form-control mr-1" value="2" placeholder="rows">
              <span class="mx-1 mt-2">×</span>
              <input id="colsA" type="number" min="1" max="10" class="form-control ml-1" value="3" placeholder="cols">
            </div>
          </div>

          <div class="form-group">
            <label for="matrixA">Matrix A Entries</label>
            <textarea id="matrixA" class="form-control" rows="4" placeholder="1 2 3
4 5 6"></textarea>
            <small class="text-muted">One row per line, space separated</small>
          </div>

          <button id="btnRandomA" class="btn btn-outline-info btn-sm btn-block mb-2">
            <i class="fas fa-random"></i> Random Matrix A
          </button>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Matrix B</h5>
        <div class="card-body">
          <div class="form-group">
            <label>Dimensions (p × q)</label>
            <div class="d-flex">
              <input id="rowsB" type="number" min="1" max="10" class="form-control mr-1" value="3" placeholder="rows">
              <span class="mx-1 mt-2">×</span>
              <input id="colsB" type="number" min="1" max="10" class="form-control ml-1" value="2" placeholder="cols">
            </div>
          </div>

          <div class="form-group">
            <label for="matrixB">Matrix B Entries</label>
            <textarea id="matrixB" class="form-control" rows="4" placeholder="1 2
3 4
5 6"></textarea>
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
            <button id="btnMultiply" class="btn btn-primary btn-sm mr-2 mb-2">
              <i class="fas fa-calculator"></i> Multiply A × B
            </button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm mb-2">Clear</button>
          </div>
          <div id="inputError" class="text-danger small mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Quick Examples</h5>
        <div class="card-body">
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="2x2">2×2 × 2×2</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="2x3">2×3 × 3×2</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="3x3">3×3 × 3×3</button>
          <button class="btn btn-outline-primary btn-sm btn-block" data-example="incompatible">Incompatible (Error Demo)</button>
        </div>
      </div>
    </div>

    <div class="col-lg-8 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header d-flex flex-wrap justify-content-between align-items-center">
          <span class="mb-1 mb-sm-0">Result: A × B</span>
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
            Enter two matrices and click "Multiply A × B" to see the result.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">📋 Computation Steps</h5>
        <div class="card-body">
          <div id="stepsArea" class="text-muted">
            Detailed multiplication steps will appear here.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">📚 Related Matrix Tools</h5>
        <div class="card-body">
          <div class="d-flex flex-wrap">
            <a href="matrix-addition-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-plus"></i> Matrix Addition
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
            <a href="matrix-eigenvalue-calculator.jsp" class="btn btn-sm btn-outline-primary mb-2">
              <i class="fas fa-wave-square"></i> Eigenvalues
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
  const rowsA = document.getElementById('rowsA');
  const colsA = document.getElementById('colsA');
  const matrixA = document.getElementById('matrixA');
  const rowsB = document.getElementById('rowsB');
  const colsB = document.getElementById('colsB');
  const matrixB = document.getElementById('matrixB');
  const showSteps = document.getElementById('showSteps');
  const btnMultiply = document.getElementById('btnMultiply');
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

  function parseMatrix(text, rows, cols) {
    const lines = text.trim().split('\n').filter(r => r.trim());
    if(lines.length !== rows) {
      throw new Error(`Expected ${rows} rows, got ${lines.length}`);
    }
    const matrix = [];
    for(let i = 0; i < rows; i++) {
      const entries = lines[i].trim().split(/[\s,]+/).filter(Boolean);
      if(entries.length !== cols) {
        throw new Error(`Row ${i+1}: Expected ${cols} columns, got ${entries.length}`);
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
    const q = C[0] ? C[0].length : 0;
    const rows = [];
    for(let i = 0; i < m; i++) {
      const row = [];
      for(let j = 0; j < q; j++) {
        if(i < currentRow || (i === currentRow && j <= currentCol)) {
          if(C[i] && C[i][j] !== undefined) {
            row.push('\\textcolor{blue}{' + smartFormat(C[i][j]) + '}');
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

  function multiplyMatrices(A, B, withSteps = false) {
    const m = A.length;
    const n = A[0].length;
    const p = B.length;
    const q = B[0].length;

    if(n !== p) {
      throw new Error(`Incompatible dimensions: (${m}×${n}) × (${p}×${q}). Columns of A (${n}) must equal rows of B (${p}).`);
    }

    const C = Array(m).fill(0).map(() => Array(q).fill(undefined));
    const steps = [];

    if(withSteps) {
      steps.push(`<span class="text-primary">Matrix A is ${m}×${n}, Matrix B is ${p}×${q}</span>`);
      steps.push(`<span class="text-success">✓ Compatible! Result C will be ${m}×${q}</span>`);
      steps.push(`<div class="mt-3 mb-2"><strong>Matrix A:</strong></div><div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>`);
      steps.push(`<div class="mt-3 mb-2"><strong>Matrix B:</strong></div><div class="matrix-display">$$B = ${formatMatrix(B)}$$</div>`);
      steps.push(`<div class="mt-4 text-primary">Computing C = A × B, where:</div><div class="matrix-display">$$c_{ij} = \\sum_{k=1}^{${n}} a_{ik} \\cdot b_{kj}$$</div>`);
    }

    for(let i = 0; i < m; i++) {
      for(let j = 0; j < q; j++) {
        let sum = 0;
        let computation = [];

        for(let k = 0; k < n; k++) {
          sum += A[i][k] * B[k][j];
          computation.push(`(${smartFormat(A[i][k])})(${smartFormat(B[k][j])})`);
        }

        C[i][j] = sum;

        if(withSteps) {
          const expr = computation.join(' + ');
          steps.push(`<div class="text-secondary matrix-display">$$c_{${i+1},${j+1}} = ${expr} = ${smartFormat(sum)}$$</div>`);

          // Show partial result matrix every few computations (for small matrices show more, for large show less)
          const showFrequency = m * q <= 9 ? 1 : (m * q <= 16 ? 2 : 3);
          if((i * q + j + 1) % showFrequency === 0 || (i === m - 1 && j === q - 1)) {
            steps.push(`<div class="mt-2 mb-3"><strong>Result C so far:</strong></div><div class="matrix-display">$$C = ${formatPartialMatrix(C, i, j)}$$</div>`);
          }
        }
      }
    }

    return { result: C, steps };
  }

  function multiply() {
    try {
      inputError.style.display = 'none';

      const m = parseInt(rowsA.value);
      const n = parseInt(colsA.value);
      const p = parseInt(rowsB.value);
      const q = parseInt(colsB.value);

      if(m < 1 || m > 10 || n < 1 || n > 10) {
        throw new Error('Matrix A dimensions must be between 1 and 10');
      }
      if(p < 1 || p > 10 || q < 1 || q > 10) {
        throw new Error('Matrix B dimensions must be between 1 and 10');
      }

      const A = parseMatrix(matrixA.value, m, n);
      const B = parseMatrix(matrixB.value, p, q);

      const { result, steps } = multiplyMatrices(A, B, showSteps.checked);

      const compatClass = n === p ? 'compatible' : 'incompatible';
      const compatText = n === p ? '✓ Compatible' : '✗ Incompatible';

      let html = `
        <div class="result-card">
          <div class="mb-3">
            <span class="dimension-badge">A: ${m}×${n}</span>
            <span class="dimension-badge ${compatClass}">${compatText}</span>
            <span class="dimension-badge">B: ${p}×${q}</span>
            <span class="dimension-badge">→ C: ${m}×${q}</span>
          </div>
          <div class="mb-2"><strong>Result Matrix C = A × B:</strong></div>
          <div class="matrix-display">$$C = ${formatMatrix(result)}$$</div>
        </div>
      `;

      resultArea.innerHTML = html;

      if(showSteps.checked && steps.length > 0) {
        let stepsHtml = '<div class="mb-4"><h5 class="text-dark">📋 Multiplication Process</h5></div>';
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
    resultArea.innerHTML = '<div class="text-center text-muted">Enter two matrices and click "Multiply A × B" to see the result.</div>';
    stepsArea.innerHTML = '<div class="text-muted">Detailed multiplication steps will appear here.</div>';
    inputError.style.display = 'none';
  }

  function generateRandomA() {
    const m = parseInt(rowsA.value);
    const n = parseInt(colsA.value);
    const rows = [];
    for(let i = 0; i < m; i++) {
      const row = [];
      for(let j = 0; j < n; j++) {
        row.push(Math.floor(Math.random() * 21 - 10));
      }
      rows.push(row.join(' '));
    }
    matrixA.value = rows.join('\n');
  }

  function generateRandomB() {
    const p = parseInt(rowsB.value);
    const q = parseInt(colsB.value);
    const rows = [];
    for(let i = 0; i < p; i++) {
      const row = [];
      for(let j = 0; j < q; j++) {
        row.push(Math.floor(Math.random() * 21 - 10));
      }
      rows.push(row.join(' '));
    }
    matrixB.value = rows.join('\n');
  }

  function loadExample(type) {
    if(type === '2x2') {
      rowsA.value = 2; colsA.value = 2;
      matrixA.value = '1 2\n3 4';
      rowsB.value = 2; colsB.value = 2;
      matrixB.value = '5 6\n7 8';
    } else if(type === '2x3') {
      rowsA.value = 2; colsA.value = 3;
      matrixA.value = '1 2 3\n4 5 6';
      rowsB.value = 3; colsB.value = 2;
      matrixB.value = '7 8\n9 10\n11 12';
    } else if(type === '3x3') {
      rowsA.value = 3; colsA.value = 3;
      matrixA.value = '1 2 3\n4 5 6\n7 8 9';
      rowsB.value = 3; colsB.value = 3;
      matrixB.value = '9 8 7\n6 5 4\n3 2 1';
    } else if(type === 'incompatible') {
      rowsA.value = 2; colsA.value = 3;
      matrixA.value = '1 2 3\n4 5 6';
      rowsB.value = 2; colsB.value = 2;
      matrixB.value = '7 8\n9 10';
    }
    multiply();
  }

  btnMultiply.addEventListener('click', multiply);
  btnClear.addEventListener('click', clear);
  btnRandomA.addEventListener('click', generateRandomA);
  btnRandomB.addEventListener('click', generateRandomB);
  exampleButtons.forEach(btn => {
    btn.addEventListener('click', () => loadExample(btn.dataset.example));
  });

  // Auto-update compatible dimensions
  colsA.addEventListener('change', () => { rowsB.value = colsA.value; });
  rowsB.addEventListener('change', () => { colsA.value = rowsB.value; });

  // Share URL functionality
  const btnShareURL = document.getElementById('btnShareURL');
  if(btnShareURL) {
    btnShareURL.addEventListener('click', function() {
      try {
        const baseUrl = window.location.origin + window.location.pathname;
        const params = new URLSearchParams();
        params.set('m', rowsA.value);
        params.set('n', colsA.value);
        params.set('p', rowsB.value);
        params.set('q', colsB.value);
        params.set('A', btoa(encodeURIComponent(matrixA.value.trim())));
        params.set('B', btoa(encodeURIComponent(matrixB.value.trim())));

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
        } else {
          alert('URL: ' + shareUrl);
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
        alert('No result to download. Please multiply matrices first.');
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
            if(node.nodeType === Node.TEXT_NODE) {
              const text = node.textContent || '';
              if(text.includes('$$') || text.includes('\\begin{bmatrix}')) return false;
            }
            return true;
          }
        });

        const link = document.createElement('a');
        const timestamp = new Date().toISOString().slice(0, 10);
        link.download = `matrix-multiplication-${timestamp}.png`;
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
    if(urlParams.has('A') && urlParams.has('B')) {
      try {
        rowsA.value = urlParams.get('m') || 2;
        colsA.value = urlParams.get('n') || 2;
        rowsB.value = urlParams.get('p') || 2;
        colsB.value = urlParams.get('q') || 2;
        matrixA.value = decodeURIComponent(atob(urlParams.get('A')));
        matrixB.value = decodeURIComponent(atob(urlParams.get('B')));
        setTimeout(() => multiply(), 100);
        return true;
      } catch(err) {
        console.error('Error loading from URL:', err);
      }
    }
    return false;
  }

  if(!loadFromURL()) {
    loadExample('2x3');
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
  <h2 class="h5">Matrix Multiplication: FAQ</h2>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">When are two matrices compatible for A×B?</h3>
    <p class="mb-0">A×B is defined when columns(A) = rows(B). If A is m×n and B is n×p, the product C is m×p. Each c<sub>i,j</sub> is the dot product of row i of A with column j of B.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">Is A×B the same as B×A?</h3>
    <p class="mb-0">No. Matrix multiplication is generally not commutative: A×B ≠ B×A. It is associative and distributive, and obeys (AB)^T = B^T A^T.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What sizes are supported?</h3>
    <p class="mb-0">This tool supports rectangular and square matrices with dimensions up to 10×10, showing step‑by‑step computations.</p>
  </div></div>
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"When are two matrices compatible for A×B?","acceptedAnswer":{"@type":"Answer","text":"A×B is defined when columns(A) = rows(B). If A is m×n and B is n×p, the product C is m×p. Each c i,j is the dot product of row i of A with column j of B."}},
    {"@type":"Question","name":"Is A×B the same as B×A?","acceptedAnswer":{"@type":"Answer","text":"No. Matrix multiplication is generally not commutative: A×B ≠ B×A. It is associative and distributive, and obeys (AB)^T = B^T A^T."}},
    {"@type":"Question","name":"What sizes are supported?","acceptedAnswer":{"@type":"Answer","text":"This tool supports rectangular and square matrices with dimensions up to 10×10, showing step‑by‑step computations."}}
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Matrix Multiplication Calculator","item":"https://8gwifi.org/matrix-multiplication-calculator.jsp"}
  ]
}
</script>
</div>
<%@ include file="body-close.jsp"%>
</html>
