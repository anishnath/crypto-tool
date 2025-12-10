<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "traits" ); request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Traits Tutorial - Shared Behavior Guide | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust traits with examples. Master trait implementations, default methods, trait bounds, and polymorphism. Free Rust tutorial with code examples.">
            <meta name="keywords"
                content="rust traits, rust traits tutorial, rust interfaces, rust polymorphism, rust trait bounds, rust shared behavior, rust trait examples, learn rust, rust programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Traits in Rust - Defining Shared Behavior">
            <meta property="og:description" content="Master Rust traits and polymorphism.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/traits.jsp">
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
    "name": "Rust Traits Tutorial - Shared Behavior Guide",
    "description": "Learn Rust traits with examples. Master trait implementations, default methods, trait bounds, and polymorphism. Free Rust tutorial with code examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/rust/traits.jsp",
    "keywords": "rust traits, rust traits tutorial, rust interfaces, rust polymorphism, rust trait bounds, rust shared behavior, rust trait examples, learn rust, rust programming",
    "teaches": ["Rust traits", "Trait implementations", "Default methods", "Trait bounds", "Polymorphism", "Trait objects", "Associated types"],
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
            "name": "Traits"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="traits">
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
                                    <span>Traits</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Traits - Defining Shared Behavior</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Traits are Rust's way of defining shared behavior. They're similar
                                        to interfaces in other languages, allowing you to define a set of methods that
                                        types must implement. Traits enable polymorphism and code reuse in a type-safe
                                        way.</p>

                                    <h2>What Are Traits?</h2>
                                    <p>A trait defines functionality a particular type has and can share with other
                                        types. We use traits to define shared behavior in an abstract way.</p>

                                    <pre><code class="language-rust">trait Summary {
    fn summarize(&self) -> String;
}</code></pre>

                                    <div class="info-box">
                                        <strong>Think of Traits Like:</strong> Interfaces in Java/C#, protocols in
                                        Swift, or type classes in Haskell. They define a contract that types must
                                        fulfill.
                                    </div>

                                    <h2>Defining and Implementing Traits</h2>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-traits.svg"
                                            alt="Rust Traits" class="tutorial-diagram" />
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/traits-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-traits-basics" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Default Implementations</h2>
                                    <p>Traits can provide default method implementations that types can use or override:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/traits-default.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-traits-default" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Default implementations can call other trait methods,
                                        even if they don't have default implementations. This allows you to build
                                        complex behavior from simple requirements.
                                    </div>

                                    <h2>Traits as Parameters</h2>
                                    <p>You can use traits to accept multiple types that implement the same trait:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/traits-parameters.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-traits-parameters" />
                                    </jsp:include>

                                    <h3>Two Syntaxes for Trait Parameters</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Syntax</th>
                                                <th>Example</th>
                                                <th>Use Case</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>impl Trait</code></td>
                                                <td><code>fn notify(item: &impl Summary)</code></td>
                                                <td>Simple cases, more concise</td>
                                            </tr>
                                            <tr>
                                                <td>Trait Bound</td>
                                                <td><code>fn notify&lt;T: Summary&gt;(item: &T)</code></td>
                                                <td>Complex bounds, multiple parameters</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Multiple Trait Bounds</h2>
                                    <p>You can require a type to implement multiple traits:</p>

                                    <pre><code class="language-rust">// Using + to specify multiple traits
fn notify(item: &(impl Summary + Display)) {
    // item must implement both Summary and Display
}

// Generic syntax
fn notify<T: Summary + Display>(item: &T) {
    // Same thing
}

// where clause for readability
fn some_function<T, U>(t: &T, u: &U) -> i32
where
    T: Display + Clone,
    U: Clone + Debug,
{
    // Function body
}</code></pre>

                                    <h2>Returning Types that Implement Traits</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/traits-advanced.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-traits-advanced" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> When using <code>impl Trait</code> as a return type,
                                        you can only return ONE concrete type. You can't return different types even if
                                        they both implement the trait.
                                    </div>

                                    <h2>Common Standard Library Traits</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Trait</th>
                                                <th>Purpose</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>Debug</code></td>
                                                <td>Formatting with {:?}</td>
                                                <td><code>#[derive(Debug)]</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>Clone</code></td>
                                                <td>Explicit duplication</td>
                                                <td><code>let y = x.clone();</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>Copy</code></td>
                                                <td>Implicit duplication</td>
                                                <td><code>let y = x;</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>Display</code></td>
                                                <td>User-facing output</td>
                                                <td><code>println!("{}", x)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>PartialEq</code></td>
                                                <td>Equality comparison</td>
                                                <td><code>x == y</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>PartialOrd</code></td>
                                                <td>Ordering comparison</td>
                                                <td><code>x < y</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Deriving Traits</h2>
                                    <p>Many common traits can be automatically implemented using <code>#[derive]</code>:
                                    </p>

                                    <pre><code class="language-rust">#[derive(Debug, Clone, PartialEq, PartialOrd)]
