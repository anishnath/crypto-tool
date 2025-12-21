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
        <jsp:param name="toolName" value="TikZ Viewer & Editor Online - Free LaTeX Diagram Tool" />
        <jsp:param name="toolDescription" value="Create and render TikZ diagrams online for free. Professional LaTeX TikZ editor with syntax highlighting, real-time preview, and export to PNG, SVG, PDF. Draw graphs, flowcharts, circuits, 3D diagrams instantly." />
        <jsp:param name="toolCategory" value="Math" />
        <jsp:param name="toolUrl" value="tikz-viewer.jsp" />
        <jsp:param name="toolKeywords" value="TikZ viewer, TikZ editor online, LaTeX diagrams, TikZ pictures, tikzpicture editor, LaTeX graphics, online diagram tool, TikZ to PNG, TikZ to SVG, TikZ to PDF, flowchart maker, graph editor, circuit diagram tool, mathematical diagrams, geometry diagrams, free TikZ tool" />
        <jsp:param name="toolImage" value="tikz-tool.png" />
        <jsp:param name="toolFeatures" value="Real-time TikZ rendering,Syntax highlighting with CodeMirror,26+ example templates,Export to PNG SVG PDF,Custom TikZ library support,Auto-render mode,Zoom controls,Share via URL" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is TikZ and how does this viewer work?" />
        <jsp:param name="faq1a" value="TikZ is a LaTeX package for creating graphics programmatically. This viewer renders your TikZ code in the browser using TikZJax - no LaTeX installation required." />
        <jsp:param name="faq2q" value="Can I export my TikZ diagrams?" />
        <jsp:param name="faq2a" value="Yes, export to PNG (high resolution), SVG (vector), or PDF formats with one click." />
        <jsp:param name="faq3q" value="Is this TikZ editor free?" />
        <jsp:param name="faq3a" value="Yes, completely free with no registration. All rendering happens in your browser for privacy." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/codemirror.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/theme/monokai.min.css">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

    <style>
        /* TikZ Tool Theme Variables */
        :root {
            --tool-primary: #6366f1;
            --tool-primary-dark: #4f46e5;
            --tool-gradient: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            --tool-light: #f0f4ff;
        }

        [data-theme="dark"] {
            --tool-gradient: linear-gradient(135deg, #818cf8 0%, #6366f1 100%);
            --tool-light: rgba(99, 102, 241, 0.15);
        }

        /* CodeMirror Container */
        .tikz-editor-wrapper {
            border: none;
            border-radius: 0;
        }

        .tikz-editor-wrapper .CodeMirror {
            height: 450px;
            font-size: 13px;
            font-family: 'JetBrains Mono', 'Fira Code', monospace;
            border: none;
            background: var(--bg-primary, #fff);
            color: #1e293b;
        }

        /* CodeMirror syntax highlighting - light mode */
        .tikz-editor-wrapper .CodeMirror .cm-keyword { color: #7c3aed; }
        .tikz-editor-wrapper .CodeMirror .cm-atom { color: #0891b2; }
        .tikz-editor-wrapper .CodeMirror .cm-number { color: #059669; }
        .tikz-editor-wrapper .CodeMirror .cm-def { color: #2563eb; }
        .tikz-editor-wrapper .CodeMirror .cm-variable { color: #1e293b; }
        .tikz-editor-wrapper .CodeMirror .cm-property { color: #0891b2; }
        .tikz-editor-wrapper .CodeMirror .cm-operator { color: #64748b; }
        .tikz-editor-wrapper .CodeMirror .cm-comment { color: #94a3b8; font-style: italic; }
        .tikz-editor-wrapper .CodeMirror .cm-string { color: #059669; }
        .tikz-editor-wrapper .CodeMirror .cm-bracket { color: #475569; }
        .tikz-editor-wrapper .CodeMirror .cm-tag { color: #dc2626; }
        .tikz-editor-wrapper .CodeMirror .cm-attribute { color: #7c3aed; }
        .tikz-editor-wrapper .CodeMirror .CodeMirror-cursor { border-left-color: #1e293b; }
        .tikz-editor-wrapper .CodeMirror .CodeMirror-gutters {
            background: #f1f5f9;
            border-right: 1px solid #e2e8f0;
        }
        .tikz-editor-wrapper .CodeMirror .CodeMirror-linenumber { color: #94a3b8; }

        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror {
            background: #1e293b;
            color: #e2e8f0;
        }

        /* CodeMirror syntax highlighting - dark mode */
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-keyword { color: #a78bfa; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-atom { color: #22d3ee; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-number { color: #34d399; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-def { color: #60a5fa; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-variable { color: #e2e8f0; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-property { color: #22d3ee; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-operator { color: #94a3b8; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-comment { color: #64748b; font-style: italic; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-string { color: #34d399; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-bracket { color: #94a3b8; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-tag { color: #f87171; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .cm-attribute { color: #a78bfa; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .CodeMirror-cursor { border-left-color: #e2e8f0; }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .CodeMirror-gutters {
            background: #0f172a;
            border-right: 1px solid #334155;
        }
        [data-theme="dark"] .tikz-editor-wrapper .CodeMirror .CodeMirror-linenumber { color: #64748b; }

        /* Viewer iframe - always white background for TikZ diagrams (black on transparent) */
        .tikz-viewer-frame {
            width: 100%;
            height: 450px;
            border: none;
            background: #ffffff !important;
        }

        /* Zoom Controls */
        .tikz-zoom-controls {
            position: absolute;
            bottom: 1rem;
            right: 1rem;
            display: flex;
            gap: 0.25rem;
            background: var(--bg-primary, #fff);
            padding: 0.375rem;
            border-radius: 0.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            border: 1px solid var(--border, #e2e8f0);
            z-index: 10;
        }

        .tikz-zoom-controls button {
            width: 32px;
            height: 32px;
            border: 1px solid var(--border, #e2e8f0);
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            border-radius: 0.375rem;
            cursor: pointer;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.15s;
        }

        .tikz-zoom-controls button:hover {
            border-color: var(--tool-primary);
            color: var(--tool-primary);
        }

        .tikz-zoom-level {
            padding: 0 0.5rem;
            font-size: 0.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            color: var(--text-primary);
        }

        /* Loading overlay */
        .tikz-loading {
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

        .tikz-loading.show {
            display: flex;
        }

        [data-theme="dark"] .tikz-loading {
            background: rgba(15, 23, 42, 0.95);
        }

        /* Custom spinner */
        .tikz-spinner {
            width: 40px;
            height: 40px;
            border: 3px solid var(--border, #e2e8f0);
            border-top-color: var(--tool-primary, #6366f1);
            border-radius: 50%;
            animation: tikzSpin 0.8s linear infinite;
        }

        @keyframes tikzSpin {
            to { transform: rotate(360deg); }
        }

        .tikz-loading-text {
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text-secondary, #64748b);
        }

        [data-theme="dark"] .tikz-spinner {
            border-color: var(--border, #334155);
            border-top-color: var(--tool-primary, #818cf8);
        }

        [data-theme="dark"] .tikz-loading-text {
            color: var(--text-secondary, #94a3b8);
        }

        /* Hint box */
        .tikz-hint {
            padding: 0.75rem 1rem;
            background: var(--tool-light);
            border-left: 3px solid var(--tool-primary);
            font-size: 0.8125rem;
            color: var(--text-secondary);
        }

        .tikz-hint strong {
            color: var(--tool-primary);
        }

        .tikz-hint code {
            background: rgba(99, 102, 241, 0.1);
            padding: 0.125rem 0.375rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
        }

        /* Error message */
        .tikz-error {
            display: none;
            padding: 0.75rem 1rem;
            background: #fef2f2;
            border-left: 3px solid #ef4444;
            color: #991b1b;
            font-size: 0.8125rem;
        }

        [data-theme="dark"] .tikz-error {
            background: rgba(239, 68, 68, 0.1);
            color: #fca5a5;
        }

        /* Viewer container - always white background for TikZ diagrams */
        .tikz-viewer-container {
            position: relative;
            min-height: 450px;
            background: #ffffff;
            border-radius: 0 0 0.75rem 0.75rem;
        }

        /* Examples dropdown - hidden by default, shown on click */
        .tikz-examples-menu {
            display: none;
            position: absolute;
            z-index: 1000;
            max-height: 400px;
            overflow-y: auto;
            min-width: 280px;
            padding: 0;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
            background: var(--bg-primary, #fff);
            list-style: none;
            margin: 0.25rem 0 0 0;
        }

        .tikz-examples-menu.show {
            display: block;
        }

        .tikz-examples-menu li {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        [data-theme="dark"] .tikz-examples-menu {
            background: var(--bg-secondary, #1e293b);
            border-color: var(--border, #334155);
        }

        .tikz-examples-menu .example-category {
            padding: 0.625rem 1rem;
            font-size: 0.6875rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--tool-primary);
            background: var(--tool-light);
            border-bottom: 1px solid var(--border, #e2e8f0);
            margin: 0;
        }

        .tikz-examples-menu .example-item {
            display: block;
            padding: 0.625rem 1rem;
            font-size: 0.8125rem;
            cursor: pointer;
            border-bottom: 1px solid var(--border, #e2e8f0);
            transition: all 0.15s;
            color: var(--text-primary, #0f172a);
            text-decoration: none;
        }

        .tikz-examples-menu li:last-child .example-item {
            border-bottom: none;
        }

        .tikz-examples-menu .example-item:hover {
            background: var(--tool-light);
            color: var(--tool-primary);
        }

        [data-theme="dark"] .tikz-examples-menu .example-item {
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .tikz-examples-menu .example-item:hover {
            background: rgba(99, 102, 241, 0.15);
        }

        /* Dark mode: visual border around viewer in dark theme */
        [data-theme="dark"] .tikz-viewer-container {
            border: 1px solid var(--border, #334155);
            border-top: none;
        }

        /* Toolbar divider */
        .tool-actions-divider {
            width: 1px;
            height: 20px;
            background: var(--border, #e2e8f0);
            margin: 0 0.25rem;
        }

        [data-theme="dark"] .tool-actions-divider {
            background: var(--border, #334155);
        }

        /* Content sections (write-ups) */
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

        .tool-feature-list,
        .tool-steps-list {
            padding-left: 1.25rem;
            margin-bottom: 1rem;
        }

        .tool-feature-list li,
        .tool-steps-list li {
            margin-bottom: 0.5rem;
            color: var(--text-secondary, #475569);
            line-height: 1.6;
        }

        .tool-feature-list li strong,
        .tool-steps-list li strong {
            color: var(--text-primary, #0f172a);
        }

        .tool-use-cases-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        @media (max-width: 600px) {
            .tool-use-cases-grid {
                grid-template-columns: 1fr;
            }
        }

        .tool-use-cases-grid ul {
            padding-left: 1.25rem;
            margin: 0;
        }

        .tool-use-cases-grid li {
            color: var(--text-secondary, #475569);
            margin-bottom: 0.375rem;
        }

        .tool-highlight-box {
            background: var(--tool-light, #f0f4ff);
            border-left: 4px solid var(--tool-primary, #6366f1);
            padding: 1rem 1.25rem;
            border-radius: 0.5rem;
            margin-top: 1.5rem;
            color: var(--text-secondary, #475569);
        }

        .tool-highlight-box strong {
            color: var(--tool-primary, #6366f1);
        }

        .tool-trust-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin: 1rem 0;
        }

        @media (max-width: 600px) {
            .tool-trust-grid {
                grid-template-columns: 1fr;
            }
        }

        .tool-trust-block ul {
            padding-left: 1.25rem;
            margin: 0;
        }

        .tool-trust-block li {
            color: var(--text-secondary, #475569);
            margin-bottom: 0.375rem;
        }

        .tool-references-list {
            padding-left: 1.25rem;
        }

        .tool-references-list li {
            margin-bottom: 0.375rem;
        }

        .tool-references-list a {
            color: var(--tool-primary, #6366f1);
            text-decoration: none;
        }

        .tool-references-list a:hover {
            text-decoration: underline;
        }

        .tool-content-section code {
            background: rgba(99, 102, 241, 0.1);
            padding: 0.125rem 0.375rem;
            border-radius: 0.25rem;
            font-size: 0.875rem;
            color: var(--tool-primary, #6366f1);
        }

        [data-theme="dark"] .tool-content-section .tool-card {
            background: var(--bg-secondary, #1e293b);
            border-color: var(--border, #334155);
        }

        [data-theme="dark"] .tool-highlight-box {
            background: rgba(99, 102, 241, 0.1);
        }

        [data-theme="dark"] .tool-section-title,
        [data-theme="dark"] .tool-subsection-title,
        [data-theme="dark"] .tool-feature-list li strong,
        [data-theme="dark"] .tool-steps-list li strong {
            color: var(--text-primary, #f1f5f9);
        }

        [data-theme="dark"] .tool-feature-list li,
        [data-theme="dark"] .tool-steps-list li,
        [data-theme="dark"] .tool-use-cases-grid li,
        [data-theme="dark"] .tool-trust-block li,
        [data-theme="dark"] .tool-highlight-box {
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
                <h1 class="tool-page-title">TikZ Viewer & Editor</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#devops">Devops Tools</a> /
                    <span>TikZ Viewer</span>
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
                <p>Create LaTeX TikZ diagrams instantly in your browser. Render, edit, and export to PNG/SVG/PDF with real-time preview, syntax highlighting, and 26+ example templates. No installation required!</p>
            </div>
            <div class="tool-description-ad">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <!-- Three-Column Layout -->
    <main class="tool-page-container">

        <!-- INPUT COLUMN: TikZ Editor -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path d="M6.854 4.646a.5.5 0 0 1 0 .708L4.207 8l2.647 2.646a.5.5 0 0 1-.708.708l-3-3a.5.5 0 0 1 0-.708l3-3a.5.5 0 0 1 .708 0zm2.292 0a.5.5 0 0 0 0 .708L11.793 8l-2.647 2.646a.5.5 0 0 0 .708.708l3-3a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708 0z"/></svg>
                    TikZ Editor
                </div>

                <!-- Toolbar -->
                <div class="tool-actions-bar">
                    <button id="btn-render" class="tool-btn tool-btn-primary" aria-label="Render TikZ diagram">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="m11.596 8.697-6.363 3.692c-.54.313-1.233-.066-1.233-.697V4.308c0-.63.692-1.01 1.233-.696l6.363 3.692a.802.802 0 0 1 0 1.393z"/></svg>
                        Render
                    </button>
                    <button id="btn-clear" class="tool-btn" aria-label="Clear editor">
                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/><path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/></svg>
                        Clear
                    </button>

                    <div class="tool-actions-spacer"></div>

                    <div class="dropdown">
                        <button class="tool-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zM2.5 2a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zm6.5.5A1.5 1.5 0 0 1 10.5 1h3A1.5 1.5 0 0 1 15 2.5v3A1.5 1.5 0 0 1 13.5 7h-3A1.5 1.5 0 0 1 9 5.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zM1 10.5A1.5 1.5 0 0 1 2.5 9h3A1.5 1.5 0 0 1 7 10.5v3A1.5 1.5 0 0 1 5.5 15h-3A1.5 1.5 0 0 1 1 13.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3zm6.5.5A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3zm1.5-.5a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3z"/></svg>
                            Examples
                        </button>
                        <ul class="dropdown-menu tikz-examples-menu" id="examples-menu"></ul>
                    </div>

                    <label class="tool-checkbox">
                        <input type="checkbox" id="auto-render">
                        Auto
                    </label>
                </div>

                <!-- Editor -->
                <div class="tool-card-body" style="padding: 0;">
                    <div class="tikz-editor-wrapper">
                        <textarea id="tikzInput" style="display:none;">\begin{tikzpicture}[scale=0.8]
  \draw[step=1cm,gray!30,very thin] (-3,-2) grid (5,5);
  \draw[->] (-3,0) -- (5,0) node[right] {$x$};
  \draw[->] (0,-2) -- (0,5) node[above] {$y$};
  \draw[thick,blue] (-2,-1) -- (4,4);
  \fill[red] (2,3) circle (2pt) node[above right] {$P(2,3)$};
\end{tikzpicture}</textarea>
                    </div>
                    <div id="errorMessage" class="tikz-error" role="alert"></div>
                </div>

                <!-- Hint -->
                <div class="tikz-hint">
                    <strong>Tip:</strong> Paste full LaTeX or just <code>\begin{tikzpicture}...\end{tikzpicture}</code>. We auto-extract the TikZ block.
                </div>

                <!-- File Actions -->
                <div class="tool-actions-bar" style="border-top: 1px solid var(--border);">
                    <button id="btn-copy-latex" class="tool-btn tool-btn-sm" aria-label="Copy LaTeX">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/><path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/></svg>
                        Copy
                    </button>
                    <button id="btn-download-tex" class="tool-btn tool-btn-sm" aria-label="Download .tex">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>
                        .tex
                    </button>
                    <label class="tool-btn tool-btn-sm" style="cursor:pointer;margin:0;">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 4.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 5.707V14.5a.5.5 0 0 1-1 0V5.707L5.354 7.854a.5.5 0 1 1-.708-.708l3-3z"/></svg>
                        Upload
                        <input id="input-upload-tex" type="file" accept=".tex,text/plain" style="display:none;">
                    </label>

                    <span class="tool-actions-divider"></span>

                    <button id="btn-save-local" class="tool-btn tool-btn-sm" aria-label="Save locally" title="Save to browser storage">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M2 1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H9.5a1 1 0 0 0-1 1v7.293l2.646-2.647a.5.5 0 0 1 .708.708l-3.5 3.5a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L7.5 9.293V2a2 2 0 0 1 2-2H14a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h2.5a.5.5 0 0 1 0 1H2z"/></svg>
                        Save
                    </button>
                    <button id="btn-load-local" class="tool-btn tool-btn-sm" aria-label="Load saved" title="Load from browser storage">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M9.828 3h3.982a2 2 0 0 1 1.992 2.181l-.637 7A2 2 0 0 1 13.174 14H2.825a2 2 0 0 1-1.991-1.819l-.637-7a1.99 1.99 0 0 1 .342-1.31L.5 3a2 2 0 0 1 2-2h3.672a2 2 0 0 1 1.414.586l.828.828A2 2 0 0 0 9.828 3zm-8.322.12C1.72 3.042 1.95 3 2.19 3h5.396l-.707-.707A1 1 0 0 0 6.172 2H2.5a1 1 0 0 0-1 .981l.006.139z"/></svg>
                        Load
                    </button>
                    <button id="btn-manage-local" class="tool-btn tool-btn-sm" aria-label="Manage saved" title="Manage saved diagrams">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/></svg>
                        Manage
                    </button>

                    <div class="tool-actions-spacer"></div>

                    <label class="tool-checkbox">
                        <input type="checkbox" id="cmThemeToggle">
                        Dark
                    </label>
                </div>
            </div>
        </div>

        <!-- OUTPUT COLUMN: Rendered Preview -->
        <div class="tool-output-column">
            <div class="tool-card" style="flex:1;display:flex;flex-direction:column;">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M10.5 8.5a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/><path d="M2 4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2h-1.172a2 2 0 0 1-1.414-.586l-.828-.828A2 2 0 0 0 9.172 2H6.828a2 2 0 0 0-1.414.586l-.828.828A2 2 0 0 1 3.172 4H2zm.5 2a.5.5 0 1 1 0-1 .5.5 0 0 1 0 1zm9 2.5a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0z"/></svg>
                    Rendered Output
                    <div class="tool-live-indicator" style="margin-left:auto;">
                        <span class="tool-live-dot"></span> Ready
                    </div>
                </div>

                <!-- Export Actions -->
                <div class="tool-actions-bar">
                    <button id="btn-png" class="tool-btn tool-btn-sm" aria-label="Export PNG">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M6.002 5.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/><path d="M2.002 1a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2h-12zm12 1a1 1 0 0 1 1 1v6.5l-3.777-1.947a.5.5 0 0 0-.577.093l-3.71 3.71-2.66-1.772a.5.5 0 0 0-.63.062L1.002 12V3a1 1 0 0 1 1-1h12z"/></svg>
                        PNG
                    </button>
                    <button id="btn-svg" class="tool-btn tool-btn-sm" aria-label="Export SVG">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M0 0h1v15h15v1H0V0Zm14.817 3.113a.5.5 0 0 1 .07.704l-4.5 5.5a.5.5 0 0 1-.74.037L7.06 6.767l-3.656 5.027a.5.5 0 0 1-.808-.588l4-5.5a.5.5 0 0 1 .758-.06l2.609 2.61 4.15-5.073a.5.5 0 0 1 .704-.07Z"/></svg>
                        SVG
                    </button>
                    <button id="btn-pdf" class="tool-btn tool-btn-sm" aria-label="Export PDF">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M4 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H4zm0 1h8a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1z"/></svg>
                        PDF
                    </button>

                    <div class="tool-actions-spacer"></div>

                    <button id="btn-share" class="tool-btn tool-btn-sm" aria-label="Share URL">
                        <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16"><path d="M13.5 1a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3zM11 2.5a2.5 2.5 0 1 1 .603 1.628l-6.718 3.12a2.499 2.499 0 0 1 0 1.504l6.718 3.12a2.5 2.5 0 1 1-.488.876l-6.718-3.12a2.5 2.5 0 1 1 0-3.256l6.718-3.12A2.5 2.5 0 0 1 11 2.5zm-8.5 4a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3zm11 5.5a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3z"/></svg>
                        Share
                    </button>
                </div>

                <!-- Viewer -->
                <div class="tool-output-wrapper" style="flex:1;position:relative;">
                    <div class="tikz-viewer-container">
                        <div class="tikz-loading" id="loading-overlay">
                            <div class="tikz-spinner" role="status" aria-hidden="true"></div>
                            <span class="tikz-loading-text">Rendering TikZ diagram...</span>
                        </div>
                        <iframe id="viewer" class="tikz-viewer-frame" title="TikZ Output"></iframe>
                        <div class="tikz-zoom-controls">
                            <button id="btn-zoom-out" aria-label="Zoom out">-</button>
                            <span class="tikz-zoom-level" id="zoom-level">100%</span>
                            <button id="btn-zoom-in" aria-label="Zoom in">+</button>
                            <button id="btn-zoom-reset" aria-label="Reset zoom">&#x21BA;</button>
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
        <jsp:param name="currentToolUrl" value="tikz-viewer.jsp"/>
        <jsp:param name="category" value="Mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- About TikZ Viewer Section -->
    <section class="tool-content-section">
        <div class="tool-content-container">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/></svg>
                    About TikZ Viewer
                </div>
                <div class="tool-card-body">
                    <h2 class="tool-section-title">Online LaTeX Diagram Editor</h2>
                    <p>Create stunning LaTeX TikZ diagrams directly in your browser with our free online TikZ viewer and editor. No LaTeX installation required! Whether you're a student, researcher, or educator, this tool makes it easy to design mathematical diagrams, flowcharts, graphs, circuits, and geometric figures.</p>

                    <h3 class="tool-subsection-title">Key Features</h3>
                    <ul class="tool-feature-list">
                        <li><strong>Real-Time Rendering:</strong> See your TikZ diagrams instantly as you type with auto-render mode</li>
                        <li><strong>Syntax Highlighting:</strong> Professional code editor with LaTeX/TikZ syntax highlighting powered by CodeMirror</li>
                        <li><strong>26+ Example Templates:</strong> Start quickly with pre-built examples including geometry, graphs, flowcharts, circuits, 3D diagrams, and animations</li>
                        <li><strong>Multiple Export Formats:</strong> Download your diagrams as PNG (high resolution), SVG (vector), or PDF files</li>
                        <li><strong>Custom TikZ Libraries:</strong> Load specialized TikZ libraries like arrows, shapes, circuits, 3D, patterns, and more</li>
                        <li><strong>Share Your Work:</strong> Generate shareable URLs to collaborate with others or save your diagrams for later</li>
                        <li><strong>Zoom Controls:</strong> Inspect your diagrams in detail with zoom functionality (50% to 300%)</li>
                        <li><strong>Copy to Clipboard:</strong> Easily copy your LaTeX code for use in papers, presentations, or documents</li>
                    </ul>

                    <h3 class="tool-subsection-title">Popular Use Cases</h3>
                    <div class="tool-use-cases-grid">
                        <ul>
                            <li>Mathematical diagrams and graphs</li>
                            <li>Flowcharts and algorithm visualization</li>
                            <li>Geometric figures and constructions</li>
                            <li>Network diagrams and trees</li>
                        </ul>
                        <ul>
                            <li>Circuit diagrams (electrical & logic gates)</li>
                            <li>3D diagrams and projections</li>
                            <li>Vector illustrations and animations</li>
                            <li>Academic papers and presentations</li>
                        </ul>
                    </div>

                    <h3 class="tool-subsection-title">How to Use</h3>
                    <ol class="tool-steps-list">
                        <li><strong>Enter TikZ Code:</strong> Type or paste your <code>\begin{tikzpicture}...\end{tikzpicture}</code> code in the editor</li>
                        <li><strong>Add Libraries (Optional):</strong> Use the Custom Preamble section to load TikZ libraries like <code>\usetikzlibrary{arrows,shapes}</code></li>
                        <li><strong>Render:</strong> Click the "Render" button or enable auto-render mode for real-time updates</li>
                        <li><strong>Export:</strong> Download your diagram as PNG, SVG, or PDF in the format you need</li>
                        <li><strong>Share:</strong> Use the "Share URL" button to generate a link to your diagram</li>
                    </ol>

                    <p class="tool-highlight-box"><strong>Why Choose Our TikZ Editor?</strong> Unlike desktop LaTeX editors that require full installation and setup, our online tool works instantly in any modern web browser. It's perfect for quick diagrams, learning TikZ syntax, or sharing visual concepts with colleagues. The tool is completely free, requires no registration, and processes everything locally in your browser for privacy and speed.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- E-E-A-T: Methodology & Trust Section -->
    <section class="tool-content-section">
        <div class="tool-content-container">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 0c-.69 0-1.843.265-2.928.56-1.11.3-2.229.655-2.887.87a1.54 1.54 0 0 0-1.044 1.262c-.596 4.477.787 7.795 2.465 9.99a11.777 11.777 0 0 0 2.517 2.453c.386.273.744.482 1.048.625.28.132.581.24.829.24s.548-.108.829-.24a7.159 7.159 0 0 0 1.048-.625 11.775 11.775 0 0 0 2.517-2.453c1.678-2.195 3.061-5.513 2.465-9.99a1.541 1.541 0 0 0-1.044-1.263 62.467 62.467 0 0 0-2.887-.87C9.843.266 8.69 0 8 0zm0 5a1.5 1.5 0 0 1 .5 2.915l.385 1.99a.5.5 0 0 1-.491.595h-.788a.5.5 0 0 1-.49-.595l.384-1.99A1.5 1.5 0 0 1 8 5z"/></svg>
                    About This Tool & Methodology
                </div>
                <div class="tool-card-body">
                    <p>This TikZ viewer uses client-side rendering powered by TikZJax to interpret <code>tikzpicture</code> code securely in your browser. CodeMirror provides syntax highlighting and editing features. Exports are produced from the rendered SVG/Canvas to PNG, SVG, or PDF using browser APIs and jsPDF.</p>

                    <div class="tool-trust-grid">
                        <div class="tool-trust-block">
                            <h3 class="tool-subsection-title">Authorship & Review</h3>
                            <ul>
                                <li><strong>Author:</strong> 8gwifi.org engineering team</li>
                                <li><strong>Reviewed by:</strong> Anish Nath (tools maintainer)</li>
                                <li><strong>Last updated:</strong> 2025-01-01</li>
                            </ul>
                        </div>
                        <div class="tool-trust-block">
                            <h3 class="tool-subsection-title">Trust & Privacy</h3>
                            <ul>
                                <li>Rendering happens locally; diagrams are not uploaded to our servers.</li>
                                <li>Share URLs only encode your TikZ content; you can remove them to keep diagrams private.</li>
                                <li>Questions? Contact us via <a href="<%=request.getContextPath()%>/contactus.jsp">Contact</a>.</li>
                            </ul>
                        </div>
                    </div>

                    <h3 class="tool-subsection-title">References</h3>
                    <ul class="tool-references-list">
                        <li><a href="https://tikz.dev/" rel="nofollow noopener" target="_blank">PGF/TikZ Manual</a></li>
                        <li><a href="https://github.com/kisonecat/tikzjax" rel="nofollow noopener" target="_blank">TikZJax</a></li>
                        <li><a href="https://codemirror.net/5/" rel="nofollow noopener" target="_blank">CodeMirror 5</a></li>
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/codemirror.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/mode/stex/stex.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/addon/edit/matchbrackets.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16/addon/edit/closebrackets.min.js"></script>

    <!-- jsPDF -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

    <!-- Tool Utilities -->
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <!-- TikZ Viewer JS -->
    <script src="<%=request.getContextPath()%>/js/tikz-viewer.js"></script>

</body>
</html>
