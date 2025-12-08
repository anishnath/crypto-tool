<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Transforms Lesson 23: CSS 2D Transforms --%>
        <% request.setAttribute("currentLesson", "transforms" );
            request.setAttribute("currentModule", "Styling Elements" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Transforms - Rotate, Scale, Translate, Skew | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS transforms: rotate, scale, translate, skew elements. Learn transform-origin and combining multiple transforms.">
                <meta name="keywords" content="CSS transform, rotate, scale, translate, skew, transform-origin">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Transforms Complete Guide">
                <meta property="og:description" content="Master CSS 2D transforms.">
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
        "name": "CSS Transforms",
        "description": "Master CSS 2D transforms",
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

            <body class="tutorial-body" data-lesson="transforms">
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
                                        <span>Transforms</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Transforms</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~9 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Rotate</h2>
                                        <p>
                                            <code>rotate()</code> rotates elements by a specified angle. Use degrees
                                            (deg) or turns.
                                        </p>

                                        <% String
                                            rotateHtml="<div class='box rotate-45'>rotate(45deg)</div>\n<div class='box rotate-90'>rotate(90deg)</div>\n<div class='box rotate-180'>rotate(180deg)</div>"
                                            ; String
                                            rotateCss=".box {\n  width: 120px;\n  padding: 30px;\n  margin: 40px;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n  display: inline-block;\n}\n\n.rotate-45 { transform: rotate(45deg); }\n.rotate-90 { transform: rotate(90deg); }\n.rotate-180 { transform: rotate(180deg); }"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-rotate" />
                                                <jsp:param name="initialHtml" value="<%=rotateHtml%>" />
                                                <jsp:param name="initialCss" value="<%=rotateCss%>" />
                                            </jsp:include>

                                            <h2>Scale</h2>
                                            <p>
                                                <code>scale()</code> resizes elements. Values > 1 enlarge, < 1 shrink.
                                                    Use <code>scaleX()</code> or <code>scaleY()</code> for one axis.
                                            </p>

                                            <% String
                                                scaleHtml="<div class='box scale-small'>scale(0.5)</div>\n<div class='box scale-normal'>scale(1)</div>\n<div class='box scale-large'>scale(1.5)</div>"
                                                ; String
                                                scaleCss=".box {\n  width: 80px;\n  padding: 20px;\n  margin: 30px;\n  background-color: #10b981;\n  color: white;\n  text-align: center;\n  display: inline-block;\n}\n\n.scale-small { transform: scale(0.5); }\n.scale-normal { transform: scale(1); }\n.scale-large { transform: scale(1.5); }"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-scale" />
                                                    <jsp:param name="initialHtml" value="<%=scaleHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=scaleCss%>" />
                                                </jsp:include>

                                                <h2>Translate</h2>
                                                <p>
                                                    <code>translate()</code> moves elements from their current position.
                                                    Use px, %, or other units.
                                                </p>

                                                <% String
                                                    translateHtml="<div class='container'>\n  <div class='box original'>Original</div>\n  <div class='box moved-right'>translateX(50px)</div>\n  <div class='box moved-down'>translateY(30px)</div>\n  <div class='box moved-both'>translate(30px, 30px)</div>\n</div>"
                                                    ; String
                                                    translateCss=".container {\n  position: relative;\n  background-color: #fef3c7;\n  padding: 20px;\n  min-height: 200px;\n}\n\n.box {\n  width: 100px;\n  padding: 15px;\n  margin: 10px;\n  background-color: #f59e0b;\n  color: white;\n  text-align: center;\n}\n\n.moved-right { transform: translateX(50px); }\n.moved-down { transform: translateY(30px); }\n.moved-both { transform: translate(30px, 30px); }"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-translate" />
                                                        <jsp:param name="initialHtml" value="<%=translateHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=translateCss%>" />
                                                    </jsp:include>

                                                    <h2>Skew</h2>
                                                    <p>
                                                        <code>skew()</code> tilts elements along the X or Y axis,
                                                        creating a slanted effect.
                                                    </p>

                                                    <% String
                                                        skewHtml="<div class='box skew-x'>skewX(20deg)</div>\n<div class='box skew-y'>skewY(20deg)</div>\n<div class='box skew-both'>skew(10deg, 10deg)</div>"
                                                        ; String
                                                        skewCss=".box {\n  width: 120px;\n  padding: 30px;\n  margin: 30px;\n  background-color: #8b5cf6;\n  color: white;\n  text-align: center;\n  display: inline-block;\n}\n\n.skew-x { transform: skewX(20deg); }\n.skew-y { transform: skewY(20deg); }\n.skew-both { transform: skew(10deg, 10deg); }"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-skew" />
                                                            <jsp:param name="initialHtml" value="<%=skewHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=skewCss%>" />
                                                        </jsp:include>

                                                        <h2>Combining Transforms</h2>
                                                        <p>
                                                            Chain multiple transforms in one <code>transform</code>
                                                            property. Order matters!
                                                        </p>

                                                        <% String
                                                            combineHtml="<div class='box combo1'>rotate + scale</div>\n<div class='box combo2'>translate + rotate</div>\n<div class='box combo3'>All combined!</div>"
                                                            ; String
                                                            combineCss=".box {\n  width: 100px;\n  padding: 20px;\n  margin: 40px;\n  background-color: #ef4444;\n  color: white;\n  text-align: center;\n  display: inline-block;\n}\n\n.combo1 {\n  transform: rotate(15deg) scale(1.2);\n}\n\n.combo2 {\n  transform: translate(20px, 10px) rotate(-10deg);\n}\n\n.combo3 {\n  transform: rotate(20deg) scale(1.1) translateY(-10px);\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-combine" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=combineHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=combineCss%>" />
                                                            </jsp:include>

                                                            <h2>Transform Origin</h2>
                                                            <p>
                                                                <code>transform-origin</code> changes the pivot point
                                                                for transforms. Default is center.
                                                            </p>

                                                            <% String
                                                                originHtml="<div class='box origin-center'>center (default)</div>\n<div class='box origin-left'>top left</div>\n<div class='box origin-right'>bottom right</div>"
                                                                ; String
                                                                originCss=".box {\n  width: 100px;\n  padding: 20px;\n  margin: 40px;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n  display: inline-block;\n  transform: rotate(30deg);\n}\n\n.origin-center { transform-origin: center; }\n.origin-left { transform-origin: top left; }\n.origin-right { transform-origin: bottom right; }"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId" value="editor-origin" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=originHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=originCss%>" />
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
                                                                        <code>translate(-50%, -50%)</code> with
                                                                        <code>position: absolute; top: 50%; left: 50%;</code>
                                                                        to perfectly center elements!
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>rotate(angle)</code> - Rotate element
                                                                        </li>
                                                                        <li><code>scale(x, y)</code> - Resize element
                                                                        </li>
                                                                        <li><code>translate(x, y)</code> - Move element
                                                                        </li>
                                                                        <li><code>skew(x, y)</code> - Slant element</li>
                                                                        <li>Chain transforms:
                                                                            <code>transform: rotate() scale()</code>
                                                                        </li>
                                                                        <li><code>transform-origin</code> - Change pivot
                                                                            point</li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId" value="quiz-transforms" />
                                                                    <jsp:param name="question"
                                                                        value="Which transform function moves an element?" />
                                                                    <jsp:param name="option1" value="move()" />
                                                                    <jsp:param name="option2" value="translate()" />
                                                                    <jsp:param name="option3" value="shift()" />
                                                                    <jsp:param name="option4" value="position()" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink" value="shadows.jsp" />
                                                                    <jsp:param name="prevTitle" value="Shadows" />
                                                                    <jsp:param name="nextLink"
                                                                        value="transitions.jsp" />
                                                                    <jsp:param name="nextTitle" value="Transitions" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="transforms" />
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