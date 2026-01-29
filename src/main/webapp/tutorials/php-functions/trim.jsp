<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "trim"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP trim() - Remove Whitespace Online | Example & Syntax</title>
    <meta name="description"
        content="PHP trim() removes whitespace from both ends of a string. Syntax: trim($string). ltrim, rtrim variants. Form input cleaning. Try online with examples.">
    <meta name="keywords" content="php trim, trim php, php remove whitespace, trim example, php strip spaces, ltrim rtrim">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/trim.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP trim() - Remove Whitespace with Examples">
    <meta property="og:description" content="Learn PHP trim() to remove whitespace from strings. ltrim, rtrim variants. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/trim.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP trim() - Remove Whitespace Online">
    <meta name="twitter:description" content="PHP trim() removes whitespace from string ends. Try online with examples.">

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
        "headline": "PHP trim() Function - Remove Whitespace",
        "description": "Complete guide to PHP trim() function. Remove whitespace or custom characters from string ends.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/trim.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php trim, remove whitespace php, strip spaces",
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
                "name": "How to remove spaces from string in PHP?",
                "acceptedAnswer": {"@type": "Answer", "text": "Use trim($string) to remove spaces from both ends. For all spaces, use str_replace(' ', '', $string)."}
            },
            {
                "@type": "Question",
                "name": "What is the difference between trim, ltrim and rtrim?",
                "acceptedAnswer": {"@type": "Answer", "text": "trim() removes from both ends, ltrim() removes from left (start) only, rtrim() removes from right (end) only."}
            },
            {
                "@type": "Question",
                "name": "Can trim() remove custom characters?",
                "acceptedAnswer": {"@type": "Answer", "text": "Yes, pass characters as second parameter: trim($str, '#@') removes # and @ from both ends."}
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
            {"@type": "ListItem", "position": 3, "name": "trim()"}
        ]
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="trim">
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
                    <span>trim()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP trim() Function</h1>
                    <div class="lesson-meta">
                        <span>String Function</span>
                        <span>PHP 4+</span>
                    </div>
                </header>


                <div class="lesson-body">
                    <p class="lead">The <code>trim()</code> function removes whitespace (or other characters) from both ends of a string.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">trim(string $string, string $characters = " \n\r\t\v\x00"): string</code></pre>

                    <h2>Parameters</h2>
                    <table class="info-table">
                        <thead>
                            <tr><th>Parameter</th><th>Type</th><th>Description</th></tr>
                        </thead>
                        <tbody>
                            <tr><td><code>$string</code></td><td>string</td><td>The string to trim</td></tr>
                            <tr><td><code>$characters</code></td><td>string</td><td>Characters to remove (optional)</td></tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns the trimmed string.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/trim.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="trim-demo" />
                    </jsp:include>


                    <h2>More Examples</h2>

                    <h3>Basic Whitespace Removal</h3>
                    <pre><code class="language-php">&lt;?php
$str = "  Hello World  ";
echo "[" . trim($str) . "]";
// "[Hello World]"
?&gt;</code></pre>

                    <h3>Left/Right Trim</h3>
                    <pre><code class="language-php">&lt;?php
$str = "  Hello  ";
echo ltrim($str);  // "Hello  " (left only)
echo rtrim($str);  // "  Hello" (right only)
?&gt;</code></pre>

                    <h3>Custom Characters</h3>
                    <pre><code class="language-php">&lt;?php
$str = "###Hello###";
echo trim($str, "#");  // "Hello"
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Tip:</strong> Always trim user input before storing or comparing to avoid whitespace issues.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Cleaning form input</li>
                        <li>Normalizing strings for comparison</li>
                        <li>Removing BOM characters</li>
                        <li>Processing file content</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><code>ltrim()</code> - Trim left side only</li>
                        <li><code>rtrim()</code> - Trim right side only</li>
                        <li><a href="str_replace.jsp">str_replace()</a> - Replace characters</li>
                    </ul>
                </div>


                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="implode.jsp" />
                    <jsp:param name="prevTitle" value="implode()" />
                    <jsp:param name="nextLink" value="strtolower.jsp" />
                    <jsp:param name="nextTitle" value="strtolower()" />
                    <jsp:param name="currentLessonId" value="trim" />
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
