<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "preg_quote"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP preg_quote() - Escape Regex Characters Online | Example</title>
    <meta name="description" content="PHP preg_quote() quotes regular expression characters. Escape special chars for safe pattern matching. Try online.">
    <meta name="keywords" content="php preg_quote, preg_quote php, php escape regex, regex special characters">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/preg_quote.jsp">
    <meta property="og:title" content="PHP preg_quote() - Escape Regex Characters"><meta property="og:type" content="article">
    <meta name="twitter:card" content="summary">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&matchMedia('(prefers-color-scheme:dark)').matches))document.documentElement.setAttribute('data-theme','dark');})();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"TechArticle","headline":"PHP preg_quote() Function","datePublished":"2025-01-01","dateModified":"2025-01-28"}</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Tutorials","item":"https://8gwifi.org/tutorials/"},{"@type":"ListItem","position":2,"name":"PHP Functions","item":"https://8gwifi.org/tutorials/php-functions/"},{"@type":"ListItem","position":3,"name":"preg_quote()"}]}</script>
    <%@ include file="../tutorial-ads.jsp" %><%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="preg_quote">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-php-functions.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
            <article class="tutorial-content">
                <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/php-functions/">PHP Functions</a><span class="breadcrumb-separator">/</span><span>preg_quote()</span></nav>
                <header class="lesson-header"><h1 class="lesson-title">PHP preg_quote() Function</h1><div class="lesson-meta"><span>Regex Function</span><span>PHP 4+</span></div></header>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
                <div class="lesson-body">
                    <p class="lead">The <code>preg_quote()</code> function quotes regular expression characters, escaping special characters.</p>
                    <h2>Syntax</h2>
                    <pre><code class="language-php">preg_quote(string $str, string $delimiter = null): string</code></pre>
                    <h2>Special Characters Escaped</h2>
                    <p><code>. \ + * ? [ ^ ] $ ( ) { } = ! < > | : - #</code></p>
                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="php-functions/preg_quote.php" /><jsp:param name="language" value="php" /><jsp:param name="editorId" value="preg-quote-demo" /></jsp:include>
                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>
                    <h2>Examples</h2>
                    <pre><code class="language-php">&lt;?php
$userInput = "Price: $100 (USD)";
$escaped = preg_quote($userInput, '/');
// Price\:\ \$100\ \(USD\)

// Safe to use in pattern
preg_match('/' . $escaped . '/', $text);
?&gt;</code></pre>
                    <div class="tip-box"><strong>Security:</strong> Always use preg_quote() when including user input in regex patterns to prevent regex injection.</div>
                    <h2>Related Functions</h2>
                    <ul><li><a href="preg_match.jsp">preg_match()</a> - Regex match</li><li><a href="preg_replace.jsp">preg_replace()</a> - Regex replace</li></ul>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
                <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="preg_filter.jsp" /><jsp:param name="prevTitle" value="preg_filter()" /><jsp:param name="nextLink" value="urlencode.jsp" /><jsp:param name="nextTitle" value="urlencode()" /><jsp:param name="currentLessonId" value="preg_quote" /></jsp:include>
            </article>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
