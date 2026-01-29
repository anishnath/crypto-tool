<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "sorted" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python sorted() Function - Sort Iterable | Live Demo</title>
            <meta name="description"
                content="Learn how to use the Python sorted() function. Returns a sorted list from an iterable object. Sort by key, reverse sort examples.">
            <meta name="keywords"
                content="python sorted function, python sort list, python sort by key, python reverse sort">
    <meta property="og:title" content="Python sorted() Function - Sort Iterable | Live Demo">
    <meta property="og:description" content="Python sorted() returns new sorted list from iterable. Interactive examples. Syntax: sorted(iterable, key, reverse). Non-destructive sorting. Try online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python sorted() returns new sorted list from iterable. Interactive examples. Syntax: sorted(iterable, key, reverse). Non-destructive sorting. Try online!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/sorted.jsp">
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
        "headline": "Python sorted() Function",
        "description": "The sorted() function returns a sorted list of the specified iterable object.",
        "articleSection": "Python Built-in Functions",
        "keywords": "python, sorted, sort, list",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-sorted">
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
                                    <span>sorted()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python sorted() Function</h1>
                                    <div class="lesson-meta">
                                        <span>Built-in Function</span>
                                        <span>•</span>
                                        <span>Sorting</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>sorted()</code> function returns a sorted list of the specified
                                        iterable object.
                                    </p>
                                    <p>
                                        You can specify ascending or descending order. Strings are sorted
                                        alphabetically, and numbers are sorted numerically.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre
                                        class="language-python"><code>sorted(iterable, key=key, reverse=reverse)</code></pre>

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
                                                    <td><code>iterable</code></td>
                                                    <td>Required. The sequence to sort (list, dictionary, tuple, etc.)
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><code>key</code></td>
                                                    <td>Optional. A function to execute to decide the order. Default is
                                                        None</td>
                                                </tr>
                                                <tr>
                                                    <td><code>reverse</code></td>
                                                    <td>Optional. A Boolean. False will sort ascending, True will sort
                                                        descending. Default is False</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A new list containing the sorted elements.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>sorted()</code> function:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/sorted.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="list_sort.jsp" class="related-link">
                                            <span class="related-icon">📋</span>
                                            <div>
                                                <strong>list.sort()</strong>
                                                <span>Sort a list in place</span>
                                            </div>
                                        </a>
                                        <a href="list_reverse.jsp" class="related-link">
                                            <span class="related-icon">↩️</span>
                                            <div>
                                                <strong>list.reverse()</strong>
                                                <span>Reverse a list</span>
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
