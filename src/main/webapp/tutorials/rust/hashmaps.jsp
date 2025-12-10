<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "hashmaps" ); request.setAttribute("currentModule", "Collections" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust HashMap Tutorial - Key-Value Pairs | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust HashMap with examples. Create, access, update HashMap&lt;K,V&gt; key-value pairs. Master entry API and HashMap methods. Free Rust tutorial.">
            <meta name="keywords"
                content="rust hashmap, rust hashmap tutorial, rust hash map, rust key value, rust collections, rust entry api, rust hashmap methods, rust dictionary, learn rust">

            <meta property="og:type" content="article">
            <meta property="og:title" content="HashMaps in Rust - Key-Value Storage">
            <meta property="og:description" content="Master Rust HashMaps for key-value pair storage.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/hashmaps.jsp">
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
    "name": "Rust HashMap Tutorial - Key-Value Pairs",
    "description": "Learn Rust HashMap with examples. Create, access, update HashMap&lt;K,V&gt; key-value pairs. Master entry API and HashMap methods. Free Rust tutorial.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/hashmaps.jsp",
    "keywords": "rust hashmap, rust hashmap tutorial, rust hash map, rust key value, rust collections, rust entry api, rust hashmap methods, rust dictionary, learn rust",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust HashMaps", "HashMap&lt;K, V&gt;", "Key-value pairs", "Entry API", "HashMap methods"],
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
            "name": "HashMaps"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="hashmaps">
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
                                    <span>HashMaps</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">HashMaps</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A <em>HashMap</em> stores a mapping of keys of type <code>K</code> to
                                        values of type <code>V</code>. It does this via a <em>hashing function</em>, which
                                        determines how it places these keys and values into memory. HashMaps are useful
                                        when you need to look up data not by an index, but by using a key that can be of
                                        any type.
                                    </p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-hashmap-structure.svg"
                                            alt="Rust HashMap Structure" class="tutorial-diagram" />
                                    </div>

                                    <h2>Creating HashMaps</h2>
                                    <p>HashMaps are not included in the prelude, so you need to import them:</p>

                                    <pre><code class="language-rust">use std::collections::HashMap;

let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);</code></pre>

                                    <div class="info-box">
                                        <strong>Import Required:</strong> Unlike <code>Vec</code> and <code>String</code>,
                                        <code>HashMap</code> is not in the prelude, so you must import it with
                                        <code>use std::collections::HashMap;</code>.
                                    </div>

                                    <h2>Creating HashMaps from Vectors</h2>
                                    <p>You can create a HashMap from a vector of tuples using <code>collect()</code>:</p>

                                    <pre><code class="language-rust">use std::collections::HashMap;

let teams = vec![
    (String::from("Blue"), 10),
    (String::from("Yellow"), 50),
];
let scores: HashMap&lt;_, _&gt; = teams.into_iter().collect();</code></pre>

                                    <div class="tip-box">
                                        <strong>Type Inference:</strong> The <code>&lt;_, _&gt;</code> tells Rust to infer
                                        the key and value types from the vector. You could also write
                                        <code>HashMap&lt;String, i32&gt;</code> explicitly.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/hashmaps-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-hashmaps-basics" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Accessing Values</h2>
                                    <p>You can get a value out of the HashMap by providing its key to the
                                        <code>get</code> method:</p>

                                    <pre><code class="language-rust">use std::collections::HashMap;

let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);

let team_name = String::from("Blue");
let score = scores.get(&team_name);</code></pre>

                                    <p>The <code>get</code> method returns an <code>Option&lt;&V&gt;</code>, so the
                                        result is wrapped in <code>Some</code> if the key exists, or <code>None</code> if
                                        it doesn't:</p>

                                    <pre><code class="language-rust">match score {
    Some(s) => println!("Score: {}", s),
    None => println!("Team not found"),
}</code></pre>

                                    <h2>Updating HashMaps</h2>
                                    <p>HashMaps have several ways to update values:</p>

                                    <h3>1. Overwriting a Value</h3>
                                    <p>If you insert a value with a key that already exists, the value will be
                                        overwritten:</p>

                                    <pre><code class="language-rust">scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Blue"), 25);  // Overwrites 10
