<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "generics" ); request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Generics Tutorial - Generic Types Guide | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust generics with examples. Master generic functions, structs, enums, and trait bounds. Free Rust tutorial with code examples for advanced topics.">
            <meta name="keywords"
                content="rust generics, rust generics tutorial, rust generic types, rust type parameters, rust monomorphization, rust generic functions, learn rust, rust programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Generics in Rust - Generic Types and Functions">
            <meta property="og:description" content="Master Rust generics and type parameters for code reuse.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/generics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

            <script>
                (function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();
            </script>

            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Rust Generics Tutorial - Generic Types Guide",
    "description": "Learn Rust generics with examples. Master generic functions, structs, enums, and trait bounds. Free Rust tutorial with code examples for advanced topics.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/generics.jsp",
    "keywords": "rust generics, rust generics tutorial, rust generic types, rust type parameters, rust monomorphization, rust generic functions, learn rust, rust programming",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust generics", "Generic functions", "Generic types", "Monomorphization", "Type parameters"],
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
            "name": "Generics"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="generics">
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
                                    <span>Generics</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Generics - Generic Types and Functions</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Generics allow you to write code that works with multiple types
                                        while maintaining type safety. Instead of writing separate functions for each
                                        type, you can write one generic function that works with any type. Rust's
                                        generics have zero runtime cost thanks to monomorphization.</p>

                                    <h2>What Are Generics?</h2>
                                    <p>Generics are abstract stand-ins for concrete types. They let you write flexible,
                                        reusable code without sacrificing performance or type safety.</p>

                                    <div class="info-box">
                                        <strong>Zero-Cost Abstraction:</strong> Rust compiles generic code into specific
                                        code for each concrete type used (monomorphization). This means generics have no
                                        runtime overhead!
                                    </div>

                                    <h2>Generic Functions</h2>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-generics.svg"
                                            alt="Rust Generics" class="tutorial-diagram" />
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/generics-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-generics-basics" />
                                    </jsp:include>

                                    <h3>Generic Type Parameters</h3>
                                    <p>Type parameters are specified in angle brackets <code>&lt;T&gt;</code>:</p>

                                    <pre><code class="language-rust">fn function_name<T>(parameter: T) -> T {
    // T is a placeholder for any type
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Generic Structs</h2>
                                    <p>Structs can use generic type parameters to hold values of any type:</p>

                                    <pre><code class="language-rust">struct Point<T> {
    x: T,
    y: T,
}

let integer_point = Point { x: 5, y: 10 };
let float_point = Point { x: 1.0, y: 4.0 };</code></pre>

                                    <h3>Multiple Type Parameters</h3>
                                    <p>You can use multiple type parameters:</p>

                                    <pre><code class="language-rust">struct Point<T, U> {
    x: T,
    y: U,
}

let mixed = Point { x: 5, y: 4.0 };  // x is i32, y is f64</code></pre>

                                    <h2>Generic Enums</h2>
                                    <p>Rust's most common enums are generic:</p>

                                    <pre><code class="language-rust">enum Option<T> {
    Some(T),
    None,
}

enum Result<T, E> {
    Ok(T),
    Err(E),
}</code></pre>

                                    <h2>Generic Implementations</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/generics-methods.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-generics-methods" />
                                    </jsp:include>

                                    <h3>Implementation Types</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Syntax</th>
                                                <th>Use Case</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Generic</td>
                                                <td><code>impl&lt;T&gt; Point&lt;T&gt;</code></td>
                                                <td>Methods for all types</td>
                                            </tr>
                                            <tr>
                                                <td>Specific</td>
                                                <td><code>impl Point&lt;f32&gt;</code></td>
                                                <td>Methods for one type only</td>
                                            </tr>
                                            <tr>
                                                <td>Constrained</td>
                                                <td><code>impl&lt;T: Display&gt; Point&lt;T&gt;</code></td>
                                                <td>Methods for types with trait</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Combining Generics with Traits</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/generics-traits.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-generics-traits" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use trait bounds to constrain generic types. This
                                        ensures the type has the capabilities your code needs while keeping it generic.
                                    </div>

                                    <h2>Trait Bounds Syntax</h2>
                                    <p>Multiple ways to specify trait bounds:</p>

                                    <pre><code class="language-rust">// Inline syntax
fn notify<T: Summary + Display>(item: T) { }

// where clause (more readable for complex bounds)
fn notify<T>(item: T)
where
    T: Summary + Display,
{ }

// impl Trait syntax (simpler for parameters)
fn notify(item: impl Summary + Display) { }</code></pre>

                                    <h2>Monomorphization</h2>
                                    <p>Rust compiles generic code into specific code for each type used:</p>

                                    <pre><code class="language-rust">// You write this:
fn largest<T: PartialOrd>(list: &[T]) -> &T { ... }

let numbers = vec![1, 2, 3];
let chars = vec!['a', 'b', 'c'];
largest(&numbers);
largest(&chars);

// Compiler generates this:
fn largest_i32(list: &[i32]) -> &i32 { ... }
fn largest_char(list: &[char]) -> &char { ... }</code></pre>

                                    <div class="info-box">
                                        <strong>Zero Runtime Cost:</strong> Because of monomorphization, generics have
                                        the same performance as hand-written code for each type!
                                    </div>

                                    <h2>Blanket Implementations</h2>
                                    <p>Implement a trait for any type that satisfies trait bounds:</p>

                                    <pre><code class="language-rust">// Standard library does this for ToString
impl<T: Display> ToString for T {
    fn to_string(&self) -> String {
        format!("{}", self)
    }
}

// Now any type with Display automatically has to_string()
let num = 42;
let s = num.to_string();  // Works!</code></pre>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use descriptive type parameter names:</strong> <code>T</code>
                                                for type, <code>E</code> for error, <code>K</code>/<code>V</code> for
                                                key/value</li>
                                            <li><strong>Add trait bounds when needed:</strong> Constrain types to ensure
                                                required functionality</li>
                                            <li><strong>Use where clauses:</strong> For complex bounds, improve
                                                readability</li>
                                            <li><strong>Prefer generics over duplication:</strong> Write once, use with
                                                many types</li>
                                            <li><strong>Don't over-generalize:</strong> Only make things generic when
                                                needed</li>
                                            <li><strong>Combine with traits:</strong> Generics + traits = powerful
                                                abstractions</li>
                                        </ul>
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting trait bounds</h4>
                                        <pre><code class="language-rust">// Wrong - T might not support comparison
fn largest<T>(list: &[T]) -> &T {
    let mut largest = &list[0];
    for item in list {
        if item > largest {  // Error: can't compare T
            largest = item;
        }
    }
    largest
}

// Correct - Add PartialOrd bound
fn largest<T: PartialOrd>(list: &[T]) -> &T {
    // Now comparison works!
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Mixing incompatible types in generic structs</h4>
                                        <pre><code class="language-rust">// Wrong - x and y must be same type
struct Point<T> {
    x: T,
    y: T,
}

let p = Point { x: 5, y: 4.0 };  // Error: i32 vs f64

// Correct - Use two type parameters
struct Point<T, U> {
    x: T,
    y: U,
}

let p = Point { x: 5, y: 4.0 };  // OK!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not specifying type parameters in impl blocks</h4>
                                        <pre><code class="language-rust">// Wrong - Missing <T> after impl
impl Point<T> {  // Error: can't find type T
    fn x(&self) -> &T {
        &self.x
    }
}

// Correct - Declare type parameter
impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}</code></pre>
                                    </div>

                                    <h2>Exercise: Generics Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement generic functions and a Container struct.
                                        </p>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-generics-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-generics" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">use std::fmt::Display;

fn find_max<T: PartialOrd>(list: &[T]) -> Option<&T> {
    if list.is_empty() {
        return None;
    }
    
    let mut max = &list[0];
    for item in list {
        if item > max {
            max = item;
        }
    }
    Some(max)
}

struct Container<T> {
    value: T,
}

impl<T> Container<T> {
    fn new(value: T) -> Self {
        Self { value }
    }
    
    fn get(&self) -> &T {
        &self.value
    }
    
    fn set(&mut self, value: T) {
        self.value = value;
    }
}

impl<T: Display> Container<T> {
    fn print(&self) {
        println!("Container holds: {}", self.value);
    }
}

fn swap<T>(a: &mut T, b: &mut T) {
    std::mem::swap(a, b);
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Generics</strong> enable code reuse across multiple types</li>
                                            <li><strong>Type parameters</strong> are specified in angle brackets
                                                <code>&lt;T&gt;</code></li>
                                            <li>Work with <strong>functions, structs, enums, and
                                                    implementations</strong></li>
                                            <li><strong>Trait bounds</strong> constrain generic types</li>
                                            <li><strong>Multiple type parameters</strong> with
                                                <code>&lt;T, U, V&gt;</code></li>
                                            <li><strong>where clauses</strong> for complex bounds</li>
                                            <li><strong>Monomorphization</strong> creates specific code at compile time
                                            </li>
                                            <li><strong>Zero runtime cost</strong> - same performance as non-generic
                                                code</li>
                                            <li><strong>Blanket implementations</strong> apply traits to many types</li>
                                            <li>Combine with <strong>traits</strong> for powerful abstractions</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand generics and traits, you're ready to explore more
                                        advanced topics like <strong>Closures</strong> (anonymous functions) and
                                        <strong>Iterators</strong> (lazy evaluation). These features work together with
                                        generics and traits to enable functional programming patterns in Rust.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="traits.jsp" />
                                    <jsp:param name="prevTitle" value="Traits" />
                                    <jsp:param name="nextLink" value="packages-crates.jsp" />
                                    <jsp:param name="nextTitle" value="Packages & Crates" />
                                    <jsp:param name="currentLessonId" value="generics" />
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