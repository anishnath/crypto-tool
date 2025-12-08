<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Attribute Selectors Lesson 28: CSS Attribute Selectors --%>
        <% request.setAttribute("currentLesson", "attribute-selectors" );
            request.setAttribute("currentModule", "Advanced Selectors" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Attribute Selectors - Target Elements by Attributes | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS attribute selectors: [attr], [attr=value], [attr^=value], [attr$=value], [attr*=value] for precise element targeting.">
                <meta name="keywords"
                    content="CSS attribute selectors, attribute selector, CSS selectors, data attributes">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Attribute Selectors Guide">
                <meta property="og:description" content="Master CSS attribute selectors.">
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
        "name": "CSS Attribute Selectors",
        "description": "Master CSS attribute selectors",
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

            <body class="tutorial-body" data-lesson="attribute-selectors">
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
                                        <span>Attribute Selectors</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Attribute Selectors</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~9 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Attribute Selectors?</h2>
                                        <p>
                                            Attribute selectors target elements based on their attributes and values.
                                            They're powerful for styling forms, links, and data attributes!
                                        </p>

                                        <h2>Has Attribute [attr]</h2>
                                        <p>
                                            Select elements that have a specific attribute, regardless of its value.
                                        </p>

                                        <% String
                                            hasAttrHtml="<input type='text' placeholder='Normal' />\n<input type='text' placeholder='Required' required />\n<input type='text' placeholder='Disabled' disabled />"
                                            ; String
                                            hasAttrCss="input {\n  padding: 12px;\n  margin: 10px 0;\n  border: 2px solid #e5e7eb;\n  border-radius: 6px;\n  font-size: 16px;\n  display: block;\n}\n\ninput[required] {\n  border-color: #f59e0b;\n  background-color: #fef3c7;\n}\n\ninput[disabled] {\n  background-color: #f1f5f9;\n  color: #9ca3af;\n  cursor: not-allowed;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-has-attr" />
                                                <jsp:param name="initialHtml" value="<%=hasAttrHtml%>" />
                                                <jsp:param name="initialCss" value="<%=hasAttrCss%>" />
                                            </jsp:include>

                                            <h2>Exact Match [attr=value]</h2>
                                            <p>
                                                Select elements where the attribute exactly matches the specified value.
                                            </p>

                                            <% String
                                                exactHtml="<input type='text' placeholder='Text' />\n<input type='email' placeholder='Email' />\n<input type='password' placeholder='Password' />\n<input type='submit' value='Submit' />"
                                                ; String
                                                exactCss="input {\n  padding: 12px;\n  margin: 8px 0;\n  border: 2px solid #e5e7eb;\n  border-radius: 6px;\n  font-size: 16px;\n  display: block;\n}\n\ninput[type='email'] {\n  border-color: #3b82f6;\n}\n\ninput[type='submit'] {\n  background-color: #10b981;\n  color: white;\n  border: none;\n  cursor: pointer;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-exact" />
                                                    <jsp:param name="initialHtml" value="<%=exactHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=exactCss%>" />
                                                </jsp:include>

                                                <h2>Starts With [attr^=value]</h2>
                                                <p>
                                                    Select elements where the attribute value starts with the specified
                                                    string.
                                                </p>

                                                <% String
                                                    startsHtml="<a href='https://google.com'>Google (https)</a>\n<a href='http://example.com'>Example (http)</a>\n<a href='mailto:test@example.com'>Email</a>\n<a href='tel:1234567890'>Phone</a>"
                                                    ; String
                                                    startsCss="a {\n  display: block;\n  padding: 12px;\n  margin: 8px 0;\n  text-decoration: none;\n  border-radius: 6px;\n}\n\na[href^='https'] {\n  background-color: #10b981;\n  color: white;\n}\n\na[href^='mailto'] {\n  background-color: #3b82f6;\n  color: white;\n}\n\na[href^='tel'] {\n  background-color: #f59e0b;\n  color: white;\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-starts" />
                                                        <jsp:param name="initialHtml" value="<%=startsHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=startsCss%>" />
                                                    </jsp:include>

                                                    <h2>Ends With [attr$=value]</h2>
                                                    <p>
                                                        Select elements where the attribute value ends with the
                                                        specified string. Great for file types!
                                                    </p>

                                                    <% String
                                                        endsHtml="<a href='document.pdf'>PDF File</a>\n<a href='image.jpg'>Image File</a>\n<a href='video.mp4'>Video File</a>\n<a href='page.html'>HTML Page</a>"
                                                        ; String
                                                        endsCss="a {\n  display: block;\n  padding: 12px;\n  margin: 8px 0;\n  text-decoration: none;\n  border-radius: 6px;\n  color: white;\n}\n\na[href$='.pdf'] {\n  background-color: #ef4444;\n}\n\na[href$='.jpg'] {\n  background-color: #8b5cf6;\n}\n\na[href$='.mp4'] {\n  background-color: #ec4899;\n}\n\na[href$='.html'] {\n  background-color: #3b82f6;\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-ends" />
                                                            <jsp:param name="initialHtml" value="<%=endsHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=endsCss%>" />
                                                        </jsp:include>

                                                        <h2>Contains [attr*=value]</h2>
                                                        <p>
                                                            Select elements where the attribute value contains the
                                                            specified string anywhere.
                                                        </p>

                                                        <% String
                                                            containsHtml="<div class='box primary'>Primary Box</div>\n<div class='box secondary'>Secondary Box</div>\n<div class='card primary'>Primary Card</div>\n<div class='item'>Regular Item</div>"
                                                            ; String
                                                            containsCss="div {\n  padding: 20px;\n  margin: 10px 0;\n  border-radius: 6px;\n}\n\n[class*='primary'] {\n  background-color: #3b82f6;\n  color: white;\n}\n\n[class*='secondary'] {\n  background-color: #64748b;\n  color: white;\n}\n\n.item {\n  background-color: #f1f5f9;\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-contains" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=containsHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=containsCss%>" />
                                                            </jsp:include>

                                                            <h2>Data Attributes</h2>
                                                            <p>
                                                                Style elements based on custom data attributes. Perfect
                                                                for state management!
                                                            </p>

                                                            <% String
                                                                dataHtml="<div class='status' data-status='success'>Success Message</div>\n<div class='status' data-status='warning'>Warning Message</div>\n<div class='status' data-status='error'>Error Message</div>"
                                                                ; String
                                                                dataCss=".status {\n  padding: 15px 20px;\n  margin: 10px 0;\n  border-radius: 6px;\n  font-weight: 600;\n}\n\n[data-status='success'] {\n  background-color: #d1fae5;\n  color: #065f46;\n  border-left: 4px solid #10b981;\n}\n\n[data-status='warning'] {\n  background-color: #fef3c7;\n  color: #92400e;\n  border-left: 4px solid #f59e0b;\n}\n\n[data-status='error'] {\n  background-color: #fee2e2;\n  color: #991b1b;\n  border-left: 4px solid #ef4444;\n}"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId" value="editor-data" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=dataHtml%>" />
                                                                    <jsp:param name="initialCss" value="<%=dataCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-tip">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Pro Tip:</strong> Use data attributes
                                                                        with attribute selectors for state-based styling
                                                                        without adding/removing classes with JavaScript!
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>[attr]</code> - Has attribute</li>
                                                                        <li><code>[attr=value]</code> - Exact match</li>
                                                                        <li><code>[attr^=value]</code> - Starts with
                                                                        </li>
                                                                        <li><code>[attr$=value]</code> - Ends with</li>
                                                                        <li><code>[attr*=value]</code> - Contains</li>
                                                                        <li>Great for forms, links, and data attributes
                                                                        </li>
                                                                        <li>Case-insensitive with <code>i</code> flag:
                                                                            <code>[attr=value i]</code>
                                                                        </li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId"
                                                                        value="quiz-attribute-selectors" />
                                                                    <jsp:param name="question"
                                                                        value="Which selector matches attributes that end with a value?" />
                                                                    <jsp:param name="option1" value="[attr^=value]" />
                                                                    <jsp:param name="option2" value="[attr$=value]" />
                                                                    <jsp:param name="option3" value="[attr*=value]" />
                                                                    <jsp:param name="option4" value="[attr~=value]" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink"
                                                                        value="pseudo-elements.jsp" />
                                                                    <jsp:param name="prevTitle"
                                                                        value="Pseudo Elements" />
                                                                    <jsp:param name="nextLink"
                                                                        value="combinators.jsp" />
                                                                    <jsp:param name="nextTitle" value="Combinators" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="attribute-selectors" />
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