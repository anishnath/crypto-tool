<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "regex-basics" ); request.setAttribute("currentModule", "Advanced" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Regular Expressions - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP regular expressions. Learn preg_match, preg_replace, pattern matching, and validation.">
            <meta name="keywords" content="php regex, php regular expressions, php preg_match, php pattern matching">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/regex-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Regular Expressions","description":"Learn PHP regex and pattern matching","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["Regular expressions","preg functions","Pattern matching","Validation"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="regex-basics">
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
                                    <span>Regular Expressions</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Regular Expressions</h1>
                                    <div class="lesson-meta"><span>Advanced</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Regular expressions (regex) are powerful patterns for matching and
                                        manipulating text. Perfect for validation, search, and data extraction!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/regex-basics.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-regex" />
                                    </jsp:include>

                                    <h2>preg_match - Find Match</h2>
                                    <pre><code class="language-php">&lt;?php
$text = "My email is john@example.com";
if (preg_match('/[\w\.-]+@[\w\.-]+\.\w+/', $text, $matches)) {
    echo "Email: " . $matches[0];
}
?&gt;</code></pre>

                                    <h2>preg_replace - Replace Pattern</h2>
                                    <pre><code class="language-php">&lt;?php
$text = "Hello World";
$result = preg_replace('/World/', 'PHP', $text);
echo $result; // Hello PHP
?&gt;</code></pre>

                                    <h2>Common Patterns</h2>
                                    <pre><code class="language-php">&lt;?php
$patterns = [
    'email' => '/^[\w\.-]+@[\w\.-]+\.\w+$/',
    'phone' => '/^\d{3}-\d{3}-\d{4}$/',
    'url' => '/^https?:\/\/[\w\.-]+\.\w+/',
];
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>preg_match():</strong> Find first match</li>
                                            <li><strong>preg_match_all():</strong> Find all matches</li>
                                            <li><strong>preg_replace():</strong> Replace patterns</li>
                                            <li><strong>Use case:</strong> Validation, search, extraction</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Date & Time</strong> - working with dates and
                                        timezones!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="errors-exceptions.jsp" />
                                    <jsp:param name="prevTitle" value="Error Handling" />
                                    <jsp:param name="nextLink" value="datetime-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Date & Time" />
                                    <jsp:param name="currentLessonId" value="regex-basics" />
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