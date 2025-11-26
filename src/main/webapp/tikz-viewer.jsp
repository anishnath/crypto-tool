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

    /* Modern Card Styles */
    .tikz-card {
      background: #fff;
      border: none;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      transition: box-shadow 0.3s ease;
      overflow: hidden;
    }
    .tikz-card:hover {
      box-shadow: 0 4px 16px rgba(0,0,0,0.12);
    }

    /* Card Header Redesign */
    .tikz-card-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 1rem 1.25rem;
      border: none;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .tikz-card-header h3 {
      margin: 0;
      font-size: 1.1rem;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    .tikz-card-header .badge {
      background: rgba(255,255,255,0.2);
      color: white;
      font-size: 0.75rem;
      padding: 0.25rem 0.5rem;
      border-radius: 4px;
    }

    /* Toolbar Redesign */
    .tikz-toolbar {
      background: #f8f9fc;
      border-bottom: 1px solid #e9ecef;
      padding: 0.75rem 1.25rem;
      display: flex;
      flex-wrap: wrap;
      gap: 0.5rem;
      align-items: center;
    }
    .tikz-toolbar-section {
      display: flex;
      gap: 0.5rem;
      align-items: center;
      padding: 0.25rem 0;
    }
    .tikz-toolbar-divider {
      width: 1px;
      height: 24px;
      background: #dee2e6;
      margin: 0 0.25rem;
    }

    /* Button Redesign */
    .tikz-btn {
      padding: 0.5rem 1rem;
      border-radius: 8px;
      font-size: 0.875rem;
      font-weight: 500;
      border: none;
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      cursor: pointer;
    }
    .tikz-btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }
    .tikz-btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
    }
    .tikz-btn-secondary {
      background: white;
      color: #495057;
      border: 1px solid #dee2e6;
    }
    .tikz-btn-secondary:hover {
      background: #f8f9fa;
      border-color: #adb5bd;
    }
    .tikz-btn-success {
      background: #10b981;
      color: white;
    }
    .tikz-btn-success:hover {
      background: #059669;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
    }

    /* Editor Styles */
    .editor {
      height: 55vh;
      resize: vertical;
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
    }
    .CodeMirror {
      height: 55vh;
      font-size: 14px;
      border: none;
      border-radius: 0;
      font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
    }

    /* Viewer Styles */
    .viewer {
      width: 100%;
      height: 60vh;
      background: #fafbfc;
      border: none;
      transform-origin: center center;
      transition: transform 0.2s ease;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    /* Error & Hint Styles */
    .error {
      color: #dc3545;
      font-size: .9rem;
      display: none;
      padding: 0.75rem;
      background: #fff5f5;
      border-left: 4px solid #dc3545;
      border-radius: 4px;
      margin-top: 0.5rem;
    }
    .hint  {
      color: #6c757d;
      font-size: .875rem;
      background: #f8f9fc;
      padding: 0.875rem 1rem;
      border-left: 4px solid #667eea;
      border-radius: 4px;
      margin: 1rem 1.25rem;
    }
    .hint strong {
      color: #667eea;
    }

    /* Loading Overlay */
    .loading-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(255,255,255,0.95);
      display: none;
      align-items: center;
      justify-content: center;
      z-index: 10;
      border-radius: 0;
    }
    .loading-overlay.show { display: flex; }
    .viewer-container { position: relative; }

    /* Zoom Controls Redesign */
    .zoom-controls {
      position: absolute;
      bottom: 1rem;
      right: 1rem;
      display: flex;
      gap: 0.25rem;
      z-index: 5;
      background: white;
      padding: 0.5rem;
      border-radius: 12px;
      box-shadow: 0 4px 16px rgba(0,0,0,0.15);
    }
    .zoom-controls button {
      width: 36px;
      height: 36px;
      padding: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 600;
      border-radius: 8px;
      border: 1px solid #e9ecef;
      background: white;
      color: #495057;
      transition: all 0.2s ease;
    }
    .zoom-controls button:hover {
      background: #f8f9fa;
      border-color: #667eea;
      color: #667eea;
    }
    .zoom-level {
      display: flex;
      align-items: center;
      padding: 0 0.75rem;
      font-size: 0.875rem;
      font-weight: 600;
      color: #495057;
      min-width: 55px;
      justify-content: center;
    }

    /* Examples Dropdown */
    .examples-dropdown {
      max-height: 450px;
      overflow-y: auto;
      box-shadow: 0 4px 20px rgba(0,0,0,0.15);
      border-radius: 8px;
      border: 1px solid #e9ecef;
    }
    .example-item {
      cursor: pointer;
      padding: 10px 16px;
      border-bottom: 1px solid #f0f0f0;
      transition: background 0.2s ease;
    }
    .example-item:hover {
      background: #f8f9fc;
      color: #667eea;
    }
    .example-category {
      font-weight: 600;
      padding: 8px 16px;
      background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: #667eea;
    }

    /* Toggle Switch */
    .auto-render-switch {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.5rem 0.75rem;
      background: white;
      border-radius: 8px;
      border: 1px solid #e9ecef;
    }
    .auto-render-switch input[type="checkbox"] {
      width: 40px;
      height: 20px;
      cursor: pointer;
    }
    .auto-render-switch label {
      margin: 0;
      font-size: 0.875rem;
      font-weight: 500;
      color: #495057;
      cursor: pointer;
    }

    /* Theme Toggle */
    .theme-toggle {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.5rem 0.75rem;
      background: white;
      border-radius: 8px;
      border: 1px solid #e9ecef;
    }
    .theme-toggle input[type="checkbox"] {
      cursor: pointer;
    }
    .theme-toggle label {
      margin: 0;
      font-size: 0.875rem;
      font-weight: 500;
      color: #495057;
      cursor: pointer;
    }

    /* Export Toolbar */
    .export-toolbar {
      background: #f8f9fc;
      border-bottom: 1px solid #e9ecef;
      padding: 0.75rem 1.25rem;
      display: flex;
      flex-wrap: wrap;
      gap: 0.5rem;
      justify-content: space-between;
      align-items: center;
    }

    /* Status Badge */
    .status-badge {
      display: inline-flex;
      align-items: center;
      gap: 0.375rem;
      padding: 0.375rem 0.75rem;
      background: #10b98115;
      color: #10b981;
      border-radius: 6px;
      font-size: 0.75rem;
      font-weight: 600;
    }
    .status-badge::before {
      content: '';
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: #10b981;
      animation: pulse 2s ease-in-out infinite;
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.5; }
    }

    /* Responsive Improvements */
    @media (max-width: 991px) {
      .tikz-toolbar {
        padding: 0.5rem;
      }
      .tikz-toolbar-section {
        width: 100%;
        justify-content: center;
      }
      .tikz-toolbar-divider {
        display: none;
      }
    }
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

  <div class="container my-4">
    <div class="row g-4">
      <!-- Editor Section -->
      <div class="col-lg-6" id="editorCol">
        <div class="tikz-card">
          <!-- Card Header -->
          <div class="tikz-card-header">
            <h3>
              <svg width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
                <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
              </svg>
              TikZ Editor
            </h3>
            <div class="auto-render-switch">
              <input type="checkbox" id="auto-render" class="form-check-input">
              <label for="auto-render">Auto-render</label>
            </div>
          </div>

          <!-- Primary Actions Toolbar -->
          <div class="tikz-toolbar">
            <div class="tikz-toolbar-section">
              <button id="btn-render" class="tikz-btn tikz-btn-primary">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="m11.596 8.697-6.363 3.692c-.54.313-1.233-.066-1.233-.697V4.308c0-.63.692-1.01 1.233-.696l6.363 3.692a.802.802 0 0 1 0 1.393z"/>
                </svg>
                Render
              </button>
              <button id="btn-clear" class="tikz-btn tikz-btn-secondary">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
                  <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                </svg>
                Clear
              </button>
              <button id="btn-copy-latex" class="tikz-btn tikz-btn-success" title="Copy LaTeX to clipboard">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/>
                  <path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/>
                </svg>
                Copy
              </button>
            </div>

            <div class="tikz-toolbar-divider"></div>

            <div class="tikz-toolbar-section">
              <div class="btn-group btn-group-sm" role="group">
                <button class="tikz-btn tikz-btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zM2.5 2a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zm6.5.5A1.5 1.5 0 0 1 10.5 1h3A1.5 1.5 0 0 1 15 2.5v3A1.5 1.5 0 0 1 13.5 7h-3A1.5 1.5 0 0 1 9 5.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zM1 10.5A1.5 1.5 0 0 1 2.5 9h3A1.5 1.5 0 0 1 7 10.5v3A1.5 1.5 0 0 1 5.5 15h-3A1.5 1.5 0 0 1 1 13.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zm6.5.5A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3z"/>
                  </svg>
                  Examples
                </button>
                <ul class="dropdown-menu examples-dropdown" id="examples-menu">
                  <!-- Populated by JS -->
                </ul>
              </div>
            </div>

            <div class="tikz-toolbar-divider"></div>

            <div class="tikz-toolbar-section">
              <button id="btn-download-tex" class="tikz-btn tikz-btn-secondary" title="Download as .tex">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
                  <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/>
                </svg>
                .tex
              </button>
              <label class="tikz-btn tikz-btn-secondary mb-0" title="Upload .tex" style="cursor: pointer;">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
                  <path d="M7.646 4.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 5.707V14.5a.5.5 0 0 1-1 0V5.707L5.354 7.854a.5.5 0 1 1-.708-.708l3-3z"/>
                </svg>
                Upload
                <input id="input-upload-tex" type="file" accept=".tex,text/plain" style="display:none;">
              </label>
            </div>

            <div class="tikz-toolbar-divider"></div>

            <div class="tikz-toolbar-section">
              <button id="btn-save-local" class="tikz-btn tikz-btn-secondary" title="Save locally">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/>
                </svg>
                Save
              </button>
              <button id="btn-load-local" class="tikz-btn tikz-btn-secondary" title="Load saved">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M2 1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H9.5a1 1 0 0 0-1 1v7.293l2.646-2.647a.5.5 0 0 1 .708.708l-3.5 3.5a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L7.5 9.293V2a2 2 0 0 1 2-2H14a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h2.5a.5.5 0 0 1 0 1H2z"/>
                </svg>
                Load
              </button>
              <button id="btn-manage-local" class="tikz-btn tikz-btn-secondary" title="Manage saved">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/>
                </svg>
                Manage
              </button>
            </div>

            <div class="tikz-toolbar-divider"></div>

            <div class="tikz-toolbar-section">
              <div class="theme-toggle">
                <input class="form-check-input" type="checkbox" id="cmThemeToggle">
                <label for="cmThemeToggle">Dark</label>
              </div>
            </div>
          </div>

          <!-- Editor Body -->
          <div class="card-body p-0">
            <textarea id="tikzInput" class="form-control editor" spellcheck="false" placeholder="Enter a tikzpicture...">
