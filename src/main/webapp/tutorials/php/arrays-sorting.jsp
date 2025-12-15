<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "arrays-sorting" ); request.setAttribute("currentModule", "Arrays" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Array Sorting - sort, usort, Custom Comparisons | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP array sorting with sort(), rsort(), asort(), ksort(), usort(), and custom comparison functions. Learn to sort indexed and associative arrays effectively.">
            <meta name="keywords"
                content="PHP sort, PHP array sorting, usort PHP, asort PHP, ksort PHP, custom sort PHP, array_multisort, PHP tutorial">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/arrays-sorting.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Array Sorting","description":"Learn PHP array sorting with sort(), rsort(), asort(), ksort(), usort(), and custom comparison functions","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP sort function","Associative array sorting","Custom comparisons","usort function","array_multisort"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="arrays-sorting">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-php.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <!-- Breadcrumb -->
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb" itemscope itemtype="https://schema.org/BreadcrumbList">
                                        <li class="breadcrumb-item" itemprop="itemListElement" itemscope
                                            itemtype="https://schema.org/ListItem">
                                            <a href="/tutorials/php/" itemprop="item"><span itemprop="name">PHP
                                                    Tutorial</span></a>
                                            <meta itemprop="position" content="1" />
                                        </li>
                                        <li class="breadcrumb-item" itemprop="itemListElement" itemscope
                                            itemtype="https://schema.org/ListItem">
                                            <a href="/tutorials/php/arrays-basics.jsp" itemprop="item"><span
                                                    itemprop="name">Arrays</span></a>
                                            <meta itemprop="position" content="2" />
                                        </li>
                                        <li class="breadcrumb-item active" aria-current="page"
                                            itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem">
                                            <span itemprop="name">Array Sorting</span>
                                            <meta itemprop="position" content="3" />
                                        </li>
                                    </ol>
                                </nav>

                                <article>
                                    <header>
                                        <h1>PHP Array Sorting</h1>
                                        <p class="lesson-meta">Module 6: Arrays | Lesson 6 of 6</p>
                                    </header>

                                    <p class="lead">
                                        PHP provides a rich set of sorting functions for both indexed and associative
                                        arrays.
                                        Understanding
                                        when to use each function and how to create custom sorting logic is essential
                                        for
                                        organizing
                                        and presenting data effectively.
                                    </p>

                                    <!-- Basic Sorting Functions -->
                                    <section>
                                        <h2 id="basic-sorting">Basic Sorting Functions</h2>
                                        <p>
                                            PHP's basic sorting functions work on indexed arrays and <strong>modify the
                                                original
                                                array</strong>.
                                            All sorting functions return <code>true</code> on success.
                                        </p>

                                        <table class="info-table">
                                            <thead>
                                                <tr>
                                                    <th>Function</th>
                                                    <th>Description</th>
                                                    <th>Key Behavior</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><code>sort()</code></td>
                                                    <td>Sort ascending</td>
                                                    <td>Reindexes keys (0, 1, 2...)</td>
                                                </tr>
                                                <tr>
                                                    <td><code>rsort()</code></td>
                                                    <td>Sort descending</td>
                                                    <td>Reindexes keys (0, 1, 2...)</td>
                                                </tr>
                                                <tr>
                                                    <td><code>shuffle()</code></td>
                                                    <td>Randomize order</td>
                                                    <td>Reindexes keys (0, 1, 2...)</td>
                                                </tr>
                                                <tr>
                                                    <td><code>array_reverse()</code></td>
                                                    <td>Reverse order</td>
                                                    <td>Returns new array</td>
                                                </tr>
                                            </tbody>
                                        </table>

                                        <pre><code class="language-php">&lt;?php
// sort() - Ascending order
$numbers = [3, 1, 4, 1, 5, 9, 2, 6];
sort($numbers);
print_r($numbers);
// Output: [1, 1, 2, 3, 4, 5, 6, 9]

// rsort() - Descending order
$letters = ["c", "a", "b", "d"];
rsort($letters);
print_r($letters);
// Output: ["d", "c", "b", "a"]

// shuffle() - Random order
$cards = ["Ace", "King", "Queen", "Jack"];
shuffle($cards);
print_r($cards);
// Output: Random order each time
?&gt;</code></pre>
                                    </section>

                                    <!-- Sorting Flags -->
                                    <section>
                                        <h2 id="sorting-flags">Sorting Flags</h2>
                                        <p>
                                            PHP sorting functions accept optional flags that control how values are
                                            compared.
                                            This is especially important when sorting mixed data types.
                                        </p>

                                        <table class="info-table">
                                            <thead>
                                                <tr>
                                                    <th>Flag</th>
                                                    <th>Description</th>
                                                    <th>Use Case</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><code>SORT_REGULAR</code></td>
                                                    <td>Compare items normally (default)</td>
                                                    <td>General purpose</td>
                                                </tr>
                                                <tr>
                                                    <td><code>SORT_NUMERIC</code></td>
                                                    <td>Compare items numerically</td>
                                                    <td>Numbers as strings</td>
                                                </tr>
                                                <tr>
                                                    <td><code>SORT_STRING</code></td>
                                                    <td>Compare items as strings</td>
                                                    <td>Force string comparison</td>
                                                </tr>
                                                <tr>
                                                    <td><code>SORT_NATURAL</code></td>
                                                    <td>Natural order like humans read</td>
                                                    <td>"img2" before "img10"</td>
                                                </tr>
                                                <tr>
                                                    <td><code>SORT_FLAG_CASE</code></td>
                                                    <td>Case-insensitive (combine with SORT_STRING)</td>
                                                    <td>"Apple" with "banana"</td>
                                                </tr>
                                            </tbody>
                                        </table>

                                        <pre><code class="language-php">&lt;?php
// Problem: String sorting of numbers
$versions = ["img1", "img10", "img2", "img21", "img3"];

sort($versions);  // Regular sort
print_r($versions);
// Wrong: ["img1", "img10", "img2", "img21", "img3"]

sort($versions, SORT_NATURAL);  // Natural sort
print_r($versions);
// Correct: ["img1", "img2", "img3", "img10", "img21"]

// Case-insensitive string sort
$names = ["alice", "Bob", "CAROL", "david"];
sort($names, SORT_STRING | SORT_FLAG_CASE);
print_r($names);
// Output: ["alice", "Bob", "CAROL", "david"]
?&gt;</code></pre>

                                        <div class="tip-box">
                                            <strong>Tip:</strong> Use <code>SORT_NATURAL</code> for file names, version
                                            numbers,
                                            or any
                                            data where humans expect "2" to come before "10".
                                        </div>
                                    </section>

                                    <!-- Associative Array Sorting -->
                                    <section>
                                        <h2 id="associative-sorting">Associative Array Sorting</h2>
                                        <p>
                                            When sorting associative arrays, you often want to <strong>preserve
                                                key-value
                                                relationships</strong>.
                                            PHP provides specialized functions for this purpose.
                                        </p>

                                        <table class="info-table">
                                            <thead>
                                                <tr>
                                                    <th>Function</th>
                                                    <th>Sorts By</th>
                                                    <th>Order</th>
                                                    <th>Keys</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><code>asort()</code></td>
                                                    <td>Value</td>
                                                    <td>Ascending</td>
                                                    <td>Preserved</td>
                                                </tr>
                                                <tr>
                                                    <td><code>arsort()</code></td>
                                                    <td>Value</td>
                                                    <td>Descending</td>
                                                    <td>Preserved</td>
                                                </tr>
                                                <tr>
                                                    <td><code>ksort()</code></td>
                                                    <td>Key</td>
                                                    <td>Ascending</td>
                                                    <td>Preserved</td>
                                                </tr>
                                                <tr>
                                                    <td><code>krsort()</code></td>
                                                    <td>Key</td>
                                                    <td>Descending</td>
                                                    <td>Preserved</td>
                                                </tr>
                                            </tbody>
                                        </table>

                                        <pre><code class="language-php">&lt;?php
$scores = [
    "Alice" => 85,
    "Bob" => 92,
    "Carol" => 78,
    "David" => 95
];

// Sort by score (value), ascending - preserve keys
asort($scores);
print_r($scores);
// Output: Carol=>78, Alice=>85, Bob=>92, David=>95

// Sort by score (value), descending
arsort($scores);
print_r($scores);
// Output: David=>95, Bob=>92, Alice=>85, Carol=>78

// Sort by name (key), ascending
ksort($scores);
print_r($scores);
// Output: Alice=>85, Bob=>92, Carol=>78, David=>95

// Sort by name (key), descending
krsort($scores);
print_r($scores);
// Output: David=>95, Carol=>78, Bob=>92, Alice=>85
?&gt;</code></pre>

                                        <div class="warning-box">
                                            <strong>Warning:</strong> Using <code>sort()</code> on an associative array
                                            will
                                            <strong>destroy all keys</strong> and reindex with numbers. Always use
                                            <code>asort()</code> or <code>arsort()</code> to preserve keys.
                                        </div>
                                    </section>

                                    <!-- Custom Sorting with usort -->
                                    <section>
                                        <h2 id="custom-sorting">Custom Sorting with usort()</h2>
                                        <p>
                                            When built-in sorting isn't enough, <code>usort()</code> lets you define
                                            custom
                                            comparison logic using a callback function.
                                        </p>

                                        <h3>Comparison Function Rules</h3>
                                        <p>Your comparison function must return:</p>
                                        <ul>
                                            <li><strong>Negative integer</strong>: if $a should come before $b</li>
                                            <li><strong>Zero</strong>: if $a equals $b</li>
                                            <li><strong>Positive integer</strong>: if $a should come after $b</li>
                                        </ul>

                                        <table class="info-table">
                                            <thead>
                                                <tr>
                                                    <th>Function</th>
                                                    <th>Description</th>
                                                    <th>Keys</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><code>usort()</code></td>
                                                    <td>Custom sort by value</td>
                                                    <td>Reindexed</td>
                                                </tr>
                                                <tr>
                                                    <td><code>uasort()</code></td>
                                                    <td>Custom sort by value</td>
                                                    <td>Preserved</td>
                                                </tr>
                                                <tr>
                                                    <td><code>uksort()</code></td>
                                                    <td>Custom sort by key</td>
                                                    <td>Preserved</td>
                                                </tr>
                                            </tbody>
                                        </table>

                                        <pre><code class="language-php">&lt;?php
// Sort products by price
$products = [
    ["name" => "Widget", "price" => 29.99],
    ["name" => "Gadget", "price" => 49.99],
    ["name" => "Gizmo", "price" => 19.99]
];

usort($products, function($a, $b) {
    return $a["price"] <=> $b["price"];  // Spaceship operator
});

foreach ($products as $p) {
    echo "{$p['name']}: \${$p['price']}\n";
}
// Output: Gizmo: $19.99, Widget: $29.99, Gadget: $49.99

// Using arrow function (PHP 7.4+)
usort($products, fn($a, $b) => $b["price"] <=> $a["price"]);  // Descending
?&gt;</code></pre>

                                        <h3>The Spaceship Operator (&lt;=&gt;)</h3>
                                        <p>
                                            PHP 7 introduced the spaceship operator, which simplifies comparison
                                            functions by
                                            returning -1, 0, or 1 automatically.
                                        </p>

                                        <pre><code class="language-php">&lt;?php
// Without spaceship operator (old way)
function compare($a, $b) {
    if ($a < $b) return -1;
    if ($a > $b) return 1;
    return 0;
}

// With spaceship operator (modern way)
function compare($a, $b) {
    return $a <=> $b;
}

// Examples
echo 1 <=> 2;   // -1 (1 is less than 2)
echo 2 <=> 2;   //  0 (equal)
echo 3 <=> 2;   //  1 (3 is greater than 2)

// Works with strings too
echo "apple" <=> "banana";  // -1
?&gt;</code></pre>

                                        <div class="tip-box">
                                            <strong>Tip:</strong> To sort in descending order, simply swap
                                            <code>$a</code> and
                                            <code>$b</code>
                                            in the comparison: <code>$b &lt;=&gt; $a</code>
                                        </div>
                                    </section>

                                    <!-- Multi-field Sorting -->
                                    <section>
                                        <h2 id="multi-field">Multi-field Sorting</h2>
                                        <p>
                                            Often you need to sort by multiple criteria - for example, sort by last
                                            name,
                                            then by first name when last names are equal.
                                        </p>

                                        <pre><code class="language-php">&lt;?php
$employees = [
    ["last" => "Smith", "first" => "John", "age" => 30],
    ["last" => "Smith", "first" => "Alice", "age" => 25],
    ["last" => "Jones", "first" => "Bob", "age" => 35],
    ["last" => "Smith", "first" => "Bob", "age" => 28]
];

// Sort by last name, then first name
usort($employees, function($a, $b) {
    // First compare last names
    $lastCmp = $a["last"] <=> $b["last"];
    if ($lastCmp !== 0) {
        return $lastCmp;
    }
    // If last names equal, compare first names
    return $a["first"] <=> $b["first"];
});

foreach ($employees as $e) {
    echo "{$e['last']}, {$e['first']}\n";
}
// Output:
// Jones, Bob
// Smith, Alice
// Smith, Bob
// Smith, John

// Compact version with null coalescing-like pattern
usort($employees, fn($a, $b) =>
    ($a["last"] <=> $b["last"]) ?: ($a["first"] <=> $b["first"])
);
?&gt;</code></pre>

                                        <div class="info-box">
                                            <strong>How it works:</strong> The <code>?:</code> operator (Elvis operator)
                                            returns
                                            the
                                            left side if it's truthy (non-zero), otherwise the right side. Since 0 is
                                            falsy,
                                            it falls through to the next comparison when values are equal.
                                        </div>
                                    </section>

                                    <!-- array_multisort -->
                                    <section>
                                        <h2 id="multisort">Sorting Multiple Arrays Together</h2>
                                        <p>
                                            <code>array_multisort()</code> sorts multiple arrays at once, or sorts a
                                            multidimensional array by one or more columns.
                                        </p>

                                        <pre><code class="language-php">&lt;?php
// Sort parallel arrays together
$names = ["Carol", "Alice", "Bob"];
$ages = [30, 25, 35];

array_multisort($names, SORT_ASC, $ages);
print_r($names);  // ["Alice", "Bob", "Carol"]
print_r($ages);   // [25, 35, 30] - ages follow their names

// Sort multidimensional array by column
$users = [
    ["name" => "Alice", "score" => 85, "time" => 120],
    ["name" => "Bob", "score" => 85, "time" => 90],
    ["name" => "Carol", "score" => 92, "time" => 100]
];

// Extract columns for sorting
$scores = array_column($users, "score");
$times = array_column($users, "time");

// Sort by score DESC, then time ASC
array_multisort(
    $scores, SORT_DESC,
    $times, SORT_ASC,
    $users
);

print_r($users);
// Carol (92, 100), Bob (85, 90), Alice (85, 120)
?&gt;</code></pre>
                                    </section>

                                    <!-- Practical Examples -->
                                    <section>
                                        <h2 id="practical">Practical Sorting Examples</h2>

                                        <h3>Sort by String Length</h3>
                                        <pre><code class="language-php">&lt;?php
$words = ["elephant", "cat", "dog", "hippopotamus", "ant"];

usort($words, fn($a, $b) => strlen($a) <=> strlen($b));
print_r($words);
// ["ant", "cat", "dog", "elephant", "hippopotamus"]
?&gt;</code></pre>

                                        <h3>Sort Dates</h3>
                                        <pre><code class="language-php">&lt;?php
$events = [
    ["name" => "Meeting", "date" => "2024-03-15"],
    ["name" => "Deadline", "date" => "2024-01-20"],
    ["name" => "Launch", "date" => "2024-02-28"]
];

usort($events, fn($a, $b) =>
    strtotime($a["date"]) <=> strtotime($b["date"])
);

foreach ($events as $e) {
    echo "{$e['date']}: {$e['name']}\n";
}
// 2024-01-20: Deadline
// 2024-02-28: Launch
// 2024-03-15: Meeting
?&gt;</code></pre>

                                        <h3>Case-Insensitive Custom Sort</h3>
                                        <pre><code class="language-php">&lt;?php
$names = ["bob", "Alice", "CAROL", "David"];

usort($names, fn($a, $b) =>
    strcasecmp($a, $b)  // Case-insensitive comparison
);
print_r($names);
// ["Alice", "bob", "CAROL", "David"]
?&gt;</code></pre>

                                        <h3>Sort by Priority (Custom Order)</h3>
                                        <pre><code class="language-php">&lt;?php
$tasks = [
    ["title" => "Fix bug", "priority" => "medium"],
    ["title" => "Deploy", "priority" => "high"],
    ["title" => "Update docs", "priority" => "low"],
    ["title" => "Code review", "priority" => "high"]
];

$priorityOrder = ["high" => 1, "medium" => 2, "low" => 3];

usort($tasks, fn($a, $b) =>
    $priorityOrder[$a["priority"]] <=> $priorityOrder[$b["priority"]]
);

foreach ($tasks as $t) {
    echo "[{$t['priority']}] {$t['title']}\n";
}
// [high] Deploy
// [high] Code review
// [medium] Fix bug
// [low] Update docs
?&gt;</code></pre>
                                    </section>

                                    <!-- Interactive Code -->
                                    <section>
                                        <h2 id="try-it">Try It Yourself</h2>
                                        <p>Experiment with PHP sorting functions in the interactive editor below.</p>

                                        <div class="code-tabs">
                                            <button class="tab-btn active" data-tab="basic">Basic Sorting</button>
                                            <button class="tab-btn" data-tab="custom">Custom Sort</button>
                                        </div>

                                        <div id="basic" class="tab-content active">
                                            <jsp:include page="../tutorial-compiler.jsp">
                                                <jsp:param name="codeFile" value="php/arrays-sorting.php" />
                                                <jsp:param name="language" value="php" />
                                                <jsp:param name="editorId" value="compiler-sorting-basic" />
                                            </jsp:include>
                                        </div>

                                        <div id="custom" class="tab-content">
                                            <jsp:include page="../tutorial-compiler.jsp">
                                                <jsp:param name="codeFile" value="php/arrays-custom-sort.php" />
                                                <jsp:param name="language" value="php" />
                                                <jsp:param name="editorId" value="compiler-sorting-custom" />
                                            </jsp:include>
                                        </div>
                                    </section>

                                    <!-- Common Mistakes -->
                                    <section>
                                        <h2 id="mistakes">Common Mistakes</h2>

                                        <div class="mistake-box">
                                            <h4>Using sort() on Associative Arrays</h4>
                                            <pre><code class="language-php">&lt;?php
// Wrong - loses keys!
$prices = ["apple" => 1.50, "banana" => 0.75];
sort($prices);
print_r($prices);  // [0 => 0.75, 1 => 1.50] - keys gone!

// Correct - preserves keys
$prices = ["apple" => 1.50, "banana" => 0.75];
asort($prices);
print_r($prices);  // ["banana" => 0.75, "apple" => 1.50]
?&gt;</code></pre>
                                        </div>

                                        <div class="mistake-box">
                                            <h4>Forgetting Sort Modifies Original Array</h4>
                                            <pre><code class="language-php">&lt;?php
$original = [3, 1, 2];

// Wrong - trying to capture return value
$sorted = sort($original);  // $sorted is true/false!

// Correct - sort modifies in place
$sorted = $original;  // Copy first if needed
sort($sorted);
// Now $original is unchanged, $sorted is sorted
?&gt;</code></pre>
                                        </div>

                                        <div class="mistake-box">
                                            <h4>Wrong Comparison Return Values</h4>
                                            <pre><code class="language-php">&lt;?php
// Wrong - returning boolean
usort($arr, fn($a, $b) => $a > $b);  // Inconsistent!

// Correct - return integer
usort($arr, fn($a, $b) => $a <=> $b);
?&gt;</code></pre>
                                        </div>
                                    </section>

                                    <!-- Exercises -->
                                    <section>
                                        <h2 id="exercises">Exercises</h2>

                                        <div class="exercise">
                                            <h4>Exercise 1: Sort Products</h4>
                                            <p>Sort an array of products by price (ascending), then by name if prices
                                                are equal.
                                            </p>
                                            <pre><code class="language-php">&lt;?php
$products = [
    ["name" => "Pen", "price" => 2.50],
    ["name" => "Notebook", "price" => 5.00],
    ["name" => "Pencil", "price" => 1.00],
    ["name" => "Eraser", "price" => 1.00]
];
// Your code here
?&gt;</code></pre>
                                            <button class="solution-toggle" onclick="toggleSolution('sol1')">Show
                                                Solution</button>
                                            <div id="sol1" class="solution">
                                                <pre><code class="language-php">&lt;?php
usort($products, fn($a, $b) =>
    ($a["price"] <=> $b["price"]) ?: ($a["name"] <=> $b["name"])
);

foreach ($products as $p) {
    echo "{$p['name']}: \${$p['price']}\n";
}
// Eraser: $1.00, Pencil: $1.00, Pen: $2.50, Notebook: $5.00
?&gt;</code></pre>
                                            </div>
                                        </div>

                                        <div class="exercise">
                                            <h4>Exercise 2: Sort by Age Groups</h4>
                                            <p>Sort users into "child" (under 18), "adult" (18-64), "senior" (65+)
                                                groups,
                                                then by name within each group.</p>
                                            <pre><code class="language-php">&lt;?php
$users = [
    ["name" => "Bob", "age" => 45],
    ["name" => "Alice", "age" => 12],
    ["name" => "Carol", "age" => 70],
    ["name" => "David", "age" => 8],
    ["name" => "Eve", "age" => 35]
];
// Your code here
?&gt;</code></pre>
                                            <button class="solution-toggle" onclick="toggleSolution('sol2')">Show
                                                Solution</button>
                                            <div id="sol2" class="solution">
                                                <pre><code class="language-php">&lt;?php
function getAgeGroup($age) {
    if ($age < 18) return 1;  // child
    if ($age < 65) return 2;  // adult
    return 3;                  // senior
}

usort($users, function($a, $b) {
    $groupCmp = getAgeGroup($a["age"]) <=> getAgeGroup($b["age"]);
    return $groupCmp ?: ($a["name"] <=> $b["name"]);
});

foreach ($users as $u) {
    echo "{$u['name']} ({$u['age']})\n";
}
// Alice (12), David (8), Bob (45), Eve (35), Carol (70)
?&gt;</code></pre>
                                            </div>
                                        </div>

                                        <div class="exercise">
                                            <h4>Exercise 3: Leaderboard Ranking</h4>
                                            <p>Create a leaderboard sorted by score (descending), then by fastest time
                                                (ascending) for ties, then by name alphabetically.</p>
                                            <pre><code class="language-php">&lt;?php
$players = [
    ["name" => "Alice", "score" => 100, "time" => 45],
    ["name" => "Bob", "score" => 100, "time" => 45],
    ["name" => "Carol", "score" => 100, "time" => 42],
    ["name" => "David", "score" => 95, "time" => 30]
];
// Your code here - Output with rank numbers
?&gt;</code></pre>
                                            <button class="solution-toggle" onclick="toggleSolution('sol3')">Show
                                                Solution</button>
                                            <div id="sol3" class="solution">
                                                <pre><code class="language-php">&lt;?php
usort($players, fn($a, $b) =>
    ($b["score"] <=> $a["score"]) ?:      // Score DESC
    ($a["time"] <=> $b["time"]) ?:         // Time ASC
    ($a["name"] <=> $b["name"])            // Name ASC
);

$rank = 1;
foreach ($players as $p) {
    echo "\#{$rank} {$p['name']} - Score: {$p['score']}, Time: {$p['time']}s\n";
    $rank++;
}
// #1 Carol - Score: 100, Time: 42s
// #2 Alice - Score: 100, Time: 45s
// #3 Bob - Score: 100, Time: 45s
// #4 David - Score: 95, Time: 30s
?&gt;</code></pre>
                                            </div>
                                        </div>
                                    </section>

                                    <!-- Summary -->
                                    <section>
                                        <div class="summary-box">
                                            <h3>Summary</h3>
                                            <ul>
                                                <li><code>sort()</code>/<code>rsort()</code> for indexed arrays -
                                                    reindexes keys
                                                </li>
                                                <li><code>asort()</code>/<code>arsort()</code> for associative arrays by
                                                    value -
                                                    preserves keys</li>
                                                <li><code>ksort()</code>/<code>krsort()</code> for associative arrays by
                                                    key
                                                </li>
                                                <li>Use <code>SORT_NATURAL</code> flag for human-friendly ordering</li>
                                                <li><code>usort()</code> for custom sorting with comparison callback
                                                </li>
                                                <li>Spaceship operator <code>&lt;=&gt;</code> simplifies comparisons
                                                </li>
                                                <li>Chain comparisons with <code>?:</code> for multi-field sorting</li>
                                                <li><code>array_multisort()</code> for sorting multiple arrays together
                                                </li>
                                            </ul>
                                        </div>
                                    </section>

                                    <!-- Navigation -->
                                    <nav class="lesson-nav">
                                        <a href="arrays-iteration.jsp" class="prev-link">
                                            <span class="arrow">&larr;</span> Previous: Array Iteration
                                        </a>
                                        <a href="functions-basics.jsp" class="next-link">
                                            Next: Functions Basics <span class="arrow">&rarr;</span>
                                        </a>
                                    </nav>
                                </article>
                    </main>
            </div>

            <%@ include file="../tutorial-footer.jsp" %>

                <script>
                    function toggleSolution(id) {
                        const sol = document.getElementById(id);
                        sol.style.display = sol.style.display === 'block' ? 'none' : 'block';
                    }

                    // Tab switching
                    document.querySelectorAll('.tab-btn').forEach(btn => {
                        btn.addEventListener('click', function () {
                            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
                            this.classList.add('active');
                            document.getElementById(this.dataset.tab).classList.add('active');
                        });
                    });
                </script>
        </body>

        </html>