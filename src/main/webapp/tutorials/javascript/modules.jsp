<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Modules Lesson 28: Import, Export, Default vs Named Exports --%>
        <% request.setAttribute("currentLesson", "modules" ); request.setAttribute("currentModule", "Modern JavaScript"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Modules | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about ES6 Modules in JavaScript. Understand import, export, default exports, and named exports.">
                <meta name="keywords"
                    content="JavaScript modules, ES6 modules, import export, default export, named export">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Modules">
                <meta property="og:description" content="Master JavaScript Modules">
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
            <%-- Ads --%>
                <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
            </head>

            <body class="tutorial-body" data-lesson="modules">
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
                                        <span>Modules</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Modules</h1>
                                        <div class="lesson-meta">
                                            <span>Modern</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>What are Modules?</h2>
                                        <p>
                                            Modules allow you to break up your code into separate files. This makes it
                                            easier to maintain the code-base.
                                        </p>
                                        <p>
                                            ES6 introduced a native way to use modules using <code>import</code> and
                                            <code>export</code> statements.
                                        </p>

                                        <div class="callout callout-info">
                                            <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10" />
                                                <line x1="12" y1="16" x2="12" y2="12" />
                                                <line x1="12" y1="8" x2="12.01" y2="8" />
                                            </svg>
                                            <div class="callout-content">
                                                <strong>Note:</strong> Modules only work with the HTTP(s) protocol. A
                                                file-system protocol (file://) will not work.
                                            </div>
                                        </div>

                                        <h2>Named Exports</h2>
                                        <p>
                                            You can create named exports two ways. In-line individually, or all at once
                                            at the bottom.
                                        </p>
                                        <pre class="code-example"><code>// person.js
export const name = "Jesse";
export const age = 40;

// OR
const name = "Jesse";
const age = 40;
export { name, age };</code></pre>

                                        <h2>Default Exports</h2>
                                        <p>
                                            You can only have one default export in a file.
                                        </p>
                                        <pre class="code-example"><code>// message.js
const message = () => {
  const name = "Jesse";
  const age = 40;
  return name + ' is ' + age + 'years old.';
};

export default message;</code></pre>

                                        <h2>Importing</h2>
                                        <p>
                                            You can import modules into a file in two ways, based on if they are named
                                            exports or default exports.
                                        </p>
                                        <pre class="code-example"><code>// Importing named exports
import { name, age } from "./person.js";

// Importing default export
import message from "./message.js";</code></pre>

                                        <h2>Module Demo</h2>
                                        <p>
                                            Since modules require separate files, this demo simulates module behavior
                                            using an object pattern (Revealing Module Pattern), which was common before
                                            ES6 modules.
                                        </p>

                                        <% String moduleHtml="<h2>Module Pattern Demo</h2>\n<p id='moduleOutput'></p>" ;
                                            String
                                            moduleJs="const myModule = (function() {\n  // Private variables\n  const privateVar = 'I am private';\n  \n  // Public API\n  return {\n    publicMethod: function() {\n      return 'Public Method accessing: ' + privateVar;\n    }\n  };\n})();\n\ndocument.getElementById('moduleOutput').innerHTML = myModule.publicMethod();\n// document.getElementById('moduleOutput').innerHTML += myModule.privateVar; // Undefined"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-module" />
                                                <jsp:param name="initialHtml" value="<%=moduleHtml%>" />
                                                <jsp:param name="initialJs" value="<%=moduleJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Summary</h2>
                                            <div class="card" style="margin: var(--space-6) 0;">
                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                    <li>Modules help organize code into separate files.</li>
                                                    <li>Use <code>export</code> to expose variables and functions.</li>
                                                    <li>Use <code>import</code> to bring them into other files.</li>
                                                    <li>Use <code>type="module"</code> in your script tag to enable
                                                        module features.</li>
                                                </ul>
                                            </div>

                                            <jsp:include page="../tutorial-quiz.jsp">
                                                <jsp:param name="quizId" value="quiz-modules" />
                                                <jsp:param name="question"
                                                    value="How many default exports can a module have?" />
                                                <jsp:param name="option1" value="Zero" />
                                                <jsp:param name="option2" value="One" />
                                                <jsp:param name="option3" value="Two" />
                                                <jsp:param name="option4" value="Unlimited" />
                                                <jsp:param name="correctAnswer" value="2" />
                                            </jsp:include>

                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="async-await.jsp" />
                                                <jsp:param name="prevTitle" value="Async/Await" />
                                                <jsp:param name="nextLink" value="destructuring.jsp" />
                                                <jsp:param name="nextTitle" value="Destructuring" />
                                                <jsp:param name="currentLessonId" value="modules" />
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