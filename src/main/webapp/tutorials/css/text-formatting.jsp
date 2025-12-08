<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Text Formatting Lesson 6: Text Alignment, Decoration, Transform, Spacing --%>
        <% request.setAttribute("currentLesson", "text-formatting" );
            request.setAttribute("currentModule", "Text & Fonts" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Text Formatting - Alignment, Decoration, Transform | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn CSS text formatting: text-align, text-decoration, text-transform, letter-spacing, and word-spacing for professional typography.">
                <meta name="keywords"
                    content="CSS text formatting, text-align, text-decoration, text-transform, letter-spacing, CSS typography">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Text Formatting - Complete Guide">
                <meta property="og:description" content="Master CSS text formatting properties.">
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
        "name": "CSS Text Formatting",
        "description": "Master CSS text formatting properties",
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

            <body class="tutorial-body" data-lesson="text-formatting">
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
                                        <span>Text Formatting</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Text Formatting</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~7 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Text Alignment</h2>
                                        <p>
                                            The <code>text-align</code> property controls horizontal alignment of text
                                            within its container.
                                        </p>

                                        <% String
                                            alignHtml="<p class='left'>Left aligned text (default)</p>\n<p class='center'>Center aligned text</p>\n<p class='right'>Right aligned text</p>\n<p class='justify'>Justified text spreads content evenly from left to right edges. This is useful for newspaper-style layouts.</p>"
                                            ; String
                                            alignCss=".left { text-align: left; }\n.center { text-align: center; }\n.right { text-align: right; }\n.justify {\n  text-align: justify;\n  max-width: 300px;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-align" />
                                                <jsp:param name="initialHtml" value="<%=alignHtml%>" />
                                                <jsp:param name="initialCss" value="<%=alignCss%>" />
                                            </jsp:include>

                                            <h2>Text Decoration</h2>
                                            <p>
                                                Add or remove underlines, overlines, and line-throughs with
                                                <code>text-decoration</code>.
                                            </p>

                                            <% String
                                                decorationHtml="<p class='underline'>Underlined text</p>\n<p class='overline'>Overlined text</p>\n<p class='line-through'>Strikethrough text</p>\n<a href='#' class='no-underline'>Link with no underline</a>"
                                                ; String
                                                decorationCss=".underline { text-decoration: underline; }\n.overline { text-decoration: overline; }\n.line-through { text-decoration: line-through; }\n.no-underline {\n  text-decoration: none;\n  color: #2563eb;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-decoration" />
                                                    <jsp:param name="initialHtml" value="<%=decorationHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=decorationCss%>" />
                                                </jsp:include>

                                                <h2>Text Transform</h2>
                                                <p>
                                                    Change text capitalization with <code>text-transform</code> without
                                                    modifying the HTML.
                                                </p>

                                                <% String
                                                    transformHtml="<p class='uppercase'>uppercase text</p>\n<p class='lowercase'>LOWERCASE TEXT</p>\n<p class='capitalize'>capitalize each word</p>\n<p class='none'>Normal Text</p>"
                                                    ; String
                                                    transformCss=".uppercase { text-transform: uppercase; }\n.lowercase { text-transform: lowercase; }\n.capitalize { text-transform: capitalize; }\n.none { text-transform: none; }"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-transform" />
                                                        <jsp:param name="initialHtml" value="<%=transformHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=transformCss%>" />
                                                    </jsp:include>

                                                    <h2>Letter & Word Spacing</h2>
                                                    <p>
                                                        Control spacing between letters with <code>letter-spacing</code>
                                                        and between words with <code>word-spacing</code>.
                                                    </p>

                                                    <% String
                                                        spacingHtml="<p class='tight'>Tight letter spacing</p>\n<p class='normal'>Normal spacing</p>\n<p class='loose'>Loose letter spacing</p>\n<p class='word-space'>Increased word spacing example</p>"
                                                        ; String
                                                        spacingCss=".tight { letter-spacing: -1px; }\n.normal { letter-spacing: normal; }\n.loose { letter-spacing: 3px; }\n.word-space {\n  word-spacing: 8px;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-spacing" />
                                                            <jsp:param name="initialHtml" value="<%=spacingHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=spacingCss%>" />
                                                        </jsp:include>

                                                        <div class="callout callout-tip">
                                                            <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <circle cx="12" cy="12" r="10" />
                                                                <path d="M12 16v-4M12 8h.01" />
                                                            </svg>
                                                            <div class="callout-content">
                                                                <strong>Pro Tip:</strong> Use
                                                                <code>text-transform: uppercase</code> with
                                                                <code>letter-spacing: 1-2px</code> for elegant headings.
                                                            </div>
                                                        </div>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li><code>text-align</code> - Align text (left, center,
                                                                    right, justify)</li>
                                                                <li><code>text-decoration</code> - Add/remove underlines
                                                                    and strikethroughs</li>
                                                                <li><code>text-transform</code> - Change capitalization
                                                                </li>
                                                                <li><code>letter-spacing</code> - Space between letters
                                                                </li>
                                                                <li><code>word-spacing</code> - Space between words</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-text-formatting" />
                                                            <jsp:param name="question"
                                                                value="Which property removes the underline from links?" />
                                                            <jsp:param name="option1" value="text-decoration: none" />
                                                            <jsp:param name="option2" value="text-transform: none" />
                                                            <jsp:param name="option3" value="text-align: none" />
                                                            <jsp:param name="option4" value="text-style: none" />
                                                            <jsp:param name="correctAnswer" value="0" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="text-styling.jsp" />
                                                            <jsp:param name="prevTitle" value="Text Styling" />
                                                            <jsp:param name="nextLink" value="google-fonts.jsp" />
                                                            <jsp:param name="nextTitle" value="Google Fonts" />
                                                            <jsp:param name="currentLessonId" value="text-formatting" />
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