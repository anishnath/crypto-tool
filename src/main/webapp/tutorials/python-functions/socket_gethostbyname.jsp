<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "socket_gethostbyname"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Python socket.gethostbyname() - DNS Lookup | 8gwifi.org</title>
    <meta name="description" content="Get IP address from hostname using DNS lookup for network programming">
    <meta name="keywords" content="python socket, gethostbyname, dns lookup, ip address, hostname resolution, network">
    <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/socket_gethostbyname.jsp">
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
        "headline": "Python socket.gethostbyname() Function",
        "description": "Get IP address from hostname using DNS lookup for network programming",
        "articleSection": "Python Networking",
        "keywords": "python socket, gethostbyname, dns lookup, ip address, hostname resolution, network",
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
            "name": "socket.gethostbyname()"
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
                    <span>socket.gethostbyname()</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">Python socket.gethostbyname() Function</h1>
                    <div class="lesson-meta"><span>Networking</span><span>•</span><span>Socket</span></div>
                </header>
                <div class="lesson-body">
                    <p class="lead">The <code>socket.gethostbyname()</code> function translates a hostname to IPv4 address format.</p>
                    <h2>Syntax</h2>
                    <pre class="language-python"><code>socket.gethostbyname(hostname)</code></pre>
                    <h2>Return Value</h2>
                    <p>A string representing the IPv4 address.</p>
                    <h2>Example</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="language" value="python" />
                        <jsp:param name="codeFile" value="python-functions/socket_gethostbyname.py" />
                    </jsp:include>
                </div>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
