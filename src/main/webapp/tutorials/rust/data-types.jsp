<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "data-types" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Data Types Tutorial - Scalar & Compound | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust data types with examples. Master integers, floats, booleans, characters, tuples, and arrays. Free Rust tutorial for beginners.">
            <meta name="keywords"
                content="rust data types, rust data types tutorial, rust integers, rust floats, rust boolean, rust char, rust tuple, rust array, rust types, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Data Types in Rust - Scalar & Compound Types">
            <meta property="og:description" content="Master Rust's type system with scalar and compound types.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/data-types.jsp">
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
    "name": "Rust Data Types Tutorial - Scalar & Compound",
    "description": "Learn Rust data types with examples. Master integers, floats, booleans, characters, tuples, and arrays. Free Rust tutorial for beginners.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/data-types.jsp",
    "keywords": "rust data types, rust data types tutorial, rust integers, rust floats, rust boolean, rust char, rust tuple, rust array, rust types, learn rust",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust data types", "Scalar types", "Compound types", "Integers", "Floats", "Tuples", "Arrays"],
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
            "name": "Data Types"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="data-types">
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
                                    <span>Data Types</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Data Types</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Rust is a statically typed language, which means it must know the
                                        types of all variables at compile time.
                                        The compiler can usually infer the type based on the value and how it's used. In
                                        this lesson, you'll learn about
                                        Rust's scalar types (single values) and compound types (multiple values).</p>

                                    <!-- Section 1: Scalar Types -->
                                    <h2>Scalar Types</h2>
                                    <p>A scalar type represents a single value. Rust has four primary scalar types:</p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-type-hierarchy.svg"
                                            alt="Rust Data Types Hierarchy" class="tutorial-diagram" />
                                    </div>

                                    <h3>1. Integer Types</h3>
                                    <p>Integers are numbers without fractional components. Rust provides both signed and
                                        unsigned integers in various sizes:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Length</th>
                                                <th>Signed</th>
                                                <th>Unsigned</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>8-bit</td>
                                                <td><code>i8</code></td>
                                                <td><code>u8</code></td>
                                            </tr>
                                            <tr>
                                                <td>16-bit</td>
                                                <td><code>i16</code></td>
                                                <td><code>u16</code></td>
                                            </tr>
                                            <tr>
                                                <td>32-bit</td>
                                                <td><code>i32</code> (default)</td>
                                                <td><code>u32</code></td>
                                            </tr>
                                            <tr>
                                                <td>64-bit</td>
                                                <td><code>i64</code></td>
                                                <td><code>u64</code></td>
                                            </tr>
                                            <tr>
                                                <td>128-bit</td>
                                                <td><code>i128</code></td>
                                                <td><code>u128</code></td>
                                            </tr>
                                            <tr>
                                                <td>arch</td>
                                                <td><code>isize</code></td>
                                                <td><code>usize</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>Integer Literals:</strong>
                                        <ul>
                                            <li>Decimal: <code>98_222</code></li>
                                            <li>Hex: <code>0xff</code></li>
                                            <li>Octal: <code>0o77</code></li>
                                            <li>Binary: <code>0b1111_0000</code></li>
                                            <li>Byte (u8 only): <code>b'A'</code></li>
                                        </ul>
                                    </div>

                                    <h3>2. Floating-Point Types</h3>
                                    <p>Rust has two floating-point types: <code>f32</code> (32-bit) and <code>f64</code>
                                        (64-bit, default):</p>

                                    <pre><code class="language-rust">let x = 2.0;      // f64 (default)
let y: f32 = 3.0; // f32</code></pre>

                                    <h3>3. Boolean Type</h3>
                                    <p>Booleans are one byte in size and have two possible values: <code>true</code> or
                                        <code>false</code>:
                                    </p>

                                    <pre><code class="language-rust">let t = true;
let f: bool = false;</code></pre>

                                    <h3>4. Character Type</h3>
                                    <p>Rust's <code>char</code> type is four bytes in size and represents a Unicode
                                        Scalar Value:</p>

                                    <pre><code class="language-rust">let c = 'z';
let z = 'ℤ';
let heart = '❤';</code></pre>

                                    <div class="tip-box">
                                        <strong>Note:</strong> Use single quotes for <code>char</code> literals and
                                        double quotes for string literals.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/data-types-scalar.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-scalar" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: Compound Types -->
                                    <h2>Compound Types</h2>
                                    <p>Compound types can group multiple values into one type. Rust has two primitive
                                        compound types:</p>

                                    <h3>1. Tuples</h3>
                                    <p>A tuple groups together values of different types. Tuples have a fixed
                                        length—once declared, they cannot grow or shrink:</p>

                                    <pre><code class="language-rust">let tup: (i32, f64, u8) = (500, 6.4, 1);</code></pre>

                                    <p>You can access tuple elements using pattern matching (destructuring) or dot
                                        notation:</p>

                                    <pre><code class="language-rust">// Destructuring
