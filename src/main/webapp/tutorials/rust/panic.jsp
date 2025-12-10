<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "panic" ); request.setAttribute("currentModule", "Error Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Panic Tutorial - Error Handling Guide | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust panic with examples. Master panic! macro, unwrap(), expect(), backtraces, and when to use panic vs Result. Free Rust tutorial.">
            <meta name="keywords"
                content="rust panic, rust panic tutorial, rust error handling, rust unwrap, rust expect, rust backtrace, rust unrecoverable errors, learn rust, rust tutorial">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Panic! in Rust - Unrecoverable Errors">
            <meta property="og:description" content="Master Rust panic handling for unrecoverable errors.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/panic.jsp">
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
    "name": "Rust Panic Tutorial - Error Handling Guide",
    "description": "Learn Rust panic with examples. Master panic! macro, unwrap(), expect(), backtraces, and when to use panic vs Result. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/panic.jsp",
    "keywords": "rust panic, rust panic tutorial, rust error handling, rust unwrap, rust expect, rust backtrace, rust unrecoverable errors, learn rust, rust tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust panic", "panic! macro", "unwrap()", "expect()", "Backtraces", "Error handling"],
    "timeRequired": "PT30M",
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
            "name": "Panic!"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="panic">
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
                                    <span>Panic!</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Panic!</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">In Rust, a <em>panic</em> is an unrecoverable error that causes the
                                        program to stop execution immediately. Panics are used for situations where the
                                        program cannot continue and there's no way to recover. Understanding when and how
                                        panics occur is crucial for writing robust Rust programs.
                                    </p>

                                    <h2>What is a Panic?</h2>
                                    <p>A panic occurs when your program encounters an error that it cannot handle. When a
                                        panic happens, Rust will:</p>
                                    <ul>
                                        <li>Print an error message</li>
                                        <li>Unwind the stack (clean up resources)</li>
                                        <li>Exit the program</li>
                                    </ul>

                                    <div class="warning-box">
                                        <strong>Unrecoverable:</strong> Panics are for unrecoverable errors. If you can
                                        handle an error gracefully, use <code>Result&lt;T, E&gt;</code> instead. Panics
                                        should be rare in production code.
                                    </div>

                                    <h2>Using the panic! Macro</h2>
                                    <p>You can explicitly cause a panic using the <code>panic!</code> macro:</p>

                                    <pre><code class="language-rust">panic!("crash and burn");</code></pre>

                                    <p>When this code runs, the program will stop and print:</p>
                                    <pre><code>thread 'main' panicked at 'crash and burn', src/main.rs:2:5
note: run with `RUST_BACKTRACE=1` for a backtrace</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/panic-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-panic-basics" />
                                    </jsp:include>

                                    <h2>When Panics Occur</h2>
                                    <p>Panics can occur in several situations:</p>

                                    <h3>1. Explicit panic! Calls</h3>
                                    <pre><code class="language-rust">if value < 0 {
    panic!("Value cannot be negative");
}</code></pre>

                                    <h3>2. Index Out of Bounds</h3>
                                    <pre><code class="language-rust">let v = vec![1, 2, 3];
let element = v[10];  // Panics! Index 10 doesn't exist</code></pre>

                                    <div class="tip-box">
                                        <strong>Safe Alternative:</strong> Use <code>v.get(10)</code> instead, which
                                        returns <code>Option&lt;&T&gt;</code> and won't panic.
                                    </div>

                                    <h3>3. Division by Zero</h3>
                                    <pre><code class="language-rust">let result = 10 / 0;  // Panics!</code></pre>

                                    <h3>4. Calling unwrap() on None or Err</h3>
                                    <pre><code class="language-rust">let none: Option&lt;i32&gt; = None;
let value = none.unwrap();  // Panics!</code></pre>

                                    <h2>unwrap() and expect()</h2>
                                    <p>Two common methods that can cause panics are <code>unwrap()</code> and
                                        <code>expect()</code>:</p>

                                    <h3>unwrap()</h3>
                                    <pre><code class="language-rust">let some_value = Some(5);
let value = some_value.unwrap();  // Returns 5

