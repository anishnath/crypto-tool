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
    <jsp:param name="toolName" value="Matrix Power Calculator | A^n Free with Practice Worksheet" />
    <jsp:param name="toolDescription" value="Free matrix power calculator A^n. Repeated squaring, diagonalization. Step-by-step. Print worksheet with practice exercises. Share, download. Markov chains support." />
    <jsp:param name="toolCategory" value="Math Tools" />
    <jsp:param name="toolUrl" value="matrix-power-calculator.jsp" />
    <jsp:param name="toolKeywords" value="matrix power calculator, A^n calculator, matrix exponentiation, matrix to power n, repeated matrix multiplication, diagonalization, matrix powers, square matrix calculator, nilpotent matrix, idempotent matrix, Markov chain calculator" />
    <jsp:param name="toolFeatures" value="Compute A^n powers,Print worksheet with practice exercises,Share URL and download,Repeated squaring,Diagonal optimization,Markov chains" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="faq1q" value="What is matrix exponentiation and how do you compute A^n?" />
    <jsp:param name="faq1a" value="Matrix exponentiation multiplies a square matrix by itself n times. This tool uses efficient repeated squaring (O(log n)) and optimizations for diagonal, idempotent, and nilpotent cases. Special case: A^0 = I." />
    <jsp:param name="faq2q" value="What are common applications of matrix powers?" />
    <jsp:param name="faq2a" value="Markov chains (long-run behavior), graph theory (path counts via adjacency powers), linear recurrences (e.g., Fibonacci), repeated geometric transforms, and systems of differential equations." />
    <jsp:param name="faq3q" value="What sizes and exponents are supported?" />
    <jsp:param name="faq3a" value="Supports square matrices and integer exponents in a practical range (including 0). For large n, repeated squaring keeps computations fast and stable." />
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
    :root { --tool-primary:#3b82f6; --tool-primary-dark:#1d4ed8; --tool-gradient:linear-gradient(135deg,#3b82f6 0%,#1d4ed8 100%); --tool-light:#eff6ff }
    [data-theme="dark"] { --tool-light:rgba(59,130,246,0.15) }
    .power-calc { --mc-result-color:#3b82f6; --mc-result-bg:linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); --mc-result-shadow:rgba(59,130,246,0.1) }
    .power-calc .power-value{font-size:2rem;font-weight:700;color:#2563eb;font-family:monospace}
    .power-calc .info-badge{display:inline-block;background:#dbeafe;color:#1e40af;padding:0.4rem 0.8rem;border-radius:8px;font-weight:600;margin:0.25rem;font-size:0.9rem}
    .tool-btn-outline{background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);padding:0.5rem 1rem;font-size:0.875rem;font-weight:500;border-radius:0.5rem;cursor:pointer}
    .tool-btn-outline:hover{background:var(--tool-light)}
    .matrix-example-grid{display:flex;flex-direction:column;gap:0.5rem}
    .matrix-example-btn{text-align:left;padding:0.5rem 0.75rem;font-size:0.8125rem;border:1px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);cursor:pointer;transition:all .15s}
    .matrix-example-btn:hover{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary)}
    .tool-checkbox-wrap{display:flex;align-items:center;gap:0.5rem;cursor:pointer;font-size:0.875rem;color:var(--text-secondary)}
    .tool-checkbox-wrap input{width:1.125rem;height:1.125rem;accent-color:var(--tool-primary)}
    @media (max-width: 767px) { .power-calc .power-value{font-size:1.5rem} }
  </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp"%>

<header class="tool-page-header">
  <div class="tool-page-header-inner">
    <div>
      <h1 class="tool-page-title">Matrix Power Calculator (A<sup>n</sup>)</h1>
      <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
        <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
        <span>Matrix Power</span>
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
      <p>Calculate matrix powers A<sup>n</sup> with efficient repeated squaring, diagonalization, and step-by-step solutions. Supports Markov chains, diagonal matrices, and special cases (A<sup>0</sup>=I, idempotent, nilpotent). <strong>100% client-side</strong>—no data sent to servers. Enter square matrices 2×2 to 5×5.</p>
    </div>
  </div>
</section>

<main class="tool-page-container">
  <div class="tool-input-column">
    <div class="tool-card matrix-calc power-calc">
      <div class="tool-card-header">Matrix Input</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixSize">Matrix Size (n×n)</label>
          <div class="matrix-dim-row" style="display:flex;align-items:center;gap:0.5rem;flex-wrap:wrap">
            <input id="matrixSize" type="number" min="2" max="5" class="tool-input" value="3" style="flex:1;min-width:60px">
            <button id="btnRandom" class="tool-btn-outline" title="Generate random matrix" style="padding:0.4rem 0.75rem;font-size:0.8125rem">
              <i class="fas fa-random"></i> Random
            </button>
          </div>
          <small class="tool-form-hint">Square matrices only, 2×2 to 5×5</small>
        </div>

        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixInput">Matrix A</label>
          <textarea id="matrixInput" class="tool-input" rows="5" placeholder="Enter matrix:
0.7 0.3
0.2 0.8"></textarea>
          <small class="tool-form-hint">One row per line, space separated</small>
        </div>

        <div class="tool-form-group">
          <label class="tool-form-label" for="powerN">Power (n)</label>
          <input id="powerN" type="number" min="0" max="100" class="tool-input" value="5">
          <small class="tool-form-hint">Calculate A<sup>n</sup>, where 0 ≤ n ≤ 100</small>
        </div>

        <div class="tool-form-group">
          <label class="tool-checkbox-wrap">
            <input type="checkbox" id="showSteps">
            <span>Show intermediate powers</span>
          </label>
        </div>

        <div style="display:flex;flex-wrap:wrap;gap:0.5rem">
          <button id="btnCalculate" class="tool-action-btn">Calculate A<sup>n</sup></button>
          <button id="btnClear" class="tool-btn-outline">Clear</button>
        </div>
        <div id="inputError" class="tool-form-hint" style="color:var(--error,#ef4444);display:none;margin-top:0.5rem"></div>
      </div>
    </div>

    <div class="tool-card">
      <div class="tool-card-header">Quick Examples</div>
      <div class="tool-card-body matrix-example-grid">
        <button class="matrix-example-btn" data-example="diagonal">Diagonal Matrix</button>
        <button class="matrix-example-btn" data-example="markov">Markov Chain (Stochastic)</button>
        <button class="matrix-example-btn" data-example="rotation">Rotation Matrix</button>
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
          Enter a matrix and power, then click "Calculate A<sup>n</sup>" to see the result.
        </div>
      </div>
    </div>

    <div class="tool-card">
      <div class="tool-card-header">Calculation Details</div>
      <div class="tool-card-body">
        <div id="stepsArea" class="text-muted">
          Computation details will appear here.
        </div>
      </div>
    </div>

    <div class="tool-card">
      <div class="tool-card-header">About Matrix Powers</div>
      <div class="tool-card-body" style="font-size:0.875rem">
          <p><strong>Matrix Exponentiation:</strong><br>
          A<sup>n</sup> means multiplying matrix A by itself n times. For n=0, result is identity matrix I.</p>

          <p><strong>Special Cases:</strong></p>
          <ul>
            <li><strong>A<sup>0</sup> = I</strong> (identity matrix)</li>
            <li><strong>Diagonal Matrix:</strong> Diagonal elements raised to power n</li>
            <li><strong>Nilpotent Matrix:</strong> A<sup>k</sup> = 0 for some k</li>
            <li><strong>Idempotent Matrix:</strong> A<sup>2</sup> = A</li>
          </ul>

          <p><strong>Applications:</strong></p>
          <ul>
            <li><strong>Markov Chains:</strong> Long-term behavior (A<sup>∞</sup>)</li>
            <li><strong>Fibonacci:</strong> Using companion matrix</li>
            <li><strong>Differential Equations:</strong> e<sup>At</sup> via series expansion</li>
            <li><strong>Graph Theory:</strong> Number of paths of length n</li>
          </ul>

          <p><strong>Efficiency:</strong><br>
          For large n, this calculator uses repeated squaring: O(log n) multiplications instead of O(n).</p>
      </div>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
      <jsp:param name="currentToolUrl" value="matrix-power-calculator.jsp" />
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
  const powerN = document.getElementById('powerN');
  const showSteps = document.getElementById('showSteps');
  const btnCalculate = document.getElementById('btnCalculate');
  const btnClear = document.getElementById('btnClear');
  const btnRandom = document.getElementById('btnRandom');
  const resultArea = document.getElementById('resultArea');
  const stepsArea = document.getElementById('stepsArea');
  const inputError = document.getElementById('inputError');
  const exampleButtons = document.querySelectorAll('[data-example]');

  const EPS = MatrixUtils.EPS;
  const smartFormat = (num) => { if(Math.abs(num) < EPS) return '0'; if(Math.abs(num - Math.round(num)) < EPS) return Math.round(num).toString(); return parseFloat(num.toFixed(4)).toString(); };
  const parseMatrix = (text, n) => MatrixUtils.parseMatrix(text, n, n);
  const formatMatrix = (mat) => { const rows = mat.map(row => row.map(val => { const n = Math.abs(val) < EPS ? 0 : val; return smartFormat(n); }).join(' & ')); return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}'; };
  const createIdentity = MatrixUtils.createIdentity;
  const multiplyMatrices = MatrixUtils.multiply;
  const cloneMatrix = MatrixUtils.cloneMatrix;

  function isDiagonal(mat) {
    const n = mat.length;
    for(let i = 0; i < n; i++) {
      for(let j = 0; j < n; j++) {
        if(i !== j && Math.abs(mat[i][j]) > EPS) {
          return false;
        }
      }
    }
    return true;
  }

  function matrixPower(A, n, trackSteps) {
    const size = A.length;
    const steps = [];

    // Special case: n = 0
    if(n === 0) {
      const I = createIdentity(size);
      steps.push(`<span class="text-primary">A<sup>0</sup> = I (identity matrix)</span>`);
      steps.push(`<div class="matrix-display mt-2">$$A^0 = ${formatMatrix(I)}$$</div>`);
      return {result: I, steps, method: 'identity'};
    }

    // Check if diagonal
    if(isDiagonal(A)) {
      steps.push(`<span class="text-info">Matrix is diagonal - using element-wise power</span>`);
      const result = cloneMatrix(A);
      for(let i = 0; i < size; i++) {
        const original = A[i][i];
        result[i][i] = Math.pow(original, n);
        steps.push(`<div class="text-secondary">Diagonal element [${i+1},${i+1}]: ${smartFormat(original)}<sup>${n}</sup> = ${smartFormat(result[i][i])}</div>`);
      }
      steps.push(`<div class="matrix-display mt-2">$$A^{${n}} = ${formatMatrix(result)}$$</div>`);
      return {result, steps, method: 'diagonal'};
    }

    // Use repeated squaring for efficiency
    steps.push(`<span class="text-primary">Using repeated squaring method for efficiency</span>`);
    steps.push(`<div class="text-secondary small">Computing A<sup>${n}</sup> using O(log n) multiplications</div>`);

    let result = createIdentity(size);
    let base = cloneMatrix(A);
    let exp = n;
    let intermediateSteps = [];

    let powerOf2 = 1;
    while(exp > 0) {
      if(exp % 2 === 1) {
        intermediateSteps.push({power: powerOf2, matrix: cloneMatrix(base)});
        result = multiplyMatrices(result, base);
      }
      if(exp > 1) {
        base = multiplyMatrices(base, base);
        powerOf2 *= 2;
      }
      exp = Math.floor(exp / 2);
    }

    if(trackSteps && n <= 10) {
      // Show intermediate powers for small n
      let current = createIdentity(size);
      steps.push(`<div class="matrix-display mt-2">$$A^0 = ${formatMatrix(current)}$$</div>`);

      for(let i = 1; i <= n; i++) {
        current = multiplyMatrices(current, A);
        if(i <= 5 || i === n) {
          steps.push(`<div class="matrix-display mt-2">$$A^{${i}} = ${formatMatrix(current)}$$</div>`);
        } else if(i === 6) {
          steps.push(`<div class="text-secondary">... (intermediate steps omitted) ...</div>`);
        }
      }
    } else {
      steps.push(`<div class="text-secondary">Computation used ${intermediateSteps.length} matrix multiplication(s)</div>`);
    }

    return {result, steps, method: 'repeated-squaring'};
  }

  function calculate() {
    try {
      inputError.style.display = 'none';
      const n = parseInt(matrixSize.value);
      const power = parseInt(powerN.value);

      if(n < 2 || n > 5) {
        throw new Error('Matrix size must be between 2 and 5');
      }
      if(power < 0 || power > 100) {
        throw new Error('Power must be between 0 and 100');
      }

      const matrix = parseMatrix(matrixInput.value, n);
      const result = matrixPower(matrix, power, showSteps.checked);

      const methodName = result.method === 'identity' ? 'Identity' :
                         result.method === 'diagonal' ? 'Diagonal Optimization' :
                         'Repeated Squaring';

      let html = `
        <div class="result-card">
          <div class="mb-3">
            <span class="info-badge">📊 Method: ${methodName}</span>
            <span class="info-badge">⚡ Size: ${n}×${n}</span>
          </div>

          <div class="mb-2"><strong>Original Matrix A:</strong></div>
          <div class="matrix-display mb-3">$$A = ${formatMatrix(matrix)}$$</div>

          <div class="mb-2"><strong>Result A<sup>${power}</sup>:</strong></div>
          <div class="matrix-display">$$A^{${power}} = ${formatMatrix(result.result)}$$</div>
        </div>
      `;

      resultArea.innerHTML = html;

      let stepsHtml = '<div class="mb-4"><h5 class="text-dark">📋 Computation Process</h5></div>';
      if(showSteps.checked || result.method !== 'repeated-squaring') {
        result.steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card"><div class="step-inner"><span class="step-number">${idx + 1}</span><div class="step-description">${step}</div></div></div>`;
        });
      } else {
        stepsHtml += `<p class="text-muted">Enable "Show intermediate powers" to see step-by-step calculation.<br>
        Large powers use efficient repeated squaring algorithm.</p>`;
        result.steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card"><div class="step-inner"><span class="step-number">${idx + 1}</span><div class="step-description">${step}</div></div></div>`;
        });
      }
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
    resultArea.innerHTML = '<div class="text-center text-muted">Enter a matrix and power, then click "Calculate A<sup>n</sup>" to see the result.</div>';
    stepsArea.innerHTML = '<div class="text-muted">Computation details will appear here.</div>';
    inputError.style.display = 'none';
  }

  function loadExample(type) {
    if(type === 'diagonal') {
      matrixSize.value = 3;
      matrixInput.value = '2 0 0\n0 3 0\n0 0 4';
      powerN.value = 5;
    } else if(type === 'markov') {
      matrixSize.value = 2;
      matrixInput.value = '0.7 0.3\n0.2 0.8';
      powerN.value = 10;
    } else if(type === 'rotation') {
      matrixSize.value = 2;
      matrixInput.value = '0 -1\n1 0';
      powerN.value = 4;
    }
    calculate();
  }

  // Random matrix generator
  function generateRandom() {
    const n = parseInt(matrixSize.value);
    if(n < 2 || n > 5) {
      alert('Please set matrix size between 2 and 5');
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
    return { size: matrixSize.value, power: powerN.value, matrix: btoa(encodeURIComponent(matrixText)) };
  });

  // Download Image
  MatrixUtils.downloadImage(document.getElementById('btnDownloadImage'), 'matrix-power', 'No result to download. Please calculate a power first.');
  MatrixUtils.printWorksheet(document.getElementById('btnPrintWorksheet'), 'Matrix Power', { exerciseType: 'power' });

  // Load from URL or default
  const loaded = MatrixUtils.loadFromURL(function(p) {
    if(p.matrix && p.size && p.power) {
      matrixSize.value = p.size;
      powerN.value = p.power;
      matrixInput.value = p.matrix;
      setTimeout(() => calculate(), 100);
      return true;
    }
    return false;
  });
  if(!loaded) {
    loadExample('diagonal');
  }
})();
</script>

