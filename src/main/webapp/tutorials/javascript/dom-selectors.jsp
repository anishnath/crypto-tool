<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Selecting Elements Lesson 17: getElementById, getElementsByClassName, querySelector,
        querySelectorAll --%>
        <% request.setAttribute("currentLesson", "dom-selectors" );
            request.setAttribute("currentModule", "DOM Manipulation" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript DOM Selectors | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to select HTML elements using JavaScript: getElementById, querySelector, querySelectorAll, and more.">
                <meta name="keywords"
                    content="JavaScript DOM, getElementById, querySelector, getElementsByClassName, DOM selectors">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript DOM Selectors">
                <meta property="og:description" content="Master selecting elements in the DOM">
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

            <body class="tutorial-body" data-lesson="dom-selectors">
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
                                        <span>Selecting Elements</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Selecting Elements</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>The Document Object Model (DOM)</h2>
                                        <p>
                                            The DOM is a tree-like representation of your HTML document. JavaScript uses
                                            the DOM to access and manipulate HTML elements.
                                        </p>

                                        <h2>Selecting by ID</h2>
                                        <p>
                                            The most common way to access an HTML element is to use the <code>id</code>
                                            of the element.
                                        </p>
                                        <pre class="code-example-sm"><code>document.getElementById("myId");</code></pre>

                                        <% String
                                            idHtml="<h2>ID Selector Demo</h2>\n<p id='demo'>Hello World!</p>\n<button onclick='changeText()'>Change Text</button>"
                                            ; String
                                            idJs="function changeText() {\n  const element = document.getElementById('demo');\n  element.innerHTML = 'Hello JavaScript!';\n  element.style.color = 'var(--primary)';\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-id" />
                                                <jsp:param name="initialHtml" value="<%=idHtml%>" />
                                                <jsp:param name="initialJs" value="<%=idJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Selecting by Class Name</h2>
                                            <p>
                                                You can find all elements with the same class name using
                                                <code>getElementsByClassName</code>. This returns an HTMLCollection
                                                (array-like object).
                                            </p>

                                            <% String
                                                classHtml="<h2>Class Selector Demo</h2>\n<p class='intro'>Paragraph 1</p>\n<p class='intro'>Paragraph 2</p>\n<button onclick='highlight()'>Highlight All</button>"
                                                ; String
                                                classJs="function highlight() {\n  const elements = document.getElementsByClassName('intro');\n  \n  // Loop through the collection\n  for (let i = 0; i < elements.length; i++) {\n    elements[i].style.backgroundColor = 'rgba(255, 255, 0, 0.3)';\n  }\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-class" />
                                                    <jsp:param name="initialHtml" value="<%=classHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=classJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Query Selectors</h2>
                                                <p>
                                                    The <code>querySelector()</code> and <code>querySelectorAll()</code>
                                                    methods allow you to use CSS selectors to find elements. This is
                                                    very powerful and flexible.
                                                </p>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <ul style="margin: 0; padding-left: var(--space-6);">
                                                        <li><code>querySelector(selector)</code>: Returns the
                                                            <strong>first</strong> matching element.</li>
                                                        <li><code>querySelectorAll(selector)</code>: Returns a
                                                            <strong>NodeList</strong> of all matching elements.</li>
                                                    </ul>
                                                </div>

                                                <% String
                                                    queryHtml="<h2>Query Selector Demo</h2>\n<div class='container'>\n  <p>First Paragraph</p>\n  <p class='highlight'>Second Paragraph (highlight)</p>\n  <p>Third Paragraph</p>\n</div>\n<button onclick='styleQuery()'>Style Elements</button>"
                                                    ; String
                                                    queryJs="function styleQuery() {\n  // Select first p in container\n  const first = document.querySelector('.container p');\n  first.style.fontWeight = 'bold';\n  \n  // Select all p elements\n  const all = document.querySelectorAll('p');\n  all.forEach(p => {\n    p.style.border = '1px solid var(--border-color)';\n    p.style.padding = '5px';\n    p.style.margin = '5px 0';\n  });\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-query" />
                                                        <jsp:param name="initialHtml" value="<%=queryHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=queryJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <div class="callout callout-tip">
                                                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="10" />
                                                            <path d="M12 16v-4M12 8h.01" />
                                                        </svg>
                                                        <div class="callout-content">
                                                            <strong>NodeList vs HTMLCollection:</strong>
                                                            <code>querySelectorAll</code> returns a NodeList, which has
                                                            a built-in <code>forEach()</code> method.
                                                            <code>getElementsByClassName</code> returns an
                                                            HTMLCollection, which does NOT have <code>forEach()</code>
                                                            (you have to use a regular for loop or convert it to an
                                                            array).
                                                        </div>
                                                    </div>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li><code>getElementById</code> is the fastest way to select
                                                                a single element.</li>
                                                            <li><code>querySelector</code> uses CSS syntax to find the
                                                                first match.</li>
                                                            <li><code>querySelectorAll</code> finds all matches and
                                                                returns a NodeList.</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-selectors" />
                                                        <jsp:param name="question"
                                                            value="Which method returns a NodeList?" />
                                                        <jsp:param name="option1" value="getElementById" />
                                                        <jsp:param name="option2" value="getElementsByClassName" />
                                                        <jsp:param name="option3" value="querySelectorAll" />
                                                        <jsp:param name="option4" value="querySelector" />
                                                        <jsp:param name="correctAnswer" value="3" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="object-methods.jsp" />
                                                        <jsp:param name="prevTitle" value="Object Methods" />
                                                        <jsp:param name="nextLink" value="dom-modify.jsp" />
                                                        <jsp:param name="nextTitle" value="Modifying Elements" />
                                                        <jsp:param name="currentLessonId" value="dom-selectors" />
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