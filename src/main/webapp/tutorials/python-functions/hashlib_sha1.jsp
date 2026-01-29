<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "hashlib_sha1"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Python hashlib.sha1() - SHA1 Hash Function | Try Online</title>
    <meta name="description" content="Python hashlib.sha1() creates SHA1 hash object. Interactive examples with live code. Syntax: hashlib.sha1(data). Generate SHA1 hashes. Try free!">
    <meta name="keywords" content="python hashlib sha1, hashlib.sha1, sha1 hash, python sha1, sha1 example, python hash sha1">
    <meta property="og:title" content="Python hashlib.sha1() - SHA1 Hash Function | Try Online">
    <meta property="og:description" content="Python hashlib.sha1() creates SHA1 hash object. Interactive examples with live code. Syntax: hashlib.sha1(data). Generate SHA1 hashes. Try free!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python hashlib.sha1() creates SHA1 hash object. Interactive examples with live code. Syntax: hashlib.sha1(data). Generate SHA1 hashes. Try free!">    <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/hashlib_sha1.jsp">
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
        "headline": "Python hashlib.sha1() Function",
        "description": "Calculate SHA-1 cryptographic hash (deprecated for security, use SHA-256 or SHA-512 instead)",
        "articleSection": "Python Hashing",
        "keywords": "python hashlib, sha1, sha-1, cryptographic hash, legacy hash, deprecated",
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
            "name": "hashlib.sha1()"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview">
    <div class="tutorial-layout has-ad-rail">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-python-functions.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
            <article class="tutorial-content" >
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/">Functions</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>hashlib.sha1()</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">Python hashlib.sha1() Function</h1>
                    <div class="lesson-meta"><span>Hashing</span><span>•</span><span>SHA-1</span></div>
                </header>
                <div class="lesson-body">
                    <p class="lead">The <code>hashlib.sha1()</code> function returns a SHA-1 hash object.</p>
                    <p><strong>Note:</strong> SHA-1 is deprecated for security purposes. Use SHA-256 or SHA-512 for new applications.</p>
                    <h2>Syntax</h2>
                    <pre class="language-python"><code>hashlib.sha1(data)</code></pre>
                    <h2>Return Value</h2>
                    <p>A hash object.</p>
                    <h2>Example</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="language" value="python" />
                        <jsp:param name="codeFile" value="python-functions/hashlib_sha1.py" />
                    </jsp:include>
                </div>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
