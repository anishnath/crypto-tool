<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "arrays-iteration" ); request.setAttribute("currentModule", "Arrays" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Array Iteration - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn PHP functional array iteration with array_map, array_filter, array_reduce, and array_walk. Master functional programming patterns.">
            <meta name="keywords"
                content="php array_map, php array_filter, php array_reduce, php array_walk, php functional programming">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/arrays-iteration.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Array Iteration","description":"Learn PHP functional array iteration with array_map, array_filter, array_reduce, and array_walk","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["array_map()","array_filter()","array_reduce()","array_walk()","Functional programming"],"timeRequired":"PT35M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="arrays-iteration">
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
                                    <span>Array Iteration</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Array Iteration</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~35 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Beyond basic foreach loops, PHP provides powerful functional-style
                                        array functions.
                                        These let you transform, filter, and reduce arrays with clean, expressive code
                                        that's easy to
                                        read and maintain.</p>

                                    <h2>Functional Array Functions Overview</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Function</th>
                                                <th>Purpose</th>
                                                <th>Returns</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>array_map()</code></td>
                                                <td>Transform each element</td>
                                                <td>New array (same length)</td>
                                            </tr>
                                            <tr>
                                                <td><code>array_filter()</code></td>
                                                <td>Keep matching elements</td>
                                                <td>New array (subset)</td>
                                            </tr>
                                            <tr>
                                                <td><code>array_reduce()</code></td>
                                                <td>Combine to single value</td>
                                                <td>Single value</td>
                                            </tr>
                                            <tr>
                                                <td><code>array_walk()</code></td>
                                                <td>Apply function (in place)</td>
                                                <td>true/false</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>array_map() - Transform Elements</h2>
                                    <p>Apply a function to each element and return a new array:</p>

                                    <pre><code class="language-php">&lt;?php
$numbers = [1, 2, 3, 4, 5];

// Square each number
$squared = array_map(fn($n) => $n * $n, $numbers);
// [1, 4, 9, 16, 25]

// Format prices
$prices = [10, 25.5, 99.99];
$formatted = array_map(fn($p) => "$" . number_format($p, 2), $prices);
// ["$10.00", "$25.50", "$99.99"]

// Extract property from objects
$users = [
    ["name" => "Alice", "age" => 25],
    ["name" => "Bob", "age" => 30]
];
$names = array_map(fn($u) => $u["name"], $users);
// ["Alice", "Bob"]
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/arrays-iteration.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-iteration" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Note:</strong> <code>array_map()</code> puts the callback first, then
                                        the array(s).
                                        This is opposite of <code>array_filter()</code> and <code>array_reduce()</code>!
                                    </div>

                                    <h2>array_filter() - Keep Matching Elements</h2>
                                    <p>Filter elements based on a condition:</p>

                                    <pre><code class="language-php">&lt;?php
$numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Keep even numbers
$evens = array_filter($numbers, fn($n) => $n % 2 === 0);
// [2, 4, 6, 8, 10]

// Keep positive values
$mixed = [-5, 0, 3, -2, 8, -1];
$positive = array_filter($mixed, fn($n) => $n > 0);
// [3, 8]

// Without callback - removes "falsy" values
$data = [0, 1, "", "hello", null, false, []];
$truthy = array_filter($data);
// [1, "hello"]

// Filter by key
$arr = ["a" => 1, "b" => 2, "c" => 3];
$filtered = array_filter($arr, fn($k) => $k !== "b", ARRAY_FILTER_USE_KEY);
// ["a" => 1, "c" => 3]
?&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> <code>array_filter()</code> preserves keys! Use
                                        <code>array_values()</code> if you need reindexing.
                                    </div>

                                    <h2>array_reduce() - Combine to Single Value</h2>
                                    <p>Reduce an array to a single value by applying a function cumulatively:</p>

                                    <pre><code class="language-php">&lt;?php
$numbers = [1, 2, 3, 4, 5];

// Sum all values
$sum = array_reduce($numbers, fn($carry, $n) => $carry + $n, 0);
// 15

// Product of all values
$product = array_reduce($numbers, fn($carry, $n) => $carry * $n, 1);
// 120

// Find maximum
$max = array_reduce($numbers, fn($carry, $n) => max($carry, $n), PHP_INT_MIN);
// 5

// Build string
$words = ["Hello", "World"];
$sentence = array_reduce($words, fn($c, $w) => $c ? "$c $w" : $w, "");
// "Hello World"

// Build associative array
$items = [["id" => 1, "val" => "a"], ["id" => 2, "val" => "b"]];
$indexed = array_reduce($items, function($carry, $item) {
    $carry[$item["id"]] = $item["val"];
    return $carry;
}, []);
// [1 => "a", 2 => "b"]
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>array_walk() - Modify In Place</h2>
                                    <p>Apply a function to each element, modifying the original array:</p>

                                    <pre><code class="language-php">&lt;?php
$prices = [100, 200, 300];

// Apply 10% discount (modify in place)
array_walk($prices, function(&$price) {
    $price *= 0.9;
});
// $prices is now [90, 180, 270]

// With key access
$inventory = ["apples" => 50, "bananas" => 30];
array_walk($inventory, function(&$qty, $item) {
    echo "Checking $item: $qty units\n";
    $qty += 10;  // Add 10 to each
});

// Pass extra data
$rates = [100, 200, 300];
$taxRate = 0.08;
array_walk($rates, function(&$val, $key, $tax) {
    $val *= (1 + $tax);
}, $taxRate);
?&gt;</code></pre>

                                    <h2>Chaining Operations</h2>
                                    <p>Combine functions for complex transformations:</p>

                                    <pre><code class="language-php">&lt;?php
$users = [
    ["name" => "Alice", "age" => 25, "active" => true],
    ["name" => "Bob", "age" => 17, "active" => true],
    ["name" => "Carol", "age" => 30, "active" => false],
    ["name" => "David", "age" => 22, "active" => true]
];

// Get names of active adult users
$result = array_map(
    fn($u) => $u["name"],
    array_filter($users, fn($u) => $u["active"] && $u["age"] >= 18)
);
// ["Alice", "David"]

// Calculate average age of active users
$activeUsers = array_filter($users, fn($u) => $u["active"]);
$totalAge = array_reduce($activeUsers, fn($sum, $u) => $sum + $u["age"], 0);
$avgAge = $totalAge / count($activeUsers);
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/arrays-functional.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-functional" />
                                    </jsp:include>

                                    <h2>Useful Related Functions</h2>

                                    <pre><code class="language-php">&lt;?php
// array_column - Extract column from 2D array
$users = [
    ["id" => 1, "name" => "Alice"],
    ["id" => 2, "name" => "Bob"]
];
$names = array_column($users, "name");          // ["Alice", "Bob"]
$byId = array_column($users, "name", "id");     // [1 => "Alice", 2 => "Bob"]

// array_sum / array_product
$numbers = [1, 2, 3, 4, 5];
echo array_sum($numbers);      // 15
echo array_product($numbers);  // 120

// array_count_values
$votes = ["yes", "no", "yes", "yes", "no"];
$counts = array_count_values($votes);
// ["yes" => 3, "no" => 2]

// array_diff / array_intersect
$a = [1, 2, 3, 4, 5];
$b = [3, 4, 5, 6, 7];
array_diff($a, $b);       // [1, 2]
array_intersect($a, $b);  // [3, 4, 5]
?&gt;</code></pre>

                                    <h2>When to Use Each</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Task</th>
                                                <th>Use</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Transform each element</td>
                                                <td><code>array_map()</code></td>
                                            </tr>
                                            <tr>
                                                <td>Remove some elements</td>
                                                <td><code>array_filter()</code></td>
                                            </tr>
                                            <tr>
                                                <td>Calculate total/aggregate</td>
                                                <td><code>array_reduce()</code></td>
                                            </tr>
                                            <tr>
                                                <td>Modify original array</td>
                                                <td><code>array_walk()</code></td>
                                            </tr>
                                            <tr>
                                                <td>Extract single column</td>
                                                <td><code>array_column()</code></td>
                                            </tr>
                                            <tr>
                                                <td>Sum numbers</td>
                                                <td><code>array_sum()</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Exercise: Data Pipeline</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Process sales data using functional array functions.
                                        </p>
                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Filter out cancelled orders</li>
                                            <li>Calculate total for each order (price × quantity)</li>
                                            <li>Get total revenue</li>
                                            <li>Find the highest value order</li>
                                        </ul>
                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-php">&lt;?php
$orders = [
    ["id" => 1, "product" => "Widget", "price" => 25, "qty" => 4, "status" => "completed"],
    ["id" => 2, "product" => "Gadget", "price" => 50, "qty" => 2, "status" => "cancelled"],
    ["id" => 3, "product" => "Tool", "price" => 35, "qty" => 3, "status" => "completed"],
    ["id" => 4, "product" => "Device", "price" => 100, "qty" => 1, "status" => "completed"],
    ["id" => 5, "product" => "Part", "price" => 15, "qty" => 10, "status" => "cancelled"]
];

// 1. Filter out cancelled orders
$activeOrders = array_filter($orders, fn($o) => $o["status"] !== "cancelled");

// 2. Calculate total for each order
$ordersWithTotal = array_map(fn($o) => [
    ...$o,
    "total" => $o["price"] * $o["qty"]
], $activeOrders);

// 3. Get total revenue
$totalRevenue = array_reduce($ordersWithTotal, fn($sum, $o) => $sum + $o["total"], 0);

// 4. Find highest value order
$highestOrder = array_reduce($ordersWithTotal, function($max, $o) {
    return ($o["total"] > ($max["total"] ?? 0)) ? $o : $max;
}, []);

echo "Active Orders:\n";
foreach ($ordersWithTotal as $order) {
    echo "  Order \#{$order['id']}: {$order['product']} - \${$order['total']}\n";
}

echo "\nTotal Revenue: \$$totalRevenue\n";
echo "Highest Order: \#{$highestOrder['id']} ({$highestOrder['product']}) - \${$highestOrder['total']}\n";
?&gt;</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>array_map():</strong> Transform each element &rarr; new array
                                            </li>
                                            <li><strong>array_filter():</strong> Keep matching elements &rarr; subset
                                                array</li>
                                            <li><strong>array_reduce():</strong> Combine to single value</li>
                                            <li><strong>array_walk():</strong> Modify array in place</li>
                                            <li><strong>Chain functions:</strong> Combine for complex pipelines</li>
                                            <li><strong>Use arrow functions:</strong> <code>fn($x) => $x * 2</code> for
                                                concise code</li>
                                            <li><strong>array_filter preserves keys:</strong> Use array_values() to
                                                reindex</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Finally, let's learn about <strong>Array Sorting</strong> - PHP's many sorting
                                        functions
                                        and how to create custom sort comparisons!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="arrays-functions-advanced.jsp" />
                                    <jsp:param name="prevTitle" value="Array Functions II" />
                                    <jsp:param name="nextLink" value="arrays-sorting.jsp" />
                                    <jsp:param name="nextTitle" value="Array Sorting" />
                                    <jsp:param name="currentLessonId" value="arrays-iteration" />
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