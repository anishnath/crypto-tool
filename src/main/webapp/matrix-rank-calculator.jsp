<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <jsp:include page="modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Matrix Rank Calculator | rank(A) Free Online" />
    <jsp:param name="toolDescription" value="Free matrix rank calculator. rank(A), nullity, pivot positions. Row echelon form, Gaussian elimination. Print worksheet with practice exercises. Share, download. Step-by-step." />
    <jsp:param name="toolCategory" value="Mathematics" />
    <jsp:param name="toolUrl" value="matrix-rank-calculator.jsp" />
    <jsp:param name="toolKeywords" value="matrix rank calculator, rank of matrix, row echelon form, pivot positions, nullity, linear algebra, rank nullity theorem, linearly independent, REF" />
    <jsp:param name="toolFeatures" value="Rank and nullity,Print worksheet with practice exercises,Share URL and download,Row echelon form,Gaussian elimination,Pivot positions" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="faq1q" value="How do I find the rank of a matrix?" />
    <jsp:param name="faq1a" value="Enter your matrix and click Calculate. The tool reduces it to row echelon form (REF) and counts non-zero rows (pivot rows) to obtain rank(A)." />
    <jsp:param name="faq2q" value="What is nullity and how is it related to rank?" />
    <jsp:param name="faq2a" value="Nullity is the dimension of the null space. For an m×n matrix, the rank-nullity theorem states rank(A) + nullity(A) = n." />
    <jsp:param name="faq3q" value="What does rank tell me about a matrix?" />
    <jsp:param name="faq3a" value="Full rank means maximum linearly independent columns. If rank(A) &lt; n for an n×n square matrix, A is singular and not invertible." />
  </jsp:include>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">

  <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/matrix-modern.css?v=<%=cacheVersion%>">

  <%@ include file="modern/ads/ad-init.jsp"%>
  <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
  <script src="<%=request.getContextPath()%>/js/matrix-common.js?v=<%=cacheVersion%>"></script>
  <script>MatrixUtils.initMathJax();</script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" crossorigin="anonymous"></script>
  <style>
    :root { --tool-primary:#8b5cf6; --tool-primary-dark:#7c3aed; --tool-gradient:linear-gradient(135deg,#8b5cf6 0%,#7c3aed 100%); --tool-light:#f5f3ff }
    [data-theme="dark"] { --tool-light:rgba(139,92,246,0.15) }
    .rank-calc { --mc-result-color:#8b5cf6; --mc-result-bg:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%); --mc-result-shadow:rgba(139,92,246,0.1) }
    .rank-calc .rank-value{font-size:2.5rem;font-weight:700;color:#7c3aed;font-family:monospace}
    .rank-calc .info-badge{display:inline-block;background:#e0e7ff;color:#4338ca;padding:0.4rem 0.8rem;border-radius:8px;font-weight:600;margin:0.25rem;font-size:0.9rem}
    .rank-calc .pivot-indicator{color:#7c3aed;font-weight:700}
    .tool-btn-outline{background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);padding:0.5rem 1rem;font-size:0.875rem;font-weight:500;border-radius:0.5rem;cursor:pointer}
    .tool-btn-outline:hover{background:var(--tool-light)}
    .matrix-example-grid{display:flex;flex-direction:column;gap:0.5rem}
    .matrix-example-btn{text-align:left;padding:0.5rem 0.75rem;font-size:0.8125rem;border:1px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);cursor:pointer;transition:all .15s}
    .matrix-example-btn:hover{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary)}
    @media (max-width: 767px) { .rank-calc .rank-value{font-size:2rem} }
  </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp"%>

<header class="tool-page-header">
  <div class="tool-page-header-inner">
    <div>
      <h1 class="tool-page-title">Matrix Rank Calculator</h1>
      <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
        <a href="<%=request.getContextPath()%>/index.jsp#mathematics">Mathematics</a> /
        <span>Matrix Rank</span>
      </nav>
    </div>
    <div class="tool-page-badges">
      <span class="tool-badge">Free</span>
      <span class="tool-badge">Client-Side</span>
      <span class="tool-badge">Step-by-Step</span>
    </div>
  </div>
</header>

<section class="tool-description-section">
  <div class="tool-description-inner">
    <div class="tool-description-content">
      <p>Calculate matrix rank with step-by-step row echelon form (REF) transformation. Shows rank(A), nullity, pivot positions, and linearly independent rows for m×n matrices. <strong>100% client-side</strong>—no data sent to servers. Supports 2×2 up to 8×8.</p>
    </div>
  </div>
</section>

<main class="tool-page-container">
  <div class="tool-input-column">
    <div class="tool-card matrix-calc rank-calc">
      <div class="tool-card-header">Matrix Input</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixRows">Number of Rows</label>
          <div class="matrix-dim-row" style="display:flex;align-items:center;gap:0.5rem;flex-wrap:wrap">
            <input id="matrixRows" type="number" min="2" max="8" class="tool-input" value="3" style="flex:1;min-width:60px">
            <button id="btnRandomRows" class="tool-btn-outline" title="Generate random matrix" style="padding:0.4rem 0.75rem;font-size:0.8125rem">
              <i class="fas fa-random"></i> Random
            </button>
          </div>
        </div>

        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixCols">Number of Columns</label>
          <input id="matrixCols" type="number" min="2" max="8" class="tool-input" value="4">
        </div>

        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixInput">Matrix Entries</label>
          <textarea id="matrixInput" class="tool-input" rows="6" placeholder="Enter matrix:
1 2 3 4
2 4 6 8
1 1 1 1"></textarea>
          <span class="tool-form-hint">One row per line, space separated</span>
        </div>

        <div style="display:flex;flex-wrap:wrap;gap:0.5rem">
          <button id="btnCalculate" class="tool-action-btn">Calculate Rank</button>
          <button id="btnClear" class="tool-btn-outline">Clear</button>
        </div>
        <div id="inputError" class="tool-form-hint" style="color:var(--error,#ef4444);display:none;margin-top:0.5rem"></div>
      </div>
    </div>

    <div class="tool-card">
      <div class="tool-card-header">Quick Examples</div>
      <div class="tool-card-body matrix-example-grid">
        <button class="matrix-example-btn" data-example="full">Full Rank (3×3)</button>
        <button class="matrix-example-btn" data-example="deficient">Rank Deficient</button>
        <button class="matrix-example-btn" data-example="rectangular">Rectangular Matrix</button>
      </div>
    </div>
  </div>

  <div class="tool-output-column">
    <div class="tool-card">
      <div class="tool-card-header" style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:0.5rem">
        <span>Result</span>
        <div style="display:flex;flex-wrap:wrap;gap:0.25rem">
          <button id="btnShareURL" class="tool-btn-outline" title="Copy URL to clipboard" style="padding:0.4rem 0.75rem;font-size:0.8125rem">
            <i class="fas fa-share-alt"></i> Share URL
          </button>
          <button id="btnDownloadImage" class="tool-btn-outline" title="Download result as image" style="padding:0.4rem 0.75rem;font-size:0.8125rem">
            <i class="fas fa-download"></i> Download
          </button>
          <button id="btnPrintWorksheet" class="tool-btn-outline" title="Print worksheet" style="padding:0.4rem 0.75rem;font-size:0.8125rem;background:linear-gradient(135deg,#64748b,#475569);color:#fff;border:none">&#128424; Print Worksheet</button>
        </div>
      </div>
      <div class="tool-card-body">
        <div id="resultArea" class="text-center text-muted">
          Enter a matrix and click "Calculate Rank" to see the result.
        </div>
      </div>
    </div>

    <div class="tool-card">
      <div class="tool-card-header">Step-by-Step Solution</div>
      <div class="tool-card-body">
        <div id="stepsArea" class="text-muted">
          Detailed row reduction steps will appear here.
        </div>
      </div>
    </div>

    <div class="tool-card">
      <div class="tool-card-header">About Matrix Rank</div>
      <div class="tool-card-body" style="font-size:0.875rem">
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

    <jsp:include page="modern/components/related-tools.jsp">
      <jsp:param name="currentToolUrl" value="matrix-rank-calculator.jsp" />
      <jsp:param name="keyword" value="matrix" />
    </jsp:include>
  </div>

  <div class="tool-ads-column">
    <%@ include file="modern/ads/ad-in-content-mid.jsp"%>
  </div>
</main>

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

  const EPS = MatrixUtils.EPS;
  const smartFormat = MatrixUtils.smartFormat;
  const parseMatrix = MatrixUtils.parseMatrix;
  const cloneMatrix = MatrixUtils.cloneMatrix;

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
          <div class="step-inner">
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
      resultArea.innerHTML = '<div style="padding:1rem;background:rgba(239,68,68,0.1);border:1px solid var(--error);border-radius:0.5rem;color:var(--error)">Error: ' + err.message + '</div>';
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

  // Share URL
  MatrixUtils.shareURL(document.getElementById('btnShareURL'), function() {
    const matrixText = matrixInput.value.trim();
    if(!matrixText) { alert('Please enter a matrix first!'); return null; }
    return { rows: matrixRows.value, cols: matrixCols.value, matrix: btoa(encodeURIComponent(matrixText)) };
  });

  // Download Image
  MatrixUtils.downloadImage(document.getElementById('btnDownloadImage'), 'matrix-rank', 'No result to download. Please calculate rank first.');
  MatrixUtils.printWorksheet(document.getElementById('btnPrintWorksheet'), 'Matrix Rank', { exerciseType: 'rank' });

  // Load from URL or default
  const loaded = MatrixUtils.loadFromURL(function(p) {
    if(p.matrix && p.rows && p.cols) {
      matrixRows.value = p.rows;
      matrixCols.value = p.cols;
      matrixInput.value = p.matrix;
      setTimeout(() => calculate(), 100);
      return true;
    }
    return false;
  });
  if(!loaded) {
    loadExample('full');
  }
})();
</script>

