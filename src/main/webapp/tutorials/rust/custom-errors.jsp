<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "custom-errors" ); request.setAttribute("currentModule", "Error Handling" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Custom Errors Tutorial - Error Types | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust custom errors with examples. Create error types with enums/structs, implement Display and Error traits. Free Rust tutorial with code.">
            <meta name="keywords"
                content="rust custom errors, rust custom errors tutorial, rust error types, rust error trait, rust Display trait, rust error handling, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Custom Errors in Rust - Creating Error Types">
            <meta property="og:description" content="Master creating custom error types in Rust.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/custom-errors.jsp">
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
    "name": "Rust Custom Errors Tutorial - Error Types",
    "description": "Learn Rust custom errors with examples. Create error types with enums/structs, implement Display and Error traits. Free Rust tutorial with code.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/custom-errors.jsp",
    "keywords": "rust custom errors, rust custom errors tutorial, rust error types, rust error trait, rust Display trait, rust error handling, learn rust",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust custom errors", "Error types", "Display trait", "Error trait", "Error handling"],
    "timeRequired": "PT35M",
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
            "name": "Custom Errors"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="custom-errors">
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
                                    <span>Custom Errors</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Custom Errors</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">While Rust's standard library provides many error types, creating
                                        your own custom error types gives you better control over error messages, allows
                                        you to add context, and makes your error handling more structured and
                                        maintainable. Custom errors are essential for building robust, user-friendly
                                        applications.
                                    </p>

                                    <h2>Why Custom Errors?</h2>
                                    <p>Custom error types provide several benefits:</p>
                                    <ul>
                                        <li><strong>Better error messages:</strong> Provide context-specific error messages</li>
                                        <li><strong>Type safety:</strong> Compiler ensures you handle all error cases</li>
                                        <li><strong>Structured errors:</strong> Organize errors by domain or module</li>
                                        <li><strong>Error context:</strong> Include additional information about the error</li>
                                        <li><strong>Error chaining:</strong> Preserve error chain for debugging</li>
                                    </ul>

                                    <h2>Creating Custom Error Types</h2>
                                    <p>There are two main ways to create custom error types:</p>
                                    <ol>
                                        <li><strong>Using enums:</strong> For multiple error variants</li>
                                        <li><strong>Using structs:</strong> For errors with additional context</li>
                                    </ol>

                                    <h2>Custom Error with Enum</h2>
                                    <p>Enums are great when you have multiple error variants:</p>

                                    <pre><code class="language-rust">use std::fmt;

#[derive(Debug)]
enum MathError {
    DivisionByZero,
    NegativeNumber,
    Overflow,
}

impl fmt::Display for MathError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            MathError::DivisionByZero => write!(f, "Cannot divide by zero"),
            MathError::NegativeNumber => write!(f, "Number cannot be negative"),
            MathError::Overflow => write!(f, "Arithmetic overflow occurred"),
        }
    }
}

impl std::error::Error for MathError {}
</code></pre>

                                    <div class="info-box">
                                        <strong>Required Traits:</strong> To use your error type with <code>Result</code>
                                        and the <code>?</code> operator, you need to implement both <code>Display</code>
                                        (for user-facing messages) and <code>Error</code> (for error handling).
                                    </div>

                                    <h2>Using Custom Error Types</h2>
                                    <p>Once you've defined your error type, you can use it in functions:</p>

                                    <pre><code class="language-rust">fn divide(a: i32, b: i32) -> Result&lt;i32, MathError&gt; {
    if b == 0 {
        Err(MathError::DivisionByZero)
    } else {
        Ok(a / b)
    }
}

fn sqrt(n: i32) -> Result&lt;f64, MathError&gt; {
    if n &lt; 0 {
        Err(MathError::NegativeNumber)
    } else {
        Ok((n as f64).sqrt())
    }
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/custom-errors.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-custom-errors" />
                                    </jsp:include>

                                    <h2>Custom Error with Struct</h2>
                                    <p>Structs are useful when you need to include additional context:</p>

                                    <pre><code class="language-rust">use std::fmt;

#[derive(Debug)]
struct ValidationError {
    field: String,
    message: String,
}

impl fmt::Display for ValidationError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Validation error in {}: {}", self.field, self.message)
    }
}

impl std::error::Error for ValidationError {}

