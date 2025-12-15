<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions-parameters" ); request.setAttribute("currentModule", "Functions"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Function Parameters - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP function parameters: default values, type declarations, nullable types, and return type hints. Learn modern PHP 7+ features.">
            <meta name="keywords"
                content="php function parameters, php default parameters, php type hints, php nullable types">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/functions-parameters.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Function Parameters","description":"Learn PHP function parameters and type declarations","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["Function parameters","Default values","Type hints","Nullable types"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="functions-parameters">
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
                                    <span>Function Parameters</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Function Parameters</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Function parameters make your functions flexible and reusable. Learn
                                        about default values, type declarations, and modern PHP 7+ features for safer,
                                        more predictable code!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/functions-parameters.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-parameters" />
                                    </jsp:include>

                                    <h2>Default Parameters</h2>
                                    <pre><code class="language-php">&lt;?php
function greet($name = "Guest") {
    return "Hello, $name!";
}

echo greet();         // "Hello, Guest!"
echo greet("Alice");  // "Hello, Alice!"
?&gt;</code></pre>

                                    <h2>Type Declarations (PHP 7+)</h2>
                                    <pre><code class="language-php">&lt;?php
function add(int $a, int $b): int {
    return $a + $b;
}

echo add(5, 3);  // 8
?&gt;</code></pre>

                                    <h2>Nullable Types (PHP 7.1+)</h2>
                                    <pre><code class="language-php">&lt;?php
function findUser(?string $email): ?array {
    if ($email === null) {
        return null;
    }
    return ["email" => $email];
}
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Default:</strong> <code>$param = value</code></li>
                                            <li><strong>Type hint:</strong> <code>int $param</code></li>
                                            <li><strong>Return type:</strong> <code>: int</code></li>
                                            <li><strong>Nullable:</strong> <code>?string</code></li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Variable Functions</strong> and anonymous functions
                                        (closures)!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="functions-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Defining Functions" />
                                    <jsp:param name="nextLink" value="functions-variable.jsp" />
                                    <jsp:param name="nextTitle" value="Variable Functions" />
                                    <jsp:param name="currentLessonId" value="functions-parameters" />
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