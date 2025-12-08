<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Data Types Lesson 5: Primitive and Object types --%>
        <% request.setAttribute("currentLesson", "data-types" ); request.setAttribute("currentModule", "Fundamentals" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Data Types | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about JavaScript data types: String, Number, Boolean, Undefined, Null, Symbol, and Objects.">
                <meta name="keywords" content="JavaScript data types, primitives, objects, typeof">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Data Types">
                <meta property="og:description" content="Master JavaScript primitive and object types">
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

            <body class="tutorial-body" data-lesson="data-types">
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
                                        <span>Data Types</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Data Types</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~12 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Dynamic Typing</h2>
                                        <p>
                                            JavaScript is a <strong>dynamically typed</strong> language. This means you
                                            don't have to specify the data type of a variable when you declare it, and
                                            data types are converted automatically as needed during script execution.
                                        </p>

                                        <% String dynamicHtml="<h2>Dynamic Typing Demo</h2>\n<p id='output'></p>" ;
                                            String
                                            dynamicJs="let x;           // Now x is undefined\nlet output = 'x is undefined<br>';\n\nx = 5;           // Now x is a Number\noutput += `x is now a Number: ${x}<br>`;\n\nx = 'John';      // Now x is a String\noutput += `x is now a String: ${x}`;\n\ndocument.getElementById('output').innerHTML = output;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-dynamic" />
                                                <jsp:param name="initialHtml" value="<%=dynamicHtml%>" />
                                                <jsp:param name="initialJs" value="<%=dynamicJs%>" />
                                            </jsp:include>

                                            <h2>Primitive Data Types</h2>
                                            <p>JavaScript has 7 primitive data types:</p>

                                            <div class="card" style="margin: var(--space-6) 0;">
                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                    <li><strong>String</strong>: Text data, e.g., <code>"Hello"</code>
                                                    </li>
                                                    <li><strong>Number</strong>: Integer or floating-point, e.g.,
                                                        <code>42</code>, <code>3.14</code></li>
                                                    <li><strong>BigInt</strong>: Integers with arbitrary precision</li>
                                                    <li><strong>Boolean</strong>: <code>true</code> or
                                                        <code>false</code></li>
                                                    <li><strong>Undefined</strong>: A variable that has not been
                                                        assigned a value</li>
                                                    <li><strong>Null</strong>: Intentional absence of any object value
                                                    </li>
                                                    <li><strong>Symbol</strong>: Unique and immutable primitive</li>
                                                </ul>
                                            </div>

                                            <h3>The <code>typeof</code> Operator</h3>
                                            <p>You can use the <code>typeof</code> operator to find the data type of a
                                                JavaScript variable.</p>

                                            <% String typeofHtml="<h2>Typeof Demo</h2>\n<p id='types'></p>" ; String
                                                typeofJs="const types = [\n  'John',                // String\n  3.14,                  // Number\n  true,                  // Boolean\n  {firstName:'John'},    // Object\n  [1, 2, 3],             // Object (Array)\n  undefined,             // Undefined\n  null                   // Object (Bug in JS)\n];\n\nlet html = '';\n\ntypes.forEach(val => {\n  html += `Value: <strong>${val}</strong>, Type: <code>${typeof val}</code><br>`;\n});\n\ndocument.getElementById('types').innerHTML = html;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-typeof" />
                                                    <jsp:param name="initialHtml" value="<%=typeofHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=typeofJs%>" />
                                                </jsp:include>

                                                <h2>Objects</h2>
                                                <p>
                                                    Objects are collections of key-value pairs. They are the most
                                                    important data type in JavaScript.
                                                </p>

                                                <% String objectHtml="<h2>Object Demo</h2>\n<p id='person'></p>" ;
                                                    String
                                                    objectJs="const person = {\n  firstName: 'John',\n  lastName: 'Doe',\n  age: 50,\n  eyeColor: 'blue'\n};\n\nconst output = document.getElementById('person');\noutput.innerHTML = `\n  Name: ${person.firstName} ${person.lastName}<br>\n  Age: ${person.age}<br>\n  Eye Color: ${person.eyeColor}\n`;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-object" />
                                                        <jsp:param name="initialHtml" value="<%=objectHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=objectJs%>" />
                                                    </jsp:include>

                                                    <h2>Arrays</h2>
                                                    <p>
                                                        Arrays are a special type of object used to store multiple
                                                        values in a single variable.
                                                    </p>
                                                    <pre
                                                        class="code-example-sm"><code>const cars = ["Saab", "Volvo", "BMW"];</code></pre>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>JavaScript variables can hold many data types: numbers,
                                                                strings, objects and more.</li>
                                                            <li>JavaScript has dynamic types.</li>
                                                            <li>Strings are written with quotes.</li>
                                                            <li>Numbers are written with or without decimals.</li>
                                                            <li>Booleans can only have two values: <code>true</code> or
                                                                <code>false</code>.</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-datatypes" />
                                                        <jsp:param name="question"
                                                            value="What is the data type of the value 'Hello'?" />
                                                        <jsp:param name="option1" value="Number" />
                                                        <jsp:param name="option2" value="Boolean" />
                                                        <jsp:param name="option3" value="String" />
                                                        <jsp:param name="option4" value="Object" />
                                                        <jsp:param name="correctAnswer" value="3" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="variables.jsp" />
                                                        <jsp:param name="prevTitle" value="Variables" />
                                                        <jsp:param name="nextLink" value="operators.jsp" />
                                                        <jsp:param name="nextTitle" value="Operators" />
                                                        <jsp:param name="currentLessonId" value="data-types" />
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