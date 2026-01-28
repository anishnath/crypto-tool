<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "strtolower"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP strtolower() - Convert to Lowercase Online | Example</title>
    <meta name="description"
        content="PHP strtolower() converts string to lowercase. Syntax: strtolower($string). Case-insensitive comparisons, normalization. Try online with examples.">
    <meta name="keywords" content="php strtolower, strtolower php, php lowercase, convert lowercase php, strtolower example">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/strtolower.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP strtolower() - Convert to Lowercase with Examples">
    <meta property="og:description" content="Learn PHP strtolower() for case conversion. String normalization. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/strtolower.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP strtolower() - Convert to Lowercase Online">
    <meta name="twitter:description" content="PHP strtolower() converts string to lowercase. Try online.">

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
        "headline": "PHP strtolower() Function - Convert to Lowercase",
        "description": "Complete guide to PHP strtolower() function. Convert strings to lowercase for comparisons and normalization.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/strtolower.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php strtolower, lowercase php, convert case",
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
                "name": "How to convert string to lowercase in PHP?",
                "acceptedAnswer": {"@type": "Answer", "text": "Use strtolower($string). Example: strtolower('HELLO') returns 'hello'."}
            },
            {
                "@type": "Question",
                "name": "Does strtolower() work with UTF-8?",
                "acceptedAnswer": {"@type": "Answer", "text": "strtolower() only works with ASCII. For UTF-8, use mb_strtolower($str, 'UTF-8')."}
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
            {"@type": "ListItem", "position": 3, "name": "strtolower()"}
        ]
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="strtolower">
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
                    <span>strtolower()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP strtolower() Function</h1>
                    <div class="lesson-meta">
                        <span>String Function</span>
                        <span>PHP 4+</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>strtolower()</code> function converts all alphabetic characters in a string to lowercase.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">strtolower(string $string): string</code></pre>

                    <h2>Parameters</h2>
                    <table class="info-table">
                        <thead>
                            <tr><th>Parameter</th><th>Type</th><th>Description</th></tr>
                        </thead>
                        <tbody>
                            <tr><td><code>$string</code></td><td>string</td><td>The input string</td></tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns the string with all alphabetic characters converted to lowercase.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/strtolower.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="strtolower-demo" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>More Examples</h2>

                    <h3>Case-Insensitive Comparison</h3>
                    <pre><code class="language-php">&lt;?php
$input = "YES";
if (strtolower($input) === "yes") {
    echo "User agreed!";
}
?&gt;</code></pre>

                    <h3>Email Normalization</h3>
                    <pre><code class="language-php">&lt;?php
$email = "John@Example.COM";
$normalized = strtolower($email);
echo $normalized;  // "john@example.com"
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Note:</strong> For UTF-8 strings with special characters, use <code>mb_strtolower()</code> instead.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Case-insensitive string comparisons</li>
                        <li>Email normalization</li>
                        <li>URL slug generation</li>
                        <li>Username validation</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="strtoupper.jsp">strtoupper()</a> - Convert to uppercase</li>
                        <li><code>ucfirst()</code> - Capitalize first letter</li>
                        <li><code>ucwords()</code> - Capitalize each word</li>
                        <li><code>mb_strtolower()</code> - UTF-8 safe version</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="trim.jsp" />
                    <jsp:param name="prevTitle" value="trim()" />
                    <jsp:param name="nextLink" value="strtoupper.jsp" />
                    <jsp:param name="nextTitle" value="strtoupper()" />
                    <jsp:param name="currentLessonId" value="strtolower" />
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
