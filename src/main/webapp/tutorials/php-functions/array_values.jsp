<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "array_values"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP array_values() - Get All Values & Reindex Online | Example</title>
    <meta name="description"
        content="PHP array_values() returns all values and reindexes array. Syntax: array_values($array). Reset array keys. Try online with examples.">
    <meta name="keywords" content="php array_values, array_values php, php reindex array, reset array keys php, array_values example">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/array_values.jsp">

    <meta property="og:title" content="PHP array_values() - Get Values & Reindex">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/array_values.jsp">
    <meta name="twitter:card" content="summary">

    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "TechArticle", "headline": "PHP array_values() Function", "datePublished": "2025-01-01", "dateModified": "2025-01-28"}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "FAQPage", "mainEntity": [
        {"@type": "Question", "name": "How to reindex array in PHP?", "acceptedAnswer": {"@type": "Answer", "text": "Use array_values($array). It returns values with numeric keys starting from 0."}},
        {"@type": "Question", "name": "When to use array_values?", "acceptedAnswer": {"@type": "Answer", "text": "Use after array_filter() to reindex, or to convert associative array to indexed."}}
    ]}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
        {"@type": "ListItem", "position": 1, "name": "Tutorials", "item": "https://8gwifi.org/tutorials/"},
        {"@type": "ListItem", "position": 2, "name": "PHP Functions", "item": "https://8gwifi.org/tutorials/php-functions/"},
        {"@type": "ListItem", "position": 3, "name": "array_values()"}
    ]}
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="array_values">
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
                    <span>array_values()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP array_values() Function</h1>
                    <div class="lesson-meta"><span>Array Function</span><span>PHP 4+</span></div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>array_values()</code> function returns all values of an array with numeric keys starting from 0.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">array_values(array $array): array</code></pre>

                    <h2>Return Value</h2>
                    <p>Returns an indexed array of values.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/array_values.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="array-values-demo" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>

                    <h2>More Examples</h2>

                    <h3>Reindex After Filter</h3>
                    <pre><code class="language-php">&lt;?php
$nums = [1, 2, 3, 4, 5];
$even = array_filter($nums, fn($n) => $n % 2 === 0);
// [1 => 2, 3 => 4] - gaps in keys

$reindexed = array_values($even);
// [0 => 2, 1 => 4] - clean indexes
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Tip:</strong> Use after <code>array_filter()</code> to get clean 0-based indexes.
                    </div>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="array_keys.jsp">array_keys()</a> - Get all keys</li>
                        <li><a href="array_filter.jsp">array_filter()</a> - Filter array</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="array_keys.jsp" />
                    <jsp:param name="prevTitle" value="array_keys()" />
                    <jsp:param name="nextLink" value="sort.jsp" />
                    <jsp:param name="nextTitle" value="sort()" />
                    <jsp:param name="currentLessonId" value="array_values" />
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
