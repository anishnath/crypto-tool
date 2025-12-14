<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "structs-methods" );
        request.setAttribute("currentModule", "Data Structures" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Structs & Methods in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go structs, methods, receivers, embedding, and composition. Master custom types and object-oriented programming in Go with interactive examples.">
            <meta name="keywords"
                content="go structs, golang structs, go methods, go receivers, go embedding, go composition, go oop">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Structs & Methods in Go">
            <meta property="og:description" content="Master Go structs and methods for custom types.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/structs-methods.jsp">
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
    "name": "Structs & Methods in Go",
    "description": "Learn Go structs, methods, receivers, and composition with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/structs-methods.jsp",
    "teaches": ["structs", "methods", "receivers", "embedding", "composition"],
    "timeRequired": "PT30M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="structs-methods">
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
                                    <span>Structs & Methods</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Structs & Methods</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Structs are Go's way of creating custom types that group related
                                        data together.
                                        Methods let you add behavior to these types. Together, they form the foundation
                                        of
                                        object-oriented programming in Go—without classes or inheritance!</p>

                                    <!-- Section 1: Struct Basics -->
                                    <h2>What is a Struct?</h2>
                                    <p>A struct is a composite data type that groups together zero or more fields:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/structs-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-structs" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Struct Characteristics:</strong>
                                        <ul>
                                            <li><strong>Value type</strong> - Copying creates a new struct</li>
                                            <li><strong>Fields</strong> can be any type (including other structs)</li>
                                            <li><strong>Zero value</strong> - All fields set to their zero values</li>
                                            <li><strong>Exported fields</strong> start with uppercase letter</li>
                                        </ul>
                                    </div>

                                    <h3>Creating Struct Instances</h3>
                                    <pre><code class="language-go">// Using struct literal
p1 := Person{Name: "Alice", Age: 25}

// Positional (not recommended)
p2 := Person{"Bob", 30}

// Zero value
var p3 Person  // Name: "", Age: 0

// Pointer to struct
p4 := &Person{Name: "Carol", Age: 28}

// Partial initialization
p5 := Person{Name: "Dave"}  // Age: 0</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Always use named fields in struct literals. It's
                                        more
                                        readable and won't break if you reorder fields!
                                    </div>

                                    <!-- Section 2: Methods -->
                                    <h2>Methods</h2>
                                    <p>Methods are functions with a special receiver argument that associates them with
                                        a type:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/structs-methods.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-methods" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Method Syntax:</strong>
                                        <pre><code class="language-go">func (receiver Type) MethodName(params) returnType {
    // method body
}</code></pre>
                                        The receiver appears between <code>func</code> and the method name.
                                    </div>

                                    <!-- Section 3: Value vs Pointer Receivers -->
                                    <h2>Value vs Pointer Receivers</h2>
                                    <p>Methods can have value receivers or pointer receivers:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/structs-pointer-receivers.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-receivers" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Receiver Type</th>
                                                <th>When to Use</th>
                                                <th>Behavior</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Value</strong><br><code>(r Type)</code></td>
                                                <td>• Method doesn't modify receiver<br>• Small structs<br>• Read-only
                                                    operations</td>
                                                <td>Works on a copy</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Pointer</strong><br><code>(r *Type)</code></td>
                                                <td>• Method modifies receiver<br>• Large structs<br>• Consistency</td>
                                                <td>Works on original</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use pointer receivers by default unless you have
                                        a good
                                        reason not to. This avoids copying and allows modification.
                                    </div>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-structs-methods.svg"
                                            alt="Structs and Methods - Value vs Pointer Receivers"
                                            class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Structs and Methods - Understanding value
                                            receivers (copy) vs pointer receivers (reference)</p>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 4: Struct Embedding -->
                                    <h2>Struct Embedding (Composition)</h2>
                                    <p>Go doesn't have inheritance, but it has composition through embedding:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/structs-nested.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-embedding" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Embedding Benefits:</strong>
                                        <ul>
                                            <li><strong>Promoted fields</strong> - Access embedded fields directly</li>
                                            <li><strong>Promoted methods</strong> - Call embedded type's methods</li>
                                            <li><strong>Composition over inheritance</strong> - More flexible</li>
                                            <li><strong>No diamond problem</strong> - Simpler than inheritance</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Anonymous Structs -->
                                    <h2>Anonymous Structs</h2>
                                    <p>Structs without a name, useful for one-time use:</p>

                                    <pre><code class="language-go">// Anonymous struct
person := struct {
    Name string
    Age  int
}{
    Name: "Alice",
    Age:  25,
}

// Common use: test data
testCases := []struct {
    input    int
    expected int
}{
    {1, 2},
    {2, 4},
    {3, 6},
}

for _, tc := range testCases {
    result := double(tc.input)
    if result != tc.expected {
        t.Errorf("Expected %d, got %d", tc.expected, result)
    }
}</code></pre>

                                    <!-- Section 6: Struct Tags -->
                                    <h2>Struct Tags</h2>
                                    <p>Struct tags provide metadata about fields, commonly used for JSON encoding:</p>

                                    <pre><code class="language-go">type User struct {
    ID        int    `json:"id"`
    Name      string `json:"name"`
    Email     string `json:"email,omitempty"`
    Password  string `json:"-"`  // Never serialize
    CreatedAt time.Time `json:"created_at"`
}

user := User{
    ID:    1,
    Name:  "Alice",
    Email: "alice@example.com",
}

// Marshal to JSON
data, _ := json.Marshal(user)
fmt.Println(string(data))
// {"id":1,"name":"Alice","email":"alice@example.com","created_at":"..."}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting pointer receiver for modification</h4>
                                        <pre><code class="language-go">// ❌ Wrong - value receiver doesn't modify original
type Counter struct {
    count int
}

func (c Counter) Increment() {
    c.count++  // Modifies copy!
}

c := Counter{}
c.Increment()
fmt.Println(c.count)  // 0 (unchanged)

// ✅ Correct - pointer receiver
func (c *Counter) Increment() {
    c.count++  // Modifies original
}

c := Counter{}
c.Increment()
fmt.Println(c.count)  // 1</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Comparing structs with uncomparable fields</h4>
                                        <pre><code class="language-go">// ❌ Wrong - can't compare structs with slices
type Person struct {
    Name    string
    Friends []string  // Slice is not comparable
}

p1 := Person{Name: "Alice"}
p2 := Person{Name: "Alice"}
if p1 == p2 {  // Error: invalid operation
    // ...
}

// ✅ Correct - compare manually or use reflect.DeepEqual
func (p Person) Equals(other Person) bool {
    if p.Name != other.Name {
        return false
    }
    // Compare slices manually
    // ...
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Mixing value and pointer receivers</h4>
                                        <pre><code class="language-go">// ❌ Inconsistent - mixing receiver types
type Person struct {
    Name string
}

func (p Person) GetName() string {
    return p.Name
}

func (p *Person) SetName(name string) {
    p.Name = name
}

// ✅ Better - use pointer receivers consistently
func (p *Person) GetName() string {
    return p.Name
}

func (p *Person) SetName(name string) {
    p.Name = name
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Rectangle Calculator</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a Rectangle struct with methods.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a Rectangle struct with Width and Height</li>
                                            <li>Add an Area() method</li>
                                            <li>Add a Perimeter() method</li>
                                            <li>Add a Scale(factor float64) method to resize</li>
                                            <li>Test with a 5x10 rectangle</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

type Rectangle struct {
    Width  float64
    Height float64
}

// Area calculates the area
func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

// Perimeter calculates the perimeter
func (r Rectangle) Perimeter() float64 {
    return 2 * (r.Width + r.Height)
}

// Scale resizes the rectangle
func (r *Rectangle) Scale(factor float64) {
    r.Width *= factor
    r.Height *= factor
}

// String provides a string representation
func (r Rectangle) String() string {
    return fmt.Sprintf("Rectangle{Width: %.2f, Height: %.2f}", r.Width, r.Height)
}

func main() {
    rect := Rectangle{Width: 5, Height: 10}
    
    fmt.Println(rect)
    fmt.Printf("Area: %.2f\n", rect.Area())
    fmt.Printf("Perimeter: %.2f\n", rect.Perimeter())
    
    // Scale up by 2x
    rect.Scale(2)
    fmt.Println("\nAfter scaling by 2:")
    fmt.Println(rect)
    fmt.Printf("Area: %.2f\n", rect.Area())
    fmt.Printf("Perimeter: %.2f\n", rect.Perimeter())
    
    // Bonus: Check if it's a square
    if rect.Width == rect.Height {
        fmt.Println("This is a square!")
    } else {
        fmt.Println("This is a rectangle!")
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Structs</strong> group related data into custom types</li>
                                            <li><strong>Methods</strong> add behavior to types via receivers</li>
                                            <li><strong>Value receivers</strong> work on copies (read-only)</li>
                                            <li><strong>Pointer receivers</strong> work on originals (can modify)</li>
                                            <li><strong>Embedding</strong> provides composition (not inheritance)</li>
                                            <li><strong>Anonymous structs</strong> useful for one-time use</li>
                                            <li><strong>Struct tags</strong> provide metadata for encoding/decoding</li>
                                            <li><strong>Use pointer receivers</strong> by default for consistency</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing the Data Structures module! You now understand
                                        arrays, slices,
                                        maps, and structs. Next, you'll learn about <strong>Pointers</strong>—how to
                                        work with
                                        memory addresses and understand Go's memory model.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="maps.jsp" />
                                    <jsp:param name="prevTitle" value="Maps" />
                                    <jsp:param name="nextLink" value="pointers.jsp" />
                                    <jsp:param name="nextTitle" value="Pointers" />
                                    <jsp:param name="currentLessonId" value="structs-methods" />
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