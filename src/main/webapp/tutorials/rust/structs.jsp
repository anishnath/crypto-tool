<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "structs" ); request.setAttribute("currentModule", "Structs & Enums" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Rust Structs Tutorial - Custom Data Types | 8gwifi.org</title>
            <meta name="description"
                content="Learn Rust structs with examples. Master defining structs, field access, tuple structs, and struct update syntax. Free Rust tutorial with code.">
            <meta name="keywords"
                content="rust structs, rust structs tutorial, rust custom types, rust struct syntax, rust tuple structs, rust struct update, learn rust, rust programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Structs in Rust - Custom Data Types">
            <meta property="og:description" content="Master Rust structs for creating custom data types.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/rust/structs.jsp">
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
    "name": "Rust Structs Tutorial - Custom Data Types",
    "description": "Learn Rust structs with examples. Master defining structs, field access, tuple structs, and struct update syntax. Free Rust tutorial with code.",
    "learningResourceType": "Tutorial",
    "url": "https://8gwifi.org/tutorials/rust/structs.jsp",
    "keywords": "rust structs, rust structs tutorial, rust custom types, rust struct syntax, rust tuple structs, rust struct update, learn rust, rust programming",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Rust structs", "Custom data types", "Tuple structs", "Struct update syntax", "Field access"],
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
            "name": "Structs"
        }
    ]
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="structs">
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
                                    <span>Structs</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Structs</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A <em>struct</em>, short for <em>structure</em>, is a custom data
                                        type
                                        that lets you package
                                        together and name multiple related values. If you're familiar with
                                        object-oriented
                                        languages, a struct is
                                        like an object's data attributes. Structs are one of the fundamental building
                                        blocks for creating your
                                        own types in Rust.
                                    </p>

                                    <!-- Defining Structs -->
                                    <h2>Defining and Instantiating Structs</h2>
                                    <p>To define a struct, we use the <code>struct</code> keyword and name the entire
                                        struct. Then, inside curly
                                        brackets, we define the names and types of the pieces of data, which we call
                                        <em>fields</em>.
                                    </p>

                                    <pre><code class="language-rust">struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool,
}</code></pre>

                                    <p>To use a struct after we've defined it, we create an <em>instance</em> by
                                        specifying concrete values for
                                        each field:</p>

                                    <pre><code class="language-rust">let user1 = User {
    email: String::from("user@example.com"),
    username: String::from("someuser123"),
    active: true,
    sign_in_count: 1,
};</code></pre>

                                    <div class="info-box">
                                        <strong>Field Order:</strong> The order of fields in the instance doesn't have
                                        to
                                        match the order in the
                                        struct definition.
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/struct-basics.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-struct-basics" />
                                    </jsp:include>

                                    <!-- Accessing Fields -->
                                    <h2>Accessing Struct Fields</h2>
                                    <p>We can access struct fields using dot notation:</p>

                                    <pre><code class="language-rust">println!("Username: {}", user1.username);
println!("Email: {}", user1.email);</code></pre>

                                    <p>To change a field value, the entire instance must be mutable:</p>

                                    <pre><code class="language-rust">let mut user1 = User {
    email: String::from("user@example.com"),
    username: String::from("someuser123"),
    active: true,
    sign_in_count: 1,
};

user1.email = String::from("newemail@example.com");</code></pre>

                                    <div class="warning-box">
                                        <strong>All or Nothing:</strong> Rust doesn't allow marking only certain fields
                                        as
                                        mutable. The entire
                                        instance must be mutable.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Field Init Shorthand -->
                                    <h2>Field Init Shorthand</h2>
                                    <p>When parameter names match field names, you can use the field init shorthand:</p>

                                    <pre><code class="language-rust">fn build_user(email: String, username: String) -> User {
    User {
        email,      // Shorthand for email: email
        username,   // Shorthand for username: username
        active: true,
        sign_in_count: 1,
    }
}</code></pre>

                                    <!-- Struct Update Syntax -->
                                    <h2>Struct Update Syntax</h2>
                                    <p>You can create a new instance from an existing one using struct update syntax:
                                    </p>

                                    <pre><code class="language-rust">let user2 = User {
    email: String::from("another@example.com"),
    ..user1  // Use remaining fields from user1
};</code></pre>

                                    <p>The <code>..user1</code> must come last and specifies that the remaining fields
                                        should have the same value
                                        as the fields in <code>user1</code>.</p>

                                    <div class="warning-box">
                                        <strong>Ownership Note:</strong> If the struct contains non-Copy types (like
                                        <code>String</code>), those
                                        fields are moved. After using struct update syntax with <code>String</code>
                                        fields,
                                        <code>user1</code> can no
                                        longer be used!
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/struct-update.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-struct-update" />
                                    </jsp:include>

                                    <!-- Struct Types -->
                                    <h2>Types of Structs</h2>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-struct-types.svg"
                                            alt="Rust Struct Types" class="tutorial-diagram" />
                                    </div>

                                    <h3>1. Named Structs</h3>
                                    <p>The most common type with named fields:</p>

                                    <pre><code class="language-rust">struct Rectangle {
    width: u32,
    height: u32,
}</code></pre>

                                    <h3>2. Tuple Structs</h3>
                                    <p>Structs that look like tuples but have a name:</p>

                                    <pre><code class="language-rust">struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

