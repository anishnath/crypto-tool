<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "borrowing" ); request.setAttribute("currentModule", "Ownership" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Borrowing Tutorial - References & Borrowing | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust borrowing and references with examples. Master immutable & mutable references, borrowing rules, and prevent dangling pointers. Free tutorial.">
            <meta name="keywords"
                content="rust borrowing, rust borrowing tutorial, rust references, rust &T, rust &mut T, rust mutable references, rust borrowing rules, rust borrow checker, learn rust, rust tutorial">

            <meta property="og:type" content="article">
            <meta property="og:title" content="References & Borrowing in Rust - Safe Memory Access">
            <meta property="og:description" content="Master Rust's references and borrowing system.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/borrowing.jsp">
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
    "name": "Rust Borrowing Tutorial - References & Borrowing",
    "description": "Learn Rust borrowing and references with examples. Master immutable & mutable references, borrowing rules, and prevent dangling pointers. Free tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/borrowing.jsp",
    "keywords": "rust borrowing, rust borrowing tutorial, rust references, rust &T, rust &mut T, rust mutable references, rust borrowing rules, rust borrow checker, learn rust, rust tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust references", "Borrowing", "Mutable references", "Immutable references", "Borrowing rules"],
    "timeRequired": "PT25M",
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
            "name": "References & Borrowing"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="borrowing">
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
                                    <span>References & Borrowing</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">References & Borrowing</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">In the previous lesson, we learned that transferring ownership can
                                        be
                                        tedious. Imagine having to
                                        pass ownership back and forth with every function call! Fortunately, Rust
                                        provides
                                        <strong>references</strong> -
                                        a way to refer to a value without taking ownership of it. This is called
                                        <strong>borrowing</strong>.
                                    </p>

                                    <!-- What is a Reference? -->
                                    <h2>What is a Reference?</h2>
                                    <p>A reference is like a pointer: it's an address we can follow to access data
                                        stored
                                        at that address. Unlike
                                        a pointer, a reference is guaranteed to point to a valid value of a particular
                                        type
                                        for the life of that
                                        reference.</p>

                                    <div class="info-box">
                                        <strong>Real-World Analogy:</strong> Think of borrowing like checking out a
                                        library
                                        book. You can read it
                                        (immutable reference) or make notes in it if it's a special notebook (mutable
                                        reference), but you don't own
                                        it. When you're done, you return it to the library (the owner).
                                    </div>

                                    <pre><code class="language-rust">let s1 = String::from("hello");
let len = calculate_length(&s1);  // &s1 creates a reference to s1

println!("The length of '{}' is {}", s1, len);

fn calculate_length(s: &String) -> usize {
    s.len()
}  // s goes out of scope, but it doesn't own the data</code></pre>

                                    <p>The <code>&s1</code> syntax creates a reference that <em>refers to</em> the value
                                        of
                                        <code>s1</code> but does
                                        not own it. Because it doesn't own it, the value it points to will not be
                                        dropped
                                        when the reference stops
                                        being used.
                                    </p>

                                    <!-- Immutable References -->
                                    <h2>Immutable References (&T)</h2>
                                    <p>By default, references are immutable. You can have multiple immutable references
                                        to
                                        the same data:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/references-immutable.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-immutable-refs" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Multiple Readers:</strong> Having multiple immutable references is safe
                                        because no one can modify
                                        the data. It's like having multiple people reading the same book - they don't
                                        interfere with each other.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Mutable References -->
                                    <h2>Mutable References (&mut T)</h2>
                                    <p>If you want to modify a borrowed value, you need a mutable reference:</p>

                                    <pre><code class="language-rust">let mut s = String::from("hello");

