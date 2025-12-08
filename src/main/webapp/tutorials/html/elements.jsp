<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Elements Lesson 4: HTML Elements --%>
        <% request.setAttribute("currentLesson", "elements" ); request.setAttribute("currentModule", "HTML Basics" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Elements - Tags and Content | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about HTML elements, start tags, end tags, and nested elements.">

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

            <body class="tutorial-body" data-lesson="elements">
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
                                        <span>Elements</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Elements</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~5 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is an HTML Element?</h2>
                                        <p>An HTML element is usually defined by a <strong>start tag</strong>, some
                                            <strong>content</strong>, and an <strong>end tag</strong>.</p>

                                        <div class="card"
                                            style="background: var(--bg-code); border: none; margin-bottom: var(--space-6); text-align: center; font-family: var(--font-mono);">
                                            <span style="color: #f92672;">&lt;tagname&gt;</span> Content goes here...
                                            <span style="color: #f92672;">&lt;/tagname&gt;</span>
                                        </div>

                                        <p>Examples:</p>
                                        <ul>
                                            <li><code>&lt;h1&gt;My First Heading&lt;/h1&gt;</code></li>
                                            <li><code>&lt;p&gt;My first paragraph.&lt;/p&gt;</code></li>
                                        </ul>

                                        <h2>Nested Elements</h2>
                                        <p>HTML elements can be nested (this means that elements can contain other
                                            elements).</p>
                                        <p>In the example below, the <code>&lt;body&gt;</code> element contains both an
                                            <code>&lt;h1&gt;</code> and a <code>&lt;p&gt;</code> element.</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-elements" />
                                            <jsp:param name="initialHtml"
                                                value="<body>\n    <h1>I am a child of body</h1>\n    <p>I am also a child of body</p>\n</body>" />
                                        </jsp:include>

                                        <h2>Empty Elements</h2>
                                        <p>Some HTML elements have no content (like the <code>&lt;br&gt;</code>
                                            element). These are called empty elements. Empty elements do not have an end
                                            tag!</p>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-elements" />
                                            <jsp:param name="question"
                                                value="Which character is used to indicate an end tag?" />
                                            <jsp:param name="option1" value="*" />
                                            <jsp:param name="option2" value="/" />
                                            <jsp:param name="option3" value="<" />
                                            <jsp:param name="option4" value="^" />
                                            <jsp:param name="correctAnswer" value="1" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="basic-structure.jsp" />
                                            <jsp:param name="prevTitle" value="Basic Structure" />
                                            <jsp:param name="nextLink" value="attributes.jsp" />
                                            <jsp:param name="nextTitle" value="Attributes" />
                                            <jsp:param name="currentLessonId" value="elements" />
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