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
    <jsp:param name="toolName" value="Matrix Transpose Calculator | A^T Free with Practice Worksheet" />
    <jsp:param name="toolDescription" value="Free matrix transpose calculator. Compute A^T, check symmetric and skew-symmetric. Step-by-step solutions. Print practice worksheet with exercises. Share and download. Instant results." />
    <jsp:param name="toolCategory" value="Math Tools" />
    <jsp:param name="toolUrl" value="matrix-transpose-calculator.jsp" />
    <jsp:param name="toolKeywords" value="matrix transpose calculator, A^T calculator, transpose matrix, symmetric matrix checker, skew-symmetric matrix, transpose properties, matrix transposition, (A^T)^T = A, orthogonal matrix, linear algebra calculator" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="toolFeatures" value="Compute A^T transpose,Symmetric and skew-symmetric check,Print worksheet with practice exercises,Share URL and download,Step-by-step solutions,Up to 10×10" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="faq1q" value="What is a matrix transpose and how do you compute A^T?" />
    <jsp:param name="faq1a" value="The transpose A^T is obtained by swapping rows and columns: (A^T)_ij = A_ji. If A is m×n, then A^T is n×m. Key rules: (A^T)^T = A, (A+B)^T = A^T + B^T, and (AB)^T = B^T A^T." />
    <jsp:param name="faq2q" value="How do I check symmetric or skew-symmetric matrices?" />
    <jsp:param name="faq2a" value="A matrix is symmetric when A = A^T and skew-symmetric when A = -A^T (all diagonal entries are zero). This tool flags these properties automatically." />
    <jsp:param name="faq3q" value="Does transposing change determinant or rank?" />
    <jsp:param name="faq3a" value="For square matrices, det(A^T) = det(A) and rank(A^T) = rank(A). Transpose preserves determinant magnitude and rank." />
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
    .transpose-calc { --mc-result-color:#10b981 }
    .transpose-calc .property-card{border-left:4px solid #8b5cf6;background:linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);border-radius:8px;padding:1.25rem;margin:1rem 0}
    .transpose-calc .property-badge{display:inline-flex;align-items:center;padding:0.4rem 0.8rem;border-radius:999px;font-size:0.9rem;font-weight:600;margin:0.25rem}
    .property-badge.true{background:#d1fae5;color:#065f46}
    .property-badge.false{background:#fee2e2;color:#991b1b}
    .tool-btn-outline{background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);padding:0.5rem 1rem;font-size:0.875rem;border-radius:0.5rem;cursor:pointer}
    .tool-btn-outline:hover{background:var(--tool-light)}
    .matrix-dim-row{display:flex;align-items:center;gap:0.5rem;flex-wrap:wrap}
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
      <h1 class="tool-page-title">Matrix Transpose Calculator (A^T)</h1>
      <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
        <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
        <span>Matrix Transpose</span>
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
      <p>Calculate matrix transpose A^T, check symmetric and skew-symmetric matrices, and verify transpose properties. <strong>100% client-side</strong>—no data sent to servers. Supports matrices up to 10×10.</p>
    </div>
  </div>
</section>

<main class="tool-page-container">
  <div class="tool-input-column">
    <div class="tool-card matrix-calc transpose-calc">
      <div class="tool-card-header">Matrix Input</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label">Dimensions (m × n)</label>
          <div class="matrix-dim-row">
            <input id="rows" type="number" min="1" max="10" class="tool-input" value="3" placeholder="rows" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);flex:1;min-width:60px;font-size:0.875rem">
            <span style="color:var(--text-secondary)">×</span>
            <input id="cols" type="number" min="1" max="10" class="tool-input" value="2" placeholder="cols" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);flex:1;min-width:60px;font-size:0.875rem">
          </div>
        </div>
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixInput">Matrix Entries</label>
          <textarea id="matrixInput" class="tool-input" rows="6" placeholder="1 2
3 4
5 6" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-family:var(--font-mono,'monospace');font-size:0.875rem;resize:vertical"></textarea>
          <span class="tool-form-hint">One row per line, space separated</span>
        </div>
        <button type="button" id="btnRandom" class="tool-btn-outline" style="width:100%;margin-bottom:0.5rem">Random Matrix</button>
      </div>
    </div>

    <div class="tool-card matrix-calc transpose-calc">
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-checkbox-wrap"><input type="checkbox" id="showProperties" checked><span>Show matrix properties</span></label>
          <label class="tool-checkbox-wrap"><input type="checkbox" id="showSteps" checked><span>Show detailed steps</span></label>
        </div>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.5rem">
          <button type="button" id="btnCalculate" class="tool-action-btn" style="padding:0.5rem 1rem;margin-top:0">Calculate A^T</button>
          <button type="button" id="btnClear" class="tool-btn-outline" style="margin-top:0">Clear</button>
        </div>
        <div id="inputError" class="tool-form-hint" style="color:var(--error,#ef4444);display:none;margin-top:0.5rem"></div>
      </div>
    </div>

    <div class="tool-card matrix-calc transpose-calc">
      <div class="tool-card-header">Quick Examples</div>
      <div class="tool-card-body">
        <div class="matrix-example-grid">
          <button type="button" class="matrix-example-btn" data-example="rect">Rectangular (3×2)</button>
          <button type="button" class="matrix-example-btn" data-example="symmetric">Symmetric (3×3)</button>
          <button type="button" class="matrix-example-btn" data-example="skew">Skew-Symmetric (3×3)</button>
          <button type="button" class="matrix-example-btn" data-example="square">Square (4×4)</button>
        </div>
      </div>
    </div>
  </div>

  <div class="tool-output-column">
    <div class="tool-card matrix-calc transpose-calc">
      <div class="tool-card-header" style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:0.5rem">
        <span>Result: A^T</span>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap">
          <button type="button" id="btnShareURL" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem" title="Copy URL to clipboard">Share URL</button>
          <button type="button" id="btnDownloadImage" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem" title="Download result as image">Download Image</button>
          <button type="button" id="btnPrintWorksheet" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem;background:linear-gradient(135deg,#64748b,#475569);color:#fff;border:none" title="Print worksheet">&#128424; Print Worksheet</button>
        </div>
      </div>
      <div class="tool-card-body">
        <div id="resultArea" style="text-align:center;color:var(--text-muted);padding:1rem">Enter a matrix and click "Calculate A^T" to see the transpose.</div>
      </div>
    </div>

    <div class="tool-card matrix-calc transpose-calc" id="propertiesCard" style="display:none">
      <div class="tool-card-header">Matrix Properties</div>
      <div class="tool-card-body">
        <div id="propertiesArea"></div>
      </div>
    </div>

    <div class="tool-card matrix-calc transpose-calc">
      <div class="tool-card-header">Computation Steps</div>
      <div class="tool-card-body">
        <div id="stepsArea" style="color:var(--text-muted)">Detailed transpose computation steps will appear here.</div>
      </div>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
      <jsp:param name="currentToolUrl" value="matrix-transpose-calculator.jsp" />
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

  const EPS = MatrixUtils.EPS;
  const smartFormat = MatrixUtils.smartFormat;
  const parseMatrix = MatrixUtils.parseMatrix;
  const formatMatrix = MatrixUtils.formatMatrix;

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
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:0.5rem">
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
        let stepsHtml = '<div class="mb-4"><h5 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Transpose Process</h5></div>';
        steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card"><div class="step-inner"><span class="step-number">${idx + 1}</span><div class="step-description">${step}</div></div></div>`;
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
      resultArea.innerHTML = '<div style="padding:1rem;background:rgba(239,68,68,0.1);border:1px solid var(--error);border-radius:0.5rem;color:var(--error)">Error: ' + err.message + '</div>';
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

  // Share URL
  MatrixUtils.shareURL(document.getElementById('btnShareURL'), function() {
    return { m: rows.value, n: cols.value, matrix: btoa(encodeURIComponent(matrixInput.value.trim())) };
  });

  // Download Image
  MatrixUtils.downloadImage(document.getElementById('btnDownloadImage'), 'matrix-transpose', 'No result to download. Please calculate transpose first.');
  MatrixUtils.printWorksheet(document.getElementById('btnPrintWorksheet'), 'Matrix Transpose', { exerciseType: 'transpose' });

  // Load from URL or default
  const loaded = MatrixUtils.loadFromURL(function(p) {
    if(p.matrix) {
      rows.value = p.m || 3;
      cols.value = p.n || 2;
      matrixInput.value = p.matrix;
      setTimeout(() => calculate(), 100);
      return true;
    }
    return false;
  });
  if(!loaded) {
    loadExample('rect');
  }
})();
</script>

