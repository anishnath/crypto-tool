<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Introduction Lesson 1: What is JavaScript? --%>
        <% request.setAttribute("currentLesson", "introduction" );
            request.setAttribute("currentModule", "Getting Started" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Introduction - What is JavaScript? | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn what JavaScript is, its history, and why it's essential for modern web development. Start your JavaScript journey here!">
                <meta name="keywords"
                    content="JavaScript introduction, what is JavaScript, JavaScript basics, learn JavaScript">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Introduction">
                <meta property="og:description" content="Learn JavaScript from scratch">
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
        "name": "JavaScript Introduction",
        "description": "Learn what JavaScript is and why it matters",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "isPartOf": {
            "@type": "Course",
            "name": "JavaScript Tutorial",
            "url": "https://8gwifi.org/tutorials/javascript/"
        }
    }
    </script>
            <%-- Ads --%>
                <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
            </head>

            <body class="tutorial-body" data-lesson="introduction">
                <div class="tutorial-layout">
                    <%@ include file="../tutorial-header.jsp" %>

                        <main class="tutorial-main">
                            <%@ include file="../tutorial-sidebar-javascript.jsp" %>
                                <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                                <article class="tutorial-content">
                                    <nav class="breadcrumb">
                                        <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/">JavaScript</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <span>Introduction</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Introduction to JavaScript</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~8 min read</span>
                                        </div>
                                    </header>

                                    <%-- Ad Slot: Top of Article --%>
                                        <jsp:include page="../tutorial-ad-slot.jsp">
                                            <jsp:param name="slot" value="top" />
                                            <jsp:param name="adSlot" value="1234567890" />
                                            <jsp:param name="format" value="auto" />
                                            <jsp:param name="responsive" value="true" />
                                        </jsp:include>

                                        <div class="lesson-body">
                                            <h2>What is JavaScript?</h2>
                                            <p>
                                                JavaScript is a <strong>programming language</strong> that makes
                                                websites
                                                interactive and dynamic. While HTML provides structure and CSS handles
                                                styling, JavaScript brings your web pages to life!
                                            </p>

                                            <div class="callout callout-tip">
                                                <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <circle cx="12" cy="12" r="10" />
                                                    <path d="M12 16v-4M12 8h.01" />
                                                </svg>
                                                <div class="callout-content">
                                                    <strong>Fun Fact:</strong> JavaScript was created in just 10 days by
                                                    Brendan Eich in 1995! Despite its name, it has nothing to do with
                                                    Java.
                                                </div>
                                            </div>

                                            <h2>Why Learn JavaScript?</h2>
                                            <div class="card" style="margin: var(--space-6) 0;">
                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                    <li><strong>Universal:</strong> Runs in every web browser</li>
                                                    <li><strong>Versatile:</strong> Frontend, backend (Node.js), mobile
                                                        apps, desktop apps</li>
                                                    <li><strong>In-Demand:</strong> One of the most popular programming
                                                        languages</li>
                                                    <li><strong>Beginner-Friendly:</strong> Easy to start, powerful when
                                                        mastered</li>
                                                    <li><strong>Huge Ecosystem:</strong> Millions of libraries and
                                                        frameworks</li>
                                                </ul>
                                            </div>

                                            <h2>Your First JavaScript Code</h2>
                                            <p>
                                                Let's write your first JavaScript! This code displays a message in the
                                                browser console.
                                            </p>

                                            <% String
                                                helloHtml="<h1>Hello JavaScript!</h1>\n<p>Open the browser console (F12) to see the message.</p>"
                                                ; String
                                                helloJs="// Your first JavaScript code!\nconsole.log('Hello, JavaScript!');\nconsole.log('Welcome to programming!');"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-hello" />
                                                    <jsp:param name="initialHtml" value="<%=helloHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=helloJs%>" />
                                                </jsp:include>

                                                <h2>What Can JavaScript Do?</h2>
                                                <p>
                                                    JavaScript can manipulate HTML elements, respond to user actions,
                                                    and
                                                    create dynamic content. Here's a simple example:
                                                </p>

                                                <% String
                                                    interactiveHtml="<button id='myButton'>Click Me!</button>\n<p id='message'></p>"
                                                    ; String
                                                    interactiveJs="// Get the button and paragraph elements\nconst button = document.getElementById('myButton');\nconst message = document.getElementById('message');\n\n// Add a click event listener\nbutton.addEventListener('click', function() {\n  message.textContent = 'You clicked the button! 🎉';\n  message.style.color = '#10b981';\n  message.style.fontWeight = 'bold';\n});"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-interactive" />
                                                        <jsp:param name="initialHtml" value="<%=interactiveHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=interactiveJs%>" />
                                                    </jsp:include>

                                                    <h2>JavaScript Capabilities</h2>
                                                    <div
                                                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: var(--space-4); margin: var(--space-6) 0;">
                                                        <div class="card">
                                                            <h3
                                                                style="margin: 0 0 var(--space-2) 0; color: var(--accent-primary);">
                                                                🎨 DOM Manipulation</h3>
                                                            <p
                                                                style="margin: 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                                Change HTML content, styles, and structure dynamically
                                                            </p>
                                                        </div>
                                                        <div class="card">
                                                            <h3
                                                                style="margin: 0 0 var(--space-2) 0; color: var(--accent-primary);">
                                                                ⚡ Event Handling</h3>
                                                            <p
                                                                style="margin: 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                                Respond to clicks, keyboard input, mouse movements</p>
                                                        </div>
                                                        <div class="card">
                                                            <h3
                                                                style="margin: 0 0 var(--space-2) 0; color: var(--accent-primary);">
                                                                🌐 API Communication</h3>
                                                            <p
                                                                style="margin: 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                                Fetch data from servers, send requests, update content
                                                            </p>
                                                        </div>
                                                        <div class="card">
                                                            <h3
                                                                style="margin: 0 0 var(--space-2) 0; color: var(--accent-primary);">
                                                                ✨ Animations</h3>
                                                            <p
                                                                style="margin: 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                                Create smooth transitions and interactive animations</p>
                                                        </div>
                                                    </div>

                                                    <h2>JavaScript vs Other Languages</h2>
                                                    <p>
                                                        JavaScript is unique because it runs directly in the browser,
                                                        making
                                                        it perfect for web development.
                                                    </p>

                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <table style="width: 100%; border-collapse: collapse;">
                                                            <thead>
                                                                <tr
                                                                    style="border-bottom: 2px solid var(--border-color);">
                                                                    <th
                                                                        style="padding: var(--space-3); text-align: left;">
                                                                        Feature</th>
                                                                    <th
                                                                        style="padding: var(--space-3); text-align: left;">
                                                                        JavaScript</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr
                                                                    style="border-bottom: 1px solid var(--border-color);">
                                                                    <td style="padding: var(--space-3);">Where it runs
                                                                    </td>
                                                                    <td style="padding: var(--space-3);">Browser &
                                                                        Server
                                                                        (Node.js)</td>
                                                                </tr>
                                                                <tr
                                                                    style="border-bottom: 1px solid var(--border-color);">
                                                                    <td style="padding: var(--space-3);">Type</td>
                                                                    <td style="padding: var(--space-3);">Dynamically
                                                                        typed
                                                                    </td>
                                                                </tr>
                                                                <tr
                                                                    style="border-bottom: 1px solid var(--border-color);">
                                                                    <td style="padding: var(--space-3);">Learning curve
                                                                    </td>
                                                                    <td style="padding: var(--space-3);">
                                                                        Beginner-friendly
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="padding: var(--space-3);">Use cases</td>
                                                                    <td style="padding: var(--space-3);">Web, Mobile,
                                                                        Desktop, IoT</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>

                                                    <div class="callout callout-important">
                                                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="10" />
                                                            <path d="M12 16v-4M12 8h.01" />
                                                        </svg>
                                                        <div class="callout-content">
                                                            <strong>Remember:</strong> JavaScript is
                                                            <strong>not</strong>
                                                            Java! They are completely different programming languages
                                                            with
                                                            different purposes and syntax.
                                                        </div>
                                                    </div>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>JavaScript makes websites interactive and dynamic</li>
                                                            <li>It runs in every web browser</li>
                                                            <li>Can be used for frontend, backend, mobile, and desktop
                                                                development</li>
                                                            <li>One of the most popular and in-demand programming
                                                                languages
                                                            </li>
                                                            <li>Easy to learn but powerful when mastered</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                                        <jsp:param name="slot" value="bottom" />
                                                        <jsp:param name="adSlot" value="1122334455" />
                                                        <jsp:param name="format" value="autorelaxed" />
                                                        <jsp:param name="responsive" value="true" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-intro" />
                                                        <jsp:param name="question"
                                                            value="What is the primary purpose of JavaScript?" />
                                                        <jsp:param name="option1" value="To style web pages" />
                                                        <jsp:param name="option2"
                                                            value="To make websites interactive" />
                                                        <jsp:param name="option3" value="To structure web content" />
                                                        <jsp:param name="option4" value="To manage databases" />
                                                        <jsp:param name="correctAnswer" value="1" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="" />
                                                        <jsp:param name="prevTitle" value="" />
                                                        <jsp:param name="nextLink" value="adding-javascript.jsp" />
                                                        <jsp:param name="nextTitle" value="Adding JavaScript" />
                                                        <jsp:param name="currentLessonId" value="introduction" />
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