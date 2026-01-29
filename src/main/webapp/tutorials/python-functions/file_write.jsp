<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "file_write" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python file.write() - Write to File | Live Examples</title>
            <meta name="description"
                content="Learn how to use the Python file.write() method. Writes a specified string to the file. Syntax and examples.">
            <meta name="keywords"
                content="python file write, python write file, python write text, python append to file">
    <meta property="og:title" content="Python file.write() - Write to File | Live Examples">
    <meta property="og:description" content="Python file.write() writes string to file. Interactive examples. Syntax: file.write(string). Write files easily. Try it online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python file.write() writes string to file. Interactive examples. Syntax: file.write(string). Write files easily. Try it online!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/file_write.jsp">
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
        "headline": "Python file.write() Method",
        "description": "The write() method writes a specified text to the file. Returns the number of characters written.",
        "articleSection": "Python File Methods",
        "keywords": "python, file, write, append",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-file-write">
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
                                    <span>file.write()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python file.write() Method</h1>
                                    <div class="lesson-meta">
                                        <span>File Method</span>
                                        <span>•</span>
                                        <span>Write</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>write()</code> method writes a specified text to the file.
                                    </p>
                                    <p>Where the specified text will be inserted depends on the file mode and stream
                                        position.</p>
                                    <ul>
                                        <li>"a": The text will be inserted at the current file stream position, default
                                            at the end of the file.</li>
                                        <li>"w": The file will be emptied before the text will be inserted at the
                                            current file stream position, default 0.</li>
                                    </ul>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>file.write(text)</code></pre>

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
                                                    <td><code>text</code></td>
                                                    <td>Required. The text to be written.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>The number of bytes written.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>write()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/file_write.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="python_open.jsp" class="related-link">
                                            <span class="related-icon">📂</span>
                                            <div>
                                                <strong>open()</strong>
                                                <span>Open file</span>
                                            </div>
                                        </a>
                                        <a href="file_writelines.jsp" class="related-link">
                                            <span class="related-icon">📝</span>
                                            <div>
                                                <strong>file.writelines()</strong>
                                                <span>Write multiple lines</span>
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
