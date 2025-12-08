<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - Audio & Video --%>
<% request.setAttribute("currentLesson", "audio-video"); request.setAttribute("currentModule", "Links & Media"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>HTML Audio & Video - Embedding Media | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn how to embed audio and video in HTML5 using the audio and video tags with controls, autoplay, and multiple sources.">
    <meta name="keywords" content="HTML audio, HTML video, embed video HTML, HTML5 media, video tag, audio tag, web media">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Audio & Video - Embedding Media">
    <meta property="og:description" content="Learn how to embed audio and video in HTML5 using the audio and video tags.">
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
        "name": "HTML Audio & Video",
        "description": "Learn how to embed audio and video in HTML5 using the audio and video tags",
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
<body class="tutorial-body" data-lesson="audio-video">
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
                    <span>Audio & Video</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">HTML Audio & Video</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~10 min read</span>
                    </div>
                </header>

                <%
                String audioHtml = "<" + "audio controls>\\n" +
                    "  <" + "source src=\"audio.mp3\" type=\"audio/mpeg\">\\n" +
                    "  Your browser does not support audio.\\n" +
                    "<" + "/audio>";

                String videoHtml = "<" + "video width=\"320\" height=\"240\" controls>\\n" +
                    "  <" + "source src=\"movie.mp4\" type=\"video/mp4\">\\n" +
                    "  <" + "source src=\"movie.ogg\" type=\"video/ogg\">\\n" +
                    "  Your browser does not support video.\\n" +
                    "<" + "/video>";

                String videoAttrsHtml = "<" + "video width=\"320\" height=\"240\"\\n" +
                    "       controls\\n" +
                    "       autoplay\\n" +
                    "       muted\\n" +
                    "       loop\\n" +
                    "       poster=\"thumbnail.jpg\">\\n" +
                    "  <" + "source src=\"movie.mp4\" type=\"video/mp4\">\\n" +
                    "<" + "/video>";
                %>

                <div class="lesson-body">
                    <h2>HTML5 Media Elements</h2>
                    <p>Before HTML5, playing audio or video required plugins like Flash. HTML5 introduced native <code>&lt;audio&gt;</code> and <code>&lt;video&gt;</code> elements.</p>

                    <h2>The Audio Element</h2>
                    <p>The <code>&lt;audio&gt;</code> element embeds sound content in documents.</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-audio" />
                        <jsp:param name="initialHtml" value="<%= audioHtml %>" />
                    </jsp:include>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>Tip:</strong> Common audio formats are MP3, WAV, and OGG. MP3 has the best browser support.
                        </div>
                    </div>

                    <h2>The Video Element</h2>
                    <p>The <code>&lt;video&gt;</code> element embeds video content. Use multiple <code>&lt;source&gt;</code> elements for different formats.</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-video" />
                        <jsp:param name="initialHtml" value="<%= videoHtml %>" />
                    </jsp:include>

                    <h2>Video Attributes</h2>
                    <ul>
                        <li><code>controls</code> - Shows play/pause, volume, etc.</li>
                        <li><code>autoplay</code> - Starts playing automatically</li>
                        <li><code>muted</code> - Mutes the audio (required for autoplay in most browsers)</li>
                        <li><code>loop</code> - Loops the video continuously</li>
                        <li><code>poster</code> - Image shown before video plays</li>
                        <li><code>width/height</code> - Sets dimensions</li>
                    </ul>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-attrs" />
                        <jsp:param name="initialHtml" value="<%= videoAttrsHtml %>" />
                    </jsp:include>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-media" />
                        <jsp:param name="question" value="Which attribute is required for autoplay to work in most browsers?" />
                        <jsp:param name="option1" value="controls" />
                        <jsp:param name="option2" value="muted" />
                        <jsp:param name="option3" value="loop" />
                        <jsp:param name="option4" value="poster" />
                        <jsp:param name="correctAnswer" value="1" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="images.jsp" />
                        <jsp:param name="prevTitle" value="Images" />
                        <jsp:param name="nextLink" value="iframes.jsp" />
                        <jsp:param name="nextTitle" value="Iframes" />
                        <jsp:param name="currentLessonId" value="audio-video" />
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
