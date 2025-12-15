<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "arrays-multidimensional");
   request.setAttribute("currentModule", "Arrays"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Multidimensional Arrays - PHP Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn PHP multidimensional arrays. Master 2D arrays, nested arrays, arrays of objects, and real-world data structures.">
    <meta name="keywords"
        content="php multidimensional array, php 2d array, php nested array, php array of arrays, php complex arrays">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php/arrays-multidimensional.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Multidimensional Arrays","description":"Learn PHP multidimensional arrays including 2D arrays, nested arrays, and real-world data structures","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["Multidimensional arrays","2D arrays","Nested arrays","Array traversal"],"timeRequired":"PT35M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="arrays-multidimensional">
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
                    <span>Multidimensional Arrays</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">PHP Multidimensional Arrays</h1>
                    <div class="lesson-meta"><span>Intermediate</span><span>~35 min read</span></div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">Multidimensional arrays are arrays that contain other arrays. They're essential for
                        representing complex data structures like tables, matrices, hierarchical data, and records from
                        databases or APIs.</p>

                    <h2>What are Multidimensional Arrays?</h2>
                    <p>A multidimensional array is simply an array where each element can be another array. The most
                        common type is the 2D array (array of arrays).</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Dimensions</th>
                                <th>Description</th>
                                <th>Access Pattern</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>2D Array</td>
                                <td>Array of arrays (like a table)</td>
                                <td><code>$arr[row][col]</code></td>
                            </tr>
                            <tr>
                                <td>3D Array</td>
                                <td>Array of 2D arrays</td>
                                <td><code>$arr[x][y][z]</code></td>
                            </tr>
                            <tr>
                                <td>Nested Assoc.</td>
                                <td>Associative arrays within arrays</td>
                                <td><code>$arr["key"]["subkey"]</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <h2>2D Arrays (Matrices)</h2>
                    <p>A 2D array is like a table with rows and columns:</p>

                    <pre><code class="language-php">&lt;?php
// 3x3 matrix
$matrix = [
    [1, 2, 3],    // Row 0
    [4, 5, 6],    // Row 1
    [7, 8, 9]     // Row 2
];

// Access: $matrix[row][column]
echo $matrix[0][0];  // 1 (first row, first column)
echo $matrix[1][2];  // 6 (second row, third column)
echo $matrix[2][1];  // 8 (third row, second column)
?&gt;</code></pre>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/arrays-multidimensional.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-multi" />
                    </jsp:include>

                    <h2>Array of Associative Arrays</h2>
                    <p>This is the most common real-world pattern - a list of records:</p>

                    <pre><code class="language-php">&lt;?php
// Array of user records (like database rows)
$users = [
    ["id" => 1, "name" => "Alice", "email" => "alice@example.com"],
    ["id" => 2, "name" => "Bob", "email" => "bob@example.com"],
    ["id" => 3, "name" => "Carol", "email" => "carol@example.com"]
];

// Access specific user's data
echo $users[0]["name"];   // Alice
echo $users[1]["email"];  // bob@example.com

// Loop through all users
foreach ($users as $user) {
    echo "{$user['name']}: {$user['email']}\n";
}
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Common Use Cases:</strong>
                        <ul>
                            <li>Database query results</li>
                            <li>API responses (JSON decoded)</li>
                            <li>Form data with multiple items</li>
                            <li>Configuration files</li>
                        </ul>
                    </div>

                    <h2>Nested Associative Arrays</h2>
                    <p>Deeply nested structures for complex hierarchical data:</p>

                    <pre><code class="language-php">&lt;?php
$company = [
    "name" => "TechCorp",
    "address" => [
        "street" => "123 Main St",
        "city" => "San Francisco",
        "state" => "CA",
        "zip" => "94102"
    ],
    "departments" => [
        "engineering" => [
            "manager" => "Alice",
            "team_size" => 15
        ],
        "sales" => [
            "manager" => "Bob",
            "team_size" => 10
        ]
    ]
];

// Access nested values
echo $company["name"];                              // TechCorp
echo $company["address"]["city"];                   // San Francisco
echo $company["departments"]["engineering"]["manager"];  // Alice
?&gt;</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Traversing Multidimensional Arrays</h2>

                    <h3>Using Nested Foreach</h3>
                    <pre><code class="language-php">&lt;?php
$matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

// Nested foreach
foreach ($matrix as $rowIndex => $row) {
    foreach ($row as $colIndex => $value) {
        echo "[$rowIndex][$colIndex] = $value\n";
    }
}
?&gt;</code></pre>

                    <h3>Using Nested For Loops</h3>
                    <pre><code class="language-php">&lt;?php
$matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

$rows = count($matrix);
$cols = count($matrix[0]);

for ($i = 0; $i < $rows; $i++) {
    for ($j = 0; $j < $cols; $j++) {
        echo $matrix[$i][$j] . " ";
    }
    echo "\n";
}
?&gt;</code></pre>

                    <h2>Real-World Examples</h2>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/arrays-nested.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-nested" />
                    </jsp:include>

                    <h2>Modifying Nested Arrays</h2>
                    <pre><code class="language-php">&lt;?php
$data = [
    "users" => [
        ["name" => "Alice", "age" => 25],
        ["name" => "Bob", "age" => 30]
    ]
];

// Add a new user
$data["users"][] = ["name" => "Carol", "age" => 28];

// Modify existing user
$data["users"][0]["age"] = 26;

// Add a new property to existing user
$data["users"][1]["city"] = "New York";

// Remove a user
unset($data["users"][0]);

// Reindex after removal
$data["users"] = array_values($data["users"]);
?&gt;</code></pre>

                    <h2>Checking Nested Keys</h2>
                    <pre><code class="language-php">&lt;?php
$config = [
    "database" => [
        "host" => "localhost",
        "port" => 3306
    ]
];

// Check if nested key exists
if (isset($config["database"]["host"])) {
    echo "Host: " . $config["database"]["host"];
}

// Safe access with null coalescing
$timeout = $config["database"]["timeout"] ?? 30;
echo "Timeout: $timeout";  // 30 (default)

// Check multiple levels
function getNestedValue($arr, $keys, $default = null) {
    foreach ($keys as $key) {
        if (!isset($arr[$key])) {
            return $default;
        }
        $arr = $arr[$key];
    }
    return $arr;
}

$host = getNestedValue($config, ["database", "host"], "127.0.0.1");
?&gt;</code></pre>

                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Accessing non-existent nested keys</h4>
                        <pre><code class="language-php">&lt;?php
$data = ["user" => ["name" => "John"]];

// ❌ WRONG: Will cause errors
echo $data["user"]["email"]["domain"];
// Warning: Undefined array key "email"

// ✅ CORRECT: Check before accessing
if (isset($data["user"]["email"]["domain"])) {
    echo $data["user"]["email"]["domain"];
}

// Or use null coalescing
echo $data["user"]["email"]["domain"] ?? "N/A";
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Confusing index order</h4>
                        <pre><code class="language-php">&lt;?php
$table = [
    ["A1", "B1", "C1"],
    ["A2", "B2", "C2"]
];

// ❌ WRONG: Accessing [column][row]
echo $table[0][1];  // "B1", not "A2"

// ✅ CORRECT: Remember it's [row][column]
echo $table[1][0];  // "A2" (row 1, column 0)
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Modifying copy instead of original</h4>
                        <pre><code class="language-php">&lt;?php
$users = [
    ["name" => "Alice", "score" => 85]
];

// ❌ WRONG: $user is a copy
foreach ($users as $user) {
    $user["score"] += 10;  // Doesn't modify original
}
print_r($users);  // Score still 85!

// ✅ CORRECT: Use reference
foreach ($users as &$user) {
    $user["score"] += 10;  // Modifies original
}
unset($user);  // Don't forget!
print_r($users);  // Score is now 95
?&gt;</code></pre>
                    </div>

                    <h2>Exercise: Product Inventory</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create and manage a product inventory system.</p>
                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a nested array with product categories</li>
                            <li>Each category contains multiple products</li>
                            <li>Each product has: id, name, price, stock</li>
                            <li>Calculate total inventory value per category</li>
                            <li>Find products with low stock (< 10 items)</li>
                        </ul>
                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-php">&lt;?php
$inventory = [
    "electronics" => [
        ["id" => 1, "name" => "Laptop", "price" => 999.99, "stock" => 15],
        ["id" => 2, "name" => "Mouse", "price" => 29.99, "stock" => 50],
        ["id" => 3, "name" => "Keyboard", "price" => 79.99, "stock" => 5]
    ],
    "clothing" => [
        ["id" => 4, "name" => "T-Shirt", "price" => 19.99, "stock" => 100],
        ["id" => 5, "name" => "Jeans", "price" => 49.99, "stock" => 8],
        ["id" => 6, "name" => "Jacket", "price" => 89.99, "stock" => 3]
    ]
];

echo "=== Inventory Value by Category ===\n\n";

foreach ($inventory as $category => $products) {
    $categoryValue = 0;

    foreach ($products as $product) {
        $categoryValue += $product["price"] * $product["stock"];
    }

    echo ucfirst($category) . ": $" . number_format($categoryValue, 2) . "\n";
}

echo "\n=== Low Stock Alert (<10 items) ===\n\n";

foreach ($inventory as $category => $products) {
    foreach ($products as $product) {
        if ($product["stock"] < 10) {
            echo "⚠️  {$product['name']} ({$category}): ";
            echo "Only {$product['stock']} left!\n";
        }
    }
}
?&gt;</code></pre>
                        </details>
                    </div>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>2D Arrays:</strong> Arrays of arrays, like tables</li>
                            <li><strong>Access:</strong> <code>$arr[row][col]</code> or <code>$arr["key"]["subkey"]</code></li>
                            <li><strong>Records:</strong> Array of associative arrays for data records</li>
                            <li><strong>Nesting:</strong> Arrays can be nested to any depth</li>
                            <li><strong>Traversal:</strong> Use nested foreach or for loops</li>
                            <li><strong>Safety:</strong> Always check with <code>isset()</code> or <code>??</code></li>
                            <li><strong>Modification:</strong> Use <code>&</code> reference in foreach to modify</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can work with complex array structures, let's learn about
                        <strong>Array Functions I</strong> - PHP's built-in functions for searching, checking, and
                        extracting array data!</p>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="arrays-basics.jsp" />
                    <jsp:param name="prevTitle" value="Array Basics" />
                    <jsp:param name="nextLink" value="arrays-functions-basic.jsp" />
                    <jsp:param name="nextTitle" value="Array Functions I" />
                    <jsp:param name="currentLessonId" value="arrays-multidimensional" />
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
