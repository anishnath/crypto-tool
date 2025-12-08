<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Advanced String Methods Lesson 31: includes, startsWith, endsWith, padStart, padEnd,
        repeat, template literals --%>
        <% request.setAttribute("currentLesson", "string-advanced" );
            request.setAttribute("currentModule", "Modern JavaScript" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Advanced String Methods | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master advanced JavaScript string methods: includes, startsWith, endsWith, padding, and template literals.">
                <meta name="keywords"
                    content="JavaScript string methods, string includes, string startsWith, string padding, template literals">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Advanced String Methods">
                <meta property="og:description" content="Master Advanced JavaScript String Methods">
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

            <body class="tutorial-body" data-lesson="string-advanced">
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
                                        <span>Advanced Strings</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Advanced String Methods</h1>
                                        <div class="lesson-meta">
                                            <span>Modern</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Searching Strings</h2>
                                        <p>
                                            Modern JavaScript provides cleaner ways to search within strings than
                                            <code>indexOf</code>.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><code>includes()</code>: Returns true if a string contains a
                                                    specified value.</li>
                                                <li><code>startsWith()</code>: Returns true if a string begins with a
                                                    specified value.</li>
                                                <li><code>endsWith()</code>: Returns true if a string ends with a
                                                    specified value.</li>
                                            </ul>
                                        </div>

                                        <% String searchHtml="<h2>Search Demo</h2>\n<p id='searchOutput'></p>" ; String
                                            searchJs="let text = 'Hello world, welcome to the universe.';\n\nlet hasWorld = text.includes('world');\nlet startsHello = text.startsWith('Hello');\nlet endsUniverse = text.endsWith('universe.');\n\ndocument.getElementById('searchOutput').innerHTML = \n  `Includes 'world'? ${hasWorld}<br>Starts with 'Hello'? ${startsHello}<br>Ends with 'universe.'? ${endsUniverse}`;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-search" />
                                                <jsp:param name="initialHtml" value="<%=searchHtml%>" />
                                                <jsp:param name="initialJs" value="<%=searchJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>String Padding</h2>
                                            <p>
                                                ES2017 added two String methods to support padding at the beginning and
                                                at the end of a string.
                                            </p>
                                            <div class="card" style="margin: var(--space-6) 0;">
                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                    <li><code>padStart()</code>: Pads a string with another string until
                                                        it reaches a given length (from the start).</li>
                                                    <li><code>padEnd()</code>: Pads a string with another string until
                                                        it reaches a given length (from the end).</li>
                                                </ul>
                                            </div>

                                            <% String padHtml="<h2>Padding Demo</h2>\n<p id='padOutput'></p>" ; String
                                                padJs="let text = '5';\nlet paddedStart = text.padStart(4, '0'); // 0005\nlet paddedEnd = text.padEnd(4, 'x');   // 5xxx\n\ndocument.getElementById('padOutput').innerHTML = \n  `Start Padded: ${paddedStart}<br>End Padded: ${paddedEnd}`;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-pad" />
                                                    <jsp:param name="initialHtml" value="<%=padHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=padJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Template Literals</h2>
                                                <p>
                                                    Template Literals use back-ticks (``) rather than quotes ("") to
                                                    define a string. They allow for:
                                                </p>
                                                <ul style="margin-bottom: var(--space-4);">
                                                    <li>Multi-line strings</li>
                                                    <li>String interpolation (variables inside strings)</li>
                                                </ul>

                                                <% String
                                                    templateHtml="<h2>Template Literal Demo</h2>\n<p id='templateOutput'></p>"
                                                    ; String
                                                    templateJs="let firstName = 'John';\nlet lastName = 'Doe';\n\nlet text = `Welcome ${firstName}, ${lastName}!`;\n\ndocument.getElementById('templateOutput').innerHTML = text;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-template" />
                                                        <jsp:param name="initialHtml" value="<%=templateHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=templateJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Use <code>includes</code>, <code>startsWith</code>,
                                                                <code>endsWith</code> for easier searching.
                                                            </li>
                                                            <li>Use <code>padStart</code> and <code>padEnd</code> for
                                                                formatting strings.</li>
                                                            <li>Use Template Literals for cleaner string construction.
                                                            </li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-string-adv" />
                                                        <jsp:param name="question"
                                                            value="Which method pads a string from the beginning?" />
                                                        <jsp:param name="option1" value="padLeft()" />
                                                        <jsp:param name="option2" value="padBegin()" />
                                                        <jsp:param name="option3" value="padStart()" />
                                                        <jsp:param name="option4" value="padFront()" />
                                                        <jsp:param name="correctAnswer" value="3" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="array-advanced.jsp" />
                                                        <jsp:param name="prevTitle" value="Advanced Arrays" />
                                                        <jsp:param name="nextLink" value="error-handling.jsp" />
                                                        <jsp:param name="nextTitle"
                                                            value="Next Module: Practical Topics" />
                                                        <jsp:param name="currentLessonId" value="string-advanced" />
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