<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-increment" ); request.setAttribute("currentModule", "Operators"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Increment & Decrement Operators - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP increment (++) and decrement (--) operators. Learn the difference between pre and post increment/decrement.">
            <meta name="keywords" content="php increment, php decrement, php ++, php --, pre increment, post increment">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/operators-increment.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Increment Decrement Operators","description":"Learn PHP increment and decrement operators","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["Increment operators","Decrement operators","Pre vs post increment"],"timeRequired":"PT15M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="operators-increment">
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
                                    <span>Increment/Decrement</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Increment & Decrement Operators</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~15 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Increment (++) and decrement (--) operators provide shortcuts for
                                        adding or subtracting 1. Understanding the difference between pre and post
                                        operations is crucial!</p>

                                    <h2>Operators Overview</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Effect</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>++$x</code></td>
                                                <td>Pre-increment</td>
                                                <td>Increment first, then return</td>
                                            </tr>
                                            <tr>
                                                <td><code>$x++</code></td>
                                                <td>Post-increment</td>
                                                <td>Return first, then increment</td>
                                            </tr>
                                            <tr>
                                                <td><code>--$x</code></td>
                                                <td>Pre-decrement</td>
                                                <td>Decrement first, then return</td>
                                            </tr>
                                            <tr>
                                                <td><code>$x--</code></td>
                                                <td>Post-decrement</td>
                                                <td>Return first, then decrement</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/operators-increment.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-increment" />
                                    </jsp:include>

                                    <h2>Pre vs Post Increment</h2>
                                    <pre><code class="language-php">&lt;?php
// Pre-increment: increment FIRST, then use
$x = 5;
echo ++$x;  // Outputs: 6 (incremented to 6, then returned)
echo $x;    // Outputs: 6

// Post-increment: use FIRST, then increment
$x = 5;
echo $x++;  // Outputs: 5 (returned 5, then incremented)
echo $x;    // Outputs: 6
?&gt;</code></pre>

                                    <h2>Common Use: Loops</h2>
                                    <pre><code class="language-php">&lt;?php
// Most common use in for loops
for ($i = 0; $i < 5; $i++) {
    echo $i . " ";  // 0 1 2 3 4
}

// Counting down
for ($i = 5; $i > 0; $i--) {
    echo $i . " ";  // 5 4 3 2 1
}
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>++$x:</strong> Pre-increment (increment first)</li>
                                            <li><strong>$x++:</strong> Post-increment (return first)</li>
                                            <li><strong>--$x:</strong> Pre-decrement (decrement first)</li>
                                            <li><strong>$x--:</strong> Post-decrement (return first)</li>
                                            <li><strong>Common use:</strong> Loop counters</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, we'll explore the <strong>Ternary and Null Coalescing Operators</strong> -
                                        powerful shortcuts for conditional assignments!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="operators-logical.jsp" />
                                    <jsp:param name="prevTitle" value="Logical Operators" />
                                    <jsp:param name="nextLink" value="operators-ternary.jsp" />
                                    <jsp:param name="nextTitle" value="Ternary & Null Coalescing" />
                                    <jsp:param name="currentLessonId" value="operators-increment" />
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