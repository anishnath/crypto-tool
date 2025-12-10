<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "slices" ); request.setAttribute("currentModule", "Ownership" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Slices Tutorial - String & Array Slices | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust slices with examples. Master string slices (&str), array slices, slice syntax, and safe sequence references. Free Rust tutorial.">
            <meta name="keywords"
                content="rust slices, rust slices tutorial, rust &str, rust string slices, rust array slices, rust slice syntax, rust references, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Slices in Rust - String and Array Slices">
            <meta property="og:description" content="Master Rust slices for safe sequence references.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/slices.jsp">
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
    "name": "Rust Slices Tutorial - String & Array Slices",
    "description": "Learn Rust slices with examples. Master string slices (&str), array slices, slice syntax, and safe sequence references. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/slices.jsp",
    "keywords": "rust slices, rust slices tutorial, rust &str, rust string slices, rust array slices, rust slice syntax, rust references, learn rust",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust slices", "String slices", "Array slices", "Slice syntax", "Safe references"],
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
            "name": "Slices"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="slices">
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
                                    <span>Slices</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Slices</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Slices let you reference a contiguous sequence of elements in a
                                        collection rather than the
                                        whole collection. A slice is a kind of reference, so it does not have ownership.
                                        Slices are incredibly
                                        useful for working with portions of strings and arrays safely.
                                    </p>

                                    <!-- The Problem -->
                                    <h2>The Problem: Working with Parts of Data</h2>
                                    <p>Let's say we want to write a function that takes a string and returns the first
                                        word. Without slices,
                                        we might return the index of the end of the word:</p>

                                    <pre><code class="language-rust">fn first_word(s: &String) -> usize {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return i;
        }
    }
    
    s.len()
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Problem:</strong> The index returned has no connection to the
                                        <code>String</code>. If the
                                        <code>String</code> changes, the index becomes meaningless!
                                    </div>

                                    <!-- String Slices -->
                                    <h2>String Slices</h2>
                                    <p>A <em>string slice</em> is a reference to part of a <code>String</code>:</p>

                                    <pre><code class="language-rust">let s = String::from("hello world");

let hello = &s[0..5];   // "hello"
let world = &s[6..11];  // "world"</code></pre>

                                    <p>The syntax <code>&s[start..end]</code> creates a slice starting at
                                        <code>start</code> and ending just
                                        before <code>end</code> (exclusive).
                                    </p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-slice-memory.svg"
                                            alt="String Slice Memory Layout" class="tutorial-diagram" />
                                    </div>

                                    <h3>Slice Syntax Shortcuts</h3>
                                    <pre><code class="language-rust">let s = String::from("hello");

let slice = &s[0..2];  // "he"
let slice = &s[..2];   // Same - start from beginning

let len = s.len();
let slice = &s[3..len];  // "lo"
let slice = &s[3..];     // Same - go to end

let slice = &s[0..len];  // "hello"
let slice = &s[..];      // Same - entire string</code></pre>

                                    <div class="info-box">
                                        <strong>String Slice Type:</strong> The type of a string slice is written as
                                        <code>&str</code>.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/slices-string.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-string-slices" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- String Literals are Slices -->
                                    <h2>String Literals are Slices</h2>
                                    <p>Remember string literals from earlier? They're actually slices!</p>

                                    <pre><code class="language-rust">let s = "Hello, world!";  // Type is &str</code></pre>

                                    <p>The type of <code>s</code> here is <code>&str</code>: it's a slice pointing to
                                        that specific point in the
                                        binary. This is why string literals are immutable - <code>&str</code> is an
                                        immutable reference.
                                    </p>

                                    <!-- Better first_word -->
                                    <h2>A Better first_word Function</h2>
                                    <p>Now we can write <code>first_word</code> to return a slice:</p>

                                    <pre><code class="language-rust">fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    
    &s[..]
}

fn main() {
    let my_string = String::from("hello world");
    let word = first_word(&my_string);  // Works with String
    
    let my_literal = "hello world";
    let word = first_word(my_literal);  // Works with &str
}</code></pre>

                                    <div class="tip-box">
                                        <strong>API Design Tip:</strong> Using <code>&str</code> as a parameter type
                                        instead of <code>&String</code>
                                        makes your API more flexible - it works with both <code>String</code> and
                                        <code>&str</code>!
                                    </div>

                                    <!-- Slices Enforce Safety -->
                                    <h2>Slices Enforce Safety</h2>
                                    <p>Slices prevent bugs at compile time:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/slices-safety.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-slice-safety" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Compile-Time Safety:</strong> If you have an immutable reference (slice)
                                        to something, you can't
                                        also take a mutable reference. The compiler prevents this!
                                    </div>

                                    <!-- Array Slices -->
                                    <h2>Array Slices</h2>
                                    <p>Slices work with arrays too:</p>

                                    <pre><code class="language-rust">let a = [1, 2, 3, 4, 5];

let slice = &a[1..3];  // Type is &[i32]

