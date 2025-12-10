<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "packages-crates" ); request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Packages & Crates Tutorial - Cargo Guide | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust packages and crates with examples. Master Cargo.toml, dependency management, publishing to crates.io, and using external crates. Free tutorial.">
            <meta name="keywords"
                content="rust packages, rust crates tutorial, rust cargo, rust dependencies, rust Cargo.toml, rust crates.io, rust package manager, rust cargo tutorial, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Packages & Crates in Rust - Cargo & Dependencies">
            <meta property="og:description" content="Master Rust packages, crates, and dependency management with Cargo.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/packages-crates.jsp">
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
    "name": "Rust Packages & Crates Tutorial - Cargo Guide",
    "description": "Learn Rust packages and crates with examples. Master Cargo.toml, dependency management, publishing to crates.io, and using external crates. Free tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/packages-crates.jsp",
    "keywords": "rust packages, rust crates tutorial, rust cargo, rust dependencies, rust Cargo.toml, rust crates.io, rust package manager, rust cargo tutorial, learn rust",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust packages", "Rust crates", "Cargo", "Dependencies", "Cargo.toml", "crates.io"],
    "timeRequired": "PT35M",
    "isPartOf": {
        "@type": "Course",
        "name": "Rust Tutorial",
        "description": "Complete Rust programming course from beginner to advanced with interactive examples",
        "url": "https://8gwifi.org/tutorials/rust/",
        "provider": {
            "@type": "Organization",
            "name": "8gwifi.org"
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
            "name": "Packages & Crates"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="packages-crates">
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
                                    <span>Packages & Crates</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Packages & Crates</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A <em>crate</em> is the smallest amount of code that the Rust
                                        compiler considers at a time. A <em>package</em> is one or more crates that
                                        provide a set of functionality. Understanding packages and crates is essential
                                        for organizing your Rust code and managing dependencies with Cargo.
                                    </p>

                                    <h2>What is a Crate?</h2>
                                    <p>A crate is a compilation unit in Rust. There are two types of crates:</p>

                                    <h3>1. Binary Crate</h3>
                                    <p>A binary crate is a program you can compile to an executable that you can run.
                                        Every package has at most one binary crate, and it must be in
                                        <code>src/main.rs</code>.</p>

                                    <pre><code class="language-rust">// src/main.rs - Binary crate
fn main() {
    println!("Hello, world!");
}</code></pre>

                                    <h3>2. Library Crate</h3>
                                    <p>A library crate doesn't have a <code>main()</code> function and doesn't compile
                                        to an executable. Instead, it defines functionality intended to be shared with
                                        multiple projects. Library crates are in <code>src/lib.rs</code>.</p>

                                    <pre><code class="language-rust">// src/lib.rs - Library crate
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}</code></pre>

                                    <div class="info-box">
                                        <strong>Crate Types:</strong> A package can contain both a binary crate (in
                                        <code>src/main.rs</code>) and a library crate (in <code>src/lib.rs</code>). The
                                        binary crate can use the library crate as if it were an external crate.
                                    </div>

                                    <h2>What is a Package?</h2>
                                    <p>A <em>package</em> is one or more crates that provide a set of functionality.
                                        A package contains a <code>Cargo.toml</code> file that describes how to build
                                        those crates.</p>

                                    <p>Rules for packages:</p>
                                    <ul>
                                        <li>A package must contain <strong>at most one</strong> library crate</li>
                                        <li>A package can contain <strong>as many</strong> binary crates as you want</li>
                                        <li>A package must contain <strong>at least one</strong> crate (either library or binary)</li>
                                    </ul>

                                    <h2>Cargo.toml File</h2>
                                    <p>The <code>Cargo.toml</code> file defines your package:</p>

                                    <pre><code class="language-toml">[package]
name = "my_project"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = "1.0"
serde_json = "1.0"</code></pre>

                                    <div class="tip-box">
                                        <strong>Edition:</strong> The <code>edition</code> field specifies which Rust
                                        edition your package uses. Current editions are "2015", "2018", and "2021". Use
                                        "2021" for new projects.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/packages-crates-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-packages-basics" />
                                    </jsp:include>

                                    <h2>Managing Dependencies</h2>
                                    <p>Dependencies are external crates your package needs. They're specified in
                                        <code>Cargo.toml</code>:</p>

                                    <h3>Adding Dependencies</h3>
                                    <p>Add dependencies to the <code>[dependencies]</code> section:</p>

                                    <pre><code class="language-toml">[dependencies]
serde = "1.0"
serde_json = "1.0"
tokio = { version = "1.0", features = ["full"] }</code></pre>

                                    <p>Then run <code>cargo build</code> to download and compile dependencies.</p>

                                    <h3>Version Specifications</h3>
                                    <p>You can specify versions in different ways:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Specification</th>
                                                <th>Meaning</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>"1.0"</code></td>
                                                <td>Compatible with 1.0.x</td>
                                                <td><code>serde = "1.0"</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>"^1.0"</code></td>
                                                <td>Compatible with 1.x.x (default)</td>
                                                <td><code>serde = "^1.0"</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>"~1.0"</code></td>
                                                <td>Compatible with 1.0.x only</td>
                                                <td><code>serde = "~1.0"</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>"=1.0.0"</code></td>
                                                <td>Exact version</td>
                                                <td><code>serde = "=1.0.0"</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>"*"</code></td>
                                                <td>Any version (not recommended)</td>
                                                <td><code>serde = "*"</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Dependency Sources</h3>
                                    <p>Dependencies can come from different sources:</p>

                                    <h4>1. From crates.io (Default)</h4>
                                    <pre><code class="language-toml">[dependencies]
serde = "1.0"  # From crates.io</code></pre>

                                    <h4>2. From Git Repository</h4>
                                    <pre><code class="language-toml">[dependencies]
my_crate = { git = "https://github.com/user/repo", branch = "main" }</code></pre>

                                    <h4>3. From Local Path</h4>
                                    <pre><code class="language-toml">[dependencies]
my_crate = { path = "../my_crate" }</code></pre>

                                    <h4>4. From Workspace</h4>
                                    <pre><code class="language-toml">[dependencies]
my_crate = { workspace = true }</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/packages-crates-dependencies.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-packages-dependencies" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Features</h2>
                                    <p>Many crates support optional features that you can enable:</p>

                                    <pre><code class="language-toml">[dependencies]
tokio = { version = "1.0", features = ["full", "macros"] }
serde = { version = "1.0", features = ["derive"] }</code></pre>

                                    <div class="info-box">
                                        <strong>Feature Flags:</strong> Features allow you to include only the parts of
                                        a crate you need, reducing compilation time and binary size. Check the crate's
                                        documentation for available features.
                                    </div>

                                    <h2>Development Dependencies</h2>
                                    <p>Dependencies needed only for development (tests, benchmarks) go in
                                        <code>[dev-dependencies]</code>:</p>

                                    <pre><code class="language-toml">[dev-dependencies]
mockito = "1.0"
criterion = "0.5"</code></pre>

                                    <div class="tip-box">
                                        <strong>Build Dependencies:</strong> Dependencies needed only at build time go in
                                        <code>[build-dependencies]</code>. These are used by build scripts in
                                        <code>build.rs</code>.
                                    </div>

                                    <h2>Using External Crates</h2>
                                    <p>Once you've added a dependency to <code>Cargo.toml</code>, you can use it in
                                        your code:</p>

                                    <pre><code class="language-rust">// In Cargo.toml:
// [dependencies]
// serde = "1.0"

// In your code:
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize)]
struct User {
    name: String,
    age: u32,
}</code></pre>

                                    <h2>Publishing to crates.io</h2>
                                    <p>To publish your crate to crates.io:</p>

                                    <ol>
                                        <li><strong>Create an account:</strong> Sign up at crates.io and get an API token</li>
                                        <li><strong>Add metadata:</strong> Ensure your <code>Cargo.toml</code> has required fields:
                                            <pre><code class="language-toml">[package]
