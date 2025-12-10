<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "error-propagation" ); request.setAttribute("currentModule", "Error Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Error Propagation Tutorial - ? Operator | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust error propagation with examples. Master the ? operator, automatic error conversion, and chaining Result operations. Free Rust tutorial.">
            <meta name="keywords"
                content="rust error propagation, rust error propagation tutorial, rust ? operator, rust question mark operator, rust error handling, rust Result propagation, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Error Propagation in Rust - The ? Operator">
            <meta property="og:description" content="Master Rust error propagation with the ? operator.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/error-propagation.jsp">
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
    "name": "Rust Error Propagation Tutorial - ? Operator",
    "description": "Learn Rust error propagation with examples. Master the ? operator, automatic error conversion, and chaining Result operations. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/error-propagation.jsp",
    "keywords": "rust error propagation, rust error propagation tutorial, rust ? operator, rust question mark operator, rust error handling, rust Result propagation, learn rust",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust error propagation", "? operator", "Result propagation", "Error conversion"],
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
            "name": "Error Propagation"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="error-propagation">
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
                                    <span>Error Propagation</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Error Propagation</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The <code>?</code> operator is Rust's way of propagating errors
                                        automatically. Instead of writing verbose <code>match</code> expressions to
                                        handle every <code>Result</code>, you can use <code>?</code> to automatically
                                        return errors to the caller. This makes error handling much more concise and
                                        readable.
                                    </p>

                                    <h2>What is the ? Operator?</h2>
                                    <p>The <code>?</code> operator is a shorthand for propagating errors. When placed
                                        after a <code>Result</code> value, it:</p>
                                    <ul>
                                        <li>If the value is <code>Ok</code>, it unwraps the value and continues</li>
                                        <li>If the value is <code>Err</code>, it returns the error from the function</li>
                                    </ul>

                                    <h2>Before: Verbose Error Handling</h2>
                                    <p>Without the <code>?</code> operator, you need to write verbose <code>match</code>
                                        expressions:</p>

                                    <pre><code class="language-rust">use std::fs::File;
use std::io::Read;

fn read_username_from_file() -> Result&lt;String, std::io::Error&gt; {
    let mut f = match File::open("hello.txt") {
        Ok(file) => file,
        Err(e) => return Err(e),
    };
    
    let mut s = String::new();
    match f.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    }
}</code></pre>

                                    <h2>After: Using the ? Operator</h2>
                                    <p>With the <code>?</code> operator, the same code becomes much more concise:</p>

                                    <pre><code class="language-rust">use std::fs::File;
use std::io::Read;

