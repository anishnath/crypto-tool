<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Flexbox Advanced Lesson 16: Advanced Flexbox Properties --%>
        <% request.setAttribute("currentLesson", "flexbox-advanced" );
            request.setAttribute("currentModule", "Layout Fundamentals" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Flexbox Advanced - Flex Grow, Shrink, Wrap | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master advanced Flexbox: flex-grow, flex-shrink, flex-basis, flex-wrap, align-self, and order for complex responsive layouts.">
                <meta name="keywords"
                    content="flexbox advanced, flex-grow, flex-shrink, flex-wrap, align-self, flex-basis, CSS flexbox">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Flexbox Advanced - Complete Guide">
                <meta property="og:description" content="Master advanced Flexbox properties.">
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
        "name": "CSS Flexbox Advanced",
        "description": "Master advanced Flexbox properties",
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

            <body class="tutorial-body" data-lesson="flexbox-advanced">
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
                                        <span>Flexbox Advanced</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Flexbox Advanced</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~11 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Flex Grow</h2>
                                        <p>
                                            <code>flex-grow</code> controls how much a flex item grows relative to
                                            others. Default is 0 (no growth). Higher values = more growth.
                                        </p>

                                        <% String
                                            growHtml="<div class='container'>\n  <div class='box grow-0'>grow: 0</div>\n  <div class='box grow-1'>grow: 1</div>\n  <div class='box grow-2'>grow: 2</div>\n</div>"
                                            ; String
                                            growCss=".container {\n  display: flex;\n  background-color: #f1f5f9;\n  padding: 10px;\n  gap: 10px;\n}\n\n.box {\n  padding: 20px;\n  color: white;\n  text-align: center;\n}\n\n.grow-0 {\n  flex-grow: 0;\n  background-color: #64748b;\n}\n\n.grow-1 {\n  flex-grow: 1;\n  background-color: #3b82f6;\n}\n\n.grow-2 {\n  flex-grow: 2;\n  background-color: #10b981;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-grow" />
                                                <jsp:param name="initialHtml" value="<%=growHtml%>" />
                                                <jsp:param name="initialCss" value="<%=growCss%>" />
                                            </jsp:include>

                                            <h2>Flex Shrink</h2>
                                            <p>
                                                <code>flex-shrink</code> controls how much a flex item shrinks when
                                                space is limited. Default is 1. Set to 0 to prevent shrinking.
                                            </p>

                                            <% String
                                                shrinkHtml="<div class='container'>\n  <div class='box no-shrink'>No Shrink (0)</div>\n  <div class='box shrink'>Can Shrink (1)</div>\n  <div class='box shrink'>Can Shrink (1)</div>\n</div>"
                                                ; String
                                                shrinkCss=".container {\n  display: flex;\n  width: 400px;\n  background-color: #fef3c7;\n  padding: 10px;\n  gap: 10px;\n}\n\n.box {\n  padding: 20px;\n  color: white;\n  text-align: center;\n  min-width: 150px;\n}\n\n.no-shrink {\n  flex-shrink: 0;\n  background-color: #f59e0b;\n}\n\n.shrink {\n  flex-shrink: 1;\n  background-color: #ef4444;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-shrink" />
                                                    <jsp:param name="initialHtml" value="<%=shrinkHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=shrinkCss%>" />
                                                </jsp:include>

                                                <h2>Flex Basis</h2>
                                                <p>
                                                    <code>flex-basis</code> sets the initial size of a flex item before
                                                    growing or shrinking. Think of it as the starting width/height.
                                                </p>

                                                <% String
                                                    basisHtml="<div class='container'>\n  <div class='box basis-100'>basis: 100px</div>\n  <div class='box basis-200'>basis: 200px</div>\n  <div class='box basis-auto'>basis: auto</div>\n</div>"
                                                    ; String
                                                    basisCss=".container {\n  display: flex;\n  background-color: #e0e7ff;\n  padding: 10px;\n  gap: 10px;\n}\n\n.box {\n  padding: 20px;\n  background-color: #6366f1;\n  color: white;\n  text-align: center;\n}\n\n.basis-100 { flex-basis: 100px; }\n.basis-200 { flex-basis: 200px; }\n.basis-auto { flex-basis: auto; }"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-basis" />
                                                        <jsp:param name="initialHtml" value="<%=basisHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=basisCss%>" />
                                                    </jsp:include>

                                                    <h2>Flex Shorthand</h2>
                                                    <p>
                                                        The <code>flex</code> property combines grow, shrink, and basis:
                                                        <code>flex: grow shrink basis</code>. Common values:
                                                        <code>flex: 1</code> (grow equally), <code>flex: none</code>
                                                        (don't grow/shrink).
                                                    </p>

                                                    <% String
                                                        shorthandHtml="<div class='container'>\n  <div class='box flex-1'>flex: 1</div>\n  <div class='box flex-2'>flex: 2</div>\n  <div class='box flex-none'>flex: none</div>\n</div>"
                                                        ; String
                                                        shorthandCss=".container {\n  display: flex;\n  background-color: #f1f5f9;\n  padding: 10px;\n  gap: 10px;\n}\n\n.box {\n  padding: 20px;\n  color: white;\n  text-align: center;\n}\n\n.flex-1 {\n  flex: 1;\n  background-color: #3b82f6;\n}\n\n.flex-2 {\n  flex: 2;\n  background-color: #10b981;\n}\n\n.flex-none {\n  flex: none;\n  background-color: #64748b;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-shorthand" />
                                                            <jsp:param name="initialHtml" value="<%=shorthandHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=shorthandCss%>" />
                                                        </jsp:include>

                                                        <h2>Flex Wrap</h2>
                                                        <p>
                                                            <code>flex-wrap</code> controls whether items wrap to new
                                                            lines. Values: <code>nowrap</code> (default),
                                                            <code>wrap</code>, <code>wrap-reverse</code>.
                                                        </p>

                                                        <% String
                                                            wrapHtml="<div class='nowrap'>\n  <div class='item'>1</div>\n  <div class='item'>2</div>\n  <div class='item'>3</div>\n  <div class='item'>4</div>\n  <div class='item'>5</div>\n</div>\n<div class='wrap'>\n  <div class='item'>1</div>\n  <div class='item'>2</div>\n  <div class='item'>3</div>\n  <div class='item'>4</div>\n  <div class='item'>5</div>\n</div>"
                                                            ; String
                                                            wrapCss=".nowrap,\n.wrap {\n  display: flex;\n  background-color: #fef3c7;\n  padding: 10px;\n  margin: 10px 0;\n  gap: 10px;\n}\n\n.nowrap { flex-wrap: nowrap; }\n.wrap { flex-wrap: wrap; }\n\n.item {\n  width: 100px;\n  padding: 15px;\n  background-color: #f59e0b;\n  color: white;\n  text-align: center;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-wrap" />
                                                                <jsp:param name="initialHtml" value="<%=wrapHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=wrapCss%>" />
                                                            </jsp:include>

                                                            <h2>Align Self</h2>
                                                            <p>
                                                                <code>align-self</code> overrides
                                                                <code>align-items</code> for individual flex items.
                                                                Perfect for making one item behave differently!
                                                            </p>

                                                            <% String
                                                                alignSelfHtml="<div class='container'>\n  <div class='box'>Normal</div>\n  <div class='box self-start'>align-self: flex-start</div>\n  <div class='box self-center'>align-self: center</div>\n  <div class='box self-end'>align-self: flex-end</div>\n</div>"
                                                                ; String
                                                                alignSelfCss=".container {\n  display: flex;\n  align-items: stretch;\n  height: 200px;\n  background-color: #e0e7ff;\n  padding: 10px;\n  gap: 10px;\n}\n\n.box {\n  padding: 15px;\n  background-color: #8b5cf6;\n  color: white;\n  text-align: center;\n}\n\n.self-start { align-self: flex-start; }\n.self-center { align-self: center; }\n.self-end { align-self: flex-end; }"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId"
                                                                        value="editor-alignself" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=alignSelfHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=alignSelfCss%>" />
                                                                </jsp:include>

                                                                <h2>Order</h2>
                                                                <p>
                                                                    The <code>order</code> property changes the visual
                                                                    order of flex items without changing HTML. Default
                                                                    is 0. Lower values appear first.
                                                                </p>

                                                                <% String
                                                                    orderHtml="<div class='container'>\n  <div class='box order-3'>HTML: 1st (order: 3)</div>\n  <div class='box order-1'>HTML: 2nd (order: 1)</div>\n  <div class='box order-2'>HTML: 3rd (order: 2)</div>\n</div>"
                                                                    ; String
                                                                    orderCss=".container {\n  display: flex;\n  background-color: #f1f5f9;\n  padding: 10px;\n  gap: 10px;\n}\n\n.box {\n  padding: 20px;\n  background-color: #ec4899;\n  color: white;\n  text-align: center;\n}\n\n.order-1 { order: 1; }\n.order-2 { order: 2; }\n.order-3 { order: 3; }"
                                                                    ; %>
                                                                    <jsp:include page="../tutorial-editor.jsp">
                                                                        <jsp:param name="editorId"
                                                                            value="editor-order" />
                                                                        <jsp:param name="initialHtml"
                                                                            value="<%=orderHtml%>" />
                                                                        <jsp:param name="initialCss"
                                                                            value="<%=orderCss%>" />
                                                                    </jsp:include>

                                                                    <div class="callout callout-tip">
                                                                        <svg class="callout-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <circle cx="12" cy="12" r="10" />
                                                                            <path d="M12 16v-4M12 8h.01" />
                                                                        </svg>
                                                                        <div class="callout-content">
                                                                            <strong>Common Pattern:</strong> Use
                                                                            <code>flex: 1</code> on items to make them
                                                                            grow equally and fill available space.
                                                                            Perfect for equal-width columns!
                                                                        </div>
                                                                    </div>

                                                                    <h2>Summary</h2>
                                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                                        <ul
                                                                            style="margin: 0; padding-left: var(--space-6);">
                                                                            <li><code>flex-grow</code> - How much item
                                                                                grows (default: 0)</li>
                                                                            <li><code>flex-shrink</code> - How much item
                                                                                shrinks (default: 1)</li>
                                                                            <li><code>flex-basis</code> - Initial size
                                                                                before grow/shrink</li>
                                                                            <li><code>flex</code> - Shorthand: grow
                                                                                shrink basis</li>
                                                                            <li><code>flex-wrap</code> - Allow items to
                                                                                wrap (nowrap, wrap)</li>
                                                                            <li><code>align-self</code> - Override
                                                                                align-items for one item</li>
                                                                            <li><code>order</code> - Change visual order
                                                                                (default: 0)</li>
                                                                        </ul>
                                                                    </div>

                                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                                        <jsp:param name="quizId"
                                                                            value="quiz-flexbox-advanced" />
                                                                        <jsp:param name="question"
                                                                            value="Which property makes flex items wrap to new lines?" />
                                                                        <jsp:param name="option1" value="flex-grow" />
                                                                        <jsp:param name="option2" value="flex-wrap" />
                                                                        <jsp:param name="option3"
                                                                            value="flex-direction" />
                                                                        <jsp:param name="option4" value="align-items" />
                                                                        <jsp:param name="correctAnswer" value="1" />
                                                                    </jsp:include>

                                                                    <jsp:include page="../tutorial-nav.jsp">
                                                                        <jsp:param name="prevLink"
                                                                            value="flexbox-basics.jsp" />
                                                                        <jsp:param name="prevTitle"
                                                                            value="Flexbox Basics" />
                                                                        <jsp:param name="nextLink"
                                                                            value="grid-basics.jsp" />
                                                                        <jsp:param name="nextTitle"
                                                                            value="Grid Basics" />
                                                                        <jsp:param name="currentLessonId"
                                                                            value="flexbox-advanced" />
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