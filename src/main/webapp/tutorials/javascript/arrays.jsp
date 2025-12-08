<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Arrays Lesson 13: Creating arrays, accessing elements, length property --%>
        <% request.setAttribute("currentLesson", "arrays" ); request.setAttribute("currentModule", "Data Structures" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Arrays | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to create and use JavaScript Arrays. Understand array indexing, length property, and basic operations.">
                <meta name="keywords" content="JavaScript arrays, array creation, array index, array length">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Arrays">
                <meta property="og:description" content="Master JavaScript arrays">
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

            <body class="tutorial-body" data-lesson="arrays">
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
                                        <span>Arrays</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Arrays</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is an Array?</h2>
                                        <p>
                                            An array is a special variable, which can hold more than one value. It is a
                                            common data structure used to store ordered collections.
                                        </p>

                                        <% String basicHtml="<h2>Array Demo</h2>\n<p id='demo'></p>" ; String
                                            basicJs="// Creating an array\nconst cars = ['Saab', 'Volvo', 'BMW'];\n\n// Accessing elements\nlet first = cars[0];\nlet second = cars[1];\n\n// Changing an element\ncars[0] = 'Toyota';\n\ndocument.getElementById('demo').innerHTML = `\n  Original First: ${first}<br>\n  Second: ${second}<br>\n  Modified Array: ${cars}\n`;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=basicHtml%>" />
                                                <jsp:param name="initialJs" value="<%=basicJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Creating Arrays</h2>
                                            <p>
                                                The easiest way to create an array is using an array literal
                                                <code>[]</code>.
                                            </p>
                                            <pre
                                                class="code-example-sm"><code>const array_name = [item1, item2, ...];</code></pre>

                                            <div class="callout callout-tip">
                                                <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <circle cx="12" cy="12" r="10" />
                                                    <path d="M12 16v-4M12 8h.01" />
                                                </svg>
                                                <div class="callout-content">
                                                    <strong>Best Practice:</strong> Always declare arrays with
                                                    <code>const</code>. This prevents accidental reassignment of the
                                                    array variable itself (though you can still modify its elements).
                                                </div>
                                            </div>

                                            <h2>Accessing Elements</h2>
                                            <p>
                                                You access an array element by referring to the <strong>index
                                                    number</strong>.
                                            </p>
                                            <p>
                                                <strong>Note:</strong> Array indexes start with 0. <code>[0]</code> is
                                                the first element. <code>[1]</code> is the second element.
                                            </p>

                                            <h2>The Length Property</h2>
                                            <p>
                                                The <code>length</code> property of an array returns the length of an
                                                array (the number of array elements).
                                            </p>

                                            <% String lengthHtml="<h2>Length Demo</h2>\n<p id='lengthOutput'></p>" ;
                                                String
                                                lengthJs="const fruits = ['Banana', 'Orange', 'Apple', 'Mango'];\nlet len = fruits.length;\nlet last = fruits[fruits.length - 1]; // Accessing the last element\n\ndocument.getElementById('lengthOutput').innerHTML = `\n  Array: ${fruits}<br>\n  Length: ${len}<br>\n  Last Element: ${last}\n`;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-length" />
                                                    <jsp:param name="initialHtml" value="<%=lengthHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=lengthJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Looping Array Elements</h2>
                                                <p>
                                                    The safest way to loop through an array is using a <code>for</code>
                                                    loop or the <code>forEach()</code> method.
                                                </p>

                                                <% String loopHtml="<h2>Looping Demo</h2>\n<ul id='list'></ul>" ; String
                                                    loopJs="const fruits = ['Banana', 'Orange', 'Apple', 'Mango'];\nlet listItems = '';\n\n// Using forEach\nfruits.forEach((fruit, index) => {\n  listItems += `<li>${index}: ${fruit}</li>`;\n});\n\ndocument.getElementById('list').innerHTML = listItems;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-loop" />
                                                        <jsp:param name="initialHtml" value="<%=loopHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=loopJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Arrays are Objects</h2>
                                                    <p>
                                                        Arrays are a special type of objects. The <code>typeof</code>
                                                        operator in JavaScript returns "object" for arrays.
                                                    </p>
                                                    <p>
                                                        To check if a variable is an array, you can use
                                                        <code>Array.isArray()</code>.
                                                    </p>

                                                    <% String
                                                        typeHtml="<h2>Type Check Demo</h2>\n<p id='typeOutput'></p>" ;
                                                        String
                                                        typeJs="const fruits = ['Banana', 'Orange'];\nconst person = {firstName: 'John', lastName: 'Doe'};\n\nlet output = `\n  typeof fruits: ${typeof fruits}<br>\n  Array.isArray(fruits): ${Array.isArray(fruits)}<br>\n  Array.isArray(person): ${Array.isArray(person)}\n`;\n\ndocument.getElementById('typeOutput').innerHTML = output;"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-type" />
                                                            <jsp:param name="initialHtml" value="<%=typeHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=typeJs%>" />
                                                            <jsp:param name="defaultTab" value="js" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li>Arrays are used to store multiple values in a single
                                                                    variable.</li>
                                                                <li>Array indexes start at 0.</li>
                                                                <li>Use <code>const</code> to declare arrays.</li>
                                                                <li>The <code>length</code> property returns the number
                                                                    of elements.</li>
                                                                <li>Use <code>Array.isArray()</code> to check if a
                                                                    variable is an array.</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-arrays" />
                                                            <jsp:param name="question"
                                                                value="If an array has 5 elements, what is the index of the last element?" />
                                                            <jsp:param name="option1" value="5" />
                                                            <jsp:param name="option2" value="4" />
                                                            <jsp:param name="option3" value="0" />
                                                            <jsp:param name="option4" value="-1" />
                                                            <jsp:param name="correctAnswer" value="2" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="scope-closures.jsp" />
                                                            <jsp:param name="prevTitle" value="Scope & Closures" />
                                                            <jsp:param name="nextLink" value="array-methods.jsp" />
                                                            <jsp:param name="nextTitle" value="Array Methods" />
                                                            <jsp:param name="currentLessonId" value="arrays" />
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