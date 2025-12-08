<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Grid Basics Lesson 17: Introduction to CSS Grid Layout --%>
        <% request.setAttribute("currentLesson", "grid-basics" ); request.setAttribute("currentModule", "Modern Layouts"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Grid Basics - Grid Container & Items | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn CSS Grid basics: display grid, grid-template-columns, grid-template-rows, gap, and creating powerful 2D layouts.">
                <meta name="keywords"
                    content="CSS grid, display grid, grid-template-columns, grid-template-rows, CSS grid layout">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Grid Basics - Complete Guide">
                <meta property="og:description" content="Master CSS Grid fundamentals.">
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
        "name": "CSS Grid Basics",
        "description": "Master CSS Grid fundamentals",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
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

            <body class="tutorial-body" data-lesson="grid-basics">
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
                                        <span>Grid Basics</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Grid Basics</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~11 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is CSS Grid?</h2>
                                        <p>
                                            CSS Grid is a powerful 2D layout system for creating complex, responsive
                                            layouts. Unlike Flexbox (1D), Grid works with both rows and columns
                                            simultaneously.
                                        </p>

                                        <h2>Creating a Grid Container</h2>
                                        <p>
                                            Apply <code>display: grid</code> to create a grid container. Direct children
                                            become grid items.
                                        </p>

                                        <% String
                                            gridContainerHtml="<div class='grid'>\n  <div class='item'>1</div>\n  <div class='item'>2</div>\n  <div class='item'>3</div>\n  <div class='item'>4</div>\n  <div class='item'>5</div>\n  <div class='item'>6</div>\n</div>"
                                            ; String
                                            gridContainerCss=".grid {\n  display: grid;\n  grid-template-columns: 1fr 1fr 1fr;\n  gap: 10px;\n  background-color: #f1f5f9;\n  padding: 10px;\n}\n\n.item {\n  padding: 30px;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n  font-size: 20px;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-container" />
                                                <jsp:param name="initialHtml" value="<%=gridContainerHtml%>" />
                                                <jsp:param name="initialCss" value="<%=gridContainerCss%>" />
                                            </jsp:include>

                                            <h2>Grid Template Columns</h2>
                                            <p>
                                                <code>grid-template-columns</code> defines column widths. Use px, %, fr
                                                (fraction), auto, or mix them!
                                            </p>

                                            <% String
                                                columnsHtml="<div class='grid-px'>\n  <div class='box'>200px</div>\n  <div class='box'>200px</div>\n  <div class='box'>200px</div>\n</div>\n<div class='grid-fr'>\n  <div class='box'>1fr</div>\n  <div class='box'>2fr</div>\n  <div class='box'>1fr</div>\n</div>"
                                                ; String
                                                columnsCss=".grid-px,\n.grid-fr {\n  display: grid;\n  gap: 10px;\n  margin: 10px 0;\n  padding: 10px;\n  background-color: #fef3c7;\n}\n\n.grid-px {\n  grid-template-columns: 200px 200px 200px;\n}\n\n.grid-fr {\n  grid-template-columns: 1fr 2fr 1fr;\n}\n\n.box {\n  padding: 20px;\n  background-color: #f59e0b;\n  color: white;\n  text-align: center;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-columns" />
                                                    <jsp:param name="initialHtml" value="<%=columnsHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=columnsCss%>" />
                                                </jsp:include>

                                                <h2>Grid Template Rows</h2>
                                                <p>
                                                    <code>grid-template-rows</code> defines row heights. Works the same
                                                    as columns.
                                                </p>

                                                <% String
                                                    rowsHtml="<div class='grid'>\n  <div class='item'>Row 1</div>\n  <div class='item'>Row 2</div>\n  <div class='item'>Row 3</div>\n</div>"
                                                    ; String
                                                    rowsCss=".grid {\n  display: grid;\n  grid-template-columns: 1fr;\n  grid-template-rows: 100px 150px 80px;\n  gap: 10px;\n  background-color: #e0e7ff;\n  padding: 10px;\n}\n\n.item {\n  padding: 20px;\n  background-color: #6366f1;\n  color: white;\n  text-align: center;\n  display: flex;\n  align-items: center;\n  justify-content: center;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-rows" />
                                                        <jsp:param name="initialHtml" value="<%=rowsHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=rowsCss%>" />
                                                    </jsp:include>

                                                    <h2>Gap (Grid Spacing)</h2>
                                                    <p>
                                                        The <code>gap</code> property creates spacing between grid
                                                        items. Use <code>row-gap</code> and <code>column-gap</code> for
                                                        individual control.
                                                    </p>

                                                    <% String
                                                        gapHtml="<div class='grid-small'>\n  <div class='box'>1</div>\n  <div class='box'>2</div>\n  <div class='box'>3</div>\n  <div class='box'>4</div>\n</div>\n<div class='grid-large'>\n  <div class='box'>1</div>\n  <div class='box'>2</div>\n  <div class='box'>3</div>\n  <div class='box'>4</div>\n</div>"
                                                        ; String
                                                        gapCss=".grid-small,\n.grid-large {\n  display: grid;\n  grid-template-columns: 1fr 1fr;\n  background-color: #f1f5f9;\n  padding: 10px;\n  margin: 10px 0;\n}\n\n.grid-small { gap: 5px; }\n.grid-large { gap: 20px; }\n\n.box {\n  padding: 30px;\n  background-color: #10b981;\n  color: white;\n  text-align: center;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-gap" />
                                                            <jsp:param name="initialHtml" value="<%=gapHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=gapCss%>" />
                                                        </jsp:include>

                                                        <h2>Repeat Function</h2>
                                                        <p>
                                                            Use <code>repeat()</code> to avoid repetition:
                                                            <code>repeat(3, 1fr)</code> = <code>1fr 1fr 1fr</code>.
                                                        </p>

                                                        <% String
                                                            repeatHtml="<div class='grid'>\n  <div class='item'>1</div>\n  <div class='item'>2</div>\n  <div class='item'>3</div>\n  <div class='item'>4</div>\n  <div class='item'>5</div>\n  <div class='item'>6</div>\n</div>"
                                                            ; String
                                                            repeatCss=".grid {\n  display: grid;\n  /* Same as: 1fr 1fr 1fr 1fr */\n  grid-template-columns: repeat(4, 1fr);\n  gap: 10px;\n  background-color: #fef3c7;\n  padding: 10px;\n}\n\n.item {\n  padding: 25px;\n  background-color: #ef4444;\n  color: white;\n  text-align: center;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-repeat" />
                                                                <jsp:param name="initialHtml" value="<%=repeatHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=repeatCss%>" />
                                                            </jsp:include>

                                                            <h2>Auto-Fit & Minmax</h2>
                                                            <p>
                                                                Combine <code>repeat(auto-fit, minmax(min, max))</code>
                                                                for responsive grids that automatically adjust columns!
                                                            </p>

                                                            <% String
                                                                autoFitHtml="<div class='grid'>\n  <div class='card'>Card 1</div>\n  <div class='card'>Card 2</div>\n  <div class='card'>Card 3</div>\n  <div class='card'>Card 4</div>\n  <div class='card'>Card 5</div>\n</div>"
                                                                ; String
                                                                autoFitCss=".grid {\n  display: grid;\n  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));\n  gap: 15px;\n  background-color: #f1f5f9;\n  padding: 15px;\n}\n\n.card {\n  padding: 30px;\n  background-color: #8b5cf6;\n  color: white;\n  text-align: center;\n  border-radius: 8px;\n}"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId" value="editor-autofit" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=autoFitHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=autoFitCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-tip">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Pro Tip:</strong> The <code>fr</code>
                                                                        unit (fraction) divides available space
                                                                        proportionally. <code>1fr 2fr</code> means the
                                                                        second column gets twice the space of the first!
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>display: grid</code> - Creates grid
                                                                            container</li>
                                                                        <li><code>grid-template-columns</code> - Define
                                                                            column widths</li>
                                                                        <li><code>grid-template-rows</code> - Define row
                                                                            heights</li>
                                                                        <li><code>gap</code> - Spacing between grid
                                                                            items</li>
                                                                        <li><code>repeat(n, size)</code> - Repeat
                                                                            pattern n times</li>
                                                                        <li><code>fr</code> unit - Fraction of available
                                                                            space</li>
                                                                        <li><code>minmax(min, max)</code> - Flexible
                                                                            sizing with limits</li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId" value="quiz-grid-basics" />
                                                                    <jsp:param name="question"
                                                                        value="What does the 'fr' unit stand for in CSS Grid?" />
                                                                    <jsp:param name="option1" value="Frame" />
                                                                    <jsp:param name="option2" value="Fraction" />
                                                                    <jsp:param name="option3" value="Free" />
                                                                    <jsp:param name="option4" value="Fixed ratio" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink"
                                                                        value="flexbox-advanced.jsp" />
                                                                    <jsp:param name="prevTitle"
                                                                        value="Flexbox Advanced" />
                                                                    <jsp:param name="nextLink" value="grid-areas.jsp" />
                                                                    <jsp:param name="nextTitle"
                                                                        value="Grid Template Areas" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="grid-basics" />
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