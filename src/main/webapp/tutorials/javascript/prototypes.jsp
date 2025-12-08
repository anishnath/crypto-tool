<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Prototypes Lesson 23: Prototype chain, inheritance, __proto__, prototype property --%>
        <% request.setAttribute("currentLesson", "prototypes" );
            request.setAttribute("currentModule", "Advanced Concepts" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Prototypes | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Understand JavaScript prototypes, the prototype chain, and inheritance. Learn how objects inherit properties and methods.">
                <meta name="keywords"
                    content="JavaScript prototypes, prototype chain, inheritance, __proto__, prototype property">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Prototypes">
                <meta property="og:description" content="Master JavaScript prototypes and inheritance">
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

            <body class="tutorial-body" data-lesson="prototypes">
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
                                        <span>Prototypes</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Prototypes & Inheritance</h1>
                                        <div class="lesson-meta">
                                            <span>Advanced</span>
                                            <span>~25 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is a Prototype?</h2>
                                        <p>
                                            JavaScript is a prototype-based language. All JavaScript objects inherit
                                            properties and methods from a <strong>prototype</strong>.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><code>Date</code> objects inherit from <code>Date.prototype</code>
                                                </li>
                                                <li><code>Array</code> objects inherit from <code>Array.prototype</code>
                                                </li>
                                                <li><code>Person</code> objects inherit from
                                                    <code>Person.prototype</code></li>
                                            </ul>
                                        </div>

                                        <h2>The Prototype Chain</h2>
                                        <p>
                                            When you try to access a property of an object:
                                        <ol>
                                            <li>JavaScript first checks if the object itself has the property.</li>
                                            <li>If not, it looks at the object's prototype.</li>
                                            <li>If not there, it looks at the prototype's prototype.</li>
                                            <li>This continues until it reaches <code>Object.prototype</code> (the top
                                                of the chain).</li>
                                        </ol>
                                        </p>

                                        <% String chainHtml="<h2>Prototype Chain Demo</h2>\n<p id='chainOutput'></p>" ;
                                            String
                                            chainJs="const myObj = {};\n\n// myObj doesn't have toString(), but it inherits it from Object.prototype\nconst str = myObj.toString();\n\ndocument.getElementById('chainOutput').innerHTML = `\n  Has own toString? ${myObj.hasOwnProperty('toString')}<br>\n  Result of toString(): ${str}\n`;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-chain" />
                                                <jsp:param name="initialHtml" value="<%=chainHtml%>" />
                                                <jsp:param name="initialJs" value="<%=chainJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Adding Properties to Prototypes</h2>
                                            <p>
                                                You can add new properties or methods to all existing objects of a given
                                                type by adding them to the prototype.
                                            </p>

                                            <% String
                                                protoHtml="<h2>Adding to Prototype Demo</h2>\n<p id='protoOutput'></p>"
                                                ; String
                                                protoJs="function Person(first, last) {\n  this.firstName = first;\n  this.lastName = last;\n}\n\n// Add a method to the prototype\nPerson.prototype.fullName = function() {\n  return this.firstName + ' ' + this.lastName;\n};\n\nconst myFather = new Person('John', 'Doe');\nconst myMother = new Person('Mary', 'Doe');\n\ndocument.getElementById('protoOutput').innerHTML = `\n  Father: ${myFather.fullName()}<br>\n  Mother: ${myMother.fullName()}\n`;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-proto" />
                                                    <jsp:param name="initialHtml" value="<%=protoHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=protoJs%>" />
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
                                                        <strong>Warning:</strong> Only modify your <em>own</em>
                                                        prototypes. Never modify the prototypes of standard JavaScript
                                                        objects (like <code>Array.prototype</code>) as this can cause
                                                        conflicts with other libraries.
                                                    </div>
                                                </div>

                                                <h2>Prototypal Inheritance</h2>
                                                <p>
                                                    Before ES6 Classes, prototypes were the primary way to implement
                                                    inheritance in JavaScript.
                                                </p>

                                                <% String
                                                    inheritHtml="<h2>Inheritance Demo</h2>\n<p id='inheritOutput'></p>"
                                                    ; String
                                                    inheritJs="const animal = {\n  eats: true,\n  walk() {\n    return 'Animal walk';\n  }\n};\n\nconst rabbit = {\n  jumps: true,\n  __proto__: animal // Inherit from animal\n};\n\nlet output = `\n  Can rabbit jump? ${rabbit.jumps}<br>\n  Can rabbit eat? ${rabbit.eats} (Inherited)<br>\n  Action: ${rabbit.walk()} (Inherited)\n`;\n\ndocument.getElementById('inheritOutput').innerHTML = output;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-inherit" />
                                                        <jsp:param name="initialHtml" value="<%=inheritHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=inheritJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Every JavaScript object has a prototype.</li>
                                                            <li>Objects inherit properties and methods from their
                                                                prototype.</li>
                                                            <li>The prototype chain allows for property lookups up the
                                                                hierarchy.</li>
                                                            <li>You can extend constructors by adding to their
                                                                <code>.prototype</code>.</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-proto" />
                                                        <jsp:param name="question"
                                                            value="What is the top of the prototype chain?" />
                                                        <jsp:param name="option1" value="Array.prototype" />
                                                        <jsp:param name="option2" value="Function.prototype" />
                                                        <jsp:param name="option3" value="Object.prototype" />
                                                        <jsp:param name="option4" value="Window.prototype" />
                                                        <jsp:param name="correctAnswer" value="3" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="this-keyword.jsp" />
                                                        <jsp:param name="prevTitle" value="The 'this' Keyword" />
                                                        <jsp:param name="nextLink" value="classes.jsp" />
                                                        <jsp:param name="nextTitle" value="Classes" />
                                                        <jsp:param name="currentLessonId" value="prototypes" />
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