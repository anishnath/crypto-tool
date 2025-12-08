<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Input Types Lesson 15: HTML Input Types --%>
        <% request.setAttribute("currentLesson", "input-types" ); request.setAttribute("currentModule", "Forms" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Input Types - Text, Checkbox, Radio | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about different HTML input types like text, password, radio, checkbox, date, color, and more.">

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

            <body class="tutorial-body" data-lesson="input-types">
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
                                        <span>Input Types</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Input Types</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <%-- Define editor HTML content using scriptlets for clean formatting --%>
                                    <%
                                    String textPasswordHtml = "<form>\\n" +
                                        "  Username: <input type=\"text\" name=\"user\"><br><br>\\n" +
                                        "  Password: <input type=\"password\" name=\"pass\">\\n" +
                                        "</form>";

                                    String radioHtml = "<form>\\n" +
                                        "  <input type=\"radio\" id=\"html\" name=\"fav_language\" value=\"HTML\">\\n" +
                                        "  <label for=\"html\">HTML</label><br>\\n" +
                                        "  <input type=\"radio\" id=\"css\" name=\"fav_language\" value=\"CSS\">\\n" +
                                        "  <label for=\"css\">CSS</label><br>\\n" +
                                        "  <input type=\"radio\" id=\"js\" name=\"fav_language\" value=\"JavaScript\">\\n" +
                                        "  <label for=\"js\">JavaScript</label>\\n" +
                                        "</form>";

                                    String checkboxHtml = "<form>\\n" +
                                        "  <input type=\"checkbox\" id=\"vehicle1\" name=\"vehicle1\" value=\"Bike\">\\n" +
                                        "  <label for=\"vehicle1\"> I have a bike</label><br>\\n" +
                                        "  <input type=\"checkbox\" id=\"vehicle2\" name=\"vehicle2\" value=\"Car\">\\n" +
                                        "  <label for=\"vehicle2\"> I have a car</label>\\n" +
                                        "</form>";
                                    %>

                                    <div class="lesson-body">
                                        <h2>Common Input Types</h2>
                                        <p>The <code>&lt;input&gt;</code> element is the most important form element. It
                                            can be displayed in several ways, depending on the <code>type</code>
                                            attribute.</p>

                                        <h3>Text and Password</h3>
                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-text" />
                                            <jsp:param name="initialHtml" value="<%= textPasswordHtml %>" />
                                        </jsp:include>

                                        <h3>Radio Buttons</h3>
                                        <p>Radio buttons let a user select ONE of a limited number of choices.</p>
                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-radio" />
                                            <jsp:param name="initialHtml" value="<%= radioHtml %>" />
                                        </jsp:include>

                                        <h3>Checkboxes</h3>
                                        <p>Checkboxes let a user select ZERO or MORE options of a limited number of
                                            choices.</p>
                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-checkbox" />
                                            <jsp:param name="initialHtml" value="<%= checkboxHtml %>" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-inputs" />
                                            <jsp:param name="question"
                                                value="Which input type is best for selecting multiple options?" />
                                            <jsp:param name="option1" value="radio" />
                                            <jsp:param name="option2" value="text" />
                                            <jsp:param name="option3" value="checkbox" />
                                            <jsp:param name="option4" value="select" />
                                            <jsp:param name="correctAnswer" value="2" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="forms.jsp" />
                                            <jsp:param name="prevTitle" value="Forms" />
                                            <jsp:param name="nextLink" value="form-attributes.jsp" />
                                            <jsp:param name="nextTitle" value="Form Attributes" />
                                            <jsp:param name="currentLessonId" value="input-types" />
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