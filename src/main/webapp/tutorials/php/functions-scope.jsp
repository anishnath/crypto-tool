<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions-scope" ); request.setAttribute("currentModule", "Functions" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Function Scope & Static Variables - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP variable scope: global, local, and static variables. Learn the global keyword and variable lifetime.">
            <meta name="keywords" content="php scope, php global variables, php static variables, php variable scope">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/functions-scope.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Function Scope","description":"Learn PHP variable scope and static variables","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["Variable scope","Global variables","Static variables","Variable lifetime"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="functions-scope">
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
                                    <span>Scope & Static</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Function Scope & Static Variables</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Understanding variable scope is crucial for writing bug-free code.
                                        Learn about global, local, and static variables, and how they behave in
                                        different contexts!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/functions-scope.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-scope" />
                                    </jsp:include>

                                    <h2>Global Scope</h2>
                                    <pre><code class="language-php">&lt;?php
$globalVar = "I'm global";

function test() {
    global $globalVar;
    echo $globalVar;
}

test();  // "I'm global"
?&gt;</code></pre>

                                    <h2>Local Scope</h2>
                                    <pre><code class="language-php">&lt;?php
function example() {
    $local = "I'm local";
    return $local;
}

echo example();
// echo $local;  // Error! Not accessible
?&gt;</code></pre>

                                    <h2>Static Variables</h2>
                                    <pre><code class="language-php">&lt;?php
function counter() {
    static $count = 0;
    $count++;
    return $count;
}

echo counter();  // 1
echo counter();  // 2
echo counter();  // 3
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Global:</strong> Accessible everywhere with <code>global</code>
                                            </li>
                                            <li><strong>Local:</strong> Only inside function</li>
                                            <li><strong>Static:</strong> Retains value between calls</li>
                                            <li><strong>Lifetime:</strong> Static persists, local doesn't</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 5. Next, dive into
                                        <strong>Arrays</strong> - PHP's most powerful data structure!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="functions-variadic.jsp" />
                                    <jsp:param name="prevTitle" value="Variadic Functions" />
                                    <jsp:param name="nextLink" value="arrays-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Array Basics" />
                                    <jsp:param name="currentLessonId" value="functions-scope" />
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