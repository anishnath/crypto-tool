<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "hashlib_sha512"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Python hashlib.sha512() - SHA-512 Hash | 8gwifi.org</title>
    <meta name="description" content="Calculate SHA-512 cryptographic hash for secure password hashing and data integrity verification">
    <meta name="keywords" content="python hashlib, sha512, sha-512, cryptographic hash, password hashing, data integrity">
    <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/hashlib_sha512.jsp">
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
        "headline": "Python hashlib.sha512() Function",
        "description": "Calculate SHA-512 cryptographic hash for secure password hashing and data integrity verification",
        "articleSection": "Python Hashing",
        "keywords": "python hashlib, sha512, sha-512, cryptographic hash, password hashing, data integrity",
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
            "name": "hashlib.sha512()"
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
                    <span>hashlib.sha512()</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">Python hashlib.sha512() Function</h1>
                    <div class="lesson-meta"><span>Hashing</span><span>•</span><span>SHA-512</span></div>
                </header>
                <div class="lesson-body">
                    <p class="lead">The <code>hashlib.sha512()</code> function returns a SHA-512 hash object.</p>
                    <p>SHA-512 is more secure than SHA-256 and produces a 512-bit (64-byte) hash value.</p>
                    <h2>Syntax</h2>
                    <pre class="language-python"><code>hashlib.sha512(data)</code></pre>
                    <h2>Return Value</h2>
                    <p>A hash object.</p>
                    <h2>Example</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="language" value="python" />
                        <jsp:param name="codeFile" value="python-functions/hashlib_sha512.py" />
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