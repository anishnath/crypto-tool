<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - Page Layout --%>
<% request.setAttribute("currentLesson", "page-layout"); request.setAttribute("currentModule", "Semantic HTML"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>HTML Page Layout - Semantic Structure | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn how to structure web pages using semantic HTML5 elements like header, nav, main, article, section, aside, and footer.">
    <meta name="keywords" content="HTML page layout, semantic HTML5, header nav main footer, article section aside, HTML structure">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Page Layout - Semantic Structure">
    <meta property="og:description" content="Learn how to structure web pages using semantic HTML5 elements.">
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
        "name": "HTML Page Layout",
        "description": "Learn how to structure web pages using semantic HTML5 elements",
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
<body class="tutorial-body" data-lesson="page-layout">
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
                    <span>Page Layout</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">HTML Page Layout</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~12 min read</span>
                    </div>
                </header>

                <%
                String layoutHtml = "<" + "header style=\"background: #1976d2; color: white; padding: 20px;\">\\n" +
                    "  <" + "h1>My Website<" + "/h1>\\n" +
                    "  <" + "nav>\\n" +
                    "    <" + "a href=\"#\" style=\"color: white; margin-right: 15px;\">Home<" + "/a>\\n" +
                    "    <" + "a href=\"#\" style=\"color: white; margin-right: 15px;\">About<" + "/a>\\n" +
                    "    <" + "a href=\"#\" style=\"color: white;\">Contact<" + "/a>\\n" +
                    "  <" + "/nav>\\n" +
                    "<" + "/header>\\n\\n" +
                    "<" + "main style=\"padding: 20px;\">\\n" +
                    "  <" + "h2>Welcome<" + "/h2>\\n" +
                    "  <" + "p>This is the main content area.<" + "/p>\\n" +
                    "<" + "/main>\\n\\n" +
                    "<" + "footer style=\"background: #333; color: white; padding: 15px; text-align: center;\">\\n" +
                    "  <" + "p>&copy; 2024 My Website<" + "/p>\\n" +
                    "<" + "/footer>";

                String articleHtml = "<" + "article style=\"border: 1px solid #ddd; padding: 20px; margin: 10px 0;\">\\n" +
                    "  <" + "header>\\n" +
                    "    <" + "h2>Blog Post Title<" + "/h2>\\n" +
                    "    <" + "p style=\"color: #666;\">Posted on January 15, 2024<" + "/p>\\n" +
                    "  <" + "/header>\\n" +
                    "  <" + "p>This is the article content. Articles represent independent, self-contained content.<" + "/p>\\n" +
                    "  <" + "footer>\\n" +
                    "    <" + "p>Written by: John Doe<" + "/p>\\n" +
                    "  <" + "/footer>\\n" +
                    "<" + "/article>";

                String sectionAsideHtml = "<" + "div style=\"display: flex; gap: 20px;\">\\n" +
                    "  <" + "main style=\"flex: 1;\">\\n" +
                    "    <" + "section style=\"background: #e3f2fd; padding: 15px; margin-bottom: 15px;\">\\n" +
                    "      <" + "h2>Section 1<" + "/h2>\\n" +
                    "      <" + "p>Sections group related content.<" + "/p>\\n" +
                    "    <" + "/section>\\n" +
                    "    <" + "section style=\"background: #e8f5e9; padding: 15px;\">\\n" +
                    "      <" + "h2>Section 2<" + "/h2>\\n" +
                    "      <" + "p>Another thematic section.<" + "/p>\\n" +
                    "    <" + "/section>\\n" +
                    "  <" + "/main>\\n" +
                    "  <" + "aside style=\"width: 200px; background: #fff3e0; padding: 15px;\">\\n" +
                    "    <" + "h3>Sidebar<" + "/h3>\\n" +
                    "    <" + "p>Related links, ads, or extra info.<" + "/p>\\n" +
                    "  <" + "/aside>\\n" +
                    "<" + "/div>";
                %>

                <div class="lesson-body">
                    <h2>Semantic Page Structure</h2>
                    <p>HTML5 introduced semantic elements that describe the purpose of content, making pages more meaningful to browsers, search engines, and screen readers.</p>

                    <h2>Core Layout Elements</h2>
                    <ul>
                        <li><code>&lt;header&gt;</code> - Introductory content, navigation</li>
                        <li><code>&lt;nav&gt;</code> - Navigation links</li>
                        <li><code>&lt;main&gt;</code> - Main unique content (only one per page)</li>
                        <li><code>&lt;footer&gt;</code> - Footer content, copyright, links</li>
                    </ul>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-layout" />
                        <jsp:param name="initialHtml" value="<%= layoutHtml %>" />
                    </jsp:include>

                    <h2>The Article Element</h2>
                    <p><code>&lt;article&gt;</code> represents independent, self-contained content that could be distributed separately (blog posts, news articles, comments).</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-article" />
                        <jsp:param name="initialHtml" value="<%= articleHtml %>" />
                    </jsp:include>

                    <h2>Section and Aside</h2>
                    <ul>
                        <li><code>&lt;section&gt;</code> - Thematic grouping of content with a heading</li>
                        <li><code>&lt;aside&gt;</code> - Content tangentially related (sidebars, pull quotes)</li>
                    </ul>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-section" />
                        <jsp:param name="initialHtml" value="<%= sectionAsideHtml %>" />
                    </jsp:include>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>SEO Benefit:</strong> Search engines use semantic elements to better understand your content structure and importance.
                        </div>
                    </div>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-layout" />
                        <jsp:param name="question" value="How many &lt;main&gt; elements should a page have?" />
                        <jsp:param name="option1" value="One" />
                        <jsp:param name="option2" value="Multiple" />
                        <jsp:param name="option3" value="None required" />
                        <jsp:param name="option4" value="Two" />
                        <jsp:param name="correctAnswer" value="0" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="classes-ids.jsp" />
                        <jsp:param name="prevTitle" value="Classes & IDs" />
                        <jsp:param name="nextLink" value="entities.jsp" />
                        <jsp:param name="nextTitle" value="HTML Entities" />
                        <jsp:param name="currentLessonId" value="page-layout" />
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
