<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions-arrow" ); request.setAttribute("currentModule", "Functions" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Arrow Functions - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP 7.4+ arrow functions with concise syntax and automatic variable capture. Learn modern functional programming.">
            <meta name="keywords" content="php arrow functions, php 7.4, php fn, php short closures">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/functions-arrow.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Arrow Functions","description":"Learn PHP 7.4+ arrow functions","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["Arrow functions","PHP 7.4","Short closures","Functional programming"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="functions-arrow">
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
                                    <span>Arrow Functions</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Arrow Functions</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Arrow functions (PHP 7.4+) provide a shorter syntax for simple
                                        functions. They automatically capture variables from the parent scope - no more
                                        <code>use</code> keyword needed!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/functions-arrow.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-arrow" />
                                    </jsp:include>

                                    <h2>Arrow Function Syntax</h2>
                                    <pre><code class="language-php">&lt;?php
// Traditional
$multiply = function($x, $y) {
    return $x * $y;
};

// Arrow function
$multiplyArrow = fn($x, $y) => $x * $y;
?&gt;</code></pre>

                                    <h2>Automatic Variable Capture</h2>
                                    <pre><code class="language-php">&lt;?php
$factor = 10;

// No 'use' needed!
$scale = fn($n) => $n * $factor;

echo $scale(5);  // 50
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Syntax:</strong> <code>fn($params) => expression</code></li>
                                            <li><strong>Auto-capture:</strong> No <code>use</code> needed</li>
                                            <li><strong>Single expression:</strong> Implicit return</li>
                                            <li><strong>PHP 7.4+:</strong> Modern feature</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Variadic Functions</strong> - handling variable numbers
                                        of arguments!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="functions-variable.jsp" />
                                    <jsp:param name="prevTitle" value="Variable Functions" />
                                    <jsp:param name="nextLink" value="functions-variadic.jsp" />
                                    <jsp:param name="nextTitle" value="Variadic Functions" />
                                    <jsp:param name="currentLessonId" value="functions-arrow" />
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