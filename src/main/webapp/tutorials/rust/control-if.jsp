<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "control-if" ); request.setAttribute("currentModule", "Control Flow" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust If Expressions Tutorial - Control Flow | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust if expressions with examples. Master if/else syntax, if as expression, multiple conditions. Free Rust tutorial for beginners.">
            <meta name="keywords"
                content="rust if, rust if tutorial, rust else, rust if expression, rust conditional, rust control flow, rust if else, learn rust, rust programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="if Expressions in Rust - Control Flow">
            <meta property="og:description" content="Master if expressions and conditional logic in Rust.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/control-if.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

            <script>
                (function () {
                    var theme = localStorage.getItem('tutorial-theme');
                    if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                        document.documentElement.setAttribute('data-theme', 'dark');
                    }
                })();
            </script>

            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Rust If Expressions Tutorial - Control Flow",
    "description": "Learn Rust if expressions with examples. Master if/else syntax, if as expression, multiple conditions. Free Rust tutorial for beginners.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/control-if.jsp",
    "keywords": "rust if, rust if tutorial, rust else, rust if expression, rust conditional, rust control flow, rust if else, learn rust, rust programming",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust if expressions", "if/else", "Conditional logic", "if as expression", "Control flow"],
    "timeRequired": "PT20M",
    "isPartOf": {
        "@type": "Course",
        "name": "Rust Tutorial",
        "description": "Complete Rust programming course from beginner to advanced with interactive examples",
        "url": "https://8gwifi.org/tutorials/rust/",
        "provider": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        }
    },
    "author": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
    }
}
    </script>

            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        {
            "@type": "ListItem",
            "position": 1,
            "name": "Tutorials",
            "item": "https://8gwifi.org/tutorials/"
        },
        {
            "@type": "ListItem",
            "position": 2,
            "name": "Rust",
            "item": "https://8gwifi.org/tutorials/rust/"
        },
        {
            "@type": "ListItem",
            "position": 3,
            "name": "if Expressions"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="control-if">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-rust.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/rust/">Rust</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>if Expressions</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">if Expressions in Rust</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Control flow is essential in any programming language. Rust's
                                        <code>if</code> expressions allow you to
                                        execute code conditionally based on boolean conditions. What makes Rust unique
                                        is
                                        that <code>if</code> is an
                                        expression, meaning it can return a value!
                                    </p>

                                    <!-- Section 1: Basic if Syntax -->
                                    <h2>Basic if Syntax</h2>
                                    <p>The simplest form of <code>if</code> checks a condition and executes a block of
                                        code if it's true:</p>

                                    <pre><code class="language-rust">if condition {
    // Code to execute if condition is true
}</code></pre>

                                    <div class="info-box">
                                        <strong>Important:</strong> The condition must be a <code>bool</code>. Rust will
                                        not automatically convert
                                        other types to boolean. You must use explicit comparison operators.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/if-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-if-basics" />
                                    </jsp:include>

                                    <!-- Section 2: if-else -->
                                    <h2>if-else Statements</h2>
                                    <p>Use <code>else</code> to provide an alternative block of code when the condition
                                        is false:</p>

                                    <pre><code class="language-rust">if condition {
    // Execute if true
} else {
    // Execute if false
}</code></pre>

                                    <h3>Multiple Conditions with else if</h3>
                                    <p>Chain multiple conditions using <code>else if</code>:</p>

                                    <pre><code class="language-rust">if condition1 {
    // Execute if condition1 is true
} else if condition2 {
    // Execute if condition2 is true
} else {
    // Execute if all conditions are false
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Rust evaluates conditions from top to bottom and stops at
                                        the first <code>true</code> condition.
                                        Order your conditions from most specific to most general.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Logical Operators -->
                                    <h2>Logical Operators</h2>
                                    <p>Combine multiple conditions using logical operators:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Example</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>&&</code></td>
                                                <td>AND</td>
                                                <td><code>a && b</code></td>
                                                <td>True if both are true</td>
                                            </tr>
                                            <tr>
                                                <td><code>||</code></td>
                                                <td>OR</td>
                                                <td><code>a || b</code></td>
                                                <td>True if either is true</td>
                                            </tr>
                                            <tr>
                                                <td><code>!</code></td>
                                                <td>NOT</td>
                                                <td><code>!a</code></td>
                                                <td>Inverts the boolean</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-rust">let age = 25;
let has_license = true;

// Both conditions must be true
if age >= 18 && has_license {
    println!("You can drive!");
}

// At least one condition must be true
if is_weekend || is_holiday {
    println!("Time to relax!");
}

// Negate a condition
if !is_raining {
    println!("Let's go outside!");
}</code></pre>

                                    <!-- Section 4: if as an Expression -->
                                    <h2>if as an Expression</h2>
                                    <p>This is where Rust shines! Since <code>if</code> is an expression, it can return
                                        a value:</p>

                                    <pre><code class="language-rust">let condition = true;
let number = if condition { 5 } else { 6 };
println!("The number is: {}", number);</code></pre>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-if-flow.svg"
                                            alt="if Expression Flow in Rust" class="tutorial-diagram" />
                                    </div>

                                    <div class="warning-box">
                                        <strong>Type Consistency:</strong> When using <code>if</code> as an expression,
                                        both branches must return
                                        the same type. This won't compile:
                                        <pre><code class="language-rust">let result = if condition { 5 } else { "six" }; // Error!</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/if-expressions.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-if-expressions" />
                                    </jsp:include>

                                    <!-- Section 5: Comparison Operators -->
                                    <h2>Comparison Operators</h2>
                                    <p>Use these operators to create conditions:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Meaning</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>==</code></td>
                                                <td>Equal to</td>
                                                <td><code>x == 5</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>!=</code></td>
                                                <td>Not equal to</td>
                                                <td><code>x != 5</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;</code></td>
                                                <td>Less than</td>
                                                <td><code>x &lt; 5</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;</code></td>
                                                <td>Greater than</td>
                                                <td><code>x &gt; 5</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;=</code></td>
                                                <td>Less than or equal</td>
                                                <td><code>x &lt;= 5</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;=</code></td>
                                                <td>Greater than or equal</td>
                                                <td><code>x &gt;= 5</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using non-boolean conditions</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let number = 5;
if number {  // Error: expected bool, found integer
    println!("Number exists");
}</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let number = 5;
if number != 0 {  // Explicit comparison
    println!("Number is non-zero");
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Type mismatch in if expression</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let result = if condition {
    5
} else {
    "six"  // Error: type mismatch
};</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let result = if condition {
    "five"
} else {
    "six"  // Both branches return &str
};</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting else when using if as expression</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let number = if condition { 5 };  // Error: missing else branch</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let number = if condition { 5 } else { 0 };</code></pre>
                                    </div>

                                    <!-- Best Practices -->
                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Keep conditions simple:</strong> Complex conditions are hard to
                                                read. Extract them into variables:
                                                <pre><code class="language-rust">let is_eligible = age >= 18 && has_license && !is_suspended;
if is_eligible {
    // ...
}</code></pre>
                                            </li>
                                            <li><strong>Use if expressions:</strong> Prefer <code>if</code> expressions
                                                over mutable variables:
                                                <pre><code class="language-rust">// Good
let status = if age >= 18 { "adult" } else { "minor" };

// Less idiomatic
let mut status = "minor";
if age >= 18 {
    status = "adult";
}</code></pre>
                                            </li>
                                            <li><strong>Consider match:</strong> For many conditions, <code>match</code>
                                                is often clearer than multiple <code>else if</code></li>
                                        </ul>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Practice if Expressions</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Fix the code to make it compile and work correctly.
                                        </p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Fix boolean conditions</li>
                                            <li>Complete if-else chains</li>
                                            <li>Use if as expression</li>
                                            <li>Handle type consistency</li>
                                            <li>Use logical operators</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-if-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-if" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn main() {
    // Fixed: Check if number is positive
    let number = 42;
    if number > 0 {
        println!("Number is positive");
    }
    
    // Complete age categorization
    let age = 25;
    if age >= 65 {
        println!("Senior");
    } else if age >= 18 {
        println!("Adult");
    } else {
        println!("Minor");
    }
    
    // Use if as expression
    let score = 85;
    let grade = if score >= 90 {
        "A"
    } else {
        "B"
    };
    println!("Grade: {}", grade);
    
    // Fix type mismatch
    let is_even = true;
    let result = if is_even {
        "even"
    } else {
        "odd"
    };
    println!("Result: {}", result);
    
    // Absolute value
    let num = -15;
    let absolute = if num < 0 { -num } else { num };
    println!("Absolute value of {}: {}", num, absolute);
    
    // Multiple conditions
    let temperature = 25;
    let is_sunny = true;
    if temperature > 20 && is_sunny {
        println!("Perfect day!");
    }
    
    // Max of three numbers
    let a = 10;
    let b = 25;
    let c = 15;
    let max = if a > b && a > c {
        a
    } else if b > c {
        b
    } else {
        c
    };
    println!("Max of {}, {}, {}: {}", a, b, c, max);
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><code>if</code> expressions allow conditional execution of code</li>
                                            <li>Conditions must be boolean (<code>true</code> or <code>false</code>)
                                            </li>
                                            <li>Use <code>else if</code> for multiple conditions</li>
                                            <li>Logical operators: <code>&&</code> (AND), <code>||</code> (OR),
                                                <code>!</code> (NOT)
                                            </li>
                                            <li><strong>if is an expression</strong> - it can return a value</li>
                                            <li>Both branches of an if expression must return the same type</li>
                                            <li>When using if as expression, <code>else</code> is required</li>
                                            <li>Comparison operators: <code>==</code>, <code>!=</code>,
                                                <code>&lt;</code>,
                                                <code>&gt;</code>, <code>&lt;=</code>, <code>&gt;=</code>
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand <code>if</code> expressions, you're ready to learn about
                                        <strong>loops</strong>.
                                        In the next lesson, you'll learn about Rust's three types of loops:
                                        <code>loop</code>, <code>while</code>, and <code>for</code>,
                                        and how to control their execution with <code>break</code> and
                                        <code>continue</code>.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="comments.jsp" />
                                    <jsp:param name="prevTitle" value="Comments" />
                                    <jsp:param name="nextLink" value="control-loops.jsp" />
                                    <jsp:param name="nextTitle" value="Loops" />
                                    <jsp:param name="currentLessonId" value="control-if" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/rust.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>