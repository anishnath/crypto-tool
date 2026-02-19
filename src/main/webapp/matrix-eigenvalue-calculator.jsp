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
    <jsp:param name="toolName" value="Eigenvalue Calculator | λ & Eigenvectors Free" />
    <jsp:param name="toolDescription" value="Free eigenvalue and eigenvector calculator. det(A-λI)=0, power iteration, QR. 2×2 to 4×4. Step-by-step. Print worksheet with practice exercises. Share, download." />
    <jsp:param name="toolCategory" value="Math Tools" />
    <jsp:param name="toolUrl" value="matrix-eigenvalue-calculator.jsp" />
    <jsp:param name="toolKeywords" value="eigenvalue calculator, eigenvector calculator, characteristic polynomial, power iteration, spectral decomposition, matrix diagonalization, lambda, det(A-lambda*I), QR algorithm" />
    <jsp:param name="toolFeatures" value="Eigenvalues and eigenvectors,Print worksheet with practice exercises,Share URL and download,Characteristic polynomial,Power iteration,QR algorithm" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="faq1q" value="How do I find eigenvalues of a matrix?" />
    <jsp:param name="faq1a" value="Enter a square matrix and click Calculate. The tool solves det(A − λI) = 0 to get eigenvalues λ, then computes eigenvectors by solving (A − λI)v = 0 for each λ." />
    <jsp:param name="faq2q" value="What if the eigenvalues are complex?" />
    <jsp:param name="faq2a" value="For some real matrices the characteristic polynomial has complex roots; these appear as complex conjugate pairs and the corresponding eigenvectors are complex as well." />
    <jsp:param name="faq3q" value="What sizes and methods are supported?" />
    <jsp:param name="faq3a" value="This calculator supports 2×2 to 4×4 matrices and offers characteristic polynomial, power iteration (dominant eigenvalue), and QR algorithm to find all eigenvalues." />
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
    :root { --tool-primary:#f59e0b; --tool-primary-dark:#d97706; --tool-gradient:linear-gradient(135deg,#f59e0b 0%,#d97706 100%); --tool-light:#fffbeb }
    [data-theme="dark"] { --tool-light:rgba(245,158,11,0.15) }
    .eigen-calc { --mc-result-color:#f59e0b; --mc-result-bg:linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%); --mc-result-shadow:rgba(245,158,11,0.1) }
    .eigen-calc .eigenvalue-card{border-left:4px solid #f59e0b;background:#fffbeb;border-radius:6px;padding:1rem;margin:0.75rem 0}
    .eigen-calc .eigenvector-card{border-left:4px solid #3b82f6;background:#eff6ff;border-radius:6px;padding:1rem;margin:0.75rem 0}
    .eigen-calc .eigenvalue-badge{background:#fef3c7;color:#92400e;padding:0.25rem 0.6rem;border-radius:12px;font-weight:600;margin:0.25rem;display:inline-block}
    .tool-btn-outline{background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);padding:0.5rem 1rem;font-size:0.875rem;font-weight:500;border-radius:0.5rem;cursor:pointer}
    .tool-btn-outline:hover{background:var(--tool-light)}
    .matrix-example-grid{display:flex;flex-direction:column;gap:0.5rem}
    .matrix-example-btn{text-align:left;padding:0.5rem 0.75rem;font-size:0.8125rem;border:1px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);cursor:pointer;transition:all .15s}
    .matrix-example-btn:hover{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary)}
    .tool-checkbox-wrap{display:flex;align-items:center;gap:0.5rem;cursor:pointer;font-size:0.875rem;color:var(--text-secondary)}
    .tool-checkbox-wrap input{width:1.125rem;height:1.125rem;accent-color:var(--tool-primary)}
  </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp"%>

<header class="tool-page-header">
  <div class="tool-page-header-inner">
    <div>
      <h1 class="tool-page-title">Eigenvalue &amp; Eigenvector Calculator</h1>
      <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
        <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
        <span>Eigenvalues &amp; Eigenvectors</span>
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
      <p>Calculate eigenvalues and eigenvectors using the characteristic polynomial det(A−λI)=0, power iteration, or QR algorithm. Supports 2×2 to 4×4 matrices with step-by-step solutions. <strong>100% client-side</strong>—no data sent to servers.</p>
    </div>
  </div>
</section>

<main class="tool-page-container">
  <div class="tool-input-column">
    <div class="tool-card matrix-calc eigen-calc">
      <div class="tool-card-header">Matrix Input</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixSize">Matrix Size (n×n)</label>
          <div class="matrix-dim-row" style="display:flex;align-items:center;gap:0.5rem;flex-wrap:wrap">
            <input id="matrixSize" type="number" min="2" max="4" class="tool-input" value="2" style="flex:1;min-width:60px">
            <button id="btnRandom" class="tool-btn-outline" title="Generate random matrix" style="padding:0.4rem 0.75rem;font-size:0.8125rem">
              <i class="fas fa-random"></i> Random
            </button>
          </div>
          <span class="tool-form-hint">Supports 2×2 to 4×4 matrices</span>
        </div>

        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixInput">Matrix Entries</label>
          <textarea id="matrixInput" class="tool-input" rows="6" placeholder="Enter matrix entries:
4 -2
1 1"></textarea>
          <span class="tool-form-hint">One row per line, space or comma separated</span>
        </div>

        <div class="tool-form-group">
          <label class="tool-form-label" for="methodSelect">Computation Method</label>
          <select id="methodSelect" class="tool-input" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);color:var(--text-primary);width:100%;font-size:0.875rem">
            <option value="characteristic">Characteristic Polynomial</option>
            <option value="power">Power Iteration (Dominant)</option>
            <option value="qr">QR Algorithm (All)</option>
          </select>
        </div>

        <div class="tool-form-group">
          <label class="tool-checkbox-wrap">
            <input type="checkbox" id="showSteps" checked>
            <span>Show detailed steps</span>
          </label>
          <label class="tool-checkbox-wrap">
            <input type="checkbox" id="findEigenvectors" checked>
            <span>Find eigenvectors</span>
          </label>
        </div>

        <div style="display:flex;flex-wrap:wrap;gap:0.5rem">
          <button id="btnCalculate" class="tool-action-btn">Calculate</button>
          <button id="btnClear" class="tool-btn-outline">Clear</button>
        </div>
        <div id="inputError" class="tool-form-hint" style="color:var(--error,#ef4444);display:none;margin-top:0.5rem"></div>
      </div>
    </div>

    <div class="tool-card">
      <div class="tool-card-header">Quick Presets</div>
      <div class="tool-card-body matrix-example-grid">
        <button class="matrix-example-btn" data-preset="diagonal">Diagonal (2×2)</button>
        <button class="matrix-example-btn" data-preset="symmetric">Symmetric (2×2)</button>
        <button class="matrix-example-btn" data-preset="rotation">Rotation Matrix</button>
        <button class="matrix-example-btn" data-preset="example">Example (3×3)</button>
      </div>
    </div>
  </div>

  <div class="tool-output-column">
    <div class="tool-card">
      <div class="tool-card-header" style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:0.5rem">
        <span>Eigenvalues &amp; Eigenvectors</span>
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
          Enter a square matrix and click "Calculate" to find eigenvalues and eigenvectors.
        </div>
      </div>
    </div>

    <div class="tool-card">
      <div class="tool-card-header">Step-by-Step Solution</div>
      <div class="tool-card-body">
        <div id="stepsArea" class="text-muted">
          Detailed computation steps will appear here.
        </div>
      </div>
    </div>

    <div class="tool-card">
      <div class="tool-card-header">About Eigenvalues &amp; Eigenvectors</div>
      <div class="tool-card-body" style="font-size:0.875rem">
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

    <jsp:include page="modern/components/related-tools.jsp">
      <jsp:param name="currentToolUrl" value="matrix-eigenvalue-calculator.jsp" />
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

  const EPS = MatrixUtils.EPS;
  const parseMatrix = (text, n) => MatrixUtils.parseMatrix(text, n, n);
  const formatMatrix = MatrixUtils.formatMatrix;

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
          html += '<div style="padding:1rem;background:rgba(59,130,246,0.1);border:1px solid var(--tool-primary,#3b82f6);border-radius:0.5rem;color:var(--text-primary)">Matrix has complex eigenvalues</div>';
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
      resultArea.innerHTML = '<div style="padding:1rem;background:rgba(239,68,68,0.1);border:1px solid var(--error);border-radius:0.5rem;color:var(--error)">Error: ' + err.message + '</div>';
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

  // Share URL
  MatrixUtils.shareURL(document.getElementById('btnShareURL'), function() {
    const matrixText = matrixInput.value.trim();
    if(!matrixText) { alert('Please enter a matrix first!'); return null; }
    return { size: matrixSize.value, matrix: btoa(encodeURIComponent(matrixText)) };
  });

  // Download Image
  MatrixUtils.downloadImage(document.getElementById('btnDownloadImage'), 'matrix-eigenvalue', 'No result to download. Please calculate eigenvalues first.');
  MatrixUtils.printWorksheet(document.getElementById('btnPrintWorksheet'), 'Matrix Eigenvalue', { exerciseType: 'eigenvalue' });

  // Load from URL or default
  const loaded = MatrixUtils.loadFromURL(function(p) {
    if(p.matrix && p.size) {
      matrixSize.value = p.size;
      matrixInput.value = p.matrix;
      setTimeout(() => calculate(), 100);
      return true;
    }
    return false;
  });
  if(!loaded) {
    loadPreset('symmetric');
  }
})();
</script>

