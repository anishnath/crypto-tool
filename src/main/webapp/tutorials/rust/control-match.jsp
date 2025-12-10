<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "control-match" ); request.setAttribute("currentModule", "Control Flow" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Pattern Matching Tutorial - match | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust pattern matching with examples. Master match expression, exhaustive matching, destructuring, and guards. Free Rust tutorial.">
            <meta name="keywords"
                content="rust match, rust pattern matching tutorial, rust match expression, rust destructuring, rust match guards, rust patterns, learn rust, rust programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Pattern Matching in Rust - match Expression">
            <meta property="og:description" content="Master pattern matching with Rust's match expression.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/control-match.jsp">
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
    "name": "Rust Pattern Matching Tutorial - match",
    "description": "Learn Rust pattern matching with examples. Master match expression, exhaustive matching, destructuring, and guards. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/control-match.jsp",
    "keywords": "rust match, rust pattern matching tutorial, rust match expression, rust destructuring, rust match guards, rust patterns, learn rust, rust programming",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust match", "Pattern matching", "Destructuring", "Match guards", "Exhaustive matching"],
    "timeRequired": "PT25M",
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
            "name": "Pattern Matching"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="control-match">
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
                                    <span>Pattern Matching</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Pattern Matching with match</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Pattern matching is one of Rust's most powerful features. The
                                        <code>match</code> expression allows you
                                        to compare a value against a series of patterns and execute code based on which
                                        pattern matches. Unlike
                                        <code>if</code>, <code>match</code> is exhaustive - you must handle all possible
                                        cases.
                                    </p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-match-flow.svg"
                                            alt="Pattern Matching Flow with match" class="tutorial-diagram" />
                                    </div>

                                    <!-- Section 1: Basic match -->
                                    <h2>Basic match Syntax</h2>
                                    <p>The <code>match</code> expression compares a value against patterns:</p>

                                    <pre><code class="language-rust">match value {
    pattern1 => expression1,
    pattern2 => expression2,
    pattern3 => expression3,
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/match-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-match-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>match is an expression:</strong> Like <code>if</code>,
                                        <code>match</code> returns a value.
                                        All arms must return the same type.
                                    </div>

                                    <!-- Section 2: Exhaustiveness -->
                                    <h2>Exhaustive Matching</h2>
                                    <p>Rust requires that <code>match</code> expressions handle all possible values:</p>

                                    <pre><code class="language-rust">let number = 5;

match number {
    1 => println!("One"),
    2 => println!("Two"),
    _ => println!("Something else"),  // Catch-all required!
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Compiler enforces exhaustiveness:</strong> If you don't cover all cases,
                                        your code won't compile.
                                        Use <code>_</code> (underscore) as a catch-all pattern for remaining cases.
                                    </div>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Pattern</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Literal</td>
                                                <td>Match exact value</td>
                                                <td><code>1 => ...</code></td>
                                            </tr>
                                            <tr>
                                                <td>Multiple</td>
                                                <td>Match any of several</td>
                                                <td><code>1 | 2 | 3 => ...</code></td>
                                            </tr>
                                            <tr>
                                                <td>Range</td>
                                                <td>Match a range</td>
                                                <td><code>1..=10 => ...</code></td>
                                            </tr>
                                            <tr>
                                                <td>Variable</td>
                                                <td>Bind to variable</td>
                                                <td><code>x => ...</code></td>
                                            </tr>
                                            <tr>
                                                <td>Wildcard</td>
                                                <td>Match anything</td>
                                                <td><code>_ => ...</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Destructuring -->
                                    <h2>Destructuring Patterns</h2>
                                    <p>You can destructure tuples, structs, and enums in match patterns:</p>

                                    <h3>Destructuring Tuples</h3>
                                    <pre><code class="language-rust">let point = (0, 5);

match point {
    (0, 0) => println!("Origin"),
    (0, y) => println!("On Y-axis at {}", y),
    (x, 0) => println!("On X-axis at {}", x),
    (x, y) => println!("Point at ({}, {})", x, y),
}</code></pre>

                                    <h3>Matching Option&lt;T&gt;</h3>
                                    <p>Pattern matching is perfect for handling <code>Option</code> types:</p>

                                    <pre><code class="language-rust">let some_number = Some(5);

match some_number {
    Some(n) => println!("Got a number: {}", n),
    None => println!("Got nothing"),
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Use <code>match</code> instead of
                                        <code>unwrap()</code> when handling
                                        <code>Option</code> and <code>Result</code> types. It's safer and more explicit.
                                    </div>

                                    <!-- Section 4: Match Guards -->
                                    <h2>Match Guards</h2>
                                    <p>Add extra conditions to patterns using <code>if</code>:</p>

                                    <pre><code class="language-rust">let number = 4;

match number {
    n if n < 0 => println!("Negative: {}", n),
    n if n == 0 => println!("Zero"),
    n if n % 2 == 0 => println!("Positive even: {}", n),
    n => println!("Positive odd: {}", n),
}</code></pre>

                                    <div class="info-box">
                                        <strong>Match guards:</strong> The <code>if</code> condition is evaluated after
                                        the pattern matches.
                                        If the guard is false, matching continues to the next arm.
                                    </div>

                                    <!-- Section 5: @ Bindings -->
                                    <h2>@ Bindings</h2>
                                    <p>Use <code>@</code> to bind a value to a variable while also testing it:</p>

                                    <pre><code class="language-rust">let age = 25;

match age {
    n @ 0..=12 => println!("Child of age {}", n),
    n @ 13..=19 => println!("Teenager of age {}", n),
    n @ 20..=64 => println!("Adult of age {}", n),
    n @ 65.. => println!("Senior of age {}", n),
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/match-patterns.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-match-patterns" />
                                    </jsp:include>

                                    <!-- Section 6: Ignoring Values -->
                                    <h2>Ignoring Values</h2>

                                    <h3>Using _ to Ignore Values</h3>
                                    <pre><code class="language-rust">let triple = (5, 10, 15);

match triple {
    (first, _, third) => {
        println!("First: {}, Third: {}", first, third);
        // Second value is ignored
    }
}</code></pre>

                                    <h3>Using .. to Ignore Remaining Parts</h3>
                                    <pre><code class="language-rust">let numbers = (1, 2, 3, 4, 5);

match numbers {
    (first, .., last) => {
        println!("First: {}, Last: {}", first, last);
    }
}</code></pre>

                                    <!-- Common Patterns -->
                                    <h2>Common Patterns</h2>

                                    <h3>1. Simple State Machine</h3>
                                    <pre><code class="language-rust">let state = "running";

match state {
    "idle" => println!("System is idle"),
    "running" => println!("System is running"),
    "stopped" => println!("System is stopped"),
    _ => println!("Unknown state"),
}</code></pre>

                                    <h3>2. Error Handling with Result</h3>
                                    <pre><code class="language-rust">let result: Result<i32, &str> = Ok(42);

match result {
    Ok(value) => println!("Success: {}", value),
    Err(error) => println!("Error: {}", error),
}</code></pre>

                                    <h3>3. Multiple Conditions</h3>
                                    <pre><code class="language-rust">let pair = (2, -5);

match pair {
    (x, y) if x == y => println!("Equal"),
    (x, y) if x > y => println!("{} is greater", x),
    (x, y) => println!("{} is greater", y),
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Non-exhaustive match</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let number = 5;
match number {
    1 => println!("One"),
    2 => println!("Two"),
    // Error: non-exhaustive patterns
}</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let number = 5;
match number {
    1 => println!("One"),
    2 => println!("Two"),
    _ => println!("Other"),  // Catch-all
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Type mismatch in arms</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let result = match number {
    1 => "one",
    2 => 2,  // Error: type mismatch
    _ => "other",
};</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let result = match number {
    1 => "one",
    2 => "two",  // All arms return &str
    _ => "other",
};</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Unreachable patterns</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">match number {
    _ => println!("Anything"),
    1 => println!("One"),  // Warning: unreachable!
}</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">match number {
    1 => println!("One"),
    _ => println!("Anything"),  // Catch-all goes last
}</code></pre>
                                    </div>

                                    <!-- Best Practices -->
                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Prefer match over if chains:</strong> When you have multiple
                                                conditions, <code>match</code> is often clearer</li>
                                            <li><strong>Order patterns from specific to general:</strong> Put more
                                                specific patterns first</li>
                                            <li><strong>Use meaningful variable names:</strong> Instead of
                                                <code>x</code>, use descriptive names in patterns
                                            </li>
                                            <li><strong>Leverage exhaustiveness:</strong> Let the compiler help you
                                                catch
                                                missing cases</li>
                                            <li><strong>Use guards sparingly:</strong> Complex guards can make code hard
                                                to read</li>
                                        </ul>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Pattern Matching Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Complete the pattern matching exercises.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Add catch-all patterns</li>
                                            <li>Use match expressions</li>
                                            <li>Destructure tuples</li>
                                            <li>Handle Option types</li>
                                            <li>Use match guards</li>
                                            <li>Apply @ bindings</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-match-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-match" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn main() {
    // Fixed with catch-all
    let number = 10;
    match number {
        1 => println!("One"),
        2 => println!("Two"),
        3 => println!("Three"),
        _ => println!("Other"),
    }
    
    // Grade categorization
    let score = 85;
    let grade = match score {
        90..=100 => "A",
        80..=89 => "B",
        70..=79 => "C",
        60..=69 => "D",
        _ => "F",
    };
    println!("Grade: {}", grade);
    
    // Quadrant determination
    let point = (3, -5);
    match point {
        (x, y) if x > 0 && y > 0 => println!("Quadrant I"),
        (x, y) if x < 0 && y > 0 => println!("Quadrant II"),
        (x, y) if x < 0 && y < 0 => println!("Quadrant III"),
        (x, y) if x > 0 && y < 0 => println!("Quadrant IV"),
        _ => println!("On axis"),
    }
    
    // Option handling
    let maybe_number: Option<i32> = Some(42);
    let value = match maybe_number {
        Some(n) => n,
        None => 0,
    };
    println!("Value: {}", value);
    
    // Temperature categorization
    let temp = 25;
    match temp {
        t if t < 0 => println!("Freezing"),
        t if t <= 15 => println!("Cold"),
        t if t <= 25 => println!("Comfortable"),
        _ => println!("Hot"),
    }
    
    // Destructure with ..
    let data = (10, 20, 30, 40, 50);
    match data {
        (first, .., last) => {
            println!("First: {}, Last: {}", first, last);
        }
    }
    
    // @ binding
    let age = 17;
    match age {
        n @ 0..=12 => println!("Child: {}", n),
        n @ 13..=19 => println!("Teen: {}", n),
        n @ 20..=64 => println!("Adult: {}", n),
        n @ 65.. => println!("Senior: {}", n),
    }
    
    // Multiple patterns
    let day = 6;
    match day {
        1..=5 => println!("Weekday"),
        6 | 7 => println!("Weekend"),
        _ => println!("Invalid day"),
    }
    
    // Calculator
    let operation = '+';
    let a = 10;
    let b = 5;
    let result = match operation {
        '+' => a + b,
        '-' => a - b,
        '*' => a * b,
        '/' => a / b,
        _ => 0,
    };
    println!("{} {} {} = {}", a, operation, b, result);
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><code>match</code> is an expression that returns a value</li>
                                            <li><strong>Exhaustive:</strong> Must handle all possible cases</li>
                                            <li>Use <code>_</code> as a catch-all pattern</li>
                                            <li>Patterns can be literals, ranges, or variables</li>
                                            <li>Combine multiple patterns with <code>|</code></li>
                                            <li><strong>Destructuring:</strong> Extract values from tuples, structs,
                                                enums
                                            </li>
                                            <li><strong>Match guards:</strong> Add conditions with <code>if</code></li>
                                            <li><strong>@ bindings:</strong> Bind and test values simultaneously</li>
                                            <li>Use <code>_</code> to ignore values, <code>..</code> to ignore remaining
                                            </li>
                                            <li>All arms must return the same type</li>
                                            <li>More specific patterns should come before general ones</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 3: Control Flow. You now understand
                                        <code>if</code> expressions,
                                        loops, and pattern matching - the building blocks of program logic in Rust.
                                    </p>
                                    <p>In the next module, we'll dive into <strong>Ownership</strong> - the feature that
                                        makes Rust unique.
                                        You'll learn about ownership rules, borrowing, references, and how Rust achieves
                                        memory safety without
                                        a garbage collector.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="control-loops.jsp" />
                                    <jsp:param name="prevTitle" value="Loops" />
                                    <jsp:param name="nextLink" value="ownership.jsp" />
                                    <jsp:param name="nextTitle" value="Ownership" />
                                    <jsp:param name="currentLessonId" value="control-match" />
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