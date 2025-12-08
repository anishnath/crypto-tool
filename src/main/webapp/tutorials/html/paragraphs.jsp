<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Paragraphs Lesson 7: HTML Paragraphs --%>
        <% request.setAttribute("currentLesson", "paragraphs" ); request.setAttribute("currentModule", "HTML Basics" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Paragraphs - Text Formatting | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to use paragraphs in HTML. Understand how browsers handle whitespace and line breaks.">

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

            <body class="tutorial-body" data-lesson="paragraphs">
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
                                        <span>Paragraphs</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Paragraphs</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~5 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>The Paragraph Tag</h2>
                                        <p>The HTML <code>&lt;p&gt;</code> element defines a paragraph.</p>
                                        <p>A paragraph always starts on a new line, and browsers automatically add some
                                            white space (a margin) before and after a paragraph.</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-paragraphs" />
                                            <jsp:param name="initialHtml"
                                                value="<p>This is a paragraph.</p>\n<p>This is another paragraph.</p>" />
                                        </jsp:include>

                                        <h2>Line Breaks</h2>
                                        <p>The HTML <code>&lt;br&gt;</code> element defines a line break.</p>
                                        <p>Use <code>&lt;br&gt;</code> if you want a line break (a new line) without
                                            starting a new paragraph:</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-br" />
                                            <jsp:param name="initialHtml"
                                                value="<p>This is<br>a paragraph<br>with line breaks.</p>" />
                                        </jsp:include>

                                        <h2>The Pre Element</h2>
                                        <p>The HTML <code>&lt;pre&gt;</code> element defines preformatted text.</p>
                                        <p>The text inside a <code>&lt;pre&gt;</code> element is displayed in a
                                            fixed-width font (usually Courier), and it preserves both spaces and line
                                            breaks:</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-pre" />
                                            <jsp:param name="initialHtml"
                                                value="<pre>\n  My Bonnie lies over the ocean.\n\n  My Bonnie lies over the sea.\n\n  My Bonnie lies over the ocean.\n\n  Oh, bring back my Bonnie to me.\n</pre>" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-paragraphs" />
                                            <jsp:param name="question"
                                                value="Which tag is used to insert a line break?" />
                                            <jsp:param name="option1" value="<br>" />
                                            <jsp:param name="option2" value="<lb>" />
                                            <jsp:param name="option3" value="<break>" />
                                            <jsp:param name="option4" value="<newline>" />
                                            <jsp:param name="correctAnswer" value="0" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="headings.jsp" />
                                            <jsp:param name="prevTitle" value="Headings" />
                                            <jsp:param name="nextLink" value="formatting.jsp" />
                                            <jsp:param name="nextTitle" value="Formatting" />
                                            <jsp:param name="currentLessonId" value="paragraphs" />
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