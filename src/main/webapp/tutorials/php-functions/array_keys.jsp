<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "array_keys"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP array_keys() - Get All Keys Online | Example</title>
    <meta name="description"
        content="PHP array_keys() returns all keys from an array. Syntax: array_keys($array). Get keys with specific value. Try online with examples.">
    <meta name="keywords" content="php array_keys, array_keys php, php get keys, array keys php, array_keys example">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/array_keys.jsp">

    <meta property="og:title" content="PHP array_keys() - Get All Array Keys">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/tutorials/php-functions/array_keys.jsp">
    <meta name="twitter:card" content="summary">

    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "TechArticle", "headline": "PHP array_keys() Function", "datePublished": "2025-01-01", "dateModified": "2025-01-28"}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "FAQPage", "mainEntity": [
        {"@type": "Question", "name": "How to get all keys from PHP array?", "acceptedAnswer": {"@type": "Answer", "text": "Use array_keys($array). Returns an indexed array of all keys."}},
        {"@type": "Question", "name": "Can array_keys find keys by value?", "acceptedAnswer": {"@type": "Answer", "text": "Yes, array_keys($arr, $value) returns only keys that have the specified value."}}
    ]}
    </script>

    <script type="application/ld+json">
    {"@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
        {"@type": "ListItem", "position": 1, "name": "Tutorials", "item": "https://8gwifi.org/tutorials/"},
        {"@type": "ListItem", "position": 2, "name": "PHP Functions", "item": "https://8gwifi.org/tutorials/php-functions/"},
        {"@type": "ListItem", "position": 3, "name": "array_keys()"}
    ]}
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="array_keys">
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
                    <span>array_keys()</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">PHP array_keys() Function</h1>
                    <div class="lesson-meta"><span>Array Function</span><span>PHP 4+</span></div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>array_keys()</code> function returns all the keys of an array.</p>

                    <h2>Syntax</h2>
                    <pre><code class="language-php">array_keys(array $array, mixed $filter_value, bool $strict = false): array</code></pre>

                    <h2>Return Value</h2>
                    <p>Returns an array of all keys, or keys with the specified value.</p>

                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php-functions/array_keys.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="array-keys-demo" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>

                    <h2>More Examples</h2>

                    <h3>Find Keys with Specific Value</h3>
                    <pre><code class="language-php">&lt;?php
$scores = ["John" => 85, "Jane" => 90, "Bob" => 85];
$keys = array_keys($scores, 85);
print_r($keys);  // ["John", "Bob"]
?&gt;</code></pre>

                    <h2>Related Functions</h2>
                    <ul>
                        <li><a href="array_values.jsp">array_values()</a> - Get all values</li>
                        <li><code>array_key_exists()</code> - Check if key exists</li>
                        <li><a href="in_array.jsp">in_array()</a> - Check if value exists</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="in_array.jsp" />
                    <jsp:param name="prevTitle" value="in_array()" />
                    <jsp:param name="nextLink" value="array_values.jsp" />
                    <jsp:param name="nextTitle" value="array_values()" />
                    <jsp:param name="currentLessonId" value="array_keys" />
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