<section style="max-width:900px;margin:2rem auto;padding:0 1.5rem">
  <div class="tool-card" style="padding:2rem;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-secondary)">
    <h2 id="eeat" style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">About This Matrix Transpose Tool &amp; Methodology</h2>
    <p style="margin-bottom:1rem;color:var(--text-secondary);line-height:1.7">This matrix transpose calculator computes A^T by swapping rows and columns. All computations run <strong>client-side in your browser</strong>—no matrices are sent to any server. Supports symmetric and skew-symmetric detection, property checks, and step-by-step solutions up to 10×10.</p>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5rem;margin-top:1.5rem">
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Authorship &amp; Expertise</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">Anish Nath</a></li>
          <li><strong>Background:</strong> Math and developer tools for education</li>
          <li><strong>Standards:</strong> Standard linear algebra (transpose properties)</li>
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
  <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">Matrix Transpose: FAQ</h2>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What is a matrix transpose and how do you compute A^T?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">The transpose A^T is obtained by swapping rows and columns: (A^T)<sub>ij</sub> = A<sub>ji</sub>. If A is m×n, then A^T is n×m. Key rules: (A^T)^T = A, (A+B)^T = A^T + B^T, and (AB)^T = B^T A^T.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">How do I check symmetric or skew-symmetric matrices?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">A matrix is symmetric when A = A^T and skew-symmetric when A = -A^T (all diagonal entries are zero). This tool flags these properties automatically.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">Does transposing change determinant or rank?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">For square matrices, det(A^T) = det(A) and rank(A^T) = rank(A). Transpose preserves determinant magnitude and rank.</p>
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
