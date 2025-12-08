<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Scope & Closures Lesson 12: Global, Function, Block Scope, and Closures --%>
        <% request.setAttribute("currentLesson", "scope-closures" );
            request.setAttribute("currentModule", "Control Flow" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Scope & Closures | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript scope (Global, Function, Block) and Closures. Understand how variable accessibility works.">
                <meta name="keywords" content="JavaScript scope, closures, global scope, function scope, block scope">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Scope & Closures">
                <meta property="og:description" content="Master JavaScript scope and closures">
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

            <body class="tutorial-body" data-lesson="scope-closures">
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
                                        <span>Scope & Closures</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Scope & Closures</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~20 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is Scope?</h2>
                                        <p>
                                            Scope determines the accessibility (visibility) of variables. JavaScript has
                                            3 types of scope:
                                        </p>
                                        <ul style="margin-bottom: var(--space-4);">
                                            <li><strong>Block scope</strong> (let, const)</li>
                                            <li><strong>Function scope</strong> (var, let, const)</li>
                                            <li><strong>Global scope</strong></li>
                                        </ul>

                                        <% String scopeHtml="<h2>Scope Demo</h2>\n<p id='scopeOutput'></p>" ; String
                                            scopeJs="// Global Scope\nlet globalVar = 'I am global';\n\nfunction myFunction() {\n  // Function Scope\n  let functionVar = 'I am local to function';\n  \n  if (true) {\n    // Block Scope\n    let blockVar = 'I am local to block';\n    var varVariable = 'I ignore block scope (var)';\n  }\n  \n  // console.log(blockVar); // Error: blockVar is not defined\n  \n  return `\n    Global: ${globalVar}<br>\n    Function: ${functionVar}<br>\n    Var (leaked): ${varVariable}\n  `;\n}\n\ndocument.getElementById('scopeOutput').innerHTML = myFunction();"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-scope" />
                                                <jsp:param name="initialHtml" value="<%=scopeHtml%>" />
                                                <jsp:param name="initialJs" value="<%=scopeJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Closures</h2>
                                            <p>
                                                A <strong>closure</strong> is a function having access to the parent
                                                scope, even after the parent function has closed.
                                            </p>

                                            <% String
                                                closureHtml="<h2>Closure Demo</h2>\n<button id='btn'>Count!</button>\n<p id='countOutput'>Count: 0</p>"
                                                ; String
                                                closureJs="const add = (function () {\n  let counter = 0;\n  return function () {\n    counter += 1;\n    return counter;\n  }\n})();\n\ndocument.getElementById('btn').addEventListener('click', function() {\n  document.getElementById('countOutput').innerHTML = `Count: ${add()}`;\n});"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-closure" />
                                                    <jsp:param name="initialHtml" value="<%=closureHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=closureJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <div class="callout callout-tip">
                                                    <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10" />
                                                        <path d="M12 16v-4M12 8h.01" />
                                                    </svg>
                                                    <div class="callout-content">
                                                        <strong>Why Closures?</strong> Closures make it possible for a
                                                        function to have "private" variables. The counter is protected
                                                        by the scope of the anonymous function, and can only be changed
                                                        using the <code>add</code> function.
                                                    </div>
                                                </div>

                                                <h2>Hoisting</h2>
                                                <p>
                                                    Hoisting is JavaScript's default behavior of moving declarations to
                                                    the top.
                                                </p>
                                                <pre class="code-example-sm"><code>x = 5; // Assign 5 to x
var x; // Declare x
// This works because of hoisting</code></pre>

                                                <div class="callout callout-warning">
                                                    <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path
                                                            d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                                                        <line x1="12" y1="9" x2="12" y2="13" />
                                                        <line x1="12" y1="17" x2="12.01" y2="17" />
                                                    </svg>
                                                    <div class="callout-content">
                                                        <strong>Let and Const are not hoisted</strong> in the same way.
                                                        Using a <code>let</code> variable before it is declared will
                                                        result in a ReferenceError.
                                                    </div>
                                                </div>

                                                <h2>Summary</h2>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <ul style="margin: 0; padding-left: var(--space-6);">
                                                        <li>Variables declared with <code>var</code> have function
                                                            scope.</li>
                                                        <li>Variables declared with <code>let</code> and
                                                            <code>const</code> have block scope.</li>
                                                        <li>Closures allow functions to access variables from an
                                                            enclosing scope even after it has finished executing.</li>
                                                        <li>Hoisting moves declarations to the top of the current scope.
                                                        </li>
                                                    </ul>
                                                </div>

                                                <jsp:include page="../tutorial-quiz.jsp">
                                                    <jsp:param name="quizId" value="quiz-scope" />
                                                    <jsp:param name="question"
                                                        value="Which keyword creates a block-scoped variable?" />
                                                    <jsp:param name="option1" value="var" />
                                                    <jsp:param name="option2" value="let" />
                                                    <jsp:param name="option3" value="global" />
                                                    <jsp:param name="option4" value="function" />
                                                    <jsp:param name="correctAnswer" value="2" />
                                                </jsp:include>

                                                <jsp:include page="../tutorial-nav.jsp">
                                                    <jsp:param name="prevLink" value="functions.jsp" />
                                                    <jsp:param name="prevTitle" value="Functions" />
                                                    <jsp:param name="nextLink" value="arrays.jsp" />
                                                    <jsp:param name="nextTitle" value="Arrays" />
                                                    <jsp:param name="currentLessonId" value="scope-closures" />
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