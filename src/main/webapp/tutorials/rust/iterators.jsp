<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "iterators" ); request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Iterators Tutorial - Iterator Trait Guide | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust iterators with examples. Master Iterator trait, iter() methods, map/filter adapters, lazy evaluation, and custom iterators. Free tutorial.">
            <meta name="keywords"
                content="rust iterators, rust iterators tutorial, rust iterator trait, rust map filter, rust iterator adapters, rust lazy evaluation, rust custom iterators, rust iterator examples, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Iterators in Rust - Iterator Trait & Methods">
            <meta property="og:description" content="Master Rust iterators for efficient collection processing.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/iterators.jsp">
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
    "name": "Rust Iterators Tutorial - Iterator Trait Guide",
    "description": "Learn Rust iterators with examples. Master Iterator trait, iter() methods, map/filter adapters, lazy evaluation, and custom iterators. Free tutorial.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/rust/iterators.jsp",
    "keywords": "rust iterators, rust iterators tutorial, rust iterator trait, rust map filter, rust iterator adapters, rust lazy evaluation, rust custom iterators, rust iterator examples, learn rust",
    "teaches": ["Rust iterators", "Iterator trait", "Iterator adapters", "Lazy evaluation", "Custom iterators", "Iterator methods", "Functional programming"],
    "timeRequired": "PT40M",
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
            "name": "Iterators"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="iterators">
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
                                    <span>Iterators</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Iterators</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">An <em>iterator</em> is a way of processing a series of items. In
                                        Rust, iterators are lazy, meaning they don't do any work until you call methods
                                        that consume the iterator. Iterators are one of Rust's most powerful features,
                                        allowing you to write efficient, functional-style code that's both readable and
                                        performant.
                                    </p>

                                    <h2>What is an Iterator?</h2>
                                    <p>An iterator is a value that produces a sequence of values. The <code>Iterator</code>
                                        trait is defined in the standard library and has one required method:
                                        <code>next()</code>:</p>

                                    <pre><code class="language-rust">trait Iterator {
    type Item;
    
    fn next(&mut self) -> Option&lt;Self::Item&gt;;
}</code></pre>

                                    <div class="info-box">
                                        <strong>Iterator Trait:</strong> The <code>Iterator</code> trait is in the prelude,
                                        so you don't need to import it. It provides many useful methods for working with
                                        sequences of values.
                                    </div>

                                    <h2>Creating Iterators</h2>
                                    <p>Most collections in Rust can produce iterators. There are three main methods:</p>

                                    <h3>1. iter() - Borrows Elements</h3>
                                    <pre><code class="language-rust">let v = vec![1, 2, 3];
for item in v.iter() {
    println!("{}", item);
}
// v is still valid after iteration</code></pre>

                                    <h3>2. into_iter() - Takes Ownership</h3>
                                    <pre><code class="language-rust">let v = vec![1, 2, 3];
for item in v.into_iter() {
    println!("{}", item);
}
// v is no longer valid - it was moved</code></pre>

                                    <h3>3. iter_mut() - Mutable References</h3>
                                    <pre><code class="language-rust">let mut v = vec![1, 2, 3];
for item in v.iter_mut() {
    *item += 10;
}
// v is modified: [11, 12, 13]</code></pre>

                                    <div class="tip-box">
                                        <strong>Choosing the Right Method:</strong> Use <code>iter()</code> when you only
                                        need to read values, <code>into_iter()</code> when you need to consume the
                                        collection, and <code>iter_mut()</code> when you need to modify values.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/iterators-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-iterators-basics" />
                                    </jsp:include>

                                    <h2>Using next() Directly</h2>
                                    <p>You can call <code>next()</code> directly to get values one at a time:</p>

                                    <pre><code class="language-rust">let v = vec![1, 2, 3];
let mut iter = v.iter();

println!("{:?}", iter.next());  // Some(&1)
println!("{:?}", iter.next());  // Some(&2)
println!("{:?}", iter.next());  // Some(&3)
println!("{:?}", iter.next());  // None</code></pre>

                                    <div class="info-box">
                                        <strong>Returns Option:</strong> The <code>next()</code> method returns
                                        <code>Option&lt;Item&gt;</code>. When there are more items, it returns
                                        <code>Some(item)</code>. When the iterator is exhausted, it returns
                                        <code>None</code>.
                                    </div>

                                    <h2>Lazy Evaluation</h2>
                                    <p>Iterators are <em>lazy</em> - they don't do any work until you consume them:</p>

                                    <pre><code class="language-rust">let v = vec![1, 2, 3, 4, 5];
