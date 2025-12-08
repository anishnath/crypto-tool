<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Grid Advanced Lesson 19: Advanced Grid Properties --%>
        <% request.setAttribute("currentLesson", "grid-advanced" );
            request.setAttribute("currentModule", "Modern Layouts" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Grid Advanced - Grid Column, Row, Spanning | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master advanced CSS Grid: grid-column, grid-row, spanning cells, justify-items, align-items, and complex grid layouts.">
                <meta name="keywords"
                    content="CSS grid advanced, grid-column, grid-row, grid spanning, justify-items, align-items">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Grid Advanced Properties">
                <meta property="og:description" content="Master advanced CSS Grid techniques.">
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

                <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "CSS Grid Advanced",
        "description": "Master advanced CSS Grid techniques",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "isPartOf": {
            "@type": "Course",
            "name": "CSS Tutorial",
            "url": "https://8gwifi.org/tutorials/css/"
        }
    }
    </script>
            <%-- Ads --%>
                <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
            </head>

            <body class="tutorial-body" data-lesson="grid-advanced">
                <div class="tutorial-layout">
                    <%@ include file="../tutorial-header.jsp" %>

                        <main class="tutorial-main">
                            <%@ include file="../tutorial-sidebar-css.jsp" %>
                                <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                                <article class="tutorial-content">
                                    <nav class="breadcrumb">
                                        <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <a href="<%=request.getContextPath()%>/tutorials/css/">CSS</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <span>Grid Advanced</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Grid Advanced</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Grid Column & Row</h2>
                                        <p>
                                            Use <code>grid-column</code> and <code>grid-row</code> to position items on
                                            specific grid lines. Lines are numbered starting from 1.
                                        </p>

                                        <% String
                                            columnRowHtml="<div class='grid'>\n  <div class='item1'>Item 1</div>\n  <div class='item2'>Item 2</div>\n  <div class='item3'>Item 3</div>\n  <div class='item4'>Item 4</div>\n</div>"
                                            ; String
                                            columnRowCss=".grid {\n  display: grid;\n  grid-template-columns: repeat(3, 1fr);\n  grid-template-rows: repeat(3, 100px);\n  gap: 10px;\n  background-color: #f1f5f9;\n  padding: 10px;\n}\n\n.item1 {\n  grid-column: 1 / 3;\n  grid-row: 1;\n  background-color: #3b82f6;\n}\n\n.item2 {\n  grid-column: 3;\n  grid-row: 1 / 3;\n  background-color: #10b981;\n}\n\n.item3, .item4 {\n  background-color: #f59e0b;\n}\n\n.grid > div {\n  color: white;\n  padding: 20px;\n  display: flex;\n  align-items: center;\n  justify-content: center;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-position" />
                                                <jsp:param name="initialHtml" value="<%=columnRowHtml%>" />
                                                <jsp:param name="initialCss" value="<%=columnRowCss%>" />
                                            </jsp:include>

                                            <h2>Spanning Cells</h2>
                                            <p>
                                                Use <code>span</code> keyword to make items span multiple columns or
                                                rows: <code>grid-column: span 2</code>.
                                            </p>

                                            <% String
                                                spanHtml="<div class='grid'>\n  <div class='wide'>Spans 2 columns</div>\n  <div class='box'>1</div>\n  <div class='tall'>Spans 2 rows</div>\n  <div class='box'>2</div>\n  <div class='box'>3</div>\n</div>"
                                                ; String
                                                spanCss=".grid {\n  display: grid;\n  grid-template-columns: repeat(3, 1fr);\n  gap: 10px;\n  background-color: #fef3c7;\n  padding: 10px;\n}\n\n.wide {\n  grid-column: span 2;\n  background-color: #f59e0b;\n}\n\n.tall {\n  grid-row: span 2;\n  background-color: #ef4444;\n}\n\n.box {\n  background-color: #6366f1;\n}\n\n.grid > div {\n  color: white;\n  padding: 30px;\n  text-align: center;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-span" />
                                                    <jsp:param name="initialHtml" value="<%=spanHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=spanCss%>" />
                                                </jsp:include>

                                                <h2>Justify Items (Horizontal)</h2>
                                                <p>
                                                    <code>justify-items</code> aligns grid items horizontally within
                                                    their cells: <code>start</code>, <code>center</code>,
                                                    <code>end</code>, <code>stretch</code> (default).
                                                </p>

                                                <% String
                                                    justifyHtml="<div class='grid-start'>\n  <div class='box'>Start</div>\n  <div class='box'>Start</div>\n</div>\n<div class='grid-center'>\n  <div class='box'>Center</div>\n  <div class='box'>Center</div>\n</div>"
                                                    ; String
                                                    justifyCss=".grid-start,\n.grid-center {\n  display: grid;\n  grid-template-columns: 1fr 1fr;\n  gap: 10px;\n  background-color: #e0e7ff;\n  padding: 10px;\n  margin: 10px 0;\n  min-height: 100px;\n}\n\n.grid-start { justify-items: start; }\n.grid-center { justify-items: center; }\n\n.box {\n  background-color: #8b5cf6;\n  color: white;\n  padding: 15px 30px;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-justify" />
                                                        <jsp:param name="initialHtml" value="<%=justifyHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=justifyCss%>" />
                                                    </jsp:include>

                                                    <h2>Align Items (Vertical)</h2>
                                                    <p>
                                                        <code>align-items</code> aligns grid items vertically within
                                                        their cells.
                                                    </p>

                                                    <% String
                                                        alignHtml="<div class='grid'>\n  <div class='box'>Aligned Start</div>\n  <div class='box'>Aligned Center</div>\n  <div class='box'>Aligned End</div>\n</div>"
                                                        ; String
                                                        alignCss=".grid {\n  display: grid;\n  grid-template-columns: repeat(3, 1fr);\n  align-items: center;\n  gap: 10px;\n  background-color: #fef3c7;\n  padding: 10px;\n  min-height: 200px;\n}\n\n.box {\n  background-color: #f59e0b;\n  color: white;\n  padding: 20px;\n  text-align: center;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-align" />
                                                            <jsp:param name="initialHtml" value="<%=alignHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=alignCss%>" />
                                                        </jsp:include>

                                                        <h2>Justify Self & Align Self</h2>
                                                        <p>
                                                            Override container alignment for individual items with
                                                            <code>justify-self</code> and <code>align-self</code>.
                                                        </p>

                                                        <% String
                                                            selfHtml="<div class='grid'>\n  <div class='box start'>justify-self: start</div>\n  <div class='box center'>justify-self: center</div>\n  <div class='box end'>justify-self: end</div>\n</div>"
                                                            ; String
                                                            selfCss=".grid {\n  display: grid;\n  grid-template-columns: repeat(3, 1fr);\n  gap: 10px;\n  background-color: #f1f5f9;\n  padding: 10px;\n}\n\n.box {\n  background-color: #3b82f6;\n  color: white;\n  padding: 20px;\n}\n\n.start { justify-self: start; }\n.center { justify-self: center; }\n.end { justify-self: end; }"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-self" />
                                                                <jsp:param name="initialHtml" value="<%=selfHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=selfCss%>" />
                                                            </jsp:include>

                                                            <h2>Complex Layout Example</h2>
                                                            <p>
                                                                Combining all techniques to create a magazine-style
                                                                layout with different sized items.
                                                            </p>

                                                            <% String
                                                                complexHtml="<div class='magazine'>\n  <div class='feature'>Feature Story</div>\n  <div class='article'>Article 1</div>\n  <div class='article'>Article 2</div>\n  <div class='article'>Article 3</div>\n  <div class='sidebar'>Sidebar</div>\n</div>"
                                                                ; String
                                                                complexCss=".magazine {\n  display: grid;\n  grid-template-columns: repeat(4, 1fr);\n  grid-auto-rows: 150px;\n  gap: 15px;\n  background-color: #f1f5f9;\n  padding: 15px;\n}\n\n.feature {\n  grid-column: span 2;\n  grid-row: span 2;\n  background-color: #ef4444;\n}\n\n.article {\n  background-color: #3b82f6;\n}\n\n.sidebar {\n  grid-column: 4;\n  grid-row: 1 / 3;\n  background-color: #10b981;\n}\n\n.magazine > div {\n  color: white;\n  padding: 20px;\n  display: flex;\n  align-items: center;\n  justify-content: center;\n  font-weight: 600;\n}"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId" value="editor-complex" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=complexHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=complexCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-tip">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Pro Tip:</strong> Grid lines can be
                                                                        negative! <code>grid-column: 1 / -1</code> spans
                                                                        from the first to the last column.
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>grid-column</code> /
                                                                            <code>grid-row</code> - Position items on
                                                                            grid lines</li>
                                                                        <li><code>span</code> - Make items span multiple
                                                                            cells</li>
                                                                        <li><code>justify-items</code> - Horizontal
                                                                            alignment of all items</li>
                                                                        <li><code>align-items</code> - Vertical
                                                                            alignment of all items</li>
                                                                        <li><code>justify-self</code> /
                                                                            <code>align-self</code> - Individual item
                                                                            alignment</li>
                                                                        <li>Negative line numbers count from the end
                                                                        </li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId"
                                                                        value="quiz-grid-advanced" />
                                                                    <jsp:param name="question"
                                                                        value="Which property makes a grid item span 3 columns?" />
                                                                    <jsp:param name="option1" value="grid-span: 3" />
                                                                    <jsp:param name="option2"
                                                                        value="grid-column: span 3" />
                                                                    <jsp:param name="option3" value="column-span: 3" />
                                                                    <jsp:param name="option4" value="grid-width: 3" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink" value="grid-areas.jsp" />
                                                                    <jsp:param name="prevTitle"
                                                                        value="Grid Template Areas" />
                                                                    <jsp:param name="nextLink"
                                                                        value="responsive-design.jsp" />
                                                                    <jsp:param name="nextTitle"
                                                                        value="Responsive Design" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="grid-advanced" />
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