<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "loops-while" ); request.setAttribute("currentModule", "Control Structures"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP While Loops - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn PHP while and do-while loops. Master condition-based iteration with practical examples and best practices.">
            <meta name="keywords" content="php while loop, php do while, php loop, php iteration, php infinite loop">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/loops-while.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP While Loops","description":"Learn PHP while and do-while loops for condition-based iteration","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP while loop","PHP do-while loop","Loop conditions","Infinite loops"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="loops-while">
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
                                    <span>While Loops</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP While Loops</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Loops let you repeat code multiple times. The <code>while</code>
                                        loop is PHP's
                                        simplest loop - it keeps executing as long as a condition remains true. Perfect
                                        when you don't
                                        know in advance how many iterations you'll need.</p>

                                    <h2>While Loop Syntax</h2>
                                    <p>The while loop checks the condition <strong>before</strong> each iteration:</p>

                                    <pre><code class="language-php">&lt;?php
while (condition) {
    // Code to repeat
    // Make sure condition eventually becomes false!
}
?&gt;</code></pre>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Step</th>
                                                <th>What Happens</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>1. Check</td>
                                                <td>Evaluate the condition</td>
                                            </tr>
                                            <tr>
                                                <td>2. Execute (if true)</td>
                                                <td>Run the code block</td>
                                            </tr>
                                            <tr>
                                                <td>3. Repeat</td>
                                                <td>Go back to step 1</td>
                                            </tr>
                                            <tr>
                                                <td>4. Exit (if false)</td>
                                                <td>Continue after the loop</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/loops-while.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-while" />
                                    </jsp:include>

                                    <h2>Basic While Loop Examples</h2>

                                    <pre><code class="language-php">&lt;?php
// Counting up
$i = 1;
while ($i <= 5) {
    echo "Number: $i\n";
    $i++;  // Don't forget this!
}

// Counting down
$countdown = 5;
while ($countdown > 0) {
    echo "$countdown... ";
    $countdown--;
}
echo "Liftoff!\n";

// Processing until empty
$queue = ["Task 1", "Task 2", "Task 3"];
while (count($queue) > 0) {
    $task = array_shift($queue);  // Remove first element
    echo "Processing: $task\n";
}
?&gt;</code></pre>

                                    <div class="tip-box">
                                        <strong>Key Rule:</strong> Always ensure the condition will eventually become
                                        <code>false</code>.
                                        Update a variable inside the loop, or use <code>break</code> to exit.
                                    </div>

                                    <h2>Do-While Loop</h2>
                                    <p>The do-while loop checks the condition <strong>after</strong> each iteration,
                                        guaranteeing at
                                        least one execution:</p>

                                    <pre><code class="language-php">&lt;?php
do {
    // Code to repeat (runs at least once)
} while (condition);  // Note the semicolon!
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/loops-do-while.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-do-while" />
                                    </jsp:include>

                                    <h2>While vs Do-While</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>while</th>
                                                <th>do-while</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Condition check</td>
                                                <td>Before loop body</td>
                                                <td>After loop body</td>
                                            </tr>
                                            <tr>
                                                <td>Minimum iterations</td>
                                                <td>0 (may never run)</td>
                                                <td>1 (always runs once)</td>
                                            </tr>
                                            <tr>
                                                <td>Use when</td>
                                                <td>May not need to run at all</td>
                                                <td>Must run at least once</td>
                                            </tr>
                                            <tr>
                                                <td>Syntax ending</td>
                                                <td><code>}</code></td>
                                                <td><code>} while (...);</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-php">&lt;?php
$value = 100;

// While: Won't execute (condition false initially)
while ($value < 10) {
    echo "While: $value\n";
    $value++;
}

// Do-while: Executes once despite false condition
do {
    echo "Do-while: $value\n";
    $value++;
} while ($value < 10);
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Practical Use Cases</h2>

                                    <h3>Reading File Lines</h3>
                                    <pre><code class="language-php">&lt;?php
$file = fopen("data.txt", "r");
while (($line = fgets($file)) !== false) {
    echo $line;
}
fclose($file);
?&gt;</code></pre>

                                    <h3>Database Result Processing</h3>
                                    <pre><code class="language-php">&lt;?php
$result = $mysqli->query("SELECT name FROM users");
while ($row = $result->fetch_assoc()) {
    echo "User: " . $row['name'] . "\n";
}
?&gt;</code></pre>

                                    <h3>Retry Logic with Backoff</h3>
                                    <pre><code class="language-php">&lt;?php
$maxRetries = 3;
$attempt = 0;
$success = false;

while ($attempt < $maxRetries && !$success) {
    $attempt++;
    echo "Attempt $attempt... ";

    // Simulate operation that might fail
    $success = (rand(1, 3) === 1);

    if ($success) {
        echo "Success!\n";
    } else {
        echo "Failed. Retrying...\n";
        sleep(1);  // Wait before retry
    }
}

