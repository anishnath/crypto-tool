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
    <jsp:param name="toolName" value="Matrix Multiplication Calculator | A×B Free Online" />
    <jsp:param name="toolDescription" value="Free matrix multiplication calculator. Multiply A×B with dimension checker. Step-by-step dot product. Print worksheet with practice exercises. Share, download. Instant results." />
    <jsp:param name="toolCategory" value="Mathematics" />
    <jsp:param name="toolUrl" value="matrix-multiplication-calculator.jsp" />
    <jsp:param name="toolKeywords" value="matrix multiplication calculator, A×B calculator, matrix multiply, matrix product, linear algebra calculator, step by step matrix multiplication, matrix dimensions, compatible matrices, dot product, matrix operations" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="toolFeatures" value="A×B multiplication,Dimension compatibility checker,Print worksheet with practice exercises,Share URL and download image,Step-by-step dot product,Up to 10×10" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="faq1q" value="When are two matrices compatible for A×B?" />
    <jsp:param name="faq1a" value="A×B is defined when columns(A) = rows(B). If A is m×n and B is n×p, the product C is m×p. Each c_ij is the dot product of row i of A with column j of B." />
    <jsp:param name="faq2q" value="Is A×B the same as B×A?" />
    <jsp:param name="faq2a" value="No. Matrix multiplication is generally not commutative: A×B ≠ B×A. It is associative and distributive, and obeys (AB)^T = B^T A^T." />
    <jsp:param name="faq3q" value="What sizes are supported?" />
    <jsp:param name="faq3a" value="This tool supports rectangular and square matrices with dimensions up to 10×10, showing step-by-step computations." />
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
    .matmul-calc .dimension-badge{display:inline-flex;align-items:center;padding:0.4rem 0.8rem;border-radius:999px;font-size:0.9rem;font-weight:600;background:var(--tool-light);color:var(--tool-primary);margin:0.25rem}
    .matmul-calc .compatible{background:#d1fae5;color:#065f46}
    .matmul-calc .incompatible{background:#fee2e2;color:#991b1b}
    .tool-btn-outline{background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);padding:0.5rem 1rem;font-size:0.875rem;border-radius:0.5rem;cursor:pointer}
    .tool-btn-outline:hover{background:var(--tool-light)}
    .matrix-dim-row{display:flex;align-items:center;gap:0.5rem;flex-wrap:wrap}
    .matrix-dim-row input{flex:1;min-width:60px}
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
      <h1 class="tool-page-title">Matrix Multiplication Calculator (A × B)</h1>
      <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
        <a href="<%=request.getContextPath()%>/index.jsp#mathematics">Mathematics</a> /
        <span>Matrix Multiplication</span>
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
      <p>Multiply two matrices A×B with step-by-step visualization. Checks dimension compatibility (columns of A = rows of B). <strong>100% client-side</strong>—no data sent to servers. Supports rectangular matrices up to 10×10.</p>
    </div>
  </div>
</section>

<main class="tool-page-container">
  <div class="tool-input-column">
    <div class="tool-card matrix-calc matmul-calc">
      <div class="tool-card-header">Matrix A</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label">Dimensions (m × n)</label>
          <div class="matrix-dim-row">
            <input id="rowsA" type="number" min="1" max="10" class="tool-input" value="2" placeholder="rows" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);font-size:0.875rem">
            <span style="color:var(--text-secondary)">×</span>
            <input id="colsA" type="number" min="1" max="10" class="tool-input" value="3" placeholder="cols" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);font-size:0.875rem">
          </div>
        </div>
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixA">Matrix A Entries</label>
          <textarea id="matrixA" class="tool-input" rows="4" placeholder="1 2 3
