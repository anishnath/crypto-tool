<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "math_factorial"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Python math.factorial() - Calculate Factorial | Live Demo</title>
    <meta name="description" content="Python math.factorial() returns factorial of non-negative integer. Interactive examples. Syntax: math.factorial(x). Calculate n! easily. Try it online!">
    <meta name="keywords" content="python math factorial, math.factorial, factorial python, python factorial, math factorial example, calculate factorial">
    <meta property="og:title" content="Python math.factorial() - Calculate Factorial | Live Demo">
    <meta property="og:description" content="Python math.factorial() returns factorial of non-negative integer. Interactive examples. Syntax: math.factorial(x). Calculate n! easily. Try it online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python math.factorial() returns factorial of non-negative integer. Interactive examples. Syntax: math.factorial(x). Calculate n! easily. Try it online!">    <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/math_factorial.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (&& window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
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
                    <span>math.factorial()</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">Python math.factorial() Method</h1>
                    <div class="lesson-meta"><span>Math</span><span>•</span><span>Factorial</span></div>
                </header>
                <div class="lesson-body">
                    <p class="lead">The <code>math.factorial()</code> method returns the factorial of a number.</p>
                    <h2>Syntax</h2>
                    <pre class="language-python"><code>math.factorial(x)</code></pre>
                    <h2>Return Value</h2>
                    <p>x! (x factorial).</p>
                    <h2>Example</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="language" value="python" />
                        <jsp:param name="codeFile" value="python-functions/math_factorial.py" />
                    </jsp:include>
                </div>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
