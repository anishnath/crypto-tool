<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "variables" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Variables Tutorial - Mutability & Constants | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust variables with examples. Master mutability, immutability, constants, and shadowing. Free Rust tutorial for beginners with code examples.">
            <meta name="keywords"
                content="rust variables, rust variables tutorial, rust mutability, rust immutable, rust mut, rust constants, rust shadowing, rust let, learn rust, rust tutorial">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Variables & Mutability in Rust">
            <meta property="og:description"
                content="Master Rust variables, mutability, and shadowing with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/variables.jsp">
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
    "name": "Rust Variables Tutorial - Mutability & Constants",
    "description": "Learn Rust variables with examples. Master mutability, immutability, constants, and shadowing. Free Rust tutorial for beginners with code examples.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/variables.jsp",
    "keywords": "rust variables, rust variables tutorial, rust mutability, rust immutable, rust mut, rust constants, rust shadowing, rust let, learn rust, rust tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust variables", "Mutability", "Immutability", "Constants", "Shadowing", "let keyword"],
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
            "name": "Variables & Mutability"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="variables">
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
                                    <span>Variables & Mutability</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Variables & Mutability</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Variables in Rust are immutable by default—a key design choice that
                                        promotes safety and prevents bugs.
                                        In this lesson, you'll learn how Rust handles variables, when and how to make
                                        them mutable, the difference between
                                        variables and constants, and the powerful concept of shadowing.</p>

                                    <!-- Section 1: Variables are Immutable by Default -->
                                    <h2>Variables are Immutable by Default</h2>
                                    <p>In Rust, when you declare a variable with <code>let</code>, it's immutable by
                                        default. This means once you bind a value to a name, you can't change that
                                        value:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/variables-mutability.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-mutability" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Why Immutable by Default?</strong>
                                        <ul>
                                            <li><strong>Safety:</strong> Prevents accidental changes to values</li>
                                            <li><strong>Concurrency:</strong> Immutable data can be safely shared
                                                between threads</li>
                                            <li><strong>Clarity:</strong> Makes code easier to reason about</li>
                                            <li><strong>Optimization:</strong> Compiler can make better optimizations
                                            </li>
                                        </ul>
                                    </div>

                                    <h3>Making Variables Mutable</h3>
                                    <p>When you need to change a variable's value, add the <code>mut</code> keyword:</p>

                                    <pre><code class="language-rust">let mut x = 5;  // Mutable variable
x = 6;          // OK: x is mutable</code></pre>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-mutability.svg"
                                            alt="Rust Mutability: Immutable vs Mutable Variables"
                                            class="tutorial-diagram" />
                                    </div>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Only use <code>mut</code> when you actually need
                                        to change a variable.
                                        Immutability by default helps catch bugs early and makes your intentions clear.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: Constants -->
                                    <h2>Constants</h2>
                                    <p>Constants are similar to immutable variables, but with important differences:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Variables (let)</th>
                                                <th>Constants (const)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Mutability</td>
                                                <td>Can be made mutable with <code>mut</code></td>
                                                <td>Always immutable</td>
                                            </tr>
                                            <tr>
                                                <td>Type annotation</td>
                                                <td>Optional (type inference)</td>
                                                <td>Required</td>
                                            </tr>
                                            <tr>
                                                <td>Scope</td>
                                                <td>Any scope</td>
                                                <td>Any scope (often global)</td>
                                            </tr>
                                            <tr>
                                                <td>Value</td>
                                                <td>Can be runtime value</td>
                                                <td>Must be compile-time constant</td>
                                            </tr>
                                            <tr>
                                                <td>Naming</td>
                                                <td>snake_case</td>
                                                <td>SCREAMING_SNAKE_CASE</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-rust">const MAX_POINTS: u32 = 100_000;
const PI: f64 = 3.14159;

