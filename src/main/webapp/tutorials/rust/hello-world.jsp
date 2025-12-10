<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "hello-world" ); request.setAttribute("currentModule", "Getting Started" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Hello World - First Program Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Write your first Rust program! Learn main function, println! macro, compile and run Rust code. Free Rust tutorial with examples for beginners.">
            <meta name="keywords"
                content="rust hello world, rust hello world tutorial, first rust program, rust main function, println macro, compile rust, rustc, rust tutorial, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Hello World in Rust - First Rust Program">
            <meta property="og:description"
                content="Write and run your first Rust program with this step-by-step guide.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/hello-world.jsp">
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
    "name": "Rust Hello World - First Program Tutorial",
    "description": "Write your first Rust program! Learn main function, println! macro, compile and run Rust code. Free Rust tutorial with examples for beginners.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/hello-world.jsp",
    "keywords": "rust hello world, rust hello world tutorial, first rust program, rust main function, println macro, compile rust, rustc, rust tutorial, learn rust",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust Hello World", "main function", "println! macro", "Compiling Rust", "Running Rust programs"],
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
            "name": "Hello World"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="hello-world">
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
                                    <span>Hello World</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Hello, World! in Rust</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Every programming journey begins with "Hello, World!" In this
                                        lesson, you'll write your first Rust program,
                                        understand its structure, learn about the main function and println! macro, and
                                        discover how to compile and run Rust code.</p>

                                    <!-- Section 1: Your First Rust Program -->
                                    <h2>Your First Rust Program</h2>
                                    <p>Let's start with the simplest possible Rust program:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/hello-basic.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-hello-basic" />
                                    </jsp:include>

                                    <p>This program does one thing: it prints "Hello, World!" to the console. Let's
                                        break down each part.</p>

                                    <!-- Section 2: Anatomy of a Rust Program -->
                                    <h2>Anatomy of a Rust Program</h2>

                                    <h3>The main Function</h3>
                                    <p>Every Rust program must have a <code>main</code> function—it's the entry point
                                        where execution begins:</p>

                                    <pre><code class="language-rust">fn main() {
    // Code goes here
}</code></pre>

                                    <div class="info-box">
                                        <strong>Function Syntax:</strong>
                                        <ul>
                                            <li><code>fn</code> - keyword to declare a function</li>
                                            <li><code>main</code> - the function name (special: program entry point)
                                            </li>
                                            <li><code>()</code> - parentheses for parameters (empty here)</li>
                                            <li><code>{}</code> - curly braces contain the function body</li>
                                        </ul>
                                    </div>

                                    <h3>The println! Macro</h3>
                                    <p><code>println!</code> is a macro (note the <code>!</code>) that prints text to
                                        the console with a newline:</p>

                                    <pre><code class="language-rust">println!("Hello, World!");</code></pre>

                                    <div class="tip-box">
                                        <strong>Macro vs Function:</strong> The <code>!</code> indicates a macro, not a
                                        regular function.
                                        Macros are expanded at compile time and can do things functions can't, like take
                                        a variable number of arguments.
                                    </div>

                                    <h3>Statements and Semicolons</h3>
                                    <p>In Rust, most statements end with a semicolon <code>;</code>. This tells the
                                        compiler where one statement ends and another begins.</p>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Compiling and Running -->
                                    <h2>Compiling and Running</h2>

                                    <h3>Step 1: Create the File</h3>
                                    <p>Create a file named <code>hello.rs</code> (the <code>.rs</code> extension is for
                                        Rust source files):</p>

                                    <pre><code class="language-rust">fn main() {
    println!("Hello, World!");
}</code></pre>

                                    <h3>Step 2: Compile with rustc</h3>
                                    <p>Use the Rust compiler <code>rustc</code> to compile your program:</p>

                                    <pre><code class="language-bash">rustc hello.rs</code></pre>

                                    <p>This creates an executable file:</p>
                                    <ul>
                                        <li><strong>Windows:</strong> <code>hello.exe</code></li>
                                        <li><strong>macOS/Linux:</strong> <code>hello</code></li>
                                    </ul>

                                    <h3>Step 3: Run the Program</h3>
                                    <pre><code class="language-bash"># Windows
.\hello.exe

# macOS/Linux
./hello</code></pre>

                                    <p>You should see:</p>
                                    <pre><code class="language-bash">Hello, World!</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> While <code>rustc</code> works for simple
                                        programs, you'll typically use Cargo
                                        (Rust's build tool) for real projects. We'll cover Cargo in the next lesson!
                                    </div>

                                    <!-- Section 4: Adding Comments and Formatting -->
                                    <h2>Comments and Formatting</h2>

                                    <p>Let's enhance our program with comments and string formatting:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/hello-annotated.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-hello-annotated" />
                                    </jsp:include>

                                    <h3>Comments</h3>
                                    <p>Rust supports two types of comments:</p>
                                    <ul>
                                        <li><strong>Line comments:</strong> <code>// This is a comment</code></li>
                                        <li><strong>Block comments:</strong>
                                            <code>/* This spans multiple lines */</code>
                                        </li>
                                    </ul>

                                    <h3>String Formatting</h3>
                                    <p>Use <code>{}</code> as placeholders in format strings:</p>

                                    <pre><code class="language-rust">let name = "Alice";
println!("Hello, {}!", name);  // Prints: Hello, Alice!</code></pre>

                                    <p>You can use multiple placeholders:</p>

                                    <pre><code class="language-rust">let name = "Bob";
let age = 30;
println!("{} is {} years old", name, age);</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting the exclamation mark</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">println("Hello");  // Error: println is not a function!</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">println!("Hello");  // Correct: println! is a macro</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Missing semicolon</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">fn main() {
    println!("Hello")  // Error: missing semicolon
}</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">fn main() {
    println!("Hello");  // Correct
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Wrong file extension</h4>
                                        <p><strong>Problem:</strong> Saving file as <code>hello.txt</code> or
                                            <code>hello.rs.txt</code>
                                        </p>
                                        <p><strong>Solution:</strong> Always use <code>.rs</code> extension for Rust
                                            source files</p>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Personalize Your Program</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Modify the Hello World program to greet yourself and
                                            share something about you.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Print a greeting with your name</li>
                                            <li>Add a second line stating your favorite programming language</li>
                                            <li>Use variables and string formatting</li>
                                            <li>Add comments explaining your code</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-hello-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-hello" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">// My personalized Rust program
fn main() {
    let name = "Alice";
    let favorite_language = "Rust";
    
    println!("Hello! My name is {}.", name);
    println!("My favorite programming language is {}!", favorite_language);
    println!("I'm excited to learn more about systems programming!");
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Every Rust program starts with a <code>main</code> function</li>
                                            <li><code>fn</code> keyword declares functions</li>
                                            <li><code>println!</code> is a macro (note the <code>!</code>) for printing
                                                to console</li>
                                            <li>Statements end with semicolons <code>;</code></li>
                                            <li>Compile with <code>rustc filename.rs</code></li>
                                            <li>Run the resulting executable</li>
                                            <li>Use <code>{}</code> for string formatting</li>
                                            <li>Comments start with <code>//</code> for single lines or
                                                <code>/* */</code> for blocks
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>While <code>rustc</code> works for simple programs, real-world Rust development
                                        uses Cargo—Rust's build system and package manager.
                                        In the next lesson, you'll learn how to create projects with Cargo, manage
                                        dependencies, and use Rust's powerful tooling ecosystem.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="installation.jsp" />
                                    <jsp:param name="prevTitle" value="Installation & Setup" />
                                    <jsp:param name="nextLink" value="cargo-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Cargo Basics" />
                                    <jsp:param name="currentLessonId" value="hello-world" />
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