<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "closures" ); request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Closures Tutorial - Anonymous Functions | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust closures with examples. Master anonymous functions, environment capture, Fn traits, and functional programming. Free Rust tutorial.">
            <meta name="keywords"
                content="rust closures, rust closures tutorial, rust anonymous functions, rust fn trait, rust fnmut, rust fnonce, rust functional programming, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Closures in Rust - Anonymous Functions">
            <meta property="og:description" content="Master Rust closures and functional programming.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/closures.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

            <script>
                (function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();
            </script>

            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Rust Closures Tutorial - Anonymous Functions",
    "description": "Learn Rust closures with examples. Master anonymous functions, environment capture, Fn traits, and functional programming. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/closures.jsp",
    "keywords": "rust closures, rust closures tutorial, rust anonymous functions, rust fn trait, rust fnmut, rust fnonce, rust functional programming, learn rust",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust closures", "Anonymous functions", "Fn traits", "Functional programming", "Iterator methods"],
    "timeRequired": "PT35M",
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
            "name": "Closures"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="closures">
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
                                    <span>Closures</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Closures - Anonymous Functions</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Closures are anonymous functions that can capture variables from
                                        their surrounding environment. They're incredibly useful for functional
                                        programming patterns, working with iterators, and writing concise, expressive
                                        code. Rust's closures are zero-cost abstractions with powerful type inference.
                                    </p>

                                    <h2>What Are Closures?</h2>
                                    <p>A closure is an anonymous function you can save in a variable or pass as an
                                        argument to other functions. Unlike regular functions, closures can capture
                                        values from the scope in which they're defined.</p>

                                    <div class="info-box">
                                        <strong>Key Difference:</strong> Functions use <code>fn</code> keyword and can't
                                        capture environment. Closures use <code>||</code> syntax and can capture
                                        variables from their surrounding scope.
                                    </div>

                                    <h2>Closure Syntax</h2>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-closures.svg"
                                            alt="Rust Closures" class="tutorial-diagram" />
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/closures-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-closures-basics" />
                                    </jsp:include>

                                    <h3>Syntax Variations</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Syntax</th>
                                                <th>Example</th>
                                                <th>Use Case</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Simple</td>
                                                <td><code>|x| x + 1</code></td>
                                                <td>Single expression, type inference</td>
                                            </tr>
                                            <tr>
                                                <td>With types</td>
                                                <td><code>|x: i32| -> i32 { x + 1 }</code></td>
                                                <td>Explicit types</td>
                                            </tr>
                                            <tr>
                                                <td>Multiple params</td>
                                                <td><code>|x, y| x + y</code></td>
                                                <td>Multiple parameters</td>
                                            </tr>
                                            <tr>
                                                <td>Block body</td>
                                                <td><code>|x| { let y = x * 2; y + 1 }</code></td>
                                                <td>Multiple statements</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Capturing the Environment</h2>
                                    <p>Closures can capture variables from their surrounding scope in three ways:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/closures-capturing.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-closures-capturing" />
                                    </jsp:include>

                                    <h3>The Three Fn Traits</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Trait</th>
                                                <th>Capturing</th>
                                                <th>Can Call</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>Fn</code></td>
                                                <td>Borrows immutably</td>
                                                <td>Multiple times</td>
                                                <td><code>|| println!("{}", x)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>FnMut</code></td>
                                                <td>Borrows mutably</td>
                                                <td>Multiple times</td>
                                                <td><code>|| list.push(4)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>FnOnce</code></td>
                                                <td>Takes ownership</td>
                                                <td>Once</td>
                                                <td><code>|| drop(x)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Rust automatically chooses the most restrictive trait
                                        that works. If a closure only reads variables, it implements <code>Fn</code>. If
                                        it modifies them, <code>FnMut</code>. If it consumes them, <code>FnOnce</code>.
                                    </div>

                                    <h2>The move Keyword</h2>
                                    <p>Use <code>move</code> to force a closure to take ownership of captured variables:
                                    </p>

                                    <pre><code class="language-rust">let x = vec![1, 2, 3];
let closure = move || println!("{:?}", x);

closure();
// println!("{:?}", x);  // Error: x was moved</code></pre>

                                    <div class="info-box">
                                        <strong>When to use move:</strong> Essential for threads and async code where
                                        the closure needs to outlive the current scope.
                                    </div>

                                    <h2>Closures with Iterators</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/closures-iterators.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-closures-iterators" />
                                    </jsp:include>

                                    <h3>Common Iterator Methods</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Method</th>
                                                <th>Purpose</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>map</code></td>
                                                <td>Transform each element</td>
                                                <td><code>.map(|x| x * 2)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>filter</code></td>
                                                <td>Keep matching elements</td>
                                                <td><code>.filter(|x| *x > 5)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>fold</code></td>
                                                <td>Reduce to single value</td>
                                                <td><code>.fold(0, |acc, x| acc + x)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>find</code></td>
                                                <td>Find first match</td>
                                                <td><code>.find(|x| *x == 5)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>any</code></td>
                                                <td>Check if any match</td>
                                                <td><code>.any(|x| *x > 10)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>all</code></td>
                                                <td>Check if all match</td>
                                                <td><code>.all(|x| *x > 0)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Returning Closures</h2>
                                    <p>You can return closures using <code>impl Fn</code>:</p>

                                    <pre><code class="language-rust">fn make_adder(x: i32) -> impl Fn(i32) -> i32 {
    move |y| x + y
}

let add_5 = make_adder(5);
println!("{}", add_5(10));  // 15</code></pre>

                                    <h2>Type Inference</h2>
                                    <p>Closures have powerful type inference:</p>

                                    <pre><code class="language-rust">// Compiler infers types from usage
let add = |x, y| x + y;
let result = add(5, 10);  // Infers i32

// Once used, types are fixed
// let result2 = add(5.0, 10.0);  // Error: expected i32</code></pre>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use closures for short functions:</strong> Especially with
                                                iterators</li>
                                            <li><strong>Let type inference work:</strong> Only add types when needed
                                            </li>
                                            <li><strong>Use move for threads:</strong> Ensure closure owns its data</li>
                                            <li><strong>Chain iterator methods:</strong> Readable, efficient functional
                                                code</li>
                                            <li><strong>Prefer closures over loops:</strong> More expressive with
                                                iterators</li>
                                            <li><strong>Know your Fn traits:</strong> Understand capturing behavior</li>
                                        </ul>
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to dereference in closures</h4>
                                        <pre><code class="language-rust">// Wrong - comparing references
let numbers = vec![1, 2, 3];
let evens: Vec<&i32> = numbers.iter()
    .filter(|x| x % 2 == 0)  // Error: can't mod &i32
    .collect();

// Correct - dereference with *
let evens: Vec<&i32> = numbers.iter()
    .filter(|x| *x % 2 == 0)
    .collect();</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using closure after move</h4>
                                        <pre><code class="language-rust">// Wrong - using moved value
let x = vec![1, 2, 3];
let closure = move || println!("{:?}", x);
closure();
println!("{:?}", x);  // Error: x was moved

// Correct - clone if you need both
let x = vec![1, 2, 3];
let x_clone = x.clone();
let closure = move || println!("{:?}", x_clone);
closure();
println!("{:?}", x);  // OK!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Trying to return closure without impl Fn</h4>
                                        <pre><code class="language-rust">// Wrong - can't return closure type directly
fn make_adder(x: i32) -> ??? {  // What type?
    |y| x + y
}

// Correct - use impl Fn
fn make_adder(x: i32) -> impl Fn(i32) -> i32 {
    move |y| x + y
}</code></pre>
                                    </div>

                                    <h2>Exercise: Closures Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Practice closures with temperature conversion,
                                            filtering, and functional patterns.</p>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-closures-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-closures" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">let square = |x| x * x;

let base = 10;
let add_base = |x| x + base;

let fahrenheit: Vec<i32> = celsius.iter()
    .map(|c| c * 9 / 5 + 32)
    .collect();

let result: Vec<i32> = numbers.iter()
    .filter(|x| *x > 5)
    .map(|x| x * x)
    .collect();

let sum: i32 = nums.iter()
    .filter(|x| *x % 2 == 0)
    .sum();

fn make_multiplier(factor: i32) -> impl Fn(i32) -> i32 {
    move |x| x * factor
}

let max = values.iter()
    .fold(0, |acc, x| if x > &acc { *x } else { acc });</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Closures</strong> are anonymous functions that capture
                                                environment</li>
                                            <li>Syntax: <code>|params| expression</code> or
                                                <code>|params| { body }</code></li>
                                            <li><strong>Three Fn traits:</strong> Fn, FnMut, FnOnce</li>
                                            <li><strong>Fn</strong> borrows immutably, can call multiple times</li>
                                            <li><strong>FnMut</strong> borrows mutably, can call multiple times</li>
                                            <li><strong>FnOnce</strong> takes ownership, can call once</li>
                                            <li><strong>move keyword</strong> forces ownership transfer</li>
                                            <li>Work seamlessly with <strong>iterators</strong></li>
                                            <li><strong>Type inference</strong> makes closures concise</li>
                                            <li><strong>Zero-cost abstraction</strong> - no runtime overhead</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand closures, you're ready to explore
                                        <strong>Iterators</strong> in depth - how to create custom iterators, use
                                        iterator adapters, and write efficient, functional code. Closures and iterators
                                        work together to enable powerful functional programming patterns in Rust.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="iterators.jsp" />
                                    <jsp:param name="prevTitle" value="Iterators" />
                                    <jsp:param name="nextLink" value="smart-pointers.jsp" />
                                    <jsp:param name="nextTitle" value="Smart Pointers" />
                                    <jsp:param name="currentLessonId" value="closures" />
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