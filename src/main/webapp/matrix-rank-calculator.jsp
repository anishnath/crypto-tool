<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Matrix Rank Calculator Online – Free | 8gwifi.org</title>
  <meta name="description" content="Free matrix rank calculator with step-by-step row echelon transformation. Calculate rank(A), nullity, pivot positions for m×n matrices. Gaussian elimination to REF. Shows linearly independent rows. Random generator.">
  <meta name="keywords" content="matrix rank calculator, rank of matrix, row echelon form, pivot positions, nullity, linear algebra, rank nullity theorem, linearly independent, REF">
  <link rel="canonical" href="https://8gwifi.org/matrix-rank-calculator.jsp">

  <meta property="og:type" content="website">
  <meta property="og:title" content="Matrix Rank Calculator Online – Free | 8gwifi.org">
  <meta property="og:description" content="Compute rank(A), nullity, and pivot positions via row echelon form with step-by-step output.">
  <meta property="og:url" content="https://8gwifi.org/matrix-rank-calculator.jsp">

  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Matrix Rank Calculator Online – Free | 8gwifi.org">
  <meta name="twitter:description" content="Find rank, nullity, and pivots using REF with clear steps.">

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Matrix Rank Calculator",
    "applicationCategory": "EducationalApplication",
    "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
    "description": "Calculate matrix rank using row echelon form. Shows pivot positions, nullity, and verifies rank-nullity theorem: rank(A) + nullity(A) = n.",
    "url": "https://8gwifi.org/matrix-rank-calculator.jsp",
    "featureList": ["Row echelon form", "Rank calculation", "Nullity calculation", "Pivot positions", "Rank-nullity theorem", "m×n matrices", "Step-by-step", "Random generator"]
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
    .rank-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .rank-calc .card-body{padding:.7rem .9rem}
    .rank-calc .result-card{border-left:4px solid #8b5cf6;background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);border-radius:8px;padding:1.25rem;margin:1rem 0;box-shadow:0 2px 8px rgba(139,92,246,0.1)}
    .rank-calc .rank-value{font-size:2.5rem;font-weight:700;color:#7c3aed;font-family:monospace}
    .rank-calc .info-badge{display:inline-block;background:#e0e7ff;color:#4338ca;padding:0.4rem 0.8rem;border-radius:8px;font-weight:600;margin:0.25rem;font-size:0.9rem}
    .rank-calc .step-card{
      border-left:4px solid #6366f1;
      background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);
      padding:1rem 1.25rem;
      margin:0.75rem 0;
      border-radius:8px;
      box-shadow:0 1px 3px rgba(99,102,241,0.08);
      transition:all 0.2s ease;
    }
    .rank-calc .step-card:hover{
      box-shadow:0 4px 12px rgba(99,102,241,0.15);
      transform:translateX(2px);
    }
    .rank-calc .matrix-display{
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
    .pivot-indicator{color:#7c3aed;font-weight:700}
    .matrix-display .MathJax_Preview,
    .matrix-display script[type^="math/tex"] {
      display: none !important;
    }

    @media (max-width: 767px) {
      .rank-calc h1{font-size:1.5rem}
      .rank-calc .rank-value{font-size:2rem}
      .rank-calc .card-header{font-size:0.95rem}
      .rank-calc button{width:100%;margin:0.25rem 0}
      .rank-calc .step-card{padding:0.75rem}
      .rank-calc .matrix-display{padding:0.5rem;font-size:0.9em}
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
<div class="container mt-4 rank-calc">
  <h1 class="mb-2">Matrix Rank Calculator</h1>
  <p class="text-muted mb-3">Calculate matrix rank with step-by-step row echelon form transformation.</p>

  <div class="row">
    <div class="col-lg-4 col-md-12">
      <div class="card mb-3">
        <h5 class="card-header">Matrix Input</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="matrixRows">Number of Rows</label>
            <div class="d-flex align-items-center">
              <input id="matrixRows" type="number" min="2" max="8" class="form-control mr-2" value="3" style="flex:1">
              <button id="btnRandomRows" class="btn btn-outline-info btn-sm" title="Generate random matrix">
                <i class="fas fa-random"></i> Random
              </button>
            </div>
          </div>

          <div class="form-group">
            <label for="matrixCols">Number of Columns</label>
            <input id="matrixCols" type="number" min="2" max="8" class="form-control" value="4">
          </div>

          <div class="form-group">
            <label for="matrixInput">Matrix Entries</label>
            <textarea id="matrixInput" class="form-control" rows="6" placeholder="Enter matrix:
1 2 3 4
2 4 6 8
1 1 1 1"></textarea>
            <small class="text-muted">One row per line, space separated</small>
          </div>

          <div class="d-flex flex-wrap">
            <button id="btnCalculate" class="btn btn-primary btn-sm mr-2 mb-2">Calculate Rank</button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm mb-2">Clear</button>
          </div>
          <div id="inputError" class="text-danger small mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Quick Examples</h5>
        <div class="card-body">
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="full">Full Rank (3×3)</button>
          <button class="btn btn-outline-primary btn-sm btn-block mb-2" data-example="deficient">Rank Deficient</button>
          <button class="btn btn-outline-primary btn-sm btn-block" data-example="rectangular">Rectangular Matrix</button>
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
            Enter a matrix and click "Calculate Rank" to see the result.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Step-by-Step Solution</h5>
        <div class="card-body">
          <div id="stepsArea" class="text-muted">
            Detailed row reduction steps will appear here.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">About Matrix Rank</h5>
        <div class="card-body small">
          <p><strong>What is Matrix Rank?</strong><br>
          The rank of a matrix is the maximum number of linearly independent rows (or columns). It equals the number of non-zero rows in row echelon form.</p>

          <p><strong>Properties:</strong></p>
          <ul>
            <li>rank(A) ≤ min(rows, columns)</li>
            <li>Full rank means rank equals the smaller dimension</li>
            <li>Rank deficient means rank is less than the smaller dimension</li>
            <li>Zero matrix has rank 0</li>
          </ul>

          <p><strong>Applications:</strong></p>
          <ul>
            <li><strong>Linear Systems:</strong> Determines if Ax = b has solutions</li>
            <li><strong>Nullity:</strong> nullity = n − rank (dimension of null space)</li>
            <li><strong>Invertibility:</strong> Square matrix is invertible iff rank = n</li>
            <li><strong>Span:</strong> Rank tells dimension of column/row space</li>
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
            <a href="linear-equations-solver.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-equals"></i> Linear Equations
            </a>
            <a href="matrix-determinant-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-calculator"></i> Determinant
            </a>
            <a href="matrix-inverse-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-sync"></i> Matrix Inverse
            </a>
            <a href="matrix-power-calculator.jsp" class="btn btn-sm btn-outline-primary mb-2">
              <i class="fas fa-superscript"></i> Matrix Powers
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
  const matrixRows = document.getElementById('matrixRows');
  const matrixCols = document.getElementById('matrixCols');
  const matrixInput = document.getElementById('matrixInput');
  const btnCalculate = document.getElementById('btnCalculate');
  const btnClear = document.getElementById('btnClear');
  const btnRandomRows = document.getElementById('btnRandomRows');
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
        throw new Error(`Row ${i+1}: expected ${cols} entries, got ${entries.length}`);
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

  function formatMatrix(mat, pivotPositions = []) {
    const rows = mat.map((row, i) =>
      row.map((val, j) => {
        const num = Math.abs(val) < EPS ? 0 : val;
        const formatted = smartFormat(num);
        // Highlight pivots
        const isPivot = pivotPositions.some(p => p.row === i && p.col === j);
        if(isPivot) {
          return '\\textcolor{purple}{\\mathbf{' + formatted + '}}';
        }
        // Gray out zeros
        if(Math.abs(num) < EPS) {
          return '\\textcolor{gray}{0}';
        }
        return formatted;
      }).join(' & ')
    );
    return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}';
  }

  function calculateRank(matrix) {
    const m = matrix.length;
    const n = matrix[0].length;
    const A = cloneMatrix(matrix);
    const steps = [];
    const pivotPositions = [];

    steps.push(`<span class="text-primary">Starting with ${m}×${n} matrix</span>`);
    steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A)}$$</div>`);

    let currentRow = 0;

    // Row reduction to echelon form
    for(let col = 0; col < n && currentRow < m; col++) {
      // Find pivot
      let pivotRow = currentRow;
      for(let i = currentRow + 1; i < m; i++) {
        if(Math.abs(A[i][col]) > Math.abs(A[pivotRow][col])) {
          pivotRow = i;
        }
      }

      // Skip if no pivot found
      if(Math.abs(A[pivotRow][col]) < EPS) {
        steps.push(`<span class="text-secondary">Column ${col+1} has no pivot, moving to next column</span>`);
        continue;
      }

      // Swap rows if needed
      if(pivotRow !== currentRow) {
        [A[pivotRow], A[currentRow]] = [A[currentRow], A[pivotRow]];
        steps.push(`<span class="text-info">Row swap: R${currentRow+1} ↔ R${pivotRow+1}</span>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A, pivotPositions)}$$</div>`);
      }

      // Record pivot position
      pivotPositions.push({row: currentRow, col: col});

      // Scale pivot to 1
      const pivotVal = A[currentRow][col];
      if(Math.abs(pivotVal - 1) > EPS) {
        for(let j = 0; j < n; j++) {
          A[currentRow][j] /= pivotVal;
        }
        steps.push(`<span class="text-secondary">Scale R${currentRow+1} by 1/${smartFormat(pivotVal)}</span>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A, pivotPositions)}$$</div>`);
      }

      // Eliminate below pivot
      let eliminated = [];
      for(let i = currentRow + 1; i < m; i++) {
        const factor = A[i][col];
        if(Math.abs(factor) > EPS) {
          eliminated.push(`R${i+1} = R${i+1} - (${smartFormat(factor)})R${currentRow+1}`);
          for(let j = 0; j < n; j++) {
            A[i][j] -= factor * A[currentRow][j];
          }
        }
      }

      if(eliminated.length > 0) {
        steps.push(`<div class="text-secondary">${eliminated.join(', ')}</div>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A, pivotPositions)}$$</div>`);
      }

      currentRow++;
    }

    const rank = pivotPositions.length;

    steps.push(`<span class="text-success">Row echelon form achieved with ${rank} pivot${rank !== 1 ? 's' : ''}</span>`);
    steps.push(`<div class="matrix-display mt-2 mb-3">$$${formatMatrix(A, pivotPositions)}$$</div>`);

    return {
      rank,
      pivotPositions,
      echelonForm: A,
      steps,
      nullity: n - rank
    };
  }

  function calculate() {
    try {
      inputError.style.display = 'none';
      const rows = parseInt(matrixRows.value);
      const cols = parseInt(matrixCols.value);

      if(rows < 2 || rows > 8 || cols < 2 || cols > 8) {
        throw new Error('Dimensions must be between 2 and 8');
      }

      const matrix = parseMatrix(matrixInput.value, rows, cols);
      const result = calculateRank(matrix);

      const isFullRank = result.rank === Math.min(rows, cols);
      const pivotCols = result.pivotPositions.map(p => p.col + 1).join(', ');

      let html = `
        <div class="result-card">
          <div class="text-center mb-3">
            <div class="mb-2" style="font-size:1.1rem;color:#64748b">Rank of Matrix:</div>
            <div class="rank-value">${result.rank}</div>
          </div>

          <div class="mt-4">
            <div class="mb-2">
              <span class="info-badge">📐 Dimensions: ${rows}×${cols}</span>
              <span class="info-badge">📊 Nullity: ${result.nullity}</span>
              ${isFullRank ? '<span class="info-badge" style="background:#d1fae5;color:#065f46">✓ Full Rank</span>' : '<span class="info-badge" style="background:#fee2e2;color:#991b1b">⚠ Rank Deficient</span>'}
            </div>

            <div class="mt-3 small">
              <div><strong>Pivot columns:</strong> ${pivotCols}</div>
              <div class="mt-1"><strong>Free variables:</strong> ${result.nullity} (columns: ${result.nullity > 0 ? 'not in pivot positions' : 'none'})</div>
              ${rows === cols ? `<div class="mt-1"><strong>Invertible:</strong> ${isFullRank ? 'Yes ✓' : 'No (singular)'}</div>` : ''}
            </div>
          </div>
        </div>
      `;

      resultArea.innerHTML = html;

      let stepsHtml = '<div class="mb-4"><h5 class="text-dark">📋 Row Reduction Steps</h5></div>';
      stepsHtml += '<p class="text-muted mb-4" style="font-size:0.95rem">Transform to row echelon form (pivots in <span class="pivot-indicator">purple</span>):</p>';
      result.steps.forEach((step, idx) => {
        stepsHtml += `<div class="step-card">
          <div class="d-flex align-items-start">
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
    resultArea.innerHTML = '<div class="text-center text-muted">Enter a matrix and click "Calculate Rank" to see the result.</div>';
    stepsArea.innerHTML = '<div class="text-muted">Detailed row reduction steps will appear here.</div>';
    inputError.style.display = 'none';
  }

  function loadExample(type) {
    if(type === 'full') {
      matrixRows.value = 3;
      matrixCols.value = 3;
      matrixInput.value = '1 2 3\n4 5 6\n7 8 10';
    } else if(type === 'deficient') {
      matrixRows.value = 3;
      matrixCols.value = 4;
      matrixInput.value = '1 2 3 4\n2 4 6 8\n1 1 1 1';
    } else if(type === 'rectangular') {
      matrixRows.value = 2;
      matrixCols.value = 5;
      matrixInput.value = '1 2 0 3 4\n0 0 1 5 6';
    }
    calculate();
  }

  // Random matrix generator
  function generateRandom() {
    const rows = parseInt(matrixRows.value);
    const cols = parseInt(matrixCols.value);
    if(rows < 2 || rows > 8) {
      alert('Please set number of rows between 2 and 8');
      return;
    }
    if(cols < 2 || cols > 8) {
      alert('Please set number of columns between 2 and 8');
      return;
    }

    const rowsArray = [];
    for(let i = 0; i < rows; i++) {
      const row = [];
      for(let j = 0; j < cols; j++) {
        row.push(Math.floor(Math.random() * 21 - 10));
      }
      rowsArray.push(row.join(' '));
    }
    matrixInput.value = rowsArray.join('\n');
    setTimeout(() => calculate(), 100);
  }

  btnCalculate.addEventListener('click', calculate);
  btnClear.addEventListener('click', clear);
  btnRandomRows.addEventListener('click', generateRandom);
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
        const rows = parseInt(matrixRows.value);
        const cols = parseInt(matrixCols.value);
        const matrixText = matrixInput.value.trim();
        if(!matrixText) {
          alert('Please enter a matrix first!');
          return;
        }

        const baseUrl = window.location.origin + window.location.pathname;
        const params = new URLSearchParams();
        params.set('rows', rows);
        params.set('cols', cols);
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
        alert('No result to download. Please calculate rank first.');
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
        link.download = `matrix-rank-${timestamp}.png`;
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
    if(urlParams.has('matrix') && urlParams.has('rows') && urlParams.has('cols')) {
      try {
        const rows = parseInt(urlParams.get('rows'));
        const cols = parseInt(urlParams.get('cols'));
        const matrixData = decodeURIComponent(atob(urlParams.get('matrix')));

        matrixRows.value = rows;
        matrixCols.value = cols;
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
    loadExample('full');
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
  <h2 class="h5">Matrix Rank: FAQ</h2>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">How do I find the rank of a matrix?</h3>
    <p class="mb-0">Enter your matrix and click Calculate. The tool reduces it to row echelon form (REF) and counts non‑zero rows (pivot rows) to obtain rank(A).</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What is nullity and how is it related to rank?</h3>
    <p class="mb-0">Nullity is the dimension of the null space. For an m×n matrix, the rank‑nullity theorem states rank(A) + nullity(A) = n.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What does rank tell me about a matrix?</h3>
    <p class="mb-0">Full rank means maximum linearly independent columns. If rank(A) &lt; n for an n×n square matrix, A is singular and not invertible.</p>
  </div></div>
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"How do I find the rank of a matrix?","acceptedAnswer":{"@type":"Answer","text":"Enter your matrix and click Calculate. The tool reduces it to row echelon form (REF) and counts non‑zero rows (pivot rows) to obtain rank(A)."}},
    {"@type":"Question","name":"What is nullity and how is it related to rank?","acceptedAnswer":{"@type":"Answer","text":"Nullity is the dimension of the null space. For an m×n matrix, the rank‑nullity theorem states rank(A) + nullity(A) = n."}},
    {"@type":"Question","name":"What does rank tell me about a matrix?","acceptedAnswer":{"@type":"Answer","text":"Full rank means maximum linearly independent columns. If rank(A) < n for an n×n square matrix, A is singular and not invertible."}}
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Matrix Rank Calculator","item":"https://8gwifi.org/matrix-rank-calculator.jsp"}
  ]
}
</script>
</div>
<%@ include file="body-close.jsp"%>
