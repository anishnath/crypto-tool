<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "comments" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Comments Tutorial - Documentation Guide | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust comments with examples. Master line/block comments, documentation comments, and cargo doc. Free Rust tutorial for beginners.">
            <meta name="keywords"
                content="rust comments, rust comments tutorial, rust documentation, cargo doc, rust doc comments, rust /// comments, rustdoc, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Comments & Documentation in Rust">
            <meta property="og:description" content="Master Rust comments and documentation with cargo doc.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/comments.jsp">
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
    "name": "Rust Comments Tutorial - Documentation Guide",
    "description": "Learn Rust comments with examples. Master line/block comments, documentation comments, and cargo doc. Free Rust tutorial for beginners.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/comments.jsp",
    "keywords": "rust comments, rust comments tutorial, rust documentation, cargo doc, rust doc comments, rust /// comments, rustdoc, learn rust",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust comments", "Documentation comments", "cargo doc", "Rustdoc", "Code documentation"],
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
            "name": "Comments"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="comments">
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
                                    <span>Comments</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Comments & Documentation</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Good comments make code easier to understand and maintain. Rust
                                        supports several types of comments,
                                        including special documentation comments that can generate beautiful HTML
                                        documentation automatically.
                                        In this lesson, you'll learn how to write effective comments and documentation
                                        in Rust.</p>

                                    <!-- Section 1: Comment Types -->
                                    <h2>Types of Comments</h2>

                                    <h3>1. Line Comments</h3>
                                    <p>The most common type of comment starts with <code>//</code> and continues to the
                                        end of the line:</p>

                                    <pre><code class="language-rust">// This is a line comment
