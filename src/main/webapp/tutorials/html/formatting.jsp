<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Formatting Lesson 8: HTML Formatting --%>
        <% request.setAttribute("currentLesson", "formatting" ); request.setAttribute("currentModule", "HTML Basics" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Formatting - Bold, Italic, and More | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about HTML formatting elements like bold, italic, strong, emphasized, mark, small, del, ins, sub, and sup.">

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

            <body class="tutorial-body" data-lesson="formatting">
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
                                        <span>Formatting</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Formatting</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~6 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Formatting Elements</h2>
                                        <p>HTML contains several elements for defining text with a special meaning.</p>

                                        <ul>
                                            <li><code>&lt;b&gt;</code> - Bold text</li>
                                            <li><code>&lt;strong&gt;</code> - Important text</li>
                                            <li><code>&lt;i&gt;</code> - Italic text</li>
                                            <li><code>&lt;em&gt;</code> - Emphasized text</li>
                                            <li><code>&lt;mark&gt;</code> - Marked text</li>
                                            <li><code>&lt;small&gt;</code> - Smaller text</li>
                                            <li><code>&lt;del&gt;</code> - Deleted text</li>
                                            <li><code>&lt;ins&gt;</code> - Inserted text</li>
                                            <li><code>&lt;sub&gt;</code> - Subscript text</li>
                                            <li><code>&lt;sup&gt;</code> - Superscript text</li>
                                        </ul>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-formatting" />
                                            <jsp:param name="initialHtml"
                                                value="<p><b>This text is bold</b></p>\n<p><i>This text is italic</i></p>\n<p>This is <sub>subscript</sub> and <sup>superscript</sup></p>" />
                                        </jsp:include>

                                        <h2>Strong vs Bold</h2>
                                        <p>The <code>&lt;strong&gt;</code> tag is often displayed like
                                            <code>&lt;b&gt;</code> (bold), but it has semantic meaning: it defines text
                                            with strong importance.</p>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-formatting" />
                                            <jsp:param name="question"
                                                value="Which tag is used to define emphasized text?" />
                                            <jsp:param name="option1" value="<italic>" />
                                            <jsp:param name="option2" value="<em>" />
                                            <jsp:param name="option3" value="<i>" />
                                            <jsp:param name="option4" value="<emp>" />
                                            <jsp:param name="correctAnswer" value="1" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="paragraphs.jsp" />
                                            <jsp:param name="prevTitle" value="Paragraphs" />
                                            <jsp:param name="nextLink" value="comments.jsp" />
                                            <jsp:param name="nextTitle" value="Comments" />
                                            <jsp:param name="currentLessonId" value="formatting" />
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