let iter = v.iter().map(|x| {
    println!("Processing {}", x);
    x * 2
});
// Nothing printed yet - iterator is lazy!

let doubled: Vec&lt;i32&gt; = iter.collect();  // Now it executes
// Processing 1, Processing 2, ...</code></pre>

                                    <div class="warning-box">
                                        <strong>Lazy Evaluation:</strong> Because iterators are lazy, you must consume
                                        them (e.g., with <code>collect()</code>, <code>sum()</code>, or a for loop) for
                                        them to actually do work.
                                    </div>

                                    <h2>Iterator Consumers</h2>
                                    <p>Methods that consume the iterator and produce a final value:</p>

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
                                                <td><code>collect()</code></td>
                                                <td>Collect into collection</td>
                                                <td><code>iter.collect::&lt;Vec&lt;_&gt;&gt;()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>sum()</code></td>
                                                <td>Sum all elements</td>
                                                <td><code>iter.sum()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>product()</code></td>
                                                <td>Multiply all elements</td>
                                                <td><code>iter.product()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>max()</code></td>
                                                <td>Find maximum</td>
                                                <td><code>iter.max()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>min()</code></td>
                                                <td>Find minimum</td>
                                                <td><code>iter.min()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>count()</code></td>
                                                <td>Count elements</td>
                                                <td><code>iter.count()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>any()</code></td>
                                                <td>Check if any element matches</td>
                                                <td><code>iter.any(|x| x > 5)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>all()</code></td>
                                                <td>Check if all elements match</td>
                                                <td><code>iter.all(|x| x > 0)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Iterator Adapters</h2>
                                    <p>Iterator adapters transform one iterator into another. They're lazy and return
                                        new iterators:</p>

                                    <h3>map() - Transform Each Element</h3>
                                    <pre><code class="language-rust">let numbers = vec![1, 2, 3];
let doubled: Vec&lt;i32&gt; = numbers.iter()
    .map(|x| x * 2)
    .collect();
// [2, 4, 6]</code></pre>

                                    <h3>filter() - Keep Matching Elements</h3>
                                    <pre><code class="language-rust">let numbers = vec![1, 2, 3, 4, 5];
let evens: Vec&lt;&i32&gt; = numbers.iter()
    .filter(|x| *x % 2 == 0)
    .collect();
// [2, 4]</code></pre>

                                    <h3>take() - Take First N Elements</h3>
                                    <pre><code class="language-rust">let numbers = vec![1, 2, 3, 4, 5];
let first_three: Vec&lt;&i32&gt; = numbers.iter()
    .take(3)
    .collect();
// [1, 2, 3]</code></pre>

                                    <h3>skip() - Skip First N Elements</h3>
                                    <pre><code class="language-rust">let numbers = vec![1, 2, 3, 4, 5];
let skipped: Vec&lt;&i32&gt; = numbers.iter()
    .skip(2)
    .collect();
// [3, 4, 5]</code></pre>

                                    <h3>enumerate() - Add Index</h3>
                                    <pre><code class="language-rust">let items = vec!["a", "b", "c"];
for (i, item) in items.iter().enumerate() {
    println!("{}: {}", i, item);
}
// 0: a, 1: b, 2: c</code></pre>

                                    <h3>zip() - Combine Two Iterators</h3>
                                    <pre><code class="language-rust">let names = vec!["Alice", "Bob"];
let ages = vec![30, 25];
let people: Vec&lt;_&gt; = names.iter()
    .zip(ages.iter())
    .collect();
// [("Alice", 30), ("Bob", 25)]</code></pre>

                                    <h3>chain() - Concatenate Iterators</h3>
                                    <pre><code class="language-rust">let v1 = vec![1, 2, 3];
let v2 = vec![4, 5, 6];
let chained: Vec&lt;&i32&gt; = v1.iter()
    .chain(v2.iter())
    .collect();
// [1, 2, 3, 4, 5, 6]</code></pre>

                                    <h3>flat_map() - Map and Flatten</h3>
                                    <pre><code class="language-rust">let words = vec!["hello", "world"];
let chars: Vec&lt;char&gt; = words.iter()
    .flat_map(|s| s.chars())
    .collect();
