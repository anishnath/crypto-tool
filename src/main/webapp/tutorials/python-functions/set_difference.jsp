<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "set_difference" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python set.difference() - Elements Not in Other | Live Examples</title>
            <meta name="description"
                content="Learn how to use the Python set.difference() method. Returns a set containing the difference between two or more sets. Syntax and examples.">
            <meta name="keywords"
                content="python set difference, python difference method, subtract sets python, set minus python">
    <meta property="og:title" content="Python set.difference() - Elements Not in Other | Live Examples">
    <meta property="og:description" content="Python set.difference() returns elements in set but not in others. Interactive examples. Syntax: set.difference(*others). Set subtraction. Try online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python set.difference() returns elements in set but not in others. Interactive examples. Syntax: set.difference(*others). Set subtraction. Try online!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/set_difference.jsp">
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
        "headline": "Python set.difference() Method",
        "description": "The difference() method returns a set that contains the difference between two sets.",
        "articleSection": "Python Set Methods",
        "keywords": "python, set, difference, subtract",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-set-difference">
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
                                    <span>set.difference()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python set.difference() Method</h1>
                                    <div class="lesson-meta">
                                        <span>Set Method</span>
                                        <span>•</span>
                                        <span>Difference</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>difference()</code> method returns a set that contains the difference
                                        between two sets.
                                    </p>
                                    <p>Meaning: The returned set contains items that exist only in the first set, and
                                        not in both sets.</p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>set.difference(set)</code></pre>

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
                                                    <td><code>set</code></td>
                                                    <td>Required. The set to check for differences in</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A new set containing the difference.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>difference()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/set_difference.py" />
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
                                        <a href="set_intersection.jsp" class="related-link">
                                            <span class="related-icon">∩</span>
                                            <div>
                                                <strong>set.intersection()</strong>
                                                <span>Common elements</span>
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
