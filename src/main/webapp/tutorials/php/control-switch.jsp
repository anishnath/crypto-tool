<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "control-switch");
   request.setAttribute("currentModule", "Control Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Switch Statements - PHP Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn PHP switch statements, case blocks, break, default, fall-through behavior, and PHP 8 match expressions with practical examples.">
    <meta name="keywords"
        content="php switch, php case, php break, php default, php match expression, php 8 match">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php/control-switch.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Switch Statements","description":"Learn PHP switch statements, case blocks, fall-through behavior, and PHP 8 match expressions","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP switch statement","Case blocks","Break keyword","Default case","Fall-through","PHP 8 match"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="control-switch">
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
                    <span>Switch Statements</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">PHP Switch Statements</h1>
                    <div class="lesson-meta"><span>Beginner</span><span>~30 min read</span></div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">When you need to compare a single value against many possible matches, the
                        <code>switch</code> statement provides a cleaner alternative to multiple <code>if-elseif</code>
                        chains. PHP 8 also introduces the powerful <code>match</code> expression for even more concise code.</p>

                    <h2>Basic Switch Statement</h2>
                    <p>The switch statement evaluates an expression once and compares it against multiple cases:</p>

                    <pre><code class="language-php">&lt;?php
switch (expression) {
    case value1:
        // Code for value1
        break;
    case value2:
        // Code for value2
        break;
    default:
        // Code if no match
}
?&gt;</code></pre>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Keyword</th>
                                <th>Purpose</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>switch</code></td>
                                <td>Starts the switch block with expression to evaluate</td>
                            </tr>
                            <tr>
                                <td><code>case</code></td>
                                <td>Defines a value to compare against</td>
                            </tr>
                            <tr>
                                <td><code>break</code></td>
                                <td>Exits the switch block (prevents fall-through)</td>
                            </tr>
                            <tr>
                                <td><code>default</code></td>
                                <td>Executes when no case matches (optional)</td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/control-switch.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-switch-basic" />
                    </jsp:include>

                    <h2>Switch vs If-Elseif</h2>
                    <p>Compare the same logic written both ways:</p>

                    <pre><code class="language-php">&lt;?php
$color = "red";

// Using if-elseif (verbose)
if ($color === "red") {
    echo "Stop!";
} elseif ($color === "yellow") {
    echo "Caution!";
} elseif ($color === "green") {
    echo "Go!";
} else {
    echo "Unknown color";
}

// Using switch (cleaner for many cases)
switch ($color) {
    case "red":
        echo "Stop!";
        break;
    case "yellow":
        echo "Caution!";
        break;
    case "green":
        echo "Go!";
        break;
    default:
        echo "Unknown color";
}
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>When to use switch:</strong> Use switch when comparing one variable against 3 or more
                        specific values. Use if-elseif for complex conditions, ranges, or when comparing different variables.
                    </div>

                    <h2>Fall-Through Behavior</h2>
                    <p>Without <code>break</code>, execution "falls through" to the next case. This can be intentional:</p>

                    <pre><code class="language-php">&lt;?php
$month = 2;

switch ($month) {
    case 1:
    case 3:
    case 5:
    case 7:
    case 8:
    case 10:
    case 12:
        $days = 31;
        break;
    case 4:
    case 6:
    case 9:
    case 11:
        $days = 30;
        break;
    case 2:
        $days = 28;  // Simplified, ignoring leap years
        break;
    default:
        $days = 0;
}

echo "Month $month has $days days.";
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Caution:</strong> Forgetting <code>break</code> is a common bug! Always add <code>break</code>
                        unless you intentionally want fall-through behavior. Add a comment when fall-through is intentional.
                    </div>

                    <h2>Switch with Strings</h2>
                    <p>Switch works with any scalar type, including strings:</p>

                    <pre><code class="language-php">&lt;?php
$action = strtolower($_GET['action'] ?? 'view');

switch ($action) {
    case 'create':
        echo "Creating new record...";
        break;
    case 'read':
    case 'view':
        echo "Displaying record...";
        break;
    case 'update':
    case 'edit':
        echo "Editing record...";
        break;
    case 'delete':
        echo "Deleting record...";
        break;
    default:
        echo "Unknown action: $action";
}
?&gt;</code></pre>

                    <div class="info-box">
                        <strong>Note:</strong> Switch uses <strong>loose comparison</strong> (<code>==</code>), not strict
                        comparison. This means <code>"0"</code> will match <code>0</code>. Use <code>match</code> (PHP 8+)
                        for strict comparison.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Alternative Syntax</h2>
                    <p>Like if statements, switch has an alternative syntax for templates:</p>

                    <pre><code class="language-php">&lt;?php $page = "about"; ?&gt;

&lt;?php switch ($page): ?&gt;
    &lt;?php case "home": ?&gt;
        &lt;h1&gt;Welcome Home&lt;/h1&gt;
        &lt;?php break; ?&gt;
    &lt;?php case "about": ?&gt;
        &lt;h1&gt;About Us&lt;/h1&gt;
        &lt;?php break; ?&gt;
    &lt;?php case "contact": ?&gt;
        &lt;h1&gt;Contact Us&lt;/h1&gt;
        &lt;?php break; ?&gt;
    &lt;?php default: ?&gt;
        &lt;h1&gt;Page Not Found&lt;/h1&gt;
&lt;?php endswitch; ?&gt;</code></pre>

                    <h2>PHP 8 Match Expression</h2>
                    <p>PHP 8 introduced <code>match</code>, a more powerful and safer alternative to switch:</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Feature</th>
                                <th>switch</th>
                                <th>match (PHP 8+)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Returns value</td>
                                <td>No (statement)</td>
                                <td>Yes (expression)</td>
                            </tr>
                            <tr>
                                <td>Comparison type</td>
                                <td>Loose (<code>==</code>)</td>
                                <td>Strict (<code>===</code>)</td>
                            </tr>
                            <tr>
                                <td>Requires break</td>
                                <td>Yes</td>
                                <td>No (implicit)</td>
                            </tr>
                            <tr>
                                <td>Fall-through</td>
                                <td>Possible</td>
                                <td>Not possible</td>
                            </tr>
                            <tr>
                                <td>No match handling</td>
                                <td>Continues silently</td>
                                <td>Throws UnhandledMatchError</td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/control-match.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-match" />
                    </jsp:include>

                    <h2>Match Syntax</h2>
                    <p>Match is an expression that returns a value:</p>

                    <pre><code class="language-php">&lt;?php
$role = "editor";

// Match returns a value directly
$permissions = match($role) {
    "admin" => ["create", "read", "update", "delete", "manage"],
    "editor" => ["create", "read", "update"],
    "viewer" => ["read"],
    default => []
};

print_r($permissions);

// Multiple values in one arm
$isWeekend = match($dayNumber) {
    1, 2, 3, 4, 5 => false,
    6, 7 => true,
    default => throw new InvalidArgumentException("Invalid day")
};
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Prefer <code>match</code> over <code>switch</code> in PHP 8+ for:
                        <ul>
                            <li>Cleaner, more concise code</li>
                            <li>Type-safe strict comparisons</li>
                            <li>No accidental fall-through bugs</li>
                            <li>When you need to return a value</li>
                        </ul>
                    </div>

                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting break statements</h4>
                        <pre><code class="language-php">&lt;?php
$fruit = "apple";

// ❌ WRONG: Missing break causes fall-through!
switch ($fruit) {
    case "apple":
        echo "Red fruit\n";  // Executes
    case "banana":
        echo "Yellow fruit\n";  // Also executes!
    case "grape":
        echo "Purple fruit\n";  // Also executes!
}

// ✅ CORRECT: Add break to each case
switch ($fruit) {
    case "apple":
        echo "Red fruit\n";
        break;
    case "banana":
        echo "Yellow fruit\n";
        break;
    case "grape":
        echo "Purple fruit\n";
        break;
}
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Relying on loose comparison</h4>
                        <pre><code class="language-php">&lt;?php
$value = "0";

// ❌ WRONG: Loose comparison matches unexpectedly
switch ($value) {
    case 0:
        echo "Zero (integer)";  // This matches "0" string!
        break;
    case "0":
        echo "Zero (string)";  // Never reached
        break;
}

// ✅ CORRECT: Use match for strict comparison (PHP 8+)
$result = match($value) {
    0 => "Zero (integer)",
    "0" => "Zero (string)",  // This matches correctly
    default => "Something else"
};
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. No default case</h4>
                        <pre><code class="language-php">&lt;?php
$status = "archived";

// ❌ WRONG: No handling for unexpected values
switch ($status) {
    case "active":
        processActive();
        break;
    case "pending":
        processPending();
        break;
}
// "archived" silently does nothing!

// ✅ CORRECT: Always include default
switch ($status) {
    case "active":
        processActive();
        break;
    case "pending":
        processPending();
        break;
    default:
        throw new Exception("Unknown status: $status");
}
?&gt;</code></pre>
                    </div>

                    <h2>Exercise: HTTP Status Handler</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a function that returns an appropriate message and CSS class for HTTP status codes.</p>
                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Handle status codes: 200, 201, 301, 400, 401, 403, 404, 500</li>
                            <li>Return an array with 'message' and 'class' keys</li>
                            <li>Group similar codes (e.g., 2xx = success, 4xx = error)</li>
                            <li>Handle unknown codes with a default</li>
                        </ul>
                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-php">&lt;?php
function getStatusInfo($code) {
    // Using match for PHP 8+
    return match($code) {
        200 => ['message' => 'OK', 'class' => 'success'],
        201 => ['message' => 'Created', 'class' => 'success'],
        301 => ['message' => 'Moved Permanently', 'class' => 'redirect'],
        400 => ['message' => 'Bad Request', 'class' => 'error'],
        401 => ['message' => 'Unauthorized', 'class' => 'error'],
        403 => ['message' => 'Forbidden', 'class' => 'error'],
        404 => ['message' => 'Not Found', 'class' => 'error'],
        500 => ['message' => 'Server Error', 'class' => 'error'],
        default => ['message' => 'Unknown Status', 'class' => 'unknown']
    };
}

// Test it
$codes = [200, 404, 500, 999];
foreach ($codes as $code) {
    $info = getStatusInfo($code);
    echo "$code: {$info['message']} ({$info['class']})\n";
}
?&gt;</code></pre>
                        </details>
                    </div>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>switch:</strong> Compare one value against multiple cases</li>
                            <li><strong>case:</strong> Define each possible value to match</li>
                            <li><strong>break:</strong> Required to prevent fall-through (unless intentional)</li>
                            <li><strong>default:</strong> Handles unmatched values (always include it!)</li>
                            <li><strong>Fall-through:</strong> Multiple cases can share the same code block</li>
                            <li><strong>match (PHP 8+):</strong> Modern alternative with strict comparison and returns a value</li>
                            <li><strong>Comparison:</strong> switch uses <code>==</code>, match uses <code>===</code></li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can make decisions with if and switch, let's learn about <strong>While Loops</strong> -
                        repeating code until a condition is no longer true!</p>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="control-if.jsp" />
                    <jsp:param name="prevTitle" value="If Statements" />
                    <jsp:param name="nextLink" value="loops-while.jsp" />
                    <jsp:param name="nextTitle" value="While Loops" />
                    <jsp:param name="currentLessonId" value="control-switch" />
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
