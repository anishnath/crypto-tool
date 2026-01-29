<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "str_split" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python str.split() - Split String into List | Live Demo</title>
            <meta name="description"
                content="Learn how to use the Python str.split() method. Splits a string into a list where each word is a list item. Syntax, parameters, and examples.">
            <meta name="keywords"
                content="python split method, python string split, split string to list python, python split string by space">
    <meta property="og:title" content="Python str.split() - Split String into List | Live Demo">
    <meta property="og:description" content="Python str.split() splits a string into a list using a delimiter. Interactive examples with live editor. Syntax: string.split(separator, maxsplit). Try it free!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python str.split() splits a string into a list using a delimiter. Interactive examples with live editor. Syntax: string.split(separator, maxsplit). Try it free!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/str_split.jsp">
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
        "headline": "Python str.split() Method",
        "description": "The split() method splits a string into a list. You can specify the separator, default separator is any whitespace.",
        "articleSection": "Python String Methods",
        "keywords": "python, string, split, list",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-str-split">
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
                                    <span>str.split()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python str.split() Method</h1>
                                    <div class="lesson-meta">
                                        <span>String Method</span>
                                        <span>•</span>
                                        <span>Split</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>split()</code> method splits a string into a list.
                                    </p>
                                    <p>
                                        You can specify the separator, default separator is any whitespace. When the
                                        maxsplit argument is returned, the list will contain the specified number of
                                        elements plus one.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>string.split(separator, maxsplit)</code></pre>

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
                                                    <td><code>separator</code></td>
                                                    <td>Optional. Specifies the separator to use when splitting the
                                                        string. Default is whitespace</td>
                                                </tr>
                                                <tr>
                                                    <td><code>maxsplit</code></td>
                                                    <td>Optional. Specifies how many splits to do. Default value is -1
                                                        (all occurrences)</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A list of strings.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>split()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/str_split.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="str_join.jsp" class="related-link">
                                            <span class="related-icon">🔗</span>
                                            <div>
                                                <strong>str.join()</strong>
                                                <span>Join strings</span>
                                            </div>
                                        </a>
                                        <a href="str_replace.jsp" class="related-link">
                                            <span class="related-icon">🔄</span>
                                            <div>
                                                <strong>str.replace()</strong>
                                                <span>Replace substring</span>
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
