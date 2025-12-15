<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-ternary" ); request.setAttribute("currentModule", "Operators" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Ternary & Null Coalescing Operators - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP ternary (?:) and null coalescing (??, ??=) operators. Learn shortcuts for conditional assignments and null handling.">
            <meta name="keywords"
                content="php ternary operator, php null coalescing, php ??, php ??=, php conditional operator">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/operators-ternary.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Ternary and Null Coalescing Operators","description":"Learn PHP ternary and null coalescing operators for concise conditionals","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["Ternary operator","Null coalescing","Conditional assignment","PHP 7 features"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="operators-ternary">
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
                                    <span>Ternary & Null Coalescing</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Ternary & Null Coalescing Operators</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">These operators provide elegant shortcuts for conditional
                                        assignments. The ternary operator replaces simple if-else statements, while null
                                        coalescing handles default values beautifully!</p>

                                    <h2>Operators Overview</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Syntax</th>
                                                <th>PHP Version</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>?:</code></td>
                                                <td>Ternary</td>
                                                <td><code>condition ? true_val : false_val</code></td>
                                                <td>All</td>
                                            </tr>
                                            <tr>
                                                <td><code>??</code></td>
                                                <td>Null coalescing</td>
                                                <td><code>$a ?? $b</code></td>
                                                <td>7.0+</td>
                                            </tr>
                                            <tr>
                                                <td><code>??=</code></td>
                                                <td>Null coalescing assignment</td>
                                                <td><code>$a ??= $b</code></td>
                                                <td>7.4+</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/operators-ternary.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-ternary" />
                                    </jsp:include>

                                    <h2>Ternary Operator (?:)</h2>
                                    <p>Shorthand for simple if-else statements:</p>
                                    <pre><code class="language-php">&lt;?php
// Long form
if ($age >= 18) {
    $status = "Adult";
} else {
    $status = "Minor";
}

// Ternary form
$status = ($age >= 18) ? "Adult" : "Minor";

// Another example
$discount = ($isMember) ? 10 : 0;
?&gt;</code></pre>

                                    <h2>Null Coalescing Operator (??) - PHP 7+</h2>
                                    <p>Returns first value if it exists and is not null, otherwise returns second:</p>
                                    <pre><code class="language-php">&lt;?php
// Old way
$username = isset($_GET['user']) ? $_GET['user'] : 'Guest';

// Null coalescing way
$username = $_GET['user'] ?? 'Guest';

// Chain multiple
$name = $firstName ?? $lastName ?? $defaultName ?? 'Anonymous';
?&gt;</code></pre>

                                    <div class="info-box">
                                        <strong>Key Difference:</strong>
                                        <ul>
                                            <li><strong>Ternary:</strong> Checks if condition is true</li>
                                            <li><strong>Null coalescing:</strong> Checks if variable exists and is not
                                                null</li>
                                        </ul>
                                    </div>

                                    <h2>Null Coalescing Assignment (??=) - PHP 7.4+</h2>
                                    <pre><code class="language-php">&lt;?php
// Assign only if null or doesn't exist
$count ??= 0;  // Same as: $count = $count ?? 0

// Useful for default values
$config['timeout'] ??= 30;
$config['retries'] ??= 3;
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Ternary:</strong> <code>condition ? true : false</code></li>
                                            <li><strong>Null coalescing:</strong> <code>$a ?? $b</code> (PHP 7+)</li>
                                            <li><strong>Null coalescing assignment:</strong> <code>$a ??= $b</code> (PHP
                                                7.4+)</li>
                                            <li><strong>Use ternary:</strong> For simple conditions</li>
                                            <li><strong>Use ??:</strong> For default values and null checks</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Finally, we'll explore <strong>Array Operators</strong> - special operators for
                                        combining and comparing arrays!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="operators-increment.jsp" />
                                    <jsp:param name="prevTitle" value="Increment/Decrement" />
                                    <jsp:param name="nextLink" value="operators-array.jsp" />
                                    <jsp:param name="nextTitle" value="Array Operators" />
                                    <jsp:param name="currentLessonId" value="operators-ternary" />
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