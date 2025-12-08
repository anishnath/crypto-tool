<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Console & Debugging Lesson 3: Console Methods and Debugging Basics --%>
        <% request.setAttribute("currentLesson", "console-debugging" );
            request.setAttribute("currentModule", "Getting Started" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Console & Debugging - Master console.log() | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript console methods, debugging techniques, and how to troubleshoot your code effectively.">
                <meta name="keywords"
                    content="JavaScript console, console.log, debugging JavaScript, browser console, JavaScript errors">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Console & Debugging">
                <meta property="og:description" content="Master console methods and debugging">
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
        "name": "Console & Debugging",
        "description": "Learn console methods and debugging techniques",
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

            <body class="tutorial-body" data-lesson="console-debugging">
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
                                        <span>Console & Debugging</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">Console & Debugging</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~9 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What is the Console?</h2>
                                        <p>
                                            The browser console is a powerful tool for viewing output, testing code, and
                                            debugging. It's your best friend when learning JavaScript!
                                        </p>

                                        <div class="callout callout-tip">
                                            <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10" />
                                                <path d="M12 16v-4M12 8h.01" />
                                            </svg>
                                            <div class="callout-content">
                                                <strong>Open the Console:</strong> Press <kbd>F12</kbd> or
                                                <kbd>Ctrl+Shift+I</kbd> (Windows/Linux) or <kbd>Cmd+Option+I</kbd>
                                                (Mac), then click the "Console" tab.
                                            </div>
                                        </div>

                                        <h2>console.log() - Your Debugging Companion</h2>
                                        <p>
                                            <code>console.log()</code> prints messages to the console. Use it to check
                                            variable values, track code execution, and debug issues.
                                        </p>

                                        <% String
                                            logHtml="<h2>Console Log Demo</h2>\n<p>Open the browser console (F12) to see the output!</p>\n<button id='logBtn'>Log Messages</button>"
                                            ; String
                                            logJs="// Basic console.log examples\nconsole.log('Hello, Console!');\nconsole.log('The answer is:', 42);\n\n// Log multiple values\nconst name = 'Alice';\nconst age = 25;\nconsole.log('Name:', name, 'Age:', age);\n\n// Log objects and arrays\nconst person = { name: 'Bob', job: 'Developer' };\nconsole.log('Person object:', person);\n\nconst colors = ['red', 'green', 'blue'];\nconsole.log('Colors array:', colors);\n\n// Button click logging\ndocument.getElementById('logBtn').addEventListener('click', function() {\n  console.log('Button clicked at:', new Date().toLocaleTimeString());\n});"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-log" />
                                                <jsp:param name="initialHtml" value="<%=logHtml%>" />
                                                <jsp:param name="initialJs" value="<%=logJs%>" />
                                            </jsp:include>

                                            <h2>Other Console Methods</h2>
                                            <p>
                                                The console has many useful methods beyond <code>log()</code>. Each
                                                serves a specific purpose!
                                            </p>

                                            <% String
                                                methodsHtml="<h2>Console Methods Demo</h2>\n<p>Check the console to see different message types!</p>\n<button id='demoBtn'>Run All Methods</button>"
                                                ; String
                                                methodsJs="document.getElementById('demoBtn').addEventListener('click', function() {\n  // Different console methods\n  console.log('📝 Regular log message');\n  console.info('ℹ️ Informational message');\n  console.warn('⚠️ Warning message');\n  console.error('❌ Error message');\n  \n  // Table display\n  const users = [\n    { name: 'Alice', age: 25 },\n    { name: 'Bob', age: 30 },\n    { name: 'Charlie', age: 35 }\n  ];\n  console.table(users);\n  \n  // Grouping messages\n  console.group('User Details');\n  console.log('Name: Alice');\n  console.log('Age: 25');\n  console.log('Role: Developer');\n  console.groupEnd();\n  \n  // Clear console\n  // console.clear(); // Uncomment to clear\n});"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-methods" />
                                                    <jsp:param name="initialHtml" value="<%=methodsHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=methodsJs%>" />
                                                </jsp:include>

                                                <h2>Console Method Reference</h2>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <table style="width: 100%; border-collapse: collapse;">
                                                        <thead>
                                                            <tr style="border-bottom: 2px solid var(--border-color);">
                                                                <th style="padding: var(--space-3); text-align: left;">
                                                                    Method</th>
                                                                <th style="padding: var(--space-3); text-align: left;">
                                                                    Purpose</th>
                                                                <th style="padding: var(--space-3); text-align: left;">
                                                                    Example</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr style="border-bottom: 1px solid var(--border-color);">
                                                                <td style="padding: var(--space-3);"><code>log()</code>
                                                                </td>
                                                                <td style="padding: var(--space-3);">General output</td>
                                                                <td style="padding: var(--space-3);">
                                                                    <code>console.log('Hi')</code>
                                                                </td>
                                                            </tr>
                                                            <tr style="border-bottom: 1px solid var(--border-color);">
                                                                <td style="padding: var(--space-3);">
                                                                    <code>error()</code>
                                                                </td>
                                                                <td style="padding: var(--space-3);">Error messages</td>
                                                                <td style="padding: var(--space-3);">
                                                                    <code>console.error('Oops!')</code>
                                                                </td>
                                                            </tr>
                                                            <tr style="border-bottom: 1px solid var(--border-color);">
                                                                <td style="padding: var(--space-3);"><code>warn()</code>
                                                                </td>
                                                                <td style="padding: var(--space-3);">Warnings</td>
                                                                <td style="padding: var(--space-3);">
                                                                    <code>console.warn('Careful')</code>
                                                                </td>
                                                            </tr>
                                                            <tr style="border-bottom: 1px solid var(--border-color);">
                                                                <td style="padding: var(--space-3);">
                                                                    <code>table()</code>
                                                                </td>
                                                                <td style="padding: var(--space-3);">Display as table
                                                                </td>
                                                                <td style="padding: var(--space-3);">
                                                                    <code>console.table(data)</code>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding: var(--space-3);">
                                                                    <code>clear()</code>
                                                                </td>
                                                                <td style="padding: var(--space-3);">Clear console</td>
                                                                <td style="padding: var(--space-3);">
                                                                    <code>console.clear()</code>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>

                                                <h2>Debugging with console.log()</h2>
                                                <p>
                                                    Use <code>console.log()</code> strategically to track down bugs and
                                                    understand code flow.
                                                </p>

                                                <% String
                                                    debugHtml="<h2>Debugging Example</h2>\n<p>Enter a number:</p>\n<input type='number' id='numInput' value='5'>\n<button id='calculateBtn'>Calculate Square</button>\n<p id='result'></p>"
                                                    ; String
                                                    debugJs="document.getElementById('calculateBtn').addEventListener('click', function() {\n  console.log('=== Starting calculation ===');\n  \n  // Get input value\n  const input = document.getElementById('numInput').value;\n  console.log('Input value:', input);\n  console.log('Input type:', typeof input);\n  \n  // Convert to number\n  const num = Number(input);\n  console.log('Converted number:', num);\n  console.log('Number type:', typeof num);\n  \n  // Calculate square\n  const square = num * num;\n  console.log('Square result:', square);\n  \n  // Display result\n  const result = document.getElementById('result');\n  result.textContent = `The square of ${num} is ${square}`;\n  result.style.color = '#10b981';\n  result.style.fontWeight = 'bold';\n  \n  console.log('=== Calculation complete ===');\n});"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-debug" />
                                                        <jsp:param name="initialHtml" value="<%=debugHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=debugJs%>" />
                                                    </jsp:include>

                                                    <h2>Common Debugging Techniques</h2>
                                                    <div
                                                        style="display: grid; gap: var(--space-4); margin: var(--space-6) 0;">
                                                        <div class="card">
                                                            <h3
                                                                style="margin: 0 0 var(--space-2) 0; color: var(--accent-primary);">
                                                                1. Check Variable Values</h3>
                                                            <pre class="code-example-sm"><code>const result = calculateTotal();
console.log('Result:', result);</code></pre>
                                                        </div>

                                                        <div class="card">
                                                            <h3
                                                                style="margin: 0 0 var(--space-2) 0; color: var(--accent-primary);">
                                                                2. Track Function Execution</h3>
                                                            <pre class="code-example-sm"><code>function processData() {
  console.log('processData started');
  // ... code ...
  console.log('processData finished');
}</code></pre>
                                                        </div>

                                                        <div class="card">
                                                            <h3
                                                                style="margin: 0 0 var(--space-2) 0; color: var(--accent-primary);">
                                                                3. Inspect Objects</h3>
                                                            <pre class="code-example-sm"><code>const user = { name: 'Alice', age: 25 };
console.log('User object:', user);</code></pre>
                                                        </div>

                                                        <div class="card">
                                                            <h3
                                                                style="margin: 0 0 var(--space-2) 0; color: var(--accent-primary);">
                                                                4. Check Data Types</h3>
                                                            <pre class="code-example-sm"><code>const value = '42';
console.log('Type:', typeof value);</code></pre>
                                                        </div>
                                                    </div>

                                                    <div class="callout callout-warning">
                                                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z" />
                                                            <line x1="12" y1="9" x2="12" y2="13" />
                                                            <line x1="12" y1="17" x2="12.01" y2="17" />
                                                        </svg>
                                                        <div class="callout-content">
                                                            <strong>Remember:</strong> Remove or comment out
                                                            <code>console.log()</code> statements before deploying to
                                                            production!
                                                        </div>
                                                    </div>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>The console is essential for debugging JavaScript</li>
                                                            <li><code>console.log()</code> displays values and messages
                                                            </li>
                                                            <li>Use <code>console.error()</code> for errors,
                                                                <code>console.warn()</code> for warnings
                                                            </li>
                                                            <li><code>console.table()</code> displays arrays/objects as
                                                                tables</li>
                                                            <li>Strategic logging helps track code execution and find
                                                                bugs</li>
                                                            <li>Open console with F12 or Ctrl+Shift+I</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-console" />
                                                        <jsp:param name="question"
                                                            value="Which console method displays data in a table format?" />
                                                        <jsp:param name="option1" value="console.log()" />
                                                        <jsp:param name="option2" value="console.table()" />
                                                        <jsp:param name="option3" value="console.grid()" />
                                                        <jsp:param name="option4" value="console.display()" />
                                                        <jsp:param name="correctAnswer" value="1" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="adding-javascript.jsp" />
                                                        <jsp:param name="prevTitle" value="Adding JavaScript" />
                                                        <jsp:param name="nextLink" value="variables.jsp" />
                                                        <jsp:param name="nextTitle" value="Variables" />
                                                        <jsp:param name="currentLessonId" value="console-debugging" />
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