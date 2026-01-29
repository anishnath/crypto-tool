<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "set" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python set() Function - Create Set | Live Examples</title>
            <meta name="description"
                content="Learn how to use the Python set() function. Creates a set object. A set is a collection which is unordered and unindexed. Syntax and examples.">
            <meta name="keywords"
                content="python set function, python create set, python variable types, python set example">
    <meta property="og:title" content="Python set() Function - Create Set | Live Examples">
    <meta property="og:description" content="Python set() creates a set from iterable with unique elements. Interactive examples. Syntax: set(iterable). Remove duplicates automatically. Try online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python set() creates a set from iterable with unique elements. Interactive examples. Syntax: set(iterable). Remove duplicates automatically. Try online!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/set.jsp">
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
        "headline": "Python set() Function",
        "description": "The set() function creates a set object. A set is a collection which is unordered and unindexed.",
        "articleSection": "Python Type Conversion",
        "keywords": "python, set, conversion, collection",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-set">
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
                                    <span>set()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python set() Function</h1>
                                    <div class="lesson-meta">
                                        <span>Type Conversion</span>
                                        <span>•</span>
                                        <span>Set</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>set()</code> function creates a set object. A set is a collection
                                        which is unordered, unchangeable*, and unindexed.
                                    </p>
                                    <p>
                                        * Note: Set items are unchangeable, but you can remove items and add new items.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>set(iterable)</code></pre>

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
                                                    <td>Optional. A sequence, collection or an iterator object</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A set object.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>set()</code> function:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile" value="python-functions/set.py" />
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
                                        <a href="tuple.jsp" class="related-link">
                                            <span class="related-icon">📦</span>
                                            <div>
                                                <strong>tuple()</strong>
                                                <span>Convert to tuple</span>
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
