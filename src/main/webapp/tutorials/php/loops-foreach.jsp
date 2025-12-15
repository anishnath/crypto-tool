<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-foreach");
   request.setAttribute("currentModule", "Control Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Foreach Loops - PHP Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn PHP foreach loops for iterating arrays. Master key-value pairs, reference modification, and best practices.">
    <meta name="keywords"
        content="php foreach, php array loop, php iterate array, php foreach key value, php foreach reference">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php/loops-foreach.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Foreach Loops","description":"Learn PHP foreach loops for iterating arrays with key-value pairs and references","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP foreach","Array iteration","Key-value pairs","Reference modification"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="loops-foreach">
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
                    <span>Foreach Loops</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">PHP Foreach Loops</h1>
                    <div class="lesson-meta"><span>Beginner</span><span>~30 min read</span></div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">The <code>foreach</code> loop is PHP's most elegant way to iterate arrays. It
                        automatically handles array traversal without needing counters or indices - just loop through
                        each element directly!</p>

                    <h2>Foreach Syntax</h2>
                    <p>There are two forms of foreach - with values only, or with keys and values:</p>

                    <pre><code class="language-php">&lt;?php
// Values only
foreach ($array as $value) {
    // Use $value
}

// Keys and values
foreach ($array as $key => $value) {
    // Use $key and $value
}
?&gt;</code></pre>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Syntax</th>
                                <th>Use Case</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>$array as $value</code></td>
                                <td>When you only need the values</td>
                            </tr>
                            <tr>
                                <td><code>$array as $key => $value</code></td>
                                <td>When you need both keys and values</td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/loops-foreach.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-foreach" />
                    </jsp:include>

                    <h2>Indexed Arrays</h2>
                    <p>For simple indexed arrays, you usually just need the values:</p>

                    <pre><code class="language-php">&lt;?php
$fruits = ["Apple", "Banana", "Cherry"];

// Simple iteration
foreach ($fruits as $fruit) {
    echo "I like $fruit\n";
}

// With index (key)
foreach ($fruits as $index => $fruit) {
    $position = $index + 1;
    echo "$position. $fruit\n";
}
// Output:
// 1. Apple
// 2. Banana
// 3. Cherry
?&gt;</code></pre>

                    <h2>Associative Arrays</h2>
                    <p>For associative arrays, the key-value syntax is essential:</p>

                    <pre><code class="language-php">&lt;?php
$user = [
    "name" => "John",
    "email" => "john@example.com",
    "role" => "admin"
];

foreach ($user as $field => $value) {
    echo ucfirst($field) . ": $value\n";
}
// Output:
// Name: John
// Email: john@example.com
// Role: admin
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Naming Convention:</strong> Choose meaningful variable names that describe what you're
                        iterating. Use singular for the value (<code>$user</code> in <code>$users</code>) and the
                        actual property name for keys (<code>$field</code>, <code>$id</code>, <code>$name</code>).
                    </div>

                    <h2>Nested Arrays</h2>
                    <p>Foreach handles nested arrays elegantly:</p>

                    <pre><code class="language-php">&lt;?php
$products = [
    ["name" => "Laptop", "price" => 999.99],
    ["name" => "Mouse", "price" => 29.99],
    ["name" => "Keyboard", "price" => 79.99]
];

foreach ($products as $product) {
    echo "{$product['name']}: \${$product['price']}\n";
}

// With nested foreach
$categories = [
    "Electronics" => ["TV", "Radio", "Phone"],
    "Clothing" => ["Shirt", "Pants", "Hat"]
];

foreach ($categories as $category => $items) {
    echo "\n$category:\n";
    foreach ($items as $item) {
        echo "  - $item\n";
    }
}
?&gt;</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Modifying Values by Reference</h2>
                    <p>Use <code>&</code> to modify array elements in place:</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/loops-foreach-reference.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-reference" />
                    </jsp:include>

                    <h2>Reference Syntax</h2>
                    <pre><code class="language-php">&lt;?php
$numbers = [1, 2, 3, 4, 5];

// Without reference - original unchanged
foreach ($numbers as $num) {
    $num *= 2;  // Modifies copy only
}
// $numbers is still [1, 2, 3, 4, 5]

// With reference - modifies original
foreach ($numbers as &$num) {
    $num *= 2;  // Modifies actual array element
}
unset($num);  // CRITICAL: Remove reference!
// $numbers is now [2, 4, 6, 8, 10]
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Critical:</strong> Always call <code>unset($var)</code> after a reference foreach loop!
                        The reference variable remains linked to the last array element, which can cause subtle bugs
                        if you reuse the variable name later.
                    </div>

                    <h2>Foreach vs For Loop</h2>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Feature</th>
                                <th>foreach</th>
                                <th>for</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Best for</td>
                                <td>Arrays and objects</td>
                                <td>Known iteration count</td>
                            </tr>
                            <tr>
                                <td>Index access</td>
                                <td>Built-in with <code>$key</code></td>
                                <td>Manual with <code>$i</code></td>
                            </tr>
                            <tr>
                                <td>Associative arrays</td>
                                <td>Native support</td>
                                <td>Not practical</td>
                            </tr>
                            <tr>
                                <td>Readability</td>
                                <td>More readable</td>
                                <td>More verbose</td>
                            </tr>
                            <tr>
                                <td>Skip by index</td>
                                <td>Not easy</td>
                                <td>Easy with <code>$i += 2</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-php">&lt;?php
$colors = ["red", "green", "blue"];

// Foreach (recommended for arrays)
foreach ($colors as $color) {
    echo "$color ";
}

// For loop equivalent (verbose)
for ($i = 0; $i < count($colors); $i++) {
    echo $colors[$i] . " ";
}
?&gt;</code></pre>

                    <h2>Alternative Syntax</h2>
                    <p>For templates mixing PHP and HTML:</p>

                    <pre><code class="language-php">&lt;?php $users = [
    ["name" => "Alice", "active" => true],
    ["name" => "Bob", "active" => false]
]; ?&gt;

&lt;ul&gt;
&lt;?php foreach ($users as $user): ?&gt;
    &lt;li class="&lt;?= $user['active'] ? 'active' : 'inactive' ?&gt;"&gt;
        &lt;?= htmlspecialchars($user['name']) ?&gt;
    &lt;/li&gt;
&lt;?php endforeach; ?&gt;
&lt;/ul&gt;</code></pre>

                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting unset() after reference</h4>
                        <pre><code class="language-php">&lt;?php
$arr = [1, 2, 3];

// ❌ WRONG: Missing unset()
foreach ($arr as &$val) {
    $val *= 2;
}
// $val still references $arr[2]!

$val = 100;  // Oops! Changes $arr[2] to 100!
print_r($arr);  // [2, 4, 100] - unexpected!

// ✅ CORRECT: Always unset
foreach ($arr as &$val) {
    $val *= 2;
}
unset($val);  // Break the reference
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Modifying array during iteration</h4>
                        <pre><code class="language-php">&lt;?php
$items = ["a", "b", "c", "d"];

// ❌ DANGEROUS: Adding elements while iterating
foreach ($items as $item) {
    if ($item === "b") {
        $items[] = "e";  // Don't do this!
    }
}

// ✅ SAFE: Build a new array instead
$newItems = [];
foreach ($items as $item) {
    $newItems[] = $item;
    if ($item === "b") {
        $newItems[] = "e";
    }
}
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Using wrong syntax for keys</h4>
                        <pre><code class="language-php">&lt;?php
$data = ["name" => "John", "age" => 30];

// ❌ WRONG: Only gets values
foreach ($data as $value) {
    // Can't access the key here!
}

// ✅ CORRECT: Get both key and value
foreach ($data as $key => $value) {
    echo "$key: $value\n";
}
?&gt;</code></pre>
                    </div>

                    <h2>Exercise: Data Processor</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Process a list of products and calculate statistics.</p>
                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Calculate total value of all products (price × quantity)</li>
                            <li>Find the most expensive product</li>
                            <li>Apply a 15% discount to products over $50</li>
                            <li>Display the results</li>
                        </ul>
                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-php">&lt;?php
$products = [
    ["name" => "Laptop", "price" => 999.99, "qty" => 2],
    ["name" => "Mouse", "price" => 29.99, "qty" => 10],
    ["name" => "Keyboard", "price" => 79.99, "qty" => 5],
    ["name" => "Monitor", "price" => 299.99, "qty" => 3]
];

$totalValue = 0;
$mostExpensive = null;
$highestPrice = 0;

// Process products
foreach ($products as &$product) {
    // Calculate line total
    $lineTotal = $product['price'] * $product['qty'];
    $totalValue += $lineTotal;

    // Track most expensive
    if ($product['price'] > $highestPrice) {
        $highestPrice = $product['price'];
        $mostExpensive = $product['name'];
    }

    // Apply discount to items over $50
    if ($product['price'] > 50) {
        $product['price'] *= 0.85;  // 15% off
        $product['discounted'] = true;
    }
}
unset($product);

echo "=== Product Report ===\n\n";
foreach ($products as $product) {
    $status = isset($product['discounted']) ? " (15% OFF!)" : "";
    printf("%-10s: $%7.2f x %d%s\n",
        $product['name'],
        $product['price'],
        $product['qty'],
        $status
    );
}

echo "\nTotal Inventory Value: $" . number_format($totalValue, 2) . "\n";
echo "Most Expensive Item: $mostExpensive\n";
?&gt;</code></pre>
                        </details>
                    </div>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Basic:</strong> <code>foreach ($arr as $val)</code> - values only</li>
                            <li><strong>Key-Value:</strong> <code>foreach ($arr as $key => $val)</code></li>
                            <li><strong>Reference:</strong> <code>foreach ($arr as &$val)</code> - modify in place</li>
                            <li><strong>Always unset:</strong> Call <code>unset($val)</code> after reference loops</li>
                            <li><strong>Best for:</strong> Arrays and objects of any structure</li>
                            <li><strong>Readable:</strong> More intuitive than for loops for collections</li>
                            <li><strong>Alternative:</strong> <code>foreach: ... endforeach;</code> for templates</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>You've learned all PHP loop types! Now let's master <strong>Loop Control</strong> with
                        <code>break</code> and <code>continue</code> to precisely control loop execution!</p>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="loops-for.jsp" />
                    <jsp:param name="prevTitle" value="For Loops" />
                    <jsp:param name="nextLink" value="loops-control.jsp" />
                    <jsp:param name="nextTitle" value="Loop Control" />
                    <jsp:param name="currentLessonId" value="loops-foreach" />
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
