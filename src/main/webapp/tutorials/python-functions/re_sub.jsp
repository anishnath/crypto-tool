<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "re_sub" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Python re.sub() - Replace Pattern Matches | Try Online</title>
            <meta name="description" content="Python re.sub() replaces pattern matches with replacement string. Interactive examples. Syntax: re.sub(pattern, repl, string). Regex replace. Try free!">
    <meta name="keywords" content="python re sub, re.sub, regex replace, python regex sub, replace pattern, python re.sub example">
    <meta property="og:title" content="Python re.sub() - Replace Pattern Matches | Try Online">
    <meta property="og:description" content="Python re.sub() replaces pattern matches with replacement string. Interactive examples. Syntax: re.sub(pattern, repl, string). Regex replace. Try free!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python re.sub() replaces pattern matches with replacement string. Interactive examples. Syntax: re.sub(pattern, repl, string). Regex replace. Try free!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/re_sub.jsp">
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

        <body class="tutorial-body no-preview">
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
                                    <span>re.sub()</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python re.sub() Method</h1>
                                    <div class="lesson-meta"><span>Regular
                                            Expressions</span><span>•</span><span>Replace</span></div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">The <code>re.sub()</code> method replaces matches with a replacement
                                        string.</p>
                                    <h2>Syntax</h2>
                                    <pre
                                        class="language-python"><code>re.sub(pattern, repl, string, count=0)</code></pre>
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
                                                    <td>Required. The pattern to match.</td>
                                                </tr>
                                                <tr>
                                                    <td><code>repl</code></td>
                                                    <td>Required. The replacement string.</td>
                                                </tr>
                                                <tr>
                                                    <td><code>string</code></td>
                                                    <td>Required. The string to search.</td>
                                                </tr>
                                                <tr>
                                                    <td><code>count</code></td>
                                                    <td>Optional. Max replacements (0 = all).</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <h2>Return Value</h2>
                                    <p>The modified string.</p>
                                    <h2>Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/re_sub.py" />
                                    </jsp:include>
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
