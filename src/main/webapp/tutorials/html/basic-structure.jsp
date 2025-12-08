<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Basic Structure Lesson 3: HTML Basic Structure --%>
        <% request.setAttribute("currentLesson", "basic-structure" );
            request.setAttribute("currentModule", "Getting Started" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>HTML Basic Structure - The Skeleton of a Webpage | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn the basic structure of an HTML document. Understand DOCTYPE, html, head, and body tags.">

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

            <body class="tutorial-body" data-lesson="basic-structure">
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
                                        <span>Basic Structure</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Basic Structure</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>The Skeleton</h2>
                                        <p>
                                            Every HTML document follows a specific structure. Think of it as the
                                            skeleton of your webpage.
                                            Without this structure, the browser won't know how to display your content
                                            correctly.
                                        </p>

                                        <div class="card"
                                            style="background: var(--bg-code); border: none; margin-bottom: var(--space-6);">
                                            <pre><code style="color: #f8f8f2;">&lt;!DOCTYPE html&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;title&gt;Page Title&lt;/title&gt;
  &lt;/head&gt;
  &lt;body&gt;
    &lt;h1&gt;My First Heading&lt;/h1&gt;
    &lt;p&gt;My first paragraph.&lt;/p&gt;
  &lt;/body&gt;
&lt;/html&gt;</code></pre>
                                        </div>

                                        <h2>Component Breakdown</h2>

                                        <h3>1. &lt;!DOCTYPE html&gt;</h3>
                                        <p>This declaration must be the very first thing in your HTML document. It tells
                                            the browser that this is an HTML5 document.</p>

                                        <h3>2. &lt;html&gt;</h3>
                                        <p>The root element. Everything else lives inside this tag.</p>

                                        <h3>3. &lt;head&gt;</h3>
                                        <p>Contains metadata about the document that isn't displayed on the page itself,
                                            such as the title, character set, and links to CSS files.</p>

                                        <h3>4. &lt;body&gt;</h3>
                                        <p>Contains the visible page content. Headings, paragraphs, images, links - they
                                            all go here.</p>

                                        <h2>Interactive Example</h2>
                                        <p>Try moving the <code>&lt;h1&gt;</code> tag inside the
                                            <code>&lt;head&gt;</code> section and see what happens (spoiler: it might
                                            disappear or behave strangely!).
                                        </p>

                                        <%
                                        String structureHtml = "<" + "!DOCTYPE html>\\n" +
                                            "<" + "html>\\n" +
                                            "<" + "head>\\n" +
                                            "    <" + "title>My Page<" + "/title>\\n" +
                                            "<" + "/head>\\n" +
                                            "<" + "body>\\n" +
                                            "    <" + "h1>I am in the Body!<" + "/h1>\\n" +
                                            "    <" + "p>I am visible.<" + "/p>\\n" +
                                            "<" + "/body>\\n" +
                                            "<" + "/html>";
                                        %>
                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-structure" />
                                            <jsp:param name="initialHtml" value="<%= structureHtml %>" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-structure" />
                                            <jsp:param name="question" value="Which tag contains the visible content of the webpage?" />
                                            <jsp:param name="option1" value="&lt;head&gt;" />
                                            <jsp:param name="option2" value="&lt;body&gt;" />
                                            <jsp:param name="option3" value="&lt;html&gt;" />
                                            <jsp:param name="option4" value="&lt;title&gt;" />
                                            <jsp:param name="correctAnswer" value="1" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="editors.jsp" />
                                            <jsp:param name="prevTitle" value="Editors" />
                                            <jsp:param name="nextLink" value="elements.jsp" />
                                            <jsp:param name="nextTitle" value="HTML Elements" />
                                            <jsp:param name="currentLessonId" value="basic-structure" />
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
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            </body>

            </html>