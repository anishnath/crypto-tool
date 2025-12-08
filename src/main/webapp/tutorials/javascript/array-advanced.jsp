<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Advanced Array Methods Lesson 30: find, findIndex, some, every, flat, flatMap --%>
        <% request.setAttribute("currentLesson", "array-advanced" );
            request.setAttribute("currentModule", "Modern JavaScript" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Advanced Array Methods | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master advanced JavaScript array methods: find, findIndex, some, every, flat, and flatMap.">
                <meta name="keywords"
                    content="JavaScript array methods, array find, array some, array every, array flat">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Advanced Array Methods">
                <meta property="og:description" content="Master Advanced JavaScript Array Methods">
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

            <body class="tutorial-body" data-lesson="array-advanced">
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
                                        <span>Advanced Arrays</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Advanced Array Methods</h1>
                                        <div class="lesson-meta">
                                            <span>Modern</span>
                                            <span>~20 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Searching Arrays</h2>
                                        <p>
                                            Beyond <code>indexOf</code>, modern JavaScript offers powerful search
                                            methods.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><code>find()</code>: Returns the value of the first element that
                                                    passes a test.</li>
                                                <li><code>findIndex()</code>: Returns the index of the first element
                                                    that passes a test.</li>
                                            </ul>
                                        </div>

                                        <% String findHtml="<h2>Find Demo</h2>\n<p id='findOutput'></p>" ; String
                                            findJs="const ages = [3, 10, 18, 20];\n\nfunction checkAge(age) {\n  return age > 18;\n}\n\nconst found = ages.find(checkAge);\nconst foundIndex = ages.findIndex(checkAge);\n\ndocument.getElementById('findOutput').innerHTML = \n  `First adult age: ${found} at index ${foundIndex}`;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-find" />
                                                <jsp:param name="initialHtml" value="<%=findHtml%>" />
                                                <jsp:param name="initialJs" value="<%=findJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Testing Arrays</h2>
                                            <p>
                                                You can check if elements in an array pass a test.
                                            </p>
                                            <div class="card" style="margin: var(--space-6) 0;">
                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                    <li><code>some()</code>: Checks if at least one element passes a
                                                        test.</li>
                                                    <li><code>every()</code>: Checks if all elements pass a test.</li>
                                                </ul>
                                            </div>

                                            <% String testHtml="<h2>Some/Every Demo</h2>\n<p id='testOutput'></p>" ;
                                                String
                                                testJs="const ages = [32, 33, 16, 40];\n\nfunction checkAdult(age) {\n  return age >= 18;\n}\n\nconst someAdults = ages.some(checkAdult);\nconst allAdults = ages.every(checkAdult);\n\ndocument.getElementById('testOutput').innerHTML = \n  `Some are adults? ${someAdults}<br>All are adults? ${allAdults}`;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-test" />
                                                    <jsp:param name="initialHtml" value="<%=testHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=testJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Flattening Arrays</h2>
                                                <p>
                                                    The <code>flat()</code> method creates a new array with all
                                                    sub-array elements concatenated into it recursively up to the
                                                    specified depth.
                                                </p>

                                                <% String flatHtml="<h2>Flat Demo</h2>\n<p id='flatOutput'></p>" ;
                                                    String
                                                    flatJs="const myArr = [[1,2],[3,4],[5,6]];\nconst newArr = myArr.flat();\n\ndocument.getElementById('flatOutput').innerHTML = newArr;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-flat" />
                                                        <jsp:param name="initialHtml" value="<%=flatHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=flatJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>FlatMap</h2>
                                                    <p>
                                                        The <code>flatMap()</code> method first maps each element using
                                                        a mapping function, then flattens the result into a new array.
                                                        It is identical to a map followed by a flat of depth 1.
                                                    </p>

                                                    <% String
                                                        flatMapHtml="<h2>FlatMap Demo</h2>\n<p id='flatMapOutput'></p>"
                                                        ; String
                                                        flatMapJs="const myArr = [1, 2, 3, 4, 5, 6];\nconst newArr = myArr.flatMap((x) => x * 10);\n\ndocument.getElementById('flatMapOutput').innerHTML = newArr;"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-flatMap" />
                                                            <jsp:param name="initialHtml" value="<%=flatMapHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=flatMapJs%>" />
                                                            <jsp:param name="defaultTab" value="js" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li>Use <code>find()</code> to get a single element
                                                                    based on a condition.</li>
                                                                <li>Use <code>some()</code> and <code>every()</code> for
                                                                    boolean checks.</li>
                                                                <li>Use <code>flat()</code> to flatten nested arrays.
                                                                </li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-array-adv" />
                                                            <jsp:param name="question"
                                                                value="Which method checks if ALL elements in an array pass a test?" />
                                                            <jsp:param name="option1" value="some()" />
                                                            <jsp:param name="option2" value="checkAll()" />
                                                            <jsp:param name="option3" value="every()" />
                                                            <jsp:param name="option4" value="all()" />
                                                            <jsp:param name="correctAnswer" value="3" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="destructuring.jsp" />
                                                            <jsp:param name="prevTitle" value="Destructuring" />
                                                            <jsp:param name="nextLink" value="string-advanced.jsp" />
                                                            <jsp:param name="nextTitle" value="Advanced Strings" />
                                                            <jsp:param name="currentLessonId" value="array-advanced" />
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