println!("{:?}", slice);  // [2, 3]</code></pre>

                                    <p>This slice has the type <code>&[i32]</code>. It works the same way as string
                                        slices: storing a reference
                                        to the first element and a length.
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/slices-array.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-array-slices" />
                                    </jsp:include>

                                    <!-- Slice Types -->
                                    <h2>Slice Types Summary</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Collection Type</th>
                                                <th>Slice Type</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>String</code></td>
                                                <td><code>&str</code></td>
                                                <td><code>&s[0..5]</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>[i32; 5]</code></td>
                                                <td><code>&[i32]</code></td>
                                                <td><code>&arr[1..3]</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>Vec&lt;i32&gt;</code></td>
                                                <td><code>&[i32]</code></td>
                                                <td><code>&vec[2..4]</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>[char; 10]</code></td>
                                                <td><code>&[char]</code></td>
                                                <td><code>&chars[..]</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Common Patterns -->
                                    <h2>Common Slice Patterns</h2>

                                    <h3>1. First N Elements</h3>
                                    <pre><code class="language-rust">let data = [1, 2, 3, 4, 5];
let first_three = &data[..3];  // [1, 2, 3]</code></pre>

                                    <h3>2. Last N Elements</h3>
                                    <pre><code class="language-rust">let data = [1, 2, 3, 4, 5];
let len = data.len();
let last_two = &data[len-2..];  // [4, 5]</code></pre>

                                    <h3>3. Middle Elements</h3>
                                    <pre><code class="language-rust">let data = [1, 2, 3, 4, 5];
let middle = &data[1..4];  // [2, 3, 4]</code></pre>

                                    <h3>4. Entire Collection</h3>
                                    <pre><code class="language-rust">let data = [1, 2, 3, 4, 5];
let all = &data[..];  // [1, 2, 3, 4, 5]</code></pre>

                                    <!-- Best Practices -->
                                    <h2>Slice Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use &str instead of &String:</strong> More flexible API</li>
                                            <li><strong>Use slices for function parameters:</strong> Works with owned
                                                and
                                                borrowed data</li>
                                            <li><strong>Prefer slices over indices:</strong> Safer and more expressive
                                            </li>
                                            <li><strong>Use range syntax shortcuts:</strong> <code>[..n]</code>,
                                                <code>[n..]</code>, <code>[..]</code>
                                            </li>
                                            <li><strong>Remember slices are references:</strong> They don't own data
                                            </li>
                                            <li><strong>Slices prevent data races:</strong> Follow borrowing rules</li>
                                        </ul>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Slices Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Complete the slice functions.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Return string slices instead of indices</li>
                                            <li>Extract specific words from strings</li>
                                            <li>Work with array slices</li>
                                            <li>Use proper slice syntax</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-slices-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-slices" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">fn main() {
    let s = String::from("hello world");
    let word = first_word(&s);
    println!("First word: {}", word);
    
    let text = "Rust programming language";
    let second = second_word(text);
    println!("Second word: {}", second);
    
    let data = "abcdefghij";
    let middle = get_middle(data);
    println!("Middle: {}", middle);
    
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    let evens = get_even_indices(&numbers);
    println!("Even indices: {:?}", evens);
    
    let sentence = "The quick brown fox";
    let last = last_word(sentence);
    println!("Last word: {}", last);
}

fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    &s[..]
}

fn second_word(s: &str) -> &str {
    let words: Vec<&str> = s.split_whitespace().collect();
    if words.len() >= 2 {
        words[1]
    } else {
        ""
    }
}

fn get_middle(s: &str) -> &str {
    let len = s.len();
    if len > 4 {
        &s[2..len-2]
    } else {
        s
    }
}

fn get_even_indices(arr: &[i32]) -> Vec<i32> {
    arr.iter()
        .enumerate()
        .filter(|(i, _)| i % 2 == 0)
        .map(|(_, &val)| val)
        .collect()
}

fn last_word(s: &str) -> &str {
    s.split_whitespace().last().unwrap_or("")
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Slices</strong> are references to a contiguous sequence of
                                                elements
                                            </li>
                                            <li><strong>String slices (&str):</strong> Reference to part of a String
                                            </li>
                                            <li><strong>Array slices (&[T]):</strong> Reference to part of an array</li>
                                            <li>Syntax: <code>&collection[start..end]</code> (end is exclusive)</li>
                                            <li>Shortcuts: <code>[..n]</code>, <code>[n..]</code>, <code>[..]</code>
                                            </li>
                                            <li>String literals are <code>&str</code> slices</li>
                                            <li>Slices <strong>don't own data</strong> - they're references</li>
                                            <li>Slices <strong>enforce safety</strong> at compile time</li>
                                            <li>Use <code>&str</code> for parameters - more flexible than
                                                <code>&String</code>
                                            </li>
                                            <li>Slices follow <strong>borrowing rules</strong></li>
                                            <li>Slices are <strong>zero-cost</strong> - just a pointer and length</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p><strong>Congratulations!</strong> You've completed the Ownership module - the
                                        heart
                                        of Rust! You now
                                        understand ownership, borrowing, and slices. These concepts make Rust unique and
                                        enable memory safety
                                        without a garbage collector.
                                    </p>
                                    <p>In the next module, we'll explore <strong>Structs</strong> - how to create custom
                                        data types to organize
                                        related data together. You'll learn how ownership works with structs and how to
                                        build more complex
                                        programs.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="borrowing.jsp" />
                                    <jsp:param name="prevTitle" value="References & Borrowing" />
                                    <jsp:param name="nextLink" value="structs.jsp" />
                                    <jsp:param name="nextTitle" value="Structs" />
                                    <jsp:param name="currentLessonId" value="slices" />
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