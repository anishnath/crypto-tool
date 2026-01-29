<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "list_reverse" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python list.reverse() Method - Reverse List Order | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python list.reverse() method. Reverses the sorting order of the elements. Syntax and examples.">
            <meta name="keywords"
                content="python reverse method, python list reverse, reverse list python, python array reverse">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/list_reverse.jsp">
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
        "headline": "Python list.reverse() Method",
        "description": "The reverse() method reverses the sorting order of the elements.",
        "articleSection": "Python List Methods",
        "keywords": "python, list, reverse, order",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-list-reverse">
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
                                    <span>list.reverse()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python list.reverse() Method</h1>
                                    <div class="lesson-meta">
                                        <span>List Method</span>
                                        <span>•</span>
                                        <span>Reverse</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>reverse()</code> method reverses the sorting order of the elements.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>list.reverse()</code></pre>

                                    <h2>Parameters</h2>
                                    <p>No parameters.</p>

                                    <h2>Return Value</h2>
                                    <p>None. The list is modified in place.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>reverse()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/list_reverse.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="list_sort.jsp" class="related-link">
                                            <span class="related-icon">🔃</span>
                                            <div>
                                                <strong>list.sort()</strong>
                                                <span>Sort list</span>
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