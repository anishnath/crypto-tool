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
    <jsp:param name="toolName" value="Matrix Addition Calculator | A+B, A-B, cA, aA+bB Free" />
    <jsp:param name="toolDescription" value="Free matrix addition calculator. Add A+B, subtract A-B, scalar multiply cA, linear combinations. Step-by-step solutions. Print worksheet with practice exercises. Share URL, download. 100% client-side." />
    <jsp:param name="toolCategory" value="Math Tools" />
    <jsp:param name="toolUrl" value="matrix-addition-calculator.jsp" />
    <jsp:param name="toolKeywords" value="matrix addition calculator, A+B calculator, matrix subtraction, scalar multiplication cA, linear combination aA+bB, matrix arithmetic, homework help, printable worksheet" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="toolFeatures" value="Addition A+B and subtraction A-B,Scalar multiplication cA,Linear combination aA+bB,Print worksheet with practice exercises,Share URL and download image,Step-by-step solutions,Up to 10×10 matrices" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="faq1q" value="How do you add and subtract matrices?" />
    <jsp:param name="faq1a" value="Addition and subtraction are element-wise and require the same dimensions. For result C, c_ij = a_ij ± b_ij. Addition is commutative and associative." />
    <jsp:param name="faq2q" value="What is scalar multiplication and a linear combination?" />
    <jsp:param name="faq2a" value="Scalar multiplication multiplies each entry by a constant c. Linear combinations have the form aA + bB with matching dimensions, fundamental for many linear algebra applications." />
    <jsp:param name="faq3q" value="What sizes are supported?" />
    <jsp:param name="faq3a" value="This tool supports matrices up to 10×10 and shows element-wise steps for A+B, A−B, cA, and aA+bB." />
    <jsp:param name="faq4q" value="Can I print practice worksheets?" />
    <jsp:param name="faq4a" value="Yes. Click Print Worksheet to generate a PDF-ready sheet with your result plus practice exercises (A+B, A−B, cA, aA+bB) with answer blanks." />
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
    [data-theme="dark"] { --tool-light:rgba(59,130,246,0.15) }
    .matrix-calc .operation-badge{display:inline-flex;align-items:center;padding:0.4rem 0.8rem;border-radius:999px;font-size:0.95rem;font-weight:600;background:var(--tool-light);color:var(--tool-primary);margin:0.25rem}
    .tool-btn-outline{background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);padding:0.5rem 1rem;font-size:0.875rem;font-weight:500;border-radius:0.5rem;cursor:pointer}
    .tool-btn-outline:hover{background:var(--tool-light)}
    .matrix-dim-row{display:flex;align-items:center;gap:0.5rem;flex-wrap:wrap}
    .matrix-dim-row input{flex:1;min-width:60px}
    .matrix-example-grid{display:flex;flex-direction:column;gap:0.5rem}
    .matrix-example-btn{text-align:left;padding:0.5rem 0.75rem;font-size:0.8125rem;border:1px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);cursor:pointer;transition:all .15s}
    .matrix-example-btn:hover{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary)}
    [data-theme="dark"] .matrix-example-btn{background:var(--bg-secondary);border-color:var(--border)}
    .tool-checkbox-wrap{display:flex;align-items:center;gap:0.5rem;cursor:pointer;font-size:0.875rem;color:var(--text-secondary)}
    .tool-checkbox-wrap input{width:1.125rem;height:1.125rem;accent-color:var(--tool-primary)}
  </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp"%>

<header class="tool-page-header">
  <div class="tool-page-header-inner">
    <div>
      <h1 class="tool-page-title">Matrix Addition &amp; Subtraction Calculator</h1>
      <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
        <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
        <span>Matrix Addition</span>
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
      <p>Add, subtract matrices, and perform scalar multiplication with step-by-step solutions. Supports A+B, A−B, cA, and linear combinations aA+bB. <strong>100% client-side</strong>—no data sent to servers. Enter matrices up to 10×10 or use quick examples.</p>
    </div>
  </div>
</section>