change(&mut s);  // Pass a mutable reference

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Important Restriction:</strong> You can have only <strong>one</strong>
                                        mutable reference to a
                                        particular piece of data at a time. This prevents data races at compile time!
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/references-mutable.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-mutable-refs" />
                                    </jsp:include>

                                    <!-- The Borrowing Rules -->
                                    <h2>The Borrowing Rules</h2>
                                    <p>Rust enforces these rules at compile time to prevent data races:</p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-references-borrowing.svg"
                                            alt="References and Borrowing Rules" class="tutorial-diagram" />
                                    </div>

                                    <ol class="numbered-list">
                                        <li><strong>You can have any number of immutable references</strong> to a value
                                        </li>
                                        <li><strong>You can have only ONE mutable reference</strong> to a value</li>
                                        <li><strong>You cannot have mutable and immutable references at the same
                                                time</strong></li>
                                    </ol>

                                    <h3>Why These Rules?</h3>
                                    <p>These rules prevent <strong>data races</strong>, which occur when:</p>
                                    <ul>
                                        <li>Two or more pointers access the same data at the same time</li>
                                        <li>At least one pointer is being used to write to the data</li>
                                        <li>There's no mechanism to synchronize access to the data</li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/borrowing-rules.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-borrowing-rules" />
                                    </jsp:include>

                                    <!-- Reference Scope -->
                                    <h2>Reference Scope and Lifetimes</h2>
                                    <p>A reference's scope starts where it's introduced and continues through its last
                                        use:
                                    </p>

                                    <pre><code class="language-rust">let mut s = String::from("hello");

let r1 = &s;
let r2 = &s;
println!("{} and {}", r1, r2);
// r1 and r2 are no longer used after this point

let r3 = &mut s;  // OK! No immutable references are active
println!("{}", r3);</code></pre>

                                    <div class="info-box">
                                        <strong>Non-Lexical Lifetimes (NLL):</strong> The Rust compiler is smart enough
                                        to
                                        see that <code>r1</code>
                                        and <code>r2</code> are not used after the <code>println!</code>, so it's safe
                                        to
                                        create a mutable reference.
                                    </div>

                                    <!-- Dangling References -->
                                    <h2>Dangling References</h2>
                                    <p>In languages with pointers, it's easy to create a <em>dangling pointer</em> - a
                                        pointer that references a
                                        location in memory that may have been given to someone else. Rust guarantees
                                        that
                                        references will never be
                                        dangling:</p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-dangling-prevention.svg"
                                            alt="Rust Prevents Dangling References" class="tutorial-diagram" />
                                    </div>

                                    <pre><code class="language-rust">// This won't compile!
// fn dangle() -> &String {
//     let s = String::from("hello");
//     &s  // Error! s will be dropped, creating a dangling reference
// }

