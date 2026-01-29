<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "python_open" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python open() - Open File for I/O | Try Free</title>
            <meta name="description"
                content="Learn how to use the Python open() function. Opens a file and returns it as a file object. Syntax and examples.">
            <meta name="keywords" content="python open, open function, open file, python file open, file io, python open example">
    <meta property="og:title" content="Python open() - Open File for I/O | Try Free">
    <meta property="og:description" content="Python open() opens file and returns file object. Interactive examples with live code. Syntax: open(file, mode). Read/write files. Try it now!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python open() opens file and returns file object. Interactive examples with live code. Syntax: open(file, mode). Read/write files. Try it now!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/python_open.jsp">
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
        "headline": "Python open() Function",
        "description": "The open() function opens a file, and returns it as a file object.",
        "articleSection": "Python Built-in Functions",
        "keywords": "python, open, file, read, write",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-open">
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
                                    <span>open()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python open() Function</h1>
                                    <div class="lesson-meta">
                                        <span>Built-in Function</span>
                                        <span>•</span>
                                        <span>File I/O</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>open()</code> function opens a file, and returns it as a file object.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>open(file, mode)</code></pre>

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
                                                    <td><code>file</code></td>
                                                    <td>Required. The path and name of the file</td>
                                                </tr>
                                                <tr>
                                                    <td><code>mode</code></td>
                                                    <td>Optional. A string, defined which mode you want to open the file
                                                        in:
                                                        <ul>
                                                            <li>"r" - Read - Default value. Opens a file for reading,
                                                                error if the file does not exist</li>
                                                            <li>"a" - Append - Opens a file for appending, creates the
                                                                file if it does not exist</li>
                                                            <li>"w" - Write - Opens a file for writing, creates the file
                                                                if it does not exist</li>
                                                            <li>"x" - Create - Creates the specified file, returns an
                                                                error if the file exists</li>
                                                            <li>"t" - Text - Default value. Text mode</li>
                                                            <li>"b" - Binary - Binary mode (e.g. images)</li>
                                                        </ul>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A file object.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>open()</code> function:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/python_open.py" />
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
                                        <a href="file_write.jsp" class="related-link">
                                            <span class="related-icon">✍️</span>
                                            <div>
                                                <strong>file.write()</strong>
                                                <span>Write file</span>
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