name = "my_crate"
version = "0.1.0"
edition = "2021"
description = "A short description"
license = "MIT OR Apache-2.0"
repository = "https://github.com/user/repo"</code></pre>
                                        </li>
                                        <li><strong>Publish:</strong> Run <code>cargo publish</code></li>
                                    </ol>

                                    <div class="warning-box">
                                        <strong>Publishing is Permanent:</strong> Once published, you cannot delete a
                                        version. You can only yank it (mark it as unavailable for new projects). Plan
                                        your version numbers carefully!
                                    </div>

                                    <h2>Workspaces</h2>
                                    <p>A workspace is a set of packages that share a <code>Cargo.lock</code> and output
                                        directory:</p>

                                    <pre><code class="language-toml"># Cargo.toml at workspace root
[workspace]
members = [
    "crate1",
    "crate2",
    "crate3",
]

[workspace.dependencies]
shared_dep = "1.0"</code></pre>

                                    <div class="info-box">
                                        <strong>Workspace Benefits:</strong> Workspaces allow you to manage multiple
                                        related packages together, share dependencies, and build them all at once with
                                        <code>cargo build --workspace</code>.
                                    </div>

                                    <h2>When to Use Packages vs Crates</h2>
                                    <div class="best-practice-box">
                                        <p><strong>Use a package when:</strong></p>
                                        <ul>
                                            <li><strong>Creating a new project:</strong> Use <code>cargo new</code> to create a package</li>
                                            <li><strong>Organizing code:</strong> Group related functionality into packages</li>
                                            <li><strong>Sharing code:</strong> Publish packages to crates.io</li>
                                            <li><strong>Managing dependencies:</strong> Packages manage their own dependencies</li>
                                        </ul>
                                        
                                        <p style="margin-top: 15px;"><strong>Use multiple crates when:</strong></p>
                                        <ul>
                                            <li><strong>Binary + library:</strong> Have both executable and reusable code</li>
                                            <li><strong>Multiple binaries:</strong> Need several executables in one package</li>
                                            <li><strong>Workspace:</strong> Managing multiple related packages</li>
                                        </ul>
                                    </div>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use semantic versioning:</strong> Follow MAJOR.MINOR.PATCH versioning</li>
                                            <li><strong>Specify exact versions carefully:</strong> Use <code>^</code> for compatibility</li>
                                            <li><strong>Keep dependencies up to date:</strong> Use <code>cargo update</code> regularly</li>
                                            <li><strong>Use features wisely:</strong> Only enable features you need</li>
                                            <li><strong>Document your crate:</strong> Add README.md and documentation</li>
                                            <li><strong>Test before publishing:</strong> Run <code>cargo test</code> and <code>cargo build --release</code></li>
                                            <li><strong>Use workspaces for monorepos:</strong> Manage multiple packages together</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Not specifying edition in Cargo.toml</h4>
                                        <pre><code class="language-toml">// Wrong - Missing edition
