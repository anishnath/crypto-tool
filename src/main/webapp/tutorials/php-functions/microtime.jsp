<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "microtime" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP microtime() - Get Current Unix Timestamp | Live Demo</title>
            <meta name="description"
                content="PHP microtime() returns the current Unix timestamp with microseconds. Useful for benchmark timing.">
    <meta name="keywords" content="php microtime, microtime php, microseconds, precise time, benchmark php, microtime example, php timing">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/microtime.jsp">
            <meta property="og:title" content="PHP microtime() - Get Current Unix Timestamp | Live Demo">
    <meta property="og:description" content="PHP microtime() returns current Unix timestamp with microseconds. Interactive examples. Syntax: microtime($as_float). Precise timing and benchmarking. Try it online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/php-logo.svg">
            <meta property="og:type" content="article">
            <meta name="twitter:card" content="summary">
    <meta name="twitter:description" content="PHP microtime() returns current Unix timestamp with microseconds. Interactive examples. Syntax: microtime($as_float). Precise timing and benchmarking. Try it online!">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var t = localStorage.getItem('tutorial-theme'); if (t === 'dark' || (!t && matchMedia('(prefers-color-scheme:dark)').matches)) document.documentElement.setAttribute('data-theme', 'dark'); })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"TechArticle","headline":"PHP microtime() Function","datePublished":"2025-01-28","dateModified":"2025-01-28"}</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Tutorials","item":"https://8gwifi.org/tutorials/"},{"@type":"ListItem","position":2,"name":"PHP Functions","item":"https://8gwifi.org/tutorials/php-functions/"},{"@type":"ListItem","position":3,"name":"microtime()"}]}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="microtime">
            <div class="tutorial-layout has-ad-rail">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-php-functions.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb"><a
                                        href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span
                                        class="breadcrumb-separator">/</span><a
                                        href="<%=request.getContextPath()%>/tutorials/php-functions/">PHP
                                        Functions</a><span class="breadcrumb-separator">/</span><span>microtime()</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP microtime() Function</h1>
                                    <div class="lesson-meta"><span>Date/Time Function</span><span>PHP 4+</span></div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">The <code>microtime()</code> function returns the current Unix
                                        timestamp with microseconds. This function is typically used for performance
                                        benchmarking.</p>
                                    <h2>Syntax</h2>
                                    <pre><code class="language-php">microtime(bool $as_float = false): string|float</code></pre>
                                    <h2>Parameters</h2>
                                    <ul class="parameter-list">
                                        <li><code>as_float</code>: If true, returns a float instead of a string.
                                            Defaults to false.</li>
                                    </ul>
                                    <h2>Return Value</h2>
                                    <p>By default, returns a string in the format "msec sec". If <code>as_float</code>
                                        is true, returns a float representing the current time in seconds since the Unix
                                        epoch accurate to the nearest microsecond.</p>
                                    <h2>Try It Online</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php-functions/microtime.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="microtime-demo" />
                                    </jsp:include>
                                    <h2>Related Functions</h2>
                                    <ul>
                                        <li><a href="hrtime.jsp">hrtime()</a> - Get the system's high resolution time
                                        </li>
                                        <li><a href="time.jsp">time()</a> - Return current Unix timestamp</li>
                                    </ul>
                                </div>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="localtime.jsp" />
                                    <jsp:param name="prevTitle" value="localtime()" />
                                    <jsp:param name="nextLink" value="strftime.jsp" />
                                    <jsp:param name="nextTitle" value="strftime()" />
                                    <jsp:param name="currentLessonId" value="microtime" />
                                </jsp:include>
                            </article>

                            <%-- Right Ad Rail (desktop only) --%>
                            <%@ include file="../tutorial-ad-rail.jsp" %>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>
