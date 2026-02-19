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
    <jsp:param name="toolName" value="Matrix Inverse Calculator | A⁻¹ Free Gauss-Jordan" />
    <jsp:param name="toolDescription" value="Free matrix inverse calculator A⁻¹. Gauss-Jordan elimination, step-by-step. [A|I]→[I|A⁻¹]. Print worksheet with practice exercises. Share, download. 2×2 to 6×6." />
    <jsp:param name="toolCategory" value="Math Tools" />
    <jsp:param name="toolUrl" value="matrix-inverse-calculator.jsp" />
    <jsp:param name="toolKeywords" value="matrix inverse calculator, inverse matrix, A inverse, Gauss-Jordan elimination, adjugate matrix, matrix inversion, linear algebra calculator, invertible matrix, A^-1" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="toolFeatures" value="Gauss-Jordan elimination,Print worksheet with practice exercises,Share URL and download,Singularity detection,2×2 to 6×6,Step-by-step solutions" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="faq1q" value="How do I find the inverse of a matrix?" />
    <jsp:param name="faq1a" value="Enter your square matrix and click Calculate. The tool performs Gauss-Jordan elimination on the augmented matrix [A | I] until it reaches [I | A⁻¹]. If det(A) = 0 at any point, the matrix is singular and has no inverse." />
    <jsp:param name="faq2q" value="When does a matrix not have an inverse?" />
    <jsp:param name="faq2a" value="A matrix is non-invertible (singular) when det(A) = 0. This typically happens when rows or columns are linearly dependent, or rank(A) &lt; n for an n×n matrix." />
    <jsp:param name="faq3q" value="What sizes and checks are supported?" />
    <jsp:param name="faq3a" value="This calculator supports 2×2 up to 6×6 matrices. It includes optional verification that A × A⁻¹ = I, and shows intermediate Gauss-Jordan steps." />
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
    :root { --tool-primary:#3b82f6; --tool-gradient:linear-gradient(135deg,#3b82f6 0%,#1d4ed8 100%); --tool-light:#eff6ff }
    .inverse-calc .verification-card{border-left:4px solid #10b981;background:linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%);border-radius:8px;padding:1.25rem;margin:1rem 0}
    .inverse-calc .augmented-matrix{display:inline-block;position:relative}
    .inverse-calc .augmented-divider{position:absolute;left:50%;top:10%;bottom:10%;width:2px;background:#94a3b8}
    .tool-btn-outline{background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);padding:0.5rem 1rem;font-size:0.875rem;border-radius:0.5rem;cursor:pointer}
    .tool-btn-outline:hover{background:var(--tool-light)}
    .matrix-example-grid{display:flex;flex-direction:column;gap:0.5rem}
    .matrix-example-btn{text-align:left;padding:0.5rem 0.75rem;font-size:0.8125rem;border:1px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);cursor:pointer;transition:all .15s}
    .matrix-example-btn:hover{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary)}
    .tool-checkbox-wrap{display:flex;align-items:center;gap:0.5rem;cursor:pointer;font-size:0.875rem;color:var(--text-secondary);margin-bottom:0.5rem}
    .tool-checkbox-wrap input{width:1.125rem;height:1.125rem;accent-color:var(--tool-primary)}
  </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp"%>

<header class="tool-page-header">
  <div class="tool-page-header-inner">
    <div>
      <h1 class="tool-page-title">Matrix Inverse Calculator</h1>
      <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
        <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
        <span>Matrix Inverse</span>
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
      <p>Calculate the inverse of any square invertible matrix using Gauss-Jordan elimination. [A|I] → [I|A⁻¹]. <strong>100% client-side</strong>—no data sent to servers. Supports 2×2 to 6×6.</p>
    </div>
  </div>
</section>

<main class="tool-page-container">
  <div class="tool-input-column">
    <div class="tool-card matrix-calc inverse-calc">
      <div class="tool-card-header">Matrix Input</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixSize">Matrix Size (n×n)</label>
          <div style="display:flex;gap:0.5rem;align-items:center">
            <input id="matrixSize" type="number" min="2" max="6" class="tool-input" value="3" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);flex:1;font-size:0.875rem">
            <button type="button" id="btnRandom" class="tool-btn-outline" style="flex-shrink:0" title="Generate random matrix">Random</button>
          </div>
          <span class="tool-form-hint">Supports 2×2 up to 6×6 matrices</span>
        </div>
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixInput">Matrix Entries</label>
          <textarea id="matrixInput" class="tool-input" rows="8" placeholder="Enter matrix entries:
