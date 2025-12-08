<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Responsive Design Lesson 20: Media Queries and Responsive Layouts --%>
        <% request.setAttribute("currentLesson", "responsive-design" );
            request.setAttribute("currentModule", "Modern Layouts" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Responsive Design - Media Queries & Breakpoints | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master responsive design: media queries, breakpoints, mobile-first approach, and creating layouts that work on all devices.">
                <meta name="keywords"
                    content="responsive design, media queries, CSS breakpoints, mobile-first, responsive layout">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Responsive Design Guide">
                <meta property="og:description" content="Master responsive web design with CSS.">
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
        "name": "CSS Responsive Design",
        "description": "Master responsive web design with CSS",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
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

            <body class="tutorial-body" data-lesson="responsive-design">
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
                                        <span>Responsive Design</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Responsive Design</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~12 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is Responsive Design?</h2>
                                        <p>
                                            Responsive design makes websites adapt to different screen sizes and
                                            devices. Your site should look great on phones, tablets, and desktops!
                                        </p>

                                        <h2>Media Queries Basics</h2>
                                        <p>
                                            Media queries apply CSS rules based on screen size. Syntax:
                                            <code>@media (condition) { /* CSS */ }</code>
                                        </p>

                                        <% String
                                            mediaBasicHtml="<div class='box'>Resize the preview to see me change color!</div>"
                                            ; String
                                            mediaBasicCss=".box {\n  padding: 40px;\n  color: white;\n  text-align: center;\n  font-weight: 600;\n  background-color: #3b82f6;\n}\n\n/* Tablet */\n@media (max-width: 768px) {\n  .box {\n    background-color: #10b981;\n  }\n}\n\n/* Mobile */\n@media (max-width: 480px) {\n  .box {\n    background-color: #f59e0b;\n  }\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=mediaBasicHtml%>" />
                                                <jsp:param name="initialCss" value="<%=mediaBasicCss%>" />
                                            </jsp:include>

                                            <h2>Common Breakpoints</h2>
                                            <p>
                                                Standard breakpoints for different devices:
                                            </p>
                                            <div class="card" style="margin: var(--space-6) 0;">
                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                    <li><strong>Mobile:</strong> 320px - 480px</li>
                                                    <li><strong>Tablet:</strong> 481px - 768px</li>
                                                    <li><strong>Desktop:</strong> 769px - 1024px</li>
                                                    <li><strong>Large Desktop:</strong> 1025px+</li>
                                                </ul>
                                            </div>

                                            <h2>Mobile-First Approach</h2>
                                            <p>
                                                Start with mobile styles, then add complexity for larger screens using
                                                <code>min-width</code>. This is the modern best practice!
                                            </p>

                                            <% String
                                                mobileFirstHtml="<div class='container'>\n  <div class='card'>Card 1</div>\n  <div class='card'>Card 2</div>\n  <div class='card'>Card 3</div>\n</div>"
                                                ; String
                                                mobileFirstCss="/* Mobile first (default) */\n.container {\n  display: flex;\n  flex-direction: column;\n  gap: 10px;\n  padding: 10px;\n  background-color: #f1f5f9;\n}\n\n.card {\n  padding: 30px;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n}\n\n/* Tablet and up */\n@media (min-width: 768px) {\n  .container {\n    flex-direction: row;\n  }\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-mobilefirst" />
                                                    <jsp:param name="initialHtml" value="<%=mobileFirstHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=mobileFirstCss%>" />
                                                </jsp:include>

                                                <h2>Responsive Grid Layout</h2>
                                                <p>
                                                    Change grid columns based on screen size for optimal layouts on all
                                                    devices.
                                                </p>

                                                <% String
                                                    gridHtml="<div class='grid'>\n  <div class='item'>1</div>\n  <div class='item'>2</div>\n  <div class='item'>3</div>\n  <div class='item'>4</div>\n  <div class='item'>5</div>\n  <div class='item'>6</div>\n</div>"
                                                    ; String
                                                    gridCss=".grid {\n  display: grid;\n  grid-template-columns: 1fr;\n  gap: 10px;\n  background-color: #fef3c7;\n  padding: 10px;\n}\n\n.item {\n  padding: 30px;\n  background-color: #f59e0b;\n  color: white;\n  text-align: center;\n}\n\n/* Tablet: 2 columns */\n@media (min-width: 600px) {\n  .grid {\n    grid-template-columns: repeat(2, 1fr);\n  }\n}\n\n/* Desktop: 3 columns */\n@media (min-width: 900px) {\n  .grid {\n    grid-template-columns: repeat(3, 1fr);\n  }\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-grid" />
                                                        <jsp:param name="initialHtml" value="<%=gridHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=gridCss%>" />
                                                    </jsp:include>

                                                    <h2>Hiding Elements</h2>
                                                    <p>
                                                        Show or hide elements based on screen size using
                                                        <code>display: none</code>.
                                                    </p>

                                                    <% String
                                                        hideHtml="<div class='mobile-only'>📱 Mobile Only</div>\n<div class='desktop-only'>💻 Desktop Only</div>\n<div class='always'>✨ Always Visible</div>"
                                                        ; String
                                                        hideCss="div {\n  padding: 20px;\n  margin: 10px 0;\n  color: white;\n  text-align: center;\n  font-size: 18px;\n}\n\n.mobile-only {\n  display: block;\n  background-color: #3b82f6;\n}\n\n.desktop-only {\n  display: none;\n  background-color: #10b981;\n}\n\n.always {\n  background-color: #8b5cf6;\n}\n\n@media (min-width: 768px) {\n  .mobile-only { display: none; }\n  .desktop-only { display: block; }\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-hide" />
                                                            <jsp:param name="initialHtml" value="<%=hideHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=hideCss%>" />
                                                        </jsp:include>

                                                        <h2>Responsive Typography</h2>
                                                        <p>
                                                            Adjust font sizes for better readability on different
                                                            screens.
                                                        </p>

                                                        <% String
                                                            typoHtml="<h1>Responsive Heading</h1>\n<p>This paragraph text adjusts size based on screen width for optimal readability.</p>"
                                                            ; String
                                                            typoCss="h1 {\n  font-size: 24px;\n  color: #1e40af;\n  margin: 0 0 15px 0;\n}\n\np {\n  font-size: 14px;\n  line-height: 1.6;\n  color: #475569;\n}\n\n/* Tablet */\n@media (min-width: 768px) {\n  h1 { font-size: 32px; }\n  p { font-size: 16px; }\n}\n\n/* Desktop */\n@media (min-width: 1024px) {\n  h1 { font-size: 40px; }\n  p { font-size: 18px; }\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-typo" />
                                                                <jsp:param name="initialHtml" value="<%=typoHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=typoCss%>" />
                                                            </jsp:include>

                                                            <h2>Responsive Navigation</h2>
                                                            <p>
                                                                Transform horizontal desktop navigation into a vertical
                                                                mobile menu.
                                                            </p>

                                                            <% String
                                                                navHtml="<nav class='nav'>\n  <a href='#'>Home</a>\n  <a href='#'>About</a>\n  <a href='#'>Services</a>\n  <a href='#'>Contact</a>\n</nav>"
                                                                ; String
                                                                navCss=".nav {\n  display: flex;\n  flex-direction: column;\n  background-color: #1e40af;\n  padding: 10px;\n}\n\n.nav a {\n  color: white;\n  text-decoration: none;\n  padding: 15px;\n  border-bottom: 1px solid rgba(255,255,255,0.1);\n}\n\n.nav a:hover {\n  background-color: rgba(255,255,255,0.1);\n}\n\n/* Desktop: horizontal */\n@media (min-width: 768px) {\n  .nav {\n    flex-direction: row;\n    justify-content: center;\n    gap: 5px;\n  }\n  \n  .nav a {\n    border-bottom: none;\n    border-radius: 4px;\n  }\n}"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId" value="editor-nav" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=navHtml%>" />
                                                                    <jsp:param name="initialCss" value="<%=navCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-important">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Don't Forget:</strong> Always include
                                                                        the viewport meta tag in your HTML:<br>
                                                                        <code>&lt;meta name='viewport' content='width=device-width, initial-scale=1.0'&gt;</code>
                                                                    </div>
                                                                </div>

                                                                <h2>Best Practices</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li>Use mobile-first approach with
                                                                            <code>min-width</code></li>
                                                                        <li>Test on real devices, not just browser
                                                                            resize</li>
                                                                        <li>Use relative units (%, em, rem) over fixed
                                                                            pixels</li>
                                                                        <li>Keep breakpoints simple (3-4 is usually
                                                                            enough)</li>
                                                                        <li>Optimize images for different screen sizes
                                                                        </li>
                                                                        <li>Touch targets should be at least 44×44px on
                                                                            mobile</li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId" value="quiz-responsive" />
                                                                    <jsp:param name="question"
                                                                        value="Which approach is recommended for responsive design?" />
                                                                    <jsp:param name="option1"
                                                                        value="Desktop-first with max-width" />
                                                                    <jsp:param name="option2"
                                                                        value="Mobile-first with min-width" />
                                                                    <jsp:param name="option3" value="Tablet-first" />
                                                                    <jsp:param name="option4"
                                                                        value="No media queries" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink"
                                                                        value="grid-advanced.jsp" />
                                                                    <jsp:param name="prevTitle" value="Grid Advanced" />
                                                                    <jsp:param name="nextLink"
                                                                        value="backgrounds.jsp" />
                                                                    <jsp:param name="nextTitle" value="Backgrounds" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="responsive-design" />
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