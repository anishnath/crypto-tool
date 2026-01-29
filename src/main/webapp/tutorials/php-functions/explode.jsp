<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "explode"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP explode() - Split String to Array Online | Example</title>
    <meta name="description"
        content="PHP explode() splits a string into an array by delimiter. Syntax: explode($separator, $string). CSV parsing, word splitting. Try online with examples.">
    <meta name="keywords" content="php explode, explode php, php split string, string to array php, explode example, php delimiter">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/explode.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP explode() - Split String to Array with Examples">
    <meta property="og:description" content="Learn PHP explode() to split strings into arrays. CSV parsing, word splitting. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/explode.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP explode() - Split String to Array Online">
    <meta name="twitter:description" content="PHP explode() splits string by delimiter. Try online with examples.">

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
        "headline": "PHP explode() Function - Split String to Array",
        "description": "Complete guide to PHP explode() function. Split strings into arrays using delimiters.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/explode.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php explode, split string php, string to array",
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
                "name": "How to split a string in PHP?",
                "acceptedAnswer": {"@type": "Answer", "text": "Use explode($delimiter, $string). Example: explode(',', 'a,b,c') returns ['a', 'b', 'c']."}
            },
            {
                "@type": "Question",
                "name": "What is the difference between explode() and str_split()?",
                "acceptedAnswer": {"@type": "Answer", "text": "explode() splits by a delimiter string, str_split() splits into chunks of N characters."}
            },
            {
                "@type": "Question",
                "name": "How to limit the number of splits in explode()?",
                "acceptedAnswer": {"@type": "Answer", "text": "Use the third parameter: explode(',', 'a,b,c,d', 2) returns ['a', 'b,c,d']."}
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
            {"@type": "ListItem", "position": 3, "name": "explode()"}
        ]
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="explode">
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
                    <span>explode()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP explode() Function</h1>
                    <div class="lesson-meta">
                        <span>String Function</span>
                        <span>PHP 4+</span>
                    </div>
                </header>


                <div class="lesson-body">
                    <p class="lead">The <code>explode()</code> function splits a string into an array using a delimiter.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">explode(string $separator, string $string, int $limit = PHP_INT_MAX): array</code></pre>

                    <h2>Parameters</h2>
                    <table class="info-table">
                        <thead>
                            <tr><th>Parameter</th><th>Type</th><th>Description</th></tr>
                        </thead>
                        <tbody>
                            <tr><td><code>$separator</code></td><td>string</td><td>The delimiter to split by</td></tr>
                            <tr><td><code>$string</code></td><td>string</td><td>The string to split</td></tr>
                            <tr><td><code>$limit</code></td><td>int</td><td>Max number of elements (optional)</td></tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns an array of strings created by splitting the input string.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/explode.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="explode-demo" />
                    </jsp:include>


                    <h2>More Examples</h2>

                    <h3>Split CSV Data</h3>
                    <pre><code class="language-php">&lt;?php
$csv = "apple,banana,cherry";
$fruits = explode(",", $csv);
print_r($fruits);
// ["apple", "banana", "cherry"]
?&gt;</code></pre>

                    <h3>Split Words</h3>
                    <pre><code class="language-php">&lt;?php
$sentence = "Hello World PHP";
$words = explode(" ", $sentence);
print_r($words);
// ["Hello", "World", "PHP"]
?&gt;</code></pre>

                    <h3>Limit Splits</h3>
                    <pre><code class="language-php">&lt;?php
$str = "one-two-three-four";
$parts = explode("-", $str, 2);
print_r($parts);
// ["one", "two-three-four"]
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Tip:</strong> Use <code>implode()</code> to join array elements back into a string.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Parsing CSV data</li>
                        <li>Splitting URL paths</li>
                        <li>Processing form input</li>
                        <li>Breaking text into words</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="implode.jsp">implode()</a> - Join array to string</li>
                        <li><code>str_split()</code> - Split into character chunks</li>
                        <li><code>preg_split()</code> - Split with regex</li>
                    </ul>
                </div>


                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="strpos.jsp" />
                    <jsp:param name="prevTitle" value="strpos()" />
                    <jsp:param name="nextLink" value="implode.jsp" />
                    <jsp:param name="nextTitle" value="implode()" />
                    <jsp:param name="currentLessonId" value="explode" />
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
