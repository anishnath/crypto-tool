<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "array_search"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP array_search() - Find Key by Value Online | Example</title>
    <meta name="description"
        content="PHP array_search() searches array for value and returns its key. Syntax: array_search($needle, $haystack). Try online with examples.">
    <meta name="keywords" content="php array_search, array_search php, php find key, search array php, array_search example">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/array_search.jsp">

    <meta property="og:title" content="PHP array_search() - Find Key by Value">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/array_search.jsp">
    <meta name="twitter:card" content="summary">

    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "TechArticle", "headline": "PHP array_search() Function", "datePublished": "2025-01-01", "dateModified": "2025-01-28"}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "FAQPage", "mainEntity": [
        {"@type": "Question", "name": "How to find key from value in PHP array?", "acceptedAnswer": {"@type": "Answer", "text": "Use array_search($value, $array). Returns the key if found, false otherwise."}},
        {"@type": "Question", "name": "Difference between array_search and in_array?", "acceptedAnswer": {"@type": "Answer", "text": "array_search() returns the key, in_array() returns boolean (true/false)."}}
    ]}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
        {"@type": "ListItem", "position": 1, "name": "Tutorials", "item": "https://8gwifi.org/tutorials/"},
        {"@type": "ListItem", "position": 2, "name": "PHP Functions", "item": "https://8gwifi.org/tutorials/php-functions/"},
        {"@type": "ListItem", "position": 3, "name": "array_search()"}
    ]}
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="array_search">
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
                    <span>array_search()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP array_search() Function</h1>
                    <div class="lesson-meta"><span>Array Function</span><span>PHP 4.0.5+</span></div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>array_search()</code> function searches an array for a value and returns the corresponding key.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">array_search(mixed $needle, array $haystack, bool $strict = false): int|string|false</code></pre>

                    <h2>Return Value</h2>
                    <p>Returns the key of the value if found, or <code>false</code> if not found.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/array_search.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="array-search-demo" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>

                    <h2>More Examples</h2>

                    <h3>Strict Type Comparison</h3>
                    <pre><code class="language-php">&lt;?php
$arr = [0 => "0", 1 => "1", 2 => "2"];
echo array_search(0, $arr);        // 0 (loose)
echo array_search(0, $arr, true);  // false (strict)
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> Use <code>=== false</code> to check if not found, since key 0 is valid.
                    </div>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="in_array.jsp">in_array()</a> - Check if value exists</li>
                        <li><a href="array_keys.jsp">array_keys()</a> - Get all keys</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="array_pop.jsp" />
                    <jsp:param name="prevTitle" value="array_pop()" />
                    <jsp:param name="nextLink" value="in_array.jsp" />
                    <jsp:param name="nextTitle" value="in_array()" />
                    <jsp:param name="currentLessonId" value="array_search" />
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
