<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "control-loops" ); request.setAttribute("currentModule", "Control Flow" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Loops Tutorial - loop, while, for | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust loops with examples. Master loop, while, for, break, continue, and loop labels. Free Rust tutorial with code examples.">
            <meta name="keywords"
                content="rust loops, rust loops tutorial, rust loop, rust while, rust for, rust break, rust continue, rust loop labels, rust iteration, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Loops in Rust - loop, while, for">
            <meta property="og:description" content="Master loops and iteration in Rust.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/control-loops.jsp">
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
    "name": "Rust Loops Tutorial - loop, while, for",
    "description": "Learn Rust loops with examples. Master loop, while, for, break, continue, and loop labels. Free Rust tutorial with code examples.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/control-loops.jsp",
    "keywords": "rust loops, rust loops tutorial, rust loop, rust while, rust for, rust break, rust continue, rust loop labels, rust iteration, learn rust",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust loops", "loop keyword", "while loop", "for loop", "break", "continue", "Loop labels"],
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
            "name": "Loops"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="control-loops">
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
                                    <span>Loops</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Loops in Rust</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Loops allow you to execute code repeatedly. Rust provides three
                                        types of
                                        loops: <code>loop</code>,
                                        <code>while</code>, and <code>for</code>. Each has its own use case and
                                        advantages. In this lesson, you'll learn
                                        when and how to use each type, along with <code>break</code>,
                                        <code>continue</code>, and loop labels.
                                    </p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-loop-types.svg"
                                            alt="Rust Loop Types Comparison" class="tutorial-diagram" />
                                    </div>

                                    <!-- Section 1: loop -->
                                    <h2>The <code>loop</code> Keyword</h2>
                                    <p>The <code>loop</code> keyword creates an infinite loop that runs forever unless
                                        explicitly stopped:</p>

                                    <pre><code class="language-rust">loop {
    // This code runs forever
    // Use 'break' to exit
}</code></pre>

                                    <h3>Exiting with break</h3>
                                    <p>Use <code>break</code> to exit a loop:</p>

                                    <pre><code class="language-rust">let mut counter = 0;

loop {
    counter += 1;
    println!("Counter: {}", counter);
    
    if counter == 5 {
        break;  // Exit the loop
    }
}</code></pre>

                                    <h3>Returning Values from Loops</h3>
                                    <p>One unique feature of Rust: loops can return values!</p>

                                    <pre><code class="language-rust">let mut counter = 0;

let result = loop {
    counter += 1;
    
    if counter == 10 {
        break counter * 2;  // Return 20
    }
};

println!("Result: {}", result);  // 20</code></pre>

                                    <div class="info-box">
                                        <strong>When to use loop:</strong> Use <code>loop</code> when you don't know how
                                        many iterations you need,
                                        or when the exit condition is complex or in the middle of the loop body.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/loop-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-loop-basics" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: while -->
                                    <h2>The <code>while</code> Loop</h2>
                                    <p>A <code>while</code> loop runs as long as a condition is true:</p>

                                    <pre><code class="language-rust">let mut number = 3;

while number != 0 {
    println!("{}!", number);
    number -= 1;
}

println!("LIFTOFF!");</code></pre>

                                    <div class="warning-box">
                                        <strong>Condition must be boolean:</strong> Just like <code>if</code>, the
                                        condition must evaluate to
                                        <code>true</code> or <code>false</code>. You can't use numbers directly.
                                    </div>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>loop</th>
                                                <th>while</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Condition check</td>
                                                <td>None (infinite)</td>
                                                <td>Before each iteration</td>
                                            </tr>
                                            <tr>
                                                <td>Guaranteed to run</td>
                                                <td>Yes (at least once)</td>
                                                <td>No (may not run)</td>
                                            </tr>
                                            <tr>
                                                <td>Exit method</td>
                                                <td>Must use break</td>
                                                <td>Condition becomes false</td>
                                            </tr>
                                            <tr>
                                                <td>Can return value</td>
                                                <td>Yes</td>
                                                <td>No</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 3: for -->
                                    <h2>The <code>for</code> Loop</h2>
                                    <p>The <code>for</code> loop is the most common and safest way to iterate in Rust:
                                    </p>

                                    <h3>Iterating Over Ranges</h3>
                                    <pre><code class="language-rust">// Exclusive range (1 to 4)
for i in 1..5 {
    println!("{}", i);  // Prints 1, 2, 3, 4
}

// Inclusive range (1 to 5)
for i in 1..=5 {
    println!("{}", i);  // Prints 1, 2, 3, 4, 5
}</code></pre>

                                    <h3>Iterating Over Collections</h3>
                                    <pre><code class="language-rust">let numbers = [10, 20, 30, 40, 50];

for num in numbers {
    println!("{}", num);
}

// With index
for (index, value) in numbers.iter().enumerate() {
    println!("Index {}: {}", index, value);
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Prefer <code>for</code> loops over
                                        <code>while</code> when iterating over
                                        collections or ranges. They're safer (no index out of bounds errors) and more
                                        idiomatic.
                                    </div>

                                    <!-- Section 4: break and continue -->
                                    <h2>break and continue</h2>

                                    <h3>break - Exit the Loop</h3>
                                    <p><code>break</code> immediately exits the current loop:</p>

                                    <pre><code class="language-rust">for i in 1..=10 {
    if i == 5 {
        break;  // Stop at 5
    }
    println!("{}", i);  // Prints 1, 2, 3, 4
}</code></pre>

                                    <h3>continue - Skip to Next Iteration</h3>
                                    <p><code>continue</code> skips the rest of the current iteration and moves to the
                                        next:</p>

                                    <pre><code class="language-rust">for i in 1..=10 {
    if i % 2 != 0 {
        continue;  // Skip odd numbers
    }
    println!("{}", i);  // Prints only even: 2, 4, 6, 8, 10
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/loop-break-continue.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-break-continue" />
                                    </jsp:include>

                                    <!-- Section 5: Loop Labels -->
                                    <h2>Loop Labels</h2>
                                    <p>For nested loops, you can use labels to specify which loop to
                                        <code>break</code> or <code>continue</code>:
                                    </p>

                                    <pre><code class="language-rust">'outer: loop {
    println!("Outer loop");
    
    'inner: loop {
        println!("Inner loop");
        
        break 'outer;  // Break the outer loop
    }
    
    println!("This never runs");
}</code></pre>

                                    <div class="info-box">
                                        <strong>Label Syntax:</strong> Loop labels start with a single quote
                                        (<code>'</code>) followed by a name.
                                        Common names: <code>'outer</code>, <code>'inner</code>, <code>'search</code>,
                                        etc.
                                    </div>

                                    <h3>Practical Example: Searching in 2D Array</h3>
                                    <pre><code class="language-rust">let matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
];

let target = 5;

'search: for (row_idx, row) in matrix.iter().enumerate() {
    for (col_idx, &value) in row.iter().enumerate() {
        if value == target {
            println!("Found {} at ({}, {})", target, row_idx, col_idx);
            break 'search;  // Exit both loops
        }
    }
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/loop-labels.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-loop-labels" />
                                    </jsp:include>

                                    <!-- Common Patterns -->
                                    <h2>Common Loop Patterns</h2>

                                    <h3>1. Countdown</h3>
                                    <pre><code class="language-rust">for i in (1..=5).rev() {
    println!("{}", i);  // Prints 5, 4, 3, 2, 1
}</code></pre>

                                    <h3>2. Infinite Loop with Condition</h3>
                                    <pre><code class="language-rust">loop {
    let input = get_user_input();
    
    if input == "quit" {
        break;
    }
    
    process(input);
}</code></pre>

                                    <h3>3. Accumulator Pattern</h3>
                                    <pre><code class="language-rust">let mut sum = 0;

for i in 1..=100 {
    sum += i;
}

println!("Sum: {}", sum);  // 5050</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Infinite loop without break</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">loop {
    println!("Forever!");  // This never stops!
}</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let mut count = 0;
loop {
    println!("Count: {}", count);
    count += 1;
    if count >= 10 {
        break;
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using while for collections</h4>
                                        <p><strong>Less idiomatic:</strong></p>
                                        <pre><code class="language-rust">let arr = [1, 2, 3, 4, 5];
let mut index = 0;

while index < arr.len() {
    println!("{}", arr[index]);
    index += 1;
}</code></pre>
                                        <p><strong>Better (safer):</strong></p>
                                        <pre><code class="language-rust">let arr = [1, 2, 3, 4, 5];

for num in arr {
    println!("{}", num);
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting to update loop variable</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let mut i = 0;
while i < 5 {
    println!("{}", i);
    // Forgot to increment i - infinite loop!
}</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let mut i = 0;
while i < 5 {
    println!("{}", i);
    i += 1;  // Don't forget this!
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Loop Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Fix and complete the loop exercises.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Fix infinite loops</li>
                                            <li>Use appropriate loop types</li>
                                            <li>Implement break and continue</li>
                                            <li>Use loop labels for nested loops</li>
                                            <li>Return values from loops</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-loops-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-loops" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn main() {
    // Fixed infinite loop
    let mut i = 0;
    loop {
        i += 1;
        println!("{}", i);
        if i >= 5 {
            break;
        }
    }
    
    // Countdown
    let mut countdown = 10;
    while countdown > 0 {
        println!("{}", countdown);
        countdown -= 1;
    }
    
    // Print 1 to 10
    for num in 1..=10 {
        println!("{}", num);
    }
    
    // Even numbers only
    for num in 1..=20 {
        if num % 2 != 0 {
            continue;
        }
        println!("{}", num);
    }
    
    // First divisible by 7
    for num in 1..=100 {
        if num % 7 == 0 {
            println!("First number divisible by 7: {}", num);
            break;
        }
    }
    
    // Pairs that multiply to 12
    for i in 1..=12 {
        for j in 1..=12 {
            if i * j == 12 {
                println!("({}, {})", i, j);
            }
        }
    }
    
    // Sum 1 to 100
    let mut sum = 0;
    for i in 1..=100 {
        sum += i;
    }
    println!("Sum of 1 to 100: {}", sum);
    
    // Labeled loop
    let numbers = [
        [10, 20, 30],
        [40, 50, 60],
        [70, 80, 90],
    ];
    
    'search: for row in numbers {
        for &num in row.iter() {
            if num == 50 {
                println!("Found 50!");
                break 'search;
            }
        }
    }
    
    // Factorial
    let mut factorial = 1;
    for i in 1..=5 {
        factorial *= i;
    }
    println!("Factorial of 5: {}", factorial);
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>loop:</strong> Infinite loop, must use <code>break</code> to
                                                exit
                                            </li>
                                            <li><strong>while:</strong> Conditional loop, checks condition before each
                                                iteration</li>
                                            <li><strong>for:</strong> Iterator loop, safest and most idiomatic for
                                                collections</li>
                                            <li><code>break</code> exits the current loop immediately</li>
                                            <li><code>continue</code> skips to the next iteration</li>
                                            <li>Loops can return values using <code>break value</code></li>
                                            <li>Loop labels (<code>'label</code>) control nested loops</li>
                                            <li>Ranges: <code>1..5</code> (exclusive) or <code>1..=5</code> (inclusive)
                                            </li>
                                            <li>Prefer <code>for</code> loops for collections - they're safer!</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand loops, you're ready to learn about
                                        <strong>pattern matching</strong>.
                                        In the next lesson, you'll discover Rust's powerful <code>match</code>
                                        expression, which provides
                                        exhaustive pattern matching and is one of Rust's most powerful features.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="control-if.jsp" />
                                    <jsp:param name="prevTitle" value="if Expressions" />
                                    <jsp:param name="nextLink" value="control-match.jsp" />
                                    <jsp:param name="nextTitle" value="Pattern Matching" />
                                    <jsp:param name="currentLessonId" value="control-loops" />
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