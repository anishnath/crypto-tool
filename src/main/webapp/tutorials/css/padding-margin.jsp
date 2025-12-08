<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Padding & Margin Lesson 10: Understanding Padding and Margin --%>
        <% request.setAttribute("currentLesson", "padding-margin" ); request.setAttribute("currentModule", "Box Model"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Padding & Margin - Spacing Elements | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS padding and margin: learn the difference, shorthand syntax, individual sides, and auto margins for centering elements.">
                <meta name="keywords"
                    content="CSS padding, CSS margin, spacing, margin auto, padding shorthand, box model spacing">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Padding & Margin - Complete Guide">
                <meta property="og:description" content="Master CSS padding and margin properties.">
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
        "name": "CSS Padding & Margin",
        "description": "Master CSS padding and margin properties",
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

            <body class="tutorial-body" data-lesson="padding-margin">
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
                                        <span>Padding & Margin</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Padding & Margin</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~9 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Padding vs Margin</h2>
                                        <p>
                                            <strong>Padding</strong> is space <em>inside</em> the element, between
                                            content and border.<br>
                                            <strong>Margin</strong> is space <em>outside</em> the element, between the
                                            border and other elements.
                                        </p>

                                        <% String
                                            differenceHtml="<div class='with-padding'>I have padding (space inside)</div>\n<div class='with-margin'>I have margin (space outside)</div>\n<div class='with-both'>I have both padding and margin</div>"
                                            ; String
                                            differenceCss="div {\n  background-color: #3b82f6;\n  color: white;\n  border: 2px solid #1e40af;\n}\n\n.with-padding {\n  padding: 20px;\n}\n\n.with-margin {\n  margin: 20px;\n}\n\n.with-both {\n  padding: 15px;\n  margin: 20px;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-difference" />
                                                <jsp:param name="initialHtml" value="<%=differenceHtml%>" />
                                                <jsp:param name="initialCss" value="<%=differenceCss%>" />
                                            </jsp:include>

                                            <h2>Padding Shorthand</h2>
                                            <p>
                                                The <code>padding</code> property can take 1, 2, 3, or 4 values:
                                            </p>
                                            <div class="card" style="margin: var(--space-6) 0;">
                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                    <li><code>padding: 20px;</code> - All sides</li>
                                                    <li><code>padding: 10px 20px;</code> - Top/Bottom, Left/Right</li>
                                                    <li><code>padding: 10px 20px 15px;</code> - Top, Left/Right, Bottom
                                                    </li>
                                                    <li><code>padding: 10px 20px 15px 25px;</code> - Top, Right, Bottom,
                                                        Left (clockwise)</li>
                                                </ul>
                                            </div>

                                            <% String
                                                paddingHtml="<div class='pad1'>padding: 20px;</div>\n<div class='pad2'>padding: 10px 30px;</div>\n<div class='pad3'>padding: 5px 15px 25px;</div>\n<div class='pad4'>padding: 10px 20px 30px 40px;</div>"
                                                ; String
                                                paddingCss="div {\n  background-color: #10b981;\n  color: white;\n  margin: 10px 0;\n  border: 2px solid #059669;\n}\n\n.pad1 { padding: 20px; }\n.pad2 { padding: 10px 30px; }\n.pad3 { padding: 5px 15px 25px; }\n.pad4 { padding: 10px 20px 30px 40px; }"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-padding" />
                                                    <jsp:param name="initialHtml" value="<%=paddingHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=paddingCss%>" />
                                                </jsp:include>

                                                <h2>Margin Shorthand</h2>
                                                <p>
                                                    Margin uses the same shorthand syntax as padding. It creates space
                                                    between elements.
                                                </p>

                                                <% String
                                                    marginHtml="<div class='box1'>margin: 20px;</div>\n<div class='box2'>margin: 10px 40px;</div>\n<div class='box3'>margin: 30px 0;</div>"
                                                    ; String
                                                    marginCss=".box1,\n.box2,\n.box3 {\n  background-color: #f59e0b;\n  color: white;\n  padding: 15px;\n}\n\n.box1 { margin: 20px; }\n.box2 { margin: 10px 40px; }\n.box3 { margin: 30px 0; }"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-margin" />
                                                        <jsp:param name="initialHtml" value="<%=marginHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=marginCss%>" />
                                                    </jsp:include>

                                                    <h2>Individual Sides</h2>
                                                    <p>
                                                        You can also set padding and margin for individual sides using
                                                        specific properties.
                                                    </p>

                                                    <% String
                                                        sidesHtml="<div class='custom'>Custom padding and margin on each side</div>"
                                                        ; String
                                                        sidesCss=".custom {\n  background-color: #8b5cf6;\n  color: white;\n  \n  /* Individual padding */\n  padding-top: 30px;\n  padding-right: 20px;\n  padding-bottom: 10px;\n  padding-left: 40px;\n  \n  /* Individual margin */\n  margin-top: 20px;\n  margin-bottom: 30px;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-sides" />
                                                            <jsp:param name="initialHtml" value="<%=sidesHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=sidesCss%>" />
                                                        </jsp:include>

                                                        <h2>Centering with Margin Auto</h2>
                                                        <p>
                                                            Use <code>margin: 0 auto;</code> to horizontally center a
                                                            block element with a defined width.
                                                        </p>

                                                        <% String
                                                            centerHtml="<div class='centered'>I am centered!</div>\n<div class='not-centered'>I am not centered</div>"
                                                            ; String
                                                            centerCss=".centered {\n  width: 300px;\n  margin: 0 auto;\n  background-color: #3b82f6;\n  color: white;\n  padding: 20px;\n  text-align: center;\n}\n\n.not-centered {\n  width: 300px;\n  margin-top: 20px;\n  background-color: #64748b;\n  color: white;\n  padding: 20px;\n  text-align: center;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-center" />
                                                                <jsp:param name="initialHtml" value="<%=centerHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=centerCss%>" />
                                                            </jsp:include>

                                                            <div class="callout callout-tip">
                                                                <svg class="callout-icon" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <path d="M12 16v-4M12 8h.01" />
                                                                </svg>
                                                                <div class="callout-content">
                                                                    <strong>Remember:</strong> Padding adds to the
                                                                    element's size (unless using border-box), while
                                                                    margin creates space between elements without
                                                                    affecting size.
                                                                </div>
                                                            </div>

                                                            <h2>Negative Margins</h2>
                                                            <p>
                                                                You can use negative margins to pull elements closer or
                                                                overlap them. Use carefully!
                                                            </p>

                                                            <% String
                                                                negativeHtml="<div class='box-a'>Box A</div>\n<div class='box-b'>Box B (negative margin-top)</div>"
                                                                ; String
                                                                negativeCss=".box-a {\n  background-color: #ef4444;\n  color: white;\n  padding: 20px;\n}\n\n.box-b {\n  background-color: #3b82f6;\n  color: white;\n  padding: 20px;\n  margin-top: -10px;\n}"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId"
                                                                        value="editor-negative" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=negativeHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=negativeCss%>" />
                                                                </jsp:include>

                                                                <h2>Key Points</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><strong>Padding</strong> - Space inside,
                                                                            between content and border</li>
                                                                        <li><strong>Margin</strong> - Space outside,
                                                                            between elements</li>
                                                                        <li>Both use same shorthand syntax (1-4 values)
                                                                        </li>
                                                                        <li><code>margin: 0 auto;</code> centers block
                                                                            elements</li>
                                                                        <li>Negative margins pull elements closer</li>
                                                                        <li>Individual properties:
                                                                            <code>padding-top</code>,
                                                                            <code>margin-left</code>, etc.</li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId"
                                                                        value="quiz-padding-margin" />
                                                                    <jsp:param name="question"
                                                                        value="How do you horizontally center a block element?" />
                                                                    <jsp:param name="option1"
                                                                        value="padding: 0 auto;" />
                                                                    <jsp:param name="option2" value="margin: 0 auto;" />
                                                                    <jsp:param name="option3"
                                                                        value="text-align: center;" />
                                                                    <jsp:param name="option4" value="align: center;" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink" value="borders.jsp" />
                                                                    <jsp:param name="prevTitle" value="Borders" />
                                                                    <jsp:param name="nextLink"
                                                                        value="width-height.jsp" />
                                                                    <jsp:param name="nextTitle"
                                                                        value="Width & Height" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="padding-margin" />
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