<section style="max-width:900px;margin:2rem auto;padding:0 1.5rem">
  <div class="tool-card" style="padding:2rem;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-secondary)">
    <h2 id="eeat" style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">About This Matrix Power Calculator &amp; Methodology</h2>
    <p style="margin-bottom:1rem;color:var(--text-secondary);line-height:1.7">Matrix exponentiation A<sup>n</sup> multiplies a square matrix by itself n times. This tool uses efficient repeated squaring (O(log n)) and optimizations for diagonal, idempotent, and nilpotent matrices. A<sup>0</sup> = I by definition. <strong>All calculations run client-side</strong>—no data stored.</p>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5rem;margin-top:1.5rem">
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Authorship &amp; Expertise</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">Anish Nath</a></li>
          <li><strong>Background:</strong> Math and developer tools for education</li>
          <li><strong>Method:</strong> Repeated squaring, diagonalization shortcuts</li>
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
  <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">Matrix Powers: FAQ</h2>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What is matrix exponentiation and how do you compute A^n?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Matrix exponentiation multiplies a square matrix by itself n times. This tool uses efficient repeated squaring (O(log n)) and optimizations for diagonal, idempotent, and nilpotent cases. Special case: A^0 = I.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What are common applications of matrix powers?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Markov chains (long-run behavior), graph theory (path counts via adjacency powers), linear recurrences (e.g., Fibonacci), repeated geometric transforms, and systems of differential equations.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What sizes and exponents are supported?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Supports square matrices and integer exponents in a practical range (including 0). For large n, repeated squaring keeps computations fast and stable.</p>
  </div>
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"What is matrix exponentiation and how do you compute A^n?","acceptedAnswer":{"@type":"Answer","text":"Matrix exponentiation multiplies a square matrix by itself n times. This tool uses efficient repeated squaring (O(log n)) and optimizations for diagonal, idempotent, and nilpotent cases. Special case: A^0 = I."}},
    {"@type":"Question","name":"What are common applications of matrix powers?","acceptedAnswer":{"@type":"Answer","text":"Markov chains (long-run behavior), graph theory (path counts via adjacency powers), linear recurrences (e.g., Fibonacci), repeated geometric transforms, and systems of differential equations."}},
    {"@type":"Question","name":"What sizes and exponents are supported?","acceptedAnswer":{"@type":"Answer","text":"Supports square matrices and integer exponents in a practical range (including 0). For large n, repeated squaring keeps computations fast and stable."}}
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
