<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Width & Height Lesson 11: Controlling Element Dimensions --%>
        <% request.setAttribute("currentLesson", "width-height" ); request.setAttribute("currentModule", "Box Model" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Width & Height - Sizing Elements | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn CSS width and height properties: fixed sizes, percentages, min/max values, and responsive sizing techniques.">
                <meta name="keywords"
                    content="CSS width, CSS height, min-width, max-width, min-height, max-height, responsive sizing">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Width & Height - Complete Guide">
                <meta property="og:description" content="Master CSS width and height properties.">
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
        "name": "CSS Width & Height",
        "description": "Master CSS width and height properties",
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

            <body class="tutorial-body" data-lesson="width-height">
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
                                        <span>Width & Height</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Width & Height</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Fixed Dimensions</h2>
                                        <p>
                                            Use <code>width</code> and <code>height</code> to set exact dimensions in
                                            pixels, ems, or other units.
                                        </p>

                                        <% String
                                            fixedHtml="<div class='small'>200px × 100px</div>\n<div class='medium'>300px × 150px</div>\n<div class='large'>400px × 200px</div>"
                                            ; String
                                            fixedCss="div {\n  background-color: #3b82f6;\n  color: white;\n  margin: 10px 0;\n  padding: 10px;\n  display: flex;\n  align-items: center;\n  justify-content: center;\n}\n\n.small {\n  width: 200px;\n  height: 100px;\n}\n\n.medium {\n  width: 300px;\n  height: 150px;\n}\n\n.large {\n  width: 400px;\n  height: 200px;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-fixed" />
                                                <jsp:param name="initialHtml" value="<%=fixedHtml%>" />
                                                <jsp:param name="initialCss" value="<%=fixedCss%>" />
                                            </jsp:include>

                                            <h2>Percentage Widths</h2>
                                            <p>
                                                Percentages are relative to the parent element's width. Great for
                                                responsive designs!
                                            </p>

                                            <% String
                                                percentHtml="<div class='container'>\n  <div class='half'>50% width</div>\n  <div class='third'>33.33% width</div>\n  <div class='quarter'>25% width</div>\n</div>"
                                                ; String
                                                percentCss=".container {\n  background-color: #f1f5f9;\n  padding: 10px;\n}\n\n.half,\n.third,\n.quarter {\n  background-color: #10b981;\n  color: white;\n  padding: 15px;\n  margin: 10px 0;\n  text-align: center;\n}\n\n.half { width: 50%; }\n.third { width: 33.33%; }\n.quarter { width: 25%; }"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-percent" />
                                                    <jsp:param name="initialHtml" value="<%=percentHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=percentCss%>" />
                                                </jsp:include>

                                                <h2>Min and Max Width</h2>
                                                <p>
                                                    <code>min-width</code> and <code>max-width</code> set boundaries for
                                                    responsive elements. The element can grow or shrink within these
                                                    limits.
                                                </p>

                                                <% String
                                                    minMaxHtml="<div class='responsive'>Resize the preview to see me adapt! I have min-width: 200px and max-width: 600px.</div>"
                                                    ; String
                                                    minMaxCss=".responsive {\n  min-width: 200px;\n  max-width: 600px;\n  width: 100%;\n  background-color: #f59e0b;\n  color: white;\n  padding: 20px;\n  margin: 20px auto;\n  text-align: center;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-minmax" />
                                                        <jsp:param name="initialHtml" value="<%=minMaxHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=minMaxCss%>" />
                                                    </jsp:include>

                                                    <h2>Min and Max Height</h2>
                                                    <p>
                                                        Similarly, <code>min-height</code> and <code>max-height</code>
                                                        control vertical boundaries.
                                                    </p>

                                                    <% String
                                                        heightHtml="<div class='min-height'>I have min-height: 150px. Add more text to see me grow!</div>\n<div class='max-height'>I have max-height: 100px. This text will overflow if it's too long. You can add overflow: auto to make it scrollable.</div>"
                                                        ; String
                                                        heightCss=".min-height {\n  min-height: 150px;\n  background-color: #8b5cf6;\n  color: white;\n  padding: 15px;\n  margin-bottom: 20px;\n}\n\n.max-height {\n  max-height: 100px;\n  background-color: #ec4899;\n  color: white;\n  padding: 15px;\n  overflow: auto;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-height" />
                                                            <jsp:param name="initialHtml" value="<%=heightHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=heightCss%>" />
                                                        </jsp:include>

                                                        <h2>Auto and 100%</h2>
                                                        <p>
                                                            <code>width: auto</code> (default) sizes based on content.
                                                            <code>width: 100%</code> fills the parent container.
                                                        </p>

                                                        <% String
                                                            autoHtml="<div class='auto'>width: auto (fits content)</div>\n<div class='full'>width: 100% (fills container)</div>"
                                                            ; String
                                                            autoCss=".auto {\n  width: auto;\n  background-color: #3b82f6;\n  color: white;\n  padding: 15px;\n  margin-bottom: 10px;\n  display: inline-block;\n}\n\n.full {\n  width: 100%;\n  background-color: #10b981;\n  color: white;\n  padding: 15px;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-auto" />
                                                                <jsp:param name="initialHtml" value="<%=autoHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=autoCss%>" />
                                                            </jsp:include>

                                                            <div class="callout callout-tip">
                                                                <svg class="callout-icon" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <path d="M12 16v-4M12 8h.01" />
                                                                </svg>
                                                                <div class="callout-content">
                                                                    <strong>Responsive Design:</strong> Use
                                                                    <code>max-width: 100%</code> on images to prevent
                                                                    them from overflowing their containers on small
                                                                    screens.
                                                                </div>
                                                            </div>

                                                            <h2>Summary</h2>
                                                            <div class="card" style="margin: var(--space-6) 0;">
                                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                                    <li><code>width</code> / <code>height</code> - Set
                                                                        exact dimensions</li>
                                                                    <li>Use <code>%</code> for responsive, fluid layouts
                                                                    </li>
                                                                    <li><code>min-width</code> / <code>max-width</code>
                                                                        - Set size boundaries</li>
                                                                    <li><code>min-height</code> /
                                                                        <code>max-height</code> - Control vertical
                                                                        limits</li>
                                                                    <li><code>width: 100%</code> - Fill parent container
                                                                    </li>
                                                                    <li><code>width: auto</code> - Size based on content
                                                                        (default)</li>
                                                                </ul>
                                                            </div>

                                                            <jsp:include page="../tutorial-quiz.jsp">
                                                                <jsp:param name="quizId" value="quiz-width-height" />
                                                                <jsp:param name="question"
                                                                    value="Which property prevents an element from growing beyond 800px wide?" />
                                                                <jsp:param name="option1" value="width: 800px;" />
                                                                <jsp:param name="option2" value="min-width: 800px;" />
                                                                <jsp:param name="option3" value="max-width: 800px;" />
                                                                <jsp:param name="option4" value="width: 100%;" />
                                                                <jsp:param name="correctAnswer" value="2" />
                                                            </jsp:include>

                                                            <jsp:include page="../tutorial-nav.jsp">
                                                                <jsp:param name="prevLink" value="padding-margin.jsp" />
                                                                <jsp:param name="prevTitle" value="Padding & Margin" />
                                                                <jsp:param name="nextLink" value="display.jsp" />
                                                                <jsp:param name="nextTitle" value="Display Property" />
                                                                <jsp:param name="currentLessonId"
                                                                    value="width-height" />
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