1 2 3
0 1 4
5 6 0" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-family:var(--font-mono,'monospace');font-size:0.875rem;resize:vertical"></textarea>
          <span class="tool-form-hint">One row per line, space or comma separated</span>
        </div>
        <div class="tool-form-group">
          <label class="tool-checkbox-wrap"><input type="checkbox" id="showSteps" checked><span>Show detailed steps</span></label>
          <label class="tool-checkbox-wrap"><input type="checkbox" id="verifyResult" checked><span>Verify A × A⁻¹ = I</span></label>
        </div>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.5rem">
          <button type="button" id="btnCalculate" class="tool-action-btn" style="padding:0.5rem 1rem;margin-top:0">Calculate Inverse</button>
          <button type="button" id="btnClear" class="tool-btn-outline" style="margin-top:0">Clear</button>
        </div>
        <div id="inputError" class="tool-form-hint" style="color:var(--error,#ef4444);display:none;margin-top:0.5rem"></div>
      </div>
    </div>

    <div class="tool-card matrix-calc inverse-calc">
      <div class="tool-card-header">Quick Presets</div>
      <div class="tool-card-body">
        <div class="matrix-example-grid">
          <button type="button" class="matrix-example-btn" data-preset="identity">Identity (3×3)</button>
          <button type="button" class="matrix-example-btn" data-preset="diagonal">Diagonal Matrix</button>
          <button type="button" class="matrix-example-btn" data-preset="example1">Example 1 (3×3)</button>
          <button type="button" class="matrix-example-btn" data-preset="example2">Example 2 (2×2)</button>
        </div>
      </div>
    </div>
  </div>

  <div class="tool-output-column">
    <div class="tool-card matrix-calc inverse-calc">
      <div class="tool-card-header" style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:0.5rem">
        <span>Inverse Matrix Result</span>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap">
          <button type="button" id="btnShareURL" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem" title="Copy URL to clipboard">Share URL</button>
          <button type="button" id="btnDownloadImage" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem" title="Download result as image">Download Image</button>
          <button type="button" id="btnPrintWorksheet" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem;background:linear-gradient(135deg,#64748b,#475569);color:#fff;border:none" title="Print worksheet">&#128424; Print Worksheet</button>
        </div>
      </div>
      <div class="tool-card-body">
        <div id="resultArea" style="text-align:center;color:var(--text-muted);padding:1rem">Enter an invertible square matrix and click "Calculate Inverse" to see the result.</div>
      </div>
    </div>

    <div class="tool-card matrix-calc inverse-calc">
      <div class="tool-card-header">Step-by-Step Solution</div>
      <div class="tool-card-body">
        <div id="stepsArea" style="color:var(--text-muted)">Detailed Gauss-Jordan elimination steps will appear here.</div>
      </div>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
      <jsp:param name="currentToolUrl" value="matrix-inverse-calculator.jsp" />
      <jsp:param name="keyword" value="matrix" />
      <jsp:param name="limit" value="6" />
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
  const showSteps = document.getElementById('showSteps');
  const verifyResult = document.getElementById('verifyResult');
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
  const formatMatrix = MatrixUtils.formatMatrix;

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

  const createIdentity = MatrixUtils.createIdentity;
  const multiply = MatrixUtils.multiply;

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
                ? '✓ Result verified! A × A⁻¹ = I'
                : '⚠ Minor numerical errors present (expected for floating point)'}
            </div>
          </div>
        `;
      }

      resultArea.innerHTML = html;

      if(showSteps.checked) {
        let stepsHtml = '<div class="mb-4"><h5 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Gauss-Jordan Steps</h5></div>';
        stepsHtml += '<p class="text-muted mb-4" style="font-size:0.95rem">Watch the transformation: [A | I] → [I | A⁻¹]</p>';

        result.steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card"><div class="step-inner">`;
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
      resultArea.innerHTML = '<div style="padding:1rem;background:rgba(239,68,68,0.1);border:1px solid var(--error);border-radius:0.5rem;color:var(--error)">' + err.message + '</div>';
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

  // Share URL
  MatrixUtils.shareURL(document.getElementById('btnShareURL'), function() {
    const matrixText = matrixInput.value.trim();
    if(!matrixText) { alert('Please enter a matrix first!'); return null; }
    return { size: matrixSize.value, matrix: btoa(encodeURIComponent(matrixText)) };
  });

  // Download Image
  MatrixUtils.downloadImage(document.getElementById('btnDownloadImage'), 'matrix-inverse', 'No result to download. Please calculate an inverse first.');
  MatrixUtils.printWorksheet(document.getElementById('btnPrintWorksheet'), 'Matrix Inverse', { exerciseType: 'inverse' });

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
    loadPreset('example1');
  }
})();
</script>

<section style="max-width:900px;margin:2rem auto;padding:0 1.5rem">
  <div class="tool-card" style="padding:2rem;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-secondary)">
    <h2 id="eeat" style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">About This Matrix Inverse Tool &amp; Methodology</h2>
    <p style="margin-bottom:1rem;color:var(--text-secondary);line-height:1.7">The inverse A⁻¹ satisfies A × A⁻¹ = I. This tool uses Gauss-Jordan elimination on [A|I] to produce [I|A⁻¹]. A matrix is singular (no inverse) when det(A)=0. <strong>All calculations run client-side</strong>—no data stored.</p>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5rem;margin-top:1.5rem">
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Authorship &amp; Expertise</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">Anish Nath</a></li>
          <li><strong>Background:</strong> Math and developer tools for education</li>
          <li><strong>Method:</strong> Gauss-Jordan elimination</li>
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
  <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">Matrix Inverse: FAQ</h2>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">How do I find the inverse of a matrix?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Enter your square matrix and click Calculate. The tool performs Gauss-Jordan elimination on the augmented matrix [A | I] until it reaches [I | A⁻¹]. If det(A) = 0 at any point, the matrix is singular and has no inverse.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">When does a matrix not have an inverse?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">A matrix is non-invertible (singular) when det(A) = 0. This typically happens when rows or columns are linearly dependent, or rank(A) &lt; n for an n×n matrix.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What sizes and checks are supported?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">This calculator supports 2×2 up to 6×6 matrices. It includes optional verification that A × A⁻¹ = I, and shows intermediate Gauss-Jordan steps.</p>
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

<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
</body>
</html>
