<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "cookies-basics" ); request.setAttribute("currentModule", "Superglobals" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Cookies - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP cookies. Learn setcookie(), $_COOKIE, expiration, security flags, and best practices.">
            <meta name="keywords" content="php cookies, php setcookie, php $_COOKIE, php cookie security, php httponly">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/cookies-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Cookies","description":"Learn PHP cookie management","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["PHP cookies","setcookie","$_COOKIE","Cookie security"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="cookies-basics">
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
                                    <span>Cookies</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Cookies</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Cookies store small amounts of data on the client's browser. Perfect
                                        for preferences, tracking, and "remember me" functionality!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/cookies-basics.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-cookies" />
                                    </jsp:include>

                                    <h2>Setting a Cookie</h2>
                                    <pre><code class="language-php">&lt;?php
// Basic cookie (expires in 1 hour)
setcookie("username", "john_doe", time() + 3600, "/");

// Cookie with all options
setcookie(
    "user_pref",           // name
    "dark_mode",           // value
    time() + (86400 * 30), // expires in 30 days
    "/",                   // path
    "",                    // domain
    false,                 // secure (HTTPS only)
    true                   // httponly (not accessible via JS)
);
?&gt;</code></pre>

                                    <h2>Reading a Cookie</h2>
                                    <pre><code class="language-php">&lt;?php
if (isset($_COOKIE['username'])) {
    echo "Welcome back, " . $_COOKIE['username'];
}
?&gt;</code></pre>

                                    <h2>Deleting a Cookie</h2>
                                    <pre><code class="language-php">&lt;?php
// Set expiration to past
setcookie("username", "", time() - 3600, "/");
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>setcookie():</strong> Must be before output</li>
                                            <li><strong>$_COOKIE:</strong> Read cookie values</li>
                                            <li><strong>httponly:</strong> Prevent JavaScript access</li>
                                            <li><strong>secure:</strong> HTTPS only</li>
                                            <li><strong>Don't store sensitive data</strong></li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Finally, learn about <strong>File Uploads</strong> - handling user file
                                        submissions!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="sessions-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Sessions" />
                                    <jsp:param name="nextLink" value="uploads-basics.jsp" />
                                    <jsp:param name="nextTitle" value="File Uploads" />
                                    <jsp:param name="currentLessonId" value="cookies-basics" />
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