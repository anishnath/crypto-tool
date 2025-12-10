<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "type-conversion" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Type Conversion Tutorial - as, From, Into | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust type conversion with examples. Master as keyword, From/Into traits, TryFrom/TryInto, and safe type casting. Free Rust tutorial.">
            <meta name="keywords"
                content="rust type conversion, rust type conversion tutorial, rust as keyword, rust from into, rust tryfrom tryinto, rust type casting, rust parse, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Type Conversion in Rust - as, From, Into">
            <meta property="og:description" content="Master type conversion in Rust with safe and unsafe methods.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/type-conversion.jsp">
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
    "name": "Rust Type Conversion Tutorial - as, From, Into",
    "description": "Learn Rust type conversion with examples. Master as keyword, From/Into traits, TryFrom/TryInto, and safe type casting. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/type-conversion.jsp",
    "keywords": "rust type conversion, rust type conversion tutorial, rust as keyword, rust from into, rust tryfrom tryinto, rust type casting, rust parse, learn rust",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust type conversion", "as keyword", "From trait", "Into trait", "TryFrom", "TryInto", "Type casting"],
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
            "name": "Type Conversion"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="type-conversion">
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
                                    <span>Type Conversion</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Type Conversion in Rust</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Type conversion is the process of converting a value from one type
                                        to
                                        another. Rust provides several
                                        ways to perform type conversions, ranging from simple casting with the
                                        <code>as</code> keyword to safe,
                                        trait-based conversions. In this lesson, you'll learn when and how to use each
                                        method.
                                    </p>

                                    <!-- Section 1: The as Keyword -->
                                    <h2>The <code>as</code> Keyword</h2>
                                    <p>The <code>as</code> keyword is used for primitive type conversions. It's simple
                                        but
                                        can be unsafe:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/type-conversion-as.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-as-keyword" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Warning:</strong> The <code>as</code> keyword can truncate values
                                        without
                                        warning!
                                        Converting a large number to a smaller type will silently lose data.
                                    </div>

                                    <h3>Common Uses of <code>as</code></h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Conversion</th>
                                                <th>Example</th>
                                                <th>Notes</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Integer to Integer</td>
                                                <td><code>let y: i64 = x as i64</code></td>
                                                <td>Can truncate if target is smaller</td>
                                            </tr>
                                            <tr>
                                                <td>Float to Integer</td>
                                                <td><code>let i: i32 = f as i32</code></td>
                                                <td>Truncates decimal part</td>
                                            </tr>
                                            <tr>
                                                <td>Integer to Float</td>
                                                <td><code>let f: f64 = i as f64</code></td>
                                                <td>Safe, no data loss</td>
                                            </tr>
                                            <tr>
                                                <td>Char to Integer</td>
                                                <td><code>let n: u32 = c as u32</code></td>
                                                <td>Gets Unicode code point</td>
                                            </tr>
                                            <tr>
                                                <td>Boolean to Integer</td>
                                                <td><code>let n: i32 = b as i32</code></td>
                                                <td>true=1, false=0</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Use <code>as</code> only for primitive types
                                        when
                                        you're certain the conversion is safe.
                                        For more complex conversions, use traits like <code>From</code> and
                                        <code>Into</code>.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: From and Into Traits -->
                                    <h2>From and Into Traits</h2>
                                    <p>The <code>From</code> and <code>Into</code> traits provide safe, explicit type
                                        conversions:</p>

                                    <h3>The From Trait</h3>
                                    <p><code>From</code> defines how to create a type from another type:</p>

                                    <pre><code class="language-rust">// Converting &str to String
let my_str = "Hello";
let my_string = String::from(my_str);

// Converting i32 to i64
let small: i32 = 42;
let large: i64 = i64::from(small);</code></pre>

                                    <h3>The Into Trait</h3>
                                    <p><code>Into</code> is the reciprocal of <code>From</code>. If a type implements
                                        <code>From</code>, it automatically gets <code>Into</code>:
                                    </p>

                                    <pre><code class="language-rust">let num: i32 = 42;
let num_i64: i64 = num.into(); // Calls i64::from(num)

