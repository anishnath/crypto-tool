<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "array_map"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP array_map() - Transform Array Elements Online | Example</title>
    <meta name="description"
        content="PHP array_map() applies a callback to each array element. Syntax: array_map($callback, $array). Transform, convert, and process arrays. Try online.">
    <meta name="keywords" content="php array_map, array_map php, php array transform, php callback array, array_map example, php map function">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/array_map.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP array_map() - Transform Array Elements with Examples">
    <meta property="og:description" content="Learn PHP array_map() to apply callbacks to arrays. Arrow functions, multiple arrays. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/array_map.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP array_map() - Transform Arrays Online">
    <meta name="twitter:description" content="PHP array_map() applies callback to array elements. Try online with examples.">

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
        "headline": "PHP array_map() Function - Transform Array Elements",
        "description": "Complete guide to PHP array_map() function. Apply callbacks, use arrow functions, process multiple arrays with practical examples.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/array_map.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php array_map, array transform php, callback array php",
        "proficiencyLevel": "Intermediate",
        "dependencies": "PHP 4.0.6+"
    }
    </script>

    <%-- HowTo Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Transform Array Elements in PHP using array_map()",
        "description": "Use PHP array_map() to apply a function to each element of an array.",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Define your callback function",
                "text": "Create a function or use an arrow function: fn($x) => $x * 2",
                "position": 1
            },
            {
                "@type": "HowToStep",
                "name": "Call array_map()",
                "text": "Use: array_map($callback, $array)",
                "position": 2
            },
            {
                "@type": "HowToStep",
                "name": "Use the transformed array",
                "text": "array_map() returns a new array with transformed elements",
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
                "name": "What does array_map() do in PHP?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "array_map() applies a callback function to each element of an array and returns a new array with the transformed values. Example: array_map(fn($n) => $n * 2, [1,2,3]) returns [2,4,6]."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between array_map() and array_filter()?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "array_map() transforms elements (returns same count), while array_filter() removes elements based on a condition (may return fewer elements)."
                }
            },
            {
                "@type": "Question",
                "name": "Can array_map() work with multiple arrays?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, pass multiple arrays and a callback that accepts multiple parameters: array_map(fn($a, $b) => $a + $b, $arr1, $arr2)."
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
            {"@type": "ListItem", "position": 3, "name": "array_map()"}
        ]
    }
    </script>

    <%-- SoftwareSourceCode Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareSourceCode",
        "name": "PHP array_map() Example",
        "programmingLanguage": "PHP",
        "codeSampleType": "code snippet",
        "text": "<?php\n$numbers = [1, 2, 3, 4, 5];\n$squared = array_map(fn($n) => $n * $n, $numbers);\nprint_r($squared);\n// [1, 4, 9, 16, 25]\n?>"
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="array_map">
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
                    <span>array_map()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP array_map() Function</h1>
                    <div class="lesson-meta">
                        <span>Array Function</span>
                        <span>PHP 4.0.6+</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>array_map()</code> function applies a callback function to each element of an array and returns a new array with the results.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">array_map(?callable $callback, array $array, array ...$arrays): array</code></pre>

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
                                <td><code>$callback</code></td>
                                <td>callable|null</td>
                                <td>A callback function to apply to each element</td>
                            </tr>
                            <tr>
                                <td><code>$array</code></td>
                                <td>array</td>
                                <td>The array to process</td>
                            </tr>
                            <tr>
                                <td><code>$arrays</code></td>
                                <td>array</td>
                                <td>Additional arrays (optional)</td>
                            </tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns a new array containing the results of applying the callback function to each element.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/array_map.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="array-map-demo" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>More Examples</h2>

                    <h3>Using Built-in Functions</h3>
                    <pre><code class="language-php">&lt;?php
$names = ["john", "jane", "bob"];

// Capitalize all names
$capitalized = array_map('ucfirst', $names);
print_r($capitalized);
// ["John", "Jane", "Bob"]
?&gt;</code></pre>

                    <h3>Using Arrow Functions (PHP 7.4+)</h3>
                    <pre><code class="language-php">&lt;?php
$numbers = [1, 2, 3, 4, 5];

// Square each number
$squares = array_map(fn($n) => $n * $n, $numbers);
print_r($squares);
// [1, 4, 9, 16, 25]
?&gt;</code></pre>

                    <h3>Multiple Arrays</h3>
                    <pre><code class="language-php">&lt;?php
$first = ["John", "Jane"];
$last = ["Doe", "Smith"];

// Combine first and last names
$full = array_map(fn($f, $l) => "$f $l", $first, $last);
print_r($full);
// ["John Doe", "Jane Smith"]
?&gt;</code></pre>

                    <h3>With null Callback (Zip Arrays)</h3>
                    <pre><code class="language-php">&lt;?php
$a = [1, 2, 3];
$b = ['a', 'b', 'c'];

$zipped = array_map(null, $a, $b);
print_r($zipped);
// [[1, 'a'], [2, 'b'], [3, 'c']]
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Tip:</strong> Unlike <code>array_filter()</code>, <code>array_map()</code> always returns an array with the same number of elements as the input.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Transforming data (e.g., formatting prices, dates)</li>
                        <li>Extracting values from objects/arrays</li>
                        <li>Applying calculations to all elements</li>
                        <li>Converting data types</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="array_filter.jsp">array_filter()</a> - Filter array elements</li>
                        <li><a href="array_keys.jsp">array_keys()</a> - Get array keys</li>
                        <li><a href="array_values.jsp">array_values()</a> - Get array values</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="./" />
                    <jsp:param name="prevTitle" value="All Functions" />
                    <jsp:param name="nextLink" value="array_filter.jsp" />
                    <jsp:param name="nextTitle" value="array_filter()" />
                    <jsp:param name="currentLessonId" value="array_map" />
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
