<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "set_union" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python set.union() - Combine Sets | Live Demo</title>
            <meta name="description"
                content="Learn how to use the Python set.union() method. Returns a set containing the union of sets. Syntax and examples.">
            <meta name="keywords"
                content="python set union, python union method, merge sets python, combine sets python">
    <meta property="og:title" content="Python set.union() - Combine Sets | Live Demo">
    <meta property="og:description" content="Python set.union() returns union of sets. Interactive examples. Syntax: set.union(*others). Combine sets without duplicates. Try it online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python set.union() returns union of sets. Interactive examples. Syntax: set.union(*others). Combine sets without duplicates. Try it online!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/set_union.jsp">
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
        "headline": "Python set.union() Method",
        "description": "The union() method returns a set containing all items from the original set, and all items from the specified set(s).",
        "articleSection": "Python Set Methods",
        "keywords": "python, set, union, merge",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-set-union">
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
                                    <span>set.union()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python set.union() Method</h1>
                                    <div class="lesson-meta">
                                        <span>Set Method</span>
                                        <span>•</span>
                                        <span>Union</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>union()</code> method returns a set containing all items from the
                                        original set, and all items from the specified set(s).
                                    </p>
                                    <p>You can specify as many sets you want, separated by commas.</p>
                                    <p>It does not have to be a set, it can be any iterable object.</p>
                                    <p>If an item is present in more than one set, the result will contain only one
                                        appearance of this item.</p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>set.union(set1, set2...)</code></pre>

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
                                                    <td><code>set1</code></td>
                                                    <td>Required. The set to add items from</td>
                                                </tr>
                                                <tr>
                                                    <td><code>set2...</code></td>
                                                    <td>Optional. The other sets to add items from, separated by commas
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A new set containing the union of sets.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>union()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/set_union.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="set_intersection.jsp" class="related-link">
                                            <span class="related-icon">∩</span>
                                            <div>
                                                <strong>set.intersection()</strong>
                                                <span>Common elements</span>
                                            </div>
                                        </a>
                                        <a href="set_difference.jsp" class="related-link">
                                            <span class="related-icon">➖</span>
                                            <div>
                                                <strong>set.difference()</strong>
                                                <span>Difference of sets</span>
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
