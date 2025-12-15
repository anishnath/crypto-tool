<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions-variadic" ); request.setAttribute("currentModule", "Functions"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Variadic Functions - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP variadic functions using the splat operator (...). Learn to handle variable numbers of arguments.">
            <meta name="keywords" content="php variadic functions, php splat operator, php ..., php variable arguments">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/functions-variadic.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Variadic Functions","description":"Learn PHP variadic functions and splat operator","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["Variadic functions","Splat operator","Variable arguments"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="functions-variadic">
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
                                    <span>Variadic Functions</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Variadic Functions</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Variadic functions accept a variable number of arguments using the
                                        splat operator (...). Perfect for flexible functions like sum(), max(), or
                                        custom utilities!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/functions-variadic.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-variadic" />
                                    </jsp:include>

                                    <h2>Variadic Parameters</h2>
                                    <pre><code class="language-php">&lt;?php
function sum(...$numbers) {
    return array_sum($numbers);
}

echo sum(1, 2, 3);        // 6
echo sum(1, 2, 3, 4, 5);  // 15
?&gt;</code></pre>

                                    <h2>Mixed Parameters</h2>
                                    <pre><code class="language-php">&lt;?php
function formatList($separator, ...$items) {
    return implode($separator, $items);
}

echo formatList(", ", "apple", "banana", "cherry");
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Syntax:</strong> <code>...$params</code></li>
                                            <li><strong>Variable args:</strong> Accept any number</li>
                                            <li><strong>Type hints:</strong> <code>int ...$nums</code></li>
                                            <li><strong>Unpacking:</strong> <code>func(...$array)</code></li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Finally, learn about <strong>Function Scope</strong> - global, local, and static
                                        variables!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="functions-arrow.jsp" />
                                    <jsp:param name="prevTitle" value="Arrow Functions" />
                                    <jsp:param name="nextLink" value="functions-scope.jsp" />
                                    <jsp:param name="nextTitle" value="Scope & Static" />
                                    <jsp:param name="currentLessonId" value="functions-variadic" />
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