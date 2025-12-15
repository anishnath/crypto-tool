<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "control-if");
   request.setAttribute("currentModule", "Control Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP If Statements - PHP Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn PHP if statements, else, elseif, nested conditions, and alternative syntax. Master conditional logic with practical examples.">
    <meta name="keywords"
        content="php if statement, php else, php elseif, php conditional, php nested if, php alternative syntax">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php/control-if.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP If Statements","description":"Learn PHP conditional statements including if, else, elseif, nested conditions, and alternative syntax","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP if statement","PHP else","PHP elseif","Nested conditions","Alternative syntax"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="control-if">
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
                    <span>If Statements</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">PHP If Statements</h1>
                    <div class="lesson-meta"><span>Beginner</span><span>~25 min read</span></div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">Conditional statements allow your program to make decisions based on conditions.
                        The <code>if</code> statement is the most fundamental control structure in PHP, letting you
                        execute code only when specific conditions are met.</p>

                    <h2>Basic If Statement</h2>
                    <p>The simplest form executes code when a condition is <code>true</code>:</p>

                    <pre><code class="language-php">&lt;?php
if (condition) {
    // Code executes if condition is true
}
?&gt;</code></pre>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Part</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>if</code></td>
                                <td>Keyword that starts the conditional</td>
                            </tr>
                            <tr>
                                <td><code>(condition)</code></td>
                                <td>Expression that evaluates to true or false</td>
                            </tr>
                            <tr>
                                <td><code>{ }</code></td>
                                <td>Code block to execute when condition is true</td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/control-if.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-if-basic" />
                    </jsp:include>

                    <h2>If-Else Statement</h2>
                    <p>Use <code>else</code> to execute alternative code when the condition is <code>false</code>:</p>

                    <pre><code class="language-php">&lt;?php
$age = 16;

if ($age >= 18) {
    echo "You can vote!";
} else {
    echo "You're too young to vote.";
}
// Output: You're too young to vote.
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Best Practice:</strong> Always use curly braces <code>{ }</code> even for single-line
                        statements. It prevents bugs when adding more code later and improves readability.
                    </div>

                    <h2>If-Elseif-Else Statement</h2>
                    <p>Check multiple conditions in sequence using <code>elseif</code>:</p>

                    <pre><code class="language-php">&lt;?php
$score = 85;

if ($score >= 90) {
    $grade = 'A';
} elseif ($score >= 80) {
    $grade = 'B';
} elseif ($score >= 70) {
    $grade = 'C';
} elseif ($score >= 60) {
    $grade = 'D';
} else {
    $grade = 'F';
}

echo "Grade: $grade";  // Output: Grade: B
?&gt;</code></pre>

                    <div class="info-box">
                        <strong>Note:</strong> PHP accepts both <code>elseif</code> (one word) and
                        <code>else if</code> (two words). They behave identically with curly brace syntax.
                    </div>

                    <h2>Multiple Conditions</h2>
                    <p>Combine conditions using logical operators:</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Name</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>&&</code> or <code>and</code></td>
                                <td>AND</td>
                                <td>True if both conditions are true</td>
                            </tr>
                            <tr>
                                <td><code>||</code> or <code>or</code></td>
                                <td>OR</td>
                                <td>True if at least one condition is true</td>
                            </tr>
                            <tr>
                                <td><code>!</code></td>
                                <td>NOT</td>
                                <td>Inverts the condition</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-php">&lt;?php
$age = 25;
$hasLicense = true;
$hasCar = false;

// AND: both must be true
if ($age >= 18 && $hasLicense) {
    echo "You can drive legally.\n";
}

// OR: at least one must be true
if ($hasCar || $hasLicense) {
    echo "You have some driving capability.\n";
}

// NOT: inverts the condition
if (!$hasCar) {
    echo "You don't own a car.\n";
}
?&gt;</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>Nested If Statements</h2>
                    <p>Place if statements inside other if statements for complex logic:</p>

                    <pre><code class="language-php">&lt;?php
$isLoggedIn = true;
$isAdmin = false;
$hasPermission = true;

if ($isLoggedIn) {
    echo "Welcome!\n";

    if ($isAdmin) {
        echo "You have full access.\n";
    } else {
        if ($hasPermission) {
            echo "You can view this content.\n";
        } else {
            echo "Access denied.\n";
        }
    }
} else {
    echo "Please log in.\n";
}
?&gt;</code></pre>

                    <div class="warning-box">
                        <strong>Caution:</strong> Avoid deeply nested if statements (more than 2-3 levels). They become
                        hard to read and maintain. Consider using early returns or restructuring your logic.
                    </div>

                    <h2>Alternative Syntax</h2>
                    <p>PHP provides an alternative syntax useful when mixing PHP with HTML in templates:</p>

                    <pre><code class="language-php">&lt;?php $userType = "premium"; ?&gt;

&lt;?php if ($userType === "premium"): ?&gt;
    &lt;div class="premium-badge"&gt;Premium Member&lt;/div&gt;
&lt;?php elseif ($userType === "basic"): ?&gt;
    &lt;div class="basic-badge"&gt;Basic Member&lt;/div&gt;
&lt;?php else: ?&gt;
    &lt;div class="guest-badge"&gt;Guest&lt;/div&gt;
&lt;?php endif; ?&gt;</code></pre>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/control-if-alternative.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-if-alternative" />
                    </jsp:include>

                    <h2>Truthy and Falsy Values</h2>
                    <p>PHP automatically converts values to boolean in conditions. Understanding what's "falsy" is crucial:</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Falsy Values (evaluate to false)</th>
                                <th>Truthy Values (evaluate to true)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>false</code></td>
                                <td><code>true</code></td>
                            </tr>
                            <tr>
                                <td><code>0</code> and <code>0.0</code></td>
                                <td>Non-zero numbers</td>
                            </tr>
                            <tr>
                                <td><code>""</code> and <code>"0"</code></td>
                                <td>Non-empty strings (including <code>"false"</code>)</td>
                            </tr>
                            <tr>
                                <td><code>[]</code> (empty array)</td>
                                <td>Non-empty arrays</td>
                            </tr>
                            <tr>
                                <td><code>null</code></td>
                                <td>Objects, resources</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-php">&lt;?php
$name = "";

if ($name) {
    echo "Hello, $name!";
} else {
    echo "Name is empty!";  // This executes
}

// Better: be explicit
if ($name !== "") {
    echo "Hello, $name!";
}
?&gt;</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use strict comparisons (<code>===</code> and <code>!==</code>) when
                        checking specific values to avoid unexpected type coercion.
                    </div>

                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using = instead of == or ===</h4>
                        <pre><code class="language-php">&lt;?php
$status = "active";

// ❌ WRONG: This assigns "inactive" to $status!
if ($status = "inactive") {
    echo "Account disabled";  // Always executes!
}

// ✅ CORRECT: Use == or ===
if ($status === "inactive") {
    echo "Account disabled";
}
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting braces with multiple statements</h4>
                        <pre><code class="language-php">&lt;?php
$loggedIn = true;

// ❌ WRONG: Only first line is conditional!
if ($loggedIn)
    echo "Welcome!\n";
    echo "Dashboard loaded\n";  // Always executes!

// ✅ CORRECT: Use braces
if ($loggedIn) {
    echo "Welcome!\n";
    echo "Dashboard loaded\n";
}
?&gt;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not handling all cases</h4>
                        <pre><code class="language-php">&lt;?php
$role = "moderator";

// ❌ Incomplete: What about other roles?
if ($role === "admin") {
    echo "Full access";
} elseif ($role === "user") {
    echo "Limited access";
}
// "moderator" gets nothing!

// ✅ CORRECT: Handle all cases
if ($role === "admin") {
    echo "Full access";
} elseif ($role === "user") {
    echo "Limited access";
} else {
    echo "Unknown role: $role";
}
?&gt;</code></pre>
                    </div>

                    <h2>Exercise: User Access Control</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create an access control system that determines what a user can do.</p>
                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Check if user is logged in</li>
                            <li>If logged in, check their role (admin, editor, viewer)</li>
                            <li>Display appropriate permissions for each role</li>
                            <li>Handle unknown roles gracefully</li>
                        </ul>
                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-php">&lt;?php
$isLoggedIn = true;
$userRole = "editor";

if (!$isLoggedIn) {
    echo "Please log in to continue.\n";
} else {
    echo "Welcome! You are logged in.\n";

    if ($userRole === "admin") {
        echo "Permissions: Create, Read, Update, Delete, Manage Users\n";
    } elseif ($userRole === "editor") {
        echo "Permissions: Create, Read, Update\n";
    } elseif ($userRole === "viewer") {
        echo "Permissions: Read only\n";
    } else {
        echo "Unknown role. Please contact support.\n";
    }
}
?&gt;</code></pre>
                        </details>
                    </div>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>if:</strong> Executes code when condition is true</li>
                            <li><strong>else:</strong> Executes when if condition is false</li>
                            <li><strong>elseif:</strong> Checks additional conditions in sequence</li>
                            <li><strong>Nested if:</strong> Place if inside another if for complex logic</li>
                            <li><strong>Alternative syntax:</strong> Use <code>if:</code>...<code>endif;</code> in templates</li>
                            <li><strong>Logical operators:</strong> <code>&&</code>, <code>||</code>, <code>!</code> combine conditions</li>
                            <li><strong>Always use braces:</strong> Even for single statements</li>
                            <li><strong>Use === over ==:</strong> For type-safe comparisons</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you understand if statements, let's explore <strong>Switch Statements</strong> - a
                        cleaner way to handle multiple conditions when comparing a single value against many options!</p>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="constants-basics.jsp" />
                    <jsp:param name="prevTitle" value="Constants" />
                    <jsp:param name="nextLink" value="control-switch.jsp" />
                    <jsp:param name="nextTitle" value="Switch Statements" />
                    <jsp:param name="currentLessonId" value="control-if" />
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
