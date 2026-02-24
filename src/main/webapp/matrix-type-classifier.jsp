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
    <jsp:param name="toolName" value="Matrix Type Classifier — Identify 20+ Types Free" />
    <jsp:param name="toolDescription" value="Classify matrices automatically: symmetric, orthogonal, diagonal, triangular, and 20+ types. D3 visualization, step-by-step reasoning. Free." />
    <jsp:param name="toolCategory" value="Math Tools" />
    <jsp:param name="toolUrl" value="matrix-type-classifier.jsp" />
    <jsp:param name="toolKeywords" value="matrix type classifier, matrix properties, symmetric matrix, orthogonal matrix, diagonal matrix, triangular matrix, positive definite, nilpotent, idempotent, matrix analysis" />
    <jsp:param name="toolFeatures" value="20+ matrix types,Print worksheet with practice exercises,Share URL and copy matrix,Property analysis,Visual classification,Step-by-step reasoning" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="faq1q" value="How do you identify the type of a matrix?" />
    <jsp:param name="faq1a" value="Check dimensions first (square vs rectangular). For square matrices, compare A to A^T (symmetric if A = A^T, skew-symmetric if A = -A^T), inspect diagonal entries, and compute determinant/rank for singularity. The tool automates these steps." />
    <jsp:param name="faq2q" value="What matrix types does this detect?" />
    <jsp:param name="faq2a" value="Rectangular, square, row, column, zero, diagonal, scalar, identity, upper/lower triangular, symmetric, skew-symmetric, orthogonal, singular/non-singular, stochastic, and sparse; plus trace, determinant, rank and definiteness hints." />
    <jsp:param name="faq3q" value="Why is my matrix flagged as singular?" />
    <jsp:param name="faq3a" value="A matrix is singular when det(A) = 0 or rows are linearly dependent. The tool uses tolerance-aware elimination; very small determinants relative to entries are treated as singular." />
    <jsp:param name="faq4q" value="Can I practice with exam-style classification questions?" />
    <jsp:param name="faq4a" value="Yes. The Exam-Style Practice section generates classification problems at Easy (diagonal/identity/zero), Medium (symmetric/triangular), or Hard (orthogonal/positive-definite) with instant scoring." />
    <jsp:param name="faq5q" value="How are matrix properties related to each other?" />
    <jsp:param name="faq5a" value="Many properties overlap: every identity matrix is diagonal, symmetric, and orthogonal. Every orthogonal matrix has det = ±1. Positive-definite matrices are always symmetric and non-singular. Understanding these relationships helps classify matrices quickly." />
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
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/matrix-bootstrap-compat.css?v=<%=cacheVersion%>">

  <%@ include file="modern/ads/ad-init.jsp"%>
  <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
  <script src="<%=request.getContextPath()%>/js/matrix-common.js?v=<%=cacheVersion%>"></script>
  <script src="<%=request.getContextPath()%>/modern/js/practice-sheet.js?v=<%=cacheVersion%>"></script>
  <script src="<%=request.getContextPath()%>/js/matrix-practice-problems.js?v=<%=cacheVersion%>"></script>
  <script>MatrixUtils.initMathJax();</script>
  <script src="https://d3js.org/d3.v7.min.js"  crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"  crossorigin="anonymous"></script>
  <style>
    :root { --tool-primary:#3b82f6; --tool-primary-dark:#1d4ed8; --tool-gradient:linear-gradient(135deg,#3b82f6 0%,#1d4ed8 100%); --tool-light:#eff6ff }
    .matrix-classifier .tool-card-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;padding:0.75rem 1.25rem;font-size:1rem;font-weight:600;color:var(--text-primary,#1e293b);border-bottom:1px solid var(--border,#e2e8f0);background:var(--bg-secondary,#f8fafc);border-radius:var(--radius-lg,12px) var(--radius-lg,12px) 0 0}
    .matrix-classifier .tool-card-body{padding:1.25rem;color:var(--text-primary,#1e293b)}
    #matrixCanvas{width:100%;min-height:320px;border:1px solid var(--border,#e5e7eb);border-radius:6px;background:var(--bg-secondary,#f8fafc)}
    .badge-type{display:inline-flex;align-items:center;padding:0.3rem 0.6rem;border-radius:999px;font-size:0.85rem;margin:0.15rem 0.25rem;font-weight:500}
    .badge-core{background:#dbeafe;color:#1d4ed8}
    .badge-structure{background:#dcfce7;color:#166534}
    .badge-warning{background:#fee2e2;color:#b91c1c}
    .badge-neutral{background:var(--bg-tertiary,#e2e8f0);color:var(--text-primary,#1e293b)}
    .matrix-grid{display:inline-block;border-collapse:collapse;margin-top:0.5rem}
    .matrix-grid td{padding:0.35rem 0.6rem;border:1px solid var(--border,#cbd5e1);font-family:monospace;font-size:0.95rem;min-width:48px;text-align:center;color:var(--text-primary,#1e293b)}
    .matrix-grid .diag{background:#fef3c7}
    .matrix-grid .offdiag{background:var(--bg-primary,#f8fafc)}
    .matrix-grid .highlight{background:#fecdd3;color:#7f1d1d}
    .matrix-grid .zero{color:var(--text-muted,#94a3b8)}
    .classification-card{border-left:4px solid #3b82f6;background:var(--tool-light,#eff6ff);color:var(--text-primary,#1e293b);border-radius:4px;padding:0.6rem;margin-bottom:0.6rem}
    .classification-card strong{color:var(--text-primary,#1e293b)}
    .explain-step{border-left:3px solid #6366f1;padding-left:0.6rem;margin-bottom:0.5rem;color:var(--text-primary,#1e293b)}
    .mc-preset-btn{display:inline-block;padding:0.3rem 0.6rem;font-size:0.78rem;font-weight:500;border:1px solid var(--border,#cbd5e1);border-radius:6px;background:var(--bg-primary,#fff);color:var(--text-secondary,#475569);cursor:pointer;transition:all 0.15s ease;white-space:nowrap}
    .mc-preset-btn:hover{border-color:var(--tool-primary);color:var(--tool-primary);background:var(--tool-light)}
    .mc-preset-btn.active{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary);font-weight:600}
    [data-theme="dark"] .mc-preset-btn{background:var(--bg-tertiary,#334155);border-color:var(--border,#475569);color:var(--text-secondary,#94a3b8)}
    [data-theme="dark"] .mc-preset-btn:hover{border-color:#60a5fa;color:#93c5fd;background:rgba(59,130,246,0.12)}
    [data-theme="dark"] .mc-preset-btn.active{border-color:#60a5fa;color:#93c5fd;background:rgba(59,130,246,0.15)}
    .matrix-meta{font-family:monospace;font-size:0.95rem;color:var(--text-primary,#334155)}
    .matrix-svg-wrapper{
      position:relative;
      overflow:visible;
      background:var(--bg-primary,#fff);
      border:1px solid var(--border,#e2e8f0);
      border-radius:12px;
      padding:20px;
      box-shadow:0 4px 6px rgba(0,0,0,0.05), 0 10px 25px rgba(0,0,0,0.03);
    }
    .matrix-tooltip{
      position:absolute;
      pointer-events:none;
      background:linear-gradient(135deg, rgba(15,23,42,0.95) 0%, rgba(30,41,59,0.95) 100%);
      color:#f8fafc;
      border-radius:8px;
      padding:0.5rem 0.75rem;
      font-size:0.85rem;
      box-shadow:0 10px 30px rgba(15,23,42,0.4), 0 0 0 1px rgba(255,255,255,0.1);
      transform:translate(-50%, -110%);
      white-space:nowrap;
      opacity:0;
      transition:opacity 0.2s ease, transform 0.2s ease;
      backdrop-filter:blur(8px);
    }
    .matrix-tooltip strong{font-weight:600;color:#60a5fa}
    .matrix-tooltip::after{
      content:'';
      position:absolute;
      bottom:-6px;
      left:50%;
      transform:translateX(-50%);
      width:0;
      height:0;
      border-left:6px solid transparent;
      border-right:6px solid transparent;
      border-top:6px solid rgba(15,23,42,0.95);
    }
    .matrix-legend-label{font-size:0.75rem;fill:var(--text-secondary,#475569);font-weight:500}
    .matrix-cell-value{
      font-family:'SF Mono','Monaco','Fira Code',monospace;
      font-size:0.8rem;
      fill:var(--text-primary,#0f172a);
      font-weight:600;
      transition:all 0.2s ease;
    }
    .matrix-axis-label{
      font-size:0.8rem;
      fill:var(--text-secondary,#475569);
      font-weight:600;
      text-transform:uppercase;
      letter-spacing:0.05em;
    }
    .matrix-axis-tick{font-size:0.7rem;fill:var(--text-muted,#64748b)}
    .matrix-diagonal-outline{
      stroke:#f59e0b;
      stroke-width:2.5;
      stroke-dasharray:8 4;
      fill:none;
      pointer-events:none;
      filter:drop-shadow(0 0 3px rgba(245,158,11,0.4));
    }
    .matrix-zero-dot{fill:var(--text-muted,#cbd5e1);opacity:0.5}
    .matrix-cell{
      transition:all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
      filter:drop-shadow(0 1px 2px rgba(0,0,0,0.05));
    }
    .matrix-cell:hover{
      filter:drop-shadow(0 4px 12px rgba(0,0,0,0.15)) brightness(1.05);
    }
    .matrix-row-highlight{
      fill:rgba(59,130,246,0.05);
      opacity:0;
      transition:opacity 0.2s ease;
    }
    .matrix-col-highlight{
      fill:rgba(16,185,129,0.05);
      opacity:0;
      transition:opacity 0.2s ease;
    }

    /* ===== Dark Mode ===== */
    [data-theme="dark"] .matrix-classifier .tool-card-header{background:var(--bg-tertiary,#334155);color:var(--text-primary,#f1f5f9);border-bottom-color:var(--border,#475569)}
    [data-theme="dark"] .matrix-classifier .tool-card-body{background:var(--bg-secondary,#1e293b);color:var(--text-primary,#f1f5f9)}
    [data-theme="dark"] .classification-card{background:rgba(59,130,246,0.12);border-left-color:#60a5fa;color:var(--text-primary,#f1f5f9)}
    [data-theme="dark"] .classification-card strong{color:#93c5fd}
    [data-theme="dark"] .explain-step{border-left-color:#818cf8;color:var(--text-primary,#f1f5f9)}
    [data-theme="dark"] .badge-core{background:rgba(59,130,246,0.2);color:#93c5fd}
    [data-theme="dark"] .badge-structure{background:rgba(34,197,94,0.15);color:#86efac}
    [data-theme="dark"] .badge-warning{background:rgba(239,68,68,0.15);color:#fca5a5}
    [data-theme="dark"] .badge-neutral{background:var(--bg-tertiary,#334155);color:var(--text-secondary,#cbd5e1)}
    [data-theme="dark"] .matrix-grid td{border-color:var(--border,#475569);color:var(--text-primary,#f1f5f9)}
    [data-theme="dark"] .matrix-grid .diag{background:rgba(251,191,36,0.15)}
    [data-theme="dark"] .matrix-grid .offdiag{background:var(--bg-secondary,#1e293b)}
    [data-theme="dark"] .matrix-grid .highlight{background:rgba(239,68,68,0.2);color:#fca5a5}
    [data-theme="dark"] .matrix-svg-wrapper{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155);box-shadow:0 4px 6px rgba(0,0,0,0.2)}
    [data-theme="dark"] #matrixCanvas{border-color:var(--border,#475569);background:var(--bg-secondary,#1e293b)}
    [data-theme="dark"] .matrix-meta{color:var(--text-secondary,#cbd5e1)}
    [data-theme="dark"] .matrix-classifier label{color:var(--text-primary,#f1f5f9)}
    [data-theme="dark"] #gridContainer input{background:var(--bg-tertiary,#334155);color:var(--text-primary,#f1f5f9);border-color:var(--border,#475569)}
    [data-theme="dark"] .matrix-classifier strong{color:var(--text-primary,#f1f5f9)}

    /* Mobile Responsive Styles */
    @media (max-width: 991px) {
      .matrix-classifier h1{font-size:1.75rem}
      .matrix-classifier .tool-card{margin-bottom:1rem}
      .matrix-classifier .tool-card-header{font-size:0.95rem;padding:0.5rem 0.75rem}
      .matrix-classifier .tool-card-body{padding:0.75rem}

      /* Adjust form inputs for better touch targets */
      .matrix-classifier input[type="number"],
      .matrix-classifier textarea,
      .matrix-classifier .tool-input{font-size:16px;padding:0.5rem 0.75rem}

      /* Make badges wrap better */
      .badge-type{font-size:0.8rem;padding:0.25rem 0.5rem;margin:0.1rem 0.15rem}

      /* Adjust matrix visualization wrapper */
      .matrix-svg-wrapper{padding:10px;border-radius:8px}

      /* Make tooltips larger and easier to read on mobile */
      .matrix-tooltip{font-size:0.9rem;padding:0.6rem 0.85rem;max-width:90vw;white-space:normal}

      /* Improve example section for mobile */
      #examplesContent h6{font-size:0.9rem}
    }

    @media (max-width: 767px) {
      .matrix-classifier h1{font-size:1.5rem;margin-bottom:0.5rem}

      /* Make action buttons stack vertically */
      #btnAnalyse,#btnRandom,#btnClear{width:100%;margin:0.25rem 0}

      /* Simplify header on mobile */
      .matrix-classifier .tool-card-header{flex-direction:column;align-items:flex-start!important}
      .tool-card-header button{margin-top:0.5rem;width:100%}

      /* Optimize matrix meta display */
      .matrix-meta{font-size:0.85rem;line-height:1.6}

      /* Make classification cards more compact */
      .classification-card{padding:0.5rem;margin-bottom:0.5rem}
      .explain-step{padding-left:0.5rem;margin-bottom:0.4rem;font-size:0.9rem}

      /* Better example section for small mobile */
      #examplesContent{max-height:400px}
    }

    @media (max-width: 575px) {
      /* Extra small devices - further optimize */
      .container{padding-left:10px;padding-right:10px}
      .matrix-classifier h1{font-size:1.3rem}

      /* Compact grid editor for tiny screens */
      #gridContainer input{font-size:14px;padding:0.25rem}

      /* Make sure LaTeX doesn't overflow */
      .matrix-classifier .MathJax{font-size:0.9em!important;max-width:100%}

      /* Optimize quick tips section */
      .tool-card-body ul{padding-left:1.25rem;font-size:0.85rem}
      .tool-card-body ul li{margin-bottom:0.25rem}
    }

    /* Touch-specific improvements */
    @media (hover: none) and (pointer: coarse) {
      /* Increase touch targets */
      .matrix-classifier button{min-height:44px;padding:0.5rem 1rem}

      /* Disable hover effects on touch devices */
      .matrix-cell:hover{filter:drop-shadow(0 1px 2px rgba(0,0,0,0.05))}

      /* Make tooltips tap-friendly */
      .matrix-tooltip{pointer-events:auto}
    }

    /* Landscape mobile optimization */
    @media (max-width: 991px) and (orientation: landscape) {
      .matrix-classifier{padding-top:1rem}
      #examplesContent{max-height:300px}
      .tool-card-body{padding:0.5rem}
    }

    /* Print styles */
    @media print {
      .matrix-classifier button,
      .sharethis-inline-share-buttons{display:none}
      .matrix-classifier .tool-card{border:1px solid #ddd;box-shadow:none}
      .matrix-classifier{padding:0}
    }
  </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp"%>

<header class="tool-page-header">
  <div class="tool-page-header-inner">
    <div>
      <h1 class="tool-page-title">Matrix Type Classifier</h1>
      <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
        <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
        <span>Matrix Type Classifier</span>
      </nav>
    </div>
    <div class="tool-page-badges">
      <span class="tool-badge">Free</span>
      <span class="tool-badge">Client-Side</span>
      <span class="tool-badge">Visual</span>
    </div>
  </div>
</header>

<section class="tool-description-section">
  <div class="tool-description-inner">
    <div class="tool-description-content">
      <p>Identify and classify matrix types automatically: symmetric, orthogonal, diagonal, triangular, Hermitian, positive definite, nilpotent, idempotent, and more. D3 visualization, step-by-step reasoning, and property analysis. <strong>100% client-side</strong>—no data sent to servers.</p>
    </div>
  </div>
</section>

<main class="tool-page-container">
  <div class="tool-input-column matrix-calc matrix-classifier">
      <div class="tool-card" style="margin-bottom:1rem">
        <div class="tool-card-header">Matrix Input</div>
        <div class="tool-card-body">
          <!-- Presets -->
          <div class="mc-presets" style="margin-bottom:0.75rem">
            <label class="tool-form-label" style="margin-bottom:0.4rem;display:block;font-size:0.8rem;font-weight:600;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.03em">Presets</label>
            <div style="display:flex;flex-wrap:wrap;gap:0.35rem">
              <button type="button" class="mc-preset-btn" data-preset="identity3">Identity 3×3</button>
              <button type="button" class="mc-preset-btn" data-preset="symmetric3">Symmetric 3×3</button>
              <button type="button" class="mc-preset-btn" data-preset="orthogonal3">Orthogonal 3×3</button>
              <button type="button" class="mc-preset-btn" data-preset="upper4">Upper Tri 4×4</button>
              <button type="button" class="mc-preset-btn" data-preset="lower4">Lower Tri 4×4</button>
              <button type="button" class="mc-preset-btn" data-preset="singular3">Singular</button>
              <button type="button" class="mc-preset-btn" data-preset="stochastic3">Stochastic</button>
              <button type="button" class="mc-preset-btn" data-preset="rectangular23">Rect 2×3</button>
            </div>
          </div>

          <div class="tool-form-group" style="margin-bottom:0.55rem">
            <label class="tool-form-label" for="rowCount">Dimensions</label>
            <div style="display:flex;align-items:center;gap:0.5rem">
              <input id="rowCount" type="number" min="1" max="10" class="tool-input" value="3" style="width:70px;text-align:center">
              <span style="color:var(--text-secondary);font-weight:600">×</span>
              <input id="colCount" type="number" min="1" max="10" class="tool-input" value="3" style="width:70px;text-align:center">
            </div>
            <span class="tool-form-hint">Up to 10×10. Use commas or spaces, newline per row.</span>
          </div>

          <div class="tool-form-group" style="margin-bottom:0.55rem">
            <label class="tool-form-label" for="matrixInput">Matrix Entries</label>
            <textarea id="matrixInput" class="tool-input" rows="6" placeholder="Example (3×3):
1 0 0
0 1 0
0 0 1" style="font-family:var(--font-mono,'monospace');resize:vertical;width:100%"></textarea>
            <span class="tool-form-hint">Delimiters: space, comma, semicolon. Complex: a+bi.</span>
          </div>
          <div id="matrixTelemetry" style="font-size:0.8rem;color:var(--text-muted);margin-bottom:0.5rem"></div>

          <button id="btnGridEditor" type="button" class="tool-btn-outline" style="margin-bottom:0.75rem"><i class="fas fa-table"></i> Grid Editor</button>
          <div id="gridEditor" style="display:none;margin-bottom:0.75rem">
            <div style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;margin-bottom:0.5rem">
              <strong style="font-size:0.875rem;color:var(--text-primary)">Cell Editor</strong>
              <div style="display:flex;gap:0.35rem;flex-wrap:wrap">
                <button id="btnGridAddRow" type="button" class="tool-btn-outline">+ Row</button>
                <button id="btnGridAddCol" type="button" class="tool-btn-outline">+ Col</button>
                <button id="btnGridSync" type="button" class="tool-action-btn" style="padding:0.4rem 0.75rem;font-size:0.8125rem">Apply</button>
              </div>
            </div>
            <div id="gridContainer" style="overflow-x:auto"></div>
          </div>

          <div class="tool-form-group" style="margin-bottom:0.55rem">
            <label class="tool-checkbox-wrap">
              <input type="checkbox" id="allowComplex">
              <span>Allow complex entries (a + bi)</span>
            </label>
            <label class="tool-checkbox-wrap">
              <input type="checkbox" id="showIntermediate" checked>
              <span>Show intermediate calculations</span>
            </label>
          </div>

          <div style="display:flex;flex-wrap:wrap;gap:0.5rem;margin-top:0.5rem">
            <button id="btnAnalyse" class="tool-action-btn" style="padding:0.5rem 1rem">Classify Matrix</button>
            <button id="btnRandom" class="tool-btn-outline">Random Matrix</button>
            <button id="btnClear" class="tool-btn-outline">Clear</button>
          </div>
          <div id="inputError" style="font-size:0.8rem;color:var(--error,#ef4444);display:none;margin-top:0.5rem"></div>
        </div>
      </div>

      <div class="tool-card" style="margin-bottom:1rem">
        <h5 class="tool-card-header">Detected Types</h5>
        <div class="tool-card-body">
          <div id="typeBadges" style="margin-bottom:0.5rem"></div>
          <div id="matrixMeta" class="matrix-meta"></div>
        </div>
      </div>

      <div class="tool-card" style="margin-bottom:1rem">
        <h5 class="tool-card-header">Quick Tips</h5>
        <div class="tool-card-body" style="font-size:0.85rem">
          <ul style="margin-bottom:0;padding-left:1rem">
            <li>Diagonal matrices have zero off-diagonal entries.</li>
            <li>Scalar matrix ⇒ diagonal with constant diagonal values.</li>
            <li>Orthogonal matrices satisfy AᵀA = I (columns are orthonormal).</li>
            <li>Singular matrices have determinant 0 and rank &lt; number of rows.</li>
            <li>Stochastic matrices have non-negative columns summing to 1.</li>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <div class="tool-output-column matrix-calc matrix-classifier">
      <div class="tool-card" style="margin-bottom:1rem">
        <h5 class="tool-card-header" style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center">
          <span>Matrix Visualization</span>
          <div style="display:flex;flex-wrap:wrap;gap:0.35rem">
            <button id="btnCopyMatrix" class="tool-btn-outline"><i class="fas fa-copy"></i> Copy Matrix</button>
            <button id="btnPrintWorksheet" class="tool-btn-outline tool-btn-print">&#128424; Print Worksheet</button>
          </div>
        </h5>
        <div class="tool-card-body">
          <div id="matrixVisual" style="text-align:center;color:var(--text-muted)">Enter a matrix and click classify to view the visualization.</div>
        </div>
      </div>

      <div class="tool-card" style="margin-bottom:1rem">
        <h5 class="tool-card-header">Classification Summary</h5>
        <div class="tool-card-body">
          <div id="classificationSummary"></div>
        </div>
      </div>

      <div class="tool-card" style="margin-bottom:1rem">
        <h5 class="tool-card-header">Step-by-Step Reasoning</h5>
        <div class="tool-card-body" style="font-size:0.85rem">
          <div id="stepsContent" style="line-height:1.8"></div>
        </div>
      </div>

      <div class="tool-card" style="margin-bottom:1rem">
        <h5 class="tool-card-header">About Matrix Types</h5>
        <div class="tool-card-body" style="font-size:0.85rem">
          <div><strong>Square vs Rectangular:</strong> A matrix with equal rows and columns is square (n×n), enabling determinant, inverse, eigenvalue and orthogonality checks. Rectangular matrices are either row (1×n) or column (m×1) matrices.</div>
          <div style="margin-top:0.5rem"><strong>Diagonal &amp; Scalar:</strong> A diagonal matrix has non-zero entries only on its main diagonal. A scalar matrix is diagonal with equal diagonal entries. The identity matrix is a scalar matrix with all ones on the diagonal.</div>
          <div style="margin-top:0.5rem"><strong>Symmetric &amp; Skew-Symmetric:</strong> A matrix is symmetric if A = Aᵀ. It is skew-symmetric if A = -Aᵀ (diagonal entries must be zero). Symmetric matrices have real eigenvalues and orthogonal eigenvectors.</div>
          <div style="margin-top:0.5rem"><strong>Orthogonal Matrices:</strong> A matrix A is orthogonal if AᵀA = AAᵀ = I. Columns (and rows) are orthonormal. Orthogonal matrices preserve lengths and angles, and their inverse equals their transpose.</div>
          <div style="margin-top:0.5rem"><strong>Singular vs Non-Singular:</strong> Determinant zero ⇒ singular (not invertible). Determinant non-zero ⇒ non-singular (invertible). Rank reveals number of independent rows/columns.</div>
          <div style="margin-top:0.5rem"><strong>Stochastic Matrices:</strong> In Markov chains, column-stochastic matrices have non-negative entries with each column summing to 1. They represent transition probabilities.</div>
        </div>
      </div>

    <jsp:include page="modern/components/related-tools.jsp">
      <jsp:param name="currentToolUrl" value="matrix-type-classifier.jsp" />
      <jsp:param name="keyword" value="matrix" />
    </jsp:include>

    <div class="tool-card" style="margin-bottom:1rem">
        <h5 class="tool-card-header" style="display:flex;justify-content:space-between;align-items:center">
          Matrix Type Examples
          <button id="btnToggleExamples" class="tool-btn-outline">Hide Examples</button>
        </h5>
        <div id="examplesContent" class="tool-card-body" style="font-size:0.85rem;max-height:600px;overflow-y:auto">
          <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:1rem">
            <div style="margin-bottom:0">
              <h6 style="font-weight:700;font-size:0.9rem;margin:0 0 0.25rem;color:var(--text-primary)">Identity Matrix (I)</h6>
              <div style="margin-bottom:0.25rem">$$\begin{pmatrix} \textcolor{blue}{1} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{blue}{1} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{blue}{1} \end{pmatrix}$$</div>
              <div style="font-size:0.8rem;color:var(--text-secondary);margin:0;line-height:1.5">Diagonal of ones, zeros elsewhere. Special case of diagonal, scalar, and symmetric matrices.</div>
            </div>
            <div style="margin-bottom:0">
              <h6 style="font-weight:700;font-size:0.9rem;margin:0 0 0.25rem;color:var(--text-primary)">Zero Matrix (O)</h6>
              <div style="margin-bottom:0.25rem">$$\begin{pmatrix} \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{gray}{0} \end{pmatrix}$$</div>
              <div style="font-size:0.8rem;color:var(--text-secondary);margin:0;line-height:1.5">All elements are zero. Singular matrix with determinant 0 and rank 0.</div>
            </div>
            <div style="margin-bottom:0">
              <h6 style="font-weight:700;font-size:0.9rem;margin:0 0 0.25rem;color:var(--text-primary)">Diagonal Matrix</h6>
              <div style="margin-bottom:0.25rem">$$\begin{pmatrix} \textcolor{blue}{5} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{blue}{-3} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{blue}{2} \end{pmatrix}$$</div>
              <div style="font-size:0.8rem;color:var(--text-secondary);margin:0;line-height:1.5">Non-zero entries only on main diagonal. Easy to compute powers and determinant.</div>
            </div>
            <div style="margin-bottom:0">
              <h6 style="font-weight:700;font-size:0.9rem;margin:0 0 0.25rem;color:var(--text-primary)">Symmetric Matrix</h6>
              <div style="margin-bottom:0.25rem">$$\begin{pmatrix} \textcolor{blue}{4} & \textcolor{green}{1} & \textcolor{green}{2} \\ \textcolor{green}{1} & \textcolor{blue}{3} & \textcolor{gray}{0} \\ \textcolor{green}{2} & \textcolor{gray}{0} & \textcolor{blue}{5} \end{pmatrix}$$</div>
              <div style="font-size:0.8rem;color:var(--text-secondary);margin:0;line-height:1.5">A = Aᵀ. Real eigenvalues, orthogonal eigenvectors. Common in physics and optimization.</div>
            </div>
            <div style="margin-bottom:0">
              <h6 style="font-weight:700;font-size:0.9rem;margin:0 0 0.25rem;color:var(--text-primary)">Upper Triangular</h6>
              <div style="margin-bottom:0.25rem">$$\begin{pmatrix} \textcolor{blue}{2} & \textcolor{green}{4} & \textcolor{green}{1} \\ \textcolor{gray}{0} & \textcolor{blue}{3} & \textcolor{red}{-1} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{blue}{5} \end{pmatrix}$$</div>
              <div style="font-size:0.8rem;color:var(--text-secondary);margin:0;line-height:1.5">All entries below diagonal are zero. Determinant = product of diagonal entries.</div>
            </div>
            <div style="margin-bottom:0">
              <h6 style="font-weight:700;font-size:0.9rem;margin:0 0 0.25rem;color:var(--text-primary)">Lower Triangular</h6>
              <div style="margin-bottom:0.25rem">$$\begin{pmatrix} \textcolor{blue}{3} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{red}{-1} & \textcolor{blue}{2} & \textcolor{gray}{0} \\ \textcolor{green}{4} & \textcolor{green}{5} & \textcolor{blue}{1} \end{pmatrix}$$</div>
              <div style="font-size:0.8rem;color:var(--text-secondary);margin:0;line-height:1.5">All entries above diagonal are zero. Used in LU decomposition.</div>
            </div>
            <div style="margin-bottom:0">
              <h6 style="font-weight:700;font-size:0.9rem;margin:0 0 0.25rem;color:var(--text-primary)">Orthogonal Matrix</h6>
              <div style="margin-bottom:0.25rem">$$\begin{pmatrix} \textcolor{gray}{0} & \textcolor{blue}{1} & \textcolor{gray}{0} \\ \textcolor{blue}{1} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{red}{-1} \end{pmatrix}$$</div>
              <div style="font-size:0.8rem;color:var(--text-secondary);margin:0;line-height:1.5">AᵀA = I. Preserves lengths and angles. Represents rotations/reflections.</div>
            </div>
            <div style="margin-bottom:0">
              <h6 style="font-weight:700;font-size:0.9rem;margin:0 0 0.25rem;color:var(--text-primary)">Singular Matrix</h6>
              <div style="margin-bottom:0.25rem">$$\begin{pmatrix} \textcolor{blue}{2} & \textcolor{green}{4} & \textcolor{green}{6} \\ \textcolor{blue}{1} & \textcolor{green}{2} & \textcolor{green}{3} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{gray}{0} \end{pmatrix}$$</div>
              <div style="font-size:0.8rem;color:var(--text-secondary);margin:0;line-height:1.5">det(A) = 0. Not invertible. Rows/columns are linearly dependent.</div>
            </div>
            <div style="margin-bottom:0">
              <h6 style="font-weight:700;font-size:0.9rem;margin:0 0 0.25rem;color:var(--text-primary)">Column Stochastic</h6>
              <div style="margin-bottom:0.25rem">$$\begin{pmatrix} \textcolor{green}{0.5} & \textcolor{green}{0.2} & \textcolor{green}{0.3} \\ \textcolor{green}{0.3} & \textcolor{green}{0.5} & \textcolor{green}{0.3} \\ \textcolor{green}{0.2} & \textcolor{green}{0.3} & \textcolor{green}{0.4} \end{pmatrix}$$</div>
              <div style="font-size:0.8rem;color:var(--text-secondary);margin:0;line-height:1.5">Non-negative entries, each column sums to 1. Used in Markov chains.</div>
            </div>
            <div style="margin-bottom:0">
              <h6 style="font-weight:700;font-size:0.9rem;margin:0 0 0.25rem;color:var(--text-primary)">Rectangular Matrix</h6>
              <div style="margin-bottom:0.25rem">$$\begin{pmatrix} \textcolor{blue}{1} & \textcolor{green}{2} & \textcolor{green}{3} \\ \textcolor{green}{4} & \textcolor{blue}{5} & \textcolor{green}{6} \end{pmatrix}$$</div>
              <div style="font-size:0.8rem;color:var(--text-secondary);margin:0;line-height:1.5">Rows ≠ columns. No determinant or eigenvalues, but has rank and singular values.</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="tool-ads-column">
    <%@ include file="modern/ads/ad-in-content-mid.jsp"%>
  </div>
</main>

<script>
;(function(){
  const textarea = document.getElementById('matrixInput');
  const rowCountInput = document.getElementById('rowCount');
  const colCountInput = document.getElementById('colCount');
  const allowComplex = document.getElementById('allowComplex');
  const showIntermediate = document.getElementById('showIntermediate');
  const btnAnalyse = document.getElementById('btnAnalyse');
  const btnRandom = document.getElementById('btnRandom');
  const btnClear = document.getElementById('btnClear');
  const matrixVisual = document.getElementById('matrixVisual');
  const stepsContent = document.getElementById('stepsContent');
  const typeBadges = document.getElementById('typeBadges');
  const classificationSummary = document.getElementById('classificationSummary');
  const matrixMeta = document.getElementById('matrixMeta');
  const inputError = document.getElementById('inputError');
  const btnCopyMatrix = document.getElementById('btnCopyMatrix');
  const presetItems = document.querySelectorAll('[data-preset]');
  const matrixTelemetry = document.getElementById('matrixTelemetry');
  const btnGridEditor = document.getElementById('btnGridEditor');
  const gridEditor = document.getElementById('gridEditor');
  const gridContainer = document.getElementById('gridContainer');
  const btnGridSync = document.getElementById('btnGridSync');
  const btnGridAddRow = document.getElementById('btnGridAddRow');
  const btnGridAddCol = document.getElementById('btnGridAddCol');

  let currentGridMatrix = null;
  let gridEditorOpen = false;

  function queueTypeset(elements){
    const list = Array.isArray(elements) ? elements : [elements];
    const filtered = list.filter(Boolean);
    if(!filtered.length) return;
    if(window.MathJax && window.MathJax.typesetPromise){
      if(window.MathJax.startup && window.MathJax.startup.promise){
        window.MathJax.startup.promise.then(function(){
          if(MathJax.typesetClear){
            MathJax.typesetClear(filtered);
          }
          MathJax.typesetPromise(filtered.length ? filtered : undefined).catch(function(err){ console.error(err); });
        });
      } else {
        if(MathJax.typesetClear){
          MathJax.typesetClear(filtered);
        }
        MathJax.typesetPromise(filtered.length ? filtered : undefined).catch(function(err){ console.error(err); });
      }
    } else {
      window.__pendingMath = (window.__pendingMath || []).concat(filtered);
    }
  }

  function renderLatex(container, latex){
    container.innerHTML = '$$' + latex + '$$';
    // Small delay to ensure DOM is ready
    setTimeout(function(){
      if(window.MathJax && window.MathJax.typesetPromise){
        MathJax.typesetPromise([container]).catch(function(err){
          console.error('MathJax typeset error:', err);
        });
      }
    }, 10);
  }

  const EPS = 1e-9;

  function parseMatrix(text, rows, cols, allowComplexNumbers){
    const cleaned = text.trim();
    if(!cleaned){
      throw new Error('Matrix input is empty.');
    }
    const normalized = cleaned.replace(/\t/g,' ').replace(/;+$/gm,'').replace(/ {2,}/g,' ');
    const rowStrings = normalized.split(/\n|;/).map(s => s.trim()).filter(Boolean);
    if(rowStrings.length !== rows){
      throw new Error('Input rows ('+rowStrings.length+') do not match selected row count ('+rows+').');
    }
    const matrix = [];
    for(let r=0;r<rows;r++){
      const parts = rowStrings[r].split(/[\s,]+/).filter(Boolean);
      if(parts.length !== cols){
        throw new Error('Row '+(r+1)+' has '+parts.length+' entries; expected '+cols+'.');
      }
      const row = [];
      for(let c=0;c<cols;c++){
        const value = parts[c];
        if(allowComplexNumbers){
          row.push(parseComplex(value));
        } else {
          const num = parseFloat(value);
          if(!isFinite(num)){
            throw new Error('Entry ('+(r+1)+','+(c+1)+') is not a valid number: '+value);
          }
          row.push(num);
        }
      }
      matrix.push(row);
    }
    return matrix;
  }

  function parseComplex(str){
    const normalized = str.replace(/\s+/g,'').replace(/i$/,'*i');
    if(/^[+-]?\d+(\.\d+)?$/.test(normalized)){
      return {re: parseFloat(normalized), im:0};
    }
    const match = normalized.match(/^([+-]?\d+(?:\.\d+)?)([+-]\d+(?:\.\d+)?)\*?i$/i);
    if(match){
      return {re: parseFloat(match[1]), im: parseFloat(match[2])};
    }
    const pureImag = normalized.match(/^([+-]?\d*(?:\.\d+)?)\*?i$/i);
    if(pureImag){
      const coeff = pureImag[1] === '' || pureImag[1] === '+' || pureImag[1] === '-' ? (pureImag[1]==='-'?-1:1) : parseFloat(pureImag[1]);
      return {re:0, im:coeff};
    }
    throw new Error('Invalid complex number: '+str);
  }

  function cloneMatrix(mat){
    return mat.map(row => row.map(val => typeof val === 'object' ? {re:val.re, im:val.im} : val));
  }

  function latexColorWrap(text, color){
    if(!color) return text;
    return '\\textcolor{' + color + '}{' + text + '}';
  }

  function getColorForCell(cell){
    if(cell.isComplex) return null;
    if(cell.isZero) return 'gray';
    if(cell.isDiag) return 'blue';
    if(cell.value > 0) return 'green';
    if(cell.value < 0) return 'red';
    return null;
  }

  function formatLatexValue(val){
    if(typeof val === 'object'){
      return prettyValue(val, 4);
    }
    const num = Math.abs(val) < EPS ? 0 : val;
    const rounded = Number(num.toFixed(4));
    return rounded.toString();
  }

  function generateLatexMatrix(dataMatrix){
    const rowsLatex = dataMatrix.map(row =>
      row.map(cell => latexColorWrap(formatLatexValue(cell.raw), getColorForCell(cell))).join(' & ')
    );
    return '\\mathbf{A} = \\begin{bmatrix}' + rowsLatex.join(' \\\\ ') + '\\end{bmatrix}';
  }

  function detectDimensions(text){
    if(!text.trim()) return null;
    const rows = text.trim().split(/\n|;/).map(r => r.trim()).filter(Boolean);
    if(!rows.length) return null;
    const lengths = rows.map(r => r.replace(/\t/g,' ').split(/[\s,]+/).filter(Boolean).length);
    const distinct = Array.from(new Set(lengths));
    return {
      rowCount: rows.length,
      colCount: lengths[0] || 0,
      consistent: distinct.length === 1,
      lengths
    };
  }

  function updateTelemetry(){
    const detected = detectDimensions(textarea.value);
    if(!detected){
      matrixTelemetry.innerHTML = 'Awaiting input…';
      return;
    }
    const sliderRows = parseInt(rowCountInput.value,10) || 0;
    const sliderCols = parseInt(colCountInput.value,10) || 0;
    const {rowCount, colCount, consistent, lengths} = detected;
    const mismatchRows = sliderRows !== rowCount;
    const mismatchCols = sliderCols !== colCount;

    let html = `<div><strong>Detected:</strong> ${rowCount} × ${colCount}${consistent ? '' : ' (inconsistent row lengths)'}</div>`;
    if(!consistent){
      html += `<div style="color:var(--error,#ef4444)">Row lengths: ${lengths.join(' | ')} — fix highlighted rows.</div>`;
    }
    if(mismatchRows || mismatchCols){
      html += `<div style="margin-top:0.25rem"><button id="btnApplyDetected" type="button" style="background:none;border:none;color:var(--tool-primary);cursor:pointer;padding:0;font-size:0.8rem;text-decoration:underline">Use detected size (${rowCount}×${colCount})</button></div>`;
    }
    matrixTelemetry.innerHTML = html;

    if(!consistent){
      highlightInconsistentRows(lengths);
    } else if(matrixVisual.dataset.state === 'telemetry'){
      clearHighlights();
    }

    const applyBtn = document.getElementById('btnApplyDetected');
    if(applyBtn){
      applyBtn.addEventListener('click', function(){
        rowCountInput.value = rowCount;
        colCountInput.value = colCount;
        matrixTelemetry.innerHTML = `<div style="color:#16a34a">Applied detected dimensions (${rowCount}×${colCount}).</div>`;
        if(gridEditorOpen){
          buildGridFromText();
        }
      }, {once:true});
    }
  }

  function highlightInconsistentRows(lengths){
    const segments = textarea.value.split(/\n|;/);
    const expected = lengths.reduce((a,b) => b > a ? b : a, 0);
    let pointer = 0;
    const highlighted = segments.map(segment => {
      if(segment.trim().length === 0) return segment;
      const count = lengths[pointer] || 0;
      pointer++;
      if(count === expected) return segment;
      return `<mark style="background:#fee2e2;color:#991b1b">${segment}</mark>`;
    });
    matrixVisual.dataset.state = 'telemetry';
    matrixVisual.innerHTML = `<div style="color:var(--error,#ef4444);font-size:0.85rem;margin-bottom:0.5rem">Rows highlighted below have inconsistent entry counts.</div><pre style="background:var(--bg-secondary,#f1f5f9);padding:0.5rem;border-radius:0.375rem;max-height:200px;overflow:auto">${highlighted.join('\n')}</pre>`;
  }

  function clearHighlights(){
    matrixVisual.dataset.state = '';
    matrixVisual.innerHTML = '<div style="color:var(--text-muted)">Enter a matrix and click classify to view the visualization.</div>';
  }

  function isComplexMatrix(mat){
    for(let r=0;r<mat.length;r++){
      for(let c=0;c<mat[0].length;c++){
        if(typeof mat[r][c] === 'object') return true;
      }
    }
    return false;
  }

  function prettyValue(val, precision=4){
    if(typeof val === 'object'){
      const re = Math.abs(val.re) < EPS ? 0 : val.re;
      const im = Math.abs(val.im) < EPS ? 0 : val.im;
      if(im === 0) return re.toFixed(precision);
      if(re === 0) return (im.toFixed(precision))+'i';
      return re.toFixed(precision)+(im>=0?'+':'')+im.toFixed(precision)+'i';
    }
    return (Math.abs(val) < EPS ? 0 : val).toFixed(precision);
  }

  function equals(a,b,tol=EPS){
    if(typeof a === 'object' || typeof b === 'object'){
      const ar = typeof a === 'object' ? a.re : a;
      const ai = typeof a === 'object' ? a.im : 0;
      const br = typeof b === 'object' ? b.re : b;
      const bi = typeof b === 'object' ? b.im : 0;
      return Math.abs(ar - br) <= tol && Math.abs(ai - bi) <= tol;
    }
    return Math.abs(a - b) <= tol;
  }

  function addSteps(steps, title, description){
    steps.push({title, description});
  }

  function isSquare(mat){
    return mat.length === mat[0].length;
  }

  function transpose(mat){
    const rows = mat.length, cols = mat[0].length;
    const result = Array.from({length:cols}, () => Array(rows).fill(0));
    for(let i=0;i<rows;i++){
      for(let j=0;j<cols;j++){
        result[j][i] = mat[i][j];
      }
    }
    return result;
  }

  function conjugateTranspose(mat){
    const rows = mat.length, cols = mat[0].length;
    const result = Array.from({length:cols}, () => Array(rows).fill(0));
    for(let i=0;i<rows;i++){
      for(let j=0;j<cols;j++){
        const val = mat[i][j];
        if(typeof val === 'object'){
          result[j][i] = {re: val.re, im: -val.im};
        } else {
          result[j][i] = val;
        }
      }
    }
    return result;
  }

  function multiply(matA, matB){
    const rowsA = matA.length, colsA = matA[0].length;
    const rowsB = matB.length, colsB = matB[0].length;
    const complex = isComplexMatrix(matA) || isComplexMatrix(matB);
    if(colsA !== rowsB) return null;
    const result = Array.from({length:rowsA}, () => Array(colsB).fill(0));
    for(let i=0;i<rowsA;i++){
      for(let j=0;j<colsB;j++){
        let sum = complex ? {re:0, im:0} : 0;
        for(let k=0;k<colsA;k++){
          const a = matA[i][k];
          const b = matB[k][j];
          const prod = multiplyValues(a,b);
          sum = addValues(sum, prod);
        }
        result[i][j] = sum;
      }
    }
    return result;
  }

  function multiplyValues(a,b){
    if(typeof a === 'object' || typeof b === 'object'){
      const ar = typeof a === 'object' ? a.re : a;
      const ai = typeof a === 'object' ? a.im : 0;
      const br = typeof b === 'object' ? b.re : b;
      const bi = typeof b === 'object' ? b.im : 0;
      return {re: ar*br - ai*bi, im: ar*bi + ai*br};
    }
    return a*b;
  }

  function addValues(a,b){
    if(typeof a === 'object' || typeof b === 'object'){
      const ar = typeof a === 'object' ? a.re : a;
      const ai = typeof a === 'object' ? a.im : 0;
      const br = typeof b === 'object' ? b.re : b;
      const bi = typeof b === 'object' ? b.im : 0;
      return {re: ar+br, im: ai+bi};
    }
    return a + b;
  }

  function isZeroMatrix(mat){
    for(let i=0;i<mat.length;i++){
      for(let j=0;j<mat[0].length;j++){
        if(!equals(mat[i][j], 0)) return false;
      }
    }
    return true;
  }

  function isDiagonal(mat){
    if(!isSquare(mat)) return false;
    for(let i=0;i<mat.length;i++){
      for(let j=0;j<mat.length;j++){
        if(i !== j && !equals(mat[i][j], 0)) return false;
      }
    }
    return true;
  }

  function isScalar(mat){
    if(!isDiagonal(mat)) return false;
    const diag = mat[0][0];
    for(let i=1;i<mat.length;i++){
      if(!equals(mat[i][i], diag)) return false;
    }
    return true;
  }

  function isIdentity(mat){
    if(!isSquare(mat)) return false;
    for(let i=0;i<mat.length;i++){
      for(let j=0;j<mat.length;j++){
        if(i === j){
          if(!equals(mat[i][j], 1)) return false;
        } else {
          if(!equals(mat[i][j], 0)) return false;
        }
      }
    }
    return true;
  }

  function isUpperTriangular(mat){
    if(!isSquare(mat)) return false;
    for(let i=1;i<mat.length;i++){
      for(let j=0;j<i;j++){
        if(!equals(mat[i][j], 0)) return false;
      }
    }
    return true;
  }

  function isLowerTriangular(mat){
    if(!isSquare(mat)) return false;
    const n = mat.length;
    for(let i=0;i<n;i++){
      for(let j=i+1;j<n;j++){
        if(!equals(mat[i][j], 0)) return false;
      }
    }
    return true;
  }

  function isSymmetric(mat){
    if(!isSquare(mat)) return false;
    const n = mat.length;
    for(let i=0;i<n;i++){
      for(let j=i+1;j<n;j++){
        if(!equals(mat[i][j], mat[j][i])) return false;
      }
    }
    return true;
  }

  function isSkewSymmetric(mat){
    if(!isSquare(mat)) return false;
    const n = mat.length;
    for(let i=0;i<n;i++){
      if(!equals(mat[i][i], 0)) return false;
      for(let j=i+1;j<n;j++){
        if(!equals(mat[i][j], negateValue(mat[j][i]))) return false;
      }
    }
    return true;
  }

  function negateValue(val){
    if(typeof val === 'object'){
      return {re:-val.re, im:-val.im};
    }
    return -val;
  }

  function isOrthogonal(mat){
    if(!isSquare(mat) || isComplexMatrix(mat)) return false;
    const n = mat.length;
    const trans = transpose(mat);
    const prod = multiply(trans, mat);
    if(!prod) return false;
    for(let i=0;i<n;i++){
      for(let j=0;j<n;j++){
        if(i===j){
          if(Math.abs(prod[i][j]-1) > 1e-6) return false;
        } else {
          if(Math.abs(prod[i][j]) > 1e-6) return false;
        }
      }
    }
    return true;
  }

  function isColumnStochastic(mat){
    if(isComplexMatrix(mat)) return false;
    const rows = mat.length, cols = mat[0].length;
    for(let c=0;c<cols;c++){
      let sum = 0;
      for(let r=0;r<rows;r++){
        if(mat[r][c] < -EPS) return false;
        sum += mat[r][c];
      }
      if(Math.abs(sum - 1) > 1e-6) return false;
    }
    return true;
  }

  function determinant(mat){
    if(!isSquare(mat)) return null;
    if(isComplexMatrix(mat)) return null;
    const n = mat.length;
    const a = mat.map(row => row.slice());
    let det = 1;
    let swaps = 0;
    for(let i=0;i<n;i++){
      let pivot = i;
      for(let r=i+1;r<n;r++){
        if(Math.abs(a[r][i]) > Math.abs(a[pivot][i])) pivot = r;
      }
      if(Math.abs(a[pivot][i]) < EPS){
        return 0;
      }
      if(pivot !== i){
        [a[pivot], a[i]] = [a[i], a[pivot]];
        swaps++;
      }
      const pivotVal = a[i][i];
      det *= pivotVal;
      for(let r=i+1;r<n;r++){
        const factor = a[r][i] / pivotVal;
        for(let c=i;c<n;c++){
          a[r][c] -= factor * a[i][c];
        }
      }
    }
    return swaps % 2 === 0 ? det : -det;
  }

  function rank(matrix){
    const rows = matrix.length;
    const cols = matrix[0].length;
    if(isComplexMatrix(matrix)) return null;
    const a = matrix.map(row => row.slice());
    let rank = 0;
    let row = 0;
    for(let col=0;col<cols && row<rows;col++){
      let pivot = row;
      for(let r=row;r<rows;r++){
        if(Math.abs(a[r][col]) > Math.abs(a[pivot][col])) pivot = r;
      }
      if(Math.abs(a[pivot][col]) < EPS) continue;
      [a[pivot], a[row]] = [a[row], a[pivot]];
      const pivotVal = a[row][col];
      for(let c=col;c<cols;c++){
        a[row][c] /= pivotVal;
      }
      for(let r=0;r<rows;r++){
        if(r===row) continue;
        const factor = a[r][col];
        for(let c=col;c<cols;c++){
          a[r][c] -= factor * a[row][c];
        }
      }
      row++;
      rank++;
    }
    return rank;
  }

  function trace(matrix){
    if(!isSquare(matrix)) return null;
    let t = typeof matrix[0][0] === 'object' ? {re:0, im:0} : 0;
    for(let i=0;i<matrix.length;i++){
      t = addValues(t, matrix[i][i]);
    }
    return t;
  }

  function isSparse(matrix){
    const rows = matrix.length, cols = matrix[0].length;
    let zeroCount = 0;
    let total = rows * cols;
    for(let i=0;i<rows;i++){
      for(let j=0;j<cols;j++){
        if(equals(matrix[i][j], 0)) zeroCount++;
      }
    }
    return zeroCount / total >= 0.6;
  }

  function classifyMatrix(matrix){
    const rows = matrix.length;
    const cols = matrix[0].length;
    const steps = [];
    const types = [];
    const isComplex = isComplexMatrix(matrix);
    const square = isSquare(matrix);

    addSteps(steps, 'Dimensions', 'Matrix size: '+rows+' × '+cols+'.');

    if(rows === 1) types.push({name:'Row matrix', type:'structure', description:'Only one row.'});
    if(cols === 1) types.push({name:'Column matrix', type:'structure', description:'Only one column.'});
    if(square){
      types.push({name:'Square matrix', type:'core', description:'Rows equal columns (n = '+rows+').'});
    } else {
      types.push({name:'Rectangular matrix', type:'core', description:'Rows (m='+rows+') differ from columns (n='+cols+').'});
    }

    if(isZeroMatrix(matrix)){
      types.push({name:'Zero matrix', type:'structure', description:'All entries are zero.'});
      addSteps(steps, 'Zero matrix', 'All entries checked: A[i][j] = 0 ∀ i,j.');
    }

    if(square){
      if(isDiagonal(matrix)){
        types.push({name:'Diagonal matrix', type:'structure', description:'All off-diagonal entries are zero.'});
        addSteps(steps, 'Diagonal matrix', 'Verified A[i][j] = 0 for all i ≠ j.');
        if(isScalar(matrix)){
          types.push({name:'Scalar matrix', type:'structure', description:'Diagonal entries are equal.'});
          addSteps(steps, 'Scalar matrix', 'Diagonal entries equal to '+prettyValue(matrix[0][0])+' for all i.');
        }
        if(isIdentity(matrix)){
          types.push({name:'Identity matrix', type:'core', description:'Diagonal of ones and zeros elsewhere.'});
          addSteps(steps, 'Identity matrix', 'A[i][i] = 1 and A[i][j] = 0 for i ≠ j.');
        }
      }
      if(isUpperTriangular(matrix)){
        types.push({name:'Upper triangular', type:'structure', description:'Entries below main diagonal are zero.'});
        addSteps(steps, 'Upper triangular', 'A[i][j] = 0 for all i > j.');
      }
      if(isLowerTriangular(matrix)){
        types.push({name:'Lower triangular', type:'structure', description:'Entries above main diagonal are zero.'});
        addSteps(steps, 'Lower triangular', 'A[i][j] = 0 for all i < j.');
      }
      if(isSymmetric(matrix)){
        types.push({name:'Symmetric matrix', type:'core', description:'Matrix equals its transpose (A = Aᵀ).'});
        addSteps(steps, 'Symmetric', 'Checked A[i][j] = A[j][i] for all i,j.');
      }
      if(isSkewSymmetric(matrix)){
        types.push({name:'Skew-symmetric matrix', type:'structure', description:'A = -Aᵀ and diagonal entries are zero.'});
        addSteps(steps, 'Skew-symmetric', 'Verified A[i][j] = -A[j][i] and diagonal zeros.');
      }
      if(isOrthogonal(matrix)){
        types.push({name:'Orthogonal matrix', type:'core', description:'AᵀA = I (columns are orthonormal).'});
        addSteps(steps, 'Orthogonal', 'Computed AᵀA ≈ I within tolerance.');
      }
    }

    if(isColumnStochastic(matrix)){
      types.push({name:'Column-stochastic matrix', type:'structure', description:'Columns sum to 1 with non-negative entries.'});
      addSteps(steps, 'Column-stochastic', 'Verified ∑ rows for each column = 1 and non-negative entries.');
    }

    if(isSparse(matrix)){
      types.push({name:'Sparse matrix', type:'structure', description:'At least 60% of entries are zero.'});
    }

    const detVal = determinant(matrix);
    if(detVal !== null){
      const singular = Math.abs(detVal) <= 1e-7;
      if(singular){
        types.push({name:'Singular matrix', type:'warning', description:'Determinant ≈ 0 ⇒ matrix not invertible.'});
        addSteps(steps, 'Singularity', 'det(A) ≈ 0 (|det| = '+detVal.toExponential(4)+').');
      } else {
        types.push({name:'Non-singular matrix', type:'structure', description:'Determinant ≠ 0 ⇒ matrix invertible.'});
        addSteps(steps, 'Non-singular', 'det(A) = '+detVal.toFixed(4)+' ≠ 0.');
      }
    } else if(square) {
      types.push({name:'Determinant undefined (complex)', type:'warning', description:'Determinant check skipped for complex entries.'});
    }

    const rankVal = rank(matrix);
    if(rankVal !== null){
      addSteps(steps, 'Rank', 'Row-reduced echelon form shows rank r = '+rankVal+'.');
      if(square){
        types.push({name:'Rank '+rankVal, type:'neutral', description:'Rank of the matrix is '+rankVal+'.'});
      }
    }

    const traceVal = trace(matrix);
    if(traceVal !== null){
      addSteps(steps, 'Trace', 'Trace(A) = '+prettyValue(traceVal, 4)+'.');
    }

    return {types, steps, det:detVal, rank:rankVal, trace:traceVal, isSquare:square, isComplex};
  }

  function renderMatrix(matrix, metadata){
    const rows = matrix.length;
    const cols = matrix[0].length;
    matrixVisual.style.color = '';
    matrixVisual.innerHTML = '';
    matrixVisual.dataset.state = 'matrix';

    const dataMatrix = Array.from({length:rows}, (_, r) => Array.from({length:cols}, (_, c) => {
      const raw = matrix[r][c];
      const isComplexVal = typeof raw === 'object';
      const magnitude = isComplexVal ? Math.sqrt(raw.re*raw.re + raw.im*raw.im) : Math.abs(raw);
      return {
        row:r,
        col:c,
        raw,
        display:prettyValue(raw,4),
        value: isComplexVal ? magnitude : raw,
        magnitude,
        isDiag: r === c,
        isZero: equals(raw,0),
        isComplex: isComplexVal
      };
    }));
    const data = dataMatrix.flat();
    const valueFloats = data.map(cell => cell.isComplex ? cell.magnitude : cell.value);
    const isComplex = data.some(cell => cell.isComplex);
    const latexMatrixString = generateLatexMatrix(dataMatrix);

    // Fallback to table if d3 unavailable
    if(typeof d3 === 'undefined'){
      const latexWrapper = document.createElement('div');
      latexWrapper.className = 'latex-matrix';
      latexWrapper.style.textAlign = 'left';
      const label = document.createElement('div');
      label.style.cssText = 'color:var(--text-muted);font-size:0.85rem;margin-bottom:0.25rem';
      label.textContent = 'Matrix notation';
      const latexContainer = document.createElement('div');
      latexWrapper.appendChild(label);
      latexWrapper.appendChild(latexContainer);
      matrixVisual.appendChild(latexWrapper);
      renderLatex(latexContainer, latexMatrixString);
      return;
    }

    const wrapper = document.createElement('div');
    wrapper.className = 'matrix-svg-wrapper';
    matrixVisual.appendChild(wrapper);

    // Responsive sizing based on screen width
    const isMobile = window.innerWidth < 768;
    const svgMargin = isMobile
      ? {top:50,right:40,bottom:100,left:50}
      : {top:70,right:80,bottom:130,left:80};

    const maxCellSize = isMobile ? 50 : 70;
    const minCellSize = isMobile ? 28 : 36;
    const availableWidth = isMobile ? window.innerWidth - 80 : 420;

    const cellSize = Math.min(maxCellSize, Math.max(minCellSize, availableWidth / Math.max(rows, cols)));
    const innerWidth = cellSize * cols;
    const innerHeight = cellSize * rows;
    const svgWidth = innerWidth + svgMargin.left + svgMargin.right;
    const svgHeight = innerHeight + svgMargin.top + svgMargin.bottom;

    const svg = d3.select(wrapper)
      .append('svg')
      .attr('width', svgWidth)
      .attr('height', svgHeight)
      .attr('viewBox', `0 0 ${svgWidth} ${svgHeight}`)
      .style('max-width', '100%');

    const minVal = d3.min(valueFloats);
    const maxVal = d3.max(valueFloats);
    const maxAbs = d3.max(valueFloats.map(v => Math.abs(v))) || 1;
    let colorScale;
    if(isComplex){
      const end = maxVal === 0 ? 1 : maxVal;
      colorScale = d3.scaleSequential(d3.interpolatePuBuGn).domain([0, end]);
    } else if(minVal < 0 && maxVal > 0){
      colorScale = d3.scaleLinear()
        .domain([-maxAbs, 0, maxAbs])
        .range(['#1d4ed8', '#f8fafc', '#b91c1c']);
    } else {
      const end = maxVal === 0 ? 1 : maxVal;
      colorScale = d3.scaleLinear()
        .domain([0, end])
        .range(['#e0f2fe', '#1d4ed8']);
    }

    const g = svg.append('g')
      .attr('transform', `translate(${svgMargin.left},${svgMargin.top})`);

    // Add row highlight backgrounds
    const rowHighlights = g.selectAll('rect.row-highlight')
      .data(d3.range(rows))
      .enter()
      .append('rect')
      .attr('class', 'matrix-row-highlight')
      .attr('x', 0)
      .attr('y', i => i * cellSize)
      .attr('width', innerWidth)
      .attr('height', cellSize)
      .attr('rx', 6);

    // Add column highlight backgrounds
    const colHighlights = g.selectAll('rect.col-highlight')
      .data(d3.range(cols))
      .enter()
      .append('rect')
      .attr('class', 'matrix-col-highlight')
      .attr('x', i => i * cellSize)
      .attr('y', 0)
      .attr('width', cellSize)
      .attr('height', innerHeight)
      .attr('rx', 6);

    const tooltip = d3.select(wrapper)
      .append('div')
      .attr('class', 'matrix-tooltip');

    // Add gradient definitions for enhanced cells
    const defs = svg.append('defs');
    data.forEach((d, i) => {
      const gradientId = `cell-gradient-${i}`;
      const gradient = defs.append('linearGradient')
        .attr('id', gradientId)
        .attr('x1', '0%')
        .attr('y1', '0%')
        .attr('x2', '0%')
        .attr('y2', '100%');

      const base = isComplex ? d.magnitude : d.value;
      const baseColor = d3.color(colorScale(base));
      const lighterColor = baseColor.brighter(0.3);

      gradient.append('stop')
        .attr('offset', '0%')
        .attr('stop-color', lighterColor);
      gradient.append('stop')
        .attr('offset', '100%')
        .attr('stop-color', baseColor);

      d.gradientId = gradientId;
    });

    const cells = g.selectAll('rect.cell')
      .data(data)
      .enter()
      .append('rect')
      .attr('class','cell matrix-cell')
      .attr('x', d => d.col * cellSize)
      .attr('y', d => d.row * cellSize)
      .attr('width', 0)
      .attr('height', 0)
      .attr('rx', 10)
      .attr('ry', 10)
      .attr('fill', d => `url(#${d.gradientId})`)
      .attr('stroke', d => d.isDiag ? '#f59e0b' : 'rgba(15,23,42,0.08)')
      .attr('stroke-width', d => d.isDiag ? 2.5 : 1.5)
      .attr('transform', `translate(3,3)`)
      .style('cursor','pointer')
      .transition()
      .duration(600)
      .delay((d, i) => i * 20)
      .ease(d3.easeCubicOut)
      .attr('width', cellSize - 6)
      .attr('height', cellSize - 6);

    cells.on('end', function() {
      d3.select(this)
        .on('mouseenter', function(event, d){
          // Highlight row and column
          rowHighlights.filter((r, i) => i === d.row).style('opacity', 1);
          colHighlights.filter((c, i) => i === d.col).style('opacity', 1);

          d3.select(this)
            .transition()
            .duration(200)
            .attr('stroke-width', d.isDiag ? 4 : 3)
            .attr('stroke', d.isDiag ? '#f59e0b' : '#3b82f6')
            .attr('rx', 8)
            .attr('ry', 8);

          const [x,y] = d3.pointer(event, wrapper);
          tooltip
            .style('left', `${x}px`)
            .style('top', `${y}px`)
            .style('opacity', 1)
            .style('transform', 'translate(-50%, -120%)')
            .html(`<strong>a<sub>${d.row+1}${d.col+1}</sub></strong> = ${d.display}${d.isDiag ? '<div style="color:#fbbf24;margin-top:4px">⬥ Main diagonal</div>' : ''}${d.isZero ? '<div style="color:#94a3b8;margin-top:4px">○ Zero entry</div>' : ''}${isComplex ? `<div style="color:#a78bfa;margin-top:4px">|value| = ${d.magnitude.toFixed(4)}</div>` : ''}`);
        })
        .on('mousemove', function(event){
          const [x,y] = d3.pointer(event, wrapper);
          tooltip
            .style('left', `${x}px`)
            .style('top', `${y}px`);
        })
        .on('mouseleave', function(event, d){
          // Remove highlights
          rowHighlights.style('opacity', 0);
          colHighlights.style('opacity', 0);

          d3.select(this)
            .transition()
            .duration(200)
            .attr('stroke-width', d.isDiag ? 2.5 : 1.5)
            .attr('stroke', d.isDiag ? '#f59e0b' : 'rgba(15,23,42,0.08)')
            .attr('rx', 10)
            .attr('ry', 10);

          tooltip.style('opacity', 0).style('transform', 'translate(-50%, -110%)');
        });
    });

    g.selectAll('text.matrix-cell-value')
      .data(data)
      .enter()
      .append('text')
      .attr('class','matrix-cell-value')
      .attr('x', d => d.col * cellSize + (cellSize/2))
      .attr('y', d => d.row * cellSize + (cellSize/2))
      .attr('text-anchor','middle')
      .attr('dominant-baseline','middle')
      .attr('fill', d => {
        const base = isComplex ? d.magnitude : d.value;
        const color = d3.color(colorScale(base));
        const luminance = color ? (0.2126*color.r + 0.7152*color.g + 0.0722*color.b)/255 : 0.7;
        return luminance < 0.55 ? '#f8fafc' : '#0f172a';
      })
      .style('opacity', 0)
      .text(d => d.display)
      .transition()
      .duration(400)
      .delay((d, i) => 600 + i * 20)
      .style('opacity', 1);

    // Add diagonal indicator for square matrices
    if(rows === cols){
      g.append('line')
        .attr('class', 'matrix-diagonal-outline')
        .attr('x1', 0)
        .attr('y1', 0)
        .attr('x2', innerWidth)
        .attr('y2', innerHeight)
        .style('opacity', 0)
        .transition()
        .duration(800)
        .delay(400)
        .style('opacity', 0.6);
    }

    // Row labels
    const rowLabels = svg.append('g')
      .attr('transform', `translate(${svgMargin.left - 12},${svgMargin.top})`);
    rowLabels.selectAll('text')
      .data(d3.range(rows))
      .enter()
      .append('text')
      .attr('class','matrix-axis-label')
      .attr('x', -12)
      .attr('y', i => i * cellSize + cellSize/2)
      .attr('text-anchor','end')
      .attr('dominant-baseline','middle')
      .text(i => 'Row '+(i+1));

    // Column labels
    const colLabels = svg.append('g')
      .attr('transform', `translate(${svgMargin.left},${svgMargin.top - 20})`);
    colLabels.selectAll('text')
      .data(d3.range(cols))
      .enter()
      .append('text')
      .attr('class','matrix-axis-label')
      .attr('x', i => i * cellSize + cellSize/2)
      .attr('y', -20)
      .attr('text-anchor','middle')
      .text(i => 'Col '+(i+1));

    // Legend
    const legendWidth = Math.min(260, innerWidth);
    const legendHeight = 12;
    const legendX = svgMargin.left + (innerWidth - legendWidth)/2;
    const legendY = svgMargin.top + innerHeight + 40;

    const legendGradientId = 'matrix-gradient-'+Date.now();
    const legendGradient = defs.append('linearGradient')
      .attr('id', legendGradientId)
      .attr('x1','0%')
      .attr('y1','0%')
      .attr('x2','100%')
      .attr('y2','0%');

    const legendDomain = isComplex ? [0, maxVal === 0 ? 1 : maxVal] : (minVal < 0 && maxVal > 0 ? [-maxAbs, 0, maxAbs] : [0, maxVal === 0 ? 1 : maxVal]);
    const legendStops = legendDomain.length === 3 ? [0,0.5,1] : [0,1];
    legendStops.forEach((offset, idx) => {
      legendGradient.append('stop')
        .attr('offset', `${offset*100}%`)
        .attr('stop-color', colorScale(legendDomain[idx]));
    });

    svg.append('rect')
      .attr('x', legendX)
      .attr('y', legendY)
      .attr('width', legendWidth)
      .attr('height', legendHeight)
      .attr('rx',6)
      .attr('fill', `url(#${legendGradientId})`);

    const legendScale = d3.scaleLinear()
      .domain([legendDomain[0], legendDomain[legendDomain.length -1]])
      .range([0, legendWidth]);

    const legendAxis = d3.axisBottom(legendScale)
      .ticks(legendDomain.length === 3 ? 5 : 4)
      .tickFormat(d3.format('.2f'));

    svg.append('g')
      .attr('transform', `translate(${legendX},${legendY + legendHeight})`)
      .attr('class','matrix-axis-tick')
      .call(legendAxis);

    svg.append('text')
      .attr('x', legendX + legendWidth/2)
      .attr('y', legendY + legendHeight + 30)
      .attr('text-anchor','middle')
      .attr('class','matrix-legend-label')
      .text(isComplex ? 'Magnitude |aᵢⱼ|' : (minVal < 0 && maxVal > 0 ? 'Value scale (negative → positive)' : 'Value scale'));

    const latexRows = dataMatrix.map(row =>
      row.map(cell => {
        const color = getColorForCell(cell);
        return latexColorWrap(formatLatexValue(cell.raw), color);
      }).join(' & ')
    );
    const latexDiv = document.createElement('div');
    latexDiv.className = 'latex-matrix';
    latexDiv.style.cssText = 'margin-top:0.75rem;text-align:left';
    const latexLabel = document.createElement('div');
    latexLabel.style.cssText = 'color:var(--text-muted);font-size:0.85rem;margin-bottom:0.25rem';
    latexLabel.textContent = 'Matrix notation';
    const latexContainer = document.createElement('div');
    latexDiv.appendChild(latexLabel);
    latexDiv.appendChild(latexContainer);
    matrixVisual.appendChild(latexDiv);
    renderLatex(latexContainer, latexMatrixString);

    let metaHtml = '';
    if(metadata.isSquare){
      metaHtml += 'Determinant: ';
      if(metadata.det === null) metaHtml += 'n/a (complex)';
      else metaHtml += metadata.det.toFixed(6);
      metaHtml += '<br>';
      metaHtml += 'Rank: '+(metadata.rank === null ? 'n/a (complex)' : metadata.rank)+'<br>';
      if(metadata.trace !== null){
        metaHtml += 'Trace: '+prettyValue(metadata.trace,4)+'<br>';
      }
    } else {
      metaHtml += 'Rank: '+(metadata.rank === null ? 'n/a (complex)' : metadata.rank)+'<br>';
    }
    metaHtml += 'Value range: '+(isComplex ? `|aᵢⱼ| ∈ [${(d3.min(valueFloats) || 0).toFixed(4)}, ${(d3.max(valueFloats) || 0).toFixed(4)}]` : `[${(d3.min(valueFloats) || 0).toFixed(4)}, ${(d3.max(valueFloats) || 0).toFixed(4)}]`);
    matrixMeta.innerHTML = metaHtml;
    queueTypeset([matrixMeta]);
  }

  function renderTypes(types){
    if(!types.length){
      typeBadges.innerHTML = '<span style="color:var(--text-muted)">No classifications found.</span>';
      return;
    }
    const html = types.map(t => {
      const badgeClass = t.type === 'core' ? 'badge-core' : t.type === 'structure' ? 'badge-structure' : t.type === 'warning' ? 'badge-warning' : 'badge-neutral';
      return '<span class="badge-type '+badgeClass+'">'+t.name+'</span>';
    }).join('');
    typeBadges.innerHTML = html;

    const summary = types.map(t => '<div class="classification-card"><strong>'+t.name+':</strong> '+t.description+'</div>').join('');
    classificationSummary.innerHTML = summary;
  }

  function renderSteps(steps){
    if(!steps.length){
      stepsContent.innerHTML = '<div style="color:var(--text-muted)">Run the classifier to see step-by-step reasoning.</div>';
      return;
    }
    const html = steps.map(step => '<div class="explain-step"><strong>'+step.title+':</strong> '+step.description+'</div>').join('');
    stepsContent.innerHTML = html;
  }

  function randomMatrix(rows, cols){
    const matrix = [];
    for(let r=0;r<rows;r++){
      const row = [];
      for(let c=0;c<cols;c++){
        const val = Math.random() < 0.6 ? 0 : (Math.random()*4 - 2);
        row.push(parseFloat(val.toFixed(2)));
      }
      matrix.push(row);
    }
    return matrix;
  }

  function buildGridFromText(){
    try{
      const rows = parseInt(rowCountInput.value, 10) || 0;
      const cols = parseInt(colCountInput.value, 10) || 0;
      const matrix = parseMatrix(textarea.value, rows, cols, allowComplex.checked);
      buildGridFromMatrix(matrix);
    } catch(err){
      gridContainer.innerHTML = '<div style="color:var(--error,#ef4444);font-size:0.85rem">Cannot load editor: '+err.message+'</div>';
    }
  }

  function buildGridFromMatrix(matrix){
    currentGridMatrix = cloneMatrix(matrix);
    const rows = matrix.length;
    const cols = matrix[0].length;
    let html = '<table style="border-collapse:collapse;width:100%;margin-bottom:0"><tbody>';
    for(let r=0;r<rows;r++){
      html += '<tr>';
      for(let c=0;c<cols;c++){
        const val = typeof matrix[r][c] === 'object' ? prettyValue(matrix[r][c],4) : matrix[r][c];
        html += `<td style="min-width:70px;border:1px solid var(--border,#e2e8f0);padding:0.15rem"><input type="text" class="tool-input grid-cell" data-row="${r}" data-col="${c}" value="${val}" style="padding:0.25rem 0.4rem;font-size:0.85rem"></td>`;
      }
      html += '</tr>';
    }
    html += '</tbody></table>';
    gridContainer.innerHTML = html;

    gridContainer.querySelectorAll('.grid-cell').forEach(input => {
      input.addEventListener('input', function(){
        const r = parseInt(this.getAttribute('data-row'),10);
        const c = parseInt(this.getAttribute('data-col'),10);
        const raw = this.value.trim();
        if(!currentGridMatrix[r]) currentGridMatrix[r] = [];
        currentGridMatrix[r][c] = allowComplex.checked ? parseComplexSafe(raw) : parseFloatSafe(raw);
      });
    });
  }

  function parseFloatSafe(str){
    if(!str) return 0;
    const num = parseFloat(str.replace(/,/g,''));
    return isFinite(num) ? num : 0;
  }

  function parseComplexSafe(str){
    if(!str) return {re:0, im:0};
    try{
      return parseComplex(str);
    } catch(err){
      return {re:0, im:0};
    }
  }

  function setMatrixInputs(matrix){
    const rows = matrix.length;
    const cols = matrix[0].length;
    rowCountInput.value = rows;
    colCountInput.value = cols;
    const lines = matrix.map(row => row.map(val => typeof val === 'object' ? prettyValue(val,4) : val).join(' '));
    textarea.value = lines.join('\n');
    if(gridEditorOpen){
      buildGridFromMatrix(matrix);
    }
    updateTelemetry();
  }

  function handleAnalyse(){
    try{
      inputError.style.display = 'none';
      const rows = parseInt(rowCountInput.value, 10) || 0;
      const cols = parseInt(colCountInput.value, 10) || 0;
      if(rows < 1 || cols < 1 || rows > 10 || cols > 10){
        throw new Error('Supported dimensions: 1 ≤ rows, cols ≤ 10.');
      }
      const matrix = parseMatrix(textarea.value, rows, cols, allowComplex.checked);
      const result = classifyMatrix(matrix);
      renderMatrix(matrix, result);
      renderTypes(result.types);
      renderSteps(showIntermediate.checked ? result.steps : []);
    } catch(err){
      const detected = detectDimensions(textarea.value);
      if(detected && !detected.consistent){
        highlightInconsistentRows(detected.lengths);
      } else if(matrixVisual.dataset.state !== 'matrix'){
        matrixVisual.innerHTML = '<div style="color:var(--error,#ef4444)">'+err.message+'</div>';
      }
      inputError.textContent = err.message;
      inputError.style.display = 'block';
      typeBadges.innerHTML = '';
      classificationSummary.innerHTML = '';
      stepsContent.innerHTML = '';
      matrixMeta.innerHTML = '';
    }
  }

  function handleRandom(){
    const rows = Math.floor(Math.random()*5) + 2; // 2 - 6
    const cols = Math.floor(Math.random()*5) + 2; // 2 - 6
    const matrix = randomMatrix(rows, cols);
    setMatrixInputs(matrix);
    handleAnalyse();
  }

  function handleClear(){
    textarea.value = '';
    typeBadges.innerHTML = '';
    classificationSummary.innerHTML = '';
    stepsContent.innerHTML = '';
    matrixVisual.innerHTML = '<div style="color:var(--text-muted)">Enter a matrix and click classify to view the visualization.</div>';
    matrixVisual.dataset.state = '';
    matrixMeta.innerHTML = '';
    inputError.style.display = 'none';
    matrixTelemetry.innerHTML = 'Awaiting input…';
    if(gridEditorOpen){
      gridContainer.innerHTML = '';
      currentGridMatrix = null;
    }
  }

  function presetMatrix(name){
    if(name === 'identity3'){
      setMatrixInputs([
        [1,0,0],
        [0,1,0],
        [0,0,1]
      ]);
    } else if(name === 'symmetric3'){
      setMatrixInputs([
        [4,1,2],
        [1,3,0],
        [2,0,5]
      ]);
    } else if(name === 'orthogonal3'){
      setMatrixInputs([
        [0,1,0],
        [1,0,0],
        [0,0,-1]
      ]);
    } else if(name === 'upper4'){
      setMatrixInputs([
        [2,4,1,0],
        [0,3,-1,2],
        [0,0,5,7],
        [0,0,0,1]
      ]);
    } else if(name === 'lower4'){
      setMatrixInputs([
        [3,0,0,0],
        [-1,2,0,0],
        [4,5,1,0],
        [2,-3,6,2]
      ]);
    } else if(name === 'singular3'){
      setMatrixInputs([
        [2,4,6],
        [1,2,3],
        [0,0,0]
      ]);
    } else if(name === 'stochastic3'){
      setMatrixInputs([
        [0.5, 0.2, 0.3],
        [0.3, 0.5, 0.3],
        [0.2, 0.3, 0.4]
      ]);
    } else if(name === 'rectangular23'){
      setMatrixInputs([
        [1,2,3],
        [4,5,6]
      ]);
    }
    handleAnalyse();
  }

  function copyMatrix(){
    var text = textarea.value.trim();
    if(!text) return;
    if(window.ToolUtils && window.ToolUtils.copyToClipboard){
      ToolUtils.copyToClipboard(text, {
        toastMessage: 'Matrix copied to clipboard!',
        showSupportPopup: false
      });
    } else if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(text).then(function(){
        btnCopyMatrix.innerHTML = '<i class="fas fa-check"></i> Copied!';
        btnCopyMatrix.className = 'tool-btn-outline';
        btnCopyMatrix.style.cssText = 'color:#16a34a;border-color:#16a34a';
        setTimeout(function(){
          btnCopyMatrix.innerHTML = '<i class="fas fa-copy"></i> Copy Matrix';
          btnCopyMatrix.className = 'tool-btn-outline';
          btnCopyMatrix.style.cssText = '';
        }, 2000);
      });
    }
  }

  btnAnalyse.addEventListener('click', handleAnalyse);
  btnRandom.addEventListener('click', handleRandom);
  btnClear.addEventListener('click', handleClear);
  btnCopyMatrix.addEventListener('click', copyMatrix);
  MatrixUtils.printWorksheet(document.getElementById('btnPrintWorksheet'), 'Matrix Type Classifier', {
    exerciseType: 'classifier'
  });
  var _stepsEl = document.getElementById('stepsContent'); if(_stepsEl) MatrixUtils.makeStepsCollapsible(_stepsEl.closest('.tool-card'));
  textarea.addEventListener('keydown', function(e){
    if(e.key === 'Enter' && (e.metaKey || e.ctrlKey)){
      handleAnalyse();
    }
  });
  textarea.addEventListener('input', function(){
    updateTelemetry();
    if(gridEditorOpen){
      buildGridFromText();
    }
  });

  rowCountInput.addEventListener('change', function(){
    updateTelemetry();
    if(gridEditorOpen){
      buildGridFromText();
    }
  });
  colCountInput.addEventListener('change', function(){
    updateTelemetry();
    if(gridEditorOpen){
      buildGridFromText();
    }
  });

  btnGridEditor.addEventListener('click', function(){
    gridEditorOpen = !gridEditorOpen;
    gridEditor.style.display = gridEditorOpen ? '' : 'none';
    btnGridEditor.innerHTML = gridEditorOpen ? '<i class="fas fa-times"></i> Close Grid Editor' : '<i class="fas fa-table"></i> Open Grid Editor';
    if(gridEditorOpen){
      buildGridFromText();
    }
  });

  btnGridSync.addEventListener('click', function(){
    if(!currentGridMatrix) return;
    setMatrixInputs(currentGridMatrix);
    handleAnalyse();
  });

  btnGridAddRow.addEventListener('click', function(){
    if(!currentGridMatrix){
      buildGridFromText();
      return;
    }
    const cols = currentGridMatrix[0] ? currentGridMatrix[0].length : parseInt(colCountInput.value,10) || 1;
    currentGridMatrix.push(Array(cols).fill(0));
    buildGridFromMatrix(currentGridMatrix);
    rowCountInput.value = currentGridMatrix.length;
    updateTelemetry();
  });

  btnGridAddCol.addEventListener('click', function(){
    if(!currentGridMatrix){
      buildGridFromText();
      return;
    }
    currentGridMatrix.forEach(row => row.push(0));
    buildGridFromMatrix(currentGridMatrix);
    if(currentGridMatrix[0]){
      colCountInput.value = currentGridMatrix[0].length;
    }
    updateTelemetry();
  });

  presetItems.forEach(item => {
    item.addEventListener('click', function(e){
      e.preventDefault();
      presetItems.forEach(b => b.classList.remove('active'));
      item.classList.add('active');
      const preset = item.getAttribute('data-preset');
      presetMatrix(preset);
    });
  });

  // Toggle examples section
  const btnToggleExamples = document.getElementById('btnToggleExamples');
  const examplesContent = document.getElementById('examplesContent');
  if(btnToggleExamples && examplesContent){
    btnToggleExamples.addEventListener('click', function(){
      const isVisible = examplesContent.style.display !== 'none';
      if(isVisible){
        examplesContent.style.display = 'none';
        btnToggleExamples.textContent = 'Show Examples';
      } else {
        examplesContent.style.display = 'block';
        btnToggleExamples.textContent = 'Hide Examples';
        // Render MathJax for examples
        if(window.MathJax && window.MathJax.typesetPromise){
          MathJax.typesetPromise([examplesContent]).catch(function(err){
            console.error('MathJax examples error:', err);
          });
        }
      }
    });
  }

  // Initialize with identity
  presetMatrix('identity3');
  var initPreset = document.querySelector('[data-preset="identity3"]');
  if (initPreset) initPreset.classList.add('active');
  updateTelemetry();

  // Render examples on page load
  if(window.MathJax && window.MathJax.startup && window.MathJax.startup.promise){
    MathJax.startup.promise.then(function(){
      if(examplesContent){
        MathJax.typesetPromise([examplesContent]).catch(function(err){
          console.error('MathJax examples init error:', err);
        });
      }
    });
  }

  // Exam-style practice
  if (typeof ToolUtils !== 'undefined' && ToolUtils.PracticeSheet) {
    ToolUtils.PracticeSheet.init({
      containerId: 'practiceSection',
      title: 'Matrix Classifier Practice',
      toolColor: '#3b82f6',
      difficulties: [
        { id: 'easy', label: 'Easy', description: 'Diagonal / identity / zero' },
        { id: 'medium', label: 'Medium', description: 'Symmetric / triangular' },
        { id: 'hard', label: 'Hard', description: 'Orthogonal / positive-definite' }
      ],
      generateProblems: MatrixPractice.classifier
    });
  }
})();
</script>

<section style="max-width:900px;margin:2rem auto;padding:0 1.5rem">
  <!-- Exam-Style Practice -->
  <div class="tool-card" style="margin-bottom:1.5rem;padding:0;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-secondary)">
    <div style="padding:1.25rem 1.5rem;border-bottom:1px solid var(--border)"><h3 style="margin:0;font-size:1.15rem;color:var(--text-primary)">Exam-Style Practice</h3></div>
    <div style="padding:1.5rem" id="practiceSection"></div>
  </div>

  <div class="tool-card" style="padding:2rem;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-secondary)">
    <h2 id="eeat" style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">About This Matrix Type Classifier</h2>
    <p style="margin-bottom:1rem;color:var(--text-secondary);line-height:1.7">This tool identifies 20+ matrix types by checking dimensions, transpose relations (A vs Aᵀ), diagonal structure, determinant, rank, and orthogonality. It uses D3 for visualization and provides step-by-step reasoning. <strong>All analysis runs client-side</strong>—no data stored.</p>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5rem;margin-top:1.5rem">
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Authorship &amp; Expertise</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">Anish Nath</a></li>
          <li><strong>Background:</strong> Math and developer tools for education</li>
          <li><strong>Method:</strong> Tolerance-aware property checks</li>
        </ul>
      </div>
      <div>
        <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary)">Trust &amp; Privacy</h3>
        <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7">
          <li><strong>Privacy:</strong> All analysis runs locally; no data stored</li>
          <li><strong>Client-side:</strong> Your matrices never leave your device</li>
          <li><strong>Support:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary)">@anish2good</a></li>
        </ul>
      </div>
    </div>
  </div>
</section>

<section id="faq" style="max-width:900px;margin:2rem auto;padding:0 1.5rem">
  <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary)">Matrix Type Classifier: FAQ</h2>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">How do you identify the type of a matrix?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Check dimensions first (square vs rectangular). For square matrices, compare A to Aᵀ (symmetric if A = Aᵀ, skew-symmetric if A = −Aᵀ), inspect diagonal entries, and compute determinant/rank for singularity. The tool automates these steps.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What matrix types does this detect?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Rectangular, square, row, column, zero, diagonal, scalar, identity, upper/lower triangular, symmetric, skew-symmetric, orthogonal, singular/non-singular, stochastic, and sparse; plus trace, determinant, rank and definiteness hints.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">Why is my matrix flagged as singular?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">A matrix is singular when det(A) = 0 or rows are linearly dependent. The tool uses tolerance-aware elimination; very small determinants relative to entries are treated as singular.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">How are matrix properties related to each other?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Many properties overlap: every identity matrix is diagonal, symmetric, and orthogonal. Every orthogonal matrix has det = ±1. Positive-definite matrices are always symmetric and non-singular. Understanding these relationships helps classify matrices quickly.</p>
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
