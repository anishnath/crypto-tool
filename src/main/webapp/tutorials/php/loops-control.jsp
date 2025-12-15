<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-control");
   request.setAttribute("currentModule", "Control Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Loop Control - PHP Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn PHP break and continue statements to control loop execution. Master loop levels and practical flow control patterns.">
    <meta name="keywords"
        content="php break, php continue, php loop control, php break levels, php nested loop control">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php/loops-control.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Loop Control","description":"Learn PHP break and continue statements for controlling loop execution","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP break","PHP continue","Loop levels","Flow control"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="loops-control">
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
                    <span>Loop Control</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">PHP Loop Control</h1>
                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">Sometimes you need to exit a loop early or skip certain iterations. PHP provides
                        <code>break</code> and <code>continue</code> statements for precise control over loop execution,
                        including the ability to break out of multiple nested loops at once.</p>

                    <h2>Break Statement</h2>
                    <p><code>break</code> immediately exits the loop, skipping all remaining iterations:</p>

                    <pre><code class="language-php">&lt;?php
// Find first match and stop
$numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

foreach ($numbers as $num) {
    if ($num === 5) {
        echo "Found 5!";
        break;  // Exit loop immediately
    }
    echo "$num ";
}
// Output: 1 2 3 4 Found 5!
?&gt;</code></pre>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Statement</th>
                                <th>Effect</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>break</code></td>
                                <td>Exit the current loop immediately</td>
                            </tr>
                            <tr>
                                <td><code>break 1</code></td>
                                <td>Same as <code>break</code></td>
                            </tr>
                            <tr>
                                <td><code>break 2</code></td>
                                <td>Exit two nested loops</td>
                            </tr>
                            <tr>
                                <td><code>break n</code></td>
                                <td>Exit n levels of nesting</td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/loops-control.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-control" />
                    </jsp:include>

                    <h2>Continue Statement</h2>
                    <p><code>continue</code> skips the rest of the current iteration and moves to the next:</p>

                    <pre><code class="language-php">&lt;?php
// Print only odd numbers
for ($i = 1; $i <= 10; $i++) {
    if ($i % 2 === 0) {
        continue;  // Skip even numbers
    }
    echo "$i ";
}
// Output: 1 3 5 7 9

// Skip specific values
$items = ["apple", "SKIP", "banana", "SKIP", "cherry"];
foreach ($items as $item) {
    if ($item === "SKIP") {
        continue;
    }
    echo "$item ";
}
// Output: apple banana cherry
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Difference:</strong>
                        <ul>
                            <li><code>break</code> = "I'm done with this loop entirely"</li>
                            <li><code>continue</code> = "Skip this one, try the next"</li>
                        </ul>
                    </div>

                    <h2>Break in Nested Loops</h2>
                    <p>By default, <code>break</code> only exits the innermost loop. Use levels to break out of multiple loops:</p>

                    <pre><code class="language-php">&lt;?php
// Without level - only exits inner loop
for ($i = 1; $i <= 3; $i++) {
    for ($j = 1; $j <= 3; $j++) {
        if ($j === 2) {
            break;  // Only exits inner loop
        }
        echo "($i,$j) ";
    }
    echo "| ";
}
// Output: (1,1) | (2,1) | (3,1) |

// With level 2 - exits both loops
for ($i = 1; $i <= 3; $i++) {
    for ($j = 1; $j <= 3; $j++) {
        if ($i === 2 && $j === 2) {
            echo "Breaking out completely!";
            break 2;  // Exits BOTH loops
        }
        echo "($i,$j) ";
    }
}
// Output: (1,1) (1,2) (1,3) (2,1) Breaking out completely!
?&gt;</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Break and Continue Levels</h2>
                    <p>Both statements accept a level number for nested loop control:</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/loops-break-levels.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-levels" />
                    </jsp:include>

                    <h2>Continue with Levels</h2>
                    <pre><code class="language-php">&lt;?php
// Skip entire row if condition met
$data = [
    [1, 2, 3],
    [4, -1, 6],  // Contains negative
    [7, 8, 9]
];

foreach ($data as $row) {
    foreach ($row as $val) {
        if ($val < 0) {
            echo "(skip row) ";
            continue 2;  // Skip to next outer iteration
        }
        echo "$val ";
    }
    echo "| ";
}
// Output: 1 2 3 | (skip row) 7 8 9 |
?&gt;</code></pre>

                    <h2>Break in Switch Within Loop</h2>
                    <p>Remember: <code>break</code> in a switch only exits the switch, not the surrounding loop:</p>

                    <pre><code class="language-php">&lt;?php
$commands = ["run", "stop", "run", "exit"];

foreach ($commands as $cmd) {
    switch ($cmd) {
        case "run":
            echo "Running... ";
            break;  // Exits switch only, loop continues
        case "stop":
            echo "Stopped. ";
            break;  // Exits switch only
        case "exit":
            echo "Exiting!";
            break 2;  // Exits switch AND foreach loop
    }
}
// Output: Running... Stopped. Running... Exiting!
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> Using high level numbers (like <code>break 5</code>) is a code smell.
                        If you need to break out of many nested loops, consider refactoring into a function and using
                        <code>return</code> instead.
                    </div>

                    <h2>Practical Patterns</h2>

                    <h3>Early Exit Pattern</h3>
                    <pre><code class="language-php">&lt;?php
function findUser($users, $id) {
    foreach ($users as $user) {
        if ($user['id'] === $id) {
            return $user;  // Found! Exit function
        }
    }
    return null;  // Not found
}
?&gt;</code></pre>

                    <h3>Skip Invalid Items</h3>
                    <pre><code class="language-php">&lt;?php
$items = [10, null, 20, "", 30, false, 40];
$sum = 0;

foreach ($items as $item) {
    if (!is_numeric($item)) {
        continue;  // Skip non-numeric values
    }
    $sum += $item;
}
echo "Sum: $sum";  // Sum: 100
?&gt;</code></pre>

                    <h3>Limited Processing</h3>
                    <pre><code class="language-php">&lt;?php
$records = getLotsOfRecords();
$processed = 0;
$limit = 100;

foreach ($records as $record) {
    processRecord($record);
    $processed++;

    if ($processed >= $limit) {
        echo "Processed $limit records. Stopping.";
        break;
    }
}
?&gt;</code></pre>

                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using break instead of continue</h4>
                        <pre><code class="language-php">&lt;?php
$numbers = [1, 2, 3, 4, 5];

// ❌ WRONG: Stops at first even number
foreach ($numbers as $num) {
    if ($num % 2 === 0) {
        break;  // Exits entire loop!
    }
    echo $num;
}
// Output: 1

// ✅ CORRECT: Skips even numbers, continues loop
foreach ($numbers as $num) {
    if ($num % 2 === 0) {
        continue;  // Skip to next iteration
    }
    echo $num;
}
// Output: 135
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Wrong level number</h4>
                        <pre><code class="language-php">&lt;?php
// ❌ WRONG: break 3 when only 2 loops exist
for ($i = 0; $i < 3; $i++) {
    for ($j = 0; $j < 3; $j++) {
        if ($condition) {
            break 3;  // Error: Cannot break 3 levels!
        }
    }
}

// ✅ CORRECT: Use appropriate level
for ($i = 0; $i < 3; $i++) {
    for ($j = 0; $j < 3; $j++) {
        if ($condition) {
            break 2;  // Exit both loops
        }
    }
}
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting switch counts as a level</h4>
                        <pre><code class="language-php">&lt;?php
// ❌ WRONG: break 1 only exits switch
foreach ($items as $item) {
    switch ($item) {
        case "exit":
            break;  // Only exits switch!
    }
    echo "Still in loop\n";  // This runs!
}

// ✅ CORRECT: break 2 exits switch AND loop
foreach ($items as $item) {
    switch ($item) {
        case "exit":
            break 2;  // Exits switch and foreach
    }
}
?&gt;</code></pre>
                    </div>

                    <h2>Exercise: Data Validator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Process a batch of user registrations with validation.</p>
                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Skip users with empty email</li>
                            <li>Skip users under 18 years old</li>
                            <li>Stop processing if you find a banned email domain</li>
                            <li>Count valid registrations</li>
                        </ul>
                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-php">&lt;?php
$registrations = [
    ["name" => "Alice", "email" => "alice@gmail.com", "age" => 25],
    ["name" => "Bob", "email" => "", "age" => 30],  // Empty email
    ["name" => "Carol", "email" => "carol@yahoo.com", "age" => 16],  // Under 18
    ["name" => "David", "email" => "david@spam.com", "age" => 28],  // Banned domain!
    ["name" => "Eve", "email" => "eve@gmail.com", "age" => 22]
];

$bannedDomains = ["spam.com", "fake.com", "temp.com"];
$validCount = 0;

foreach ($registrations as $user) {
    // Skip empty email
    if (empty($user['email'])) {
        echo "Skipping {$user['name']}: No email\n";
        continue;
    }

    // Skip underage
    if ($user['age'] < 18) {
        echo "Skipping {$user['name']}: Under 18\n";
        continue;
    }

    // Check for banned domain
    $emailDomain = substr($user['email'], strpos($user['email'], '@') + 1);
    if (in_array($emailDomain, $bannedDomains)) {
        echo "ALERT: Banned domain detected ({$emailDomain})!\n";
        echo "Stopping all processing.\n";
        break;
    }

    // Valid registration
    echo "Registered: {$user['name']} ({$user['email']})\n";
    $validCount++;
}

echo "\nTotal valid registrations: $validCount\n";
?&gt;</code></pre>
                        </details>
                    </div>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>break:</strong> Exit the loop completely</li>
                            <li><strong>continue:</strong> Skip current iteration, continue to next</li>
                            <li><strong>break n:</strong> Exit n levels of nested loops</li>
                            <li><strong>continue n:</strong> Skip to next iteration of nth outer loop</li>
                            <li><strong>switch:</strong> Counts as a level for break/continue</li>
                            <li><strong>Best practice:</strong> Avoid high level numbers; refactor instead</li>
                            <li><strong>Alternative:</strong> Use <code>return</code> in functions for cleaner exits</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations! You've mastered PHP control structures - conditions, switches, and all types
                        of loops! Next, we'll learn about <strong>Functions</strong> - reusable blocks of code that
                        make your programs modular and maintainable.</p>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="loops-foreach.jsp" />
                    <jsp:param name="prevTitle" value="Foreach Loops" />
                    <jsp:param name="nextLink" value="functions-basics.jsp" />
                    <jsp:param name="nextTitle" value="Defining Functions" />
                    <jsp:param name="currentLessonId" value="loops-control" />
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