// Correct version - return the String itself
fn no_dangle() -> String {
    let s = String::from("hello");
    s  // Ownership is moved out
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Compile-Time Safety:</strong> The Rust compiler prevents dangling
                                        references at compile time.
                                        You'll get a helpful error message explaining the problem.
                                    </div>

                                    <!-- Comparison Table -->
                                    <h2>References vs Ownership</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Aspect</th>
                                                <th>Ownership</th>
                                                <th>Immutable Reference</th>
                                                <th>Mutable Reference</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Syntax</td>
                                                <td><code>T</code></td>
                                                <td><code>&T</code></td>
                                                <td><code>&mut T</code></td>
                                            </tr>
                                            <tr>
                                                <td>Owns data</td>
                                                <td>Yes</td>
                                                <td>No</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>Can modify</td>
                                                <td>Yes (if mut)</td>
                                                <td>No</td>
                                                <td>Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Multiple allowed</td>
                                                <td>No</td>
                                                <td>Yes</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>Drops data</td>
                                                <td>Yes</td>
                                                <td>No</td>
                                                <td>No</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Common Mistakes -->
                                    <h2>Common Borrowing Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Multiple mutable references</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let mut s = String::from("hello");
let r1 = &mut s;
let r2 = &mut s;  // Error! Cannot have two mutable references
println!("{}, {}", r1, r2);</code></pre>
                                        <p><strong>Fix - Use scopes:</strong></p>
                                        <pre><code class="language-rust">let mut s = String::from("hello");
{
    let r1 = &mut s;
}  // r1 goes out of scope
let r2 = &mut s;  // OK!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Mixing mutable and immutable references</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let mut s = String::from("hello");
let r1 = &s;
let r2 = &mut s;  // Error! Cannot borrow as mutable
println!("{}, {}", r1, r2);</code></pre>
                                        <p><strong>Fix - Separate usage:</strong></p>
                                        <pre><code class="language-rust">let mut s = String::from("hello");
let r1 = &s;
println!("{}", r1);  // r1 is no longer used after this

let r2 = &mut s;  // OK!
println!("{}", r2);</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Modifying through immutable reference</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">fn change(s: &String) {
    s.push_str("!");  // Error! Cannot mutate through & reference
}</code></pre>
                                        <p><strong>Fix - Use mutable reference:</strong></p>
                                        <pre><code class="language-rust">fn change(s: &mut String) {
    s.push_str("!");  // OK!
}</code></pre>
                                    </div>

                                    <!-- Best Practices -->
                                    <h2>Borrowing Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Prefer borrowing over ownership:</strong> Use references when
                                                you
                                                don't need to own the data</li>
                                            <li><strong>Use immutable references by default:</strong> Only use
                                                <code>&mut</code> when you need to modify
                                            </li>
                                            <li><strong>Keep mutable reference scopes small:</strong> Limit the scope of
                                                mutable references</li>
                                            <li><strong>Let references expire:</strong> Use references and let them go
                                                out
                                                of scope before creating new ones</li>
                                            <li><strong>Trust the compiler:</strong> Borrowing errors are caught at
                                                compile
                                                time with helpful messages</li>
                                            <li><strong>Think about data flow:</strong> Design your functions to
                                                minimize
                                                mutable state</li>
                                        </ul>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Borrowing Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Fix the borrowing errors in the code.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Fix immutable reference errors</li>
                                            <li>Fix multiple mutable reference errors</li>
                                            <li>Fix mixed reference errors</li>
                                            <li>Use proper reference types</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-borrowing-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-borrowing" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn main() {
    // Fix 1: Use mutable reference
    let mut s = String::from("hello");
    change_string(&mut s);
    println!("{}", s);
    
    // Fix 2: Separate mutable references
    let mut s1 = String::from("world");
    let r1 = &mut s1;
    r1.push_str("!");
    println!("{}", r1);
    // r1 is done, now create r2
    let r2 = &mut s1;
    r2.push_str("!");
    println!("{}", r2);
    
    // Fix 3: Separate immutable and mutable
    let mut s2 = String::from("Rust");
    let r1 = &s2;
    println!("{}", r1);
    // r1 is done
    let r2 = &mut s2;
    r2.push_str("!");
    println!("{}", r2);
    
    // Fix 4: Use reference
    let s3 = String::from("programming");
    let len = calculate_length_fixed(&s3);
    println!("Length of '{}' is {}", s3, len);
    
    // Fix 5: Use mutable reference
    let mut s4 = String::from("hello");
    append_world(&mut s4);
    println!("{}", s4);
}

fn change_string(s: &mut String) {
    s.push_str(", world");
}

fn calculate_length_fixed(s: &String) -> usize {
    s.len()
}

fn append_world(s: &mut String) {
    s.push_str(" world");
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>References</strong> let you refer to values without taking
                                                ownership
                                            </li>
                                            <li><strong>Borrowing</strong> is creating a reference</li>
                                            <li><strong>Immutable references (&T):</strong> Read-only access, multiple
                                                allowed</li>
                                            <li><strong>Mutable references (&mut T):</strong> Read-write access, only
                                                one at
                                                a time</li>
                                            <li><strong>Three borrowing rules:</strong> Multiple immutable OR one
                                                mutable,
                                                never both</li>
                                            <li>References must always be <strong>valid</strong> - no dangling
                                                references
                                            </li>
                                            <li>Reference scope ends at <strong>last use</strong>, not end of block</li>
                                            <li>Borrowing rules prevent <strong>data races</strong> at compile time</li>
                                            <li>The compiler provides <strong>helpful error messages</strong> for
                                                borrowing
                                                issues</li>
                                            <li>References are <strong>zero-cost abstractions</strong> - no runtime
                                                overhead!
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You now understand ownership and borrowing - the core of Rust's memory safety! In
                                        the next lesson,
                                        you'll learn about <strong>slices</strong> - a special kind of reference that
                                        lets
                                        you reference a
                                        contiguous sequence of elements in a collection rather than the whole
                                        collection.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="ownership.jsp" />
                                    <jsp:param name="prevTitle" value="Ownership" />
                                    <jsp:param name="nextLink" value="slices.jsp" />
                                    <jsp:param name="nextTitle" value="Slices" />
                                    <jsp:param name="currentLessonId" value="borrowing" />
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