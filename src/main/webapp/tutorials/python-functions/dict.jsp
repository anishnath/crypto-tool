<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "dict" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python dict() Function - Create Dictionaries | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python dict() function. Creates a dictionary (hash map) key-value pairs. Syntax, parameters, and examples.">
            <meta name="keywords"
                content="python dict function, python create dict, python dictionary, python key value pair">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/dict.jsp">
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
        "headline": "Python dict() Function",
        "description": "The dict() function creates a dictionary. A dictionary is a collection which is unordered, changeable and indexed.",
        "articleSection": "Python Type Conversion",
        "keywords": "python, dict, dictionary, map",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-dict">
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
                                    <span>dict()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python dict() Function</h1>
                                    <div class="lesson-meta">
                                        <span>Type Conversion</span>
                                        <span>•</span>
                                        <span>Key-Value Store</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>dict()</code> function creates a dictionary. A dictionary is a
                                        collection which is unordered, changeable and indexed.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>dict(keyword arguments)</code></pre>
                                    <p>Or</p>
                                    <pre class="language-python"><code>dict(iterable)</code></pre>
                                    <p>Or</p>
                                    <pre class="language-python"><code>dict(mapping)</code></pre>


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
                                                    <td><code>keyword arguments</code></td>
                                                    <td>Optional. Keyword arguments: key=value, key=value...</td>
                                                </tr>
                                                <tr>
                                                    <td><code>iterable</code></td>
                                                    <td>Optional. An iterable with key:value pairs.</td>
                                                </tr>
                                                <tr>
                                                    <td><code>mapping</code></td>
                                                    <td>Optional. A mapping object (like another dictionary).</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A dictionary object.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>dict()</code> function:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/dict.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="list.jsp" class="related-link">
                                            <span class="related-icon">📋</span>
                                            <div>
                                                <strong>list()</strong>
                                                <span>Convert to list</span>
                                            </div>
                                        </a>
                                        <a href="set.jsp" class="related-link">
                                            <span class="related-icon">⭕</span>
                                            <div>
                                                <strong>set()</strong>
                                                <span>Convert to set</span>
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
