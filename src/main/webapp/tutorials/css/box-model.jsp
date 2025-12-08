<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Box Model Basics Lesson 8: Understanding the CSS Box Model --%>
        <% request.setAttribute("currentLesson", "box-model" ); request.setAttribute("currentModule", "Box Model" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Box Model - Content, Padding, Border, Margin | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master the CSS box model: understand content, padding, border, and margin. Learn box-sizing and how elements take up space on the page.">
                <meta name="keywords"
                    content="CSS box model, padding, border, margin, box-sizing, content box, border box">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Box Model - Complete Guide">
                <meta property="og:description" content="Master the CSS box model fundamentals.">
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
        "name": "CSS Box Model",
        "description": "Master the CSS box model fundamentals",
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

            <body class="tutorial-body" data-lesson="box-model">
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
                                        <span>Box Model</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">The CSS Box Model</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~9 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is the Box Model?</h2>
                                        <p>
                                            Every HTML element is a rectangular box. The CSS box model describes how
                                            these boxes are sized and spaced. Understanding this is crucial for layout
                                            and positioning.
                                        </p>

                                        <h2>The Four Parts</h2>
                                        <p>
                                            The box model consists of four areas, from inside to outside:
                                        </p>
                                        <div class="card" style="margin: var(--space-6) 0;">
                                            <ol style="margin: 0; padding-left: var(--space-6);">
                                                <li><strong>Content</strong> - The actual content (text, images, etc.)
                                                </li>
                                                <li><strong>Padding</strong> - Space between content and border</li>
                                                <li><strong>Border</strong> - Line around the padding</li>
                                                <li><strong>Margin</strong> - Space outside the border</li>
                                            </ol>
                                        </div>

                                        <h2>Visualizing the Box Model</h2>
                                        <p>
                                            Let's see how padding, border, and margin create space around content.
                                        </p>

                                        <% String boxModelHtml="<div class='box'>Content Area</div>" ; String
                                            boxModelCss=".box {\n  /* Content */\n  width: 200px;\n  height: 100px;\n  background-color: #3b82f6;\n  color: white;\n  \n  /* Padding - space inside */\n  padding: 20px;\n  \n  /* Border */\n  border: 4px solid #1e40af;\n  \n  /* Margin - space outside */\n  margin: 30px;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=boxModelHtml%>" />
                                                <jsp:param name="initialCss" value="<%=boxModelCss%>" />
                                            </jsp:include>

                                            <div class="callout callout-tip">
                                                <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <circle cx="12" cy="12" r="10" />
                                                    <path d="M12 16v-4M12 8h.01" />
                                                </svg>
                                                <div class="callout-content">
                                                    <strong>Pro Tip:</strong> Use browser DevTools to inspect the box
                                                    model. Right-click any element and select "Inspect" to see its box
                                                    model diagram.
                                                </div>
                                            </div>

                                            <h2>Total Element Size</h2>
                                            <p>
                                                By default, the total width of an element is calculated as:<br>
                                                <code>total width = width + padding-left + padding-right + border-left + border-right</code>
                                            </p>

                                            <% String
                                                sizeCalcHtml="<div class='box1'>Box 1: 200px width</div>\n<div class='box2'>Box 2: 200px + 40px padding + 4px border = 244px total</div>"
                                                ; String
                                                sizeCalcCss=".box1 {\n  width: 200px;\n  background-color: #10b981;\n  color: white;\n  padding: 10px;\n  margin-bottom: 20px;\n}\n\n.box2 {\n  width: 200px;\n  background-color: #f59e0b;\n  color: white;\n  padding: 20px;\n  border: 2px solid #d97706;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-size" />
                                                    <jsp:param name="initialHtml" value="<%=sizeCalcHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=sizeCalcCss%>" />
                                                </jsp:include>

                                                <h2>Box-Sizing Property</h2>
                                                <p>
                                                    The <code>box-sizing</code> property changes how width and height
                                                    are calculated. <code>border-box</code> includes padding and border
                                                    in the width, making sizing much easier.
                                                </p>

                                                <% String
                                                    boxSizingHtml="<div class='content-box'>box-sizing: content-box (default)</div>\n<div class='border-box'>box-sizing: border-box (recommended)</div>"
                                                    ; String
                                                    boxSizingCss=".content-box,\n.border-box {\n  width: 200px;\n  padding: 20px;\n  border: 4px solid #6366f1;\n  background-color: #818cf8;\n  color: white;\n  margin-bottom: 20px;\n}\n\n.content-box {\n  box-sizing: content-box;\n  /* Total width: 200 + 40 + 8 = 248px */\n}\n\n.border-box {\n  box-sizing: border-box;\n  /* Total width: 200px (includes padding & border) */\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-boxsizing" />
                                                        <jsp:param name="initialHtml" value="<%=boxSizingHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=boxSizingCss%>" />
                                                    </jsp:include>

                                                    <div class="callout callout-important">
                                                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="10" />
                                                            <path d="M12 16v-4M12 8h.01" />
                                                        </svg>
                                                        <div class="callout-content">
                                                            <strong>Best Practice:</strong> Most developers use
                                                            <code>box-sizing: border-box</code> globally for easier,
                                                            more predictable layouts. Add this to your CSS reset:
                                                            <pre
                                                                style="margin-top: 8px;"><code>* { box-sizing: border-box; }</code></pre>
                                                        </div>
                                                    </div>

                                                    <h2>Key Concepts</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Every element is a box with content, padding, border,
                                                                and margin</li>
                                                            <li>Default: width/height only applies to content area</li>
                                                            <li><code>box-sizing: border-box</code> includes padding and
                                                                border in width/height</li>
                                                            <li>Margin creates space between elements</li>
                                                            <li>Padding creates space inside the element</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-box-model" />
                                                        <jsp:param name="question"
                                                            value="Which box-sizing value includes padding and border in the element's width?" />
                                                        <jsp:param name="option1" value="content-box" />
                                                        <jsp:param name="option2" value="border-box" />
                                                        <jsp:param name="option3" value="padding-box" />
                                                        <jsp:param name="option4" value="margin-box" />
                                                        <jsp:param name="correctAnswer" value="1" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="google-fonts.jsp" />
                                                        <jsp:param name="prevTitle" value="Google Fonts" />
                                                        <jsp:param name="nextLink" value="borders.jsp" />
                                                        <jsp:param name="nextTitle" value="Borders" />
                                                        <jsp:param name="currentLessonId" value="box-model" />
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