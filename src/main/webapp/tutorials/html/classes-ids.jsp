<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - Classes & IDs --%>
<% request.setAttribute("currentLesson", "classes-ids"); request.setAttribute("currentModule", "Layout & Structure"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>HTML Classes & IDs - Naming Elements | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn how to use class and id attributes to identify and style HTML elements with CSS and JavaScript.">
    <meta name="keywords" content="HTML class attribute, HTML id attribute, CSS selectors, class vs id, HTML element naming">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Classes & IDs - Naming Elements">
    <meta property="og:description" content="Learn how to use class and id attributes to identify and style HTML elements.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <%-- Favicon --%>
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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

    <%-- JSON-LD --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "HTML Classes & IDs",
        "description": "Learn how to use class and id attributes to identify and style HTML elements",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "isPartOf": {
            "@type": "Course",
            "name": "HTML Tutorial",
            "url": "https://8gwifi.org/tutorials/html/"
        }
    }
    </script>
    <%-- Analytics & Ads --%>
    <%@ include file="../tutorial-analytics.jsp" %>
    <%@ include file="../tutorial-ads.jsp" %>
</head>
<body class="tutorial-body" data-lesson="classes-ids">
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
                    <span>Classes & IDs</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">HTML Classes & IDs</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~10 min read</span>
                    </div>
                </header>

                <%
                String classHtml = "<" + "style>\\n" +
                    "  .highlight { background: yellow; padding: 2px 5px; }\\n" +
                    "  .error { color: red; font-weight: bold; }\\n" +
                    "  .success { color: green; }\\n" +
                    "<" + "/style>\\n\\n" +
                    "<" + "p class=\"highlight\">This paragraph is highlighted.<" + "/p>\\n" +
                    "<" + "p class=\"error\">Error: Something went wrong!<" + "/p>\\n" +
                    "<" + "p class=\"success\">Success: Operation completed.<" + "/p>\\n" +
                    "<" + "p class=\"highlight\">Another highlighted paragraph.<" + "/p>";

                String idHtml = "<" + "style>\\n" +
                    "  #main-title { color: #1976d2; border-bottom: 2px solid #1976d2; }\\n" +
                    "  #sidebar { background: #f5f5f5; padding: 15px; }\\n" +
                    "<" + "/style>\\n\\n" +
                    "<" + "h1 id=\"main-title\">Welcome to My Site<" + "/h1>\\n" +
                    "<" + "div id=\"sidebar\">\\n" +
                    "  <" + "p>This is the sidebar content.<" + "/p>\\n" +
                    "<" + "/div>";

                String multiClassHtml = "<" + "style>\\n" +
                    "  .btn { padding: 10px 20px; border: none; cursor: pointer; }\\n" +
                    "  .btn-primary { background: #1976d2; color: white; }\\n" +
                    "  .btn-danger { background: #d32f2f; color: white; }\\n" +
                    "  .btn-large { font-size: 18px; padding: 15px 30px; }\\n" +
                    "<" + "/style>\\n\\n" +
                    "<" + "button class=\"btn btn-primary\">Primary<" + "/button>\\n" +
                    "<" + "button class=\"btn btn-danger\">Danger<" + "/button>\\n" +
                    "<" + "button class=\"btn btn-primary btn-large\">Large Primary<" + "/button>";
                %>

                <div class="lesson-body">
                    <h2>Why Use Classes & IDs?</h2>
                    <p>Classes and IDs allow you to:</p>
                    <ul>
                        <li>Target specific elements with CSS styles</li>
                        <li>Select elements with JavaScript</li>
                        <li>Create reusable style patterns</li>
                        <li>Link to specific page sections</li>
                    </ul>

                    <h2>The Class Attribute</h2>
                    <p>Classes can be used on <strong>multiple elements</strong>. They're perfect for reusable styles.</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-class" />
                        <jsp:param name="initialHtml" value="<%= classHtml %>" />
                    </jsp:include>

                    <h2>The ID Attribute</h2>
                    <p>IDs must be <strong>unique</strong> - only one element per page can have a specific ID.</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-id" />
                        <jsp:param name="initialHtml" value="<%= idHtml %>" />
                    </jsp:include>

                    <h2>Multiple Classes</h2>
                    <p>An element can have multiple classes, separated by spaces:</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-multi" />
                        <jsp:param name="initialHtml" value="<%= multiClassHtml %>" />
                    </jsp:include>

                    <h2>Class vs ID: When to Use</h2>
                    <div class="card" style="margin: var(--space-4) 0;">
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr style="background: var(--bg-secondary);">
                                <th style="padding: 10px; text-align: left;">Class</th>
                                <th style="padding: 10px; text-align: left;">ID</th>
                            </tr>
                            <tr>
                                <td style="padding: 10px; border-top: 1px solid var(--border-color);">Reusable on many elements</td>
                                <td style="padding: 10px; border-top: 1px solid var(--border-color);">Unique, one per page</td>
                            </tr>
                            <tr>
                                <td style="padding: 10px; border-top: 1px solid var(--border-color);">CSS: <code>.classname</code></td>
                                <td style="padding: 10px; border-top: 1px solid var(--border-color);">CSS: <code>#idname</code></td>
                            </tr>
                            <tr>
                                <td style="padding: 10px; border-top: 1px solid var(--border-color);">For styling patterns</td>
                                <td style="padding: 10px; border-top: 1px solid var(--border-color);">For unique elements, anchors</td>
                            </tr>
                        </table>
                    </div>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>Naming Convention:</strong> Use lowercase with hyphens: <code>main-content</code>, <code>nav-link</code>, <code>btn-primary</code>
                        </div>
                    </div>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-classid" />
                        <jsp:param name="question" value="How many elements can share the same ID on a page?" />
                        <jsp:param name="option1" value="Unlimited" />
                        <jsp:param name="option2" value="One" />
                        <jsp:param name="option3" value="Two" />
                        <jsp:param name="option4" value="Ten" />
                        <jsp:param name="correctAnswer" value="1" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="div-span.jsp" />
                        <jsp:param name="prevTitle" value="Div & Span" />
                        <jsp:param name="nextLink" value="page-layout.jsp" />
                        <jsp:param name="nextTitle" value="Page Layout" />
                        <jsp:param name="currentLessonId" value="classes-ids" />
                    </jsp:include>
                </div>
            </article>

            <aside class="tutorial-preview" id="previewPanel">
                <div class="preview-header">
                    <span>Live Preview</span>
                    <button class="btn btn-ghost btn-icon" onclick="refreshPreview()" title="Refresh">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M23 4v6h-6M1 20v-6h6" />
                            <path d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15" />
                        </svg>
                    </button>
                </div>
                <iframe id="previewFrame" class="preview-frame" sandbox="allow-scripts allow-same-origin"></iframe>
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
