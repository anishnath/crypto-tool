<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-logical" ); request.setAttribute("currentModule", "Operators" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Logical Operators - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP logical operators: AND (&&), OR (||), NOT (!), and XOR. Learn short-circuit evaluation and operator precedence.">
            <meta name="keywords"
                content="php logical operators, php AND, php OR, php NOT, php XOR, short-circuit evaluation">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/operators-logical.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Logical Operators","description":"Learn PHP logical operators for combining conditions","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["Logical operators","AND OR NOT","Short-circuit evaluation","Operator precedence"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="operators-logical">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-php.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/php/">PHP</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Logical Operators</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Logical Operators</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Logical operators combine multiple boolean expressions. They're
                                        essential for creating complex conditions in if statements, loops, and other
                                        control structures!</p>

                                    <h2>Logical Operators Overview</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>&&</code></td>
                                                <td>AND</td>
                                                <td>True if both are true</td>
                                                <td><code>true && false</code> → false</td>
                                            </tr>
                                            <tr>
                                                <td><code>||</code></td>
                                                <td>OR</td>
                                                <td>True if at least one is true</td>
                                                <td><code>true || false</code> → true</td>
                                            </tr>
                                            <tr>
                                                <td><code>!</code></td>
                                                <td>NOT</td>
                                                <td>Inverts boolean value</td>
                                                <td><code>!true</code> → false</td>
                                            </tr>
                                            <tr>
                                                <td><code>and</code></td>
                                                <td>AND</td>
                                                <td>Same as && (lower precedence)</td>
                                                <td><code>true and false</code> → false</td>
                                            </tr>
                                            <tr>
                                                <td><code>or</code></td>
                                                <td>OR</td>
                                                <td>Same as || (lower precedence)</td>
                                                <td><code>true or false</code> → true</td>
                                            </tr>
                                            <tr>
                                                <td><code>xor</code></td>
                                                <td>XOR</td>
                                                <td>True if exactly one is true</td>
                                                <td><code>true xor false</code> → true</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/operators-logical.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-logical" />
                                    </jsp:include>

                                    <h2>AND Operator (&&)</h2>
                                    <p>Returns true only if BOTH conditions are true:</p>
                                    <pre><code class="language-php">&lt;?php
$age = 25;
$hasLicense = true;

if ($age >= 18 && $hasLicense) {
    echo "Can drive!";
}

// Truth table for AND
var_dump(true && true);    // true
var_dump(true && false);   // false
var_dump(false && true);   // false
var_dump(false && false);  // false
?&gt;</code></pre>

                                    <h2>OR Operator (||)</h2>
                                    <p>Returns true if AT LEAST ONE condition is true:</p>
                                    <pre><code class="language-php">&lt;?php
$isWeekend = true;
$isHoliday = false;

if ($isWeekend || $isHoliday) {
    echo "Day off!";
}

// Truth table for OR
var_dump(true || true);    // true
var_dump(true || false);   // true
var_dump(false || true);   // true
var_dump(false || false);  // false
?&gt;</code></pre>

                                    <h2>NOT Operator (!)</h2>
                                    <p>Inverts a boolean value:</p>
                                    <pre><code class="language-php">&lt;?php
$isLoggedIn = false;

if (!$isLoggedIn) {
    echo "Please log in";
}

var_dump(!true);   // false
var_dump(!false);  // true
?&gt;</code></pre>

                                    <h2>Short-Circuit Evaluation</h2>
                                    <div class="info-box">
                                        <strong>Important:</strong> PHP stops evaluating as soon as the result is known!
                                        <ul>
                                            <li><strong>AND (&&):</strong> Stops if first is false</li>
                                            <li><strong>OR (||):</strong> Stops if first is true</li>
                                        </ul>
                                    </div>

                                    <pre><code class="language-php">&lt;?php
// Second condition never evaluated
false && expensiveFunction();  // expensiveFunction() not called

// Second condition never evaluated
true || expensiveFunction();   // expensiveFunction() not called
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>&&:</strong> AND - both must be true</li>
                                            <li><strong>||:</strong> OR - at least one must be true</li>
                                            <li><strong>!:</strong> NOT - inverts boolean</li>
                                            <li><strong>xor:</strong> XOR - exactly one must be true</li>
                                            <li><strong>Short-circuit:</strong> Stops when result is known</li>
                                            <li><strong>Precedence:</strong> ! > && > ||</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, we'll learn about <strong>Increment and Decrement Operators</strong> -
                                        shortcuts for adding or subtracting 1 from variables!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="operators-comparison.jsp" />
                                    <jsp:param name="prevTitle" value="Comparison Operators" />
                                    <jsp:param name="nextLink" value="operators-increment.jsp" />
                                    <jsp:param name="nextTitle" value="Increment/Decrement" />
                                    <jsp:param name="currentLessonId" value="operators-logical" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>