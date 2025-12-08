<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Async Basics Lesson 25: Synchronous vs Asynchronous, Callbacks, setTimeout, setInterval
        --%>
        <% request.setAttribute("currentLesson", "async-basics" );
            request.setAttribute("currentModule", "Advanced Concepts" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Async Basics | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn the basics of Asynchronous JavaScript. Understand callbacks, setTimeout, setInterval, and the difference between sync and async code.">
                <meta name="keywords"
                    content="JavaScript async, callbacks, setTimeout, setInterval, asynchronous programming">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Async Basics">
                <meta property="og:description" content="Master Asynchronous JavaScript Basics">
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

            <body class="tutorial-body" data-lesson="async-basics">
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
                                        <span>Async Basics</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Asynchronous JavaScript</h1>
                                        <div class="lesson-meta">
                                            <span>Advanced</span>
                                            <span>~20 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Synchronous vs Asynchronous</h2>
                                        <p>
                                            <strong>Synchronous</strong> code executes line by line. Each line must
                                            finish before the next one starts.
                                        </p>
                                        <p>
                                            <strong>Asynchronous</strong> code allows the program to start a
                                            long-running task and continue running other code while waiting for the task
                                            to finish.
                                        </p>

                                        <% String syncHtml="<h2>Sync vs Async Demo</h2>\n<p id='syncOutput'></p>" ;
                                            String
                                            syncJs="let output = '';\n\n// Synchronous\noutput += '1. Start<br>';\n\n// Asynchronous (setTimeout)\nsetTimeout(() => {\n  document.getElementById('syncOutput').innerHTML += '2. Async Operation Finished (after 2s)<br>';\n}, 2000);\n\noutput += '3. End<br>';\ndocument.getElementById('syncOutput').innerHTML = output;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-sync" />
                                                <jsp:param name="initialHtml" value="<%=syncHtml%>" />
                                                <jsp:param name="initialJs" value="<%=syncJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Callbacks</h2>
                                            <p>
                                                A callback is a function passed as an argument to another function. This
                                                technique allows a function to call another function. A callback
                                                function can run after another function has finished.
                                            </p>

                                            <% String callbackHtml="<h2>Callback Demo</h2>\n<p id='callbackOutput'></p>"
                                                ; String
                                                callbackJs="function myCalculator(num1, num2, myCallback) {\n  let sum = num1 + num2;\n  myCallback(sum);\n}\n\nfunction displayResult(some) {\n  document.getElementById('callbackOutput').innerHTML = 'Result: ' + some;\n}\n\n// Pass displayResult as a callback\nmyCalculator(5, 5, displayResult);"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-callback" />
                                                    <jsp:param name="initialHtml" value="<%=callbackHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=callbackJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Timing Events</h2>
                                                <p>
                                                    JavaScript allows execution of code at specified time intervals.
                                                </p>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <ul style="margin: 0; padding-left: var(--space-6);">
                                                        <li><code>setTimeout(function, milliseconds)</code>: Executes a
                                                            function after waiting a specified number of milliseconds.
                                                        </li>
                                                        <li><code>setInterval(function, milliseconds)</code>: Same as
                                                            setTimeout(), but repeats the execution of the function
                                                            continuously.</li>
                                                    </ul>
                                                </div>

                                                <% String
                                                    timerHtml="<h2>Timer Demo</h2>\n<p id='timerOutput'>Waiting...</p>\n<button onclick='stopTimer()'>Stop Timer</button>"
                                                    ; String
                                                    timerJs="let count = 0;\nconst output = document.getElementById('timerOutput');\n\nconst intervalId = setInterval(() => {\n  count++;\n  output.innerHTML = `Counter: ${count}`;\n}, 1000);\n\nfunction stopTimer() {\n  clearInterval(intervalId);\n  output.innerHTML += ' (Stopped)';\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-timer" />
                                                        <jsp:param name="initialHtml" value="<%=timerHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=timerJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <div class="callout callout-warning">
                                                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                                                            <line x1="12" y1="9" x2="12" y2="13" />
                                                            <line x1="12" y1="17" x2="12.01" y2="17" />
                                                        </svg>
                                                        <div class="callout-content">
                                                            <strong>Callback Hell:</strong> Using too many nested
                                                            callbacks can make code difficult to read and maintain. This
                                                            is known as "Callback Hell". Promises and Async/Await were
                                                            introduced to solve this.
                                                        </div>
                                                    </div>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Asynchronous code runs in parallel with other code
                                                                (non-blocking).</li>
                                                            <li>Callbacks are functions passed as arguments to be
                                                                executed later.</li>
                                                            <li><code>setTimeout</code> runs code once after a delay.
                                                            </li>
                                                            <li><code>setInterval</code> runs code repeatedly at
                                                                intervals.</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-async" />
                                                        <jsp:param name="question"
                                                            value="Which function is used to stop an interval timer?" />
                                                        <jsp:param name="option1" value="stopInterval()" />
                                                        <jsp:param name="option2" value="clearTimeout()" />
                                                        <jsp:param name="option3" value="clearInterval()" />
                                                        <jsp:param name="option4" value="endTimer()" />
                                                        <jsp:param name="correctAnswer" value="3" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="classes.jsp" />
                                                        <jsp:param name="prevTitle" value="Classes" />
                                                        <jsp:param name="nextLink" value="promises.jsp" />
                                                        <jsp:param name="nextTitle" value="Promises" />
                                                        <jsp:param name="currentLessonId" value="async-basics" />
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