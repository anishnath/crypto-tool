<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "re_match" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python re.match() - Match Pattern at Start | Live Examples</title>
            <meta name="description"
                content="Learn how to use Python's re.match() method. Matches a regular expression pattern at the beginning of a string. Syntax and examples.">
            <meta name="keywords"
                content="python re.match, python regex match, python pattern matching, python regular expressions">
    <meta property="og:title" content="Python re.match() - Match Pattern at Start | Live Examples">
    <meta property="og:description" content="Python re.match() checks if pattern matches at beginning of string. Interactive examples. Syntax: re.match(pattern, string). Regex matching. Try online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python re.match() checks if pattern matches at beginning of string. Interactive examples. Syntax: re.match(pattern, string). Regex matching. Try online!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/re_match.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "TechArticle",
        "headline": "Python re.match() Method",
        "description": "The re.match() method checks for a match only at the beginning of the string.",
        "articleSection": "Python Regular Expressions",
        "keywords": "python, re, match, regex",
        "datePublished": "2026-01-29",
        "dateModified": "2026-01-29",
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "logo": {
                "@type": "ImageObject",
                "url": "https://8gwifi.org/tutorials/assets/images/logo.svg"
            }
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="python-functions-re-match">
            <div class="tutorial-layout has-ad-rail">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-python-functions.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content" >
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/">Functions</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>re.match()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python re.match() Method</h1>
                                    <div class="lesson-meta">
                                        <span>Regular Expressions</span>
                                        <span>•</span>
                                        <span>Pattern Matching</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>re.match()</code> method checks for a match only at the beginning of
                                        the string.
                                    </p>
                                    <p>If the pattern is found at the start, it returns a match object; otherwise, it
                                        returns <code>None</code>.</p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>re.match(pattern, string, flags=0)</code></pre>

                                    <h2>Parameters</h2>
                                    <div class="table-responsive">
                                        <table class="reference-table">
                                            <thead>
                                                <tr>
                                                    <th>Parameter</th>
                                                    <th>Description</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><code>pattern</code></td>
                                                    <td>Required. The regular expression pattern to match.</td>
                                                </tr>
                                                <tr>
                                                    <td><code>string</code></td>
                                                    <td>Required. The string to search.</td>
                                                </tr>
                                                <tr>
                                                    <td><code>flags</code></td>
                                                    <td>Optional. Modify the matching behavior (e.g., re.IGNORECASE).
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A match object if the pattern matches at the beginning, otherwise
                                        <code>None</code>.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>re.match()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/re_match.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="re_search.jsp" class="related-link">
                                            <span class="related-icon">🔍</span>
                                            <div>
                                                <strong>re.search()</strong>
                                                <span>Search anywhere</span>
                                            </div>
                                        </a>
                                        <a href="re_findall.jsp" class="related-link">
                                            <span class="related-icon">📋</span>
                                            <div>
                                                <strong>re.findall()</strong>
                                                <span>Find all matches</span>
                                            </div>
                                        </a>
                                    </div>
                                </div>


                                                        </article>

                            <%-- Right Ad Rail (desktop only) --%>
                            <%@ include file="../tutorial-ad-rail.jsp" %>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

        </html>
