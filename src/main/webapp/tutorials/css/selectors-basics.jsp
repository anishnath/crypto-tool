<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Selectors Basics Lesson 3: Element, Class, and ID Selectors --%>
        <% request.setAttribute("currentLesson", "selectors-basics" );
            request.setAttribute("currentModule", "Getting Started" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Selectors Basics - Element, Class, ID | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn the three fundamental CSS selectors: element, class, and ID selectors. Master targeting HTML elements for styling.">
                <meta name="keywords"
                    content="CSS selectors, element selector, class selector, ID selector, CSS targeting">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Selectors Basics">
                <meta property="og:description" content="Learn element, class, and ID selectors in CSS.">
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
        "name": "CSS Selectors Basics",
        "description": "Learn element, class, and ID selectors in CSS",
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

            <body class="tutorial-body" data-lesson="selectors-basics">
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
                                        <span>Selectors Basics</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Selectors Basics</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Selectors?</h2>
                                        <p>
                                            Selectors are patterns used to <strong>target</strong> HTML elements you
                                            want to style. Think of them as the "address" that tells CSS which elements
                                            to apply styles to.
                                        </p>

                                        <h2>1. Element Selector</h2>
                                        <p>
                                            The element selector targets <strong>all elements</strong> of a specific
                                            type. Use the element name directly.
                                        </p>

                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-element" />
                                            <jsp:param name="initialHtml"
                                                value="<h1>Main Heading</h1>\n<p>First paragraph.</p>\n<p>Second paragraph.</p>\n<h2>Subheading</h2>" />
                                            <jsp:param name="initialCss"
                                                value="/* Targets ALL paragraphs */\np {\n  color: #64748b;\n  font-size: 16px;\n}\n\n/* Targets ALL h1 elements */\nh1 {\n  color: #2563eb;\n  font-size: 32px;\n}" />
                                        </jsp:include>

                                        <h2>2. Class Selector</h2>
                                        <p>
                                            The class selector targets elements with a specific <code>class</code>
                                            attribute. Use a <strong>dot (.)</strong> followed by the class name.
                                            Classes are <strong>reusable</strong> - multiple elements can have the same
                                            class.
                                        </p>


                                        <%
                                            String editor_class_html = "<p>Normal paragraph.</p>\n<p class='highlight'>Highlighted paragraph.</p>\n<p class='highlight'>Another highlighted one.</p>\n<button class='btn'>Click Me</button>";
                                            String editor_class_css = "/* Targets elements with class='highlight' */\n.highlight {\n background-color: #fef3c7;\n padding: 12px;\n border-radius: 6px;\n}\n\n.btn {\n background-color: #2563eb;\n color: white;\n padding: 10px 20px;\n border: none;\n border-radius: 6px;\n}";
                                        %>
                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-class" />
                                            <jsp:param name="initialHtml" value="<%=editor_class_html%>" />
                                            <jsp:param name="initialCss" value="<%=editor_class_css%>" />
                                        </jsp:include>


                                        <div class="callout callout-tip">
                                            <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10" />
                                                <path d="M12 16v-4M12 8h.01" />
                                            </svg>
                                            <div class="callout-content">
                                                <strong>Tip:</strong> Use classes for styling elements that appear
                                                multiple times. They're the most commonly used selector!
                                            </div>
                                        </div>

                                        <h2>3. ID Selector</h2>
                                        <p>
                                            The ID selector targets a <strong>single unique</strong> element with a
                                            specific <code>id</code> attribute. Use a <strong>hash (#)</strong> followed
                                            by the ID name. IDs must be unique on a page.
                                        </p>


                                        <%
                                            String editor_id_html = "<header id=\"main-header\">\n<h1>Website Title</h1>\n</header>\n<p>Some content here.</p>\n<footer id=\"main-footer\">\n<p>© 2024 My Site</p>\n</footer>";
                                            String editor_id_css = "/* Targets the element with id=\"main-header\" */\n#main-header {\n background-color: #1e293b;\n color: white;\n padding: 20px;\n text-align: center;\n}\n\n#main-footer {\n background-color: #f1f5f9;\n padding: 16px;\n text-align: center;\n margin-top: 20px;\n}";
                                        %>
                                        <jsp:include page="../tutorial-editor.jsp">
                                            <jsp:param name="editorId" value="editor-id" />
                                            <jsp:param name="initialHtml" value="<%=editor_id_html%>" />
                                            <jsp:param name="initialCss" value="<%=editor_id_css%>" />
                                        </jsp:include>


                                        <h2>Selector Comparison</h2>
                                        <div class="card" style="margin-bottom: var(--space-6);">
                                            <table style="width: 100%; border-collapse: collapse;">
                                                <thead>
                                                    <tr style="border-bottom: 2px solid var(--border-color);">
                                                        <th style="padding: 12px; text-align: left;">Selector</th>
                                                        <th style="padding: 12px; text-align: left;">Syntax</th>
                                                        <th style="padding: 12px; text-align: left;">Use Case</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr style="border-bottom: 1px solid var(--border-color);">
                                                        <td style="padding: 12px;"><strong>Element</strong></td>
                                                        <td style="padding: 12px;"><code>p { }</code></td>
                                                        <td style="padding: 12px;">All elements of that type</td>
                                                    </tr>
                                                    <tr style="border-bottom: 1px solid var(--border-color);">
                                                        <td style="padding: 12px;"><strong>Class</strong></td>
                                                        <td style="padding: 12px;"><code>.highlight { }</code></td>
                                                        <td style="padding: 12px;">Reusable styles</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding: 12px;"><strong>ID</strong></td>
                                                        <td style="padding: 12px;"><code>#header { }</code></td>
                                                        <td style="padding: 12px;">Unique elements</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="callout callout-important">
                                            <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10" />
                                                <line x1="12" y1="8" x2="12" y2="12" />
                                                <line x1="12" y1="16" x2="12.01" y2="16" />
                                            </svg>
                                            <div class="callout-content">
                                                <strong>Best Practice:</strong> Use classes for most styling. Reserve
                                                IDs for JavaScript or unique page sections.
                                            </div>
                                        </div>

                                        <jsp:include page="../tutorial-quiz.jsp">
                                            <jsp:param name="quizId" value="quiz-selectors" />
                                            <jsp:param name="question"
                                                value="Which selector is best for styling multiple elements with the same style?" />
                                            <jsp:param name="option1" value="Element selector" />
                                            <jsp:param name="option2" value="Class selector" />
                                            <jsp:param name="option3" value="ID selector" />
                                            <jsp:param name="option4" value="All are the same" />
                                            <jsp:param name="correctAnswer" value="1" />
                                        </jsp:include>

                                        <jsp:include page="../tutorial-nav.jsp">
                                            <jsp:param name="prevLink" value="adding-css.jsp" />
                                            <jsp:param name="prevTitle" value="Adding CSS" />
                                            <jsp:param name="nextLink" value="colors.jsp" />
                                            <jsp:param name="nextTitle" value="Colors" />
                                            <jsp:param name="currentLessonId" value="selectors-basics" />
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