fn validate_age(age: i32) -> Result&lt;i32, ValidationError&gt; {
    if age &lt; 0 {
        Err(ValidationError {
            field: String::from("age"),
            message: String::from("Age cannot be negative"),
        })
    } else if age > 150 {
        Err(ValidationError {
            field: String::from("age"),
            message: String::from("Age cannot exceed 150"),
        })
    } else {
        Ok(age)
    }
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Context Matters:</strong> Struct-based errors allow you to include
                                        context like which field failed, what value was provided, and why it failed.
                                        This makes debugging much easier!
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/custom-errors-struct.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-custom-errors-struct" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Implementing the Error Trait</h2>
                                    <p>The <code>Error</code> trait has several optional methods. The minimal
                                        implementation is just an empty impl block:</p>

                                    <pre><code class="language-rust">impl std::error::Error for MathError {}
</code></pre>

                                    <p>However, you can implement additional methods for more functionality:</p>

                                    <h3>source() - Error Chaining</h3>
                                    <pre><code class="language-rust">impl std::error::Error for AppError {
    fn source(&self) -> Option&lt;&(dyn std::error::Error + 'static)&gt; {
        self.source.as_deref()
    }
}</code></pre>

                                    <div class="info-box">
                                        <strong>Error Chaining:</strong> The <code>source()</code> method allows you to
                                        chain errors, preserving the original error while wrapping it with additional
                                        context. This is very useful for debugging.
                                    </div>

                                    <h2>Error Conversion</h2>
                                    <p>You can convert between error types using the <code>From</code> trait. This allows
                                        the <code>?</code> operator to automatically convert errors:</p>

                                    <pre><code class="language-rust">impl From&lt;std::num::ParseIntError&gt; for MathError {
    fn from(err: std::num::ParseIntError) -> Self {
        MathError::ParseError(err.to_string())
    }
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Automatic Conversion:</strong> Implementing <code>From</code> allows the
                                        <code>?</code> operator to automatically convert between compatible error types,
                                        making error handling more flexible.
                                    </div>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use enums for variants:</strong> When you have multiple related error types</li>
                                            <li><strong>Use structs for context:</strong> When you need to include additional information</li>
                                            <li><strong>Implement Display:</strong> Always provide user-friendly error messages</li>
                                            <li><strong>Implement Error:</strong> Required for use with Result and ? operator</li>
                                            <li><strong>Add Debug derive:</strong> Makes debugging easier with {:?}</li>
                                            <li><strong>Use descriptive names:</strong> Make error types self-documenting</li>
                                            <li><strong>Include context:</strong> Add fields that help understand what went wrong</li>
                                            <li><strong>Implement From:</strong> For automatic error conversion</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to implement Display</h4>
                                        <pre><code class="language-rust">// Wrong - No Display implementation
#[derive(Debug)]
enum MyError {
    SomethingWentWrong,
}

// Correct - Implement Display
#[derive(Debug)]
enum MyError {
    SomethingWentWrong,
}

impl fmt::Display for MyError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Something went wrong")
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Not implementing Error trait</h4>
                                        <pre><code class="language-rust">// Wrong - Can't use with ? operator
#[derive(Debug)]
struct MyError {
    message: String,
}

impl fmt::Display for MyError { /* ... */ }

// Correct - Implement Error trait
impl std::error::Error for MyError {}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Generic error messages</h4>
                                        <pre><code class="language-rust">// Wrong - Not helpful
impl fmt::Display for ValidationError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Error")  // Too generic!
    }
}

// Correct - Include context
impl fmt::Display for ValidationError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Validation error in {}: {}", self.field, self.message)
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Not using Debug derive</h4>
                                        <pre><code class="language-rust">// Wrong - Can't use {:?}
enum MyError {
    SomethingWentWrong,
}

// Correct - Add Debug derive
#[derive(Debug)]
enum MyError {
    SomethingWentWrong,
}</code></pre>
                                    </div>

                                    <h2>Exercise: Custom Errors Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create custom error types and use them in your functions.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create an error enum with multiple variants</li>
                                            <li>Create an error struct with context fields</li>
                                            <li>Implement Display and Error traits</li>
                                            <li>Use your custom errors in functions</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-custom-errors-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-custom-errors" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">use std::fmt;

#[derive(Debug)]
enum CalculationError {
    DivisionByZero,
    NegativeSquareRoot,
    Overflow,
}

impl fmt::Display for CalculationError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            CalculationError::DivisionByZero => write!(f, "Division by zero"),
            CalculationError::NegativeSquareRoot => write!(f, "Cannot take square root of negative number"),
            CalculationError::Overflow => write!(f, "Arithmetic overflow"),
        }
    }
}

impl std::error::Error for CalculationError {}

fn safe_calculate(a: f64, b: f64) -> Result&lt;f64, CalculationError&gt; {
    if b == 0.0 {
        return Err(CalculationError::DivisionByZero);
    }
    let result = a / b;
    if result &lt; 0.0 {
        return Err(CalculationError::NegativeSquareRoot);
    }
    Ok(result.sqrt())
}

#[derive(Debug)]
struct ValidationError {
    field: String,
    value: String,
    message: String,
}

impl fmt::Display for ValidationError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Validation error in {} (value: '{}'): {}", 
               self.field, self.value, self.message)
    }
}

impl std::error::Error for ValidationError {}

fn validate_email(email: &str) -> Result&lt;String, ValidationError&gt; {
    if !email.contains('@') {
        Err(ValidationError {
            field: String::from("email"),
            value: email.to_string(),
            message: String::from("Email must contain '@'"),
        })
    } else {
        Ok(email.to_string())
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Custom errors</strong> provide better error messages and structure</li>
                                            <li>Use <strong>enums</strong> for multiple error variants</li>
                                            <li>Use <strong>structs</strong> for errors with context</li>
                                            <li>Implement <strong>Display</strong> trait for user-friendly messages</li>
                                            <li>Implement <strong>Error</strong> trait for use with Result</li>
                                            <li>Add <strong>Debug</strong> derive for easier debugging</li>
                                            <li>Implement <strong>From</strong> for automatic error conversion</li>
                                            <li>Include <strong>context</strong> in error messages</li>
                                            <li>Use descriptive error type names</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p><strong>Congratulations!</strong> You've completed the Error Handling module. You
                                        now understand how to handle errors in Rust using panics, Results, error
                                        propagation, and custom error types. These concepts are fundamental to writing
                                        robust Rust programs.
                                    </p>
                                    <p>In the next modules, you'll learn about advanced Rust features like traits,
                                        generics, lifetimes, and more that build on these error handling foundations.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="error-propagation.jsp" />
                                    <jsp:param name="prevTitle" value="Error Propagation" />
                                    <jsp:param name="nextLink" value="traits.jsp" />
                                    <jsp:param name="nextTitle" value="Traits" />
                                    <jsp:param name="currentLessonId" value="custom-errors" />
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

