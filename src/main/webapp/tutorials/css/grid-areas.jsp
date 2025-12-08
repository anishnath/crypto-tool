<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Grid Template Areas Lesson 18: Named Grid Areas for Semantic Layouts --%>
        <% request.setAttribute("currentLesson", "grid-areas" ); request.setAttribute("currentModule", "Modern Layouts"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Grid Template Areas - Named Grid Layouts | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS Grid template areas: create semantic, readable layouts with named grid areas for headers, sidebars, content, and footers.">
                <meta name="keywords"
                    content="CSS grid areas, grid-template-areas, grid-area, named grid, CSS grid layout">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Grid Template Areas Guide">
                <meta property="og:description" content="Master CSS Grid template areas.">
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
        "name": "CSS Grid Template Areas",
        "description": "Master CSS Grid template areas",
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

            <body class="tutorial-body" data-lesson="grid-areas">
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
                                        <span>Grid Template Areas</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Grid Template Areas</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~9 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Grid Template Areas?</h2>
                                        <p>
                                            Grid template areas let you name sections of your grid and create layouts
                                            visually in CSS. It's incredibly readable and semantic!
                                        </p>

                                        <h2>Basic Layout with Areas</h2>
                                        <p>
                                            Use <code>grid-template-areas</code> to define named regions, then assign
                                            items to areas with <code>grid-area</code>.
                                        </p>

                                        <% String
                                            basicAreasHtml="<div class='container'>\n  <header class='header'>Header</header>\n  <main class='content'>Main Content</main>\n  <footer class='footer'>Footer</footer>\n</div>"
                                            ; String
                                            basicAreasCss=".container {\n  display: grid;\n  grid-template-areas:\n    'header'\n    'content'\n    'footer';\n  gap: 10px;\n  background-color: #f1f5f9;\n  padding: 10px;\n}\n\n.header {\n  grid-area: header;\n  background-color: #3b82f6;\n  color: white;\n  padding: 20px;\n}\n\n.content {\n  grid-area: content;\n  background-color: #10b981;\n  color: white;\n  padding: 40px;\n}\n\n.footer {\n  grid-area: footer;\n  background-color: #64748b;\n  color: white;\n  padding: 20px;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=basicAreasHtml%>" />
                                                <jsp:param name="initialCss" value="<%=basicAreasCss%>" />
                                            </jsp:include>

                                            <h2>Classic Website Layout</h2>
                                            <p>
                                                Create a classic header-sidebar-content-footer layout with named areas.
                                                Notice how readable the CSS is!
                                            </p>

                                            <% String
                                                classicHtml="<div class='layout'>\n  <header class='header'>Header</header>\n  <aside class='sidebar'>Sidebar</aside>\n  <main class='main'>Main Content</main>\n  <footer class='footer'>Footer</footer>\n</div>"
                                                ; String
                                                classicCss=".layout {\n  display: grid;\n  grid-template-areas:\n    'header header'\n    'sidebar main'\n    'footer footer';\n  grid-template-columns: 200px 1fr;\n  gap: 15px;\n  background-color: #fef3c7;\n  padding: 15px;\n  min-height: 400px;\n}\n\n.header { grid-area: header; background-color: #f59e0b; }\n.sidebar { grid-area: sidebar; background-color: #ef4444; }\n.main { grid-area: main; background-color: #10b981; }\n.footer { grid-area: footer; background-color: #6366f1; }\n\n.header, .sidebar, .main, .footer {\n  color: white;\n  padding: 20px;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-classic" />
                                                    <jsp:param name="initialHtml" value="<%=classicHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=classicCss%>" />
                                                </jsp:include>

                                                <h2>Empty Cells with Dots</h2>
                                                <p>
                                                    Use a dot <code>.</code> to create empty cells in your grid
                                                    template.
                                                </p>

                                                <% String
                                                    emptyHtml="<div class='grid'>\n  <div class='box1'>Box 1</div>\n  <div class='box2'>Box 2</div>\n  <div class='box3'>Box 3</div>\n</div>"
                                                    ; String
                                                    emptyCss=".grid {\n  display: grid;\n  grid-template-areas:\n    'box1 . box2'\n    'box1 box3 box3';\n  grid-template-columns: 1fr 1fr 1fr;\n  gap: 10px;\n  background-color: #e0e7ff;\n  padding: 10px;\n}\n\n.box1 { grid-area: box1; background-color: #8b5cf6; }\n.box2 { grid-area: box2; background-color: #ec4899; }\n.box3 { grid-area: box3; background-color: #3b82f6; }\n\n.box1, .box2, .box3 {\n  color: white;\n  padding: 30px;\n  text-align: center;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-empty" />
                                                        <jsp:param name="initialHtml" value="<%=emptyHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=emptyCss%>" />
                                                    </jsp:include>

                                                    <h2>Responsive Grid Areas</h2>
                                                    <p>
                                                        Change grid-template-areas with media queries for responsive
                                                        layouts. Desktop: sidebar on left. Mobile: sidebar below
                                                        content.
                                                    </p>

                                                    <% String
                                                        responsiveHtml="<div class='responsive'>\n  <header class='h'>Header</header>\n  <aside class='s'>Sidebar</aside>\n  <main class='m'>Main</main>\n  <footer class='f'>Footer</footer>\n</div>"
                                                        ; String
                                                        responsiveCss=".responsive {\n  display: grid;\n  gap: 10px;\n  padding: 10px;\n  background-color: #f1f5f9;\n}\n\n/* Desktop layout */\n.responsive {\n  grid-template-areas:\n    'h h h'\n    's m m'\n    'f f f';\n  grid-template-columns: 150px 1fr 1fr;\n}\n\n.h { grid-area: h; background-color: #3b82f6; }\n.s { grid-area: s; background-color: #f59e0b; }\n.m { grid-area: m; background-color: #10b981; }\n.f { grid-area: f; background-color: #64748b; }\n\n.h, .s, .m, .f {\n  color: white;\n  padding: 20px;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-responsive" />
                                                            <jsp:param name="initialHtml" value="<%=responsiveHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=responsiveCss%>" />
                                                        </jsp:include>

                                                        <div class="callout callout-tip">
                                                            <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <circle cx="12" cy="12" r="10" />
                                                                <path d="M12 16v-4M12 8h.01" />
                                                            </svg>
                                                            <div class="callout-content">
                                                                <strong>Pro Tip:</strong> Grid template areas make your
                                                                CSS self-documenting. You can literally see the layout
                                                                structure in the CSS!
                                                            </div>
                                                        </div>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li><code>grid-template-areas</code> - Define named grid
                                                                    regions</li>
                                                                <li><code>grid-area</code> - Assign element to named
                                                                    area</li>
                                                                <li>Use quotes for each row in template-areas</li>
                                                                <li>Repeat area name to span multiple cells</li>
                                                                <li>Use <code>.</code> for empty cells</li>
                                                                <li>Perfect for semantic, readable layouts</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-grid-areas" />
                                                            <jsp:param name="question"
                                                                value="What character creates an empty cell in grid-template-areas?" />
                                                            <jsp:param name="option1" value="Underscore (_)" />
                                                            <jsp:param name="option2" value="Dot (.)" />
                                                            <jsp:param name="option3" value="Hash (#)" />
                                                            <jsp:param name="option4" value="Asterisk (*)" />
                                                            <jsp:param name="correctAnswer" value="1" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="grid-basics.jsp" />
                                                            <jsp:param name="prevTitle" value="Grid Basics" />
                                                            <jsp:param name="nextLink" value="grid-advanced.jsp" />
                                                            <jsp:param name="nextTitle" value="Grid Advanced" />
                                                            <jsp:param name="currentLessonId" value="grid-areas" />
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