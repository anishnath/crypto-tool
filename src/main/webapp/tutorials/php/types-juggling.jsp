<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "types-juggling" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Type Juggling - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP type juggling and type casting. Learn automatic type conversion, explicit casting, and strict typing in PHP 7+.">
            <meta name="keywords"
                content="php type juggling, php type casting, php type conversion, php strict types, php declare">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/types-juggling.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Type Juggling","description":"Learn PHP's automatic type conversion and explicit type casting","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["Type juggling","Type casting","Strict types","Type conversion"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="types-juggling">
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
                                    <span>Type Juggling</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Type Juggling & Casting</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">PHP is a loosely typed language, meaning it automatically converts
                                        types when needed. This feature, called "type juggling," makes PHP flexible but
                                        can also lead to unexpected behavior. Let's master both automatic and explicit
                                        type conversion!</p>

                                    <h2>What is Type Juggling?</h2>
                                    <p><strong>Type juggling</strong> is PHP's automatic conversion of values from one
                                        type to another based on context. PHP decides the appropriate type without you
                                        explicitly telling it.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/types-juggling.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-juggling" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Concept:</strong> Type juggling happens automatically during
                                        operations, comparisons, and function calls. PHP converts types to make the
                                        operation work.
                                    </div>

                                    <h2>Automatic Type Conversion Rules</h2>

                                    <h3>String to Number</h3>
                                    <pre><code class="language-php">&lt;?php
$str = "123";
$num = $str + 10;  // "123" becomes 123
echo $num;  // Output: 133

$mixed = "45 apples";
$result = $mixed + 5;  // "45 apples" becomes 45
echo $result;  // Output: 50

$invalid = "hello" + 5;  // "hello" becomes 0
echo $invalid;  // Output: 5
?&gt;</code></pre>

                                    <h3>Number to String</h3>
                                    <pre><code class="language-php">&lt;?php
$number = 42;
$text = "The answer is " . $number;  // 42 becomes "42"
echo $text;  // Output: The answer is 42
?&gt;</code></pre>

                                    <h3>Boolean Conversions</h3>
                                    <pre><code class="language-php">&lt;?php
// To boolean - these are FALSE:
$false1 = (bool)0;
$false2 = (bool)0.0;
$false3 = (bool)"";
$false4 = (bool)"0";
$false5 = (bool)[];
$false6 = (bool)null;

// Everything else is TRUE:
$true1 = (bool)1;
$true2 = (bool)-1;
$true3 = (bool)"hello";
$true4 = (bool)[1, 2, 3];
?&gt;</code></pre>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Value</th>
                                                <th>Boolean Equivalent</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>false</code></td>
                                                <td>false</td>
                                            </tr>
                                            <tr>
                                                <td><code>0</code></td>
                                                <td>false</td>
                                            </tr>
                                            <tr>
                                                <td><code>0.0</code></td>
                                                <td>false</td>
                                            </tr>
                                            <tr>
                                                <td><code>""</code> (empty string)</td>
                                                <td>false</td>
                                            </tr>
                                            <tr>
                                                <td><code>"0"</code></td>
                                                <td>false</td>
                                            </tr>
                                            <tr>
                                                <td><code>[]</code> (empty array)</td>
                                                <td>false</td>
                                            </tr>
                                            <tr>
                                                <td><code>null</code></td>
                                                <td>false</td>
                                            </tr>
                                            <tr>
                                                <td>Everything else</td>
                                                <td>true</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Explicit Type Casting</h2>
                                    <p>Sometimes you need to force a specific type conversion. Use type casting:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/types-casting.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-casting" />
                                    </jsp:include>

                                    <h3>Casting Syntax</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Cast</th>
                                                <th>Syntax</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Integer</td>
                                                <td><code>(int)</code> or <code>(integer)</code></td>
                                                <td><code>$i = (int)9.99;</code></td>
                                            </tr>
                                            <tr>
                                                <td>Float</td>
                                                <td><code>(float)</code> or <code>(double)</code></td>
                                                <td><code>$f = (float)42;</code></td>
                                            </tr>
                                            <tr>
                                                <td>String</td>
                                                <td><code>(string)</code></td>
                                                <td><code>$s = (string)123;</code></td>
                                            </tr>
                                            <tr>
                                                <td>Boolean</td>
                                                <td><code>(bool)</code> or <code>(boolean)</code></td>
                                                <td><code>$b = (bool)1;</code></td>
                                            </tr>
                                            <tr>
                                                <td>Array</td>
                                                <td><code>(array)</code></td>
                                                <td><code>$a = (array)"hi";</code></td>
                                            </tr>
                                            <tr>
                                                <td>Object</td>
                                                <td><code>(object)</code></td>
                                                <td><code>$o = (object)[];</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Comparison Operators and Type Juggling</h2>

                                    <h3>Loose Comparison (==)</h3>
                                    <p>Compares values after type juggling:</p>
                                    <pre><code class="language-php">&lt;?php
var_dump(0 == "0");      // true (string "0" becomes 0)
var_dump(0 == "");       // true (empty string becomes 0)
var_dump(0 == false);    // true (false becomes 0)
var_dump("10" == 10);    // true (string "10" becomes 10)
?&gt;</code></pre>

                                    <h3>Strict Comparison (===)</h3>
                                    <p>Compares both value AND type (no juggling):</p>
                                    <pre><code class="language-php">&lt;?php
