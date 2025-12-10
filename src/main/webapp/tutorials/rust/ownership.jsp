<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "ownership" ); request.setAttribute("currentModule", "Ownership" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Ownership Tutorial - Memory Safety Guide | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust ownership rules with examples. Master memory safety, move semantics, stack vs heap. Free Rust tutorial for beginners with code examples.">
            <meta name="keywords"
                content="rust ownership, rust ownership tutorial, rust memory safety, rust move semantics, rust stack heap, rust ownership rules, rust copy trait, learn rust ownership, rust tutorial, rust programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Ownership in Rust - Memory Safety Without Garbage Collection">
            <meta property="og:description" content="Master Rust's ownership system for memory safety.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/ownership.jsp">
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
    "name": "Rust Ownership Tutorial - Memory Safety Guide",
    "description": "Learn Rust ownership rules with examples. Master memory safety, move semantics, stack vs heap. Free Rust tutorial for beginners with code examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/rust/ownership.jsp",
    "keywords": "rust ownership, rust ownership tutorial, rust memory safety, rust move semantics, rust stack heap, rust ownership rules, rust copy trait, learn rust ownership, rust tutorial, rust programming",
    "teaches": ["Rust ownership", "Memory safety", "Move semantics", "Stack and heap", "Copy trait", "Ownership rules", "Memory management"],
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
            "name": "Ownership"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="ownership">
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
                                    <span>Ownership</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Ownership in Rust</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Ownership is Rust's most unique feature. It enables Rust to make
                                        memory
                                        safety guarantees without
                                        needing a garbage collector. Understanding ownership is essential to writing
                                        Rust
                                        programs. In this lesson,
                                        you'll learn the three ownership rules, how memory works, and why ownership
                                        makes
                                        Rust special.
                                    </p>

                                    <!-- What is Ownership? -->
                                    <h2>What is Ownership?</h2>
                                    <p>Ownership is a set of rules that govern how Rust manages memory. All programs
                                        must
                                        manage the way they use
                                        a computer's memory while running. Some languages have garbage collection,
                                        others
                                        require manual memory
                                        management. Rust uses a third approach: memory is managed through a system of
                                        ownership with rules that
                                        the compiler checks at compile time.</p>

                                    <div class="info-box">
                                        <strong>Real-World Analogy:</strong> Think of ownership like a library book
                                        system.
                                        When you check out a book
                                        (value), you become its owner. Only one person can own the book at a time. When
                                        you
                                        return it (variable goes
                                        out of scope), the library can lend it to someone else or remove it from the
                                        collection.
                                    </div>

                                    <!-- The Three Rules -->
                                    <h2>The Three Rules of Ownership</h2>
                                    <p>Keep these rules in mind as we work through examples:</p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-ownership-rules.svg"
                                            alt="The Three Rules of Ownership" class="tutorial-diagram" />
                                    </div>

                                    <ol class="numbered-list">
                                        <li><strong>Each value in Rust has a variable that's called its owner.</strong>
                                        </li>
                                        <li><strong>There can only be one owner at a time.</strong></li>
                                        <li><strong>When the owner goes out of scope, the value will be
                                                dropped.</strong>
                                        </li>
                                    </ol>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/ownership-rules.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-ownership-rules" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Stack vs Heap -->
                                    <h2>The Stack and the Heap</h2>
                                    <p>To understand ownership, we need to understand how memory works. Both the stack
                                        and
                                        the heap are parts of
                                        memory available to your code at runtime, but they're structured differently.
                                    </p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-stack-heap.svg"
                                            alt="Stack vs Heap Memory" class="tutorial-diagram" />
                                    </div>

                                    <h3>The Stack</h3>
                                    <p>The stack stores values in the order it gets them and removes them in the
                                        opposite
                                        order (LIFO - Last In,
                                        First Out). All data stored on the stack must have a known, fixed size at
                                        compile
                                        time.</p>

                                    <ul>
                                        <li><strong>Fast:</strong> Adding and removing data is very quick</li>
                                        <li><strong>Fixed size:</strong> Size must be known at compile time</li>
                                        <li><strong>Automatic:</strong> Memory is automatically managed</li>
                                        <li><strong>Examples:</strong> Integers, booleans, chars, fixed-size arrays</li>
                                    </ul>

                                    <h3>The Heap</h3>
                                    <p>The heap is less organized. When you put data on the heap, you request a certain
                                        amount of space. The
                                        memory allocator finds an empty spot big enough, marks it as in use, and returns
                                        a
                                        pointer.</p>

                                    <ul>
                                        <li><strong>Slower:</strong> Allocating requires finding space</li>
                                        <li><strong>Dynamic size:</strong> Can grow or shrink at runtime</li>
                                        <li><strong>Manual management:</strong> Must be explicitly freed (Rust does this
                                            via
                                            ownership)</li>
                                        <li><strong>Examples:</strong> String, Vec, Box, HashMap</li>
                                    </ul>

                                    <div class="tip-box">
                                        <strong>Performance Tip:</strong> Accessing data on the stack is faster than the
                                        heap because you don't have
                                        to follow a pointer. Modern processors are faster if they jump around less in
                                        memory.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/stack-vs-heap.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-stack-heap" />
                                    </jsp:include>

                                    <!-- Move Semantics -->
                                    <h2>Move Semantics</h2>
                                    <p>When you assign a heap-allocated value to another variable, Rust <em>moves</em>
                                        the
                                        ownership rather than
                                        copying the data. This is different from many other languages!</p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-move-semantics.svg"
                                            alt="Move Semantics Visualization" class="tutorial-diagram" />
                                    </div>

                                    <pre><code class="language-rust">let s1 = String::from("hello");
let s2 = s1;  // s1 is moved to s2

// println!("{}", s1);  // Error! s1 is no longer valid
println!("{}", s2);  // OK! s2 is the owner</code></pre>

                                    <div class="warning-box">
                                        <strong>Why Move?</strong> If Rust allowed both <code>s1</code> and
                                        <code>s2</code> to be valid, when they
                                        both go out of scope, they would both try to free the same memory. This is
                                        called a
                                        <em>double free</em> error
                                        and is a memory safety bug. Rust prevents this by invalidating <code>s1</code>.
                                    </div>

                                    <!-- Copy Trait -->
                                    <h2>The Copy Trait</h2>
                                    <p>Some types implement the <code>Copy</code> trait. When a type implements
                                        <code>Copy</code>, variables are
                                        copied instead of moved. This applies to simple scalar values stored entirely on
                                        the stack.
                                    </p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Copy Types</th>
                                                <th>Move Types</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>All integers (<code>i32</code>, <code>u64</code>, etc.)</td>
                                                <td><code>String</code></td>
                                            </tr>
                                            <tr>
                                                <td>Floating point (<code>f32</code>, <code>f64</code>)</td>
                                                <td><code>Vec&lt;T&gt;</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>bool</code></td>
                                                <td><code>Box&lt;T&gt;</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>char</code></td>
                                                <td><code>HashMap&lt;K, V&gt;</code></td>
                                            </tr>
                                            <tr>
                                                <td>Tuples (if all elements are Copy)</td>
                                                <td>Any type with heap data</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-rust">// Copy types - both variables are valid
let x = 5;
let y = x;
println!("x: {}, y: {}", x, y);  // Both work!

// Move types - only one owner
let s1 = String::from("hello");
let s2 = s1;
// println!("{}", s1);  // Error! s1 was moved</code></pre>

                                    <!-- Clone -->
                                    <h2>Deep Copying with Clone</h2>
                                    <p>If you <em>do</em> want to deeply copy heap data, you can use the
                                        <code>clone</code> method:
                                    </p>

                                    <pre><code class="language-rust">let s1 = String::from("hello");
let s2 = s1.clone();  // Deep copy of heap data

println!("s1: {}, s2: {}", s1, s2);  // Both are valid!</code></pre>

                                    <div class="warning-box">
                                        <strong>Performance Note:</strong> Calling <code>clone</code> can be expensive
                                        because it copies all the heap
                                        data. Use it only when you actually need a deep copy.
                                    </div>

                                    <!-- Ownership and Functions -->
                                    <h2>Ownership and Functions</h2>
                                    <p>Passing a value to a function will move or copy, just like assignment:</p>

                                    <pre><code class="language-rust">fn main() {
    let s = String::from("hello");
    takes_ownership(s);  // s is moved into the function
    // s is no longer valid here
    
    let x = 5;
    makes_copy(x);  // x is copied
    // x is still valid here
}

fn takes_ownership(some_string: String) {
    println!("{}", some_string);
}  // some_string goes out of scope and is dropped

fn makes_copy(some_integer: i32) {
    println!("{}", some_integer);
}  // some_integer goes out of scope, nothing special happens</code></pre>

                                    <h3>Returning Values and Ownership</h3>
                                    <p>Returning values can also transfer ownership:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/ownership-functions.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-ownership-functions" />
                                    </jsp:include>

                                    <!-- Common Mistakes -->
                                    <h2>Common Ownership Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using a value after it's been moved</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let s1 = String::from("hello");
let s2 = s1;
println!("{}", s1);  // Error: value borrowed after move</code></pre>
                                        <p><strong>Fix Option 1 - Clone:</strong></p>
                                        <pre><code class="language-rust">let s1 = String::from("hello");
let s2 = s1.clone();
println!("{}", s1);  // OK! s1 still owns its data</code></pre>
                                        <p><strong>Fix Option 2 - Use references (next lesson):</strong></p>
                                        <pre><code class="language-rust">let s1 = String::from("hello");
let s2 = &s1;  // Borrow instead of move
println!("{}", s1);  // OK! s1 still owns its data</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Forgetting that functions take ownership</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let s = String::from("hello");
print_string(s);
println!("{}", s);  // Error: s was moved into function

fn print_string(text: String) {
    println!("{}", text);
}</code></pre>
                                        <p><strong>Fix - Return ownership:</strong></p>
                                        <pre><code class="language-rust">let s = String::from("hello");
let s = print_and_return(s);
println!("{}", s);  // OK!

fn print_and_return(text: String) -> String {
    println!("{}", text);
    text  // Return ownership
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Moving in a loop</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let words = vec![String::from("hello")];
for word in words {
    println!("{}", word);
}
println!("{:?}", words);  // Error: words was moved</code></pre>
                                        <p><strong>Fix - Iterate by reference:</strong></p>
                                        <pre><code class="language-rust">let words = vec![String::from("hello")];
for word in &words {  // Borrow each element
    println!("{}", word);
}
println!("{:?}", words);  // OK!</code></pre>
                                    </div>

                                    <!-- Best Practices -->
                                    <h2>Ownership Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Prefer borrowing over moving:</strong> We'll learn about
                                                references
                                                in the next lesson</li>
                                            <li><strong>Use clone sparingly:</strong> It's expensive; only use when you
                                                truly need a deep copy</li>
                                            <li><strong>Return ownership when needed:</strong> Functions can return
                                                values
                                                to give ownership back</li>
                                            <li><strong>Understand Copy vs Move:</strong> Know which types implement
                                                Copy
                                            </li>
                                            <li><strong>Let the compiler guide you:</strong> Ownership errors are caught
                                                at
                                                compile time with helpful messages</li>
                                            <li><strong>Think about ownership early:</strong> Design your APIs with
                                                ownership in mind</li>
                                        </ul>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Ownership Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Fix the ownership errors in the code.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Fix moved value errors</li>
                                            <li>Use clone where appropriate</li>
                                            <li>Return ownership from functions</li>
                                            <li>Handle ownership in loops</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-ownership-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-ownership" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn main() {
    // Fix 1: Clone s1
    let s1 = String::from("hello");
    let s2 = s1.clone();
    println!("s1: {}, s2: {}", s1, s2);
    
    // Fix 2: Return ownership
    let s3 = String::from("world");
    print_string_fixed(s3.clone());
    println!("s3: {}", s3);
    
    // Fix 3: Return tuple
    let s4 = String::from("Rust");
    let (s4, len) = calculate_length_fixed(s4);
    println!("Length of '{}' is {}", s4, len);
    
    // Fix 4: Return both values
    let s5 = String::from("programming");
    let (s5, s6) = append_exclamation_fixed(s5);
    println!("s5: {}, s6: {}", s5, s6);
    
    // Fix 5: Clone for copy
    let x = String::from("copy");
    let y = x.clone();
    println!("x: {}, y: {}", x, y);
    
    // Fix 6: Use iter()
    let words = vec![
        String::from("hello"),
        String::from("world"),
    ];
    
    for word in &words {
        println!("{}", word);
    }
    
    println!("Words: {:?}", words);
}

fn print_string_fixed(s: String) {
    println!("{}", s);
}

fn calculate_length_fixed(s: String) -> (String, usize) {
    let len = s.len();
    (s, len)
}

fn append_exclamation_fixed(s: String) -> (String, String) {
    let mut result = s.clone();
    result.push('!');
    (s, result)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Ownership</strong> is Rust's most unique feature for memory
                                                safety
                                            </li>
                                            <li><strong>Three rules:</strong> Each value has one owner, only one owner
                                                at a
                                                time, value dropped when owner goes out of scope</li>
                                            <li><strong>Stack:</strong> Fast, fixed-size, automatic management</li>
                                            <li><strong>Heap:</strong> Slower, dynamic-size, ownership rules apply</li>
                                            <li><strong>Move semantics:</strong> Heap values are moved, not copied by
                                                default</li>
                                            <li><strong>Copy trait:</strong> Simple stack values are copied
                                                automatically
                                            </li>
                                            <li><strong>Clone:</strong> Explicit deep copy for heap data</li>
                                            <li>Functions can <strong>take and return ownership</strong></li>
                                            <li>Ownership errors are caught at <strong>compile time</strong></li>
                                            <li>No garbage collector needed - zero runtime overhead!</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Ownership is powerful, but taking and returning ownership with every function
                                        would
                                        be tedious. In the next
                                        lesson, you'll learn about <strong>references and borrowing</strong> - a way to
                                        use
                                        values without taking
                                        ownership. This makes Rust both safe and ergonomic.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="control-match.jsp" />
                                    <jsp:param name="prevTitle" value="Pattern Matching" />
                                    <jsp:param name="nextLink" value="borrowing.jsp" />
                                    <jsp:param name="nextTitle" value="References & Borrowing" />
                                    <jsp:param name="currentLessonId" value="ownership" />
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