<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Attributes Lesson 5: HTML Attributes --%>
        <% request.setAttribute("currentLesson", "attributes" ); request.setAttribute("currentModule", "HTML Basics" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Attributes - Adding Power to Tags | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about HTML attributes like href, src, width, height, alt, and style.">

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

            <body class="tutorial-body" data-lesson="attributes">
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
                                        <span>Attributes</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Attributes</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Attributes?</h2>
                                        <p>Attributes provide additional information about HTML elements. All HTML
                                            elements can have attributes.</p>
                                        <ul>
                                            <li>Attributes are always specified in the <strong>start tag</strong></li>
                                            <li>Attributes usually come in name/value pairs like:
                                                <code>name="value"</code></li>
                                        </ul>

                                        <h2>The href Attribute</h2>
                                        <p>The <code>&lt;a&gt;</code> tag defines a hyperlink. The <code>href</code>
                                            attribute specifies the URL of the page the link goes to:</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-href" />
                                            <jsp:param name="initialHtml" value="<a href=\" https://8gwifi.org\">Visit 8gwifi.org</a>" />
                                        </jsp:include>

                                        <h2>The src Attribute</h2>
                                        <p>The <code>&lt;img&gt;</code> tag is used to embed an image. The
                                            <code>src</code> attribute specifies the path to the image to be displayed:
                                        </p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-src" />
                                            <jsp:param name="initialHtml" value="<img src=\"https://via.placeholder.com/150\" width=\"150\" height=\"150\">" />
                                        </jsp:include>

                                        <h2>The style Attribute</h2>
                                        <p>The <code>style</code> attribute is used to add styles to an element, such as
                                            color, font, size, and more.</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-style" />
                                            <jsp:param name="initialHtml" value="<p style=\" color:red;\">I am a red paragraph.</p>\n<p style=\"font-size:24px;\">I am big!</p>" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-attributes" />
                                            <jsp:param name="question" value="Where are HTML attributes defined?" />
                                            <jsp:param name="option1" value="In the end tag" />
                                            <jsp:param name="option2" value="In the start tag" />
                                            <jsp:param name="option3" value="In the content" />
                                            <jsp:param name="option4" value="In the head section" />
                                            <jsp:param name="correctAnswer" value="1" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="elements.jsp" />
                                            <jsp:param name="prevTitle" value="Elements" />
                                            <jsp:param name="nextLink" value="headings.jsp" />
                                            <jsp:param name="nextTitle" value="Headings" />
                                            <jsp:param name="currentLessonId" value="attributes" />
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