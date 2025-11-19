<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Matrix Type Classifier Online – Free | 8gwifi.org</title>
  <meta name="description" content="Free online matrix type classifier. Paste any matrix and instantly detect if it is square, rectangular, diagonal, scalar, identity, symmetric, skew-symmetric, triangular, orthogonal, singular, or stochastic. Shows working steps with rank, determinant, trace and property explanations. Perfect for linear algebra, engineering, machine learning, and competitive exams.">
  <meta name="keywords" content="matrix type classifier, types of matrices, matrix identifier, symmetric matrix checker, diagonal matrix checker, scalar matrix, orthogonal matrix, singular matrix, stochastic matrix, linear algebra calculator, matrix rank, determinant calculator, matrix classification">
  <link rel="canonical" href="https://8gwifi.org/matrix-type-classifier.jsp">
  <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1">
  <meta name="author" content="8gwifi.org">
  <meta property="og:title" content="Matrix Type Classifier Online – Free | 8gwifi.org">
  <meta property="og:description" content="Paste any matrix to detect 15+ matrix types: square, diagonal, identity, symmetric, upper triangular, orthogonal, singular and more. Includes explanations and visualization.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/matrix-type-classifier.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/matrix-classifier.png">
  <meta property="og:site_name" content="8gwifi.org - Free Online Tools">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Matrix Type Classifier Online – Free | 8gwifi.org">
  <meta name="twitter:description" content="Detect dozens of matrix properties instantly. Includes proofs, rank/determinant and interactive visualization.">
  <meta name="twitter:image" content="https://8gwifi.org/images/matrix-classifier.png">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"SoftwareApplication",
    "name":"Matrix Type Classifier",
    "alternateName":"Matrix Property Identifier",
    "url":"https://8gwifi.org/matrix-type-classifier.jsp",
    "applicationCategory":"EducationalApplication",
    "applicationSubCategory":"Mathematics Tool",
    "operatingSystem":"Web Browser (All Platforms)",
    "browserRequirements":"Requires JavaScript. HTML5 Canvas Support.",
    "softwareVersion":"1.0",
    "description":"Interactive linear algebra calculator that classifies matrices in real time. Paste any matrix to detect if it is square, diagonal, scalar, identity, symmetric, skew-symmetric, orthogonal, triangular, singular, stochastic and more. Provides determinant, rank, trace, eigenvalue hints, visualization and step-by-step reasoning.",
    "featureList":[
      "Matrix dimension & entry validator",
      "Automatic detection of 15+ matrix classes",
      "Determinant, rank & trace computation",
      "Orthogonality & stochastic checks",
      "Matrix heatmap & diagonal highlighting",
      "Preset library (identity, symmetric, orthogonal, singular, stochastic)",
      "Step-by-step proof style explanations",
      "Export & copy results"
    ],
    "offers":{
      "@type":"Offer",
      "price":"0",
      "priceCurrency":"USD",
      "availability":"https://schema.org/InStock",
      "priceValidUntil":"2099-12-31"
    },
    "provider":{
      "@type":"Organization",
      "name":"8gwifi.org",
      "url":"https://8gwifi.org"
    },
    "inLanguage":"en-US",
    "isAccessibleForFree":true,
    "audience":{
      "@type":"EducationalAudience",
      "educationalRole":"Student, Teacher, Engineer, Data Scientist"
    },
    "learningResourceType":"Interactive Calculator",
    "interactivityType":"active",
    "teaches":["Matrix Classification","Linear Algebra","Symmetric Matrices","Orthogonal Matrices","Determinant","Rank"],
    "keywords":"matrix type classifier, matrix type checker, linear algebra calculator, symmetric matrix detector"
  }
  </script>
  <script>
    window.MathJax = {
      loader: { load: ['[tex]/color'] },
      tex: {
        packages: { '[+]': ['color'] },
        inlineMath: [['$', '$'], ['\\(', '\\)']],
        displayMath: [['$$', '$$'], ['\\[', '\\]']]
      },
      startup: {
        ready: () => {
          MathJax.startup.defaultReady();
          console.log('MathJax loaded and ready');
          if(window.__pendingMath && window.__pendingMath.length){
            MathJax.typesetPromise(window.__pendingMath).finally(() => { window.__pendingMath = []; });
          }
        }
      }
    };
  </script>
  <script src="https://d3js.org/d3.v7.min.js"  crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"  crossorigin="anonymous"></script>
  <style>
    .matrix-classifier .card-header{padding:.6rem .9rem;font-weight:600}
    .matrix-classifier .card-body{padding:.7rem .9rem}
    .matrix-classifier .form-group{margin-bottom:.55rem}
    #matrixCanvas{width:100%;min-height:320px;border:1px solid #e5e7eb;border-radius:6px;background:#f8fafc}
    .badge-type{display:inline-flex;align-items:center;padding:0.3rem 0.6rem;border-radius:999px;font-size:0.85rem;margin:0.15rem 0.25rem;font-weight:500}
    .badge-core{background:#dbeafe;color:#1d4ed8}
    .badge-structure{background:#dcfce7;color:#166534}
    .badge-warning{background:#fee2e2;color:#b91c1c}
    .badge-neutral{background:#e2e8f0;color:#1e293b}
    .matrix-grid{display:inline-block;border-collapse:collapse;margin-top:0.5rem}
    .matrix-grid td{padding:0.35rem 0.6rem;border:1px solid #cbd5e1;font-family:monospace;font-size:0.95rem;min-width:48px;text-align:center}
    .matrix-grid .diag{background:#fef3c7}
    .matrix-grid .offdiag{background:#f8fafc}
    .matrix-grid .highlight{background:#fecdd3;color:#7f1d1d}
    .matrix-grid .zero{color:#94a3b8}
    .classification-card{border-left:4px solid #3b82f6;background:#eff6ff;border-radius:4px;padding:0.6rem;margin-bottom:0.6rem}
    .explain-step{border-left:3px solid #6366f1;padding-left:0.6rem;margin-bottom:0.5rem}
    .preset-btn{margin:0.2rem 0.3rem}
    .matrix-meta{font-family:monospace;font-size:0.95rem;color:#334155}
    .matrix-svg-wrapper{
      position:relative;
      overflow:visible;
      background:linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
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
    .matrix-legend-label{font-size:0.75rem;fill:#475569;font-weight:500}
    .matrix-cell-value{
      font-family:'SF Mono','Monaco','Fira Code',monospace;
      font-size:0.8rem;
      fill:#0f172a;
      font-weight:600;
      transition:all 0.2s ease;
    }
    .matrix-axis-label{
      font-size:0.8rem;
      fill:#475569;
      font-weight:600;
      text-transform:uppercase;
      letter-spacing:0.05em;
    }
    .matrix-axis-tick{font-size:0.7rem;fill:#64748b}
    .matrix-diagonal-outline{
      stroke:#f59e0b;
      stroke-width:2.5;
      stroke-dasharray:8 4;
      fill:none;
      pointer-events:none;
      filter:drop-shadow(0 0 3px rgba(245,158,11,0.4));
    }
    .matrix-zero-dot{fill:#cbd5e1;opacity:0.5}
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

    /* Mobile Responsive Styles */
    @media (max-width: 991px) {
      .matrix-classifier h1{font-size:1.75rem}
      .matrix-classifier .card{margin-bottom:1rem}
      .matrix-classifier .card-header{font-size:0.95rem;padding:0.5rem 0.75rem}
      .matrix-classifier .card-body{padding:0.75rem}

      /* Make buttons full-width on mobile */
      .matrix-classifier .btn-group{display:flex;flex-direction:column}
      .matrix-classifier .d-flex.flex-wrap button{flex:1 1 auto;margin:0.25rem 0}

      /* Adjust form inputs for better touch targets */
      .matrix-classifier input[type="number"],
      .matrix-classifier textarea,
      .matrix-classifier .form-control{font-size:16px;padding:0.5rem 0.75rem}

      /* Stack dimension inputs vertically on very small screens */
      .matrix-classifier .form-group .d-flex{flex-wrap:wrap}

      /* Make badges wrap better */
      .badge-type{font-size:0.8rem;padding:0.25rem 0.5rem;margin:0.1rem 0.15rem}

      /* Adjust matrix visualization wrapper */
      .matrix-svg-wrapper{padding:10px;border-radius:8px}

      /* Make tooltips larger and easier to read on mobile */
      .matrix-tooltip{font-size:0.9rem;padding:0.6rem 0.85rem;max-width:90vw;white-space:normal}

      /* Improve example section for mobile */
      #examplesContent .row{margin:0}
      #examplesContent .col-md-6{padding:0.5rem}
      #examplesContent h6{font-size:0.9rem}
      #examplesContent .text-muted{font-size:0.8rem}
    }

    @media (max-width: 767px) {
      .matrix-classifier h1{font-size:1.5rem;margin-bottom:0.5rem}
      .matrix-classifier .text-muted{font-size:0.9rem}

      /* Make action buttons stack vertically */
      #btnAnalyse,#btnRandom,#btnClear{width:100%;margin:0.25rem 0}

      /* Simplify header on mobile */
      .card-header.d-flex{flex-direction:column;align-items:flex-start!important}
      .card-header button{margin-top:0.5rem;width:100%}

      /* Better spacing for mobile */
      .matrix-classifier .form-group{margin-bottom:0.75rem}

      /* Optimize matrix meta display */
      .matrix-meta{font-size:0.85rem;line-height:1.6}

      /* Make classification cards more compact */
      .classification-card{padding:0.5rem;margin-bottom:0.5rem}
      .explain-step{padding-left:0.5rem;margin-bottom:0.4rem;font-size:0.9rem}

      /* Better example section for small mobile */
      #examplesContent{max-height:400px}
      #examplesContent .col-md-6{padding:0.25rem;margin-bottom:0.75rem}

      /* Reduce padding in related tools section */
      .card-body.small{font-size:0.85rem}
      .card-body.small .btn-sm{font-size:0.75rem;padding:0.25rem 0.5rem}
    }

    @media (max-width: 575px) {
      /* Extra small devices - further optimize */
      .container{padding-left:10px;padding-right:10px}
      .matrix-classifier h1{font-size:1.3rem}

      /* Make preset dropdown full width */
      .dropdown-menu{min-width:100%;left:0!important}

      /* Compact grid editor for tiny screens */
      #gridContainer input{font-size:14px;padding:0.25rem}

      /* Make sure LaTeX doesn't overflow */
      .matrix-classifier .MathJax{font-size:0.9em!important;max-width:100%}

      /* Optimize quick tips section */
      .card-body ul{padding-left:1.25rem;font-size:0.85rem}
      .card-body ul li{margin-bottom:0.25rem}
    }

    /* Touch-specific improvements */
    @media (hover: none) and (pointer: coarse) {
      /* Increase touch targets */
      .matrix-classifier button,
      .matrix-classifier .btn{min-height:44px;padding:0.5rem 1rem}

      /* Make dropdowns easier to tap */
      .dropdown-item{padding:0.75rem 1rem;font-size:1rem}

      /* Disable hover effects on touch devices */
      .matrix-cell:hover{filter:drop-shadow(0 1px 2px rgba(0,0,0,0.05))}

      /* Make tooltips tap-friendly */
      .matrix-tooltip{pointer-events:auto}
    }

    /* Landscape mobile optimization */
    @media (max-width: 991px) and (orientation: landscape) {
      .matrix-classifier{padding-top:1rem}
      #examplesContent{max-height:300px}
      .card-body{padding:0.5rem}
    }

    /* Print styles */
    @media print {
      .matrix-classifier .btn,
      .matrix-classifier button,
      .sharethis-inline-share-buttons{display:none}
      .matrix-classifier .card{border:1px solid #ddd;box-shadow:none}
      .matrix-classifier{padding:0}
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>
    <%@ include file="math-menu-nav.jsp"%>
<div class="container mt-4 matrix-classifier">
  <h1 class="mb-2">Matrix Type Classifier</h1>
  <p class="text-muted mb-3">Paste any matrix to instantly detect its properties: square, diagonal, identity, symmetric, triangular, orthogonal, singular, stochastic and more.</p>

  <div class="row">
    <div class="col-lg-4 col-md-12 order-lg-1 order-2">
      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">
          Matrix Input
          <button id="btnPresetMenu" class="btn btn-outline-secondary btn-sm dropdown-toggle" data-toggle="dropdown">Presets</button>
          <div class="dropdown-menu" aria-labelledby="btnPresetMenu">
            <h6 class="dropdown-header">Square</h6>
            <a class="dropdown-item" href="#" data-preset="identity3">Identity (3×3)</a>
            <a class="dropdown-item" href="#" data-preset="symmetric3">Symmetric (3×3)</a>
            <a class="dropdown-item" href="#" data-preset="orthogonal3">Orthogonal (3×3)</a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Triangular</h6>
            <a class="dropdown-item" href="#" data-preset="upper4">Upper Triangular (4×4)</a>
            <a class="dropdown-item" href="#" data-preset="lower4">Lower Triangular (4×4)</a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Special</h6>
            <a class="dropdown-item" href="#" data-preset="singular3">Singular (rank deficient)</a>
            <a class="dropdown-item" href="#" data-preset="stochastic3">Column-Stochastic</a>
            <a class="dropdown-item" href="#" data-preset="rectangular23">Rectangular (2×3)</a>
          </div>
        </h5>
        <div class="card-body">
          <div class="form-group">
            <label for="rowCount">Dimensions</label>
            <div class="d-flex">
              <input id="rowCount" type="number" min="1" max="10" class="form-control mr-2" value="3">
              <span class="align-self-center">×</span>
              <input id="colCount" type="number" min="1" max="10" class="form-control ml-2" value="3">
            </div>
            <small class="text-muted">Supports up to 10×10 matrices. Use commas or spaces between entries, newline per row.</small>
          </div>

          <div class="form-group">
            <label for="matrixInput">Matrix Entries</label>
            <textarea id="matrixInput" class="form-control" rows="6" placeholder="Example (3×3):
1 0 0
0 1 0
0 0 1"></textarea>
            <small class="text-muted">Accepted delimiters: space, comma, semicolon. For complex numbers use a+bi format.</small>
          </div>
          <div id="matrixTelemetry" class="small text-muted mb-2"></div>

          <button id="btnGridEditor" type="button" class="btn btn-outline-info btn-sm mb-3"><i class="fas fa-table"></i> Open Grid Editor</button>
          <div id="gridEditor" class="mb-3" style="display:none">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-2">
              <strong class="mb-2 mb-md-0">Cell Editor</strong>
              <div class="d-flex flex-wrap">
                <button id="btnGridAddRow" type="button" class="btn btn-outline-secondary btn-sm mr-1 mb-1">+ Row</button>
                <button id="btnGridAddCol" type="button" class="btn btn-outline-secondary btn-sm mr-1 mb-1">+ Column</button>
                <button id="btnGridSync" type="button" class="btn btn-primary btn-sm mb-1">Apply to Text</button>
              </div>
            </div>
            <div id="gridContainer" class="table-responsive"></div>
          </div>

          <div class="form-group">
            <div class="custom-control custom-switch">
              <input type="checkbox" class="custom-control-input" id="allowComplex">
              <label class="custom-control-label" for="allowComplex">Allow complex entries (a + bi)</label>
            </div>
            <div class="custom-control custom-switch">
              <input type="checkbox" class="custom-control-input" id="showIntermediate" checked>
              <label class="custom-control-label" for="showIntermediate">Show intermediate calculations</label>
            </div>
          </div>

          <div class="d-flex flex-wrap">
            <button id="btnAnalyse" class="btn btn-primary btn-sm mr-2 mb-2">Classify Matrix</button>
            <button id="btnRandom" class="btn btn-outline-primary btn-sm mr-2 mb-2">Random Matrix</button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm mb-2">Clear</button>
          </div>
          <div id="inputError" class="text-danger small mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Detected Types</h5>
        <div class="card-body">
          <div id="typeBadges" class="mb-2"></div>
          <div id="matrixMeta" class="matrix-meta"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Quick Tips</h5>
        <div class="card-body small">
          <ul class="mb-0 pl-3">
            <li>Diagonal matrices have zero off-diagonal entries.</li>
            <li>Scalar matrix ⇒ diagonal with constant diagonal values.</li>
            <li>Orthogonal matrices satisfy AᵀA = I (columns are orthonormal).</li>
            <li>Singular matrices have determinant 0 and rank &lt; number of rows.</li>
            <li>Stochastic matrices have non-negative columns summing to 1.</li>
          </ul>
        </div>
      </div>
    </div>

    <div class="col-lg-8 col-md-12 order-lg-2 order-1">
      <div class="card mb-3">
        <h5 class="card-header d-flex flex-wrap justify-content-between align-items-center">
          <span class="mb-1 mb-sm-0">Matrix Visualization</span>
          <button id="btnCopyMatrix" class="btn btn-outline-primary btn-sm"><i class="fas fa-copy"></i> Copy Matrix</button>
        </h5>
        <div class="card-body">
          <div id="matrixVisual" class="text-center text-muted">Enter a matrix and click classify to view the visualization.</div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Classification Summary</h5>
        <div class="card-body">
          <div id="classificationSummary"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Step-by-Step Reasoning</h5>
        <div class="card-body small">
          <div id="stepsContent" style="line-height:1.8"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">About Matrix Types</h5>
        <div class="card-body small">
          <div><strong>Square vs Rectangular:</strong> A matrix with equal rows and columns is square (n×n), enabling determinant, inverse, eigenvalue and orthogonality checks. Rectangular matrices are either row (1×n) or column (m×1) matrices.</div>
          <div class="mt-2"><strong>Diagonal &amp; Scalar:</strong> A diagonal matrix has non-zero entries only on its main diagonal. A scalar matrix is diagonal with equal diagonal entries. The identity matrix is a scalar matrix with all ones on the diagonal.</div>
          <div class="mt-2"><strong>Symmetric &amp; Skew-Symmetric:</strong> A matrix is symmetric if A = Aᵀ. It is skew-symmetric if A = -Aᵀ (diagonal entries must be zero). Symmetric matrices have real eigenvalues and orthogonal eigenvectors.</div>
          <div class="mt-2"><strong>Orthogonal Matrices:</strong> A matrix A is orthogonal if AᵀA = AAᵀ = I. Columns (and rows) are orthonormal. Orthogonal matrices preserve lengths and angles, and their inverse equals their transpose.</div>
          <div class="mt-2"><strong>Singular vs Non-Singular:</strong> Determinant zero ⇒ singular (not invertible). Determinant non-zero ⇒ non-singular (invertible). Rank reveals number of independent rows/columns.</div>
          <div class="mt-2"><strong>Stochastic Matrices:</strong> In Markov chains, column-stochastic matrices have non-negative entries with each column summing to 1. They represent transition probabilities.</div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Math Tools</h5>
        <div class="card-body small">
          <div class="d-flex flex-wrap mb-2">
            <a href="matrix-determinant-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-square-root-alt"></i> Determinant Calculator
            </a>
            <a href="matrix-inverse-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">
              <i class="fas fa-sync"></i> Matrix Inverse
            </a>
            <a href="matrix-eigenvalue-calculator.jsp" class="btn btn-sm btn-outline-primary mb-2">
              <i class="fas fa-wave-square"></i> Eigenvalues &amp; Eigenvectors
            </a>
          </div>
          <div class="text-muted">
            Solve complementary linear algebra tasks: compute determinants &amp; inverses, or analyse eigenvalues to study stability and diagonalization.
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">
          Matrix Type Examples
          <button id="btnToggleExamples" class="btn btn-outline-secondary btn-sm">Hide Examples</button>
        </h5>
        <div id="examplesContent" class="card-body small" style="max-height:600px;overflow-y:auto">
          <div class="row">
            <div class="col-md-6 mb-3">
              <h6 class="font-weight-bold">Identity Matrix (I)</h6>
              <div class="mb-1">$$\begin{pmatrix} \textcolor{blue}{1} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{blue}{1} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{blue}{1} \end{pmatrix}$$</div>
              <div class="text-muted">Diagonal of ones, zeros elsewhere. Special case of diagonal, scalar, and symmetric matrices.</div>
            </div>
            <div class="col-md-6 mb-3">
              <h6 class="font-weight-bold">Zero Matrix (O)</h6>
              <div class="mb-1">$$\begin{pmatrix} \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{gray}{0} \end{pmatrix}$$</div>
              <div class="text-muted">All elements are zero. Singular matrix with determinant 0 and rank 0.</div>
            </div>
            <div class="col-md-6 mb-3">
              <h6 class="font-weight-bold">Diagonal Matrix</h6>
              <div class="mb-1">$$\begin{pmatrix} \textcolor{blue}{5} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{blue}{-3} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{blue}{2} \end{pmatrix}$$</div>
              <div class="text-muted">Non-zero entries only on main diagonal. Easy to compute powers and determinant.</div>
            </div>
            <div class="col-md-6 mb-3">
              <h6 class="font-weight-bold">Symmetric Matrix</h6>
              <div class="mb-1">$$\begin{pmatrix} \textcolor{blue}{4} & \textcolor{green}{1} & \textcolor{green}{2} \\ \textcolor{green}{1} & \textcolor{blue}{3} & \textcolor{gray}{0} \\ \textcolor{green}{2} & \textcolor{gray}{0} & \textcolor{blue}{5} \end{pmatrix}$$</div>
              <div class="text-muted">A = Aᵀ. Real eigenvalues, orthogonal eigenvectors. Common in physics and optimization.</div>
            </div>
            <div class="col-md-6 mb-3">
              <h6 class="font-weight-bold">Upper Triangular</h6>
              <div class="mb-1">$$\begin{pmatrix} \textcolor{blue}{2} & \textcolor{green}{4} & \textcolor{green}{1} \\ \textcolor{gray}{0} & \textcolor{blue}{3} & \textcolor{red}{-1} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{blue}{5} \end{pmatrix}$$</div>
              <div class="text-muted">All entries below diagonal are zero. Determinant = product of diagonal entries.</div>
            </div>
            <div class="col-md-6 mb-3">
              <h6 class="font-weight-bold">Lower Triangular</h6>
              <div class="mb-1">$$\begin{pmatrix} \textcolor{blue}{3} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{red}{-1} & \textcolor{blue}{2} & \textcolor{gray}{0} \\ \textcolor{green}{4} & \textcolor{green}{5} & \textcolor{blue}{1} \end{pmatrix}$$</div>
              <div class="text-muted">All entries above diagonal are zero. Used in LU decomposition.</div>
            </div>
            <div class="col-md-6 mb-3">
              <h6 class="font-weight-bold">Orthogonal Matrix</h6>
              <div class="mb-1">$$\begin{pmatrix} \textcolor{gray}{0} & \textcolor{blue}{1} & \textcolor{gray}{0} \\ \textcolor{blue}{1} & \textcolor{gray}{0} & \textcolor{gray}{0} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{red}{-1} \end{pmatrix}$$</div>
              <div class="text-muted">AᵀA = I. Preserves lengths and angles. Represents rotations/reflections.</div>
            </div>
            <div class="col-md-6 mb-3">
              <h6 class="font-weight-bold">Singular Matrix</h6>
              <div class="mb-1">$$\begin{pmatrix} \textcolor{blue}{2} & \textcolor{green}{4} & \textcolor{green}{6} \\ \textcolor{blue}{1} & \textcolor{green}{2} & \textcolor{green}{3} \\ \textcolor{gray}{0} & \textcolor{gray}{0} & \textcolor{gray}{0} \end{pmatrix}$$</div>
              <div class="text-muted">det(A) = 0. Not invertible. Rows/columns are linearly dependent.</div>
            </div>
            <div class="col-md-6 mb-3">
              <h6 class="font-weight-bold">Column Stochastic</h6>
              <div class="mb-1">$$\begin{pmatrix} \textcolor{green}{0.5} & \textcolor{green}{0.2} & \textcolor{green}{0.3} \\ \textcolor{green}{0.3} & \textcolor{green}{0.5} & \textcolor{green}{0.3} \\ \textcolor{green}{0.2} & \textcolor{green}{0.3} & \textcolor{green}{0.4} \end{pmatrix}$$</div>
              <div class="text-muted">Non-negative entries, each column sums to 1. Used in Markov chains.</div>
            </div>
            <div class="col-md-6 mb-3">
              <h6 class="font-weight-bold">Rectangular Matrix</h6>
              <div class="mb-1">$$\begin{pmatrix} \textcolor{blue}{1} & \textcolor{green}{2} & \textcolor{green}{3} \\ \textcolor{green}{4} & \textcolor{blue}{5} & \textcolor{green}{6} \end{pmatrix}$$</div>
              <div class="text-muted">Rows ≠ columns. No determinant or eigenvalues, but has rank and singular values.</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

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
      html += `<div class="text-danger">Row lengths: ${lengths.join(' | ')} — fix highlighted rows.</div>`;
    }
    if(mismatchRows || mismatchCols){
      html += `<div class="mt-1"><button id="btnApplyDetected" type="button" class="btn btn-link btn-sm p-0">Use detected size (${rowCount}×${colCount})</button></div>`;
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
        matrixTelemetry.innerHTML = `<div class="text-success">Applied detected dimensions (${rowCount}×${colCount}).</div>`;
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
    matrixVisual.innerHTML = `<div class="text-danger small mb-2">Rows highlighted below have inconsistent entry counts.</div><pre class="bg-light p-2 rounded" style="max-height:200px;overflow:auto">${highlighted.join('\n')}</pre>`;
  }

  function clearHighlights(){
    matrixVisual.dataset.state = '';
    matrixVisual.innerHTML = '<div class="text-muted">Enter a matrix and click classify to view the visualization.</div>';
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
    matrixVisual.classList.remove('text-muted');
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
      latexWrapper.className = 'latex-matrix text-left';
      const label = document.createElement('div');
      label.className = 'text-muted small mb-1';
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
    latexDiv.className = 'mt-3 latex-matrix text-left';
    const latexLabel = document.createElement('div');
    latexLabel.className = 'text-muted small mb-1';
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
      typeBadges.innerHTML = '<span class="text-muted">No classifications found.</span>';
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
      stepsContent.innerHTML = '<div class="text-muted">Run the classifier to see step-by-step reasoning.</div>';
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
      gridContainer.innerHTML = '<div class="text-danger small">Cannot load editor: '+err.message+'</div>';
    }
  }

  function buildGridFromMatrix(matrix){
    currentGridMatrix = cloneMatrix(matrix);
    const rows = matrix.length;
    const cols = matrix[0].length;
    let html = '<table class="table table-bordered table-sm mb-0"><tbody>';
    for(let r=0;r<rows;r++){
      html += '<tr>';
      for(let c=0;c<cols;c++){
        const val = typeof matrix[r][c] === 'object' ? prettyValue(matrix[r][c],4) : matrix[r][c];
        html += `<td style="min-width:70px"><input type="text" class="form-control form-control-sm grid-cell" data-row="${r}" data-col="${c}" value="${val}"></td>`;
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
        matrixVisual.innerHTML = '<div class="text-danger">'+err.message+'</div>';
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
    matrixVisual.innerHTML = '<div class="text-muted">Enter a matrix and click classify to view the visualization.</div>';
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
    if(!textarea.value.trim()){
      return;
    }
    if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(textarea.value).then(function(){
        btnCopyMatrix.innerHTML = '<i class="fas fa-check"></i> Copied!';
        btnCopyMatrix.className = 'btn btn-success btn-sm';
        setTimeout(function(){
          btnCopyMatrix.innerHTML = '<i class="fas fa-copy"></i> Copy Matrix';
          btnCopyMatrix.className = 'btn btn-outline-primary btn-sm';
        }, 2000);
      });
    }
  }

  btnAnalyse.addEventListener('click', handleAnalyse);
  btnRandom.addEventListener('click', handleRandom);
  btnClear.addEventListener('click', handleClear);
  btnCopyMatrix.addEventListener('click', copyMatrix);
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
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- Visible FAQ section (must match JSON-LD below) -->
<section id="faq" class="mt-5">
  <h2 class="h5">Matrix Type Classifier: FAQ</h2>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">How do you identify the type of a matrix?</h3>
    <p class="mb-0">Check dimensions first (square vs rectangular). For square matrices, compare A to Aᵀ (symmetric if A = Aᵀ, skew‑symmetric if A = −Aᵀ), inspect diagonal entries (diagonal/scalar/identity), and compute determinant/rank for singularity and full‑rank checks. The tool automates these steps.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What matrix types does this detect?</h3>
    <p class="mb-0">Rectangular, square, row, column, zero, diagonal, scalar, identity, upper/lower triangular, symmetric, skew‑symmetric, orthogonal, singular/non‑singular, stochastic, and sparse; it also reports trace, determinant, rank and hints about definiteness.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">Why is my matrix flagged as singular?</h3>
    <p class="mb-0">A matrix is singular when det(A) = 0 or rows are linearly dependent. The tool uses tolerance‑aware elimination; very small determinants relative to entries are treated as singular.</p>
  </div></div>
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"How do you identify the type of a matrix?","acceptedAnswer":{"@type":"Answer","text":"Check dimensions first (square vs rectangular). For square matrices, compare A to Aᵀ (symmetric if A = Aᵀ, skew‑symmetric if A = −Aᵀ), inspect diagonal entries (diagonal/scalar/identity), and compute determinant/rank for singularity and full‑rank checks. The tool automates these steps."}},
    {"@type":"Question","name":"What matrix types does this detect?","acceptedAnswer":{"@type":"Answer","text":"Rectangular, square, row, column, zero, diagonal, scalar, identity, upper/lower triangular, symmetric, skew‑symmetric, orthogonal, singular/non‑singular, stochastic, and sparse; it also reports trace, determinant, rank and hints about definiteness."}},
    {"@type":"Question","name":"Why is my matrix flagged as singular?","acceptedAnswer":{"@type":"Answer","text":"A matrix is singular when det(A) = 0 or rows are linearly dependent. The tool uses tolerance‑aware elimination; very small determinants relative to entries are treated as singular."}}
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Matrix Type Classifier","item":"https://8gwifi.org/matrix-type-classifier.jsp"}
  ]
}
</script>
</div>
<%@ include file="body-close.jsp"%>
