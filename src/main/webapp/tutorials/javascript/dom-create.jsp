<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Creating Elements Lesson 19: createElement, appendChild, insertBefore, removeChild --%>
        <% request.setAttribute("currentLesson", "dom-create" );
            request.setAttribute("currentModule", "DOM Manipulation" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Creating DOM Elements | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to create, append, insert, and remove HTML elements using JavaScript.">
                <meta name="keywords"
                    content="JavaScript createElement, appendChild, removeChild, insertBefore, DOM manipulation">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Creating DOM Elements">
                <meta property="og:description" content="Master creating and removing DOM elements">
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

            <body class="tutorial-body" data-lesson="dom-create">
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
                                        <span>Creating Elements</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Creating Elements</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~20 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Creating New Elements</h2>
                                        <p>
                                            To add a new element to the HTML DOM, you must create the element (element
                                            node) first, and then append it to an existing element.
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><code>document.createElement(tag)</code>: Creates a new element
                                                    node.</li>
                                                <li><code>document.createTextNode(text)</code>: Creates a new text node.
                                                </li>
                                                <li><code>element.appendChild(node)</code>: Appends a node as the last
                                                    child of a node.</li>
                                            </ul>
                                        </div>

                                        <% String
                                            createHtml="<h2>Create Element Demo</h2>\n<div id='container' style='border: 1px solid #ccc; padding: 10px;'>\n  <p>Existing Paragraph</p>\n</div>\n<br>\n<button onclick='addElement()'>Add Paragraph</button>"
                                            ; String
                                            createJs="function addElement() {\n  // 1. Create element\n  const newP = document.createElement('p');\n  \n  // 2. Create text node\n  const textNode = document.createTextNode('This is a new paragraph.');\n  \n  // 3. Append text to element\n  newP.appendChild(textNode);\n  \n  // 4. Append element to container\n  const container = document.getElementById('container');\n  container.appendChild(newP);\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-create" />
                                                <jsp:param name="initialHtml" value="<%=createHtml%>" />
                                                <jsp:param name="initialJs" value="<%=createJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Inserting Elements</h2>
                                            <p>
                                                <code>appendChild()</code> adds the new element as the
                                                <strong>last</strong> child. To insert it somewhere else, use
                                                <code>insertBefore()</code>.
                                            </p>
                                            <pre
                                                class="code-example-sm"><code>parentNode.insertBefore(newNode, referenceNode);</code></pre>

                                            <% String
                                                insertHtml="<h2>Insert Before Demo</h2>\n<ul id='list'>\n  <li>Item 1</li>\n  <li>Item 2</li>\n</ul>\n<button onclick='insertItem()'>Insert Item at Top</button>"
                                                ; String
                                                insertJs="function insertItem() {\n  const list = document.getElementById('list');\n  \n  const newItem = document.createElement('li');\n  newItem.innerText = 'New Item (Inserted)';\n  newItem.style.color = 'var(--primary)';\n  \n  // Insert before the first child\n  list.insertBefore(newItem, list.childNodes[0]);\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-insert" />
                                                    <jsp:param name="initialHtml" value="<%=insertHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=insertJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Removing Elements</h2>
                                                <p>
                                                    To remove an HTML element, use <code>remove()</code> or
                                                    <code>removeChild()</code>.
                                                </p>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <ul style="margin: 0; padding-left: var(--space-6);">
                                                        <li><code>element.remove()</code>: Removes the element itself
                                                            (Modern).</li>
                                                        <li><code>parent.removeChild(child)</code>: Removes a child node
                                                            from the parent (Legacy/Cross-browser).</li>
                                                    </ul>
                                                </div>

                                                <% String
                                                    removeHtml="<h2>Remove Demo</h2>\n<div id='removeContainer'>\n  <p id='p1'>Paragraph 1 (Click to remove)</p>\n  <p id='p2'>Paragraph 2 (Click to remove)</p>\n</div>\n<button onclick='resetDemo()'>Reset</button>"
                                                    ; String
                                                    removeJs="document.getElementById('p1').onclick = function() {\n  this.remove(); // Modern way\n};\n\ndocument.getElementById('p2').onclick = function() {\n  const parent = document.getElementById('removeContainer');\n  parent.removeChild(this); // Traditional way\n};\n\nfunction resetDemo() {\n  // Just reloading the iframe content for simplicity in this demo\n  location.reload();\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-remove" />
                                                        <jsp:param name="initialHtml" value="<%=removeHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=removeJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Replacing Elements</h2>
                                                    <p>
                                                        You can replace an element using <code>replaceChild()</code>.
                                                    </p>
                                                    <pre
                                                        class="code-example-sm"><code>parentNode.replaceChild(newChild, oldChild);</code></pre>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Use <code>createElement</code> to make new nodes.</li>
                                                            <li>Use <code>appendChild</code> to add nodes to the end of
                                                                a parent.</li>
                                                            <li>Use <code>insertBefore</code> to place nodes at specific
                                                                positions.</li>
                                                            <li>Use <code>remove</code> to delete elements.</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-create" />
                                                        <jsp:param name="question"
                                                            value="Which method adds a new child node to the end of the list of children of a specified parent node?" />
                                                        <jsp:param name="option1" value="appendChild()" />
                                                        <jsp:param name="option2" value="insertAfter()" />
                                                        <jsp:param name="option3" value="addNode()" />
                                                        <jsp:param name="option4" value="push()" />
                                                        <jsp:param name="correctAnswer" value="1" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="dom-modify.jsp" />
                                                        <jsp:param name="prevTitle" value="Modifying Elements" />
                                                        <jsp:param name="nextLink" value="events.jsp" />
                                                        <jsp:param name="nextTitle" value="Events" />
                                                        <jsp:param name="currentLessonId" value="dom-create" />
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