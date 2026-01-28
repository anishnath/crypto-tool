<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "get_meta_tags"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP get_meta_tags() - Extract Meta Tags Online | Example</title>
    <meta name="description" content="PHP get_meta_tags() extracts all meta tag content attributes from a file. SEO analysis, web scraping. Try online.">
    <meta name="keywords" content="php get_meta_tags, get_meta_tags php, php extract meta tags, seo meta tags">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/get_meta_tags.jsp">
    <meta property="og:title" content="PHP get_meta_tags() - Extract Meta Tags"><meta property="og:type" content="article">
    <meta name="twitter:card" content="summary">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&matchMedia('(prefers-color-scheme:dark)').matches))document.documentElement.setAttribute('data-theme','dark');})();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"TechArticle","headline":"PHP get_meta_tags() Function","datePublished":"2025-01-01","dateModified":"2025-01-28"}</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Tutorials","item":"https://8gwifi.org/tutorials/"},{"@type":"ListItem","position":2,"name":"PHP Functions","item":"https://8gwifi.org/tutorials/php-functions/"},{"@type":"ListItem","position":3,"name":"get_meta_tags()"}]}</script>
    <%@ include file="../tutorial-ads.jsp" %><%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="get_meta_tags">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-php-functions.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
            <article class="tutorial-content">
                <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/php-functions/">PHP Functions</a><span class="breadcrumb-separator">/</span><span>get_meta_tags()</span></nav>
                <header class="lesson-header"><h1 class="lesson-title">PHP get_meta_tags() Function</h1><div class="lesson-meta"><span>URL Function</span><span>PHP 4+</span></div></header>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
                <div class="lesson-body">
                    <p class="lead">The <code>get_meta_tags()</code> function extracts all meta tag content attributes from a file and returns an array.</p>
                    <h2>Syntax</h2>
                    <pre><code class="language-php">get_meta_tags(string $filename, bool $use_include_path = false): array|false</code></pre>
                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="php-functions/get_meta_tags.php" /><jsp:param name="language" value="php" /><jsp:param name="editorId" value="get-meta-tags-demo" /></jsp:include>
                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>
                    <h2>Examples</h2>
                    <pre><code class="language-php">&lt;?php
// From HTML string (write to temp file first)
$html = '&lt;meta name="description" content="Test page"&gt;
         &lt;meta name="keywords" content="php, test"&gt;';
file_put_contents('/tmp/test.html', $html);
$tags = get_meta_tags('/tmp/test.html');
// ['description' => 'Test page', 'keywords' => 'php, test']
?&gt;</code></pre>
                    <div class="tip-box"><strong>Note:</strong> Only extracts meta tags with name attribute. Does not extract property (Open Graph) tags.</div>
                    <h2>Related Functions</h2>
                    <ul><li><a href="parse_url.jsp">parse_url()</a> - Parse URL</li><li><a href="file_get_contents.jsp">file_get_contents()</a> - Read file</li></ul>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
                <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="http_build_query.jsp" /><jsp:param name="prevTitle" value="http_build_query()" /><jsp:param name="nextLink" value="gethostbyaddr.jsp" /><jsp:param name="nextTitle" value="gethostbyaddr()" /><jsp:param name="currentLessonId" value="get_meta_tags" /></jsp:include>
            </article>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
