<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Numbers & Math Lesson 8: Number methods, Math object, and random numbers --%>
        <% request.setAttribute("currentLesson", "numbers-math" ); request.setAttribute("currentModule", "Fundamentals"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Numbers & Math | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript Numbers, Number methods, and the Math object for performing mathematical operations.">
                <meta name="keywords" content="JavaScript numbers, Math object, random numbers, number methods">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Numbers & Math">
                <meta property="og:description" content="Master JavaScript numbers and math operations">
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

            <body class="tutorial-body" data-lesson="numbers-math">
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
                                        <span>Numbers & Math</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Numbers & Math</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~12 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>JavaScript Numbers</h2>
                                        <p>
                                            JavaScript has only one type of number. Numbers can be written with or
                                            without decimals.
                                        </p>

                                        <% String numberHtml="<h2>Number Demo</h2>\n<p id='demo'></p>" ; String
                                            numberJs="let x = 3.14;    // A number with decimals\nlet y = 3;       // A number without decimals\nlet z = 123e5;   // Scientific notation (12300000)\n\nlet output = `\n  x: ${x}<br>\n  y: ${y}<br>\n  z: ${z}\n`;\n\ndocument.getElementById('demo').innerHTML = output;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-number" />
                                                <jsp:param name="initialHtml" value="<%=numberHtml%>" />
                                                <jsp:param name="initialJs" value="<%=numberJs%>" />
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
                                                    <strong>Floating Point Precision:</strong> Floating point arithmetic
                                                    is not always 100% accurate. <br>
                                                    <code>0.1 + 0.2 === 0.30000000000000004</code>
                                                </div>
                                            </div>

                                            <h2>Number Methods</h2>
                                            <p>
                                                Useful methods for working with numbers:
                                            </p>

                                            <% String methodsHtml="<h2>Number Methods Demo</h2>\n<p id='methods'></p>" ;
                                                String
                                                methodsJs="let num = 9.656;\nlet output = '';\n\n// toFixed() returns a string with specified decimals\noutput += `toFixed(0): ${num.toFixed(0)}<br>`;\noutput += `toFixed(2): ${num.toFixed(2)}<br>`;\n\n// toPrecision() returns a string with specified length\noutput += `toPrecision(2): ${num.toPrecision(2)}<br>`;\n\n// Converting variables to numbers\noutput += `Number('10'): ${Number('10')}<br>`;\noutput += `parseInt('10.33'): ${parseInt('10.33')}<br>`;\noutput += `parseFloat('10.33'): ${parseFloat('10.33')}<br>`;\n\ndocument.getElementById('methods').innerHTML = output;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-methods" />
                                                    <jsp:param name="initialHtml" value="<%=methodsHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=methodsJs%>" />
                                                </jsp:include>

                                                <h2>The Math Object</h2>
                                                <p>
                                                    The JavaScript <code>Math</code> object allows you to perform
                                                    mathematical tasks on numbers.
                                                </p>

                                                <% String mathHtml="<h2>Math Object Demo</h2>\n<p id='math'></p>" ;
                                                    String
                                                    mathJs="let output = '';\n\noutput += `Math.PI: ${Math.PI}<br>`;\noutput += `Math.round(4.7): ${Math.round(4.7)}<br>`;\noutput += `Math.ceil(4.4): ${Math.ceil(4.4)} (Round up)<br>`;\noutput += `Math.floor(4.7): ${Math.floor(4.7)} (Round down)<br>`;\noutput += `Math.sqrt(64): ${Math.sqrt(64)}<br>`;\noutput += `Math.abs(-4.7): ${Math.abs(-4.7)}<br>`;\noutput += `Math.min(0, 150, 30, 20, -8): ${Math.min(0, 150, 30, 20, -8)}<br>`;\noutput += `Math.max(0, 150, 30, 20, -8): ${Math.max(0, 150, 30, 20, -8)}<br>`;\n\ndocument.getElementById('math').innerHTML = output;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-math" />
                                                        <jsp:param name="initialHtml" value="<%=mathHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=mathJs%>" />
                                                    </jsp:include>

                                                    <h2>Random Numbers</h2>
                                                    <p>
                                                        <code>Math.random()</code> returns a random number between 0
                                                        (inclusive) and 1 (exclusive).
                                                    </p>

                                                    <% String
                                                        randomHtml="<h2>Random Demo</h2>\n<button id='btn'>Generate Random Number</button>\n<p id='random'></p>"
                                                        ; String
                                                        randomJs="document.getElementById('btn').addEventListener('click', function() {\n  // Random number between 0 and 1\n  let r1 = Math.random();\n  \n  // Random integer between 0 and 9\n  let r2 = Math.floor(Math.random() * 10);\n  \n  // Random integer between 1 and 100\n  let r3 = Math.floor(Math.random() * 100) + 1;\n  \n  document.getElementById('random').innerHTML = `\n    Random (0-1): ${r1.toFixed(4)}<br>\n    Random (0-9): ${r2}<br>\n    Random (1-100): ${r3}\n  `;\n});"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-random" />
                                                            <jsp:param name="initialHtml" value="<%=randomHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=randomJs%>" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li>JavaScript numbers are always 64-bit floating point.
                                                                </li>
                                                                <li>Integers are accurate up to 15 digits.</li>
                                                                <li>Use <code>Math.round()</code>,
                                                                    <code>Math.ceil()</code>, and
                                                                    <code>Math.floor()</code> to round numbers.
                                                                </li>
                                                                <li><code>Math.random()</code> generates random numbers.
                                                                </li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-math" />
                                                            <jsp:param name="question"
                                                                value="Which method rounds a number DOWN to the nearest integer?" />
                                                            <jsp:param name="option1" value="Math.round()" />
                                                            <jsp:param name="option2" value="Math.ceil()" />
                                                            <jsp:param name="option3" value="Math.floor()" />
                                                            <jsp:param name="option4" value="Math.down()" />
                                                            <jsp:param name="correctAnswer" value="3" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="strings.jsp" />
                                                            <jsp:param name="prevTitle" value="Strings" />
                                                            <jsp:param name="nextLink" value="conditionals.jsp" />
                                                            <jsp:param name="nextTitle" value="Home" />
                                                            <jsp:param name="currentLessonId" value="numbers-math" />
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