<main class="tool-page-container">
  <div class="tool-input-column">
    <div class="tool-card matrix-calc">
      <div class="tool-card-header">Operation</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label" for="operation">Choose Operation</label>
          <select id="operation" class="tool-input" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);color:var(--text-primary);width:100%;font-size:0.875rem">
            <option value="add">A + B</option>
            <option value="subtract">A - B</option>
            <option value="scalar">Scalar × A (cA)</option>
            <option value="linear">Linear Combination (aA + bB)</option>
          </select>
        </div>
        <div id="scalarInputs" style="display:none">
          <div class="tool-form-group">
            <label class="tool-form-label" for="scalarValue">Scalar c</label>
            <input id="scalarValue" type="number" step="any" class="tool-input" value="2" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-size:0.875rem">
          </div>
        </div>
        <div id="linearInputs" style="display:none">
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.75rem">
            <div class="tool-form-group">
              <label class="tool-form-label" for="scalarA">Scalar a</label>
              <input id="scalarA" type="number" step="any" class="tool-input" value="2" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-size:0.875rem">
            </div>
            <div class="tool-form-group">
              <label class="tool-form-label" for="scalarB">Scalar b</label>
              <input id="scalarB" type="number" step="any" class="tool-input" value="3" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-size:0.875rem">
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="tool-card matrix-calc">
      <div class="tool-card-header">Matrix A</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label">Dimensions (m × n)</label>
          <div class="matrix-dim-row">
            <input id="rows" type="number" min="1" max="10" class="tool-input" value="2" placeholder="rows" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);font-size:0.875rem">
            <span style="color:var(--text-secondary)">×</span>
            <input id="cols" type="number" min="1" max="10" class="tool-input" value="2" placeholder="cols" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);font-size:0.875rem">
          </div>
        </div>
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixA">Matrix A Entries</label>
          <textarea id="matrixA" class="tool-input" rows="4" placeholder="1 2
3 4" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-family:var(--font-mono,'monospace');font-size:0.875rem;resize:vertical"></textarea>
          <span class="tool-form-hint">One row per line, space separated</span>
        </div>
        <button type="button" id="btnRandomA" class="tool-btn-outline" style="width:100%;margin-bottom:0.5rem">Random Matrix A</button>
      </div>
    </div>

    <div class="tool-card matrix-calc" id="matrixBCard">
      <div class="tool-card-header">Matrix B</div>
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixB">Matrix B Entries (same dimensions as A)</label>
          <textarea id="matrixB" class="tool-input" rows="4" placeholder="5 6
