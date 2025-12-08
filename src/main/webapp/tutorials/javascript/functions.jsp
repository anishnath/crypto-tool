<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Functions Lesson 11: Function declarations, expressions, arrow functions --%>
        <% request.setAttribute("currentLesson", "functions" ); request.setAttribute("currentModule", "Control Flow" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Functions | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript functions: declarations, expressions, arrow functions, parameters, and return values.">
                <meta name="keywords"
                    content="JavaScript functions, arrow functions, function expressions, return value">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Functions">
                <meta property="og:description" content="Master JavaScript functions and reusable code">
                <meta property="og:site_name" content="8gwifi.org Tutorials">

                <link rel="icon" type="image/svg+xml"
                    href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

                <script>
                    (function () {
                        var theme = localStorage.getItem('tutorial-theme');
                        if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                            document.documentElement.setAttribute('data-theme', 'dark');
                        }
                    })();
                </script>
            <%-- Ads --%>
                <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
            </head>

            <body class="tutorial-body" data-lesson="functions">
                <div class="tutorial-layout">
                    <%@ include file="../tutorial-header.jsp" %>

                        <main class="tutorial-main">
                            <%@ include file="../tutorial-sidebar-javascript.jsp" %>
                                <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                                <article class="tutorial-content">
                                    <nav class="breadcrumb">
                                        <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/">JavaScript</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <span>Functions</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Functions</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is a Function?</h2>
                                        <p>
                                            A function is a block of code designed to perform a particular task. A
                                            function is executed when "something" invokes it (calls it).
                                        </p>

                                        <% String basicHtml="<h2>Function Demo</h2>\n<p id='demo'></p>" ; String
                                            basicJs="// Function Declaration\nfunction greet(name) {\n  return `Hello, ${name}!`;\n}\n\n// Calling the function\nlet message = greet('Alice');\n\ndocument.getElementById('demo').innerHTML = message;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=basicHtml%>" />
                                                <jsp:param name="initialJs" value="<%=basicJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Function Expressions</h2>
                                            <p>
                                                A function can also be defined using an expression. A function
                                                expression can be stored in a variable.
                                            </p>
                                            <pre class="code-example-sm"><code>const square = function(number) {
  return number * number;
};

let x = square(4); // x gets the value 16</code></pre>

                                            <h2>Arrow Functions</h2>
                                            <p>
                                                Arrow functions (introduced in ES6) allow for a shorter syntax for
                                                writing function expressions.
                                            </p>

                                            <% String arrowHtml="<h2>Arrow Function Demo</h2>\n<p id='arrowOutput'></p>"
                                                ; String
                                                arrowJs="// Traditional Function\nconst add = function(a, b) {\n  return a + b;\n};\n\n// Arrow Function\nconst multiply = (a, b) => a * b;\n\n// Arrow Function (One parameter, implicit return)\nconst double = n => n * 2;\n\nlet output = `\n  Add(5, 3): ${add(5, 3)}<br>\n  Multiply(5, 3): ${multiply(5, 3)}<br>\n  Double(10): ${double(10)}\n`;\n\ndocument.getElementById('arrowOutput').innerHTML = output;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-arrow" />
                                                    <jsp:param name="initialHtml" value="<%=arrowHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=arrowJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <div class="callout callout-tip">
                                                    <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10" />
                                                        <path d="M12 16v-4M12 8h.01" />
                                                    </svg>
                                                    <div class="callout-content">
                                                        <strong>Implicit Return:</strong> If an arrow function has a
                                                        single expression in its body, you can omit the curly braces
                                                        <code>{}</code> and the <code>return</code> keyword.
                                                    </div>
                                                </div>

                                                <h2>Parameters and Arguments</h2>
                                                <p>
                                                    <strong>Parameters</strong> are the names listed in the function
                                                    definition. <br>
                                                    <strong>Arguments</strong> are the real values passed to the
                                                    function.
                                                </p>

                                                <% String
                                                    paramsHtml="<h2>Default Parameters Demo</h2>\n<p id='paramsOutput'></p>"
                                                    ; String
                                                    paramsJs="// Default Parameter Value (ES6)\nfunction welcome(user = 'Guest') {\n  return `Welcome, ${user}!`;\n}\n\nlet msg1 = welcome('John');\nlet msg2 = welcome(); // Uses default 'Guest'\n\ndocument.getElementById('paramsOutput').innerHTML = `\n  ${msg1}<br>\n  ${msg2}\n`;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-params" />
                                                        <jsp:param name="initialHtml" value="<%=paramsHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=paramsJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Functions are reusable blocks of code.</li>
                                                            <li>Functions can return values using the
                                                                <code>return</code> keyword.</li>
                                                            <li>Variables declared inside a function are local to the
                                                                function.</li>
                                                            <li>Arrow functions provide a concise syntax for writing
                                                                functions.</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-functions" />
                                                        <jsp:param name="question"
                                                            value="Which syntax is correct for an arrow function?" />
                                                        <jsp:param name="option1" value="function() => {}" />
                                                        <jsp:param name="option2" value="() => {}" />
                                                        <jsp:param name="option3" value="=> function() {}" />
                                                        <jsp:param name="option4" value="arrow() {}" />
                                                        <jsp:param name="correctAnswer" value="2" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="loops.jsp" />
                                                        <jsp:param name="prevTitle" value="Loops" />
                                                        <jsp:param name="nextLink" value="scope-closures.jsp" />
                                                        <jsp:param name="nextTitle" value="Scope & Closures" />
                                                        <jsp:param name="currentLessonId" value="functions" />
                                                    </jsp:include>
                                    </div>
                                </article>

                                <aside class="tutorial-preview" id="previewPanel">
                                    <div class="preview-header">
                                        <span>Live Preview</span>
                                        <button class="btn btn-ghost btn-icon" onclick="refreshPreview()"
                                            title="Refresh">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M23 4v6h-6M1 20v-6h6" />
                                                <path
                                                    d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15" />
                                            </svg>
                                        </button>
                                    </div>
                                    <iframe id="previewFrame" class="preview-frame"
                                        sandbox="allow-scripts allow-same-origin"></iframe>
                                </aside>
                        </main>

                        <%@ include file="../tutorial-footer.jsp" %>
                </div>

                <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
                <script
                    src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
                <script
                    src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            </body>

            </html>