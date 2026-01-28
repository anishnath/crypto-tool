<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "json_encode"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP json_encode() - Convert Array to JSON Online | Example</title>
    <meta name="description"
        content="PHP json_encode() converts PHP arrays and objects to JSON. Syntax: json_encode($value, $flags). Pretty print, API responses. Try online with examples.">
    <meta name="keywords" content="php json_encode, json_encode php, php array to json, php object to json, json_encode example, php json pretty print">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/json_encode.jsp">

    <%-- Open Graph --%>
    <meta property="og:title" content="PHP json_encode() - Convert to JSON with Examples">
    <meta property="og:description" content="Learn PHP json_encode() to convert arrays to JSON. Pretty print, flags, API responses. Try online free.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/json_encode.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="PHP json_encode() - Array to JSON Online">
    <meta name="twitter:description" content="PHP json_encode() converts arrays/objects to JSON. Try online with examples.">

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
        "headline": "PHP json_encode() Function - Convert to JSON",
        "description": "Complete guide to PHP json_encode() function. Convert arrays and objects to JSON, use flags for formatting, and build API responses.",
        "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2025-01-01",
        "dateModified": "2025-01-28",
        "mainEntityOfPage": {"@type": "WebPage", "@id": "https://8gwifi.org/tutorials/php-functions/json_encode.jsp"},
        "image": "https://8gwifi.org/tutorials/assets/images/php-logo.svg",
        "articleSection": "PHP Functions",
        "keywords": "php json_encode, array to json php, php json",
        "proficiencyLevel": "Beginner",
        "dependencies": "PHP 5.2.0+"
    }
    </script>

    <%-- HowTo Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Convert PHP Array to JSON using json_encode()",
        "description": "Use PHP json_encode() to convert arrays and objects to JSON format.",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Prepare your data",
                "text": "Create an array or object: $data = ['name' => 'John', 'age' => 30]",
                "position": 1
            },
            {
                "@type": "HowToStep",
                "name": "Call json_encode()",
                "text": "Use: $json = json_encode($data)",
                "position": 2
            },
            {
                "@type": "HowToStep",
                "name": "Use flags for formatting",
                "text": "Add JSON_PRETTY_PRINT for readable output: json_encode($data, JSON_PRETTY_PRINT)",
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
                "name": "How to convert PHP array to JSON?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Use json_encode($array). Example: json_encode(['name' => 'John']) returns '{\"name\":\"John\"}'."
                }
            },
            {
                "@type": "Question",
                "name": "How to pretty print JSON in PHP?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Use JSON_PRETTY_PRINT flag: json_encode($data, JSON_PRETTY_PRINT) adds indentation and line breaks."
                }
            },
            {
                "@type": "Question",
                "name": "What does json_encode return on failure?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "json_encode() returns false on failure. Use json_last_error() and json_last_error_msg() to get error details."
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
            {"@type": "ListItem", "position": 3, "name": "json_encode()"}
        ]
    }
    </script>

    <%-- SoftwareSourceCode Schema --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareSourceCode",
        "name": "PHP json_encode() Example",
        "programmingLanguage": "PHP",
        "codeSampleType": "code snippet",
        "text": "<?php\n$data = ['name' => 'John', 'age' => 30];\necho json_encode($data, JSON_PRETTY_PRINT);\n// {\"name\": \"John\", \"age\": 30}\n?>"
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="json_encode">
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
                    <span>json_encode()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP json_encode() Function</h1>
                    <div class="lesson-meta">
                        <span>JSON Function</span>
                        <span>PHP 5.2.0+</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>json_encode()</code> function converts a PHP value (array, object, etc.) to a JSON-formatted string.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">json_encode(mixed $value, int $flags = 0, int $depth = 512): string|false</code></pre>

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
                                <td><code>$value</code></td>
                                <td>mixed</td>
                                <td>The value to encode (array, object, string, number, etc.)</td>
                            </tr>
                            <tr>
                                <td><code>$flags</code></td>
                                <td>int</td>
                                <td>Bitmask of JSON constants (optional)</td>
                            </tr>
                            <tr>
                                <td><code>$depth</code></td>
                                <td>int</td>
                                <td>Maximum nesting depth (default: 512)</td>
                            </tr>
                        </tbody>
                    </table>

                    <h2>Return Value</h2>
                    <p>Returns a JSON encoded string on success, or <code>false</code> on failure.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/json_encode.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="json-encode-demo" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Common Flags</h2>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Flag</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>JSON_PRETTY_PRINT</code></td>
                                <td>Format output with whitespace for readability</td>
                            </tr>
                            <tr>
                                <td><code>JSON_UNESCAPED_UNICODE</code></td>
                                <td>Don't escape Unicode characters</td>
                            </tr>
                            <tr>
                                <td><code>JSON_UNESCAPED_SLASHES</code></td>
                                <td>Don't escape forward slashes</td>
                            </tr>
                            <tr>
                                <td><code>JSON_FORCE_OBJECT</code></td>
                                <td>Output object instead of array</td>
                            </tr>
                            <tr>
                                <td><code>JSON_NUMERIC_CHECK</code></td>
                                <td>Encode numeric strings as numbers</td>
                            </tr>
                        </tbody>
                    </table>

                    <h2>More Examples</h2>

                    <h3>Pretty Print</h3>
                    <pre><code class="language-php">&lt;?php
$data = [
    "name" => "John",
    "age" => 30,
    "city" => "NYC"
];

echo json_encode($data, JSON_PRETTY_PRINT);
/*
{
    "name": "John",
    "age": 30,
    "city": "NYC"
}
*/
?&gt;</code></pre>

                    <h3>Combining Flags</h3>
                    <pre><code class="language-php">&lt;?php
$data = [
    "url" => "https://example.com/api",
    "message" => "Hello World!"
];

$json = json_encode($data,
    JSON_PRETTY_PRINT |
    JSON_UNESCAPED_SLASHES |
    JSON_UNESCAPED_UNICODE
);
echo $json;
?&gt;</code></pre>

                    <h3>API Response</h3>
                    <pre><code class="language-php">&lt;?php
header('Content-Type: application/json');

$response = [
    "success" => true,
    "data" => [
        "id" => 123,
        "name" => "Product"
    ]
];

echo json_encode($response);
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> Always check for errors using <code>json_last_error()</code> after encoding, especially with user-provided data.
                    </div>

                    <h2>Common Use Cases</h2>
                    <ul>
                        <li>Building REST API responses</li>
                        <li>Storing data in databases</li>
                        <li>Passing data to JavaScript</li>
                        <li>Configuration file generation</li>
                    </ul>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="json_decode.jsp">json_decode()</a> - Decode a JSON string</li>
                        <li><code>json_last_error()</code> - Get last JSON error</li>
                        <li><code>json_last_error_msg()</code> - Get error message</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="./" />
                    <jsp:param name="prevTitle" value="All Functions" />
                    <jsp:param name="nextLink" value="json_decode.jsp" />
                    <jsp:param name="nextTitle" value="json_decode()" />
                    <jsp:param name="currentLessonId" value="json_encode" />
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