7 8" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-family:var(--font-mono,'monospace');font-size:0.875rem;resize:vertical"></textarea>
          <span class="tool-form-hint">One row per line, space separated</span>
        </div>
        <button type="button" id="btnRandomB" class="tool-btn-outline" style="width:100%;margin-bottom:0.5rem">Random Matrix B</button>
      </div>
    </div>

    <div class="tool-card matrix-calc">
      <div class="tool-card-body">
        <div class="tool-form-group">
          <label class="tool-checkbox-wrap">
            <input type="checkbox" id="showSteps" checked>
            <span>Show detailed steps</span>
          </label>
        </div>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.5rem">
          <button type="button" id="btnCalculate" class="tool-action-btn" style="padding:0.5rem 1rem;margin-top:0">Calculate</button>
          <button type="button" id="btnClear" class="tool-btn-outline" style="margin-top:0">Clear</button>
        </div>
        <div id="inputError" class="tool-form-hint" style="color:var(--error,#ef4444);display:none;margin-top:0.5rem"></div>
      </div>
    </div>

    <div class="tool-card matrix-calc">
      <div class="tool-card-header">Quick Examples</div>
      <div class="tool-card-body">
        <div class="matrix-example-grid">
          <button type="button" class="matrix-example-btn" data-example="add">Addition (2×2)</button>
          <button type="button" class="matrix-example-btn" data-example="subtract">Subtraction (3×3)</button>
          <button type="button" class="matrix-example-btn" data-example="scalar">Scalar Multiply</button>
          <button type="button" class="matrix-example-btn" data-example="linear">Linear Combination</button>
        </div>
      </div>
    </div>
  </div>

  <div class="tool-output-column">
    <div class="tool-card matrix-calc">
      <div class="tool-card-header" style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:0.5rem">
        <span>Result</span>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap">
          <button type="button" id="btnShareURL" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem" title="Copy URL to clipboard">Share URL</button>
          <button type="button" id="btnDownloadImage" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem" title="Download result as image">Download Image</button>
          <button type="button" id="btnPrintWorksheet" class="tool-btn-outline" style="padding:0.375rem 0.75rem;font-size:0.75rem;background:linear-gradient(135deg,#64748b,#475569);color:#fff;border:none" title="Print worksheet">&#128424; Print Worksheet</button>
        </div>
      </div>
      <div class="tool-card-body">
        <div id="resultArea" style="text-align:center;color:var(--text-muted);padding:1rem">
          Select an operation and enter matrices to see the result.
        </div>
      </div>
    </div>

    <div class="tool-card matrix-calc">
      <div class="tool-card-header">Computation Steps</div>
      <div class="tool-card-body">
        <div id="stepsArea" style="color:var(--text-muted)">
          Detailed computation steps will appear here.
        </div>
      </div>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
      <jsp:param name="currentToolUrl" value="matrix-addition-calculator.jsp" />
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
    <h2 id="eeat" style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">About This Matrix Addition Tool &amp; Methodology</h2>
    <p style="margin-bottom:1rem;color:var(--text-secondary);line-height:1.7">This matrix addition calculator performs element-wise operations using standard linear algebra rules. All computations run <strong>client-side in your browser</strong>—no matrices are sent to any server. Supports A+B, A−B, scalar multiplication cA, and linear combinations aA+bB with step-by-step solutions up to 10×10.</p>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5rem;margin-top:1.5rem">
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Authorship &amp; Expertise</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">Anish Nath</a></li>
          <li><strong>Background:</strong> Math and developer tools for education</li>
          <li><strong>Standards:</strong> Standard linear algebra (element-wise operations)</li>
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
  <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">Matrix Addition &amp; Subtraction: FAQ</h2>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">How do you add and subtract matrices?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Addition and subtraction are element-wise and require the same dimensions. For result C, c<sub>ij</sub> = a<sub>ij</sub> ± b<sub>ij</sub>. Addition is commutative and associative.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What is scalar multiplication and a linear combination?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Scalar multiplication multiplies each entry by a constant c. Linear combinations have the form aA + bB with matching dimensions, fundamental for many linear algebra applications.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What sizes are supported?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">This tool supports matrices up to 10×10 and shows element-wise steps for A+B, A−B, cA, and aA+bB.</p>
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
  const rows = document.getElementById('rows');
  const cols = document.getElementById('cols');
  const matrixA = document.getElementById('matrixA');
  const matrixB = document.getElementById('matrixB');
  const matrixBCard = document.getElementById('matrixBCard');
  const operation = document.getElementById('operation');
  const scalarInputs = document.getElementById('scalarInputs');
  const linearInputs = document.getElementById('linearInputs');
  const scalarValue = document.getElementById('scalarValue');
  const scalarA = document.getElementById('scalarA');
  const scalarB = document.getElementById('scalarB');
  const showSteps = document.getElementById('showSteps');
  const btnCalculate = document.getElementById('btnCalculate');
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
    const n = C[0] ? C[0].length : 0;
    const rows = [];
    for(let i = 0; i < m; i++) {
      const row = [];
      for(let j = 0; j < n; j++) {
        if(i < currentRow || (i === currentRow && j <= currentCol)) {
          if(C[i] && C[i][j] !== undefined) {
            row.push('\\textcolor{green}{' + smartFormat(C[i][j]) + '}');
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

  function addMatrices(A, B, withSteps = false) {
    const m = A.length;
    const n = A[0].length;
    const C = Array(m).fill(0).map(() => Array(n).fill(undefined));
    const steps = [];
    if(withSteps) {
      steps.push(`<div class="mb-2"><strong>Matrix A:</strong></div><div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>`);
      steps.push(`<div class="mb-2"><strong>Matrix B:</strong></div><div class="matrix-display">$$B = ${formatMatrix(B)}$$</div>`);
      steps.push(`<div class="text-primary">Adding element-wise:</div><div class="matrix-display">$$c_{ij} = a_{ij} + b_{ij}$$</div>`);
    }
    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        C[i][j] = A[i][j] + B[i][j];
        if(withSteps) {
          steps.push(`<div class="text-secondary matrix-display">$$c_{${i+1},${j+1}} = ${smartFormat(A[i][j])} + ${smartFormat(B[i][j])} = ${smartFormat(C[i][j])}$$</div>`);
          const totalElements = m * n;
          const showFrequency = totalElements <= 9 ? 1 : (totalElements <= 16 ? 2 : 4);
          if((i * n + j + 1) % showFrequency === 0 || (i === m - 1 && j === n - 1)) {
            steps.push(`<div class="mt-2 mb-3"><strong>Result C so far:</strong></div><div class="matrix-display">$$C = ${formatPartialMatrix(C, i, j)}$$</div>`);
          }
        }
      }
    }
    return { result: C, steps };
  }

  function subtractMatrices(A, B, withSteps = false) {
    const m = A.length;
    const n = A[0].length;
    const C = Array(m).fill(0).map(() => Array(n).fill(undefined));
    const steps = [];
    if(withSteps) {
      steps.push(`<div class="mb-2"><strong>Matrix A:</strong></div><div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>`);
      steps.push(`<div class="mb-2"><strong>Matrix B:</strong></div><div class="matrix-display">$$B = ${formatMatrix(B)}$$</div>`);
      steps.push(`<div class="text-primary">Subtracting element-wise:</div><div class="matrix-display">$$c_{ij} = a_{ij} - b_{ij}$$</div>`);
    }
    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        C[i][j] = A[i][j] - B[i][j];
        if(withSteps) {
          steps.push(`<div class="text-secondary matrix-display">$$c_{${i+1},${j+1}} = ${smartFormat(A[i][j])} - ${smartFormat(B[i][j])} = ${smartFormat(C[i][j])}$$</div>`);
          const totalElements = m * n;
          const showFrequency = totalElements <= 9 ? 1 : (totalElements <= 16 ? 2 : 4);
          if((i * n + j + 1) % showFrequency === 0 || (i === m - 1 && j === n - 1)) {
            steps.push(`<div class="mt-2 mb-3"><strong>Result C so far:</strong></div><div class="matrix-display">$$C = ${formatPartialMatrix(C, i, j)}$$</div>`);
          }
        }
      }
    }
    return { result: C, steps };
  }

  function scalarMultiply(c, A, withSteps = false) {
    const m = A.length;
    const n = A[0].length;
    const C = Array(m).fill(0).map(() => Array(n).fill(undefined));
    const steps = [];
    if(withSteps) {
      steps.push(`<div class="text-primary">Scalar: c = ${smartFormat(c)}</div>`);
      steps.push(`<div class="mb-2"><strong>Matrix A:</strong></div><div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>`);
      steps.push(`<div class="text-primary">Multiplying each element by ${smartFormat(c)}:</div><div class="matrix-display">$$c_{ij} = ${smartFormat(c)} \\times a_{ij}$$</div>`);
    }
    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        C[i][j] = c * A[i][j];
        if(withSteps) {
          steps.push(`<div class="text-secondary matrix-display">$$c_{${i+1},${j+1}} = ${smartFormat(c)} \\times ${smartFormat(A[i][j])} = ${smartFormat(C[i][j])}$$</div>`);
          const totalElements = m * n;
          const showFrequency = totalElements <= 9 ? 1 : (totalElements <= 16 ? 2 : 4);
          if((i * n + j + 1) % showFrequency === 0 || (i === m - 1 && j === n - 1)) {
            steps.push(`<div class="mt-2 mb-3"><strong>Result C so far:</strong></div><div class="matrix-display">$$C = ${formatPartialMatrix(C, i, j)}$$</div>`);
          }
        }
      }
    }
    return { result: C, steps };
  }

  function linearCombination(a, A, b, B, withSteps = false) {
    const m = A.length;
    const n = A[0].length;
    const C = Array(m).fill(0).map(() => Array(n).fill(undefined));
    const steps = [];
    if(withSteps) {
      steps.push(`<div class="text-primary">Linear Combination: ${smartFormat(a)}A + ${smartFormat(b)}B</div>`);
      steps.push(`<div class="mb-2"><strong>Matrix A:</strong></div><div class="matrix-display">$$A = ${formatMatrix(A)}$$</div>`);
      steps.push(`<div class="mb-2"><strong>Matrix B:</strong></div><div class="matrix-display">$$B = ${formatMatrix(B)}$$</div>`);
      steps.push(`<div class="text-primary">Computing:</div><div class="matrix-display">$$c_{ij} = ${smartFormat(a)} \\times a_{ij} + ${smartFormat(b)} \\times b_{ij}$$</div>`);
    }
    for(let i = 0; i < m; i++) {
      for(let j = 0; j < n; j++) {
        C[i][j] = a * A[i][j] + b * B[i][j];
        if(withSteps) {
          steps.push(`<div class="text-secondary matrix-display">$$c_{${i+1},${j+1}} = ${smartFormat(a)} \\times ${smartFormat(A[i][j])} + ${smartFormat(b)} \\times ${smartFormat(B[i][j])} = ${smartFormat(C[i][j])}$$</div>`);
          const totalElements = m * n;
          const showFrequency = totalElements <= 9 ? 1 : (totalElements <= 16 ? 2 : 4);
          if((i * n + j + 1) % showFrequency === 0 || (i === m - 1 && j === n - 1)) {
            steps.push(`<div class="mt-2 mb-3"><strong>Result C so far:</strong></div><div class="matrix-display">$$C = ${formatPartialMatrix(C, i, j)}$$</div>`);
          }
        }
      }
    }
    return { result: C, steps };
  }

  function calculate() {
    try {
      inputError.style.display = 'none';
      const m = parseInt(rows.value);
      const n = parseInt(cols.value);
      const op = operation.value;
      if(m < 1 || m > 10 || n < 1 || n > 10) {
        throw new Error('Matrix dimensions must be between 1 and 10');
      }
      const A = parseMatrix(matrixA.value, m, n);
      let result, steps, opLabel;
      if(op === 'add') {
        const B = parseMatrix(matrixB.value, m, n);
        ({ result, steps } = addMatrices(A, B, showSteps.checked));
        opLabel = 'A + B';
      } else if(op === 'subtract') {
        const B = parseMatrix(matrixB.value, m, n);
        ({ result, steps } = subtractMatrices(A, B, showSteps.checked));
        opLabel = 'A - B';
      } else if(op === 'scalar') {
        const c = parseFloat(scalarValue.value);
        if(isNaN(c)) throw new Error('Invalid scalar value');
        ({ result, steps } = scalarMultiply(c, A, showSteps.checked));
        opLabel = `${smartFormat(c)}A`;
      } else if(op === 'linear') {
        const B = parseMatrix(matrixB.value, m, n);
        const a = parseFloat(scalarA.value);
        const b = parseFloat(scalarB.value);
        if(isNaN(a) || isNaN(b)) throw new Error('Invalid scalar values');
        ({ result, steps } = linearCombination(a, A, b, B, showSteps.checked));
        opLabel = `${smartFormat(a)}A + ${smartFormat(b)}B`;
      }
      let html = `<div class="result-card">
        <div class="mb-3"><span class="operation-badge">${opLabel}</span><span class="operation-badge">Dimensions: ${m}×${n}</span></div>
        <div class="mb-2"><strong>Result:</strong></div>
        <div class="matrix-display">$$${formatMatrix(result)}$$</div></div>`;
      resultArea.innerHTML = html;
      if(showSteps.checked && steps.length > 0) {
        let stepsHtml = '<div class="mb-4"><h5 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Computation Process</h5></div>';
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
    resultArea.innerHTML = '<div style="text-align:center;color:var(--text-muted);padding:1rem">Select an operation and enter matrices to see the result.</div>';
    stepsArea.innerHTML = '<div style="color:var(--text-muted)">Detailed computation steps will appear here.</div>';
    inputError.style.display = 'none';
  }

  function generateRandomA() {
    const m = parseInt(rows.value);
    const n = parseInt(cols.value);
    const rowsData = [];
    for(let i = 0; i < m; i++) {
      const row = [];
      for(let j = 0; j < n; j++) row.push(Math.floor(Math.random() * 21 - 10));
      rowsData.push(row.join(' '));
    }
    matrixA.value = rowsData.join('\n');
  }

  function generateRandomB() {
    const m = parseInt(rows.value);
    const n = parseInt(cols.value);
    const rowsData = [];
    for(let i = 0; i < m; i++) {
      const row = [];
      for(let j = 0; j < n; j++) row.push(Math.floor(Math.random() * 21 - 10));
      rowsData.push(row.join(' '));
    }
    matrixB.value = rowsData.join('\n');
  }

  function loadExample(type) {
    if(type === 'add') {
      operation.value = 'add'; rows.value = 2; cols.value = 2;
      matrixA.value = '1 2\n3 4'; matrixB.value = '5 6\n7 8';
    } else if(type === 'subtract') {
      operation.value = 'subtract'; rows.value = 3; cols.value = 3;
      matrixA.value = '9 8 7\n6 5 4\n3 2 1'; matrixB.value = '1 2 3\n4 5 6\n7 8 9';
    } else if(type === 'scalar') {
      operation.value = 'scalar'; rows.value = 2; cols.value = 3;
      matrixA.value = '1 2 3\n4 5 6'; scalarValue.value = '3';
    } else if(type === 'linear') {
      operation.value = 'linear'; rows.value = 2; cols.value = 2;
      matrixA.value = '1 2\n3 4'; matrixB.value = '5 6\n7 8';
      scalarA.value = '2'; scalarB.value = '3';
    }
    updateOperationVisibility();
    calculate();
  }

  function updateOperationVisibility() {
    const op = operation.value;
    matrixBCard.style.display = (op === 'scalar') ? 'none' : 'block';
    scalarInputs.style.display = (op === 'scalar') ? 'block' : 'none';
    linearInputs.style.display = (op === 'linear') ? 'block' : 'none';
  }

  btnCalculate.addEventListener('click', calculate);
  btnClear.addEventListener('click', clear);
  btnRandomA.addEventListener('click', generateRandomA);
  btnRandomB.addEventListener('click', generateRandomB);
  operation.addEventListener('change', updateOperationVisibility);
  exampleButtons.forEach(btn => btn.addEventListener('click', () => loadExample(btn.dataset.example)));

  MatrixUtils.shareURL(document.getElementById('btnShareURL'), function() {
    var params = { op: operation.value, m: rows.value, n: cols.value, A: btoa(encodeURIComponent(matrixA.value.trim())) };
    if(operation.value !== 'scalar') params.B = btoa(encodeURIComponent(matrixB.value.trim()));
    if(operation.value === 'scalar') params.c = scalarValue.value;
    if(operation.value === 'linear') { params.a = scalarA.value; params.b = scalarB.value; }
    return params;
  });

  MatrixUtils.downloadImage(document.getElementById('btnDownloadImage'), 'matrix-addition', 'No result to download. Please calculate first.');
  MatrixUtils.printWorksheet(document.getElementById('btnPrintWorksheet'), 'Matrix Addition', { exerciseType: 'addition' });

  const loaded = MatrixUtils.loadFromURL(function(p) {
    if(p.A) {
      operation.value = p.op || 'add';
      rows.value = p.m || 2;
      cols.value = p.n || 2;
      matrixA.value = p.A;
      if(p.B) matrixB.value = p.B;
      if(p.c) scalarValue.value = p.c;
      if(p.a) scalarA.value = p.a;
      if(p.b) scalarB.value = p.b;
      updateOperationVisibility();
      setTimeout(() => calculate(), 100);
      return true;
    }
    return false;
  });
  if(!loaded) loadExample('add');
})();
</script>

<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
</body>
</html>
