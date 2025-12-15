<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "arrays-functions-basic");
   request.setAttribute("currentModule", "Arrays"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Array Functions I - PHP Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn PHP array functions for searching and checking. Master count, in_array, array_search, array_key_exists, array_keys, and array_values.">
    <meta name="keywords"
        content="php array functions, php in_array, php array_search, php array_keys, php array_values, php count">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php/arrays-functions-basic.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Array Functions I","description":"Learn PHP array functions for searching, checking, and extracting data from arrays","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["count()","in_array()","array_search()","array_key_exists()","array_keys()","array_values()"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="arrays-functions-basic">
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
                    <span>Array Functions I</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">PHP Array Functions I</h1>
                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">PHP provides dozens of built-in array functions. In this lesson, we'll cover the
                        essential functions for counting, searching, and extracting information from arrays.</p>

                    <h2>Counting Elements</h2>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Function</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>count($arr)</code></td>
                                <td>Returns number of elements in array</td>
                            </tr>
                            <tr>
                                <td><code>sizeof($arr)</code></td>
                                <td>Alias for count()</td>
                            </tr>
                            <tr>
                                <td><code>count($arr, COUNT_RECURSIVE)</code></td>
                                <td>Counts all elements including nested arrays</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-php">&lt;?php
$fruits = ["Apple", "Banana", "Cherry"];
echo count($fruits);  // 3

$nested = ["a", ["b", "c"], "d"];
echo count($nested);                    // 3 (top level only)
echo count($nested, COUNT_RECURSIVE);   // 5 (all elements)

// Empty array check
$empty = [];
if (count($empty) === 0) {
    echo "Array is empty";
}
?&gt;</code></pre>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/arrays-functions-basic.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <h2>Checking for Values</h2>

                    <h3>in_array()</h3>
                    <p>Check if a value exists in an array:</p>

                    <pre><code class="language-php">&lt;?php
$fruits = ["Apple", "Banana", "Cherry"];

// Basic usage
in_array("Banana", $fruits);  // true
in_array("Grape", $fruits);   // false

// Case-sensitive!
in_array("apple", $fruits);   // false
in_array("Apple", $fruits);   // true

// Strict mode (checks type too)
$mixed = [1, 2, "3", 4];
in_array(3, $mixed);          // true (loose comparison)
in_array(3, $mixed, true);    // false (strict comparison)
in_array("3", $mixed, true);  // true
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Best Practice:</strong> Use the third parameter <code>true</code> for strict
                        comparison to avoid unexpected matches due to type juggling.
                    </div>

                    <h2>Finding Keys</h2>

                    <h3>array_search()</h3>
                    <p>Find the key of a value:</p>

                    <pre><code class="language-php">&lt;?php
$fruits = ["apple", "banana", "cherry"];

// Find key
$key = array_search("banana", $fruits);
echo $key;  // 1

// Not found returns false
$key = array_search("grape", $fruits);
if ($key === false) {
    echo "Not found";
}

// With duplicates, returns first match
$items = ["a", "b", "c", "b"];
echo array_search("b", $items);  // 1 (first occurrence)
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> Always use <code>=== false</code> to check for "not found"
                        because array_search() can return <code>0</code> (a valid key), which is falsy!
                    </div>

                    <h2>Checking for Keys</h2>

                    <h3>array_key_exists() vs isset()</h3>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Function</th>
                                <th>Returns true for null values?</th>
                                <th>Use when</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>array_key_exists()</code></td>
                                <td>Yes</td>
                                <td>Need to know if key exists regardless of value</td>
                            </tr>
                            <tr>
                                <td><code>isset()</code></td>
                                <td>No</td>
                                <td>Need to know if key exists AND is not null</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-php">&lt;?php
$data = [
    "name" => "John",
    "email" => null,
    "active" => false
];

// array_key_exists - checks only if key exists
array_key_exists("name", $data);   // true
array_key_exists("email", $data);  // true (even though null)
array_key_exists("phone", $data);  // false

// isset - checks if key exists AND is not null
isset($data["name"]);   // true
isset($data["email"]);  // false (null value)
isset($data["phone"]);  // false
?&gt;</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Extracting Keys and Values</h2>

                    <h3>array_keys()</h3>
                    <pre><code class="language-php">&lt;?php
$person = ["name" => "John", "age" => 30, "city" => "NYC"];

// Get all keys
$keys = array_keys($person);
print_r($keys);  // ["name", "age", "city"]

// Get keys for specific value
$scores = ["Alice" => 95, "Bob" => 88, "Carol" => 95];
$topScorers = array_keys($scores, 95);
print_r($topScorers);  // ["Alice", "Carol"]
?&gt;</code></pre>

                    <h3>array_values()</h3>
                    <pre><code class="language-php">&lt;?php
$person = ["name" => "John", "age" => 30, "city" => "NYC"];

// Get all values (reindexed)
$values = array_values($person);
print_r($values);  // ["John", 30, "NYC"]

// Useful for reindexing after unset
$arr = [0 => "a", 1 => "b", 2 => "c"];
unset($arr[1]);
print_r($arr);  // [0 => "a", 2 => "c"] - gap in indices

$arr = array_values($arr);
print_r($arr);  // [0 => "a", 1 => "c"] - reindexed
?&gt;</code></pre>

                    <h2>First and Last Elements</h2>

                    <pre><code class="language-php">&lt;?php
$queue = ["first", "second", "third", "last"];

// Get first element
$first = reset($queue);  // "first" (moves pointer to start)

// Get last element
$last = end($queue);     // "last" (moves pointer to end)

// Get current element
$current = current($queue);  // "last" (pointer is at end)

// PHP 7.3+: Get first/last key without moving pointer
$firstKey = array_key_first($queue);  // 0
$lastKey = array_key_last($queue);    // 3
?&gt;</code></pre>

                    <h2>Practical Examples</h2>

                    <pre><code class="language-php">&lt;?php
// Check if user role is allowed
$allowedRoles = ["admin", "editor", "moderator"];
$userRole = "editor";

if (in_array($userRole, $allowedRoles, true)) {
    echo "Access granted";
}

// Find user by email
$users = [
    ["id" => 1, "email" => "alice@test.com"],
    ["id" => 2, "email" => "bob@test.com"],
    ["id" => 3, "email" => "carol@test.com"]
];

$searchEmail = "bob@test.com";
$foundUser = null;

foreach ($users as $user) {
    if ($user["email"] === $searchEmail) {
        $foundUser = $user;
        break;
    }
}

// Get unique values
$tags = ["php", "javascript", "php", "python", "javascript"];
$uniqueTags = array_unique($tags);
print_r($uniqueTags);  // ["php", "javascript", "python"]
?&gt;</code></pre>

                    <h2>Quick Reference</h2>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Task</th>
                                <th>Function</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Count elements</td>
                                <td><code>count($arr)</code></td>
                            </tr>
                            <tr>
                                <td>Check if value exists</td>
                                <td><code>in_array($val, $arr)</code></td>
                            </tr>
                            <tr>
                                <td>Find key of value</td>
                                <td><code>array_search($val, $arr)</code></td>
                            </tr>
                            <tr>
                                <td>Check if key exists</td>
                                <td><code>array_key_exists($key, $arr)</code></td>
                            </tr>
                            <tr>
                                <td>Get all keys</td>
                                <td><code>array_keys($arr)</code></td>
                            </tr>
                            <tr>
                                <td>Get all values</td>
                                <td><code>array_values($arr)</code></td>
                            </tr>
                            <tr>
                                <td>Remove duplicates</td>
                                <td><code>array_unique($arr)</code></td>
                            </tr>
                            <tr>
                                <td>Get first element</td>
                                <td><code>reset($arr)</code></td>
                            </tr>
                            <tr>
                                <td>Get last element</td>
                                <td><code>end($arr)</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <h2>Exercise: Search System</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Build a simple product search system.</p>
                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create an array of products with id, name, category, price</li>
                            <li>Function to find product by ID</li>
                            <li>Function to check if category exists</li>
                            <li>Function to get all unique categories</li>
                            <li>Function to count products per category</li>
                        </ul>
                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-php">&lt;?php
$products = [
    ["id" => 1, "name" => "Laptop", "category" => "Electronics", "price" => 999],
    ["id" => 2, "name" => "Mouse", "category" => "Electronics", "price" => 29],
    ["id" => 3, "name" => "Desk", "category" => "Furniture", "price" => 199],
    ["id" => 4, "name" => "Chair", "category" => "Furniture", "price" => 149],
    ["id" => 5, "name" => "Notebook", "category" => "Stationery", "price" => 5]
];

// Find product by ID
function findProductById($products, $id) {
    foreach ($products as $product) {
        if ($product["id"] === $id) {
            return $product;
        }
    }
    return null;
}

// Check if category exists
function categoryExists($products, $category) {
    foreach ($products as $product) {
        if ($product["category"] === $category) {
            return true;
        }
    }
    return false;
}

// Get unique categories
function getCategories($products) {
    $categories = [];
    foreach ($products as $product) {
        if (!in_array($product["category"], $categories)) {
            $categories[] = $product["category"];
        }
    }
    return $categories;
}

// Count products per category
function countByCategory($products) {
    $counts = [];
    foreach ($products as $product) {
        $cat = $product["category"];
        if (!isset($counts[$cat])) {
            $counts[$cat] = 0;
        }
        $counts[$cat]++;
    }
    return $counts;
}

// Test the functions
echo "Product #2: ";
print_r(findProductById($products, 2));

echo "Electronics exists: " . (categoryExists($products, "Electronics") ? "Yes" : "No") . "\n";

echo "Categories: " . implode(", ", getCategories($products)) . "\n";

echo "Products per category:\n";
print_r(countByCategory($products));
?&gt;</code></pre>
                        </details>
                    </div>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>count():</strong> Get array length</li>
                            <li><strong>in_array():</strong> Check if value exists (use strict mode!)</li>
                            <li><strong>array_search():</strong> Find key of a value (returns false if not found)</li>
                            <li><strong>array_key_exists():</strong> Check if key exists (works with null values)</li>
                            <li><strong>isset():</strong> Check if key exists AND is not null</li>
                            <li><strong>array_keys():</strong> Extract all keys as a new array</li>
                            <li><strong>array_values():</strong> Extract all values (reindexes array)</li>
                            <li><strong>array_unique():</strong> Remove duplicate values</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's explore <strong>Array Functions II</strong> - functions for modifying arrays:
                        adding, removing, merging, and slicing elements!</p>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="arrays-multidimensional.jsp" />
                    <jsp:param name="prevTitle" value="Multidimensional Arrays" />
                    <jsp:param name="nextLink" value="arrays-functions-advanced.jsp" />
                    <jsp:param name="nextTitle" value="Array Functions II" />
                    <jsp:param name="currentLessonId" value="arrays-functions-basic" />
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
