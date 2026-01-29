<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "re_search" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python re.search() - Search Pattern Anywhere | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use Python's re.search() method. Searches for a pattern anywhere in the string.">
            <meta name="keywords" content="python re.search, python regex search, python pattern search">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/re_search.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="python-functions-re-search">
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
                                    <span>re.search()</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python re.search() Method</h1>
                                    <div class="lesson-meta">
                                        <span>Regular Expressions</span>
                                        <span>•</span>
                                        <span>Search</span>
                                    </div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">The <code>re.search()</code> method searches for a pattern anywhere
                                        in the string.</p>
                                    <p>Unlike <code>match()</code>, it doesn't require the pattern to be at the
                                        beginning.</p>
                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>re.search(pattern, string, flags=0)</code></pre>
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
                                                    <td><code>pattern</code></td>
                                                    <td>Required. The regular expression pattern.</td>
                                                </tr>
                                                <tr>
                                                    <td><code>string</code></td>
                                                    <td>Required. The string to search.</td>
                                                </tr>
                                                <tr>
                                                    <td><code>flags</code></td>
                                                    <td>Optional. Matching flags.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <h2>Return Value</h2>
                                    <p>A match object if found, otherwise <code>None</code>.</p>
                                    <h2>Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/re_search.py" />
                                    </jsp:include>
                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="re_match.jsp" class="related-link">
                                            <span class="related-icon">🎯</span>
                                            <div><strong>re.match()</strong><span>Match at start</span></div>
                                        </a>
                                        <a href="re_findall.jsp" class="related-link">
                                            <span class="related-icon">📋</span>
                                            <div><strong>re.findall()</strong><span>Find all</span></div>
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
