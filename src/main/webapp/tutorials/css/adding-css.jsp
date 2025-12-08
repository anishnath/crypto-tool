<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Adding CSS Lesson 2: How to Add CSS to HTML --%>
        <% request.setAttribute("currentLesson", "adding-css" ); request.setAttribute("currentModule", "Getting Started"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>Adding CSS to HTML - Three Methods | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn the three ways to add CSS to HTML: inline, internal, and external stylesheets. Understand best practices for each method.">
                <meta name="keywords"
                    content="CSS tutorial, add CSS, inline CSS, internal CSS, external CSS, stylesheet">

                <meta property="og:type" content="article">
                <meta property="og:title" content="Adding CSS to HTML - Three Methods">
                <meta property="og:description" content="Learn the three ways to add CSS to HTML and best practices.">
                <meta property="og:site_name" content="8gwifi.org Tutorials">

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

                <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Adding CSS to HTML",
        "description": "Learn the three ways to add CSS to HTML and best practices",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "isPartOf": {
            "@type": "Course",
            "name": "CSS Tutorial",
            "url": "https://8gwifi.org/tutorials/css/"
        }
    }
    </script>
            <%-- Ads --%>
                <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
            </head>

            <body class="tutorial-body" data-lesson="adding-css">
                <div class="tutorial-layout">
                    <%@ include file="../tutorial-header.jsp" %>

                        <main class="tutorial-main">
                            <%@ include file="../tutorial-sidebar-css.jsp" %>
                                <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                                <article class="tutorial-content">
                                    <nav class="breadcrumb">
                                        <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <a href="<%=request.getContextPath()%>/tutorials/css/">CSS</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <span>Adding CSS</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Adding CSS to HTML</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~7 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Three Ways to Add CSS</h2>
                                        <p>
                                            There are three methods to apply CSS to HTML documents. Each has its use
                                            case, but some are better than others for most situations.
                                        </p>

                                        <h2>1. Inline CSS</h2>
                                        <p>
                                            Inline CSS uses the <code>style</code> attribute directly on HTML elements.
                                            This method has the highest specificity but is generally not recommended.
                                        </p>
                                        <%
                                            String inlineHtml = "<h1 style=\"color: #dc2626; font-size: 28px;\">Inline CSS</h1>\n<p style=\"color: #64748b;\">This paragraph uses inline styling.</p>";
                                            String inlineCss = "/* Inline styles are in the HTML, not here */\n/* Try adding styles here - they won't override inline styles! */";
                                        %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-inline" />
                                                <jsp:param name="initialHtml" value="<%=inlineHtml%>" />
                                                <jsp:param name="initialCss" value="<%=inlineCss%>" />
                                            </jsp:include>



                                            <div class="callout callout-warning">
                                                <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path
                                                        d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                                                    <line x1="12" y1="9" x2="12" y2="13" />
                                                    <line x1="12" y1="17" x2="12.01" y2="17" />
                                                </svg>
                                                <div class="callout-content">
                                                    <strong>Not Recommended:</strong> Inline CSS mixes content with
                                                    presentation and is hard to maintain.
                                                </div>
                                            </div>

                                            <h2>2. Internal CSS</h2>
                                            <p>
                                                Internal CSS uses a <code>&lt;style&gt;</code> tag in the
                                                <code>&lt;head&gt;</code> section. Good for single-page styling or quick
                                                prototypes.
                                            </p>


                                            <% String internalHtml = "<!DOCTYPE html>\\n<html>\\n<head>\\n<style>\\nh1 { color: #2563eb; }\\np { color: #475569; }\\n</style>\\n</head>\\n<body>\\n<h1>Internal CSS</h1>\\n<p>Styles are in the head section.</p>\\n</body>\\n</html>"; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-internal" />
                                                    <jsp:param name="initialHtml" value="<%=internalHtml%>" />
                                                </jsp:include>


                                                <h2>3. External CSS (Recommended)</h2>
                                                <p>
                                                    External CSS uses a separate <code>.css</code> file linked with the
                                                    <code>&lt;link&gt;</code> tag. This is the <strong>best
                                                        practice</strong>
                                                    for most websites.
                                                </p>

                                                <div class="card"
                                                    style="background: var(--bg-code); border: none; margin-bottom: var(--space-6);">
                                                    <pre><code style="color: #f8f8f2;"><!-- In your HTML file -->
&lt;head&gt;
  &lt;link rel="stylesheet" href="styles.css"&gt;
&lt;/head&gt;</code></pre>
                                                </div>

                                                <div class="card"
                                                    style="background: var(--bg-code); border: none; margin-bottom: var(--space-6);">
                                                    <pre><code style="color: #f8f8f2;">/* In styles.css */
h1 {
  color: #2563eb;
  font-size: 32px;
}

p {
  color: #475569;
  line-height: 1.6;
}</code></pre>
                                                </div>

                                                <h2>Why External CSS is Best</h2>
                                                <div class="card" style="margin-bottom: var(--space-6);">
                                                    <ul style="margin: 0; padding-left: var(--space-6);">
                                                        <li><strong>Reusability</strong> - One stylesheet for multiple
                                                            pages
                                                        </li>
                                                        <li><strong>Maintainability</strong> - Update styles in one
                                                            place
                                                        </li>
                                                        <li><strong>Caching</strong> - Browser caches the CSS file for
                                                            faster
                                                            loads</li>
                                                        <li><strong>Separation</strong> - Clean separation of content
                                                            and
                                                            presentation</li>
                                                        <li><strong>Organization</strong> - Easier to manage large
                                                            projects
                                                        </li>
                                                    </ul>
                                                </div>

                                                <jsp:include page="../tutorial-quiz.jsp">
                                                    <jsp:param name="quizId" value="quiz-adding" />
                                                    <jsp:param name="question"
                                                        value="Which method is recommended for adding CSS to most websites?" />
                                                    <jsp:param name="option1" value="Inline CSS" />
                                                    <jsp:param name="option2" value="Internal CSS" />
                                                    <jsp:param name="option3" value="External CSS" />
                                                    <jsp:param name="option4" value="All are equally good" />
                                                    <jsp:param name="correctAnswer" value="2" />
                                                </jsp:include>

                                                <jsp:include page="../tutorial-nav.jsp">
                                                    <jsp:param name="prevLink" value="introduction.jsp" />
                                                    <jsp:param name="prevTitle" value="Introduction" />
                                                    <jsp:param name="nextLink" value="selectors-basics.jsp" />
                                                    <jsp:param name="nextTitle" value="Selectors Basics" />
                                                    <jsp:param name="currentLessonId" value="adding-css" />
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