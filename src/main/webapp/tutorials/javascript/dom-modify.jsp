<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Modifying Elements Lesson 18: Changing content (innerHTML, textContent), styles,
        attributes, and classes --%>
        <% request.setAttribute("currentLesson", "dom-modify" );
            request.setAttribute("currentModule", "DOM Manipulation" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Modifying DOM Elements | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to modify HTML content, change CSS styles, update attributes, and manipulate classes using JavaScript.">
                <meta name="keywords"
                    content="JavaScript innerHTML, textContent, style property, classList, setAttribute">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Modifying DOM Elements">
                <meta property="og:description" content="Master modifying DOM elements with JavaScript">
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

            <body class="tutorial-body" data-lesson="dom-modify">
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
                                        <span>Modifying Elements</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Modifying Elements</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~20 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Changing HTML Content</h2>
                                        <p>
                                            The easiest way to modify the content of an HTML element is by using the
                                            <code>innerHTML</code> property.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><code>innerHTML</code>: Gets or sets the HTML content (including
                                                    tags).</li>
                                                <li><code>innerText</code>: Gets or sets the visible text content.</li>
                                                <li><code>textContent</code>: Gets or sets the text content (including
                                                    hidden text).</li>
                                            </ul>
                                        </div>

                                        <% String
                                            contentHtml="<h2>Content Demo</h2>\n<p id='p1'>Original Text</p>\n<p id='p2'>Original <strong>HTML</strong></p>\n<button onclick='changeContent()'>Change Content</button>"
                                            ; String
                                            contentJs="function changeContent() {\n  document.getElementById('p1').innerText = 'New Text Content';\n  document.getElementById('p2').innerHTML = 'New <em>HTML</em> Content';\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-content" />
                                                <jsp:param name="initialHtml" value="<%=contentHtml%>" />
                                                <jsp:param name="initialJs" value="<%=contentJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Changing CSS Styles</h2>
                                            <p>
                                                You can change the style of an HTML element using the <code>style</code>
                                                property.
                                            </p>
                                            <pre
                                                class="code-example-sm"><code>element.style.property = "value";</code></pre>
                                            <p>
                                                <strong>Note:</strong> CSS properties with hyphens (like
                                                <code>background-color</code>) are written in camelCase in JavaScript
                                                (<code>backgroundColor</code>).
                                            </p>

                                            <% String
                                                styleHtml="<h2>Style Demo</h2>\n<div id='box' style='width: 100px; height: 100px; background: red;'></div>\n<br>\n<button onclick='changeStyle()'>Change Style</button>"
                                                ; String
                                                styleJs="function changeStyle() {\n  const box = document.getElementById('box');\n  box.style.backgroundColor = 'blue';\n  box.style.borderRadius = '50%';\n  box.style.width = '150px';\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-style" />
                                                    <jsp:param name="initialHtml" value="<%=styleHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=styleJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Changing Attributes</h2>
                                                <p>
                                                    You can change element attributes like <code>src</code>,
                                                    <code>href</code>, <code>alt</code>, etc.
                                                </p>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <ul style="margin: 0; padding-left: var(--space-6);">
                                                        <li><code>element.attribute = value</code> (Direct property
                                                            access)</li>
                                                        <li><code>element.setAttribute(name, value)</code> (Method)</li>
                                                        <li><code>element.getAttribute(name)</code> (Get value)</li>
                                                    </ul>
                                                </div>

                                                <% String
                                                    attrHtml="<h2>Attribute Demo</h2>\n<img id='myImage' src='https://via.placeholder.com/150/FF0000/FFFFFF?text=Red' alt='Red Image'>\n<br><br>\n<button onclick='changeImage()'>Change Image</button>"
                                                    ; String
                                                    attrJs="function changeImage() {\n  const img = document.getElementById('myImage');\n  img.src = 'https://via.placeholder.com/150/0000FF/FFFFFF?text=Blue';\n  img.alt = 'Blue Image';\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-attr" />
                                                        <jsp:param name="initialHtml" value="<%=attrHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=attrJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Class Manipulation</h2>
                                                    <p>
                                                        The <code>classList</code> property is the best way to add,
                                                        remove, or toggle CSS classes.
                                                    </p>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li><code>element.classList.add("class")</code></li>
                                                            <li><code>element.classList.remove("class")</code></li>
                                                            <li><code>element.classList.toggle("class")</code></li>
                                                            <li><code>element.classList.contains("class")</code></li>
                                                        </ul>
                                                    </div>

                                                    <% String
                                                        classHtml="<h2>ClassList Demo</h2>\n<style>\n  .highlight { background-color: yellow; color: black; padding: 10px; }\n</style>\n<p id='text'>Click the button to toggle class</p>\n<button onclick='toggleClass()'>Toggle Highlight</button>"
                                                        ; String
                                                        classJs="function toggleClass() {\n  const element = document.getElementById('text');\n  element.classList.toggle('highlight');\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-class" />
                                                            <jsp:param name="initialHtml" value="<%=classHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=classJs%>" />
                                                            <jsp:param name="defaultTab" value="js" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li>Use <code>innerHTML</code> to change HTML content.
                                                                </li>
                                                                <li>Use <code>style.property</code> to change inline
                                                                    styles.</li>
                                                                <li>Use <code>setAttribute</code> or direct property
                                                                    access to change attributes.</li>
                                                                <li>Use <code>classList</code> to manage CSS classes
                                                                    efficiently.</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-modify" />
                                                            <jsp:param name="question"
                                                                value="Which property is used to change the background color in JavaScript?" />
                                                            <jsp:param name="option1" value="style.background-color" />
                                                            <jsp:param name="option2" value="style.backgroundColor" />
                                                            <jsp:param name="option3" value="style.bgColor" />
                                                            <jsp:param name="option4" value="css.background" />
                                                            <jsp:param name="correctAnswer" value="2" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="dom-selectors.jsp" />
                                                            <jsp:param name="prevTitle" value="Selecting Elements" />
                                                            <jsp:param name="nextLink" value="dom-create.jsp" />
                                                            <jsp:param name="nextTitle" value="Creating Elements" />
                                                            <jsp:param name="currentLessonId" value="dom-modify" />
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