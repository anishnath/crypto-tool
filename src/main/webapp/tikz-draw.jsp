<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">

    <!-- Critical CSS -->
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root{--primary:#6366f1;--primary-dark:#4f46e5;--bg-primary:#fff;--bg-secondary:#f8fafc;--bg-tertiary:#f1f5f9;--bg-hover:#f1f5f9;--text-primary:#0f172a;--text-secondary:#475569;--text-muted:#94a3b8;--border:#e2e8f0;--tool-primary:#4f46e5;--tool-primary-dark:#4338ca;--tool-gradient:linear-gradient(135deg,#4f46e5 0%,#6366f1 100%);--tool-light:#eef2ff}
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--tool-light:rgba(79,70,229,0.15)}

        /* Page header + breadcrumbs */
        .tool-page-header{background:var(--bg-primary);border-bottom:1px solid var(--border);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-secondary);margin-top:0.5rem}
        .tool-breadcrumbs a{color:var(--text-secondary);text-decoration:none}
        .tool-breadcrumbs a:hover{color:var(--tool-primary)}

        /* Description section */
        .tool-description-section{background:var(--tool-light);border-bottom:1px solid var(--border);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;gap:2rem}
        .tool-description-content{flex:1}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary)}
        .tool-description-content a{color:var(--tool-primary);text-decoration:none}
        .tool-description-content a:hover{text-decoration:underline}
        .tool-description-ad{flex-shrink:0}
        @media(max-width:767px){.tool-description-section{padding:1rem}.tool-description-inner{flex-direction:column;gap:1rem}.tool-description-ad{width:100%}}

        /* About / content section */
        .tool-content-section{max-width:1200px;margin:2rem auto;padding:0 1rem}
        .tool-content-container{max-width:100%}
        .tool-card{background:var(--bg-primary);border:1px solid var(--border);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}
        .tool-card-body{padding:1.25rem 1.5rem}
        .tool-card-body p{margin:0 0 1rem;font-size:0.9375rem;line-height:1.7;color:var(--text-secondary)}
        .tool-card-body p:last-child{margin-bottom:0}
        .tool-section-title{font-size:1.25rem;font-weight:700;color:var(--text-primary);margin:0 0 0.75rem}
        .tool-subsection-title{font-size:1rem;font-weight:600;color:var(--text-primary);margin:1.25rem 0 0.5rem}
        .tool-feature-list{list-style:none;padding:0;margin:0 0 1rem}
        .tool-feature-list li{position:relative;padding:0.375rem 0 0.375rem 1.25rem;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary)}
        .tool-feature-list li::before{content:'';position:absolute;left:0;top:0.75rem;width:6px;height:6px;border-radius:50%;background:var(--tool-primary)}
        .tool-feature-list li strong{color:var(--text-primary);font-weight:600}
        .tool-highlight-box{background:var(--tool-light);border-left:3px solid var(--tool-primary);border-radius:0.5rem;padding:1rem 1.25rem;margin-top:1rem;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary)}
        .tool-highlight-box a{color:var(--tool-primary);text-decoration:none}
        .tool-highlight-box a:hover{text-decoration:underline}

        /* Dark mode overrides */
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary);border-bottom-color:var(--border)}
        [data-theme="dark"] .tool-page-title{color:var(--text-primary)}
        [data-theme="dark"] .tool-breadcrumbs,[data-theme="dark"] .tool-breadcrumbs a{color:var(--text-secondary)}
        [data-theme="dark"] .tool-badge{background:var(--tool-light);color:var(--tool-primary)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary);border-bottom-color:var(--border)}
        [data-theme="dark"] .tool-description-content p{color:var(--text-secondary)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary);border-color:var(--border)}
        [data-theme="dark"] .tool-card-body p{color:var(--text-secondary)}
        [data-theme="dark"] .tool-section-title,[data-theme="dark"] .tool-subsection-title{color:var(--text-primary)}
        [data-theme="dark"] .tool-feature-list li{color:var(--text-secondary)}
        [data-theme="dark"] .tool-feature-list li strong{color:var(--text-primary)}
        [data-theme="dark"] .tool-highlight-box{background:rgba(79,70,229,0.1)}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="TikZ Draw - Visual LaTeX Diagram Editor Online" />
        <jsp:param name="toolDescription" value="Draw LaTeX TikZ diagrams visually with a point-and-click editor. Create lines, circles, arcs, rectangles, paths, bezier curves, labels with LaTeX math, and export clean TikZ code. Free, no installation required." />
        <jsp:param name="toolCategory" value="Math" />
        <jsp:param name="toolUrl" value="tikz-draw.jsp" />
        <jsp:param name="toolKeywords" value="TikZ draw, visual TikZ editor, LaTeX diagram editor, draw TikZ online, TikZ diagram maker, visual LaTeX, point and click TikZ, TikZ code generator, geometry drawing tool, LaTeX graphics editor, free TikZ tool" />
        <jsp:param name="toolImage" value="tikz-tool.png" />
        <jsp:param name="toolFeatures" value="Visual point-and-click drawing,12 drawing tools,Real-time TikZ code generation,LaTeX math labels with MathJax,Export clean TikZ code,Save and load projects,Undo/redo support,Custom colors and patterns" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="How does TikZ Draw work?" />
        <jsp:param name="faq1a" value="TikZ Draw lets you visually create diagrams by clicking and drawing on a canvas. It automatically generates the corresponding LaTeX TikZ code that you can copy into your documents." />
        <jsp:param name="faq2q" value="Can I use LaTeX math in labels?" />
        <jsp:param name="faq2a" value="Yes! Labels support full LaTeX math notation like $\\alpha$, $\\frac{a}{b}$, and more. MathJax renders them in real-time on the canvas." />
        <jsp:param name="faq3q" value="Is TikZ Draw free?" />
        <jsp:param name="faq3a" value="Yes, completely free with no registration. Everything runs in your browser." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tikz-draw.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- MathJax for LaTeX rendering in labels -->
    <script>
        window.MathJax = {
            tex: { inlineMath: [['$','$'], ['\\(','\\)']], displayMath: [['$$','$$'], ['\\[','\\]']] },
            svg: { fontCache: 'global' },
            startup: {
                ready: () => {
                    MathJax.startup.defaultReady();
                    MathJax.startup.promise.then(() => {
                        if (window.app) { window.app.mathJaxReady = true; window.app.render(); }
                    });
                }
            }
        };
    </script>
    <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js" async></script>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">TikZ Draw - Visual Editor</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#devops">Devops Tools</a> /
                    <a href="<%=request.getContextPath()%>/tikz-viewer.jsp">TikZ Viewer</a> /
                    <span>TikZ Draw</span>
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge"><svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8.707 8l2.647-2.646a.5.5 0 0 0-.708-.708L8 7.293 5.354 4.646z"/></svg> Free</span>
                <span class="tool-badge"><svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/></svg> No Login</span>
                <span class="tool-badge"><svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm15 2h-4v3h4V4zm0 4h-4v3h4V8zm0 4h-4v3h3a1 1 0 0 0 1-1v-2zm-5 3v-3H6v3h4zm-5 0v-3H1v2a1 1 0 0 0 1 1h3zm-4-4h4V8H1v3zm0-4h4V4H1v3zm5-3v3h4V4H6zm4 4H6v3h4V8z"/></svg> Math</span>
            </div>
        </div>
    </header>

    <!-- Description + Ad Section -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Draw LaTeX TikZ diagrams visually. Click to place points, lines, circles, arcs, rectangles, paths, bezier curves, and labels with LaTeX math. The tool generates clean TikZ code automatically. Also try the <a href="<%=request.getContextPath()%>/tikz-viewer.jsp">code-first TikZ Viewer</a>.</p>
            </div>
            <div class="tool-description-ad">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <!-- Drawing Workspace (full-width, no ads inside) -->
    <section style="padding: 0 1rem 1rem;">
        <div class="tikz-draw-workspace">
            <!-- Action Bar -->
            <div class="header">
                <div class="header-buttons">
                    <button id="undoBtn" class="btn" onclick="app.undo()" title="Undo (Ctrl+Z)" disabled>&#x21B6; Undo</button>
                    <button id="redoBtn" class="btn" onclick="app.redo()" title="Redo (Ctrl+Y)" disabled>&#x21B7; Redo</button>
                    <button id="copyBtn" class="btn" onclick="app.copyObject()" title="Copy (Ctrl+C)" disabled>Copy</button>
                    <button id="pasteBtn" class="btn" onclick="app.pasteObject()" title="Paste (Ctrl+V)" disabled>Paste</button>
                    <button class="btn" onclick="app.loadProject()">Open</button>
                    <button class="btn" onclick="app.saveProject()">Save</button>
                    <button class="btn btn-primary" onclick="app.showExport()">Export TikZ</button>
                </div>
                <div class="header-buttons">
                    <button class="btn" id="codeToggle">Show Code</button>
                </div>
            </div>

            <div class="main">
                <!-- Toolbar -->
                <div class="toolbar">
                    <div class="tool active" data-tool="select" title="Select (V)">
                        <span class="tool-icon">&#x2196;</span>
                        <span>Select</span>
                    </div>
                    <div class="tool" data-tool="rotate" title="Rotate (O)">
                        <span class="tool-icon">&#x21BB;</span>
                        <span>Rotate</span>
                    </div>
                    <div class="tool" data-tool="point" title="Point (P)">
                        <span class="tool-icon">&#x2022;</span>
                        <span>Point</span>
                    </div>
                    <div class="tool" data-tool="line" title="Line (L)">
                        <span class="tool-icon">&#x2500;</span>
                        <span>Line</span>
                    </div>
                    <div class="tool-divider"></div>
                    <div class="tool" data-tool="circle" title="Circle (C)">
                        <span class="tool-icon">&#x25CB;</span>
                        <span>Circle</span>
                    </div>
                    <div class="tool" data-tool="arc" title="Arc (R)">
                        <span class="tool-icon">&#x2312;</span>
                        <span>Arc</span>
                    </div>
                    <div class="tool" data-tool="rect" title="Rectangle (B)">
                        <span class="tool-icon">&#x25A1;</span>
                        <span>Rect</span>
                    </div>
                    <div class="tool-divider"></div>
                    <div class="tool" data-tool="label" title="Label (T)">
                        <span class="tool-icon">A</span>
                        <span>Label</span>
                    </div>
                    <div class="tool" data-tool="path" title="Path (H)">
                        <span class="tool-icon">&#x27CB;</span>
                        <span>Path</span>
                    </div>
                    <div class="tool" data-tool="bezier" title="Bezier (Q)">
                        <span class="tool-icon">&#x223F;</span>
                        <span>Curve</span>
                    </div>
                    <div class="tool-divider"></div>
                    <div class="tool" data-tool="grid" title="Grid (G)">
                        <span class="tool-icon">#</span>
                        <span>Grid</span>
                    </div>
                    <div class="tool" data-tool="image" title="Image (I)">
                        <span class="tool-icon">&#x1F5BC;</span>
                        <span>Image</span>
                    </div>
                </div>

                <!-- Canvas -->
                <div class="canvas-container" id="canvasContainer">
                    <canvas id="canvas"></canvas>

                    <!-- Properties Float (appears inside canvas when object selected) -->
                    <div class="canvas-properties" id="propertiesSection" style="display:none;">
                        <div class="canvas-properties-header">
                            <span id="propertiesTitle">Properties</span>
                            <button class="panel-close-btn" onclick="app.closePropertiesPanel()" title="Close">&times;</button>
                        </div>
                        <div class="canvas-properties-body" id="propertiesPanel"></div>
                    </div>
                </div>

                <!-- Right Panel -->
                <div class="right-panel">
                    <!-- Objects Section -->
                    <div class="panel-section object-list-container">
                        <div class="panel-header">
                            Objects
                            <span style="font-weight:normal;text-transform:none;font-size:10px;color:#a1a1aa;">drag to reorder</span>
                        </div>
                        <div class="panel-header" style="display:flex;gap:12px;padding:4px 10px;">
                            <label style="font-weight:normal;text-transform:none;font-size:11px;"><input type="checkbox" id="hideInvisiblePoints" name="hideInvisiblePoints" value="1" onclick="javascript:app.updateObjectList();" checked/> Hide Invisible</label>
                            <label style="font-weight:normal;text-transform:none;font-size:11px;"><input type="checkbox" id="removeUnusedPoints" name="removeUnusedPoints" value="1" onclick="javascript:app.updateObjectList();"/> Remove Unused</label>
                        </div>
                        <div class="object-list" id="objectList"></div>
                    </div>

                    <!-- Code Section (toggleable) -->
                    <div class="panel-section code-section collapsed" id="codePanel">
                        <div class="panel-header">
                            TikZ Code
                            <button class="panel-copy-btn" onclick="app.copyCodeToClipboard()" title="Copy">Copy</button>
                        </div>
                        <pre id="tikzCodeOutput" class="code-output"></pre>
                    </div>
                </div>
            </div>

            <!-- Status Bar -->
            <div class="status-bar">
                <div class="status-item">
                    <span>Pos:</span>
                    <span id="cursorPos">(0.00, 0.00)</span>
                </div>
                <div class="status-item">
                    <span>Snap:</span>
                    <span id="snapSize">0.25</span>
                </div>
                <div class="status-item">
                    <span>Zoom:</span>
                    <span id="zoomLevel">100</span>%
                </div>
                <div class="status-item">
                    <span id="objectCount">0</span> objects
                </div>
                <div class="status-item" style="margin-left:auto;">
                    <span id="statusTip">Click to place points</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Color Picker Modal -->
    <div class="modal-overlay" id="colorPickerModal">
        <div class="modal">
            <div class="modal-header">
                <h3>Add Custom Color</h3>
                <button class="modal-close" onclick="app.closeColorPicker()">&times;</button>
            </div>
            <div class="color-picker-area" id="colorPickerArea">
                <div class="color-picker-cursor" id="colorPickerCursor"></div>
            </div>
            <div class="hue-slider" id="hueSlider">
                <div class="hue-cursor" id="hueCursor"></div>
            </div>
            <div class="color-inputs-row">
                <div class="color-input-group">
                    <label>R</label>
                    <input type="number" id="colorR" min="0" max="255" value="255">
                </div>
                <div class="color-input-group">
                    <label>G</label>
                    <input type="number" id="colorG" min="0" max="255" value="0">
                </div>
                <div class="color-input-group">
                    <label>B</label>
                    <input type="number" id="colorB" min="0" max="255" value="0">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Hex:</span>
                <div class="property-input">
                    <input type="text" id="colorHex" value="#FF0000">
                </div>
            </div>
            <div class="property-row">
                <span class="property-label">Name:</span>
                <div class="property-input">
                    <input type="text" id="colorName" placeholder="mycolor">
                </div>
            </div>
            <div class="color-preview-row">
                <div class="color-preview-swatch" id="colorPreview" style="background:#f00;"></div>
                <span style="font-size:12px;color:#888;">Preview</span>
            </div>
            <div class="modal-buttons">
                <button class="btn" onclick="app.closeColorPicker()">Cancel</button>
                <button class="btn btn-primary" onclick="app.addCustomColor(document.getElementById('colorName').value)">Add Color</button>
            </div>
        </div>
    </div>

    <!-- Export Modal -->
    <div class="modal-overlay" id="exportModal">
        <div class="modal large">
            <div class="modal-header">
                <h3>Export TikZ</h3>
                <button class="modal-close" onclick="app.closeExport()">&times;</button>
            </div>
            <textarea class="export-textarea" id="exportCode" readonly></textarea>
            <div class="modal-buttons">
                <button class="btn" onclick="app.copyExport()">Copy to Clipboard</button>
                <button class="btn" onclick="app.downloadExport()">Download .tex</button>
                <button class="btn btn-primary" onclick="app.closeExport()">Close</button>
            </div>
        </div>
    </div>

    <!-- Embedded Node Editor Modal -->
    <div class="modal-overlay" id="nodeEditorModal">
        <div class="modal">
            <div class="modal-header">
                <h3>Edit Label</h3>
                <button class="modal-close" onclick="app.closeNodeEditor()">&times;</button>
            </div>
            <div class="panel-content">
                <div class="property-row">
                    <span class="property-label">Text:</span>
                    <div class="property-input">
                        <textarea id="nodeText" rows="2" placeholder="$label$"></textarea>
                    </div>
                </div>
                <div class="property-row">
                    <span class="property-label">Preview:</span>
                    <div class="property-input">
                        <div class="latex-preview" id="nodeLatexPreview" placeholder="label"></div>
                    </div>
                </div>
                <div class="property-row">
                    <span class="property-label">Position:</span>
                    <div class="property-input">
                        <input type="range" id="nodePosition" min="0" max="1" step="0.05" value="0.5" style="width:100%;">
                        <div style="display:flex;justify-content:space-between;font-size:10px;color:#888;">
                            <span>start (0)</span>
                            <span id="nodePosValue">0.5</span>
                            <span>end (1)</span>
                        </div>
                    </div>
                </div>
                <div class="property-row">
                    <span class="property-label">Anchor:</span>
                    <div class="property-input">
                        <select id="nodeAnchor">
                            <option value="above">above</option>
                            <option value="below">below</option>
                            <option value="left">left</option>
                            <option value="right">right</option>
                            <option value="above left">above left</option>
                            <option value="above right">above right</option>
                            <option value="below left">below left</option>
                            <option value="below right">below right</option>
                        </select>
                    </div>
                </div>
                <div class="property-row">
                    <span class="property-label">Font Size:</span>
                    <div class="property-input">
                        <select id="nodeFontSize">
                            <option value="tiny">tiny</option>
                            <option value="scriptsize">scriptsize</option>
                            <option value="footnotesize">footnotesize</option>
                            <option value="small">small</option>
                            <option value="normal" selected>normal</option>
                            <option value="large">large</option>
                            <option value="Large">Large</option>
                        </select>
                    </div>
                </div>
                <div class="property-row">
                    <span class="property-label">Color:</span>
                    <div class="property-input">
                        <select id="nodeColor"></select>
                    </div>
                </div>
                <div class="property-row">
                    <span class="property-label">Sloped:</span>
                    <div class="property-input">
                        <label style="display:flex;align-items:center;gap:8px;">
                            <input type="checkbox" id="nodeSloped" onchange="document.getElementById('nodeRotationRow').style.display = this.checked ? 'none' : 'flex';">
                            <span style="font-size:12px;color:#888;">Rotate text to segment?</span>
                        </label>
                    </div>
                </div>
                <div class="property-row" id="nodeRotationRow">
                    <span class="property-label">Rotation:</span>
                    <div class="property-input">
                        <input type="number" step="5" id="nodeRotation" value="0" style="width:80px;"> deg
                    </div>
                </div>
            </div>
            <div class="modal-buttons">
                <button class="btn btn-danger" onclick="app.deleteNode()">Delete</button>
                <button class="btn" onclick="app.closeNodeEditor()">Cancel</button>
                <button class="btn btn-primary" onclick="app.saveNode()">Save</button>
            </div>
        </div>
    </div>

    <!-- Mid-page ad -->
    <div style="padding: 1rem;">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="tikz-draw.jsp"/>
        <jsp:param name="category" value="Mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- About Section -->
    <section class="tool-content-section">
        <div class="tool-content-container">
            <div class="tool-card">
                <div class="tool-card-header">About TikZ Draw</div>
                <div class="tool-card-body">
                    <h2 class="tool-section-title">Visual LaTeX Diagram Editor</h2>
                    <p>TikZ Draw is a visual, point-and-click editor for creating LaTeX TikZ diagrams. Instead of writing code first, you draw directly on the canvas and the tool generates clean TikZ code automatically.</p>

                    <h3 class="tool-subsection-title">Drawing Tools</h3>
                    <ul class="tool-feature-list">
                        <li><strong>Point:</strong> Place named coordinates on the grid</li>
                        <li><strong>Line &amp; Vector:</strong> Draw segments and arrows between points</li>
                        <li><strong>Circle &amp; Ellipse:</strong> Draw circles with one center or ellipses with two foci</li>
                        <li><strong>Arc:</strong> Draw arcs with configurable start/end angles</li>
                        <li><strong>Rectangle &amp; Grid:</strong> Draw rectangles and TikZ grids</li>
                        <li><strong>Path &amp; Bezier:</strong> Draw multi-point paths and smooth bezier curves</li>
                        <li><strong>Label:</strong> Place LaTeX math labels (rendered with MathJax)</li>
                        <li><strong>Image:</strong> Insert images with configurable size and anchor</li>
                    </ul>

                    <h3 class="tool-subsection-title">Features</h3>
                    <ul class="tool-feature-list">
                        <li><strong>Smart Coordinates:</strong> Shared coordinates between objects, automatic orphan cleanup</li>
                        <li><strong>Multi-select:</strong> Ctrl+click or box-select multiple objects, move/rotate together</li>
                        <li><strong>Undo/Redo:</strong> Full state history with Ctrl+Z / Ctrl+Y</li>
                        <li><strong>Custom Colors:</strong> HSV color picker for adding custom TikZ colors</li>
                        <li><strong>Fill Patterns:</strong> 13 TikZ patterns including crosshatch, dots, bricks, stars</li>
                        <li><strong>Save/Load:</strong> Save projects as JSON, load them back later</li>
                        <li><strong>Export:</strong> Generate clean TikZ code, copy to clipboard or download as .tex</li>
                    </ul>

                    <p class="tool-highlight-box"><strong>Code-first?</strong> If you prefer writing TikZ code directly, try our <a href="<%=request.getContextPath()%>/tikz-viewer.jsp">TikZ Viewer &amp; Editor</a> which renders TikZ code with real-time preview and exports to PNG/SVG/PDF.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>

    <!-- Sticky Footer Ad -->
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Tool Utilities -->
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <!-- TikZ Draw JS (loaded in dependency order) -->
    <script defer src="<%=request.getContextPath()%>/js/tikz-draw/tikz-constants.js?v=<%=cacheVersion%>"></script>
    <script defer src="<%=request.getContextPath()%>/js/tikz-draw/tikz-objects.js?v=<%=cacheVersion%>"></script>
    <script defer src="<%=request.getContextPath()%>/js/tikz-draw/tikz-app-core.js?v=<%=cacheVersion%>"></script>
    <script defer src="<%=request.getContextPath()%>/js/tikz-draw/tikz-tools.js?v=<%=cacheVersion%>"></script>
    <script defer src="<%=request.getContextPath()%>/js/tikz-draw/tikz-renderer.js?v=<%=cacheVersion%>"></script>
    <script defer src="<%=request.getContextPath()%>/js/tikz-draw/tikz-panels.js?v=<%=cacheVersion%>"></script>
    <script defer src="<%=request.getContextPath()%>/js/tikz-draw/tikz-export.js?v=<%=cacheVersion%>"></script>
    <script defer src="<%=request.getContextPath()%>/js/tikz-draw/tikz-draw-init.js?v=<%=cacheVersion%>"></script>
</body>
</html>
