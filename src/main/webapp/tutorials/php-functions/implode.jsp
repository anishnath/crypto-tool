<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "implode"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP implode() - Join Array to String Online | Example</title>
    <meta name="description"
        content="PHP implode() joins array elements into a string with separator. Syntax: implode($glue, $array). CSV creation, building queries. Try online with examples.">
    <meta name="keywords" content="php implode, implode php, php join array, array to string php, implode example, php array join">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/implode.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP implode() - Join Array to String with Examples">
    <meta property="og:description" content="Learn PHP implode() to join arrays into strings. CSV creation, SQL IN clauses. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/implode.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP implode() - Join Array to String Online">
    <meta name="twitter:description" content="PHP implode() joins array elements with separator. Try online with examples.">

    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

    <%-- TechArticle Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "TechArticle",
        "headline": "PHP implode() Function - Join Array to String",
        "description": "Complete guide to PHP implode() function. Join array elements into a string with a separator.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/implode.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php implode, join array php, array to string",
        "proficiencyLevel": "Beginner",
        "dependencies": "PHP 4+"
    }
    </script>

    <%-- FAQPage Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "How to join array elements in PHP?",
                "acceptedAnswer": {"@type": "Answer", "text": "Use implode($separator, $array). Example: implode(', ', ['a','b','c']) returns 'a, b, c'."}
            },
            {
                "@type": "Question",
                "name": "What is the difference between implode() and join()?",
                "acceptedAnswer": {"@type": "Answer", "text": "join() is an alias of implode(). They work identically."}
            },
            {
                "@type": "Question",
                "name": "Can implode() work with associative arrays?",
                "acceptedAnswer": {"@type": "Answer", "text": "Yes, but implode() only joins values, not keys. Use array_keys() if you need keys."}
            }
        ]
    }
    </script>

    <%-- BreadcrumbList Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {"@type": "ListItem", "position": 1, "name": "Tutorials", "item": "https://8gwifi.org/tutorials/"},
            {"@type": "ListItem", "position": 2, "name": "PHP Functions", "item": "https://8gwifi.org/tutorials/php-functions/"},
            {"@type": "ListItem", "position": 3, "name": "implode()"}
        ]
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="implode">
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
                    <span>implode()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP implode() Function</h1>
                    <div class="lesson-meta">
                        <span>String Function</span>
                        <span>PHP 4+</span>
                    </div>
                </header>


                <div class="lesson-body">
                    <p class="lead">The <code>implode()</code> function joins array elements into a single string using a separator.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">implode(string $separator, array $array): string</code></pre>

                    <h2>Parameters</h2>
                    <table class="info-table">
                        <thead>
                            <tr><th>Parameter</th><th>Type</th><th>Description</th></tr>
                        </thead>
                        <tbody>
                            <tr><td><code>$separator</code></td><td>string</td><td>The glue string between elements</td></tr>
                            <tr><td><code>$array</code></td><td>array</td><td>The array of strings to join</td></tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns a string containing all array elements joined by the separator.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/implode.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="implode-demo" />
                    </jsp:include>


                    <h2>More Examples</h2>

                    <h3>Create CSV String</h3>
                    <pre><code class="language-php">&lt;?php
$data = ["John", "25", "NYC"];
echo implode(",", $data);
// "John,25,NYC"
?&gt;</code></pre>

                    <h3>SQL IN Clause</h3>
                    <pre><code class="language-php">&lt;?php
$ids = [1, 2, 3, 4];
$sql = "SELECT * FROM users WHERE id IN (" . implode(",", $ids) . ")";
echo $sql;
?&gt;</code></pre>

                    <h3>No Separator</h3>
                    <pre><code class="language-php">&lt;?php
$chars = ["H", "e", "l", "l", "o"];
echo implode("", $chars);  // "Hello"
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Tip:</strong> <code>join()</code> is an alias of <code>implode()</code> - they work identically.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Creating CSV output</li>
                        <li>Building SQL queries</li>
                        <li>Generating breadcrumbs</li>
                        <li>Creating URL paths</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="explode.jsp">explode()</a> - Split string to array</li>
                        <li><code>join()</code> - Alias of implode</li>
                        <li><a href="array_values.jsp">array_values()</a> - Get array values</li>
                    </ul>
                </div>


                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="explode.jsp" />
                    <jsp:param name="prevTitle" value="explode()" />
                    <jsp:param name="nextLink" value="trim.jsp" />
                    <jsp:param name="nextTitle" value="trim()" />
                    <jsp:param name="currentLessonId" value="implode" />
                </jsp:include>
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
