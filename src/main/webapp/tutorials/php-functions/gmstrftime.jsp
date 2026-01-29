<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "gmstrftime" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP gmstrftime() - Format GMT/UTC Time | Live Examples</title>
            <meta name="description"
                content="PHP gmstrftime() formats a GMT/UTC time/date according to locale settings.">
    <meta name="keywords" content="php gmstrftime, gmstrftime php, format gmt time, utc time format, php timezone, gmstrftime example, php time formatting">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/gmstrftime.jsp">
            <meta property="og:title" content="PHP gmstrftime() - Format GMT/UTC Time | Live Examples">
    <meta property="og:description" content="PHP gmstrftime() formats GMT/UTC time based on locale settings. Interactive examples with live editor. Syntax: gmstrftime($format, $timestamp). Works with timezones. Try online!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/php-logo.svg">
            <meta property="og:type" content="article">
            <meta name="twitter:card" content="summary">
    <meta name="twitter:description" content="PHP gmstrftime() formats GMT/UTC time based on locale settings. Interactive examples with live editor. Syntax: gmstrftime($format, $timestamp). Works with timezones. Try online!">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var t = localStorage.getItem('tutorial-theme'); if (t === 'dark' || (!t && matchMedia('(prefers-color-scheme:dark)').matches)) document.documentElement.setAttribute('data-theme', 'dark'); })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"TechArticle","headline":"PHP gmstrftime() Function","datePublished":"2025-01-28","dateModified":"2025-01-28"}</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Tutorials","item":"https://8gwifi.org/tutorials/"},{"@type":"ListItem","position":2,"name":"PHP Functions","item":"https://8gwifi.org/tutorials/php-functions/"},{"@type":"ListItem","position":3,"name":"gmstrftime()"}]}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="gmstrftime">
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
                                        class="breadcrumb-separator">/</span><span>gmstrftime()</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP gmstrftime() Function</h1>
                                    <div class="lesson-meta"><span>Date/Time Function</span><span>PHP 4+</span></div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">The <code>gmstrftime()</code> function formats a GMT/UTC time/date
                                        according to locale settings. It behaves the same as <code>strftime()</code>
                                        except it uses GMT time.</p>
                                    <p class="alert alert-warning"><strong>Warning:</strong> This function has been
                                        DEPRECATED as of PHP 8.1.0. Relying on this function is highly discouraged. Use
                                        <a href="gmdate.jsp">gmdate()</a> or <code>IntlDateFormatter::format()</code>
                                        instead.</p>
                                    <h2>Syntax</h2>
                                    <pre><code class="language-php">gmstrftime(string $format, ?int $timestamp = null): string|false</code></pre>
                                    <h2>Try It Online</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php-functions/gmstrftime.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="gmstrftime-demo" />
                                    </jsp:include>
                                    <h2>Related Functions</h2>
                                    <ul>
                                        <li><a href="strftime.jsp">strftime()</a> - Format a local time/date according
                                            to locale settings</li>
                                        <li><a href="gmdate.jsp">gmdate()</a> - Format a GMT/UTC date/time</li>
                                    </ul>
                                </div>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="gmmktime.jsp" />
                                    <jsp:param name="prevTitle" value="gmmktime()" />
                                    <jsp:param name="nextLink" value="hrtime.jsp" />
                                    <jsp:param name="nextTitle" value="hrtime()" />
                                    <jsp:param name="currentLessonId" value="gmstrftime" />
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
