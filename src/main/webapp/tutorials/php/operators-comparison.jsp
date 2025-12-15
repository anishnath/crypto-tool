<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-comparison" ); request.setAttribute("currentModule", "Operators"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Comparison Operators - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP comparison operators: ==, ===, !=, !==, <, >, <=, >=, and the spaceship operator (<=>). Learn loose vs strict comparison.">
            <meta name="keywords"
                content="php comparison operators, php ==, php ===, php spaceship operator, loose vs strict comparison">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/operators-comparison.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Comparison Operators","description":"Learn PHP comparison operators for comparing values","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["Comparison operators","Loose comparison","Strict comparison","Spaceship operator"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="operators-comparison">
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
                                    <span>Comparison Operators</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Comparison Operators</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Comparison operators compare two values and return a boolean result
                                        (true or false). They're essential for making decisions in your code.
                                        Understanding the difference between loose and strict comparison is crucial!</p>

                                    <h2>Comparison Operators Overview</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Example</th>
                                                <th>Result</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>==</code></td>
                                                <td>Equal</td>
                                                <td><code>5 == "5"</code></td>
                                                <td>true (loose)</td>
                                            </tr>
                                            <tr>
                                                <td><code>===</code></td>
                                                <td>Identical</td>
                                                <td><code>5 === "5"</code></td>
                                                <td>false (strict)</td>
                                            </tr>
                                            <tr>
                                                <td><code>!=</code></td>
                                                <td>Not equal</td>
                                                <td><code>5 != 3</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;&gt;</code></td>
                                                <td>Not equal</td>
                                                <td><code>5 &lt;&gt; 3</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>!==</code></td>
                                                <td>Not identical</td>
                                                <td><code>5 !== "5"</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;</code></td>
                                                <td>Less than</td>
                                                <td><code>3 &lt; 5</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;</code></td>
                                                <td>Greater than</td>
                                                <td><code>5 &gt; 3</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;=</code></td>
                                                <td>Less than or equal</td>
                                                <td><code>5 &lt;= 5</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;=</code></td>
                                                <td>Greater than or equal</td>
                                                <td><code>5 &gt;= 3</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;=&gt;</code></td>
                                                <td>Spaceship</td>
                                                <td><code>5 &lt;=&gt; 3</code></td>
                                                <td>1</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/operators-comparison.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-comparison" />
                                    </jsp:include>

                                    <h2>Loose vs Strict Comparison</h2>
                                    <div class="info-box">
                                        <strong>Key Difference:</strong>
                                        <ul>
                                            <li><strong>Loose (==, !=):</strong> Compares values after type juggling
                                            </li>
                                            <li><strong>Strict (===, !==):</strong> Compares both value AND type</li>
                                        </ul>
                                    </div>

                                    <pre><code class="language-php">&lt;?php
$a = 5;
$b = "5";

// Loose comparison
var_dump($a == $b);   // true (values are equal after conversion)

// Strict comparison
var_dump($a === $b);  // false (different types: int vs string)
?&gt;</code></pre>

                                    <h2>Spaceship Operator (&lt;=&gt;) - PHP 7+</h2>
                                    <p>Returns -1, 0, or 1 based on comparison. Perfect for sorting!</p>
                                    <pre><code class="language-php">&lt;?php
echo 5 &lt;=&gt; 3;   // 1 (5 is greater)
echo 3 &lt;=&gt; 5;   // -1 (3 is less)
echo 5 &lt;=&gt; 5;   // 0 (equal)

// Useful for sorting
usort($array, function($a, $b) {
    return $a &lt;=&gt; $b;  // Ascending sort
});
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>Using == instead of ===</h4>
                                        <pre><code class="language-php">&lt;?php
if ($value == 0) {  // ❌ Dangerous!
    // Executes for: 0, "0", "", false, null, []
}

if ($value === 0) {  // ✅ Better
    // Only executes for integer 0
}
?&gt;</code></pre>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>==:</strong> Loose equality (type juggling)</li>
                                            <li><strong>===:</strong> Strict equality (type + value)</li>
                                            <li><strong>!=, &lt;&gt;:</strong> Not equal (loose)</li>
                                            <li><strong>!==:</strong> Not identical (strict)</li>
                                            <li><strong>&lt;=&gt;:</strong> Spaceship (-1, 0, 1)</li>
                                            <li><strong>Best Practice:</strong> Use === and !== by default</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, we'll explore <strong>Logical Operators</strong> - combining multiple
                                        conditions with AND, OR, and NOT!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="operators-assignment.jsp" />
                                    <jsp:param name="prevTitle" value="Assignment Operators" />
                                    <jsp:param name="nextLink" value="operators-logical.jsp" />
                                    <jsp:param name="nextTitle" value="Logical Operators" />
                                    <jsp:param name="currentLessonId" value="operators-comparison" />
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