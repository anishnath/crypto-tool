<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Destructuring Lesson 29: Array and Object Destructuring, Spread Operator, Rest Parameter
        --%>
        <% request.setAttribute("currentLesson", "destructuring" );
            request.setAttribute("currentModule", "Modern JavaScript" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Destructuring | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about JavaScript Destructuring Assignment. Unpack arrays and objects into distinct variables. Master the Spread and Rest operators.">
                <meta name="keywords"
                    content="JavaScript destructuring, array destructuring, object destructuring, spread operator, rest parameter">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Destructuring">
                <meta property="og:description" content="Master JavaScript Destructuring and Spread Operator">
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

            <body class="tutorial-body" data-lesson="destructuring">
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
                                        <span>Destructuring</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Destructuring & Spread</h1>
                                        <div class="lesson-meta">
                                            <span>Modern</span>
                                            <span>~20 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Destructuring Assignment</h2>
                                        <p>
                                            The destructuring assignment syntax is a JavaScript expression that makes it
                                            possible to unpack values from arrays, or properties from objects, into
                                            distinct variables.
                                        </p>

                                        <h3>Array Destructuring</h3>
                                        <% String
                                            arrayHtml="<h2>Array Destructuring Demo</h2>\n<p id='arrayOutput'></p>" ;
                                            String
                                            arrayJs="const fruits = ['Apple', 'Banana', 'Orange'];\n\n// Old way\n// const f1 = fruits[0];\n// const f2 = fruits[1];\n\n// New way (Destructuring)\nconst [fruit1, fruit2] = fruits;\n\ndocument.getElementById('arrayOutput').innerHTML = `Fruit 1: ${fruit1}, Fruit 2: ${fruit2}`;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-array" />
                                                <jsp:param name="initialHtml" value="<%=arrayHtml%>" />
                                                <jsp:param name="initialJs" value="<%=arrayJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h3>Object Destructuring</h3>
                                            <% String
                                                objHtml="<h2>Object Destructuring Demo</h2>\n<p id='objOutput'></p>" ;
                                                String
                                                objJs="const person = {\n  firstName: 'John',\n  lastName: 'Doe',\n  age: 50\n};\n\n// Destructuring\nconst { firstName, age } = person;\n\n// Renaming variables\nconst { lastName: surname } = person;\n\ndocument.getElementById('objOutput').innerHTML = \n  `Name: ${firstName}, Age: ${age}, Surname: ${surname}`;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-obj" />
                                                    <jsp:param name="initialHtml" value="<%=objHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=objJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Spread Operator (...)</h2>
                                                <p>
                                                    The spread operator (<code>...</code>) allows an iterable (like an
                                                    array) to be expanded in places where zero or more arguments or
                                                    elements are expected.
                                                </p>

                                                <% String
                                                    spreadHtml="<h2>Spread Operator Demo</h2>\n<p id='spreadOutput'></p>"
                                                    ; String
                                                    spreadJs="const q1 = ['Jan', 'Feb', 'Mar'];\nconst q2 = ['Apr', 'May', 'Jun'];\n\n// Combine arrays\nconst halfYear = [...q1, ...q2];\n\n// Copy object\nconst person = { name: 'John' };\nconst updatedPerson = { ...person, age: 30 };\n\ndocument.getElementById('spreadOutput').innerHTML = \n  `Half Year: ${halfYear}<br>Updated Person: ${JSON.stringify(updatedPerson)}`;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-spread" />
                                                        <jsp:param name="initialHtml" value="<%=spreadHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=spreadJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Rest Parameter (...)</h2>
                                                    <p>
                                                        The rest parameter syntax allows a function to accept an
                                                        indefinite number of arguments as an array. It looks the same as
                                                        spread, but is used in function definitions.
                                                    </p>

                                                    <% String
                                                        restHtml="<h2>Rest Parameter Demo</h2>\n<p id='restOutput'></p>"
                                                        ; String
                                                        restJs="function sum(...args) {\n  let total = 0;\n  for (const arg of args) {\n    total += arg;\n  }\n  return total;\n}\n\nlet result = sum(1, 2, 3, 4, 5);\ndocument.getElementById('restOutput').innerHTML = 'Sum: ' + result;"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-rest" />
                                                            <jsp:param name="initialHtml" value="<%=restHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=restJs%>" />
                                                            <jsp:param name="defaultTab" value="js" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li>Destructuring unpacks values from arrays or
                                                                    properties from objects into variables.</li>
                                                                <li>The Spread operator (<code>...</code>) expands
                                                                    iterables into elements.</li>
                                                                <li>The Rest parameter (<code>...</code>) collects
                                                                    multiple elements into an array.</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-destructuring" />
                                                            <jsp:param name="question"
                                                                value="Which operator is used to unpack an array?" />
                                                            <jsp:param name="option1" value="Rest" />
                                                            <jsp:param name="option2" value="Spread" />
                                                            <jsp:param name="option3" value="Destructure" />
                                                            <jsp:param name="option4" value="Unpack" />
                                                            <jsp:param name="correctAnswer" value="2" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="modules.jsp" />
                                                            <jsp:param name="prevTitle" value="Modules" />
                                                            <jsp:param name="nextLink" value="array-advanced.jsp" />
                                                            <jsp:param name="nextTitle" value="Advanced Arrays" />
                                                            <jsp:param name="currentLessonId" value="destructuring" />
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