let none_value: Option&lt;i32&gt; = None;
let value = none_value.unwrap();  // Panics!</code></pre>

                                    <div class="warning-box">
                                        <strong>Avoid unwrap() in Production:</strong> <code>unwrap()</code> should only
                                        be used in examples, tests, or when you're absolutely certain the value exists.
                                        In production code, handle errors properly with <code>match</code> or
                                        <code>Result</code>.
                                    </div>

                                    <h3>expect()</h3>
                                    <p><code>expect()</code> is like <code>unwrap()</code>, but allows you to provide a
                                        custom error message:</p>

                                    <pre><code class="language-rust">let result: Result&lt;i32, &str&gt; = Ok(42);
let value = result.expect("Failed to get value");  // Returns 42

let error: Result&lt;i32, &str&gt; = Err("something went wrong");
let value = error.expect("Failed to get value");  // Panics with message</code></pre>

                                    <div class="info-box">
                                        <strong>Better Error Messages:</strong> <code>expect()</code> is slightly better
                                        than <code>unwrap()</code> because it provides context about what went wrong,
                                        making debugging easier.
                                    </div>

                                    <h2>Safe Alternatives to unwrap()</h2>
                                    <p>Instead of using <code>unwrap()</code>, use these safer alternatives:</p>

                                    <h3>1. Using match</h3>
                                    <pre><code class="language-rust">let maybe_value: Option&lt;i32&gt; = Some(10);

match maybe_value {
    Some(v) => println!("Value: {}", v),
    None => println!("No value"),
}</code></pre>

                                    <h3>2. Using if let</h3>
                                    <pre><code class="language-rust">if let Some(v) = maybe_value {
    println!("Value: {}", v);
}</code></pre>

                                    <h3>3. Using unwrap_or()</h3>
                                    <pre><code class="language-rust">let value = maybe_value.unwrap_or(0);  // Returns 10 or 0 if None</code></pre>

                                    <h3>4. Using unwrap_or_else()</h3>
                                    <pre><code class="language-rust">let value = maybe_value.unwrap_or_else(|| {
    // Compute default value
    0
});</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Backtraces</h2>
                                    <p>When a panic occurs, Rust can print a <em>backtrace</em>, which shows the call
                                        stack leading to the panic. This is extremely useful for debugging.</p>

                                    <p>To see a backtrace, run your program with:</p>
                                    <pre><code>RUST_BACKTRACE=1 cargo run</code></pre>

                                    <p>Or set it permanently:</p>
                                    <pre><code>export RUST_BACKTRACE=1  # On Unix/Linux/Mac
set RUST_BACKTRACE=1      # On Windows</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/panic-backtrace.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-panic-backtrace" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Debugging Tip:</strong> Backtraces show the exact line where the panic
                                        occurred and the call chain that led to it. This makes it much easier to find and
                                        fix bugs.
                                    </div>

                                    <h2>When to Use Panic vs Result</h2>
                                    <div class="best-practice-box">
                                        <p><strong>Use <code>panic!</code> when:</strong></p>
                                        <ul>
                                            <li><strong>Unrecoverable errors:</strong> When there's no way to recover from the error</li>
                                            <li><strong>Programming errors:</strong> When the error indicates a bug in your code (e.g., index out of bounds)</li>
                                            <li><strong>Examples and tests:</strong> When writing example code or tests where panics are acceptable</li>
                                            <li><strong>Prototyping:</strong> During early development when you want to fail fast</li>
                                        </ul>
                                        
                                        <p style="margin-top: 15px;"><strong>Use <code>Result&lt;T, E&gt;</code> when:</strong></p>
                                        <ul>
                                            <li><strong>Recoverable errors:</strong> When the caller can handle the error</li>
                                            <li><strong>I/O operations:</strong> File operations, network requests, etc.</li>
                                            <li><strong>User input:</strong> Parsing, validation, etc.</li>
                                            <li><strong>Production code:</strong> When you need robust error handling</li>
                                        </ul>
                                    </div>

                                    <div class="info-box">
                                        <strong>Rule of Thumb:</strong> If it's a programming error (bug), use panic. If
                                        it's an expected error condition that can be handled, use Result.
                                    </div>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Avoid unwrap() in production:</strong> Always handle errors properly</li>
                                            <li><strong>Use expect() for better messages:</strong> If you must panic, use expect() with a descriptive message</li>
                                            <li><strong>Prefer Result for recoverable errors:</strong> Use Result when the caller can handle the error</li>
                                            <li><strong>Use safe alternatives:</strong> Use get(), unwrap_or(), or match instead of unwrap()</li>
                                            <li><strong>Enable backtraces in development:</strong> Set RUST_BACKTRACE=1 for debugging</li>
                                            <li><strong>Document panic conditions:</strong> If your function can panic, document when it happens</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using unwrap() everywhere</h4>
                                        <pre><code class="language-rust">// Wrong - Can panic at runtime
