<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Event Listeners Lesson 21: addEventListener, removeEventListener, Event Object, Bubbling
        vs Capturing --%>
        <% request.setAttribute("currentLesson", "event-listeners" );
            request.setAttribute("currentModule", "DOM Manipulation" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Event Listeners | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to use addEventListener and removeEventListener in JavaScript. Understand the Event object and event propagation.">
                <meta name="keywords"
                    content="JavaScript addEventListener, removeEventListener, event object, event bubbling, event capturing">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Event Listeners">
                <meta property="og:description" content="Master JavaScript event listeners">
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

            <body class="tutorial-body" data-lesson="event-listeners">
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
                                        <span>Event Listeners</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Event Listeners</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~20 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>The addEventListener() Method</h2>
                                        <p>
                                            The <code>addEventListener()</code> method attaches an event handler to an
                                            element without overwriting existing event handlers.
                                        </p>
                                        <pre
                                            class="code-example-sm"><code>element.addEventListener(event, function, useCapture);</code></pre>

                                        <% String
                                            listenerHtml="<h2>Listener Demo</h2>\n<button id='myBtn'>Click Me</button>\n<p id='demo'></p>"
                                            ; String
                                            listenerJs="const btn = document.getElementById('myBtn');\n\n// Add first listener\nbtn.addEventListener('click', function() {\n  document.getElementById('demo').innerHTML += 'Hello World!<br>';\n});\n\n// Add second listener (both will run)\nbtn.addEventListener('click', function() {\n  this.style.backgroundColor = 'var(--primary)';\n  this.style.color = 'white';\n});"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-listener" />
                                                <jsp:param name="initialHtml" value="<%=listenerHtml%>" />
                                                <jsp:param name="initialJs" value="<%=listenerJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>The Event Object</h2>
                                            <p>
                                                When an event occurs, the browser creates an <strong>event
                                                    object</strong>, puts details into it, and passes it as an argument
                                                to the handler.
                                            </p>

                                            <% String
                                                eventObjHtml="<h2>Event Object Demo</h2>\n<button id='evtBtn'>Click Me</button>\n<p id='evtOutput'></p>"
                                                ; String
                                                eventObjJs="document.getElementById('evtBtn').addEventListener('click', function(event) {\n  const output = `\n    Event Type: ${event.type}<br>\n    Target Element: ${event.target.tagName}<br>\n    Client X/Y: ${event.clientX}, ${event.clientY}\n  `;\n  document.getElementById('evtOutput').innerHTML = output;\n});"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-obj" />
                                                    <jsp:param name="initialHtml" value="<%=eventObjHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=eventObjJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Event Bubbling vs Capturing</h2>
                                                <p>
                                                    There are two ways of event propagation in the HTML DOM:
                                                    <strong>bubbling</strong> and <strong>capturing</strong>.
                                                </p>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <ul style="margin: 0; padding-left: var(--space-6);">
                                                        <li><strong>Bubbling (Default):</strong> The inner element's
                                                            event is handled first, then the outer.</li>
                                                        <li><strong>Capturing:</strong> The outer element's event is
                                                            handled first, then the inner.</li>
                                                    </ul>
                                                </div>

                                                <% String
                                                    propHtml="<h2>Propagation Demo</h2>\n<div id='div1' style='padding: 20px; border: 1px solid red; background: rgba(255,0,0,0.1);'>\n  Div 1 (Outer)\n  <div id='div2' style='padding: 20px; border: 1px solid blue; background: rgba(0,0,255,0.1);'>\n    Div 2 (Inner)\n  </div>\n</div>\n<p id='log'></p>"
                                                    ; String
                                                    propJs="function log(msg) {\n  document.getElementById('log').innerHTML += msg + '<br>';\n}\n\n// Bubbling (default, 3rd arg is false)\ndocument.getElementById('div1').addEventListener('click', function() {\n  log('Div 1 Clicked (Bubbling)');\n}, false);\n\ndocument.getElementById('div2').addEventListener('click', function(e) {\n  log('Div 2 Clicked (Bubbling)');\n  // e.stopPropagation(); // Uncomment to stop bubbling\n}, false);"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-prop" />
                                                        <jsp:param name="initialHtml" value="<%=propHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=propJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Removing Listeners</h2>
                                                    <p>
                                                        The <code>removeEventListener()</code> method removes event
                                                        handlers that have been attached with the addEventListener()
                                                        method.
                                                    </p>
                                                    <p>
                                                        <strong>Note:</strong> To remove a handler, the handler function
                                                        must be a named function (not an anonymous function).
                                                    </p>

                                                    <% String
                                                        removeHtml="<h2>Remove Listener Demo</h2>\n<div id='hoverBox' style='width: 100px; height: 100px; background: #ccc;'>Hover me</div>\n<br>\n<button onclick='removeHandler()'>Remove Hover Effect</button>"
                                                        ; String
                                                        removeJs="const box = document.getElementById('hoverBox');\n\nfunction randomColor() {\n  box.style.backgroundColor = '#' + Math.floor(Math.random()*16777215).toString(16);\n}\n\n// Add listener\nbox.addEventListener('mousemove', randomColor);\n\nfunction removeHandler() {\n  box.removeEventListener('mousemove', randomColor);\n  box.style.backgroundColor = '#ccc';\n  box.innerText = 'Removed';\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-remove" />
                                                            <jsp:param name="initialHtml" value="<%=removeHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=removeJs%>" />
                                                            <jsp:param name="defaultTab" value="js" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li>Use <code>addEventListener</code> to attach multiple
                                                                    handlers to an element.</li>
                                                                <li>The <code>event</code> object contains information
                                                                    about the event.</li>
                                                                <li>Event bubbling handles inner elements first;
                                                                    capturing handles outer elements first.</li>
                                                                <li>Use <code>removeEventListener</code> to clean up
                                                                    event handlers.</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-listeners" />
                                                            <jsp:param name="question"
                                                                value="Which method stops the event from bubbling up the DOM tree?" />
                                                            <jsp:param name="option1" value="event.stop()" />
                                                            <jsp:param name="option2" value="event.preventDefault()" />
                                                            <jsp:param name="option3" value="event.stopPropagation()" />
                                                            <jsp:param name="option4" value="event.cancelBubble()" />
                                                            <jsp:param name="correctAnswer" value="3" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="events.jsp" />
                                                            <jsp:param name="prevTitle" value="Events" />
                                                            <jsp:param name="nextLink" value="this-keyword.jsp" />
                                                            <jsp:param name="nextTitle"
                                                                value="Next Module: Advanced Concepts" />
                                                            <jsp:param name="currentLessonId" value="event-listeners" />
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