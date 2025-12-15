<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "types-overview" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Data Types - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP data types: scalar (int, float, string, bool), compound (array, object), and special types. Learn type checking and conversion.">
            <meta name="keywords"
                content="php data types, php int, php float, php string, php boolean, php array, php object, php types">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/types-overview.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Data Types","description":"Learn all PHP data types including scalar, compound, and special types","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP data types","Scalar types","Compound types","Type checking","var_dump"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="types-overview">
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
                                    <span>Data Types</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Data Types</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">PHP supports 10 different data types, each designed for specific
                                        kinds of information. Understanding data types is crucial for writing efficient
                                        and bug-free code. Let's explore each type and learn when to use them!</p>

                                    <h2>PHP Data Types Overview</h2>
                                    <p>PHP organizes its data types into three categories:</p>

                                    <div class="diagram-container" style="margin: 2rem 0; text-align: center;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-data-types.svg"
                                            alt="PHP Data Types Hierarchy"
                                            style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Category</th>
                                                <th>Types</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Scalar</strong></td>
                                                <td>int, float, string, bool</td>
                                                <td>Single values</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Compound</strong></td>
                                                <td>array, object, callable, iterable</td>
                                                <td>Multiple values</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Special</strong></td>
                                                <td>resource, NULL</td>
                                                <td>Unique purposes</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/types-overview.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-overview" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>var_dump():</strong> This function displays detailed information about a
                                        variable including its type and value. It's invaluable for debugging!
                                    </div>

                                    <h2>Scalar Types (Single Values)</h2>

                                    <h3>1. Integer (int)</h3>
                                    <p>Whole numbers without decimal points, positive or negative:</p>
                                    <pre><code class="language-php">&lt;?php
$age = 25;           // Positive integer
$temperature = -10;  // Negative integer
$hex = 0xFF;         // Hexadecimal (255)
$octal = 0755;       // Octal (493)
$binary = 0b1010;    // Binary (10)
?&gt;</code></pre>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Platform</th>
                                                <th>Range</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>32-bit</td>
                                                <td>-2,147,483,648 to 2,147,483,647</td>
                                            </tr>
                                            <tr>
                                                <td>64-bit</td>
                                                <td>-9,223,372,036,854,775,808 to 9,223,372,036,854,775,807</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>2. Float (double)</h3>
                                    <p>Numbers with decimal points or in exponential form:</p>
                                    <pre><code class="language-php">&lt;?php
$price = 19.99;
$pi = 3.14159;
$scientific = 1.5e3;  // 1500
$negative = -2.5;
?&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Precision Warning:</strong> Floating-point numbers have limited
                                        precision. Never compare floats directly with <code>==</code>. Use a small
                                        tolerance instead!
                                    </div>

                                    <h3>3. String</h3>
                                    <p>Sequence of characters enclosed in quotes:</p>
                                    <pre><code class="language-php">&lt;?php
$single = 'Single quotes';
$double = "Double quotes";
$name = "John";
$greeting = "Hello, $name!";  // Variable parsing
?&gt;</code></pre>

                                    <h3>4. Boolean (bool)</h3>
                                    <p>Represents true or false:</p>
                                    <pre><code class="language-php">&lt;?php
$isActive = true;
$isDeleted = false;

// These values are considered false:
// false, 0, 0.0, "", "0", [], null

// Everything else is true
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Compound Types (Multiple Values)</h2>

                                    <h3>5. Array</h3>
                                    <p>Ordered collection of values:</p>
                                    <pre><code class="language-php">&lt;?php
// Indexed array
$colors = ["red", "green", "blue"];

// Associative array
$person = [
    "name" => "John",
    "age" => 30,
    "city" => "New York"
];

// Mixed array
$mixed = [1, "text", true, [1, 2, 3]];
?&gt;</code></pre>

                                    <h3>6. Object</h3>
                                    <p>Instances of classes:</p>
                                    <pre><code class="language-php">&lt;?php
class Person {
    public $name;
    public $age;
}

$user = new Person();
$user->name = "John";
$user->age = 30;
?&gt;</code></pre>

                                    <h3>7. Callable</h3>
                                    <p>Functions that can be called:</p>
                                    <pre><code class="language-php">&lt;?php
function greet($name) {
    return "Hello, $name!";
}

$callback = 'greet';
echo $callback("John");  // Calls greet("John")
?&gt;</code></pre>

                                    <h3>8. Iterable</h3>
                                    <p>Arrays or objects that can be iterated (PHP 7.1+):</p>
                                    <pre><code class="language-php">&lt;?php
