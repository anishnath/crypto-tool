<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Flexbox Basics Lesson 15: Introduction to CSS Flexbox --%>
        <% request.setAttribute("currentLesson", "flexbox-basics" );
            request.setAttribute("currentModule", "Layout Fundamentals" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Flexbox Basics - Flex Container & Items | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn CSS Flexbox basics: display flex, flex-direction, justify-content, align-items. Master modern CSS layouts.">
                <meta name="keywords"
                    content="CSS flexbox, display flex, justify-content, align-items, flex-direction, flexbox layout">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Flexbox Basics - Complete Guide">
                <meta property="og:description" content="Master CSS Flexbox fundamentals.">
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
        "name": "CSS Flexbox Basics",
        "description": "Master CSS Flexbox fundamentals",
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

            <body class="tutorial-body" data-lesson="flexbox-basics">
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
                                        <span>Flexbox Basics</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Flexbox Basics</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is Flexbox?</h2>
                                        <p>
                                            Flexbox (Flexible Box Layout) is a modern CSS layout system designed for
                                            creating flexible, responsive layouts. It makes aligning and distributing
                                            space among items incredibly easy.
                                        </p>

                                        <h2>Creating a Flex Container</h2>
                                        <p>
                                            Apply <code>display: flex</code> to a parent element to make it a flex
                                            container. Its direct children become flex items.
                                        </p>

                                        <% String
                                            flexContainerHtml="<div class='container'>\n  <div class='item'>Item 1</div>\n  <div class='item'>Item 2</div>\n  <div class='item'>Item 3</div>\n</div>"
                                            ; String
                                            flexContainerCss=".container {\n  display: flex;\n  background-color: #f1f5f9;\n  padding: 20px;\n  gap: 10px;\n}\n\n.item {\n  padding: 20px;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-container" />
                                                <jsp:param name="initialHtml" value="<%=flexContainerHtml%>" />
                                                <jsp:param name="initialCss" value="<%=flexContainerCss%>" />
                                            </jsp:include>

                                            <h2>Flex Direction</h2>
                                            <p>
                                                <code>flex-direction</code> controls the main axis direction:
                                                <code>row</code> (default), <code>column</code>,
                                                <code>row-reverse</code>, <code>column-reverse</code>.
                                            </p>

                                            <% String
                                                directionHtml="<div class='row'>\n  <div class='item'>1</div>\n  <div class='item'>2</div>\n  <div class='item'>3</div>\n</div>\n<div class='column'>\n  <div class='item'>1</div>\n  <div class='item'>2</div>\n  <div class='item'>3</div>\n</div>"
                                                ; String
                                                directionCss=".row,\n.column {\n  display: flex;\n  background-color: #f1f5f9;\n  padding: 15px;\n  margin: 10px 0;\n  gap: 10px;\n}\n\n.row {\n  flex-direction: row;\n}\n\n.column {\n  flex-direction: column;\n}\n\n.item {\n  padding: 15px;\n  background-color: #10b981;\n  color: white;\n  text-align: center;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-direction" />
                                                    <jsp:param name="initialHtml" value="<%=directionHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=directionCss%>" />
                                                </jsp:include>

                                                <h2>Justify Content (Main Axis)</h2>
                                                <p>
                                                    <code>justify-content</code> aligns items along the main axis:
                                                    <code>flex-start</code>, <code>center</code>, <code>flex-end</code>,
                                                    <code>space-between</code>, <code>space-around</code>,
                                                    <code>space-evenly</code>.
                                                </p>

                                                <% String
                                                    justifyHtml="<div class='start'>\n  <div class='box'>1</div>\n  <div class='box'>2</div>\n  <div class='box'>3</div>\n</div>\n<div class='center'>\n  <div class='box'>1</div>\n  <div class='box'>2</div>\n  <div class='box'>3</div>\n</div>\n<div class='between'>\n  <div class='box'>1</div>\n  <div class='box'>2</div>\n  <div class='box'>3</div>\n</div>"
                                                    ; String
                                                    justifyCss=".start,\n.center,\n.between {\n  display: flex;\n  background-color: #fef3c7;\n  padding: 10px;\n  margin: 10px 0;\n}\n\n.start { justify-content: flex-start; }\n.center { justify-content: center; }\n.between { justify-content: space-between; }\n\n.box {\n  width: 60px;\n  padding: 15px;\n  background-color: #f59e0b;\n  color: white;\n  text-align: center;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-justify" />
                                                        <jsp:param name="initialHtml" value="<%=justifyHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=justifyCss%>" />
                                                    </jsp:include>

                                                    <h2>Align Items (Cross Axis)</h2>
                                                    <p>
                                                        <code>align-items</code> aligns items along the cross axis:
                                                        <code>stretch</code> (default), <code>flex-start</code>,
                                                        <code>center</code>, <code>flex-end</code>,
                                                        <code>baseline</code>.
                                                    </p>

                                                    <% String
                                                        alignHtml="<div class='align-start'>\n  <div class='box'>Start</div>\n  <div class='box tall'>Center</div>\n  <div class='box'>End</div>\n</div>\n<div class='align-center'>\n  <div class='box'>Start</div>\n  <div class='box tall'>Center</div>\n  <div class='box'>End</div>\n</div>"
                                                        ; String
                                                        alignCss=".align-start,\n.align-center {\n  display: flex;\n  height: 150px;\n  background-color: #e0e7ff;\n  padding: 10px;\n  margin: 10px 0;\n  gap: 10px;\n}\n\n.align-start { align-items: flex-start; }\n.align-center { align-items: center; }\n\n.box {\n  padding: 15px;\n  background-color: #6366f1;\n  color: white;\n}\n\n.tall {\n  padding: 30px 15px;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-align" />
                                                            <jsp:param name="initialHtml" value="<%=alignHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=alignCss%>" />
                                                        </jsp:include>

                                                        <h2>Centering with Flexbox</h2>
                                                        <p>
                                                            Combine <code>justify-content: center</code> and
                                                            <code>align-items: center</code> to perfectly center content
                                                            both horizontally and vertically!
                                                        </p>

                                                        <% String
                                                            centeringHtml="<div class='perfect-center'>\n  <div class='box'>Perfectly Centered!</div>\n</div>"
                                                            ; String
                                                            centeringCss=".perfect-center {\n  display: flex;\n  justify-content: center;\n  align-items: center;\n  height: 200px;\n  background-color: #f1f5f9;\n  border: 2px dashed #3b82f6;\n}\n\n.box {\n  padding: 20px 40px;\n  background-color: #3b82f6;\n  color: white;\n  border-radius: 8px;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-centering" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=centeringHtml%>" />
                                                                <jsp:param name="initialCss"
                                                                    value="<%=centeringCss%>" />
                                                            </jsp:include>

                                                            <div class="callout callout-tip">
                                                                <svg class="callout-icon" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <path d="M12 16v-4M12 8h.01" />
                                                                </svg>
                                                                <div class="callout-content">
                                                                    <strong>Quick Reference:</strong><br>
                                                                    • <code>justify-content</code> - Aligns along main
                                                                    axis (horizontal in row)<br>
                                                                    • <code>align-items</code> - Aligns along cross axis
                                                                    (vertical in row)<br>
                                                                    • <code>gap</code> - Spacing between flex items
                                                                </div>
                                                            </div>

                                                            <h2>Summary</h2>
                                                            <div class="card" style="margin: var(--space-6) 0;">
                                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                                    <li><code>display: flex</code> - Creates a flex
                                                                        container</li>
                                                                    <li><code>flex-direction</code> - row, column,
                                                                        row-reverse, column-reverse</li>
                                                                    <li><code>justify-content</code> - Align on main
                                                                        axis</li>
                                                                    <li><code>align-items</code> - Align on cross axis
                                                                    </li>
                                                                    <li><code>gap</code> - Space between items</li>
                                                                    <li>Perfect centering:
                                                                        <code>justify-content: center; align-items: center;</code>
                                                                    </li>
                                                                </ul>
                                                            </div>

                                                            <jsp:include page="../tutorial-quiz.jsp">
                                                                <jsp:param name="quizId" value="quiz-flexbox-basics" />
                                                                <jsp:param name="question"
                                                                    value="Which property aligns flex items along the main axis?" />
                                                                <jsp:param name="option1" value="align-items" />
                                                                <jsp:param name="option2" value="justify-content" />
                                                                <jsp:param name="option3" value="flex-direction" />
                                                                <jsp:param name="option4" value="align-content" />
                                                                <jsp:param name="correctAnswer" value="1" />
                                                            </jsp:include>

                                                            <jsp:include page="../tutorial-nav.jsp">
                                                                <jsp:param name="prevLink" value="float-clear.jsp" />
                                                                <jsp:param name="prevTitle" value="Float & Clear" />
                                                                <jsp:param name="nextLink"
                                                                    value="flexbox-advanced.jsp" />
                                                                <jsp:param name="nextTitle" value="Flexbox Advanced" />
                                                                <jsp:param name="currentLessonId"
                                                                    value="flexbox-basics" />
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