let black = Color(0, 0, 0);
let origin = Point(0, 0, 0);

// Access with index
println!("R: {}", black.0);</code></pre>

                                    <div class="info-box">
                                        <strong>Type Safety:</strong> Even though <code>Color</code> and
                                        <code>Point</code> have the same fields,
                                        they're different types! You can't use one where the other is expected.
                                    </div>

                                    <h3>3. Unit-like Structs</h3>
                                    <p>Structs with no fields, useful for implementing traits:</p>

                                    <pre><code class="language-rust">struct AlwaysEqual;

let subject = AlwaysEqual;</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="rust/struct-types.rs" />
                                        <jsp:param name="language" value="rust" />
                                        <jsp:param name="editorId" value="compiler-struct-types" />
                                    </jsp:include>

                                    <!-- Ownership of Struct Data -->
                                    <h2>Ownership of Struct Data</h2>
                                    <p>In our <code>User</code> struct, we used the owned <code>String</code> type
                                        rather
                                        than the <code>&str</code>
                                        string slice type. This is deliberate - we want each instance to own all of its
                                        data.</p>

                                    <pre><code class="language-rust">struct User {
    username: String,  // Owned
    email: String,     // Owned
    active: bool,
    sign_in_count: u64,
}</code></pre>

                                    <p>It's possible for structs to store references, but that requires the use of
                                        <em>lifetimes</em>, which we'll
                                        cover in a later module.
                                    </p>

                                    <!-- When to Use Structs -->
                                    <h2>When to Use Each Type</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Struct Type</th>
                                                <th>Use When</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Named Struct</td>
                                                <td>Fields have clear names</td>
                                                <td><code>User</code>, <code>Rectangle</code></td>
                                            </tr>
                                            <tr>
                                                <td>Tuple Struct</td>
                                                <td>Few fields, names would be verbose</td>
                                                <td><code>Color(r, g, b)</code>, <code>Point(x, y)</code></td>
                                            </tr>
                                            <tr>
                                                <td>Unit-like Struct</td>
                                                <td>Need a type with no data</td>
                                                <td>Trait implementations</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Common Patterns -->
                                    <h2>Common Struct Patterns</h2>

                                    <h3>1. Builder Pattern</h3>
                                    <pre><code class="language-rust">fn new_user(email: String, username: String) -> User {
    User {
        email,
        username,
        active: true,
        sign_in_count: 1,
    }
}</code></pre>

                                    <h3>2. Default Values</h3>
                                    <pre><code class="language-rust">let user = User {
    email: String::from("user@example.com"),
    username: String::from("user"),
    ..Default::default()  // Use default for other fields
};</code></pre>

                                    <h3>3. Destructuring</h3>
                                    <pre><code class="language-rust">let User { username, email, .. } = user1;
println!("Username: {}", username);</code></pre>

                                    <!-- Best Practices -->
                                    <h2>Struct Best Practices</h2>
                                    <div class="best-practice-box">
                                        <ul>
                                            <li><strong>Use owned types when possible:</strong> Prefer
                                                <code>String</code>
                                                over <code>&str</code> in structs</li>
                                            <li><strong>Name fields clearly:</strong> Field names should be descriptive
                                            </li>
                                            <li><strong>Group related data:</strong> Structs should represent a cohesive
                                                concept</li>
                                            <li><strong>Use tuple structs sparingly:</strong> Only when field names
                                                would be
                                                redundant</li>
                                            <li><strong>Consider visibility:</strong> Use <code>pub</code> for public
                                                fields
                                                when needed</li>
                                            <li><strong>Keep structs focused:</strong> Don't create "god objects" with
                                                too
                                                many fields</li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use struct update syntax (<code>..existing</code>) to create new instances from existing ones. This is especially useful when you want to change only a few fields while keeping the rest the same.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Trying to mutate immutable struct fields</h4>
                                        <pre><code class="language-rust">// Wrong