function process(iterable $items) {
    foreach ($items as $item) {
        echo $item;
    }
}

process([1, 2, 3]);  // Works with arrays
?&gt;</code></pre>

                                    <h2>Special Types</h2>

                                    <h3>9. Resource</h3>
                                    <p>References to external resources (files, databases):</p>
                                    <pre><code class="language-php">&lt;?php
$file = fopen("data.txt", "r");  // File resource
// $db = mysqli_connect(...);    // Database resource
fclose($file);
?&gt;</code></pre>

                                    <h3>10. NULL</h3>
                                    <p>Represents a variable with no value:</p>
                                    <pre><code class="language-php">&lt;?php
$empty = null;
$undefined;  // Also NULL

// These create NULL:
$var = null;
unset($var);
$notSet;
?&gt;</code></pre>

                                    <h2>Type Checking Functions</h2>
                                    <p>PHP provides functions to check variable types:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Function</th>
                                                <th>Checks For</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>is_int()</code></td>
                                                <td>Integer</td>
                                                <td><code>is_int(42)</code> → true</td>
                                            </tr>
                                            <tr>
                                                <td><code>is_float()</code></td>
                                                <td>Float</td>
                                                <td><code>is_float(3.14)</code> → true</td>
                                            </tr>
                                            <tr>
                                                <td><code>is_string()</code></td>
                                                <td>String</td>
                                                <td><code>is_string("hi")</code> → true</td>
                                            </tr>
                                            <tr>
                                                <td><code>is_bool()</code></td>
                                                <td>Boolean</td>
                                                <td><code>is_bool(true)</code> → true</td>
                                            </tr>
                                            <tr>
                                                <td><code>is_array()</code></td>
                                                <td>Array</td>
                                                <td><code>is_array([1,2])</code> → true</td>
                                            </tr>
                                            <tr>
                                                <td><code>is_object()</code></td>
                                                <td>Object</td>
                                                <td><code>is_object($obj)</code> → true</td>
                                            </tr>
                                            <tr>
                                                <td><code>is_null()</code></td>
                                                <td>NULL</td>
                                                <td><code>is_null(null)</code> → true</td>
                                            </tr>
                                            <tr>
                                                <td><code>is_resource()</code></td>
                                                <td>Resource</td>
                                                <td><code>is_resource($file)</code> → true</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-php">&lt;?php
$age = 25;

if (is_int($age)) {
    echo "Age is an integer";
}

// Get type as string
echo gettype($age);  // Output: "integer"
?&gt;</code></pre>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Comparing floats with ==</h4>
                                        <pre><code class="language-php">&lt;?php
$a = 0.1 + 0.2;
$b = 0.3;

if ($a == $b) {  // ❌ May fail due to precision
    echo "Equal";
}

// ✅ Correct way
if (abs($a - $b) < 0.0001) {
    echo "Equal (within tolerance)";
}
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Confusing "0" and 0</h4>
                                        <pre><code class="language-php">&lt;?php
$str = "0";
$num = 0;

if ($str == $num) {  // ✅ true (type juggling)
    echo "Equal with ==";
}

if ($str === $num) {  // ❌ false (different types)
    echo "This won't print";
}
?&gt;</code></pre>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>10 Types:</strong> int, float, string, bool, array, object,
                                                callable, iterable, resource, NULL</li>
                                            <li><strong>Scalar:</strong> Single values (int, float, string, bool)</li>
                                            <li><strong>Compound:</strong> Multiple values (array, object, callable,
                                                iterable)</li>
                                            <li><strong>Special:</strong> Unique purposes (resource, NULL)</li>
                                            <li><strong>var_dump():</strong> Shows type and value</li>
                                            <li><strong>gettype():</strong> Returns type as string</li>
                                            <li><strong>is_*():</strong> Functions to check specific types</li>
                                            <li><strong>Flexible:</strong> Variables can change types</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you know PHP's data types, let's explore <strong>Type Juggling</strong>
                                        - PHP's automatic type conversion system. You'll learn how PHP converts between
                                        types and when to use explicit type casting!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="variables-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Variables" />
                                    <jsp:param name="nextLink" value="types-juggling.jsp" />
                                    <jsp:param name="nextTitle" value="Type Juggling" />
                                    <jsp:param name="currentLessonId" value="types-overview" />
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