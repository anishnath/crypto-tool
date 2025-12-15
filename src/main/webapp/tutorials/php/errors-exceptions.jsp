<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "errors-exceptions" ); request.setAttribute("currentModule", "Advanced" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Error Handling & Exceptions - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP error handling and exceptions. Learn try-catch blocks, custom exceptions, and error management.">
            <meta name="keywords" content="php exceptions, php error handling, php try catch, php custom exceptions">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/errors-exceptions.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Error Handling","description":"Learn PHP error handling and exceptions","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["Error handling","Exceptions","try-catch","Custom exceptions"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="errors-exceptions">
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
                                    <span>Error Handling</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Error Handling & Exceptions</h1>
                                    <div class="lesson-meta"><span>Advanced</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Proper error handling makes your applications robust and
                                        maintainable. Exceptions provide a clean way to handle errors without cluttering
                                        your code!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/errors-exceptions.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-errors" />
                                    </jsp:include>

                                    <h2>Try-Catch Block</h2>
                                    <pre><code class="language-php">&lt;?php
try {
    $file = fopen('nonexistent.txt', 'r');
    if (!$file) {
        throw new Exception("File not found");
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
?&gt;</code></pre>

                                    <h2>Custom Exceptions</h2>
                                    <pre><code class="language-php">&lt;?php
class DatabaseException extends Exception {}

try {
    throw new DatabaseException("Connection failed");
} catch (DatabaseException $e) {
    echo "DB Error: " . $e->getMessage();
}
?&gt;</code></pre>

                                    <h2>Finally Block</h2>
                                    <pre><code class="language-php">&lt;?php
try {
    // Code that might fail
} catch (Exception $e) {
    // Handle error
} finally {
    // Always runs (cleanup)
}
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>try-catch:</strong> Handle exceptions</li>
                                            <li><strong>throw:</strong> Raise exception</li>
                                            <li><strong>finally:</strong> Always executes</li>
                                            <li><strong>Custom exceptions:</strong> Extend Exception class</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Regular Expressions</strong> - powerful pattern
                                        matching!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="database-security.jsp" />
                                    <jsp:param name="prevTitle" value="Database Security" />
                                    <jsp:param name="nextLink" value="regex-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Regular Expressions" />
                                    <jsp:param name="currentLessonId" value="errors-exceptions" />
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