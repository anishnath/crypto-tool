<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "methods" ); request.setAttribute("currentModule", "Structs & Enums" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Methods Tutorial - impl Blocks Guide | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust methods with examples. Master impl blocks, self parameters, associated functions, and method syntax. Free Rust tutorial with code.">
            <meta name="keywords"
                content="rust methods, rust methods tutorial, rust impl, rust self, rust associated functions, rust method syntax, learn rust, rust programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Methods in Rust - impl Blocks and Associated Functions">
            <meta property="og:description" content="Master Rust methods and associated functions.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/methods.jsp">
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
    "name": "Rust Methods Tutorial - impl Blocks Guide",
    "description": "Learn Rust methods with examples. Master impl blocks, self parameters, associated functions, and method syntax. Free Rust tutorial with code.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/methods.jsp",
    "keywords": "rust methods, rust methods tutorial, rust impl, rust self, rust associated functions, rust method syntax, learn rust, rust programming",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust methods", "impl blocks", "Associated functions", "self parameter", "Method syntax"],
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
            "name": "Methods"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="methods">
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
                                    <span>Methods</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Methods & Associated Functions</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Methods are functions that are defined within the context of a
                                        struct
                                        (or enum or trait object).
                                        Their first parameter is always <code>self</code>, which represents the instance
                                        of the struct the method is
                                        being called on. Methods let you organize functionality that belongs to a type.
                                    </p>

                                    <h2>Defining Methods</h2>
                                    <p>Methods are defined within an <code>impl</code> (implementation) block:</p>

                                    <pre><code class="language-rust">struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}</code></pre>

                                    <div class="info-box">
                                        <strong>The self Parameter:</strong> The <code>&self</code> is short for
                                        <code>self: &Self</code>. Within an
                                        <code>impl</code> block, <code>Self</code> is an alias for the type that the
                                        <code>impl</code> block is for.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/methods-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-methods-basics" />
                                    </jsp:include>

                                    <h2>Methods vs Associated Functions</h2>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-methods.svg"
                                            alt="Methods vs Associated Functions" class="tutorial-diagram" />
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The self Parameter</h2>
                                    <p>Methods can take ownership of <code>self</code>, borrow it immutably, or borrow
                                        it mutably:</p>

                                    <h3>1. &self (Immutable Borrow)</h3>
                                    <p>Most common. Read-only access to the instance:</p>
                                    <pre><code class="language-rust">fn area(&self) -> u32 {
    self.width * self.height
}</code></pre>

                                    <h3>2. &mut self (Mutable Borrow)</h3>
                                    <p>When you need to modify the instance:</p>
                                    <pre><code class="language-rust">fn scale(&mut self, factor: u32) {
    self.width *= factor;
    self.height *= factor;
}</code></pre>

                                    <h3>3. self (Take Ownership)</h3>
                                    <p>Rare. Consumes the instance:</p>
                                    <pre><code class="language-rust">fn into_string(self) -> String {
    format!("{}x{}", self.width, self.height)
}</code></pre>

                                    <h2>Associated Functions</h2>
                                    <p>Functions within <code>impl</code> blocks that don't take <code>self</code> are
                                        called <em>associated
                                            functions</em>. They're often used as constructors:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/associated-functions.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-associated-functions" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Naming Convention:</strong> By convention, associated functions that
                                        create new instances are named
                                        <code>new</code>, but this isn't enforced by the language.
                                    </div>

                                    <h2>Multiple impl Blocks</h2>
                                    <p>You can have multiple <code>impl</code> blocks for the same type:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/methods-advanced.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-methods-advanced" />
                                    </jsp:include>

                                    <h2>Automatic Referencing and Dereferencing</h2>
                                    <p>Rust automatically adds <code>&</code>, <code>&mut</code>, or <code>*</code> to
                                        match the method signature:</p>

                                    <pre><code class="language-rust">let rect = Rectangle { width: 30, height: 50 };