if (!$success) {
    echo "All $maxRetries attempts failed.\n";
}
?&gt;</code></pre>

                                    <h2>Infinite Loops</h2>
                                    <p>Sometimes you intentionally want an infinite loop, exiting with
                                        <code>break</code>:</p>

                                    <pre><code class="language-php">&lt;?php
// Infinite loop pattern
while (true) {
    $input = readline("Enter command (quit to exit): ");

    if ($input === "quit") {
        break;  // Exit the loop
    }

    echo "You entered: $input\n";
}

echo "Goodbye!\n";
?&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Danger:</strong> Accidental infinite loops will hang your script! Always
                                        ensure:
                                        <ul>
                                            <li>The loop variable is modified inside the loop</li>
                                            <li>There's a <code>break</code> condition that can be reached</li>
                                            <li>Set <code>max_execution_time</code> in production to prevent runaway
                                                scripts</li>
                                        </ul>
                                    </div>

                                    <h2>Alternative Syntax</h2>
                                    <p>While loops have an alternative syntax for templates:</p>

                                    <pre><code class="language-php">&lt;?php $items = ["Apple", "Banana", "Cherry"]; $i = 0; ?&gt;

&lt;ul&gt;
&lt;?php while ($i < count($items)): ?&gt;
    &lt;li&gt;&lt;?= $items[$i] ?&gt;&lt;/li&gt;
    &lt;?php $i++; ?&gt;
&lt;?php endwhile; ?&gt;
&lt;/ul&gt;</code></pre>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to update the loop variable</h4>
                                        <pre><code class="language-php">&lt;?php
$i = 1;

// ❌ WRONG: Infinite loop! $i never changes
while ($i <= 5) {
    echo $i;
    // Missing: $i++
}

// ✅ CORRECT: Increment the counter
while ($i <= 5) {
    echo $i;
    $i++;
}
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Off-by-one errors</h4>
                                        <pre><code class="language-php">&lt;?php
$items = [1, 2, 3, 4, 5];
$i = 0;

// ❌ WRONG: <= causes index out of bounds
while ($i <= count($items)) {  // 0,1,2,3,4,5 (6 iterations!)
    echo $items[$i];  // Error on last iteration
    $i++;
}

// ✅ CORRECT: Use < for zero-indexed arrays
while ($i < count($items)) {  // 0,1,2,3,4 (5 iterations)
    echo $items[$i];
    $i++;
}
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Missing semicolon in do-while</h4>
                                        <pre><code class="language-php">&lt;?php
// ❌ WRONG: Missing semicolon causes syntax error
do {
    echo "Hello";
} while (false)  // Missing semicolon!

// ✅ CORRECT: Always end with semicolon
do {
    echo "Hello";
} while (false);
?&gt;</code></pre>
                                    </div>

                                    <h2>Exercise: Number Guessing Game</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a simple number guessing game simulation.</p>
                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Generate a random target number between 1 and 10</li>
                                            <li>Simulate guesses until correct or max attempts reached</li>
                                            <li>Give "too high" or "too low" hints</li>
                                            <li>Track number of attempts</li>
                                            <li>Display success or failure message</li>
                                        </ul>
                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-php">&lt;?php
$target = rand(1, 10);
$maxAttempts = 5;
$attempts = 0;
$won = false;

// Simulated guesses
$guesses = [5, 3, 7, 8, 6, 4, 9, 2, 10, 1];

echo "Guess a number between 1 and 10!\n";
echo "(Secret number: $target)\n\n";

while ($attempts < $maxAttempts && !$won) {
    $guess = $guesses[$attempts];
    $attempts++;

    echo "Attempt $attempts: Guessing $guess... ";

    if ($guess === $target) {
        $won = true;
        echo "Correct!\n";
    } elseif ($guess < $target) {
        echo "Too low!\n";
    } else {
        echo "Too high!\n";
    }
}

echo "\n";
if ($won) {
    echo "You won in $attempts attempt(s)!\n";
} else {
    echo "Game over! The number was $target.\n";
}
?&gt;</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>while:</strong> Checks condition first, may run 0 times</li>
                                            <li><strong>do-while:</strong> Checks condition after, always runs at least
                                                once</li>
                                            <li><strong>Loop variable:</strong> Always update it to prevent infinite
                                                loops</li>
                                            <li><strong>break:</strong> Exit the loop immediately</li>
                                            <li><strong>Infinite loops:</strong> Use <code>while (true)</code> with
                                                <code>break</code></li>
                                            <li><strong>Use case:</strong> Best when iterations depend on runtime
                                                conditions</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>While loops are great for unknown iteration counts. Next, let's explore
                                        <strong>For Loops</strong> -
                                        the go-to choice when you know exactly how many times to repeat!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="control-switch.jsp" />
                                    <jsp:param name="prevTitle" value="Switch Statements" />
                                    <jsp:param name="nextLink" value="loops-for.jsp" />
                                    <jsp:param name="nextTitle" value="For Loops" />
                                    <jsp:param name="currentLessonId" value="loops-while" />
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