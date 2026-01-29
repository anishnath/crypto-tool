<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "strlen"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP strlen() - Get String Length Online | Example & Syntax</title>
    <meta name="description"
        content="PHP strlen() returns the length of a string. Try it online with live examples. Syntax: strlen($string). Common use: password validation, form input checks.">
    <meta name="keywords" content="php strlen, strlen php, php string length, strlen example, php count characters, strlen online, php strlen tutorial">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/strlen.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP strlen() Function - Get String Length with Examples">
    <meta property="og:description" content="Learn PHP strlen() to get string length. Interactive examples, syntax, and common use cases. Try it online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/strlen.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP strlen() - Get String Length Online">
    <meta name="twitter:description" content="PHP strlen() returns string length. Try online with live examples. Syntax: strlen($string)">

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
        "headline": "PHP strlen() Function - Get String Length",
        "description": "Complete guide to PHP strlen() function. Learn syntax, parameters, return values, and practical examples for getting string length in PHP.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/strlen.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php strlen, string length php, strlen function, php tutorial",
        "proficiencyLevel": "Beginner",
        "dependencies": "PHP 4+"
    }
    </script>

    <%-- HowTo Schema for Rich Snippets --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Get String Length in PHP using strlen()",
        "description": "Use PHP strlen() function to count the number of bytes in a string.",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Call strlen() with your string",
                "text": "Pass the string as parameter: strlen($myString)",
                "position": 1
            },
            {
                "@type": "HowToStep",
                "name": "Store or use the result",
                "text": "strlen() returns an integer representing the string length in bytes",
                "position": 2
            },
            {
                "@type": "HowToStep",
                "name": "For UTF-8, use mb_strlen()",
                "text": "For multibyte characters (emojis, unicode), use mb_strlen() instead",
                "position": 3
            }
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
                "name": "What does PHP strlen() return?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "strlen() returns an integer representing the number of bytes in the string. For ASCII strings, this equals the character count. For multibyte strings (UTF-8), use mb_strlen() for accurate character count."
                }
            },
            {
                "@type": "Question",
                "name": "How to check string length in PHP?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Use strlen($string) to get the length. Example: if (strlen($password) < 8) { echo 'Too short'; }"
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between strlen() and mb_strlen()?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "strlen() counts bytes, mb_strlen() counts characters. For UTF-8 strings with emojis or special characters, strlen() may return a higher number than the actual character count."
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
            {"@type": "ListItem", "position": 3, "name": "strlen()"}
        ]
    }
    </script>

    <%-- SoftwareSourceCode Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareSourceCode",
        "name": "PHP strlen() Example",
        "programmingLanguage": "PHP",
        "codeSampleType": "code snippet",
        "text": "<?php\n$text = \"Hello, World!\";\necho strlen($text);  // Output: 13\n?>"
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="strlen">
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
                    <span>strlen()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP strlen() Function</h1>
                    <div class="lesson-meta">
                        <span>String Function</span>
                        <span>PHP 4+</span>
                    </div>
                </header>


                <div class="lesson-body">
                    <p class="lead">The <code>strlen()</code> function returns the length of a string (number of bytes).</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">strlen(string $string): int</code></pre>

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
                                <td><code>$string</code></td>
                                <td>string</td>
                                <td>The string to measure</td>
                            </tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns the length of the string in bytes, or <code>0</code> if the string is empty.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/strlen.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="strlen-demo" />
                    </jsp:include>


                    <h2>More Examples</h2>

                    <h3>Basic Usage</h3>
                    <pre><code class="language-php">&lt;?php
$text = "Hello, World!";
echo strlen($text);  // Output: 13
?&gt;</code></pre>

                    <h3>Password Validation</h3>
                    <pre><code class="language-php">&lt;?php
$password = "abc123";

if (strlen($password) < 8) {
    echo "Password must be at least 8 characters!";
} else {
    echo "Password length is acceptable.";
}
?&gt;</code></pre>

                    <h3>Empty String Check</h3>
                    <pre><code class="language-php">&lt;?php
$empty = "";
$whitespace = "   ";

echo strlen($empty);       // 0
echo strlen($whitespace);  // 3 (spaces are counted)
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Note:</strong> <code>strlen()</code> counts bytes, not characters. For multibyte strings (UTF-8), use <code>mb_strlen()</code> instead.
                    </div>

                    <h3>Multibyte Strings</h3>
                    <pre><code class="language-php">&lt;?php
$emoji = "Hello! 👋";

echo strlen($emoji);      // 11 (bytes - emoji is 4 bytes)
echo mb_strlen($emoji);   // 8 (characters)
?&gt;</code></pre>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Form validation (minimum/maximum length)</li>
                        <li>Truncating strings</li>
                        <li>Checking if a string is empty</li>
                        <li>Padding strings to a certain length</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="substr.jsp">substr()</a> - Return part of a string</li>
                        <li><a href="str_replace.jsp">str_replace()</a> - Replace occurrences in a string</li>
                        <li><code>mb_strlen()</code> - Get string length for multibyte strings</li>
                    </ul>
                </div>


                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="./" />
                    <jsp:param name="prevTitle" value="All Functions" />
                    <jsp:param name="nextLink" value="str_replace.jsp" />
                    <jsp:param name="nextTitle" value="str_replace()" />
                    <jsp:param name="currentLessonId" value="strlen" />
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
