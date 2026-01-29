<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "str_replace"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP str_replace() - Find and Replace String Online | Example</title>
    <meta name="description"
        content="PHP str_replace() replaces all occurrences of search string with replacement. Syntax: str_replace($search, $replace, $subject). Try online with examples.">
    <meta name="keywords" content="php str_replace, str_replace php, php string replace, find and replace php, str_replace example, php replace text">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/str_replace.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP str_replace() - Find and Replace String with Examples">
    <meta property="og:description" content="Learn PHP str_replace() for text replacement. Multiple replacements, case-insensitive options. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/str_replace.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP str_replace() - Find and Replace Online">
    <meta name="twitter:description" content="PHP str_replace() replaces text in strings. Try online with live examples.">

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
        "headline": "PHP str_replace() Function - Find and Replace Strings",
        "description": "Complete guide to PHP str_replace() function. Learn syntax, multiple replacements, and practical examples for string manipulation.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/str_replace.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php str_replace, string replace php, find replace php",
        "proficiencyLevel": "Beginner",
        "dependencies": "PHP 4+"
    }
    </script>

    <%-- HowTo Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Replace Text in PHP using str_replace()",
        "description": "Use PHP str_replace() to find and replace text in strings.",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Define search and replace values",
                "text": "Specify what to find ($search) and what to replace with ($replace)",
                "position": 1
            },
            {
                "@type": "HowToStep",
                "name": "Call str_replace()",
                "text": "Use: str_replace($search, $replace, $subject)",
                "position": 2
            },
            {
                "@type": "HowToStep",
                "name": "For multiple replacements, use arrays",
                "text": "Pass arrays: str_replace(['a','b'], ['x','y'], $text)",
                "position": 3
            }
        ],
        "totalTime": "PT2M"
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
                "name": "How to replace text in PHP?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Use str_replace($search, $replace, $subject). Example: str_replace('old', 'new', $text) replaces all 'old' with 'new'."
                }
            },
            {
                "@type": "Question",
                "name": "Is str_replace() case sensitive?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, str_replace() is case-sensitive. Use str_ireplace() for case-insensitive replacement."
                }
            },
            {
                "@type": "Question",
                "name": "Can str_replace() do multiple replacements?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, pass arrays: str_replace(['a','b'], ['x','y'], $text) replaces 'a' with 'x' and 'b' with 'y'."
                }
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
            {"@type": "ListItem", "position": 3, "name": "str_replace()"}
        ]
    }
    </script>

    <%-- SoftwareSourceCode Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareSourceCode",
        "name": "PHP str_replace() Example",
        "programmingLanguage": "PHP",
        "codeSampleType": "code snippet",
        "text": "<?php\n$text = \"Hello World\";\necho str_replace(\"World\", \"PHP\", $text);\n// Output: Hello PHP\n?>"
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="str_replace">
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
                    <span>str_replace()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP str_replace() Function</h1>
                    <div class="lesson-meta">
                        <span>String Function</span>
                        <span>PHP 4+</span>
                    </div>
                </header>


                <div class="lesson-body">
                    <p class="lead">The <code>str_replace()</code> function replaces all occurrences of a search string (or array of strings) with a replacement string (or array).</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">str_replace(
    array|string $search,
    array|string $replace,
    string|array $subject,
    int &$count = null
): string|array</code></pre>

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
                                <td><code>$search</code></td>
                                <td>string|array</td>
                                <td>The value(s) to search for</td>
                            </tr>
                            <tr>
                                <td><code>$replace</code></td>
                                <td>string|array</td>
                                <td>The replacement value(s)</td>
                            </tr>
                            <tr>
                                <td><code>$subject</code></td>
                                <td>string|array</td>
                                <td>The string or array to search in</td>
                            </tr>
                            <tr>
                                <td><code>$count</code></td>
                                <td>int</td>
                                <td>Optional. Number of replacements performed</td>
                            </tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns a string or array with all occurrences of search replaced with replace.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/str_replace.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="str-replace-demo" />
                    </jsp:include>


                    <h2>More Examples</h2>

                    <h3>Simple Replace</h3>
                    <pre><code class="language-php">&lt;?php
$text = "Hello World";
$result = str_replace("World", "PHP", $text);
echo $result;  // "Hello PHP"
?&gt;</code></pre>

                    <h3>Multiple Replacements</h3>
                    <pre><code class="language-php">&lt;?php
$text = "I like apples and apples are healthy";
$result = str_replace(
    ["apples", "healthy"],
    ["oranges", "delicious"],
    $text
);
echo $result;
// "I like oranges and oranges are delicious"
?&gt;</code></pre>

                    <h3>Count Replacements</h3>
                    <pre><code class="language-php">&lt;?php
$text = "PHP is great. PHP is powerful.";
$count = 0;
$result = str_replace("PHP", "Python", $text, $count);
echo "Made $count replacements\n";  // Made 2 replacements
echo $result;
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Tip:</strong> For case-insensitive replacements, use <code>str_ireplace()</code> instead.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Template variable replacement</li>
                        <li>Sanitizing user input</li>
                        <li>URL slug generation</li>
                        <li>Text formatting</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><code>str_ireplace()</code> - Case-insensitive version</li>
                        <li><a href="substr.jsp">substr()</a> - Extract part of a string</li>
                        <li><a href="strpos.jsp">strpos()</a> - Find position of substring</li>
                        <li><code>preg_replace()</code> - Regex-based replacement</li>
                    </ul>
                </div>


                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="strlen.jsp" />
                    <jsp:param name="prevTitle" value="strlen()" />
                    <jsp:param name="nextLink" value="substr.jsp" />
                    <jsp:param name="nextTitle" value="substr()" />
                    <jsp:param name="currentLessonId" value="str_replace" />
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
