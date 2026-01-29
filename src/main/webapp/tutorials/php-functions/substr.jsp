<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "substr"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP substr() - Extract Substring Online | Example & Syntax</title>
    <meta name="description"
        content="PHP substr() extracts part of a string. Syntax: substr($string, $start, $length). Negative positions, string slicing. Try online with examples.">
    <meta name="keywords" content="php substr, substr php, php substring, extract string php, substr example, php string slice">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/substr.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP substr() - Extract Substring with Examples">
    <meta property="og:description" content="Learn PHP substr() to extract parts of strings. Negative positions, slicing. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/substr.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP substr() - Extract Substring Online">
    <meta name="twitter:description" content="PHP substr() extracts part of a string. Try online with examples.">

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
        "headline": "PHP substr() Function - Extract Substring",
        "description": "Complete guide to PHP substr() function. Learn to extract parts of strings with start position and length parameters.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/substr.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php substr, substring php, extract string",
        "proficiencyLevel": "Beginner",
        "dependencies": "PHP 4+"
    }
    </script>

    <%-- HowTo Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Extract Substring in PHP using substr()",
        "description": "Use PHP substr() to extract part of a string.",
        "step": [
            {"@type": "HowToStep", "name": "Specify start position", "text": "First parameter is start index (0-based)", "position": 1},
            {"@type": "HowToStep", "name": "Optionally specify length", "text": "Second parameter limits characters to extract", "position": 2},
            {"@type": "HowToStep", "name": "Use negative values", "text": "Negative start counts from end of string", "position": 3}
        ],
        "totalTime": "PT1M"
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
                "name": "How to get first N characters in PHP?",
                "acceptedAnswer": {"@type": "Answer", "text": "Use substr($string, 0, N). Example: substr('Hello', 0, 3) returns 'Hel'."}
            },
            {
                "@type": "Question",
                "name": "How to get last N characters in PHP?",
                "acceptedAnswer": {"@type": "Answer", "text": "Use negative start: substr($string, -N). Example: substr('Hello', -2) returns 'lo'."}
            },
            {
                "@type": "Question",
                "name": "What happens if start is beyond string length?",
                "acceptedAnswer": {"@type": "Answer", "text": "substr() returns false (PHP 7) or empty string (PHP 8) if start is beyond string length."}
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
            {"@type": "ListItem", "position": 3, "name": "substr()"}
        ]
    }
    </script>

    <%-- SoftwareSourceCode Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareSourceCode",
        "name": "PHP substr() Example",
        "programmingLanguage": "PHP",
        "codeSampleType": "code snippet",
        "text": "<?php\n$str = \"Hello World\";\necho substr($str, 0, 5);  // \"Hello\"\necho substr($str, -5);    // \"World\"\n?>"
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="substr">
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
                    <span>substr()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP substr() Function</h1>
                    <div class="lesson-meta">
                        <span>String Function</span>
                        <span>PHP 4+</span>
                    </div>
                </header>


                <div class="lesson-body">
                    <p class="lead">The <code>substr()</code> function extracts a portion of a string starting at a specified position.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">substr(string $string, int $start, ?int $length = null): string</code></pre>

                    <h2>Parameters</h2>
                    <table class="info-table">
                        <thead>
                            <tr><th>Parameter</th><th>Type</th><th>Description</th></tr>
                        </thead>
                        <tbody>
                            <tr><td><code>$string</code></td><td>string</td><td>The input string</td></tr>
                            <tr><td><code>$start</code></td><td>int</td><td>Start position (0-based, negative from end)</td></tr>
                            <tr><td><code>$length</code></td><td>int|null</td><td>Max characters to extract (optional)</td></tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns the extracted substring, or an empty string if start is beyond string length.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/substr.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="substr-demo" />
                    </jsp:include>


                    <h2>More Examples</h2>

                    <h3>Get First N Characters</h3>
                    <pre><code class="language-php">&lt;?php
$str = "Hello World";
echo substr($str, 0, 5);  // "Hello"
?&gt;</code></pre>

                    <h3>Get Last N Characters</h3>
                    <pre><code class="language-php">&lt;?php
$str = "Hello World";
echo substr($str, -5);    // "World"
?&gt;</code></pre>

                    <h3>Remove Last N Characters</h3>
                    <pre><code class="language-php">&lt;?php
$str = "filename.txt";
echo substr($str, 0, -4); // "filename"
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Tip:</strong> For multibyte strings (UTF-8), use <code>mb_substr()</code> instead.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Extracting file extensions</li>
                        <li>Truncating text for previews</li>
                        <li>Parsing fixed-width data</li>
                        <li>Getting parts of timestamps</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="strlen.jsp">strlen()</a> - Get string length</li>
                        <li><a href="strpos.jsp">strpos()</a> - Find position of substring</li>
                        <li><code>mb_substr()</code> - Multibyte safe version</li>
                    </ul>
                </div>


                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="str_replace.jsp" />
                    <jsp:param name="prevTitle" value="str_replace()" />
                    <jsp:param name="nextLink" value="strpos.jsp" />
                    <jsp:param name="nextTitle" value="strpos()" />
                    <jsp:param name="currentLessonId" value="substr" />
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
