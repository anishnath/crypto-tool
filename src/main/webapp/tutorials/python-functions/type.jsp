<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "type" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python type() Function - Get Object Type | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python type() function. Returns the type of an object or creates a new type object. Syntax, parameters, and examples.">
            <meta name="keywords"
                content="python type function, python check type, type checking python, python dynamic class creation">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/type.jsp">
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
        "headline": "Python type() Function",
        "description": "The type() function creates a new type or returns the type of the specified object.",
        "articleSection": "Python Built-in Functions",
        "keywords": "python, type, introspection",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-type">
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
                                    <span>type()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python type() Function</h1>
                                    <div class="lesson-meta">
                                        <span>Built-in Function</span>
                                        <span>•</span>
                                        <span>Introspection</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>type()</code> function either returns the type of the object or
                                        returns a new type object based on the arguments passed.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>type(object)
type(name, bases, dict)</code></pre>

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
                                                    <td><code>object</code></td>
                                                    <td>Required (if only one argument). The object whose type you want
                                                        to get</td>
                                                </tr>
                                                <tr>
                                                    <td><code>name</code></td>
                                                    <td>String. Proposed name for the class</td>
                                                </tr>
                                                <tr>
                                                    <td><code>bases</code></td>
                                                    <td>Tuple. Base classes the new class inherits from</td>
                                                </tr>
                                                <tr>
                                                    <td><code>dict</code></td>
                                                    <td>Dictionary. Namespace definition for the class</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>Returns the type of the object (if one argument) or a new type object (if three
                                        arguments).</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>type()</code> function:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/type.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="isinstance.jsp" class="related-link">
                                            <span class="related-icon">🔍</span>
                                            <div>
                                                <strong>isinstance()</strong>
                                                <span>Check instance type</span>
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
