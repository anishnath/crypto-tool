<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    8gwifi.org Tutorial Platform - Base Template
    Fully Independent - No parent site dependencies

    Usage: Include this at the top of lesson pages
    Required attributes:
    - pageTitle: Page title for SEO
    - pageDescription: Meta description
    - currentLesson: Current lesson ID for sidebar highlighting
    - currentModule: Current module name
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <%-- SEO Meta Tags --%>
    <title>${param.pageTitle} | 8gwifi.org Tutorials</title>
    <meta name="description" content="${param.pageDescription}">
    <meta name="keywords" content="${param.pageKeywords}">
    <meta name="author" content="8gwifi.org">
    <meta name="robots" content="index, follow">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="${param.pageTitle}">
    <meta property="og:description" content="${param.pageDescription}">
    <meta property="og:site_name" content="8gwifi.org Tutorials">
    <meta property="og:locale" content="en_US">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="${param.pageTitle}">
    <meta name="twitter:description" content="${param.pageDescription}">

    <%-- Favicon --%>
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.png">

    <%-- Fonts (self-hosted) --%>
    <link rel="preload" href="<%=request.getContextPath()%>/tutorials/assets/fonts/Inter-Regular.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="<%=request.getContextPath()%>/tutorials/assets/fonts/Inter-Medium.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="<%=request.getContextPath()%>/tutorials/assets/fonts/Inter-SemiBold.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="<%=request.getContextPath()%>/tutorials/assets/fonts/JetBrainsMono-Regular.woff2" as="font" type="font/woff2" crossorigin>

    <%-- CSS - All from /tutorials/assets/ --%>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

    <%-- Prevent FOUC --%>
    <script>
        (function() {
            var theme = localStorage.getItem('tutorial-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <%-- JSON-LD Structured Data (passed from child page) --%>
    ${param.jsonLd}
</head>
<body class="tutorial-body">
    <div class="tutorial-layout">
        <%-- Header --%>
        <%@ include file="tutorial-header.jsp" %>

        <%-- Main Content Area --%>
        <main class="tutorial-main">
            <%-- Sidebar --%>
            <%@ include file="tutorial-sidebar.jsp" %>

            <%-- Overlay for mobile sidebar --%>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <%-- Lesson Content (injected by child page) --%>
            <article class="tutorial-content">
                <jsp:doBody />
            </article>

            <%-- Live Preview Panel --%>
            <aside class="tutorial-preview" id="previewPanel">
                <div class="preview-header">
                    <span>Live Preview</span>
                    <button class="btn btn-ghost btn-icon" onclick="refreshPreview()" title="Refresh">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M23 4v6h-6M1 20v-6h6"/>
                            <path d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15"/>
                        </svg>
                    </button>
                </div>
                <iframe id="previewFrame" class="preview-frame" sandbox="allow-scripts allow-same-origin" title="Live Preview"></iframe>
            </aside>
        </main>

        <%-- Footer --%>
        <%@ include file="tutorial-footer.jsp" %>
    </div>

    <%-- Mobile Preview Bottom Sheet --%>
    <div class="mobile-preview" id="mobilePreview">
        <div class="mobile-preview-header">
            <span class="font-medium">Preview</span>
            <button class="btn btn-ghost btn-icon" onclick="closeMobilePreview()">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"/>
                    <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
            </button>
        </div>
        <div class="mobile-preview-body">
            <iframe id="mobilePreviewFrame" class="preview-frame" style="width:100%;height:100%;" sandbox="allow-scripts allow-same-origin" title="Mobile Preview"></iframe>
        </div>
    </div>

    <%-- JavaScript - All from /tutorials/assets/ --%>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js"></script>
</body>
</html>
