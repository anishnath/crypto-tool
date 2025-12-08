<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Editors Lesson 2: HTML Editors --%>
        <% request.setAttribute("currentLesson", "editors" ); request.setAttribute("currentModule", "Getting Started" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>HTML Editors - Writing HTML Code | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about HTML editors. From simple text editors like Notepad to powerful IDEs like VS Code.">

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

            <body class="tutorial-body" data-lesson="editors">
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
                                        <span>Editors</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Editors</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~5 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Writing HTML</h2>
                                        <p>
                                            HTML files are just plain text files. You can write HTML using any text
                                            editor, even the basic ones that come with your computer.
                                            However, for professional development, specialized code editors are
                                            recommended.
                                        </p>

                                        <h2>Common Editors</h2>
                                        <div class="card" style="margin-bottom: var(--space-6);">
                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                <li><strong>VS Code</strong> - The most popular free editor
                                                    (Recommended)</li>
                                                <li><strong>Sublime Text</strong> - Fast and lightweight</li>
                                                <li><strong>Notepad++</strong> - Great for Windows users</li>
                                                <li><strong>Atom</strong> - Another popular choice</li>
                                            </ul>
                                        </div>

                                        <h2>Try It Yourself</h2>
                                        <p>
                                            You don't need to install anything right now! You can use our built-in
                                            editor to practice.
                                            Try changing the text inside the <code>&lt;h1&gt;</code> tag below:
                                        </p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-editors" />
                                            <jsp:param name="initialHtml"
                                                value="<h1>I am using an Editor!</h1>\n<p>This is my first code change.</p>" />
                                        </jsp:include>

                                        <div class="callout callout-tip">
                                            <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10" />
                                                <path d="M12 16v-4M12 8h.01" />
                                            </svg>
                                            <div class="callout-content">
                                                <strong>Note:</strong> HTML files must be saved with the
                                                <code>.html</code> or <code>.htm</code> extension (e.g.,
                                                <code>index.html</code>).
                                            </div>
                                        </div>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-editors" />
                                            <jsp:param name="question"
                                                value="Which of the following is NOT a suitable HTML editor?" />
                                            <jsp:param name="option1" value="VS Code" />
                                            <jsp:param name="option2" value="Sublime Text" />
                                            <jsp:param name="option3" value="Adobe Photoshop" />
                                            <jsp:param name="option4" value="Notepad++" />
                                            <jsp:param name="correctAnswer" value="2" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="introduction.jsp" />
                                            <jsp:param name="prevTitle" value="Introduction" />
                                            <jsp:param name="nextLink" value="basic-structure.jsp" />
                                            <jsp:param name="nextTitle" value="Basic Structure" />
                                            <jsp:param name="currentLessonId" value="editors" />
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

                <%-- Scripts --%>
                    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
                    <script
                        src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
                    <script
                        src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
                    <script
                        src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
                    <script
                        src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
                    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
                    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            </body>

            </html>