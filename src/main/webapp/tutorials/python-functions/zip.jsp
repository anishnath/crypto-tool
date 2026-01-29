<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "zip" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python zip() Function - Loop Over Parallel Lists | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python zip() function. Combine multiple iterables element by element. Syntax, parameters, and examples for parallel iteration.">
            <meta name="keywords"
                content="python zip function, zip lists python, python parallel iteration, zip example python">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/zip.jsp">
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
        "headline": "Python zip() Function",
        "description": "The zip() function returns a zip object, which is an iterator of tuples where the first item in each passed iterator is paired together, and so on.",
        "articleSection": "Python Built-in Functions",
        "keywords": "python, zip, iterator",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-zip">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-python-functions.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content" style="margin-right: 0;">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/">Functions</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>zip()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python zip() Function</h1>
                                    <div class="lesson-meta">
                                        <span>Built-in Function</span>
                                        <span>•</span>
                                        <span>Iterator</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>zip()</code> function returns a zip object, which is an iterator of
                                        tuples where the first item in each passed iterator is paired together, and then
                                        the second item in each passed iterator are paired together etc.
                                    </p>
                                    <p>
                                        If the passed iterators have different lengths, the iterator with the least
                                        items decides the length of the new iterator.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>zip(iterables)</code></pre>

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
                                                    <td><code>iterables</code></td>
                                                    <td>Optional. Iterables (list, tuple, etc.) to zip together</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A zip object (iterator of tuples).</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>zip()</code> function:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile" value="python-functions/zip.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="enumerate.jsp" class="related-link">
                                            <span class="related-icon">🔢</span>
                                            <div>
                                                <strong>enumerate()</strong>
                                                <span>Loop with index</span>
                                            </div>
                                        </a>
                                        <a href="map.jsp" class="related-link">
                                            <span class="related-icon">🗺️</span>
                                            <div>
                                                <strong>map()</strong>
                                                <span>Apply function to iterable</span>
                                            </div>
                                        </a>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

        </html>