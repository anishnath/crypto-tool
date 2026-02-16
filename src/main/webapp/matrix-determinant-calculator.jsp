<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="robots" content="index,follow">
  <meta name="resource-type" content="document">
  <meta name="language" content="en">
  <meta name="author" content="Anish Nath">

  <jsp:include page="modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Matrix Determinant Calculator | det(A) 2×2 to 10×10 Free" />
    <jsp:param name="toolDescription" value="Free matrix determinant calculator. det(A) for 2×2 to 10×10. LU, cofactor expansion, Gaussian elimination. Step-by-step. Print worksheet with practice exercises. Share, download." />
    <jsp:param name="toolCategory" value="Mathematics" />
    <jsp:param name="toolUrl" value="matrix-determinant-calculator.jsp" />
    <jsp:param name="toolKeywords" value="determinant calculator, det(A), matrix determinant, 2x2 3x3 determinant, cofactor expansion, LU decomposition, linear algebra, homework help" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="toolFeatures" value="LU decomposition and cofactor expansion,Gaussian elimination,Print worksheet with practice exercises,Share URL and download,2×2 to 10×10 matrices,Step-by-step solutions" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="faq1q" value="How do I calculate the determinant of a matrix?" />
    <jsp:param name="faq1a" value="Enter a square matrix and click Calculate. The tool shows step-by-step methods such as cofactor expansion and row operations; for larger sizes it may use LU decomposition for efficiency." />
    <jsp:param name="faq2q" value="What sizes and methods are supported?" />
    <jsp:param name="faq2a" value="This calculator supports square matrices from 2×2 up to 10×10 and can display cofactor expansion steps, row-operation reductions, and LU-based computations." />
    <jsp:param name="faq3q" value="What does det(A) = 0 mean?" />
    <jsp:param name="faq3a" value="det(A) = 0 indicates the matrix is singular: rows/columns are linearly dependent, rank is less than n, and A is not invertible." />
    <jsp:param name="faq4q" value="Can I print determinant practice worksheets?" />
    <jsp:param name="faq4a" value="Yes. Click Print Worksheet to get your result plus practice exercises (2×2 and 3×3 determinants) with answer blanks for homework or exams." />
  </jsp:include>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
  <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"></noscript>

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
    :root { --tool-primary:#3b82f6; --tool-primary-dark:#1d4ed8; --tool-gradient:linear-gradient(135deg,#3b82f6 0%,#1d4ed8 100%); --tool-light:#eff6ff }
    .det-calculator .result-value{font-size:2rem;font-weight:700;color:#059669;font-family:monospace}
    .method-badge{display:inline-flex;align-items:center;padding:0.3rem 0.6rem;border-radius:999px;font-size:0.85rem;margin:0.25rem;font-weight:500;background:var(--tool-light);color:var(--tool-primary)}
    .tool-btn-outline{background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);padding:0.5rem 1rem;font-size:0.875rem;border-radius:0.5rem;cursor:pointer}
    .tool-btn-outline:hover{background:var(--tool-light)}
    .matrix-example-grid{display:flex;flex-direction:column;gap:0.5rem}
    .matrix-example-btn{text-align:left;padding:0.5rem 0.75rem;font-size:0.8125rem;border:1px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);cursor:pointer;transition:all .15s}
    .matrix-example-btn:hover{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary)}
    @media (max-width: 767px) { .det-calculator .result-value{font-size:1.5rem} }
  </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp"%>

<header class="tool-page-header">
  <div class="tool-page-header-inner">
    <div>
      <h1 class="tool-page-title">Matrix Determinant Calculator</h1>
      <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
        <a href="<%=request.getContextPath()%>/index.jsp#mathematics">Mathematics</a> /
        <span>Matrix Determinant</span>
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
      <p>Calculate the determinant of any square matrix with detailed step-by-step solutions. LU decomposition, cofactor expansion, or Gaussian elimination. <strong>100% client-side</strong>—no data sent to servers. Supports 2×2 to 10×10.</p>
    </div>
  </div>
</section>

<main class="tool-page-container">
  <div class="tool-input-column">
    <div class="tool-card matrix-calc det-calculator">
      <div class="tool-card-header">Matrix Input</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixSize">Matrix Size (n×n)</label>
          <div style="display:flex;gap:0.5rem;align-items:center">
            <input id="matrixSize" type="number" min="2" max="10" class="tool-input" value="3" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);flex:1;font-size:0.875rem">
            <button type="button" id="btnRandom" class="tool-btn-outline" style="flex-shrink:0" title="Generate random matrix">Random</button>
          </div>
          <span class="tool-form-hint">Supports 2×2 up to 10×10 square matrices</span>
        </div>
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixInput">Matrix Entries</label>
          <textarea id="matrixInput" class="tool-input" rows="8" placeholder="Enter matrix entries:
