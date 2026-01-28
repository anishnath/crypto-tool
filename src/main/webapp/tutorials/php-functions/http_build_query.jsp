<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "http_build_query"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP http_build_query() - Build Query String Online | Example</title>
    <meta name="description" content="PHP http_build_query() generates URL-encoded query string from array. API requests, form data. Try online.">
    <meta name="keywords" content="php http_build_query, http_build_query php, php query string, build url query">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/http_build_query.jsp">
    <meta property="og:title" content="PHP http_build_query() - Build Query String"><meta property="og:type" content="article">
    <meta name="twitter:card" content="summary">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&matchMedia('(prefers-color-scheme:dark)').matches))document.documentElement.setAttribute('data-theme','dark');})();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"TechArticle","headline":"PHP http_build_query() Function","datePublished":"2025-01-01","dateModified":"2025-01-28"}</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Tutorials","item":"https://8gwifi.org/tutorials/"},{"@type":"ListItem","position":2,"name":"PHP Functions","item":"https://8gwifi.org/tutorials/php-functions/"},{"@type":"ListItem","position":3,"name":"http_build_query()"}]}</script>
    <%@ include file="../tutorial-ads.jsp" %><%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="http_build_query">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-php-functions.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
            <article class="tutorial-content">
                <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/php-functions/">PHP Functions</a><span class="breadcrumb-separator">/</span><span>http_build_query()</span></nav>
                <header class="lesson-header"><h1 class="lesson-title">PHP http_build_query() Function</h1><div class="lesson-meta"><span>URL Function</span><span>PHP 5+</span></div></header>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
                <div class="lesson-body">
                    <p class="lead">The <code>http_build_query()</code> function generates URL-encoded query string from an array or object.</p>
                    <h2>Syntax</h2>
                    <pre><code class="language-php">http_build_query(array|object $data, string $numeric_prefix = "", string $arg_separator = "&", int $encoding_type = PHP_QUERY_RFC1738): string</code></pre>
                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="php-functions/http_build_query.php" /><jsp:param name="language" value="php" /><jsp:param name="editorId" value="http-build-query-demo" /></jsp:include>
                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>
                    <h2>Examples</h2>
                    <pre><code class="language-php">&lt;?php
$params = ['name' => 'John', 'age' => 30];
$query = http_build_query($params);
// name=John&age=30

$url = "https://api.example.com/search?" . $query;
?&gt;</code></pre>
                    <h2>Related Functions</h2>
                    <ul><li><a href="parse_url.jsp">parse_url()</a> - Parse URL</li><li><a href="urlencode.jsp">urlencode()</a> - URL encoding</li></ul>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
                <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="parse_url.jsp" /><jsp:param name="prevTitle" value="parse_url()" /><jsp:param name="nextLink" value="get_meta_tags.jsp" /><jsp:param name="nextTitle" value="get_meta_tags()" /><jsp:param name="currentLessonId" value="http_build_query" /></jsp:include>
            </article>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
