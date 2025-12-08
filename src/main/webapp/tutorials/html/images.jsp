<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Images Lesson 11: HTML Images --%>
        <% request.setAttribute("currentLesson", "images" ); request.setAttribute("currentModule", "Links & Media" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Images - Embedding Pictures | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to add images to your webpage using the img tag. Understand src, alt, width, and height attributes.">

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

            <body class="tutorial-body" data-lesson="images">
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
                                        <span>Images</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Images</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>The Image Tag</h2>
                                        <p>Images are defined with the <code>&lt;img&gt;</code> tag.</p>
                                        <p>The <code>&lt;img&gt;</code> tag is empty, it contains attributes only, and
                                            does not have a closing tag.</p>

                                        <h2>The src Attribute</h2>
                                        <p>The <code>src</code> attribute specifies the path (URL) to the image.</p>

                                        <h2>The alt Attribute</h2>
                                        <p>The <code>alt</code> attribute provides an alternate text for an image, if
                                            the user for some reason cannot view it (because of slow connection, an
                                            error in the src attribute, or if the user uses a screen reader).</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-images" />
                                            <jsp:param name="initialHtml" value="<img src=\"https://via.placeholder.com/300x150\" alt=\"A placeholder image\">\n<p> If the image fails to load, the alt text will be shown.</p>" />
                                        </jsp:include>

                                        <h2>Width and Height</h2>
                                        <p>You can use the <code>width</code> and <code>height</code> attributes to
                                            specify the width and height of an image.</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-size" />
                                            <jsp:param name="initialHtml" value="<img src=\"https://via.placeholder.com/150\" width=\"100\" height=\"100\"alt=\"Small image\">" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-images" />
                                            <jsp:param name="question" value="Which attribute specifies the path to the image?" />
                                            <jsp:param name="option1" value="href" />
                                            <jsp:param name="option2" value="src" />
                                            <jsp:param name="option3" value="link" />
                                            <jsp:param name="option4" value="path" />
                                            <jsp:param name="correctAnswer" value="1" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="links.jsp" />
                                            <jsp:param name="prevTitle" value="Links" />
                                            <jsp:param name="nextLink" value="audio-video.jsp" />
                                            <jsp:param name="nextTitle" value="Audio & Video" />
                                            <jsp:param name="currentLessonId" value="images" />
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