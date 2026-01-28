<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "array_pop"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP array_pop() - Remove Last Element Online | Example</title>
    <meta name="description"
        content="PHP array_pop() removes and returns the last element of an array. Syntax: array_pop($array). Stack operations, LIFO. Try online with examples.">
    <meta name="keywords" content="php array_pop, array_pop php, php remove last element, pop array php, array_pop example">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/array_pop.jsp">

    <meta property="og:title" content="PHP array_pop() - Remove Last Element">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/array_pop.jsp">
    <meta name="twitter:card" content="summary">

    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "TechArticle", "headline": "PHP array_pop() Function", "datePublished": "2025-01-01", "dateModified": "2025-01-28"}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "FAQPage", "mainEntity": [
        {"@type": "Question", "name": "How to remove last element from array in PHP?", "acceptedAnswer": {"@type": "Answer", "text": "Use array_pop($array). It removes and returns the last element."}},
        {"@type": "Question", "name": "What does array_pop return for empty array?", "acceptedAnswer": {"@type": "Answer", "text": "array_pop() returns null if the array is empty."}}
    ]}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
        {"@type": "ListItem", "position": 1, "name": "Tutorials", "item": "https://8gwifi.org/tutorials/"},
        {"@type": "ListItem", "position": 2, "name": "PHP Functions", "item": "https://8gwifi.org/tutorials/php-functions/"},
        {"@type": "ListItem", "position": 3, "name": "array_pop()"}
    ]}
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="array_pop">
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
                    <span>array_pop()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP array_pop() Function</h1>
                    <div class="lesson-meta"><span>Array Function</span><span>PHP 4+</span></div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>array_pop()</code> function removes and returns the last element of an array.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">array_pop(array &$array): mixed</code></pre>

                    <h2>Return Value</h2>
                    <p>Returns the removed element, or <code>null</code> if the array is empty.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/array_pop.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="array-pop-demo" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>

                    <h2>More Examples</h2>

                    <h3>Stack Operations (LIFO)</h3>
                    <pre><code class="language-php">&lt;?php
$stack = [];
array_push($stack, "first", "second", "third");
echo array_pop($stack);  // "third"
echo array_pop($stack);  // "second"
?&gt;</code></pre>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="array_push.jsp">array_push()</a> - Add to end</li>
                        <li><code>array_shift()</code> - Remove from beginning</li>
                        <li><code>array_unshift()</code> - Add to beginning</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="array_push.jsp" />
                    <jsp:param name="prevTitle" value="array_push()" />
                    <jsp:param name="nextLink" value="array_search.jsp" />
                    <jsp:param name="nextTitle" value="array_search()" />
                    <jsp:param name="currentLessonId" value="array_pop" />
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