\begin{tikzpicture}[scale=0.8]
  \draw[step=1cm,gray!30,very thin] (-3,-2) grid (5,5);
  \draw[->] (-3,0) -- (5,0) node[right] {$x$};
  \draw[->] (0,-2) -- (0,5) node[above] {$y$};
  \draw[thick,blue] (-2,-1) -- (4,4);
  \fill[red] (2,3) circle (2pt) node[above right] {$P(2,3)$};
\end{tikzpicture}</textarea>
            <div id="errorMessage" class="error" style="margin: 1rem 1.25rem;"></div>
          </div>

          <!-- Hint Section -->
          <div class="hint">
            <strong>💡 Pro Tip:</strong> Paste your full LaTeX or just <code>\begin{tikzpicture}...\end{tikzpicture}</code>. We automatically extract the TikZ block and place any <code>\usetikzlibrary{...}</code> lines right above it.
          </div>
        </div>
      </div>

      <!-- Viewer Section -->
      <div class="col-lg-6" id="viewerCol">
        <div class="tikz-card">
          <!-- Card Header -->
          <div class="tikz-card-header">
            <h3>
              <svg width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                <path d="M10.5 8.5a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                <path d="M2 4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2h-1.172a2 2 0 0 1-1.414-.586l-.828-.828A2 2 0 0 0 9.172 2H6.828a2 2 0 0 0-1.414.586l-.828.828A2 2 0 0 1 3.172 4H2zm.5 2a.5.5 0 1 1 0-1 .5.5 0 0 1 0 1zm9 2.5a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0z"/>
              </svg>
              Rendered Output
            </h3>
            <span class="status-badge">Ready</span>
          </div>

          <!-- Export Toolbar -->
          <div class="export-toolbar">
            <div class="tikz-toolbar-section">
              <button id="btn-png" class="tikz-btn tikz-btn-secondary">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M6.002 5.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/>
                  <path d="M2.002 1a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2h-12zm12 1a1 1 0 0 1 1 1v6.5l-3.777-1.947a.5.5 0 0 0-.577.093l-3.71 3.71-2.66-1.772a.5.5 0 0 0-.63.062L1.002 12V3a1 1 0 0 1 1-1h12z"/>
                </svg>
                PNG
              </button>
              <button id="btn-svg" class="tikz-btn tikz-btn-secondary">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path fill-rule="evenodd" d="M0 0h1v15h15v1H0V0Zm14.817 3.113a.5.5 0 0 1 .07.704l-4.5 5.5a.5.5 0 0 1-.74.037L7.06 6.767l-3.656 5.027a.5.5 0 0 1-.808-.588l4-5.5a.5.5 0 0 1 .758-.06l2.609 2.61 4.15-5.073a.5.5 0 0 1 .704-.07Z"/>
                </svg>
                SVG
              </button>
              <button id="btn-pdf" class="tikz-btn tikz-btn-secondary">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M4 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H4zm0 1h8a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1z"/>
                  <path d="M4.603 12.087a.81.81 0 0 1-.438-.42c-.195-.388-.13-.776.08-1.102.198-.307.526-.568.897-.787a7.68 7.68 0 0 1 1.482-.645 19.701 19.701 0 0 0 1.062-2.227 7.269 7.269 0 0 1-.43-1.295c-.086-.4-.119-.796-.046-1.136.075-.354.274-.672.65-.823.192-.077.4-.12.602-.077a.7.7 0 0 1 .477.365c.088.164.12.356.127.538.007.187-.012.395-.047.614-.084.51-.27 1.134-.52 1.794a10.954 10.954 0 0 0 .98 1.686 5.753 5.753 0 0 1 1.334.05c.364.065.734.195.96.465.12.144.193.32.2.518.007.192-.047.382-.138.563a1.04 1.04 0 0 1-.354.416.856.856 0 0 1-.51.138c-.331-.014-.654-.196-.933-.417a5.716 5.716 0 0 1-.911-.95 11.642 11.642 0 0 0-1.997.406 11.311 11.311 0 0 1-1.021 1.51c-.29.35-.608.655-.926.787a.793.793 0 0 1-.58.029z"/>
                </svg>
                PDF
              </button>
            </div>

            <div class="tikz-toolbar-section">
              <button id="btn-share" class="tikz-btn tikz-btn-secondary">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M13.5 1a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3zM11 2.5a2.5 2.5 0 1 1 .603 1.628l-6.718 3.12a2.499 2.499 0 0 1 0 1.504l6.718 3.12a2.5 2.5 0 1 1-.488.876l-6.718-3.12a2.5 2.5 0 1 1 0-3.256l6.718-3.12A2.5 2.5 0 0 1 11 2.5zm-8.5 4a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3zm11 5.5a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3z"/>
                </svg>
                Share URL
              </button>
              <button id="btn-expand" class="tikz-btn tikz-btn-secondary" title="Toggle full-width output">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path fill-rule="evenodd" d="M5.828 10.172a.5.5 0 0 0-.707 0l-4.096 4.096V11.5a.5.5 0 0 0-1 0v3.975a.5.5 0 0 0 .5.5H4.5a.5.5 0 0 0 0-1H1.732l4.096-4.096a.5.5 0 0 0 0-.707zm4.344 0a.5.5 0 0 1 .707 0l4.096 4.096V11.5a.5.5 0 1 1 1 0v3.975a.5.5 0 0 1-.5.5H11.5a.5.5 0 0 1 0-1h2.768l-4.096-4.096a.5.5 0 0 1 0-.707zm0-4.344a.5.5 0 0 0 .707 0l4.096-4.096V4.5a.5.5 0 1 0 1 0V.525a.5.5 0 0 0-.5-.5H11.5a.5.5 0 0 0 0 1h2.768l-4.096 4.096a.5.5 0 0 0 0 .707zm-4.344 0a.5.5 0 0 1-.707 0L1.025 1.732V4.5a.5.5 0 0 1-1 0V.525a.5.5 0 0 1 .5-.5H4.5a.5.5 0 0 1 0 1H1.732l4.096 4.096a.5.5 0 0 1 0 .707z"/>
                </svg>
                Expand
              </button>
            </div>
          </div>

          <!-- Viewer Body -->
          <div class="card-body viewer-container p-0">
            <div class="loading-overlay" id="loading-overlay">
              <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Rendering...</span>
              </div>
            </div>
            <iframe id="viewer" class="viewer" title="TikZ Render"></iframe>
            <div class="zoom-controls">
              <button id="btn-zoom-out" title="Zoom Out">-</button>
              <span class="zoom-level" id="zoom-level">100%</span>
              <button id="btn-zoom-in" title="Zoom In">+</button>
              <button id="btn-zoom-reset" title="Reset Zoom">⟲</button>
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
  </div>

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
