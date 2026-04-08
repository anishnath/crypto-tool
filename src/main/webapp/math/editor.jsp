<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- SEO Component -->
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="AI-Powered Document Editor — Math, Code, Diagrams & PDF Export" />
        <jsp:param name="toolCategory" value="Editor Tools" />
        <jsp:param name="toolDescription" value="Free AI-powered document editor. AI writes content, solves equations step-by-step, fixes code errors, rewrites text, generates practice problems. LaTeX math with live compute, runnable code in 6 languages, diagrams, chemistry, graphing, PDF export. No signup required." />
        <jsp:param name="toolUrl" value="math/editor.jsp" />
        <jsp:param name="toolKeywords" value="ai document editor, ai math solver, ai equation explainer, ai writing assistant, online document editor, math editor, ai step by step solver, LaTeX editor, ai code fix, run code in browser, online code runner, ai rewrite, ai summarize, ai translate, technical writing editor, equation editor, ai practice problems, diagram editor, LaTeX to PDF, WYSIWYG math editor, chemistry editor, ai homework helper" />
        <jsp:param name="toolImage" value="math-editor.svg" />
        <jsp:param name="toolFeatures" value="AI writing assistant - generate content from descriptions,AI math solver - step-by-step solutions for any equation,AI equation explainer - explains math in plain English,AI text rewrite - formal or concise or expanded or grammar fix,AI code error fix - auto-fix code block errors,AI practice problem generator - create problems by topic,AI summarize and translate,WYSIWYG rich-text editing,LaTeX math with live compute,Run code in 6 languages (Python Java Rust Bash Node.js Lua),Diagrams and drawing canvas,Chemistry structures and Lewis diagrams,Graphing and plotting,Export PDF Word LaTeX" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate, Graduate, Professional" />
        <jsp:param name="teaches" value="Mathematical notation, programming, equation formatting, technical document preparation, chemistry visualization" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Open the editor|Navigate to the editor page — no signup or install needed,Write or let AI generate|Type text with rich formatting or press Ctrl+Shift+A to ask AI to write content for you. Use /ai in the slash menu for more AI commands,Insert math and let AI solve|Press Ctrl+M to add equations. Right-click any equation for AI Explain or AI Solve Step-by-Step plus derivatives integrals and plots,Add code and let AI fix|Insert a code block in Python Java or Rust. Run it and if it fails click AI Fix. Select code and click AI Explain,Rewrite and polish|Select any text to see the AI toolbar — rewrite as formal or concise or fix grammar or translate or summarize,Export your document|Export to PDF Word or LaTeX with all content including AI-generated solutions and explanations" />
        <jsp:param name="faq1q" value="What AI features does this editor have?" />
        <jsp:param name="faq1a" value="The editor includes AI writing (generate content from descriptions), AI math solving (step-by-step solutions for equations), AI equation explanation (plain English), AI text rewriting (formal, concise, expand, grammar fix), AI code fixing (auto-fix errors), AI problem generation (practice problems by topic), AI summarization, and AI translation. Access via the AI toolbar button, Ctrl+Shift+A, the slash menu, or right-click on equations." />
        <jsp:param name="faq2q" value="How does AI solve equations step by step?" />
        <jsp:param name="faq2a" value="Right-click any math equation and select AI Solve Step-by-Step. The AI reads the LaTeX equation and generates a complete worked solution with intermediate steps, all formatted with proper math notation. You can also type /ai in the slash menu and choose AI Solve Step-by-Step." />
        <jsp:param name="faq3q" value="Can AI rewrite or improve my text?" />
        <jsp:param name="faq3a" value="Yes. Select any text and a floating AI toolbar appears with options to rewrite as formal academic, make concise, expand with detail, fix grammar, summarize, or translate. The AI preserves all LaTeX math and code formatting while improving the natural language." />
        <jsp:param name="faq4q" value="What programming languages can I run?" />
        <jsp:param name="faq4a" value="Python, Java, Rust, Bash, Node.js, and Lua. Insert a code block, write code, click Run. If it fails, AI can auto-fix the error. Select code and click Explain for an AI explanation of what the code does." />
        <jsp:param name="faq5q" value="Is this free? Do I need to sign up?" />
        <jsp:param name="faq5a" value="Completely free with no signup required. All AI features, math computation, code execution, diagrams, chemistry structures, and PDF export are available immediately." />
    </jsp:include>

    <!-- LCP: Preconnect for fonts + MathLive CDN -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <!-- Prefetch graphing libs so first Plot click is fast (won't block page load) -->
    <link rel="prefetch" href="https://cdn.jsdelivr.net/npm/mathjs@13.2.0/lib/browser/math.min.js" as="script">
    <link rel="prefetch" href="https://cdn.plot.ly/plotly-basic-2.35.2.min.js" as="script">
    <link rel="preload" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet"></noscript>

    <!-- Site-wide CSS (navigation, etc.) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    <%@ include file="../modern/ads/ad-init.jsp" %>

    <!-- MathLive static CSS — load async to avoid blocking LCP -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>

    <!-- Math Editor CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/assets/css/main.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/assets/css/editor.css">
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

            <button type="button" class="me-toolbar-btn me-toolbar-btn-ai" title="AI Assistant (Ctrl+Shift+A)" onclick="if(window.MeAI)MeAI.showPrompt()">
                &#10024; AI
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

<!-- Nerdamer CAS — defer to unblock LCP/INP (only needed on first compute action) -->
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.js" defer></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js" defer></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.js" defer></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Solve.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator-core.js" defer></script>

<!-- Math Editor JS — critical path: editor-core, toolbar, code-runner (needed before TipTap) -->
<script src="<%=request.getContextPath()%>/math/assets/js/editor-core.js"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/toolbar.js"></script>
<script src="<%=request.getContextPath()%>/math/assets/js/code-runner.js"></script>

<!-- Math Editor JS — deferred (listen for me:editor-ready, not needed for first paint) -->
<script src="<%=request.getContextPath()%>/math/assets/js/mathlive-init.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/compute.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/virtual-keyboard.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/graph-insert.js" defer></script>

<!-- Fabric.js — defer to avoid blocking LCP/INP; loads before first diagram use -->
<script src="https://cdn.jsdelivr.net/npm/fabric@5.5.2/dist/fabric.min.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/drawing.js" defer></script>

<!-- Document management — defer (autosave hooks into me:editor-ready event) -->
<script src="<%=request.getContextPath()%>/math/assets/js/math-api.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/doc-loader.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/visibility-dropdown.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/autosave.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/share-modal.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/export-auth.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/ai-assistant.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/slash-menu.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/export-latex.js" defer></script>
<script src="<%=request.getContextPath()%>/math/assets/js/export-pdf.js" defer></script>

<!-- TipTap Editor (ES module — loads from CDN, creates editor, fires me:editor-ready) -->
<script type="module" src="<%=request.getContextPath()%>/math/assets/js/tiptap-init.js"></script>

<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

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
