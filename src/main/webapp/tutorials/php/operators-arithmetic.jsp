<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-arithmetic" ); request.setAttribute("currentModule", "Operators"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Arithmetic Operators - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP arithmetic operators: addition, subtraction, multiplication, division, modulus, and exponentiation. Learn operator precedence and common pitfalls.">
            <meta name="keywords"
                content="php arithmetic operators, php math, php addition, php division, php modulus, php exponentiation">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/operators-arithmetic.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Arithmetic Operators","description":"Learn PHP arithmetic operators for mathematical operations","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["Arithmetic operators","Math operations","Operator precedence","Modulus","Exponentiation"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="operators-arithmetic">
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
                                    <span>Arithmetic Operators</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Arithmetic Operators</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Arithmetic operators perform mathematical operations on numbers. PHP
                                        supports all standard math operations plus some powerful extras like
                                        exponentiation. Let's master them all!</p>

                                    <h2>Arithmetic Operators Overview</h2>
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
                                                <td><code>+</code></td>
                                                <td>Addition</td>
                                                <td><code>10 + 5</code></td>
                                                <td>15</td>
                                            </tr>
                                            <tr>
                                                <td><code>-</code></td>
                                                <td>Subtraction</td>
                                                <td><code>10 - 5</code></td>
                                                <td>5</td>
                                            </tr>
                                            <tr>
                                                <td><code>*</code></td>
                                                <td>Multiplication</td>
                                                <td><code>10 * 5</code></td>
                                                <td>50</td>
                                            </tr>
                                            <tr>
                                                <td><code>/</code></td>
                                                <td>Division</td>
                                                <td><code>10 / 5</code></td>
                                                <td>2</td>
                                            </tr>
                                            <tr>
                                                <td><code>%</code></td>
                                                <td>Modulus</td>
                                                <td><code>10 % 3</code></td>
                                                <td>1</td>
                                            </tr>
                                            <tr>
                                                <td><code>**</code></td>
                                                <td>Exponentiation</td>
                                                <td><code>2 ** 3</code></td>
                                                <td>8</td>
                                            </tr>
                                            <tr>
                                                <td><code>-</code></td>
                                                <td>Negation</td>
                                                <td><code>-10</code></td>
                                                <td>-10</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/operators-arithmetic.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-arithmetic" />
                                    </jsp:include>

                                    <h2>Addition (+)</h2>
                                    <p>Adds two numbers together:</p>
                                    <pre><code class="language-php">&lt;?php
$a = 10;
$b = 5;
$sum = $a + $b;
echo $sum;  // Output: 15

// Works with floats
$price1 = 19.99;
$price2 = 5.50;
$total = $price1 + $price2;
echo $total;  // Output: 25.49
?&gt;</code></pre>

                                    <h2>Subtraction (-)</h2>
                                    <p>Subtracts the second number from the first:</p>
                                    <pre><code class="language-php">&lt;?php
$a = 10;
$b = 5;
$difference = $a - $b;
echo $difference;  // Output: 5

// Can result in negative numbers
$result = 5 - 10;
echo $result;  // Output: -5
?&gt;</code></pre>

                                    <h2>Multiplication (*)</h2>
                                    <p>Multiplies two numbers:</p>
                                    <pre><code class="language-php">&lt;?php
$quantity = 5;
$price = 10.50;
$total = $quantity * $price;
echo $total;  // Output: 52.5

// Multiplying by zero
$result = 100 * 0;
echo $result;  // Output: 0
?&gt;</code></pre>

                                    <h2>Division (/)</h2>
                                    <p>Divides the first number by the second:</p>
                                    <pre><code class="language-php">&lt;?php
$total = 100;
$people = 4;
$perPerson = $total / $people;
echo $perPerson;  // Output: 25

// Division can result in floats
$result = 10 / 3;
echo $result;  // Output: 3.3333333333333
?&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Division by Zero:</strong> Dividing by zero produces a warning and
                                        returns <code>INF</code> (infinity) or <code>NAN</code> (not a number). Always
                                        validate divisors!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Modulus (%)</h2>
                                    <p>Returns the remainder after division:</p>
                                    <pre><code class="language-php">&lt;?php
$number = 10;
$divisor = 3;
$remainder = $number % $divisor;
echo $remainder;  // Output: 1 (10 ÷ 3 = 3 remainder 1)

// Check if number is even or odd
$num = 7;
if ($num % 2 == 0) {
    echo "Even";
} else {
    echo "Odd";  // This executes
}
?&gt;</code></pre>

                                    <div class="tip-box">
                                        <strong>Common Use Cases:</strong>
                                        <ul>
                                            <li>Check if number is even/odd: <code>$n % 2 == 0</code></li>
                                            <li>Cycle through values: <code>$index % $arrayLength</code></li>
                                            <li>Check divisibility: <code>$n % 5 == 0</code></li>
                                        </ul>
                                    </div>

                                    <h2>Exponentiation (**)</h2>
                                    <p>Raises the first number to the power of the second (PHP 5.6+):</p>
                                    <pre><code class="language-php">&lt;?php
$base = 2;
$exponent = 3;
$result = $base ** $exponent;
echo $result;  // Output: 8 (2³ = 2 × 2 × 2)

// Calculate area of square
$side = 5;
$area = $side ** 2;
echo $area;  // Output: 25

// Fractional exponents (roots)
$number = 16;
$squareRoot = $number ** 0.5;
echo $squareRoot;  // Output: 4
?&gt;</code></pre>

                                    <h2>Negation (-)</h2>
                                    <p>Changes the sign of a number:</p>
                                    <pre><code class="language-php">&lt;?php
$positive = 10;
$negative = -$positive;
echo $negative;  // Output: -10

// Double negation returns original
$result = -(-10);
echo $result;  // Output: 10
?&gt;</code></pre>

                                    <h2>Operator Precedence</h2>
                                    <p>When multiple operators are used, PHP follows mathematical order of operations:
                                    </p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Priority</th>
                                                <th>Operators</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>1 (Highest)</td>
                                                <td><code>**</code></td>
                                                <td>Exponentiation</td>
                                            </tr>
                                            <tr>
                                                <td>2</td>
                                                <td><code>-</code></td>
                                                <td>Negation (unary)</td>
                                            </tr>
                                            <tr>
                                                <td>3</td>
                                                <td><code>*</code> <code>/</code> <code>%</code></td>
                                                <td>Multiplication, Division, Modulus</td>
                                            </tr>
                                            <tr>
                                                <td>4 (Lowest)</td>
                                                <td><code>+</code> <code>-</code></td>
                                                <td>Addition, Subtraction</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-php">&lt;?php
// Without parentheses
$result = 2 + 3 * 4;
echo $result;  // Output: 14 (not 20!)
// Calculation: 3 * 4 = 12, then 2 + 12 = 14

// With parentheses
$result = (2 + 3) * 4;
echo $result;  // Output: 20
// Calculation: 2 + 3 = 5, then 5 * 4 = 20

// Complex expression
$result = 2 ** 3 + 4 * 5;
echo $result;  // Output: 28
// Calculation: 2³ = 8, 4 * 5 = 20, 8 + 20 = 28
?&gt;</code></pre>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Use parentheses to make your intentions clear,
                                        even when not strictly necessary. It improves code readability!
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Division by zero</h4>
                                        <pre><code class="language-php">&lt;?php
$result = 10 / 0;  // ❌ Warning: Division by zero

// Always check first
$divisor = 0;
if ($divisor != 0) {
    $result = 10 / $divisor;
} else {
    echo "Cannot divide by zero";
}
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Integer division expectations</h4>
                                        <pre><code class="language-php">&lt;?php
$result = 7 / 2;
echo $result;  // 3.5 (not 3!)

// For integer division, use intdiv() (PHP 7+)
$result = intdiv(7, 2);
echo $result;  // 3
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Modulus with negative numbers</h4>
                                        <pre><code class="language-php">&lt;?php
echo 10 % 3;   // 1
echo -10 % 3;  // -1 (takes sign of dividend)
echo 10 % -3;  // 1
?&gt;</code></pre>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Addition (+):</strong> Add two numbers</li>
                                            <li><strong>Subtraction (-):</strong> Subtract second from first</li>
                                            <li><strong>Multiplication (*):</strong> Multiply two numbers</li>
                                            <li><strong>Division (/):</strong> Divide first by second</li>
                                            <li><strong>Modulus (%):</strong> Get remainder after division</li>
                                            <li><strong>Exponentiation (**):</strong> Raise to power (PHP 5.6+)</li>
                                            <li><strong>Negation (-):</strong> Change sign</li>
                                            <li><strong>Precedence:</strong> ** > * / % > + -</li>
                                            <li><strong>Parentheses:</strong> Override precedence</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you've mastered arithmetic operators, let's learn about
                                        <strong>Assignment Operators</strong> - shortcuts for updating variables with
                                        arithmetic operations!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="constants-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Constants" />
                                    <jsp:param name="nextLink" value="operators-assignment.jsp" />
                                    <jsp:param name="nextTitle" value="Assignment Operators" />
                                    <jsp:param name="currentLessonId" value="operators-arithmetic" />
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