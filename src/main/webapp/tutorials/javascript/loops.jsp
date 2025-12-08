<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Loops Lesson 10: For, While, Do While, Break, Continue --%>
        <% request.setAttribute("currentLesson", "loops" ); request.setAttribute("currentModule", "Control Flow" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Loops | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript loops: for loop, while loop, do while loop, and loop control statements like break and continue.">
                <meta name="keywords" content="JavaScript loops, for loop, while loop, do while, break continue">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Loops">
                <meta property="og:description" content="Master JavaScript iteration with loops">
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

            <body class="tutorial-body" data-lesson="loops">
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
                                        <span>Loops</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Loops</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>The For Loop</h2>
                                        <p>
                                            Loops can execute a block of code a number of times. The <code>for</code>
                                            loop is the most common loop.
                                        </p>
                                        <pre class="code-example-sm"><code>for (expression 1; expression 2; expression 3) {
  // code block to be executed
}</code></pre>

                                        <% String forHtml="<h2>For Loop Demo</h2>\n<p id='forOutput'></p>" ; String
                                            forJs="let text = '';\n\nfor (let i = 0; i < 5; i++) {\n  text += `The number is ${i}<br>`;\n}\n\ndocument.getElementById('forOutput').innerHTML = text;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-for" />
                                                <jsp:param name="initialHtml" value="<%=forHtml%>" />
                                                <jsp:param name="initialJs" value="<%=forJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>The While Loop</h2>
                                            <p>
                                                The <code>while</code> loop loops through a block of code as long as a
                                                specified condition is true.
                                            </p>

                                            <% String whileHtml="<h2>While Loop Demo</h2>\n<p id='whileOutput'></p>" ;
                                                String
                                                whileJs="let text = '';\nlet i = 0;\n\nwhile (i < 5) {\n  text += `Count: ${i} | `;\n  i++;\n}\n\ndocument.getElementById('whileOutput').innerHTML = text;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-while" />
                                                    <jsp:param name="initialHtml" value="<%=whileHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=whileJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Do...While Loop</h2>
                                                <p>
                                                    The <code>do...while</code> loop is a variant of the while loop.
                                                    This loop will execute the code block once, before checking if the
                                                    condition is true, then it will repeat the loop as long as the
                                                    condition is true.
                                                </p>

                                                <% String
                                                    doWhileHtml="<h2>Do...While Demo</h2>\n<p id='doWhileOutput'></p>" ;
                                                    String
                                                    doWhileJs="let text = '';\nlet i = 10;\n\ndo {\n  text += `Number is ${i} (Condition i < 5 is false, but run once)<br>`;\n  i++;\n} while (i < 5);\n\ndocument.getElementById('doWhileOutput').innerHTML = text;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-dowhile" />
                                                        <jsp:param name="initialHtml" value="<%=doWhileHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=doWhileJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Break and Continue</h2>
                                                    <p>
                                                        The <code>break</code> statement "jumps out" of a loop. <br>
                                                        The <code>continue</code> statement "jumps over" one iteration
                                                        in the loop.
                                                    </p>

                                                    <% String
                                                        breakHtml="<h2>Break/Continue Demo</h2>\n<p id='breakOutput'></p>"
                                                        ; String
                                                        breakJs="let text = '';\n\nfor (let i = 0; i < 10; i++) {\n  if (i === 3) {\n    text += 'Skipped 3 (continue)<br>';\n    continue;\n  }\n  if (i === 7) {\n    text += 'Stopped at 7 (break)<br>';\n    break;\n  }\n  text += `Number: ${i}<br>`;\n}\n\ndocument.getElementById('breakOutput').innerHTML = text;"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-break" />
                                                            <jsp:param name="initialHtml" value="<%=breakHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=breakJs%>" />
                                                            <jsp:param name="defaultTab" value="js" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li><code>for</code> - loops through a block of code a
                                                                    number of times</li>
                                                                <li><code>while</code> - loops through a block of code
                                                                    while a specified condition is true</li>
                                                                <li><code>do...while</code> - also loops through a block
                                                                    of code while a specified condition is true</li>
                                                                <li><code>break</code> - exits the loop</li>
                                                                <li><code>continue</code> - skips the current iteration
                                                                    and continues with the next</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-loops" />
                                                            <jsp:param name="question"
                                                                value="Which statement skips the current iteration of a loop?" />
                                                            <jsp:param name="option1" value="break" />
                                                            <jsp:param name="option2" value="stop" />
                                                            <jsp:param name="option3" value="continue" />
                                                            <jsp:param name="option4" value="skip" />
                                                            <jsp:param name="correctAnswer" value="3" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="conditionals.jsp" />
                                                            <jsp:param name="prevTitle" value="Conditionals" />
                                                            <jsp:param name="nextLink" value="functions.jsp" />
                                                            <jsp:param name="nextTitle" value="Functions" />
                                                            <jsp:param name="currentLessonId" value="loops" />
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