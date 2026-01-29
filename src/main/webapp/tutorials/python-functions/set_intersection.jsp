<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "set_intersection" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python set.intersection() Method - Set Intersection | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python set.intersection() method. Returns a set, that is the intersection of two other sets. Syntax and examples.">
            <meta name="keywords"
                content="python set intersection, python intersection method, common elements python sets, set overlap python">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/set_intersection.jsp">
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
        "headline": "Python set.intersection() Method",
        "description": "The intersection() method returns a set that contains the similarity between two or more sets.",
        "articleSection": "Python Set Methods",
        "keywords": "python, set, intersection, common",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-set-intersection">
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
                                    <span>set.intersection()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python set.intersection() Method</h1>
                                    <div class="lesson-meta">
                                        <span>Set Method</span>
                                        <span>•</span>
                                        <span>Intersection</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>intersection()</code> method returns a set that contains the
                                        similarity between two or more sets.
                                    </p>
                                    <p>Meaning: The returned set contains only items that exist in both sets, or in all
                                        sets if the comparison is done with more than two sets.</p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>set.intersection(set1, set2...)</code></pre>

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
                                                    <td>Required. The set to search for equal items in</td>
                                                </tr>
                                                <tr>
                                                    <td><code>set2...</code></td>
                                                    <td>Optional. The other sets to search for equal items in, separated
                                                        by commas</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A new set containing the intersection of sets.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>intersection()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/set_intersection.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="set_union.jsp" class="related-link">
                                            <span class="related-icon">∪</span>
                                            <div>
                                                <strong>set.union()</strong>
                                                <span>Combine sets</span>
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