fn main() {
    println!("Max points: {}", MAX_POINTS);
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Constants must be set to a constant expression, not
                                        the result of a function call
                                        or any value computed at runtime.
                                    </div>

                                    <!-- Section 3: Shadowing -->
                                    <h2>Shadowing</h2>
                                    <p>Rust allows you to declare a new variable with the same name as a previous
                                        variable. The new variable <em>shadows</em> the previous one:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/variables-shadowing.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-shadowing" />
                                    </jsp:include>

                                    <h3>Shadowing vs Mutability</h3>
                                    <p>Shadowing is different from marking a variable as <code>mut</code>:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Aspect</th>
                                                <th>Shadowing</th>
                                                <th>Mutability</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Creates new variable</td>
                                                <td>✅ Yes</td>
                                                <td>❌ No</td>
                                            </tr>
                                            <tr>
                                                <td>Can change type</td>
                                                <td>✅ Yes</td>
                                                <td>❌ No</td>
                                            </tr>
                                            <tr>
                                                <td>Requires <code>let</code></td>
                                                <td>✅ Yes</td>
                                                <td>❌ No</td>
                                            </tr>
                                            <tr>
                                                <td>Variable is immutable</td>
                                                <td>✅ Yes (by default)</td>
                                                <td>❌ No</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="best-practice-box">
                                        <strong>When to Use Shadowing:</strong>
                                        <ul>
                                            <li>When you want to transform a value but keep the same name</li>
                                            <li>When you need to change the type of a value</li>
                                            <li>When you want to reuse a descriptive variable name</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Trying to mutate an immutable variable</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let x = 5;
x = 6;  // Error: cannot assign twice to immutable variable</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let mut x = 5;  // Add mut keyword
x = 6;          // OK</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Forgetting type annotation for constants</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">const MAX = 100;  // Error: missing type annotation</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">const MAX: u32 = 100;  // Type annotation required</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Confusing shadowing with mutation</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let spaces = "   ";
spaces = spaces.len();  // Error: can't change type without let</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let spaces = "   ";
let spaces = spaces.len();  // OK: shadowing allows type change</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Fix the Variables</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Fix the code to make it compile and run correctly.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Make variables mutable where needed</li>
                                            <li>Fix type mismatches</li>
                                            <li>Use proper naming conventions for constants</li>
                                            <li>Use shadowing appropriately</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-variables-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-variables" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn main() {
    // Fix: make count mutable
    let mut count = 0;
    count = count + 1;
    println!("Count: {}", count);
    
    // Fix: parse string to number
    let age: u32 = 25;  // or "25".parse().unwrap()
    println!("Age: {}", age);
    
    // Fix: use const with proper naming
    const MAX_USERS: u32 = 100;
    println!("Max users: {}", MAX_USERS);
    
    // Fix: use shadowing (remove mut)
    let total = 10;
    let total = total + 5;
    let total = total * 2;
    println!("Total: {}", total);
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Variables are immutable by default</strong> in Rust for safety
                                                and clarity</li>
                                            <li>Use <code>let mut</code> to make a variable mutable</li>
                                            <li><strong>Constants</strong> use <code>const</code>, require type
                                                annotations, and must be compile-time values</li>
                                            <li><strong>Shadowing</strong> creates a new variable with the same name
                                                using <code>let</code></li>
                                            <li>Shadowing allows changing the type, while mutation does not</li>
                                            <li>Use <code>SCREAMING_SNAKE_CASE</code> for constants,
                                                <code>snake_case</code> for variables
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand variables and mutability, let's explore Rust's
                                        <strong>data types</strong>.
                                        In the next lesson, you'll learn about scalar types (integers, floats, booleans,
                                        characters) and
                                        compound types (tuples, arrays), and how Rust's type system ensures safety.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="cargo-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Cargo Basics" />
                                    <jsp:param name="nextLink" value="data-types.jsp" />
                                    <jsp:param name="nextTitle" value="Data Types" />
                                    <jsp:param name="currentLessonId" value="variables" />
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