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
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://code.jquery.com">

    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root{--primary:#059669;--primary-dark:#047857;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
    </style>

    <%--
        SEO AUDIT — Title / Description / JSON-LD optimised for high CTR
        Based on GSC data (last 3 months): 80 clicks, 7124 impressions, 1.12% CTR, avg pos 9.24

        TOP REAL QUERIES (from GSC):
          "mermaid to ascii"            — 49 imp, 4.08% CTR, pos 8.67  ← highest-value
          "ascii to diagram converter"  — 28 imp, 7.14% CTR, pos 9.14
          (all other queries are long-tail below top-1000 threshold)

        STRATEGY: Title leads with "Mermaid to ASCII" intent + "Text to Diagram".
                  Description front-loads "convert text to ASCII diagrams" and "Mermaid alternative".
                  Position ~9 = bottom of page 1, where title/desc CTR matters most.

        TITLE  (toolName → 47 chars)
        Component: toolName < 50 AND no "|" → appends " | 8gwifi.org"
        Rendered:  "Text to ASCII Diagram - Mermaid Alternative | 8gwifi.org"  =  55 chars  ✓

        DESCRIPTION  (toolDescription → 96 chars)
        Category "Developer Tools" appends " Free, secure, client-side processing. No registration required." (63 chars)
        96 + 63 = 159 ≤ 160 → append fires ✓
        Rendered:  "Convert text to ASCII diagrams online. Free Mermaid to ASCII alternative. Export to PNG/SVG/PDF. Free, secure, client-side processing. No registration required."  (159 chars ✓)

        OG IMAGE  → logo.png (guaranteed; replace with screenshot once uploaded)

        SCHEMAS (6 total):
        1. WebApplication  — 11-item featureList, $0 offer
        2. BreadcrumbList  — Home > Developer Tools > Text to ASCII Diagram
        3. WebPage          — auto dateModified, SearchAction sitelinks
        4. HowTo            — 4 steps
        5. FAQPage          — 8 Q&A (rich snippet eligible)
        6. (LearningResource skipped — not math/science)
    --%>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="AI ASCII Diagram Generator - Describe in English, Get Diagrams" />
        <jsp:param name="toolDescription" value="AI-powered ASCII diagram generator. Describe your diagram in plain English and AI creates Graph-Easy notation. ASCII art flowcharts, architecture diagrams, system design. Export PNG/SVG/PDF." />
        <jsp:param name="toolCategory" value="Developer Tools" />
        <jsp:param name="toolUrl" value="graph-easy.jsp" />
        <jsp:param name="toolKeywords" value="ai ascii diagram, ai flowchart generator, ai text to diagram, ai architecture diagram, mermaid to ascii, ascii to diagram converter, text to ascii diagram, ai graph generator, mermaid alternative, graph easy online, ai system design diagram, diagram as code ai, ascii art diagram ai, plantuml alternative, graphviz online, readme diagram tool, free ai diagram tool" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="AI generates Graph-Easy notation from plain English,Text to ASCII flowchart conversion,Free Mermaid and PlantUML alternative,Export to PNG and SVG and PDF via Viz.js,Unicode box-drawing art output,GraphViz DOT export with live SVG preview,AI example prompts for CI/CD microservices git flow,Share diagrams via encoded URL,Keyboard shortcut Ctrl+Enter to render,Runs entirely in browser via WebAssembly,No signup and no data stored" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Describe your diagram|Type what you want in plain English like 'CI/CD pipeline with build test deploy' and click Generate,AI creates the notation|AI generates valid Graph-Easy syntax with nodes edges labels and groups automatically,Render and export|The diagram renders as ASCII art or Box Art. Export to PNG SVG or PDF. Share via URL" />
        <jsp:param name="faq1q" value="How does the AI diagram generator work?" />
        <jsp:param name="faq1a" value="Describe your diagram in plain English — like 'microservice architecture with API gateway' or 'git branching workflow' — and AI generates valid Graph-Easy notation with nodes, edges, labels, and groups. The diagram renders instantly as ASCII art. No need to learn the syntax." />
        <jsp:param name="faq2q" value="How do I convert Mermaid to ASCII text diagrams?" />
        <jsp:param name="faq2a" value="Mermaid does not output ASCII art natively. This tool is the best free Mermaid to ASCII alternative. Use AI to describe your diagram in English or write Graph-Easy notation like [A] -> [B]. The output works in terminals, README files, and plain-text docs. Export to PNG, SVG, and PDF too." />
        <jsp:param name="faq3q" value="How do I export a diagram to PNG, SVG, or PDF?" />
        <jsp:param name="faq3a" value="Select the GraphViz DOT output format and click Render. Export buttons for PNG, SVG, and PDF appear above the output. All rendering happens client-side via Viz.js with no upload required." />
        <jsp:param name="faq4q" value="Can AI generate architecture and system design diagrams?" />
        <jsp:param name="faq4a" value="Yes. Describe your architecture in English — like 'microservices with API gateway connecting to user service, order service, each with its own database' — and AI generates the complete Graph-Easy notation with groups, labeled edges, and proper structure." />
        <jsp:param name="faq5q" value="Can I paste the output into a GitHub README?" />
        <jsp:param name="faq5a" value="Yes. ASCII art output renders correctly on GitHub, GitLab, Bitbucket, and any plain-text viewer. Wrap in a fenced code block with triple backticks. No image hosting needed." />
        <jsp:param name="faq6q" value="Is it free?" />
        <jsp:param name="faq6a" value="Yes, completely free with no signup. AI diagram generation, rendering, editing, and export are all available immediately. The tool runs entirely in your browser via WebAssembly." />
        <jsp:param name="faq7q" value="What is the syntax for edge labels, groups, and styling?" />
        <jsp:param name="faq7a" value="Add labels: [A] -> { label: yes; } [B]. Styles: { style: dashed; }. Groups: ( Backend ). Or just describe what you want in English and let AI generate the syntax for you." />
        <jsp:param name="faq8q" value="How do I share a diagram?" />
        <jsp:param name="faq8a" value="Click Share to generate a URL that encodes your diagram. Anyone who opens the link sees it pre-loaded and auto-rendered. You can also copy ASCII output directly into Slack, email, Jira, or docs." />
    </jsp:include>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

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

    <%@ include file="modern/ads/ad-init.jsp" %>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

    <style>
        /* Graph-Easy Tool — green theme */
        :root {
            --tool-primary: #059669;
            --tool-primary-dark: #047857;
            --tool-gradient: linear-gradient(135deg, #059669 0%, #10b981 100%);
            --tool-light: #ecfdf5;
        }

        .tool-page-container { grid-template-columns: minmax(260px, 300px) 1fr 300px; }
        @media (max-width: 1024px) { .tool-page-container { grid-template-columns: minmax(250px, 300px) 1fr; } }

        /* Status bar */
        .ge-status-box {
            padding: 0.5rem 0.625rem;
            border-radius: 0.375rem;
            font-size: 0.6875rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        .ge-status-loading {
            background: #fff3cd;
            color: #856404;
        }
        .ge-status-ready {
            background: var(--tool-light);
            color: #155724;
        }
        .ge-status-error {
            background: #fef2f2;
            color: #991b1b;
        }
        [data-theme="dark"] .ge-status-loading { background: rgba(255,243,205,0.1); color: #fbbf24; }
        [data-theme="dark"] .ge-status-ready { background: rgba(5,150,105,0.1); color: #6ee7b7; }
        [data-theme="dark"] .ge-status-error { background: rgba(239,68,68,0.1); color: #fca5a5; }

        .ge-loader {
            display: inline-block;
            width: 12px;
            height: 12px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid var(--tool-primary);
            border-radius: 50%;
            animation: geSpin 1s linear infinite;
            flex-shrink: 0;
        }
        @keyframes geSpin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

        .ge-progress-bar {
            width: 100%;
            height: 3px;
            background: var(--border, #e2e8f0);
            border-radius: 2px;
            margin-top: 0.25rem;
            overflow: hidden;
            flex-basis: 100%;
        }
        .ge-progress-fill {
            height: 100%;
            background: var(--tool-gradient);
            border-radius: 2px;
            transition: width 0.3s ease;
            width: 0%;
        }

        /* Input textarea */
        #graphInput {
            width: 100%;
            min-height: 150px;
            padding: 0.5rem 0.625rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.375rem;
            font-family: 'JetBrains Mono', 'Monaco', 'Menlo', 'Consolas', monospace;
            font-size: 0.6875rem;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            resize: vertical;
            line-height: 1.45;
        }
        #graphInput:focus {
            outline: none;
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1);
        }

        /* Format select */
        .ge-select {
            width: 100%;
            padding: 0.375rem 0.5rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.375rem;
            font-size: 0.6875rem;
            font-family: inherit;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            cursor: pointer;
        }
        .ge-select:focus {
            outline: none;
            border-color: var(--tool-primary);
            box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1);
        }

        /* Output textarea */
        #graphOutput {
            width: 100%;
            min-height: 400px;
            padding: 0.75rem;
            border: 1.5px solid #334155;
            border-radius: 0.5rem;
            font-family: 'JetBrains Mono', 'Monaco', 'Menlo', 'Consolas', monospace;
            font-size: 0.8125rem;
            background: #1e1e1e;
            color: #00ff00;
            resize: vertical;
            line-height: 1.4;
        }
        [data-theme="dark"] #graphOutput {
            border-color: #475569;
        }

        /* HTML preview */
        .ge-html-preview {
            min-height: 400px;
            overflow: auto;
            padding: 1rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            background: var(--bg-primary, #fff);
        }

        /* SVG preview */
        .ge-svg-preview {
            min-height: 300px;
            overflow: auto;
            padding: 1rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            background: var(--bg-primary, #fff);
            margin-top: 0.75rem;
        }

        /* Render button */
        .ge-render-btn {
            width: 100%;
            padding: 0.5rem 0.75rem;
            border: none;
            border-radius: 0.375rem;
            background: var(--tool-gradient);
            color: #fff;
            font-size: 0.75rem;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.375rem;
        }
        .ge-render-btn:hover:not(:disabled) {
            opacity: 0.9;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(5, 150, 105, 0.3);
        }
        .ge-render-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Example chip buttons */
        .ge-examples-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 0.375rem;
            margin-top: 0.375rem;
        }
        .ge-example-chip {
            padding: 0.25rem 0.5rem;
            font-size: 0.6875rem;
            font-weight: 500;
            font-family: inherit;
            background: var(--bg-primary, #fff);
            border: 1.5px solid var(--border, #e2e8f0);
            color: var(--text-primary, #0f172a);
            border-radius: 0.375rem;
            cursor: pointer;
            transition: all 0.15s;
        }
        .ge-example-chip:hover {
            border-color: var(--tool-primary);
            background: var(--tool-light);
            color: var(--tool-primary);
        }
        [data-theme="dark"] .ge-example-chip {
            background: var(--bg-primary, #1e293b);
            border-color: var(--border, #334155);
            color: var(--text-primary, #e2e8f0);
        }
        [data-theme="dark"] .ge-example-chip:hover {
            border-color: #10b981;
            background: rgba(5,150,105,0.1);
            color: #6ee7b7;
        }

        /* Export buttons row */
        .ge-export-btns {
            display: none;
            gap: 0.375rem;
            flex-wrap: wrap;
        }
        .ge-export-btns.visible {
            display: flex;
        }
        .ge-export-btn {
            padding: 0.375rem 0.75rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.375rem;
            font-size: 0.75rem;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.15s;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
        }
        .ge-export-btn:hover {
            border-color: var(--tool-primary);
            background: var(--tool-light);
        }
        .ge-export-btn-png { color: #d97706; border-color: #d97706; }
        .ge-export-btn-png:hover { background: #fffbeb; }
        .ge-export-btn-svg { color: #0891b2; border-color: #0891b2; }
        .ge-export-btn-svg:hover { background: #ecfeff; }
        .ge-export-btn-pdf { color: #dc2626; border-color: #dc2626; }
        .ge-export-btn-pdf:hover { background: #fef2f2; }
        [data-theme="dark"] .ge-export-btn-png:hover { background: rgba(217,119,6,0.1); }
        [data-theme="dark"] .ge-export-btn-svg:hover { background: rgba(8,145,178,0.1); }
        [data-theme="dark"] .ge-export-btn-pdf:hover { background: rgba(220,38,38,0.1); }

        /* Action buttons (copy, share, toggle source) */
        .ge-action-btn {
            padding: 0.375rem 0.75rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.375rem;
            font-size: 0.75rem;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.15s;
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
        }
        .ge-action-btn:hover {
            border-color: var(--tool-primary);
            background: var(--tool-light);
        }
        .ge-action-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        [data-theme="dark"] .ge-action-btn {
            background: var(--bg-primary, #1e293b);
            border-color: var(--border, #334155);
            color: var(--text-primary, #e2e8f0);
        }
        .ge-share-btn {
            background: var(--tool-gradient);
            color: #fff;
            border: none;
        }
        .ge-share-btn:hover {
            opacity: 0.9;
            background: var(--tool-gradient);
            color: #fff;
        }

        /* Output toolbar */
        .ge-output-toolbar {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
            flex-wrap: wrap;
        }
        .ge-output-toolbar-spacer { flex: 1; }

        /* Section label */
        .ge-section-label {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.625rem;
            font-weight: 700;
            color: var(--text-secondary, #64748b);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin: 0.5rem 0 0.375rem 0;
            padding-bottom: 0.25rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
        }
        .ge-section-label:first-child { margin-top: 0; }

        .ge-form-group { margin-bottom: 0.5rem; }

        .ge-label {
            display: block;
            font-size: 0.6875rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.1875rem;
        }

        /* Syntax reference table */
        .ge-syntax-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.6875rem;
        }
        .ge-syntax-table th {
            background: var(--bg-secondary, #f8fafc);
            padding: 0.25rem 0.375rem;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid var(--border, #e2e8f0);
            color: var(--text-primary);
            font-size: 0.625rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
        .ge-syntax-table td {
            padding: 0.25rem 0.375rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
            color: var(--text-secondary);
        }
        .ge-syntax-table code {
            background: var(--bg-secondary, #f1f5f9);
            padding: 0.0625rem 0.25rem;
            border-radius: 0.1875rem;
            font-size: 0.6875rem;
            font-family: 'JetBrains Mono', monospace;
            color: var(--tool-primary);
        }
        [data-theme="dark"] .ge-syntax-table th {
            background: rgba(255,255,255,0.05);
        }
        [data-theme="dark"] .ge-syntax-table code {
            background: rgba(255,255,255,0.08);
            color: #6ee7b7;
        }

        /* Modal overlay */
        .ge-modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        .ge-modal-overlay.active { display: flex; }
        .ge-modal {
            background: var(--bg-primary, #fff);
            border-radius: 0.75rem;
            padding: 1.5rem;
            max-width: 600px;
            width: 90%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-height: 85vh;
            overflow-y: auto;
        }
        .ge-modal h3 {
            margin: 0 0 1rem 0;
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--text-primary);
        }
        .ge-modal-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            justify-content: flex-end;
        }
        .ge-modal-cancel {
            padding: 0.5rem 1rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            background: var(--bg-secondary, #f8fafc);
            color: var(--text-primary);
            cursor: pointer;
            font-family: inherit;
            font-size: 0.875rem;
            font-weight: 500;
        }
        .ge-modal-cancel:hover { background: var(--border, #e2e8f0); }
        .ge-modal-confirm {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 0.5rem;
            background: var(--tool-gradient);
            color: #fff;
            cursor: pointer;
            font-family: inherit;
            font-size: 0.875rem;
            font-weight: 600;
        }
        .ge-modal-confirm:hover { opacity: 0.9; }
        [data-theme="dark"] .ge-modal {
            background: var(--bg-primary, #1e293b);
        }
        [data-theme="dark"] .ge-modal-cancel {
            background: rgba(255,255,255,0.05);
            border-color: var(--border, #334155);
            color: var(--text-primary, #e2e8f0);
        }

        /* Export preview */
        .ge-export-preview {
            min-height: 200px;
            max-height: 400px;
            overflow: auto;
            padding: 1rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0.5rem;
            background: var(--bg-secondary, #f8fafc);
            text-align: center;
        }

        /* Export filename input */
        .ge-filename-row {
            display: flex;
            gap: 0;
        }
        .ge-filename-input {
            flex: 1;
            padding: 0.5rem 0.625rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-right: none;
            border-radius: 0.375rem 0 0 0.375rem;
            font-size: 0.8125rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--bg-primary, #fff);
            color: var(--text-primary);
        }
        .ge-filename-input:focus { outline: none; border-color: var(--tool-primary); }
        .ge-filename-ext {
            padding: 0.5rem 0.625rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: 0 0.375rem 0.375rem 0;
            font-size: 0.8125rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--bg-secondary, #f8fafc);
            color: var(--text-secondary);
        }

        /* Share URL input */
        .ge-share-url-row {
            display: flex;
            gap: 0;
        }
        .ge-share-url-input {
            flex: 1;
            padding: 0.5rem 0.625rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-right: none;
            border-radius: 0.375rem 0 0 0.375rem;
            font-size: 0.75rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--bg-primary, #fff);
            color: var(--text-primary);
        }
        .ge-share-url-copy {
            padding: 0.5rem 0.75rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-left: none;
            border-radius: 0 0.375rem 0.375rem 0;
            background: var(--bg-secondary, #f8fafc);
            color: var(--text-secondary);
            cursor: pointer;
            font-family: inherit;
            transition: all 0.15s;
        }
        .ge-share-url-copy:hover { background: var(--tool-light); color: var(--tool-primary); }

        /* Social share links */
        .ge-social-links {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        .ge-social-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.375rem 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.75rem;
            font-weight: 600;
            font-family: inherit;
            text-decoration: none;
            color: #fff;
            transition: opacity 0.15s;
        }
        .ge-social-btn:hover { opacity: 0.85; }
        .ge-social-twitter { background: #1DA1F2; }
        .ge-social-linkedin { background: #0077b5; }
        .ge-social-reddit { background: #ff4500; }
        .ge-social-hn { background: #ff6600; }
        .ge-social-email { background: #64748b; }

        /* Tool alert info */
        .ge-alert-info {
            padding: 0.75rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.8125rem;
            background: rgba(5,150,105,0.06);
            border: 1px solid rgba(5,150,105,0.15);
            color: var(--text-secondary);
        }
        [data-theme="dark"] .ge-alert-info {
            background: rgba(5,150,105,0.1);
            border-color: rgba(5,150,105,0.2);
            color: var(--text-secondary);
        }

        /* Comparison table */
        .ge-comparison-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.8125rem;
        }
        .ge-comparison-table th, .ge-comparison-table td {
            padding: 0.5rem 0.625rem;
            text-align: left;
            border-bottom: 1px solid var(--border, #e2e8f0);
        }
        .ge-comparison-table th {
            font-weight: 600;
            background: var(--bg-secondary, #f8fafc);
            color: var(--text-primary);
            font-size: 0.75rem;
        }
        .ge-comparison-table td { color: var(--text-secondary); }
        .ge-comparison-table .ge-highlight-col {
            background: var(--tool-light);
        }
        [data-theme="dark"] .ge-comparison-table th { background: rgba(255,255,255,0.05); }
        [data-theme="dark"] .ge-comparison-table .ge-highlight-col { background: rgba(5,150,105,0.08); }

        /* Format cards grid */
        .ge-format-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 0.75rem;
        }
        .ge-format-card {
            padding: 0.875rem;
            border-radius: 0.5rem;
            border: 1.5px solid;
        }
        .ge-format-card h4 {
            font-size: 0.875rem;
            margin: 0 0 0.375rem 0;
            text-align: center;
        }
        .ge-format-card p { font-size: 0.8125rem; margin: 0; }

        /* Persona cards */
        .ge-persona-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 0.75rem;
        }
        .ge-persona-card {
            text-align: center;
            padding: 0.875rem 0.5rem;
            border-radius: 0.5rem;
            background: var(--tool-light);
        }
        .ge-persona-card .ge-persona-icon {
            font-size: 1.5rem;
            margin-bottom: 0.25rem;
        }
        .ge-persona-card strong {
            display: block;
            font-size: 0.8125rem;
            color: var(--text-primary);
        }
        .ge-persona-card span {
            font-size: 0.75rem;
            color: var(--text-secondary);
        }
        [data-theme="dark"] .ge-persona-card { background: rgba(5,150,105,0.08); }

        /* FAQ */
        .faq-item { border: 1px solid var(--border, #e2e8f0); border-radius: 0.5rem; margin-bottom: 0.5rem; overflow: hidden; }
        .faq-question { padding: 0.75rem 1rem; font-weight: 600; font-size: 0.875rem; color: var(--text-primary, #0f172a); background: var(--bg-secondary, #f8fafc); border: none; width: 100%; cursor: pointer; display: flex; align-items: center; justify-content: space-between; gap: 0.75rem; font-family: inherit; text-align: left; }
        .faq-question:hover { background: var(--border, #f1f5f9); }
        .faq-answer { display: none; padding: 0.75rem 1rem; font-size: 0.8125rem; line-height: 1.6; color: var(--text-secondary, #475569); border-top: 1px solid var(--border, #e2e8f0); }
        .faq-item.open .faq-answer { display: block; }
        .faq-item.open .faq-chevron { transform: rotate(180deg); }
        .faq-chevron { transition: transform .2s; flex-shrink: 0; }
        [data-theme="dark"] .faq-question { background: rgba(255,255,255,0.05); color: var(--text-primary, #f1f5f9); }
        [data-theme="dark"] .faq-question:hover { background: rgba(255,255,255,0.08); }
        [data-theme="dark"] .faq-answer { color: var(--text-secondary, #cbd5e1); border-top-color: var(--border, #475569); }
        [data-theme="dark"] .faq-item { border-color: var(--border, #334155); }

        /* Code blocks in educational content */
        .ge-code-block {
            background: #1e293b;
            color: #e2e8f0;
            padding: 0.625rem 0.75rem;
            border-radius: 0.375rem;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.75rem;
            overflow-x: auto;
            white-space: pre;
            line-height: 1.5;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .tool-page-container { grid-template-columns: 1fr; }
        }

        @media (prefers-reduced-motion: reduce) {
            .ge-loader { animation: none; border-top-color: rgba(5,150,105,0.6); }
        }
    </style>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Graph-Easy ASCII Diagram Generator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#developer-tools">Developer Tools</a> /
                    Graph-Easy
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">ASCII Flowcharts</span>
                <span class="tool-badge">Mermaid Alternative</span>
                <span class="tool-badge">PNG/SVG/PDF Export</span>
                <span class="tool-badge">Browser-Based</span>
                <span class="tool-badge">No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Convert simple text notation into ASCII flowcharts, architecture diagrams, and graphs. Free Mermaid &amp; PlantUML alternative with PNG/SVG/PDF export. Runs entirely in your browser via WebAssembly &mdash; no server, no signup, no data stored.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ========== INPUT COLUMN ========== -->
        <div class="tool-input-column">
            <div class="tool-card" style="padding: 0.75rem;">

                <!-- Status Bar -->
                <div id="statusBox" class="ge-status-box ge-status-loading">
                    <span class="ge-loader"></span>
                    <span id="statusText">Loading Perl runtime (~4MB compressed)...</span>
                    <div class="ge-progress-bar">
                        <div id="progressFill" class="ge-progress-fill"></div>
                    </div>
                </div>

                <!-- AI: Describe in English -->
                <div style="margin-bottom:0.5rem;padding:0.6rem;background:linear-gradient(135deg,rgba(99,102,241,0.06),rgba(139,92,246,0.04));border:1px solid rgba(99,102,241,0.15);border-radius:0.375rem;">
                    <label style="display:flex;align-items:center;gap:0.3rem;font-size:0.7rem;font-weight:600;color:#6366f1;margin-bottom:0.35rem;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:12px;height:12px;"><path d="M12 2a4 4 0 014 4v1h1a3 3 0 010 6h-1v1a4 4 0 01-8 0v-1H7a3 3 0 010-6h1V6a4 4 0 014-4z"/><circle cx="9" cy="10" r="1" fill="currentColor" stroke="none"/><circle cx="15" cy="10" r="1" fill="currentColor" stroke="none"/></svg>
                        AI — describe your diagram
                    </label>
                    <div style="display:flex;gap:0.3rem;">
                        <input type="text" id="ge-ai-input" placeholder="e.g. CI/CD pipeline with build, test, deploy" autocomplete="off" spellcheck="false" style="flex:1;padding:0.35rem 0.5rem;border:1px solid var(--border);border-radius:0.25rem;font-size:0.75rem;background:var(--bg-primary);color:var(--text-primary);">
                        <button type="button" id="ge-ai-btn" style="padding:0.35rem 0.7rem;background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border:none;border-radius:0.25rem;font-size:0.7rem;font-weight:600;cursor:pointer;white-space:nowrap;">Generate</button>
                    </div>
                    <div id="ge-ai-status" style="display:none;margin-top:0.3rem;padding:0.25rem 0.4rem;border-radius:0.2rem;font-size:0.68rem;"></div>
                    <div style="display:flex;flex-wrap:wrap;gap:0.25rem;margin-top:0.4rem;">
                        <button type="button" class="ge-ai-chip" data-prompt="CI/CD pipeline: code commit, build, unit tests, integration tests, staging deploy, production deploy">CI/CD</button>
                        <button type="button" class="ge-ai-chip" data-prompt="microservice architecture: API gateway connects to user service, order service, payment service, each has its own database">microservices</button>
                        <button type="button" class="ge-ai-chip" data-prompt="git branching: main branch, develop branch, feature branch merges to develop, develop merges to main, hotfix from main">git flow</button>
                        <button type="button" class="ge-ai-chip" data-prompt="TCP three-way handshake: client sends SYN, server sends SYN-ACK, client sends ACK, connection established">TCP handshake</button>
                    </div>
                </div>

                <!-- Graph Notation Input -->
                <div class="ge-section-label">Graph Notation Input</div>
                <div class="ge-form-group">
                    <textarea id="graphInput" placeholder="Enter graph notation, or use AI above...&#10;Example: [A] -> [B] -> [C]">[ Start ] -> [ Process ] -> [ End ]
[ Process ] -> { style: dashed; } [ Error ]
[ Error ] -> [ Start ]</textarea>
                </div>

                <!-- Output Format -->
                <div class="ge-section-label">Output Format</div>
                <div class="ge-form-group">
                    <select class="ge-select" id="formatSelect">
                        <option value="ascii">ASCII Art</option>
                        <option value="boxart">Box Art (Unicode)</option>
                        <option value="html">HTML</option>
                        <option value="graphviz">GraphViz DOT</option>
                        <option value="txt">Text (re-parseable)</option>
                    </select>
                </div>

                <!-- Render Button -->
                <button class="ge-render-btn" id="renderBtn" disabled>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><polygon points="5,3 19,12 5,21"/></svg>
                    Render Graph
                </button>

                <!-- Examples -->
                <div class="ge-section-label" style="margin-top: 1rem;">Examples</div>
                <div class="ge-examples-grid">
                    <button class="ge-example-chip" data-example="simple">Simple</button>
                    <button class="ge-example-chip" data-example="flow">Flowchart</button>
                    <button class="ge-example-chip" data-example="cities">Cities</button>
                    <button class="ge-example-chip" data-example="bidi">Bidirectional</button>
                    <button class="ge-example-chip" data-example="labels">Edge Labels</button>
                    <button class="ge-example-chip" data-example="groups">Groups</button>
                    <button class="ge-example-chip" data-example="selfloop">Self Loop</button>
                    <button class="ge-example-chip" data-example="git">Git Flow</button>
                </div>

                <!-- Quick Syntax Reference -->
                <div class="ge-section-label" style="margin-top: 1rem;">Quick Syntax Reference</div>
                <table class="ge-syntax-table">
                    <thead>
                        <tr>
                            <th>Syntax</th>
                            <th>Description</th>
                            <th>Example</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>[ Node ]</code></td>
                            <td>Create a node</td>
                            <td><code>[ Server ]</code></td>
                        </tr>
                        <tr>
                            <td><code>-></code></td>
                            <td>Directed edge</td>
                            <td><code>[ A ] -> [ B ]</code></td>
                        </tr>
                        <tr>
                            <td><code><-></code></td>
                            <td>Bidirectional edge</td>
                            <td><code>[ A ] <-> [ B ]</code></td>
                        </tr>
                        <tr>
                            <td><code>--</code></td>
                            <td>Undirected edge</td>
                            <td><code>[ A ] -- [ B ]</code></td>
                        </tr>
                        <tr>
                            <td><code>{ label: text; }</code></td>
                            <td>Edge label</td>
                            <td><code>-> { label: yes; }</code></td>
                        </tr>
                        <tr>
                            <td><code>( Group )</code></td>
                            <td>Node group</td>
                            <td><code>( Frontend )</code></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <div class="tool-card" style="padding: 1rem;">

                <!-- Output Toolbar -->
                <div class="ge-output-toolbar">
                    <strong style="font-size: 0.875rem; color: var(--text-primary);">Rendered Output</strong>
                    <div class="ge-output-toolbar-spacer"></div>

                    <!-- DOT Export buttons (hidden by default) -->
                    <div id="dotExportBtns" class="ge-export-btns">
                        <button class="ge-export-btn ge-export-btn-png" id="exportPngBtn" title="Export as PNG">PNG</button>
                        <button class="ge-export-btn ge-export-btn-svg" id="exportSvgBtn" title="Export as SVG">SVG</button>
                        <button class="ge-export-btn ge-export-btn-pdf" id="exportPdfBtn" title="Export as PDF">PDF</button>
                    </div>

                    <button class="ge-action-btn" id="copyBtn" disabled title="Copy output">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
                        Copy
                    </button>
                    <button class="ge-action-btn ge-share-btn" id="shareBtn" title="Share this diagram">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
                        Share
                    </button>
                </div>

                <!-- Text output (ASCII, BoxArt, DOT, TXT) -->
                <textarea id="graphOutput" readonly placeholder="Rendered graph will appear here..."></textarea>

                <!-- HTML Preview (hidden by default) -->
                <div id="htmlPreviewContainer" style="display: none;">
                    <div style="margin-bottom: 0.5rem;">
                        <button class="ge-action-btn" id="toggleHtmlSource">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                            View Source
                        </button>
                    </div>
                    <div id="htmlPreview" class="ge-html-preview"></div>
                </div>

                <!-- SVG Preview for DOT export (hidden) -->
                <div id="svgPreviewContainer" style="display: none;">
                    <div id="svgPreview" class="ge-svg-preview"></div>
                </div>
            </div>

            <!-- Educational Content -->
            <div class="tool-card" style="padding: 1.5rem; margin-top: 1.25rem;">
                <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Understanding Graph-Easy</h2>

                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">What is Graph-Easy?</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1.25rem;">Graph-Easy is a Perl library that converts simple text notation into beautiful ASCII art diagrams. Originally created by Tels, it's widely used for documenting software architecture, creating flowcharts in documentation, and generating diagrams that can be embedded in plain text files like README files.</p>

                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Output Formats</h3>
                <div class="ge-format-grid" style="margin-bottom: 1.25rem;">
                    <div class="ge-format-card" style="background: #ecfdf5; border-color: #059669;">
                        <h4 style="color: #155724;">ASCII Art</h4>
                        <p style="color: #166534;">Classic text-based diagrams using +, -, |, and other ASCII characters. Works everywhere.</p>
                    </div>
                    <div class="ge-format-card" style="background: #ecfeff; border-color: #0891b2;">
                        <h4 style="color: #0c5460;">Box Art</h4>
                        <p style="color: #155e75;">Uses Unicode box-drawing characters for cleaner, professional-looking diagrams.</p>
                    </div>
                    <div class="ge-format-card" style="background: #fffbeb; border-color: #d97706;">
                        <h4 style="color: #92400e;">GraphViz DOT <span style="font-size:0.625rem;background:#d97706;color:#fff;padding:0.125rem 0.375rem;border-radius:1rem;vertical-align:middle;">Export</span></h4>
                        <p style="color: #78350f;">DOT format with <strong>PNG/SVG/PDF export</strong> via Viz.js rendering.</p>
                    </div>
                    <div class="ge-format-card" style="background: #eef2ff; border-color: #6366f1;">
                        <h4 style="color: #4338ca;">HTML <span style="font-size:0.625rem;background:#6366f1;color:#fff;padding:0.125rem 0.375rem;border-radius:1rem;vertical-align:middle;">Preview</span></h4>
                        <p style="color: #3730a3;">HTML table output with <strong>live preview</strong>. Toggle to view source code.</p>
                    </div>
                </div>

                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Common Use Cases</h3>
                <ul style="margin: 0 0 1.25rem 1.25rem; color: var(--text-secondary); font-size: 0.875rem; line-height: 1.8;">
                    <li><strong>Documentation:</strong> Create architecture diagrams that live alongside your code</li>
                    <li><strong>README files:</strong> Add visual flowcharts to project documentation</li>
                    <li><strong>System design:</strong> Quickly sketch component relationships</li>
                    <li><strong>Process flows:</strong> Document workflows and decision trees</li>
                    <li><strong>Git workflows:</strong> Visualize branching strategies</li>
                </ul>

                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Syntax Examples</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 0.75rem; margin-bottom: 1.25rem;">
                    <div>
                        <p style="font-size: 0.8125rem; font-weight: 600; margin-bottom: 0.25rem; color: var(--text-primary);">Simple Chain</p>
                        <div class="ge-code-block">[ Input ] -> [ Process ] -> [ Output ]</div>
                    </div>
                    <div>
                        <p style="font-size: 0.8125rem; font-weight: 600; margin-bottom: 0.25rem; color: var(--text-primary);">With Labels</p>
                        <div class="ge-code-block">[ Decision ] -> { label: yes; } [ Success ]
[ Decision ] -> { label: no; } [ Retry ]</div>
                    </div>
                    <div>
                        <p style="font-size: 0.8125rem; font-weight: 600; margin-bottom: 0.25rem; color: var(--text-primary);">Bidirectional</p>
                        <div class="ge-code-block">[ Client ] <-> [ Server ]
[ Server ] <-> [ Database ]</div>
                    </div>
                    <div>
                        <p style="font-size: 0.8125rem; font-weight: 600; margin-bottom: 0.25rem; color: var(--text-primary);">Groups</p>
                        <div class="ge-code-block">( Backend )
[ API ] -> [ Service ] -> [ DB ]</div>
                    </div>
                </div>

                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Graph-Easy vs Other Diagram Tools</h3>
                <div style="overflow-x: auto; margin-bottom: 1.25rem;">
                    <table class="ge-comparison-table">
                        <thead>
                            <tr>
                                <th>Feature</th>
                                <th class="ge-highlight-col"><strong>Graph-Easy</strong></th>
                                <th>Mermaid</th>
                                <th>PlantUML</th>
                                <th>ASCII Flow</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>ASCII Art Output</td>
                                <td class="ge-highlight-col"><strong>Native</strong></td>
                                <td>No</td>
                                <td>Limited</td>
                                <td>Yes</td>
                            </tr>
                            <tr>
                                <td>PNG/SVG Export</td>
                                <td class="ge-highlight-col">Yes</td>
                                <td>Yes</td>
                                <td>Yes</td>
                                <td>No</td>
                            </tr>
                            <tr>
                                <td>README Compatible</td>
                                <td class="ge-highlight-col"><strong>Perfect</strong></td>
                                <td>Needs render</td>
                                <td>Needs render</td>
                                <td>Yes</td>
                            </tr>
                            <tr>
                                <td>No Server Required</td>
                                <td class="ge-highlight-col">Browser only</td>
                                <td>Yes</td>
                                <td>Needs Java</td>
                                <td>Yes</td>
                            </tr>
                            <tr>
                                <td>Learning Curve</td>
                                <td class="ge-highlight-col"><strong>Easy</strong></td>
                                <td>Medium</td>
                                <td>Medium</td>
                                <td>Visual/Easy</td>
                            </tr>
                            <tr>
                                <td>Best For</td>
                                <td class="ge-highlight-col"><strong>Docs, README, Terminal</strong></td>
                                <td>Web docs, Markdown</td>
                                <td>UML, Complex diagrams</td>
                                <td>Quick sketches</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Who Uses This Tool?</h3>
                <div class="ge-persona-grid" style="margin-bottom: 1.25rem;">
                    <div class="ge-persona-card">
                        <div class="ge-persona-icon">&#128187;</div>
                        <strong>Developers</strong>
                        <span>README diagrams</span>
                    </div>
                    <div class="ge-persona-card">
                        <div class="ge-persona-icon">&#9881;&#65039;</div>
                        <strong>DevOps/SRE</strong>
                        <span>Architecture docs</span>
                    </div>
                    <div class="ge-persona-card">
                        <div class="ge-persona-icon">&#128218;</div>
                        <strong>Tech Writers</strong>
                        <span>Documentation</span>
                    </div>
                    <div class="ge-persona-card">
                        <div class="ge-persona-icon">&#127891;</div>
                        <strong>Students</strong>
                        <span>Flowcharts</span>
                    </div>
                </div>

                <div class="ge-alert-info">
                    <strong>Tips:</strong>
                    <ul style="margin: 0.375rem 0 0 1.25rem;">
                        <li>Press <kbd style="background:var(--bg-secondary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-size:0.8125rem;border:1px solid var(--border);">Ctrl</kbd>+<kbd style="background:var(--bg-secondary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-size:0.8125rem;border:1px solid var(--border);">Enter</kbd> (or <kbd style="background:var(--bg-secondary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-size:0.8125rem;border:1px solid var(--border);">Cmd</kbd>+<kbd style="background:var(--bg-secondary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-size:0.8125rem;border:1px solid var(--border);">Enter</kbd> on Mac) to quickly render your graph.</li>
                        <li>Select <strong>GraphViz DOT</strong> format to export your diagram as PNG, SVG, or PDF.</li>
                        <li>Select <strong>HTML</strong> format to see a live preview &mdash; toggle between preview and source code.</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- ========== ADS COLUMN ========== -->
        <div class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="graph-easy.jsp"/>
        <jsp:param name="category" value="Developer Tools"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- FAQ Section -->
    <section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Frequently Asked Questions</h2>
        <div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">What is Graph-Easy and how does it work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer"><p>Graph-Easy is a text-to-diagram tool that converts simple text notation into ASCII art flowcharts and graphs. Write [Node A] -> [Node B] and it automatically generates properly formatted diagrams with boxes, arrows, and connections. This tool runs the full Perl Graph-Easy library in your browser via WebAssembly.</p></div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">How do I convert Mermaid to ASCII text diagrams?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer"><p>Mermaid does not output ASCII art natively. Graph-Easy is the best free Mermaid to ASCII alternative. Rewrite your diagram in Graph-Easy notation like [A] -> [B] and select ASCII Art or Box Art format. The output works in terminals, README files, and plain-text docs. You can also export to PNG, SVG, and PDF just like Mermaid.</p></div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">Can I export diagrams to PNG, SVG, or PDF?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer"><p>Yes! Select 'GraphViz DOT' format, render your diagram, then use the PNG, SVG, or PDF export buttons. The tool uses Viz.js to convert DOT to high-resolution images entirely in your browser.</p></div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">How do I create architecture or system design diagrams?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer"><p>Use groups with parentheses like (Frontend) and (Backend) to organize components. Connect services with labeled edges: [API] -> { label: REST; } [Database]. This is perfect for documenting microservices, cloud architecture, and system designs.</p></div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">Can I use this for README documentation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer"><p>Absolutely! ASCII art output is perfect for README files since it displays correctly on GitHub, GitLab, and any plain text viewer. Copy the output directly into your markdown files without needing external image hosting.</p></div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">Does this tool work offline or require an account?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer"><p>No account required! The tool runs entirely in your browser using WebAssembly (Perl compiled to WASM). After the initial load, diagram generation works offline. Your data never leaves your browser.</p></div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">What's the syntax for edge labels and styling?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer"><p>Add labels with { label: text; } between nodes: [A] -> { label: yes; } [B]. For styling use { style: dashed; } or { style: bold; }. You can combine multiple attributes in one block. Use ( Group Name ) to group related nodes.</p></div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">How do I share my diagram with someone?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer"><p>Click the Share button to generate a URL that encodes your diagram notation. Anyone with the link will see your diagram pre-loaded and auto-rendered. You can also copy the ASCII output directly into emails, Slack, or documentation.</p></div>
            </div>
        </div>
    </section>

    <%@ include file="modern/components/support-section.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <!-- Export Modal -->
    <div class="ge-modal-overlay" id="exportModal">
        <div class="ge-modal">
            <h3>Export Graph</h3>
            <div class="ge-form-group">
                <label class="ge-label">Filename</label>
                <div class="ge-filename-row">
                    <input type="text" class="ge-filename-input" id="exportFilename" value="8gwifi-graph-data">
                    <span class="ge-filename-ext" id="exportExtension">.png</span>
                </div>
                <p style="font-size: 0.75rem; color: var(--text-secondary); margin-top: 0.25rem;">File will be saved as: <span id="fullFilename">8gwifi-graph-data.png</span></p>
            </div>
            <div class="ge-form-group">
                <label class="ge-label">Preview</label>
                <div id="exportPreview" class="ge-export-preview"></div>
            </div>
            <div class="ge-alert-info" style="margin-bottom: 0.75rem;">
                <span id="exportInfo">Your graph will be exported as a high-resolution image.</span>
            </div>
            <!-- Twitter Support Section -->
            <div style="text-align: center; padding: 0.875rem; border-radius: 0.5rem; background: var(--tool-light);">
                <p style="font-size: 0.8125rem; font-weight: 600; margin-bottom: 0.5rem;">Enjoying this free tool? Show your support!</p>
                <div class="ge-social-links">
                    <a href="https://twitter.com/anish2good" target="_blank" class="ge-social-btn ge-social-twitter">Follow @anish2good</a>
                    <a href="https://twitter.com/intent/tweet?text=Just%20created%20an%20awesome%20ASCII%20diagram%20using%20Graph-Easy%20tool%20by%20%40anish2good%20%F0%9F%9A%80%0A%0ACreate%20flowcharts%2C%20export%20to%20PNG%2FSVG%2FPDF%20-%20all%20in%20your%20browser!%0A%0Ahttps%3A%2F%2F8gwifi.org%2Fgraph-easy.jsp&hashtags=ASCII,DevTools,Diagrams" target="_blank" class="ge-social-btn" style="background: transparent; border: 1.5px solid #1DA1F2; color: #1DA1F2;">Tweet for Support</a>
                </div>
            </div>
            <div class="ge-modal-actions">
                <button type="button" class="ge-modal-cancel" onclick="document.getElementById('exportModal').classList.remove('active')">Cancel</button>
                <button type="button" class="ge-modal-confirm" id="confirmExportBtn">Download</button>
            </div>
        </div>
    </div>

    <!-- Share Modal -->
    <div class="ge-modal-overlay" id="shareModal">
        <div class="ge-modal">
            <h3>Share This Tool</h3>
            <div style="text-align: center; margin-bottom: 1.25rem;">
                <div style="font-size: 2rem; margin-bottom: 0.5rem;">&#128200;</div>
                <h4 style="font-size: 1rem; margin: 0 0 0.25rem 0; color: var(--text-primary);">Graph-Easy ASCII Diagram Generator</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary);">Free online text-to-diagram converter for flowcharts and architecture diagrams</p>
            </div>
            <div class="ge-form-group">
                <label class="ge-label">Share URL</label>
                <div class="ge-share-url-row">
                    <input type="text" class="ge-share-url-input" id="shareUrl" value="https://8gwifi.org/graph-easy.jsp" readonly>
                    <button class="ge-share-url-copy" id="copyShareUrl" title="Copy URL">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
                    </button>
                </div>
            </div>
            <!-- Twitter Section -->
            <div style="text-align: center; padding: 0.875rem; border-radius: 0.5rem; background: var(--tool-light); margin-bottom: 1rem;">
                <p style="font-size: 0.8125rem; font-weight: 600; margin-bottom: 0.5rem;">Support on Twitter</p>
                <div class="ge-social-links">
                    <a href="https://twitter.com/anish2good" target="_blank" class="ge-social-btn ge-social-twitter">Follow @anish2good</a>
                    <a href="https://twitter.com/intent/tweet?text=Just%20created%20an%20awesome%20ASCII%20diagram%20using%20Graph-Easy%20tool%20by%20%40anish2good%20%F0%9F%9A%80%0A%0ACreate%20flowcharts%2C%20export%20to%20PNG%2FSVG%2FPDF%20-%20all%20in%20your%20browser!%0A%0Ahttps%3A%2F%2F8gwifi.org%2Fgraph-easy.jsp&hashtags=ASCII,DevTools,Diagrams,Documentation" target="_blank" class="ge-social-btn" style="background: transparent; border: 1.5px solid #1DA1F2; color: #1DA1F2;">Tweet This Tool</a>
                </div>
                <p style="margin-top: 0.5rem; font-size: 0.75rem; color: var(--text-secondary);">Your support helps keep this tool free!</p>
            </div>
            <!-- Other Share Options -->
            <div style="margin-bottom: 0.75rem;">
                <p style="font-size: 0.75rem; color: var(--text-secondary); font-weight: 600; margin-bottom: 0.5rem;">More ways to share:</p>
                <div class="ge-social-links">
                    <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://8gwifi.org/graph-easy.jsp" target="_blank" class="ge-social-btn ge-social-linkedin" title="Share on LinkedIn">LinkedIn</a>
                    <a href="https://www.reddit.com/submit?url=https://8gwifi.org/graph-easy.jsp&title=Free%20ASCII%20Diagram%20Generator%20-%20Text%20to%20Flowchart" target="_blank" class="ge-social-btn ge-social-reddit" title="Share on Reddit">Reddit</a>
                    <a href="https://news.ycombinator.com/submitlink?u=https://8gwifi.org/graph-easy.jsp&t=Graph-Easy%20Online%20-%20Free%20ASCII%20Diagram%20Generator" target="_blank" class="ge-social-btn ge-social-hn" title="Share on Hacker News">HN</a>
                    <a href="mailto:?subject=Free%20ASCII%20Diagram%20Generator&body=Check%20out%20this%20free%20tool%20to%20create%20ASCII%20flowcharts%20and%20diagrams%3A%0A%0Ahttps%3A%2F%2F8gwifi.org%2Fgraph-easy.jsp" class="ge-social-btn ge-social-email" title="Share via Email">Email</a>
                </div>
            </div>
            <div class="ge-modal-actions">
                <button type="button" class="ge-modal-cancel" onclick="document.getElementById('shareModal').classList.remove('active')">Close</button>
            </div>
        </div>
    </div>

    <!-- FAQ toggle script -->
    <script>
        function toggleFaq(btn) {
            var item = btn.parentElement;
            item.classList.toggle('open');
        }
    </script>

    <!-- Click-outside-to-close modals -->
    <script>
        document.querySelectorAll('.ge-modal-overlay').forEach(function(overlay) {
            overlay.addEventListener('click', function(e) {
                if (e.target === overlay) {
                    overlay.classList.remove('active');
                }
            });
        });
    </script>

    <!-- Load Graph-Easy modules bundle -->
    <script src="graph-easy/graph-easy-modules.js?v=<%= System.currentTimeMillis() %>"></script>

    <!-- Setup script -->
    <script>
        // Example graphs
        const examples = {
            simple: '[ A ] -> [ B ] -> [ C ]',

            flow: `[ Start ] -> [ Input ]
[ Input ] -> [ Process ]
[ Process ] -> [ Decision ]
[ Decision ] -> { label: yes; } [ Output ]
[ Decision ] -> { label: no; } [ Process ]
[ Output ] -> [ End ]`,

            cities: `[ Bonn ] -> [ Berlin ]
[ Berlin ] -> [ Frankfurt ]
[ Frankfurt ] -> [ Dresden ]
[ Berlin ] -> [ Potsdam ]
[ Potsdam ] -> [ Cottbus ]
[ Cottbus ] -> [ Frankfurt ]`,

            bidi: `[ Client ] <-> [ Server ]
[ Server ] <-> [ Database ]
[ Client ] <-> [ Cache ]
[ Cache ] -> [ Database ]`,

            labels: `[ Alice ] -- sends request --> [ Server ]
[ Server ] -- queries --> [ Database ]
[ Database ] -- returns data --> [ Server ]
[ Server ] -- sends response --> [ Alice ]`,

            groups: `( Frontend )
[ React ] -> [ Redux ]
[ Redux ] -> [ API Client ]

( Backend )
[ Express ] -> [ MongoDB ]

[ API Client ] -> [ Express ]`,

            selfloop: `[ Retry ] -> [ Retry ]
[ Start ] -> [ Retry ]
[ Retry ] -> [ Success ]
[ Retry ] -> [ Failure ]`,

            git: `[ main ] -> [ feature ]
[ feature ] -> [ commit 1 ]
[ commit 1 ] -> [ commit 2 ]
[ commit 2 ] -> [ merge ]
[ main ] -> [ hotfix ]
[ hotfix ] -> [ merge ]
[ merge ] -> [ main ]`
        };

        // DOM elements
        const inputEl = document.getElementById('graphInput');
        const outputEl = document.getElementById('graphOutput');
        const statusBox = document.getElementById('statusBox');
        const statusText = document.getElementById('statusText');
        const progressFill = document.getElementById('progressFill');
        const renderBtn = document.getElementById('renderBtn');
        const copyBtn = document.getElementById('copyBtn');
        const formatSelect = document.getElementById('formatSelect');
        const htmlPreviewContainer = document.getElementById('htmlPreviewContainer');
        const htmlPreview = document.getElementById('htmlPreview');
        const toggleHtmlSourceBtn = document.getElementById('toggleHtmlSource');
        const dotExportBtns = document.getElementById('dotExportBtns');
        const svgPreviewContainer = document.getElementById('svgPreviewContainer');
        const svgPreview = document.getElementById('svgPreview');

        // State
        let perlReady = false;
        let vizLoaded = false;
        let vizInstance = null;
        let currentDotSource = '';
        let showingHtmlSource = false;

        // Toast notification
        function showToast(message) {
            if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
                ToolUtils.showToast(message);
            } else {
                var toast = $('<div style="position:fixed;bottom:1rem;right:1rem;z-index:9999;padding:0.75rem 1.25rem;background:linear-gradient(135deg,#059669,#10b981);color:#fff;border-radius:0.5rem;font-size:0.875rem;font-weight:500;box-shadow:0 4px 12px rgba(0,0,0,0.15);"></div>');
                toast.text(message);
                $('body').append(toast);
                setTimeout(function () { toast.fadeOut(function () { toast.remove(); }); }, 2000);
            }
        }

        // Update status
        function setStatus(message, type, progress) {
            statusBox.className = 'ge-status-box ge-status-' + type;
            if (type === 'loading') {
                statusBox.innerHTML = '<span class="ge-loader"></span><span id="statusText">' + message + '</span>' +
                    '<div class="ge-progress-bar"><div id="progressFill" class="ge-progress-fill" style="width:' + (progress || 0) + '%"></div></div>';
            } else {
                var icon = type === 'ready' ? '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color:#059669;flex-shrink:0;"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>' :
                    '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color:#dc2626;flex-shrink:0;"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>';
                statusBox.innerHTML = icon + '<span>' + message + '</span>';
            }
        }

        // Load modules into virtual filesystem
        function loadModulesToFS() {
            if (typeof FS === 'undefined') {
                console.error('FS not available yet');
                return false;
            }

            console.log('Loading Graph-Easy modules into virtual filesystem...');

            try { FS.mkdir('/lib'); } catch (e) { }

            const dirs = new Set();
            for (const modulePath of Object.keys(window.GraphEasyModules)) {
                const dir = modulePath.substring(0, modulePath.lastIndexOf('/'));
                if (dir) {
                    let current = '';
                    for (const part of dir.split('/')) {
                        current = current ? current + '/' + part : part;
                        dirs.add(current);
                    }
                }
            }

            for (const dir of Array.from(dirs).sort()) {
                try { FS.mkdir('/lib/' + dir); } catch (e) { }
            }

            for (const [modulePath, content] of Object.entries(window.GraphEasyModules)) {
                try {
                    FS.writeFile('/lib/' + modulePath, content);
                } catch (e) {
                    console.error('Failed to write:', modulePath, e);
                }
            }

            console.log('Graph-Easy modules loaded!');
            return true;
        }

        // JavaScript function called by Perl when ready
        window.graphEasyReady = function () {
            perlReady = true;
            setStatus('Ready! Enter graph notation and click "Render Graph".', 'ready');
            renderBtn.disabled = false;
            copyBtn.disabled = false;
        };

        // JavaScript function to render graph (calls Perl)
        window.renderGraphResult = function (output, error) {
            const format = formatSelect.value;

            // Reset all views
            outputEl.style.display = 'block';
            htmlPreviewContainer.style.display = 'none';
            dotExportBtns.classList.remove('visible');
            svgPreviewContainer.style.display = 'none';
            showingHtmlSource = false;
            toggleHtmlSourceBtn.innerHTML = '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg> View Source';

            if (error) {
                outputEl.value = 'Error: ' + error;
                setStatus('Error: ' + error.split('\n')[0], 'error');
                showToast('Rendering failed');
            } else {
                outputEl.value = output;

                // Handle HTML format - show live preview
                if (format === 'html') {
                    outputEl.style.display = 'none';
                    htmlPreviewContainer.style.display = 'block';
                    htmlPreview.innerHTML = output;
                    setStatus('HTML rendered! Click "View Source" to see the code.', 'ready');
                }
                // Handle GraphViz DOT format - enable export buttons
                else if (format === 'graphviz') {
                    currentDotSource = output;
                    dotExportBtns.classList.add('visible');
                    renderDotPreview(output);
                    setStatus('DOT generated! Use export buttons for PNG/SVG/PDF.', 'ready');
                }
                else {
                    setStatus('Rendered successfully!', 'ready');
                }
                showToast('Graph rendered!');
            }
        };

        // Toggle HTML source view
        toggleHtmlSourceBtn.addEventListener('click', function () {
            showingHtmlSource = !showingHtmlSource;
            if (showingHtmlSource) {
                outputEl.style.display = 'block';
                htmlPreview.style.display = 'none';
                toggleHtmlSourceBtn.innerHTML = '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg> View Preview';
            } else {
                outputEl.style.display = 'none';
                htmlPreview.style.display = 'block';
                toggleHtmlSourceBtn.innerHTML = '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg> View Source';
            }
        });

        // Load Viz.js for DOT rendering
        function loadVizJs(callback) {
            if (vizLoaded && vizInstance) {
                callback();
                return;
            }
            const script = document.createElement('script');
            script.src = 'https://cdn.jsdelivr.net/npm/@viz-js/viz@3.2.4/lib/viz-standalone.js';
            script.onload = function () {
                Viz.instance().then(function (viz) {
                    vizInstance = viz;
                    vizLoaded = true;
                    callback();
                });
            };
            script.onerror = function () {
                showToast('Failed to load Viz.js for export');
            };
            document.head.appendChild(script);
        }

        // Render DOT preview as SVG
        function renderDotPreview(dotSource) {
            loadVizJs(function () {
                try {
                    const svg = vizInstance.renderSVGElement(dotSource);
                    svgPreview.innerHTML = '';
                    svgPreview.appendChild(svg);
                    svgPreviewContainer.style.display = 'block';
                } catch (e) {
                    console.error('DOT render error:', e);
                    svgPreviewContainer.style.display = 'none';
                }
            });
        }

        // Export modal elements
        let currentExportType = 'png';
        const exportFilenameInput = document.getElementById('exportFilename');
        const exportExtension = document.getElementById('exportExtension');
        const fullFilenameSpan = document.getElementById('fullFilename');
        const exportPreviewDiv = document.getElementById('exportPreview');
        const exportInfoSpan = document.getElementById('exportInfo');

        // Update filename preview
        exportFilenameInput.addEventListener('input', function () {
            fullFilenameSpan.textContent = this.value + exportExtension.textContent;
        });

        // Show export modal
        function showExportModal(type) {
            if (!currentDotSource) {
                showToast('No DOT source to export');
                return;
            }

            currentExportType = type;
            const ext = '.' + type;
            exportExtension.textContent = ext;
            fullFilenameSpan.textContent = exportFilenameInput.value + ext;

            // Set info text based on type
            const infoTexts = {
                'png': 'Your graph will be exported as a high-resolution PNG image (2x scale for clarity).',
                'svg': 'Your graph will be exported as a scalable SVG vector graphic.',
                'pdf': 'Your graph will be exported as a PDF document.'
            };
            exportInfoSpan.textContent = infoTexts[type] || '';

            // Load preview
            loadVizJs(function () {
                try {
                    const svg = vizInstance.renderSVGElement(currentDotSource);
                    exportPreviewDiv.innerHTML = '';
                    exportPreviewDiv.appendChild(svg.cloneNode(true));
                } catch (e) {
                    exportPreviewDiv.innerHTML = '<p style="color:#dc2626;">Preview failed: ' + e.message + '</p>';
                }
            });

            document.getElementById('exportModal').classList.add('active');
        }

        // Export button click handlers - show modal
        document.getElementById('exportPngBtn').addEventListener('click', function () {
            showExportModal('png');
        });

        document.getElementById('exportSvgBtn').addEventListener('click', function () {
            showExportModal('svg');
        });

        document.getElementById('exportPdfBtn').addEventListener('click', function () {
            showExportModal('pdf');
        });

        // Confirm export button
        document.getElementById('confirmExportBtn').addEventListener('click', function () {
            const filename = exportFilenameInput.value || '8gwifi-graph-data';
            const fullFilename = filename + '.' + currentExportType;

            loadVizJs(function () {
                try {
                    const svg = vizInstance.renderSVGElement(currentDotSource);
                    const svgData = new XMLSerializer().serializeToString(svg);

                    if (currentExportType === 'svg') {
                        const blob = new Blob([svgData], { type: 'image/svg+xml' });
                        downloadBlob(blob, fullFilename);
                        document.getElementById('exportModal').classList.remove('active');
                        showToast('SVG downloaded!');
                    }
                    else if (currentExportType === 'png') {
                        const canvas = document.createElement('canvas');
                        const ctx = canvas.getContext('2d');
                        const img = new Image();

                        img.onload = function () {
                            canvas.width = img.width * 2;
                            canvas.height = img.height * 2;
                            ctx.fillStyle = 'white';
                            ctx.fillRect(0, 0, canvas.width, canvas.height);
                            ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                            canvas.toBlob(function (blob) {
                                downloadBlob(blob, fullFilename);
                                document.getElementById('exportModal').classList.remove('active');
                                showToast('PNG downloaded!');
                            }, 'image/png');
                        };
                        img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgData)));
                    }
                    else if (currentExportType === 'pdf') {
                        // Load jsPDF if not already loaded
                        if (typeof window.jspdf === 'undefined') {
                            const script = document.createElement('script');
                            script.src = 'https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js';
                            script.onload = function () {
                                exportToPdf(svgData, fullFilename);
                            };
                            document.head.appendChild(script);
                        } else {
                            exportToPdf(svgData, fullFilename);
                        }
                    }
                } catch (e) {
                    showToast('Export failed: ' + e.message);
                }
            });
        });

        function exportToPdf(svgData, filename) {
            const canvas = document.createElement('canvas');
            const ctx = canvas.getContext('2d');
            const img = new Image();

            img.onload = function () {
                canvas.width = img.width * 2;
                canvas.height = img.height * 2;
                ctx.fillStyle = 'white';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                ctx.drawImage(img, 0, 0, canvas.width, canvas.height);

                const imgData = canvas.toDataURL('image/png');
                const { jsPDF } = window.jspdf;
                const pdf = new jsPDF({
                    orientation: canvas.width > canvas.height ? 'landscape' : 'portrait',
                    unit: 'px',
                    format: [canvas.width, canvas.height]
                });
                pdf.addImage(imgData, 'PNG', 0, 0, canvas.width, canvas.height);
                pdf.save(filename);
                document.getElementById('exportModal').classList.remove('active');
                showToast('PDF downloaded!');
            };
            img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgData)));
        }

        // Helper to download blob
        function downloadBlob(blob, filename) {
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }

        // Render function
        function renderGraph() {
            if (!perlReady) {
                showToast('Perl runtime not ready yet');
                return;
            }

            const input = inputEl.value;
            const format = formatSelect.value;

            setStatus('Rendering...', 'loading', 90);
            outputEl.value = '';

            window.graphInput = input;
            window.graphFormat = format;

            if (window.doRender) {
                window.doRender();
            }
        }

        // Copy to clipboard
        function copyOutput() {
            outputEl.select();
            document.execCommand('copy');
            showToast('Copied to clipboard!');
        }

        // Load example
        function loadExample(name) {
            if (examples[name]) {
                inputEl.value = examples[name];
                showToast('Example loaded: ' + name);
            }
        }

        // Event listeners
        renderBtn.addEventListener('click', renderGraph);
        copyBtn.addEventListener('click', copyOutput);

        document.querySelectorAll('.ge-example-chip').forEach(btn => {
            btn.addEventListener('click', () => loadExample(btn.dataset.example));
        });

        inputEl.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                e.preventDefault();
                renderGraph();
            }
        });

        // Share button functionality
        const shareBtn = document.getElementById('shareBtn');
        const copyShareUrlBtn = document.getElementById('copyShareUrl');
        const shareUrlInput = document.getElementById('shareUrl');

        // Generate share URL with encoded input data
        function generateShareUrl() {
            const input = inputEl.value.trim();
            const baseUrl = 'https://8gwifi.org/graph-easy.jsp';

            if (input) {
                // Use base64 encoding for the input data
                const encoded = btoa(unescape(encodeURIComponent(input)));
                return baseUrl + '?data=' + encodeURIComponent(encoded);
            }
            return baseUrl;
        }

        // Update Twitter share link with current data
        function updateTwitterShareLink() {
            const shareUrl = generateShareUrl();
            const tweetText = encodeURIComponent('Just created an awesome ASCII diagram using Graph-Easy tool by @anish2good \u{1F680}\n\nCreate flowcharts, export to PNG/SVG/PDF - all in your browser!\n\n');
            const tweetLink = document.querySelector('#shareModal a[href*="twitter.com/intent/tweet"]');
            if (tweetLink) {
                tweetLink.href = 'https://twitter.com/intent/tweet?text=' + tweetText + encodeURIComponent(shareUrl) + '&hashtags=ASCII,DevTools,Diagrams,Documentation';
            }
        }

        shareBtn.addEventListener('click', function () {
            // Update share URL with current input data
            shareUrlInput.value = generateShareUrl();
            updateTwitterShareLink();
            document.getElementById('shareModal').classList.add('active');
        });

        copyShareUrlBtn.addEventListener('click', function () {
            shareUrlInput.select();
            document.execCommand('copy');
            showToast('URL copied to clipboard!');
        });

        // Load data from URL parameter on page load
        function loadFromUrlParams() {
            const urlParams = new URLSearchParams(window.location.search);
            const encodedData = urlParams.get('data');

            if (encodedData) {
                try {
                    const decoded = decodeURIComponent(escape(atob(decodeURIComponent(encodedData))));
                    inputEl.value = decoded;
                    showToast('Data loaded from shared URL!');

                    // Auto-render graph once Perl is ready
                    const checkPerlAndRender = setInterval(function () {
                        if (perlReady) {
                            clearInterval(checkPerlAndRender);
                            setTimeout(renderGraph, 500);
                        }
                    }, 100);
                } catch (e) {
                    console.error('Failed to decode shared data:', e);
                }
            }
        }

        // Call on page load
        loadFromUrlParams();

        // Store modules for Perl to access
        window.graphEasyModuleList = Object.keys(window.GraphEasyModules);
        window.getModuleContent = function (path) {
            return window.GraphEasyModules[path] || '';
        };
    </script>

    <!-- Load WebPerl -->
    <script src="graph-easy/webperl.js?v=<%= System.currentTimeMillis() %>"></script>

    <!-- Perl code that runs after WebPerl loads -->
    <script type="text/perl">
use strict;
use warnings;
use WebPerl qw/js/;
use File::Path qw(make_path);

js('console')->log("Starting Graph-Easy initialization...");

# Load modules into filesystem from JavaScript
my @module_list = @{ js('window')->{graphEasyModuleList} };
js('console')->log("Loading " . scalar(@module_list) . " modules...");

for my $mod_path (@module_list) {
    my $content = js('window')->getModuleContent($mod_path);
    my $full_path = "/lib/$mod_path";

    my $dir = $full_path;
    $dir =~ s|/[^/]+$||;
    eval { make_path($dir) };

    if (open my $fh, '>', $full_path) {
        print $fh $content;
        close $fh;
        js('console')->log("Wrote: $full_path");
    } else {
        js('console')->error("Failed to write: $full_path - $!");
    }
}

# Now load Graph::Easy
eval {
    push @INC, '/lib';
    require Graph::Easy;
    require Graph::Easy::Parser;
};
if ($@) {
    js('console')->error("Failed to load Graph::Easy: $@");
    js('window')->renderGraphResult('', "Failed to load Graph::Easy: $@");
} else {
    js('console')->log("Graph::Easy loaded successfully!");

    js('window')->{doRender} = sub {
        my $input = js('window')->{graphInput};
        my $format = js('window')->{graphFormat} || 'ascii';

        eval {
            my $parser = Graph::Easy::Parser->new();
            my $graph = $parser->from_text($input);

            if (!$graph) {
                die "Failed to parse: " . ($parser->error() || "Unknown error");
            }

            my $output;
            if ($format eq 'ascii') {
                $output = $graph->as_ascii();
            } elsif ($format eq 'boxart') {
                $output = $graph->as_boxart();
            } elsif ($format eq 'html') {
                $output = $graph->as_html();
            } elsif ($format eq 'graphviz') {
                $output = $graph->as_graphviz();
            } elsif ($format eq 'txt') {
                $output = $graph->as_txt();
            } else {
                $output = $graph->as_ascii();
            }

            js('window')->renderGraphResult($output, '');
        };
        if ($@) {
            js('window')->renderGraphResult('', "$@");
        }
    };

    js('window')->graphEasyReady();
}
</script>

<style>
.ge-ai-chip{padding:0.15rem 0.4rem;background:rgba(99,102,241,0.08);border:1px solid rgba(99,102,241,0.15);border-radius:10px;font-size:0.65rem;color:#6366f1;font-weight:500;cursor:pointer;transition:background 0.12s}
.ge-ai-chip:hover{background:rgba(99,102,241,0.15)}
[data-theme="dark"] .ge-ai-chip{background:rgba(99,102,241,0.12);border-color:rgba(99,102,241,0.2);color:#a5b4fc}
[data-theme="dark"] .ge-ai-chip:hover{background:rgba(99,102,241,0.2)}
</style>

<script>
// AI: Describe → Graph-Easy notation
(function() {
    var aiInput = document.getElementById('ge-ai-input');
    var aiBtn = document.getElementById('ge-ai-btn');
    var aiStatus = document.getElementById('ge-ai-status');
    var graphInput = document.getElementById('graphInput');

    var AI_SYSTEM = 'You are a Graph-Easy notation expert. Given a plain-English description, output ONLY valid Graph-Easy syntax.\n\n' +
        'Graph-Easy syntax rules:\n' +
        '- Nodes: [Node Name]\n' +
        '- Directed edge: [A] -> [B]\n' +
        '- Bidirectional: [A] <-> [B]\n' +
        '- Edge label: [A] -> { label: yes; } [B]\n' +
        '- Edge style: [A] -> { style: dashed; } [B]\n' +
        '- Groups: ( Group Name )\n' +
        '- Each connection on its own line\n' +
        '- Output ONLY the Graph-Easy code, no explanation\n\n' +
        'Examples:\n' +
        '"simple pipeline: A to B to C"\n[ A ] -> [ B ] -> [ C ]\n\n' +
        '"login flow with error handling"\n[ Login ] -> { label: valid; } [ Dashboard ]\n[ Login ] -> { label: invalid; } [ Error ]\n[ Error ] -> [ Login ]\n\n' +
        '"microservices with gateway"\n( Frontend )\n  [ Browser ] -> [ API Gateway ]\n\n( Backend )\n  [ API Gateway ] -> [ User Service ]\n  [ API Gateway ] -> [ Order Service ]\n  [ User Service ] -> [ User DB ]\n  [ Order Service ] -> [ Order DB ]\n\n' +
        'RESPOND WITH ONLY GRAPH-EASY CODE.';

    function setStatus(msg, cls) {
        if (!aiStatus) return;
        aiStatus.textContent = msg;
        aiStatus.style.display = msg ? 'block' : 'none';
        aiStatus.style.color = cls === 'error' ? '#dc2626' : cls === 'success' ? '#16a34a' : '#6366f1';
        aiStatus.style.background = cls === 'error' ? 'rgba(220,38,38,0.08)' : cls === 'success' ? 'rgba(22,163,74,0.08)' : 'rgba(99,102,241,0.08)';
    }

    if (aiBtn && aiInput) {
        aiBtn.addEventListener('click', function() { aiGenerate(); });
        aiInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !aiBtn.disabled) aiGenerate();
        });
        document.querySelectorAll('.ge-ai-chip').forEach(function(chip) {
            chip.addEventListener('click', function() {
                aiInput.value = chip.getAttribute('data-prompt');
                aiInput.focus();
            });
        });
    }

    function aiGenerate() {
        var desc = aiInput.value.trim();
        if (!desc) { setStatus('Enter a description', 'error'); return; }

        aiBtn.disabled = true;
        aiBtn.textContent = 'Thinking...';
        setStatus('AI is generating Graph-Easy notation...', 'loading');

        fetch('<%=request.getContextPath()%>/ai', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                messages: [
                    { role: 'system', content: AI_SYSTEM },
                    { role: 'user', content: desc }
                ],
                stream: false
            })
        })
        .then(function(r) {
            if (r.status === 429) throw new Error('Rate limit — try again');
            if (!r.ok) throw new Error('AI unavailable');
            return r.json();
        })
        .then(function(data) {
            var text = '';
            if (data.message && data.message.content) text = data.message.content;
            else if (data.response) text = data.response;
            else if (data.choices && data.choices[0]) {
                text = data.choices[0].message ? data.choices[0].message.content : (data.choices[0].text || '');
            }
            if (!text) throw new Error('Empty AI response');

            text = text.replace(/```[a-z-]*\s*/gi, '').replace(/```/g, '').trim();

            graphInput.value = text;
            setStatus('Generated! Click Render or press Ctrl+Enter', 'success');

            // Auto-render if renderGraph function exists
            if (typeof window.renderGraph === 'function') {
                window.renderGraph();
            }

            setTimeout(function() { setStatus('', ''); }, 4000);
        })
        .catch(function(err) {
            setStatus(err.message, 'error');
        })
        .finally(function() {
            aiBtn.disabled = false;
            aiBtn.textContent = 'Generate';
        });
    }
})();
</script>

</body>
</html>
