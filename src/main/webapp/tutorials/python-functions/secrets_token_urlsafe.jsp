<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "secrets_token_urlsafe"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Python secrets.token_urlsafe() - URL-Safe Token | 8gwifi.org</title>
    <meta name="description" content="Generate URL-safe random tokens for session IDs, CSRF tokens, and secure web applications">
    <meta name="keywords" content="python secrets, token_urlsafe, url safe token, session id, csrf token, web security">
    <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/secrets_token_urlsafe.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (&& window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "TechArticle",
        "headline": "Python secrets.token_urlsafe() Function",
        "description": "Generate URL-safe random tokens for session IDs, CSRF tokens, and secure web applications",
        "articleSection": "Python Secrets",
        "keywords": "python secrets, token_urlsafe, url safe token, session id, csrf token, web security",
        "datePublished": "2026-01-29",
        "dateModified": "2026-01-29",
        "author": {
            "@type": "Organization",
            "name": "8gwifi.org"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "logo": {
                "@type": "ImageObject",
                "url": "https://8gwifi.org/tutorials/assets/images/logo.svg"
            }
        },
        "mainEntity": {
            "@type": "SoftwareSourceCode",
            "programmingLanguage": "Python",
            "codeRepository": "https://8gwifi.org/tutorials/python-functions/",
            "codeSampleType": "full function",
            "name": "secrets.token_urlsafe()"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-python-functions.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
            <article class="tutorial-content" style="margin-right: 0;">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/">Functions</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>secrets.token_urlsafe()</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">Python secrets.token_urlsafe() Function</h1>
                    <div class="lesson-meta"><span>Secrets</span><span>•</span><span>Tokens</span></div>
                </header>
                <div class="lesson-body">
                    <p class="lead">The <code>secrets.token_urlsafe()</code> function generates a secure random URL-safe text string.</p>
                    <p>Perfect for session tokens, CSRF tokens, and any token that needs to be passed in URLs.</p>
                    <h2>Syntax</h2>
                    <pre class="language-python"><code>secrets.token_urlsafe(nbytes=None)</code></pre>
                    <h2>Return Value</h2>
                    <p>A random URL-safe text string.</p>
                    <h2>Example</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="language" value="python" />
                        <jsp:param name="codeFile" value="python-functions/secrets_token_urlsafe.py" />
                    </jsp:include>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
            </article>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>