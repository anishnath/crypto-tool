<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Position Property Lesson 13: CSS Positioning - Static, Relative, Absolute, Fixed, Sticky --%>
        <% request.setAttribute("currentLesson", "position" );
            request.setAttribute("currentModule", "Layout Fundamentals" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Position - Static, Relative, Absolute, Fixed, Sticky | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS positioning: static, relative, absolute, fixed, and sticky. Learn top, right, bottom, left, and z-index properties.">
                <meta name="keywords"
                    content="CSS position, position absolute, position relative, position fixed, position sticky, z-index">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Position Property - Complete Guide">
                <meta property="og:description" content="Master CSS positioning techniques.">
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
        "name": "CSS Position Property",
        "description": "Master CSS positioning techniques",
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

            <body class="tutorial-body" data-lesson="position">
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
                                        <span>Position</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Position Property</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~12 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Position: Static (Default)</h2>
                                        <p>
                                            <code>position: static</code> is the default. Elements flow normally in the
                                            document. Top, right, bottom, left have no effect.
                                        </p>

                                        <% String
                                            staticHtml="<div class='box static'>Static (default)</div>\n<div class='box static'>Another static box</div>"
                                            ; String
                                            staticCss=".box {\n  padding: 20px;\n  margin: 10px 0;\n  background-color: #3b82f6;\n  color: white;\n}\n\n.static {\n  position: static;\n  /* top, left have no effect */\n  top: 50px;\n  left: 50px;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-static" />
                                                <jsp:param name="initialHtml" value="<%=staticHtml%>" />
                                                <jsp:param name="initialCss" value="<%=staticCss%>" />
                                            </jsp:include>

                                            <h2>Position: Relative</h2>
                                            <p>
                                                <code>position: relative</code> allows you to move an element from its
                                                normal position using top, right, bottom, left. The original space is
                                                preserved.
                                            </p>

                                            <% String
                                                relativeHtml="<div class='box'>Box 1</div>\n<div class='box relative'>Box 2 (moved 20px down, 30px right)</div>\n<div class='box'>Box 3</div>"
                                                ; String
                                                relativeCss=".box {\n  padding: 20px;\n  margin: 10px 0;\n  background-color: #10b981;\n  color: white;\n}\n\n.relative {\n  position: relative;\n  top: 20px;\n  left: 30px;\n  background-color: #f59e0b;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-relative" />
                                                    <jsp:param name="initialHtml" value="<%=relativeHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=relativeCss%>" />
                                                </jsp:include>

                                                <h2>Position: Absolute</h2>
                                                <p>
                                                    <code>position: absolute</code> removes the element from normal flow
                                                    and positions it relative to its nearest positioned ancestor (or the
                                                    viewport if none exists).
                                                </p>

                                                <% String
                                                    absoluteHtml="<div class='container'>\n  <div class='box'>Normal box</div>\n  <div class='box absolute'>Absolute (top-right corner)</div>\n  <div class='box'>Another normal box</div>\n</div>"
                                                    ; String
                                                    absoluteCss=".container {\n  position: relative;\n  background-color: #f1f5f9;\n  padding: 20px;\n  min-height: 200px;\n}\n\n.box {\n  padding: 15px;\n  margin: 10px 0;\n  background-color: #3b82f6;\n  color: white;\n}\n\n.absolute {\n  position: absolute;\n  top: 10px;\n  right: 10px;\n  background-color: #ef4444;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-absolute" />
                                                        <jsp:param name="initialHtml" value="<%=absoluteHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=absoluteCss%>" />
                                                    </jsp:include>

                                                    <h2>Position: Fixed</h2>
                                                    <p>
                                                        <code>position: fixed</code> positions the element relative to
                                                        the viewport. It stays in place even when scrolling.
                                                    </p>

                                                    <% String
                                                        fixedHtml="<div class='fixed-box'>I'm fixed to the top-right!</div>\n<p>Scroll down to see the fixed element stay in place...</p>\n<p>More content...</p>\n<p>Even more content...</p>"
                                                        ; String
                                                        fixedCss=".fixed-box {\n  position: fixed;\n  top: 10px;\n  right: 10px;\n  padding: 15px;\n  background-color: #8b5cf6;\n  color: white;\n  border-radius: 8px;\n  box-shadow: 0 4px 6px rgba(0,0,0,0.1);\n}\n\np {\n  margin: 20px 0;\n  padding: 20px;\n  background-color: #f1f5f9;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-fixed" />
                                                            <jsp:param name="initialHtml" value="<%=fixedHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=fixedCss%>" />
                                                        </jsp:include>

                                                        <h2>Position: Sticky</h2>
                                                        <p>
                                                            <code>position: sticky</code> toggles between relative and
                                                            fixed based on scroll position. Perfect for sticky headers!
                                                        </p>

                                                        <% String
                                                            stickyHtml="<div class='sticky-header'>I stick to the top when you scroll!</div>\n<p>Content before...</p>\n<p>More content...</p>\n<p>Keep scrolling...</p>\n<p>Even more content...</p>"
                                                            ; String
                                                            stickyCss=".sticky-header {\n  position: sticky;\n  top: 0;\n  padding: 15px;\n  background-color: #ec4899;\n  color: white;\n  font-weight: 600;\n  text-align: center;\n  box-shadow: 0 2px 4px rgba(0,0,0,0.1);\n}\n\np {\n  margin: 20px 0;\n  padding: 30px;\n  background-color: #fef3c7;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-sticky" />
                                                                <jsp:param name="initialHtml" value="<%=stickyHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=stickyCss%>" />
                                                            </jsp:include>

                                                            <h2>Z-Index (Stacking Order)</h2>
                                                            <p>
                                                                The <code>z-index</code> property controls which
                                                                elements appear on top. Higher values = closer to
                                                                viewer. Only works on positioned elements.
                                                            </p>

                                                            <% String
                                                                zindexHtml="<div class='container-z'>\n  <div class='box-z box1'>Z-index: 1</div>\n  <div class='box-z box2'>Z-index: 3 (on top)</div>\n  <div class='box-z box3'>Z-index: 2</div>\n</div>"
                                                                ; String
                                                                zindexCss=".container-z {\n  position: relative;\n  height: 250px;\n}\n\n.box-z {\n  position: absolute;\n  width: 150px;\n  height: 150px;\n  padding: 20px;\n  color: white;\n  font-weight: 600;\n}\n\n.box1 {\n  top: 20px;\n  left: 20px;\n  background-color: #3b82f6;\n  z-index: 1;\n}\n\n.box2 {\n  top: 60px;\n  left: 60px;\n  background-color: #ef4444;\n  z-index: 3;\n}\n\n.box3 {\n  top: 100px;\n  left: 100px;\n  background-color: #10b981;\n  z-index: 2;\n}"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId" value="editor-zindex" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=zindexHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=zindexCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-important">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Key Concept:</strong> For
                                                                        <code>position: absolute</code> to work relative
                                                                        to a parent, that parent must have
                                                                        <code>position: relative</code> (or
                                                                        absolute/fixed).
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>static</code> - Default, normal flow
                                                                        </li>
                                                                        <li><code>relative</code> - Offset from normal
                                                                            position, space preserved</li>
                                                                        <li><code>absolute</code> - Removed from flow,
                                                                            positioned relative to parent</li>
                                                                        <li><code>fixed</code> - Positioned relative to
                                                                            viewport, stays on scroll</li>
                                                                        <li><code>sticky</code> - Relative until scroll
                                                                            threshold, then fixed</li>
                                                                        <li><code>z-index</code> - Controls stacking
                                                                            order (higher = on top)</li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId" value="quiz-position" />
                                                                    <jsp:param name="question"
                                                                        value="Which position value keeps an element in place when scrolling?" />
                                                                    <jsp:param name="option1" value="relative" />
                                                                    <jsp:param name="option2" value="absolute" />
                                                                    <jsp:param name="option3" value="fixed" />
                                                                    <jsp:param name="option4" value="static" />
                                                                    <jsp:param name="correctAnswer" value="2" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink" value="display.jsp" />
                                                                    <jsp:param name="prevTitle"
                                                                        value="Display Property" />
                                                                    <jsp:param name="nextLink"
                                                                        value="float-clear.jsp" />
                                                                    <jsp:param name="nextTitle" value="Float & Clear" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="position" />
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