// ['h', 'e', 'l', 'l', 'o', 'w', 'o', 'r', 'l', 'd']</code></pre>

                                    <h3>rev() - Reverse Iterator</h3>
                                    <pre><code class="language-rust">let numbers = vec![1, 2, 3];
let reversed: Vec&lt;&i32&gt; = numbers.iter()
    .rev()
    .collect();
// [3, 2, 1]</code></pre>

                                    <h3>Chaining Multiple Adapters</h3>
                                    <pre><code class="language-rust">let numbers = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
let result: Vec&lt;i32&gt; = numbers.iter()
    .filter(|x| *x % 2 == 0)  // Keep evens
    .map(|x| x * x)            // Square them
    .take(3)                   // Take first 3
    .copied()                   // Copy values
    .collect();
// [4, 16, 36]</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/iterators-adapters.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-iterators-adapters" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Efficient Chaining:</strong> Iterator adapters can be chained efficiently
                                        because they're lazy. The compiler can optimize the entire chain into a single
                                        loop.
                                    </div>

                                    <h2>Creating Custom Iterators</h2>
                                    <p>You can create your own iterators by implementing the <code>Iterator</code> trait:</p>

                                    <pre><code class="language-rust">struct Counter {
    count: u32,
    max: u32,
}

impl Counter {
    fn new(max: u32) -> Counter {
        Counter { count: 0, max }
    }
}

impl Iterator for Counter {
    type Item = u32;
    
    fn next(&mut self) -> Option&lt;Self::Item&gt; {
        if self.count &lt; self.max {
            self.count += 1;
            Some(self.count)
        } else {
            None
        }
    }
}

let counter = Counter::new(5);
for num in counter {
    println!("{}", num);  // 1, 2, 3, 4, 5
}</code></pre>

                                    <div class="info-box">
                                        <strong>type Item:</strong> The associated type <code>Item</code> defines what
                                        type of value the iterator yields. This is required when implementing
                                        <code>Iterator</code>.
                                    </div>

                                    <h3>Infinite Iterators</h3>
                                    <p>Iterators can be infinite - just never return <code>None</code>:</p>

                                    <pre><code class="language-rust">struct Fibonacci {
    curr: u32,
    next: u32,
}

impl Iterator for Fibonacci {
    type Item = u32;
    
    fn next(&mut self) -> Option&lt;Self::Item&gt; {
        let current = self.curr;
        self.curr = self.next;
        self.next = current + self.next;
        Some(current)
    }
}

let fib: Vec&lt;u32&gt; = Fibonacci::new()
    .take(10)  // Limit infinite iterator
    .collect();
// [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]</code></pre>

                                    <div class="warning-box">
                                        <strong>Infinite Iterators:</strong> Be careful with infinite iterators! Always
                                        use methods like <code>take()</code> to limit them, or you'll get an infinite
                                        loop.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/iterators-custom.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-iterators-custom" />
                                    </jsp:include>

                                    <h2>When to Use Iterators</h2>
                                    <div class="best-practice-box">
                                        <p><strong>Use iterators when:</strong></p>
                                        <ul>
                                            <li><strong>Processing collections:</strong> Transforming, filtering, or aggregating data</li>
                                            <li><strong>Functional style:</strong> When you prefer functional programming patterns</li>
                                            <li><strong>Performance:</strong> Iterators are often optimized by the compiler</li>
                                            <li><strong>Readability:</strong> Iterator chains can be more readable than loops</li>
                                            <li><strong>Lazy evaluation:</strong> When you want to defer computation</li>
                                        </ul>
                                        
                                        <p style="margin-top: 15px;"><strong>Consider loops when:</strong></p>
                                        <ul>
                                            <li><strong>Simple iteration:</strong> When you just need to iterate without transformation</li>
                                            <li><strong>Early exit needed:</strong> When you need break/continue</li>
                                            <li><strong>Side effects:</strong> When the primary purpose is side effects, not transformation</li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <strong>Performance:</strong> Iterators are often as fast as (or faster than)
                                        hand-written loops because the compiler can optimize them. Don't avoid iterators
                                        for performance reasons - benchmark first!
                                    </div>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Prefer iterators for transformations:</strong> map, filter, etc. are more idiomatic</li>
                                            <li><strong>Chain adapters efficiently:</strong> Multiple adapters are optimized together</li>
                                            <li><strong>Use collect() when needed:</strong> Remember iterators are lazy</li>
                                            <li><strong>Choose the right iterator method:</strong> iter(), into_iter(), or iter_mut()</li>
                                            <li><strong>Implement Iterator for custom types:</strong> When you need custom iteration logic</li>
                                            <li><strong>Use take() for infinite iterators:</strong> Always limit infinite iterators</li>
                                            <li><strong>Consider performance:</strong> Iterators are usually fast, but benchmark if needed</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting that iterators are lazy</h4>
                                        <pre><code class="language-rust">// Wrong - Nothing happens!
