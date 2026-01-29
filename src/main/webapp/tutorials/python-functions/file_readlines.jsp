<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "file_readlines" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python file.readlines() - Read All Lines | Live Demo</title>
            <meta name="description"
                content="Learn how to use the Python file.readlines() method. Returns a list containing each line in the file as a list item. Syntax and examples.">
            <meta name="keywords"
                content="python file readlines, python read lines list, python file to list, python read text file">
    <meta property="og:title" content="Python file.readlines() - Read All Lines | Live Demo">
    <meta property="og:description" content="Python file.readlines() reads all lines into list. Interactive examples. Syntax: file.readlines(hint). Get all lines at once. Try it online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python file.readlines() reads all lines into list. Interactive examples. Syntax: file.readlines(hint). Get all lines at once. Try it online!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/file_readlines.jsp">
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
        "headline": "Python file.readlines() Method",
        "description": "The readlines() method returns a list containing each line in the file as a list item.",
        "articleSection": "Python File Methods",
        "keywords": "python, file, readlines, list",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-file-readlines">
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
                                    <span>file.readlines()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python file.readlines() Method</h1>
                                    <div class="lesson-meta">
                                        <span>File Method</span>
                                        <span>•</span>
                                        <span>Read List</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>readlines()</code> method returns a list containing each line in the
                                        file as a list item.
                                    </p>
                                    <p>Use the <code>hint</code> parameter to limit the number of lines returned. If the
                                        total number of bytes returned exceeds the specified number, no more lines are
                                        returned.</p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>file.readlines(hint)</code></pre>

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
                                                    <td><code>hint</code></td>
                                                    <td>Optional. If the number of bytes returned exceed the hint
                                                        number, no more lines will be returned. Default value is -1,
                                                        which means all lines will be returned.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A list of lines from the file.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>readlines()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/file_readlines.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="file_read.jsp" class="related-link">
                                            <span class="related-icon">📖</span>
                                            <div>
                                                <strong>file.read()</strong>
                                                <span>Read file</span>
                                            </div>
                                        </a>
                                        <a href="file_list.jsp" class="related-link">
                                            <span class="related-icon">📋</span>
                                            <div>
                                                <strong>file.writable()</strong>
                                                <span>Check writable</span>
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