let (x, y, z) = tup;

// Dot notation
let five_hundred = tup.0;
let six_point_four = tup.1;</code></pre>

                                    <div class="info-box">
                                        <strong>Unit Type:</strong> A tuple without any values, <code>()</code>, is
                                        called the <em>unit type</em>.
                                        It represents an empty value or empty return type.
                                    </div>

                                    <h3>2. Arrays</h3>
                                    <p>Unlike tuples, every element of an array must have the same type. Arrays in Rust
                                        have a fixed length:</p>

                                    <pre><code class="language-rust">let arr = [1, 2, 3, 4, 5];
let first = arr[0];
let second = arr[1];</code></pre>

                                    <p>You can specify the array's type and length:</p>

                                    <pre><code class="language-rust">let arr: [i32; 5] = [1, 2, 3, 4, 5];</code></pre>

                                    <p>Initialize an array with the same value for each element:</p>

                                    <pre><code class="language-rust">let arr = [3; 5];  // Same as [3, 3, 3, 3, 3]</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/data-types-compound.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-compound" />
                                    </jsp:include>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-data-types-memory.svg"
                                            alt="Rust Data Types Memory Layout" class="tutorial-diagram" />
                                    </div>

                                    <div class="warning-box">
                                        <strong>Array Bounds:</strong> Accessing an array element beyond its bounds will
                                        cause a runtime panic.
                                        Rust checks array bounds at runtime to prevent memory safety issues.
                                    </div>

                                    <!-- Section 3: Type Inference -->
                                    <h2>Type Inference</h2>
                                    <p>Rust can often infer the type based on the value and usage:</p>

                                    <pre><code class="language-rust">let x = 5;        // Inferred as i32
let y = 2.0;      // Inferred as f64
let z = true;     // Inferred as bool
let c = 'A';      // Inferred as char</code></pre>

                                    <p>Sometimes you need to provide type annotations when multiple types are possible:
                                    </p>

                                    <pre><code class="language-rust">let guess: u32 = "42".parse().expect("Not a number!");</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Integer overflow in debug mode</h4>
                                        <p><strong>Problem:</strong> Assigning a value outside the type's range</p>
                                        <pre><code class="language-rust">let x: u8 = 256;  // Error: literal out of range for u8</code></pre>
                                        <p><strong>Solution:</strong> Use appropriate type or handle overflow explicitly
                                        </p>
                                        <pre><code class="language-rust">let x: u16 = 256;  // OK: u16 can hold 0-65535</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Mixing char and string literals</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let c: char = "A";  // Error: expected char, found &str</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-rust">let c: char = 'A';  // Use single quotes for char</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Accessing array out of bounds</h4>
                                        <p><strong>Problem:</strong> Runtime panic when accessing invalid index</p>
                                        <pre><code class="language-rust">let arr = [1, 2, 3];
let x = arr[5];  // Panic: index out of bounds</code></pre>
                                        <p><strong>Solution:</strong> Use <code>get()</code> method for safe access</p>
                                        <pre><code class="language-rust">let x = arr.get(5);  // Returns None instead of panicking</code></pre>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Scalar types</strong> represent single values: integers, floats,
                                                booleans, characters</li>
                                            <li><strong>Integer types:</strong> Signed (i8-i128) and unsigned (u8-u128),
                                                default is <code>i32</code></li>
                                            <li><strong>Floating-point types:</strong> <code>f32</code> and
                                                <code>f64</code> (default)
                                            </li>
                                            <li><strong>Boolean:</strong> <code>bool</code> with values
                                                <code>true</code> or <code>false</code>
                                            </li>
                                            <li><strong>Character:</strong> <code>char</code> is 4 bytes, represents
                                                Unicode</li>
                                            <li><strong>Tuples:</strong> Fixed-size, mixed types, access via
                                                destructuring or dot notation</li>
                                            <li><strong>Arrays:</strong> Fixed-size, same type, access via indexing</li>
                                            <li>Rust uses <strong>type inference</strong> but allows explicit type
                                                annotations</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand Rust's type system, you're ready to learn about
                                        <strong>functions</strong>.
                                        In the next lesson, you'll learn how to define functions, pass parameters,
                                        return values, and understand
                                        the difference between statements and expressions in Rust.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="variables.jsp" />
                                    <jsp:param name="prevTitle" value="Variables & Mutability" />
                                    <jsp:param name="nextLink" value="strings.jsp" />
                                    <jsp:param name="nextTitle" value="Strings" />
                                    <jsp:param name="currentLessonId" value="data-types" />
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