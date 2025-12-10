<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Functions Tutorial - Parameters & Return | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust functions with examples. Master function syntax, parameters, return values, statements vs expressions. Free Rust tutorial with code.">
            <meta name="keywords"
                content="rust functions, rust functions tutorial, rust fn, rust parameters, rust return, rust expressions, rust statements, function syntax, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Functions in Rust - Parameters & Return Values">
            <meta property="og:description"
                content="Master Rust functions with parameters, return values, and expressions.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/functions.jsp">
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
    "name": "Rust Functions Tutorial - Parameters & Return",
    "description": "Learn Rust functions with examples. Master function syntax, parameters, return values, statements vs expressions. Free Rust tutorial with code.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/functions.jsp",
    "keywords": "rust functions, rust functions tutorial, rust fn, rust parameters, rust return, rust expressions, rust statements, function syntax, learn rust",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust functions", "Function parameters", "Return values", "Statements vs expressions", "fn keyword"],
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
            "name": "Functions"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="functions">
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
                                    <span>Functions</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Functions</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Functions are the building blocks of Rust programs. You've already
                                        seen the most important function:
                                        <code>main</code>, the entry point of many programs. In this lesson, you'll
                                        learn how to define your own functions,
                                        pass parameters, return values, and understand the crucial difference between
                                        statements and expressions.
                                    </p>

                                    <!-- Section 1: Function Basics -->
                                    <h2>Defining Functions</h2>
                                    <p>Functions are defined using the <code>fn</code> keyword, followed by a name and
                                        parentheses. Rust uses <code>snake_case</code> for function names:</p>

                                    <pre><code class="language-rust">fn function_name() {
    // Function body
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/functions-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Function Naming:</strong>
                                        <ul>
                                            <li>Use <code>snake_case</code> for function names</li>
                                            <li>Names should be descriptive and verb-based</li>
                                            <li>Examples: <code>calculate_sum</code>, <code>print_message</code>,
                                                <code>is_valid</code>
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Parameters -->
                                    <h2>Function Parameters</h2>
                                    <p>Functions can take parameters (also called arguments). You must declare the type
                                        of each parameter:</p>

                                    <pre><code class="language-rust">fn print_number(x: i32) {
    println!("The number is: {}", x);
}

fn print_sum(x: i32, y: i32) {
    println!("{} + {} = {}", x, y, x + y);
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Type Annotations Required:</strong> Unlike variable declarations, you
                                        must always specify parameter types.
                                        This is a deliberate design choice to make function signatures clear and
                                        explicit.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Return Values -->
                                    <h2>Return Values</h2>
                                    <p>Functions can return values. Declare the return type after an arrow
                                        <code>-></code>:
                                    </p>

                                    <pre><code class="language-rust">fn add(x: i32, y: i32) -> i32 {
    x + y  // No semicolon - this is the return value
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/functions-return.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-return" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Implicit Returns:</strong> In Rust, the last expression in a function is
                                        automatically returned.
                                        You can use the <code>return</code> keyword for early returns, but it's
                                        idiomatic to omit it for the final value.
                                    </div>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-function-flow.svg"
                                            alt="Rust Function Flow: Parameters to Return Value"
                                            class="tutorial-diagram" />
                                    </div>

                                    <!-- Section 4: Statements vs Expressions -->
                                    <h2>Statements vs Expressions</h2>
                                    <p>This is a crucial concept in Rust:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Aspect</th>
                                                <th>Statements</th>
                                                <th>Expressions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Definition</td>
                                                <td>Instructions that perform an action</td>
                                                <td>Evaluate to a value</td>
                                            </tr>
                                            <tr>
                                                <td>Return value</td>
                                                <td>Do not return a value</td>
                                                <td>Return a value</td>
                                            </tr>
                                            <tr>
                                                <td>Semicolon</td>
                                                <td>End with <code>;</code></td>
                                                <td>No <code>;</code> at the end</td>
                                            </tr>
                                            <tr>
                                                <td>Examples</td>
                                                <td><code>let x = 5;</code></td>
                                                <td><code>5 + 6</code>, <code>{ x + 1 }</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/functions-expressions.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-expressions" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Key Point:</strong> Adding a semicolon to an expression turns it into a
                                        statement.
                                        This is why <code>x + y</code> returns a value, but <code>x + y;</code> does
                                        not.
                                    </div>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-statements-vs-expressions.svg"
                                            alt="Rust Statements vs Expressions" class="tutorial-diagram" />
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Adding semicolon to return expression</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">fn add(x: i32, y: i32) -> i32 {
    x + y;  // Error: expected i32, found ()
}</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">fn add(x: i32, y: i32) -> i32 {
    x + y  // No semicolon - this is an expression
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Missing parameter types</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">fn greet(name) {  // Error: expected type
    println!("Hello, {}!", name);
}</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">fn greet(name: &str) {  // Type annotation required
    println!("Hello, {}!", name);
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting return type annotation</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">fn multiply(x: i32, y: i32) {  // Missing -> i32
    x * y
}</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">fn multiply(x: i32, y: i32) -> i32 {
    x * y
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Create Your Own Functions</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement the missing functions.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Implement <code>multiply</code> to multiply two numbers</li>
                                            <li>Implement <code>is_even</code> to check if a number is even</li>
                                            <li>Implement <code>max</code> to return the larger of two numbers</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-functions-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-functions" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn main() {
    println!("5 * 3 = {}", multiply(5, 3));
    println!("Is 7 even? {}", is_even(7));
    println!("Max of 10 and 20: {}", max(10, 20));
}

fn multiply(a: i32, b: i32) -> i32 {
    a * b
}

fn is_even(n: i32) -> bool {
    n % 2 == 0
}

fn max(a: i32, b: i32) -> i32 {
    if a > b {
        a
    } else {
        b
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Functions are defined with <code>fn</code> keyword</li>
                                            <li>Use <code>snake_case</code> for function names</li>
                                            <li><strong>Parameter types must be declared</strong> explicitly</li>
                                            <li>Return type is specified with <code>-> Type</code></li>
                                            <li><strong>Statements</strong> perform actions but don't return values</li>
                                            <li><strong>Expressions</strong> evaluate to values</li>
                                            <li>Last expression in a function is implicitly returned (no semicolon)</li>
                                            <li>Use <code>return</code> keyword for early returns</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've learned the fundamentals of Rust: variables, types, and functions. In the
                                        next lesson, we'll cover
                                        <strong>comments and documentation</strong>, learning how to write clear,
                                        maintainable code and generate
                                        beautiful documentation for your Rust projects.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="type-conversion.jsp" />
                                    <jsp:param name="prevTitle" value="Type Conversion" />
                                    <jsp:param name="nextLink" value="comments.jsp" />
                                    <jsp:param name="nextTitle" value="Comments" />
                                    <jsp:param name="currentLessonId" value="functions" />
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