fn read_username_from_file() -> Result&lt;String, std::io::Error&gt; {
    let mut f = File::open("hello.txt")?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Much Cleaner:</strong> The <code>?</code> operator reduces boilerplate
                                        code significantly, making error handling more readable and maintainable.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/error-propagation.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-error-propagation" />
                                    </jsp:include>

                                    <h2>How ? Works</h2>
                                    <p>The <code>?</code> operator is syntactic sugar for:</p>

                                    <pre><code class="language-rust">match result {
    Ok(value) => value,
    Err(error) => return Err(error.into()),
}</code></pre>

                                    <p>Notice that it uses <code>error.into()</code>, which means it can convert between
                                        compatible error types automatically!</p>

                                    <div class="info-box">
                                        <strong>Automatic Conversion:</strong> The <code>?</code> operator uses
                                        <code>Into</code> trait to convert error types, allowing you to use different
                                        error types in the same function chain.
                                    </div>

                                    <h2>Using ? with Different Error Types</h2>
                                    <p>You can use <code>?</code> with different error types by using
                                        <code>Box&lt;dyn std::error::Error&gt;</code>:</p>

                                    <pre><code class="language-rust">use std::fs::File;
use std::io::Read;

fn parse_and_read() -> Result&lt;i32, Box&lt;dyn std::error::Error&gt;&gt; {
    let mut s = String::new();
    File::open("number.txt")?
        .read_to_string(&mut s)?;
    let num: i32 = s.trim().parse()?;
    Ok(num)
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Box&lt;dyn Error&gt;:</strong> This type can hold any error type that
                                        implements the <code>Error</code> trait, allowing you to mix different error
                                        types in one function.
                                    </div>

                                    <h2>Chaining Operations with ?</h2>
                                    <p>You can chain multiple operations that return <code>Result</code>:</p>

                                    <pre><code class="language-rust">fn read_file_contents(filename: &str) -> Result&lt;String, std::io::Error&gt; {
    let mut file = File::open(filename)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}</code></pre>

                                    <p>Or even more concisely:</p>

                                    <pre><code class="language-rust">fn read_and_parse(filename: &str) -> Result&lt;i32, Box&lt;dyn std::error::Error&gt;&gt; {
    let contents = std::fs::read_to_string(filename)?;
    let number: i32 = contents.trim().parse()?;
    Ok(number)
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/error-propagation-chaining.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-error-chaining" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Using ? in main()</h2>
                                    <p>You can use <code>?</code> in <code>main()</code> by changing its return type:</p>

                                    <pre><code class="language-rust">fn main() -> Result&lt;(), Box&lt;dyn std::error::Error&gt;&gt; {
    let username = read_username_from_file()?;
    println!("Username: {}", username);
    Ok(())
}</code></pre>

                                    <div class="info-box">
                                        <strong>main() Return Type:</strong> When <code>main()</code> returns
                                        <code>Result</code>, Rust will print the error and exit with a non-zero status
                                        code if an error occurs.
                                    </div>

                                    <h2>When Can You Use ?</h2>
                                    <p>The <code>?</code> operator can only be used in functions that return
                                        <code>Result</code> (or <code>Option</code>). It cannot be used in functions
                                        that return other types.</p>

                                    <pre><code class="language-rust">// ✅ OK - Function returns Result
fn read_file() -> Result&lt;String, std::io::Error&gt; {
    let contents = std::fs::read_to_string("file.txt")?;
    Ok(contents)
}

// ❌ Error - Function doesn't return Result
fn read_file() -> String {
    let contents = std::fs::read_to_string("file.txt")?;  // Error!
    contents
}
</code></pre>

                                    <h2>Converting Error Types</h2>
                                    <p>The <code>?</code> operator automatically converts error types using the
                                        <code>Into</code> trait:</p>

                                    <pre><code class="language-rust">use std::num::ParseIntError;

fn parse_number(s: &str) -> Result&lt;i32, ParseIntError&gt; {
    s.parse()
}

fn read_and_parse() -> Result&lt;i32, Box&lt;dyn std::error::Error&gt;&gt; {
    let contents = std::fs::read_to_string("number.txt")?;  // io::Error
    let number = contents.trim().parse()?;  // ParseIntError
    Ok(number)
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Error Conversion:</strong> Both <code>io::Error</code> and
                                        <code>ParseIntError</code> can be converted to <code>Box&lt;dyn Error&gt;</code>
                                        automatically, allowing you to use <code>?</code> with different error types.
                                    </div>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use ? for error propagation:</strong> Prefer ? over verbose match expressions</li>
                                            <li><strong>Use Box&lt;dyn Error&gt; for mixed errors:</strong> When combining different error types</li>
                                            <li><strong>Keep functions focused:</strong> Let errors propagate to the caller</li>
                                            <li><strong>Add context when needed:</strong> Use map_err() before ? to add context</li>
                                            <li><strong>Use ? in main():</strong> Change main() return type to Result for cleaner error handling</li>
                                            <li><strong>Document error conditions:</strong> Make it clear what errors your function can return</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using ? in functions that don't return Result</h4>
                                        <pre><code class="language-rust">// Wrong - Function doesn't return Result
fn read_file() -> String {
    let contents = std::fs::read_to_string("file.txt")?;  // Error!
    contents
}

// Correct - Function returns Result
fn read_file() -> Result&lt;String, std::io::Error&gt; {
    let contents = std::fs::read_to_string("file.txt")?;
    Ok(contents)
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Not handling incompatible error types</h4>
                                        <pre><code class="language-rust">// Wrong - Different error types
fn process() -> Result&lt;i32, std::io::Error&gt; {
    let num: i32 = "5".parse()?;  // Error! ParseIntError != io::Error
    Ok(num)
}

// Correct - Use Box&lt;dyn Error&gt;
fn process() -> Result&lt;i32, Box&lt;dyn std::error::Error&gt;&gt; {
    let num: i32 = "5".parse()?;
    Ok(num)
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting to return Ok() at the end</h4>
                                        <pre><code class="language-rust">// Wrong - Missing Ok()
fn read_file() -> Result&lt;String, std::io::Error&gt; {
    let contents = std::fs::read_to_string("file.txt")?;
    contents  // Error! Should be Ok(contents)
}

// Correct - Return Ok()
fn read_file() -> Result&lt;String, std::io::Error&gt; {
    let contents = std::fs::read_to_string("file.txt")?;
    Ok(contents)
}</code></pre>
                                    </div>

                                    <h2>Exercise: Error Propagation Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement functions using the ? operator for error propagation.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Read and parse numbers from files</li>
                                            <li>Chain multiple operations with ?</li>
                                            <li>Handle different error types</li>
                                            <li>Use Box&lt;dyn Error&gt; for mixed error types</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-error-propagation-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-error-propagation" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">use std::fs::File;
use std::io::Read;

fn read_number_from_file(filename: &str) -> Result&lt;i32, Box&lt;dyn std::error::Error&gt;&gt; {
    let mut file = File::open(filename)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    let number: i32 = contents.trim().parse()?;
    Ok(number)
}

fn read_divide(filename: &str) -> Result&lt;f64, Box&lt;dyn std::error::Error&gt;&gt; {
    let contents = std::fs::read_to_string(filename)?;
    let divisor: i32 = contents.trim().parse()?;
    if divisor == 0 {
        return Err("Division by zero".into());
    }
    Ok(100.0 / divisor as f64)
}

fn validate_and_divide(n: i32) -> Result&lt;f64, String&gt; {
    if n &lt;= 0 {
        return Err(String::from("Number must be positive"));
    }
    if n == 0 {
        return Err(String::from("Division by zero"));
    }
    Ok(100.0 / n as f64)
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>? operator</strong> propagates errors automatically</li>
                                            <li>Can only be used in functions that return <code>Result</code> or <code>Option</code></li>
                                            <li>Unwraps <code>Ok</code> values, returns <code>Err</code> values</li>
                                            <li>Automatically converts error types using <code>Into</code> trait</li>
                                            <li>Use <code>Box&lt;dyn Error&gt;</code> for mixed error types</li>
                                            <li>Much more concise than verbose <code>match</code> expressions</li>
                                            <li>Can be used in <code>main()</code> by changing return type</li>
                                            <li>Chains multiple operations cleanly</li>
                                            <li>Remember to return <code>Ok()</code> at the end</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand error propagation, you'll learn about <strong>custom error types</strong>. Creating your own error types allows you to provide better error messages, add context, and make your error handling more structured and maintainable.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="result.jsp" />
                                    <jsp:param name="prevTitle" value="Result Type" />
                                    <jsp:param name="nextLink" value="custom-errors.jsp" />
                                    <jsp:param name="nextTitle" value="Custom Errors" />
                                    <jsp:param name="currentLessonId" value="error-propagation" />
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

