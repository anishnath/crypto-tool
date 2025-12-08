<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Combinators Lesson 29: CSS Combinators --%>
        <% request.setAttribute("currentLesson", "combinators" );
            request.setAttribute("currentModule", "Advanced Selectors" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Combinators - Descendant, Child, Sibling Selectors | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS combinators: descendant (space), child (>), adjacent sibling (+), general sibling (~) for precise element relationships.">
                <meta name="keywords"
                    content="CSS combinators, descendant selector, child selector, sibling selector, CSS selectors">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Combinators Complete Guide">
                <meta property="og:description" content="Master CSS combinators.">
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
        "name": "CSS Combinators",
        "description": "Master CSS combinators",
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

            <body class="tutorial-body" data-lesson="combinators">
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
                                        <span>Combinators</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Combinators</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Combinators?</h2>
                                        <p>
                                            Combinators define relationships between selectors. They let you target
                                            elements based on their position relative to other elements in the DOM tree.
                                        </p>

                                        <h2>Descendant Selector (Space)</h2>
                                        <p>
                                            The space combinator selects all descendants (children, grandchildren, etc.)
                                            of an element.
                                        </p>

                                        <% String
                                            descendantHtml="<div class='container'>\n  <p>Direct child paragraph</p>\n  <div>\n    <p>Nested paragraph (grandchild)</p>\n  </div>\n  <p>Another direct child</p>\n</div>\n<p>Outside paragraph</p>"
                                            ; String
                                            descendantCss=".container p {\n  padding: 15px;\n  background-color: #3b82f6;\n  color: white;\n  margin: 10px 0;\n}\n\n.container {\n  background-color: #f1f5f9;\n  padding: 20px;\n  margin-bottom: 10px;\n}\n\np {\n  margin: 0;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-descendant" />
                                                <jsp:param name="initialHtml" value="<%=descendantHtml%>" />
                                                <jsp:param name="initialCss" value="<%=descendantCss%>" />
                                            </jsp:include>

                                            <h2>Child Selector (>)</h2>
                                            <p>
                                                The <code>></code> combinator selects only direct children, not deeper
                                                descendants.
                                            </p>

                                            <% String
                                                childHtml="<div class='parent'>\n  <p>Direct child (styled)</p>\n  <div>\n    <p>Grandchild (not styled)</p>\n  </div>\n  <p>Another direct child (styled)</p>\n</div>"
                                                ; String
                                                childCss=".parent > p {\n  padding: 15px;\n  background-color: #10b981;\n  color: white;\n  margin: 10px 0;\n}\n\n.parent {\n  background-color: #fef3c7;\n  padding: 20px;\n}\n\np {\n  margin: 0;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-child" />
                                                    <jsp:param name="initialHtml" value="<%=childHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=childCss%>" />
                                                </jsp:include>

                                                <h2>Adjacent Sibling Selector (+)</h2>
                                                <p>
                                                    The <code>+</code> combinator selects the element immediately
                                                    following another element (same parent).
                                                </p>

                                                <% String
                                                    adjacentHtml="<div class='content'>\n  <h2>Heading</h2>\n  <p>First paragraph (immediately after h2)</p>\n  <p>Second paragraph</p>\n  <h2>Another Heading</h2>\n  <p>First paragraph after second h2</p>\n</div>"
                                                    ; String
                                                    adjacentCss="h2 + p {\n  background-color: #f59e0b;\n  color: white;\n  padding: 15px;\n  font-weight: 600;\n}\n\n.content {\n  background-color: #f1f5f9;\n  padding: 20px;\n}\n\nh2 {\n  color: #1e40af;\n  margin: 15px 0 10px 0;\n}\n\np {\n  margin: 10px 0;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-adjacent" />
                                                        <jsp:param name="initialHtml" value="<%=adjacentHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=adjacentCss%>" />
                                                    </jsp:include>

                                                    <h2>General Sibling Selector (~)</h2>
                                                    <p>
                                                        The <code>~</code> combinator selects all siblings following an
                                                        element (not just the immediate one).
                                                    </p>

                                                    <% String
                                                        siblingHtml="<div class='wrapper'>\n  <h3>Title</h3>\n  <p>First sibling paragraph</p>\n  <p>Second sibling paragraph</p>\n  <div>A div sibling</div>\n  <p>Third sibling paragraph</p>\n</div>"
                                                        ; String
                                                        siblingCss="h3 ~ p {\n  background-color: #8b5cf6;\n  color: white;\n  padding: 12px;\n  margin: 8px 0;\n}\n\n.wrapper {\n  background-color: #e0e7ff;\n  padding: 20px;\n}\n\nh3 {\n  color: #5b21b6;\n  margin: 0 0 15px 0;\n}\n\ndiv {\n  background-color: #c7d2fe;\n  padding: 12px;\n  margin: 8px 0;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-sibling" />
                                                            <jsp:param name="initialHtml" value="<%=siblingHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=siblingCss%>" />
                                                        </jsp:include>

                                                        <h2>Combining Multiple Combinators</h2>
                                                        <p>
                                                            Chain combinators together for precise targeting. Read from
                                                            right to left!
                                                        </p>

                                                        <% String
                                                            combineHtml="<nav>\n  <ul>\n    <li><a href='#'>Home</a></li>\n    <li>\n      <a href='#'>Products</a>\n      <ul>\n        <li><a href='#'>Nested Item 1</a></li>\n        <li><a href='#'>Nested Item 2</a></li>\n      </ul>\n    </li>\n    <li><a href='#'>Contact</a></li>\n  </ul>\n</nav>"
                                                            ; String
                                                            combineCss="nav > ul > li > a {\n  display: block;\n  padding: 12px 20px;\n  background-color: #3b82f6;\n  color: white;\n  text-decoration: none;\n  margin: 5px 0;\n}\n\nnav ul ul li a {\n  background-color: #1e40af;\n  padding-left: 40px;\n}\n\nul {\n  list-style: none;\n  padding: 0;\n  margin: 0;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-combine" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=combineHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=combineCss%>" />
                                                            </jsp:include>

                                                            <h2>Practical Example: Form Layout</h2>
                                                            <p>
                                                                Use combinators to style form elements based on their
                                                                relationships.
                                                            </p>

                                                            <% String
                                                                formHtml="<form>\n  <label>Name</label>\n  <input type='text' />\n  <label>Email</label>\n  <input type='email' />\n  <button>Submit</button>\n</form>"
                                                                ; String
                                                                formCss="form {\n  background-color: #f1f5f9;\n  padding: 30px;\n  border-radius: 8px;\n}\n\nlabel {\n  display: block;\n  font-weight: 600;\n  color: #1e293b;\n  margin-bottom: 8px;\n}\n\nlabel + input {\n  width: 100%;\n  padding: 12px;\n  border: 2px solid #e5e7eb;\n  border-radius: 6px;\n  margin-bottom: 20px;\n  font-size: 16px;\n}\n\nlabel + input:focus {\n  outline: none;\n  border-color: #3b82f6;\n}\n\nbutton {\n  padding: 12px 30px;\n  background-color: #10b981;\n  color: white;\n  border: none;\n  border-radius: 6px;\n  cursor: pointer;\n  font-size: 16px;\n}"
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
                                                                        <strong>Pro Tip:</strong> Use child selector
                                                                        <code>></code> instead of descendant selector
                                                                        (space) when possible for better performance and
                                                                        more predictable styling!
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>A B</code> (space) - Descendant: all B
                                                                            inside A</li>
                                                                        <li><code>A > B</code> - Child: direct children
                                                                            B of A</li>
                                                                        <li><code>A + B</code> - Adjacent sibling: B
                                                                            immediately after A</li>
                                                                        <li><code>A ~ B</code> - General sibling: all B
                                                                            siblings after A</li>
                                                                        <li>Combinators can be chained for precise
                                                                            targeting</li>
                                                                        <li>Read complex selectors from right to left
                                                                        </li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId" value="quiz-combinators" />
                                                                    <jsp:param name="question"
                                                                        value="Which combinator selects only direct children?" />
                                                                    <jsp:param name="option1" value="Space" />
                                                                    <jsp:param name="option2" value=">" />
                                                                    <jsp:param name="option3" value="+" />
                                                                    <jsp:param name="option4" value="~" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink"
                                                                        value="attribute-selectors.jsp" />
                                                                    <jsp:param name="prevTitle"
                                                                        value="Attribute Selectors" />
                                                                    <jsp:param name="nextLink" value="variables.jsp" />
                                                                    <jsp:param name="nextTitle" value="CSS Variables" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="combinators" />
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