[package]
name = "my_project"
version = "0.1.0"

// Correct - Specify edition
[package]
name = "my_project"
version = "0.1.0"
edition = "2021"</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using wildcard versions for dependencies</h4>
                                        <pre><code class="language-toml">// Wrong - Too permissive
[dependencies]
serde = "*"  // Can break with any update

// Correct - Specify compatible version
[dependencies]
serde = "1.0"  // Compatible with 1.x.x</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting to add dependencies to Cargo.toml</h4>
                                        <pre><code class="language-rust">// Wrong - Using crate without adding to Cargo.toml
use serde::Serialize;  // Error: can't find crate

// Correct - Add to Cargo.toml first
// [dependencies]
// serde = "1.0"
use serde::Serialize;  // OK</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Not running cargo build after adding dependencies</h4>
                                        <pre><code class="language-bash"># Wrong - Dependencies not downloaded
# Added to Cargo.toml but didn't run cargo build

# Correct - Build to download dependencies
cargo build</code></pre>
                                    </div>

                                    <h2>Exercise: Packages & Crates Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Practice creating and managing packages and
                                            dependencies.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a Cargo.toml file with proper metadata</li>
                                            <li>Add dependencies from crates.io</li>
                                            <li>Understand the difference between binary and library crates</li>
                                            <li>Learn about different dependency sources</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-packages-crates-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-packages-crates" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-toml"># Cargo.toml
[package]
name = "calculator"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = "1.0"
serde_json = "1.0"

# Binary crate: src/main.rs (has main function)
# Library crate: src/lib.rs (no main function)
# Package: Contains Cargo.toml and one or more crates

# Dependency sources:
# 1. From crates.io: serde = "1.0"
# 2. From Git: my_crate = { git = "https://github.com/user/repo" }
# 3. From local: my_crate = { path = "../my_crate" }</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Crate</strong> is the smallest compilation unit (binary or library)</li>
                                            <li><strong>Package</strong> is one or more crates with a Cargo.toml</li>
                                            <li><strong>Binary crate</strong> has <code>main()</code> and produces executable</li>
                                            <li><strong>Library crate</strong> has no <code>main()</code> and provides functionality</li>
                                            <li><strong>Cargo.toml</strong> defines package metadata and dependencies</li>
                                            <li>Dependencies can come from crates.io, Git, or local paths</li>
                                            <li>Use <code>^</code> version specifier for compatibility</li>
                                            <li>Features allow optional functionality in crates</li>
                                            <li>Workspaces manage multiple related packages</li>
                                            <li>Publish to crates.io to share your crates</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand packages and crates, you'll learn about <strong>iterators</strong> - one of Rust's most powerful features for processing collections. Iterators allow you to write efficient, functional-style code that's both readable and performant.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="generics.jsp" />
                                    <jsp:param name="prevTitle" value="Generics" />
                                    <jsp:param name="nextLink" value="iterators.jsp" />
                                    <jsp:param name="nextTitle" value="Iterators" />
                                    <jsp:param name="currentLessonId" value="packages-crates" />
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

