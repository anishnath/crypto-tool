<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- HTML Tutorial - Meta Tags & SEO --%>
<% request.setAttribute("currentLesson", "meta-seo"); request.setAttribute("currentModule", "Advanced Topics"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%-- SEO --%>
    <title>HTML Meta Tags & SEO - Search Optimization | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn about HTML meta tags for SEO, viewport settings, Open Graph, and how to optimize your pages for search engines.">
    <meta name="keywords" content="HTML meta tags, SEO HTML, Open Graph tags, meta description, viewport meta, search optimization">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Meta Tags & SEO - Search Optimization">
    <meta property="og:description" content="Learn about HTML meta tags for SEO and how to optimize your pages.">
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
        "name": "HTML Meta Tags & SEO",
        "description": "Learn about HTML meta tags for SEO and how to optimize your pages for search engines",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
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
<body class="tutorial-body" data-lesson="meta-seo">
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
                    <span>Meta Tags & SEO</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Meta Tags & SEO</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~12 min read</span>
                    </div>
                </header>

                <%
                String basicMeta = "<" + "head>\\n" +
                    "  <" + "meta charset=\"UTF-8\">\\n" +
                    "  <" + "meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\\n" +
                    "  <" + "title>Page Title - Site Name<" + "/title>\\n" +
                    "  <" + "meta name=\"description\" content=\"A brief description of your page (150-160 chars)\">\\n" +
                    "  <" + "meta name=\"keywords\" content=\"keyword1, keyword2, keyword3\">\\n" +
                    "  <" + "meta name=\"author\" content=\"Your Name\">\\n" +
                    "<" + "/head>";

                String ogMeta = "<" + "head>\\n" +
                    "  <" + "!-- Open Graph for Facebook, LinkedIn -->\\n" +
                    "  <" + "meta property=\"og:title\" content=\"Your Page Title\">\\n" +
                    "  <" + "meta property=\"og:description\" content=\"Description for social sharing\">\\n" +
                    "  <" + "meta property=\"og:image\" content=\"https://example.com/image.jpg\">\\n" +
                    "  <" + "meta property=\"og:url\" content=\"https://example.com/page\">\\n" +
                    "  <" + "meta property=\"og:type\" content=\"website\">\\n" +
                    "  \\n" +
                    "  <" + "!-- Twitter Card -->\\n" +
                    "  <" + "meta name=\"twitter:card\" content=\"summary_large_image\">\\n" +
                    "  <" + "meta name=\"twitter:title\" content=\"Your Page Title\">\\n" +
                    "  <" + "meta name=\"twitter:description\" content=\"Description for Twitter\">\\n" +
                    "<" + "/head>";

                String robotsMeta = "<" + "head>\\n" +
                    "  <" + "!-- Allow indexing (default) -->\\n" +
                    "  <" + "meta name=\"robots\" content=\"index, follow\">\\n" +
                    "  \\n" +
                    "  <" + "!-- Prevent indexing -->\\n" +
                    "  <" + "meta name=\"robots\" content=\"noindex, nofollow\">\\n" +
                    "  \\n" +
                    "  <" + "!-- Canonical URL (prevents duplicate content) -->\\n" +
                    "  <" + "link rel=\"canonical\" href=\"https://example.com/preferred-url\">\\n" +
                    "<" + "/head>";
                %>

                <div class="lesson-body">
                    <h2>What are Meta Tags?</h2>
                    <p>Meta tags provide metadata about your HTML document. They don't appear on the page but are read by browsers and search engines.</p>

                    <h2>Essential Meta Tags</h2>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-basic" />
                        <jsp:param name="initialHtml" value="<%= basicMeta %>" />
                    </jsp:include>

                    <h3>Key Meta Tags Explained:</h3>
                    <ul>
                        <li><code>charset</code> - Character encoding (always use UTF-8)</li>
                        <li><code>viewport</code> - Essential for responsive design on mobile</li>
                        <li><code>description</code> - Shows in search results (keep under 160 chars)</li>
                        <li><code>keywords</code> - Less important now, but still used by some engines</li>
                    </ul>

                    <h2>Social Media Meta Tags</h2>
                    <p>Open Graph and Twitter Cards control how your pages appear when shared:</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-og" />
                        <jsp:param name="initialHtml" value="<%= ogMeta %>" />
                    </jsp:include>

                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>Image Tip:</strong> Use images at least 1200x630px for best display on social media.
                        </div>
                    </div>

                    <h2>SEO & Robots</h2>
                    <p>Control how search engines index your pages:</p>

                    <jsp:include page="../tutorial-editor.jsp">
                        <jsp:param name="editorId" value="editor-robots" />
                        <jsp:param name="initialHtml" value="<%= robotsMeta %>" />
                    </jsp:include>

                    <h2>SEO Best Practices</h2>
                    <ul>
                        <li>Use unique, descriptive titles (50-60 characters)</li>
                        <li>Write compelling meta descriptions</li>
                        <li>Use semantic HTML elements</li>
                        <li>Include alt text on all images</li>
                        <li>Use proper heading hierarchy (h1 &rarr; h2 &rarr; h3)</li>
                        <li>Make your site mobile-friendly</li>
                        <li>Use HTTPS for security</li>
                    </ul>

                    <jsp:include page="../tutorial-quiz.jsp">
                        <jsp:param name="quizId" value="quiz-meta" />
                        <jsp:param name="question" value="What is the recommended maximum length for a meta description?" />
                        <jsp:param name="option1" value="50 characters" />
                        <jsp:param name="option2" value="160 characters" />
                        <jsp:param name="option3" value="500 characters" />
                        <jsp:param name="option4" value="No limit" />
                        <jsp:param name="correctAnswer" value="1" />
                    </jsp:include>

                    <jsp:include page="../tutorial-nav.jsp">
                        <jsp:param name="prevLink" value="entities.jsp" />
                        <jsp:param name="prevTitle" value="HTML Entities" />
                        <jsp:param name="nextLink" value="accessibility.jsp" />
                        <jsp:param name="nextTitle" value="Accessibility" />
                        <jsp:param name="currentLessonId" value="meta-seo" />
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
