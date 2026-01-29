<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "array_filter"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP array_filter() - Filter Array Elements Online | Example</title>
    <meta name="description"
        content="PHP array_filter() filters array elements using a callback. Remove empty values, filter by condition. Syntax: array_filter($array, $callback). Try online.">
    <meta name="keywords" content="php array_filter, array_filter php, php filter array, remove empty array php, array_filter example, php array callback">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/array_filter.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP array_filter() - Filter Array Elements with Examples">
    <meta property="og:description" content="Learn PHP array_filter() to remove empty values and filter arrays. Callback functions, key filtering. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/array_filter.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP array_filter() - Filter Arrays Online">
    <meta name="twitter:description" content="PHP array_filter() removes empty values and filters arrays. Try online with examples.">

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
        "headline": "PHP array_filter() Function - Filter Array Elements",
        "description": "Complete guide to PHP array_filter() function. Remove empty values, filter with callbacks, and use key filtering with practical examples.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/array_filter.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php array_filter, filter array php, remove empty values php",
        "proficiencyLevel": "Intermediate",
        "dependencies": "PHP 4.0.6+"
    }
    </script>

    <%-- HowTo Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Filter Array Elements in PHP using array_filter()",
        "description": "Use PHP array_filter() to filter elements based on a condition or remove empty values.",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Remove empty values (no callback)",
                "text": "Call array_filter($array) without callback to remove falsy values",
                "position": 1
            },
            {
                "@type": "HowToStep",
                "name": "Filter with callback",
                "text": "Use: array_filter($array, fn($x) => $x > 10) to keep elements > 10",
                "position": 2
            },
            {
                "@type": "HowToStep",
                "name": "Reindex if needed",
                "text": "Use array_values() to reindex the filtered array",
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
                "name": "How to remove empty values from array in PHP?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Use array_filter($array) without a callback. It removes all falsy values including empty strings, 0, null, and false."
                }
            },
            {
                "@type": "Question",
                "name": "Does array_filter() preserve keys?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, array_filter() preserves original keys. Use array_values(array_filter($arr)) to reindex starting from 0."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between array_filter() and array_map()?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "array_filter() removes elements based on a condition (may return fewer elements). array_map() transforms elements (always returns same count)."
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
            {"@type": "ListItem", "position": 3, "name": "array_filter()"}
        ]
    }
    </script>

    <%-- SoftwareSourceCode Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareSourceCode",
        "name": "PHP array_filter() Example",
        "programmingLanguage": "PHP",
        "codeSampleType": "code snippet",
        "text": "<?php\n$numbers = [1, 2, 3, 4, 5, 6];\n$even = array_filter($numbers, fn($n) => $n % 2 === 0);\nprint_r($even);\n// [2, 4, 6]\n?>"
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="array_filter">
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
                    <span>array_filter()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP array_filter() Function</h1>
                    <div class="lesson-meta">
                        <span>Array Function</span>
                        <span>PHP 4.0.6+</span>
                    </div>
                </header>


                <div class="lesson-body">
                    <p class="lead">The <code>array_filter()</code> function filters elements of an array using a callback function, returning only elements that pass the test.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">array_filter(
    array $array,
    ?callable $callback = null,
    int $mode = 0
): array</code></pre>

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
                                <td><code>$array</code></td>
                                <td>array</td>
                                <td>The array to filter</td>
                            </tr>
                            <tr>
                                <td><code>$callback</code></td>
                                <td>callable|null</td>
                                <td>The callback function. If null, removes falsy values.</td>
                            </tr>
                            <tr>
                                <td><code>$mode</code></td>
                                <td>int</td>
                                <td>ARRAY_FILTER_USE_KEY or ARRAY_FILTER_USE_BOTH</td>
                            </tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns a filtered array. Keys are preserved.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/array_filter.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="array-filter-demo" />
                    </jsp:include>


                    <h2>More Examples</h2>

                    <h3>Remove Empty Values</h3>
                    <pre><code class="language-php">&lt;?php
$data = ["hello", "", "world", null, 0, false, "php"];

// Without callback - removes all falsy values
$filtered = array_filter($data);
print_r($filtered);
// ["hello", "world", "php"] (indices: 0, 2, 6)
?&gt;</code></pre>

                    <h3>Filter with Callback</h3>
                    <pre><code class="language-php">&lt;?php
$numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Keep only even numbers
$even = array_filter($numbers, fn($n) => $n % 2 === 0);
print_r($even);
// [2, 4, 6, 8, 10]
?&gt;</code></pre>

                    <h3>Filter by Key</h3>
                    <pre><code class="language-php">&lt;?php
$data = [
    "name" => "John",
    "email" => "john@test.com",
    "password" => "secret",
    "age" => 30
];

// Keep only specific keys
$allowed = ["name", "email", "age"];
$filtered = array_filter(
    $data,
    fn($key) => in_array($key, $allowed),
    ARRAY_FILTER_USE_KEY
);
print_r($filtered);
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Note:</strong> <code>array_filter()</code> preserves keys. Use <code>array_values()</code> to reindex if needed.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Removing empty/null values from arrays</li>
                        <li>Filtering user input</li>
                        <li>Selecting items matching criteria</li>
                        <li>Data validation and cleaning</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="array_map.jsp">array_map()</a> - Transform array elements</li>
                        <li><a href="array_values.jsp">array_values()</a> - Reindex array</li>
                        <li><a href="in_array.jsp">in_array()</a> - Check if value exists</li>
                    </ul>
                </div>


                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="array_map.jsp" />
                    <jsp:param name="prevTitle" value="array_map()" />
                    <jsp:param name="nextLink" value="array_merge.jsp" />
                    <jsp:param name="nextTitle" value="array_merge()" />
                    <jsp:param name="currentLessonId" value="array_filter" />
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
