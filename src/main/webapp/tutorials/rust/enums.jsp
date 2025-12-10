<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "enums" ); request.setAttribute("currentModule", "Structs & Enums" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Enums Tutorial - Option, Result & Match | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust enums with examples. Master enum syntax, Option&lt;T&gt;, Result&lt;T,E&gt;, pattern matching, and enum methods. Free Rust tutorial.">
            <meta name="keywords"
                content="rust enums, rust enums tutorial, rust option, rust result, rust pattern matching, rust enum variants, rust match, learn rust, rust programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Enums in Rust - Option, Result & Pattern Matching">
            <meta property="og:description" content="Master Rust enums and pattern matching.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/enums.jsp">
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
    "name": "Rust Enums Tutorial - Option, Result & Match",
    "description": "Learn Rust enums with examples. Master enum syntax, Option&lt;T&gt;, Result&lt;T,E&gt;, pattern matching, and enum methods. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/enums.jsp",
    "keywords": "rust enums, rust enums tutorial, rust option, rust result, rust pattern matching, rust enum variants, rust match, learn rust, rust programming",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust enums", "Option type", "Result type", "Pattern matching", "Enum variants"],
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
            "name": "Enums"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="enums">
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
                                    <span>Enums</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Enums & Pattern Matching</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Enums allow you to define a type by enumerating its possible
                                        variants.
                                        Unlike structs, which
                                        group related data together, enums let you say a value is one of a possible set
                                        of values. Enums are
                                        incredibly powerful in Rust, especially when combined with pattern matching.
                                    </p>

                                    <h2>Defining Enums</h2>
                                    <p>Here's a simple enum:</p>

                                    <pre><code class="language-rust">enum IpAddrKind {
    V4,
    V6,
}

let four = IpAddrKind::V4;
let six = IpAddrKind::V6;</code></pre>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-enums.svg"
                                            alt="Rust Enums" class="tutorial-diagram" />
                                    </div>

                                    <h2>Enums with Data</h2>
                                    <p>Enum variants can have associated data:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/enums-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-enums-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Flexibility:</strong> Each variant can have different types and amounts
                                        of
                                        associated data. This is
                                        more flexible than using multiple structs!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The Option Enum</h2>
                                    <p>Rust doesn't have null. Instead, it has <code>Option&lt;T&gt;</code>:</p>

                                    <pre><code class="language-rust">enum Option<T> {
    Some(T),
    None,
}</code></pre>

                                    <p><code>Option&lt;T&gt;</code> is so useful it's included in the prelude - you
                                        don't
                                        need to import it!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/option-enum.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-option" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>No Null Pointer Errors:</strong> By using <code>Option&lt;T&gt;</code>,
                                        Rust forces you to handle the
                                        case where a value might be absent, preventing null pointer errors at compile
                                        time!
                                    </div>

                                    <h2>The Result Enum</h2>
                                    <p><code>Result&lt;T, E&gt;</code> is used for error handling:</p>

                                    <pre><code class="language-rust">enum Result<T, E> {
    Ok(T),
    Err(E),
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/result-enum.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-result" />
                                    </jsp:include>

                                    <h2>Pattern Matching with match</h2>
                                    <p>The <code>match</code> expression is extremely powerful for working with enums:
                                    </p>

                                    <pre><code class="language-rust">enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Exhaustive Matching:</strong> <code>match</code> expressions must be
                                        exhaustive - you must handle
                                        every possible case!
                                    </div>

                                    <h2>Matching with Data</h2>
                                    <p>You can extract data from enum variants:</p>

                                    <pre><code class="language-rust">enum Message {
    Move { x: i32, y: i32 },
    Write(String),
}

fn process(msg: Message) {
    match msg {
        Message::Move { x, y } => {
            println!("Move to ({}, {})", x, y);
        }
        Message::Write(text) => {
            println!("Text: {}", text);
        }
    }
}</code></pre>

                                    <h2>The if let Syntax</h2>
                                    <p>For when you only care about one variant:</p>

                                    <pre><code class="language-rust">let some_value = Some(3);

// Using match
match some_value {
    Some(3) => println!("three"),
    _ => (),
}

// Using if let - more concise!
if let Some(3) = some_value {
    println!("three");
}</code></pre>

                                    <h2>Enum Methods</h2>
                                    <p>Enums can have methods just like structs:</p>

                                    <pre><code class="language-rust">enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
}

impl Message {
    fn call(&self) {
        match self {
            Message::Quit => println!("Quit"),
            Message::Move { x, y } => println!("Move to ({}, {})", x, y),
            Message::Write(text) => println!("Write: {}", text),
        }
    }
}</code></pre>

                                    <h2>Common Option Methods</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Method</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>is_some()</code></td>
                                                <td>Returns true if Some</td>
                                                <td><code>value.is_some()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>is_none()</code></td>
                                                <td>Returns true if None</td>
                                                <td><code>value.is_none()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>unwrap_or(default)</code></td>
                                                <td>Returns value or default</td>
                                                <td><code>value.unwrap_or(0)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>map(f)</code></td>
                                                <td>Transform the value</td>
                                                <td><code>value.map(|x| x * 2)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use Option instead of null:</strong> Prevents null pointer
                                                errors
                                            </li>
                                            <li><strong>Use Result for error handling:</strong> Makes errors explicit
                                            </li>
                                            <li><strong>Prefer match for exhaustive handling:</strong> Compiler ensures
                                                all
                                                cases covered</li>
                                            <li><strong>Use if let for single variant:</strong> More concise when you
                                                only
                                                care about one case</li>
                                            <li><strong>Add methods to enums:</strong> Encapsulate behavior with the
                                                data
                                            </li>
                                            <li><strong>Use descriptive variant names:</strong> Make code
                                                self-documenting
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Not handling all enum variants in match</h4>
                                        <pre><code class="language-rust">// Wrong - Not exhaustive
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        // Error: non-exhaustive patterns
    }
}

