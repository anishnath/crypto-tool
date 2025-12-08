<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Best Practices Lesson 35: Coding conventions, performance tips, avoiding global variables
        --%>
        <% request.setAttribute("currentLesson", "best-practices" );
            request.setAttribute("currentModule", "Practical Topics" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Best Practices | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript best practices. Improve your code quality with coding conventions, performance tips, and common pitfalls to avoid.">
                <meta name="keywords"
                    content="JavaScript best practices, coding conventions, performance tips, clean code">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Best Practices">
                <meta property="og:description" content="Master JavaScript Best Practices">
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

            <body class="tutorial-body" data-lesson="best-practices">
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
                                        <span>Best Practices</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Best Practices</h1>
                                        <div class="lesson-meta">
                                            <span>Practical</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Avoid Global Variables</h2>
                                        <p>
                                            Minimize the use of global variables. Global variables are easy to overwrite
                                            by other scripts.
                                        </p>
                                        <pre class="code-example"><code>// Bad
var name = "John";

// Good (Local Scope)
function myFunction() {
  let name = "John";
}

// Good (Block Scope)
{
  let name = "John";
}</code></pre>

                                        <h2>Always Declare Local Variables</h2>
                                        <p>
                                            All variables used in a function should be declared as local variables.
                                            Local variables must be declared with the <code>var</code>,
                                            <code>let</code>, or <code>const</code> keyword.
                                        </p>

                                        <h2>Declarations on Top</h2>
                                        <p>
                                            It is a good coding practice to put all declarations at the top of each
                                            script or function.
                                        </p>
                                        <pre class="code-example"><code>// Good
let firstName, lastName, price, discount, fullPrice;

firstName = "John";
lastName = "Doe";
price = 19.90;
discount = 0.10;
fullPrice = price * 100 / discount;</code></pre>

                                        <h2>Initialize Variables</h2>
                                        <p>
                                            It is a good coding practice to initialize variables when you declare them.
                                        </p>
                                        <pre class="code-example"><code>// Good
let firstName = "";
let lastName = "";
let price = 0;
let discount = 0;
let myArray = [];
let myObject = {};</code></pre>

                                        <h2>Use === Comparison</h2>
                                        <p>
                                            The <code>==</code> comparison operator converts types (to matching types)
                                            before comparison. The <code>===</code> operator forces comparison of values
                                            and type.
                                        </p>
                                        <% String equalHtml="<h2>Comparison Demo</h2>\n<p id='equalOutput'></p>" ;
                                            String
                                            equalJs="let x = 0;\nlet y = '0';\n\nlet loose = (x == y);  // true\nlet strict = (x === y); // false\n\ndocument.getElementById('equalOutput').innerHTML = \n  `0 == '0' is ${loose}<br>0 === '0' is ${strict}`;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-equal" />
                                                <jsp:param name="initialHtml" value="<%=equalHtml%>" />
                                                <jsp:param name="initialJs" value="<%=equalJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Use "use strict"</h2>
                                            <p>
                                                "use strict" defines that JavaScript code should be executed in "strict
                                                mode". This makes it easier to write "secure" JavaScript.
                                            </p>
                                            <pre class="code-example"><code>"use strict";
x = 3.14; // This will cause an error because x is not declared</code></pre>

                                            <h2>Summary</h2>
                                            <div class="card" style="margin: var(--space-6) 0;">
                                                <ul style="margin: 0; padding-left: var(--space-6);">
                                                    <li>Always declare variables.</li>
                                                    <li>Use <code>const</code> and <code>let</code> instead of
                                                        <code>var</code>.</li>
                                                    <li>Use <code>===</code> instead of <code>==</code>.</li>
                                                    <li>Avoid global variables.</li>
                                                    <li>Use <code>"use strict"</code>.</li>
                                                </ul>
                                            </div>

                                            <jsp:include page="../tutorial-quiz.jsp">
                                                <jsp:param name="quizId" value="quiz-best" />
                                                <jsp:param name="question"
                                                    value="Which operator checks both value and type?" />
                                                <jsp:param name="option1" value="=" />
                                                <jsp:param name="option2" value="==" />
                                                <jsp:param name="option3" value="===" />
                                                <jsp:param name="option4" value="!=" />
                                                <jsp:param name="correctAnswer" value="3" />
                                            </jsp:include>

                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="local-storage.jsp" />
                                                <jsp:param name="prevTitle" value="Local Storage" />
                                                <jsp:param name="nextLink"
                                                    value="<%=request.getContextPath()%>/tutorials/javascript/" />
                                                <jsp:param name="nextTitle" value="Back to Index" />
                                                <jsp:param name="currentLessonId" value="best-practices" />
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