<section style="max-width:900px;margin:2rem auto;padding:0 1.5rem">
  <div class="tool-card" style="padding:2rem;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-secondary)">
    <h2 id="eeat" style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">About This Matrix Rank Calculator &amp; Methodology</h2>
    <p style="margin-bottom:1rem;color:var(--text-secondary);line-height:1.7">The rank of a matrix is the maximum number of linearly independent rows (or columns). This tool uses Gaussian elimination to reduce to row echelon form (REF), then counts non-zero pivot rows. The rank-nullity theorem: rank(A) + nullity(A) = n. <strong>All calculations run client-side</strong>—no data stored.</p>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5rem;margin-top:1.5rem">
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Authorship &amp; Expertise</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">Anish Nath</a></li>
          <li><strong>Background:</strong> Math and developer tools for education</li>
          <li><strong>Method:</strong> Gaussian elimination to REF</li>
        </ul>
      </div>
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Trust &amp; Privacy</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Privacy:</strong> All calculations run locally; no data stored</li>
          <li><strong>Client-side:</strong> Your matrices never leave your device</li>
          <li><strong>Support:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">@anish2good</a></li>
        </ul>
      </div>
    </div>
  </div>
</section>

<section id="faq" style="max-width:900px;margin:2rem auto;padding:0 1.5rem">
  <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">Matrix Rank: FAQ</h2>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">How do I find the rank of a matrix?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Enter your matrix and click Calculate. The tool reduces it to row echelon form (REF) and counts non-zero rows (pivot rows) to obtain rank(A).</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What is nullity and how is it related to rank?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Nullity is the dimension of the null space. For an m×n matrix, the rank-nullity theorem states rank(A) + nullity(A) = n.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What does rank tell me about a matrix?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Full rank means maximum linearly independent columns. If rank(A) &lt; n for an n×n square matrix, A is singular and not invertible.</p>
  </div>
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"How do I find the rank of a matrix?","acceptedAnswer":{"@type":"Answer","text":"Enter your matrix and click Calculate. The tool reduces it to row echelon form (REF) and counts non-zero rows (pivot rows) to obtain rank(A)."}},
    {"@type":"Question","name":"What is nullity and how is it related to rank?","acceptedAnswer":{"@type":"Answer","text":"Nullity is the dimension of the null space. For an m×n matrix, the rank-nullity theorem states rank(A) + nullity(A) = n."}},
    {"@type":"Question","name":"What does rank tell me about a matrix?","acceptedAnswer":{"@type":"Answer","text":"Full rank means maximum linearly independent columns. If rank(A) < n for an n×n square matrix, A is singular and not invertible."}}
  ]
}
</script>

<%@ include file="modern/ads/ad-in-content-mid.jsp"%>
<%@ include file="modern/components/support-section.jsp"%>
<%@ include file="modern/ads/ad-sticky-footer.jsp"%>

<footer class="page-footer">
  <div class="footer-content">
    <p class="footer-text">&copy; <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %> 8gwifi.org - Free Online Tools</p>
    <div class="footer-links">
      <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
      <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
      <a href="https://x.com/anish2good" target="_blank" rel="noopener" class="footer-link">X</a>
    </div>
  </div>
</footer>

<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
</body>
</html>
