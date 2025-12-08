<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Events Lesson 20: Introduction to events, inline handlers, DOM properties --%>
        <% request.setAttribute("currentLesson", "events" ); request.setAttribute("currentModule", "DOM Manipulation" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Events | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about JavaScript events: click, mouseover, keydown, load, and how to handle them.">
                <meta name="keywords" content="JavaScript events, onclick, onmouseover, event handlers, DOM events">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Events">
                <meta property="og:description" content="Master JavaScript events">
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

            <body class="tutorial-body" data-lesson="events">
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
                                        <span>Events</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Events</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Events?</h2>
                                        <p>
                                            HTML events are "things" that happen to HTML elements. When JavaScript is
                                            used in HTML pages, JavaScript can "react" on these events.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><strong>Mouse Events:</strong> click, dblclick, mouseover, mouseout
                                                </li>
                                                <li><strong>Keyboard Events:</strong> keydown, keyup, keypress</li>
                                                <li><strong>Form Events:</strong> submit, change, focus, blur</li>
                                                <li><strong>Document Events:</strong> load, resize, scroll</li>
                                            </ul>
                                        </div>

                                        <h2>Inline Event Handlers</h2>
                                        <p>
                                            You can add event handlers directly in your HTML code using attributes like
                                            <code>onclick</code>.
                                        </p>
                                        <pre
                                            class="code-example-sm"><code>&lt;button onclick="alert('Hello!')"&gt;Click Me&lt;/button&gt;</code></pre>

                                        <% String inlineHtml="<h2>Inline Handler Demo</h2>\n<button onclick=\"
                                            this.innerHTML='Clicked!' \">Click Me</button>";
                                            String inlineJs = "// No JS needed for inline handler";
                                            %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-inline" />
                                                <jsp:param name="initialHtml" value="<%=inlineHtml%>" />
                                                <jsp:param name="initialJs" value="<%=inlineJs%>" />
                                                <jsp:param name="defaultTab" value="html" />
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
                                                    <strong>Avoid Inline Handlers:</strong> Mixing JavaScript with HTML
                                                    makes code harder to maintain. It's better to separate your logic.
                                                </div>
                                            </div>

                                            <h2>DOM Event Properties</h2>
                                            <p>
                                                A better way is to assign a function to the event property of a DOM
                                                element in JavaScript.
                                            </p>

                                            <% String
                                                propHtml="<h2>DOM Property Demo</h2>\n<button id='myBtn'>Hover over me</button>\n<p id='status'>Status: Waiting...</p>"
                                                ; String
                                                propJs="const btn = document.getElementById('myBtn');\nconst status = document.getElementById('status');\n\nbtn.onmouseover = function() {\n  status.innerHTML = 'Status: Mouse Over!';\n  status.style.color = 'green';\n};\n\nbtn.onmouseout = function() {\n  status.innerHTML = 'Status: Mouse Out!';\n  status.style.color = 'red';\n};"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-prop" />
                                                    <jsp:param name="initialHtml" value="<%=propHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=propJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Common Events</h2>
                                                <p>Here are some examples of common events you'll use often.</p>

                                                <h3>onchange</h3>
                                                <p>Fires when the value of an input element changes (often used with
                                                    select menus or text inputs).</p>

                                                <% String
                                                    changeHtml="<h2>OnChange Demo</h2>\n<input type='text' id='fname' placeholder='Type name and click outside'>\n<p>Transform to uppercase on change.</p>"
                                                    ; String
                                                    changeJs="const input = document.getElementById('fname');\n\ninput.onchange = function() {\n  this.value = this.value.toUpperCase();\n};"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-change" />
                                                        <jsp:param name="initialHtml" value="<%=changeHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=changeJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Events allow JavaScript to react to user interactions.
                                                            </li>
                                                            <li>Common events include click, mouseover, keydown, change,
                                                                and load.</li>
                                                            <li>Avoid inline event handlers (<code>onclick="..."</code>)
                                                                in HTML.</li>
                                                            <li>Use DOM properties (<code>element.onclick = func</code>)
                                                                for cleaner code.</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-events" />
                                                        <jsp:param name="question"
                                                            value="Which event occurs when the user clicks on an HTML element?" />
                                                        <jsp:param name="option1" value="onchange" />
                                                        <jsp:param name="option2" value="onclick" />
                                                        <jsp:param name="option3" value="onmouseclick" />
                                                        <jsp:param name="option4" value="onmouseover" />
                                                        <jsp:param name="correctAnswer" value="2" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="dom-create.jsp" />
                                                        <jsp:param name="prevTitle" value="Creating Elements" />
                                                        <jsp:param name="nextLink" value="event-listeners.jsp" />
                                                        <jsp:param name="nextTitle" value="Event Listeners" />
                                                        <jsp:param name="currentLessonId" value="events" />
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