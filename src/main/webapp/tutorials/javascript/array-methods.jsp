<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Array Methods Lesson 14: Common array methods (push, pop, shift, unshift, slice, splice,
        map, filter, reduce) --%>
        <% request.setAttribute("currentLesson", "array-methods" );
            request.setAttribute("currentModule", "Data Structures" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Array Methods | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn essential JavaScript array methods: push, pop, shift, unshift, map, filter, reduce, and more.">
                <meta name="keywords"
                    content="JavaScript array methods, push pop, map filter reduce, array manipulation">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Array Methods">
                <meta property="og:description" content="Master JavaScript array methods">
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

            <body class="tutorial-body" data-lesson="array-methods">
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
                                        <span>Array Methods</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Array Methods</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~20 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Adding and Removing Elements</h2>
                                        <p>
                                            Methods to add or remove elements from the beginning or end of an array.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><code>push()</code>: Adds element to end</li>
                                                <li><code>pop()</code>: Removes element from end</li>
                                                <li><code>unshift()</code>: Adds element to beginning</li>
                                                <li><code>shift()</code>: Removes element from beginning</li>
                                            </ul>
                                        </div>

                                        <% String basicHtml="<h2>Basic Methods Demo</h2>\n<p id='basicOutput'></p>" ;
                                            String
                                            basicJs="const fruits = ['Banana', 'Orange'];\nlet output = `Original: ${fruits}<br>`;\n\nfruits.push('Apple');\noutput += `After push('Apple'): ${fruits}<br>`;\n\nfruits.pop();\noutput += `After pop(): ${fruits}<br>`;\n\nfruits.unshift('Lemon');\noutput += `After unshift('Lemon'): ${fruits}<br>`;\n\nfruits.shift();\noutput += `After shift(): ${fruits}<br>`;\n\ndocument.getElementById('basicOutput').innerHTML = output;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=basicHtml%>" />
                                                <jsp:param name="initialJs" value="<%=basicJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Slicing and Splicing</h2>
                                            <p>
                                                <code>slice()</code> extracts a part of an array and returns a new array
                                                (does not modify original). <br>
                                                <code>splice()</code> adds/removes items to/from an array (modifies
                                                original).
                                            </p>

                                            <% String spliceHtml="<h2>Slice/Splice Demo</h2>\n<p id='spliceOutput'></p>"
                                                ; String
                                                spliceJs="const fruits = ['Banana', 'Orange', 'Apple', 'Mango'];\nlet output = `Original: ${fruits}<br>`;\n\n// Slice (non-destructive)\nconst citrus = fruits.slice(1, 3);\noutput += `Slice(1, 3): ${citrus}<br>`;\n\n// Splice (destructive)\n// Remove 1 element at index 2, add 'Lemon', 'Kiwi'\nfruits.splice(2, 1, 'Lemon', 'Kiwi');\noutput += `After Splice: ${fruits}<br>`;\n\ndocument.getElementById('spliceOutput').innerHTML = output;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-splice" />
                                                    <jsp:param name="initialHtml" value="<%=spliceHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=spliceJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>High-Order Array Methods</h2>
                                                <p>
                                                    These methods take a function as an argument and are very powerful
                                                    for data manipulation.
                                                </p>

                                                <h3>map()</h3>
                                                <p>Creates a new array by performing a function on each array element.
                                                </p>

                                                <h3>filter()</h3>
                                                <p>Creates a new array with all array elements that pass a test.</p>

                                                <h3>reduce()</h3>
                                                <p>Runs a function on each array element to produce (reduce it to) a
                                                    single value.</p>

                                                <% String
                                                    highOrderHtml="<h2>Map/Filter/Reduce Demo</h2>\n<p id='highOrderOutput'></p>"
                                                    ; String
                                                    highOrderJs="const numbers = [1, 2, 3, 4, 5];\nlet output = `Original: ${numbers}<br>`;\n\n// Map: Double each number\nconst doubled = numbers.map(num => num * 2);\noutput += `Map (*2): ${doubled}<br>`;\n\n// Filter: Keep only even numbers\nconst evens = numbers.filter(num => num % 2 === 0);\noutput += `Filter (evens): ${evens}<br>`;\n\n// Reduce: Sum all numbers\nconst sum = numbers.reduce((total, num) => total + num, 0);\noutput += `Reduce (sum): ${sum}<br>`;\n\ndocument.getElementById('highOrderOutput').innerHTML = output;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-highorder" />
                                                        <jsp:param name="initialHtml" value="<%=highOrderHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=highOrderJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li><code>push/pop</code> work on the end of the array.</li>
                                                            <li><code>unshift/shift</code> work on the beginning of the
                                                                array.</li>
                                                            <li><code>map</code> transforms every element.</li>
                                                            <li><code>filter</code> selects a subset of elements.</li>
                                                            <li><code>reduce</code> combines elements into a single
                                                                value.</li>
                                                            <li>These methods (especially map/filter/reduce) are
                                                                essential for modern JavaScript (React, Vue, etc.).</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-methods" />
                                                        <jsp:param name="question"
                                                            value="Which method creates a NEW array with the results of calling a function for every array element?" />
                                                        <jsp:param name="option1" value="forEach()" />
                                                        <jsp:param name="option2" value="map()" />
                                                        <jsp:param name="option3" value="filter()" />
                                                        <jsp:param name="option4" value="reduce()" />
                                                        <jsp:param name="correctAnswer" value="2" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="arrays.jsp" />
                                                        <jsp:param name="prevTitle" value="Arrays" />
                                                        <jsp:param name="nextLink" value="objects.jsp" />
                                                        <jsp:param name="nextTitle" value="Objects" />
                                                        <jsp:param name="currentLessonId" value="array-methods" />
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