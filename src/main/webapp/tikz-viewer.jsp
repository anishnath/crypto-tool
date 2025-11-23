<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TikZ Viewer & Editor Online – Free | 8gwifi.org</title>
  <meta name="description" content="Create and render TikZ diagrams online for free. Professional LaTeX TikZ editor with syntax highlighting, real-time preview, and export to PNG, SVG, PDF. Draw graphs, flowcharts, circuits, 3D diagrams instantly.">
  <meta name="keywords" content="TikZ viewer, TikZ editor online, LaTeX diagrams, TikZ pictures, tikzpicture editor, LaTeX graphics, online diagram tool, TikZ to PNG, TikZ to SVG, TikZ to PDF, flowchart maker, graph editor, circuit diagram tool, mathematical diagrams, geometry diagrams, free TikZ tool">
  <meta name="author" content="8gwifi.org">
  <link rel="canonical" href="https://8gwifi.org/tikz-viewer.jsp">

  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/tikz-viewer.jsp">
  <meta property="og:title" content="TikZ Viewer & Editor Online – Free | 8gwifi.org">
  <meta property="og:description" content="Create and render TikZ diagrams online for free. Professional LaTeX TikZ editor with syntax highlighting, real-time preview, and export to PNG, SVG, PDF. Draw graphs, flowcharts, circuits, 3D diagrams instantly.">
  <meta property="og:image" content="https://8gwifi.org/images/site/tikz-tool.png">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/tikz-viewer.jsp">
  <meta property="twitter:title" content="TikZ Viewer & Editor Online – Free | 8gwifi.org">
  <meta property="twitter:description" content="Create and render TikZ diagrams online for free. Professional LaTeX TikZ editor with syntax highlighting, real-time preview, and export to PNG, SVG, PDF. Draw graphs, flowcharts, circuits, 3D diagrams instantly.">
  <meta property="twitter:image" content="https://8gwifi.org/images/site/tikz-tool.png">

  <!-- JSON-LD Schema -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "TikZ Viewer & Editor",
    "applicationCategory": "DesignApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free online TikZ viewer and editor for creating LaTeX diagrams. Render TikZ pictures in browser with real-time preview, syntax highlighting, and export to PNG, SVG, PDF formats.",
    "url": "https://8gwifi.org/tikz-viewer.jsp",
    "author": {
      "@type": "Organization",
      "name": "8gwifi.org"
    },
    "featureList": [
      "Real-time TikZ rendering",
      "Syntax highlighting with CodeMirror",
      "26+ example templates (geometry, graphs, circuits, 3D)",
      "Export to PNG, SVG, PDF",
      "Custom TikZ library support",
      "Auto-render mode",
      "Zoom controls",
      "Share via URL",
      "Copy LaTeX code to clipboard"
    ],
    "screenshot": "https://8gwifi.org/images/site/tikz-tool.png",
    "softwareVersion": "2.0"
  }
  </script>

  <!-- Bootstrap for layout (open-source) -->
