<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Forms Lesson 14: HTML Forms --%>
        <% request.setAttribute("currentLesson", "forms" ); request.setAttribute("currentModule", "Forms" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Forms - Collecting User Input | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to create HTML forms to collect user input. Understand the form element, action, and method attributes.">

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

            <body class="tutorial-body" data-lesson="forms">
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
                                        <span>Forms</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Forms</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>The Form Element</h2>
                                        <p>The HTML <code>&lt;form&gt;</code> element is used to create an HTML form for
                                            user input.</p>
                                        <p>The form element is a container for different types of input elements, such
                                            as: text fields, checkboxes, radio buttons, submit buttons, etc.</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-forms" />
                                            <jsp:param name="initialHtml" value="<form>\n  <label for=\" fname\">First name:</label><br>\n <input type=\"text\" id=\"fname\" name=\"fname\" value=\"John\"><br>\n <label for=\"lname\">Last name:</label><br>\n <input type=\"text\" id=\"lname\" name=\"lname\" value=\"Doe\"><br><br>\n <input type=\"submit\" value=\"Submit\">\n</form>" />
                                        </jsp:include>

                                        <h2>Action and Method</h2>
                                        <p>The <code>action</code> attribute defines the action to be performed when the
                                            form is submitted (usually a URL to a server script).</p>
                                        <p>The <code>method</code> attribute specifies the HTTP method to be used when
                                            submitting the form data (usually GET or POST).</p>

                                        <div class="card"
                                            style="background: var(--bg-code); border: none; margin-bottom: var(--space-6); text-align: center; font-family: var(--font-mono);">
                                            <span style="color: #f92672;">&lt;form</span> <span
                                                style="color: #a6e22e;">action</span>=<span
                                                style="color: #e6db74;">"/submit"</span> <span
                                                style="color: #a6e22e;">method</span>=<span
                                                style="color: #e6db74;">"POST"</span><span
                                                style="color: #f92672;">&gt;</span>...<span
                                                style="color: #f92672;">&lt;/form&gt;</span>
                                        </div>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-forms" />
                                            <jsp:param name="question"
                                                value="Which attribute specifies the URL where form data should be sent?" />
                                            <jsp:param name="option1" value="method" />
                                            <jsp:param name="option2" value="target" />
                                            <jsp:param name="option3" value="action" />
                                            <jsp:param name="option4" value="submit" />
                                            <jsp:param name="correctAnswer" value="2" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="tables.jsp" />
                                            <jsp:param name="prevTitle" value="Tables" />
                                            <jsp:param name="nextLink" value="input-types.jsp" />
                                            <jsp:param name="nextTitle" value="Input Types" />
                                            <jsp:param name="currentLessonId" value="forms" />
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