<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Operators Lesson 6: Arithmetic, Assignment, Comparison, Logical --%>
        <% request.setAttribute("currentLesson", "operators" ); request.setAttribute("currentModule", "Fundamentals" );
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Operators | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn JavaScript operators: Arithmetic, Assignment, Comparison, Logical, and Bitwise operators.">
                <meta name="keywords" content="JavaScript operators, arithmetic, comparison, logical, assignment">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Operators">
                <meta property="og:description" content="Master JavaScript operators">
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

            <body class="tutorial-body" data-lesson="operators">
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
                                        <span>Operators</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Operators</h1>
                                        <div class="lesson-meta">
                                            <span>Beginner</span>
                                            <span>~15 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Arithmetic Operators</h2>
                                        <p>
                                            Arithmetic operators are used to perform arithmetic on numbers.
                                        </p>

                                        <% String arithmeticHtml="<h2>Arithmetic Demo</h2>\n<p id='arithmetic'></p>" ;
                                            String
                                            arithmeticJs="let x = 10;\nlet y = 5;\n\nlet output = '';\noutput += `Addition (x + y): ${x + y}<br>`;\noutput += `Subtraction (x - y): ${x - y}<br>`;\noutput += `Multiplication (x * y): ${x * y}<br>`;\noutput += `Division (x / y): ${x / y}<br>`;\noutput += `Modulus (x % y): ${x % y}<br>`;\noutput += `Exponentiation (x ** y): ${x ** y}<br>`;\n\n// Increment/Decrement\noutput += `Increment (x++): ${x++} (now x is ${x})<br>`;\noutput += `Decrement (--y): ${--y} (now y is ${y})<br>`;\n\ndocument.getElementById('arithmetic').innerHTML = output;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-arithmetic" />
                                                <jsp:param name="initialHtml" value="<%=arithmeticHtml%>" />
                                                <jsp:param name="initialJs" value="<%=arithmeticJs%>" />
                                            </jsp:include>

                                            <h2>Assignment Operators</h2>
                                            <p>
                                                Assignment operators assign values to JavaScript variables.
                                            </p>

                                            <div class="card" style="margin: var(--space-6) 0;">
                                                <table class="tutorial-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Operator</th>
                                                            <th>Example</th>
                                                            <th>Same As</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td><code>=</code></td>
                                                            <td><code>x = y</code></td>
                                                            <td><code>x = y</code></td>
                                                        </tr>
                                                        <tr>
                                                            <td><code>+=</code></td>
                                                            <td><code>x += y</code></td>
                                                            <td><code>x = x + y</code></td>
                                                        </tr>
                                                        <tr>
                                                            <td><code>-=</code></td>
                                                            <td><code>x -= y</code></td>
                                                            <td><code>x = x - y</code></td>
                                                        </tr>
                                                        <tr>
                                                            <td><code>*=</code></td>
                                                            <td><code>x *= y</code></td>
                                                            <td><code>x = x * y</code></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <h2>Comparison Operators</h2>
                                            <p>
                                                Comparison operators are used in logical statements to determine
                                                equality or difference between variables or values.
                                            </p>

                                            <% String comparisonHtml="<h2>Comparison Demo</h2>\n<p id='comparison'></p>"
                                                ; String
                                                comparisonJs="let x = 5;\n\nlet output = '';\noutput += `x == 8: ${x == 8}<br>`;\noutput += `x == 5: ${x == 5}<br>`;\noutput += `x === 5: ${x === 5} (Strict equality)<br>`;\noutput += `x === '5': ${x === '5'} (Strict equality check type)<br>`;\noutput += `x != 8: ${x != 8}<br>`;\noutput += `x !== 5: ${x !== 5}<br>`;\noutput += `x > 8: ${x > 8}<br>`;\noutput += `x < 8: ${x < 8}<br>`;\n\ndocument.getElementById('comparison').innerHTML = output;"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-comparison" />
                                                    <jsp:param name="initialHtml" value="<%=comparisonHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=comparisonJs%>" />
                                                </jsp:include>

                                                <div class="callout callout-warning">
                                                    <svg class="callout-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path
                                                            d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                                                        <line x1="12" y1="9" x2="12" y2="13" />
                                                        <line x1="12" y1="17" x2="12.01" y2="17" />
                                                    </svg>
                                                    <div class="callout-content">
                                                        <strong>Always use <code>===</code> (strict equality)</strong>
                                                        instead of <code>==</code>. The <code>==</code> operator
                                                        performs type coercion, which can lead to unexpected results
                                                        (e.g., <code>0 == '0'</code> is true).
                                                    </div>
                                                </div>

                                                <h2>Logical Operators</h2>
                                                <p>
                                                    Logical operators are used to determine the logic between variables
                                                    or values.
                                                </p>

                                                <% String logicalHtml="<h2>Logical Demo</h2>\n<p id='logical'></p>" ;
                                                    String
                                                    logicalJs="let x = 6;\nlet y = 3;\n\nlet output = '';\noutput += `(x < 10 && y > 1): ${x < 10 && y > 1} (AND)<br>`;\noutput += `(x == 5 || y == 5): ${x == 5 || y == 5} (OR)<br>`;\noutput += `!(x == y): ${!(x == y)} (NOT)<br>`;\n\ndocument.getElementById('logical').innerHTML = output;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-logical" />
                                                        <jsp:param name="initialHtml" value="<%=logicalHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=logicalJs%>" />
                                                    </jsp:include>

                                                    <h2>Summary</h2>
                                                    <div class="card" style="margin: var(--space-6) 0;">
                                                        <ul style="margin: 0; padding-left: var(--space-6);">
                                                            <li>Arithmetic operators perform math (<code>+</code>,
                                                                <code>-</code>, <code>*</code>, <code>/</code>).</li>
                                                            <li>Assignment operators assign values (<code>=</code>,
                                                                <code>+=</code>).</li>
                                                            <li>Comparison operators compare values (<code>===</code>,
                                                                <code>></code>, <code><</code>).</li>
                                                            <li>Logical operators combine booleans (<code>&&</code>,
                                                                <code>||</code>, <code>!</code>).</li>
                                                        </ul>
                                                    </div>

                                                    <jsp:include page="../tutorial-quiz.jsp">
                                                        <jsp:param name="quizId" value="quiz-operators" />
                                                        <jsp:param name="question"
                                                            value="What is the result of 5 === '5'?" />
                                                        <jsp:param name="option1" value="true" />
                                                        <jsp:param name="option2" value="false" />
                                                        <jsp:param name="option3" value="undefined" />
                                                        <jsp:param name="option4" value="NaN" />
                                                        <jsp:param name="correctAnswer" value="2" />
                                                    </jsp:include>

                                                    <jsp:include page="../tutorial-nav.jsp">
                                                        <jsp:param name="prevLink" value="data-types.jsp" />
                                                        <jsp:param name="prevTitle" value="Data Types" />
                                                        <jsp:param name="nextLink" value="strings.jsp" />
                                                        <jsp:param name="nextTitle" value="Strings" />
                                                        <jsp:param name="currentLessonId" value="operators" />
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