1 2 3
4 5 6
7 8 9" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-family:var(--font-mono,'monospace');font-size:0.875rem;resize:vertical"></textarea>
          <span class="tool-form-hint">One row per line, space or comma separated</span>
        </div>
        <div class="tool-form-group">
          <label class="tool-form-label" for="methodSelect">Computation Method</label>
          <select id="methodSelect" class="tool-input" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-size:0.875rem">
            <option value="lu">LU Decomposition (Fastest)</option>
            <option value="cofactor">Cofactor Expansion</option>
            <option value="gaussian">Gaussian Elimination</option>
          </select>
        </div>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.5rem">
          <button type="button" id="btnCalculate" class="tool-action-btn" style="padding:0.5rem 1rem;margin-top:0">Calculate Determinant</button>
          <button type="button" id="btnClear" class="tool-btn-outline" style="margin-top:0">Clear</button>
        </div>
        <div id="inputError" class="tool-form-hint" style="color:var(--error,#ef4444);display:none;margin-top:0.5rem"></div>
      </div>
    </div>

    <div class="tool-card matrix-calc det-calculator">
      <div class="tool-card-header">Quick Presets</div>
      <div class="tool-card-body">
        <div class="matrix-example-grid">
          <button type="button" class="matrix-example-btn" data-preset="identity">Identity Matrix (3×3)</button>
          <button type="button" class="matrix-example-btn" data-preset="diagonal">Diagonal Matrix</button>
          <button type="button" class="matrix-example-btn" data-preset="triangular">Triangular Matrix</button>
          <button type="button" class="matrix-example-btn" data-preset="random">Random Matrix</button>
        </div>
      </div>
    </div>
  </div>

  <div class="tool-output-column">
    <div class="tool-card matrix-calc det-calculator">
      <div class="tool-card-header" style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:0.5rem">
        <span>Result</span>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap">
          <button type="button" id="btnShareURL" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem" title="Copy URL to clipboard">Share URL</button>
          <button type="button" id="btnDownloadImage" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem" title="Download result as image">Download Image</button>
          <button type="button" id="btnPrintWorksheet" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem;background:linear-gradient(135deg,#64748b,#475569);color:#fff;border:none" title="Print worksheet">&#128424; Print Worksheet</button>
        </div>
      </div>
      <div class="tool-card-body">
        <div id="resultArea" style="text-align:center;color:var(--text-muted);padding:1rem">Enter a square matrix and click "Calculate Determinant" to see the result.</div>
      </div>
    </div>

    <div class="tool-card matrix-calc det-calculator">
      <div class="tool-card-header">Step-by-Step Solution</div>
      <div class="tool-card-body">
        <div id="stepsArea" style="color:var(--text-muted)">Detailed steps will appear here after calculation.</div>
      </div>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
      <jsp:param name="currentToolUrl" value="matrix-determinant-calculator.jsp" />
      <jsp:param name="keyword" value="matrix" />
      <jsp:param name="limit" value="6" />
    </jsp:include>
  </div>

  <div class="tool-ads-column">
    <%@ include file="modern/ads/ad-in-content-mid.jsp"%>
  </div>
</main>

<section style="max-width:900px;margin:2rem auto;padding:0 1.5rem">
  <div class="tool-card" style="padding:2rem;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-secondary)">
    <h2 id="eeat" style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">About This Matrix Determinant Tool &amp; Methodology</h2>
    <p style="margin-bottom:1rem;color:var(--text-secondary);line-height:1.7">The determinant det(A) is a scalar computed from a square matrix. Key properties: det(I)=1, det(AB)=det(A)×det(B), det(A<sup>T</sup>)=det(A). If det(A)=0 the matrix is singular (not invertible). This tool computes det(A) using LU decomposition, cofactor expansion, or Gaussian elimination. <strong>All calculations run client-side</strong>—no data stored.</p>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5rem;margin-top:1.5rem">
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Authorship &amp; Expertise</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">Anish Nath</a></li>
          <li><strong>Background:</strong> Math and developer tools for education</li>
          <li><strong>Methods:</strong> LU, cofactor expansion, Gaussian elimination</li>
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
  <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">Matrix Determinant: FAQ</h2>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">How do I calculate the determinant of a matrix?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Enter a square matrix and click Calculate. The tool shows step-by-step methods such as cofactor expansion and row operations; for larger sizes it may use LU decomposition for efficiency.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What sizes and methods are supported?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">This calculator supports square matrices from 2×2 up to 10×10 and can display cofactor expansion steps, row-operation reductions, and LU-based computations.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What does det(A) = 0 mean?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">det(A) = 0 indicates the matrix is singular: rows/columns are linearly dependent, rank is less than n, and A is not invertible.</p>
  </div>
</section>

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

  const EPS = MatrixUtils.EPS;
  const parseMatrix = (text, n) => MatrixUtils.parseMatrix(text, n, n);
  const cloneMatrix = MatrixUtils.cloneMatrix;
  const smartFormat = MatrixUtils.smartFormat;

  function formatMatrix(mat, highlightDiag = false) {
    const rows = mat.map((row, i) =>
      row.map((val, j) => {
        const num = Math.abs(val) < EPS ? 0 : val;
        const formatted = smartFormat(num);
        if(highlightDiag && i === j) return '\\textcolor{blue}{' + formatted + '}';
        if(i > j && Math.abs(num) < EPS) return '\\textcolor{gray}{0}';
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
        for(let c = i; c < n; c++) A[r][c] -= factor * A[i][c];
      }
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
        }
        for(let c = i; c < n; c++) A[r][c] -= factor * A[i][c];
      }
      if(rowOpsInStep.length > 0) {
        steps.push(`<div class="text-secondary">${rowOpsInStep.join(', ')}</div>`);
        steps.push(`<div class="matrix-display mt-2">$$${formatMatrix(A, true)}$$</div>`);
      }
    }
    for(let i = 0; i < n; i++) det *= A[i][i];
    steps.push(`<span class="text-success">Upper triangular matrix achieved (diagonal in blue):</span>`);
    steps.push(`<div class="matrix-display mt-2 mb-3">$$${formatMatrix(A, true)}$$</div>`);
    steps.push(`<strong>det(A) = product of diagonal</strong> = ${det.toFixed(6)}`);
    return {det, steps};
  }

  function calculate() {
    try {
      inputError.style.display = 'none';
      const n = parseInt(matrixSize.value);
      if(n < 2 || n > 10) throw new Error('Matrix size must be between 2 and 10');

      const matrix = parseMatrix(matrixInput.value, n);
      const method = methodSelect.value;

      let result;
      if(method === 'lu') result = determinantLU(matrix);
      else if(method === 'cofactor') result = determinantCofactor(matrix);
      else result = determinantGaussian(matrix);

      const methodName = method === 'lu' ? 'LU Decomposition' : method === 'cofactor' ? 'Cofactor Expansion' : 'Gaussian Elimination';

      resultArea.innerHTML = `
        <div class="result-card">
          <div class="mb-2">Original Matrix:</div>
          <div class="matrix-display mb-3">$$${formatMatrix(matrix)}$$</div>
          <div class="mb-2"><span class="method-badge">${methodName}</span></div>
          <div class="mt-3">
            <div style="font-size:1.1rem;color:var(--text-secondary)">Determinant:</div>
            <div class="result-value">${result.det.toFixed(6)}</div>
          </div>
          ${Math.abs(result.det) < EPS ? '<div style="color:var(--warning,#f59e0b);margin-top:0.5rem">Matrix is singular (not invertible)</div>' : ''}
        </div>
      `;

      let stepsHtml = '<div class="mb-4"><h5 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Computation Steps</h5></div>';
      stepsHtml += '<p style="color:var(--text-muted);margin-bottom:1rem;font-size:0.95rem">Watch how the matrix transforms at each step:</p>';
      result.steps.forEach((step, idx) => {
        stepsHtml += `<div class="step-card"><div class="step-inner"><span class="step-number">${idx + 1}</span><div class="step-description">${step}</div></div></div>`;
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
    resultArea.innerHTML = '<div style="text-align:center;color:var(--text-muted);padding:1rem">Enter a square matrix and click "Calculate Determinant" to see the result.</div>';
    stepsArea.innerHTML = '<div style="color:var(--text-muted)">Detailed steps will appear here after calculation.</div>';
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
        for(let j = 0; j < n; j++) row.push(Math.floor(Math.random() * 20 - 10));
        rows.push(row.join(' '));
      }
      matrixInput.value = rows.join('\n');
    }
    calculate();
  }

  function generateRandom() {
    const n = parseInt(matrixSize.value);
    if(n < 2 || n > 10) { alert('Please set matrix size between 2 and 10'); return; }
    const rows = [];
    for(let i = 0; i < n; i++) {
      const row = [];
      for(let j = 0; j < n; j++) row.push(Math.floor(Math.random() * 21 - 10));
      rows.push(row.join(' '));
    }
    matrixInput.value = rows.join('\n');
    setTimeout(() => calculate(), 100);
  }

  btnCalculate.addEventListener('click', calculate);
  btnClear.addEventListener('click', clear);
  btnRandom.addEventListener('click', generateRandom);
  presetButtons.forEach(btn => btn.addEventListener('click', () => loadPreset(btn.dataset.preset)));

  matrixInput.addEventListener('keydown', e => {
    if(e.key === 'Enter' && (e.metaKey || e.ctrlKey)) calculate();
  });

  MatrixUtils.shareURL(document.getElementById('btnShareURL'), function() {
    const matrixText = matrixInput.value.trim();
    if(!matrixText) { alert('Please enter a matrix first!'); return null; }
    return { size: matrixSize.value, matrix: btoa(encodeURIComponent(matrixText)), method: methodSelect.value };
  });

  MatrixUtils.downloadImage(document.getElementById('btnDownloadImage'), 'matrix-determinant', 'No result to download. Please calculate a determinant first.');
  MatrixUtils.printWorksheet(document.getElementById('btnPrintWorksheet'), 'Matrix Determinant', { exerciseType: 'determinant' });

  const loaded = MatrixUtils.loadFromURL(function(p) {
    if(p.matrix && p.size) {
      matrixSize.value = p.size;
      matrixInput.value = p.matrix;
      if(p.method) methodSelect.value = p.method;
      setTimeout(() => calculate(), 100);
      return true;
    }
    return false;
  });
  if(!loaded) loadPreset('identity');
})();
</script>

<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
</body>
</html>
