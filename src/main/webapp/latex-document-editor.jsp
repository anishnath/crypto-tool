<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String cacheVersion = "2.1";
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdnjs.cloudflare.com">
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">

    <!-- Critical CSS -->
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root{--primary:#6366f1;--primary-dark:#4f46e5;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="LaTeX Document Editor Online - Free PDF Export"/>
        <jsp:param name="toolDescription" value="Professional LaTeX document editor with live preview and PDF export. Write complete LaTeX documents in your browser with syntax highlighting, auto-save, and multiple templates."/>
        <jsp:param name="toolCategory" value="Math"/>
        <jsp:param name="toolUrl" value="latex-document-editor.jsp"/>
        <jsp:param name="toolImage" value="images/site/latex-editor.png"/>
        <jsp:param name="toolFeatures" value="Live LaTeX preview,PDF export,Auto-save functionality,Multiple document templates (Article Report Letter CV),Syntax highlighting with CodeMirror,Session storage,100% client-side processing,No registration required"/>
        <jsp:param name="toolHowToSteps" value="Choose a template (Article Report Letter Presentation CV)|Write LaTeX code with syntax highlighting|Preview in real-time as you type|Export to PDF with automatic date-stamped filename"/>
        <jsp:param name="faq1Question" value="Is this LaTeX editor free to use?"/>
        <jsp:param name="faq1Answer" value="Yes, the LaTeX Document Editor is completely free with no registration required. All features including PDF export are available at no cost."/>
        <jsp:param name="faq2Question" value="Is my LaTeX document data secure and private?"/>
        <jsp:param name="faq2Answer" value="Absolutely. All processing happens entirely in your browser (client-side). We do not upload, store, track, or analyze your documents. Your data never leaves your device."/>
        <jsp:param name="faq3Question" value="What LaTeX features are supported?"/>
        <jsp:param name="faq3Answer" value="The editor supports mathematical equations (via KaTeX), document classes (article, report), sections, lists, tables, text formatting, and more. Templates for various document types are included."/>
    </jsp:include>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
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

    <!-- CodeMirror -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/theme/monokai.min.css">

    <!-- KaTeX CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <!-- LaTeX.js CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/latex.js@0.12.6/dist/css/latex.css">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

    <style>
        /* LaTeX Tool Theme Variables */
        :root {
            --tool-primary: #6366f1;
            --tool-primary-dark: #4f46e5;
            --tool-gradient: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            --tool-light: #f0f4ff;
        }

        /* Editor/Preview Layout */
        .latex-editor-container {
            display: flex;
            gap: 0;
            min-height: 500px;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.75rem;
            overflow: hidden;
            background: var(--bg-primary, #fff);
        }

        .latex-editor-pane {
            flex: 1;
            display: flex;
            flex-direction: column;
            border-right: 1px solid var(--border, #e2e8f0);
            background: #1e1e1e;
            min-width: 0;
        }

        .latex-preview-pane {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: var(--bg-primary, #fff);
            min-width: 0;
        }

        .latex-pane-header {
            padding: 0.75rem 1rem;
            font-weight: 600;
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
        }

        .latex-editor-pane .latex-pane-header {
            background: #272822;
            color: #fff;
            border-bottom-color: #333;
        }

        .latex-preview-pane .latex-pane-header {
            background: var(--bg-secondary, #f8fafc);
        }

        /* CodeMirror */
        .latex-editor-wrapper {
            flex: 1;
            overflow: auto;
            min-height: 500px;
            max-height: 700px;
            position: relative;
        }

        .latex-editor-wrapper .CodeMirror {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            height: auto !important;
            font-size: 13px;
            font-family: 'JetBrains Mono', 'Fira Code', monospace;
            background: #272822;
        }

        .latex-editor-wrapper .CodeMirror-scroll {
            overflow-y: auto !important;
            overflow-x: auto !important;
        }

        /* Preview Content */
        .latex-preview-content {
            flex: 1;
            overflow-y: auto;
            padding: 1.5rem;
            background: #ffffff;
        }

        .latex-preview-content .latex-content {
            max-width: 800px;
            margin: 0 auto;
            font-family: 'Georgia', 'Times New Roman', serif;
            line-height: 1.8;
        }

        /* Loading */
        .latex-loading {
            position: absolute;
            inset: 0;
            background: rgba(255,255,255,0.95);
            display: none;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            z-index: 20;
        }

        .latex-loading.show {
            display: flex;
        }

        .latex-spinner {
            width: 40px;
            height: 40px;
            border: 3px solid var(--border, #e2e8f0);
            border-top-color: var(--tool-primary, #6366f1);
            border-radius: 50%;
            animation: latexSpin 0.8s linear infinite;
        }

        @keyframes latexSpin {
            to { transform: rotate(360deg); }
        }

        /* Status bar */
        .latex-status-bar {
            padding: 0.5rem 1rem;
            background: var(--bg-secondary, #f8fafc);
            border-top: 1px solid var(--border, #e2e8f0);
            font-size: 0.75rem;
            color: var(--text-secondary, #64748b);
            display: flex;
            justify-content: space-between;
        }

        /* Template selector */
        .latex-template-select {
            padding: 0.5rem 1rem;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            font-size: 0.875rem;
            background: var(--bg-primary, #fff);
            cursor: pointer;
        }

        /* Mobile responsive */
        @media (max-width: 991px) {
            .latex-editor-container {
                flex-direction: column;
                min-height: auto;
            }

            .latex-editor-pane {
                border-right: none;
                border-bottom: 1px solid var(--border, #e2e8f0);
                height: 350px;
            }

            .latex-preview-pane {
                height: 400px;
            }
        }

        /* Dark mode */
        [data-theme="dark"] .latex-preview-pane {
            background: var(--bg-secondary, #1e293b);
        }

        [data-theme="dark"] .latex-preview-content {
            background: var(--bg-primary, #0f172a);
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .latex-pane-header {
            border-bottom-color: var(--border, #334155);
        }

        /* Content sections */
        .tool-content-section {
            padding: 2rem 1.5rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .tool-content-container {
            max-width: 900px;
            margin: 0 auto;
        }

        .tool-content-section .tool-card {
            background: var(--bg-primary, #fff);
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .tool-content-section .tool-card-header {
            background: linear-gradient(135deg, var(--tool-primary, #6366f1) 0%, var(--tool-primary-dark, #4f46e5) 100%);
            color: white;
            padding: 1rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .tool-content-section .tool-card-body {
            padding: 1.5rem;
        }

        .tool-section-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-primary, #0f172a);
            margin-bottom: 1rem;
        }

        .tool-subsection-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
            margin: 1.5rem 0 0.75rem;
        }

        .tool-feature-list {
            padding-left: 1.25rem;
            margin-bottom: 1rem;
        }

        .tool-feature-list li {
            margin-bottom: 0.5rem;
            color: var(--text-secondary, #475569);
            line-height: 1.6;
        }

        .tool-feature-list li strong {
            color: var(--text-primary, #0f172a);
        }

        [data-theme="dark"] .tool-content-section .tool-card {
            background: var(--bg-secondary, #1e293b);
            border-color: var(--border, #334155);
        }

        [data-theme="dark"] .tool-section-title,
        [data-theme="dark"] .tool-subsection-title,
        [data-theme="dark"] .tool-feature-list li strong {
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .tool-feature-list li {
            color: var(--text-secondary, #94a3b8);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">LaTeX Document Editor</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#math">Math Tools</a> /
                    <span>LaTeX Editor</span>
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge"><svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8.707 8l2.647-2.646a.5.5 0 0 0-.708-.708L8 7.293 5.354 4.646z"/></svg> Free</span>
                <span class="tool-badge"><svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/></svg> No Login</span>
                <span class="tool-badge"><svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M5.5 7a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1h-5zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5z"/><path d="M9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.5L9.5 0zm0 1v2A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5z"/></svg> PDF Export</span>
            </div>
        </div>
    </header>

    <!-- Description with Ad -->
    <section class="tool-description-section">
        <div class="tool-description-content">
            <p>Write complete LaTeX documents in your browser with <strong>live preview</strong> and <strong>PDF export</strong>. Choose from templates for articles, reports, letters, presentations, and CVs. Features syntax highlighting, auto-save, and 100% client-side processing for privacy.</p>
        </div>
        <div class="tool-description-ad">
            <%@ include file="modern/ads/ad-in-content-top.jsp" %>
        </div>
    </section>

    <!-- Main Tool Area -->
    <main class="tool-page-container">
        <!-- INPUT COLUMN: Editor -->
        <div class="tool-input-column">
            <div class="tool-card" style="display:flex;flex-direction:column;">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/><path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/></svg>
                    LaTeX Source
                </div>

                <!-- Toolbar -->
                <div class="tool-actions-bar">
                    <select id="templateSelect" class="latex-template-select" aria-label="Select template">
                        <option value="">Template...</option>
                        <option value="article">Article</option>
                        <option value="report">Report</option>
                        <option value="letter">Letter</option>
                        <option value="beamer">Presentation</option>
                        <option value="exam">Exam</option>
                        <option value="cv">CV/Resume</option>
                    </select>

                    <button id="btn-compile" class="tool-btn tool-btn-primary" aria-label="Compile">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="m11.596 8.697-6.363 3.692c-.54.313-1.233-.066-1.233-.697V4.308c0-.63.692-1.01 1.233-.696l6.363 3.692a.802.802 0 0 1 0 1.393z"/></svg>
                        Compile
                    </button>

                    <button id="btn-clear" class="tool-btn" aria-label="Clear">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/></svg>
                        Clear
                    </button>

                    <div class="tool-actions-spacer"></div>

                    <label class="tool-checkbox">
                        <input type="checkbox" id="autoCompile" checked>
                        Auto
                    </label>
                </div>

                <!-- Editor -->
                <div class="tool-card-body" style="padding:0;flex:1;display:flex;flex-direction:column;">
                    <div class="latex-editor-wrapper">
                        <textarea id="latexEditor" style="display:none;"></textarea>
                    </div>
                </div>

                <!-- File Actions -->
                <div class="tool-actions-bar" style="border-top: 1px solid var(--border);">
                    <button id="btn-download-pdf" class="tool-btn tool-btn-sm tool-btn-primary" aria-label="Download PDF">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>
                        PDF
                    </button>
                    <button id="btn-copy-latex" class="tool-btn tool-btn-sm" aria-label="Copy LaTeX">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/><path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/></svg>
                        Copy
                    </button>
                    <button id="btn-download-tex" class="tool-btn tool-btn-sm" aria-label="Download .tex">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>
                        .tex
                    </button>

                    <span class="tool-actions-divider"></span>

                    <button id="btn-save" class="tool-btn tool-btn-sm" aria-label="Save" title="Save to browser">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M2 1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H9.5a1 1 0 0 0-1 1v7.293l2.646-2.647a.5.5 0 0 1 .708.708l-3.5 3.5a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L7.5 9.293V2a2 2 0 0 1 2-2H14a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h2.5a.5.5 0 0 1 0 1H2z"/></svg>
                        Save
                    </button>
                    <button id="btn-load" class="tool-btn tool-btn-sm" aria-label="Load" title="Load saved documents">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M9.828 3h3.982a2 2 0 0 1 1.992 2.181l-.637 7A2 2 0 0 1 13.174 14H2.825a2 2 0 0 1-1.991-1.819l-.637-7a1.99 1.99 0 0 1 .342-1.31L.5 3a2 2 0 0 1 2-2h3.672a2 2 0 0 1 1.414.586l.828.828A2 2 0 0 0 9.828 3zm-8.322.12C1.72 3.042 1.95 3 2.19 3h5.396l-.707-.707A1 1 0 0 0 6.172 2H2.5a1 1 0 0 0-1 .981l.006.139z"/></svg>
                        Load
                    </button>

                    <div class="tool-actions-spacer"></div>

                    <span id="autoSaveStatus" style="font-size:0.75rem;color:var(--text-secondary);">
                        <svg width="10" height="10" fill="#10b981" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg>
                        Saved
                    </span>
                </div>

                <!-- Status Bar -->
                <div class="latex-status-bar">
                    <div>
                        <span id="lineCount">Lines: 0</span> |
                        <span id="wordCount">Words: 0</span> |
                        <span id="charCount">Chars: 0</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- OUTPUT COLUMN: Preview -->
        <div class="tool-output-column">
            <div class="tool-card" style="flex:1;display:flex;flex-direction:column;">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M10.5 8.5a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/><path d="M2 4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2h-1.172a2 2 0 0 1-1.414-.586l-.828-.828A2 2 0 0 0 9.172 2H6.828a2 2 0 0 0-1.414.586l-.828.828A2 2 0 0 1 3.172 4H2zm.5 2a.5.5 0 1 1 0-1 .5.5 0 0 1 0 1zm9 2.5a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0z"/></svg>
                    Live Preview
                    <div class="tool-live-indicator" style="margin-left:auto;">
                        <span class="tool-live-dot"></span> Ready
                    </div>
                </div>

                <!-- Preview -->
                <div class="tool-output-wrapper" style="flex:1;position:relative;">
                    <div class="latex-loading" id="loading-overlay">
                        <div class="latex-spinner" role="status" aria-hidden="true"></div>
                        <span style="font-size:0.875rem;color:var(--text-secondary);">Compiling...</span>
                    </div>
                    <div class="latex-preview-content" id="previewContent">
                        <div class="latex-content">
                            <div style="text-align:center;padding:3rem;color:var(--text-secondary);">
                                <svg width="48" height="48" fill="currentColor" opacity="0.3" viewBox="0 0 16 16"><path d="M9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.5L9.5 0zm0 1v2A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5z"/></svg>
                                <p style="margin-top:1rem;">Select a template or start typing to see preview...</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ADS COLUMN -->
        <aside class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </aside>

    </main>

    <!-- Mobile Ad (hidden on desktop) -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="latex-document-editor.jsp"/>
        <jsp:param name="category" value="Mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- About Section -->
    <section class="tool-content-section">
        <div class="tool-content-container">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/></svg>
                    About LaTeX Document Editor
                </div>
                <div class="tool-card-body">
                    <h2 class="tool-section-title">Professional LaTeX Editor for Documents</h2>
                    <p>Create professional LaTeX documents directly in your browser without any installation. Perfect for academic papers, research articles, reports, presentations, CVs, and more.</p>

                    <h3 class="tool-subsection-title">Key Features</h3>
                    <ul class="tool-feature-list">
                        <li><strong>Live Preview:</strong> See your document rendered in real-time as you type</li>
                        <li><strong>PDF Export:</strong> Download your finished document as a professional PDF file</li>
                        <li><strong>Template Library:</strong> Pre-built templates for articles, reports, letters, presentations, exams, and CVs</li>
                        <li><strong>Syntax Highlighting:</strong> CodeMirror-powered editor with LaTeX syntax highlighting</li>
                        <li><strong>Auto-Save:</strong> Your work is automatically saved to browser storage</li>
                        <li><strong>Math Support:</strong> Full mathematical equation support via KaTeX</li>
                        <li><strong>100% Private:</strong> All processing happens in your browser - no data uploaded</li>
                    </ul>

                    <h3 class="tool-subsection-title">Supported LaTeX Features</h3>
                    <ul class="tool-feature-list">
                        <li>Document classes: article, report, book, letter, beamer</li>
                        <li>Mathematical equations (inline and display)</li>
                        <li>Sections, subsections, paragraphs</li>
                        <li>Lists (itemize, enumerate, description)</li>
                        <li>Tables and figures</li>
                        <li>Text formatting (bold, italic, underline)</li>
                        <li>Bibliographies and citations</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- E-E-A-T Section -->
    <section class="tool-content-section">
        <div class="tool-content-container">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 0c-.69 0-1.843.265-2.928.56-1.11.3-2.229.655-2.887.87a1.54 1.54 0 0 0-1.044 1.262c-.596 4.477.787 7.795 2.465 9.99a11.777 11.777 0 0 0 2.517 2.453c.386.273.744.482 1.048.625.28.132.581.24.829.24s.548-.108.829-.24a7.159 7.159 0 0 0 1.048-.625 11.775 11.775 0 0 0 2.517-2.453c1.678-2.195 3.061-5.513 2.465-9.99a1.541 1.541 0 0 0-1.044-1.263 62.467 62.467 0 0 0-2.887-.87C9.843.266 8.69 0 8 0zm0 5a1.5 1.5 0 0 1 .5 2.915l.385 1.99a.5.5 0 0 1-.491.595h-.788a.5.5 0 0 1-.49-.595l.384-1.99A1.5 1.5 0 0 1 8 5z"/></svg>
                    Trust & Privacy
                </div>
                <div class="tool-card-body">
                    <p>This LaTeX editor uses client-side rendering powered by LaTeX.js and KaTeX. All processing happens in your browser - your documents are never uploaded to any server.</p>

                    <h3 class="tool-subsection-title">Privacy Commitment</h3>
                    <ul class="tool-feature-list">
                        <li><strong>No Server Upload:</strong> All LaTeX compilation happens in your browser</li>
                        <li><strong>Zero Data Collection:</strong> We don't track, store, or analyze your documents</li>
                        <li><strong>Session Storage Only:</strong> Saved documents stay on your device only</li>
                        <li><strong>Open Source Libraries:</strong> Built with LaTeX.js, KaTeX, CodeMirror</li>
                    </ul>

                    <h3 class="tool-subsection-title">References</h3>
                    <ul class="tool-feature-list">
                        <li><a href="https://latex.js.org/" rel="nofollow noopener" target="_blank">LaTeX.js Documentation</a></li>
                        <li><a href="https://katex.org/" rel="nofollow noopener" target="_blank">KaTeX - Fast Math Typesetting</a></li>
                        <li><a href="https://codemirror.net/" rel="nofollow noopener" target="_blank">CodeMirror Editor</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>

    <!-- Sticky Footer Ad -->
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- CodeMirror -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/stex/stex.min.js"></script>

    <!-- KaTeX -->
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js"></script>

    <!-- LaTeX.js -->
    <script src="https://cdn.jsdelivr.net/npm/latex.js@0.12.6/dist/latex.min.js"></script>

    <!-- html2pdf.js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

    <!-- Tool Utilities -->
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <!-- LaTeX Editor JS -->
    <script src="<%=request.getContextPath()%>/js/latex-document-editor.js"></script>

</body>
</html>
