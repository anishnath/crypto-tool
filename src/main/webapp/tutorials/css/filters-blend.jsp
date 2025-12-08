<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Filters & Blend Modes Lesson 32: CSS Filters and Blend Modes --%>
        <% request.setAttribute("currentLesson", "filters-blend" );
            request.setAttribute("currentModule", "Advanced Topics" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Filters & Blend Modes - Visual Effects | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS filters (blur, brightness, contrast, grayscale) and blend modes (multiply, screen, overlay) for stunning visual effects.">
                <meta name="keywords" content="CSS filters, blend modes, blur, brightness, grayscale, mix-blend-mode">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Filters & Blend Modes Guide">
                <meta property="og:description" content="Master CSS visual effects.">
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
        "name": "CSS Filters & Blend Modes",
        "description": "Master CSS visual effects",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
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

            <body class="tutorial-body" data-lesson="filters-blend">
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
                                        <span>Filters & Blend Modes</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Filters & Blend Modes</h1>
                                        <div class="lesson-meta">
                                            <span>Advanced</span>
                                            <span>~9 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are CSS Filters?</h2>
                                        <p>
                                            CSS filters apply visual effects like blur, brightness, and saturation to
                                            elements. Perfect for images and creative effects!
                                        </p>

                                        <h2>Blur Filter</h2>
                                        <p>
                                            <code>filter: blur()</code> creates a Gaussian blur effect. Great for
                                            backgrounds and focus effects.
                                        </p>

                                        <% String
                                            blurHtml="<div class='card no-blur'>No Blur</div>\n<div class='card blur-small'>blur(2px)</div>\n<div class='card blur-large'>blur(5px)</div>"
                                            ; String
                                            blurCss=".card {\n  padding: 30px;\n  margin: 15px 0;\n  background: linear-gradient(135deg, #3b82f6, #8b5cf6);\n  color: white;\n  text-align: center;\n  font-weight: 600;\n  border-radius: 8px;\n}\n\n.blur-small { filter: blur(2px); }\n.blur-large { filter: blur(5px); }"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-blur" />
                                                <jsp:param name="initialHtml" value="<%=blurHtml%>" />
                                                <jsp:param name="initialCss" value="<%=blurCss%>" />
                                            </jsp:include>

                                            <h2>Brightness & Contrast</h2>
                                            <p>
                                                Adjust brightness and contrast with <code>brightness()</code> and
                                                <code>contrast()</code>. Values > 1 increase, < 1 decrease. </p>

                                                    <% String
                                                        brightnessHtml="<div class='box normal'>Normal</div>\n<div class='box bright'>Bright (1.5)</div>\n<div class='box dark'>Dark (0.5)</div>\n<div class='box high-contrast'>High Contrast (2)</div>"
                                                        ; String
                                                        brightnessCss=".box {\n  padding: 25px;\n  margin: 10px;\n  background: linear-gradient(to right, #10b981, #059669);\n  color: white;\n  text-align: center;\n  display: inline-block;\n  border-radius: 6px;\n}\n\n.bright { filter: brightness(1.5); }\n.dark { filter: brightness(0.5); }\n.high-contrast { filter: contrast(2); }"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-brightness" />
                                                            <jsp:param name="initialHtml" value="<%=brightnessHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=brightnessCss%>" />
                                                        </jsp:include>

                                                        <h2>Grayscale & Sepia</h2>
                                                        <p>
                                                            Convert to grayscale or add vintage sepia tone. Values from
                                                            0 (none) to 1 (full effect).
                                                        </p>

                                                        <% String
                                                            grayscaleHtml="<div class='img normal'>Color</div>\n<div class='img grayscale'>Grayscale</div>\n<div class='img sepia'>Sepia</div>"
                                                            ; String
                                                            grayscaleCss=".img {\n  padding: 40px;\n  margin: 10px;\n  background: linear-gradient(135deg, #f59e0b, #ef4444);\n  color: white;\n  text-align: center;\n  font-weight: 600;\n  display: inline-block;\n  border-radius: 8px;\n}\n\n.grayscale { filter: grayscale(1); }\n.sepia { filter: sepia(1); }"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-grayscale" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=grayscaleHtml%>" />
                                                                <jsp:param name="initialCss"
                                                                    value="<%=grayscaleCss%>" />
                                                            </jsp:include>

                                                            <h2>Multiple Filters</h2>
                                                            <p>
                                                                Combine multiple filters by separating them with spaces.
                                                                Order matters!
                                                            </p>

                                                            <% String
                                                                multipleHtml="<div class='card'>Multiple filters combined!</div>"
                                                                ; String
                                                                multipleCss=".card {\n  padding: 50px;\n  background: linear-gradient(135deg, #8b5cf6, #ec4899);\n  color: white;\n  text-align: center;\n  font-size: 20px;\n  font-weight: 600;\n  border-radius: 12px;\n  filter:\n    brightness(1.2)\n    contrast(1.1)\n    saturate(1.3);\n}"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId"
                                                                        value="editor-multiple" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=multipleHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=multipleCss%>" />
                                                                </jsp:include>

                                                                <h2>Backdrop Filter</h2>
                                                                <p>
                                                                    <code>backdrop-filter</code> applies filters to the
                                                                    area behind an element. Perfect for glassmorphism!
                                                                </p>

                                                                <% String
                                                                    backdropHtml="<div class='background'>\n  <div class='glass'>Glassmorphism Effect</div>\n</div>"
                                                                    ; String
                                                                    backdropCss=".background {\n  padding: 60px;\n  background: linear-gradient(135deg, #3b82f6, #8b5cf6);\n  display: flex;\n  justify-content: center;\n  align-items: center;\n}\n\n.glass {\n  padding: 30px 50px;\n  background: rgba(255, 255, 255, 0.1);\n  backdrop-filter: blur(10px);\n  border: 1px solid rgba(255, 255, 255, 0.2);\n  border-radius: 12px;\n  color: white;\n  font-weight: 600;\n}"
                                                                    ; %>
                                                                    <jsp:include page="../tutorial-editor.jsp">
                                                                        <jsp:param name="editorId"
                                                                            value="editor-backdrop" />
                                                                        <jsp:param name="initialHtml"
                                                                            value="<%=backdropHtml%>" />
                                                                        <jsp:param name="initialCss"
                                                                            value="<%=backdropCss%>" />
                                                                    </jsp:include>

                                                                    <h2>Blend Modes</h2>
                                                                    <p>
                                                                        <code>mix-blend-mode</code> controls how
                                                                        elements blend with their background. Similar to
                                                                        Photoshop blend modes!
                                                                    </p>

                                                                    <% String
                                                                        blendHtml="<div class='container'>\n  <div class='box multiply'>multiply</div>\n  <div class='box screen'>screen</div>\n  <div class='box overlay'>overlay</div>\n</div>"
                                                                        ; String
                                                                        blendCss=".container {\n  background: linear-gradient(135deg, #fef3c7, #fde68a);\n  padding: 30px;\n  display: flex;\n  gap: 20px;\n  justify-content: center;\n}\n\n.box {\n  padding: 30px;\n  background-color: #3b82f6;\n  color: white;\n  font-weight: 600;\n  border-radius: 8px;\n}\n\n.multiply { mix-blend-mode: multiply; }\n.screen { mix-blend-mode: screen; }\n.overlay { mix-blend-mode: overlay; }"
                                                                        ; %>
                                                                        <jsp:include page="../tutorial-editor.jsp">
                                                                            <jsp:param name="editorId"
                                                                                value="editor-blend" />
                                                                            <jsp:param name="initialHtml"
                                                                                value="<%=blendHtml%>" />
                                                                            <jsp:param name="initialCss"
                                                                                value="<%=blendCss%>" />
                                                                        </jsp:include>

                                                                        <div class="callout callout-warning">
                                                                            <svg class="callout-icon"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <path
                                                                                    d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z" />
                                                                                <line x1="12" y1="9" x2="12" y2="13" />
                                                                                <line x1="12" y1="17" x2="12.01"
                                                                                    y2="17" />
                                                                            </svg>
                                                                            <div class="callout-content">
                                                                                <strong>Performance Note:</strong>
                                                                                Filters can be GPU-intensive. Use them
                                                                                sparingly, especially
                                                                                <code>blur()</code> and
                                                                                <code>backdrop-filter</code>, to
                                                                                maintain good performance!
                                                                            </div>
                                                                        </div>

                                                                        <h2>Summary</h2>
                                                                        <div class="card"
                                                                            style="margin: var(--space-6) 0;">
                                                                            <ul
                                                                                style="margin: 0; padding-left: var(--space-6);">
                                                                                <li><code>filter: blur()</code> -
                                                                                    Gaussian blur</li>
                                                                                <li><code>brightness()</code>,
                                                                                    <code>contrast()</code> - Adjust
                                                                                    lighting</li>
                                                                                <li><code>grayscale()</code>,
                                                                                    <code>sepia()</code> - Color effects
                                                                                </li>
                                                                                <li><code>backdrop-filter</code> -
                                                                                    Filter background behind element
                                                                                </li>
                                                                                <li><code>mix-blend-mode</code> - Blend
                                                                                    with background</li>
                                                                                <li>Combine multiple filters with spaces
                                                                                </li>
                                                                            </ul>
                                                                        </div>

                                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                                            <jsp:param name="quizId"
                                                                                value="quiz-filters" />
                                                                            <jsp:param name="question"
                                                                                value="Which property filters the area behind an element?" />
                                                                            <jsp:param name="option1" value="filter" />
                                                                            <jsp:param name="option2"
                                                                                value="backdrop-filter" />
                                                                            <jsp:param name="option3"
                                                                                value="background-filter" />
                                                                            <jsp:param name="option4"
                                                                                value="behind-filter" />
                                                                            <jsp:param name="correctAnswer" value="1" />
                                                                        </jsp:include>

                                                                        <jsp:include page="../tutorial-nav.jsp">
                                                                            <jsp:param name="prevLink"
                                                                                value="css-functions.jsp" />
                                                                            <jsp:param name="prevTitle"
                                                                                value="CSS Functions" />
                                                                            <jsp:param name="nextLink"
                                                                                value="best-practices.jsp" />
                                                                            <jsp:param name="nextTitle"
                                                                                value="Best Practices" />
                                                                            <jsp:param name="currentLessonId"
                                                                                value="filters-blend" />
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