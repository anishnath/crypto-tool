<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Backgrounds Lesson 21: CSS Background Properties --%>
        <% request.setAttribute("currentLesson", "backgrounds" );
            request.setAttribute("currentModule", "Styling Elements" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Backgrounds - Color, Image, Gradient | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS backgrounds: background-color, background-image, gradients, background-size, background-position, and multiple backgrounds.">
                <meta name="keywords"
                    content="CSS background, background-image, CSS gradient, background-size, background-position">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Backgrounds Complete Guide">
                <meta property="og:description" content="Master CSS background properties.">
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
        "name": "CSS Backgrounds",
        "description": "Master CSS background properties",
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

            <body class="tutorial-body" data-lesson="backgrounds">
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
                                        <span>Backgrounds</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Backgrounds</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Background Color</h2>
                                        <p>
                                            The <code>background-color</code> property sets the background color. Use
                                            any CSS color value.
                                        </p>

                                        <% String
                                            colorHtml="<div class='box1'>Solid Color</div>\n<div class='box2'>RGB Color</div>\n<div class='box3'>Transparent</div>"
                                            ; String
                                            colorCss=".box1,\n.box2,\n.box3 {\n  padding: 30px;\n  margin: 10px 0;\n  color: white;\n  text-align: center;\n}\n\n.box1 { background-color: #3b82f6; }\n.box2 { background-color: rgb(16, 185, 129); }\n.box3 {\n  background-color: rgba(239, 68, 68, 0.5);\n  color: #1e293b;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-color" />
                                                <jsp:param name="initialHtml" value="<%=colorHtml%>" />
                                                <jsp:param name="initialCss" value="<%=colorCss%>" />
                                            </jsp:include>

                                            <h2>Linear Gradients</h2>
                                            <p>
                                                Create smooth color transitions with <code>linear-gradient()</code>.
                                                Specify direction and colors.
                                            </p>

                                            <% String
                                                linearHtml="<div class='grad1'>Top to Bottom</div>\n<div class='grad2'>Left to Right</div>\n<div class='grad3'>Diagonal</div>\n<div class='grad4'>Multiple Colors</div>"
                                                ; String
                                                linearCss="div {\n  padding: 40px;\n  margin: 10px 0;\n  color: white;\n  text-align: center;\n  font-weight: 600;\n}\n\n.grad1 {\n  background: linear-gradient(to bottom, #3b82f6, #1e40af);\n}\n\n.grad2 {\n  background: linear-gradient(to right, #10b981, #059669);\n}\n\n.grad3 {\n  background: linear-gradient(135deg, #f59e0b, #ef4444);\n}\n\n.grad4 {\n  background: linear-gradient(to right, #8b5cf6, #ec4899, #f59e0b);\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-linear" />
                                                    <jsp:param name="initialHtml" value="<%=linearHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=linearCss%>" />
                                                </jsp:include>

                                                <h2>Radial Gradients</h2>
                                                <p>
                                                    <code>radial-gradient()</code> creates circular or elliptical
                                                    gradients radiating from a center point.
                                                </p>

                                                <% String
                                                    radialHtml="<div class='radial1'>Circle</div>\n<div class='radial2'>Ellipse</div>\n<div class='radial3'>Positioned</div>"
                                                    ; String
                                                    radialCss="div {\n  padding: 50px;\n  margin: 10px 0;\n  color: white;\n  text-align: center;\n  font-weight: 600;\n}\n\n.radial1 {\n  background: radial-gradient(circle, #3b82f6, #1e40af);\n}\n\n.radial2 {\n  background: radial-gradient(ellipse, #10b981, #059669);\n}\n\n.radial3 {\n  background: radial-gradient(circle at top left, #f59e0b, #ef4444);\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-radial" />
                                                        <jsp:param name="initialHtml" value="<%=radialHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=radialCss%>" />
                                                    </jsp:include>

                                                    <h2>Background Size</h2>
                                                    <p>
                                                        Control background image size with <code>background-size</code>:
                                                        <code>cover</code>, <code>contain</code>, or specific
                                                        dimensions.
                                                    </p>

                                                    <% String
                                                        sizeHtml="<div class='cover'>cover</div>\n<div class='contain'>contain</div>\n<div class='custom'>200px 100px</div>"
                                                        ; String
                                                        sizeCss="div {\n  height: 150px;\n  margin: 10px 0;\n  color: white;\n  padding: 20px;\n  font-weight: 600;\n  background-image: linear-gradient(45deg, #3b82f6 25%, transparent 25%, transparent 75%, #3b82f6 75%, #3b82f6), linear-gradient(45deg, #3b82f6 25%, transparent 25%, transparent 75%, #3b82f6 75%, #3b82f6);\n  background-color: #1e40af;\n}\n\n.cover {\n  background-size: cover;\n}\n\n.contain {\n  background-size: contain;\n}\n\n.custom {\n  background-size: 200px 100px;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-size" />
                                                            <jsp:param name="initialHtml" value="<%=sizeHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=sizeCss%>" />
                                                        </jsp:include>

                                                        <h2>Background Position</h2>
                                                        <p>
                                                            Position backgrounds with <code>background-position</code>:
                                                            keywords, percentages, or pixels.
                                                        </p>

                                                        <% String
                                                            positionHtml="<div class='top-left'>top left</div>\n<div class='center'>center</div>\n<div class='bottom-right'>bottom right</div>"
                                                            ; String
                                                            positionCss="div {\n  height: 120px;\n  margin: 10px 0;\n  padding: 20px;\n  color: white;\n  font-weight: 600;\n  background: radial-gradient(circle at center, #f59e0b 20px, transparent 20px);\n  background-color: #fef3c7;\n  background-repeat: no-repeat;\n}\n\n.top-left { background-position: top left; }\n.center { background-position: center; }\n.bottom-right { background-position: bottom right; }"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-position" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=positionHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=positionCss%>" />
                                                            </jsp:include>

                                                            <h2>Background Repeat</h2>
                                                            <p>
                                                                Control tiling with <code>background-repeat</code>:
                                                                <code>repeat</code>, <code>no-repeat</code>,
                                                                <code>repeat-x</code>, <code>repeat-y</code>.
                                                            </p>

                                                            <% String
                                                                repeatHtml="<div class='no-repeat'>no-repeat</div>\n<div class='repeat-x'>repeat-x</div>\n<div class='repeat'>repeat</div>"
                                                                ; String
                                                                repeatCss="div {\n  height: 100px;\n  margin: 10px 0;\n  padding: 20px;\n  color: white;\n  font-weight: 600;\n  background-image: radial-gradient(circle, #3b82f6 10px, transparent 10px);\n  background-size: 40px 40px;\n  background-color: #e0e7ff;\n}\n\n.no-repeat { background-repeat: no-repeat; }\n.repeat-x { background-repeat: repeat-x; }\n.repeat { background-repeat: repeat; }"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId" value="editor-repeat" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=repeatHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=repeatCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-tip">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Pro Tip:</strong> Use
                                                                        <code>background-size: cover</code> for hero
                                                                        sections to ensure the background always fills
                                                                        the container while maintaining aspect ratio!
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>background-color</code> - Solid
                                                                            background color</li>
                                                                        <li><code>linear-gradient()</code> - Linear
                                                                            color transitions</li>
                                                                        <li><code>radial-gradient()</code> -
                                                                            Circular/elliptical gradients</li>
                                                                        <li><code>background-size</code> - cover,
                                                                            contain, or dimensions</li>
                                                                        <li><code>background-position</code> - Position
                                                                            the background</li>
                                                                        <li><code>background-repeat</code> - Control
                                                                            tiling behavior</li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId" value="quiz-backgrounds" />
                                                                    <jsp:param name="question"
                                                                        value="Which background-size value ensures the image covers the entire container?" />
                                                                    <jsp:param name="option1" value="contain" />
                                                                    <jsp:param name="option2" value="cover" />
                                                                    <jsp:param name="option3" value="auto" />
                                                                    <jsp:param name="option4" value="100%" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink"
                                                                        value="responsive-design.jsp" />
                                                                    <jsp:param name="prevTitle"
                                                                        value="Responsive Design" />
                                                                    <jsp:param name="nextLink" value="shadows.jsp" />
                                                                    <jsp:param name="nextTitle" value="Shadows" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="backgrounds" />
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