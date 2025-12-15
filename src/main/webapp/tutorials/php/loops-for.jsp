<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-for");
   request.setAttribute("currentModule", "Control Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP For Loops - PHP Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn PHP for loops including syntax, iteration, step values, and nested loops. Master counted loops with practical examples.">
    <meta name="keywords"
        content="php for loop, php nested loop, php iteration, php loop syntax, php counting loop">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php/loops-for.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP For Loops","description":"Learn PHP for loops including syntax, nested loops, and iteration patterns","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP for loop","Loop syntax","Nested loops","Iteration patterns"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="loops-for">
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
                    <span>For Loops</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">PHP For Loops</h1>
                    <div class="lesson-meta"><span>Beginner</span><span>~25 min read</span></div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">The <code>for</code> loop is perfect when you know exactly how many times you need to
                        iterate. With initialization, condition, and increment all in one place, it's the cleanest way
                        to write counted loops.</p>

                    <h2>For Loop Syntax</h2>
                    <p>A for loop has three expressions in its header:</p>

                    <pre><code class="language-php">&lt;?php
for (initialization; condition; increment) {
    // Code to repeat
}
?&gt;</code></pre>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Part</th>
                                <th>Purpose</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Initialization</td>
                                <td>Set up loop variable (runs once)</td>
                                <td><code>$i = 0</code></td>
                            </tr>
                            <tr>
                                <td>Condition</td>
                                <td>Check before each iteration</td>
                                <td><code>$i < 10</code></td>
                            </tr>
                            <tr>
                                <td>Increment</td>
                                <td>Update after each iteration</td>
                                <td><code>$i++</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/loops-for.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-for" />
                    </jsp:include>

                    <h2>Loop Execution Flow</h2>
                    <p>Here's exactly what happens when a for loop runs:</p>

                    <pre><code class="language-php">&lt;?php
// for ($i = 1; $i <= 3; $i++)

// Step 1: $i = 1 (initialization - runs once)
// Step 2: Is $i <= 3? (1 <= 3? Yes!) → Execute body → Print "1"
// Step 3: $i++ ($i becomes 2)
// Step 4: Is $i <= 3? (2 <= 3? Yes!) → Execute body → Print "2"
// Step 5: $i++ ($i becomes 3)
// Step 6: Is $i <= 3? (3 <= 3? Yes!) → Execute body → Print "3"
// Step 7: $i++ ($i becomes 4)
// Step 8: Is $i <= 3? (4 <= 3? No!) → Exit loop

for ($i = 1; $i <= 3; $i++) {
    echo $i . "\n";
}
// Output: 1, 2, 3
?&gt;</code></pre>

                    <h2>Common Patterns</h2>

                    <h3>Counting Up (most common)</h3>
                    <pre><code class="language-php">&lt;?php
// Count from 1 to 10
for ($i = 1; $i <= 10; $i++) {
    echo "$i ";
}
// Output: 1 2 3 4 5 6 7 8 9 10
?&gt;</code></pre>

                    <h3>Counting Down</h3>
                    <pre><code class="language-php">&lt;?php
// Count from 10 to 1
for ($i = 10; $i >= 1; $i--) {
    echo "$i ";
}
// Output: 10 9 8 7 6 5 4 3 2 1
?&gt;</code></pre>

                    <h3>Custom Step Values</h3>
                    <pre><code class="language-php">&lt;?php
// Step by 2 (even numbers)
for ($i = 0; $i <= 10; $i += 2) {
    echo "$i ";
}
// Output: 0 2 4 6 8 10

// Step by 5
for ($i = 0; $i <= 100; $i += 5) {
    echo "$i ";
}
// Output: 0 5 10 15 ... 95 100
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Array Iteration:</strong> When iterating arrays, use <code>$i < count($array)</code>
                        (not <code><=</code>) since array indices start at 0. Better yet, use <code>foreach</code>
                        for arrays!
                    </div>

                    <h2>Iterating Arrays with For</h2>

                    <pre><code class="language-php">&lt;?php
$fruits = ["Apple", "Banana", "Cherry", "Date"];

// Traditional for loop with array
for ($i = 0; $i < count($fruits); $i++) {
    echo ($i + 1) . ". " . $fruits[$i] . "\n";
}

// Output:
// 1. Apple
// 2. Banana
// 3. Cherry
// 4. Date

// Optimization: Cache count() outside loop
$length = count($fruits);
for ($i = 0; $i < $length; $i++) {
    // ...
}
?&gt;</code></pre>

                    <div class="info-box">
                        <strong>Performance Tip:</strong> Store <code>count($array)</code> in a variable before the loop.
                        Otherwise, PHP recalculates it on every iteration.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Nested For Loops</h2>
                    <p>Place one loop inside another for multi-dimensional iterations:</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/loops-nested.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-nested" />
                    </jsp:include>

                    <h2>Multiple Variables</h2>
                    <p>You can use multiple variables in a for loop:</p>

                    <pre><code class="language-php">&lt;?php
// Two counters moving in opposite directions
for ($left = 0, $right = 4; $left < $right; $left++, $right--) {
    echo "left: $left, right: $right\n";
}
// Output:
// left: 0, right: 4
// left: 1, right: 3

// Parallel arrays
$names = ["Alice", "Bob", "Carol"];
$ages = [25, 30, 28];
$len = count($names);

for ($i = 0; $i < $len; $i++) {
    echo "{$names[$i]} is {$ages[$i]} years old.\n";
}
?&gt;</code></pre>

                    <h2>Optional Expressions</h2>
                    <p>All three expressions in a for loop are optional:</p>

                    <pre><code class="language-php">&lt;?php
// External initialization
$i = 0;
for (; $i < 5; $i++) {
    echo $i;
}

// External increment
for ($i = 0; $i < 5;) {
    echo $i;
    $i++;
}

// Infinite loop (use break to exit)
for (;;) {
    // Must use break or return to exit!
    break;
}
?&gt;</code></pre>

                    <h2>Alternative Syntax</h2>
                    <p>For use in templates:</p>

                    <pre><code class="language-php">&lt;?php $items = ["Home", "About", "Contact"]; ?&gt;

&lt;ul&gt;
&lt;?php for ($i = 0; $i < count($items); $i++): ?&gt;
    &lt;li&gt;&lt;?= $items[$i] ?&gt;&lt;/li&gt;
&lt;?php endfor; ?&gt;
&lt;/ul&gt;</code></pre>

                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Off-by-one errors with arrays</h4>
                        <pre><code class="language-php">&lt;?php
$arr = [1, 2, 3, 4, 5];  // Indices: 0, 1, 2, 3, 4

// ❌ WRONG: <= includes index 5 which doesn't exist
for ($i = 0; $i <= count($arr); $i++) {
    echo $arr[$i];  // Error on last iteration!
}

// ✅ CORRECT: Use < for zero-indexed arrays
for ($i = 0; $i < count($arr); $i++) {
    echo $arr[$i];
}
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Modifying loop variable incorrectly</h4>
                        <pre><code class="language-php">&lt;?php
// ❌ WRONG: Unpredictable behavior
for ($i = 0; $i < 10; $i++) {
    if ($i === 5) {
        $i = 8;  // Don't modify inside loop!
    }
    echo $i;
}

// ✅ CORRECT: Use continue or break instead
for ($i = 0; $i < 10; $i++) {
    if ($i === 5) {
        continue;  // Skip this iteration
    }
    echo $i;
}
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Calling count() in condition</h4>
                        <pre><code class="language-php">&lt;?php
$bigArray = range(1, 10000);

// ❌ SLOW: count() called 10,000 times
for ($i = 0; $i < count($bigArray); $i++) {
    // ...
}

// ✅ FAST: count() called once
$length = count($bigArray);
for ($i = 0; $i < $length; $i++) {
    // ...
}
?&gt;</code></pre>
                    </div>

                    <div class="warning-box">
                        <strong>When to Use For vs Foreach:</strong>
                        <ul>
                            <li>Use <code>for</code> when you need the index or specific iteration count</li>
                            <li>Use <code>foreach</code> when you just need to iterate all elements (next lesson!)</li>
                            <li>Use <code>while</code> when iterations depend on runtime conditions</li>
                        </ul>
                    </div>

                    <h2>Exercise: Pattern Generator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a diamond pattern using nested for loops.</p>
                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Accept a size parameter (e.g., 5)</li>
                            <li>Print a diamond shape using asterisks</li>
                            <li>Center each row properly with spaces</li>
                        </ul>
                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-php">&lt;?php
$size = 5;

// Upper half (including middle)
for ($i = 1; $i <= $size; $i++) {
    // Print spaces
    for ($s = $size - $i; $s > 0; $s--) {
        echo " ";
    }
    // Print stars
    for ($j = 1; $j <= (2 * $i - 1); $j++) {
        echo "*";
    }
    echo "\n";
}

// Lower half
for ($i = $size - 1; $i >= 1; $i--) {
    // Print spaces
    for ($s = $size - $i; $s > 0; $s--) {
        echo " ";
    }
    // Print stars
    for ($j = 1; $j <= (2 * $i - 1); $j++) {
        echo "*";
    }
    echo "\n";
}

/* Output (size=5):
    *
   ***
  *****
 *******
*********
 *******
  *****
   ***
    *
*/
?&gt;</code></pre>
                        </details>
                    </div>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Syntax:</strong> <code>for (init; condition; increment)</code></li>
                            <li><strong>Initialization:</strong> Runs once before the loop starts</li>
                            <li><strong>Condition:</strong> Checked before each iteration</li>
                            <li><strong>Increment:</strong> Runs after each iteration</li>
                            <li><strong>Count up:</strong> <code>$i++</code> or <code>$i += step</code></li>
                            <li><strong>Count down:</strong> <code>$i--</code> or <code>$i -= step</code></li>
                            <li><strong>Nested loops:</strong> Use different variables (<code>$i</code>, <code>$j</code>, <code>$k</code>)</li>
                            <li><strong>Arrays:</strong> Use <code>< count()</code>, not <code><=</code></li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>For loops are great for indexed access, but PHP has an even better way to iterate arrays.
                        Let's explore <strong>Foreach Loops</strong> - designed specifically for arrays and objects!</p>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="loops-while.jsp" />
                    <jsp:param name="prevTitle" value="While Loops" />
                    <jsp:param name="nextLink" value="loops-foreach.jsp" />
                    <jsp:param name="nextTitle" value="Foreach Loops" />
                    <jsp:param name="currentLessonId" value="loops-for" />
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
