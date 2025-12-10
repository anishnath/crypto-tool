<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "smart-pointers" ); request.setAttribute("currentModule", "Advanced Topics"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Smart Pointers Tutorial - Box, Rc, RefCell | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust smart pointers with examples. Master Box&lt;T&gt;, Rc&lt;T&gt;, RefCell&lt;T&gt;, Deref and Drop traits. Free Rust tutorial for advanced topics.">
            <meta name="keywords"
                content="rust smart pointers, rust smart pointers tutorial, rust box, rust rc, rust refcell, rust deref, rust drop, rust heap allocation, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Smart Pointers in Rust - Box, Rc, RefCell">
            <meta property="og:description" content="Master Rust smart pointers for advanced memory management.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/smart-pointers.jsp">
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
    "name": "Rust Smart Pointers Tutorial - Box, Rc, RefCell",
    "description": "Learn Rust smart pointers with examples. Master Box&lt;T&gt;, Rc&lt;T&gt;, RefCell&lt;T&gt;, Deref and Drop traits. Free Rust tutorial for advanced topics.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/smart-pointers.jsp",
    "keywords": "rust smart pointers, rust smart pointers tutorial, rust box, rust rc, rust refcell, rust deref, rust drop, rust heap allocation, learn rust",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust smart pointers", "Box<T>", "Rc<T>", "RefCell<T>", "Deref trait", "Drop trait"],
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
            "name": "Smart Pointers"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="smart-pointers">
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
                                    <span>Smart Pointers</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Smart Pointers</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Smart pointers are data structures that act like pointers but have
                                        additional metadata and capabilities. Unlike regular references, smart pointers
                                        own the data they point to. Rust's smart pointers enable advanced patterns like
                                        heap allocation, reference counting, and interior mutability.</p>

                                    <h2>What Are Smart Pointers?</h2>
                                    <p>A pointer is a variable that contains an address in memory. In Rust, the most
                                        common pointer is a reference (<code>&</code>). Smart pointers are data
                                        structures that not only act like pointers but also have additional metadata and
                                        capabilities.</p>

                                    <div class="info-box">
                                        <strong>Key Difference:</strong> References borrow data, while smart pointers
                                        own the data they point to. Smart pointers are usually implemented using structs
                                        and implement the <code>Deref</code> and <code>Drop</code> traits.
                                    </div>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-smart-pointers.svg"
                                            alt="Rust Smart Pointers" class="tutorial-diagram" />
                                    </div>

                                    <h3>Common Smart Pointer Types</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Purpose</th>
                                                <th>Use Case</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>Box&lt;T&gt;</code></td>
                                                <td>Heap allocation</td>
                                                <td>Recursive types, large data, dynamic dispatch</td>
                                            </tr>
                                            <tr>
                                                <td><code>Rc&lt;T&gt;</code></td>
                                                <td>Reference counting</td>
                                                <td>Multiple ownership (single-threaded)</td>
                                            </tr>
                                            <tr>
                                                <td><code>RefCell&lt;T&gt;</code></td>
                                                <td>Interior mutability</td>
                                                <td>Mutate data with immutable references</td>
                                            </tr>
                                            <tr>
                                                <td><code>Arc&lt;T&gt;</code></td>
                                                <td>Atomic reference counting</td>
                                                <td>Multiple ownership (multi-threaded)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Box&lt;T&gt; - Heap Allocation</h2>
                                    <p><code>Box&lt;T&gt;</code> is the most straightforward smart pointer. It allows
                                        you to store data on the heap rather than the stack.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/box-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-box-basics" />
                                    </jsp:include>

                                    <h3>When to Use Box&lt;T&gt;</h3>
                                    <ul>
                                        <li><strong>Recursive types:</strong> Types whose size can't be known at compile
                                            time</li>
                                        <li><strong>Large data:</strong> Transfer ownership without copying large
                                            amounts of data</li>
                                        <li><strong>Trait objects:</strong> When you want a value with a type
                                            implementing a specific trait</li>
                                    </ul>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Box has minimal overhead - just the cost of heap
                                        allocation. Use it when you need heap storage with single ownership semantics.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Rc&lt;T&gt; - Reference Counting</h2>
                                    <p><code>Rc&lt;T&gt;</code> enables multiple ownership by keeping track of the
                                        number of references to a value. The value is dropped when the last reference
                                        goes out of scope.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/rc-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-rc-basics" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> <code>Rc&lt;T&gt;</code> is only for single-threaded
                                        scenarios. Use <code>Arc&lt;T&gt;</code> (Atomic Rc) for multi-threaded
                                        programs.
                                    </div>

                                    <h3>Rc Methods</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Method</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>Rc::new(value)</code></td>
                                                <td>Create new Rc pointer</td>
                                            </tr>
                                            <tr>
                                                <td><code>Rc::clone(&rc)</code></td>
                                                <td>Create new reference (shallow copy)</td>
                                            </tr>
                                            <tr>
                                                <td><code>Rc::strong_count(&rc)</code></td>
                                                <td>Get number of strong references</td>
                                            </tr>
                                            <tr>
                                                <td><code>Rc::weak_count(&rc)</code></td>
                                                <td>Get number of weak references</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>RefCell&lt;T&gt; - Interior Mutability</h2>
                                    <p><code>RefCell&lt;T&gt;</code> provides interior mutability - a design pattern
                                        that allows you to mutate data even when there are immutable references to that
                                        data.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/refcell-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-refcell-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Borrowing Rules at Runtime:</strong> With <code>RefCell&lt;T&gt;</code>,
                                        borrowing rules are enforced at runtime instead of compile time. If you violate
                                        the rules, your program will panic.
                                    </div>

                                    <h3>RefCell Methods</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Method</th>
                                                <th>Returns</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>borrow()</code></td>
                                                <td><code>Ref&lt;T&gt;</code></td>
                                                <td>Immutable borrow (panics if mutably borrowed)</td>
                                            </tr>
                                            <tr>
                                                <td><code>borrow_mut()</code></td>
                                                <td><code>RefMut&lt;T&gt;</code></td>
                                                <td>Mutable borrow (panics if already borrowed)</td>
                                            </tr>
                                            <tr>
                                                <td><code>try_borrow()</code></td>
                                                <td><code>Result&lt;Ref&lt;T&gt;&gt;</code></td>
                                                <td>Safe immutable borrow</td>
                                            </tr>
                                            <tr>
                                                <td><code>try_borrow_mut()</code></td>
                                                <td><code>Result&lt;RefMut&lt;T&gt;&gt;</code></td>
                                                <td>Safe mutable borrow</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Combining Rc&lt;T&gt; and RefCell&lt;T&gt;</h2>
                                    <p>A common Rust pattern is combining <code>Rc&lt;T&gt;</code> and
                                        <code>RefCell&lt;T&gt;</code> to have multiple owners with the ability to mutate
                                        data.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/rc-refcell.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-rc-refcell" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pattern:</strong> <code>Rc&lt;RefCell&lt;T&gt;&gt;</code> is useful for
                                        graph-like data structures where nodes need multiple owners and mutability.
                                    </div>

                                    <h2>The Deref Trait</h2>
                                    <p>The <code>Deref</code> trait allows you to customize the behavior of the
                                        dereference operator <code>*</code>. Smart pointers implement <code>Deref</code>
                                        so they can be treated like regular references.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/deref-trait.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-deref-trait" />
                                    </jsp:include>

                                    <h3>Deref Coercion</h3>
                                    <p>Deref coercion automatically converts a reference to a type implementing
                                        <code>Deref</code> into a reference to another type. This happens automatically
                                        when you pass a reference as an argument to a function.</p>

                                    <div class="info-box">
                                        <strong>Example:</strong> <code>&String</code> can be coerced to
                                        <code>&str</code> because <code>String</code> implements
                                        <code>Deref&lt;Target=str&gt;</code>.
                                    </div>

                                    <h2>The Drop Trait</h2>
                                    <p>The <code>Drop</code> trait lets you customize what happens when a value goes out
                                        of scope. Smart pointers use <code>Drop</code> to clean up resources.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/drop-trait.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-drop-trait" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> You can't call <code>drop()</code> method directly.
                                        Use <code>std::mem::drop()</code> to drop a value early.
                                    </div>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Prefer ownership:</strong> Use smart pointers only when you need
                                                their specific capabilities</li>
                                            <li><strong>Use Box for simple heap allocation:</strong> When you just need
                                                data on the heap</li>
                                            <li><strong>Use Rc for shared ownership:</strong> When multiple parts of
                                                code need to read the same data</li>
                                            <li><strong>Use RefCell sparingly:</strong> Runtime borrowing checks have
                                                overhead and can panic</li>
                                            <li><strong>Avoid cycles:</strong> <code>Rc</code> creates cycles that leak
                                                memory. Use <code>Weak</code> references</li>
                                            <li><strong>Document interior mutability:</strong> Make it clear when using
                                                <code>RefCell</code> in your APIs</li>
                                        </ul>
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Creating reference cycles with Rc</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">// This creates a memory leak!
use std::rc::Rc;
use std::cell::RefCell;

struct Node {
    next: Option&lt;Rc&lt;RefCell&lt;Node&gt;&gt;&gt;,
}

let a = Rc::new(RefCell::new(Node { next: None }));
let b = Rc::new(RefCell::new(Node { next: Some(Rc::clone(&a)) }));
a.borrow_mut().next = Some(Rc::clone(&b));  // Cycle!</code></pre>
                                        <p><strong>Fix - Use Weak references:</strong></p>
                                        <pre><code class="language-rust">use std::rc::{Rc, Weak};
use std::cell::RefCell;

struct Node {
    next: Option&lt;Rc&lt;RefCell&lt;Node&gt;&gt;&gt;,
    prev: Option&lt;Weak&lt;RefCell&lt;Node&gt;&gt;&gt;,  // Use Weak
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Multiple mutable borrows with RefCell</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">let value = RefCell::new(5);
let borrow1 = value.borrow_mut();
let borrow2 = value.borrow_mut();  // Panic at runtime!</code></pre>
                                        <p><strong>Fix - Drop borrows when done:</strong></p>
                                        <pre><code class="language-rust">let value = RefCell::new(5);
{
    let mut borrow1 = value.borrow_mut();
    *borrow1 = 10;
}  // borrow1 dropped here
let mut borrow2 = value.borrow_mut();  // OK!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Using Rc in multi-threaded code</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-rust">use std::rc::Rc;
use std::thread;

let data = Rc::new(5);
thread::spawn(move || {  // Error: Rc is not Send
    println!("{}", data);
});</code></pre>
                                        <p><strong>Fix - Use Arc instead:</strong></p>
                                        <pre><code class="language-rust">use std::sync::Arc;
use std::thread;

let data = Arc::new(5);
let data_clone = Arc::clone(&data);
thread::spawn(move || {
    println!("{}", data_clone);
});</code></pre>
                                    </div>

                                    <h2>Exercise: Smart Pointers Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement a simple graph structure using Rc and
                                            RefCell to handle shared ownership and mutability.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create nodes that can have multiple neighbors</li>
                                            <li>Use <code>Rc&lt;RefCell&lt;Node&gt;&gt;</code> for shared mutable
                                                ownership</li>
                                            <li>Implement the ability to add neighbors to nodes</li>
                                            <li>Create a graph with cycles (node A points to B, B to C, C back to A)
                                            </li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile"
                                                value="rust/exercises/ex-smart-pointers-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-smart-pointers" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">use std::rc::Rc;
use std::cell::RefCell;

#[derive(Debug)]
struct Node {
    value: i32,
    neighbors: RefCell&lt;Vec&lt;Rc&lt;RefCell&lt;Node&gt;&gt;&gt;&gt;,
}

impl Node {
    fn new(value: i32) -> Rc&lt;RefCell&lt;Node&gt;&gt; {
        Rc::new(RefCell::new(Node {
            value,
            neighbors: RefCell::new(vec![]),
        }))
    }

    fn add_neighbor(&mut self, neighbor: Rc&lt;RefCell&lt;Node&gt;&gt;) {
        self.neighbors.borrow_mut().push(neighbor);
    }
}

fn main() {
    let node1 = Node::new(1);
    let node2 = Node::new(2);
    let node3 = Node::new(3);

    // Connect the nodes in a cycle
    node1.borrow_mut().add_neighbor(Rc::clone(&node2));
    node2.borrow_mut().add_neighbor(Rc::clone(&node3));
    node3.borrow_mut().add_neighbor(Rc::clone(&node1));

    println!("Graph created with cycles!");
    println!("Node 1 has {} neighbors", node1.borrow().neighbors.borrow().len());
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Smart pointers</strong> own the data they point to, unlike
                                                references</li>
                                            <li><strong>Box&lt;T&gt;</strong> stores data on the heap with single
                                                ownership</li>
                                            <li><strong>Rc&lt;T&gt;</strong> enables multiple ownership via reference
                                                counting</li>
                                            <li><strong>RefCell&lt;T&gt;</strong> allows interior mutability with
                                                runtime borrow checks</li>
                                            <li><strong>Rc&lt;RefCell&lt;T&gt;&gt;</strong> combines shared ownership
                                                with mutability</li>
                                            <li><strong>Deref trait</strong> allows smart pointers to act like
                                                references</li>
                                            <li><strong>Drop trait</strong> customizes cleanup when values go out of
                                                scope</li>
                                            <li><strong>Arc&lt;T&gt;</strong> is the thread-safe version of Rc</li>
                                            <li><strong>Weak&lt;T&gt;</strong> prevents reference cycles</li>
                                            <li>Smart pointers enable advanced patterns while maintaining memory safety
                                            </li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand smart pointers, you're ready to learn about
                                        <strong>Packages, Crates, and Modules</strong> - Rust's module system for
                                        organizing code into reusable components and managing project structure.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="closures.jsp" />
                                    <jsp:param name="prevTitle" value="Closures" />
                                    <jsp:param name="nextLink" value="../index.jsp" />
                                    <jsp:param name="nextTitle" value="Tutorials Home" />
                                    <jsp:param name="currentLessonId" value="smart-pointers" />
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