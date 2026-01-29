<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "itertools_permutations"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Python itertools.permutations() - Generate Permutations | 8gwifi.org</title>
    <meta name="description" content="Generate all r-length permutations of elements for combinatorial algorithms and puzzles">
    <meta name="keywords" content="python itertools, permutations, combinatorics, arrangements, algorithm, math">
    <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/itertools_permutations.jsp">
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
        "headline": "Python itertools.permutations() Function",
        "description": "Generate all r-length permutations of elements for combinatorial algorithms and puzzles",
        "articleSection": "Python Itertools",
        "keywords": "python itertools, permutations, combinatorics, arrangements, algorithm, math",
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
            "name": "itertools.permutations()"
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
                    <span>itertools.permutations()</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">Python itertools.permutations() Function</h1>
                    <div class="lesson-meta"><span>Itertools</span><span>•</span><span>Permutations</span></div>
                </header>
                <div class="lesson-body">
                    <p class="lead">The <code>itertools.permutations()</code> function returns all r-length permutations of elements from an iterable.</p>
                    <h2>Syntax</h2>
                    <pre class="language-python"><code>itertools.permutations(iterable, r=None)</code></pre>
                    <h2>Return Value</h2>
                    <p>An iterator of tuples.</p>
                    <h2>Example</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="language" value="python" />
                        <jsp:param name="codeFile" value="python-functions/itertools_permutations.py" />
                    </jsp:include>
                </div>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
