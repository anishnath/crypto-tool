<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Best Practices Lesson 33: CSS Best Practices & Tips --%>
        <% request.setAttribute("currentLesson", "best-practices" );
            request.setAttribute("currentModule", "Advanced Topics" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Best Practices - Writing Better CSS | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn CSS best practices: naming conventions, organization, performance optimization, maintainability, and professional CSS development.">
                <meta name="keywords" content="CSS best practices, CSS tips, CSS organization, BEM, CSS performance">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Best Practices Guide">
                <meta property="og:description" content="Master professional CSS development.">
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
        "name": "CSS Best Practices",
        "description": "Master professional CSS development",
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

            <body class="tutorial-body" data-lesson="best-practices">
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
                                        <span>Best Practices</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Best Practices</h1>
                                        <div class="lesson-meta">
                                            <span>Advanced</span>
                                            <span>~12 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Why Best Practices Matter</h2>
                                        <p>
                                            Following CSS best practices makes your code more maintainable, performant,
                                            and easier for teams to work with. Let's explore professional CSS
                                            development techniques!
                                        </p>

                                        <h2>Naming Conventions: BEM</h2>
                                        <p>
                                            BEM (Block Element Modifier) creates clear, predictable class names:
                                            <code>.block__element--modifier</code>.
                                        </p>

                                        <% String
                                            bemHtml="<div class='card'>\n  <h2 class='card__title'>Card Title</h2>\n  <p class='card__text'>Card content goes here.</p>\n  <button class='card__button card__button--primary'>Action</button>\n</div>"
                                            ; String
                                            bemCss=".card {\n  padding: 30px;\n  background-color: white;\n  border: 2px solid #e5e7eb;\n  border-radius: 8px;\n}\n\n.card__title {\n  margin: 0 0 15px 0;\n  color: #1e40af;\n  font-size: 24px;\n}\n\n.card__text {\n  margin: 0 0 20px 0;\n  color: #475569;\n}\n\n.card__button {\n  padding: 10px 20px;\n  border: none;\n  border-radius: 6px;\n  cursor: pointer;\n}\n\n.card__button--primary {\n  background-color: #3b82f6;\n  color: white;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-bem" />
                                                <jsp:param name="initialHtml" value="<%=bemHtml%>" />
                                                <jsp:param name="initialCss" value="<%=bemCss%>" />
                                            </jsp:include>

                                            <h2>Avoid Deep Nesting</h2>
                                            <p>
                                                Keep selectors shallow (max 3 levels) for better performance and
                                                maintainability.
                                            </p>

                                            <% String
                                                nestingHtml="<nav class='nav'>\n  <ul class='nav__list'>\n    <li class='nav__item'>\n      <a href='#' class='nav__link nav__link--active'>Home</a>\n    </li>\n  </ul>\n</nav>"
                                                ; String
                                                nestingCss="/* ❌ Bad: Too deep */\n/* nav ul li a { } */\n\n/* ✅ Good: Flat with BEM */\n.nav {\n  background-color: #1e40af;\n  padding: 15px;\n}\n\n.nav__list {\n  list-style: none;\n  margin: 0;\n  padding: 0;\n}\n\n.nav__link {\n  color: white;\n  text-decoration: none;\n  padding: 10px 15px;\n  display: block;\n}\n\n.nav__link--active {\n  background-color: #3b82f6;\n  border-radius: 4px;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-nesting" />
                                                    <jsp:param name="initialHtml" value="<%=nestingHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=nestingCss%>" />
                                                </jsp:include>

                                                <h2>Use CSS Variables for Theming</h2>
                                                <p>
                                                    Centralize your design tokens in CSS variables for easy maintenance
                                                    and theming.
                                                </p>

                                                <% String
                                                    variablesHtml="<div class='container'>\n  <button class='btn'>Primary Button</button>\n  <button class='btn btn--secondary'>Secondary</button>\n</div>"
                                                    ; String
                                                    variablesCss=":root {\n  --color-primary: #3b82f6;\n  --color-secondary: #64748b;\n  --spacing-md: 12px;\n  --spacing-lg: 20px;\n  --radius: 6px;\n}\n\n.container {\n  padding: var(--spacing-lg);\n  background-color: #f1f5f9;\n}\n\n.btn {\n  padding: var(--spacing-md) var(--spacing-lg);\n  background-color: var(--color-primary);\n  color: white;\n  border: none;\n  border-radius: var(--radius);\n  margin: 5px;\n  cursor: pointer;\n}\n\n.btn--secondary {\n  background-color: var(--color-secondary);\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-variables" />
                                                        <jsp:param name="initialHtml" value="<%=variablesHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=variablesCss%>" />
                                                    </jsp:include>

                                                    <h2>Mobile-First Approach</h2>
                                                    <p>
                                                        Write base styles for mobile, then use <code>min-width</code>
                                                        media queries to enhance for larger screens.
                                                    </p>

                                                    <% String
                                                        mobileHtml="<div class='grid'>\n  <div class='grid__item'>Item 1</div>\n  <div class='grid__item'>Item 2</div>\n  <div class='grid__item'>Item 3</div>\n</div>"
                                                        ; String
                                                        mobileCss="/* Mobile first: 1 column */\n.grid {\n  display: grid;\n  gap: 15px;\n  padding: 20px;\n  background-color: #f1f5f9;\n}\n\n.grid__item {\n  padding: 30px;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n  border-radius: 8px;\n}\n\n/* Tablet: 2 columns */\n@media (min-width: 640px) {\n  .grid { grid-template-columns: repeat(2, 1fr); }\n}\n\n/* Desktop: 3 columns */\n@media (min-width: 1024px) {\n  .grid { grid-template-columns: repeat(3, 1fr); }\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-mobile" />
                                                            <jsp:param name="initialHtml" value="<%=mobileHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=mobileCss%>" />
                                                        </jsp:include>

                                                        <h2>Avoid !important</h2>
                                                        <p>
                                                            Use <code>!important</code> sparingly. Increase specificity
                                                            or reorganize CSS instead.
                                                        </p>

                                                        <% String
                                                            importantHtml="<button class='btn'>Normal Button</button>\n<button class='btn btn--special'>Special Button</button>"
                                                            ; String
                                                            importantCss="/* ❌ Bad: Using !important */\n/* .btn { color: blue !important; } */\n\n/* ✅ Good: Proper specificity */\n.btn {\n  padding: 12px 24px;\n  background-color: #64748b;\n  color: white;\n  border: none;\n  border-radius: 6px;\n  cursor: pointer;\n  margin: 5px;\n}\n\n.btn--special {\n  background-color: #10b981;\n  /* This overrides naturally */\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-important" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=importantHtml%>" />
                                                                <jsp:param name="initialCss"
                                                                    value="<%=importantCss%>" />
                                                            </jsp:include>

                                                            <h2>Performance Tips</h2>
                                                            <div class="card"
                                                                style="margin: var(--space-6) 0; padding: var(--space-6);">
                                                                <h3 style="margin-top: 0;">Optimize for Performance</h3>
                                                                <ul style="margin-bottom: 0;">
                                                                    <li>Minimize use of expensive properties
                                                                        (box-shadow, filter, opacity)</li>
                                                                    <li>Use <code>transform</code> and
                                                                        <code>opacity</code> for animations
                                                                        (GPU-accelerated)</li>
                                                                    <li>Avoid universal selector (*) when possible</li>
                                                                    <li>Combine similar selectors to reduce file size
                                                                    </li>
                                                                    <li>Use shorthand properties:
                                                                        <code>margin: 10px 20px;</code> instead of
                                                                        individual properties</li>
                                                                    <li>Minify CSS for production</li>
                                                                </ul>
                                                            </div>

                                                            <h2>Organization & Comments</h2>
                                                            <p>
                                                                Organize CSS logically and add helpful comments for team
                                                                collaboration.
                                                            </p>

                                                            <% String
                                                                organizationHtml="<div class='example'>Well-organized CSS!</div>"
                                                                ; String
                                                                organizationCss="/* ==========================================================================\n   Layout Components\n   ========================================================================== */\n\n/* Container */\n.example {\n  padding: 30px;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n  border-radius: 8px;\n}\n\n/* ==========================================================================\n   Utilities\n   ========================================================================== */\n\n/* Add utility classes here */"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId"
                                                                        value="editor-organization" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=organizationHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=organizationCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-tip">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Pro Tip:</strong> Use a CSS linter like
                                                                        Stylelint to automatically enforce best
                                                                        practices and catch errors in your code!
                                                                    </div>
                                                                </div>

                                                                <h2>Summary: CSS Best Practices</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li>✅ Use BEM or consistent naming conventions
                                                                        </li>
                                                                        <li>✅ Keep selectors shallow (max 3 levels)</li>
                                                                        <li>✅ Use CSS variables for design tokens</li>
                                                                        <li>✅ Mobile-first responsive design</li>
                                                                        <li>✅ Avoid <code>!important</code></li>
                                                                        <li>✅ Optimize for performance</li>
                                                                        <li>✅ Organize and comment your code</li>
                                                                        <li>✅ Use modern CSS features (Grid, Flexbox,
                                                                            Variables)</li>
                                                                    </ul>
                                                                </div>

                                                                <div class="callout callout-important"
                                                                    style="margin: var(--space-8) 0;">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Congratulations! 🎉</strong> You've
                                                                        completed the CSS Tutorial! You've learned
                                                                        everything from basic selectors to advanced
                                                                        techniques like Grid, Animations, and CSS
                                                                        Variables. Keep practicing and building amazing
                                                                        websites!
                                                                    </div>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId"
                                                                        value="quiz-best-practices" />
                                                                    <jsp:param name="question"
                                                                        value="What does BEM stand for?" />
                                                                    <jsp:param name="option1"
                                                                        value="Block Element Method" />
                                                                    <jsp:param name="option2"
                                                                        value="Block Element Modifier" />
                                                                    <jsp:param name="option3"
                                                                        value="Base Element Modifier" />
                                                                    <jsp:param name="option4"
                                                                        value="Block Extension Module" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink"
                                                                        value="filters-blend.jsp" />
                                                                    <jsp:param name="prevTitle"
                                                                        value="Filters & Blend Modes" />
                                                                    <jsp:param name="nextLink" value="" />
                                                                    <jsp:param name="nextTitle" value="" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="best-practices" />
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