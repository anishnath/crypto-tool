<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "dict_setdefault" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python dict.setdefault() Method - Get or Set Dictionary Item | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python dict.setdefault() method. Returns the value of the specified key. If the key does not exist: insert the key, with the specified value. Syntax and examples.">
            <meta name="keywords"
                content="python setdefault method, python dict setdefault, setdefault dictionary python, python get or set">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/dict_setdefault.jsp">
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
        "headline": "Python dict.setdefault() Method",
        "description": "The setdefault() method returns the value of the item with the specified key. If the key does not exist, insert the key, with the specified value.",
        "articleSection": "Python Dictionary Methods",
        "keywords": "python, dict, setdefault, modify",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-dict-setdefault">
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
                                    <span>dict.setdefault()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python dict.setdefault() Method</h1>
                                    <div class="lesson-meta">
                                        <span>Dictionary Method</span>
                                        <span>•</span>
                                        <span>Get or Set</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>setdefault()</code> method returns the value of the item with the
                                        specified key.
                                    </p>
                                    <p>
                                        If the key does not exist, insert the key, with the specified value.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre
                                        class="language-python"><code>dictionary.setdefault(keyname, value)</code></pre>

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
                                                    <td><code>keyname</code></td>
                                                    <td>Required. The keyname of the item you want to return the value
                                                        from</td>
                                                </tr>
                                                <tr>
                                                    <td><code>value</code></td>
                                                    <td>Optional. If the key exists, this parameter has no effect. If
                                                        the key does not exist, this value becomes the key's value.
                                                        Default value None</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>The value of the item with the specified key.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>setdefault()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/dict_setdefault.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="dict_get.jsp" class="related-link">
                                            <span class="related-icon">🔍</span>
                                            <div>
                                                <strong>dict.get()</strong>
                                                <span>Get item</span>
                                            </div>
                                        </a>
                                        <a href="dict_update.jsp" class="related-link">
                                            <span class="related-icon">🔄</span>
                                            <div>
                                                <strong>dict.update()</strong>
                                                <span>Update dictionary</span>
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
