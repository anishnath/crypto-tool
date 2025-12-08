<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - Div & Span --%>
<% request.setAttribute("currentLesson", "div-span"); request.setAttribute("currentModule", "Layout & Structure"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>HTML Div & Span - Container Elements | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn how to use div and span elements as containers for grouping and styling HTML content.">
    <meta name="keywords" content="HTML div tag, span tag HTML, div container, HTML grouping elements, div vs span">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Div & Span - Container Elements">
    <meta property="og:description" content="Learn how to use div and span elements as containers for grouping content.">
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
        "name": "HTML Div & Span",
        "description": "Learn how to use div and span elements as containers for grouping content",
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
<body class="tutorial-body" data-lesson="div-span">
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
                    <span>Div & Span</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">HTML Div & Span</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~8 min read</span>
                    </div>
                </header>

                <%
                String divHtml = "<" + "div style=\"background: #e3f2fd; padding: 20px; margin: 10px 0;\">\\n" +
                    "  <" + "h2>Section Title<" + "/h2>\\n" +
                    "  <" + "p>This content is grouped inside a div.<" + "/p>\\n" +
                    "  <" + "p>Divs are perfect for creating sections.<" + "/p>\\n" +
                    "<" + "/div>\\n\\n" +
                    "<" + "div style=\"background: #fff3e0; padding: 20px; margin: 10px 0;\">\\n" +
                    "  <" + "h2>Another Section<" + "/h2>\\n" +
                    "  <" + "p>This is a separate grouped section.<" + "/p>\\n" +
                    "<" + "/div>";

                String spanHtml = "<" + "p>\\n" +
                    "  The price is <" + "span style=\"color: red; font-weight: bold;\">$99.99<" + "/span> today only!\\n" +
                    "<" + "/p>\\n\\n" +
                    "<" + "p>\\n" +
                    "  Status: <" + "span style=\"background: #4caf50; color: white; padding: 2px 8px; border-radius: 4px;\">Active<" + "/span>\\n" +
                    "<" + "/p>";

                String layoutHtml = "<" + "div style=\"max-width: 600px; margin: 0 auto;\">\\n" +
                    "  <" + "div style=\"background: #1976d2; color: white; padding: 15px; text-align: center;\">\\n" +
                    "    <" + "h1>Header<" + "/h1>\\n" +
                    "  <" + "/div>\\n" +
                    "  \\n" +
                    "  <" + "div style=\"display: flex;\">\\n" +
                    "    <" + "div style=\"background: #e3f2fd; padding: 15px; width: 70%;\">\\n" +
                    "      <" + "h2>Main Content<" + "/h2>\\n" +
                    "      <" + "p>This is the main area.<" + "/p>\\n" +
                    "    <" + "/div>\\n" +
                    "    <" + "div style=\"background: #bbdefb; padding: 15px; width: 30%;\">\\n" +
                    "      <" + "h3>Sidebar<" + "/h3>\\n" +
                    "    <" + "/div>\\n" +
                    "  <" + "/div>\\n" +
                    "  \\n" +
                    "  <" + "div style=\"background: #424242; color: white; padding: 10px; text-align: center;\">\\n" +
                    "    Footer\\n" +
                    "  <" + "/div>\\n" +
                    "<" + "/div>";
                %>

                <div class="lesson-body">
                    <h2>Generic Containers</h2>
                    <p>The <code>&lt;div&gt;</code> and <code>&lt;span&gt;</code> elements are generic containers with no semantic meaning. They're used purely for grouping and styling.</p>

                    <h2>The Div Element</h2>
                    <p><code>&lt;div&gt;</code> is a block-level container used to group larger sections of content:</p>
                    <ul>
                        <li>Creates page sections and layouts</li>
                        <li>Groups related content together</li>
                        <li>Applies styles to multiple elements at once</li>
                    </ul>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-div" />
                        <jsp:param name="initialHtml" value="<%= divHtml %>" />
                    </jsp:include>

                    <h2>The Span Element</h2>
                    <p><code>&lt;span&gt;</code> is an inline container used to style parts of text:</p>
                    <ul>
                        <li>Highlights specific words or phrases</li>
                        <li>Applies styles without breaking text flow</li>
                        <li>Targets specific text with JavaScript</li>
                    </ul>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-span" />
                        <jsp:param name="initialHtml" value="<%= spanHtml %>" />
                    </jsp:include>

                    <h2>Building Layouts with Div</h2>
                    <p>Divs are essential for creating page layouts:</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-layout" />
                        <jsp:param name="initialHtml" value="<%= layoutHtml %>" />
                    </jsp:include>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>Best Practice:</strong> Use semantic elements like <code>&lt;header&gt;</code>, <code>&lt;nav&gt;</code>, <code>&lt;main&gt;</code> when possible. Use div/span only when no semantic element fits.
                        </div>
                    </div>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-divspan" />
                        <jsp:param name="question" value="Which element should you use to highlight a word within a paragraph?" />
                        <jsp:param name="option1" value="&lt;div&gt;" />
                        <jsp:param name="option2" value="&lt;span&gt;" />
                        <jsp:param name="option3" value="&lt;p&gt;" />
                        <jsp:param name="option4" value="&lt;section&gt;" />
                        <jsp:param name="correctAnswer" value="1" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="block-inline.jsp" />
                        <jsp:param name="prevTitle" value="Block vs Inline" />
                        <jsp:param name="nextLink" value="classes-ids.jsp" />
                        <jsp:param name="nextTitle" value="Classes & IDs" />
                        <jsp:param name="currentLessonId" value="div-span" />
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