var_dump(0 === "0");     // false (different types)
var_dump(0 === 0);       // true (same type and value)
var_dump("10" === 10);   // false (different types)
var_dump(true === 1);    // false (different types)
?&gt;</code></pre>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Always use strict comparison (<code>===</code>
                                        and <code>!==</code>) unless you specifically need type juggling. It prevents
                                        unexpected bugs!
                                    </div>

                                    <h2>Type Conversion Functions</h2>
                                    <p>Alternative to casting - use conversion functions:</p>

                                    <pre><code class="language-php">&lt;?php
// Integer conversion
$int = intval("123");      // 123
$int2 = intval("45.67");   // 45

// Float conversion
$float = floatval("3.14"); // 3.14

// String conversion
$str = strval(123);        // "123"

// Boolean conversion
$bool = boolval(1);        // true
?&gt;</code></pre>

                                    <h2>Strict Typing (PHP 7+)</h2>
                                    <p>PHP 7 introduced strict type declarations to prevent automatic type juggling:</p>

                                    <pre><code class="language-php">&lt;?php
declare(strict_types=1);  // Must be first line

function addNumbers(int $a, int $b): int {
    return $a + $b;
}

addNumbers(5, 10);      // ✅ Works
addNumbers(5.5, 10);    // ❌ TypeError!
addNumbers("5", 10);    // ❌ TypeError!
?&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> <code>declare(strict_types=1)</code> must be the
                                        very first statement in the file (after opening PHP tag). It only affects the
                                        file it's declared in.
                                    </div>

                                    <h2>Common Type Juggling Pitfalls</h2>

                                    <div class="mistake-box">
                                        <h4>1. Unexpected string to number conversion</h4>
                                        <pre><code class="language-php">&lt;?php
$input = "10 apples";
$result = $input + 5;  // ❌ Gives 15, not error!

// Better approach
if (is_numeric($input)) {
    $result = $input + 5;
} else {
    echo "Invalid number";
}
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Loose comparison surprises</h4>
                                        <pre><code class="language-php">&lt;?php
if ("0" == false) {  // ❌ true! Unexpected
    echo "This prints!";
}

// Use strict comparison
if ("0" === false) {  // ✅ false, as expected
    echo "This won't print";
}
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Array to string conversion</h4>
                                        <pre><code class="language-php">&lt;?php
$arr = [1, 2, 3];
echo $arr;  // ❌ Warning: Array to string conversion

// Correct ways
echo implode(", ", $arr);  // ✅ "1, 2, 3"
print_r($arr);             // ✅ Shows array structure
?&gt;</code></pre>
                                    </div>

                                    <h2>Type Juggling in Conditionals</h2>
                                    <pre><code class="language-php">&lt;?php
// These all evaluate to false
if (0) { /* won't execute */ }
if ("") { /* won't execute */ }
if (null) { /* won't execute */ }
if ([]) { /* won't execute */ }

// These all evaluate to true
if (1) { /* executes */ }
if ("0") { /* WAIT! This is false */ }
if ("hello") { /* executes */ }
if ([1]) { /* executes */ }
?&gt;</code></pre>

                                    <h2>Exercise: Type Conversion Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Fix the type-related bugs in this code!</p>
                                        <pre><code class="language-php">&lt;?php
// Buggy code
$userInput = "25";
$age = $userInput;

if ($age == "25") {
    echo "Age is 25";
}

$total = "100" + "50";
echo $total;
?&gt;</code></pre>
                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-php">&lt;?php
// Fixed code with proper type handling
$userInput = "25";
$age = (int)$userInput;  // Explicit casting

// Use strict comparison
if ($age === 25) {
    echo "Age is 25";
}

// Explicit conversion for clarity
$total = (int)"100" + (int)"50";
echo $total;  // 150

// Or validate input
if (is_numeric($userInput)) {
    $age = intval($userInput);
    echo "Valid age: " . $age;
}
?&gt;</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Type Juggling:</strong> Automatic type conversion by PHP</li>
                                            <li><strong>Happens:</strong> During operations, comparisons, function calls
                                            </li>
                                            <li><strong>Casting:</strong> <code>(int)</code>, <code>(float)</code>,
                                                <code>(string)</code>, <code>(bool)</code>, <code>(array)</code></li>
                                            <li><strong>Loose (==):</strong> Compares after type juggling</li>
                                            <li><strong>Strict (===):</strong> Compares type AND value</li>
                                            <li><strong>Falsy Values:</strong> <code>false</code>, <code>0</code>,
                                                <code>""</code>, <code>"0"</code>, <code>[]</code>, <code>null</code>
                                            </li>
                                            <li><strong>Strict Types:</strong> <code>declare(strict_types=1)</code>
                                                prevents juggling</li>
                                            <li><strong>Best Practice:</strong> Use strict comparison and explicit
                                                casting</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand type juggling, let's dive deep into
                                        <strong>Strings</strong> - one of the most commonly used data types in PHP.
                                        You'll learn about string syntax, interpolation, and manipulation!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="types-overview.jsp" />
                                    <jsp:param name="prevTitle" value="Data Types" />
                                    <jsp:param name="nextLink" value="strings-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Strings" />
                                    <jsp:param name="currentLessonId" value="types-juggling" />
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