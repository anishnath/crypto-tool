<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "hashlib_md5" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python hashlib.md5() - MD5 Hash Function | Live Demo</title>
            <meta name="description"
                content="Learn how to use Python's hashlib.md5() for creating MD5 hashes. Syntax and examples.">
            <meta name="keywords" content="python hashlib md5, hashlib.md5, md5 hash, python md5, md5 example, python hash md5">
    <meta property="og:title" content="Python hashlib.md5() - MD5 Hash Function | Live Demo">
    <meta property="og:description" content="Python hashlib.md5() creates MD5 hash object. Interactive examples. Syntax: hashlib.md5(data). Generate MD5 hashes. Try it online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python hashlib.md5() creates MD5 hash object. Interactive examples. Syntax: hashlib.md5(data). Generate MD5 hashes. Try it online!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/hashlib_md5.jsp">
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
        "headline": "Python hashlib.md5() Method",
        "description": "The hashlib.md5() method creates an MD5 hash object.",
        "articleSection": "Python Hashing",
        "keywords": "python, hashlib, md5, hash",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-hashlib-md5">
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
                                    <span>hashlib.md5()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python hashlib.md5() Method</h1>
                                    <div class="lesson-meta">
                                        <span>Hashing</span>
                                        <span>•</span>
                                        <span>MD5</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>hashlib.md5()</code> method creates an MD5 hash object from the given
                                        bytes.
                                    </p>
                                    <p>Strings must be encoded to bytes before hashing.</p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>hashlib.md5(data)</code></pre>

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
                                                    <td><code>data</code></td>
                                                    <td>Optional. The bytes to hash.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A hash object.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>hashlib.md5()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/hashlib_md5.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="hashlib_sha256.jsp" class="related-link">
                                            <span class="related-icon">🔒</span>
                                            <div>
                                                <strong>hashlib.sha256()</strong>
                                                <span>SHA256 Hash</span>
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
