<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-array" ); request.setAttribute("currentModule", "Operators" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Array Operators - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP array operators: union (+), equality (==), identity (===), and comparison. Learn how to combine and compare arrays effectively.">
            <meta name="keywords"
                content="php array operators, php array union, php array comparison, php array equality">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/operators-array.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Array Operators","description":"Learn PHP array operators for combining and comparing arrays","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["Array operators","Array union","Array comparison","Array equality"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="operators-array">
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
                                    <span>Array Operators</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Array Operators</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">PHP provides special operators for working with arrays. These
                                        operators let you combine arrays and compare them in different ways.
                                        Understanding the difference between union and merge is crucial!</p>

                                    <h2>Array Operators Overview</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>+</code></td>
                                                <td>Union</td>
                                                <td>Combines arrays (keeps first values for duplicate keys)</td>
                                            </tr>
                                            <tr>
                                                <td><code>==</code></td>
                                                <td>Equality</td>
                                                <td>True if same key-value pairs (any order)</td>
                                            </tr>
                                            <tr>
                                                <td><code>===</code></td>
                                                <td>Identity</td>
                                                <td>True if same key-value pairs, same order, same types</td>
                                            </tr>
                                            <tr>
                                                <td><code>!=</code></td>
                                                <td>Inequality</td>
                                                <td>True if not equal</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;&gt;</code></td>
                                                <td>Inequality</td>
                                                <td>True if not equal (alternative)</td>
                                            </tr>
                                            <tr>
                                                <td><code>!==</code></td>
                                                <td>Non-identity</td>
                                                <td>True if not identical</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/operators-array.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-array" />
                                    </jsp:include>

                                    <h2>Array Union (+)</h2>
                                    <p>Combines arrays, keeping the FIRST value for duplicate keys:</p>
                                    <pre><code class="language-php">&lt;?php
$arr1 = ["a" => "apple", "b" => "banana"];
$arr2 = ["b" => "blueberry", "c" => "cherry"];

$result = $arr1 + $arr2;
print_r($result);
// ["a" => "apple", "b" => "banana", "c" => "cherry"]
// Note: "banana" kept, not "blueberry"
?&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Union vs array_merge():</strong>
                                        <ul>
                                            <li><strong>Union (+):</strong> Keeps first value for duplicate keys</li>
                                            <li><strong>array_merge():</strong> Overwrites with last value</li>
                                        </ul>
                                    </div>

                                    <h2>Array Equality (==)</h2>
                                    <p>Checks if arrays have same key-value pairs (order doesn't matter):</p>
                                    <pre><code class="language-php">&lt;?php
$a = ["x" => 1, "y" => 2];
$b = ["y" => 2, "x" => 1];  // Different order

var_dump($a == $b);  // true (same pairs, order ignored)
?&gt;</code></pre>

                                    <h2>Array Identity (===)</h2>
                                    <p>Checks if arrays have same key-value pairs in same order with same types:</p>
                                    <pre><code class="language-php">&lt;?php
$a = ["x" => 1, "y" => 2];
$b = ["y" => 2, "x" => 1];  // Different order

var_dump($a === $b);  // false (different order)

$c = ["x" => 1, "y" => 2];
var_dump($a === $c);  // true (same order, same types)
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>+:</strong> Union (keeps first values for duplicate keys)</li>
                                            <li><strong>==:</strong> Equality (same pairs, any order)</li>
                                            <li><strong>===:</strong> Identity (same pairs, same order, same types)</li>
                                            <li><strong>!=, &lt;&gt;:</strong> Not equal</li>
                                            <li><strong>!==:</strong> Not identical</li>
                                            <li><strong>Union ≠ Merge:</strong> Different behavior for duplicates</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 3 and mastered all PHP operators. In the
                                        next module, we'll dive into <strong>Control Flow</strong> - using if
                                        statements, loops, and switch statements to control program execution!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="operators-ternary.jsp" />
                                    <jsp:param name="prevTitle" value="Ternary & Null Coalescing" />
                                    <jsp:param name="nextLink" value="control-if.jsp" />
                                    <jsp:param name="nextTitle" value="If Statements" />
                                    <jsp:param name="currentLessonId" value="operators-array" />
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