let text: String = "Hello".into(); // Calls String::from("Hello")</code></pre>

                                    <div class="info-box">
                                        <strong>Key Difference:</strong>
                                        <ul>
                                            <li><code>From::from(value)</code> - Explicit about the target type</li>
                                            <li><code>value.into()</code> - Target type inferred from context</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/type-conversion-traits.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-traits" />
                                    </jsp:include>

                                    <!-- Section 3: Parsing Strings -->
                                    <h2>Parsing Strings to Numbers</h2>
                                    <p>The <code>parse</code> method converts strings to numbers. It returns a
                                        <code>Result</code> because parsing can fail:
                                    </p>

                                    <pre><code class="language-rust">// Using parse with type annotation
let number_str = "42";
let number: i32 = number_str.parse().expect("Not a number!");

// Using turbofish syntax
let float_num = "3.14".parse::<f64>().expect("Not a float!");

// Handling errors with match
let input = "not a number";
match input.parse::<i32>() {
    Ok(n) => println!("Parsed: {}", n),
    Err(e) => println!("Parse error: {}", e),
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Turbofish Syntax:</strong> The <code>::&lt;Type&gt;</code> syntax
                                        (called
                                        "turbofish") explicitly
                                        specifies the type parameter when it can't be inferred.
                                    </div>

                                    <!-- Section 4: TryFrom and TryInto -->
                                    <h2>TryFrom and TryInto Traits</h2>
                                    <p>For conversions that can fail, use <code>TryFrom</code> and <code>TryInto</code>.
                                        They return a <code>Result</code>:</p>

                                    <pre><code class="language-rust">use std::convert::TryFrom;
use std::convert::TryInto;

// TryFrom - safe conversion that can fail
let big_num: i64 = 1000;
let small_num: Result<i8, _> = i8::try_from(big_num);

match small_num {
    Ok(n) => println!("Converted: {}", n),
    Err(e) => println!("Conversion failed: {}", e),
}

// TryInto - the reverse
let value: i32 = 100;
let result: Result<i8, _> = value.try_into();
match result {
    Ok(n) => println!("Success: {}", n),
    Err(e) => println!("Failed: {}", e),
}</code></pre>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Trait</th>
                                                <th>Use Case</th>
                                                <th>Returns</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>From</code></td>
                                                <td>Infallible conversions</td>
                                                <td>Target type</td>
                                            </tr>
                                            <tr>
                                                <td><code>Into</code></td>
                                                <td>Infallible (reciprocal of From)</td>
                                                <td>Target type</td>
                                            </tr>
                                            <tr>
                                                <td><code>TryFrom</code></td>
                                                <td>Fallible conversions</td>
                                                <td><code>Result&lt;T, E&gt;</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>TryInto</code></td>
                                                <td>Fallible (reciprocal of TryFrom)</td>
                                                <td><code>Result&lt;T, E&gt;</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="best-practice-box">
                                        <strong>When to Use Which:</strong>
                                        <ul>
                                            <li>Use <code>as</code> for simple primitive conversions where you're
                                                certain
                                                it's safe</li>
                                            <li>Use <code>From</code>/<code>Into</code> for infallible conversions</li>
                                            <li>Use <code>TryFrom</code>/<code>TryInto</code> when conversion might fail
                                            </li>
                                            <li>Use <code>parse</code> for string-to-number conversions</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Common Conversions -->
                                    <h2>Common Type Conversions</h2>

                                    <h3>String Conversions</h3>
                                    <pre><code class="language-rust">// &str to String
let s1 = String::from("Hello");
let s2 = "World".to_string();

// String to &str
let owned = String::from("Hello");
let borrowed: &str = &owned;

// Number to String
let num = 42;
let num_str = num.to_string();
let formatted = format!("{}", num);</code></pre>

                                    <h3>Number Conversions</h3>
                                    <pre><code class="language-rust">// Safe widening (smaller to larger)
let small: i32 = 42;
let large: i64 = small.into();

// Unsafe narrowing (use TryFrom)
let big: i64 = 1000;
let small: i8 = i8::try_from(big).unwrap_or(-1);

// Float to int (truncates)
let pi: f64 = 3.14;
let pi_int: i32 = pi as i32; // 3</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Silent truncation with <code>as</code></h4>
                                        <p><strong>Problem:</strong></p>
                                        <pre><code class="language-rust">let big: u32 = 1000;
let small: u8 = big as u8; // Silently becomes 232 (1000 % 256)</code></pre>
                                        <p><strong>Solution:</strong></p>
                                        <pre><code class="language-rust">let big: u32 = 1000;
let small: u8 = u8::try_from(big).unwrap_or(255); // Handle overflow</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Not handling parse errors</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let num: i32 = "not a number".parse().unwrap(); // Panics!</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let num: i32 = "not a number".parse().unwrap_or(0); // Default value
// Or use match to handle error properly</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Confusing From and Into</h4>
                                        <p><strong>Problem:</strong></p>
                                        <pre><code class="language-rust">let s: String = "Hello".from(); // Error: from is not a method!</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let s = String::from("Hello"); // From is a trait method
let s: String = "Hello".into(); // Into is a method (needs type annotation)</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Type Conversion Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Fix the code to perform type conversions correctly.
                                        </p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Parse strings to numbers safely</li>
                                            <li>Convert between numeric types</li>
                                            <li>Handle conversion errors properly</li>
                                            <li>Use appropriate conversion methods</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile"
                                                value="rust/exercises/ex-type-conversion-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-type-conversion" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">use std::convert::TryInto;

fn main() {
    // Parse string to integer
    let age_str = "25";
    let age: i32 = age_str.parse().expect("Failed to parse age");
    println!("Age: {}", age);
    
    // Convert float to integer
    let price: f64 = 19.99;
    let price_int = price as i32;
    println!("Price (integer): {}", price_int);
    
    // Safe conversion with error handling
    let big_number: i64 = 1000;
    let small_number: Result<i8, _> = big_number.try_into();
    match small_number {
        Ok(n) => println!("Converted: {}", n),
        Err(_) => println!("Number too large for i8"),
    }
    
    // Parse with error handling
    let input = "not a number";
    match input.parse::<i32>() {
        Ok(n) => println!("Parsed: {}", n),
        Err(e) => println!("Parse error: {}", e),
    }
    
    // Char to Unicode
    let letter = 'Z';
    let unicode_value = letter as u32;
    println!("Unicode value of '{}': {}", letter, unicode_value);
    
    // &str to String
    let str_slice = "Hello, Rust!";
    let owned_string = String::from(str_slice);
    println!("String: {}", owned_string);
    
    // Boolean to integer
    let is_active = true;
    let status_code = is_active as i32;
    println!("Status code: {}", status_code);
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong><code>as</code> keyword:</strong> Simple but unsafe primitive
                                                conversions, can truncate</li>
                                            <li><strong><code>From</code> trait:</strong> Infallible conversions,
                                                explicit
                                                target type</li>
                                            <li><strong><code>Into</code> trait:</strong> Reciprocal of From, target
                                                type
                                                inferred</li>
                                            <li><strong><code>parse</code> method:</strong> Convert strings to numbers,
                                                returns Result</li>
                                            <li><strong><code>TryFrom</code>/<code>TryInto</code>:</strong> Safe
                                                fallible
                                                conversions, return Result</li>
                                            <li>Always handle errors when parsing or converting between incompatible
                                                sizes
                                            </li>
                                            <li>Use <code>unwrap_or</code> or <code>match</code> to handle conversion
                                                failures</li>
                                            <li>Prefer trait-based conversions over <code>as</code> for safety</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand type conversion, you're ready to learn about
                                        <strong>functions</strong>.
                                        In the next lesson, you'll learn how to define functions, pass parameters,
                                        return
                                        values, and understand
                                        the crucial difference between statements and expressions in Rust.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="strings.jsp" />
                                    <jsp:param name="prevTitle" value="Strings" />
                                    <jsp:param name="nextLink" value="functions.jsp" />
                                    <jsp:param name="nextTitle" value="Functions" />
                                    <jsp:param name="currentLessonId" value="type-conversion" />
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