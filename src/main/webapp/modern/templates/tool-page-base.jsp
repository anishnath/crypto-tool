<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%--
    Modern Tool Page Base Template
    Usage: Include this in individual tool pages
    
    Parameters expected:
    - pageTitle: Tool page title
    - toolName: Display name of the tool
    - toolDescription: Brief description
    - toolCategory: Category name
    - toolKeywords: SEO keywords (optional)
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle != null ? param.pageTitle : param.toolName + ' Online – Free | 8gwifi.org'}</title>

    <meta name="description" content="${param.toolDescription != null ? param.toolDescription : 'Free online ' + param.toolName + ' tool. Professional, secure, and client-side processing.'}">
    <meta name="keywords" content="${param.toolKeywords != null ? param.toolKeywords : param.toolName + ', online tool, free, developer'}">
    <meta name="robots" content="index, follow" />

    <!-- Modern Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

    <!-- Design System -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">

    <!-- Tool Page Styles -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css">
    
    <!-- Ad System -->
    <%@ include file="../ads/ad-init.jsp" %>

    <%@ include file="../../header-script.jsp"%>
</head>

<body>
    <!-- Modern Navigation -->
    <%@ include file="../components/nav-header.jsp" %>

    <!-- Breadcrumbs -->
    <nav class="breadcrumbs" aria-label="Breadcrumb">
        <div class="breadcrumbs-container">
            <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">${param.toolName}</span>
        </div>
    </nav>

    <!-- Tool Header -->
    <header class="tool-header">
        <div class="tool-header-container">
            <div class="tool-header-content">
                <h1 class="tool-page-title">${param.toolName}</h1>
                <p class="tool-page-description">${param.toolDescription != null ? param.toolDescription : 'Professional online tool for ' + param.toolName}</p>
                <div class="tool-meta">
                    <span class="tool-category-badge">${param.toolCategory != null ? param.toolCategory : 'Tool'}</span>
                    <span class="tool-badge">✓ Free</span>
                    <span class="tool-badge">🔒 Secure</span>
                    <span class="tool-badge">⚡ Client-Side</span>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Tool Content -->
    <main class="tool-main">
        <div class="tool-container">
            <!-- Tool Form/Interface goes here -->
            <jsp:doBody />
        </div>
    </main>

    <!-- In-Content Ad -->
    <%@ include file="../ads/ad-in-content-mid.jsp" %>

    <!-- Support Section -->
    <%@ include file="../components/support-section.jsp" %>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">© 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <!-- Sticky Footer Ad -->
    <%@ include file="../ads/ad-sticky-footer.jsp" %>

    <!-- Floating Right Ad (Desktop Only) -->
    <%@ include file="../ads/ad-floating-right.jsp" %>

    <!-- Scripts -->
    <script src="<%=request.getContextPath()%>/modern/js/search.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
</body>
</html>

