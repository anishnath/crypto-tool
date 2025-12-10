<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "intro" ); request.setAttribute("currentModule", "Getting Started" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Tutorial for Beginners - Learn Rust | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust programming from scratch. Free Rust tutorial for beginners with examples. Master memory safety, speed, and concurrency. Start coding today!">
            <meta name="keywords"
                content="rust tutorial, rust tutorial for beginners, learn rust, rust programming, rust programming language, rust beginner, rust examples, rust course, rust online tutorial">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Introduction to Rust - Systems Programming Language">
            <meta property="og:description"
                content="Master Rust: the systems programming language that guarantees memory safety and thread safety.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/intro.jsp">
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
    "name": "Rust Tutorial for Beginners - Learn Rust",
    "description": "Learn Rust programming from scratch. Free Rust tutorial for beginners with examples. Master memory safety, speed, and concurrency. Start coding today!",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/rust/intro.jsp",
    "keywords": "rust tutorial, rust tutorial for beginners, learn rust, rust programming, rust programming language, rust beginner, rust examples, rust course, rust online tutorial",
    "teaches": ["Rust basics", "Memory safety", "Systems programming", "Rust philosophy", "Why Rust", "Rust introduction", "Getting started with Rust"],
    "timeRequired": "PT15M",
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
            "name": "Introduction"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="intro">
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
                                    <span>Introduction</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Introduction to Rust</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Rust is a modern systems programming language that focuses on
                                        safety, speed, and concurrency.
                                        It achieves memory safety without garbage collection, making it ideal for
                                        performance-critical applications
                                        while preventing common bugs like null pointer dereferences and data races.</p>

                                    <!-- Section 1: What is Rust? -->
                                    <h2>What is Rust?</h2>
                                    <p>Rust is a statically-typed, compiled language designed for building reliable and
                                        efficient software.
                                        Created by Mozilla Research, Rust has become one of the most loved programming
                                        languages according to
                                        Stack Overflow's annual developer survey.</p>

                                    <div class="info-box">
                                        <strong>Key Features:</strong>
                                        <ul>
                                            <li><strong>Memory Safety:</strong> Prevents segmentation faults and data
                                                races at compile time</li>
                                            <li><strong>Zero-Cost Abstractions:</strong> High-level features with no
                                                runtime overhead</li>
                                            <li><strong>Concurrency:</strong> Fearless concurrency with compile-time
                                                guarantees</li>
                                            <li><strong>Performance:</strong> Comparable to C and C++ in speed</li>
                                        </ul>
                                    </div>

                                    <h3>Your First Rust Program</h3>
                                    <p>Let's start with the traditional "Hello, World!" program to see Rust in action:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/intro-hello.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-intro" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> The <code>println!</code> macro (note the
                                        <code>!</code>) is used for printing to the console.
                                        Macros in Rust are powerful metaprogramming tools that generate code at compile
                                        time.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: Why Choose Rust? -->
                                    <h2>Why Choose Rust?</h2>
                                    <p>Rust solves problems that have plagued systems programming for decades:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Problem</th>
                                                <th>Traditional Approach</th>
                                                <th>Rust Solution</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Memory Leaks</td>
                                                <td>Manual memory management or GC</td>
                                                <td>Ownership system (compile-time)</td>
                                            </tr>
                                            <tr>
                                                <td>Null Pointer Errors</td>
                                                <td>Runtime checks</td>
                                                <td>Option type (no null)</td>
                                            </tr>
                                            <tr>
                                                <td>Data Races</td>
                                                <td>Careful programming + testing</td>
                                                <td>Borrow checker (compile-time)</td>
                                            </tr>
                                            <tr>
                                                <td>Performance</td>
                                                <td>C/C++ (unsafe) or GC (slower)</td>
                                                <td>Zero-cost abstractions</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Use Cases</h3>
                                    <p>Rust excels in domains where performance and reliability are critical:</p>
                                    <ul>
                                        <li><strong>Operating Systems:</strong> Parts of Linux kernel, Redox OS</li>
                                        <li><strong>Web Browsers:</strong> Firefox components (Servo engine)</li>
                                        <li><strong>Game Engines:</strong> High-performance game development</li>
                                        <li><strong>Embedded Systems:</strong> IoT devices, microcontrollers</li>
                                        <li><strong>Web Assembly:</strong> Fast, safe code for the web</li>
                                        <li><strong>CLI Tools:</strong> Fast command-line utilities (ripgrep, exa)</li>
                                    </ul>

                                    <!-- Section 3: The Rust Philosophy -->
                                    <h2>The Rust Philosophy</h2>
                                    <p>Rust's design is guided by three core principles:</p>

                                    <div class="best-practice-box">
                                        <strong>Safety First:</strong> Rust prevents entire classes of bugs at compile
                                        time. If your code compiles,
                                        you can be confident it won't have memory safety issues or data races.
                                    </div>

                                    <div class="best-practice-box">
                                        <strong>Performance:</strong> Rust gives you low-level control without
                                        sacrificing safety.
                                        No garbage collector means predictable performance.
                                    </div>

                                    <div class="best-practice-box">
                                        <strong>Productivity:</strong> Great tooling (Cargo, rustfmt, clippy), excellent
                                        error messages,
                                        and a helpful community make Rust productive despite its learning curve.
                                    </div>

                                    <div class="warning-box">
                                        <strong>Learning Curve:</strong> Rust has a steeper learning curve than
                                        languages like Python or JavaScript.
                                        The ownership system and borrow checker require a different way of thinking
                                        about memory management.
                                        Be patient—the investment pays off!
                                    </div>

                                    <!-- Section 4: Rust vs Other Languages -->
                                    <h2>Rust vs Other Languages</h2>
                                    <p>Understanding where Rust fits in the programming language ecosystem:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Language</th>
                                                <th>Speed</th>
                                                <th>Safety</th>
                                                <th>Best For</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Rust</strong></td>
                                                <td>⚡⚡⚡</td>
                                                <td>🛡️🛡️🛡️</td>
                                                <td>Systems, performance-critical apps</td>
                                            </tr>
                                            <tr>
                                                <td>C/C++</td>
                                                <td>⚡⚡⚡</td>
                                                <td>🛡️</td>
                                                <td>Legacy systems, game engines</td>
                                            </tr>
                                            <tr>
                                                <td>Go</td>
                                                <td>⚡⚡</td>
                                                <td>🛡️🛡️</td>
                                                <td>Web services, cloud infrastructure</td>
                                            </tr>
                                            <tr>
                                                <td>Python</td>
                                                <td>⚡</td>
                                                <td>🛡️🛡️</td>
                                                <td>Scripting, data science, web</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Expecting Rust to be like C/C++</h4>
                                        <p>While Rust is a systems language, its ownership model is fundamentally
                                            different from manual memory management.</p>
                                        <pre><code class="language-rust">// This won't compile in Rust!
