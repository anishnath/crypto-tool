<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Comments Lesson 9: HTML Comments --%>
        <% request.setAttribute("currentLesson", "comments" ); request.setAttribute("currentModule", "HTML Basics" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Comments - Notes in Code | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to add comments to your HTML code. Comments are not displayed in the browser but help document your code.">

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

            <body class="tutorial-body" data-lesson="comments">
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
                                        <span>Comments</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Comments</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~3 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Adding Comments</h2>
                                        <p>Comments are pieces of code that are ignored by the browser. They are not
                                            displayed on the page.</p>
                                        <p>You can use comments to explain your code, which can help you or others
                                            understand it later.</p>

                                        <div class="card"
                                            style="background: var(--bg-code); border: none; margin-bottom: var(--space-6); text-align: center; font-family: var(--font-mono);">
                                            <span style="color: #75715e;">&lt;!-- This is a comment --&gt;</span>
                                        </div>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-comments" />
                                            <jsp:param name="initialHtml"
                                                value="<!-- This is a comment -->\n<p>This is a paragraph.</p>\n<!-- Comments are not displayed in the browser -->" />
                                        </jsp:include>

                                        <h2>Debugging with Comments</h2>
                                        <p>You can also use comments to "hide" parts of your HTML code temporarily while
                                            you are testing or debugging.</p>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-comments" />
                                            <jsp:param name="question" value="How do you write a comment in HTML?" />
                                            <jsp:param name="option1" value="// This is a comment" />
                                            <jsp:param name="option2" value="/* This is a comment */" />
                                            <jsp:param name="option3" value="<!-- This is a comment -->" />
                                            <jsp:param name="option4" value="<comment>This is a comment</comment>" />
                                            <jsp:param name="correctAnswer" value="2" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="formatting.jsp" />
                                            <jsp:param name="prevTitle" value="Formatting" />
                                            <jsp:param name="nextLink" value="links.jsp" />
                                            <jsp:param name="nextTitle" value="Links" />
                                            <jsp:param name="currentLessonId" value="comments" />
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