<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - CSS Variables Lesson 30: CSS Custom Properties (Variables) --%>
        <% request.setAttribute("currentLesson", "variables" ); request.setAttribute("currentModule", "Advanced Topics"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Variables - Custom Properties | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS Variables (Custom Properties): --variable-name, var(), scope, theming, and dynamic styling with CSS custom properties.">
                <meta name="keywords" content="CSS variables, custom properties, var(), CSS theming, dynamic CSS">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Variables Complete Guide">
                <meta property="og:description" content="Master CSS custom properties.">
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
        "name": "CSS Variables",
        "description": "Master CSS custom properties",
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

            <body class="tutorial-body" data-lesson="variables">
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
                                        <span>CSS Variables</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Variables</h1>
                                        <div class="lesson-meta">
                                            <span>Advanced</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are CSS Variables?</h2>
                                        <p>
                                            CSS Variables (Custom Properties) let you store values and reuse them
                                            throughout your stylesheet. They make maintaining and theming your CSS much
                                            easier!
                                        </p>

                                        <h2>Defining Variables</h2>
                                        <p>
                                            Define variables with <code>--variable-name</code> and use them with
                                            <code>var(--variable-name)</code>. Define global variables in
                                            <code>:root</code>.
                                        </p>

                                        <% String
                                            defineHtml="<div class='card'>This card uses CSS variables for colors!</div>"
                                            ; String
                                            defineCss=":root {\n  --primary-color: #3b82f6;\n  --text-color: white;\n  --padding: 20px;\n  --border-radius: 8px;\n}\n\n.card {\n  background-color: var(--primary-color);\n  color: var(--text-color);\n  padding: var(--padding);\n  border-radius: var(--border-radius);\n  text-align: center;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-define" />
                                                <jsp:param name="initialHtml" value="<%=defineHtml%>" />
                                                <jsp:param name="initialCss" value="<%=defineCss%>" />
                                            </jsp:include>

                                            <h2>Fallback Values</h2>
                                            <p>
                                                Provide fallback values in case a variable isn't defined:
                                                <code>var(--variable, fallback)</code>.
                                            </p>

                                            <% String fallbackHtml="<div class='box'>I have a fallback color!</div>" ;
                                                String
                                                fallbackCss=".box {\n  padding: 30px;\n  text-align: center;\n  color: white;\n  /* Variable doesn't exist, so fallback is used */\n  background-color: var(--undefined-color, #10b981);\n  border-radius: var(--radius, 6px);\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-fallback" />
                                                    <jsp:param name="initialHtml" value="<%=fallbackHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=fallbackCss%>" />
                                                </jsp:include>

                                                <h2>Variable Scope</h2>
                                                <p>
                                                    Variables are scoped to the element they're defined on and its
                                                    children. Override global variables locally!
                                                </p>

                                                <% String
                                                    scopeHtml="<div class='container'>\n  <div class='box'>Global theme</div>\n  <div class='box special'>Local override</div>\n  <div class='box'>Global theme</div>\n</div>"
                                                    ; String
                                                    scopeCss=":root {\n  --bg-color: #3b82f6;\n  --text-color: white;\n}\n\n.box {\n  padding: 20px;\n  margin: 10px 0;\n  background-color: var(--bg-color);\n  color: var(--text-color);\n  text-align: center;\n}\n\n.special {\n  --bg-color: #f59e0b;\n  --text-color: #1e293b;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-scope" />
                                                        <jsp:param name="initialHtml" value="<%=scopeHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=scopeCss%>" />
                                                    </jsp:include>

                                                    <h2>Color Themes</h2>
                                                    <p>
                                                        Use variables to create switchable themes. Perfect for
                                                        light/dark mode!
                                                    </p>

                                                    <% String
                                                        themeHtml="<div class='theme-light'>\n  <h3>Light Theme</h3>\n  <p>Clean and bright interface</p>\n</div>\n<div class='theme-dark'>\n  <h3>Dark Theme</h3>\n  <p>Easy on the eyes</p>\n</div>"
                                                        ; String
                                                        themeCss=":root {\n  --light-bg: #ffffff;\n  --light-text: #1e293b;\n  --dark-bg: #1e293b;\n  --dark-text: #f1f5f9;\n}\n\n.theme-light,\n.theme-dark {\n  padding: 30px;\n  margin: 15px 0;\n  border-radius: 8px;\n}\n\n.theme-light {\n  background-color: var(--light-bg);\n  color: var(--light-text);\n  border: 2px solid #e5e7eb;\n}\n\n.theme-dark {\n  background-color: var(--dark-bg);\n  color: var(--dark-text);\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-theme" />
                                                            <jsp:param name="initialHtml" value="<%=themeHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=themeCss%>" />
                                                        </jsp:include>

                                                        <h2>Calculations with Variables</h2>
                                                        <p>
                                                            Use variables in <code>calc()</code> for dynamic
                                                            calculations.
                                                        </p>

                                                        <% String
                                                            calcHtml="<div class='container'>\n  <div class='item'>1x spacing</div>\n  <div class='item double'>2x spacing</div>\n  <div class='item triple'>3x spacing</div>\n</div>"
                                                            ; String
                                                            calcCss=":root {\n  --base-spacing: 10px;\n}\n\n.container {\n  background-color: #f1f5f9;\n  padding: 20px;\n}\n\n.item {\n  padding: var(--base-spacing);\n  margin: var(--base-spacing) 0;\n  background-color: #3b82f6;\n  color: white;\n}\n\n.double {\n  padding: calc(var(--base-spacing) * 2);\n}\n\n.triple {\n  padding: calc(var(--base-spacing) * 3);\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-calc" />
                                                                <jsp:param name="initialHtml" value="<%=calcHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=calcCss%>" />
                                                            </jsp:include>

                                                            <h2>Design System with Variables</h2>
                                                            <p>
                                                                Create a complete design system using CSS variables for
                                                                colors, spacing, and typography.
                                                            </p>

                                                            <% String
                                                                systemHtml="<button class='btn btn-primary'>Primary</button>\n<button class='btn btn-secondary'>Secondary</button>\n<button class='btn btn-success'>Success</button>"
                                                                ; String
                                                                systemCss=":root {\n  --color-primary: #3b82f6;\n  --color-secondary: #64748b;\n  --color-success: #10b981;\n  --spacing-sm: 8px;\n  --spacing-md: 12px;\n  --radius: 6px;\n}\n\n.btn {\n  padding: var(--spacing-md) calc(var(--spacing-md) * 2);\n  border: none;\n  border-radius: var(--radius);\n  color: white;\n  font-size: 16px;\n  cursor: pointer;\n  margin: var(--spacing-sm);\n}\n\n.btn-primary { background-color: var(--color-primary); }\n.btn-secondary { background-color: var(--color-secondary); }\n.btn-success { background-color: var(--color-success); }"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId" value="editor-system" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=systemHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=systemCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-tip">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Pro Tip:</strong> Use CSS variables for
                                                                        your entire design system! Define colors,
                                                                        spacing, typography, and more in
                                                                        <code>:root</code> for easy maintenance and
                                                                        theming.
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li>Define: <code>--variable-name: value;</code>
                                                                        </li>
                                                                        <li>Use: <code>var(--variable-name)</code></li>
                                                                        <li>Fallback:
                                                                            <code>var(--variable, fallback)</code></li>
                                                                        <li>Global scope: Define in <code>:root</code>
                                                                        </li>
                                                                        <li>Local scope: Override in specific elements
                                                                        </li>
                                                                        <li>Perfect for themes, design systems, and
                                                                            maintainability</li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId" value="quiz-variables" />
                                                                    <jsp:param name="question"
                                                                        value="Where should you define global CSS variables?" />
                                                                    <jsp:param name="option1" value="body" />
                                                                    <jsp:param name="option2" value=":root" />
                                                                    <jsp:param name="option3" value="html" />
                                                                    <jsp:param name="option4" value="*" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink"
                                                                        value="combinators.jsp" />
                                                                    <jsp:param name="prevTitle" value="Combinators" />
                                                                    <jsp:param name="nextLink"
                                                                        value="css-functions.jsp" />
                                                                    <jsp:param name="nextTitle" value="CSS Functions" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="variables" />
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