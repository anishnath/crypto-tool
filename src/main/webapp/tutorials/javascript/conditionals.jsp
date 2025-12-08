<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Conditionals Lesson 9: If, Else, Else If, Switch, Ternary Operator --%>
        <% request.setAttribute("currentLesson", "conditionals" ); request.setAttribute("currentModule", "Control Flow"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Conditionals | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript conditional statements: if, else, else if, switch, and the ternary operator.">
                <meta name="keywords" content="JavaScript conditionals, if else, switch statement, ternary operator">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Conditionals">
                <meta property="og:description" content="Master JavaScript decision making with conditionals">
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

            <body class="tutorial-body" data-lesson="conditionals">
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
                                        <span>Conditionals</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Conditionals</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>If, Else, and Else If</h2>
                                        <p>
                                            Conditional statements are used to perform different actions based on
                                            different conditions.
                                        </p>

                                        <% String ifHtml="<h2>If/Else Demo</h2>\n<p id='greeting'></p>" ; String
                                            ifJs="const hour = new Date().getHours();\nlet greeting;\n\nif (hour < 12) {\n  greeting = 'Good Morning!';\n} else if (hour < 18) {\n  greeting = 'Good Afternoon!';\n} else {\n  greeting = 'Good Evening!';\n}\n\ndocument.getElementById('greeting').innerHTML = `\n  Current Hour: ${hour}<br>\n  Message: <strong>${greeting}</strong>\n`;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-if" />
                                                <jsp:param name="initialHtml" value="<%=ifHtml%>" />
                                                <jsp:param name="initialJs" value="<%=ifJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>The Switch Statement</h2>
                                            <p>
                                                Use the <code>switch</code> statement to select one of many code blocks
                                                to be executed. It's often cleaner than many <code>else if</code>
                                                statements.
                                            </p>

                                            <% String switchHtml="<h2>Switch Demo</h2>\n<p id='day'></p>" ; String
                                                switchJs="let day;\nswitch (new Date().getDay()) {\n  case 0:\n    day = 'Sunday';\n    break;\n  case 1:\n    day = 'Monday';\n    break;\n  case 2:\n    day = 'Tuesday';\n    break;\n  case 3:\n    day = 'Wednesday';\n    break;\n  case 4:\n    day = 'Thursday';\n    break;\n  case 5:\n    day = 'Friday';\n    break;\n  case 6:\n    day = 'Saturday';\n    break;\n  default:\n    day = 'Unknown Day';\n}\n\ndocument.getElementById('day').innerHTML = `Today is: <strong>${day}</strong>`;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-switch" />
                                                    <jsp:param name="initialHtml" value="<%=switchHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=switchJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <div class="callout callout-tip">
                                                    <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10" />
                                                        <path d="M12 16v-4M12 8h.01" />
                                                    </svg>
                                                    <div class="callout-content">
                                                        <strong>Don't forget <code>break</code>!</strong> If you omit
                                                        the break statement, the next case will be executed even if the
                                                        evaluation does not match the case. This is called
                                                        "fall-through".
                                                    </div>
                                                </div>

                                                <h2>Ternary Operator</h2>
                                                <p>
                                                    The ternary operator is a shorthand for <code>if...else</code>
                                                    statements. It assigns a value to a variable based on a condition.
                                                </p>
                                                <pre
                                                    class="code-example-sm"><code>condition ? exprIfTrue : exprIfFalse</code></pre>

                                                <% String ternaryHtml="<h2>Ternary Demo</h2>\n<p id='ternary'></p>" ;
                                                    String
                                                    ternaryJs="let age = 20;\n\n// Traditional If/Else\nlet canVote;\nif (age >= 18) {\n  canVote = 'Yes';\n} else {\n  canVote = 'No';\n}\n\n// Ternary Operator (One line!)\nlet canDrive = (age >= 16) ? 'Yes' : 'No';\n\ndocument.getElementById('ternary').innerHTML = `\n  Age: ${age}<br>\n  Can Vote? ${canVote}<br>\n  Can Drive? ${canDrive}\n`;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-ternary" />
                                                        <jsp:param name="initialHtml" value="<%=ternaryHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=ternaryJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Use <code>if</code> to specify a block of code to be
                                                                executed, if a specified condition is true.</li>
                                                            <li>Use <code>else</code> to specify a block of code to be
                                                                executed, if the same condition is false.</li>
                                                            <li>Use <code>else if</code> to specify a new condition to
                                                                test, if the first condition is false.</li>
                                                            <li>Use <code>switch</code> to specify many alternative
                                                                blocks of code to be executed.</li>
                                                            <li>Use the <strong>ternary operator</strong>
                                                                (<code>? :</code>) for concise conditional assignments.
                                                            </li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-conditionals" />
                                                        <jsp:param name="question"
                                                            value="Which keyword stops the execution inside a switch block?" />
                                                        <jsp:param name="option1" value="stop" />
                                                        <jsp:param name="option2" value="break" />
                                                        <jsp:param name="option3" value="return" />
                                                        <jsp:param name="option4" value="exit" />
                                                        <jsp:param name="correctAnswer" value="2" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="numbers-math.jsp" />
                                                        <jsp:param name="prevTitle" value="Numbers & Math" />
                                                        <jsp:param name="nextLink" value="loops.jsp" />
                                                        <jsp:param name="nextTitle" value="Loops" />
                                                        <jsp:param name="currentLessonId" value="conditionals" />
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