// These are equivalent
rect.area();
(&rect).area();</code></pre>

                                    <div class="info-box">
                                        <strong>Automatic Behavior:</strong> When you call a method with
                                        <code>object.method()</code>, Rust
                                        automatically adds <code>&</code>, <code>&mut</code>, or <code>*</code> so
                                        <code>object</code> matches the
                                        signature of the method.
                                    </div>

                                    <h2>Method Call Syntax</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Syntax</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Method</td>
                                                <td><code>instance.method()</code></td>
                                                <td><code>rect.area()</code></td>
                                            </tr>
                                            <tr>
                                                <td>Associated Function</td>
                                                <td><code>Type::function()</code></td>
                                                <td><code>Rectangle::new(30, 50)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use &self by default:</strong> Only use <code>&mut self</code>
                                                or
                                                <code>self</code> when needed
                                            </li>
                                            <li><strong>Create constructors:</strong> Use <code>new()</code> as an
                                                associated function</li>
                                            <li><strong>Group related functionality:</strong> Put all methods for a type
                                                in <code>impl</code> blocks</li>
                                            <li><strong>Use descriptive names:</strong> Method names should clearly
                                                indicate what they do</li>
                                            <li><strong>Return Self for chaining:</strong> Return <code>&mut Self</code>
                                                to enable method chaining</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Caution:</strong> When you use <code>self</code> (taking ownership), the instance is consumed and can no longer be used. Only use this when you're transforming the instance into something else, like converting it to a different type.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to use &self, &mut self, or self</h4>
                                        <pre><code class="language-rust">// Wrong - Missing self parameter
impl Rectangle {
    fn area() -> u32 {  // Error: no self parameter
        self.width * self.height
    }
}

// Correct
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using &mut self when &self would suffice</h4>
                                        <pre><code class="language-rust">// Wrong - Unnecessary mutability
impl Rectangle {
    fn area(&mut self) -> u32 {  // Doesn't need to mutate
        self.width * self.height
    }
}

// Correct - Use &self for read-only operations
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Confusing methods with associated functions</h4>
                                        <pre><code class="language-rust">// Wrong - Trying to call associated function like a method
let rect = Rectangle::new(30, 50);
let area = rect.new(30, 50);  // Error: new doesn't have self

// Correct - Use :: for associated functions
let rect = Rectangle::new(30, 50);
let area = rect.area();  // Use . for methods</code></pre>
                                    </div>

                                    <h2>Exercise: Methods Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement methods for BankAccount and Temperature
                                            structs.</p>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-methods-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-methods" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">impl BankAccount {
    fn new(owner: String, initial_balance: f64) -> BankAccount {
        BankAccount {
            balance: initial_balance,
            owner,
        }
    }
    
    fn deposit(&mut self, amount: f64) {
        self.balance += amount;
    }
    
    fn withdraw(&mut self, amount: f64) -> bool {
        if self.balance >= amount {
            self.balance -= amount;
            true
        } else {
            false
        }
    }
    
    fn balance(&self) -> f64 {
        self.balance
    }
}

impl Temperature {
    fn from_celsius(celsius: f64) -> Temperature {
        Temperature { celsius }
    }
    
    fn from_fahrenheit(fahrenheit: f64) -> Temperature {
        Temperature {
            celsius: (fahrenheit - 32.0) * 5.0 / 9.0,
        }
    }
    
    fn to_fahrenheit(&self) -> f64 {
        self.celsius * 9.0 / 5.0 + 32.0
    }
    
    fn is_freezing(&self) -> bool {
        self.celsius <= 0.0
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Methods</strong> are functions defined in <code>impl</code>
                                                blocks
                                            </li>
                                            <li>Methods have <code>self</code> as first parameter</li>
                                            <li><strong>&self:</strong> Immutable borrow (most common)</li>
                                            <li><strong>&mut self:</strong> Mutable borrow (for modifications)</li>
                                            <li><strong>self:</strong> Takes ownership (rare)</li>
                                            <li><strong>Associated functions</strong> don't have <code>self</code></li>
                                            <li>Call methods with <code>instance.method()</code></li>
                                            <li>Call associated functions with <code>Type::function()</code></li>
                                            <li>Rust automatically handles referencing/dereferencing</li>
                                            <li>Multiple <code>impl</code> blocks are allowed</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand structs and methods, you'll learn about
                                        <strong>enums</strong> - another way
                                        to create custom types. Enums let you define a type by enumerating its possible
                                        variants, and they're
                                        incredibly powerful when combined with pattern matching.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="structs.jsp" />
                                    <jsp:param name="prevTitle" value="Structs" />
                                    <jsp:param name="nextLink" value="enums.jsp" />
                                    <jsp:param name="nextTitle" value="Enums" />
                                    <jsp:param name="currentLessonId" value="methods" />
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