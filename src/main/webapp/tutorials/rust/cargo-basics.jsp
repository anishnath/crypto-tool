<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "cargo-basics" ); request.setAttribute("currentModule", "Getting Started"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Cargo Tutorial - Package Manager Guide | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust Cargo with examples. Master cargo new, cargo build, cargo run, dependency management, and Cargo.toml. Free Rust tutorial for beginners.">
            <meta name="keywords"
                content="rust cargo, cargo rust tutorial, rust package manager, cargo new, cargo build, cargo run, rust dependencies, cargo.toml, rust build system, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Cargo Basics - Rust Package Manager Tutorial">
            <meta property="og:description" content="Master Cargo, Rust's powerful build system and package manager.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/cargo-basics.jsp">
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
    "name": "Rust Cargo Tutorial - Package Manager Guide",
    "description": "Learn Rust Cargo with examples. Master cargo new, cargo build, cargo run, dependency management, and Cargo.toml. Free Rust tutorial for beginners.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/cargo-basics.jsp",
    "keywords": "rust cargo, cargo rust tutorial, rust package manager, cargo new, cargo build, cargo run, rust dependencies, cargo.toml, rust build system, learn rust",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Cargo", "cargo new", "cargo build", "cargo run", "Cargo.toml", "Rust dependencies"],
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
            "name": "Cargo Basics"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="cargo-basics">
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
                                    <span>Cargo Basics</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Cargo Basics</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Cargo is Rust's build system and package manager. It handles
                                        building your code, downloading dependencies,
                                        and building those dependencies. In this lesson, you'll learn how to create
                                        projects with Cargo, understand project structure,
                                        and use essential Cargo commands.</p>

                                    <!-- Section 1: What is Cargo? -->
                                    <h2>What is Cargo?</h2>
                                    <p>Cargo is the official Rust build tool that comes installed with Rust. It
                                        provides:</p>

                                    <div class="info-box">
                                        <strong>Cargo Features:</strong>
                                        <ul>
                                            <li><strong>Project Management:</strong> Create and organize Rust projects
                                            </li>
                                            <li><strong>Build System:</strong> Compile your code and dependencies</li>
                                            <li><strong>Package Manager:</strong> Download and manage external libraries
                                                (crates)</li>
                                            <li><strong>Testing:</strong> Run tests with <code>cargo test</code></li>
                                            <li><strong>Documentation:</strong> Generate docs with
                                                <code>cargo doc</code>
                                            </li>
                                        </ul>
                                    </div>

                                    <p>While you can use <code>rustc</code> directly for simple programs, Cargo is the
                                        standard tool for Rust development.</p>

                                    <!-- Section 2: Creating a Project -->
                                    <h2>Creating a New Project</h2>

                                    <p>Create a new Rust project with <code>cargo new</code>:</p>

                                    <pre><code class="language-bash">cargo new hello_cargo
cd hello_cargo</code></pre>

                                    <p>This creates a new directory with the following structure:</p>

                                    <pre><code class="language-plaintext">hello_cargo/
├── Cargo.toml          # Project configuration
└── src/
    └── main.rs         # Your code</code></pre>

                                    <div class="tip-box">
                                        <strong>Naming Convention:</strong> Rust uses snake_case for project names
                                        (e.g., <code>hello_cargo</code>, not <code>HelloCargo</code>).
                                    </div>

                                    <!-- Section 3: Project Structure -->
                                    <h2>Understanding Project Structure</h2>

                                    <h3>Cargo.toml</h3>
                                    <p>The <code>Cargo.toml</code> file contains project metadata and dependencies:</p>

                                    <pre><code class="language-toml">[package]
name = "hello_cargo"
version = "0.1.0"
edition = "2021"

[dependencies]
# External crates go here</code></pre>

                                    <div class="info-box">
                                        <strong>TOML Format:</strong>
                                        <ul>
                                            <li><code>[package]</code> - Project metadata section</li>
                                            <li><code>name</code> - Project name</li>
                                            <li><code>version</code> - Semantic version (major.minor.patch)</li>
                                            <li><code>edition</code> - Rust edition (2015, 2018, 2021)</li>
                                            <li><code>[dependencies]</code> - External libraries</li>
                                        </ul>
                                    </div>

                                    <h3>src/main.rs</h3>
                                    <p>Cargo automatically creates a "Hello, World!" program in
                                        <code>src/main.rs</code>:
                                    </p>

                                    <pre><code class="language-rust">fn main() {
    println!("Hello, world!");
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 4: Essential Cargo Commands -->
                                    <h2>Essential Cargo Commands</h2>

                                    <h3>cargo build</h3>
                                    <p>Compile your project:</p>

                                    <pre><code class="language-bash">cargo build</code></pre>

                                    <p>This creates an executable in <code>target/debug/hello_cargo</code> (or
                                        <code>target/debug/hello_cargo.exe</code> on Windows).
                                    </p>

                                    <div class="tip-box">
                                        <strong>Release Build:</strong> For optimized production builds, use
                                        <code>cargo build --release</code>.
                                        This creates a faster executable in <code>target/release/</code>.
                                    </div>

                                    <h3>cargo run</h3>
                                    <p>Compile and run your project in one command:</p>

                                    <pre><code class="language-bash">cargo run</code></pre>

                                    <p>Output:</p>
                                    <pre><code class="language-bash">   Compiling hello_cargo v0.1.0
    Finished dev [unoptimized + debuginfo] target(s) in 0.50s
     Running `target/debug/hello_cargo`
Hello, world!</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use <code>cargo run</code> during
                                        development—it's faster than building and running separately.
                                    </div>

                                    <h3>cargo check</h3>
                                    <p>Check if your code compiles without creating an executable:</p>

                                    <pre><code class="language-bash">cargo check</code></pre>

                                    <p>This is much faster than <code>cargo build</code> and useful for quick error
                                        checking during development.</p>

                                    <h3>cargo clean</h3>
                                    <p>Remove the <code>target</code> directory to free up space:</p>

                                    <pre><code class="language-bash">cargo clean</code></pre>

                                    <!-- Section 5: Command Comparison -->
                                    <h2>Cargo vs rustc</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Task</th>
                                                <th>With rustc</th>
                                                <th>With Cargo</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Create project</td>
                                                <td>Manual setup</td>
                                                <td><code>cargo new project_name</code></td>
                                            </tr>
                                            <tr>
                                                <td>Compile</td>
                                                <td><code>rustc main.rs</code></td>
                                                <td><code>cargo build</code></td>
                                            </tr>
                                            <tr>
                                                <td>Run</td>
                                                <td><code>./main</code></td>
                                                <td><code>cargo run</code></td>
                                            </tr>
                                            <tr>
                                                <td>Dependencies</td>
                                                <td>Manual management</td>
                                                <td>Automatic via Cargo.toml</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 6: Adding Dependencies -->
                                    <h2>Adding Dependencies</h2>

                                    <p>To use external libraries (called "crates" in Rust), add them to
                                        <code>Cargo.toml</code>:
                                    </p>

                                    <pre><code class="language-toml">[dependencies]
rand = "0.8.5"
serde = "1.0"</code></pre>

                                    <p>Cargo will automatically download and compile these dependencies when you build
                                        your project.</p>

                                    <div class="info-box">
                                        <strong>Finding Crates:</strong> Browse available crates at <a
                                            href="https://crates.io" target="_blank" rel="noopener">crates.io</a>,
                                        the official Rust package registry.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Running rustc instead of cargo</h4>
                                        <p><strong>Problem:</strong> Using <code>rustc main.rs</code> in a Cargo project
                                        </p>
                                        <p><strong>Solution:</strong> Always use <code>cargo build</code> or
                                            <code>cargo run</code> in Cargo projects
                                        </p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Forgetting to rebuild after changes</h4>
                                        <p><strong>Problem:</strong> Running old executable after code changes</p>
                                        <p><strong>Solution:</strong> Use <code>cargo run</code> which automatically
                                            rebuilds if needed</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Incorrect dependency syntax</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-toml">[dependencies]
rand: "0.8.5"  # Wrong: uses colon instead of equals</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-toml">[dependencies]
rand = "0.8.5"  # Correct: uses equals sign</code></pre>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Cargo</strong> is Rust's build system and package manager</li>
                                            <li>Create projects with <code>cargo new project_name</code></li>
                                            <li><code>Cargo.toml</code> contains project configuration and dependencies
                                            </li>
                                            <li><code>cargo build</code> compiles your project</li>
                                            <li><code>cargo run</code> compiles and runs in one command</li>
                                            <li><code>cargo check</code> quickly checks for compilation errors</li>
                                            <li>Add dependencies in the <code>[dependencies]</code> section of
                                                Cargo.toml</li>
                                            <li>Use <code>--release</code> flag for optimized production builds</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed the Getting Started module. You now know how to
                                        install Rust, write basic programs,
                                        and use Cargo to manage projects. In the next module, we'll dive into Rust's
                                        type system, starting with variables,
                                        mutability, and data types—the building blocks of every Rust program.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="hello-world.jsp" />
                                    <jsp:param name="prevTitle" value="Hello World" />
                                    <jsp:param name="nextLink" value="variables.jsp" />
                                    <jsp:param name="nextTitle" value="Variables & Mutability" />
                                    <jsp:param name="currentLessonId" value="cargo-basics" />
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