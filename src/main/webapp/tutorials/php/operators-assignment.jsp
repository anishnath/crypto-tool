<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-assignment" ); request.setAttribute("currentModule", "Operators"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Assignment Operators - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP assignment operators including compound assignments (+=, -=, *=, /=, %=, .=). Learn shortcuts for updating variables efficiently.">
            <meta name="keywords" content="php assignment operators, php +=, php compound assignment, php .=">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/operators-assignment.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Assignment Operators","description":"Learn PHP assignment and compound assignment operators","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["Assignment operators","Compound assignment","Variable updates"],"timeRequired":"PT15M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="operators-assignment">
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
                                    <span>Assignment Operators</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Assignment Operators</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~15 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Assignment operators are used to assign values to variables. PHP
                                        provides shortcuts called compound assignment operators that combine arithmetic
                                        operations with assignment, making your code more concise!</p>

                                    <h2>Assignment Operators Overview</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Example</th>
                                                <th>Equivalent To</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>=</code></td>
                                                <td><code>$x = 5</code></td>
                                                <td>Simple assignment</td>
                                            </tr>
                                            <tr>
                                                <td><code>+=</code></td>
                                                <td><code>$x += 3</code></td>
                                                <td><code>$x = $x + 3</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>-=</code></td>
                                                <td><code>$x -= 3</code></td>
                                                <td><code>$x = $x - 3</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>*=</code></td>
                                                <td><code>$x *= 3</code></td>
                                                <td><code>$x = $x * 3</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>/=</code></td>
                                                <td><code>$x /= 3</code></td>
                                                <td><code>$x = $x / 3</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>%=</code></td>
                                                <td><code>$x %= 3</code></td>
                                                <td><code>$x = $x % 3</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>.=</code></td>
                                                <td><code>$x .= "y"</code></td>
                                                <td><code>$x = $x . "y"</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/operators-assignment.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-assignment" />
                                    </jsp:include>

                                    <h2>Simple Assignment (=)</h2>
                                    <pre><code class="language-php">&lt;?php
$name = "John";
$age = 25;
$price = 19.99;

// Assignment returns the assigned value
$x = $y = $z = 10;  // All three are 10
?&gt;</code></pre>

                                    <h2>Addition Assignment (+=)</h2>
                                    <pre><code class="language-php">&lt;?php
$count = 10;
$count += 5;  // Same as: $count = $count + 5
echo $count;  // 15

// Common use: incrementing counters
$total = 0;
$total += 100;
$total += 50;
echo $total;  // 150
?&gt;</code></pre>

                                    <h2>String Concatenation Assignment (.=)</h2>
                                    <pre><code class="language-php">&lt;?php
$message = "Hello";
$message .= " World";  // Same as: $message = $message . " World"
echo $message;  // "Hello World"

// Building strings
$html = "&lt;div&gt;";
$html .= "&lt;h1&gt;Title&lt;/h1&gt;";
$html .= "&lt;p&gt;Content&lt;/p&gt;";
$html .= "&lt;/div&gt;";
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>=:</strong> Assign value to variable</li>
                                            <li><strong>+=:</strong> Add and assign</li>
                                            <li><strong>-=:</strong> Subtract and assign</li>
                                            <li><strong>*=:</strong> Multiply and assign</li>
                                            <li><strong>/=:</strong> Divide and assign</li>
                                            <li><strong>%=:</strong> Modulus and assign</li>
                                            <li><strong>.=:</strong> Concatenate and assign</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, we'll explore <strong>Comparison Operators</strong> - essential for making
                                        decisions in your code by comparing values!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="operators-arithmetic.jsp" />
                                    <jsp:param name="prevTitle" value="Arithmetic Operators" />
                                    <jsp:param name="nextLink" value="operators-comparison.jsp" />
                                    <jsp:param name="nextTitle" value="Comparison Operators" />
                                    <jsp:param name="currentLessonId" value="operators-assignment" />
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