let x = 5; // Comments can be at the end of lines too</code></pre>

                                    <h3>2. Block Comments</h3>
                                    <p>For multi-line comments, use <code>/* */</code>:</p>

                                    <pre><code class="language-rust">/*
 * This is a block comment
 * It can span multiple lines
 * Useful for longer explanations
 */</code></pre>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Most Rust code uses line comments
                                        (<code>//</code>) even for multi-line comments.
                                        Block comments are typically reserved for temporarily commenting out code during
                                        development.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/comments-types.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-comments" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: Documentation Comments -->
                                    <h2>Documentation Comments</h2>
                                    <p>Rust has special comments for documentation that support Markdown formatting and
                                        can be compiled into HTML documentation:</p>

                                    <h3>Outer Doc Comments (<code>///</code>)</h3>
                                    <p>Used to document the item that follows (functions, structs, modules, etc.):</p>

                                    <pre><code class="language-rust">/// Adds two numbers together.
///
/// # Examples
///
/// ```
/// let result = add(2, 3);
/// assert_eq!(result, 5);
/// ```
fn add(a: i32, b: i32) -> i32 {
    a + b
}</code></pre>

                                    <h3>Inner Doc Comments (<code>//!</code>)</h3>
                                    <p>Used to document the containing item (typically used at the top of modules or
                                        crates):</p>

                                    <pre><code class="language-rust">//! # My Awesome Crate
//!
//! This crate provides amazing functionality.
//!
//! ## Features
//!
//! - Fast
//! - Reliable
//! - Easy to use</code></pre>

                                    <div class="info-box">
                                        <strong>Doc Comment Sections:</strong>
                                        <ul>
                                            <li><code># Examples</code> - Show how to use the code</li>
                                            <li><code># Panics</code> - Describe when the function panics</li>
                                            <li><code># Errors</code> - Explain error conditions</li>
                                            <li><code># Safety</code> - Document unsafe code requirements</li>
                                        </ul>
                                    </div>

                                    <!-- Section 3: Generating Documentation -->
                                    <h2>Generating Documentation with Cargo</h2>
                                    <p>Cargo can automatically generate HTML documentation from your doc comments:</p>

                                    <pre><code class="language-bash">cargo doc</code></pre>

                                    <p>This creates documentation in <code>target/doc/</code>. To open it in your
                                        browser:</p>

                                    <pre><code class="language-bash">cargo doc --open</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Documentation Best Practices:</strong>
                                        <ul>
                                            <li>Always include examples in your documentation</li>
                                            <li>Document public APIs thoroughly</li>
                                            <li>Use Markdown for formatting (headers, lists, code blocks)</li>
                                            <li>Include code examples that can be tested</li>
                                            <li>Explain the "why" not just the "what"</li>
                                        </ul>
                                    </div>

                                    <!-- Section 4: Markdown in Doc Comments -->
                                    <h2>Markdown in Documentation</h2>
                                    <p>Doc comments support full Markdown syntax:</p>

                                    <pre><code class="language-rust">/// # Heading
///
/// **Bold text** and *italic text*
///
/// - Bullet point 1
/// - Bullet point 2
///
/// Inline code: `variable_name`
///
/// Code block:
/// ```rust
/// let x = 5;
/// ```
///
/// [Link to Rust](https://www.rust-lang.org/)</code></pre>

                                    <!-- Section 5: Testing Documentation -->
                                    <h2>Documentation Tests</h2>
                                    <p>Code examples in doc comments are automatically tested when you run
                                        <code>cargo test</code>:
                                    </p>

                                    <pre><code class="language-rust">/// Divides two numbers.
///
/// # Examples
///
/// ```
/// let result = divide(10, 2);
/// assert_eq!(result, 5);
/// ```
///
/// # Panics
///
/// Panics if the divisor is zero:
///
/// ```should_panic
/// divide(10, 0);  // This will panic!
/// ```
fn divide(a: i32, b: i32) -> i32 {
    if b == 0 {
        panic!("Cannot divide by zero!");
    }
    a / b
}</code></pre>

                                    <div class="info-box">
                                        <strong>Doc Test Attributes:</strong>
                                        <ul>
                                            <li><code>```</code> - Normal test (must compile and run successfully)</li>
                                            <li><code>```should_panic</code> - Test should panic</li>
                                            <li><code>```no_run</code> - Compile but don't run</li>
                                            <li><code>```ignore</code> - Don't compile or run</li>
                                            <li><code>```compile_fail</code> - Should fail to compile</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using wrong doc comment style</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">fn main() {
    /// This doesn't document anything useful
    let x = 5;
}</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">/// Documents the function below
fn main() {
    // Regular comment for code inside
    let x = 5;
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Over-commenting obvious code</h4>
                                        <p><strong>Bad:</strong></p>
                                        <pre><code class="language-rust">// Increment x by 1
x = x + 1;</code></pre>
                                        <p><strong>Better:</strong></p>
                                        <pre><code class="language-rust">// Apply discount to final price
x = x + 1;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Outdated comments</h4>
                                        <p><strong>Problem:</strong> Comments that don't match the code</p>
                                        <pre><code class="language-rust">// Returns the sum of two numbers
fn multiply(a: i32, b: i32) -> i32 {  // Oops!
    a * b
}</code></pre>
                                        <p><strong>Solution:</strong> Keep comments in sync with code changes</p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Line comments:</strong> <code>//</code> for single-line comments
                                            </li>
                                            <li><strong>Block comments:</strong> <code>/* */</code> for multi-line
                                                comments</li>
                                            <li><strong>Outer doc comments:</strong> <code>///</code> to document
                                                following items</li>
                                            <li><strong>Inner doc comments:</strong> <code>//!</code> to document
                                                containing items</li>
                                            <li>Use <code>cargo doc</code> to generate HTML documentation</li>
                                            <li>Doc comments support Markdown formatting</li>
                                            <li>Code examples in docs are automatically tested</li>
                                            <li>Document public APIs, explain "why" not just "what"</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 2 and learned the fundamentals of Rust
                                        programming.
                                        In the next module, we'll dive into <strong>Control Flow</strong>, learning how
                                        to make decisions
                                        with <code>if</code> expressions, loop with <code>loop</code>,
                                        <code>while</code>, and <code>for</code>,
                                        and control program flow with pattern matching.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="functions.jsp" />
                                    <jsp:param name="prevTitle" value="Functions" />
                                    <jsp:param name="nextLink" value="control-if.jsp" />
                                    <jsp:param name="nextTitle" value="if Expressions" />
                                    <jsp:param name="currentLessonId" value="comments" />
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