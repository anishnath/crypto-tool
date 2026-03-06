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
    <jsp:param name="toolName" value="Matrix Determinant Calculator — Free Step-by-Step" />
    <jsp:param name="toolDescription" value="Calculate det(A) for 2×2 to 10×10 matrices. Cofactor expansion, row reduction, LU decomposition with step-by-step solutions. Free, instant." />
    <jsp:param name="toolCategory" value="Math Tools" />
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
    <jsp:param name="faq5q" value="Can I practice with exam-style determinant questions?" />
    <jsp:param name="faq5a" value="Yes. The Exam-Style Practice section generates problems at Easy (2×2), Medium (3×3), or Hard (4×4 and singularity checks) with instant scoring and answer reveal." />
    <jsp:param name="faq6q" value="What are useful properties of determinants?" />
    <jsp:param name="faq6a" value="Key properties: det(AB) = det(A)det(B), det(A^T) = det(A), det(cA) = c^n det(A) for n×n, swapping rows flips the sign, and a row of zeros makes det = 0." />
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
  <script src="<%=request.getContextPath()%>/modern/js/practice-sheet.js?v=<%=cacheVersion%>"></script>
  <script src="<%=request.getContextPath()%>/js/matrix-practice-problems.js?v=<%=cacheVersion%>"></script>
  <script>MatrixUtils.initMathJax();</script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" crossorigin="anonymous"></script>

  <style>
    :root { --tool-primary:#3b82f6; --tool-primary-dark:#1d4ed8; --tool-gradient:linear-gradient(135deg,#3b82f6 0%,#1d4ed8 100%); --tool-light:#eff6ff }
    .tool-page-container{min-height:auto;align-items:start;grid-template-columns:minmax(300px,360px) minmax(0,1fr) 280px}
    .tool-input-column,.tool-output-column,.tool-ads-column{min-height:0}
    .tool-input-column{position:relative;top:auto;max-height:none;overflow:visible}
    .tool-output-column{overflow:visible}
    .tool-output-column .tool-card{overflow:visible}
    #resultArea,#stepsArea{max-height:none;overflow:visible}
    .det-calculator .result-value{font-size:2rem;font-weight:700;color:#059669;font-family:monospace}
    .method-badge{display:inline-flex;align-items:center;padding:0.3rem 0.6rem;border-radius:999px;font-size:0.85rem;margin:0.25rem;font-weight:500;background:var(--tool-light);color:var(--tool-primary)}
    .teacher-chip{display:inline-flex;align-items:center;padding:0.2rem 0.55rem;border-radius:999px;font-size:0.75rem;font-weight:600;background:#e0e7ff;color:#3730a3;margin-right:0.4rem}
    .teacher-card{background:var(--bg-primary);border:1px solid var(--border);border-radius:0.75rem;padding:0.9rem;margin-bottom:0.75rem}
    .teacher-card-title{font-size:0.78rem;letter-spacing:.03em;font-weight:700;color:var(--text-secondary);margin-bottom:0.45rem;text-transform:uppercase}
    .teacher-equation{font-size:1.05rem;color:var(--text-primary);margin-top:0.25rem}
    .teacher-summary{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:0.6rem;margin:0.75rem 0}
    .teacher-summary-item{background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.6rem;padding:0.55rem}
    .teacher-summary-label{display:block;font-size:0.72rem;color:var(--text-secondary);font-weight:700;text-transform:uppercase;letter-spacing:.02em}
    .teacher-summary-value{display:block;font-size:0.92rem;color:var(--text-primary);font-weight:600;margin-top:0.2rem}
    .teacher-answer-box{background:linear-gradient(180deg,#ecfdf5 0%, #f0fdf4 100%);border:1px solid #86efac;border-radius:0.75rem;padding:0.75rem 0.9rem}
    .teacher-answer-label{font-size:0.78rem;font-weight:700;color:#166534;text-transform:uppercase;letter-spacing:.03em}
    .teacher-answer-value{font-size:1.6rem;font-weight:800;color:#065f46;font-family:var(--font-mono,'monospace');margin-top:0.2rem}
    .teacher-instructions{font-size:0.82rem;color:var(--text-secondary);line-height:1.6;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.6rem;padding:0.6rem 0.75rem}
    .teacher-layout{display:grid;grid-template-columns:minmax(0,1fr) 260px;gap:0.75rem}
    .teacher-step{border:1px solid var(--border);border-radius:0.7rem;background:var(--bg-primary);margin-bottom:0.65rem;overflow:hidden}
    .teacher-step-head{padding:0.45rem 0.7rem;background:#eff6ff;border-bottom:1px solid #dbeafe;font-size:0.76rem;font-weight:700;color:#1d4ed8;text-transform:uppercase;letter-spacing:.03em}
    .teacher-step-body{padding:0.65rem 0.75rem;color:var(--text-primary);line-height:1.55;font-size:0.9rem}
    .teacher-checkpoint{border:1px solid var(--border);background:var(--bg-primary);border-radius:0.7rem;padding:0.65rem;margin-bottom:0.65rem}
    .teacher-checkpoint-title{font-size:0.76rem;font-weight:700;color:var(--text-secondary);text-transform:uppercase;letter-spacing:.03em;margin-bottom:0.35rem}
    .teacher-checkpoint-body{font-size:0.84rem;color:var(--text-primary);line-height:1.5}
    .teacher-step-stream{border-left:2px solid #dbeafe;padding-left:0.75rem}
    .teacher-step-stream .teacher-step{position:relative}
    .teacher-step-stream .teacher-step::before{content:'';position:absolute;left:-1.2rem;top:0.78rem;width:0.55rem;height:0.55rem;border-radius:50%;background:#3b82f6}
    .teacher-focus{display:grid;grid-template-columns:1fr 1fr;gap:0.6rem}
    .teacher-focus .teacher-card{margin-bottom:0}
    .teacher-pedagogy{font-size:0.9rem;color:var(--text-primary);line-height:1.6}
    .matrix-step-player{border:1px solid var(--border);border-radius:0.8rem;background:var(--bg-primary);padding:0.75rem}
    .matrix-step-player-header{display:flex;align-items:center;justify-content:space-between;gap:0.75rem;margin-bottom:0.6rem}
    .matrix-step-player-meta{font-size:0.86rem;color:var(--text-secondary);font-weight:600;min-width:72px}
    .matrix-step-progress{flex:1;height:0.45rem;background:var(--bg-secondary);border-radius:999px;overflow:hidden;border:1px solid var(--border)}
    .matrix-step-progress-bar{height:100%;background:linear-gradient(90deg,#2563eb,#3b82f6);transition:width 0.35s ease}
    .matrix-step-viewport{min-height:220px;position:relative}
    .matrix-step-slide{display:none;opacity:0;transform:translateX(18px) scale(0.98)}
    .matrix-step-slide.is-active{display:block;animation:stepSlideIn .35s ease forwards}
    .matrix-step-slide.is-past{display:none}
    .matrix-step-controls{display:flex;justify-content:space-between;gap:0.55rem;margin-top:0.6rem}
    .matrix-step-controls .tool-btn-outline,.matrix-step-controls .tool-action-btn{flex:1}
    @keyframes stepSlideIn{from{opacity:0;transform:translateX(18px) scale(0.98)}to{opacity:1;transform:translateX(0) scale(1)}}
    .matrix-anim-player{border:1px solid var(--border);border-radius:0.8rem;background:var(--bg-primary);padding:0.8rem;margin-bottom:0.75rem}
    .matrix-anim-header{display:flex;justify-content:space-between;align-items:center;gap:0.7rem;margin-bottom:0.45rem}
    .matrix-anim-title{font-size:0.82rem;font-weight:700;color:var(--text-secondary);text-transform:uppercase;letter-spacing:.03em}
    .matrix-anim-meta{font-size:0.82rem;color:var(--text-secondary);font-weight:700}
    .matrix-anim-progress{height:0.42rem;border-radius:999px;border:1px solid var(--border);background:var(--bg-secondary);overflow:hidden;margin-bottom:0.65rem}
    .matrix-anim-progress-bar{height:100%;background:linear-gradient(90deg,#2563eb,#3b82f6);transition:width .35s ease}
    .matrix-anim-stage{border:1px dashed var(--border);border-radius:0.65rem;padding:0.55rem;background:var(--bg-secondary)}
    .matrix-anim-frame-title{font-size:0.88rem;font-weight:700;color:var(--text-primary);margin-bottom:0.4rem}
    .matrix-anim-note{font-size:0.8rem;color:var(--text-secondary);margin-top:0.45rem;line-height:1.5;min-height:1.2rem}
    .matrix-anim-grid-wrap{overflow:auto}
    .matrix-anim-grid-wrap.frame-enter .matrix-anim-grid{animation:matrixFrameIn .3s ease}
    .matrix-anim-grid{border-collapse:separate;border-spacing:0.25rem;margin:0 auto}
    .matrix-anim-grid td{min-width:2.4rem;padding:0.35rem 0.4rem;border:1px solid var(--border);border-radius:0.45rem;text-align:center;font-family:var(--font-mono,'monospace');font-size:0.86rem;background:var(--bg-primary);transition:transform .25s ease, background-color .25s ease, border-color .25s ease}
    .matrix-anim-grid td.cell-changed{background:#dbeafe;border-color:#60a5fa;animation:cellPulse .5s ease}
    .matrix-anim-controls{display:flex;gap:0.55rem;margin-top:0.6rem}
    .matrix-anim-controls .tool-btn-outline,.matrix-anim-controls .tool-action-btn{flex:1}
    @keyframes matrixFrameIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
    @keyframes cellPulse{0%{transform:scale(0.94)}100%{transform:scale(1)}}
    @media (max-width: 1100px){.teacher-layout{grid-template-columns:1fr}.teacher-focus{grid-template-columns:1fr}}
    .matrix-display{background:var(--bg-primary);border:1px solid var(--border);border-radius:0.6rem;padding:0.4rem 0.55rem}
    .matrix-calc.det-calculator .tool-card-body{padding:0.85rem}
    .result-actions{display:flex;gap:0.35rem;flex-wrap:wrap}
    .result-action-btn{width:2rem;height:2rem;padding:0;display:inline-flex;align-items:center;justify-content:center;border-radius:0.55rem;font-size:0.92rem;line-height:1}
    .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}
    .matrix-example-grid{display:flex;flex-wrap:wrap;gap:0.35rem}
    .matrix-example-btn{text-align:left;padding:0.35rem 0.55rem;font-size:0.74rem;border:1px solid var(--border);border-radius:999px;background:var(--bg-primary);color:var(--text-primary);cursor:pointer;transition:all .15s;line-height:1.2}
    .matrix-example-btn:hover{border-color:var(--tool-primary);background:var(--tool-light);color:var(--tool-primary)}
    .compact-input-row{display:grid;grid-template-columns:1fr auto auto;gap:0.4rem;align-items:center}
    .matrix-editor-toggle{display:flex;gap:0.4rem;flex-wrap:wrap;margin-bottom:0.5rem}
    .matrix-toggle-btn{padding:0.35rem 0.6rem;font-size:0.75rem;border-radius:0.45rem;border:1px solid var(--border);background:var(--bg-primary);cursor:pointer}
    .matrix-toggle-btn.is-active{background:#dbeafe;border-color:#60a5fa;color:#1d4ed8;font-weight:600}
    .matrix-editor-panel{display:none}
    .matrix-editor-panel.is-active{display:block}
    .matrix-grid-wrap{overflow:auto;border:1px solid var(--border);border-radius:0.55rem;padding:0.45rem;background:var(--bg-secondary);max-height:340px}
    .matrix-input-grid{border-collapse:separate;border-spacing:0.28rem;margin:0 auto}
    .matrix-input-grid td input{width:3.25rem;min-width:3.25rem;padding:0.3rem 0.35rem;border:1px solid var(--border);border-radius:0.45rem;text-align:center;font-family:var(--font-mono,'monospace');font-size:0.8rem;background:var(--bg-primary)}
    .matrix-input-grid td input:focus{outline:none;border-color:#3b82f6;box-shadow:0 0 0 2px rgba(59,130,246,0.16)}
    .compact-help{font-size:0.72rem;color:var(--text-secondary);margin-top:0.35rem}
    .compact-actions{display:flex;gap:0.35rem;flex-wrap:wrap}
    .compact-actions .tool-btn-outline{padding:0.3rem 0.55rem;font-size:0.74rem}
    @media (max-width: 1200px){.tool-page-container{grid-template-columns:minmax(280px,340px) minmax(0,1fr) 250px;gap:1rem;padding:1rem}}
    @media (max-width: 1024px){.tool-page-container{grid-template-columns:minmax(280px,330px) minmax(0,1fr)}.tool-ads-column{display:none}}
    @media (max-width: 640px){.compact-input-row{grid-template-columns:1fr 1fr}.compact-input-row .tool-btn-outline:last-child{grid-column:1 / -1}}
    @media (max-width: 767px) { .det-calculator .result-value{font-size:1.5rem}.result-action-btn{width:1.9rem;height:1.9rem} }
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
        <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
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
      <p>Teacher/student friendly determinant solver: enter fractions like <code>1/2</code>, choose method, and get readable step-by-step reasoning. <strong>100% client-side</strong> with support for 2×2 to 10×10.</p>
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
          <div class="compact-input-row">
            <input id="matrixSize" type="number" min="2" max="10" class="tool-input" value="3" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);flex:1;font-size:0.875rem">
            <button type="button" id="btnRandom" class="tool-btn-outline" style="flex-shrink:0" title="Generate random matrix">Random</button>
            <button type="button" id="btnApplySize" class="tool-btn-outline" style="flex-shrink:0" title="Apply size to grid">Apply</button>
          </div>
          <span class="tool-form-hint">Supports 2×2 up to 10×10 square matrices</span>
        </div>
        <div class="tool-form-group">
          <label class="tool-form-label" for="matrixInput">Matrix Entries</label>
          <div class="matrix-editor-toggle">
            <button type="button" class="matrix-toggle-btn is-active" id="btnTextMode">Text Paste</button>
            <button type="button" class="matrix-toggle-btn" id="btnGridMode">Grid View</button>
            <button type="button" class="matrix-toggle-btn" id="btnDetectSize">Detect Size from Input</button>
          </div>
          <div id="textEditorPanel" class="matrix-editor-panel is-active">
            <textarea id="matrixInput" class="tool-input" rows="6" placeholder="Enter matrix entries:
1 2 3
4 5 6
7 8 9" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-family:var(--font-mono,'monospace');font-size:0.875rem;resize:vertical"></textarea>
          </div>
          <div id="gridEditorPanel" class="matrix-editor-panel">
            <div class="matrix-grid-wrap" id="matrixGridWrap">
              <div id="matrixGrid"></div>
            </div>
            <div class="compact-actions" style="margin-top:0.4rem">
              <button type="button" id="btnSyncGridToText" class="tool-btn-outline">Sync Grid → Text</button>
              <button type="button" id="btnSyncTextToGrid" class="tool-btn-outline">Sync Text → Grid</button>
            </div>
          </div>
          <div class="compact-help">Text mode supports paste. Grid mode is compact for quick edits. Fractions like <code>-7/11</code> are supported.</div>
        </div>
        <div class="tool-form-group">
          <label class="tool-form-label" for="methodSelect">Computation Method</label>
          <select id="methodSelect" class="tool-input" style="padding:0.5rem 0.75rem;border-radius:0.5rem;border:1.5px solid var(--border);background:var(--bg-primary);width:100%;font-size:0.875rem">
            <option value="lu">LU Decomposition (recommended)</option>
            <option value="cofactor">Cofactor Expansion (teaching)</option>
            <option value="gaussian">Gaussian Elimination (row operations)</option>
          </select>
        </div>
        <div class="teacher-instructions" style="margin-top:0.45rem">
          <strong>Classroom tip:</strong> For triangular matrices, determinant is product of diagonal entries.
          Use Cofactor mode for small matrices to see formula expansion.
        </div>
        <div class="tool-form-group" style="margin-top:0.65rem;margin-bottom:0.55rem">
          <label class="tool-form-label" style="margin-bottom:0.35rem">Quick Presets</label>
          <div class="matrix-example-grid">
            <button type="button" class="matrix-example-btn" data-preset="identity">Identity 3×3</button>
            <button type="button" class="matrix-example-btn" data-preset="diagonal">Diagonal</button>
            <button type="button" class="matrix-example-btn" data-preset="triangular">Triangular</button>
            <button type="button" class="matrix-example-btn" data-preset="random">Random</button>
          </div>
        </div>
        <div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.5rem">
          <button type="button" id="btnCalculate" class="tool-action-btn" style="padding:0.5rem 1rem;margin-top:0">Calculate Determinant</button>
          <button type="button" id="btnClear" class="tool-btn-outline" style="margin-top:0">Clear</button>
        </div>
        <div id="inputError" class="tool-form-hint" style="color:var(--error,#ef4444);display:none;margin-top:0.5rem"></div>
      </div>
    </div>
  </div>

  <div class="tool-output-column">
    <div class="tool-card matrix-calc det-calculator">
      <div class="tool-card-header" style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:0.5rem">
        <span>Result</span>
        <div class="result-actions" aria-label="Result actions">
          <button type="button" id="btnShareURL" class="tool-btn-outline result-action-btn" title="Copy share URL" aria-label="Copy share URL">🔗<span class="sr-only">Copy share URL</span></button>
          <button type="button" id="btnDownloadImage" class="tool-btn-outline result-action-btn" title="Download result image" aria-label="Download result image">⬇️<span class="sr-only">Download result image</span></button>
          <button type="button" id="btnPrintWorksheet" class="tool-btn-outline tool-btn-print result-action-btn" title="Print worksheet" aria-label="Print worksheet">🖨️<span class="sr-only">Print worksheet</span></button>
        </div>
      </div>
      <div class="tool-card-body">
        <div id="resultArea" style="color:var(--text-muted);padding:0.2rem">Enter a square matrix and click "Calculate Determinant" to see a teacher-style solution card.</div>
      </div>
    </div>

    <div class="tool-card matrix-calc det-calculator">
      <div class="tool-card-header">Step-by-Step Solution</div>
      <div class="tool-card-body">
        <div id="stepsArea" style="color:var(--text-muted)">Unified lesson playback appears here after calculation.</div>
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
  <!-- Exam-Style Practice -->
  <div class="tool-card" style="margin-bottom:1.5rem;padding:0;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-secondary)">
    <div style="padding:1.25rem 1.5rem;border-bottom:1px solid var(--border)"><h3 style="margin:0;font-size:1.15rem;color:var(--text-primary)">Exam-Style Practice</h3></div>
    <div style="padding:1.5rem" id="practiceSection"></div>
  </div>

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
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What does det(A) = 0 mean?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">det(A) = 0 indicates the matrix is singular: rows/columns are linearly dependent, rank is less than n, and A is not invertible.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0.75rem;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">Can I practice with exam-style determinant questions?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Yes. The Exam-Style Practice section generates problems at Easy (2×2), Medium (3×3), or Hard (4×4 and singularity checks) with instant scoring and answer reveal.</p>
  </div>
  <div class="tool-card" style="margin-bottom:0;padding:1.25rem">
    <h3 style="font-size:1rem;margin:0 0 0.5rem;color:var(--text-primary)">What are useful properties of determinants?</h3>
    <p style="margin:0;font-size:0.9rem;color:var(--text-secondary);line-height:1.6">Key properties: det(AB) = det(A)det(B), det(A^T) = det(A), det(cA) = c^n det(A) for n×n, swapping rows flips the sign, and a row of zeros makes det = 0.</p>
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
  const btnApplySize = document.getElementById('btnApplySize');
  const btnTextMode = document.getElementById('btnTextMode');
  const btnGridMode = document.getElementById('btnGridMode');
  const btnDetectSize = document.getElementById('btnDetectSize');
  const btnSyncGridToText = document.getElementById('btnSyncGridToText');
  const btnSyncTextToGrid = document.getElementById('btnSyncTextToGrid');
  const textEditorPanel = document.getElementById('textEditorPanel');
  const gridEditorPanel = document.getElementById('gridEditorPanel');
  const matrixGrid = document.getElementById('matrixGrid');
  const resultArea = document.getElementById('resultArea');
  const stepsArea = document.getElementById('stepsArea');
  const inputError = document.getElementById('inputError');
  const presetButtons = document.querySelectorAll('[data-preset]');

  const EPS = MatrixUtils.EPS;
  const parseMatrix = (text, n) => MatrixUtils.parseMatrix(text, n, n);
  const parseNumericToken = MatrixUtils.parseNumericToken;
  const cloneMatrix = MatrixUtils.cloneMatrix;
  const smartFormat = MatrixUtils.smartFormat;
  const formatExactNumber = MatrixUtils.formatExactNumber;
  const createStepEngine = MatrixUtils.createStepEngine;
  const createMatrixAnimationEngine = MatrixUtils.createMatrixAnimationEngine;
  const renderMatrixAnimation = MatrixUtils.renderMatrixAnimation;
  const initMatrixAnimation = MatrixUtils.initMatrixAnimation;
  let editorMode = 'text';

  function detectMatrixShape(text) {
    const cleaned = String(text || '').trim();
    if (!cleaned) return null;
    const lines = cleaned.split('\n').map(row => row.trim()).filter(Boolean);
    if (!lines.length) return null;
    const counts = lines.map(line => line.split(/[\s,]+/).filter(Boolean).length);
    const cols = counts[0];
    const consistent = counts.every(c => c === cols);
    return { rows: lines.length, cols, consistent };
  }

  function inferAndApplySquareSizeFromText(showError = false) {
    const shape = detectMatrixShape(matrixInput.value);
    if (!shape) return null;
    if (!shape.consistent) {
      if (showError) throw new Error('Input rows have different number of entries.');
      return null;
    }
    if (shape.rows !== shape.cols) {
      if (showError) throw new Error(`Input is ${shape.rows}×${shape.cols}. Determinant requires a square matrix.`);
      return null;
    }
    if (shape.rows < 2 || shape.rows > 10) {
      if (showError) throw new Error('Input matrix size must be between 2 and 10.');
      return null;
    }
    matrixSize.value = String(shape.rows);
    return shape.rows;
  }

  function buildGridEditor(n, sourceText) {
    const size = Math.min(10, Math.max(2, parseInt(n, 10) || 3));
    const seed = [];
    if (sourceText) {
      const lines = sourceText.trim().split('\n').map(r => r.trim()).filter(Boolean);
      for (let i = 0; i < Math.min(size, lines.length); i++) {
        seed[i] = lines[i].split(/[\s,]+/).filter(Boolean);
      }
    }
    let html = '<table class="matrix-input-grid"><tbody>';
    for (let r = 0; r < size; r++) {
      html += '<tr>';
      for (let c = 0; c < size; c++) {
        const value = seed[r] && seed[r][c] ? seed[r][c] : (r === c ? '1' : '0');
        html += `<td><input type="text" data-grid-r="${r}" data-grid-c="${c}" value="${value}"></td>`;
      }
      html += '</tr>';
    }
    html += '</tbody></table>';
    matrixGrid.innerHTML = html;

    matrixGrid.querySelectorAll('input').forEach((input) => {
      input.addEventListener('input', () => {
        if (editorMode === 'grid') {
          matrixInput.value = readGridAsText();
        }
      });
    });
  }

  function readGridAsText() {
    const n = parseInt(matrixSize.value, 10) || 3;
    const rows = [];
    for (let r = 0; r < n; r++) {
      const row = [];
      for (let c = 0; c < n; c++) {
        const cell = matrixGrid.querySelector(`input[data-grid-r="${r}"][data-grid-c="${c}"]`);
        row.push((cell && cell.value.trim()) ? cell.value.trim() : '0');
      }
      rows.push(row.join(' '));
    }
    return rows.join('\n');
  }

  function setEditorMode(mode) {
    editorMode = mode;
    const textActive = mode === 'text';
    textEditorPanel.classList.toggle('is-active', textActive);
    gridEditorPanel.classList.toggle('is-active', !textActive);
    btnTextMode.classList.toggle('is-active', textActive);
    btnGridMode.classList.toggle('is-active', !textActive);
    if (!textActive) {
      buildGridEditor(matrixSize.value, matrixInput.value);
    }
  }

  function stepToPlainText(step) {
    const raw = [step && step.title, step && step.text, step && step.html].filter(Boolean).join(' ');
    return String(raw)
      .replace(/<div class="matrix-display"[\s\S]*?<\/div>/g, '')
      .replace(/<[^>]*>/g, ' ')
      .replace(/\s+/g, ' ')
      .trim();
  }

  function buildUnifiedFrames(stepData, animationFrames) {
    const steps = Array.isArray(stepData) ? stepData : [];
    const frames = Array.isArray(animationFrames) ? animationFrames : [];
    if (!frames.length) return [];
    if (!steps.length) return frames;

    const grouped = Array.from({ length: frames.length }, () => []);
    for (let i = 0; i < steps.length; i++) {
      const bucket = Math.min(frames.length - 1, Math.floor((i * frames.length) / steps.length));
      grouped[bucket].push(steps[i]);
    }

    return frames.map((frame, index) => {
      const plain = grouped[index].map(stepToPlainText).filter(Boolean);
      let lesson = '';
      if (plain.length > 0) {
        const shown = plain.slice(0, 3).join(' • ');
        const extra = plain.length > 3 ? ` • +${plain.length - 3} more` : '';
        lesson = `Lesson: ${shown}${extra}`;
      }
      const noteParts = [frame.note, lesson].filter(Boolean);
      return Object.assign({}, frame, { note: noteParts.join(' | ') });
    });
  }

  function toLatexToken(token) {
    const value = String(token || '').trim();
    const fracMatch = value.match(/^([+-]?(?:\d+\.?\d*|\.\d+)(?:e[+-]?\d+)?)\/([+-]?(?:\d+\.?\d*|\.\d+)(?:e[+-]?\d+)?)$/i);
    if (fracMatch) {
      return `\\frac{${fracMatch[1]}}{${fracMatch[2]}}`;
    }
    return value;
  }

  function parseMatrixTokens(text, n) {
    const lines = text.trim().split('\n').filter(r => r.trim());
    if (lines.length !== n) {
      throw new Error('Expected ' + n + ' rows, got ' + lines.length);
    }
    const matrixTokens = [];
    for (let i = 0; i < n; i++) {
      const entries = lines[i].trim().split(/[\s,]+/).filter(Boolean);
      if (entries.length !== n) {
        throw new Error('Row ' + (i + 1) + ': expected ' + n + ' entries, got ' + entries.length);
      }
      entries.forEach(token => parseNumericToken(token));
      matrixTokens.push(entries.map(toLatexToken));
    }
    return matrixTokens;
  }

  function formatTokenMatrix(tokenMat) {
    const rows = tokenMat.map(row => row.join(' & '));
    return '\\begin{bmatrix}' + rows.join(' \\\\ ') + '\\end{bmatrix}';
  }

  function getMethodPedagogy(method) {
    if (method === 'cofactor') return 'Expands along a row using minors and signs (+ − + ...).';
    if (method === 'gaussian') return 'Uses row operations until upper-triangular, then multiplies diagonal.';
    return 'Uses stable pivoting + elimination to compute determinant efficiently.';
  }

  function formatDeterminantValue(det) {
    if (Math.abs(det - Math.round(det)) < EPS) {
      return String(Math.round(det));
    }
    return det.toFixed(6);
  }

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
    const engine = createStepEngine();
    const animator = createMatrixAnimationEngine();
    engine.note('Goal', `Use LU-style elimination with pivoting on a ${n}×${n} matrix.`);
    engine.matrix('Initial Matrix', formatMatrix(A));
    animator.addFrame('Initial Matrix', A, 'Starting point.');
    for(let i = 0; i < n; i++) {
      let pivot = i;
      for(let r = i + 1; r < n; r++) {
        if(Math.abs(A[r][i]) > Math.abs(A[pivot][i])) pivot = r;
      }
      if(Math.abs(A[pivot][i]) < EPS) {
        engine.result('Zero Pivot', `Pivot at column ${i+1} is zero, so determinant is 0.`);
        return {det: 0, stepData: engine.all(), animationFrames: animator.all()};
      }
      if(pivot !== i) {
        [A[pivot], A[i]] = [A[i], A[pivot]];
        swaps++;
        engine.operation('Row Swap', `Swap R${i+1} and R${pivot+1} to bring larger pivot into position.`);
        engine.matrix('After Swap', formatMatrix(A, true));
        animator.addFrame(`Swap R${i+1} ↔ R${pivot+1}`, A, 'Pivot stabilization.', { type: 'swap', rows: [i, pivot] });
      }
      const pivotVal = A[i][i];
      det *= pivotVal;
      engine.operation('Pivot', `Pivot at row ${i+1} is ${formatExactNumber(pivotVal)}.`);
      const affectedRows = [];
      for(let r = i + 1; r < n; r++) {
        const factor = A[r][i] / pivotVal;
        if(Math.abs(factor) > EPS) {
          affectedRows.push(r);
        }
        for(let c = i; c < n; c++) A[r][c] -= factor * A[i][c];
      }
      const showInterval = n <= 4 ? 1 : Math.max(1, Math.floor(n/3));
      if(i < n - 1 && (n <= 4 || i % showInterval === 0)) {
        engine.operation('Elimination', `Eliminate entries below pivot in column ${i+1}.`);
        engine.matrix('Intermediate Upper Form', formatMatrix(A, true));
        animator.addFrame(`Eliminate Column ${i+1}`, A, 'Entries below pivot driven toward 0.', { type: 'eliminate', pivotRow: i, targetRows: affectedRows });
      }
    }
    engine.matrix('Upper Triangular Matrix', formatMatrix(A, true), 'Diagonal entries determine determinant.');
    det = swaps % 2 === 0 ? det : -det;
    engine.equation('Determinant Rule', `\\det(A) = ${swaps % 2 === 0 ? '+' : '-'}\\prod_{i=1}^{${n}} u_{ii}`,
      `Applying swap sign gives det(A) = ${det.toFixed(6)}.`);
    engine.result('Computed Determinant', `det(A) = ${det.toFixed(6)}`);
    animator.addFrame('Upper Triangular Form', A, `Diagonal product gives determinant ${det.toFixed(6)}.`);
    return {det, stepData: engine.all(), animationFrames: animator.all()};
  }

  function determinantCofactor(mat) {
    const n = mat.length;
    const engine = createStepEngine();
    const animator = createMatrixAnimationEngine();
    engine.note('Goal', 'Expand determinant along first row using cofactor signs (+ − + ...).');
    engine.matrix('Initial Matrix', formatMatrix(mat));
    animator.addFrame('Initial Matrix', mat, 'Cofactor expansion starts from row 1.');

    function computeCofactorRecursive(current, depth) {
      const size = current.length;
      if(size === 1) return current[0][0];
      if(size === 2) {
        return current[0][0] * current[1][1] - current[0][1] * current[1][0];
      }

      let detVal = 0;
      for(let j = 0; j < size; j++) {
        const sign = (j % 2 === 0) ? 1 : -1;
        const coeff = current[0][j];
        if(Math.abs(coeff) < EPS) continue;
        const minor = getMinor(current, 0, j);
        const minorDet = computeCofactorRecursive(minor, depth + 1);
        const term = sign * coeff * minorDet;
        detVal += term;
        if(depth <= 1) {
          engine.operation('Cofactor Term', `a₁${j+1} = ${formatExactNumber(coeff)}, sign = ${sign > 0 ? '+' : '-'}, minor determinant = ${formatExactNumber(minorDet)}.`);
          engine.equation('Term Contribution', `C_{1${j+1}} = ${sign > 0 ? '+' : '-'}(${formatExactNumber(coeff)})(${formatExactNumber(minorDet)}) = ${formatExactNumber(term)}`);
        }
      }
      return detVal;
    }

    const det = computeCofactorRecursive(mat, 0);
    engine.result('Computed Determinant', `det(A) = ${det.toFixed(6)}`);
    animator.addFrame('Cofactor Expansion Complete', mat, `Final determinant = ${det.toFixed(6)}.`);
    return {det, stepData: engine.all(), animationFrames: animator.all()};
  }

  function getMinor(mat, row, col) {
    return mat.filter((_, i) => i !== row).map(r => r.filter((_, j) => j !== col));
  }

  function determinantGaussian(mat) {
    const n = mat.length;
    const A = cloneMatrix(mat);
    let det = 1;
    const engine = createStepEngine();
    const animator = createMatrixAnimationEngine();
    engine.note('Goal', 'Use elementary row operations to reach upper-triangular form.');
    engine.matrix('Initial Matrix', formatMatrix(A));
    animator.addFrame('Initial Matrix', A, 'Starting point.');
    for(let i = 0; i < n; i++) {
      let pivot = i;
      for(let r = i + 1; r < n; r++) {
        if(Math.abs(A[r][i]) > Math.abs(A[pivot][i])) pivot = r;
      }
      if(Math.abs(A[pivot][i]) < EPS) {
        engine.result('Zero Pivot Column', `Column ${i+1} has no valid pivot, so determinant is 0.`);
        return {det: 0, stepData: engine.all(), animationFrames: animator.all()};
      }
      if(pivot !== i) {
        [A[pivot], A[i]] = [A[i], A[pivot]];
        det *= -1;
        engine.operation('Row Swap', `Swap R${i+1} and R${pivot+1}. This flips determinant sign.`);
        engine.matrix('After Swap', formatMatrix(A, true));
        animator.addFrame(`Swap R${i+1} ↔ R${pivot+1}`, A, 'Row swap flips determinant sign.', { type: 'swap', rows: [i, pivot] });
      }
      let rowOpsInStep = [];
      const rowOpsTargetRows = [];
      for(let r = i + 1; r < n; r++) {
        const factor = A[r][i] / A[i][i];
        if(Math.abs(factor) > EPS) {
          rowOpsInStep.push(`R${r+1} = R${r+1} - (${formatExactNumber(factor)})R${i+1}`);
          rowOpsTargetRows.push(r);
        }
        for(let c = i; c < n; c++) A[r][c] -= factor * A[i][c];
      }
      if(rowOpsInStep.length > 0) {
        engine.operation('Row Operations', rowOpsInStep.join(', '));
        engine.matrix('After Elimination', formatMatrix(A, true));
        animator.addFrame(`Eliminate Column ${i+1}`, A, rowOpsInStep.join(' | '), { type: 'eliminate', pivotRow: i, targetRows: rowOpsTargetRows });
      }
    }
    for(let i = 0; i < n; i++) det *= A[i][i];
    engine.matrix('Upper Triangular Matrix', formatMatrix(A, true));
    engine.equation('Determinant Rule', `\\det(A)=\\prod_{i=1}^{${n}} u_{ii}`, `Product of diagonal gives ${det.toFixed(6)}.`);
    engine.result('Computed Determinant', `det(A) = ${det.toFixed(6)}`);
    animator.addFrame('Upper Triangular Form', A, `Diagonal product gives determinant ${det.toFixed(6)}.`);
    return {det, stepData: engine.all(), animationFrames: animator.all()};
  }

  function calculate() {
    try {
      inputError.style.display = 'none';
      if (editorMode === 'grid') {
        matrixInput.value = readGridAsText();
      }

      let n = inferAndApplySquareSizeFromText(false) || parseInt(matrixSize.value, 10);
      if(n < 2 || n > 10) throw new Error('Matrix size must be between 2 and 10');

      const matrix = parseMatrix(matrixInput.value, n);
      const matrixTokens = parseMatrixTokens(matrixInput.value, n);
      const method = methodSelect.value;

      let result;
      if(method === 'lu') result = determinantLU(matrix);
      else if(method === 'cofactor') result = determinantCofactor(matrix);
      else result = determinantGaussian(matrix);

      const methodName = method === 'lu' ? 'LU Decomposition' : method === 'cofactor' ? 'Cofactor Expansion' : 'Gaussian Elimination';
      const detDisplay = formatDeterminantValue(result.det);
      const nature = Math.abs(result.det) < EPS ? 'Singular' : 'Non-Singular';
      const parity = Math.abs(result.det) < EPS ? 'N/A' : (result.det > 0 ? 'Positive determinant' : 'Negative determinant');
      const estComplexity = method === 'cofactor' ? 'Higher growth (best for small n)' : 'Efficient for medium/large n';

      resultArea.innerHTML = `
        <div class="teacher-answer-box" style="margin-bottom:0.75rem">
          <div class="teacher-answer-label">Final Answer</div>
          <div class="teacher-answer-value">det(A) = ${detDisplay}</div>
          <div style="font-size:0.82rem;color:#166534;margin-top:0.25rem">(decimal display: ${result.det.toFixed(6)})</div>
        </div>
        <div class="teacher-summary">
          <div class="teacher-summary-item"><span class="teacher-summary-label">Method</span><span class="teacher-summary-value">${methodName}</span></div>
          <div class="teacher-summary-item"><span class="teacher-summary-label">Matrix Type</span><span class="teacher-summary-value">${n}×${n} square</span></div>
          <div class="teacher-summary-item"><span class="teacher-summary-label">Classification</span><span class="teacher-summary-value">${nature}</span></div>
          <div class="teacher-summary-item"><span class="teacher-summary-label">Sign</span><span class="teacher-summary-value">${parity}</span></div>
          <div class="teacher-summary-item"><span class="teacher-summary-label">Complexity</span><span class="teacher-summary-value">${estComplexity}</span></div>
        </div>
        <div class="teacher-focus">
          <div class="teacher-card">
            <div class="teacher-card-title">Given Matrix</div>
            <div class="matrix-display teacher-equation">$$A = ${formatTokenMatrix(matrixTokens)}$$</div>
          </div>
          <div class="teacher-card">
            <div class="teacher-card-title">Method Insight</div>
            <div class="teacher-pedagogy">${getMethodPedagogy(method)}</div>
          </div>
        </div>
      `;

      const unifiedFrames = buildUnifiedFrames(result.stepData || [], result.animationFrames || []);
      const animationHtml = renderMatrixAnimation(unifiedFrames, { title: 'Unified Lesson Playback' });
      stepsArea.innerHTML = animationHtml || '<div style="color:var(--text-muted)">No playback frames available.</div>';
      initMatrixAnimation(stepsArea);

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
    matrixSize.value = '3';
    buildGridEditor(3, '');
    resultArea.innerHTML = '<div style="color:var(--text-muted);padding:0.2rem">Enter a square matrix and click "Calculate Determinant" to see a teacher-style solution card.</div>';
    stepsArea.innerHTML = '<div style="color:var(--text-muted)">Unified lesson playback appears here after calculation.</div>';
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
      matrixInput.value = MatrixUtils.generateRandomMatrixText(n, n, { minVal: -10, maxVal: 10, fractionProbability: 0.4 });
    }
    buildGridEditor(matrixSize.value, matrixInput.value);
    calculate();
  }

  function generateRandom() {
    const n = parseInt(matrixSize.value);
    if(n < 2 || n > 10) { alert('Please set matrix size between 2 and 10'); return; }
    matrixInput.value = MatrixUtils.generateRandomMatrixText(n, n, { minVal: -10, maxVal: 10, fractionProbability: 0.4 });
    buildGridEditor(matrixSize.value, matrixInput.value);
    setTimeout(() => calculate(), 100);
  }

  btnCalculate.addEventListener('click', calculate);
  btnClear.addEventListener('click', clear);
  btnRandom.addEventListener('click', generateRandom);
  btnApplySize.addEventListener('click', () => {
    const n = parseInt(matrixSize.value, 10);
    if (n < 2 || n > 10) {
      inputError.textContent = 'Matrix size must be between 2 and 10.';
      inputError.style.display = 'block';
      return;
    }
    buildGridEditor(n, matrixInput.value);
    if (editorMode === 'grid') {
      matrixInput.value = readGridAsText();
    }
    inputError.style.display = 'none';
  });
  btnTextMode.addEventListener('click', () => setEditorMode('text'));
  btnGridMode.addEventListener('click', () => setEditorMode('grid'));
  btnDetectSize.addEventListener('click', () => {
    try {
      const detected = inferAndApplySquareSizeFromText(true);
      if (detected) {
        buildGridEditor(detected, matrixInput.value);
        inputError.style.display = 'none';
      }
    } catch (err) {
      inputError.textContent = err.message;
      inputError.style.display = 'block';
    }
  });
  btnSyncGridToText.addEventListener('click', () => {
    matrixInput.value = readGridAsText();
    inputError.style.display = 'none';
  });
  btnSyncTextToGrid.addEventListener('click', () => {
    try {
      const detected = inferAndApplySquareSizeFromText(true) || parseInt(matrixSize.value, 10);
      buildGridEditor(detected, matrixInput.value);
      inputError.style.display = 'none';
    } catch (err) {
      inputError.textContent = err.message;
      inputError.style.display = 'block';
    }
  });
  presetButtons.forEach(btn => btn.addEventListener('click', () => loadPreset(btn.dataset.preset)));

  matrixSize.addEventListener('change', () => {
    const n = parseInt(matrixSize.value, 10);
    if (n >= 2 && n <= 10) {
      buildGridEditor(n, matrixInput.value);
      if (editorMode === 'grid') {
        matrixInput.value = readGridAsText();
      }
    }
  });

  matrixInput.addEventListener('keydown', e => {
    if(e.key === 'Enter' && (e.metaKey || e.ctrlKey)) calculate();
  });

  matrixInput.addEventListener('blur', () => {
    const detected = inferAndApplySquareSizeFromText(false);
    if (detected) {
      buildGridEditor(detected, matrixInput.value);
    }
  });

  MatrixUtils.shareURL(document.getElementById('btnShareURL'), function() {
    const matrixText = matrixInput.value.trim();
    if(!matrixText) { alert('Please enter a matrix first!'); return null; }
    return { size: matrixSize.value, matrix: btoa(encodeURIComponent(matrixText)), method: methodSelect.value };
  });

  MatrixUtils.downloadImage(document.getElementById('btnDownloadImage'), 'matrix-determinant', 'No result to download. Please calculate a determinant first.');
  MatrixUtils.printWorksheet(document.getElementById('btnPrintWorksheet'), 'Matrix Determinant', { exerciseType: 'determinant' });
  var _stepsEl = document.getElementById('stepsArea'); if(_stepsEl) MatrixUtils.makeStepsCollapsible(_stepsEl.closest('.tool-card'));

  const loaded = MatrixUtils.loadFromURL(function(p) {
    if(p.matrix && p.size) {
      matrixSize.value = p.size;
      matrixInput.value = p.matrix;
      if(p.method) methodSelect.value = p.method;
      buildGridEditor(matrixSize.value, matrixInput.value);
      setTimeout(() => calculate(), 100);
      return true;
    }
    return false;
  });
  if(!loaded) {
    loadPreset('identity');
  }
  setEditorMode('text');

  // Exam-style practice
  if (typeof ToolUtils !== 'undefined' && ToolUtils.PracticeSheet) {
    ToolUtils.PracticeSheet.init({
      containerId: 'practiceSection',
      title: 'Matrix Determinant Practice',
      toolColor: '#3b82f6',
      difficulties: [
        { id: 'easy', label: 'Easy', description: '2×2 matrices' },
        { id: 'medium', label: 'Medium', description: '3×3 matrices' },
        { id: 'hard', label: 'Hard', description: '4×4 and conceptual' }
      ],
      generateProblems: MatrixPractice.determinant
    });
  }
})();
</script>

<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
</body>
</html>
