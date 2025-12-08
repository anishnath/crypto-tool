<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Strings Lesson 7: String methods, template literals, and manipulation --%>
        <% request.setAttribute("currentLesson", "strings" ); request.setAttribute("currentModule", "Fundamentals" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Strings | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript Strings, string methods, template literals, and string manipulation techniques.">
                <meta name="keywords"
                    content="JavaScript strings, string methods, template literals, string manipulation">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Strings">
                <meta property="og:description" content="Master JavaScript string manipulation">
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

            <body class="tutorial-body" data-lesson="strings">
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
                                        <span>Strings</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Strings</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Strings?</h2>
                                        <p>
                                            Strings are used for storing and manipulating text. A JavaScript string is
                                            zero or more characters written inside quotes.
                                        </p>

                                        <%
                                            String stringHtml = "<h2>String Demo</h2>\n<p id='demo'></p>";
                                            String stringJs = "let text1 = 'John Doe';  // Single quotes\nlet text2 = \"Jane Doe\"; // Double quotes\n\n// Escaping quotes\nlet answer=\"It's alright\";\nlet quote='He said \"Hello\"';\n\ndocument.getElementById('demo').innerHTML=`\n${text1}<br>\n${text2}<br>\n${answer}<br>\n${quote}\n`;";
                                        %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-string" />
                                                <jsp:param name="initialHtml" value="<%=stringHtml%>" />
                                                <jsp:param name="initialJs" value="<%=stringJs%>" />
                                            </jsp:include>

                                            <h2>String Methods</h2>
                                            <p>
                                                JavaScript provides many useful methods to work with strings.
                                            </p>

                                            <% String methodsHtml="<h2>String Methods Demo</h2>\n<p id='methods'></p>" ;
                                                String
                                                methodsJs="let text = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';\nlet output = '';\n\n// Length property\noutput += `Length: ${text.length}<br>`;\n\n// Extracting parts\nlet str = 'Apple, Banana, Kiwi';\noutput += `Slice(7, 13): ${str.slice(7, 13)}<br>`;\noutput += `Substring(7, 13): ${str.substring(7, 13)}<br>`;\n\n// Replacing content\nlet message = 'Please visit Microsoft!';\nlet newMessage = message.replace('Microsoft', '8gwifi');\noutput += `Replace: ${newMessage}<br>`;\n\n// Converting case\nlet hello = 'Hello World!';\noutput += `UpperCase: ${hello.toUpperCase()}<br>`;\noutput += `LowerCase: ${hello.toLowerCase()}<br>`;\n\ndocument.getElementById('methods').innerHTML = output;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-methods" />
                                                    <jsp:param name="initialHtml" value="<%=methodsHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=methodsJs%>" />
                                                </jsp:include>

                                                <h2>Template Literals</h2>
                                                <p>
                                                    Template literals (introduced in ES6) use backticks (<code>`</code>)
                                                    rather than quotes to define strings. They allow for:
                                                </p>
                                                <ul style="margin-bottom: var(--space-4);">
                                                    <li>Multi-line strings</li>
                                                    <li>String interpolation (variables inside strings)</li>
                                                </ul>

                                                <% String
                                                    templateHtml="<h2>Template Literals Demo</h2>\n<p id='template'></p>"
                                                    ; String
                                                    templateJs="let firstName = 'John';\nlet lastName = 'Doe';\nlet price = 10;\nlet tax = 0.25;\n\n// Template literal with interpolation\nlet text = `Welcome ${firstName}, ${lastName}!`;\n\n// Expression evaluation\nlet total = `Total: $${(price * (1 + tax)).toFixed(2)}`;\n\n// Multi-line string\nlet html = `\n  <div style='background: var(--bg-secondary); padding: 10px; border-radius: 4px;'>\n    <h3>${text}</h3>\n    <p>${total}</p>\n  </div>\n`;\n\ndocument.getElementById('template').innerHTML = html;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-template" />
                                                        <jsp:param name="initialHtml" value="<%=templateHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=templateJs%>" />
                                                    </jsp:include>

                                                    <h2>String Search</h2>
                                                    <p>
                                                        Methods for searching strings:
                                                    </p>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li><code>indexOf()</code>: Returns the index of the first
                                                                occurrence</li>
                                                            <li><code>lastIndexOf()</code>: Returns the index of the
                                                                last occurrence</li>
                                                            <li><code>includes()</code>: Returns true if string contains
                                                                a value</li>
                                                            <li><code>startsWith()</code>: Returns true if string starts
                                                                with value</li>
                                                            <li><code>endsWith()</code>: Returns true if string ends
                                                                with value</li>
                                                        </ul>
                                                    </div>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Strings are for storing text.</li>
                                                            <li>Use single or double quotes for literals.</li>
                                                            <li>Use backticks for template literals (recommended for
                                                                dynamic strings).</li>
                                                            <li>Strings have many built-in methods like
                                                                <code>slice()</code>, <code>replace()</code>, and
                                                                <code>toUpperCase()</code>.</li>
                                                            <li>Strings are immutable (methods return new strings, they
                                                                don't change the original).</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-strings" />
                                                        <jsp:param name="question"
                                                            value="Which symbol is used for template literals?" />
                                                        <jsp:param name="option1" value="' (Single Quote)" />
                                                        <jsp:param name="option2" value="&quot; (Double Quote)" />
                                                        <jsp:param name="option3" value="` (Backtick)" />
                                                        <jsp:param name="option4" value="- (Hyphen)" />
                                                        <jsp:param name="correctAnswer" value="3" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="operators.jsp" />
                                                        <jsp:param name="prevTitle" value="Operators" />
                                                        <jsp:param name="nextLink" value="numbers-math.jsp" />
                                                        <jsp:param name="nextTitle" value="Numbers & Math" />
                                                        <jsp:param name="currentLessonId" value="strings" />
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