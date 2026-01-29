<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "map" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python map() Function - Apply Function to Items | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python map() function. Apply a given function to each item of an iterable (list, tuple etc.) and return a map object.">
            <meta name="keywords"
                content="python map function, python functional programming, map list python, python map example">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/map.jsp">
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
        "headline": "Python map() Function",
        "description": "The map() function executes a specified function for each item in an iterable. The item is sent to the function as a parameter.",
        "articleSection": "Python Built-in Functions",
        "keywords": "python, map, functional",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-map">
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
                                    <span>map()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python map() Function</h1>
                                    <div class="lesson-meta">
                                        <span>Built-in Function</span>
                                        <span>•</span>
                                        <span>Functional</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>map()</code> function executes a specified function for each item in
                                        an iterable. The item is sent to the function as a parameter.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>map(function, iterables)</code></pre>

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
                                                    <td><code>function</code></td>
                                                    <td>Required. The function to execute for each item</td>
                                                </tr>
                                                <tr>
                                                    <td><code>iterables</code></td>
                                                    <td>Required. A sequence, collection or an iterator object. You can
                                                        send as many iterables as you like, just make sure the function
                                                        has one parameter for each iterable</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A map object (which is an iterator).</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>map()</code> function:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile" value="python-functions/map.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="filter.jsp" class="related-link">
                                            <span class="related-icon">🔍</span>
                                            <div>
                                                <strong>filter()</strong>
                                                <span>Filter items</span>
                                            </div>
                                        </a>
                                        <a href="zip.jsp" class="related-link">
                                            <span class="related-icon">🔗</span>
                                            <div>
                                                <strong>zip()</strong>
                                                <span>Combine iterables</span>
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
