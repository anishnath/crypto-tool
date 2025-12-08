<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Semantic HTML Lesson 16: Semantic HTML --%>
        <% request.setAttribute("currentLesson", "semantic" ); request.setAttribute("currentModule", "Semantic HTML" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>Semantic HTML - Meaningful Elements | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about semantic HTML elements like header, footer, article, section, aside, and nav.">

                <%-- Common Head Includes --%>
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
                <%-- Analytics & Ads --%>
    <%@ include file="../tutorial-analytics.jsp" %>
    <%@ include file="../tutorial-ads.jsp" %>
</head>

            <body class="tutorial-body" data-lesson="semantic">
                <div class="tutorial-layout">
                    <%@ include file="../tutorial-header.jsp" %>
                        <main class="tutorial-main">
                            <%@ include file="../tutorial-sidebar.jsp" %>
                                <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                                <article class="tutorial-content">
                                    <nav class="breadcrumb">
                                        <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <a href="/tutorials/html/">HTML</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <span>Semantic HTML</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Semantic HTML</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~6 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is Semantic HTML?</h2>
                                        <p>Semantic HTML means using elements that clearly describe their meaning to
                                            both the browser and the developer.</p>
                                        <p>Examples of <strong>non-semantic</strong> elements: <code>&lt;div&gt;</code>
                                            and <code>&lt;span&gt;</code> - Tells nothing about its content.</p>
                                        <p>Examples of <strong>semantic</strong> elements: <code>&lt;form&gt;</code>,
                                            <code>&lt;table&gt;</code>, and <code>&lt;article&gt;</code> - Clearly
                                            defines its content.
                                        </p>

                                        <h2>Common Semantic Elements</h2>
                                        <ul>
                                            <li><code>&lt;header&gt;</code> - Defines a header for a document or a
                                                section</li>
                                            <li><code>&lt;nav&gt;</code> - Defines a set of navigation links</li>
                                            <li><code>&lt;section&gt;</code> - Defines a section in a document</li>
                                            <li><code>&lt;article&gt;</code> - Defines an independent, self-contained
                                                content</li>
                                            <li><code>&lt;aside&gt;</code> - Defines content aside from the page content
                                                (like a sidebar)</li>
                                            <li><code>&lt;footer&gt;</code> - Defines a footer for a document or a
                                                section</li>
                                        </ul>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-semantic" />
                                            <jsp:param name="initialHtml"
                                                value="<article>\n  <header>\n    <h1>What Does WWF Do?</h1>\n    <p>Posted by John Doe</p>\n  </header>\n  <p>WWF's mission is to stop the degradation of our planet's natural environment.</p>\n</article>" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-semantic" />
                                            <jsp:param name="question"
                                                value="Which element is used to define a set of navigation links?" />
                                            <jsp:param name="option1" value="<navigation>" />
                                            <jsp:param name="option2" value="<nav>" />
                                            <jsp:param name="option3" value="<links>" />
                                            <jsp:param name="option4" value="<menu>" />
                                            <jsp:param name="correctAnswer" value="1" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="classes-ids.jsp" />
                                            <jsp:param name="prevTitle" value="Classes & IDs" />
                                            <jsp:param name="nextLink" value="page-layout.jsp" />
                                            <jsp:param name="nextTitle" value="Page Layout" />
                                            <jsp:param name="currentLessonId" value="semantic" />
                                        </jsp:include>

                                        <div class="callout callout-success" style="margin-top: var(--space-6);">
                                            <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                                <polyline points="22 4 12 14.01 9 11.01" />
                                            </svg>
                                            <div class="callout-content">
                                                <strong>Congratulations!</strong> You have completed the HTML Tutorial.
                                                You now have a solid foundation in HTML.
                                            </div>
                                        </div>
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