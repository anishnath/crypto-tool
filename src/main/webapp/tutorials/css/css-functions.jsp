<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - CSS Functions Lesson 31: CSS Functions --%>
        <% request.setAttribute("currentLesson", "css-functions" );
            request.setAttribute("currentModule", "Advanced Topics" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Functions - calc(), clamp(), min(), max() | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS functions: calc(), clamp(), min(), max(), rgb(), hsl() for dynamic and responsive styling.">
                <meta name="keywords" content="CSS functions, calc(), clamp(), min(), max(), CSS calculations">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Functions Complete Guide">
                <meta property="og:description" content="Master CSS functions.">
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
        "name": "CSS Functions",
        "description": "Master CSS functions",
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

            <body class="tutorial-body" data-lesson="css-functions">
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
                                        <span>CSS Functions</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Functions</h1>
                                        <div class="lesson-meta">
                                            <span>Advanced</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are CSS Functions?</h2>
                                        <p>
                                            CSS functions perform calculations and transformations. They make your CSS
                                            dynamic and responsive!
                                        </p>

                                        <h2>calc() Function</h2>
                                        <p>
                                            <code>calc()</code> performs mathematical calculations. Mix units like px,
                                            %, rem, and more!
                                        </p>

                                        <% String
                                            calcHtml="<div class='container'>\n  <div class='sidebar'>Sidebar</div>\n  <div class='content'>Main Content</div>\n</div>"
                                            ; String
                                            calcCss=".container {\n  display: flex;\n  gap: 20px;\n  background-color: #f1f5f9;\n  padding: 20px;\n}\n\n.sidebar {\n  width: 250px;\n  background-color: #3b82f6;\n  color: white;\n  padding: 20px;\n}\n\n.content {\n  /* 100% minus sidebar width minus gap */\n  width: calc(100% - 250px - 20px);\n  background-color: white;\n  padding: 20px;\n  border: 2px solid #e5e7eb;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-calc" />
                                                <jsp:param name="initialHtml" value="<%=calcHtml%>" />
                                                <jsp:param name="initialCss" value="<%=calcCss%>" />
                                            </jsp:include>

                                            <h2>min() and max()</h2>
                                            <p>
                                                <code>min()</code> returns the smallest value, <code>max()</code>
                                                returns the largest. Perfect for responsive sizing!
                                            </p>

                                            <% String
                                                minMaxHtml="<div class='box min-width'>min() - Never wider than 400px</div>\n<div class='box max-width'>max() - Never narrower than 300px</div>"
                                                ; String
                                                minMaxCss=".box {\n  padding: 30px;\n  margin: 15px 0;\n  background-color: #10b981;\n  color: white;\n  text-align: center;\n}\n\n.min-width {\n  /* Smaller of 100% or 400px */\n  width: min(100%, 400px);\n}\n\n.max-width {\n  /* Larger of 50% or 300px */\n  width: max(50%, 300px);\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-minmax" />
                                                    <jsp:param name="initialHtml" value="<%=minMaxHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=minMaxCss%>" />
                                                </jsp:include>

                                                <h2>clamp() Function</h2>
                                                <p>
                                                    <code>clamp(min, preferred, max)</code> creates responsive values
                                                    with minimum and maximum bounds. Game-changer for fluid typography!
                                                </p>

                                                <% String
                                                    clampHtml="<h1>Responsive Heading</h1>\n<p>This text scales smoothly between minimum and maximum sizes based on viewport width!</p>"
                                                    ; String
                                                    clampCss="h1 {\n  /* Min 24px, preferred 5vw, max 48px */\n  font-size: clamp(24px, 5vw, 48px);\n  color: #1e40af;\n  margin: 0 0 20px 0;\n}\n\np {\n  /* Min 14px, preferred 2vw, max 18px */\n  font-size: clamp(14px, 2vw, 18px);\n  line-height: 1.6;\n  color: #475569;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-clamp" />
                                                        <jsp:param name="initialHtml" value="<%=clampHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=clampCss%>" />
                                                    </jsp:include>

                                                    <h2>Color Functions</h2>
                                                    <p>
                                                        <code>rgb()</code>, <code>rgba()</code>, <code>hsl()</code>,
                                                        <code>hsla()</code> create colors programmatically.
                                                    </p>

                                                    <% String
                                                        colorHtml="<div class='rgb'>RGB Color</div>\n<div class='rgba'>RGBA with Transparency</div>\n<div class='hsl'>HSL Color</div>"
                                                        ; String
                                                        colorCss=".rgb,\n.rgba,\n.hsl {\n  padding: 30px;\n  margin: 10px 0;\n  text-align: center;\n  color: white;\n  font-weight: 600;\n}\n\n.rgb {\n  background-color: rgb(59, 130, 246);\n}\n\n.rgba {\n  background-color: rgba(16, 185, 129, 0.7);\n}\n\n.hsl {\n  /* Hue, Saturation, Lightness */\n  background-color: hsl(280, 70%, 60%);\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-color" />
                                                            <jsp:param name="initialHtml" value="<%=colorHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=colorCss%>" />
                                                        </jsp:include>

                                                        <h2>Transform Functions</h2>
                                                        <p>
                                                            Functions like <code>rotate()</code>, <code>scale()</code>,
                                                            <code>translate()</code> are used with the
                                                            <code>transform</code> property.
                                                        </p>

                                                        <% String transformHtml="<div class='box'>Transformed!</div>" ;
                                                            String
                                                            transformCss=".box {\n  width: 150px;\n  padding: 30px;\n  margin: 50px auto;\n  background-color: #f59e0b;\n  color: white;\n  text-align: center;\n  /* Multiple transform functions */\n  transform:\n    rotate(10deg)\n    scale(1.1)\n    translateY(-10px);\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-transform" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=transformHtml%>" />
                                                                <jsp:param name="initialCss"
                                                                    value="<%=transformCss%>" />
                                                            </jsp:include>

                                                            <h2>Practical Example: Responsive Card</h2>
                                                            <p>
                                                                Combine multiple functions for a fully responsive
                                                                component.
                                                            </p>

                                                            <% String
                                                                practicalHtml="<div class='card'>\n  <h2>Responsive Card</h2>\n  <p>This card uses clamp() for typography, calc() for spacing, and min() for width!</p>\n</div>"
                                                                ; String
                                                                practicalCss=".card {\n  width: min(100%, 600px);\n  padding: clamp(20px, 4vw, 40px);\n  margin: 20px auto;\n  background-color: white;\n  border: 2px solid #e5e7eb;\n  border-radius: 12px;\n  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);\n}\n\n.card h2 {\n  font-size: clamp(20px, 4vw, 32px);\n  color: #1e40af;\n  margin: 0 0 calc(1em / 2) 0;\n}\n\n.card p {\n  font-size: clamp(14px, 2vw, 16px);\n  line-height: 1.6;\n  color: #475569;\n  margin: 0;\n}"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId"
                                                                        value="editor-practical" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=practicalHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=practicalCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-tip">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Pro Tip:</strong> Use
                                                                        <code>clamp()</code> for fluid typography
                                                                        instead of media queries! It creates smooth,
                                                                        responsive text that scales perfectly across all
                                                                        screen sizes.
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>calc()</code> - Mathematical
                                                                            calculations</li>
                                                                        <li><code>min()</code> - Smallest value from
                                                                            list</li>
                                                                        <li><code>max()</code> - Largest value from list
                                                                        </li>
                                                                        <li><code>clamp(min, preferred, max)</code> -
                                                                            Bounded responsive values</li>
                                                                        <li><code>rgb()</code>, <code>hsl()</code> -
                                                                            Color functions</li>
                                                                        <li>Transform functions: rotate(), scale(),
                                                                            translate()</li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId" value="quiz-functions" />
                                                                    <jsp:param name="question"
                                                                        value="Which function creates responsive values with min and max bounds?" />
                                                                    <jsp:param name="option1" value="calc()" />
                                                                    <jsp:param name="option2" value="clamp()" />
                                                                    <jsp:param name="option3" value="min()" />
                                                                    <jsp:param name="option4" value="max()" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink" value="variables.jsp" />
                                                                    <jsp:param name="prevTitle" value="CSS Variables" />
                                                                    <jsp:param name="nextLink"
                                                                        value="filters-blend.jsp" />
                                                                    <jsp:param name="nextTitle"
                                                                        value="Filters & Blend Modes" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="css-functions" />
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