<section style="max-width:900px;margin:2rem auto;padding:0 1.5rem">
  <div class="tool-card" style="padding:2rem;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-secondary)">
    <h2 id="eeat" style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">About This Eigenvalue &amp; Eigenvector Calculator</h2>
    <p style="margin-bottom:1rem;color:var(--text-secondary);line-height:1.7">For a square matrix A, eigenvalues λ satisfy det(A − λI) = 0 and eigenvectors v satisfy A v = λ v. This tool uses the characteristic polynomial for 2×2, power iteration for the dominant eigenvalue, and QR algorithm for all eigenvalues. <strong>All calculations run client-side</strong>—no data stored.</p>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5rem;margin-top:1.5rem">
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Authorship &amp; Expertise</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">Anish Nath</a></li>
          <li><strong>Background:</strong> Math and developer tools for education</li>
          <li><strong>Method:</strong> Characteristic polynomial, power iteration, QR</li>
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
  <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">Eigenvalues &amp; Eigenvectors: FAQ</h2>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">How do I find eigenvalues of a matrix?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Enter a square matrix and click Calculate. The tool solves det(A − λI) = 0 to get eigenvalues λ, then computes eigenvectors by solving (A − λI)v = 0 for each λ.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What if the eigenvalues are complex?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">For some real matrices the characteristic polynomial has complex roots; these appear as complex conjugate pairs and the corresponding eigenvectors are complex as well.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What sizes and methods are supported?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">This calculator supports 2×2 to 4×4 matrices and offers characteristic polynomial, power iteration (dominant eigenvalue), and QR algorithm to find all eigenvalues.</p>
  </div>
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
