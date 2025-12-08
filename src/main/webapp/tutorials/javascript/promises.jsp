<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Promises Lesson 26: Creating Promises, then(), catch(), finally(), Promise.all() --%>
        <% request.setAttribute("currentLesson", "promises" ); request.setAttribute("currentModule", "Advanced Concepts"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Promises | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master JavaScript Promises. Learn how to create promises, handle success and failure with then/catch, and use Promise.all.">
                <meta name="keywords" content="JavaScript promises, promise then catch, promise all, async programming">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Promises">
                <meta property="og:description" content="Master JavaScript Promises">
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

            <body class="tutorial-body" data-lesson="promises">
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
                                        <span>Promises</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Promises</h1>
                                        <div class="lesson-meta">
                                            <span>Advanced</span>
                                            <span>~25 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is a Promise?</h2>
                                        <p>
                                            A Promise is an object representing the eventual completion (or failure) of
                                            an asynchronous operation.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <p>A Promise is in one of these states:</p>
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><strong>pending:</strong> initial state, neither fulfilled nor
                                                    rejected.</li>
                                                <li><strong>fulfilled:</strong> meaning that the operation completed
                                                    successfully.</li>
                                                <li><strong>rejected:</strong> meaning that the operation failed.</li>
                                            </ul>
                                        </div>

                                        <h2>Creating a Promise</h2>
                                        <p>
                                            A Promise is created using the <code>new Promise()</code> constructor, which
                                            takes a function (executor) with two arguments: <code>resolve</code> and
                                            <code>reject</code>.
                                        </p>

                                        <% String
                                            promiseHtml="<h2>Promise Demo</h2>\n<p id='promiseOutput'>Waiting for promise...</p>"
                                            ; String
                                            promiseJs="const myPromise = new Promise(function(resolve, reject) {\n  // Simulate an async operation (e.g., fetching data)\n  setTimeout(function() {\n    const success = true;\n    if (success) {\n      resolve('Operation Successful!');\n    } else {\n      reject('Operation Failed!');\n    }\n  }, 2000);\n});\n\n// Consuming the promise\nmyPromise.then(function(value) {\n  document.getElementById('promiseOutput').innerHTML = value;\n  document.getElementById('promiseOutput').style.color = 'green';\n}).catch(function(error) {\n  document.getElementById('promiseOutput').innerHTML = error;\n  document.getElementById('promiseOutput').style.color = 'red';\n});"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-promise" />
                                                <jsp:param name="initialHtml" value="<%=promiseHtml%>" />
                                                <jsp:param name="initialJs" value="<%=promiseJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Chaining Promises</h2>
                                            <p>
                                                The <code>then()</code> method returns a new Promise, allowing you to
                                                chain multiple asynchronous operations.
                                            </p>

                                            <% String chainHtml="<h2>Chaining Demo</h2>\n<p id='chainOutput'></p>" ;
                                                String
                                                chainJs="new Promise(function(resolve, reject) {\n  setTimeout(() => resolve(1), 1000);\n}).then(function(result) {\n  document.getElementById('chainOutput').innerHTML += result + '<br>'; // 1\n  return result * 2;\n}).then(function(result) {\n  document.getElementById('chainOutput').innerHTML += result + '<br>'; // 2\n  return result * 2;\n}).then(function(result) {\n  document.getElementById('chainOutput').innerHTML += result + '<br>'; // 4\n  return result * 2;\n});"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-chain" />
                                                    <jsp:param name="initialHtml" value="<%=chainHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=chainJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Promise.all()</h2>
                                                <p>
                                                    The <code>Promise.all()</code> method takes an iterable of promises
                                                    as an input, and returns a single Promise that resolves to an array
                                                    of the results of the input promises.
                                                </p>

                                                <% String
                                                    allHtml="<h2>Promise.all Demo</h2>\n<p id='allOutput'>Waiting for all...</p>"
                                                    ; String
                                                    allJs="const p1 = new Promise(resolve => setTimeout(() => resolve('P1 Done'), 1000));\nconst p2 = new Promise(resolve => setTimeout(() => resolve('P2 Done'), 2000));\nconst p3 = new Promise(resolve => setTimeout(() => resolve('P3 Done'), 500));\n\nPromise.all([p1, p2, p3]).then(values => {\n  document.getElementById('allOutput').innerHTML = values.join('<br>');\n});"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-all" />
                                                        <jsp:param name="initialHtml" value="<%=allHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=allJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Promises provide a cleaner way to handle asynchronous
                                                                operations than callbacks.</li>
                                                            <li>Use <code>resolve()</code> for success and
                                                                <code>reject()</code> for failure.
                                                            </li>
                                                            <li>Use <code>then()</code> to handle success and
                                                                <code>catch()</code> to handle errors.
                                                            </li>
                                                            <li><code>Promise.all()</code> waits for multiple promises
                                                                to complete.</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-promises" />
                                                        <jsp:param name="question"
                                                            value="Which method is used to handle a rejected Promise?" />
                                                        <jsp:param name="option1" value="then()" />
                                                        <jsp:param name="option2" value="finally()" />
                                                        <jsp:param name="option3" value="catch()" />
                                                        <jsp:param name="option4" value="reject()" />
                                                        <jsp:param name="correctAnswer" value="3" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="async-basics.jsp" />
                                                        <jsp:param name="prevTitle" value="Async Basics" />
                                                        <jsp:param name="nextLink" value="async-await.jsp" />
                                                        <jsp:param name="nextTitle"
                                                            value="Next Module: Modern JavaScript" />
                                                        <jsp:param name="currentLessonId" value="promises" />
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