// Correct - Handle all cases
fn value(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using unwrap() without checking Option/Result</h4>
                                        <pre><code class="language-rust">// Wrong - Can panic at runtime
let value = some_option.unwrap();  // Panics if None
let result = some_result.unwrap();  // Panics if Err

// Correct - Handle the cases properly
match some_option {
    Some(value) => println!("Value: {}", value),
    None => println!("No value"),
}

// Or use unwrap_or for defaults
let value = some_option.unwrap_or(0);</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting to use :: for enum variants</h4>
                                        <pre><code class="language-rust">// Wrong - Missing :: operator
enum IpAddrKind {
    V4,
    V6,
}

let addr = V4;  // Error: cannot find value `V4` in this scope

// Correct - Use :: to access enum variants
let addr = IpAddrKind::V4;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Not extracting data from enum variants properly</h4>
                                        <pre><code class="language-rust">// Wrong - Can't access variant data directly
enum Message {
    Write(String),
    Move { x: i32, y: i32 },
}

let msg = Message::Write(String::from("hello"));
println!("{}", msg.text);  // Error: no field `text`

// Correct - Use match or if let to extract
match msg {
    Message::Write(text) => println!("{}", text),
    Message::Move { x, y } => println!("Move to ({}, {})", x, y),
}</code></pre>
                                    </div>

                                    <h2>Exercise: Enums Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement enums for shapes and web events.</p>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-enums-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-enums" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">enum Shape {
    Circle(f64),
    Rectangle(f64, f64),
    Triangle(f64, f64),
}

impl Shape {
    fn area(&self) -> f64 {
        match self {
            Shape::Circle(r) => std::f64::consts::PI * r * r,
            Shape::Rectangle(w, h) => w * h,
            Shape::Triangle(b, h) => 0.5 * b * h,
        }
    }
}

enum WebEvent {
    PageLoad,
    PageUnload,
    KeyPress(char),
    Click { x: i64, y: i64 },
}

impl WebEvent {
    fn inspect(&self) {
        match self {
            WebEvent::PageLoad => println!("Page loaded"),
            WebEvent::PageUnload => println!("Page unloaded"),
            WebEvent::KeyPress(c) => println!("Key pressed: {}", c),
            WebEvent::Click { x, y } => println!("Clicked at ({}, {})", x, y),
        }
    }
}

fn find_first_even(numbers: Vec<i32>) -> Option<i32> {
    for num in numbers {
        if num % 2 == 0 {
            return Some(num);
        }
    }
    None
}

fn safe_sqrt(x: f64) -> Result<f64, String> {
    if x < 0.0 {
        Err(String::from("Cannot take square root of negative number"))
    } else {
        Ok(x.sqrt())
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Enums</strong> define a type by enumerating variants</li>
                                            <li>Variants can have <strong>associated data</strong></li>
                                            <li><strong>Option&lt;T&gt;</strong> replaces null - Some(T) or None</li>
                                            <li><strong>Result&lt;T, E&gt;</strong> for error handling - Ok(T) or Err(E)
                                            </li>
                                            <li><strong>match</strong> expression for pattern matching</li>
                                            <li>Match must be <strong>exhaustive</strong></li>
                                            <li><strong>if let</strong> for matching single variant</li>
                                            <li>Enums can have <strong>methods</strong> via impl blocks</li>
                                            <li>Enums are <strong>zero-cost abstractions</strong></li>
                                            <li>Pattern matching is <strong>compile-time checked</strong></li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p><strong>Congratulations!</strong> You've completed the Structs & Enums module.
                                        You
                                        now know how to create
                                        custom types with structs and enums, add methods to them, and use pattern
                                        matching
                                        to handle different
                                        cases safely.
                                    </p>
                                    <p>In the next modules, you'll learn about collections (vectors, strings, hash
                                        maps),
                                        error handling in depth,
                                        and more advanced Rust features that build on these foundations.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="methods.jsp" />
                                    <jsp:param name="prevTitle" value="Methods" />
                                    <jsp:param name="nextLink" value="vectors.jsp" />
                                    <jsp:param name="nextTitle" value="Vectors" />
                                    <jsp:param name="currentLessonId" value="enums" />
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