<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- SEO Component -->
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Math Editor - WYSIWYG Equation Writer" />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolDescription" value="Write math beautifully with our free WYSIWYG editor. Create equations visually, add diagrams, collaborate in real-time and export to PDF, Word or LaTeX." />
        <jsp:param name="toolUrl" value="math/editor.jsp" />
        <jsp:param name="toolKeywords" value="math editor, equation editor, WYSIWYG math, write equations online, LaTeX editor, math document, formula editor" />
        <jsp:param name="toolImage" value="math-editor.svg" />
        <jsp:param name="toolFeatures" value="WYSIWYG editing,LaTeX math input,Export PDF Word LaTeX,Real-time collaboration,Document outline,Version history" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate, Graduate" />
        <jsp:param name="teaches" value="Mathematical notation, equation formatting, document preparation" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Open the editor|Navigate to the Math Editor page to start a new document,Write your content|Type text normally and use the toolbar for formatting like bold italic and headings,Insert math equations|Click Insert Math on the toolbar or type LaTeX to add rendered equations,Export your document|Click the Export button to download as PDF Word or LaTeX" />
        <jsp:param name="faq1q" value="Is the Math Editor free to use?" />
        <jsp:param name="faq1a" value="Yes, the Math Editor is completely free. Create documents, add equations, diagrams, and export to PDF or LaTeX with no registration required." />
        <jsp:param name="faq2q" value="How do I insert math equations in the editor?" />
        <jsp:param name="faq2a" value="Click the Insert Math button on the toolbar, or type LaTeX directly. The editor supports both inline and display math. Right-click on equations for derivative, integral, and plotting options." />
        <jsp:param name="faq3q" value="Can I export my document to PDF or LaTeX?" />
        <jsp:param name="faq3a" value="Yes. Use the Export dropdown to download as PDF (compiled via LaTeX) or raw LaTeX. Login is required for PDF export; LaTeX can be exported without an account." />
        <jsp:param name="faq4q" value="Does the Math Editor support LaTeX?" />
        <jsp:param name="faq4a" value="Yes. You can type LaTeX in math blocks for full equation support. The editor uses MathLive for rendering and supports common commands, fractions, integrals, matrices, and more." />
        <jsp:param name="faq5q" value="Can I add diagrams and drawings to my math document?" />
        <jsp:param name="faq5a" value="Yes. Click Insert Diagram to open the drawing canvas. Create shapes, arrows, coordinate axes, function curves, and geometric figures. Export as images that embed in your document." />
    </jsp:include>

    <!-- LCP: Preconnect for fonts + MathLive CDN -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <!-- Prefetch graphing libs so first Plot click is fast (won't block page load) -->
    <link rel="prefetch" href="https://cdn.jsdelivr.net/npm/mathjs@13.2.0/lib/browser/math.min.js" as="script">
    <link rel="prefetch" href="https://cdn.plot.ly/plotly-basic-2.35.2.min.js" as="script">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Site-wide CSS (navigation, etc.) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%= cacheVersion %>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%= cacheVersion %>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%= cacheVersion %>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%= cacheVersion %>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%= cacheVersion %>">
    <%@ include file="../modern/ads/ad-init.jsp" %>

    <!-- MathLive static CSS — load async to avoid blocking LCP -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>

    <!-- Math Editor CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/assets/css/main.css?v=<%= cacheVersion %>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/assets/css/editor.css?v=<%= cacheVersion %>">
</head>
<body>

<!-- Site Navigation -->
<jsp:include page="../modern/components/nav-header.jsp" />

<div class="math-editor-app me-editor-page">

    <jsp:include page="components/math-nav.jsp" />

    <!-- ============================
         TOP BAR
         ============================ -->
    <header class="me-editor-topbar">
        <!-- Left: Back + Title + Save Status -->
        <div class="me-topbar-left">
            <a href="<%=request.getContextPath()%>/math/dashboard.jsp" class="me-back-btn" title="Back to Dashboard">
                &#x2190;
            </a>
            <input type="text" class="me-doc-title-input" value="Untitled" spellcheck="false" placeholder="Document title">
            <div class="me-save-status">
                <span class="me-save-dot"></span>
                Saved
            </div>
            <div class="me-view-only-banner" id="me-view-only-banner" style="display:none;">
                View only — your edits are saved locally
            </div>
        </div>

        <!-- Right: Collaborators + Share + Export -->
        <div class="me-topbar-right">

            <div class="me-visibility-dropdown">
                <button class="me-btn-visibility" id="me-btn-visibility" title="Document visibility">
                    <span class="me-visibility-icon">&#x1F512;</span>
                    <span class="me-visibility-label">Private</span>
                    <span class="me-visibility-chevron">&#x25BE;</span>
                </button>
                <div class="me-visibility-menu" id="me-visibility-menu">
                    <button class="me-visibility-item" data-visibility="private">&#x1F512; Private — Only you</button>
                    <button class="me-visibility-item" data-visibility="unlisted">&#x1F4DD; Unlisted — Anyone with link</button>
                    <button class="me-visibility-item" data-visibility="public">&#x1F30D; Public — Listed for everyone</button>
                </div>
            </div>
            <button class="me-btn-share">
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="3" cy="7" r="1.5"/><circle cx="11" cy="3" r="1.5"/><circle cx="11" cy="11" r="1.5"/>
                    <line x1="4.3" y1="6.3" x2="9.7" y2="3.7"/><line x1="4.3" y1="7.7" x2="9.7" y2="10.3"/>
                </svg>
                Share
            </button>

            <div class="me-export-dropdown">
                <button class="me-btn-export">
                    Export &#x25BE;
                </button>
                <div class="me-export-menu">
                    <button class="me-export-menu-item" data-export="pdf">
                        <span>&#x1F4C4;</span> Export as PDF
                    </button>
                    <button class="me-export-menu-item" data-export="latex">
                        <span>&#x2211;</span> Export as LaTeX
                    </button>
                </div>
            </div>
        </div>
    </header>

    <!-- ============================
         TOOLBAR
         ============================ -->
    <div class="me-toolbar">
        <!-- Row 1: Text Formatting -->
        <div class="me-toolbar-row">
            <button type="button" class="me-toolbar-btn me-toolbar-btn-text" title="Bold (Ctrl+B)"><b>B</b></button>
            <button type="button" class="me-toolbar-btn me-toolbar-btn-text" title="Italic (Ctrl+I)"><i>I</i></button>
            <button type="button" class="me-toolbar-btn me-toolbar-btn-text" title="Underline (Ctrl+U)"><u>U</u></button>
            <button type="button" class="me-toolbar-btn me-toolbar-btn-text" title="Strikethrough (Ctrl+Shift+S)"><s>S</s></button>

            <span class="me-toolbar-sep"></span>

            <button type="button" class="me-toolbar-btn me-toolbar-btn-text" title="Heading 1">H1</button>
            <button type="button" class="me-toolbar-btn me-toolbar-btn-text" title="Heading 2">H2</button>
            <button type="button" class="me-toolbar-btn me-toolbar-btn-text" title="Heading 3">H3</button>

            <span class="me-toolbar-sep"></span>

            <button type="button" class="me-toolbar-btn" title="Bullet List">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><circle cx="3" cy="4" r="1.5"/><rect x="6" y="3" width="8" height="2" rx="0.5"/><circle cx="3" cy="8" r="1.5"/><rect x="6" y="7" width="8" height="2" rx="0.5"/><circle cx="3" cy="12" r="1.5"/><rect x="6" y="11" width="8" height="2" rx="0.5"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Numbered List">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><text x="1" y="5.5" font-size="5" font-weight="600">1.</text><rect x="6" y="3" width="8" height="2" rx="0.5"/><text x="1" y="9.5" font-size="5" font-weight="600">2.</text><rect x="6" y="7" width="8" height="2" rx="0.5"/><text x="1" y="13.5" font-size="5" font-weight="600">3.</text><rect x="6" y="11" width="8" height="2" rx="0.5"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Blockquote (Ctrl+Shift+B)">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><rect x="2" y="2" width="2" height="12" rx="1"/><rect x="6" y="4" width="8" height="2" rx="0.5"/><rect x="6" y="7" width="6" height="2" rx="0.5"/><rect x="6" y="10" width="7" height="2" rx="0.5"/></svg>
            </button>

            <span class="me-toolbar-sep"></span>

            <button type="button" class="me-toolbar-btn" title="Align Left">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><rect x="2" y="3" width="12" height="1.5" rx="0.5"/><rect x="2" y="6.5" width="8" height="1.5" rx="0.5"/><rect x="2" y="10" width="10" height="1.5" rx="0.5"/><rect x="2" y="13" width="6" height="1.5" rx="0.5"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Align Center">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><rect x="2" y="3" width="12" height="1.5" rx="0.5"/><rect x="4" y="6.5" width="8" height="1.5" rx="0.5"/><rect x="3" y="10" width="10" height="1.5" rx="0.5"/><rect x="5" y="13" width="6" height="1.5" rx="0.5"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Align Right">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><rect x="2" y="3" width="12" height="1.5" rx="0.5"/><rect x="6" y="6.5" width="8" height="1.5" rx="0.5"/><rect x="4" y="10" width="10" height="1.5" rx="0.5"/><rect x="8" y="13" width="6" height="1.5" rx="0.5"/></svg>
            </button>
        </div>

        <!-- Row 2: Math & Insert -->
        <div class="me-toolbar-row">
            <button type="button" class="me-toolbar-btn me-toolbar-btn-math" title="Insert Display Math (Ctrl+M)">
                &#x2211; Insert Math
            </button>
            <button type="button" class="me-toolbar-btn me-toolbar-btn-math" title="Insert Inline Math (Ctrl+Shift+M)">
                &#x221A; Inline Math
            </button>

            <span class="me-toolbar-sep"></span>

            <button type="button" class="me-toolbar-btn" title="Insert Table">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.2"><rect x="2" y="2" width="12" height="12" rx="1.5"/><line x1="2" y1="6" x2="14" y2="6"/><line x1="2" y1="10" x2="14" y2="10"/><line x1="6" y1="2" x2="6" y2="14"/><line x1="10" y1="2" x2="10" y2="14"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Insert Image">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.2"><rect x="2" y="3" width="12" height="10" rx="1.5"/><circle cx="5.5" cy="6.5" r="1.2"/><path d="M2 11l3-3 2 2 3-4 4 5" stroke-linejoin="round"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Insert Diagram">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.2"><circle cx="4" cy="4" r="2"/><circle cx="12" cy="4" r="2"/><circle cx="8" cy="12" r="2"/><line x1="5.5" y1="5.5" x2="6.8" y2="10.5"/><line x1="10.5" y1="5.5" x2="9.2" y2="10.5"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Insert Code Block">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"><polyline points="5,4 2,8 5,12"/><polyline points="11,4 14,8 11,12"/><line x1="9" y1="3" x2="7" y2="13"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Insert Molecule">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.2"><circle cx="5" cy="5" r="2"/><circle cx="11" cy="5" r="2"/><circle cx="8" cy="12" r="2"/><line x1="6.8" y1="5.8" x2="9.2" y2="5.8"/><line x1="5.8" y1="6.8" x2="7" y2="10.5"/><line x1="10.2" y1="6.8" x2="9" y2="10.5"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Lewis Structure">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" font-family="sans-serif" font-size="7" font-weight="600"><text x="2" y="10">L</text><circle cx="10" cy="4" r="1.2"/><circle cx="14" cy="4" r="1.2"/><circle cx="10" cy="8" r="1.2"/><circle cx="14" cy="8" r="1.2"/><circle cx="10" cy="12" r="1.2"/><circle cx="14" cy="12" r="1.2"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Molecular Geometry">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.2"><circle cx="8" cy="3" r="1.5" fill="currentColor"/><circle cx="3" cy="13" r="1.5" fill="currentColor"/><circle cx="13" cy="13" r="1.5" fill="currentColor"/><line x1="8" y1="4.5" x2="3" y2="11.5"/><line x1="8" y1="4.5" x2="13" y2="11.5"/><line x1="3" y1="13" x2="13" y2="13" stroke-dasharray="2,2"/></svg>
            </button>

            <span class="me-toolbar-sep"></span>

            <button type="button" class="me-toolbar-btn" title="Horizontal Rule">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><rect x="2" y="7.5" width="12" height="1.5" rx="0.75"/></svg>
            </button>
            <button type="button" class="me-toolbar-btn" title="Page Break" style="font-size:11px; font-weight:600;">
                &#x23CE;
            </button>
        </div>
    </div>

    <!-- ============================
         EDITOR BODY
         ============================ -->
    <div class="me-editor-body">

        <!-- Canvas Area (TipTap mounts here) -->
        <div class="me-canvas-wrapper">
            <div class="me-doc-loading-overlay" id="me-doc-loading-overlay" style="display:none;">
                <div class="me-doc-loading-spinner"></div>
                <span>Loading document...</span>
            </div>
            <div class="me-doc-load-error" id="me-doc-load-error" style="display:none;">
                <div class="me-doc-load-error-icon">&#x26A0;</div>
                <p>Could not load document</p>
                <a href="<%=request.getContextPath()%>/math/dashboard.jsp" class="me-btn me-btn-secondary">Back to Dashboard</a>
            </div>
            <div class="me-canvas"></div>
        </div>

        <!-- Right Panel -->
        <aside class="me-right-panel">
            <!-- Panel Top Ad (250x250, above outline — high visibility) -->
            <%@ include file="../modern/ads/ad-panel-native.jsp" %>

            <div class="me-panel-tabs">
                <button class="me-panel-tab active">Outline</button>
            </div>

            <div class="me-panel-content">

                <!-- Outline Tab (shown by default) -->
                <div class="me-outline-tab">
                    <nav class="me-outline-tree">
                        <a class="me-outline-item level-1" href="#">The Gaussian Integral</a>
                        <a class="me-outline-item level-2" href="#">Definition</a>
                        <a class="me-outline-item level-2" href="#">Proof Sketch</a>
                        <a class="me-outline-item level-3" href="#">Applications</a>
                    </nav>
                </div>

                <!-- Panel Bottom Ad (300x250 - highest CPM) -->
                <div class="me-panel-ad">
                    <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
                </div>

            </div>
        </aside>

    </div>

    <!-- Share Modal -->
    <div class="me-share-overlay" id="me-share-overlay" style="display:none;">
        <div class="me-share-modal" id="me-share-modal">
            <div class="me-share-header">
                <h3>Share document</h3>
                <button class="me-share-close" id="me-share-close" aria-label="Close">&times;</button>
            </div>
            <div class="me-share-body">
                <div class="me-share-no-id" id="me-share-no-id" style="display:none;">
                    <p>Save your document first to get a shareable link.</p>
                </div>
                <div class="me-share-links" id="me-share-links" style="display:none;">
                    <div class="me-share-link-row">
                        <label>View link — anyone with this can view</label>
                        <div class="me-share-input-wrap">
                            <input type="text" readonly id="me-share-view-url">
                            <button class="me-btn-copy" data-copy="view">Copy</button>
                        </div>
                    </div>
                    <div class="me-share-link-row me-share-edit-row" id="me-share-edit-row" style="display:none;">
                        <label>Edit link — anyone with this link can edit the document</label>
                        <div class="me-share-input-wrap">
                            <input type="text" readonly id="me-share-edit-url">
                            <button class="me-btn-copy" data-copy="edit">Copy</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ============================
         STATUS BAR
         ============================ -->
    <footer class="me-statusbar">
        <div class="me-statusbar-left">
            <span class="me-statusbar-item">
                <span>&#x270D;</span> <span id="stat-words">0</span> words
            </span>
            <span class="me-statusbar-item">
                <span>&#x270E;</span> <span id="stat-chars">0</span> chars
            </span>
            <span class="me-statusbar-item">
                <span>&#x2211;</span> <span id="stat-math">0</span> equations
            </span>
        </div>
        <div class="me-statusbar-right">
            <label class="me-auto-result-toggle" title="Show/hide auto-computed results below equations (hidden from print)">
                <input type="checkbox" id="auto-result-toggle" checked>
                <span>Auto-results</span>
            </label>
            <div class="me-zoom-control">
                <button class="me-zoom-btn" id="zoom-out" title="Zoom out">&#x2212;</button>
                <span class="me-zoom-value" id="zoom-label">100%</span>
                <button class="me-zoom-btn" id="zoom-in" title="Zoom in">+</button>
            </div>
        </div>
    </footer>

</div>

<!-- Sticky Footer Ad (only ad on editor - keeps writing distraction-free) -->
<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>

<!-- Context path for server-side compute (SymPy tier) -->
<script>window.ME_CTX = "<%=request.getContextPath()%>";</script>

<!-- Integral Calculator Core Engine (normalizeExpr, King's property, etc.) -->
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Solve.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator-core.js?v=<%= cacheVersion %>"></script>

<!-- Math Editor JS (IIFE scripts — listen for me:editor-ready event) -->
<script src="<%=request.getContextPath()%>/math/assets/js/editor-core.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/toolbar.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/mathlive-init.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/compute.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/virtual-keyboard.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/graph-insert.js?v=<%= cacheVersion %>"></script>

<!-- Fabric.js — defer to avoid blocking LCP/INP; loads before first diagram use -->
<script src="https://cdn.jsdelivr.net/npm/fabric@5.5.2/dist/fabric.min.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/drawing.js?v=<%= cacheVersion %>" defer></script>

<script src="<%=request.getContextPath()%>/math/assets/js/math-api.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/doc-loader.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/visibility-dropdown.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/autosave.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/share-modal.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/export-auth.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/slash-menu.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/export-latex.js?v=<%= cacheVersion %>"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/export-pdf.js?v=<%= cacheVersion %>"></script>

<!-- TipTap Editor (ES module — loads from CDN, creates editor, fires me:editor-ready) -->
<script type="module" src="<%=request.getContextPath()%>/math/assets/js/tiptap-init.js?v=<%= cacheVersion %>"></script>

<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%= cacheVersion %>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%= cacheVersion %>" defer></script>

<%@ include file="../modern/components/analytics.jsp" %>

<!-- Molecule integration: receive molecules from molecule-draw.jsp via postMessage -->
<script>
(function () {
    window.addEventListener('message', function (event) {
        if (!event.data || event.data.type !== 'molecule-insert') return;

        var editor = window.MeEditor;
        if (!editor) return;

        var svg = event.data.svg;
        var imageDataUrl = event.data.imageDataUrl;  // PNG from canvas (reactions)
        var smiles = event.data.smiles || '';
        var formula = event.data.formula || '';
        var weight = event.data.weight || '';
        var name = event.data.name || '';

        if (!svg && !imageDataUrl) return;

        // Convert SVG string to data URL, or use the PNG data URL directly
        var dataUrl = imageDataUrl || 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svg)));
        var altText = formula || smiles;
        var titleText = name || smiles;

        // Build caption text
        var caption = '';
        if (formula) caption += formula;
        if (weight) caption += ' \u2014 ' + weight + ' g/mol';

        // Focus editor and move cursor to end before inserting
        editor.commands.focus('end');

        // Insert molecule image + caption as a block sequence
        // Use insertContent with array for reliable insertion (same pattern as graph-insert)
        var content = [
            { type: 'image', attrs: { src: dataUrl, alt: altText, title: titleText, width: 300 } }
        ];
        if (caption) {
            content.push({
                type: 'paragraph',
                content: [{ type: 'text', text: caption }]
            });
        }

        try {
            editor.chain().focus('end').insertContent(content).run();
        } catch (_) {
            // Fallback: try setImage command
            try {
                editor.commands.setImage({ src: dataUrl, alt: altText, title: titleText });
                if (caption) {
                    editor.commands.insertContent({
                        type: 'paragraph',
                        content: [{ type: 'text', text: caption }]
                    });
                }
            } catch (_2) {}
        }

        // Show confirmation
        if (window.MeCompute && MeCompute.showToast) {
            MeCompute.showToast('Molecule inserted: ' + (formula || smiles), 2000);
        }
    });
})();
</script>
</body>
</html>
