<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Local Storage Lesson 34: localStorage, sessionStorage, setItem, getItem, removeItem --%>
        <% request.setAttribute("currentLesson", "local-storage" );
            request.setAttribute("currentModule", "Practical Topics" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Local Storage | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to use the Web Storage API in JavaScript. Store data locally with localStorage and sessionStorage.">
                <meta name="keywords"
                    content="JavaScript local storage, sessionStorage, setItem, getItem, web storage api">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Local Storage">
                <meta property="og:description" content="Master JavaScript Local Storage">
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

            <body class="tutorial-body" data-lesson="local-storage">
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
                                        <span>Local Storage</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Web Storage API</h1>
                                        <div class="lesson-meta">
                                            <span>Practical</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is Web Storage?</h2>
                                        <p>
                                            The Web Storage API provides mechanisms by which browsers can store
                                            key/value pairs, in a much more intuitive fashion than using cookies.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><code>localStorage</code>: Stores data with no expiration date.</li>
                                                <li><code>sessionStorage</code>: Stores data for one session (data is
                                                    lost when the browser tab is closed).</li>
                                            </ul>
                                        </div>

                                        <h2>localStorage Object</h2>
                                        <p>
                                            The <code>localStorage</code> object stores the data with no expiration
                                            date. The data will not be deleted when the browser is closed, and will be
                                            available the next day, week, or year.
                                        </p>

                                        <% String
                                            localHtml="<h2>localStorage Demo</h2>\n<input id='localInput' type='text' placeholder='Enter your name'>\n<button onclick='saveName()'>Save Name</button>\n<button onclick='loadName()'>Load Name</button>\n<button onclick='clearName()'>Clear Name</button>\n<p id='localOutput'></p>"
                                            ; String
                                            localJs="function saveName() {\n  const name = document.getElementById('localInput').value;\n  localStorage.setItem('username', name);\n  document.getElementById('localOutput').innerHTML = 'Name saved!';\n}\n\nfunction loadName() {\n  const name = localStorage.getItem('username');\n  if (name) {\n    document.getElementById('localOutput').innerHTML = 'Hello ' + name;\n  } else {\n    document.getElementById('localOutput').innerHTML = 'No name found.';\n  }\n}\n\nfunction clearName() {\n  localStorage.removeItem('username');\n  document.getElementById('localOutput').innerHTML = 'Name cleared.';\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-local" />
                                                <jsp:param name="initialHtml" value="<%=localHtml%>" />
                                                <jsp:param name="initialJs" value="<%=localJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>sessionStorage Object</h2>
                                            <p>
                                                The <code>sessionStorage</code> object is equal to the localStorage
                                                object, except that it stores the data for only one session. The data is
                                                deleted when the user closes the specific browser tab.
                                            </p>

                                            <% String
                                                sessionHtml="<h2>sessionStorage Demo</h2>\n<p>Refresh the page to see the counter increase. Close the tab to reset.</p>\n<p id='sessionOutput'></p>"
                                                ; String
                                                sessionJs="if (sessionStorage.clickcount) {\n  sessionStorage.clickcount = Number(sessionStorage.clickcount) + 1;\n} else {\n  sessionStorage.clickcount = 1;\n}\ndocument.getElementById('sessionOutput').innerHTML = \n  'You have viewed this page ' + sessionStorage.clickcount + ' time(s) in this session.';"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-session" />
                                                    <jsp:param name="initialHtml" value="<%=sessionHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=sessionJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <div class="callout callout-info">
                                                    <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10" />
                                                        <line x1="12" y1="16" x2="12" y2="12" />
                                                        <line x1="12" y1="8" x2="12.01" y2="8" />
                                                    </svg>
                                                    <div class="callout-content">
                                                        <strong>Note:</strong> Keys and values are always strings.
                                                        Remember to convert them to other formats if needed (e.g., using
                                                        <code>JSON.parse()</code> and <code>JSON.stringify()</code> for
                                                        objects).
                                                    </div>
                                                </div>

                                                <h2>Summary</h2>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <ul style="margin: 0; padding-left: var(--space-6);">
                                                        <li><code>setItem(key, value)</code>: Add key and value to
                                                            storage.</li>
                                                        <li><code>getItem(key)</code>: Retrieve a value by key.</li>
                                                        <li><code>removeItem(key)</code>: Remove an item by key.</li>
                                                        <li><code>clear()</code>: Clear all storage.</li>
                                                    </ul>
                                                </div>

                                                <jsp:include page="../tutorial-quiz.jsp">
                                                    <jsp:param name="quizId" value="quiz-storage" />
                                                    <jsp:param name="question"
                                                        value="Which storage object persists data even after the browser is closed?" />
                                                    <jsp:param name="option1" value="sessionStorage" />
                                                    <jsp:param name="option2" value="cookieStorage" />
                                                    <jsp:param name="option3" value="localStorage" />
                                                    <jsp:param name="option4" value="browserStorage" />
                                                    <jsp:param name="correctAnswer" value="3" />
                                                </jsp:include>

                                                <jsp:include page="../tutorial-nav.jsp">
                                                    <jsp:param name="prevLink" value="json.jsp" />
                                                    <jsp:param name="prevTitle" value="JSON" />
                                                    <jsp:param name="nextLink" value="best-practices.jsp" />
                                                    <jsp:param name="nextTitle" value="Best Practices" />
                                                    <jsp:param name="currentLessonId" value="local-storage" />
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