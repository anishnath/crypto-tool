<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "pointers" ); request.setAttribute("currentModule", "Pointers & Interfaces"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Pointers in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go pointers, memory addresses, dereferencing, pointer receivers, and when to use pointers. Master Go's memory model with interactive examples.">
            <meta name="keywords"
                content="go pointers, golang pointers, go memory, go addresses, go dereferencing, pointer receivers">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Pointers in Go">
            <meta property="og:description" content="Master Go pointers and memory management.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/pointers.jsp">
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
    "name": "Pointers in Go",
    "description": "Learn Go pointers, memory addresses, and dereferencing with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/pointers.jsp",
    "teaches": ["pointers", "memory addresses", "dereferencing", "pointer receivers"],
    "timeRequired": "PT40M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="pointers">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-go.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/go/">Go</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Pointers</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Pointers</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Pointers store memory addresses of values. They're essential for
                                        efficient
                                        programming and understanding how Go manages memory. In this lesson, you'll
                                        learn what
                                        pointers are, how to use them, and when they're necessary.</p>

                                    <!-- Section 1: What is a Pointer? -->
                                    <h2>What is a Pointer?</h2>
                                    <p>A pointer holds the memory address of a value:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/pointers-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-pointers" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Pointer Operators:</strong>
                                        <ul>
                                            <li><code>&</code> - Address operator (gets the address of a variable)</li>
                                            <li><code>*</code> - Dereference operator (accesses the value at an address)
                                            </li>
                                            <li><code>*Type</code> - Pointer type declaration</li>
                                        </ul>
                                    </div>

                                    <h3>Memory Visualization</h3>
                                    <pre><code class="language-go">x := 42
p := &x

// Memory layout:
// Variable x: [42]          at address 0x1234
// Variable p: [0x1234]      (stores address of x)
//
// *p accesses the value at address 0x1234, which is 42</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Think of a pointer as a "reference" or "arrow"
                                        pointing to where
                                        the actual value lives in memory.
                                    </div>

                                    <!-- Section 2: Pointer Basics -->
                                    <h2>Pointer Basics</h2>

                                    <h3>Declaring Pointers</h3>
                                    <pre><code class="language-go">// Declare a pointer to int
var p *int

// Get address of a variable
x := 42
p = &x

// Declare and initialize
y := 100
ptr := &y

// Zero value of a pointer is nil
var nilPtr *int  // nil</code></pre>

                                    <h3>Dereferencing Pointers</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/pointers-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-deref" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Dereferencing a nil pointer causes a runtime panic!
                                        Always
                                        check if a pointer is nil before dereferencing.
                                    </div>

                                    <!-- Section 3: Pointers and Functions -->
                                    <h2>Pointers and Functions</h2>
                                    <p>Pointers allow functions to modify the original value:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/pointers-pass-by-value.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-ptr-func" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Pass By Value</th>
                                                <th>Pass By Pointer</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Copies the value</td>
                                                <td>Copies the address</td>
                                            </tr>
                                            <tr>
                                                <td>Cannot modify original</td>
                                                <td>Can modify original</td>
                                            </tr>
                                            <tr>
                                                <td>Expensive for large structs</td>
                                                <td>Cheap (just an address)</td>
                                            </tr>
                                            <tr>
                                                <td><code>func f(x int)</code></td>
                                                <td><code>func f(x *int)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-pointers-memory.svg"
                                            alt="Pointers in Go - Memory Addresses and Dereferencing"
                                            class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Pointers - Understanding memory addresses,
                                            address-of operator (&), and dereference operator (*)</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 4: Pointers to Structs -->
                                    <h2>Pointers to Structs</h2>
                                    <p>Pointers are commonly used with structs:</p>

                                    <pre><code class="language-go">type Person struct {
    Name string
    Age  int
}

// Create a struct
p := Person{Name: "Alice", Age: 25}

// Get pointer to struct
ptr := &p

// Access fields (Go automatically dereferences)
fmt.Println(ptr.Name)  // Same as (*ptr).Name

// Modify through pointer
ptr.Age = 26
fmt.Println(p.Age)  // 26 (original modified)</code></pre>

                                    <div class="info-box">
                                        <strong>Automatic Dereferencing:</strong> Go automatically dereferences pointers
                                        when
                                        accessing struct fields. <code>ptr.Name</code> is shorthand for
                                        <code>(*ptr).Name</code>.
                                    </div>

                                    <h3>new() Function</h3>
                                    <pre><code class="language-go">// new() allocates memory and returns a pointer
p := new(Person)  // *Person, all fields zero-valued

p.Name = "Bob"
p.Age = 30

// Equivalent to:
p := &Person{}  // More common idiom</code></pre>

                                    <!-- Section 5: When to Use Pointers -->
                                    <h2>When to Use Pointers?</h2>

                                    <h3>✅ Use Pointers When:</h3>
                                    <ol>
                                        <li><strong>You need to modify the original value</strong>
                                            <pre><code class="language-go">func increment(x *int) {
    *x++
}</code></pre>
                                        </li>
                                        <li><strong>Working with large structs</strong> (avoid copying)
                                            <pre><code class="language-go">type LargeStruct struct {
    data [1000000]int
}

func process(s *LargeStruct) {
    // Efficient: only copies pointer
}</code></pre>
                                        </li>
                                        <li><strong>Need to represent "no value"</strong> (nil)
                                            <pre><code class="language-go">var optionalValue *int  // nil means "no value"</code></pre>
                                        </li>
                                        <li><strong>Implementing methods that modify the receiver</strong>
                                            <pre><code class="language-go">func (p *Person) Birthday() {
    p.Age++
}</code></pre>
                                        </li>
                                    </ol>

                                    <h3>❌ Don't Use Pointers When:</h3>
                                    <ol>
                                        <li><strong>Working with small values</strong> (int, bool, small structs)</li>
                                        <li><strong>Slices, maps, channels</strong> (already reference types)</li>
                                        <li><strong>You don't need to modify</strong> the value</li>
                                    </ol>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Start with values. Use pointers only when you
                                        have a
                                        specific reason (modification, large structs, or optional values).
                                    </div>

                                    <!-- Section 6: Pointer Gotchas -->
                                    <h2>Common Pointer Patterns</h2>

                                    <h3>1. Returning Pointers</h3>
                                    <pre><code class="language-go">// Safe: Go handles memory automatically
func newPerson(name string) *Person {
    p := Person{Name: name}
    return &p  // Safe! Go moves to heap if needed
}

// Usage
person := newPerson("Alice")</code></pre>

                                    <h3>2. Pointer to Pointer</h3>
                                    <pre><code class="language-go">x := 42
p := &x   // *int
pp := &p  // **int (pointer to pointer)

fmt.Println(**pp)  // 42</code></pre>

                                    <h3>3. Nil Pointer Checks</h3>
                                    <pre><code class="language-go">func process(p *Person) {
    if p == nil {
        fmt.Println("nil pointer")
        return
    }
    fmt.Println(p.Name)
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Dereferencing nil pointer</h4>
                                        <pre><code class="language-go">// ❌ Wrong - panic!
var p *int
*p = 42  // panic: nil pointer dereference

// ✅ Correct - initialize first
x := 0
p := &x
*p = 42</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Taking address of loop variable</h4>
                                        <pre><code class="language-go">// ❌ Wrong - all pointers point to same variable
var ptrs []*int
for _, v := range []int{1, 2, 3} {
    ptrs = append(ptrs, &v)  // All point to same v!
}

// ✅ Correct - create new variable
var ptrs []*int
for _, v := range []int{1, 2, 3} {
    v := v  // Create new variable
    ptrs = append(ptrs, &v)
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Unnecessary pointer to slice/map</h4>
                                        <pre><code class="language-go">// ❌ Wrong - slices are already references
func addItem(s *[]int, item int) {
    *s = append(*s, item)
}

// ✅ Correct - slices don't need pointers
func addItem(s []int, item int) []int {
    return append(s, item)
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Swap Function</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a swap function using pointers.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a <code>swap</code> function that swaps two integers</li>
                                            <li>Use pointers to modify the original values</li>
                                            <li>Test with values 10 and 20</li>
                                            <li>Print before and after values</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

// swap exchanges the values of two integers
func swap(a, b *int) {
    *a, *b = *b, *a
}

// swapStrings exchanges two strings
func swapStrings(a, b *string) {
    *a, *b = *b, *a
}

func main() {
    // Test with integers
    x, y := 10, 20
    fmt.Printf("Before swap: x=%d, y=%d\n", x, y)
    
    swap(&x, &y)
    fmt.Printf("After swap:  x=%d, y=%d\n", x, y)
    
    // Test with strings
    s1, s2 := "Hello", "World"
    fmt.Printf("\nBefore swap: s1=%s, s2=%s\n", s1, s2)
    
    swapStrings(&s1, &s2)
    fmt.Printf("After swap:  s1=%s, s2=%s\n", s1, s2)
    
    // Bonus: Demonstrate why pointers are needed
    fmt.Println("\n--- Without pointers (doesn't work) ---")
    a, b := 100, 200
    fmt.Printf("Before: a=%d, b=%d\n", a, b)
    
    // This won't work (copies values)
    func(x, y int) {
        x, y = y, x  // Only swaps copies!
    }(a, b)
    
    fmt.Printf("After:  a=%d, b=%d (unchanged!)\n", a, b)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Pointers</strong> store memory addresses of values</li>
                                            <li><strong>&</strong> operator gets the address of a variable</li>
                                            <li><strong>*</strong> operator dereferences (accesses value at address)
                                            </li>
                                            <li><strong>nil</strong> is the zero value for pointers</li>
                                            <li><strong>Use pointers</strong> to modify original values in functions
                                            </li>
                                            <li><strong>Automatic dereferencing</strong> for struct field access</li>
                                            <li><strong>new()</strong> allocates and returns a pointer</li>
                                            <li><strong>Don't use pointers</strong> for slices, maps, or channels</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand pointers, you're ready to learn about
                                        <strong>Interfaces</strong>—Go's
                                        powerful way to define behavior and achieve polymorphism without inheritance!
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="structs-methods.jsp" />
                                    <jsp:param name="prevTitle" value="Structs & Methods" />
                                    <jsp:param name="nextLink" value="interfaces-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Interface Basics" />
                                    <jsp:param name="currentLessonId" value="pointers" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/go.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>