4 5 6" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-family:var(--font-mono,'monospace');font-size:0.875rem;resize:vertical"></textarea>
          <span class="tool-form-hint">One row per line, space separated</span>
        </div>
        <button type="button" id="btnRandomA" class="tool-btn-outline" style="width:100%;margin-bottom:0.5rem">Random Matrix A</button>
      </div>
    </div>

    <div class="tool-card matrix-calc matmul-calc">
      <div class="tool-card-header">Matrix B</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label">Dimensions (p × q)</label>
          <div class="matrix-dim-row">
            <input id="rowsB" type="number" min="1" max="10" class="tool-input" value="3" placeholder="rows" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);font-size:0.875rem">
            <span style="color:var(--text-secondary)">×</span>
            <input id="colsB" type="number" min="1" max="10" class="tool-input" value="2" placeholder="cols" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);font-size:0.875rem">
          </div>
        </div>
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixB">Matrix B Entries</label>
          <textarea id="matrixB" class="tool-input" rows="4" placeholder="1 2
3 4
5 6" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-family:var(--font-mono,'monospace');font-size:0.875rem;resize:vertical"></textarea>
          <span class="tool-form-hint">One row per line, space separated</span>
        </div>
        <button type="button" id="btnRandomB" class="tool-btn-outline" style="width:100%;margin-bottom:0.5rem">Random Matrix B</button>
      </div>
    </div>

    <div class="tool-card matrix-calc matmul-calc">
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-checkbox-wrap"><input type="checkbox" id="showSteps" checked><span>Show detailed steps</span></label>
        </div>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.5rem">
          <button type="button" id="btnMultiply" class="tool-action-btn" style="padding:0.5rem 1rem;margin-top:0">Multiply A × B</button>
          <button type="button" id="btnClear" class="tool-btn-outline" style="margin-top:0">Clear</button>
        </div>
        <div id="inputError" class="tool-form-hint" style="color:var(--error,#ef4444);display:none;margin-top:0.5rem"></div>
      </div>
    </div>

    <div class="tool-card matrix-calc matmul-calc">
      <div class="tool-card-header">Quick Examples</div>
      <div class="tool-card-body">
        <div class="matrix-example-grid">
          <button type="button" class="matrix-example-btn" data-example="2x2">2×2 × 2×2</button>
          <button type="button" class="matrix-example-btn" data-example="2x3">2×3 × 3×2</button>
          <button type="button" class="matrix-example-btn" data-example="3x3">3×3 × 3×3</button>
          <button type="button" class="matrix-example-btn" data-example="incompatible">Incompatible (Error Demo)</button>
        </div>
      </div>
    </div>
  </div>

  <div class="tool-output-column">
    <div class="tool-card matrix-calc matmul-calc">
      <div class="tool-card-header" style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:0.5rem">
        <span>Result: A × B</span>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap">
          <button type="button" id="btnShareURL" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem" title="Copy URL to clipboard">Share URL</button>
          <button type="button" id="btnDownloadImage" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem" title="Download result as image">Download Image</button>
          <button type="button" id="btnPrintWorksheet" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem;background:linear-gradient(135deg,#64748b,#475569);color:#fff;border:none" title="Print worksheet">&#128424; Print Worksheet</button>
        </div>
      </div>
      <div class="tool-card-body">
        <div id="resultArea" style="text-align:center;color:var(--text-muted);padding:1rem">Enter two matrices and click "Multiply A × B" to see the result.</div>
      </div>
    </div>

    <div class="tool-card matrix-calc matmul-calc">
      <div class="tool-card-header">Computation Steps</div>
      <div class="tool-card-body">
        <div id="stepsArea" style="color:var(--text-muted)">Detailed multiplication steps will appear here.</div>
      </div>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
      <jsp:param name="currentToolUrl" value="matrix-multiplication-calculator.jsp" />
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
    <h2 id="eeat" style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">About This Matrix Multiplication Tool &amp; Methodology</h2>
    <p style="margin-bottom:1rem;color:var(--text-secondary);line-height:1.7">This matrix multiplication calculator computes C = A×B using the standard dot product formula. All computations run <strong>client-side in your browser</strong>—no matrices are sent to any server. Supports compatible dimensions (columns of A = rows of B) up to 10×10 with step-by-step solutions.</p>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5rem;margin-top:1.5rem">
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Authorship &amp; Expertise</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">Anish Nath</a></li>
          <li><strong>Background:</strong> Math and developer tools for education</li>
          <li><strong>Standards:</strong> Standard linear algebra (matrix product)</li>
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
  <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">Matrix Multiplication: FAQ</h2>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">When are two matrices compatible for A×B?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">A×B is defined when columns(A) = rows(B). If A is m×n and B is n×p, the product C is m×p. Each c<sub>ij</sub> is the dot product of row i of A with column j of B.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">Is A×B the same as B×A?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">No. Matrix multiplication is generally not commutative: A×B ≠ B×A. It is associative and distributive, and obeys (AB)^T = B^T A^T.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What sizes are supported?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">This tool supports rectangular and square matrices with dimensions up to 10×10, showing step-by-step computations.</p>
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

  const EPS = MatrixUtils.EPS;
  const smartFormat = MatrixUtils.smartFormat;
  const parseMatrix = MatrixUtils.parseMatrix;
  const formatMatrix = MatrixUtils.formatMatrix;

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
        let stepsHtml = '<div class="mb-4"><h5 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Multiplication Process</h5></div>';
        steps.forEach((step, idx) => {
          stepsHtml += `<div class="step-card"><div class="step-inner"><span class="step-number">${idx + 1}</span><div class="step-description">${step}</div></div></div>`;
        });
        stepsArea.innerHTML = stepsHtml;
      } else {
        stepsArea.innerHTML = '<div style="color:var(--text-muted)">Enable "Show detailed steps" to see the computation process.</div>';
      }

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
    matrixA.value = '';
    matrixB.value = '';
    resultArea.innerHTML = '<div style="text-align:center;color:var(--text-muted);padding:1rem">Enter two matrices and click "Multiply A × B" to see the result.</div>';
    stepsArea.innerHTML = '<div style="color:var(--text-muted)">Detailed multiplication steps will appear here.</div>';
    inputError.style.display = 'none';
  }

  function generateRandomA() {
    const m = parseInt(rowsA.value);
    const n = parseInt(colsA.value);
    const rows = [];
    for(let i = 0; i < m; i++) {
      const row = [];
      for(let j = 0; j < n; j++) row.push(Math.floor(Math.random() * 21 - 10));
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
      for(let j = 0; j < q; j++) row.push(Math.floor(Math.random() * 21 - 10));
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
  exampleButtons.forEach(btn => btn.addEventListener('click', () => loadExample(btn.dataset.example)));

  colsA.addEventListener('change', () => { rowsB.value = colsA.value; });
  rowsB.addEventListener('change', () => { colsA.value = rowsB.value; });

  MatrixUtils.shareURL(document.getElementById('btnShareURL'), function() {
    return { m: rowsA.value, n: colsA.value, p: rowsB.value, q: colsB.value, A: btoa(encodeURIComponent(matrixA.value.trim())), B: btoa(encodeURIComponent(matrixB.value.trim())) };
  });

  MatrixUtils.downloadImage(document.getElementById('btnDownloadImage'), 'matrix-multiplication', 'No result to download. Please multiply matrices first.');
  MatrixUtils.printWorksheet(document.getElementById('btnPrintWorksheet'), 'Matrix Multiplication', { exerciseType: 'multiplication' });

  const loaded = MatrixUtils.loadFromURL(function(p) {
    if(p.A && p.B) {
      rowsA.value = p.m || 2; colsA.value = p.n || 2;
      rowsB.value = p.p || 2; colsB.value = p.q || 2;
      matrixA.value = p.A;
      matrixB.value = p.B;
      setTimeout(() => multiply(), 100);
      return true;
    }
    return false;
  });
  if(!loaded) loadExample('2x3');
})();
</script>

<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
</body>
</html>
