<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "strpos"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP strpos() - Find String Position Online | Example & Syntax</title>
    <meta name="description"
        content="PHP strpos() finds the position of first occurrence of substring. Syntax: strpos($haystack, $needle). Case-sensitive search. Try online with examples.">
    <meta name="keywords" content="php strpos, strpos php, php find string, php string position, strpos example, php search string">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/strpos.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP strpos() - Find String Position with Examples">
    <meta property="og:description" content="Learn PHP strpos() to find substring positions. Case-sensitive search. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/strpos.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP strpos() - Find String Position Online">
    <meta name="twitter:description" content="PHP strpos() finds position of substring. Try online with examples.">

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
        "headline": "PHP strpos() Function - Find String Position",
        "description": "Complete guide to PHP strpos() function. Find the position of a substring within a string.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/strpos.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php strpos, find string php, string position",
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
                "name": "How to check if string contains substring in PHP?",
                "acceptedAnswer": {"@type": "Answer", "text": "Use strpos($string, $search) !== false. Returns position if found, false if not found."}
            },
            {
                "@type": "Question",
                "name": "Is strpos() case-sensitive?",
                "acceptedAnswer": {"@type": "Answer", "text": "Yes, strpos() is case-sensitive. Use stripos() for case-insensitive search."}
            },
            {
                "@type": "Question",
                "name": "Why use !== false instead of != false?",
                "acceptedAnswer": {"@type": "Answer", "text": "strpos() returns 0 if found at start, which is falsy. Use !== false for strict comparison."}
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
            {"@type": "ListItem", "position": 3, "name": "strpos()"}
        ]
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="strpos">
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
                    <span>strpos()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP strpos() Function</h1>
                    <div class="lesson-meta">
                        <span>String Function</span>
                        <span>PHP 4+</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>strpos()</code> function finds the position of the first occurrence of a substring in a string.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">strpos(string $haystack, string $needle, int $offset = 0): int|false</code></pre>

                    <h2>Parameters</h2>
                    <table class="info-table">
                        <thead>
                            <tr><th>Parameter</th><th>Type</th><th>Description</th></tr>
                        </thead>
                        <tbody>
                            <tr><td><code>$haystack</code></td><td>string</td><td>The string to search in</td></tr>
                            <tr><td><code>$needle</code></td><td>string</td><td>The substring to find</td></tr>
                            <tr><td><code>$offset</code></td><td>int</td><td>Start search from this position (optional)</td></tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns the position (0-indexed) of the first occurrence, or <code>false</code> if not found.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/strpos.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="strpos-demo" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>More Examples</h2>

                    <h3>Check if String Contains</h3>
                    <pre><code class="language-php">&lt;?php
$str = "Hello World";
if (strpos($str, "World") !== false) {
    echo "Found!";
}
?&gt;</code></pre>

                    <h3>Case-Insensitive Search</h3>
                    <pre><code class="language-php">&lt;?php
$str = "Hello World";
echo stripos($str, "world"); // 6 (case-insensitive)
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> Always use <code>=== false</code> or <code>!== false</code> when checking the result, because position 0 is valid but falsy.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Checking if string contains a substring</li>
                        <li>Finding email domain (@gmail.com)</li>
                        <li>Parsing URLs and paths</li>
                        <li>Validating input formats</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><code>stripos()</code> - Case-insensitive version</li>
                        <li><code>strrpos()</code> - Find last occurrence</li>
                        <li><a href="substr.jsp">substr()</a> - Extract substring</li>
                        <li><code>str_contains()</code> - PHP 8+ boolean check</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="substr.jsp" />
                    <jsp:param name="prevTitle" value="substr()" />
                    <jsp:param name="nextLink" value="explode.jsp" />
                    <jsp:param name="nextTitle" value="explode()" />
                    <jsp:param name="currentLessonId" value="strpos" />
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
