<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Text Styling Lesson 5: Font Family, Size, Weight, Style --%>
        <% request.setAttribute("currentLesson", "text-styling" ); request.setAttribute("currentModule", "Text & Fonts"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Text Styling - Font Family, Size, Weight | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS text styling properties: font-family, font-size, font-weight, font-style, and line-height for beautiful typography.">
                <meta name="keywords"
                    content="CSS text styling, font-family, font-size, font-weight, typography, CSS fonts">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Text Styling - Complete Guide">
                <meta property="og:description" content="Master CSS text styling and typography.">
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
        "name": "CSS Text Styling",
        "description": "Master CSS text styling and typography",
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

            <body class="tutorial-body" data-lesson="text-styling">
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
                                        <span>Text Styling</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Text Styling</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Typography Fundamentals</h2>
                                        <p>
                                            Text styling is crucial for readability and visual hierarchy. CSS provides
                                            powerful properties to control how text appears on your website.
                                        </p>

                                        <h2>Font Family</h2>
                                        <p>
                                            The <code>font-family</code> property specifies which font to use. Always
                                            provide fallback fonts in case the primary font isn't available.
                                        </p>

                                        <% String
                                            fontFamilyHtml="<h1>Different Font Families</h1>\n<p class='serif'>This uses a serif font (Times New Roman)</p>\n<p class='sans'>This uses a sans-serif font (Arial)</p>\n<p class='mono'>This uses a monospace font (Courier)</p>"
                                            ; String
                                            fontFamilyCss=".serif {\n  font-family: 'Times New Roman', Times, serif;\n}\n\n.sans {\n  font-family: Arial, Helvetica, sans-serif;\n}\n\n.mono {\n  font-family: 'Courier New', Courier, monospace;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-family" />
                                                <jsp:param name="initialHtml" value="<%=fontFamilyHtml%>" />
                                                <jsp:param name="initialCss" value="<%=fontFamilyCss%>" />
                                            </jsp:include>

                                            <h2>Font Size</h2>
                                            <p>
                                                Control text size with <code>font-size</code>. Use <code>px</code>,
                                                <code>em</code>, <code>rem</code>, or <code>%</code>.
                                            </p>

                                            <% String
                                                fontSizeHtml="<p class='small'>Small text (14px)</p>\n<p class='medium'>Medium text (18px)</p>\n<p class='large'>Large text (24px)</p>\n<p class='xlarge'>Extra large text (32px)</p>"
                                                ; String
                                                fontSizeCss=".small { font-size: 14px; }\n.medium { font-size: 18px; }\n.large { font-size: 24px; }\n.xlarge { font-size: 32px; }"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-size" />
                                                    <jsp:param name="initialHtml" value="<%=fontSizeHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=fontSizeCss%>" />
                                                </jsp:include>

                                                <h2>Font Weight</h2>
                                                <p>
                                                    The <code>font-weight</code> property controls how bold or light
                                                    text appears. Values range from 100 (thin) to 900 (black), or use
                                                    keywords like <code>normal</code> and <code>bold</code>.
                                                </p>

                                                <% String
                                                    fontWeightHtml="<p class='light'>Light text (300)</p>\n<p class='normal'>Normal text (400)</p>\n<p class='semibold'>Semi-bold text (600)</p>\n<p class='bold'>Bold text (700)</p>"
                                                    ; String
                                                    fontWeightCss=".light { font-weight: 300; }\n.normal { font-weight: 400; }\n.semibold { font-weight: 600; }\n.bold { font-weight: 700; }"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-weight" />
                                                        <jsp:param name="initialHtml" value="<%=fontWeightHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=fontWeightCss%>" />
                                                    </jsp:include>

                                                    <h2>Font Style & Line Height</h2>
                                                    <p>
                                                        <code>font-style</code> makes text italic, and
                                                        <code>line-height</code> controls spacing between lines for
                                                        better readability.
                                                    </p>

                                                    <% String
                                                        fontStyleHtml="<p class='normal-text'>Normal text</p>\n<p class='italic-text'>Italic text</p>\n<p class='tall-lines'>This paragraph has increased line height for better readability. Notice how the lines are spaced further apart.</p>"
                                                        ; String
                                                        fontStyleCss=".normal-text {\n  font-style: normal;\n}\n\n.italic-text {\n  font-style: italic;\n}\n\n.tall-lines {\n  line-height: 1.8;\n  max-width: 400px;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-style" />
                                                            <jsp:param name="initialHtml" value="<%=fontStyleHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=fontStyleCss%>" />
                                                        </jsp:include>

                                                        <div class="callout callout-tip">
                                                            <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <circle cx="12" cy="12" r="10" />
                                                                <path d="M12 16v-4M12 8h.01" />
                                                            </svg>
                                                            <div class="callout-content">
                                                                <strong>Best Practice:</strong> Use
                                                                <code>line-height: 1.5</code> to <code>1.8</code> for
                                                                body text to improve readability.
                                                            </div>
                                                        </div>

                                                        <h2>Key Takeaways</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li><code>font-family</code> - Choose fonts with
                                                                    fallbacks</li>
                                                                <li><code>font-size</code> - Control text size (px, em,
                                                                    rem)</li>
                                                                <li><code>font-weight</code> - Make text bold or light
                                                                    (100-900)</li>
                                                                <li><code>font-style</code> - Make text italic</li>
                                                                <li><code>line-height</code> - Space between lines
                                                                    (1.5-1.8 recommended)</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-text-styling" />
                                                            <jsp:param name="question"
                                                                value="Which property controls the boldness of text?" />
                                                            <jsp:param name="option1" value="font-size" />
                                                            <jsp:param name="option2" value="font-weight" />
                                                            <jsp:param name="option3" value="font-style" />
                                                            <jsp:param name="option4" value="font-family" />
                                                            <jsp:param name="correctAnswer" value="1" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="colors.jsp" />
                                                            <jsp:param name="prevTitle" value="Colors" />
                                                            <jsp:param name="nextLink" value="text-formatting.jsp" />
                                                            <jsp:param name="nextTitle" value="Text Formatting" />
                                                            <jsp:param name="currentLessonId" value="text-styling" />
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