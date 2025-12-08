<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - JSON Lesson 33: JSON Syntax, JSON.parse(), JSON.stringify() --%>
        <% request.setAttribute("currentLesson", "json" ); request.setAttribute("currentModule", "Practical Topics" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript JSON | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about JSON (JavaScript Object Notation). How to parse JSON strings and stringify JavaScript objects.">
                <meta name="keywords" content="JavaScript JSON, JSON parse, JSON stringify, JSON format">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript JSON">
                <meta property="og:description" content="Master JSON in JavaScript">
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

            <body class="tutorial-body" data-lesson="json">
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
                                        <span>JSON</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JSON (JavaScript Object Notation)</h1>
                                        <div class="lesson-meta">
                                            <span>Practical</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is JSON?</h2>
                                        <p>
                                            JSON stands for <strong>J</strong>ava<strong>S</strong>cript
                                            <strong>O</strong>bject <strong>N</strong>otation. It is a lightweight
                                            data-interchange format.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li>JSON is text, written with JavaScript object notation.</li>
                                                <li>JSON is language independent.</li>
                                                <li>JSON is easy for humans to read and write.</li>
                                            </ul>
                                        </div>

                                        <h2>JSON Syntax</h2>
                                        <p>
                                            JSON syntax is derived from JavaScript object notation syntax:
                                        </p>
                                        <ul style="margin-bottom: var(--space-4);">
                                            <li>Data is in name/value pairs</li>
                                            <li>Data is separated by commas</li>
                                            <li>Curly braces hold objects</li>
                                            <li>Square brackets hold arrays</li>
                                        </ul>
                                        <div class="callout callout-warning">
                                            <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path
                                                    d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                                                <line x1="12" y1="9" x2="12" y2="13" />
                                                <line x1="12" y1="17" x2="12.01" y2="17" />
                                            </svg>
                                            <div class="callout-content">
                                                <strong>Important:</strong> JSON keys must be strings, written with
                                                double quotes.
                                            </div>
                                        </div>

                                        <h2>JSON.parse()</h2>
                                        <p>
                                            A common use of JSON is to exchange data to/from a web server. When
                                            receiving data from a web server, the data is always a string. Parse the
                                            data with <code>JSON.parse()</code>, and the data becomes a JavaScript
                                            object.
                                        </p>

                                        <%
                                            String parseHtml = "<h2>JSON Parse Demo</h2>\n<p id='parseOutput'></p>";
                                            String parseJs = "const txt = '{\"name\":\"John\", \"age\":30, \"city\":\"New York\"}';\n" +
                                                    "const obj = JSON.parse(txt);\n" +
                                                    "document.getElementById('parseOutput').innerHTML = `Name: ${obj.name}, Age: ${obj.age}`;";
                                        %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-parse" />
                                                <jsp:param name="initialHtml" value="<%=parseHtml%>" />
                                                <jsp:param name="initialJs" value="<%=parseJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>JSON.stringify()</h2>
                                            <p>
                                                When sending data to a web server, the data has to be a string. Convert
                                                a JavaScript object into a string with <code>JSON.stringify()</code>.
                                            </p>

                                            <% String
                                                stringifyHtml="<h2>JSON Stringify Demo</h2>\n<p id='stringifyOutput'></p>"
                                                ; String
                                                stringifyJs="const obj = {name: 'John', age: 30, city: 'New York'};\nconst myJSON = JSON.stringify(obj);\n\ndocument.getElementById('stringifyOutput').innerHTML = myJSON;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-stringify" />
                                                    <jsp:param name="initialHtml" value="<%=stringifyHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=stringifyJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Summary</h2>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <ul style="margin: 0; padding-left: var(--space-6);">
                                                        <li>JSON is a text format for storing and transporting data.
                                                        </li>
                                                        <li>Use <code>JSON.parse()</code> to convert a JSON string to a
                                                            JavaScript object.</li>
                                                        <li>Use <code>JSON.stringify()</code> to convert a JavaScript
                                                            object to a JSON string.</li>
                                                    </ul>
                                                </div>

                                                <jsp:include page="../tutorial-quiz.jsp">
                                                    <jsp:param name="quizId" value="quiz-json" />
                                                    <jsp:param name="question"
                                                        value="Which method converts a JavaScript object to a JSON string?" />
                                                    <jsp:param name="option1" value="JSON.parse()" />
                                                    <jsp:param name="option2" value="JSON.toString()" />
                                                    <jsp:param name="option3" value="JSON.stringify()" />
                                                    <jsp:param name="option4" value="JSON.convert()" />
                                                    <jsp:param name="correctAnswer" value="3" />
                                                </jsp:include>

                                                <jsp:include page="../tutorial-nav.jsp">
                                                    <jsp:param name="prevLink" value="error-handling.jsp" />
                                                    <jsp:param name="prevTitle" value="Error Handling" />
                                                    <jsp:param name="nextLink" value="local-storage.jsp" />
                                                    <jsp:param name="nextTitle" value="Local Storage" />
                                                    <jsp:param name="currentLessonId" value="json" />
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