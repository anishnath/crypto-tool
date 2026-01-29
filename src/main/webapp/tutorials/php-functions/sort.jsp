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
    <div class="tutorial-layout has-ad-rail">
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


                <div class="lesson-body">
                    <p class="lead">The <code>sort()</code> function performs a specific operation.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">sort($param): mixed</code></pre>

                    <h2>Parameters</h2>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Parameter</th>
                                <th>Type</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>$param</code></td>
                                <td>mixed</td>
                                <td>Function parameter</td>
                            </tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns the result of the operation.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/sort.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="sort-demo" />
                    </jsp:include>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Data processing</li>
                        <li>Common PHP operations</li>
                    </ul>
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
