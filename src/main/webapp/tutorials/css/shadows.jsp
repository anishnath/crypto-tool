<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Shadows Lesson 22: Box Shadow and Text Shadow --%>
        <% request.setAttribute("currentLesson", "shadows" ); request.setAttribute("currentModule", "Styling Elements"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Shadows - Box Shadow & Text Shadow | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS shadows: box-shadow for elements, text-shadow for text, multiple shadows, and creating depth in designs.">
                <meta name="keywords" content="CSS shadow, box-shadow, text-shadow, drop shadow, CSS depth">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Shadows Complete Guide">
                <meta property="og:description" content="Master CSS shadow effects.">
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
        "name": "CSS Shadows",
        "description": "Master CSS shadow effects",
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

            <body class="tutorial-body" data-lesson="shadows">
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
                                        <span>Shadows</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Shadows</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Box Shadow Basics</h2>
                                        <p>
                                            <code>box-shadow</code> adds shadows to elements. Syntax:
                                            <code>x-offset y-offset blur spread color</code>.
                                        </p>

                                        <% String
                                            boxBasicHtml="<div class='card1'>Small shadow</div>\n<div class='card2'>Medium shadow</div>\n<div class='card3'>Large shadow</div>"
                                            ; String
                                            boxBasicCss=".card1,\n.card2,\n.card3 {\n  padding: 30px;\n  margin: 20px;\n  background-color: white;\n  text-align: center;\n}\n\n.card1 {\n  box-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);\n}\n\n.card2 {\n  box-shadow: 4px 4px 8px rgba(0, 0, 0, 0.2);\n}\n\n.card3 {\n  box-shadow: 8px 8px 16px rgba(0, 0, 0, 0.3);\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=boxBasicHtml%>" />
                                                <jsp:param name="initialCss" value="<%=boxBasicCss%>" />
                                            </jsp:include>

                                            <h2>Inset Shadows</h2>
                                            <p>
                                                Add <code>inset</code> keyword for inner shadows, creating a pressed or
                                                recessed effect.
                                            </p>

                                            <% String
                                                insetHtml="<div class='outer'>Outer shadow</div>\n<div class='inner'>Inset shadow (pressed)</div>"
                                                ; String
                                                insetCss=".outer,\n.inner {\n  padding: 40px;\n  margin: 20px;\n  background-color: #f1f5f9;\n  text-align: center;\n  font-weight: 600;\n}\n\n.outer {\n  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);\n}\n\n.inner {\n  box-shadow: inset 0 4px 6px rgba(0, 0, 0, 0.2);\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-inset" />
                                                    <jsp:param name="initialHtml" value="<%=insetHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=insetCss%>" />
                                                </jsp:include>

                                                <h2>Multiple Shadows</h2>
                                                <p>
                                                    Stack multiple shadows by separating them with commas for complex
                                                    effects.
                                                </p>

                                                <% String
                                                    multipleHtml="<div class='card'>Layered shadows create depth</div>"
                                                    ; String
                                                    multipleCss=".card {\n  padding: 40px;\n  margin: 30px;\n  background-color: white;\n  text-align: center;\n  font-weight: 600;\n  box-shadow:\n    0 1px 3px rgba(0, 0, 0, 0.12),\n    0 1px 2px rgba(0, 0, 0, 0.24),\n    0 10px 20px rgba(0, 0, 0, 0.1);\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-multiple" />
                                                        <jsp:param name="initialHtml" value="<%=multipleHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=multipleCss%>" />
                                                    </jsp:include>

                                                    <h2>Colored Shadows</h2>
                                                    <p>
                                                        Use any color for shadows, not just black! Great for creating
                                                        glowing effects.
                                                    </p>

                                                    <% String
                                                        coloredHtml="<div class='blue'>Blue glow</div>\n<div class='green'>Green glow</div>\n<div class='purple'>Purple glow</div>"
                                                        ; String
                                                        coloredCss=".blue,\n.green,\n.purple {\n  padding: 30px;\n  margin: 20px;\n  background-color: white;\n  text-align: center;\n  font-weight: 600;\n}\n\n.blue {\n  box-shadow: 0 0 20px rgba(59, 130, 246, 0.5);\n}\n\n.green {\n  box-shadow: 0 0 20px rgba(16, 185, 129, 0.5);\n}\n\n.purple {\n  box-shadow: 0 0 20px rgba(139, 92, 246, 0.5);\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-colored" />
                                                            <jsp:param name="initialHtml" value="<%=coloredHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=coloredCss%>" />
                                                        </jsp:include>

                                                        <h2>Text Shadow</h2>
                                                        <p>
                                                            <code>text-shadow</code> adds shadows to text. Syntax:
                                                            <code>x-offset y-offset blur color</code>.
                                                        </p>

                                                        <% String
                                                            textHtml="<h1 class='subtle'>Subtle text shadow</h1>\n<h1 class='bold'>Bold text shadow</h1>\n<h1 class='glow'>Glowing text</h1>"
                                                            ; String
                                                            textCss="h1 {\n  margin: 20px 0;\n  font-size: 32px;\n  text-align: center;\n}\n\n.subtle {\n  color: #1e293b;\n  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);\n}\n\n.bold {\n  color: #3b82f6;\n  text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.2);\n}\n\n.glow {\n  color: white;\n  background-color: #1e293b;\n  padding: 20px;\n  text-shadow: 0 0 10px #3b82f6, 0 0 20px #3b82f6;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-text" />
                                                                <jsp:param name="initialHtml" value="<%=textHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=textCss%>" />
                                                            </jsp:include>

                                                            <div class="callout callout-tip">
                                                                <svg class="callout-icon" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <path d="M12 16v-4M12 8h.01" />
                                                                </svg>
                                                                <div class="callout-content">
                                                                    <strong>Pro Tip:</strong> Use subtle shadows (low
                                                                    opacity, small blur) for modern, clean designs.
                                                                    Avoid heavy shadows unless going for a specific
                                                                    dramatic effect!
                                                                </div>
                                                            </div>

                                                            <h2>Summary</h2>
                                                            <div class="card" style="margin: var(--space-6) 0;">
                                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                                    <li><code>box-shadow</code> - Shadows for elements
                                                                    </li>
                                                                    <li>Syntax: <code>x y blur spread color</code></li>
                                                                    <li><code>inset</code> - Inner shadows</li>
                                                                    <li>Multiple shadows - Separate with commas</li>
                                                                    <li><code>text-shadow</code> - Shadows for text</li>
                                                                    <li>Use rgba() for transparent shadows</li>
                                                                </ul>
                                                            </div>

                                                            <jsp:include page="../tutorial-quiz.jsp">
                                                                <jsp:param name="quizId" value="quiz-shadows" />
                                                                <jsp:param name="question"
                                                                    value="Which keyword creates an inner shadow?" />
                                                                <jsp:param name="option1" value="inner" />
                                                                <jsp:param name="option2" value="inset" />
                                                                <jsp:param name="option3" value="inside" />
                                                                <jsp:param name="option4" value="internal" />
                                                                <jsp:param name="correctAnswer" value="1" />
                                                            </jsp:include>

                                                            <jsp:include page="../tutorial-nav.jsp">
                                                                <jsp:param name="prevLink" value="backgrounds.jsp" />
                                                                <jsp:param name="prevTitle" value="Backgrounds" />
                                                                <jsp:param name="nextLink" value="transforms.jsp" />
                                                                <jsp:param name="nextTitle" value="Transforms" />
                                                                <jsp:param name="currentLessonId" value="shadows" />
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