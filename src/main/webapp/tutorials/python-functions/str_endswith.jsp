<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "str_endswith" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python str.endswith() Method - Check String End | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python str.endswith() method. Returns True if the string ends with the specified value. Syntax, parameters, and examples.">
            <meta name="keywords"
                content="python endswith method, python string endswith, check string end python, python string check">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/str_endswith.jsp">
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
        "headline": "Python str.endswith() Method",
        "description": "The endswith() method returns True if the string ends with the specified value, otherwise False.",
        "articleSection": "Python String Methods",
        "keywords": "python, string, endswith, check",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-str-endswith">
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
                                    <span>str.endswith()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python str.endswith() Method</h1>
                                    <div class="lesson-meta">
                                        <span>String Method</span>
                                        <span>•</span>
                                        <span>Boolean Check</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>endswith()</code> method returns True if the string ends with the
                                        specified value, otherwise False.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>string.endswith(value, start, end)</code></pre>

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
                                                    <td><code>value</code></td>
                                                    <td>Required. The value to check if the string ends with. Can be a
                                                        string or a tuple of strings</td>
                                                </tr>
                                                <tr>
                                                    <td><code>start</code></td>
                                                    <td>Optional. Where to start the search</td>
                                                </tr>
                                                <tr>
                                                    <td><code>end</code></td>
                                                    <td>Optional. Where to end the search</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>Boolean. True if found, otherwise False.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>endswith()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/str_endswith.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="str_startswith.jsp" class="related-link">
                                            <span class="related-icon">🔜</span>
                                            <div>
                                                <strong>str.startswith()</strong>
                                                <span>Check string start</span>
                                            </div>
                                        </a>
                                        <a href="str_find.jsp" class="related-link">
                                            <span class="related-icon">🔍</span>
                                            <div>
                                                <strong>str.find()</strong>
                                                <span>Find substring</span>
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