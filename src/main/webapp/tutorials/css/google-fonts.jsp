<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Google Fonts Lesson 7: Using Google Fonts in Your Website --%>
        <% request.setAttribute("currentLesson", "google-fonts" ); request.setAttribute("currentModule", "Text & Fonts"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>Google Fonts in CSS - Free Web Fonts | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to use Google Fonts in your website. Add beautiful, free web fonts to enhance your typography and design.">
                <meta name="keywords"
                    content="Google Fonts, web fonts, CSS fonts, font-family, custom fonts, typography">

                <meta property="og:type" content="article">
                <meta property="og:title" content="Using Google Fonts in CSS">
                <meta property="og:description" content="Add beautiful Google Fonts to your website.">
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
        "name": "Google Fonts in CSS",
        "description": "Learn to use Google Fonts in your website",
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

            <body class="tutorial-body" data-lesson="google-fonts">
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
                                        <span>Google Fonts</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Using Google Fonts</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~6 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Google Fonts?</h2>
                                        <p>
                                            Google Fonts is a free library of over 1,400 fonts that you can use on your
                                            website. They're optimized for the web, easy to use, and completely free.
                                        </p>

                                        <h2>How to Add Google Fonts</h2>
                                        <p>
                                            There are two ways to add Google Fonts: using a <code>&lt;link&gt;</code>
                                            tag in HTML or <code>@import</code> in CSS. The link method is recommended
                                            for better performance.
                                        </p>

                                        <div class="card"
                                            style="background: var(--bg-code); border: none; margin: var(--space-6) 0;">
                                            <pre><code style="color: #f8f8f2;"><!-- In your HTML <head> -->
&lt;link rel="preconnect" href="https://fonts.googleapis.com"&gt;
&lt;link rel="preconnect" href="https://fonts.gstatic.com" crossorigin&gt;
&lt;link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet"&gt;</code></pre>
                                        </div>

                                        <h2>Using the Font in CSS</h2>
                                        <p>
                                            Once you've added the link, use the font in your CSS with
                                            <code>font-family</code>. Always include fallback fonts.
                                        </p>

                                        <% String
                                            googleFontHtml="<h1 class='roboto'>This uses Roboto font</h1>\n<p class='roboto'>Roboto is a modern, clean sans-serif font designed by Google.</p>\n<h2 class='playfair'>This uses Playfair Display</h2>\n<p class='playfair'>Playfair is an elegant serif font perfect for headings.</p>"
                                            ; String
                                            googleFontCss="/* Simulating Google Fonts */\n.roboto {\n  font-family: 'Roboto', Arial, sans-serif;\n  font-weight: 400;\n}\n\n.playfair {\n  font-family: 'Playfair Display', Georgia, serif;\n  font-weight: 700;\n  font-style: italic;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-google" />
                                                <jsp:param name="initialHtml" value="<%=googleFontHtml%>" />
                                                <jsp:param name="initialCss" value="<%=googleFontCss%>" />
                                            </jsp:include>

                                            <h2>Popular Font Combinations</h2>
                                            <p>
                                                Pairing fonts effectively creates visual hierarchy. Here are some
                                                popular combinations:
                                            </p>

                                            <% String
                                                pairingHtml="<div class='combo1'>\n  <h2>Montserrat + Open Sans</h2>\n  <p>Modern and clean combination for tech websites.</p>\n</div>\n<div class='combo2'>\n  <h2>Playfair Display + Lato</h2>\n  <p>Elegant serif heading with readable sans-serif body.</p>\n</div>"
                                                ; String
                                                pairingCss=".combo1 h2 {\n  font-family: 'Montserrat', sans-serif;\n  font-weight: 700;\n}\n\n.combo1 p {\n  font-family: 'Open Sans', sans-serif;\n}\n\n.combo2 h2 {\n  font-family: 'Playfair Display', serif;\n  font-weight: 700;\n}\n\n.combo2 p {\n  font-family: 'Lato', sans-serif;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-pairing" />
                                                    <jsp:param name="initialHtml" value="<%=pairingHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=pairingCss%>" />
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
                                                        <strong>Performance Tip:</strong> Only load the font weights you
                                                        actually use. Loading too many variants slows down your website.
                                                    </div>
                                                </div>

                                                <h2>Best Practices</h2>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <ul style="margin: 0; padding-left: var(--space-6);">
                                                        <li><strong>Limit fonts</strong> - Use 2-3 fonts maximum per
                                                            website</li>
                                                        <li><strong>Load only needed weights</strong> - Don't load all 9
                                                            weights if you only use 2</li>
                                                        <li><strong>Use <code>font-display: swap</code></strong> - Shows
                                                            fallback text while font loads</li>
                                                        <li><strong>Preconnect</strong> - Add preconnect links for
                                                            faster loading</li>
                                                        <li><strong>Always include fallbacks</strong> - System fonts as
                                                            backup</li>
                                                    </ul>
                                                </div>

                                                <h2>Finding Fonts</h2>
                                                <p>
                                                    Visit <a href="https://fonts.google.com" target="_blank"
                                                        rel="noopener">fonts.google.com</a> to browse and select fonts.
                                                    The site shows you exactly what code to add to your website.
                                                </p>

                                                <jsp:include page="../tutorial-quiz.jsp">
                                                    <jsp:param name="quizId" value="quiz-google-fonts" />
                                                    <jsp:param name="question"
                                                        value="What is the recommended way to add Google Fonts?" />
                                                    <jsp:param name="option1" value="Using <link> tag in HTML" />
                                                    <jsp:param name="option2" value="Using @import in CSS" />
                                                    <jsp:param name="option3"
                                                        value="Downloading and hosting yourself" />
                                                    <jsp:param name="option4" value="Using JavaScript" />
                                                    <jsp:param name="correctAnswer" value="0" />
                                                </jsp:include>

                                                <jsp:include page="../tutorial-nav.jsp">
                                                    <jsp:param name="prevLink" value="text-formatting.jsp" />
                                                    <jsp:param name="prevTitle" value="Text Formatting" />
                                                    <jsp:param name="nextLink" value="box-model.jsp" />
                                                    <jsp:param name="nextTitle" value="Box Model" />
                                                    <jsp:param name="currentLessonId" value="google-fonts" />
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