// let s1 = String::from("hello");
// let s2 = s1;  // s1 is moved, not copied
// println!("{}", s1);  // Error: s1 no longer valid

// Correct approach: clone or borrow
let s1 = String::from("hello");
let s2 = s1.clone();  // Explicit copy
println!("{} {}", s1, s2);  // Both valid</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Fighting the borrow checker</h4>
                                        <p>New Rustaceans often struggle with the borrow checker. Instead of fighting
                                            it, learn to work with it—it's preventing bugs!</p>
                                        <pre><code class="language-rust">// The borrow checker is your friend
// It prevents this dangerous pattern:
// let mut data = vec![1, 2, 3];
// let first = &data[0];
// data.push(4);  // Error! Can't modify while borrowed
// println!("{}", first);

// Correct: finish borrowing before modifying
let mut data = vec![1, 2, 3];
{
    let first = &data[0];
    println!("{}", first);
}  // Borrow ends here
data.push(4);  // Now OK</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Ignoring compiler warnings</h4>
                                        <p>Rust's compiler provides excellent error messages. Read them carefully—they
                                            often include suggestions for fixes!</p>
                                        <pre><code class="language-rust">// Compiler will warn about unused variables
// let unused = 42;  // Warning!

// Prefix with _ to indicate intentionally unused
let _unused = 42;  // No warning</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Your First Rust Program</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Modify the program to print personalized information
                                            about yourself.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a variable for your name</li>
                                            <li>Create a variable for your age</li>
                                            <li>Print a greeting message using both variables</li>
                                            <li>Add a comment explaining what the program does</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-intro-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-intro" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">// A simple Rust program that introduces yourself
fn main() {
    let name = "Alice";
    let age = 25;
    
    println!("Hello! My name is {} and I am {} years old.", name, age);
    println!("I'm learning Rust programming!");
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Rust is a systems programming language</strong> focused on
                                                safety, speed, and concurrency</li>
                                            <li><strong>Memory safety without garbage collection</strong> through the
                                                ownership system</li>
                                            <li><strong>Prevents common bugs</strong> like null pointers and data races
                                                at compile time</li>
                                            <li><strong>Performance comparable to C/C++</strong> with modern language
                                                features</li>
                                            <li><strong>Excellent tooling</strong> including Cargo (package manager) and
                                                helpful compiler messages</li>
                                            <li><strong>Growing ecosystem</strong> used in browsers, operating systems,
                                                web assembly, and more</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand what Rust is and why it's valuable, the next step is to
                                        get Rust installed on your system.
                                        In the next lesson, we'll cover <strong>Installation & Setup</strong>, where
                                        you'll install Rust, set up your
                                        development environment, and verify everything is working correctly.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="" />
                                    <jsp:param name="prevTitle" value="" />
                                    <jsp:param name="nextLink" value="installation.jsp" />
                                    <jsp:param name="nextTitle" value="Installation & Setup" />
                                    <jsp:param name="currentLessonId" value="intro" />
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