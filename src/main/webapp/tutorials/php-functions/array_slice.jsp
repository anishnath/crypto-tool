<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "array_slice"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP array_slice() - Extract Array Slice | Try Free</title>
    <meta name="description" content="PHP array_slice() extracts portion of array. Interactive examples with live code. Syntax: array_slice($array, $offset, $length). Slice arrays easily. Try now!">
    <meta name="keywords" content="php array_slice, array_slice php, extract slice, array portion, php array_slice example, array manipulation">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/array_slice.jsp">
    <meta property="og:title" content="PHP array_slice() - Extract Array Slice | Try Free">
    <meta property="og:description" content="PHP array_slice() extracts portion of array. Interactive examples with live code. Syntax: array_slice($array, $offset, $length). Slice arrays easily. Try now!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/php-logo.svg">
    <meta property="og:type" content="article">
    <meta name="twitter:card" content="summary">
    <meta name="twitter:description" content="PHP array_slice() extracts portion of array. Interactive examples with live code. Syntax: array_slice($array, $offset, $length). Slice arrays easily. Try now!">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&matchMedia('(prefers-color-scheme:dark)').matches))document.documentElement.setAttribute('data-theme','dark');})();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"TechArticle","headline":"PHP array_slice() Function","datePublished":"2026-01-29","dateModified":"2026-01-29"}</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Tutorials","item":"https://8gwifi.org/tutorials/"},{"@type":"ListItem","position":2,"name":"PHP Functions","item":"https://8gwifi.org/tutorials/php-functions/"},{"@type":"ListItem","position":3,"name":"array_slice()"}]}</script>
    <%@ include file="../tutorial-ads.jsp" %><%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="array_slice">
    <div class="tutorial-layout has-ad-rail">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-php-functions.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
            <article class="tutorial-content">
                <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/php-functions/">PHP Functions</a><span class="breadcrumb-separator">/</span><span>array_slice()</span></nav>
                <header class="lesson-header"><h1 class="lesson-title">PHP array_slice() Function</h1><div class="lesson-meta"><span>Array</span><span>PHP 4+</span></div></header>

                <div class="lesson-body">
                    <p class="lead">The <code>array_slice()</code> function extracts a portion of an array and returns it, without modifying the original array.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">array_slice(array $array, int $offset, ?int $length = null, bool $preserve_keys = false): array</code></pre>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/array_slice.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="array_slice-demo" />
                    </jsp:include>
                </div>

            </article>

            <%-- Right Ad Rail (desktop only) --%>
            <%@ include file="../tutorial-ad-rail.jsp" %>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
