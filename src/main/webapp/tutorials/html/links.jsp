<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Links Lesson 10: HTML Links --%>
        <% request.setAttribute("currentLesson", "links" ); request.setAttribute("currentModule", "Links & Media" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Links - Hyperlinks | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to create links in HTML using the anchor tag. Understand absolute and relative URLs.">

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

            <body class="tutorial-body" data-lesson="links">
                <div class="tutorial-layout">
                    <%@ include file="../tutorial-header.jsp" %>
                        <main class="tutorial-main">
                            <%@ include file="../tutorial-sidebar.jsp" %>
                                <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                                <article class="tutorial-content">
                                    <nav class="breadcrumb">
                                        <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <a href="<%=request.getContextPath()%>/tutorials/html/">HTML</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <span>Links</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Links</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Hyperlinks</h2>
                                        <p>Links are found in nearly all web pages. Links allow users to click their way
                                            from page to page.</p>
                                        <p>HTML links are defined with the <code>&lt;a&gt;</code> tag:</p>

                                        <div class="card"
                                            style="background: var(--bg-code); border: none; margin-bottom: var(--space-6); text-align: center; font-family: var(--font-mono);">
                                            <span style="color: #f92672;">&lt;a</span> <span
                                                style="color: #a6e22e;">href</span>=<span
                                                style="color: #e6db74;">"url"</span><span
                                                style="color: #f92672;">&gt;</span>link text<span
                                                style="color: #f92672;">&lt;/a&gt;</span>
                                        </div>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-links" />
                                            <jsp:param name="initialHtml" value="<p><a href=\" https://8gwifi.org\"> Visit 8gwifi.org</a></p>" />
                                        </jsp:include>

                                        <h2>Target Attribute</h2>
                                        <p>The <code>target</code> attribute specifies where to open the linked
                                            document.</p>
                                        <ul>
                                            <li><code>_self</code> - Default. Opens in the same window/tab</li>
                                            <li><code>_blank</code> - Opens in a new window or tab</li>
                                        </ul>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-target" />
                                            <jsp:param name="initialHtml" value="<a href=\" https://8gwifi.org\" target=\"_blank\">Open in New Tab</a>" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-links" />
                                            <jsp:param name="question" value="Which attribute is used to specify the link's destination?" />
                                            <jsp:param name="option1" value="src" />
                                            <jsp:param name="option2" value="href" />
                                            <jsp:param name="option3" value="link" />
                                            <jsp:param name="option4" value="url" />
                                            <jsp:param name="correctAnswer" value="1" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="comments.jsp" />
                                            <jsp:param name="prevTitle" value="Comments" />
                                            <jsp:param name="nextLink" value="images.jsp" />
                                            <jsp:param name="nextTitle" value="Images" />
                                            <jsp:param name="currentLessonId" value="links" />
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