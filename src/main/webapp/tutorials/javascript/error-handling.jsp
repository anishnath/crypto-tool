<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Error Handling Lesson 32: try, catch, throw, finally, Error Object --%>
        <% request.setAttribute("currentLesson", "error-handling" );
            request.setAttribute("currentModule", "Practical Topics" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Error Handling | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to handle errors in JavaScript using try, catch, throw, and finally blocks. Understand the Error object.">
                <meta name="keywords"
                    content="JavaScript error handling, try catch, throw error, finally block, javascript errors">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Error Handling">
                <meta property="og:description" content="Master JavaScript Error Handling">
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

            <body class="tutorial-body" data-lesson="error-handling">
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
                                        <span>Error Handling</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Error Handling</h1>
                                        <div class="lesson-meta">
                                            <span>Practical</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>The try...catch Statement</h2>
                                        <p>
                                            The <code>try</code> statement defines a code block to run (to try).
                                        </p>
                                        <p>
                                            The <code>catch</code> statement defines a code block to handle any error.
                                        </p>
                                        <p>
                                            The <code>finally</code> statement defines a code block to run regardless of
                                            the result.
                                        </p>

                                        <% String tryHtml="<h2>Try/Catch Demo</h2>\n<p id='tryOutput'></p>" ; String
                                            tryJs="try {\n  // Block of code to try\n  nonExistentFunction();\n} catch(err) {\n  // Block of code to handle errors\n  document.getElementById('tryOutput').innerHTML = err.message;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-try" />
                                                <jsp:param name="initialHtml" value="<%=tryHtml%>" />
                                                <jsp:param name="initialJs" value="<%=tryJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>The throw Statement</h2>
                                            <p>
                                                The <code>throw</code> statement allows you to create a custom error.
                                            </p>

                                            <% String
                                                throwHtml="<h2>Throw Demo</h2>\n<input id='demo' type='text' placeholder='Enter a number between 5 and 10'>\n<button onclick='myFunction()'>Test Input</button>\n<p id='throwOutput'></p>"
                                                ; String
                                                throwJs="function myFunction() {\n  const message = document.getElementById('throwOutput');\n  message.innerHTML = '';\n  let x = document.getElementById('demo').value;\n  \n  try {\n    if(x == '') throw 'empty';\n    if(isNaN(x)) throw 'not a number';\n    x = Number(x);\n    if(x < 5) throw 'too low';\n    if(x > 10) throw 'too high';\n    message.innerHTML = 'Input is ' + x;\n  } catch(err) {\n    message.innerHTML = 'Input is ' + err;\n  }\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-throw" />
                                                    <jsp:param name="initialHtml" value="<%=throwHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=throwJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>The finally Statement</h2>
                                                <p>
                                                    The <code>finally</code> statement lets you execute code, after try
                                                    and catch, regardless of the result.
                                                </p>

                                                <% String
                                                    finallyHtml="<h2>Finally Demo</h2>\n<p id='finallyOutput'></p>" ;
                                                    String
                                                    finallyJs="try {\n  // Code that might fail\n  let x = y + 1; // y is not defined\n} catch(err) {\n  document.getElementById('finallyOutput').innerHTML += 'Error caught.<br>';\n} finally {\n  document.getElementById('finallyOutput').innerHTML += 'Finally block executed.';\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-finally" />
                                                        <jsp:param name="initialHtml" value="<%=finallyHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=finallyJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Use <code>try...catch</code> to handle runtime errors
                                                                gracefully.</li>
                                                            <li>Use <code>throw</code> to create custom errors.</li>
                                                            <li>Use <code>finally</code> to execute code regardless of
                                                                the outcome (e.g., cleanup).</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-error" />
                                                        <jsp:param name="question"
                                                            value="Which block is executed regardless of the result?" />
                                                        <jsp:param name="option1" value="try" />
                                                        <jsp:param name="option2" value="catch" />
                                                        <jsp:param name="option3" value="finally" />
                                                        <jsp:param name="option4" value="throw" />
                                                        <jsp:param name="correctAnswer" value="3" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="string-advanced.jsp" />
                                                        <jsp:param name="prevTitle" value="Advanced Strings" />
                                                        <jsp:param name="nextLink" value="json.jsp" />
                                                        <jsp:param name="nextTitle" value="JSON" />
                                                        <jsp:param name="currentLessonId" value="error-handling" />
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