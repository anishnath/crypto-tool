<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Borders Lesson 9: CSS Border Properties --%>
        <% request.setAttribute("currentLesson", "borders" ); request.setAttribute("currentModule", "Box Model" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Borders - Style, Width, Color, Radius | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS borders: border-style, border-width, border-color, border-radius, and shorthand properties for creating beautiful element outlines.">
                <meta name="keywords"
                    content="CSS borders, border-style, border-width, border-color, border-radius, rounded corners">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Borders - Complete Guide">
                <meta property="og:description" content="Master CSS border properties.">
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
        "name": "CSS Borders",
        "description": "Master CSS border properties",
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

            <body class="tutorial-body" data-lesson="borders">
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
                                        <span>Borders</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Borders</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Border Styles</h2>
                                        <p>
                                            The <code>border-style</code> property defines the type of border. You must
                                            set this before the border will appear.
                                        </p>

                                        <% String
                                            styleHtml="<div class='solid'>Solid border</div>\n<div class='dashed'>Dashed border</div>\n<div class='dotted'>Dotted border</div>\n<div class='double'>Double border</div>"
                                            ; String
                                            styleCss="div {\n  padding: 15px;\n  margin: 10px 0;\n  background-color: #f1f5f9;\n}\n\n.solid { border-style: solid; }\n.dashed { border-style: dashed; }\n.dotted { border-style: dotted; }\n.double { border-style: double; }"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-style" />
                                                <jsp:param name="initialHtml" value="<%=styleHtml%>" />
                                                <jsp:param name="initialCss" value="<%=styleCss%>" />
                                            </jsp:include>

                                            <h2>Border Width & Color</h2>
                                            <p>
                                                Control border thickness with <code>border-width</code> and color with
                                                <code>border-color</code>.
                                            </p>

                                            <% String
                                                widthColorHtml="<div class='thin'>Thin blue border</div>\n<div class='medium'>Medium green border</div>\n<div class='thick'>Thick red border</div>"
                                                ; String
                                                widthColorCss="div {\n  padding: 15px;\n  margin: 10px 0;\n  border-style: solid;\n}\n\n.thin {\n  border-width: 1px;\n  border-color: #3b82f6;\n}\n\n.medium {\n  border-width: 4px;\n  border-color: #10b981;\n}\n\n.thick {\n  border-width: 8px;\n  border-color: #ef4444;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-width" />
                                                    <jsp:param name="initialHtml" value="<%=widthColorHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=widthColorCss%>" />
                                                </jsp:include>

                                                <h2>Border Shorthand</h2>
                                                <p>
                                                    The <code>border</code> shorthand combines width, style, and color
                                                    in one line: <code>border: width style color;</code>
                                                </p>

                                                <% String
                                                    shorthandHtml="<div class='box1'>border: 2px solid #3b82f6;</div>\n<div class='box2'>border: 4px dashed #10b981;</div>\n<div class='box3'>border: 3px dotted #f59e0b;</div>"
                                                    ; String
                                                    shorthandCss=".box1,\n.box2,\n.box3 {\n  padding: 15px;\n  margin: 10px 0;\n  background-color: #f8fafc;\n}\n\n.box1 { border: 2px solid #3b82f6; }\n.box2 { border: 4px dashed #10b981; }\n.box3 { border: 3px dotted #f59e0b; }"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-shorthand" />
                                                        <jsp:param name="initialHtml" value="<%=shorthandHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=shorthandCss%>" />
                                                    </jsp:include>

                                                    <h2>Individual Sides</h2>
                                                    <p>
                                                        You can style each side independently using
                                                        <code>border-top</code>, <code>border-right</code>,
                                                        <code>border-bottom</code>, and <code>border-left</code>.
                                                    </p>

                                                    <% String
                                                        sidesHtml="<div class='custom'>Different border on each side</div>"
                                                        ; String
                                                        sidesCss=".custom {\n  padding: 20px;\n  background-color: #fef3c7;\n  \n  border-top: 4px solid #ef4444;\n  border-right: 4px dashed #3b82f6;\n  border-bottom: 4px dotted #10b981;\n  border-left: 4px double #f59e0b;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-sides" />
                                                            <jsp:param name="initialHtml" value="<%=sidesHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=sidesCss%>" />
                                                        </jsp:include>

                                                        <h2>Border Radius (Rounded Corners)</h2>
                                                        <p>
                                                            The <code>border-radius</code> property creates rounded
                                                            corners. Use pixels or percentages.
                                                        </p>

                                                        <% String
                                                            radiusHtml="<div class='small-radius'>Small radius (8px)</div>\n<div class='medium-radius'>Medium radius (16px)</div>\n<div class='large-radius'>Large radius (24px)</div>\n<div class='circle'>Circle (50%)</div>"
                                                            ; String
                                                            radiusCss="div {\n  padding: 20px;\n  margin: 10px 0;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n}\n\n.small-radius { border-radius: 8px; }\n.medium-radius { border-radius: 16px; }\n.large-radius { border-radius: 24px; }\n.circle {\n  width: 150px;\n  height: 150px;\n  border-radius: 50%;\n  display: flex;\n  align-items: center;\n  justify-content: center;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-radius" />
                                                                <jsp:param name="initialHtml" value="<%=radiusHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=radiusCss%>" />
                                                            </jsp:include>

                                                            <div class="callout callout-tip">
                                                                <svg class="callout-icon" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <path d="M12 16v-4M12 8h.01" />
                                                                </svg>
                                                                <div class="callout-content">
                                                                    <strong>Pro Tip:</strong> Use
                                                                    <code>border-radius: 50%</code> on a square element
                                                                    to create a perfect circle!
                                                                </div>
                                                            </div>

                                                            <h2>Summary</h2>
                                                            <div class="card" style="margin: var(--space-6) 0;">
                                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                                    <li><code>border-style</code> - solid, dashed,
                                                                        dotted, double, etc.</li>
                                                                    <li><code>border-width</code> - Thickness in px, em,
                                                                        etc.</li>
                                                                    <li><code>border-color</code> - Any CSS color value
                                                                    </li>
                                                                    <li><code>border</code> - Shorthand: width style
                                                                        color</li>
                                                                    <li><code>border-radius</code> - Rounded corners
                                                                    </li>
                                                                    <li>Individual sides: <code>border-top</code>,
                                                                        <code>border-right</code>, etc.</li>
                                                                </ul>
                                                            </div>

                                                            <jsp:include page="../tutorial-quiz.jsp">
                                                                <jsp:param name="quizId" value="quiz-borders" />
                                                                <jsp:param name="question"
                                                                    value="Which property creates rounded corners?" />
                                                                <jsp:param name="option1" value="border-style" />
                                                                <jsp:param name="option2" value="border-radius" />
                                                                <jsp:param name="option3" value="border-round" />
                                                                <jsp:param name="option4" value="corner-radius" />
                                                                <jsp:param name="correctAnswer" value="1" />
                                                            </jsp:include>

                                                            <jsp:include page="../tutorial-nav.jsp">
                                                                <jsp:param name="prevLink" value="box-model.jsp" />
                                                                <jsp:param name="prevTitle" value="Box Model" />
                                                                <jsp:param name="nextLink" value="padding-margin.jsp" />
                                                                <jsp:param name="nextTitle" value="Padding & Margin" />
                                                                <jsp:param name="currentLessonId" value="borders" />
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