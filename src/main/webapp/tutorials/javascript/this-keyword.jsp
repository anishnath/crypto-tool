<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - The 'this' Keyword Lesson 22: Understanding 'this' in different contexts (global, object,
        function, event) --%>
        <% request.setAttribute("currentLesson", "this-keyword" );
            request.setAttribute("currentModule", "Advanced Concepts" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript 'this' Keyword | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master the JavaScript 'this' keyword. Learn how 'this' behaves in methods, functions, events, and arrow functions.">
                <meta name="keywords"
                    content="JavaScript this keyword, this context, call apply bind, arrow functions this">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript 'this' Keyword">
                <meta property="og:description" content="Master the JavaScript 'this' keyword">
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

            <body class="tutorial-body" data-lesson="this-keyword">
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
                                        <span>The 'this' Keyword</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">The 'this' Keyword</h1>
                                        <div class="lesson-meta">
                                            <span>Advanced</span>
                                            <span>~20 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is 'this'?</h2>
                                        <p>
                                            In JavaScript, the <code>this</code> keyword refers to an
                                            <strong>object</strong>. Which object it refers to depends on how it is
                                            being invoked (used or called).
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li>In an object method, <code>this</code> refers to the
                                                    <strong>object</strong>.</li>
                                                <li>Alone, <code>this</code> refers to the <strong>global
                                                        object</strong> (window).</li>
                                                <li>In a function, <code>this</code> refers to the <strong>global
                                                        object</strong>.</li>
                                                <li>In a function, in strict mode, <code>this</code> is
                                                    <strong>undefined</strong>.</li>
                                                <li>In an event, <code>this</code> refers to the
                                                    <strong>element</strong> that received the event.</li>
                                            </ul>
                                        </div>

                                        <h2>'this' in a Method</h2>
                                        <p>
                                            When used in an object method, <code>this</code> refers to the object.
                                        </p>

                                        <% String methodHtml="<h2>Method Context Demo</h2>\n<p id='methodOutput'></p>" ;
                                            String
                                            methodJs="const person = {\n  firstName: 'John',\n  lastName: 'Doe',\n  fullName: function() {\n    return this.firstName + ' ' + this.lastName;\n  }\n};\n\ndocument.getElementById('methodOutput').innerHTML = person.fullName();"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-method" />
                                                <jsp:param name="initialHtml" value="<%=methodHtml%>" />
                                                <jsp:param name="initialJs" value="<%=methodJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>'this' Alone (Global Context)</h2>
                                            <p>
                                                When used alone, <code>this</code> refers to the global object. In a
                                                browser window, the global object is <code>[object Window]</code>.
                                            </p>

                                            <% String
                                                globalHtml="<h2>Global Context Demo</h2>\n<p id='globalOutput'></p>" ;
                                                String
                                                globalJs="let x = this;\ndocument.getElementById('globalOutput').innerHTML = x;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-global" />
                                                    <jsp:param name="initialHtml" value="<%=globalHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=globalJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Explicit Binding: call(), apply(), and bind()</h2>
                                                <p>
                                                    The <code>call()</code>, <code>apply()</code>, and
                                                    <code>bind()</code> methods allow you to explicitly set the value of
                                                    <code>this</code> for a function call.
                                                </p>

                                                <% String
                                                    explicitHtml="<h2>Explicit Binding Demo</h2>\n<p id='explicitOutput'></p>"
                                                    ; String
                                                    explicitJs="const person1 = {\n  fullName: function() {\n    return this.firstName + ' ' + this.lastName;\n  }\n}\n\nconst person2 = {\n  firstName: 'Mary',\n  lastName: 'Doe'\n}\n\n// Using call() to use person1's method on person2\nlet name = person1.fullName.call(person2);\n\ndocument.getElementById('explicitOutput').innerHTML = name;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-explicit" />
                                                        <jsp:param name="initialHtml" value="<%=explicitHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=explicitJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>'this' in Arrow Functions</h2>
                                                    <p>
                                                        Arrow functions treat <code>this</code> differently. They don't
                                                        have their own <code>this</code> binding. Instead,
                                                        <code>this</code> is looked up in scope just like a normal
                                                        variable. This is called <strong>lexical scoping</strong>.
                                                    </p>

                                                    <% String
                                                        arrowHtml="<h2>Arrow Function Demo</h2>\n<p id='arrowOutput'></p>"
                                                        ; String
                                                        arrowJs="const obj = {\n  name: 'My Object',\n  regularFunc: function() {\n    return 'Regular: ' + this.name; // 'this' is obj\n  },\n  arrowFunc: () => {\n    return 'Arrow: ' + this.name; // 'this' is window (undefined name)\n  }\n};\n\nlet output = obj.regularFunc() + '<br>' + obj.arrowFunc();\ndocument.getElementById('arrowOutput').innerHTML = output;"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-arrow" />
                                                            <jsp:param name="initialHtml" value="<%=arrowHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=arrowJs%>" />
                                                            <jsp:param name="defaultTab" value="js" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li><code>this</code> refers to the object that is
                                                                    executing the current function.</li>
                                                                <li>The value of <code>this</code> is determined at
                                                                    runtime (dynamic binding), except for arrow
                                                                    functions.</li>
                                                                <li>Use <code>call</code>, <code>apply</code>, or
                                                                    <code>bind</code> to control <code>this</code>
                                                                    manually.</li>
                                                                <li>Arrow functions inherit <code>this</code> from the
                                                                    surrounding code.</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-this" />
                                                            <jsp:param name="question"
                                                                value="In an event handler, what does 'this' refer to?" />
                                                            <jsp:param name="option1"
                                                                value="The global window object" />
                                                            <jsp:param name="option2"
                                                                value="The element that received the event" />
                                                            <jsp:param name="option3" value="The function itself" />
                                                            <jsp:param name="option4" value="Undefined" />
                                                            <jsp:param name="correctAnswer" value="2" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="event-listeners.jsp" />
                                                            <jsp:param name="prevTitle" value="Event Listeners" />
                                                            <jsp:param name="nextLink" value="prototypes.jsp" />
                                                            <jsp:param name="nextTitle" value="Prototypes" />
                                                            <jsp:param name="currentLessonId" value="this-keyword" />
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