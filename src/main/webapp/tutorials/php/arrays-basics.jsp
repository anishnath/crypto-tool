<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "arrays-basics" ); request.setAttribute("currentModule", "Arrays" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Array Basics - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn PHP arrays from scratch. Master indexed arrays, associative arrays, array creation, access, and modification with practical examples.">
            <meta name="keywords"
                content="php arrays, php indexed array, php associative array, php array tutorial, php array basics">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/arrays-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Array Basics","description":"Learn PHP arrays including indexed arrays, associative arrays, and basic array operations","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP arrays","Indexed arrays","Associative arrays","Array creation","Array access"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="arrays-basics">
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
                                    <span>Array Basics</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Array Basics</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Arrays are one of the most powerful and frequently used data
                                        structures in PHP.
                                        They allow you to store multiple values in a single variable, making it easy to
                                        work with
                                        collections of related data like user lists, product catalogs, or configuration
                                        settings.</p>

                                    <h2>What is an Array?</h2>
                                    <p>An array is an ordered collection of values. Each value is called an
                                        <strong>element</strong>,
                                        and each element has a position called an <strong>index</strong> or
                                        <strong>key</strong>.</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Keys</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Indexed Array</td>
                                                <td>Numeric (0, 1, 2...)</td>
                                                <td><code>["Apple", "Banana", "Cherry"]</code></td>
                                            </tr>
                                            <tr>
                                                <td>Associative Array</td>
                                                <td>String keys</td>
                                                <td><code>["name" => "John", "age" => 30]</code></td>
                                            </tr>
                                            <tr>
                                                <td>Multidimensional</td>
                                                <td>Arrays inside arrays</td>
                                                <td><code>[["a", "b"], ["c", "d"]]</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Creating Indexed Arrays</h2>
                                    <p>Indexed arrays use numeric keys starting from 0:</p>

                                    <pre><code class="language-php">&lt;?php
// Modern short syntax (recommended)
$fruits = ["Apple", "Banana", "Cherry"];

// Traditional syntax
$colors = array("Red", "Green", "Blue");

// Empty array
$empty = [];

// Both syntaxes create identical arrays
var_dump($fruits);
// array(3) { [0]=> "Apple" [1]=> "Banana" [2]=> "Cherry" }
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/arrays-basics.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Always use the short array syntax
                                        <code>[]</code> instead of
                                        <code>array()</code>. It's cleaner, modern, and has been available since PHP
                                        5.4.
                                    </div>

                                    <h2>Accessing Array Elements</h2>
                                    <p>Use square brackets with the index to access elements:</p>

                                    <pre><code class="language-php">&lt;?php
$fruits = ["Apple", "Banana", "Cherry", "Date"];

echo $fruits[0];  // Apple (first element)
echo $fruits[1];  // Banana (second element)
echo $fruits[3];  // Date (fourth element)

// Get the last element
$lastIndex = count($fruits) - 1;
echo $fruits[$lastIndex];  // Date

// Or use end() function
echo end($fruits);  // Date (moves internal pointer)
?&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Remember:</strong> Array indices start at <code>0</code>, not
                                        <code>1</code>!
                                        An array with 4 elements has indices 0, 1, 2, and 3.
                                    </div>

                                    <h2>Modifying Arrays</h2>
                                    <p>Arrays in PHP are mutable - you can change, add, or remove elements:</p>

                                    <pre><code class="language-php">&lt;?php
$fruits = ["Apple", "Banana", "Cherry"];

// Modify existing element
$fruits[1] = "Blueberry";
// ["Apple", "Blueberry", "Cherry"]

// Add element at specific index
$fruits[3] = "Date";
// ["Apple", "Blueberry", "Cherry", "Date"]

// Append element (auto-assigns next index)
$fruits[] = "Elderberry";
// ["Apple", "Blueberry", "Cherry", "Date", "Elderberry"]

// Remove element
unset($fruits[2]);
// ["Apple", "Blueberry", "Date", "Elderberry"]
// Note: indices don't reindex! Index 2 is now missing
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Associative Arrays</h2>
                                    <p>Associative arrays use string keys instead of numeric indices:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/arrays-associative.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-associative" />
                                    </jsp:include>

                                    <h2>Associative Array Syntax</h2>
                                    <pre><code class="language-php">&lt;?php
// Creating associative arrays
$person = [
    "name" => "John Doe",
    "age" => 30,
    "email" => "john@example.com"
];

// Accessing values
echo $person["name"];   // John Doe
echo $person["age"];    // 30

// Adding new key-value pair
$person["city"] = "New York";

// Modifying existing value
$person["age"] = 31;

// Removing a key
unset($person["email"]);
?&gt;</code></pre>

                                    <h2>Useful Array Functions</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Function</th>
                                                <th>Purpose</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>count($arr)</code></td>
                                                <td>Get number of elements</td>
                                                <td><code>count([1,2,3])</code> &rarr; 3</td>
                                            </tr>
                                            <tr>
                                                <td><code>is_array($var)</code></td>
                                                <td>Check if variable is array</td>
                                                <td><code>is_array([])</code> &rarr; true</td>
                                            </tr>
                                            <tr>
                                                <td><code>empty($arr)</code></td>
                                                <td>Check if array is empty</td>
                                                <td><code>empty([])</code> &rarr; true</td>
                                            </tr>
                                            <tr>
                                                <td><code>array_keys($arr)</code></td>
                                                <td>Get all keys</td>
                                                <td><code>array_keys(["a"=>1])</code> &rarr; ["a"]</td>
                                            </tr>
                                            <tr>
                                                <td><code>array_values($arr)</code></td>
                                                <td>Get all values</td>
                                                <td><code>array_values(["a"=>1])</code> &rarr; [1]</td>
                                            </tr>
                                            <tr>
                                                <td><code>in_array($val, $arr)</code></td>
                                                <td>Check if value exists</td>
                                                <td><code>in_array(2, [1,2,3])</code> &rarr; true</td>
                                            </tr>
                                            <tr>
                                                <td><code>array_key_exists($key, $arr)</code></td>
                                                <td>Check if key exists</td>
                                                <td><code>array_key_exists("a", ["a"=>1])</code> &rarr; true</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Quick Array Creation</h2>
                                    <pre><code class="language-php">&lt;?php
// Create array of numbers
$numbers = range(1, 10);
// [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// Create array with step
$evens = range(2, 10, 2);
// [2, 4, 6, 8, 10]

// Create array of letters
$letters = range('a', 'f');
// ['a', 'b', 'c', 'd', 'e', 'f']

// Create array with repeated value
$zeros = array_fill(0, 5, 0);
// [0, 0, 0, 0, 0]

// Create array from variables
$a = 1; $b = 2; $c = 3;
$arr = compact('a', 'b', 'c');
// ["a" => 1, "b" => 2, "c" => 3]
?&gt;</code></pre>

                                    <h2>Printing Arrays</h2>
                                    <pre><code class="language-php">&lt;?php
$arr = ["name" => "John", "age" => 30];

// print_r - Human-readable output
print_r($arr);
/*
Array
(
    [name] => John
    [age] => 30
)
*/

// var_dump - Detailed output with types
var_dump($arr);
/*
array(2) {
  ["name"]=> string(4) "John"
  ["age"]=> int(30)
}
*/

// JSON format
echo json_encode($arr);
// {"name":"John","age":30}
?&gt;</code></pre>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Off-by-one index errors</h4>
                                        <pre><code class="language-php">&lt;?php
$arr = ["a", "b", "c"];  // Indices: 0, 1, 2

// ❌ WRONG: Index 3 doesn't exist
echo $arr[3];  // Warning: Undefined array key 3

// ✅ CORRECT: Use valid indices
echo $arr[2];  // "c" (last element)
echo $arr[count($arr) - 1];  // "c"
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using wrong quote style for keys</h4>
                                        <pre><code class="language-php">&lt;?php
$person = ["name" => "John"];

// ❌ WRONG: Using variable syntax without quotes
echo $person[name];  // Notice: Use of undefined constant

// ✅ CORRECT: Always quote string keys
echo $person["name"];  // John
echo $person['name'];  // John (also valid)
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Assuming unset reindexes</h4>
                                        <pre><code class="language-php">&lt;?php
$arr = ["a", "b", "c"];  // [0=>"a", 1=>"b", 2=>"c"]
unset($arr[1]);
// Now: [0=>"a", 2=>"c"] - Index 1 is MISSING!

print_r($arr);
// Array ( [0] => a [2] => c )

// To reindex after unset:
$arr = array_values($arr);
// Now: [0=>"a", 1=>"c"]
?&gt;</code></pre>
                                    </div>

                                    <h2>Exercise: Contact List</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a contact list with multiple entries.</p>
                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create an array of contacts (each contact is an associative array)</li>
                                            <li>Each contact has: name, email, phone</li>
                                            <li>Add at least 3 contacts</li>
                                            <li>Display all contacts in a formatted way</li>
                                            <li>Find and display a contact by name</li>
                                        </ul>
                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-php">&lt;?php
// Create contact list
$contacts = [
    [
        "name" => "Alice Smith",
        "email" => "alice@example.com",
        "phone" => "555-1234"
    ],
    [
        "name" => "Bob Johnson",
        "email" => "bob@example.com",
        "phone" => "555-5678"
    ],
    [
        "name" => "Carol Williams",
        "email" => "carol@example.com",
        "phone" => "555-9012"
    ]
];

// Display all contacts
echo "=== Contact List ===\n\n";
foreach ($contacts as $index => $contact) {
    echo ($index + 1) . ". {$contact['name']}\n";
    echo "   Email: {$contact['email']}\n";
    echo "   Phone: {$contact['phone']}\n\n";
}

// Find contact by name
$searchName = "Bob Johnson";
$found = null;

foreach ($contacts as $contact) {
    if ($contact['name'] === $searchName) {
        $found = $contact;
        break;
    }
}

if ($found) {
    echo "Found: {$found['name']} ({$found['email']})\n";
} else {
    echo "Contact not found.\n";
}
?&gt;</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Arrays:</strong> Store multiple values in one variable</li>
                                            <li><strong>Indexed:</strong> Numeric keys starting at 0</li>
                                            <li><strong>Associative:</strong> String keys for named access</li>
                                            <li><strong>Syntax:</strong> Use <code>[]</code> (not <code>array()</code>)
                                            </li>
                                            <li><strong>Access:</strong> <code>$arr[0]</code> or
                                                <code>$arr["key"]</code></li>
                                            <li><strong>Append:</strong> <code>$arr[] = $value</code></li>
                                            <li><strong>Remove:</strong> <code>unset($arr[key])</code></li>
                                            <li><strong>Count:</strong> <code>count($arr)</code></li>
                                            <li><strong>Debug:</strong> <code>print_r()</code> or
                                                <code>var_dump()</code></li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand basic arrays, let's explore <strong>Multidimensional
                                            Arrays</strong> -
                                        arrays within arrays that let you represent complex data structures!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="loops-control.jsp" />
                                    <jsp:param name="prevTitle" value="Break & Continue" />
                                    <jsp:param name="nextLink" value="arrays-multidimensional.jsp" />
                                    <jsp:param name="nextTitle" value="Multidimensional Arrays" />
                                    <jsp:param name="currentLessonId" value="arrays-basics" />
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