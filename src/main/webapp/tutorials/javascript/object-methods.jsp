<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Object Methods Lesson 16: Object.keys, Object.values, Object.entries, Object.assign,
        Object.freeze --%>
        <% request.setAttribute("currentLesson", "object-methods" );
            request.setAttribute("currentModule", "Data Structures" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Object Methods | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn advanced JavaScript Object methods: Object.keys, Object.values, Object.entries, Object.assign, and Object.freeze.">
                <meta name="keywords"
                    content="JavaScript object methods, Object.keys, Object.values, Object.assign, Object.freeze">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Object Methods">
                <meta property="og:description" content="Master advanced JavaScript object manipulation">
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

            <body class="tutorial-body" data-lesson="object-methods">
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
                                        <span>Object Methods</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Object Methods</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Iterating Over Objects</h2>
                                        <p>
                                            JavaScript provides static methods to iterate over keys, values, or entries
                                            of an object.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><code>Object.keys(obj)</code>: Returns array of keys</li>
                                                <li><code>Object.values(obj)</code>: Returns array of values</li>
                                                <li><code>Object.entries(obj)</code>: Returns array of [key, value]
                                                    pairs</li>
                                            </ul>
                                        </div>

                                        <% String iterHtml="<h2>Iteration Demo</h2>\n<p id='iterOutput'></p>" ; String
                                            iterJs="const person = {\n  firstName: 'John',\n  lastName: 'Doe',\n  age: 50\n};\n\nlet output = '';\n\n// Keys\noutput += `Keys: ${Object.keys(person)}<br>`;\n\n// Values\noutput += `Values: ${Object.values(person)}<br>`;\n\n// Entries\noutput += 'Entries:<br>';\nfor (let [key, value] of Object.entries(person)) {\n  output += `${key}: ${value}<br>`;\n}\n\ndocument.getElementById('iterOutput').innerHTML = output;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-iter" />
                                                <jsp:param name="initialHtml" value="<%=iterHtml%>" />
                                                <jsp:param name="initialJs" value="<%=iterJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Cloning and Merging</h2>
                                            <p>
                                                <code>Object.assign()</code> copies all enumerable own properties from
                                                one or more source objects to a target object.
                                            </p>
                                            <p>
                                                <strong>Note:</strong> In modern JavaScript, the spread operator
                                                <code>...</code> is often used for this purpose too.
                                            </p>

                                            <% String mergeHtml="<h2>Merge Demo</h2>\n<p id='mergeOutput'></p>" ; String
                                                mergeJs="const target = { a: 1, b: 2 };\nconst source = { b: 4, c: 5 };\n\n// Object.assign\nconst returnedTarget = Object.assign(target, source);\n\n// Spread Operator (ES6)\nconst spreadMerge = { ...target, ...source };\n\ndocument.getElementById('mergeOutput').innerHTML = `\n  Merged (assign): ${JSON.stringify(returnedTarget)}<br>\n  Merged (spread): ${JSON.stringify(spreadMerge)}\n`;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-merge" />
                                                    <jsp:param name="initialHtml" value="<%=mergeHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=mergeJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Preventing Modifications</h2>
                                                <p>
                                                    <code>Object.freeze()</code> freezes an object. A frozen object can
                                                    no longer be changed (new properties cannot be added, existing
                                                    properties cannot be removed or changed).
                                                </p>

                                                <% String freezeHtml="<h2>Freeze Demo</h2>\n<p id='freezeOutput'></p>" ;
                                                    String
                                                    freezeJs="const obj = {\n  prop: 42\n};\n\nObject.freeze(obj);\n\n// Attempt to modify (fails silently or throws error in strict mode)\nobj.prop = 33;\nobj.newProp = 'test';\n\ndocument.getElementById('freezeOutput').innerHTML = `\n  Prop: ${obj.prop} (should be 42)<br>\n  Is Frozen? ${Object.isFrozen(obj)}\n`;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-freeze" />
                                                        <jsp:param name="initialHtml" value="<%=freezeHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=freezeJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Use <code>Object.keys/values/entries</code> to iterate
                                                                over object data.</li>
                                                            <li>Use <code>Object.assign</code> or spread syntax
                                                                <code>{...obj}</code> to merge or clone objects.
                                                            </li>
                                                            <li>Use <code>Object.freeze</code> to make an object
                                                                immutable.</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-objmethods" />
                                                        <jsp:param name="question"
                                                            value="Which method returns an array of a given object's own enumerable property names?" />
                                                        <jsp:param name="option1" value="Object.values()" />
                                                        <jsp:param name="option2" value="Object.entries()" />
                                                        <jsp:param name="option3" value="Object.keys()" />
                                                        <jsp:param name="option4" value="Object.names()" />
                                                        <jsp:param name="correctAnswer" value="3" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="objects.jsp" />
                                                        <jsp:param name="prevTitle" value="Objects" />
                                                        <jsp:param name="nextLink" value="dom-selectors.jsp" />
                                                        <jsp:param name="nextTitle"
                                                            value="Next Module: DOM Manipulation" />
                                                        <jsp:param name="currentLessonId" value="object-methods" />
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