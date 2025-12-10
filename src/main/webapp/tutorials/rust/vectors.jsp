<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "vectors" ); request.setAttribute("currentModule", "Collections" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Vectors Tutorial - Vec&lt;T&gt; Examples | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust vectors with examples. Create, access, update Vec&lt;T&gt; dynamic arrays. Master vector methods, iteration, and ownership. Free Rust tutorial.">
            <meta name="keywords"
                content="rust vectors, rust vec tutorial, rust dynamic arrays, rust collections, rust vector methods, rust vec push pop, rust vec examples, learn rust, rust programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Vectors in Rust - Dynamic Arrays Vec&lt;T&gt;">
            <meta property="og:description" content="Master Rust vectors for dynamic array storage.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/vectors.jsp">
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
    "name": "Rust Vectors Tutorial - Vec&lt;T&gt; Examples",
    "description": "Learn Rust vectors with examples. Create, access, update Vec&lt;T&gt; dynamic arrays. Master vector methods, iteration, and ownership. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/rust/vectors.jsp",
    "keywords": "rust vectors, rust vec tutorial, rust dynamic arrays, rust collections, rust vector methods, rust vec push pop, rust vec examples, learn rust, rust programming",
    "teaches": ["Rust vectors", "Vec&lt;T&gt;", "Dynamic arrays", "Vector methods", "Vector iteration", "Vector ownership", "Rust collections"],
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
            "name": "Vectors"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="vectors">
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
                                    <span>Vectors</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Vectors</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A <em>vector</em> allows you to store a variable number of values
                                        next to each other in memory. Vectors can only store values of the same type,
                                        making them useful when you have a list of items, such as the items in a shopping
                                        cart or the lines of text in a file. Vectors are one of the most commonly used
                                        collection types in Rust.
                                    </p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-collections-hierarchy.svg"
                                            alt="Rust Collections Hierarchy" class="tutorial-diagram" />
                                    </div>

                                    <h2>Creating Vectors</h2>
                                    <p>There are several ways to create a vector. The most common is using the
                                        <code>vec!</code> macro:</p>

                                    <pre><code class="language-rust">let v = vec![1, 2, 3];</code></pre>

                                    <p>You can also create an empty vector and add elements later:</p>

                                    <pre><code class="language-rust">let mut v: Vec<i32> = Vec::new();
v.push(1);
v.push(2);
v.push(3);</code></pre>

                                    <div class="info-box">
                                        <strong>Type Annotation:</strong> When creating an empty vector, Rust needs to
                                        know what type you plan to store. You can either specify the type explicitly
                                        (<code>Vec&lt;i32&gt;</code>) or let Rust infer it from the first element you
                                        push.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/vectors-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-vectors-basics" />
                                    </jsp:include>

                                    <h2>Reading Vector Elements</h2>
                                    <p>There are two ways to reference a value stored in a vector:</p>

                                    <h3>1. Using Index Syntax (Panics on Out of Bounds)</h3>
                                    <pre><code class="language-rust">let v = vec![1, 2, 3, 4, 5];
let third = &v[2];
println!("The third element is {}", third);</code></pre>

                                    <div class="warning-box">
                                        <strong>Panic on Out of Bounds:</strong> Using <code>&v[index]</code> will panic
                                        if the index is out of bounds. Use this when you're certain the index exists.
                                    </div>

                                    <h3>2. Using get() Method (Returns Option)</h3>
                                    <pre><code class="language-rust">let v = vec![1, 2, 3, 4, 5];
match v.get(2) {
    Some(third) => println!("The third element is {}", third),
    None => println!("There is no third element."),
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Safe Access:</strong> Use <code>get()</code> when you're not sure if the
                                        index exists. It returns <code>Option&lt;&T&gt;</code>, which you can handle
                                        safely with <code>match</code> or <code>unwrap_or()</code>.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Updating Vectors</h2>
                                    <p>To add elements to a vector, use the <code>push</code> method. The vector must be
                                        mutable:</p>

                                    <pre><code class="language-rust">let mut v = Vec::new();
v.push(5);
v.push(6);
v.push(7);
v.push(8);</code></pre>

                                    <h2>Vector Methods</h2>
                                    <p>Vectors have many useful methods for manipulation:</p>

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
                                                <td><code>push(value)</code></td>
                                                <td>Add element to end</td>
                                                <td><code>v.push(5)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>pop()</code></td>
                                                <td>Remove and return last element</td>
                                                <td><code>v.pop()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>insert(index, value)</code></td>
                                                <td>Insert at index</td>
                                                <td><code>v.insert(2, 99)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>remove(index)</code></td>
                                                <td>Remove at index</td>
                                                <td><code>v.remove(2)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>len()</code></td>
                                                <td>Get length</td>
                                                <td><code>v.len()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>is_empty()</code></td>
                                                <td>Check if empty</td>
                                                <td><code>v.is_empty()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>clear()</code></td>
                                                <td>Remove all elements</td>
                                                <td><code>v.clear()</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/vectors-ownership.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-vectors-ownership" />
                                    </jsp:include>

                                    <h2>Iterating Over Vectors</h2>
                                    <p>You can iterate over the elements in a vector using a <code>for</code> loop:</p>

                                    <h3>Immutable Iteration</h3>
                                    <pre><code class="language-rust">let v = vec![100, 32, 57];
for i in &v {
    println!("{}", i);
}</code></pre>

                                    <h3>Mutable Iteration</h3>
                                    <pre><code class="language-rust">let mut v = vec![100, 32, 57];
for i in &mut v {
    *i += 50;
}</code></pre>

                                    <div class="info-box">
                                        <strong>Dereference Operator:</strong> When iterating mutably, use <code>*</code>
                                        to dereference the reference and modify the value.
                                    </div>

                                    <h2>Vectors and Ownership</h2>
                                    <p>Vectors own their data. When you borrow a vector element, you can't modify the
                                        vector:</p>

                                    <pre><code class="language-rust">let mut v = vec![1, 2, 3, 4, 5];
let first = &v[0];
// v.push(6);  // Error! Can't borrow as mutable while borrowed as immutable
println!("The first element is: {}", first);</code></pre>

                                    <div class="warning-box">
                                        <strong>Borrowing Rules Apply:</strong> The same borrowing rules apply to
                                        vectors. You can't have mutable and immutable borrows at the same time. This
                                        prevents data races and ensures memory safety.
                                    </div>

                                    <h2>Using Enums to Store Multiple Types</h2>
                                    <p>Vectors can only store values of the same type. To store different types, use an
                                        enum:</p>

                                    <pre><code class="language-rust">enum SpreadsheetCell {
    Int(i32),
    Float(f64),
    Text(String),
}

let row = vec![
    SpreadsheetCell::Int(3),
    SpreadsheetCell::Text(String::from("blue")),
    SpreadsheetCell::Float(10.12),
];</code></pre>

                                    <div class="tip-box">
                                        <strong>Enum Solution:</strong> Using an enum with variants is a way to store
                                        different types in a vector. Each enum variant can hold different data, but they're
                                        all the same enum type.
                                    </div>

                                    <h2>Vector Capacity</h2>
                                    <p>Vectors have both a <em>length</em> and a <em>capacity</em>:</p>

                                    <pre><code class="language-rust">let mut v = Vec::with_capacity(10);
println!("Capacity: {}, Length: {}", v.capacity(), v.len());
v.push(1);
println!("Capacity: {}, Length: {}", v.capacity(), v.len());</code></pre>

                                    <div class="info-box">
                                        <strong>Capacity vs Length:</strong> The <em>length</em> is the number of
                                        elements currently in the vector. The <em>capacity</em> is the amount of space
                                        allocated for future elements. When length exceeds capacity, Rust automatically
                                        reallocates with more capacity.
                                    </div>

                                    <h2>When to Use Vectors</h2>
                                    <div class="best-practice-box">
                                        <p><strong>Use <code>Vec&lt;T&gt;</code> when:</strong></p>
                                        <ul>
                                            <li><strong>You need a dynamic array:</strong> When the size is unknown at compile time or needs to grow/shrink</li>
                                            <li><strong>You need indexed access:</strong> When you frequently access elements by index (O(1) access)</li>
                                            <li><strong>You need ordered data:</strong> When the order of elements matters</li>
                                            <li><strong>You're storing homogeneous data:</strong> All elements must be the same type (or use enums for variants)</li>
                                            <li><strong>You need fast iteration:</strong> Vectors are cache-friendly and iterate efficiently</li>
                                            <li><strong>You're building lists, queues, or stacks:</strong> Vectors are perfect for these use cases</li>
                                        </ul>
                                        
                                        <p style="margin-top: 15px;"><strong>Consider alternatives when:</strong></p>
                                        <ul>
                                            <li><strong>Fixed size known at compile time:</strong> Use arrays <code>[T; N]</code> instead</li>
                                            <li><strong>Need key-value pairs:</strong> Use <code>HashMap&lt;K, V&gt;</code> for lookups by key</li>
                                            <li><strong>Need unique elements:</strong> Use <code>HashSet&lt;T&gt;</code> for sets</li>
                                            <li><strong>Need double-ended queue:</strong> Use <code>VecDeque&lt;T&gt;</code> for efficient push/pop at both ends</li>
                                            <li><strong>Need sorted order:</strong> Use <code>BTreeSet&lt;T&gt;</code> or <code>BTreeMap&lt;K, V&gt;</code></li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <strong>Performance Tip:</strong> Vectors are the most commonly used collection in Rust because they're versatile and performant. They're heap-allocated but provide O(1) indexed access and efficient iteration. Use <code>Vec::with_capacity()</code> when you know the approximate size to avoid reallocations.
                                    </div>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use <code>get()</code> for safe access:</strong> Prefer
                                                <code>get()</code> over index syntax when you're not certain the index
                                                exists</li>
                                            <li><strong>Prefer iteration over indexing:</strong> Iterating is safer and
                                                more idiomatic</li>
                                            <li><strong>Use <code>Vec::with_capacity()</code> when you know the size:</strong>
                                                Reduces reallocations</li>
                                            <li><strong>Consider ownership:</strong> Remember that vectors own their
                                                data</li>
                                            <li><strong>Use enums for multiple types:</strong> If you need different
                                                types, wrap them in an enum</li>
                                            <li><strong>Avoid unnecessary clones:</strong> Use references when possible
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Trying to modify a vector while holding a reference</h4>
                                        <pre><code class="language-rust">// Wrong - Can't modify while borrowed
let mut v = vec![1, 2, 3];
let first = &v[0];
v.push(4);  // Error: cannot borrow as mutable

// Correct - Use the reference first, then modify
let mut v = vec![1, 2, 3];
let first = &v[0];
println!("{}", first);  // Use the reference
v.push(4);  // Now we can modify</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using index syntax without checking bounds</h4>
                                        <pre><code class="language-rust">// Wrong - Panics if index doesn't exist
let v = vec![1, 2, 3];
let value = v[10];  // Panic!

// Correct - Use get() for safe access
let v = vec![1, 2, 3];
match v.get(10) {
    Some(value) => println!("{}", value),
    None => println!("Index out of bounds"),
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting to make vector mutable for modifications</h4>
                                        <pre><code class="language-rust">// Wrong - Vector not mutable
let v = vec![1, 2, 3];
v.push(4);  // Error: cannot borrow as mutable

// Correct - Make vector mutable
let mut v = vec![1, 2, 3];
v.push(4);  // OK</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Trying to store different types directly in a vector</h4>
                                        <pre><code class="language-rust">// Wrong - Can't store different types
let v = vec![1, "hello", 3.14];  // Error: mismatched types

// Correct - Use enum to wrap different types
enum Value {
    Int(i32),
    Str(String),
    Float(f64),
}
let v = vec![
    Value::Int(1),
    Value::Str(String::from("hello")),
    Value::Float(3.14),
];</code></pre>
                                    </div>

                                    <h2>Exercise: Vectors Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Complete the vector operations and implement vector
                                            statistics functions.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create vectors using different methods</li>
                                            <li>Access elements safely using <code>get()</code></li>
                                            <li>Modify vectors (push, pop, insert, remove)</li>
                                            <li>Iterate over vectors</li>
                                            <li>Implement statistics functions (mean, median, mode)</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-collections-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-vectors" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">use std::collections::HashMap;

fn statistics(numbers: &Vec<i32>) -> (f64, i32, i32) {
    // Mean
    let sum: i32 = numbers.iter().sum();
    let mean = sum as f64 / numbers.len() as f64;
    
    // Median
    let mut sorted = numbers.clone();
    sorted.sort();
    let median = sorted[sorted.len() / 2];
    
    // Mode
    let mut counts = HashMap::new();
    for &num in numbers {
        *counts.entry(num).or_insert(0) += 1;
    }
    let mode = counts.iter()
        .max_by_key(|(_, &count)| count)
        .map(|(&num, _)| num)
        .unwrap_or(0);
    
    (mean, median, mode)
}

fn main() {
    let numbers = vec![1, 2, 2, 3, 3, 3, 4, 5];
    let (mean, median, mode) = statistics(&numbers);
    println!("Mean: {}, Median: {}, Mode: {}", mean, median, mode);
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Vectors</strong> store multiple values of the same type</li>
                                            <li>Create with <code>vec![]</code> macro or <code>Vec::new()</code></li>
                                            <li>Access with <code>&v[index]</code> (panics) or <code>v.get(index)</code>
                                                (safe)</li>
                                            <li>Modify with <code>push()</code>, <code>pop()</code>, <code>insert()</code>,
                                                <code>remove()</code></li>
                                            <li>Iterate with <code>for</code> loops</li>
                                            <li>Vectors <strong>own</strong> their data</li>
                                            <li>Can't modify while borrowed (same borrowing rules)</li>
                                            <li>Use <strong>enums</strong> to store different types in one vector</li>
                                            <li>Vectors have <strong>length</strong> and <strong>capacity</strong></li>
                                            <li>Use <code>Vec::with_capacity()</code> when you know the size</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand vectors, you'll learn about <strong>HashMaps</strong> - a
                                        collection type that stores key-value pairs. HashMaps are useful when you need to
                                        look up data by a key rather than by an index. In the next lesson, you'll learn
                                        how to create, access, and update HashMaps, and use the powerful entry API.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="enums.jsp" />
                                    <jsp:param name="prevTitle" value="Enums & Pattern Matching" />
                                    <jsp:param name="nextLink" value="hashmaps.jsp" />
                                    <jsp:param name="nextTitle" value="HashMaps" />
                                    <jsp:param name="currentLessonId" value="vectors" />
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

