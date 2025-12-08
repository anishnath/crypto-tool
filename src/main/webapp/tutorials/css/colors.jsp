<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Colors Lesson 4: CSS Color Values --%>
        <% request.setAttribute("currentLesson", "colors" ); request.setAttribute("currentModule", "Text & Fonts" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Colors - Hex, RGB, HSL, Named Colors | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS color values: hex codes, RGB, RGBA, HSL, HSLA, and named colors. Learn opacity and transparency.">
                <meta name="keywords" content="CSS colors, hex colors, RGB, RGBA, HSL, HSLA, color values, opacity">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Colors - Complete Guide">
                <meta property="og:description" content="Master all CSS color formats and opacity.">
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
        "name": "CSS Colors",
        "description": "Master all CSS color formats and opacity",
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

            <body class="tutorial-body" data-lesson="colors">
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
                                        <span>Colors</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Colors</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Color in CSS</h2>
                                        <p>
                                            CSS offers multiple ways to specify colors. Each format has its advantages,
                                            and you'll use different ones depending on your needs.
                                        </p>

                                        <h2>1. Named Colors</h2>
                                        <p>
                                            CSS has 140 predefined color names like <code>red</code>, <code>blue</code>,
                                            <code>green</code>. Easy to remember but limited.
                                        </p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-named" />
                                            <jsp:param name="initialHtml" value="<h1>Named Colors</h1>\n<p class=\"red\">Red text</p>\n<p class=\"blue\">Blue text</p>\n<p class=\"green\">Green text</p>" />
                                                <jsp:param name="initialCss"
                                                    value=".red { color: red; }\n.blue { color: blue; }\n.green { color: green; }\n\nh1 { color: darkslateblue; }" />
                                        </jsp:include>

                                        <h2>2. Hexadecimal (Hex) Colors</h2>
                                        <p>
                                            Hex colors use a <code>#</code> followed by 6 digits (or 3 for shorthand).
                                            Format: <code>#RRGGBB</code> where RR=red, GG=green, BB=blue.
                                        </p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-hex" />
                                            <jsp:param name="initialHtml" value="<div class=\" box box1\">Blue #2563eb</div>\n<div class=\"box box2\">Green #10b981</div>\n<div class=\"box box3\">Red#dc2626</div>" />
                                    <jsp:param name="initialCss"
                                        value=".box {\n  padding: 20px;\n  margin: 10px 0;\n  color: white;\n  font-weight: 600;\n  border-radius: 8px;\n}\n\n.box1 { background-color: #2563eb; }\n.box2 { background-color: #10b981; }\n.box3 { background-color: #dc2626; }" />
                                    </jsp:include>

                                    <div class="callout callout-tip">
                                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <circle cx="12" cy="12" r="10" />
                                            <path d="M12 16v-4M12 8h.01" />
                                        </svg>
                                        <div class="callout-content">
                                            <strong>Shorthand:</strong> <code>#fff</code> = <code>#ffffff</code>
                                            (white), <code>#000</code> = <code>#000000</code> (black)
                                        </div>
                                    </div>

                                    <h2>3. RGB and RGBA</h2>
                                    <p>
                                        RGB uses red, green, blue values (0-255). RGBA adds an alpha channel for opacity
                                        (0-1).
                                    </p>

                                    <jsp:include page="../tutorial-editor.jsp">
                                        <jsp:param name="editorId" value="editor-rgb" />
                                        <jsp:param name="initialHtml" value="<div class=\" overlay overlay1\">Solid RGB </div>\n<div class=\"overlay overlay2\">50% Opacity</div>\n<div class=\"overlay overlay3\">25% Opacity</div>" />
                <jsp:param name="initialCss"
                    value=".overlay {\n  padding: 20px;\n  margin: 10px 0;\n  color: white;\n  font-weight: 600;\n  border-radius: 8px;\n}\n\n.overlay1 { background-color: rgb(37, 99, 235); }\n.overlay2 { background-color: rgba(37, 99, 235, 0.5); }\n.overlay3 { background-color: rgba(37, 99, 235, 0.25); }" />
                </jsp:include>

                <h2>4. HSL and HSLA</h2>
                <p>
                    HSL stands for Hue (0-360°), Saturation (0-100%), Lightness (0-100%). HSLA adds opacity. More
                    intuitive for color adjustments.
                </p>

                <jsp:include page="../tutorial-editor.jsp">
                    <jsp:param name="editorId" value="editor-hsl" />
                    <jsp:param name="initialHtml" value="<div class=\" hsl hsl1\">Hue 217° (Blue)</div>\n<div class=\"hsl hsl2\">Hue 142° (Green)</div>\n<div class=\"hsl hsl3\">Hue 0° (Red)</div>" />
                        <jsp:param name="initialCss"
                            value=".hsl {\n  padding: 20px;\n  margin: 10px 0;\n  color: white;\n  font-weight: 600;\n  border-radius: 8px;\n}\n\n.hsl1 { background-color: hsl(217, 91%, 60%); }\n.hsl2 { background-color: hsl(142, 76%, 36%); }\n.hsl3 { background-color: hsl(0, 84%, 60%); }" />
                </jsp:include>

                <h2>When to Use Each Format</h2>
                <div class="card" style="margin-bottom: var(--space-6);">
                    <ul style="margin: 0; padding-left: var(--space-6);">
                        <li><strong>Hex</strong> - Most common, design tools export hex codes</li>
                        <li><strong>RGB/RGBA</strong> - When you need transparency</li>
                        <li><strong>HSL/HSLA</strong> - Creating color variations (lighter/darker)</li>
                        <li><strong>Named</strong> - Quick prototyping or very basic colors</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-quiz.jsp">
                    <jsp:param name="quizId" value="quiz-colors" />
                    <jsp:param name="question" value="Which color format allows you to set transparency?" />
                    <jsp:param name="option1" value="Hex" />
                    <jsp:param name="option2" value="Named colors" />
                    <jsp:param name="option3" value="RGBA" />
                    <jsp:param name="option4" value="RGB" />
                    <jsp:param name="correctAnswer" value="2" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="selectors-basics.jsp" />
                    <jsp:param name="prevTitle" value="Selectors Basics" />
                    <jsp:param name="nextLink" value="text-styling.jsp" />
                    <jsp:param name="nextTitle" value="Text Styling" />
                    <jsp:param name="currentLessonId" value="colors" />
                </jsp:include>
                </div>
                </article>

                <aside class="tutorial-preview" id="previewPanel">
                    <div class="preview-header">
                        <span>Live Preview</span>
                        <button class="btn btn-ghost btn-icon" onclick="refreshPreview()" title="Refresh">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
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