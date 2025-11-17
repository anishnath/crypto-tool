<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Matrix Inverse Calculator - A⁻¹ | Gauss-Jordan Method | 2×2 to 6×6</title>
  <meta name="description" content="Free matrix inverse calculator (A⁻¹) using Gauss-Jordan elimination. Step-by-step solutions for 2×2 to 6×6 invertible matrices. Shows augmented matrix [A|I] → [I|A⁻¹]. Singularity check, LaTeX display.">
  <meta name="keywords" content="matrix inverse calculator, inverse matrix, A inverse, Gauss-Jordan elimination, adjugate matrix, matrix inversion, linear algebra calculator, invertible matrix, A^-1">
  <link rel="canonical" href="https://8gwifi.org/matrix-inverse-calculator.jsp">

  <meta property="og:title" content="Matrix Inverse Calculator - Gauss-Jordan Method">
  <meta property="og:description" content="Calculate A⁻¹ for square invertible matrices with step-by-step Gauss-Jordan elimination.">
  <meta property="og:url" content="https://8gwifi.org/matrix-inverse-calculator.jsp">

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Matrix Inverse Calculator",
    "applicationCategory": "EducationalApplication",
    "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
    "description": "Calculate matrix inverse A⁻¹ using Gauss-Jordan elimination. Shows step-by-step augmented matrix transformation [A|I] → [I|A⁻¹].",
    "url": "https://8gwifi.org/matrix-inverse-calculator.jsp",
    "featureList": ["Gauss-Jordan elimination", "Singularity detection", "2×2 to 6×6 matrices", "Step-by-step solutions", "Verification A·A⁻¹=I", "Random generator"]
  }
  </script>

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [{
      "@type": "Question",
      "name": "How do I find the inverse of a matrix?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Enter your square matrix, click Calculate. The calculator uses Gauss-Jordan elimination on [A|I] to get [I|A⁻¹]. If det(A)=0, the matrix is singular (non-invertible)."
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
    .inverse-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .inverse-calc .card-body{padding:.7rem .9rem}
    .inverse-calc .result-card{border-left:4px solid #8b5cf6;background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(139,92,246,0.1)}
    .inverse-calc .verification-card{border-left:4px solid #10b981;background:linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(16,185,129,0.1)}
    .inverse-calc .step-card{
      border-left:4px solid #6366f1;
      background:linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
      padding:1rem 1.25rem;
      margin:0.75rem 0;
      border-radius:8px;
      box-shadow:0 1px 3px rgba(99,102,241,0.08);
      transition:all 0.2s ease;
    }
    .inverse-calc .step-card:hover{
      box-shadow:0 4px 12px rgba(99,102,241,0.15);
      transform:translateX(2px);
    }
    .inverse-calc .matrix-display{
      display:block;
      text-align:center;
      padding:0.75rem;
      margin:0.75rem 0;
      background:white;
      border-radius:6px;
      border:1px solid #e0e7ff;
    }
    .inverse-calc .augmented-matrix{display:inline-block;position:relative}
    .inverse-calc .augmented-divider{position:absolute;left:50%;top:10%;bottom:10%;width:2px;background:#94a3b8}

    .step-number{
      display:inline-block;
      background:#6366f1;
      color:white;
      padding:0.2rem 0.6rem;
      border-radius:12px;
      font-size:0.85rem;
      font-weight:600;
      margin-right:0.5rem;
      min-width:32px;
      text-align:center;
    }

    .step-description{
      font-size:0.95rem;
      color:#4b5563;
      line-height:1.6;
      flex:1;
    }

    /* Hide LaTeX source when MathJax has rendered */
    .matrix-display .MathJax_Preview,
    .matrix-display script[type^="math/tex"] {
      display: none !important;
    }

    @media (max-width: 767px) {
      .inverse-calc h1{font-size:1.5rem}
      .inverse-calc .card-header{font-size:0.95rem}
      .inverse-calc button{width:100%;margin:0.25rem 0}
      .inverse-calc .matrix-display{font-size:0.85em;padding:0.5rem}
      .inverse-calc .step-card{padding:0.75rem}
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
<div class="container mt-4 inverse-calc">
  <h1 class="mb-2">Matrix Inverse Calculator</h1>
  <p class="text-muted mb-3">Calculate the inverse of any square invertible matrix using Gauss-Jordan elimination.</p>

  <div class="row">
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header">Matrix Input</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="matrixSize">Matrix Size (n×n)</label>
            <div class="d-flex align-items-center">
              <input id="matrixSize" type="number" min="2" max="6" class="form-control mr-2" value="3" style="flex:1">
              <button id="btnRandom" class="btn btn-outline-info btn-sm" title="Generate random matrix">
                <i class="fas fa-random"></i> Random
              </button>
            </div>
            <small class="text-muted">Supports 2×2 up to 6×6 matrices</small>
          </div>

          <div class="form-group">
            <label for="matrixInput">Matrix Entries</label>
            <textarea id="matrixInput" class="form-control" rows="8" placeholder="Enter matrix entries:
1 2 3
0 1 4
5 6 0"></textarea>
            <small class="text-muted">One row per line, space or comma separated</small>
          </div>

          <div class="form-group">
            <div class="custom-control custom-switch">
              <input type="checkbox" class="custom-control-input" id="showSteps" checked>
              <label class="custom-control-label" for="showSteps">Show detailed steps</label>
            </div>
            <div class="custom-control custom-switch">
              <input type="checkbox" class="custom-control-input" id="verifyResult" checked>
              <label class="custom-control-label" for="verifyResult">Verify A × A⁻¹ = I</label>
            </div>
          </div>

          <div class="d-flex flex-wrap">
            <button id="btnCalculate" class="btn btn-primary btn-sm mr-2 mb-2">Calculate Inverse</button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm mb-2">Clear</button>
          </div>
          <div id="inputError" class="text-danger small mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Quick Presets</h5>
        <div class="card-body">
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-preset="identity">Identity (3×3)</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-preset="diagonal">Diagonal Matrix</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-preset="example1">Example 1 (3×3)</button>
          <button class="btn btn-outline-primary btn-sm btn-block" data-preset="example2">Example 2 (2×2)</button>
        </div>
      </div>
    </div>

    <div class="col-lg-8 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header d-flex flex-wrap justify-content-between align-items-center">
          <span class="mb-1 mb-sm-0">Inverse Matrix Result</span>
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
            Enter an invertible square matrix and click "Calculate Inverse" to see the result.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Step-by-Step Solution</h5>
        <div class="card-body">
          <div id="stepsArea" class="text-muted">
            Detailed Gauss-Jordan elimination steps will appear here.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">About Matrix Inverse</h5>
        <div class="card-body small">
          <p><strong>What is a Matrix Inverse?</strong><br>
          The inverse of a square matrix A, denoted A⁻¹, is the matrix such that A × A⁻¹ = A⁻¹ × A = I (identity matrix).</p>

          <p><strong>Requirements for Invertibility:</strong></p>
          <ul>
            <li>Matrix must be square (n×n)</li>
            <li>Determinant must be non-zero (det(A) ≠ 0)</li>
            <li>All rows/columns must be linearly independent</li>
            <li>Matrix must have full rank (rank = n)</li>
          </ul>

          <p><strong>Gauss-Jordan Elimination Method:</strong></p>
          <ol>
            <li>Create augmented matrix [A | I]</li>
            <li>Use row operations to transform A into I</li>
            <li>The right side becomes A⁻¹: [I | A⁻¹]</li>
          </ol>

          <p><strong>Properties:</strong></p>
          <ul>
            <li>(A⁻¹)⁻¹ = A</li>
            <li>(AB)⁻¹ = B⁻¹A⁻¹</li>
            <li>(A<sup>T</sup>)⁻¹ = (A⁻¹)<sup>T</sup></li>
            <li>det(A⁻¹) = 1/det(A)</li>
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
  const showSteps = document.getElementById('showSteps');
  const verifyResult = document.getElementById('verifyResult');
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
    if(Math.abs(num) < EPS) return '0';
    if(Math.abs(num - Math.round(num)) < EPS) return Math.round(num).toString();
    return parseFloat(num.toFixed(3)).toString();
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

  function formatAugmentedMatrix(A, I) {
    const n = A.length;
    const rows = [];
    for(let i = 0; i < n; i++) {
      const leftPart = A[i].map((val, j) => {
        const num = Math.abs(val) < EPS ? 0 : val;
        const formatted = smartFormat(num);
        // Highlight diagonal elements forming identity on left
        return (i === j && Math.abs(num - 1) < EPS) ? `\\textcolor{blue}{${formatted}}` : formatted;
      });
      const rightPart = I[i].map(val => {
        const num = Math.abs(val) < EPS ? 0 : val;
        return smartFormat(num);
      });
      rows.push([...leftPart, '|', ...rightPart].join(' & '));
    }
    return '\\left[\\begin{array}{' + 'c'.repeat(n) + '|' + 'c'.repeat(n) + '}' + rows.join(' \\\\ ') + '\\end{array}\\right]';
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

  function multiply(A, B) {
    const n = A.length;
    const m = B[0].length;
    const p = B.length;
    const result = [];
    for(let i = 0; i < n; i++) {
      result[i] = [];
      for(let j = 0; j < m; j++) {
        let sum = 0;
        for(let k = 0; k < p; k++) {
          sum += A[i][k] * B[k][j];
        }
        result[i][j] = sum;
      }
    }
    return result;
  }

  function invertMatrix(mat) {
    const n = mat.length;
    const A = cloneMatrix(mat);
    const I = createIdentity(n);
    const steps = [];

    steps.push({
      desc: `Starting with augmented matrix [A | I]`,
      showMatrix: false
    });

    // Forward elimination
    for(let i = 0; i < n; i++) {
      // Find pivot
      let maxRow = i;
      for(let k = i + 1; k < n; k++) {
        if(Math.abs(A[k][i]) > Math.abs(A[maxRow][i])) {
          maxRow = k;
        }
      }

      if(Math.abs(A[maxRow][i]) < EPS) {
        throw new Error('Matrix is singular and cannot be inverted (det = 0)');
      }

      // Swap rows if needed
      if(maxRow !== i) {
        [A[i], A[maxRow]] = [A[maxRow], A[i]];
        [I[i], I[maxRow]] = [I[maxRow], I[i]];
        steps.push({
          desc: `Swap R${i+1} ↔ R${maxRow+1}`,
          showMatrix: true,
          matrix: {A: cloneMatrix(A), I: cloneMatrix(I)}
        });
      }

      // Scale pivot row
      const pivot = A[i][i];
      if(Math.abs(pivot - 1) > EPS) {
        for(let j = 0; j < n; j++) {
          A[i][j] /= pivot;
          I[i][j] /= pivot;
        }
        steps.push({
          desc: `R${i+1} = R${i+1} / ${pivot.toFixed(4)}`,
          showMatrix: steps.length < 10,
          matrix: {A: cloneMatrix(A), I: cloneMatrix(I)}
        });
      }

      // Eliminate column
      for(let k = 0; k < n; k++) {
        if(k === i) continue;
        const factor = A[k][i];
        if(Math.abs(factor) < EPS) continue;

        for(let j = 0; j < n; j++) {
          A[k][j] -= factor * A[i][j];
          I[k][j] -= factor * I[i][j];
        }

        steps.push({
          desc: `R${k+1} = R${k+1} - (${factor.toFixed(4)}) × R${i+1}`,
          showMatrix: steps.length < 10,
          matrix: {A: cloneMatrix(A), I: cloneMatrix(I)}
        });
      }
    }

    steps.push({
      desc: 'Gauss-Jordan elimination complete. Left side is now I, right side is A⁻¹',
      showMatrix: false
    });

    return {inverse: I, steps};
  }

  function calculate() {
    try {
      inputError.style.display = 'none';
      const n = parseInt(matrixSize.value);
      if(n < 2 || n > 6) {
        throw new Error('Matrix size must be between 2 and 6');
      }

      const matrix = parseMatrix(matrixInput.value, n);
      const result = invertMatrix(matrix);

      let html = `
        <div class="result-card">
          <div class="mb-2"><strong>Original Matrix A:</strong></div>
          <div class="matrix-display">$$A = ${formatMatrix(matrix)}$$</div>
          <div class="mt-3 mb-2"><strong>Inverse Matrix A⁻¹:</strong></div>
          <div class="matrix-display">$$A^{-1} = ${formatMatrix(result.inverse)}$$</div>
        </div>
      `;

      if(verifyResult.checked) {
        const product = multiply(matrix, result.inverse);
        const identity = createIdentity(n);
        let isIdentity = true;

        for(let i = 0; i < n; i++) {
          for(let j = 0; j < n; j++) {
            if(Math.abs(product[i][j] - identity[i][j]) > 1e-6) {
              isIdentity = false;
            }
          }
        }

        html += `
          <div class="verification-card">
            <div class="mb-2"><strong>Verification: A × A⁻¹</strong></div>
            <div class="matrix-display">$$${formatMatrix(product)}$$</div>
            <div class="mt-2">
              ${isIdentity
                ? '<i class="fas fa-check-circle text-success"></i> Result verified! A × A⁻¹ = I'
                : '<i class="fas fa-exclamation-triangle text-warning"></i> Minor numerical errors present (expected for floating point)'}
            </div>
          </div>
        `;
      }

      resultArea.innerHTML = html;

      if(showSteps.checked) {
        let stepsHtml = '<div class="mb-4"><h5 class="text-dark">📋 Gauss-Jordan Steps</h5></div>';
        stepsHtml += '<p class="text-muted mb-4" style="font-size:0.95rem">Watch the transformation: [A | I] → [I | A⁻¹]</p>';

        result.steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card">`;
          stepsHtml += `<div class="d-flex align-items-start">`;
          stepsHtml += `<span class="step-number">${idx + 1}</span>`;
          stepsHtml += `<div class="step-description">${step.desc}`;
          if(step.showMatrix && step.matrix) {
            // Show augmented matrix
            stepsHtml += `<div class="matrix-display mt-2">$$${formatAugmentedMatrix(step.matrix.A, step.matrix.I)}$$</div>`;
          }
          stepsHtml += `</div></div></div>`;
        });

        stepsArea.innerHTML = stepsHtml;
      } else {
        stepsArea.innerHTML = '<div class="text-muted">Enable "Show detailed steps" to see the solution process.</div>';
      }

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
    resultArea.innerHTML = '<div class="text-center text-muted">Enter an invertible square matrix and click "Calculate Inverse" to see the result.</div>';
    stepsArea.innerHTML = '<div class="text-muted">Detailed Gauss-Jordan elimination steps will appear here.</div>';
    inputError.style.display = 'none';
  }

  function loadPreset(preset) {
    if(preset === 'identity') {
      matrixSize.value = 3;
      matrixInput.value = '1 0 0\n0 1 0\n0 0 1';
    } else if(preset === 'diagonal') {
      matrixSize.value = 3;
      matrixInput.value = '2 0 0\n0 3 0\n0 0 5';
    } else if(preset === 'example1') {
      matrixSize.value = 3;
      matrixInput.value = '1 2 3\n0 1 4\n5 6 0';
    } else if(preset === 'example2') {
      matrixSize.value = 2;
      matrixInput.value = '4 7\n2 6';
    }
    calculate();
  }

  // Random matrix generator
  function generateRandom() {
    const n = parseInt(matrixSize.value);
    if(n < 2 || n > 6) {
      alert('Please set matrix size between 2 and 6');
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
          if(!resultCard || !resultCard.querySelector('.result-card')) {
              alert('No result to download. Please calculate an inverse first.');
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
              link.download = `matrix-inverse-${timestamp}.png`;
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

  // Load example by default or from URL
  if(!loadFromURL()) {
    loadPreset('example1');
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
