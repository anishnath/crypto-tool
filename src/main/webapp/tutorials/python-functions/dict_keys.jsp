<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "dict_keys" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python dict.keys() Method - Get Dictionary Keys | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python dict.keys() method. Returns a view object containing the keys of the dictionary. Syntax and examples.">
            <meta name="keywords"
                content="python keys method, python dict keys, get all keys python, iterate dictionary keys">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/dict_keys.jsp">
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
        "headline": "Python dict.keys() Method",
        "description": "The keys() method returns a view object. The view object contains the keys of the dictionary, as a list.",
        "articleSection": "Python Dictionary Methods",
        "keywords": "python, dict, keys, view",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-dict-keys">
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
                                    <span>dict.keys()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python dict.keys() Method</h1>
                                    <div class="lesson-meta">
                                        <span>Dictionary Method</span>
                                        <span>•</span>
                                        <span>Keys</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>keys()</code> method returns a view object. The view object contains
                                        the keys of the dictionary, as a list.
                                    </p>
                                    <p>
                                        The view object will reflect any changes done to the dictionary.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>dictionary.keys()</code></pre>

                                    <h2>Parameters</h2>
                                    <p>No parameters.</p>

                                    <h2>Return Value</h2>
                                    <p>A view object containing the keys.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>keys()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/dict_keys.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="dict_values.jsp" class="related-link">
                                            <span class="related-icon">🔢</span>
                                            <div>
                                                <strong>dict.values()</strong>
                                                <span>Get values</span>
                                            </div>
                                        </a>
                                        <a href="dict_items.jsp" class="related-link">
                                            <span class="related-icon">📋</span>
                                            <div>
                                                <strong>dict.items()</strong>
                                                <span>Get items</span>
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
