<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "gettimeofday" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP gettimeofday() - Get Current Time | Live Examples</title>
            <meta name="description"
                content="PHP gettimeofday() returns the current time. Syntax: gettimeofday(). Returns current time with microseconds.">
    <meta name="keywords" content="php gettimeofday, gettimeofday php, current time, microseconds php, precise time, gettimeofday example, php timing">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/gettimeofday.jsp">
            <meta property="og:title" content="PHP gettimeofday() - Get Current Time | Live Examples">
    <meta property="og:description" content="PHP gettimeofday() returns current time with microseconds. Interactive examples. Syntax: gettimeofday($as_float). High precision timing. Try it online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/php-logo.svg">
            <meta property="og:type" content="article">
            <meta name="twitter:card" content="summary">
    <meta name="twitter:description" content="PHP gettimeofday() returns current time with microseconds. Interactive examples. Syntax: gettimeofday($as_float). High precision timing. Try it online!">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var t = localStorage.getItem('tutorial-theme'); if (t === 'dark' || (!t && matchMedia('(prefers-color-scheme:dark)').matches)) document.documentElement.setAttribute('data-theme', 'dark'); })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"TechArticle","headline":"PHP gettimeofday() Function","datePublished":"2025-01-28","dateModified":"2025-01-28"}</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Tutorials","item":"https://8gwifi.org/tutorials/"},{"@type":"ListItem","position":2,"name":"PHP Functions","item":"https://8gwifi.org/tutorials/php-functions/"},{"@type":"ListItem","position":3,"name":"gettimeofday()"}]}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="gettimeofday">
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
                                        Functions</a><span
                                        class="breadcrumb-separator">/</span><span>gettimeofday()</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP gettimeofday() Function</h1>
                                    <div class="lesson-meta"><span>Date/Time Function</span><span>PHP 4+</span></div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">The <code>gettimeofday()</code> function returns the current time,
                                        with microsecond precision.</p>
                                    <h2>Syntax</h2>
                                    <pre><code class="language-php">gettimeofday(bool $as_float = false): array|float</code></pre>
                                    <h2>Parameters</h2>
                                    <ul class="parameter-list">
                                        <li><code>as_float</code>: If set to true, a float is returned instead of an
                                            array.</li>
                                    </ul>
                                    <h2>Return Value</h2>
                                    <p>By default, returns an associative array with members: sec, usec, minuteswest,
                                        dsttime. If <code>as_float</code> is true, returns a float.</p>
                                    <h2>Try It Online</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php-functions/gettimeofday.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="gettimeofday-demo" />
                                    </jsp:include>
                                    <h2>Related Functions</h2>
                                    <ul>
                                        <li><a href="microtime.jsp">microtime()</a> - Return current Unix timestamp with
                                            microseconds</li>
                                        <li><a href="time.jsp">time()</a> - Return current Unix timestamp</li>
                                    </ul>
                                </div>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="getdate.jsp" />
                                    <jsp:param name="prevTitle" value="getdate()" />
                                    <jsp:param name="nextLink" value="microtime.jsp" />
                                    <jsp:param name="nextTitle" value="microtime()" />
                                    <jsp:param name="currentLessonId" value="gettimeofday" />
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
