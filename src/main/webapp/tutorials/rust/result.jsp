<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "result" ); request.setAttribute("currentModule", "Error Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Result Type Tutorial - Error Handling | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust Result type with examples. Master Result&lt;T,E&gt;, Ok/Err variants, Result methods, and error handling patterns. Free Rust tutorial.">
            <meta name="keywords"
                content="rust result, rust result tutorial, rust error handling, rust Result type, rust Ok Err, rust error recovery, rust error handling examples, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Result Type in Rust - Recoverable Error Handling">
            <meta property="og:description" content="Master Rust Result type for recoverable error handling.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/result.jsp">
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
    "name": "Rust Result Type Tutorial - Error Handling",
    "description": "Learn Rust Result type with examples. Master Result&lt;T,E&gt;, Ok/Err variants, Result methods, and error handling patterns. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/result.jsp",
    "keywords": "rust result, rust result tutorial, rust error handling, rust Result type, rust Ok Err, rust error recovery, rust error handling examples, learn rust",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust Result", "Result&lt;T, E&gt;", "Error handling", "Ok variant", "Err variant", "Result methods"],
    "timeRequired": "PT35M",
    "isPartOf": {
        "@type": "Course",
        "name": "Rust Tutorial",
        "description": "Complete Rust programming course from beginner to advanced with interactive examples",
        "url": "https://8gwifi.org/tutorials/rust/",
        "provider": {
            "@type": "Organization",
            "name": "8gwifi.org"
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
            "name": "Result Type"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="result">
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
                                    <span>Result Type</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Result Type</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The <code>Result&lt;T, E&gt;</code> type is Rust's way of handling
                                        recoverable errors. Unlike panics, which stop execution, Result allows you to
                                        return either a success value (<code>Ok(T)</code>) or an error value
                                        (<code>Err(E)</code>), letting the caller decide how to handle the error. This is
                                        the preferred way to handle errors in Rust.
                                    </p>

                                    <h2>What is Result?</h2>
                                    <p><code>Result&lt;T, E&gt;</code> is an enum with two variants:</p>

                                    <pre><code class="language-rust">enum Result&lt;T, E&gt; {
    Ok(T),
    Err(E),
}</code></pre>

                                    <ul>
                                        <li><code>Ok(T)</code> - Contains the success value of type <code>T</code></li>
                                        <li><code>Err(E)</code> - Contains the error value of type <code>E</code></li>
                                    </ul>

                                    <div class="info-box">
                                        <strong>In the Prelude:</strong> <code>Result</code> is so commonly used that it's
                                        included in the prelude - you don't need to import it!
                                    </div>

                                    <h2>Creating Results</h2>
                                    <p>You can create Result values directly:</p>

                                    <pre><code class="language-rust">let success: Result&lt;i32, &str&gt; = Ok(42);
let failure: Result&lt;i32, &str&gt; = Err("something went wrong");</code></pre>

                                    <h2>Functions That Return Result</h2>
                                    <p>Many standard library functions return <code>Result</code>. For example, file
                                        operations:</p>

                                    <pre><code class="language-rust">use std::fs::File;

let file_result = File::open("hello.txt");
// file_result is Result&lt;File, std::io::Error&gt;</code></pre>

                                    <p>You can also write functions that return <code>Result</code>:</p>

                                    <pre><code class="language-rust">fn divide(a: i32, b: i32) -> Result&lt;i32, String&gt; {
    if b == 0 {
        Err(String::from("Division by zero"))
    } else {
        Ok(a / b)
    }
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/result-handling.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-result-handling" />
                                    </jsp:include>

                                    <h2>Handling Results with match</h2>
                                    <p>The most explicit way to handle a <code>Result</code> is with <code>match</code>:</p>

                                    <pre><code class="language-rust">let result = divide(10, 2);

match result {
    Ok(value) => println!("Result: {}", value),
    Err(error) => println!("Error: {}", error),
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Exhaustive Matching:</strong> <code>match</code> ensures you handle both
                                        <code>Ok</code> and <code>Err</code> cases. The compiler will error if you miss
                                        one!
                                    </div>

                                    <h2>Handling Different Error Types</h2>
                                    <p>When working with I/O operations, you can match on different error kinds:</p>

                                    <pre><code class="language-rust">use std::fs::File;
use std::io::ErrorKind;

let file_result = File::open("hello.txt");

let file = match file_result {
    Ok(file) => file,
    Err(error) => match error.kind() {
        ErrorKind::NotFound => {
            println!("File not found");
            // Handle file not found
            return;
        }
        ErrorKind::PermissionDenied => {
            println!("Permission denied");
            return;
        }
        other_error => {
            println!("Other error: {:?}", other_error);
            return;
        }
    },
};</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Result Helper Methods</h2>
                                    <p><code>Result</code> provides many useful methods for handling errors:</p>

                                    <h3>unwrap_or() - Provide Default Value</h3>
                                    <pre><code class="language-rust">let result: Result&lt;i32, &str&gt; = Err("error");
let value = result.unwrap_or(0);  // Returns 0 if Err</code></pre>

                                    <h3>unwrap_or_else() - Compute Default</h3>
                                    <pre><code class="language-rust">let value = result.unwrap_or_else(|error| {
    println!("Error: {}", error);
    0  // Compute default value
});</code></pre>

                                    <h3>map() - Transform Ok Value</h3>
                                    <pre><code class="language-rust">let result: Result&lt;i32, &str&gt; = Ok(5);
let doubled = result.map(|x| x * 2);  // Ok(10)</code></pre>

                                    <h3>map_err() - Transform Err Value</h3>
                                    <pre><code class="language-rust">let result: Result&lt;i32, &str&gt; = Err("error");
let mapped = result.map_err(|e| format!("Error: {}", e));</code></pre>

                                    <h3>and_then() - Chain Results</h3>
                                    <pre><code class="language-rust">let result: Result&lt;i32, &str&gt; = Ok(5);
let chained = result.and_then(|x| {
    if x > 0 {
        Ok(x * 2)
    } else {
        Err("must be positive")
    }
});</code></pre>

                                    <h3>or_else() - Handle Error Case</h3>
                                    <pre><code class="language-rust">let result: Result&lt;i32, &str&gt; = Err("error");
let recovered = result.or_else(|e| {
    println!("Recovering from: {}", e);
    Ok(0)  // Return alternative Result
});</code></pre>

                                    <h3>is_ok() and is_err() - Check Without Unwrapping</h3>
                                    <pre><code class="language-rust">if result.is_ok() {
    println!("Success!");
}

if result.is_err() {
    println!("Error occurred");
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/result-methods.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-result-methods" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Avoid unwrap() and expect():</strong> While <code>unwrap()</code> and
                                        <code>expect()</code> exist on <code>Result</code>, they cause panics. Use them
                                        only in examples, tests, or when you're absolutely certain the value is
                                        <code>Ok</code>.
                                    </div>

                                    <h2>Using if let</h2>
                                    <p>When you only care about one variant, <code>if let</code> is more concise:</p>

                                    <pre><code class="language-rust">if let Ok(value) = result {
    println!("Success: {}", value);
}

if let Err(error) = result {
    println!("Error: {}", error);
}</code></pre>

                                    <h2>Chaining Results</h2>
                                    <p>You can chain multiple operations that return <code>Result</code> using
                                        <code>and_then()</code>:</p>

                                    <pre><code class="language-rust">fn parse_number(s: &str) -> Result&lt;i32, String&gt; {
    s.parse::&lt;i32&gt;().map_err(|e| format!("Parse error: {}", e))
}

fn double(n: i32) -> Result&lt;i32, String&gt; {
    Ok(n * 2)
}

let result = parse_number("5")
    .and_then(double)
    .and_then(|n| Ok(n + 1));

match result {
    Ok(value) => println!("Result: {}", value),
    Err(e) => println!("Error: {}", e),
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Method Chaining:</strong> <code>and_then()</code> allows you to chain
                                        operations that return <code>Result</code>, making error handling more elegant
                                        and readable.
                                    </div>

                                    <h2>When to Use Result</h2>
                                    <div class="best-practice-box">
                                        <p><strong>Use <code>Result&lt;T, E&gt;</code> when:</strong></p>
                                        <ul>
                                            <li><strong>Errors are recoverable:</strong> The caller can handle the error</li>
                                            <li><strong>I/O operations:</strong> File operations, network requests, etc.</li>
                                            <li><strong>Parsing/validation:</strong> User input, data parsing, etc.</li>
                                            <li><strong>Production code:</strong> When you need robust error handling</li>
                                            <li><strong>Library functions:</strong> When callers need to handle errors</li>
                                        </ul>
                                        
                                        <p style="margin-top: 15px;"><strong>Use <code>panic!</code> when:</strong></p>
                                        <ul>
                                            <li><strong>Unrecoverable errors:</strong> When there's no way to recover</li>
                                            <li><strong>Programming errors:</strong> Bugs in your code</li>
                                            <li><strong>Examples/tests:</strong> When panics are acceptable</li>
                                        </ul>
                                    </div>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Always handle both cases:</strong> Use match or if let to handle Ok and Err</li>
                                            <li><strong>Use helper methods:</strong> unwrap_or, map, and_then make code cleaner</li>
                                            <li><strong>Chain operations:</strong> Use and_then() to chain Result-returning functions</li>
                                            <li><strong>Provide context:</strong> Use map_err() to add context to errors</li>
                                            <li><strong>Avoid unwrap() in production:</strong> Always handle errors properly</li>
                                            <li><strong>Use ? operator:</strong> For error propagation (covered in next lesson)</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to handle the Err case</h4>
                                        <pre><code class="language-rust">// Wrong - Only handles Ok
let result: Result&lt;i32, &str&gt; = Err("error");
let value = result.unwrap();  // Panics!

// Correct - Handle both cases
match result {
    Ok(value) => println!("{}", value),
    Err(error) => println!("Error: {}", error),
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using unwrap() everywhere</h4>
                                        <pre><code class="language-rust">// Wrong - Can panic
let file = File::open("file.txt").unwrap();

// Correct - Handle the error
let file = match File::open("file.txt") {
    Ok(file) => file,
    Err(error) => {
        println!("Failed to open file: {}", error);
        return;
    }
};</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not providing error context</h4>
                                        <pre><code class="language-rust">// Wrong - Generic error
fn parse(s: &str) -> Result&lt;i32, &str&gt; {
    s.parse().map_err(|_| "error")
}

// Correct - Descriptive error
fn parse(s: &str) -> Result&lt;i32, String&gt; {
    s.parse::&lt;i32&gt;()
        .map_err(|e| format!("Failed to parse '{}': {}", s, e))
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Not chaining Results properly</h4>
                                        <pre><code class="language-rust">// Wrong - Nested matches
let result1 = parse_number("5");
match result1 {
    Ok(n) => {
        let result2 = double(n);
        match result2 {
            Ok(v) => println!("{}", v),
            Err(e) => println!("{}", e),
        }
    }
    Err(e) => println!("{}", e),
}

// Correct - Use and_then
parse_number("5")
    .and_then(double)
    .map(|v| println!("{}", v))
    .map_err(|e| println!("{}", e));</code></pre>
                                    </div>

                                    <h2>Exercise: Result Handling Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement functions that return Result and handle errors properly.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Write a function to parse numbers from strings</li>
                                            <li>Write a safe division function</li>
                                            <li>Chain operations using and_then()</li>
                                            <li>Handle all error cases properly</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-result-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-result" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn parse_number(s: &str) -> Result&lt;i32, String&gt; {
    s.parse::&lt;i32&gt;()
        .map_err(|e| format!("Failed to parse '{}': {}", s, e))
}

fn safe_divide(a: f64, b: f64) -> Result&lt;f64, String&gt; {
    if b == 0.0 {
        Err(String::from("Division by zero"))
    } else {
        Ok(a / b)
    }
}

fn parse_and_divide(s: &str) -> Result&lt;i32, String&gt; {
    parse_number(s)
        .and_then(|n| {
            if n == 0 {
                Err(String::from("Cannot divide by zero"))
            } else {
                safe_divide(100.0, n as f64)
                    .map(|result| result as i32)
            }
        })
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Result&lt;T, E&gt;</strong> represents success (Ok) or failure (Err)</li>
                                            <li>Use <code>match</code> to handle both cases exhaustively</li>
                                            <li>Use helper methods: <code>unwrap_or()</code>, <code>map()</code>, <code>and_then()</code></li>
                                            <li>Chain operations with <code>and_then()</code> for cleaner code</li>
                                            <li>Use <code>map_err()</code> to add context to errors</li>
                                            <li>Result is for recoverable errors, panic is for unrecoverable</li>
                                            <li>Always handle both Ok and Err cases</li>
                                            <li>Avoid <code>unwrap()</code> in production code</li>
                                            <li>Many standard library functions return Result</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand <code>Result</code>, you'll learn about <strong>error propagation</strong> using the <code>?</code> operator. This powerful operator allows you to propagate errors up the call stack automatically, making error handling much more concise and readable.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="panic.jsp" />
                                    <jsp:param name="prevTitle" value="Panic!" />
                                    <jsp:param name="nextLink" value="error-propagation.jsp" />
                                    <jsp:param name="nextTitle" value="Error Propagation" />
                                    <jsp:param name="currentLessonId" value="result" />
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

