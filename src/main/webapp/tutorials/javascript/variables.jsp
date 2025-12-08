<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Variables Lesson 4: var, let, const, and scope --%>
        <% request.setAttribute("currentLesson", "variables" ); request.setAttribute("currentModule", "Fundamentals" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Variables - var, let, const | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript variables with var, let, and const. Understand scope, hoisting, and best practices for declaring variables.">
                <meta name="keywords"
                    content="JavaScript variables, var let const, JavaScript scope, variable declaration">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Variables">
                <meta property="og:description" content="Master JavaScript variable declaration">
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
        "name": "JavaScript Variables",
        "description": "Learn variable declaration with var, let, and const",
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

            <body class="tutorial-body" data-lesson="variables">
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
                                        <span>Variables</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Variables</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~10 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Variables?</h2>
                                        <p>
                                            Variables are <strong>containers for storing data values</strong>. Think of
                                            them as labeled boxes where you can store information and retrieve it later.
                                        </p>

                                        <% String basicHtml="<h2>Variable Demo</h2>\n<p id='output'></p>" ; String
                                            basicJs="// Declaring variables\nlet name = 'Alice';\nlet age = 25;\nlet isStudent = true;\n\n// Using variables\nconst output = document.getElementById('output');\noutput.innerHTML = `\n  <strong>Name:</strong> ${name}<br>\n  <strong>Age:</strong> ${age}<br>\n  <strong>Student:</strong> ${isStudent}\n`;\noutput.style.fontSize = '16px';"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-basic" />
                                                <jsp:param name="initialHtml" value="<%=basicHtml%>" />
                                                <jsp:param name="initialJs" value="<%=basicJs%>" />
                                            </jsp:include>

                                            <h2>Three Ways to Declare Variables</h2>
                                            <p>
                                                JavaScript has three keywords for declaring variables: <code>var</code>,
                                                <code>let</code>, and <code>const</code>.
                                            </p>

                                            <div style="display: grid; gap: var(--space-4); margin: var(--space-6) 0;">
                                                <div class="card">
                                                    <h3
                                                        style="margin: 0 0 var(--space-2) 0; color: var(--accent-primary);">
                                                        let (Recommended)</h3>
                                                    <p style="margin: 0 0 var(--space-2) 0;">Modern way to declare
                                                        variables that can be reassigned</p>
                                                    <pre class="code-example-sm"><code>let score = 0;
score = 10; // ✅ Can reassign</code></pre>
                                                </div>

                                                <div class="card">
                                                    <h3 style="margin: 0 0 var(--space-2) 0; color: var(--success);">
                                                        const (Recommended)</h3>
                                                    <p style="margin: 0 0 var(--space-2) 0;">For values that won't be
                                                        reassigned (constants)</p>
                                                    <pre class="code-example-sm"><code>const PI = 3.14159;
// PI = 3; // ❌ Error! Cannot reassign</code></pre>
                                                </div>

                                                <div class="card">
                                                    <h3 style="margin: 0 0 var(--space-2) 0; color: var(--text-muted);">
                                                        var (Old Way)</h3>
                                                    <p style="margin: 0 0 var(--space-2) 0;">Legacy way, avoid in modern
                                                        code</p>
                                                    <pre class="code-example-sm"><code>var oldStyle = 'avoid this';
// Has weird scoping issues</code></pre>
                                                </div>
                                            </div>

                                            <h2>let vs const - When to Use Each?</h2>

                                            <% String
                                                letConstHtml="<h2>let vs const</h2>\n<button id='btn'>Click to Update</button>\n<p id='result'></p>"
                                                ; String
                                                letConstJs="// Use let for values that change\nlet counter = 0;\n\n// Use const for values that don't change\nconst maxClicks = 10;\nconst result = document.getElementById('result');\n\ndocument.getElementById('btn').addEventListener('click', function() {\n  counter++; // ✅ Can change let variables\n  \n  result.innerHTML = `\n    Clicks: ${counter} / ${maxClicks}\n  `;\n  \n  if (counter >= maxClicks) {\n    result.innerHTML += '<br><strong>Maximum reached!</strong>';\n    result.style.color = '#10b981';\n  }\n});"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-letconst" />
                                                    <jsp:param name="initialHtml" value="<%=letConstHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=letConstJs%>" />
                                                </jsp:include>

                                                <div class="callout callout-tip">
                                                    <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10" />
                                                        <path d="M12 16v-4M12 8h.01" />
                                                    </svg>
                                                    <div class="callout-content">
                                                        <strong>Best Practice:</strong> Use <code>const</code> by
                                                        default. Only use <code>let</code> when you know the value will
                                                        change. Avoid <code>var</code>.
                                                    </div>
                                                </div>

                                                <h2>Variable Naming Rules</h2>
                                                <div class="card" style="margin: var(--space-6) 0;">
                                                    <h3 style="margin: 0 0 var(--space-3) 0;">✅ Valid Names</h3>
                                                    <pre class="code-example-sm"><code>let userName = 'Alice';
let user_age = 25;
let $price = 99.99;
let _private = 'secret';
let camelCaseStyle = 'recommended';</code></pre>

                                                    <h3 style="margin: var(--space-4) 0 var(--space-3) 0;">❌ Invalid
                                                        Names</h3>
                                                    <pre class="code-example-sm"><code>let 123name = 'error';  // Can't start with number
let user-name = 'error'; // No hyphens
let let = 'error';       // Can't use keywords
let my name = 'error';   // No spaces</code></pre>
                                                </div>

                                                <h2>Variable Scope</h2>
                                                <p>
                                                    Scope determines where variables can be accessed in your code.
                                                </p>

                                                <% String
                                                    scopeHtml="<h2>Scope Demo</h2>\n<button id='testScope'>Test Scope</button>\n<div id='scopeOutput'></div>"
                                                    ; String
                                                    scopeJs="// Global scope - accessible everywhere\nconst globalVar = 'I am global';\n\ndocument.getElementById('testScope').addEventListener('click', function() {\n  // Function scope - only inside this function\n  let functionVar = 'I am in function';\n  \n  if (true) {\n    // Block scope - only inside this block\n    let blockVar = 'I am in block';\n    console.log(blockVar); // ✅ Works\n  }\n  \n  // console.log(blockVar); // ❌ Error! blockVar not accessible here\n  \n  const output = document.getElementById('scopeOutput');\n  output.innerHTML = `\n    <p>Global: ${globalVar}</p>\n    <p>Function: ${functionVar}</p>\n    <p>Block variable is not accessible outside its block</p>\n  `;\n  output.style.padding = '1rem';\n  output.style.background = 'var(--bg-secondary)';\n  output.style.borderRadius = 'var(--radius-md)';\n});"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-scope" />
                                                        <jsp:param name="initialHtml" value="<%=scopeHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=scopeJs%>" />
                                                    </jsp:include>

                                                    <h2>Reassigning Variables</h2>

                                                    <% String
                                                        reassignHtml="<h2>Reassignment Demo</h2>\n<button id='changeBtn'>Change Values</button>\n<p id='display'></p>"
                                                        ; String
                                                        reassignJs="// let allows reassignment\nlet score = 0;\n\n// const does NOT allow reassignment\nconst playerName = 'Alice';\n\nconst display = document.getElementById('display');\n\n// Initial display\ndisplay.innerHTML = `Player: ${playerName}, Score: ${score}`;\n\ndocument.getElementById('changeBtn').addEventListener('click', function() {\n  // ✅ Can reassign let variables\n  score = score + 10;\n  \n  // ❌ Cannot reassign const\n  // playerName = 'Bob'; // This would cause an error!\n  \n  display.innerHTML = `Player: ${playerName}, Score: ${score}`;\n  display.style.color = '#10b981';\n  display.style.fontWeight = 'bold';\n});"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-reassign" />
                                                            <jsp:param name="initialHtml" value="<%=reassignHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=reassignJs%>" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li>Variables store data values</li>
                                                                <li>Use <code>const</code> by default for values that
                                                                    won't change</li>
                                                                <li>Use <code>let</code> for values that will be
                                                                    reassigned</li>
                                                                <li>Avoid <code>var</code> in modern JavaScript</li>
                                                                <li>Variable names must start with a letter, $, or _
                                                                </li>
                                                                <li>Use camelCase for variable names</li>
                                                                <li><code>let</code> and <code>const</code> have block
                                                                    scope</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-variables" />
                                                            <jsp:param name="question"
                                                                value="Which keyword should you use for a value that won't be reassigned?" />
                                                            <jsp:param name="option1" value="var" />
                                                            <jsp:param name="option2" value="let" />
                                                            <jsp:param name="option3" value="const" />
                                                            <jsp:param name="option4" value="variable" />
                                                            <jsp:param name="correctAnswer" value="2" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="console-debugging.jsp" />
                                                            <jsp:param name="prevTitle" value="Console & Debugging" />
                                                            <jsp:param name="nextLink" value="data-types.jsp" />
                                                            <jsp:param name="nextTitle" value="Data Types" />
                                                            <jsp:param name="currentLessonId" value="variables" />
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