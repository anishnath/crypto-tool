<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Adding JavaScript Lesson 2: How to Add JavaScript to Your Web Pages --%>
        <% request.setAttribute("currentLesson", "adding-javascript" );
            request.setAttribute("currentModule", "Getting Started" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>Adding JavaScript to HTML - Script Tags & External Files | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn how to add JavaScript to your web pages using script tags, external files, and best practices for script placement.">
                <meta name="keywords"
                    content="JavaScript script tag, add JavaScript to HTML, external JavaScript, inline JavaScript">

                <meta property="og:type" content="article">
                <meta property="og:title" content="Adding JavaScript to HTML">
                <meta property="og:description" content="Learn how to include JavaScript in your web pages">
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
        "name": "Adding JavaScript",
        "description": "Learn how to add JavaScript to HTML pages",
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

            <body class="tutorial-body" data-lesson="adding-javascript">
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
                                        <span>Adding JavaScript</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Adding JavaScript to HTML</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~7 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>The &lt;script&gt; Tag</h2>
                                        <p>
                                            JavaScript code is added to HTML using the <code>&lt;script&gt;</code> tag.
                                            There are three main ways to include JavaScript in your web pages.
                                        </p>

                                        <h2>Method 1: Inline JavaScript</h2>
                                        <p>
                                            Write JavaScript directly inside the <code>&lt;script&gt;</code> tag. This
                                            is great for small scripts and learning.
                                        </p>

                                        <% String inlineHtml="<!DOCTYPE html>\\n<html>\\n<head>\\n  <title>Inline JavaScript</title>\\n</head>\\n<body>\\n  <h1 id='heading'>Hello!</h1>\\n  <button onclick='changeText()'>Click Me</button>\\n  \\n  <script>\\n    function changeText() { \\n      document.getElementById('heading').textContent = 'JavaScript Works!'; \\n } \\n  </script>\\n</body>\\n</html>"; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-inline" />
                                                <jsp:param name="initialHtml" value="<%=inlineHtml%>" />
                                            </jsp:include>

                                            <h2>Method 2: Internal JavaScript</h2>
                                            <p>
                                                Place JavaScript in the <code>&lt;head&gt;</code> or
                                                <code>&lt;body&gt;</code> section. Common for page-specific scripts.
                                            </p>

                                            <% String
                                                internalHtml="<h1>Counter: <span id='count'>0</span></h1>\n<button id='incrementBtn'>Increment</button>\n<button id='resetBtn'>Reset</button>"
                                                ; String
                                                internalJs="// Internal JavaScript example\nlet count = 0;\nconst countDisplay = document.getElementById('count');\n\ndocument.getElementById('incrementBtn').addEventListener('click', function() {\n  count++;\n  countDisplay.textContent = count;\n});\n\ndocument.getElementById('resetBtn').addEventListener('click', function() {\n  count = 0;\n  countDisplay.textContent = count;\n});"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-internal" />
                                                    <jsp:param name="initialHtml" value="<%=internalHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=internalJs%>" />
                                                </jsp:include>

                                                <h2>Method 3: External JavaScript</h2>
                                                <p>
                                                    Link to an external <code>.js</code> file using the <code>src</code>
                                                    attribute. Best for larger projects and code reusability.
                                                </p>

                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <h3 style="margin: 0 0 var(--space-3) 0;">HTML File</h3>
                                                    <pre class="code-example"><code>&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
  &lt;title&gt;External JavaScript&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
  &lt;h1&gt;My Page&lt;/h1&gt;
  
  &lt;!-- Link to external JavaScript file --&gt;
  &lt;script src="script.js"&gt;&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;</code></pre>

                                                    <h3 style="margin: var(--space-4) 0 var(--space-3) 0;">script.js
                                                        File</h3>
                                                    <pre class="code-example"><code>// External JavaScript file
console.log('External script loaded!');
alert('Hello from external file!');</code></pre>
                                                </div>

                                                <h2>Script Placement: Where to Put &lt;script&gt; Tags?</h2>
                                                <p>
                                                    The location of your <code>&lt;script&gt;</code> tag affects when
                                                    the JavaScript executes.
                                                </p>

                                                <div
                                                    style="display: grid; gap: var(--space-4); margin: var(--space-6) 0;">
                                                    <div class="card">
                                                        <h3
                                                            style="margin: 0 0 var(--space-2) 0; color: var(--accent-primary);">
                                                            📍 In &lt;head&gt;</h3>
                                                        <p
                                                            style="margin: 0 0 var(--space-2) 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                            Loads before the page content</p>
                                                        <pre class="code-example-sm"><code>&lt;head&gt;
  &lt;script src="script.js"&gt;&lt;/script&gt;
&lt;/head&gt;</code></pre>
                                                        <p
                                                            style="margin: var(--space-2) 0 0 0; color: var(--text-muted); font-size: var(--text-sm);">
                                                            ⚠️ May slow down page loading</p>
                                                    </div>

                                                    <div class="card">
                                                        <h3
                                                            style="margin: 0 0 var(--space-2) 0; color: var(--success);">
                                                            ✅ Before &lt;/body&gt; (Recommended)</h3>
                                                        <p
                                                            style="margin: 0 0 var(--space-2) 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                            Loads after page content</p>
                                                        <pre class="code-example-sm"><code>&lt;body&gt;
  &lt;!-- Page content --&gt;
  &lt;script src="script.js"&gt;&lt;/script&gt;
&lt;/body&gt;</code></pre>
                                                        <p
                                                            style="margin: var(--space-2) 0 0 0; color: var(--success); font-size: var(--text-sm);">
                                                            ✅ Faster page loading, DOM is ready</p>
                                                    </div>
                                                </div>

                                                <h2>Defer and Async Attributes</h2>
                                                <p>
                                                    Modern attributes that control how scripts load and execute.
                                                </p>

                                                <% String
                                                    deferHtml="<h2>Script Loading Demo</h2>\n<p>Check the console to see the loading order!</p>\n<div id='output'></div>"
                                                    ; String
                                                    deferJs="// This script demonstrates execution timing\nconsole.log('1. Script started');\n\nconst output = document.getElementById('output');\noutput.innerHTML = '<p>✅ DOM is ready!</p>';\noutput.style.color = '#10b981';\noutput.style.fontWeight = 'bold';\n\nconsole.log('2. Script finished');\nconsole.log('3. DOM elements are accessible');"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-defer" />
                                                        <jsp:param name="initialHtml" value="<%=deferHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=deferJs%>" />
                                                    </jsp:include>

                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <h3 style="margin: 0 0 var(--space-3) 0;">Attribute Comparison
                                                        </h3>
                                                        <table style="width: 100%; border-collapse: collapse;">
                                                            <thead>
                                                                <tr
                                                                    style="border-bottom: 2px solid var(--border-color);">
                                                                    <th
                                                                        style="padding: var(--space-3); text-align: left;">
                                                                        Attribute</th>
                                                                    <th
                                                                        style="padding: var(--space-3); text-align: left;">
                                                                        When It Runs</th>
                                                                    <th
                                                                        style="padding: var(--space-3); text-align: left;">
                                                                        Use Case</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr
                                                                    style="border-bottom: 1px solid var(--border-color);">
                                                                    <td style="padding: var(--space-3);">
                                                                        <code>defer</code>
                                                                    </td>
                                                                    <td style="padding: var(--space-3);">After HTML
                                                                        parsing</td>
                                                                    <td style="padding: var(--space-3);">Most scripts
                                                                    </td>
                                                                </tr>
                                                                <tr
                                                                    style="border-bottom: 1px solid var(--border-color);">
                                                                    <td style="padding: var(--space-3);">
                                                                        <code>async</code>
                                                                    </td>
                                                                    <td style="padding: var(--space-3);">As soon as
                                                                        downloaded</td>
                                                                    <td style="padding: var(--space-3);">Analytics, ads
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="padding: var(--space-3);">None</td>
                                                                    <td style="padding: var(--space-3);">Immediately
                                                                    </td>
                                                                    <td style="padding: var(--space-3);">Critical
                                                                        scripts</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>

                                                    <div class="callout callout-tip">
                                                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="10" />
                                                            <path d="M12 16v-4M12 8h.01" />
                                                        </svg>
                                                        <div class="callout-content">
                                                            <strong>Best Practice:</strong> Place scripts at the end of
                                                            <code>&lt;body&gt;</code> or use <code>defer</code>
                                                            attribute for better page load performance!
                                                        </div>
                                                    </div>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Use <code>&lt;script&gt;</code> tag to add JavaScript
                                                            </li>
                                                            <li>Three methods: inline, internal, external</li>
                                                            <li>External files are best for larger projects</li>
                                                            <li>Place scripts before <code>&lt;/body&gt;</code> for
                                                                better performance</li>
                                                            <li>Use <code>defer</code> for scripts that need the full
                                                                DOM</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-adding" />
                                                        <jsp:param name="question"
                                                            value="Where is the best place to put script tags for optimal page loading?" />
                                                        <jsp:param name="option1" value="In the &lt;head&gt; section" />
                                                        <jsp:param name="option2" value="Before &lt;/body&gt; tag" />
                                                        <jsp:param name="option3" value="After &lt;/html&gt; tag" />
                                                        <jsp:param name="option4" value="In a CSS file" />
                                                        <jsp:param name="correctAnswer" value="1" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="introduction.jsp" />
                                                        <jsp:param name="prevTitle" value="Introduction" />
                                                        <jsp:param name="nextLink" value="console-debugging.jsp" />
                                                        <jsp:param name="nextTitle" value="Console & Debugging" />
                                                        <jsp:param name="currentLessonId" value="adding-javascript" />
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