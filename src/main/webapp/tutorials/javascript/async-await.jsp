<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Async/Await Lesson 27: Async functions, await keyword, error handling with try/catch --%>
        <% request.setAttribute("currentLesson", "async-await" );
            request.setAttribute("currentModule", "Modern JavaScript" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Async/Await | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to use async and await in JavaScript. Simplify asynchronous code with modern syntax.">
                <meta name="keywords" content="JavaScript async await, async function, await promise, try catch async">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Async/Await">
                <meta property="og:description" content="Master Async/Await in JavaScript">
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

            <body class="tutorial-body" data-lesson="async-await">
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
                                        <span>Async/Await</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Async/Await</h1>
                                        <div class="lesson-meta">
                                            <span>Modern</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Introduction</h2>
                                        <p>
                                            <code>async</code> and <code>await</code> make promises easier to write.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><code>async</code> makes a function return a Promise.</li>
                                                <li><code>await</code> makes a function wait for a Promise.</li>
                                            </ul>
                                        </div>

                                        <h2>Async Functions</h2>
                                        <p>
                                            The keyword <code>async</code> before a function makes the function return a
                                            promise.
                                        </p>

                                        <% String asyncHtml="<h2>Async Function Demo</h2>\n<p id='asyncOutput'></p>" ;
                                            String
                                            asyncJs="async function myFunction() {\n  return 'Hello';\n}\n\n// Is the same as:\n// function myFunction() {\n//   return Promise.resolve('Hello');\n// }\n\nmyFunction().then(\n  function(value) { \n    document.getElementById('asyncOutput').innerHTML = value; \n  }\n);"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-async" />
                                                <jsp:param name="initialHtml" value="<%=asyncHtml%>" />
                                                <jsp:param name="initialJs" value="<%=asyncJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Await Syntax</h2>
                                            <p>
                                                The keyword <code>await</code> before a promise makes JavaScript wait
                                                until that promise settles and returns its result.
                                            </p>
                                            <p>
                                                <strong>Note:</strong> <code>await</code> only works inside an
                                                <code>async</code> function.
                                            </p>

                                            <% String
                                                awaitHtml="<h2>Await Demo</h2>\n<p id='awaitOutput'>Waiting...</p>" ;
                                                String
                                                awaitJs="async function myDisplay() {\n  let myPromise = new Promise(function(resolve) {\n    setTimeout(function() { resolve('I love You !!'); }, 2000);\n  });\n  \n  document.getElementById('awaitOutput').innerHTML = await myPromise;\n}\n\nmyDisplay();"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-await" />
                                                    <jsp:param name="initialHtml" value="<%=awaitHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=awaitJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Error Handling</h2>
                                                <p>
                                                    You can handle errors in async functions using standard
                                                    <code>try...catch</code> blocks.
                                                </p>

                                                <% String
                                                    errorHtml="<h2>Error Handling Demo</h2>\n<p id='errorOutput'></p>" ;
                                                    String
                                                    errorJs="async function fetchData() {\n  try {\n    let response = await new Promise((resolve, reject) => {\n      setTimeout(() => reject('Network Error!'), 1000);\n    });\n    document.getElementById('errorOutput').innerHTML = response;\n  } catch (err) {\n    document.getElementById('errorOutput').innerHTML = 'Error: ' + err;\n    document.getElementById('errorOutput').style.color = 'red';\n  }\n}\n\nfetchData();"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-error" />
                                                        <jsp:param name="initialHtml" value="<%=errorHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=errorJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li><code>async/await</code> is syntactic sugar built on top
                                                                of Promises.</li>
                                                            <li>It makes asynchronous code look and behave a little more
                                                                like synchronous code.</li>
                                                            <li>Use <code>try...catch</code> for error handling.</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-async-await" />
                                                        <jsp:param name="question"
                                                            value="Can you use 'await' outside of an 'async' function?" />
                                                        <jsp:param name="option1" value="Yes, always" />
                                                        <jsp:param name="option2"
                                                            value="No, never (except top-level await in modules)" />
                                                        <jsp:param name="option3" value="Only in loops" />
                                                        <jsp:param name="option4" value="Only in callbacks" />
                                                        <jsp:param name="correctAnswer" value="2" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="promises.jsp" />
                                                        <jsp:param name="prevTitle" value="Promises" />
                                                        <jsp:param name="nextLink" value="modules.jsp" />
                                                        <jsp:param name="nextTitle" value="Modules" />
                                                        <jsp:param name="currentLessonId" value="async-await" />
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