<%--  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>

  <!-- CodeMirror for syntax highlighting -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/codemirror.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/theme/monokai.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/addon/hint/show-hint.min.css">

  <style>
    body { background: #f7f7fb; }
    .app-header { background: #fff; border-bottom: 1px solid #e9ecef; }
    .card-header {
      background: #fff !important;
      color: inherit !important;
      font-weight: 500;
    }
    .editor {
      height: 45vh;
      resize: vertical;
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
    }
    .CodeMirror {
      height: 45vh;
      font-size: 14px;
      border: 1px solid #e9ecef;
      border-radius: .5rem;
      font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
    }
    .viewer {
      width: 100%;
      height: 60vh;
      background: #fff;
      border: 1px solid #e9ecef;
      border-radius: .5rem;
      transform-origin: center center;
      transition: transform 0.2s ease;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .error { color: #dc3545; font-size: .9rem; display: none; }
    .hint  { color: #6c757d; font-size: .9rem; }
    .loading-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(255,255,255,0.9);
      display: none;
      align-items: center;
      justify-content: center;
      z-index: 10;
      border-radius: .5rem;
    }
    .loading-overlay.show { display: flex; }
    .viewer-container { position: relative; }
    .zoom-controls {
      position: absolute;
      bottom: 1rem;
      right: 1rem;
      display: flex;
      gap: 0.5rem;
      z-index: 5;
      background: white;
      padding: 0.5rem;
      border-radius: .5rem;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    .zoom-controls button {
      width: 32px;
      height: 32px;
      padding: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
    }
    .zoom-level {
      display: flex;
      align-items: center;
      padding: 0 0.5rem;
      font-size: 0.85rem;
      color: #666;
      min-width: 50px;
      justify-content: center;
    }
    .examples-dropdown {
      max-height: 450px;
      overflow-y: auto;
      box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    }
    .example-item { cursor: pointer; padding: 8px 12px; border-bottom: 1px solid #f0f0f0; }
    .example-item:hover { background: #f8f9fa; }
    .example-category { font-weight: bold; padding: 8px 12px; background: #e9ecef; font-size: 0.85rem; text-transform: uppercase; }
    .preamble-section { margin-top: 1rem; }
    .share-controls { gap: 0.5rem; }
    .auto-render-toggle { font-size: 0.85rem; }
  </style>
    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>
  <header class="app-header py-3">
    <div class="container">
      <h1 class="h4 mb-0">Free Online TikZ Viewer & Editor</h1>
      <p class="text-muted mb-0">Create LaTeX TikZ diagrams instantly. Render, edit, and export to PNG/SVG/PDF - No installation required!</p>
    </div>
  </header>

  <main class="container my-4">
    <div class="row g-3">
      <div class="col-lg-6">
        <div class="card">
          <div class="card-header bg-white d-flex justify-content-between align-items-center flex-wrap">
            <span>Input</span>
            <div class="d-flex align-items-center gap-2 flex-wrap">
              <label class="form-check-label auto-render-toggle">
                <input type="checkbox" id="auto-render" class="form-check-input"> Auto-render
              </label>
              <div class="btn-group btn-group-sm" role="group">
                <button id="btn-render" class="btn btn-primary">Render</button>
                <button id="btn-clear" class="btn btn-outline-secondary">Clear</button>
                <button id="btn-copy-latex" class="btn btn-outline-success" title="Copy LaTeX to clipboard">
                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/>
                    <path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/>
                  </svg>
                </button>
                <div class="btn-group btn-group-sm" role="group">
                  <button class="btn btn-outline-info dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    Examples
                  </button>
                  <ul class="dropdown-menu examples-dropdown" id="examples-menu">
                    <!-- Populated by JS -->
                  </ul>
                </div>
              </div>
            </div>
          </div>
          <div class="card-body">
            <textarea id="tikzInput" class="form-control editor" spellcheck="false" placeholder="Enter a tikzpicture...">
\begin{tikzpicture}[scale=0.8]
  \draw[step=1cm,gray!30,very thin] (-3,-2) grid (5,5);
  \draw[->] (-3,0) -- (5,0) node[right] {$x$};
  \draw[->] (0,-2) -- (0,5) node[above] {$y$};
  \draw[thick,blue] (-2,-1) -- (4,4);
  \fill[red] (2,3) circle (2pt) node[above right] {$P(2,3)$};
\end{tikzpicture}</textarea>
            <div id="errorMessage" class="error"></div>
            <div class="preamble-section">
              <label for="preambleInput" class="form-label">
                <small><strong>Custom Preamble</strong> - Add TikZ Libraries & Custom Styles
                  <button type="button" class="btn btn-link btn-sm p-0 ms-1" data-bs-toggle="collapse" data-bs-target="#preambleHelp" style="text-decoration: none;">ℹ️</button>
                </small>
              </label>
              <div class="collapse mb-2" id="preambleHelp">
                <div class="alert alert-info py-2 px-3 small">
                  <strong>What is Custom Preamble?</strong><br>
                  Add LaTeX commands that load TikZ libraries or define custom styles before your diagram.<br><br>
                  <strong>Examples:</strong><br>
                  • <code>\usetikzlibrary{arrows,shapes,positioning}</code> - Load arrow and shape libraries<br>
                  • <code>\usetikzlibrary{circuits.ee.IEC}</code> - Load circuit symbols<br>
                  • <code>\usetikzlibrary{3d,shadows,patterns}</code> - 3D, shadows, and pattern fills<br>
                  • <code>\tikzset{mystyle/.style={draw=blue,thick}}</code> - Define custom styles
                </div>
              </div>
              <textarea id="preambleInput" class="form-control" rows="2" placeholder="e.g. \usetikzlibrary{arrows,shapes,positioning}"></textarea>
            </div>
            <div class="hint mt-2"><strong>💡 Tip:</strong> Do not include <code>\documentclass</code> or <code>\begin{document}</code>. TikZJax provides the preamble.</div>
          </div>
        </div>
      </div>

      <div class="col-lg-6">
        <div class="card">
          <div class="card-header bg-white d-flex justify-content-between align-items-center flex-wrap">
            <span>Rendered Output</span>
            <div class="d-flex share-controls flex-wrap">
              <div class="btn-group btn-group-sm me-2" role="group">
                <button id="btn-png" class="btn btn-outline-primary">PNG</button>
                <button id="btn-svg" class="btn btn-outline-secondary">SVG</button>
                <button id="btn-pdf" class="btn btn-outline-danger">PDF</button>
              </div>
              <button id="btn-share" class="btn btn-outline-info btn-sm">Share URL</button>
            </div>
          </div>
          <div class="card-body viewer-container">
            <div class="loading-overlay" id="loading-overlay">
              <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Rendering...</span>
              </div>
            </div>
            <iframe id="viewer" class="viewer" title="TikZ Render"></iframe>
            <div class="zoom-controls">
              <button id="btn-zoom-out" class="btn btn-sm btn-outline-secondary" title="Zoom Out">-</button>
              <span class="zoom-level" id="zoom-level">100%</span>
              <button id="btn-zoom-in" class="btn btn-sm btn-outline-secondary" title="Zoom In">+</button>
              <button id="btn-zoom-reset" class="btn btn-sm btn-outline-secondary" title="Reset Zoom">⟲</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- SEO Content Section -->
    <section class="container my-5">
      <div class="row">
        <div class="col-lg-12">
          <div class="card">
            <div class="card-body">
              <h2 class="h5 mb-3">About TikZ Viewer - Online LaTeX Diagram Editor</h2>
              <p>Create stunning LaTeX TikZ diagrams directly in your browser with our free online TikZ viewer and editor. No LaTeX installation required! Whether you're a student, researcher, or educator, this tool makes it easy to design mathematical diagrams, flowcharts, graphs, circuits, and geometric figures.</p>

              <h3 class="h6 mt-4 mb-2">Key Features:</h3>
              <ul>
                <li><strong>Real-Time Rendering:</strong> See your TikZ diagrams instantly as you type with auto-render mode</li>
                <li><strong>Syntax Highlighting:</strong> Professional code editor with LaTeX/TikZ syntax highlighting powered by CodeMirror</li>
                <li><strong>26+ Example Templates:</strong> Start quickly with pre-built examples including geometry, graphs, flowcharts, circuits, 3D diagrams, and animations</li>
                <li><strong>Multiple Export Formats:</strong> Download your diagrams as PNG (high resolution), SVG (vector), or PDF files</li>
                <li><strong>Custom TikZ Libraries:</strong> Load specialized TikZ libraries like arrows, shapes, circuits, 3D, patterns, and more</li>
                <li><strong>Share Your Work:</strong> Generate shareable URLs to collaborate with others or save your diagrams for later</li>
                <li><strong>Zoom Controls:</strong> Inspect your diagrams in detail with zoom functionality (50% to 300%)</li>
                <li><strong>Copy to Clipboard:</strong> Easily copy your LaTeX code for use in papers, presentations, or documents</li>
              </ul>

              <h3 class="h6 mt-4 mb-2">Popular Use Cases:</h3>
              <div class="row">
                <div class="col-md-6">
                  <ul>
                    <li>Mathematical diagrams and graphs</li>
                    <li>Flowcharts and algorithm visualization</li>
                    <li>Geometric figures and constructions</li>
                    <li>Network diagrams and trees</li>
                  </ul>
                </div>
                <div class="col-md-6">
                  <ul>
                    <li>Circuit diagrams (electrical & logic gates)</li>
                    <li>3D diagrams and projections</li>
                    <li>Vector illustrations and animations</li>
                    <li>Academic papers and presentations</li>
                  </ul>
                </div>
              </div>

              <h3 class="h6 mt-4 mb-2">How to Use:</h3>
              <ol>
                <li><strong>Enter TikZ Code:</strong> Type or paste your <code>\begin{tikzpicture}...\end{tikzpicture}</code> code in the editor</li>
                <li><strong>Add Libraries (Optional):</strong> Use the Custom Preamble section to load TikZ libraries like <code>\usetikzlibrary{arrows,shapes}</code></li>
                <li><strong>Render:</strong> Click the "Render" button or enable auto-render mode for real-time updates</li>
                <li><strong>Export:</strong> Download your diagram as PNG, SVG, or PDF in the format you need</li>
                <li><strong>Share:</strong> Use the "Share URL" button to generate a link to your diagram</li>
              </ol>

              <p class="mt-4"><strong>Why Choose Our TikZ Editor?</strong> Unlike desktop LaTeX editors that require full installation and setup, our online tool works instantly in any modern web browser. It's perfect for quick diagrams, learning TikZ syntax, or sharing visual concepts with colleagues. The tool is completely free, requires no registration, and processes everything locally in your browser for privacy and speed.</p>

              <p class="text-muted small mt-3"><strong>Keywords:</strong> TikZ viewer online, TikZ editor, LaTeX diagrams, tikzpicture renderer, online LaTeX tool, TikZ to PNG, TikZ to SVG, TikZ to PDF, flowchart maker, graph drawing tool, circuit diagram editor, mathematical visualization, geometry diagrams, free TikZ tool, LaTeX graphics editor, academic diagram tool</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  </main>

  <!-- CodeMirror Scripts -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/codemirror.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/mode/stex/stex.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/addon/edit/matchbrackets.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/addon/edit/closebrackets.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/addon/hint/show-hint.min.js"></script>

  <!-- jsPDF for PDF export -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="js/tikz-viewer.js"></script>

  <!-- E-E-A-T: Visible author/methodology/trust section -->
  <section class="container my-5">
    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">
            <h2 class="h5 mb-3">About This Tool & Methodology</h2>
            <p>This TikZ viewer uses client‑side rendering powered by TikZJax to interpret <code>tikzpicture</code> code securely in your browser. CodeMirror provides syntax highlighting and editing features. Exports are produced from the rendered SVG/Canvas to PNG, SVG, or PDF using browser APIs and jsPDF.</p>

            <div class="row mt-3">
              <div class="col-md-6">
                <h3 class="h6">Authorship & Review</h3>
                <ul>
                  <li><strong>Author:</strong> 8gwifi.org engineering team</li>
                  <li><strong>Reviewed by:</strong> Anish Nath (tools maintainer)</li>
                  <li><strong>Last updated:</strong> 2025-11-19</li>
                </ul>
              </div>
              <div class="col-md-6">
                <h3 class="h6">Trust & Privacy</h3>
                <ul>
                  <li>Rendering happens locally; diagrams are not uploaded to our servers.</li>
                  <li>Share URLs only encode your TikZ content; you can remove them to keep diagrams private.</li>
                  <li>Questions? Contact us via <a href="contactus.jsp">Contact</a>.</li>
                </ul>
              </div>
            </div>

            <h3 class="h6 mt-3">References</h3>
            <ul>
              <li><a href="https://tikz.dev/" rel="nofollow noopener" target="_blank">PGF/TikZ Manual</a></li>
              <li><a href="https://github.com/kisonecat/tikzjax" rel="nofollow noopener" target="_blank">TikZJax</a></li>
              <li><a href="https://codemirror.net/5/" rel="nofollow noopener" target="_blank">CodeMirror 5</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- E-E-A-T JSON-LD for WebPage with author/reviewer/publisher -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebPage",
    "name": "TikZ Viewer & Editor",
    "url": "https://8gwifi.org/tikz-viewer.jsp",
    "dateModified": "2025-11-19",
    "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
    "reviewedBy": {"@type": "Person", "name": "Anish Nath"},
    "publisher": {"@type": "Organization", "name": "8gwifi.org"}
  }
  </script>

  <!-- Breadcrumbs to reinforce page context -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"TikZ Viewer","item":"https://8gwifi.org/tikz-viewer.jsp"}
    ]
  }
  </script>
<div class="sharethis-inline-share-buttons" style="margin-top: 1rem;"></div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>

<%@ include file="body-close.jsp"%>