let doubled = vec![1, 2, 3].iter().map(|x| x * 2);
// doubled is an iterator, not a Vec

// Correct - Consume the iterator
let doubled: Vec&lt;i32&gt; = vec![1, 2, 3].iter()
    .map(|x| x * 2)
    .collect();</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using into_iter() when you need the collection later</h4>
                                        <pre><code class="language-rust">// Wrong - v is moved
let v = vec![1, 2, 3];
for item in v.into_iter() { }
println!("{:?}", v);  // Error: v was moved

// Correct - Use iter() to borrow
let v = vec![1, 2, 3];
for item in v.iter() { }
println!("{:?}", v);  // OK</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Creating infinite iterators without limits</h4>
                                        <pre><code class="language-rust">// Wrong - Infinite loop!
let infinite: Vec&lt;i32&gt; = (1..).collect();  // Never finishes

// Correct - Use take() to limit
let limited: Vec&lt;i32&gt; = (1..).take(10).collect();</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Not specifying type for collect()</h4>
                                        <pre><code class="language-rust">// Wrong - Compiler doesn't know what to collect into
let result = vec![1, 2, 3].iter().map(|x| x * 2).collect();  // Error!

// Correct - Specify type
let result: Vec&lt;i32&gt; = vec![1, 2, 3].iter()
    .map(|x| x * 2)
    .collect();</code></pre>
                                    </div>

                                    <h2>Exercise: Iterators Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Practice using iterators for common operations.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Use iterators to find sum of squares of even numbers</li>
                                            <li>Create a custom iterator for powers of 2</li>
                                            <li>Use zip to combine names and scores</li>
                                            <li>Flatten nested vectors using flat_map</li>
                                            <li>Create a prime number iterator</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-iterators-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-iterators" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">// Sum of squares of evens
let sum: i32 = numbers.iter()
    .filter(|x| *x % 2 == 0)
    .map(|x| x * x)
    .sum();

// Powers of 2 iterator
struct PowersOfTwo {
    current: u32,
    max_power: u32,
}

impl Iterator for PowersOfTwo {
    type Item = u32;
    
    fn next(&mut self) -> Option&lt;Self::Item&gt; {
        if self.current &lt;= self.max_power {
            let result = 2_u32.pow(self.current);
            self.current += 1;
            Some(result)
        } else {
            None
        }
    }
}

// Zip and filter
let high_scorers: Vec&lt;_&gt; = names.iter()
    .zip(scores.iter())
    .filter(|(_, &score)| score >= 90)
    .collect();

// Flatten nested vector
let flattened: Vec&lt;i32&gt; = nested.iter()
    .flat_map(|v| v.iter())
    .copied()
    .collect();</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Iterators</strong> process sequences of values</li>
                                            <li>Three main methods: <code>iter()</code>, <code>into_iter()</code>, <code>iter_mut()</code></li>
                                            <li>Iterators are <strong>lazy</strong> - they don't work until consumed</li>
                                            <li><strong>Iterator adapters</strong> transform iterators (map, filter, take, etc.)</li>
                                            <li><strong>Iterator consumers</strong> produce final values (collect, sum, etc.)</li>
                                            <li>Implement <code>Iterator</code> trait to create custom iterators</li>
                                            <li>Use <code>take()</code> to limit infinite iterators</li>
                                            <li>Iterators are often as fast as loops (compiler optimizes them)</li>
                                            <li>Chain adapters for complex transformations</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand iterators, you'll learn about <strong>closures</strong> - anonymous functions that can capture their environment. Closures are often used with iterators (like in <code>map()</code> and <code>filter()</code>) and are a powerful feature for writing concise, functional-style code.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="packages-crates.jsp" />
                                    <jsp:param name="prevTitle" value="Packages & Crates" />
                                    <jsp:param name="nextLink" value="closures.jsp" />
                                    <jsp:param name="nextTitle" value="Closures" />
                                    <jsp:param name="currentLessonId" value="iterators" />
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

