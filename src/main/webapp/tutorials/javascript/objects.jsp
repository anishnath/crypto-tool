<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Objects Lesson 15: Object properties, methods, and accessors --%>
        <% request.setAttribute("currentLesson", "objects" ); request.setAttribute("currentModule", "Data Structures" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Objects | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript Objects. Understand object properties, methods, and how to access and modify them.">
                <meta name="keywords" content="JavaScript objects, object properties, object methods, this keyword">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Objects">
                <meta property="og:description" content="Master JavaScript objects">
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

            <body class="tutorial-body" data-lesson="objects">
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
                                        <span>Objects</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Objects</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Objects?</h2>
                                        <p>
                                            In real life, a car is an object. A car has <strong>properties</strong> like
                                            weight and color, and <strong>methods</strong> like start and stop.
                                        </p>
                                        <p>
                                            In JavaScript, objects are variables too. But objects can contain many
                                            values.
                                        </p>

                                        <% String basicHtml="<h2>Object Demo</h2>\n<p id='demo'></p>" ; String
                                            basicJs="const car = {\n  type: 'Fiat',\n  model: '500',\n  color: 'white'\n};\n\ndocument.getElementById('demo').innerHTML = `The car type is ${car.type}`"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=basicHtml%>" />
                                                <jsp:param name="initialJs" value="<%=basicJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Accessing Properties</h2>
                                            <p>
                                                You can access object properties in two ways:
                                            </p>
                                            <div class="card" style="margin: var(--space-6) 0;">
                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                    <li><code>objectName.propertyName</code> (Dot notation)</li>
                                                    <li><code>objectName["propertyName"]</code> (Bracket notation)</li>
                                                </ul>
                                            </div>

                                            <% String accessHtml="<h2>Access Demo</h2>\n<p id='accessOutput'></p>" ;
                                                String
                                                accessJs="const person = {\n  firstName: 'John',\n  lastName: 'Doe',\n  age: 50\n};\n\nlet output = '';\noutput += `Dot Notation: ${person.firstName}<br>`;\noutput += `Bracket Notation: ${person['lastName']}<br>`;\n\n// Dynamic access\nlet prop = 'age';\noutput += `Dynamic Access: ${person[prop]}`;\n\ndocument.getElementById('accessOutput').innerHTML = output;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-access" />
                                                    <jsp:param name="initialHtml" value="<%=accessHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=accessJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Object Methods</h2>
                                                <p>
                                                    Objects can also have methods. Methods are actions that can be
                                                    performed on objects. Methods are stored in properties as function
                                                    definitions.
                                                </p>

                                                <% String methodHtml="<h2>Method Demo</h2>\n<p id='methodOutput'></p>" ;
                                                    String
                                                    methodJs="const person = {\n  firstName: 'John',\n  lastName: 'Doe',\n  id: 5566,\n  fullName: function() {\n    return this.firstName + ' ' + this.lastName;\n  }\n};\n\ndocument.getElementById('methodOutput').innerHTML = person.fullName();"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-method" />
                                                        <jsp:param name="initialHtml" value="<%=methodHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=methodJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <div class="callout callout-tip">
                                                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="10" />
                                                            <path d="M12 16v-4M12 8h.01" />
                                                        </svg>
                                                        <div class="callout-content">
                                                            <strong>The <code>this</code> Keyword:</strong> In an object
                                                            method, <code>this</code> refers to the object itself. In
                                                            the example above, <code>this.firstName</code> means the
                                                            firstName property of <strong>this object</strong>.
                                                        </div>
                                                    </div>

                                                    <h2>Adding and Deleting Properties</h2>
                                                    <p>
                                                        You can add new properties to an existing object by simply
                                                        giving it a value. You can delete properties using the
                                                        <code>delete</code> keyword.
                                                    </p>

                                                    <% String
                                                        modifyHtml="<h2>Modify Object Demo</h2>\n<p id='modifyOutput'></p>"
                                                        ; String
                                                        modifyJs="const person = {\n  firstName: 'John',\n  lastName: 'Doe'\n};\n\n// Add property\nperson.nationality = 'English';\n\n// Delete property\ndelete person.lastName;\n\nlet output = `\n  Name: ${person.firstName}<br>\n  Nationality: ${person.nationality}<br>\n  Last Name: ${person.lastName} (undefined)\n`;\n\ndocument.getElementById('modifyOutput').innerHTML = output;"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-modify" />
                                                            <jsp:param name="initialHtml" value="<%=modifyHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=modifyJs%>" />
                                                            <jsp:param name="defaultTab" value="js" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li>Objects are containers for named values called
                                                                    properties.</li>
                                                                <li>Methods are functions stored as object properties.
                                                                </li>
                                                                <li>Properties can be accessed via dot notation or
                                                                    bracket notation.</li>
                                                                <li><code>this</code> refers to the owner of the
                                                                    function.</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-objects" />
                                                            <jsp:param name="question"
                                                                value="How do you access the property 'color' of object 'car'?" />
                                                            <jsp:param name="option1" value="car(color)" />
                                                            <jsp:param name="option2" value="car['color']" />
                                                            <jsp:param name="option3" value="car.color" />
                                                            <jsp:param name="option4" value="Both 2 and 3" />
                                                            <jsp:param name="correctAnswer" value="4" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="array-methods.jsp" />
                                                            <jsp:param name="prevTitle" value="Array Methods" />
                                                            <jsp:param name="nextLink" value="object-methods.jsp" />
                                                            <jsp:param name="nextTitle" value="Object Methods" />
                                                            <jsp:param name="currentLessonId" value="objects" />
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