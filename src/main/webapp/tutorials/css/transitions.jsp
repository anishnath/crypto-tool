<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Transitions Lesson 24: CSS Transitions for Smooth Effects --%>
        <% request.setAttribute("currentLesson", "transitions" );
            request.setAttribute("currentModule", "Styling Elements" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Transitions - Smooth Property Changes | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS transitions: transition-property, transition-duration, transition-timing-function, transition-delay for smooth animations.">
                <meta name="keywords"
                    content="CSS transitions, transition-property, transition-duration, ease, linear, CSS animation">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Transitions Complete Guide">
                <meta property="og:description" content="Master CSS transitions.">
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
        "name": "CSS Transitions",
        "description": "Master CSS transitions",
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

            <body class="tutorial-body" data-lesson="transitions">
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
                                        <span>Transitions</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Transitions</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~9 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Transitions?</h2>
                                        <p>
                                            Transitions create smooth changes between property values. Perfect for hover
                                            effects, focus states, and interactive elements!
                                        </p>

                                        <h2>Basic Transition</h2>
                                        <p>
                                            Use <code>transition</code> to animate property changes. Hover over the
                                            boxes to see the effect!
                                        </p>

                                        <% String basicHtml="<button class='btn'>Hover me!</button>" ; String
                                            basicCss=".btn {\n  padding: 15px 30px;\n  background-color: #3b82f6;\n  color: white;\n  border: none;\n  border-radius: 8px;\n  font-size: 16px;\n  cursor: pointer;\n  transition: background-color 0.3s;\n}\n\n.btn:hover {\n  background-color: #1e40af;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=basicHtml%>" />
                                                <jsp:param name="initialCss" value="<%=basicCss%>" />
                                            </jsp:include>

                                            <h2>Transition Duration</h2>
                                            <p>
                                                <code>transition-duration</code> controls how long the transition takes.
                                                Use seconds (s) or milliseconds (ms).
                                            </p>

                                            <% String
                                                durationHtml="<div class='box fast'>0.2s</div>\n<div class='box medium'>0.5s</div>\n<div class='box slow'>1s</div>"
                                                ; String
                                                durationCss=".box {\n  width: 100px;\n  padding: 30px;\n  margin: 10px;\n  background-color: #10b981;\n  color: white;\n  text-align: center;\n  display: inline-block;\n}\n\n.fast {\n  transition: transform 0.2s;\n}\n\n.medium {\n  transition: transform 0.5s;\n}\n\n.slow {\n  transition: transform 1s;\n}\n\n.box:hover {\n  transform: scale(1.2);\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-duration" />
                                                    <jsp:param name="initialHtml" value="<%=durationHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=durationCss%>" />
                                                </jsp:include>

                                                <h2>Timing Functions</h2>
                                                <p>
                                                    <code>transition-timing-function</code> controls the speed curve:
                                                    <code>ease</code>, <code>linear</code>, <code>ease-in</code>,
                                                    <code>ease-out</code>, <code>ease-in-out</code>.
                                                </p>

                                                <% String
                                                    timingHtml="<div class='box linear'>linear</div>\n<div class='box ease'>ease</div>\n<div class='box ease-in-out'>ease-in-out</div>"
                                                    ; String
                                                    timingCss=".box {\n  width: 100px;\n  padding: 25px;\n  margin: 10px 0;\n  background-color: #f59e0b;\n  color: white;\n  text-align: center;\n  transition-duration: 0.5s;\n  transition-property: transform;\n}\n\n.linear { transition-timing-function: linear; }\n.ease { transition-timing-function: ease; }\n.ease-in-out { transition-timing-function: ease-in-out; }\n\n.box:hover {\n  transform: translateX(200px);\n}"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-timing" />
                                                        <jsp:param name="initialHtml" value="<%=timingHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=timingCss%>" />
                                                    </jsp:include>

                                                    <h2>Transition Delay</h2>
                                                    <p>
                                                        <code>transition-delay</code> adds a pause before the transition
                                                        starts.
                                                    </p>

                                                    <% String
                                                        delayHtml="<div class='box delay-0'>No delay</div>\n<div class='box delay-1'>0.3s delay</div>\n<div class='box delay-2'>0.6s delay</div>"
                                                        ; String
                                                        delayCss=".box {\n  width: 100px;\n  padding: 25px;\n  margin: 10px;\n  background-color: #8b5cf6;\n  color: white;\n  text-align: center;\n  display: inline-block;\n  transition: transform 0.3s;\n}\n\n.delay-0 { transition-delay: 0s; }\n.delay-1 { transition-delay: 0.3s; }\n.delay-2 { transition-delay: 0.6s; }\n\n.box:hover {\n  transform: scale(1.3);\n}"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-delay" />
                                                            <jsp:param name="initialHtml" value="<%=delayHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=delayCss%>" />
                                                        </jsp:include>

                                                        <h2>Multiple Properties</h2>
                                                        <p>
                                                            Transition multiple properties at once by separating them
                                                            with commas, or use <code>all</code>.
                                                        </p>

                                                        <% String
                                                            multipleHtml="<div class='card'>Hover for multiple transitions!</div>"
                                                            ; String
                                                            multipleCss=".card {\n  padding: 40px;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n  border-radius: 8px;\n  transition:\n    background-color 0.3s,\n    transform 0.3s,\n    box-shadow 0.3s;\n}\n\n.card:hover {\n  background-color: #1e40af;\n  transform: translateY(-5px);\n  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);\n}"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-multiple" />
                                                                <jsp:param name="initialHtml"
                                                                    value="<%=multipleHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=multipleCss%>" />
                                                            </jsp:include>

                                                            <h2>Transition Shorthand</h2>
                                                            <p>
                                                                Combine all transition properties:
                                                                <code>transition: property duration timing-function delay</code>.
                                                            </p>

                                                            <% String
                                                                shorthandHtml="<button class='btn-1'>Button 1</button>\n<button class='btn-2'>Button 2</button>"
                                                                ; String
                                                                shorthandCss="button {\n  padding: 15px 30px;\n  margin: 10px;\n  border: none;\n  border-radius: 8px;\n  font-size: 16px;\n  cursor: pointer;\n  color: white;\n}\n\n.btn-1 {\n  background-color: #10b981;\n  transition: all 0.3s ease;\n}\n\n.btn-2 {\n  background-color: #ef4444;\n  transition: transform 0.5s ease-in-out 0.1s;\n}\n\n.btn-1:hover {\n  background-color: #059669;\n  transform: scale(1.05);\n}\n\n.btn-2:hover {\n  transform: rotate(5deg) scale(1.1);\n}"
                                                                ; %>
                                                                <jsp:include page="../tutorial-editor.jsp">
                                                                    <jsp:param name="editorId"
                                                                        value="editor-shorthand" />
                                                                    <jsp:param name="initialHtml"
                                                                        value="<%=shorthandHtml%>" />
                                                                    <jsp:param name="initialCss"
                                                                        value="<%=shorthandCss%>" />
                                                                </jsp:include>

                                                                <div class="callout callout-tip">
                                                                    <svg class="callout-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4M12 8h.01" />
                                                                    </svg>
                                                                    <div class="callout-content">
                                                                        <strong>Pro Tip:</strong> Keep transitions fast
                                                                        (0.2-0.3s) for better UX. Slow transitions can
                                                                        make your site feel sluggish!
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>transition-property</code> - Which
                                                                            property to animate</li>
                                                                        <li><code>transition-duration</code> - How long
                                                                            (s or ms)</li>
                                                                        <li><code>transition-timing-function</code> -
                                                                            Speed curve</li>
                                                                        <li><code>transition-delay</code> - Wait before
                                                                            starting</li>
                                                                        <li>Shorthand:
                                                                            <code>transition: property duration timing delay</code>
                                                                        </li>
                                                                        <li>Use <code>all</code> to transition all
                                                                            properties</li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId" value="quiz-transitions" />
                                                                    <jsp:param name="question"
                                                                        value="Which timing function creates a constant speed transition?" />
                                                                    <jsp:param name="option1" value="ease" />
                                                                    <jsp:param name="option2" value="linear" />
                                                                    <jsp:param name="option3" value="ease-in-out" />
                                                                    <jsp:param name="option4" value="ease-out" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink" value="transforms.jsp" />
                                                                    <jsp:param name="prevTitle" value="Transforms" />
                                                                    <jsp:param name="nextLink" value="animations.jsp" />
                                                                    <jsp:param name="nextTitle" value="Animations" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="transitions" />
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