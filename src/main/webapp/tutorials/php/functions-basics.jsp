<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions-basics" ); request.setAttribute("currentModule", "Functions" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Functions Basics - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn PHP functions from scratch. Master function definition, parameters, return values, and function calls with practical examples.">
            <meta name="keywords"
                content="php functions, php function basics, php return, php parameters, define function php">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/functions-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Functions Basics","description":"Learn PHP function fundamentals","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP functions","Function parameters","Return values","Function calls"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="functions-basics">
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
                                    <span>Functions Basics</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Functions Basics</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Functions are reusable blocks of code that perform specific tasks.
                                        They help you organize code, avoid repetition, and make your programs more
                                        maintainable. Let's master PHP functions!</p>

                                    <h2>What is a Function?</h2>
                                    <p>A <strong>function</strong> is a named block of code that can be called multiple
                                        times. Think of it as a recipe - you define it once and use it whenever needed.
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/functions-basics.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <h2>Defining a Function</h2>
                                    <pre><code class="language-php">&lt;?php
function greet() {
    echo "Hello, World!";
}

// Call the function
greet();  // Output: Hello, World!
?&gt;</code></pre>

                                    <h2>Function with Parameters</h2>
                                    <pre><code class="language-php">&lt;?php
function greetUser($name) {
    echo "Hello, $name!";
}

greetUser("Alice");  // Hello, Alice!
greetUser("Bob");    // Hello, Bob!
?&gt;</code></pre>

                                    <h2>Return Values</h2>
                                    <pre><code class="language-php">&lt;?php
function add($a, $b) {
    return $a + $b;
}

$result = add(5, 3);
echo $result;  // 8
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Define:</strong> <code>function name() { }</code></li>
                                            <li><strong>Call:</strong> <code>name()</code></li>
                                            <li><strong>Parameters:</strong> Input values</li>
                                            <li><strong>Return:</strong> Output value</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now let's explore <strong>Function Parameters</strong> in depth - default values,
                                        type hints, and more!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="loops-control.jsp" />
                                    <jsp:param name="prevTitle" value="Loop Control" />
                                    <jsp:param name="nextLink" value="functions-parameters.jsp" />
                                    <jsp:param name="nextTitle" value="Function Parameters" />
                                    <jsp:param name="currentLessonId" value="functions-basics" />
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