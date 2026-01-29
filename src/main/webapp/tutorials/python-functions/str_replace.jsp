<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "str_replace" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python str.replace() - Replace Substring | Live Examples</title>
            <meta name="description"
                content="Learn how to use the Python str.replace() method. Replaces a specified phrase with another specified phrase. Syntax, parameters, and examples.">
            <meta name="keywords"
                content="python replace method, python string replace, replace substring python, python replace all strings">
    <meta property="og:title" content="Python str.replace() - Replace Substring | Live Examples">
    <meta property="og:description" content="Python str.replace() replaces occurrences of substring with another. Interactive examples with live code. Syntax: string.replace(old, new, count). Try it online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python str.replace() replaces occurrences of substring with another. Interactive examples with live code. Syntax: string.replace(old, new, count). Try it online!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/str_replace.jsp">
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
        "headline": "Python str.replace() Method",
        "description": "The replace() method replaces a specified value with another specified value.",
        "articleSection": "Python String Methods",
        "keywords": "python, string, replace",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-str-replace">
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
                                    <span>str.replace()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python str.replace() Method</h1>
                                    <div class="lesson-meta">
                                        <span>String Method</span>
                                        <span>•</span>
                                        <span>Modify</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>replace()</code> method replaces a specified phrase with another
                                        specified phrase.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre
                                        class="language-python"><code>string.replace(oldvalue, newvalue, count)</code></pre>

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
                                                    <td><code>oldvalue</code></td>
                                                    <td>Required. The string to search for</td>
                                                </tr>
                                                <tr>
                                                    <td><code>newvalue</code></td>
                                                    <td>Required. The string to replace the old value with</td>
                                                </tr>
                                                <tr>
                                                    <td><code>count</code></td>
                                                    <td>Optional. A number specifying how many occurrences of the old
                                                        value you want to replace. Default is all occurrences</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A copy of the string where all occurrences of a substring are replaced.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>replace()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/str_replace.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="str_split.jsp" class="related-link">
                                            <span class="related-icon">✂️</span>
                                            <div>
                                                <strong>str.split()</strong>
                                                <span>Split string</span>
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
