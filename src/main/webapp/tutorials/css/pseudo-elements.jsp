<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Pseudo Elements Lesson 27: CSS Pseudo Elements --%>
        <% request.setAttribute("currentLesson", "pseudo-elements" );
            request.setAttribute("currentModule", "Advanced Selectors" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Pseudo Elements - Before, After, First-letter | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS pseudo-elements: ::before, ::after, ::first-letter, ::first-line for adding decorative content and styling.">
                <meta name="keywords"
                    content="CSS pseudo-elements, before, after, first-letter, first-line, CSS content">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Pseudo Elements Guide">
                <meta property="og:description" content="Master CSS pseudo-elements.">
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
        "name": "CSS Pseudo Elements",
        "description": "Master CSS pseudo-elements",
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

            <body class="tutorial-body" data-lesson="pseudo-elements">
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
                                        <span>Pseudo Elements</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Pseudo Elements</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~9 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Pseudo Elements?</h2>
                                        <p>
                                            Pseudo-elements style specific parts of an element or insert content. They
                                            use double colons <code>::</code> (single colon also works for legacy
                                            support).
                                        </p>

                                        <h2>Before & After</h2>
                                        <p>
                                            <code>::before</code> and <code>::after</code> insert content before or
                                            after an element. Requires the <code>content</code> property!
                                        </p>

                                        <% String
                                            beforeAfterHtml="<div class='quote'>This is a beautiful quote that will be decorated with pseudo-elements.</div>"
                                            ; String
                                            beforeAfterCss=".quote {\n  padding: 30px;\n  background-color: #f1f5f9;\n  font-size: 18px;\n  font-style: italic;\n  position: relative;\n}\n\n.quote::before {\n  content: '\\201C';\n  font-size: 60px;\n  color: #3b82f6;\n  position: absolute;\n  top: 10px;\n  left: 10px;\n}\n\n.quote::after {\n  content: '\\201D';\n  font-size: 60px;\n  color: #3b82f6;\n  position: absolute;\n  bottom: -10px;\n  right: 10px;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-before-after" />
                                                <jsp:param name="initialHtml" value="<%=beforeAfterHtml%>" />
                                                <jsp:param name="initialCss" value="<%=beforeAfterCss%>" />
                                            </jsp:include>

                                            <h2>Decorative Icons</h2>
                                            <p>
                                                Use <code>::before</code> to add icons or decorative elements without
                                                cluttering HTML.
                                            </p>

                                            <% String
                                                iconsHtml="<ul class='list'>\n  <li class='check'>Completed task</li>\n  <li class='check'>Another done</li>\n  <li class='arrow'>Next step</li>\n</ul>"
                                                ; String
                                                iconsCss=".list {\n  list-style: none;\n  padding: 0;\n}\n\n.list li {\n  padding: 12px 12px 12px 35px;\n  margin: 8px 0;\n  background-color: #f1f5f9;\n  position: relative;\n}\n\n.check::before {\n  content: '\\2713';\n  position: absolute;\n  left: 12px;\n  color: #10b981;\n  font-weight: bold;\n  font-size: 18px;\n}\n\n.arrow::before {\n  content: '\\2192';\n  position: absolute;\n  left: 12px;\n  color: #3b82f6;\n  font-weight: bold;\n  font-size: 18px;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-icons" />
                                                    <jsp:param name="initialHtml" value="<%=iconsHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=iconsCss%>" />
                                                </jsp:include>

                                                <h2>First Letter</h2>
                                                <p>
                                                    <code>::first-letter</code> styles the first letter of a block
                                                    element. Perfect for drop caps!
                                                </p>

                                                <% String
                                                    firstLetterHtml="<p class='dropcap'>Once upon a time, in a land far away, there lived a developer who loved CSS. They spent their days crafting beautiful websites with elegant typography and stunning layouts.</p>"
                                                    ; String
                                                    firstLetterCss=".dropcap::first-letter {\n  font-size: 60px;\n  font-weight: bold;\n  color: #3b82f6;\n  float: left;\n  line-height: 1;\n  margin-right: 8px;\n}\n\n.dropcap {\n  font-size: 16px;\n  line-height: 1.6;\n  color: #1e293b;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-first-letter" />
                                                        <jsp:param name="initialHtml" value="<%=firstLetterHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=firstLetterCss%>" />
                                                    </jsp:include>

                                                    <h2>First Line</h2>
                                                    <p>
                                                        <code>::first-line</code> styles the first line of text in a
                                                        block element.
                                                    </p>

                                                    <% String
                                                        firstLineHtml="<p class='intro'>This is the first line that will be styled differently. The rest of the paragraph will have normal styling and will wrap to multiple lines as needed.</p>"
                                                        ; String
                                                        firstLineCss=".intro::first-line {\n  font-weight: bold;\n  color: #3b82f6;\n  font-size: 20px;\n  text-transform: uppercase;\n  letter-spacing: 1px;\n}\n\n.intro {\n  font-size: 16px;\n  line-height: 1.6;\n  color: #475569;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-first-line" />
                                                            <jsp:param name="initialHtml" value="<%=firstLineHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=firstLineCss%>" />
                                                        </jsp:include>

                                                        <h2>Clearfix with After</h2>
                                                        <p>
                                                            A classic use of <code>::after</code> is the clearfix hack
                                                            for containing floated elements.
                                                        </p>

                                                        <% String
                                                            clearfixHtml="<div class='container'>\n  <div class='float-left'>Float Left</div>\n  <div class='float-right'>Float Right</div>\n</div>\n<div class='next'>This stays below</div>"
                                                            ; String
                                                            clearfixCss=".container::after {\n  content: '';\n  display: table;\n  clear: both;\n}\n\n.container {\n  background-color: #fef3c7;\n  padding: 10px;\n  margin-bottom: 10px;\n}\n\n.float-left,\n.float-right {\n  padding: 20px;\n  background-color: #f59e0b;\n  color: white;\n}\n\n.float-left { float: left; }\n.float-right { float: right; }\n\n.next {\n  padding: 20px;\n  background-color: #10b981;\n  color: white;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-clearfix" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=clearfixHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=clearfixCss%>" />
                                                            </jsp:include>

                                                            <div class="callout callout-important">
                                                                <svg class="callout-icon" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <path d="M12 16v-4M12 8h.01" />
                                                                </svg>
                                                                <div class="callout-content">
                                                                    <strong>Important:</strong> <code>::before</code>
                                                                    and <code>::after</code> MUST have a
                                                                    <code>content</code> property, even if it's empty:
                                                                    <code>content: '';</code>
                                                                </div>
                                                            </div>

                                                            <h2>Summary</h2>
                                                            <div class="card" style="margin: var(--space-6) 0;">
                                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                                    <li><code>::before</code> - Insert content before
                                                                        element</li>
                                                                    <li><code>::after</code> - Insert content after
                                                                        element</li>
                                                                    <li><code>::first-letter</code> - Style first letter
                                                                    </li>
                                                                    <li><code>::first-line</code> - Style first line
                                                                    </li>
                                                                    <li><code>content</code> property is required for
                                                                        ::before/::after</li>
                                                                    <li>Use for decorative elements, not essential
                                                                        content</li>
                                                                </ul>
                                                            </div>

                                                            <jsp:include page="../tutorial-quiz.jsp">
                                                                <jsp:param name="quizId" value="quiz-pseudo-elements" />
                                                                <jsp:param name="question"
                                                                    value="Which property is required for ::before and ::after?" />
                                                                <jsp:param name="option1" value="display" />
                                                                <jsp:param name="option2" value="content" />
                                                                <jsp:param name="option3" value="position" />
                                                                <jsp:param name="option4" value="text" />
                                                                <jsp:param name="correctAnswer" value="1" />
                                                            </jsp:include>

                                                            <jsp:include page="../tutorial-nav.jsp">
                                                                <jsp:param name="prevLink" value="pseudo-classes.jsp" />
                                                                <jsp:param name="prevTitle" value="Pseudo Classes" />
                                                                <jsp:param name="nextLink"
                                                                    value="attribute-selectors.jsp" />
                                                                <jsp:param name="nextTitle"
                                                                    value="Attribute Selectors" />
                                                                <jsp:param name="currentLessonId"
                                                                    value="pseudo-elements" />
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