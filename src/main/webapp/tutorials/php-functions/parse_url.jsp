<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "parse_url"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP parse_url() - Parse URL Components Online | Example</title>
    <meta name="description" content="PHP parse_url() parses a URL and returns its components. Host, path, query, fragment. URL manipulation. Try online.">
    <meta name="keywords" content="php parse_url, parse_url php, php url parser, extract url parts">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/parse_url.jsp">
    <meta property="og:title" content="PHP parse_url() - Parse URL Components"><meta property="og:type" content="article">
    <meta name="twitter:card" content="summary">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&matchMedia('(prefers-color-scheme:dark)').matches))document.documentElement.setAttribute('data-theme','dark');})();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"TechArticle","headline":"PHP parse_url() Function","datePublished":"2025-01-01","dateModified":"2025-01-28"}</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Tutorials","item":"https://8gwifi.org/tutorials/"},{"@type":"ListItem","position":2,"name":"PHP Functions","item":"https://8gwifi.org/tutorials/php-functions/"},{"@type":"ListItem","position":3,"name":"parse_url()"}]}</script>
    <%@ include file="../tutorial-ads.jsp" %><%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="parse_url">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-php-functions.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
            <article class="tutorial-content">
                <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/php-functions/">PHP Functions</a><span class="breadcrumb-separator">/</span><span>parse_url()</span></nav>
                <header class="lesson-header"><h1 class="lesson-title">PHP parse_url() Function</h1><div class="lesson-meta"><span>URL Function</span><span>PHP 4+</span></div></header>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
                <div class="lesson-body">
                    <p class="lead">The <code>parse_url()</code> function parses a URL and returns its components.</p>
                    <h2>Syntax</h2>
                    <pre><code class="language-php">parse_url(string $url, int $component = -1): int|string|array|null|false</code></pre>
                    <h2>Components</h2>
                    <p><code>scheme</code>, <code>host</code>, <code>port</code>, <code>user</code>, <code>pass</code>, <code>path</code>, <code>query</code>, <code>fragment</code></p>
                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="php-functions/parse_url.php" /><jsp:param name="language" value="php" /><jsp:param name="editorId" value="parse-url-demo" /></jsp:include>
                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>
                    <h2>Examples</h2>
                    <pre><code class="language-php">&lt;?php
$url = "https://example.com/path?q=test#section";
$parts = parse_url($url);
// ['scheme' => 'https', 'host' => 'example.com', ...]

// Get specific component
$host = parse_url($url, PHP_URL_HOST);
?&gt;</code></pre>
                    <h2>Related Functions</h2>
                    <ul><li><a href="http_build_query.jsp">http_build_query()</a> - Build query string</li><li><a href="urlencode.jsp">urlencode()</a> - URL encoding</li></ul>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
                <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="base64_decode.jsp" /><jsp:param name="prevTitle" value="base64_decode()" /><jsp:param name="nextLink" value="http_build_query.jsp" /><jsp:param name="nextTitle" value="http_build_query()" /><jsp:param name="currentLessonId" value="parse_url" /></jsp:include>
            </article>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
