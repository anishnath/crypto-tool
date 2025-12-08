<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - Iframes --%>
<% request.setAttribute("currentLesson", "iframes"); request.setAttribute("currentModule", "Links & Media"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>HTML Iframes - Embedding External Content | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn how to use iframes to embed external content like YouTube videos, maps, and other webpages in your HTML documents.">
    <meta name="keywords" content="HTML iframe, embed YouTube HTML, iframe tutorial, embed webpage, HTML embed content, iframe tag">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Iframes - Embedding External Content">
    <meta property="og:description" content="Learn how to use iframes to embed external content like YouTube videos and maps.">
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
        "name": "HTML Iframes",
        "description": "Learn how to use iframes to embed external content like YouTube videos and maps",
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
<body class="tutorial-body" data-lesson="iframes">
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
                    <span>Iframes</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">HTML Iframes</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~8 min read</span>
                    </div>
                </header>

                <%
                String iframeBasic = "<" + "iframe src=\"https://example.com\"\\n" +
                    "        width=\"400\"\\n" +
                    "        height=\"300\">\\n" +
                    "<" + "/iframe>";

                String iframeYoutube = "<" + "iframe width=\"560\" height=\"315\"\\n" +
                    "        src=\"https://www.youtube.com/embed/dQw4w9WgXcQ\"\\n" +
                    "        frameborder=\"0\"\\n" +
                    "        allowfullscreen>\\n" +
                    "<" + "/iframe>";

                String iframeSandbox = "<" + "iframe src=\"https://example.com\"\\n" +
                    "        sandbox=\"allow-scripts allow-same-origin\"\\n" +
                    "        width=\"400\"\\n" +
                    "        height=\"300\">\\n" +
                    "<" + "/iframe>";
                %>

                <div class="lesson-body">
                    <h2>What is an Iframe?</h2>
                    <p>An <code>&lt;iframe&gt;</code> (inline frame) is used to embed another HTML document within the current page. It's commonly used for:</p>
                    <ul>
                        <li>Embedding YouTube videos</li>
                        <li>Displaying Google Maps</li>
                        <li>Showing content from other websites</li>
                        <li>Embedding third-party widgets</li>
                    </ul>

                    <h2>Basic Iframe Syntax</h2>
                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-basic" />
                        <jsp:param name="initialHtml" value="<%= iframeBasic %>" />
                    </jsp:include>

                    <h2>Embedding YouTube Videos</h2>
                    <p>YouTube provides embed codes that use iframes. Click "Share" then "Embed" on any YouTube video to get the code.</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-youtube" />
                        <jsp:param name="initialHtml" value="<%= iframeYoutube %>" />
                    </jsp:include>

                    <h2>Iframe Attributes</h2>
                    <ul>
                        <li><code>src</code> - URL of the page to embed</li>
                        <li><code>width/height</code> - Dimensions of the iframe</li>
                        <li><code>frameborder</code> - Border around iframe (use 0 for none)</li>
                        <li><code>allowfullscreen</code> - Allows fullscreen mode</li>
                        <li><code>sandbox</code> - Applies extra restrictions for security</li>
                        <li><code>loading="lazy"</code> - Defers loading until visible</li>
                    </ul>

                    <h2>Security with Sandbox</h2>
                    <p>The <code>sandbox</code> attribute restricts what the iframe can do:</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-sandbox" />
                        <jsp:param name="initialHtml" value="<%= iframeSandbox %>" />
                    </jsp:include>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>Security Note:</strong> Some websites block being embedded in iframes using X-Frame-Options headers.
                        </div>
                    </div>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-iframes" />
                        <jsp:param name="question" value="What attribute is used to enable fullscreen mode for embedded videos?" />
                        <jsp:param name="option1" value="fullscreen" />
                        <jsp:param name="option2" value="allowfullscreen" />
                        <jsp:param name="option3" value="enablefullscreen" />
                        <jsp:param name="option4" value="fullscreenmode" />
                        <jsp:param name="correctAnswer" value="1" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="audio-video.jsp" />
                        <jsp:param name="prevTitle" value="Audio & Video" />
                        <jsp:param name="nextLink" value="lists.jsp" />
                        <jsp:param name="nextTitle" value="Lists" />
                        <jsp:param name="currentLessonId" value="iframes" />
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
