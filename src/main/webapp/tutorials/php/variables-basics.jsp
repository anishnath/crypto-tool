<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "variables-basics" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Variables - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn PHP variables: declaration, naming rules, scope, and best practices. Master the fundamentals of storing and using data in PHP.">
            <meta name="keywords"
                content="php variables, php variable declaration, php naming rules, php variable scope, php tutorial">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/variables-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Variables","description":"Learn how to declare and use variables in PHP","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP variables","Variable declaration","Naming rules","Variable scope"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="variables-basics">
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
                                    <span>Variables</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Variables</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Variables are containers for storing data values. In PHP, variables
                                        are incredibly flexible and easy to use - you don't need to declare their type,
                                        and they can hold any kind of data. Let's learn how to create and use variables
                                        effectively!</p>

                                    <h2>What Are Variables?</h2>
                                    <p>A <strong>variable</strong> is like a labeled box where you can store
                                        information. You can put data in, take it out, change it, or use it in
                                        calculations. In PHP, all variable names start with a dollar sign
                                        (<code>$</code>).</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/variables-basics.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Point:</strong> PHP is a <em>loosely typed</em> language. You don't
                                        need to tell PHP what type of data a variable holds - it figures it out
                                        automatically! The same variable can even hold different types at different
                                        times.
                                    </div>

                                    <h2>Variable Declaration</h2>
                                    <p>Creating a variable in PHP is simple - just use the <code>$</code> symbol
                                        followed by the variable name and assign a value:</p>

                                    <pre><code class="language-php">&lt;?php
// Syntax: $variableName = value;
$message = "Hello, PHP!";
$count = 42;
$price = 19.99;
$isActive = true;
?&gt;</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Unlike some languages (like Java or C++), you don't
                                        need to declare the variable type. PHP automatically determines whether
                                        <code>$count</code> is an integer, <code>$price</code> is a float, etc.
                                    </div>

                                    <h2>Variable Naming Rules</h2>
                                    <p>PHP has specific rules for naming variables. Follow these to avoid errors:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Rule</th>
                                                <th>Example</th>
                                                <th>Valid?</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Must start with $</td>
                                                <td><code>$name</code></td>
                                                <td>✅ Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Can contain letters, numbers, underscore</td>
                                                <td><code>$user_123</code></td>
                                                <td>✅ Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Must start with letter or underscore (after $)</td>
                                                <td><code>$_temp</code></td>
                                                <td>✅ Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Cannot start with a number</td>
                                                <td><code>$2name</code></td>
                                                <td>❌ No</td>
                                            </tr>
                                            <tr>
                                                <td>Case-sensitive</td>
                                                <td><code>$Name</code> ≠ <code>$name</code></td>
                                                <td>✅ Different variables</td>
                                            </tr>
                                            <tr>
                                                <td>No spaces allowed</td>
                                                <td><code>$first name</code></td>
                                                <td>❌ No</td>
                                            </tr>
                                            <tr>
                                                <td>No hyphens allowed</td>
                                                <td><code>$first-name</code></td>
                                                <td>❌ No</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/variables-naming.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-naming" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Naming Conventions</h2>
                                    <p>While PHP is flexible, following naming conventions makes your code more readable
                                        and professional:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Convention</th>
                                                <th>Example</th>
                                                <th>When to Use</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>camelCase</strong></td>
                                                <td><code>$firstName</code>, <code>$totalPrice</code></td>
                                                <td>Most common for variables</td>
                                            </tr>
                                            <tr>
                                                <td><strong>snake_case</strong></td>
                                                <td><code>$first_name</code>, <code>$total_price</code></td>
                                                <td>Alternative style, WordPress uses this</td>
                                            </tr>
                                            <tr>
                                                <td><strong>PascalCase</strong></td>
                                                <td><code>$FirstName</code></td>
                                                <td>Rarely used for variables</td>
                                            </tr>
                                            <tr>
                                                <td><strong>UPPER_CASE</strong></td>
                                                <td><code>$MAX_SIZE</code></td>
                                                <td>Constants only</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Choose one convention and stick with it throughout
                                        your project. Mixing styles makes code harder to read!
                                    </div>

                                    <h2>Variable Assignment</h2>
                                    <p>You can assign and reassign variables as many times as you want:</p>

                                    <pre><code class="language-php">&lt;?php
