<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - Block vs Inline --%>
<% request.setAttribute("currentLesson", "block-inline"); request.setAttribute("currentModule", "Layout & Structure"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>Block vs Inline Elements - Display Behavior | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn the difference between block-level and inline elements in HTML, and how they affect page layout and styling.">
    <meta name="keywords" content="block level elements, inline elements HTML, display block inline, HTML element types, block vs inline">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="Block vs Inline Elements - Display Behavior">
    <meta property="og:description" content="Learn the difference between block-level and inline elements in HTML.">
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
        "name": "Block vs Inline Elements",
        "description": "Learn the difference between block-level and inline elements in HTML",
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
<body class="tutorial-body" data-lesson="block-inline">
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
                    <span>Block vs Inline</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Block vs Inline Elements</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~8 min read</span>
                    </div>
                </header>

                <%
                String blockHtml = "<" + "div style=\"background: #e3f2fd; padding: 10px; margin: 5px 0;\">\\n" +
                    "  I am a DIV (block element)\\n" +
                    "<" + "/div>\\n" +
                    "<" + "p style=\"background: #fff3e0; padding: 10px; margin: 5px 0;\">\\n" +
                    "  I am a P (block element)\\n" +
                    "<" + "/p>\\n" +
                    "<" + "h3 style=\"background: #e8f5e9; padding: 10px; margin: 5px 0;\">\\n" +
                    "  I am an H3 (block element)\\n" +
                    "<" + "/h3>";

                String inlineHtml = "<" + "p>\\n" +
                    "  This is normal text with \\n" +
                    "  <" + "span style=\"background: #ffeb3b;\">a SPAN<" + "/span>, \\n" +
                    "  <" + "strong>strong text<" + "/strong>, \\n" +
                    "  <" + "a href=\"#\">a link<" + "/a>, and \\n" +
                    "  <" + "em>emphasized text<" + "/em>.\\n" +
                    "<" + "/p>";

                String compareHtml = "<" + "!-- Block: Takes full width -->\\n" +
                    "<" + "div style=\"background: #e3f2fd; padding: 10px;\">\\n" +
                    "  Block 1\\n" +
                    "<" + "/div>\\n" +
                    "<" + "div style=\"background: #bbdefb; padding: 10px;\">\\n" +
                    "  Block 2\\n" +
                    "<" + "/div>\\n\\n" +
                    "<" + "!-- Inline: Side by side -->\\n" +
                    "<" + "span style=\"background: #fff3e0; padding: 5px;\">Inline 1<" + "/span>\\n" +
                    "<" + "span style=\"background: #ffe0b2; padding: 5px;\">Inline 2<" + "/span>\\n" +
                    "<" + "span style=\"background: #ffcc80; padding: 5px;\">Inline 3<" + "/span>";
                %>

                <div class="lesson-body">
                    <h2>Two Display Types</h2>
                    <p>Every HTML element has a default display value. The two most common are <strong>block</strong> and <strong>inline</strong>.</p>

                    <h2>Block-Level Elements</h2>
                    <p>Block elements:</p>
                    <ul>
                        <li>Always start on a new line</li>
                        <li>Take up the full width available</li>
                        <li>Have top and bottom margins</li>
                    </ul>
                    <p>Common block elements: <code>&lt;div&gt;</code>, <code>&lt;p&gt;</code>, <code>&lt;h1&gt;-&lt;h6&gt;</code>, <code>&lt;ul&gt;</code>, <code>&lt;li&gt;</code>, <code>&lt;table&gt;</code>, <code>&lt;form&gt;</code></p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-block" />
                        <jsp:param name="initialHtml" value="<%= blockHtml %>" />
                    </jsp:include>

                    <h2>Inline Elements</h2>
                    <p>Inline elements:</p>
                    <ul>
                        <li>Do not start on a new line</li>
                        <li>Only take up as much width as needed</li>
                        <li>Cannot have top/bottom margins (only left/right)</li>
                    </ul>
                    <p>Common inline elements: <code>&lt;span&gt;</code>, <code>&lt;a&gt;</code>, <code>&lt;strong&gt;</code>, <code>&lt;em&gt;</code>, <code>&lt;img&gt;</code>, <code>&lt;input&gt;</code></p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-inline" />
                        <jsp:param name="initialHtml" value="<%= inlineHtml %>" />
                    </jsp:include>

                    <h2>Visual Comparison</h2>
                    <p>See how block elements stack vertically while inline elements flow horizontally:</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-compare" />
                        <jsp:param name="initialHtml" value="<%= compareHtml %>" />
                    </jsp:include>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>CSS Tip:</strong> You can change display behavior with CSS: <code>display: block;</code> or <code>display: inline;</code>
                        </div>
                    </div>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-block" />
                        <jsp:param name="question" value="Which element is a block-level element by default?" />
                        <jsp:param name="option1" value="&lt;span&gt;" />
                        <jsp:param name="option2" value="&lt;a&gt;" />
                        <jsp:param name="option3" value="&lt;div&gt;" />
                        <jsp:param name="option4" value="&lt;strong&gt;" />
                        <jsp:param name="correctAnswer" value="2" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="form-validation.jsp" />
                        <jsp:param name="prevTitle" value="Form Validation" />
                        <jsp:param name="nextLink" value="div-span.jsp" />
                        <jsp:param name="nextTitle" value="Div & Span" />
                        <jsp:param name="currentLessonId" value="block-inline" />
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
