<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Float & Clear Lesson 14: CSS Float and Clear Properties --%>
        <% request.setAttribute("currentLesson", "float-clear" );
            request.setAttribute("currentModule", "Layout Fundamentals" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Float & Clear - Text Wrapping & Layouts | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn CSS float and clear properties for text wrapping and layouts. Understand clearfix and when to use float vs flexbox.">
                <meta name="keywords" content="CSS float, float left, float right, clear both, clearfix, CSS layout">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Float & Clear - Complete Guide">
                <meta property="og:description" content="Master CSS float and clear properties.">
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
        "name": "CSS Float & Clear",
        "description": "Master CSS float and clear properties",
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

            <body class="tutorial-body" data-lesson="float-clear">
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
                                        <span>Float & Clear</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Float & Clear</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is Float?</h2>
                                        <p>
                                            The <code>float</code> property removes an element from normal flow and
                                            pushes it to the left or right, allowing text to wrap around it. Originally
                                            designed for magazine-style layouts.
                                        </p>

                                        <h2>Float Left</h2>
                                        <p>
                                            <code>float: left</code> pushes the element to the left side, with content
                                            wrapping around the right.
                                        </p>

                                        <% String
                                            floatLeftHtml="<div class='box float-left'>Floated Left</div>\n<p>This text wraps around the floated element. Lorem ipsum dolor sit amet, consectetur adipiscing elit. The floated box is pushed to the left side.</p>"
                                            ; String
                                            floatLeftCss=".box {\n  width: 150px;\n  padding: 20px;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n}\n\n.float-left {\n  float: left;\n  margin-right: 15px;\n  margin-bottom: 10px;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-floatleft" />
                                                <jsp:param name="initialHtml" value="<%=floatLeftHtml%>" />
                                                <jsp:param name="initialCss" value="<%=floatLeftCss%>" />
                                            </jsp:include>

                                            <h2>Float Right</h2>
                                            <p>
                                                <code>float: right</code> pushes the element to the right side, with
                                                content wrapping around the left.
                                            </p>

                                            <% String
                                                floatRightHtml="<div class='box float-right'>Floated Right</div>\n<p>This text wraps around the floated element on the right. Lorem ipsum dolor sit amet, consectetur adipiscing elit. The floated box is pushed to the right side.</p>"
                                                ; String
                                                floatRightCss=".box {\n  width: 150px;\n  padding: 20px;\n  background-color: #10b981;\n  color: white;\n  text-align: center;\n}\n\n.float-right {\n  float: right;\n  margin-left: 15px;\n  margin-bottom: 10px;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-floatright" />
                                                    <jsp:param name="initialHtml" value="<%=floatRightHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=floatRightCss%>" />
                                                </jsp:include>

                                                <h2>Multiple Floats</h2>
                                                <p>
                                                    Multiple floated elements stack horizontally until they run out of
                                                    space, then wrap to the next line.
                                                </p>

                                                <% String
                                                    multiFloatHtml="<div class='item'>Item 1</div>\n<div class='item'>Item 2</div>\n<div class='item'>Item 3</div>\n<div class='item'>Item 4</div>"
                                                    ; String
                                                    multiFloatCss=".item {\n  float: left;\n  width: 100px;\n  padding: 15px;\n  margin: 10px;\n  background-color: #f59e0b;\n  color: white;\n  text-align: center;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-multi" />
                                                        <jsp:param name="initialHtml" value="<%=multiFloatHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=multiFloatCss%>" />
                                                    </jsp:include>

                                                    <h2>The Clear Property</h2>
                                                    <p>
                                                        <code>clear</code> prevents an element from wrapping around
                                                        floated elements. Values: <code>left</code>, <code>right</code>,
                                                        <code>both</code>, <code>none</code>.
                                                    </p>

                                                    <% String
                                                        clearHtml="<div class='box float-left'>Floated</div>\n<p>This wraps around the float.</p>\n<p class='cleared'>This does NOT wrap (clear: both)</p>"
                                                        ; String
                                                        clearCss=".box {\n  width: 120px;\n  padding: 15px;\n  background-color: #8b5cf6;\n  color: white;\n}\n\n.float-left {\n  float: left;\n  margin-right: 15px;\n}\n\n.cleared {\n  clear: both;\n  background-color: #fef3c7;\n  padding: 10px;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-clear" />
                                                            <jsp:param name="initialHtml" value="<%=clearHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=clearCss%>" />
                                                        </jsp:include>

                                                        <h2>Clearfix Technique</h2>
                                                        <p>
                                                            When all children are floated, the parent collapses to zero
                                                            height. The clearfix hack solves this problem.
                                                        </p>

                                                        <% String
                                                            clearfixHtml="<div class='container clearfix'>\n  <div class='box'>Float 1</div>\n  <div class='box'>Float 2</div>\n</div>\n<p>Content after container</p>"
                                                            ; String
                                                            clearfixCss=".container {\n  background-color: #e0e7ff;\n  border: 2px solid #3b82f6;\n  padding: 10px;\n}\n\n.clearfix::after {\n  content: '';\n  display: table;\n  clear: both;\n}\n\n.box {\n  float: left;\n  width: 100px;\n  padding: 15px;\n  margin: 10px;\n  background-color: #3b82f6;\n  color: white;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-clearfix" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=clearfixHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=clearfixCss%>" />
                                                            </jsp:include>

                                                            <div class="callout callout-warning">
                                                                <svg class="callout-icon" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                                                                    <line x1="12" y1="9" x2="12" y2="13" />
                                                                    <line x1="12" y1="17" x2="12.01" y2="17" />
                                                                </svg>
                                                                <div class="callout-content">
                                                                    <strong>Modern Alternative:</strong> Float is mostly
                                                                    replaced by Flexbox and Grid for layouts. Use float
                                                                    primarily for text wrapping around images.
                                                                </div>
                                                            </div>

                                                            <h2>Summary</h2>
                                                            <div class="card" style="margin: var(--space-6) 0;">
                                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                                    <li><code>float: left</code> - Push element left,
                                                                        content wraps right</li>
                                                                    <li><code>float: right</code> - Push element right,
                                                                        content wraps left</li>
                                                                    <li><code>clear: both</code> - Prevent wrapping
                                                                        around floats</li>
                                                                    <li>Clearfix prevents parent collapse when all
                                                                        children float</li>
                                                                    <li>Best for: Images with text wrapping</li>
                                                                    <li>For layouts: Use Flexbox or Grid instead</li>
                                                                </ul>
                                                            </div>

                                                            <jsp:include page="../tutorial-quiz.jsp">
                                                                <jsp:param name="quizId" value="quiz-float" />
                                                                <jsp:param name="question"
                                                                    value="Which property prevents an element from wrapping around floated elements?" />
                                                                <jsp:param name="option1" value="float: none" />
                                                                <jsp:param name="option2" value="clear: both" />
                                                                <jsp:param name="option3" value="display: block" />
                                                                <jsp:param name="option4" value="position: static" />
                                                                <jsp:param name="correctAnswer" value="1" />
                                                            </jsp:include>

                                                            <jsp:include page="../tutorial-nav.jsp">
                                                                <jsp:param name="prevLink" value="position.jsp" />
                                                                <jsp:param name="prevTitle" value="Position" />
                                                                <jsp:param name="nextLink" value="flexbox-basics.jsp" />
                                                                <jsp:param name="nextTitle" value="Flexbox Basics" />
                                                                <jsp:param name="currentLessonId" value="float-clear" />
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