// Initial assignment
$count = 10;
echo $count;  // Output: 10

// Reassignment
$count = 20;
echo $count;  // Output: 20

// Change type (PHP allows this!)
$count = "twenty";
echo $count;  // Output: twenty
?&gt;</code></pre>

                                    <h2>Variable Variables</h2>
                                    <p>PHP has a unique feature called "variable variables" - using the value of one
                                        variable as the name of another:</p>

                                    <pre><code class="language-php">&lt;?php
$varName = "message";
$$varName = "Hello!";  // Creates $message = "Hello!"

echo $message;  // Output: Hello!
?&gt;</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Variable variables are powerful but can make code
                                        confusing. Use them sparingly and only when they make your code clearer!
                                    </div>

                                    <h2>Checking if Variable Exists</h2>
                                    <p>Use <code>isset()</code> to check if a variable has been set:</p>

                                    <pre><code class="language-php">&lt;?php
$name = "John";

if (isset($name)) {
    echo "Variable exists!";
}

if (isset($age)) {
    echo "This won't print";
}
?&gt;</code></pre>

                                    <h2>Unsetting Variables</h2>
                                    <p>Remove a variable from memory using <code>unset()</code>:</p>

                                    <pre><code class="language-php">&lt;?php
$temp = "temporary data";
echo $temp;  // Output: temporary data

unset($temp);
// $temp no longer exists
?&gt;</code></pre>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting the dollar sign</h4>
                                        <pre><code class="language-php">&lt;?php
name = "John";  // ❌ Error: undefined constant
$name = "John";  // ✅ Correct
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using reserved words</h4>
                                        <pre><code class="language-php">&lt;?php
$class = "MyClass";  // ❌ 'class' is reserved
$className = "MyClass";  // ✅ Better choice
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Case sensitivity confusion</h4>
                                        <pre><code class="language-php">&lt;?php
$userName = "John";
echo $username;  // ❌ Undefined variable (different case!)
echo $userName;  // ✅ Correct
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Using undefined variables</h4>
                                        <pre><code class="language-php">&lt;?php
echo $undefinedVar;  // ❌ Warning: undefined variable

// Better approach
if (isset($undefinedVar)) {
    echo $undefinedVar;
} else {
    echo "Variable not set";
}
?&gt;</code></pre>
                                    </div>

                                    <h2>Exercise: Variable Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a simple profile using variables!</p>
                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create variables for: name, age, city, occupation</li>
                                            <li>Display them in a formatted message</li>
                                            <li>Calculate birth year from age (current year - age)</li>
                                            <li>Use proper naming conventions</li>
                                        </ul>
                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-php">&lt;?php
// Profile variables
$fullName = "Jane Smith";
$age = 28;
$city = "San Francisco";
$occupation = "Software Developer";

// Calculate birth year
$currentYear = 2024;
$birthYear = $currentYear - $age;

// Display profile
echo "Profile Information:\n";
echo "Name: " . $fullName . "\n";
echo "Age: " . $age . "\n";
echo "City: " . $city . "\n";
echo "Occupation: " . $occupation . "\n";
echo "Born in: " . $birthYear;
?&gt;</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Variables:</strong> Containers for storing data, start with
                                                <code>$</code></li>
                                            <li><strong>Declaration:</strong> <code>$name = value;</code> - no type
                                                needed</li>
                                            <li><strong>Naming:</strong> Letters, numbers, underscore; must start with
                                                letter or underscore</li>
                                            <li><strong>Case-sensitive:</strong> <code>$name</code> and
                                                <code>$Name</code> are different</li>
                                            <li><strong>Conventions:</strong> Use camelCase or snake_case consistently
                                            </li>
                                            <li><strong>Flexible:</strong> Can change type and value anytime</li>
                                            <li><strong>isset():</strong> Check if variable exists</li>
                                            <li><strong>unset():</strong> Remove variable from memory</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand variables, it's time to explore <strong>Data
                                            Types</strong>! In the next lesson, you'll learn about the different types
                                        of data PHP can store - integers, floats, strings, booleans, arrays, and more.
                                    </p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="syntax-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Syntax Basics" />
                                    <jsp:param name="nextLink" value="types-overview.jsp" />
                                    <jsp:param name="nextTitle" value="Data Types" />
                                    <jsp:param name="currentLessonId" value="variables-basics" />
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