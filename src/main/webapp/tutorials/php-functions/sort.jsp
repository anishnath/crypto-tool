<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "sort"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP sort() - Sort Array Online | Example & Syntax</title>
    <meta name="description"
        content="PHP sort() sorts array elements in ascending order. Syntax: sort($array). rsort for descending, asort to preserve keys. Try online with examples.">
    <meta name="keywords" content="php sort, sort php, php sort array, sort array php, php sort example, rsort asort">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/sort.jsp">

    <meta property="og:title" content="PHP sort() - Sort Array Elements">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/sort.jsp">
    <meta name="twitter:card" content="summary">

    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "TechArticle", "headline": "PHP sort() Function", "datePublished": "2025-01-01", "dateModified": "2025-01-28"}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "FAQPage", "mainEntity": [
        {"@type": "Question", "name": "How to sort array in PHP?", "acceptedAnswer": {"@type": "Answer", "text": "Use sort($array) for ascending, rsort($array) for descending. These modify the original array."}},
        {"@type": "Question", "name": "How to sort and keep keys?", "acceptedAnswer": {"@type": "Answer", "text": "Use asort() for ascending or arsort() for descending while preserving key associations."}}
    ]}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
        {"@type": "ListItem", "position": 1, "name": "Tutorials", "item": "https://8gwifi.org/tutorials/"},
        {"@type": "ListItem", "position": 2, "name": "PHP Functions", "item": "https://8gwifi.org/tutorials/php-functions/"},
        {"@type": "ListItem", "position": 3, "name": "sort()"}
    ]}
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="sort">
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
                    <span>sort()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP sort() Function</h1>
                    <div class="lesson-meta"><span>Array Function</span><span>PHP 4+</span></div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>sort()</code> function sorts array elements in ascending order.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">sort(array &$array, int $flags = SORT_REGULAR): bool</code></pre>

                    <h2>Sort Variants</h2>
                    <table class="info-table">
                        <thead><tr><th>Function</th><th>Order</th><th>Keys</th></tr></thead>
                        <tbody>
                            <tr><td><code>sort()</code></td><td>Ascending</td><td>Reindexed</td></tr>
                            <tr><td><code>rsort()</code></td><td>Descending</td><td>Reindexed</td></tr>
                            <tr><td><code>asort()</code></td><td>Ascending</td><td>Preserved</td></tr>
                            <tr><td><code>arsort()</code></td><td>Descending</td><td>Preserved</td></tr>
                            <tr><td><code>ksort()</code></td><td>By key asc</td><td>Preserved</td></tr>
                        </tbody>
                    </table>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/sort.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="sort-demo" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>

                    <h2>More Examples</h2>

                    <h3>Sort Associative Array</h3>
                    <pre><code class="language-php">&lt;?php
$ages = ["John" => 25, "Jane" => 30, "Bob" => 20];
asort($ages);  // Keep keys, sort by value
print_r($ages);
// Bob=>20, John=>25, Jane=>30
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Note:</strong> <code>sort()</code> modifies the original array and reindexes numeric keys.
                    </div>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><code>rsort()</code> - Sort descending</li>
                        <li><code>asort()</code> - Sort keeping keys</li>
                        <li><code>usort()</code> - Sort with custom function</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="array_values.jsp" />
                    <jsp:param name="prevTitle" value="array_values()" />
                    <jsp:param name="nextLink" value="round.jsp" />
                    <jsp:param name="nextTitle" value="round()" />
                    <jsp:param name="currentLessonId" value="sort" />
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