let user = User {
    email: String::from("user@example.com"),
    username: String::from("user"),
    active: true,
    sign_in_count: 1,
};
user.email = String::from("new@example.com"); // Error: cannot assign

// Correct
let mut user = User {
    email: String::from("user@example.com"),
    username: String::from("user"),
    active: true,
    sign_in_count: 1,
};
user.email = String::from("new@example.com"); // OK</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using struct update syntax with non-Copy types incorrectly</h4>
                                        <pre><code class="language-rust">// Wrong - user1 is moved and can't be used after
let user1 = User {
    email: String::from("user@example.com"),
    username: String::from("user"),
    active: true,
    sign_in_count: 1,
};
let user2 = User {
    email: String::from("another@example.com"),
    ..user1
};
println!("{}", user1.email); // Error: value moved

// Correct - Clone if you need both
let user2 = User {
    email: String::from("another@example.com"),
    username: user1.username.clone(),
    active: user1.active,
    sign_in_count: user1.sign_in_count,
};
// Or use references if appropriate</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Confusing tuple structs with regular tuples</h4>
                                        <pre><code class="language-rust">// Wrong - These are different types!
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

let color = Color(255, 0, 0);
let point = Point(0, 0, 0);
let result = add_colors(color, point); // Error: type mismatch

// Correct - Use the right type
fn add_colors(c1: Color, c2: Color) -> Color {
    Color(c1.0 + c2.0, c1.1 + c2.1, c1.2 + c2.2)
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Structs Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Complete the struct definitions and functions.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Define named structs</li>
                                            <li>Define tuple structs</li>
                                            <li>Access and modify fields</li>
                                            <li>Use struct update syntax</li>
                                            <li>Implement helper functions</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="rust/exercises/ex-structs-starter.rs" />
                                            <jsp:param name="language" value="rust" />
                                            <jsp:param name="editorId" value="exercise-structs" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-rust">struct Rectangle {
    width: u32,
    height: u32,
}

struct Person {
    name: String,
    age: u32,
}

struct Color(i32, i32, i32);
struct Point3D(f64, f64, f64);

fn main() {
    let rect = Rectangle {
        width: 30,
        height: 50,
    };
    
    let area = calculate_area(&rect);
    println!("Area: {}", area);
    
    let person = Person {
        name: String::from("Alice"),
        age: 30,
    };
    
    println!("Name: {}, Age: {}", person.name, person.age);
    
    let person2 = Person {
        name: String::from("Bob"),
        ..person
    };
    
    let red = Color(255, 0, 0);
    println!("Red: ({}, {}, {})", red.0, red.1, red.2);
    
    let point = Point3D(3.0, 4.0, 0.0);
    let distance = (point.0.powi(2) + point.1.powi(2) + point.2.powi(2)).sqrt();
    println!("Distance from origin: {}", distance);
}

fn calculate_area(rect: &Rectangle) -> u32 {
    rect.width * rect.height
}

fn create_square(size: u32) -> Rectangle {
    Rectangle {
        width: size,
        height: size,
    }
}

fn is_adult(person: &Person) -> bool {
    person.age >= 18
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Structs</strong> let you create custom data types</li>
                                            <li><strong>Named structs:</strong> Most common, with named fields</li>
                                            <li><strong>Tuple structs:</strong> Named tuples with indexed fields</li>
                                            <li><strong>Unit-like structs:</strong> No fields, useful for traits</li>
                                            <li>Access fields with <strong>dot notation</strong></li>
                                            <li>Entire instance must be <strong>mutable</strong> to change fields</li>
                                            <li><strong>Field init shorthand:</strong> Use when parameter names match
                                                fields
                                            </li>
                                            <li><strong>Struct update syntax:</strong> Create instances from existing
                                                ones
                                                with <code>..</code></li>
                                            <li>Prefer <strong>owned types</strong> in structs (e.g.,
                                                <code>String</code>)
                                            </li>
                                            <li>Structs follow <strong>ownership rules</strong> like any other type</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you know how to define structs, you'll learn how to add
                                        <strong>methods</strong> to them.
                                        Methods are functions that are associated with a particular type. In the next
                                        lesson, you'll learn how to
                                        define methods using <code>impl</code> blocks, understand <code>self</code>, and
                                        create associated functions.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="slices.jsp" />
                                    <jsp:param name="prevTitle" value="Slices" />
                                    <jsp:param name="nextLink" value="methods.jsp" />
                                    <jsp:param name="nextTitle" value="Methods" />
                                    <jsp:param name="currentLessonId" value="structs" />
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