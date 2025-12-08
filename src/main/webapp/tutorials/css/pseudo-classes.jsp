<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Pseudo Classes Lesson 26: CSS Pseudo Classes --%>
        <% request.setAttribute("currentLesson", "pseudo-classes" );
            request.setAttribute("currentModule", "Advanced Selectors" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Pseudo Classes - Hover, Focus, Nth-child | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS pseudo-classes: :hover, :focus, :active, :nth-child, :first-child, :last-child, and more for dynamic styling.">
                <meta name="keywords"
                    content="CSS pseudo-classes, hover, focus, nth-child, first-child, last-child, CSS selectors">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Pseudo Classes Complete Guide">
                <meta property="og:description" content="Master CSS pseudo-classes.">
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
        "name": "CSS Pseudo Classes",
        "description": "Master CSS pseudo-classes",
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

            <body class="tutorial-body" data-lesson="pseudo-classes">
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
                                        <span>Pseudo Classes</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Pseudo Classes</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Pseudo Classes?</h2>
                                        <p>
                                            Pseudo-classes select elements based on their state or position. They start
                                            with a colon <code>:</code> and add dynamic styling without extra HTML.
                                        </p>

                                        <h2>Interactive States</h2>
                                        <p>
                                            <code>:hover</code>, <code>:active</code>, and <code>:focus</code> style
                                            elements based on user interaction.
                                        </p>

                                        <% String
                                            interactiveHtml="<button class='btn'>Hover & Click Me</button>\n<input type='text' placeholder='Focus me' />"
                                            ; String
                                            interactiveCss=".btn {\n  padding: 15px 30px;\n  background-color: #3b82f6;\n  color: white;\n  border: none;\n  border-radius: 8px;\n  cursor: pointer;\n  font-size: 16px;\n  transition: all 0.3s;\n}\n\n.btn:hover {\n  background-color: #1e40af;\n  transform: translateY(-2px);\n}\n\n.btn:active {\n  transform: translateY(0);\n}\n\ninput {\n  padding: 12px;\n  margin: 20px 0;\n  border: 2px solid #e5e7eb;\n  border-radius: 6px;\n  font-size: 16px;\n  transition: border-color 0.3s;\n}\n\ninput:focus {\n  outline: none;\n  border-color: #3b82f6;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-interactive" />
                                                <jsp:param name="initialHtml" value="<%=interactiveHtml%>" />
                                                <jsp:param name="initialCss" value="<%=interactiveCss%>" />
                                            </jsp:include>

                                            <h2>First & Last Child</h2>
                                            <p>
                                                <code>:first-child</code> and <code>:last-child</code> select the first
                                                or last element among siblings.
                                            </p>

                                            <% String
                                                childHtml="<ul>\n  <li>First item</li>\n  <li>Middle item</li>\n  <li>Middle item</li>\n  <li>Last item</li>\n</ul>"
                                                ; String
                                                childCss="ul {\n  list-style: none;\n  padding: 0;\n}\n\nli {\n  padding: 15px;\n  margin: 5px 0;\n  background-color: #f1f5f9;\n}\n\nli:first-child {\n  background-color: #10b981;\n  color: white;\n  font-weight: 600;\n}\n\nli:last-child {\n  background-color: #ef4444;\n  color: white;\n  font-weight: 600;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-child" />
                                                    <jsp:param name="initialHtml" value="<%=childHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=childCss%>" />
                                                </jsp:include>

                                                <h2>Nth Child</h2>
                                                <p>
                                                    <code>:nth-child(n)</code> selects elements by position. Use
                                                    numbers, <code>odd</code>, <code>even</code>, or formulas like
                                                    <code>3n</code>.
                                                </p>

                                                <% String
                                                    nthHtml="<div class='grid'>\n  <div>1</div>\n  <div>2</div>\n  <div>3</div>\n  <div>4</div>\n  <div>5</div>\n  <div>6</div>\n  <div>7</div>\n  <div>8</div>\n</div>"
                                                    ; String
                                                    nthCss=".grid {\n  display: grid;\n  grid-template-columns: repeat(4, 1fr);\n  gap: 10px;\n}\n\n.grid div {\n  padding: 30px;\n  background-color: #e5e7eb;\n  text-align: center;\n  font-weight: 600;\n}\n\n.grid div:nth-child(odd) {\n  background-color: #3b82f6;\n  color: white;\n}\n\n.grid div:nth-child(3n) {\n  background-color: #f59e0b;\n  color: white;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-nth" />
                                                        <jsp:param name="initialHtml" value="<%=nthHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=nthCss%>" />
                                                    </jsp:include>

                                                    <h2>Not Selector</h2>
                                                    <p>
                                                        <code>:not()</code> excludes elements from selection. Great for
                                                        styling everything except specific items!
                                                    </p>

                                                    <% String
                                                        notHtml="<div class='buttons'>\n  <button>Button 1</button>\n  <button class='special'>Special</button>\n  <button>Button 3</button>\n  <button>Button 4</button>\n</div>"
                                                        ; String
                                                        notCss=".buttons {\n  display: flex;\n  gap: 10px;\n}\n\nbutton {\n  padding: 12px 24px;\n  border: none;\n  border-radius: 6px;\n  cursor: pointer;\n  font-size: 14px;\n}\n\nbutton:not(.special) {\n  background-color: #64748b;\n  color: white;\n}\n\nbutton.special {\n  background-color: #10b981;\n  color: white;\n  font-weight: 600;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-not" />
                                                            <jsp:param name="initialHtml" value="<%=notHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=notCss%>" />
                                                        </jsp:include>

                                                        <h2>Link States</h2>
                                                        <p>
                                                            Style links with <code>:link</code>, <code>:visited</code>,
                                                            <code>:hover</code>, and <code>:active</code>. Order
                                                            matters: LVHA!
                                                        </p>

                                                        <% String
                                                            linkHtml="<nav>\n  <a href='#'>Unvisited Link</a>\n  <a href='#visited'>Visited Link</a>\n  <a href='#hover'>Hover Me</a>\n</nav>"
                                                            ; String
                                                            linkCss="nav {\n  display: flex;\n  gap: 20px;\n  padding: 20px;\n  background-color: #f1f5f9;\n}\n\na:link {\n  color: #3b82f6;\n  text-decoration: none;\n  font-weight: 600;\n}\n\na:visited {\n  color: #8b5cf6;\n}\n\na:hover {\n  color: #1e40af;\n  text-decoration: underline;\n}\n\na:active {\n  color: #ef4444;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-link" />
                                                                <jsp:param name="initialHtml" value="<%=linkHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=linkCss%>" />
                                                            </jsp:include>

                                                            <h2>Form States</h2>
                                                            <p>
                                                                Style form elements with <code>:checked</code>,
                                                                <code>:disabled</code>, <code>:enabled</code>,
                                                                <code>:valid</code>, <code>:invalid</code>.
                                                            </p>

                                                            <% String
                                                                formHtml="<form>\n  <input type='checkbox' id='cb' />\n  <label for='cb'>Check me</label>\n  <input type='text' required placeholder='Required field' />\n  <button disabled>Disabled</button>\n</form>"
                                                                ; String
                                                                formCss="form {\n  display: flex;\n  flex-direction: column;\n  gap: 15px;\n}\n\ninput[type='checkbox']:checked + label {\n  color: #10b981;\n  font-weight: 600;\n}\n\ninput:invalid {\n  border-color: #ef4444;\n}\n\ninput:valid {\n  border-color: #10b981;\n}\n\nbutton:disabled {\n  background-color: #e5e7eb;\n  color: #9ca3af;\n  cursor: not-allowed;\n}"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId" value="editor-form" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=formHtml%>" />
                                                                    <jsp:param name="initialCss" value="<%=formCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-tip">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Pro Tip:</strong> Remember LVHA order
                                                                        for link states: Link, Visited, Hover, Active.
                                                                        This ensures hover and active states work
                                                                        correctly!
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>:hover</code>, <code>:focus</code>,
                                                                            <code>:active</code> - Interactive states
                                                                        </li>
                                                                        <li><code>:first-child</code>,
                                                                            <code>:last-child</code> - Position-based
                                                                        </li>
                                                                        <li><code>:nth-child(n)</code> - Select by
                                                                            formula or keyword</li>
                                                                        <li><code>:not(selector)</code> - Exclude
                                                                            elements</li>
                                                                        <li><code>:checked</code>,
                                                                            <code>:disabled</code>, <code>:valid</code>
                                                                            - Form states</li>
                                                                        <li>Pseudo-classes add no specificity weight
                                                                        </li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId"
                                                                        value="quiz-pseudo-classes" />
                                                                    <jsp:param name="question"
                                                                        value="Which pseudo-class selects every other element?" />
                                                                    <jsp:param name="option1" value=":every-other" />
                                                                    <jsp:param name="option2" value=":nth-child(2n)" />
                                                                    <jsp:param name="option3" value=":alternate" />
                                                                    <jsp:param name="option4" value=":second-child" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink" value="animations.jsp" />
                                                                    <jsp:param name="prevTitle" value="Animations" />
                                                                    <jsp:param name="nextLink"
                                                                        value="pseudo-elements.jsp" />
                                                                    <jsp:param name="nextTitle"
                                                                        value="Pseudo Elements" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="pseudo-classes" />
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