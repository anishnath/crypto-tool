<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- CSS Tutorial - Animations Lesson 25: CSS Keyframe Animations --%>
        <% request.setAttribute("currentLesson", "animations" );
            request.setAttribute("currentModule", "Styling Elements" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>CSS Animations - Keyframes & Animation Properties | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Master CSS animations: @keyframes, animation-name, animation-duration, animation-iteration-count, and creating complex animations.">
                <meta name="keywords"
                    content="CSS animations, keyframes, animation-name, animation-duration, CSS keyframe animation">

                <meta property="og:type" content="article">
                <meta property="og:title" content="CSS Animations Complete Guide">
                <meta property="og:description" content="Master CSS keyframe animations.">
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
        "name": "CSS Animations",
        "description": "Master CSS keyframe animations",
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

            <body class="tutorial-body" data-lesson="animations">
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
                                        <span>Animations</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">CSS Animations</h1>
                                        <div class="lesson-meta">
                                            <span>Intermediate</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Animations?</h2>
                                        <p>
                                            CSS animations let you create complex, multi-step animations using
                                            <code>@keyframes</code>. Unlike transitions, animations can run
                                            automatically and loop!
                                        </p>

                                        <h2>Basic Keyframes</h2>
                                        <p>
                                            Define animation steps with <code>@keyframes</code>, then apply with
                                            <code>animation-name</code> and <code>animation-duration</code>.
                                        </p>

                                        <% String basicHtml="<div class='box'>I'm animating!</div>" ; String
                                            basicCss="@keyframes slide {\n  from {\n    transform: translateX(0);\n  }\n  to {\n    transform: translateX(200px);\n  }\n}\n\n.box {\n  width: 100px;\n  padding: 20px;\n  background-color: #3b82f6;\n  color: white;\n  text-align: center;\n  animation-name: slide;\n  animation-duration: 2s;\n}"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=basicHtml%>" />
                                                <jsp:param name="initialCss" value="<%=basicCss%>" />
                                            </jsp:include>

                                            <h2>Percentage Keyframes</h2>
                                            <p>
                                                Use percentages for multi-step animations. <code>0%</code> = start,
                                                <code>100%</code> = end.
                                            </p>

                                            <% String percentHtml="<div class='circle'></div>" ; String
                                                percentCss="@keyframes bounce {\n  0% { transform: translateY(0); }\n  50% { transform: translateY(-100px); }\n  100% { transform: translateY(0); }\n}\n\n.circle {\n  width: 60px;\n  height: 60px;\n  background-color: #10b981;\n  border-radius: 50%;\n  animation: bounce 1.5s infinite;\n}"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-percent" />
                                                    <jsp:param name="initialHtml" value="<%=percentHtml%>" />
                                                    <jsp:param name="initialCss" value="<%=percentCss%>" />
                                                </jsp:include>

                                                <h2>Animation Iteration</h2>
                                                <p>
                                                    <code>animation-iteration-count</code> controls how many times the
                                                    animation runs. Use <code>infinite</code> for endless loops.
                                                </p>

                                                <% String
                                                    iterationHtml="<div class='box once'>Once</div>\n<div class='box three'>3 times</div>\n<div class='box infinite'>Infinite</div>"
                                                    ; String
                                                    iterationCss="@keyframes rotate {\n  from { transform: rotate(0deg); }\n  to { transform: rotate(360deg); }\n}\n\n.box {\n  width: 80px;\n  padding: 20px;\n  margin: 20px;\n  background-color: #f59e0b;\n  color: white;\n  text-align: center;\n  display: inline-block;\n  animation-name: rotate;\n  animation-duration: 2s;\n}\n\n.once { animation-iteration-count: 1; }\n.three { animation-iteration-count: 3; }\n.infinite { animation-iteration-count: infinite; }"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-iteration" />
                                                        <jsp:param name="initialHtml" value="<%=iterationHtml%>" />
                                                        <jsp:param name="initialCss" value="<%=iterationCss%>" />
                                                    </jsp:include>

                                                    <h2>Animation Direction</h2>
                                                    <p>
                                                        <code>animation-direction</code> controls playback:
                                                        <code>normal</code>, <code>reverse</code>,
                                                        <code>alternate</code>, <code>alternate-reverse</code>.
                                                    </p>

                                                    <% String
                                                        directionHtml="<div class='box normal'>normal</div>\n<div class='box alternate'>alternate</div>"
                                                        ; String
                                                        directionCss="@keyframes move {\n  from { transform: translateX(0); }\n  to { transform: translateX(150px); }\n}\n\n.box {\n  width: 100px;\n  padding: 20px;\n  margin: 20px 0;\n  background-color: #8b5cf6;\n  color: white;\n  text-align: center;\n  animation: move 2s infinite;\n}\n\n.normal { animation-direction: normal; }\n.alternate { animation-direction: alternate; }"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-direction" />
                                                            <jsp:param name="initialHtml" value="<%=directionHtml%>" />
                                                            <jsp:param name="initialCss" value="<%=directionCss%>" />
                                                        </jsp:include>

                                                        <h2>Animation Fill Mode</h2>
                                                        <p>
                                                            <code>animation-fill-mode</code> controls styles
                                                            before/after animation: <code>none</code>,
                                                            <code>forwards</code>, <code>backwards</code>,
                                                            <code>both</code>.
                                                        </p>

                                                        <% String
                                                            fillHtml="<div class='box none'>none</div>\n<div class='box forwards'>forwards</div>"
                                                            ; String
                                                            fillCss="@keyframes fade {\n  from {\n    opacity: 0;\n    transform: scale(0.5);\n  }\n  to {\n    opacity: 1;\n    transform: scale(1);\n  }\n}\n\n.box {\n  width: 100px;\n  padding: 20px;\n  margin: 20px;\n  background-color: #ef4444;\n  color: white;\n  text-align: center;\n  display: inline-block;\n  animation: fade 2s;\n}\n\n.none { animation-fill-mode: none; }\n.forwards { animation-fill-mode: forwards; }"
                                                            ; %>
                                                            <jsp:include page="../tutorial-editor.jsp">
                                                                <jsp:param name="editorId" value="editor-fill" />
                                                                <jsp:param name="initialHtml" value="<%=fillHtml%>" />
                                                                <jsp:param name="initialCss" value="<%=fillCss%>" />
                                                            </jsp:include>

                                                            <h2>Animation Shorthand</h2>
                                                            <p>
                                                                Combine all properties:
                                                                <code>animation: name duration timing-function delay iteration-count direction fill-mode</code>.
                                                            </p>

                                                            <% String
                                                                shorthandHtml="<div class='pulse'>Pulsing</div>\n<div class='spin'>Spinning</div>"
                                                                ; String
                                                                shorthandCss="@keyframes pulse {\n  0%, 100% { transform: scale(1); }\n  50% { transform: scale(1.2); }\n}\n\n@keyframes spin {\n  from { transform: rotate(0deg); }\n  to { transform: rotate(360deg); }\n}\n\n.pulse,\n.spin {\n  width: 80px;\n  height: 80px;\n  margin: 30px;\n  background-color: #3b82f6;\n  color: white;\n  display: inline-flex;\n  align-items: center;\n  justify-content: center;\n  border-radius: 8px;\n}\n\n.pulse {\n  animation: pulse 1.5s ease-in-out infinite;\n}\n\n.spin {\n  animation: spin 3s linear infinite;\n}"
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
                                                                        <strong>Pro Tip:</strong> Use
                                                                        <code>animation-play-state: paused</code> on
                                                                        hover to pause animations for better UX. Great
                                                                        for loading spinners!
                                                                    </div>
                                                                </div>

                                                                <h2>Summary</h2>
                                                                <div class="card" style="margin: var(--space-6) 0;">
                                                                    <ul
                                                                        style="margin: 0; padding-left: var(--space-6);">
                                                                        <li><code>@keyframes</code> - Define animation
                                                                            steps</li>
                                                                        <li><code>animation-name</code> - Which keyframe
                                                                            to use</li>
                                                                        <li><code>animation-duration</code> - How long
                                                                        </li>
                                                                        <li><code>animation-iteration-count</code> - How
                                                                            many times</li>
                                                                        <li><code>animation-direction</code> - Playback
                                                                            direction</li>
                                                                        <li><code>animation-fill-mode</code> -
                                                                            Before/after styles</li>
                                                                        <li>Use <code>infinite</code> for endless loops
                                                                        </li>
                                                                    </ul>
                                                                </div>

                                                                <jsp:include page="../tutorial-quiz.jsp">
                                                                    <jsp:param name="quizId" value="quiz-animations" />
                                                                    <jsp:param name="question"
                                                                        value="Which value makes an animation loop forever?" />
                                                                    <jsp:param name="option1" value="loop" />
                                                                    <jsp:param name="option2" value="infinite" />
                                                                    <jsp:param name="option3" value="repeat" />
                                                                    <jsp:param name="option4" value="forever" />
                                                                    <jsp:param name="correctAnswer" value="1" />
                                                                </jsp:include>

                                                                <jsp:include page="../tutorial-nav.jsp">
                                                                    <jsp:param name="prevLink"
                                                                        value="transitions.jsp" />
                                                                    <jsp:param name="prevTitle" value="Transitions" />
                                                                    <jsp:param name="nextLink"
                                                                        value="pseudo-classes.jsp" />
                                                                    <jsp:param name="nextTitle"
                                                                        value="Pseudo Classes" />
                                                                    <jsp:param name="currentLessonId"
                                                                        value="animations" />
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