println!("{:?}", scores);  // {"Blue": 25}</code></pre>

                                    <h3>2. Only Inserting If the Key Has No Value</h3>
                                    <p>Use the <code>entry</code> API with <code>or_insert</code>:</p>

                                    <pre><code class="language-rust">scores.entry(String::from("Yellow")).or_insert(50);
scores.entry(String::from("Blue")).or_insert(50);  // Won't overwrite</code></pre>

                                    <h3>3. Updating a Value Based on the Old Value</h3>
                                    <p>The <code>entry</code> API also allows you to update a value based on the old
                                        value:</p>

                                    <pre><code class="language-rust">let text = "hello world wonderful world";
let mut map = HashMap::new();

for word in text.split_whitespace() {
    let count = map.entry(word).or_insert(0);
    *count += 1;
}</code></pre>

                                    <div class="info-box">
                                        <strong>The Entry API:</strong> The <code>entry</code> method returns an
                                        <code>Entry</code> enum that represents a value that might or might not exist.
                                        The <code>or_insert</code> method returns a mutable reference to the value for
                                        the corresponding <code>Entry</code> key if that key exists, and if not, inserts
                                        the parameter as the new value.
                                    </div>

                                    <h2>Iterating Over HashMaps</h2>
                                    <p>You can iterate over each key-value pair in a HashMap:</p>

                                    <pre><code class="language-rust">for (key, value) in &scores {
    println!("{}: {}", key, value);
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Unordered:</strong> HashMaps are unordered. If you need ordered
                                        key-value pairs, use <code>BTreeMap</code> instead, which stores keys in sorted
                                        order.
                                    </div>

                                    <h2>Ownership</h2>
                                    <p>For types that implement the <code>Copy</code> trait, like <code>i32</code>, the
                                        values are copied into the HashMap. For owned values like <code>String</code>, the
                                        values will be moved and the HashMap will be the owner of those values:</p>

                                    <pre><code class="language-rust">use std::collections::HashMap;

let field_name = String::from("Favorite color");
let field_value = String::from("Blue");

let mut map = HashMap::new();
map.insert(field_name, field_value);
// field_name and field_value are invalid at this point</code></pre>

                                    <div class="warning-box">
                                        <strong>Ownership Transfer:</strong> When you insert owned values (like
                                        <code>String</code>) into a HashMap, ownership is transferred. The variables are
                                        no longer valid after insertion. If you insert references, the values must be
                                        valid for the lifetime of the HashMap.
                                    </div>

                                    <h2>HashMap Methods</h2>
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
                                                <td><code>insert(k, v)</code></td>
                                                <td>Insert or update key-value pair</td>
                                                <td><code>map.insert("key", 10)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>get(&k)</code></td>
                                                <td>Get value by key (returns Option)</td>
                                                <td><code>map.get(&"key")</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>get_mut(&k)</code></td>
                                                <td>Get mutable reference to value</td>
                                                <td><code>map.get_mut(&"key")</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>entry(k)</code></td>
                                                <td>Get entry for key (Entry API)</td>
                                                <td><code>map.entry("key")</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>remove(&k)</code></td>
                                                <td>Remove key-value pair</td>
                                                <td><code>map.remove(&"key")</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>len()</code></td>
                                                <td>Get number of key-value pairs</td>
                                                <td><code>map.len()</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>contains_key(&k)</code></td>
                                                <td>Check if key exists</td>
                                                <td><code>map.contains_key(&"key")</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Patterns</h2>

                                    <h3>1. Word Counting</h3>
                                    <pre><code class="language-rust">let text = "hello world wonderful world";
let mut word_count = HashMap::new();

for word in text.split_whitespace() {
    let count = word_count.entry(word).or_insert(0);
    *count += 1;
}</code></pre>

                                    <h3>2. Default Values</h3>
                                    <pre><code class="language-rust">let score = scores.get(&team_name).copied().unwrap_or(0);</code></pre>

                                    <h3>3. Conditional Updates</h3>
                                    <pre><code class="language-rust">scores.entry(team_name.clone())
    .and_modify(|e| *e += 10)
    .or_insert(50);</code></pre>

                                    <h2>When to Use HashMaps</h2>
                                    <div class="best-practice-box">
                                        <p><strong>Use <code>HashMap&lt;K, V&gt;</code> when:</strong></p>
                                        <ul>
                                            <li><strong>You need key-value lookups:</strong> When you need to look up values by a key rather than by index</li>
                                            <li><strong>You need fast lookups:</strong> O(1) average time complexity for get/insert operations</li>
                                            <li><strong>You're building caches or indexes:</strong> HashMaps are perfect for caching computed values</li>
                                            <li><strong>You're counting occurrences:</strong> Use HashMap to count frequencies (e.g., word counts, character counts)</li>
                                            <li><strong>You're grouping data:</strong> When you need to group items by a key (e.g., employees by department)</li>
                                            <li><strong>You need associative arrays:</strong> When you need to map one set of values to another</li>
                                            <li><strong>Order doesn't matter:</strong> HashMaps are unordered (use <code>BTreeMap</code> if you need sorted order)</li>
                                        </ul>
                                        
                                        <p style="margin-top: 15px;"><strong>Consider alternatives when:</strong></p>
                                        <ul>
                                            <li><strong>You need ordered keys:</strong> Use <code>BTreeMap&lt;K, V&gt;</code> for sorted key-value pairs</li>
                                            <li><strong>You only need keys (no values):</strong> Use <code>HashSet&lt;T&gt;</code> for unique elements</li>
                                            <li><strong>You need indexed access:</strong> Use <code>Vec&lt;T&gt;</code> for sequential, indexed data</li>
                                            <li><strong>You have a small, fixed set:</strong> Consider using arrays or tuples for small datasets</li>
                                            <li><strong>Keys don't implement Hash:</strong> You'll need to use <code>BTreeMap</code> which only requires <code>Ord</code></li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <strong>Performance Tip:</strong> HashMaps provide O(1) average-case performance for lookups, inserts, and deletes. However, they have higher memory overhead than vectors. For small datasets (&lt; 10 items), the overhead might not be worth it. For large datasets or frequent lookups, HashMaps are ideal.
                                    </div>

                                    <div class="info-box">
                                        <strong>HashMap vs BTreeMap:</strong> Use <code>HashMap</code> when you need fast lookups and order doesn't matter. Use <code>BTreeMap</code> when you need sorted keys, need to iterate in order, or when your keys don't implement <code>Hash</code> (but do implement <code>Ord</code>).
                                    </div>

                                    <h2>Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use <code>entry()</code> API:</strong> More efficient than
                                                checking and inserting separately</li>
                                            <li><strong>Prefer <code>get()</code> over indexing:</strong> <code>get()</code>
                                                returns <code>Option</code>, safer than panicking</li>
                                            <li><strong>Consider key types:</strong> Keys must implement <code>Eq</code>
                                                and <code>Hash</code> traits</li>
                                            <li><strong>Use references when possible:</strong> Avoid unnecessary clones
                                                of keys</li>
                                            <li><strong>Consider <code>BTreeMap</code> for ordering:</strong> If you need
                                                sorted keys</li>
                                            <li><strong>Handle missing keys:</strong> Always handle the <code>None</code>
                                                case from <code>get()</code></li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Hash Function:</strong> The default hash function is cryptographically
                                        secure but not the fastest. For performance-critical code, consider using a
                                        different hasher (like <code>FxHashMap</code> from the <code>rustc-hash</code>
                                        crate).
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to import HashMap</h4>
                                        <pre><code class="language-rust">// Wrong - HashMap not in prelude
let mut map = HashMap::new();  // Error: cannot find type `HashMap`

// Correct - Import HashMap
use std::collections::HashMap;
let mut map = HashMap::new();</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using owned values when references would work</h4>
                                        <pre><code class="language-rust">// Wrong - Unnecessary String allocation
let mut map = HashMap::new();
map.insert(String::from("key"), 10);  // String moved

// Correct - Use &str if keys live long enough
let mut map: HashMap&lt;&str, i32&gt; = HashMap::new();
let key = "key";
map.insert(key, 10);  // key still valid</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not handling Option from get()</h4>
                                        <pre><code class="language-rust">// Wrong - Can panic if key doesn't exist
let value = map.get(&"key").unwrap();  // Panics if None

// Correct - Handle the Option
match map.get(&"key") {
    Some(value) => println!("{}", value),
    None => println!("Key not found"),
}

// Or use unwrap_or for defaults
let value = map.get(&"key").copied().unwrap_or(0);</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Trying to use types that don't implement Hash as keys</h4>
                                        <pre><code class="language-rust">// Wrong - Vec doesn't implement Hash
let mut map: HashMap&lt;Vec&lt;i32&gt;, i32&gt; = HashMap::new();  // Error!

// Correct - Use types that implement Hash
let mut map: HashMap&lt;String, i32&gt; = HashMap::new();
// Or use a tuple of hashable types
let mut map: HashMap&lt;(i32, i32), i32&gt; = HashMap::new();</code></pre>
                                    </div>

                                    <h2>Exercise: HashMaps Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Implement an employee database using HashMaps.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Add employees to departments</li>
                                            <li>List all people in a department</li>
                                            <li>List all people in company by department (sorted)</li>
                                            <li>Use the entry API for efficient updates</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-collections-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-hashmaps" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">use std::collections::HashMap;

fn add_employee(db: &mut HashMap&lt;String, Vec&lt;String&gt;&gt;, name: String, dept: String) {
    db.entry(dept).or_insert_with(Vec::new).push(name);
}

fn list_department(db: &HashMap&lt;String, Vec&lt;String&gt;&gt;, dept: &str) {
    if let Some(employees) = db.get(dept) {
        println!("Employees in {}:", dept);
        for emp in employees {
            println!("  - {}", emp);
        }
    } else {
        println!("Department '{}' not found", dept);
    }
}

fn list_all(db: &HashMap&lt;String, Vec&lt;String&gt;&gt;) {
    let mut depts: Vec&lt;&String&gt; = db.keys().collect();
    depts.sort();
    
    for dept in depts {
        println!("{}:", dept);
        let mut employees = db[dept].clone();
        employees.sort();
        for emp in employees {
            println!("  - {}", emp);
        }
    }
}

fn main() {
    let mut company: HashMap&lt;String, Vec&lt;String&gt;&gt; = HashMap::new();
    
    add_employee(&mut company, String::from("Sally"), String::from("Engineering"));
    add_employee(&mut company, String::from("Bob"), String::from("Sales"));
    add_employee(&mut company, String::from("Alice"), String::from("Engineering"));
    
    list_department(&company, "Engineering");
    list_all(&company);
}</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>HashMap&lt;K, V&gt;</strong> stores key-value pairs</li>
                                            <li>Must <strong>import</strong> from <code>std::collections</code></li>
                                            <li>Create with <code>HashMap::new()</code> or <code>collect()</code></li>
                                            <li>Access with <code>get(&key)</code> (returns <code>Option&lt;&V&gt;</code>)
                                            </li>
                                            <li>Insert/update with <code>insert(key, value)</code></li>
                                            <li>Use <strong>entry API</strong> for conditional updates</li>
                                            <li>Keys must implement <code>Eq</code> and <code>Hash</code></li>
                                            <li>Owned values are <strong>moved</strong> into HashMap</li>
                                            <li>HashMaps are <strong>unordered</strong></li>
                                            <li>Use <code>BTreeMap</code> for sorted key-value pairs</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p><strong>Congratulations!</strong> You've completed the Collections module. You
                                        now know how to work with vectors, strings, and HashMaps - three of the most
                                        commonly used collection types in Rust.
                                    </p>
                                    <p>In the next modules, you'll learn about error handling in depth (panic, Result,
                                        error propagation), and more advanced Rust features like traits, generics, and
                                        lifetimes that build on these foundations.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="vectors.jsp" />
                                    <jsp:param name="prevTitle" value="Vectors" />
                                    <jsp:param name="nextLink" value="panic.jsp" />
                                    <jsp:param name="nextTitle" value="Panic!" />
                                    <jsp:param name="currentLessonId" value="hashmaps" />
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

