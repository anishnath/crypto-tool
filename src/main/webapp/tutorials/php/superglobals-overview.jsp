<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "superglobals-overview" );
        request.setAttribute("currentModule", "Superglobals" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Superglobals Overview - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP superglobals: $_GET, $_POST, $_SERVER, $_SESSION, $_COOKIE, $_FILES. Learn built-in global arrays.">
            <meta name="keywords"
                content="php superglobals, php $_GET, php $_POST, php $_SERVER, php $_SESSION, php global arrays">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/superglobals-overview.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Superglobals Overview","description":"Learn PHP superglobals and global arrays","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["PHP superglobals","$_GET","$_POST","$_SERVER","$_SESSION"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="superglobals-overview">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-php.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/php/">PHP</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Superglobals Overview</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Superglobals Overview</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Superglobals are built-in arrays that are always accessible from any
                                        scope. They provide access to request data, server information, sessions, and
                                        more!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/superglobals-overview.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-superglobals" />
                                    </jsp:include>

                                    <h2>All Superglobals</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Superglobal</th>
                                                <th>Purpose</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>$_GET</code></td>
                                                <td>URL parameters</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_POST</code></td>
                                                <td>Form data (POST method)</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_SERVER</code></td>
                                                <td>Server and environment info</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_SESSION</code></td>
                                                <td>Session variables</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_COOKIE</code></td>
                                                <td>Cookie values</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_FILES</code></td>
                                                <td>Uploaded files</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_REQUEST</code></td>
                                                <td>GET, POST, and COOKIE combined</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_ENV</code></td>
                                                <td>Environment variables</td>
                                            </tr>
                                            <tr>
                                                <td><code>$GLOBALS</code></td>
                                                <td>All global variables</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>$_SERVER Examples</h2>
                                    <pre><code class="language-php">&lt;?php
echo $_SERVER['SERVER_NAME'];    // Domain name
echo $_SERVER['REQUEST_METHOD']; // GET, POST, etc.
echo $_SERVER['SCRIPT_NAME'];    // Current script path
echo $_SERVER['REMOTE_ADDR'];    // Client IP address
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Superglobals:</strong> Always accessible</li>
                                            <li><strong>$_GET:</strong> URL parameters</li>
                                            <li><strong>$_POST:</strong> Form data</li>
                                            <li><strong>$_SERVER:</strong> Server info</li>
                                            <li><strong>No global keyword needed</strong></li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>GET & POST</strong> - handling form submissions and URL
                                        parameters!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="oop-magic-methods.jsp" />
                                    <jsp:param name="prevTitle" value="Magic Methods" />
                                    <jsp:param name="nextLink" value="forms-get.jsp" />
                                    <jsp:param name="nextTitle" value="GET & POST" />
                                    <jsp:param name="currentLessonId" value="superglobals-overview" />
                                </jsp:include>
                            </article>
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