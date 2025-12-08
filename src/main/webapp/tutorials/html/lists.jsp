<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Lists Lesson 12: HTML Lists --%>
        <% request.setAttribute("currentLesson", "lists" ); request.setAttribute("currentModule", "Lists & Tables" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Lists - Unordered and Ordered | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to create lists in HTML. Unordered lists (ul), ordered lists (ol), and list items (li).">

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

            <body class="tutorial-body" data-lesson="lists">
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
                                        <span>Lists</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Lists</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~6 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Unordered Lists</h2>
                                        <p>An unordered list starts with the <code>&lt;ul&gt;</code> tag. Each list item
                                            starts with the <code>&lt;li&gt;</code> tag.</p>
                                        <p>The list items will be marked with bullets (small black circles) by default:
                                        </p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-ul" />
                                            <jsp:param name="initialHtml"
                                                value="<ul>\n  <li>Coffee</li>\n  <li>Tea</li>\n  <li>Milk</li>\n</ul>" />
                                        </jsp:include>

                                        <h2>Ordered Lists</h2>
                                        <p>An ordered list starts with the <code>&lt;ol&gt;</code> tag. Each list item
                                            starts with the <code>&lt;li&gt;</code> tag.</p>
                                        <p>The list items will be marked with numbers by default:</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-ol" />
                                            <jsp:param name="initialHtml"
                                                value="<ol>\n  <li>First Item</li>\n  <li>Second Item</li>\n  <li>Third Item</li>\n</ol>" />
                                        </jsp:include>

                                        <h2>Description Lists</h2>
                                        <p>HTML also supports description lists.</p>
                                        <p>A description list is a list of terms, with a description of each term.</p>
                                        <p>The <code>&lt;dl&gt;</code> tag defines the description list, the
                                            <code>&lt;dt&gt;</code> tag defines the term (name), and the
                                            <code>&lt;dd&gt;</code> tag describes each term:</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-dl" />
                                            <jsp:param name="initialHtml"
                                                value="<dl>\n  <dt>Coffee</dt>\n  <dd>- black hot drink</dd>\n  <dt>Milk</dt>\n  <dd>- white cold drink</dd>\n</dl>" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-lists" />
                                            <jsp:param name="question"
                                                value="Which tag is used to create a numbered list?" />
                                            <jsp:param name="option1" value="<ul>" />
                                            <jsp:param name="option2" value="<ol>" />
                                            <jsp:param name="option3" value="<list>" />
                                            <jsp:param name="option4" value="<nl>" />
                                            <jsp:param name="correctAnswer" value="1" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="iframes.jsp" />
                                            <jsp:param name="prevTitle" value="Iframes" />
                                            <jsp:param name="nextLink" value="tables.jsp" />
                                            <jsp:param name="nextTitle" value="Tables" />
                                            <jsp:param name="currentLessonId" value="lists" />
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