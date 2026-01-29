<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "print" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python print() Function - Output to Console | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python print() function. Syntax, parameters, examples, and how to format output, change separators, and end characters.">
            <meta name="keywords"
                content="python print function, python print example, print syntax python, python output, sep parameter, end parameter">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/print.jsp">
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
        "headline": "Python print() Function",
        "description": "The print() function prints the specified message to the screen, or other standard output device.",
        "articleSection": "Python Built-in Functions",
        "keywords": "python, print, output",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-print">
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
                                    <span>print()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python print() Function</h1>
                                    <div class="lesson-meta">
                                        <span>Built-in Function</span>
                                        <span>•</span>
                                        <span>Output</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>print()</code> function prints the specified message to the screen, or
                                        other standard output device.
                                    </p>
                                    <p>
                                        The message can be a string, or any other object, the object will be converted
                                        into a string before written to the screen.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre
                                        class="language-python"><code>print(object(s), sep=separator, end=end, file=file, flush=flush)</code></pre>

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
                                                    <td><code>object(s)</code></td>
                                                    <td>Any object, and as many as you like. Will be converted to string
                                                        before printed</td>
                                                </tr>
                                                <tr>
                                                    <td><code>sep</code></td>
                                                    <td>Optional. Specify how to separate the objects, if there is more
                                                        than one. Default is ' '</td>
                                                </tr>
                                                <tr>
                                                    <td><code>end</code></td>
                                                    <td>Optional. Specify what to print at the end. Default is '\n'
                                                        (line feed)</td>
                                                </tr>
                                                <tr>
                                                    <td><code>file</code></td>
                                                    <td>Optional. An object with a write method. Default is sys.stdout
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><code>flush</code></td>
                                                    <td>Optional. A Boolean, specifying if the output is flushed (True)
                                                        or buffered (False). Default is False</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>None</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>print()</code> function with various parameters:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/print.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="str.jsp" class="related-link">
                                            <span class="related-icon">📄</span>
                                            <div>
                                                <strong>str()</strong>
                                                <span>Convert to string</span>
                                            </div>
                                        </a>
                                        <a href="len.jsp" class="related-link">
                                            <span class="related-icon">📏</span>
                                            <div>
                                                <strong>len()</strong>
                                                <span>Get length of object</span>
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