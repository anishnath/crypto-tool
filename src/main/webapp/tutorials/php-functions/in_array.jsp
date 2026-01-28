<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "in_array"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP in_array() - Check if Value Exists Online | Example</title>
    <meta name="description"
        content="PHP in_array() checks if a value exists in an array. Syntax: in_array($needle, $haystack). Strict comparison. Try online with examples.">
    <meta name="keywords" content="php in_array, in_array php, php check array value, array contains php, in_array example">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/in_array.jsp">

    <meta property="og:title" content="PHP in_array() - Check if Value Exists">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/in_array.jsp">
    <meta name="twitter:card" content="summary">

    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "TechArticle", "headline": "PHP in_array() Function", "datePublished": "2025-01-01", "dateModified": "2025-01-28"}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "FAQPage", "mainEntity": [
        {"@type": "Question", "name": "How to check if value exists in PHP array?", "acceptedAnswer": {"@type": "Answer", "text": "Use in_array($value, $array). Returns true if found, false otherwise."}},
        {"@type": "Question", "name": "Why use strict mode in in_array?", "acceptedAnswer": {"@type": "Answer", "text": "Strict mode (third param = true) compares type too. '1' !== 1 in strict mode."}}
    ]}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
        {"@type": "ListItem", "position": 1, "name": "Tutorials", "item": "https://8gwifi.org/tutorials/"},
        {"@type": "ListItem", "position": 2, "name": "PHP Functions", "item": "https://8gwifi.org/tutorials/php-functions/"},
        {"@type": "ListItem", "position": 3, "name": "in_array()"}
    ]}
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="in_array">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-php-functions.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/php-functions/">PHP Functions</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>in_array()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP in_array() Function</h1>
                    <div class="lesson-meta"><span>Array Function</span><span>PHP 4+</span></div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>in_array()</code> function checks if a value exists in an array.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">in_array(mixed $needle, array $haystack, bool $strict = false): bool</code></pre>

                    <h2>Return Value</h2>
                    <p>Returns <code>true</code> if found, <code>false</code> otherwise.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/in_array.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="in-array-demo" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>

                    <h2>More Examples</h2>

                    <h3>Strict Comparison</h3>
                    <pre><code class="language-php">&lt;?php
$arr = [1, 2, 3];
var_dump(in_array("1", $arr));        // true (loose)
var_dump(in_array("1", $arr, true));  // false (strict)
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Tip:</strong> Always use <code>strict = true</code> for security-sensitive checks.
                    </div>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="array_search.jsp">array_search()</a> - Find key by value</li>
                        <li><a href="array_keys.jsp">array_keys()</a> - Get all keys</li>
                        <li><code>array_key_exists()</code> - Check if key exists</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="array_search.jsp" />
                    <jsp:param name="prevTitle" value="array_search()" />
                    <jsp:param name="nextLink" value="array_keys.jsp" />
                    <jsp:param name="nextTitle" value="array_keys()" />
                    <jsp:param name="currentLessonId" value="in_array" />
                </jsp:include>
            </article>
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
