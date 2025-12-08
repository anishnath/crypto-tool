<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- HTML Tutorial - Tables Lesson 13: HTML Tables --%>
        <% request.setAttribute("currentLesson", "tables" ); request.setAttribute("currentModule", "Lists & Tables" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>HTML Tables - Organizing Data | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to create tables in HTML. Understand table rows (tr), table data (td), and table headers (th).">

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

            <body class="tutorial-body" data-lesson="tables">
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
                                        <span>Tables</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">HTML Tables</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Defining a Table</h2>
                                        <p>A table in HTML consists of table cells inside rows and columns.</p>

                                        <ul>
                                            <li><code>&lt;table&gt;</code> - Defines the table</li>
                                            <li><code>&lt;tr&gt;</code> - Defines a table row</li>
                                            <li><code>&lt;th&gt;</code> - Defines a table header</li>
                                            <li><code>&lt;td&gt;</code> - Defines a table cell (data)</li>
                                        </ul>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-tables" />
                                            <jsp:param name="initialHtml" value="<table border=\" 1\">\n <tr>\n <th>
                                                        Firstname</th>\n <th>Lastname</th>\n <th>Age</th>\n </tr>\n <tr>
                                                    \n <td>Jill</td>\n <td>Smith</td>\n <td>50</td>\n </tr>\n <tr>\n
                                                    <td>Eve</td>\n <td>Jackson</td>\n <td>94</td>\n </tr>\n</table>" />
                                        </jsp:include>

                                        <h2>Table Borders</h2>
                                        <p>If you don't specify a border for the table, it will be displayed without
                                            borders. You can add borders using CSS.</p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-table-css" />
                                            <jsp:param name="initialHtml"
                                                value="<table>\n  <tr>\n    <th>Name</th>\n    <th>Age</th>\n  </tr>\n  <tr>\n    <td>John</td>\n    <td>25</td>\n  </tr>\n</table>" />
                                            <jsp:param name="initialCss"
                                                value="table, th, td {\n  border: 1px solid black;\n  border-collapse: collapse;\n  padding: 8px;\n}" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-tables" />
                                            <jsp:param name="question"
                                                value="Which tag is used to define a table row?" />
                                            <jsp:param name="option1" value="<th>" />
                                            <jsp:param name="option2" value="<td>" />
                                            <jsp:param name="option3" value="<tr>" />
                                            <jsp:param name="option4" value="<table>" />
                                            <jsp:param name="correctAnswer" value="2" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="lists.jsp" />
                                            <jsp:param name="prevTitle" value="Lists" />
                                            <jsp:param name="nextLink" value="forms.jsp" />
                                            <jsp:param name="nextTitle" value="Forms" />
                                            <jsp:param name="currentLessonId" value="tables" />
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