struct Point {
    x: i32,
    y: i32,
}

let p1 = Point { x: 5, y: 10 };
let p2 = p1.clone();
println!("{:?}", p1);  // Uses Debug
println!("{}", p1 == p2);  // Uses PartialEq</code></pre>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use traits for shared behavior:</strong> Define common
                                                functionality across types</li>
                                            <li><strong>Provide default implementations:</strong> Make traits easier to
                                                implement</li>
                                            <li><strong>Derive when possible:</strong> Use <code>#[derive]</code> for
                                                standard traits</li>
                                            <li><strong>Use impl Trait for simple cases:</strong> More concise than
                                                generics</li>
                                            <li><strong>Use where clauses:</strong> For complex trait bounds</li>
                                            <li><strong>Keep traits focused:</strong> Single responsibility principle
                                            </li>
                                        </ul>
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Trying to return different types with impl Trait</h4>
                                        <pre><code class="language-rust">// Wrong - Can't return different types
fn get_summary(switch: bool) -> impl Summary {
    if switch {
        NewsArticle { ... }  // Type 1
    } else {
        Tweet { ... }  // Type 2 - Error!
    }
}

// Correct - Use Box<dyn Trait> for dynamic dispatch
fn get_summary(switch: bool) -> Box<dyn Summary> {
    if switch {
        Box::new(NewsArticle { ... })
    } else {
        Box::new(Tweet { ... })
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Forgetting to implement required methods</h4>
                                        <pre><code class="language-rust">// Wrong - Missing required method
trait Summary {
    fn summarize(&self) -> String;
    fn author(&self) -> String;
}

impl Summary for Article {
    fn summarize(&self) -> String {
        String::from("Article")
    }
    // Error: missing author() implementation
}

// Correct - Implement all required methods
impl Summary for Article {
    fn summarize(&self) -> String {
        String::from("Article")
    }
    fn author(&self) -> String {
        String::from("Unknown")
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Orphan rule violation</h4>
                                        <pre><code class="language-rust">// Wrong - Can't implement external trait for external type
impl Display for Vec<i32> {  // Error: orphan rule
    // Can't implement Display (std) for Vec (std)
}

// Correct - Wrap in newtype pattern
struct MyVec(Vec<i32>);

impl Display for MyVec {  // OK!
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        write!(f, "{:?}", self.0)
    }
}</code></pre>
                                    </div>

                                    <h2>Exercise: Traits Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement Drawable and Area traits for shapes.</p>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-traits-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-traits" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">trait Drawable {
    fn draw(&self) -> String;
}

trait Area {
    fn area(&self) -> f64;
}

impl Drawable for Circle {
    fn draw(&self) -> String {
        format!("Circle with radius {}", self.radius)
    }
}

impl Area for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * self.radius * self.radius
    }
}

impl Drawable for Rectangle {
    fn draw(&self) -> String {
        format!("Rectangle {}x{}", self.width, self.height)
    }
}

impl Area for Rectangle {
    fn area(&self) -> f64 {
        self.width * self.height
    }
}

fn print_drawing(item: &impl Drawable) {
    println!("{}", item.draw());
}

fn total_area<T: Area>(shapes: &[&T]) -> f64 {
    shapes.iter().map(|s| s.area()).sum()
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Traits</strong> define shared behavior across types</li>
                                            <li>Similar to <strong>interfaces</strong> in other languages</li>
                                            <li>Can have <strong>default implementations</strong></li>
                                            <li>Use <strong>impl Trait</strong> or <strong>generics</strong> for
                                                parameters</li>
                                            <li><strong>Trait bounds</strong> constrain generic types</li>
                                            <li><strong>Multiple bounds</strong> with <code>+</code> operator</li>
                                            <li><strong>where clauses</strong> for complex bounds</li>
                                            <li><strong>Derive</strong> common traits automatically</li>
                                            <li>Enable <strong>polymorphism</strong> in Rust</li>
                                            <li><strong>Orphan rule:</strong> trait or type must be local</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand traits, you're ready to learn about
                                        <strong>Generics</strong> - how to write code that works with any type. Generics
                                        and traits work together to enable powerful, reusable abstractions in Rust.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="enums.jsp" />
                                    <jsp:param name="prevTitle" value="Enums" />
                                    <jsp:param name="nextLink" value="generics.jsp" />
                                    <jsp:param name="nextTitle" value="Generics" />
                                    <jsp:param name="currentLessonId" value="traits" />
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