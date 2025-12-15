<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions-variable" ); request.setAttribute("currentModule", "Functions"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Variable Functions - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP variable functions, anonymous functions, and closures. Learn callbacks and the use keyword.">
            <meta name="keywords"
                content="php variable functions, php closures, php anonymous functions, php callbacks">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/functions-variable.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Variable Functions","description":"Learn PHP variable functions and closures","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["Variable functions","Anonymous functions","Closures","Callbacks"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="functions-variable">
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
                                    <span>Variable Functions</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Variable Functions</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Variable functions and closures give you powerful ways to work with
                                        functions dynamically. Perfect for callbacks, event handlers, and functional
                                        programming!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/functions-variable.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-variable" />
                                    </jsp:include>

                                    <h2>Variable Functions</h2>
                                    <pre><code class="language-php">&lt;?php
function sayHello() {
    return "Hello!";
}

$func = 'sayHello';
echo $func();  // Calls sayHello()
?&gt;</code></pre>

                                    <h2>Anonymous Functions (Closures)</h2>
                                    <pre><code class="language-php">&lt;?php
$greet = function($name) {
    return "Hello, $name!";
};

echo $greet("Alice");
?&gt;</code></pre>

                                    <h2>The use Keyword</h2>
                                    <pre><code class="language-php">&lt;?php
$message = "Welcome";
$greeter = function($name) use ($message) {
    return "$message, $name!";
};

echo $greeter("Bob");
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Variable function:</strong> Call by variable name</li>
                                            <li><strong>Anonymous:</strong> <code>function() { }</code></li>
                                            <li><strong>Closure:</strong> Captures variables with <code>use</code></li>
                                            <li><strong>Callbacks:</strong> Pass functions as arguments</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Arrow Functions</strong> - the modern, concise syntax
                                        in PHP 7.4+!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="functions-parameters.jsp" />
                                    <jsp:param name="prevTitle" value="Function Parameters" />
                                    <jsp:param name="nextLink" value="functions-arrow.jsp" />
                                    <jsp:param name="nextTitle" value="Arrow Functions" />
                                    <jsp:param name="currentLessonId" value="functions-variable" />
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