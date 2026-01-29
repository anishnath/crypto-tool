<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "sprintf"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP sprintf() - Format String Online | Example & Syntax</title>
    <meta name="description"
        content="PHP sprintf() returns a formatted string. Syntax: sprintf($format, $args). Number formatting, padding, placeholders. Try online with examples.">
    <meta name="keywords" content="php sprintf, sprintf php, php format string, sprintf example, php string format, printf php">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/sprintf.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP sprintf() - Format String with Examples">
    <meta property="og:description" content="Learn PHP sprintf() for string formatting. Placeholders, padding, numbers. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/sprintf.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP sprintf() - Format String Online">
    <meta name="twitter:description" content="PHP sprintf() formats strings with placeholders. Try online.">

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
        "headline": "PHP sprintf() Function - Format Strings",
        "description": "Complete guide to PHP sprintf() function. Format strings with placeholders, numbers, and padding.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/sprintf.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php sprintf, format string php, printf",
        "proficiencyLevel": "Intermediate",
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
                "name": "What is the difference between sprintf and printf?",
                "acceptedAnswer": {"@type": "Answer", "text": "sprintf() returns the formatted string, printf() outputs it directly. Use sprintf() when you need to store the result."}
            },
            {
                "@type": "Question",
                "name": "How to format a number with leading zeros?",
                "acceptedAnswer": {"@type": "Answer", "text": "Use %05d for 5-digit zero-padded: sprintf('%05d', 42) returns '00042'."}
            },
            {
                "@type": "Question",
                "name": "How to format currency in PHP?",
                "acceptedAnswer": {"@type": "Answer", "text": "Use %.2f for 2 decimal places: sprintf('$%.2f', 19.9) returns '$19.90'."}
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
            {"@type": "ListItem", "position": 3, "name": "sprintf()"}
        ]
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="sprintf">
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
                    <span>sprintf()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP sprintf() Function</h1>
                    <div class="lesson-meta">
                        <span>String Function</span>
                        <span>PHP 4+</span>
                    </div>
                </header>


                <div class="lesson-body">
                    <p class="lead">The <code>sprintf()</code> function returns a formatted string using placeholders.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">sprintf(string $format, mixed ...$values): string</code></pre>

                    <h2>Common Format Specifiers</h2>
                    <table class="info-table">
                        <thead>
                            <tr><th>Specifier</th><th>Description</th><th>Example</th></tr>
                        </thead>
                        <tbody>
                            <tr><td><code>%s</code></td><td>String</td><td>"Hello"</td></tr>
                            <tr><td><code>%d</code></td><td>Integer</td><td>42</td></tr>
                            <tr><td><code>%f</code></td><td>Float</td><td>3.14</td></tr>
                            <tr><td><code>%.2f</code></td><td>Float (2 decimals)</td><td>3.14</td></tr>
                            <tr><td><code>%05d</code></td><td>Zero-padded integer</td><td>00042</td></tr>
                        </tbody>
                    </table>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/sprintf.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="sprintf-demo" />
                    </jsp:include>


                    <h2>More Examples</h2>

                    <h3>Currency Formatting</h3>
                    <pre><code class="language-php">&lt;?php
$price = 19.9;
echo sprintf("Price: $%.2f", $price);
// "Price: $19.90"
?&gt;</code></pre>

                    <h3>Zero Padding</h3>
                    <pre><code class="language-php">&lt;?php
$num = 42;
echo sprintf("%05d", $num);  // "00042"
echo sprintf("%08d", $num);  // "00000042"
?&gt;</code></pre>

                    <h3>Multiple Values</h3>
                    <pre><code class="language-php">&lt;?php
$name = "John";
$age = 25;
echo sprintf("%s is %d years old", $name, $age);
// "John is 25 years old"
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Tip:</strong> Use <code>printf()</code> to output directly instead of returning the string.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Formatting prices and currency</li>
                        <li>Creating padded IDs (e.g., INV-00001)</li>
                        <li>Building log messages</li>
                        <li>Generating formatted reports</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><code>printf()</code> - Output formatted string</li>
                        <li><code>number_format()</code> - Format numbers with thousands</li>
                        <li><a href="str_replace.jsp">str_replace()</a> - Simple replacement</li>
                    </ul>
                </div>


                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="strtoupper.jsp" />
                    <jsp:param name="prevTitle" value="strtoupper()" />
                    <jsp:param name="nextLink" value="array_map.jsp" />
                    <jsp:param name="nextTitle" value="array_map()" />
                    <jsp:param name="currentLessonId" value="sprintf" />
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
