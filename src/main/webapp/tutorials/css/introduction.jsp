<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Introduction Lesson 1: What is CSS? --%>
        <% // Set current lesson for sidebar highlighting request.setAttribute("currentLesson", "introduction" );
            request.setAttribute("currentModule", "Getting Started" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <%-- SEO --%>
                    <title>CSS Introduction - Learn What CSS Is | 8gwifi.org Tutorials</title>
                    <meta name="description"
                        content="Learn what CSS is and why it's essential for web design. Start your CSS journey with this beginner-friendly tutorial.">
                    <meta name="keywords"
                        content="CSS tutorial, what is CSS, learn CSS, CSS for beginners, web design, styling">

                    <%-- Open Graph --%>
                        <meta property="og:type" content="article">
                        <meta property="og:title" content="CSS Introduction - Learn What CSS Is">
                        <meta property="og:description"
                            content="Learn what CSS is and why it's essential for web design.">
                        <meta property="og:site_name" content="8gwifi.org Tutorials">

                        <%-- Favicon --%>
                            <link rel="icon" type="image/svg+xml"
                                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">

                            <%-- Fonts & CSS --%>
                                <link rel="stylesheet"
                                    href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
                                <link rel="stylesheet"
                                    href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
                                <link rel="stylesheet"
                                    href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
                                <link rel="stylesheet"
                                    href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

                                <%-- Prevent FOUC --%>
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
        "name": "CSS Introduction",
        "description": "Learn what CSS is and why it's essential for web design",
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

            <body class="tutorial-body" data-lesson="introduction">
                <div class="tutorial-layout">
                    <%-- Header --%>
                        <%@ include file="../tutorial-header.jsp" %>

                            <%-- Main Content Area --%>
                                <main class="tutorial-main">
                                    <%-- Sidebar --%>
                                        <%@ include file="../tutorial-sidebar-css.jsp" %>

                                            <%-- Overlay for mobile sidebar --%>
                                                <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()">
                                                </div>

                                                <%-- Lesson Content --%>
                                                    <article class="tutorial-content">
                                                        <%-- Breadcrumb --%>
                                                            <nav class="breadcrumb">
                                                                <a
                                                                    href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                                                <span class="breadcrumb-separator">/</span>
                                                                <a
                                                                    href="<%=request.getContextPath()%>/tutorials/css/">CSS</a>
                                                                <span class="breadcrumb-separator">/</span>
                                                                <span>Introduction</span>
                                                            </nav>

                                                            <%-- Lesson Header --%>
                                                                <header class="lesson-header">
                                                                    <h1 class="lesson-title">Introduction to CSS</h1>
                                                                    <div class="lesson-meta">
                                                                        <span>Beginner</span>
                                                                        <span>~5 min read</span>
                                                                    </div>
                                                                </header>

                                                                <%-- Lesson Body --%>
                                                                    <div class="lesson-body">
                                                                        <h2>What is CSS?</h2>
                                                                        <p>
                                                                            <strong>CSS</strong> stands for
                                                                            <strong>Cascading Style Sheets</strong>. It
                                                                            is the language used to style and layout web
                                                                            pages. While HTML provides the structure and
                                                                            content, CSS makes it look beautiful.
                                                                        </p>
                                                                        <p>
                                                                            Think of HTML as the skeleton and organs of
                                                                            a body, and CSS as the skin, hair, and
                                                                            clothes that make it presentable.
                                                                        </p>

                                                                        <h2>Why Use CSS?</h2>
                                                                        <div class="card"
                                                                            style="margin-bottom: var(--space-6);">
                                                                            <ul
                                                                                style="margin: 0; padding-left: var(--space-6);">
                                                                                <li><strong>Separation of
                                                                                        Concerns</strong> - Keep content
                                                                                    (HTML) separate from presentation
                                                                                    (CSS)</li>
                                                                                <li><strong>Reusability</strong> - One
                                                                                    stylesheet can style multiple pages
                                                                                </li>
                                                                                <li><strong>Maintainability</strong> -
                                                                                    Change the entire site's look by
                                                                                    editing one file</li>
                                                                                <li><strong>Responsive Design</strong> -
                                                                                    Adapt layouts for different screen
                                                                                    sizes</li>
                                                                                <li><strong>Performance</strong> -
                                                                                    Faster page loads with external
                                                                                    stylesheets</li>
                                                                            </ul>
                                                                        </div>

                                                                        <h2>CSS Syntax</h2>
                                                                        <p>CSS consists of <strong>rules</strong>. Each
                                                                            rule has two main parts:</p>

                                                                        <div class="card"
                                                                            style="background: var(--bg-code); border: none; margin-bottom: var(--space-6);">
                                                                            <pre><code style="color: #f8f8f2;">selector {
  property: value;
  property: value;
}</code></pre>
                                                                        </div>

                                                                        <ul>
                                                                            <li><strong>Selector</strong> - Targets the
                                                                                HTML element(s) to style</li>
                                                                            <li><strong>Property</strong> - The aspect
                                                                                you want to change (e.g., color,
                                                                                font-size)</li>
                                                                            <li><strong>Value</strong> - The setting for
                                                                                that property</li>
                                                                        </ul>

                                                                        <h2>Your First CSS</h2>
                                                                        <p>
                                                                            Let's see CSS in action! The example below
                                                                            shows HTML with CSS styling. Try changing
                                                                            the color value in the CSS tab and click
                                                                            "Run" to see the result.
                                                                        </p>

                                                                        <jsp:include page="../tutorial-editor.jsp">
                                                                            <jsp:param name="editorId"
                                                                                value="editor-intro" />
                                                                            <jsp:param name="initialHtml"
                                                                                value="<h1>Welcome to CSS!</h1>\n<p>CSS makes websites beautiful.</p>\n<p class='highlight'>This paragraph has a special style.</p>" />
                                                                            <jsp:param name="initialCss"
                                                                                value="h1 {\n  color: #2563eb;\n  font-size: 32px;\n}\n\np {\n  color: #64748b;\n  line-height: 1.6;\n}\n\n.highlight {\n  background-color: #fef3c7;\n  padding: 12px;\n  border-radius: 8px;\n}" />
                                                                        </jsp:include>

                                                                        <div class="callout callout-tip">
                                                                            <svg class="callout-icon"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <circle cx="12" cy="12" r="10" />
                                                                                <path d="M12 16v-4M12 8h.01" />
                                                                            </svg>
                                                                            <div class="callout-content">
                                                                                <strong>Try It:</strong> Change
                                                                                <code>#2563eb</code> to <code>red</code>
                                                                                or <code>#10b981</code> and see the
                                                                                heading color change!
                                                                            </div>
                                                                        </div>

                                                                        <h2>Key Takeaways</h2>
                                                                        <div class="card"
                                                                            style="margin: var(--space-6) 0;">
                                                                            <ul
                                                                                style="margin: 0; padding-left: var(--space-6);">
                                                                                <li>CSS stands for <strong>Cascading
                                                                                        Style Sheets</strong></li>
                                                                                <li>CSS is used to <strong>style and
                                                                                        layout</strong> web pages</li>
                                                                                <li>CSS uses <strong>selectors</strong>
                                                                                    to target HTML elements</li>
                                                                                <li>CSS rules consist of
                                                                                    <strong>properties and
                                                                                        values</strong></li>
                                                                                <li>CSS makes websites <strong>beautiful
                                                                                        and responsive</strong></li>
                                                                            </ul>
                                                                        </div>

                                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                                            <jsp:param name="quizId"
                                                                                value="quiz-intro" />
                                                                            <jsp:param name="question"
                                                                                value="What does CSS stand for?" />
                                                                            <jsp:param name="option1"
                                                                                value="Computer Style Sheets" />
                                                                            <jsp:param name="option2"
                                                                                value="Cascading Style Sheets" />
                                                                            <jsp:param name="option3"
                                                                                value="Creative Style System" />
                                                                            <jsp:param name="option4"
                                                                                value="Colorful Style Sheets" />
                                                                            <jsp:param name="correctAnswer" value="1" />
                                                                        </jsp:include>

                                                                        <jsp:include page="../tutorial-nav.jsp">
                                                                            <jsp:param name="nextLink"
                                                                                value="adding-css.jsp" />
                                                                            <jsp:param name="nextTitle"
                                                                                value="Adding CSS" />
                                                                            <jsp:param name="currentLessonId"
                                                                                value="introduction" />
                                                                        </jsp:include>
                                                                    </div>
                                                    </article>

                                                    <%-- Live Preview Panel --%>
                                                        <aside class="tutorial-preview" id="previewPanel">
                                                            <div class="preview-header">
                                                                <span>Live Preview</span>
                                                                <button class="btn btn-ghost btn-icon"
                                                                    onclick="refreshPreview()" title="Refresh">
                                                                    <svg width="16" height="16" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path d="M23 4v6h-6M1 20v-6h6" />
                                                                        <path
                                                                            d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15" />
                                                                    </svg>
                                                                </button>
                                                            </div>
                                                            <iframe id="previewFrame" class="preview-frame"
                                                                sandbox="allow-scripts allow-same-origin"
                                                                title="Live Preview"></iframe>
                                                        </aside>
                                </main>

                                <%-- Footer --%>
                                    <%@ include file="../tutorial-footer.jsp" %>
                </div>

                <%-- JavaScript --%>
                    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
                    <script
                        src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
                    <script
                        src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
                    <script
                        src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
                    <script
                        src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
                    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
                    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            </body>

            </html>