let value = some_option.unwrap();
let result = some_result.unwrap();

// Correct - Handle errors properly
match some_option {
    Some(v) => println!("{}", v),
    None => println!("No value"),
}

match some_result {
    Ok(v) => println!("{}", v),
    Err(e) => println!("Error: {}", e),
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using index syntax without checking bounds</h4>
                                        <pre><code class="language-rust">// Wrong - Panics if index doesn't exist
let v = vec![1, 2, 3];
let element = v[10];  // Panic!

// Correct - Use get() for safe access
match v.get(10) {
    Some(element) => println!("{}", element),
    None => println!("Index out of bounds"),
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Panicking on recoverable errors</h4>
                                        <pre><code class="language-rust">// Wrong - Should use Result
fn divide(a: i32, b: i32) -> i32 {
    if b == 0 {
        panic!("Division by zero");  // Bad!
    }
    a / b
}

// Correct - Return Result
fn divide(a: i32, b: i32) -> Result&lt;i32, String&gt; {
    if b == 0 {
        Err(String::from("Division by zero"))
    } else {
        Ok(a / b)
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Not enabling backtraces during development</h4>
                                        <pre><code class="language-rust">// Always set RUST_BACKTRACE=1 when debugging
// export RUST_BACKTRACE=1  (Unix/Linux/Mac)
// set RUST_BACKTRACE=1     (Windows)

// This helps you see exactly where panics occur</code></pre>
                                    </div>

                                    <h2>Exercise: Panic Handling Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement safe functions that handle errors without panicking.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Write a safe division function using Option</li>
                                            <li>Write a safe vector access function</li>
                                            <li>Write a username validation function using Result</li>
                                            <li>Avoid using unwrap() or expect()</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-panic-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-panic" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn safe_divide(a: i32, b: i32) -> Option&lt;i32&gt; {
    if b == 0 {
        None
    } else {
        Some(a / b)
    }
}

fn safe_get(v: &Vec&lt;i32&gt;, index: usize) -> Option&lt;&i32&gt; {
    v.get(index)
}

fn validate_username(username: &str) -> Result&lt;String, String&gt; {
    if username.len() &lt; 3 {
        Err(String::from("Username must be at least 3 characters"))
    } else if username.contains(' ') {
        Err(String::from("Username cannot contain spaces"))
    } else {
        Ok(String::from(username))
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Panic</strong> is for unrecoverable errors</li>
                                            <li>Use <code>panic!</code> macro to explicitly panic</li>
                                            <li><code>unwrap()</code> and <code>expect()</code> can cause panics</li>
                                            <li>Use <code>match</code>, <code>if let</code>, or <code>unwrap_or()</code> for safe handling</li>
                                            <li>Enable backtraces with <code>RUST_BACKTRACE=1</code> for debugging</li>
                                            <li>Use <code>panic!</code> for programming errors, <code>Result</code> for recoverable errors</li>
                                            <li>Avoid <code>unwrap()</code> in production code</li>
                                            <li>Panics unwind the stack and exit the program</li>
                                            <li>Use safe alternatives like <code>get()</code> instead of index syntax</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand panics, you'll learn about <strong>Result&lt;T, E&gt;</strong> - Rust's way of handling recoverable errors. The Result type allows you to return either a success value or an error, and the caller can decide how to handle it. This is the preferred way to handle errors in Rust.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="hashmaps.jsp" />
                                    <jsp:param name="prevTitle" value="HashMaps" />
                                    <jsp:param name="nextLink" value="result.jsp" />
                                    <jsp:param name="nextTitle" value="Result Type" />
                                    <jsp:param name="currentLessonId" value="panic" />
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

