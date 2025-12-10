<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "strings" ); request.setAttribute("currentModule", "Variables & Data Types"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Strings Tutorial - String vs &str Guide | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust strings with examples. Master String vs &str, UTF-8 encoding, string methods, concatenation, and slicing. Free Rust tutorial.">
            <meta name="keywords"
                content="rust strings, rust strings tutorial, rust string vs str, rust utf-8, rust string methods, rust string concatenation, rust string slicing, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Strings in Rust - String vs &str">
            <meta property="og:description" content="Master Rust strings with String and &str types.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/strings.jsp">
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
    "name": "Rust Strings Tutorial - String vs &str Guide",
    "description": "Learn Rust strings with examples. Master String vs &str, UTF-8 encoding, string methods, concatenation, and slicing. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/strings.jsp",
    "keywords": "rust strings, rust strings tutorial, rust string vs str, rust utf-8, rust string methods, rust string concatenation, rust string slicing, learn rust",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust strings", "String type", "&str type", "UTF-8", "String methods", "String concatenation"],
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
            "name": "Strings"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="strings">
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
                                    <span>Strings</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Strings in Rust</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Strings in Rust are more complex than in many other languages due to
                                        Rust's focus on safety and UTF-8 encoding.
                                        In this lesson, you'll learn about the two main string types
                                        (<code>String</code> and
                                        <code>&str</code>), how to create and manipulate strings, and common pitfalls to
                                        avoid.
                                    </p>

                                    <!-- Section 1: String vs &str -->
                                    <h2>String vs &str</h2>
                                    <p>Rust has two main string types:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>String</th>
                                                <th>&str</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Storage</td>
                                                <td>Heap-allocated</td>
                                                <td>Stack or binary (immutable)</td>
                                            </tr>
                                            <tr>
                                                <td>Ownership</td>
                                                <td>Owned</td>
                                                <td>Borrowed (reference)</td>
                                            </tr>
                                            <tr>
                                                <td>Mutability</td>
                                                <td>Can be mutable</td>
                                                <td>Always immutable</td>
                                            </tr>
                                            <tr>
                                                <td>Size</td>
                                                <td>Growable</td>
                                                <td>Fixed size</td>
                                            </tr>
                                            <tr>
                                                <td>Use case</td>
                                                <td>When you need to own/modify</td>
                                                <td>String literals, slices</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>Key Insight:</strong> <code>&str</code> is a string slice - a view into
                                        string data stored elsewhere.
                                        <code>String</code> is an owned, growable string type.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/strings-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-strings-basics" />
                                    </jsp:include>

                                    <!-- Section 2: Creating Strings -->
                                    <h2>Creating Strings</h2>
                                    <p>There are several ways to create strings in Rust:</p>

                                    <pre><code class="language-rust">// String literals (&str) - hardcoded in binary
let greeting = "Hello, World!";

// String::from() - creates owned String
let s1 = String::from("Hello");

// .to_string() method - converts &str to String
let s2 = "World".to_string();

// String::new() - creates empty String
let mut s3 = String::new();
s3.push_str("Hello");</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Use <code>&str</code> for string literals and function
                                        parameters (more flexible).
                                        Use <code>String</code> when you need to own or modify the string.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: UTF-8 Encoding -->
                                    <h2>UTF-8 Encoding</h2>
                                    <p>Rust strings are always valid UTF-8. This means:</p>

                                    <ul>
                                        <li>Each character can be 1-4 bytes</li>
                                        <li>You cannot index strings directly (no <code>s[0]</code>)</li>
                                        <li><code>.len()</code> returns byte count, not character count</li>
                                        <li>Emoji and international characters are fully supported</li>
                                    </ul>

                                    <pre><code class="language-rust">let hello = "Hello";
println!("Length: {} bytes", hello.len()); // 5 bytes

let emoji = "Hello 👋";
println!("Length: {} bytes", emoji.len()); // 10 bytes (👋 is 4 bytes!)
println!("Chars: {}", emoji.chars().count()); // 7 characters</code></pre>

                                    <div class="warning-box">
                                        <strong>Warning:</strong> String indexing like <code>s[0]</code> is not allowed
                                        in Rust because characters
                                        can be multiple bytes. Use <code>.chars()</code> or <code>.bytes()</code> to
                                        iterate.
                                    </div>

                                    <!-- Section 4: String Methods -->
                                    <h2>String Methods</h2>
                                    <p>Rust provides many useful methods for working with strings:</p>

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
                                                <td><code>push(char)</code></td>
                                                <td>Add a character</td>
                                                <td><code>s.push('!')</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>push_str(&str)</code></td>
                                                <td>Add a string slice</td>
                                                <td><code>s.push_str(" World")</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>len()</code></td>
                                                <td>Get byte length</td>
                                                <td><code>s.len()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>is_empty()</code></td>
                                                <td>Check if empty</td>
                                                <td><code>s.is_empty()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>contains(&str)</code></td>
                                                <td>Check substring</td>
                                                <td><code>s.contains("Rust")</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>replace(&str, &str)</code></td>
                                                <td>Replace substring</td>
                                                <td><code>s.replace("old", "new")</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/strings-methods.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-strings-methods" />
                                    </jsp:include>

                                    <!-- Section 5: String Concatenation -->
                                    <h2>String Concatenation</h2>
                                    <p>There are several ways to combine strings:</p>

                                    <h3>Using the + Operator</h3>
                                    <pre><code class="language-rust">let s1 = String::from("Hello");
let s2 = String::from("World");
let s3 = s1 + " " + &s2; // s1 is moved here!
// println!("{}", s1); // Error: s1 was moved</code></pre>

                                    <div class="warning-box">
                                        <strong>Ownership Note:</strong> The <code>+</code> operator takes ownership of
                                        the left operand.
                                        Use <code>&</code> for the right operand to borrow it.
                                    </div>

                                    <h3>Using the format! Macro</h3>
                                    <pre><code class="language-rust">let s1 = String::from("Hello");
let s2 = String::from("World");
let s3 = format!("{} {}", s1, s2); // s1 and s2 still valid!
println!("{}", s1); // OK: s1 not moved</code></pre>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Use <code>format!</code> for concatenation when
                                        you need to keep ownership
                                        of all strings. It's more flexible and doesn't move values.
                                    </div>

                                    <!-- Section 6: String Slicing -->
                                    <h2>String Slicing</h2>
                                    <p>You can create string slices using range syntax:</p>

                                    <pre><code class="language-rust">let s = String::from("Hello, World!");
let hello = &s[0..5];   // "Hello"
let world = &s[7..12];  // "World"
println!("{} {}", hello, world);</code></pre>

                                    <div class="warning-box">
                                        <strong>Danger:</strong> Slicing must occur at valid UTF-8 character boundaries!
                                        Slicing in the middle of a multi-byte character will panic.
                                    </div>

                                    <pre><code class="language-rust">let emoji = "👋";
// let bad = &emoji[0..1]; // PANIC! 👋 is 4 bytes
let good = &emoji[0..4];   // OK: full character</code></pre>

                                    <!-- Section 7: Iterating Over Strings -->
                                    <h2>Iterating Over Strings</h2>
                                    <p>Rust provides two main ways to iterate over strings:</p>

                                    <h3>By Characters</h3>
                                    <pre><code class="language-rust">for c in "Hello".chars() {
    println!("{}", c);
}
// Output: H e l l o</code></pre>

                                    <h3>By Bytes</h3>
                                    <pre><code class="language-rust">for b in "Hello".bytes() {
    println!("{}", b);
}
// Output: 72 101 108 108 111 (ASCII values)</code></pre>

                                    <div class="info-box">
                                        <strong>When to use which:</strong>
                                        <ul>
                                            <li>Use <code>.chars()</code> when working with Unicode characters</li>
                                            <li>Use <code>.bytes()</code> when working with raw byte data</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Trying to index strings</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let s = String::from("Hello");
let c = s[0];  // Error: cannot index into a string</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let s = String::from("Hello");
let c = s.chars().nth(0).unwrap();  // Get first character</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Confusing byte length with character count</h4>
                                        <p><strong>Problem:</strong></p>
                                        <pre><code class="language-rust">let s = "Hello 👋";
println!("{}", s.len());  // 10 bytes, not 7 characters!</code></pre>
                                        <p><strong>Solution:</strong></p>
                                        <pre><code class="language-rust">let s = "Hello 👋";
println!("Bytes: {}", s.len());
println!("Chars: {}", s.chars().count());</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Moving strings unintentionally</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let s1 = String::from("Hello");
let s2 = s1 + " World";
println!("{}", s1);  // Error: s1 was moved</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let s1 = String::from("Hello");
let s2 = format!("{} World", s1);
println!("{}", s1);  // OK: s1 still valid</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: String Manipulation</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Fix the code to make it compile and run correctly.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create mutable and immutable strings</li>
                                            <li>Concatenate strings without moving ownership</li>
                                            <li>Extract substrings safely</li>
                                            <li>Count characters correctly (not bytes)</li>
                                            <li>Convert strings to uppercase</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-strings-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-strings" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn main() {
    // Create a mutable String
    let mut language = String::from("Rust");
    
    // Add to the string
    language.push_str(" is awesome!");
    println!("{}", language);
    
    // Concatenate without moving
    let first = String::from("Hello");
    let second = String::from("World");
    let combined = format!("{} {}", first, second);
    println!("{}", combined);
    println!("First: {}, Second: {}", first, second);
    
    // Extract first word
    let sentence = "Rust programming language";
    let first_word = &sentence[0..4]; // "Rust"
    println!("First word: {}", first_word);
    
    // Count characters
    let emoji_text = "Hello 👋 World 🌍";
    let char_count = emoji_text.chars().count();
    println!("Character count: {}", char_count);
    
    // Convert to uppercase
    let message = "rust is great";
    println!("Uppercase: {}", message.to_uppercase());
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Two string types:</strong> <code>String</code> (owned, heap) and
                                                <code>&str</code> (borrowed, slice)
                                            </li>
                                            <li><strong>UTF-8 encoding:</strong> All Rust strings are valid UTF-8</li>
                                            <li><strong>No indexing:</strong> Cannot use <code>s[i]</code> due to
                                                variable-width characters</li>
                                            <li><strong>String methods:</strong> <code>push</code>,
                                                <code>push_str</code>, <code>len</code>, <code>contains</code>, etc.
                                            </li>
                                            <li><strong>Concatenation:</strong> Use <code>+</code> (moves left operand)
                                                or <code>format!</code> (doesn't move)</li>
                                            <li><strong>Slicing:</strong> Must occur at UTF-8 character boundaries</li>
                                            <li><strong>Iteration:</strong> Use <code>.chars()</code> for characters,
                                                <code>.bytes()</code> for bytes
                                            </li>
                                            <li><code>.len()</code> returns bytes, <code>.chars().count()</code> returns
                                                characters</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand strings, you're ready to learn about
                                        <strong>type conversion</strong>.
                                        In the next lesson, you'll learn how to convert between different types using
                                        the <code>as</code> keyword,
                                        <code>From</code>/<code>Into</code> traits, and safe conversion methods.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="data-types.jsp" />
                                    <jsp:param name="prevTitle" value="Data Types" />
                                    <jsp:param name="nextLink" value="type-conversion.jsp" />
                                    <jsp:param name="nextTitle" value="Type Conversion" />
                                    <jsp:param name="currentLessonId" value="strings" />
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