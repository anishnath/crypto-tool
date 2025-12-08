<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Display Property Lesson 12: Understanding CSS Display Property --%>
        <% request.setAttribute("currentLesson", "display" );
            request.setAttribute("currentModule", "Layout Fundamentals" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Display Property - Block, Inline, Inline-Block | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master the CSS display property: block, inline, inline-block, none, and flex. Learn how elements behave and flow in layouts.">
                <meta name="keywords"
                    content="CSS display, display block, display inline, inline-block, display none, CSS layout">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Display Property - Complete Guide">
                <meta property="og:description" content="Master the CSS display property.">
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
        "name": "CSS Display Property",
        "description": "Master the CSS display property",
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

            <body class="tutorial-body" data-lesson="display">
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
                                        <span>Display Property</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">The Display Property</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is Display?</h2>
                                        <p>
                                            The <code>display</code> property controls how an element behaves in the
                                            document flow. It's one of the most important CSS properties for layout.
                                        </p>

                                        <h2>Display: Block</h2>
                                        <p>
                                            Block elements take up the full width available and start on a new line.
                                            Examples: <code>&lt;div&gt;</code>, <code>&lt;p&gt;</code>,
                                            <code>&lt;h1&gt;</code>.
                                        </p>

                                        <% String
                                            blockHtml="<div class='block1'>Block Element 1</div>\n<div class='block2'>Block Element 2</div>\n<div class='block3'>Block Element 3</div>"
                                            ; String
                                            blockCss=".block1,\n.block2,\n.block3 {\n  display: block;\n  padding: 15px;\n  margin: 10px 0;\n  color: white;\n  text-align: center;\n}\n\n.block1 { background-color: #3b82f6; }\n.block2 { background-color: #10b981; }\n.block3 { background-color: #f59e0b; }"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-block" />
                                                <jsp:param name="initialHtml" value="<%=blockHtml%>" />
                                                <jsp:param name="initialCss" value="<%=blockCss%>" />
                                            </jsp:include>

                                            <h2>Display: Inline</h2>
                                            <p>
                                                Inline elements only take up as much width as needed and don't start on
                                                a new line. Width and height have no effect. Examples:
                                                <code>&lt;span&gt;</code>, <code>&lt;a&gt;</code>,
                                                <code>&lt;strong&gt;</code>.
                                            </p>

                                            <% String
                                                inlineHtml="<span class='inline1'>Inline 1</span>\n<span class='inline2'>Inline 2</span>\n<span class='inline3'>Inline 3</span>\n<p>These elements flow together on the same line.</p>"
                                                ; String
                                                inlineCss=".inline1,\n.inline2,\n.inline3 {\n  display: inline;\n  padding: 8px 12px;\n  color: white;\n}\n\n.inline1 { background-color: #ef4444; }\n.inline2 { background-color: #8b5cf6; }\n.inline3 { background-color: #ec4899; }"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-inline" />
                                                    <jsp:param name="initialHtml" value="<%=inlineHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=inlineCss%>" />
                                                </jsp:include>

                                                <h2>Display: Inline-Block</h2>
                                                <p>
                                                    Inline-block combines both behaviors: elements flow inline but
                                                    respect width and height. Perfect for creating horizontal layouts!
                                                </p>

                                                <% String
                                                    inlineBlockHtml="<div class='box1'>Box 1</div>\n<div class='box2'>Box 2</div>\n<div class='box3'>Box 3</div>"
                                                    ; String
                                                    inlineBlockCss=".box1,\n.box2,\n.box3 {\n  display: inline-block;\n  width: 150px;\n  height: 100px;\n  padding: 15px;\n  margin: 10px;\n  color: white;\n  text-align: center;\n  vertical-align: top;\n}\n\n.box1 { background-color: #3b82f6; }\n.box2 { background-color: #10b981; }\n.box3 { background-color: #f59e0b; }"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-inlineblock" />
                                                        <jsp:param name="initialHtml" value="<%=inlineBlockHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=inlineBlockCss%>" />
                                                    </jsp:include>

                                                    <h2>Display: None</h2>
                                                    <p>
                                                        <code>display: none</code> completely removes the element from
                                                        the page. It takes up no space.
                                                    </p>

                                                    <% String
                                                        noneHtml="<div class='visible'>I am visible</div>\n<div class='hidden'>I am hidden (display: none)</div>\n<div class='visible'>I am visible again</div>"
                                                        ; String
                                                        noneCss=".visible {\n  background-color: #3b82f6;\n  color: white;\n  padding: 15px;\n  margin: 10px 0;\n}\n\n.hidden {\n  display: none;\n  background-color: #ef4444;\n  color: white;\n  padding: 15px;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-none" />
                                                            <jsp:param name="initialHtml" value="<%=noneHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=noneCss%>" />
                                                        </jsp:include>

                                                        <h2>Changing Default Display</h2>
                                                        <p>
                                                            You can change an element's default display behavior. For
                                                            example, make a <code>&lt;span&gt;</code> behave like a
                                                            block element.
                                                        </p>

                                                        <% String
                                                            changeHtml="<span class='span-block'>I'm a span, but I behave like a block!</span>\n<div class='div-inline'>I'm a div, but I behave like inline!</div>"
                                                            ; String
                                                            changeCss=".span-block {\n  display: block;\n  background-color: #8b5cf6;\n  color: white;\n  padding: 15px;\n  margin: 10px 0;\n}\n\n.div-inline {\n  display: inline;\n  background-color: #ec4899;\n  color: white;\n  padding: 8px 12px;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-change" />
                                                                <jsp:param name="initialHtml" value="<%=changeHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=changeCss%>" />
                                                            </jsp:include>

                                                            <div class="callout callout-tip">
                                                                <svg class="callout-icon" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <path d="M12 16v-4M12 8h.01" />
                                                                </svg>
                                                                <div class="callout-content">
                                                                    <strong>Quick Reference:</strong><br>
                                                                    • <code>block</code> - Full width, new line<br>
                                                                    • <code>inline</code> - Content width, same line<br>
                                                                    • <code>inline-block</code> - Content width, same
                                                                    line, respects width/height<br>
                                                                    • <code>none</code> - Hidden, no space
                                                                </div>
                                                            </div>

                                                            <h2>Common Use Cases</h2>
                                                            <div class="card" style="margin: var(--space-6) 0;">
                                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                                    <li><strong>Navigation menus</strong> - Use
                                                                        <code>inline-block</code> for horizontal menu
                                                                        items</li>
                                                                    <li><strong>Image galleries</strong> - Use
                                                                        <code>inline-block</code> for side-by-side
                                                                        images</li>
                                                                    <li><strong>Hide elements</strong> - Use
                                                                        <code>display: none</code> for mobile menus,
                                                                        modals</li>
                                                                    <li><strong>Button groups</strong> - Use
                                                                        <code>inline-block</code> for buttons in a row
                                                                    </li>
                                                                </ul>
                                                            </div>

                                                            <jsp:include page="../tutorial-quiz.jsp">
                                                                <jsp:param name="quizId" value="quiz-display" />
                                                                <jsp:param name="question"
                                                                    value="Which display value allows elements to sit side-by-side AND respect width/height?" />
                                                                <jsp:param name="option1" value="block" />
                                                                <jsp:param name="option2" value="inline" />
                                                                <jsp:param name="option3" value="inline-block" />
                                                                <jsp:param name="option4" value="none" />
                                                                <jsp:param name="correctAnswer" value="2" />
                                                            </jsp:include>

                                                            <jsp:include page="../tutorial-nav.jsp">
                                                                <jsp:param name="prevLink" value="width-height.jsp" />
                                                                <jsp:param name="prevTitle" value="Width & Height" />
                                                                <jsp:param name="nextLink" value="position.jsp" />
                                                                <jsp:param name="nextTitle" value="Position" />
                                                                <jsp:param name="currentLessonId" value="display" />
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