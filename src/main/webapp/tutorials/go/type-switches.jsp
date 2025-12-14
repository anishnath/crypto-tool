<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "type-switches" );
        request.setAttribute("currentModule", "Pointers & Interfaces" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Type Switches & Common Interfaces in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go type switches, type assertions, and common standard library interfaces like Stringer, Reader, Writer. Master interface patterns.">
            <meta name="keywords"
                content="go type switch, go type assertion, go stringer, go reader writer, go common interfaces">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Type Switches & Common Interfaces in Go">
            <meta property="og:description" content="Master Go type switches and standard library interfaces.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/type-switches.jsp">
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
    "name": "Type Switches & Common Interfaces in Go",
    "description": "Learn Go type switches, type assertions, and standard library interfaces.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/type-switches.jsp",
    "teaches": ["type switches", "type assertions", "Stringer", "Reader", "Writer"],
    "timeRequired": "PT30M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="type-switches">
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
                                    <span>Type Switches & Common Interfaces</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Type Switches & Common Interfaces</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Type switches and assertions let you work with interface values
                                        dynamically. Go's
                                        standard library also provides essential interfaces that you'll use constantly.
                                        In this
                                        lesson, you'll master both concepts.</p>

                                    <!-- Section 1: Type Assertions -->
                                    <h2>Type Assertions</h2>
                                    <p>Type assertions extract the concrete value from an interface:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/interfaces-assertions.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-assertion" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Type Assertion Syntax:</strong>
                                        <pre><code class="language-go">// Single return (panics if wrong type)
value := interfaceValue.(ConcreteType)

// Two returns (safe, doesn't panic)
value, ok := interfaceValue.(ConcreteType)
if ok {
    // Type assertion succeeded
}</code></pre>
                                    </div>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Always use the two-value form of type assertion
                                        to avoid
                                        panics: <code>value, ok := i.(Type)</code>
                                    </div>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-type-assertion.svg"
                                            alt="Type Assertion and Type Switch in Go" class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Type Assertion and Type Switch - Safe vs
                                            unsafe type assertions and handling multiple types with type switch</p>
                                    </div>

                                    <!-- Section 2: Type Switches -->
                                    <h2>Type Switches</h2>
                                    <p>Type switches let you handle different types in a clean way:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/interfaces-type-switch.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-type-switch" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Type Switch Syntax:</strong>
                                        <pre><code class="language-go">switch v := interfaceValue.(type) {
case Type1:
    // v is Type1
case Type2:
    // v is Type2
default:
    // v is the interface type
}</code></pre>
                                    </div>

                                    <h3>Type Switch Patterns</h3>
                                    <pre><code class="language-go">// Multiple types in one case
switch v := i.(type) {
case int, int64:
    fmt.Println("Integer:", v)
case string:
    fmt.Println("String:", v)
case nil:
    fmt.Println("Nil value")
default:
    fmt.Printf("Unknown type: %T\n", v)
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Common Interfaces -->
                                    <h2>Common Standard Library Interfaces</h2>

                                    <h3>1. fmt.Stringer</h3>
                                    <p>The Stringer interface customizes how types are printed:</p>

                                    <pre><code class="language-go">type Stringer interface {
    String() string
}

type Person struct {
    Name string
    Age  int
}

func (p Person) String() string {
    return fmt.Sprintf("%s (%d years old)", p.Name, p.Age)
}

func main() {
    p := Person{Name: "Alice", Age: 25}
    fmt.Println(p)  // Alice (25 years old)
}</code></pre>

                                    <h3>2. io.Reader</h3>
                                    <p>Reader reads data into a byte slice:</p>

                                    <pre><code class="language-go">type Reader interface {
    Read(p []byte) (n int, err error)
}

// Common implementations:
// - os.File
// - strings.Reader
// - bytes.Buffer
// - net.Conn

func readData(r io.Reader) {
    buf := make([]byte, 1024)
    n, err := r.Read(buf)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Printf("Read %d bytes: %s\n", n, buf[:n])
}</code></pre>

                                    <h3>3. io.Writer</h3>
                                    <p>Writer writes data from a byte slice:</p>

                                    <pre><code class="language-go">type Writer interface {
    Write(p []byte) (n int, err error)
}

// Common implementations:
// - os.File
// - bytes.Buffer
// - net.Conn
// - http.ResponseWriter

func writeData(w io.Writer, data string) {
    n, err := w.Write([]byte(data))
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Printf("Wrote %d bytes\n", n)
}</code></pre>

                                    <h3>4. error Interface</h3>
                                    <p>The error interface is used throughout Go:</p>

                                    <pre><code class="language-go">type error interface {
    Error() string
}

// Custom error type
type ValidationError struct {
    Field   string
    Message string
}

func (e ValidationError) Error() string {
    return fmt.Sprintf("%s: %s", e.Field, e.Message)
}

func validate(age int) error {
    if age < 0 {
        return ValidationError{
            Field:   "age",
            Message: "must be non-negative",
        }
    }
    return nil
}</code></pre>

                                    <!-- Section 4: Interface Table -->
                                    <h2>Common Standard Library Interfaces</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Interface</th>
                                                <th>Package</th>
                                                <th>Purpose</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>Stringer</code></td>
                                                <td>fmt</td>
                                                <td>Custom string representation</td>
                                            </tr>
                                            <tr>
                                                <td><code>Reader</code></td>
                                                <td>io</td>
                                                <td>Read data</td>
                                            </tr>
                                            <tr>
                                                <td><code>Writer</code></td>
                                                <td>io</td>
                                                <td>Write data</td>
                                            </tr>
                                            <tr>
                                                <td><code>Closer</code></td>
                                                <td>io</td>
                                                <td>Close resources</td>
                                            </tr>
                                            <tr>
                                                <td><code>error</code></td>
                                                <td>builtin</td>
                                                <td>Error handling</td>
                                            </tr>
                                            <tr>
                                                <td><code>Handler</code></td>
                                                <td>http</td>
                                                <td>HTTP request handling</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 5: Practical Examples -->
                                    <h2>Practical Examples</h2>

                                    <h3>JSON Marshaling with Interfaces</h3>
                                    <pre><code class="language-go">type Animal interface {
    Speak() string
}

type Dog struct {
    Name string
}

func (d Dog) Speak() string {
    return "Woof!"
}

type Cat struct {
    Name string
}

func (c Cat) Speak() string {
    return "Meow!"
}

func main() {
    animals := []Animal{
        Dog{Name: "Buddy"},
        Cat{Name: "Whiskers"},
    }
    
    for _, animal := range animals {
        // Type switch to get specific behavior
        switch a := animal.(type) {
        case Dog:
            fmt.Printf("%s says %s\n", a.Name, a.Speak())
        case Cat:
            fmt.Printf("%s says %s\n", a.Name, a.Speak())
        }
    }
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Type assertion without checking</h4>
                                        <pre><code class="language-go">// ❌ Wrong - panics if wrong type
var i interface{} = "hello"
num := i.(int)  // panic!

// ✅ Correct - check before using
if num, ok := i.(int); ok {
    fmt.Println(num)
} else {
    fmt.Println("Not an int")
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Forgetting nil case in type switch</h4>
                                        <pre><code class="language-go">// ❌ Incomplete - doesn't handle nil
func process(i interface{}) {
    switch v := i.(type) {
    case string:
        fmt.Println("String:", v)
    case int:
        fmt.Println("Int:", v)
    }
}

// ✅ Complete - handles nil
func process(i interface{}) {
    switch v := i.(type) {
    case nil:
        fmt.Println("Nil value")
    case string:
        fmt.Println("String:", v)
    case int:
        fmt.Println("Int:", v)
    default:
        fmt.Printf("Unknown: %T\n", v)
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not implementing error interface correctly</h4>
                                        <pre><code class="language-go">// ❌ Wrong - pointer receiver
type MyError struct {
    msg string
}

func (e *MyError) Error() string {
    return e.msg
}

// This doesn't work as expected
err := MyError{msg: "oops"}
var e error = err  // Error: MyError doesn't implement error

// ✅ Correct - value receiver for error
func (e MyError) Error() string {
    return e.msg
}

err := MyError{msg: "oops"}
var e error = err  // OK</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Shape Calculator</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a shape calculator using interfaces and type
                                            switches.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Define a <code>Shape</code> interface with <code>Area()</code> method
                                            </li>
                                            <li>Implement <code>Circle</code> and <code>Rectangle</code></li>
                                            <li>Add <code>String()</code> method to both (fmt.Stringer)</li>
                                            <li>Use type switch to print specific details</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
    "math"
)

// Shape interface
type Shape interface {
    Area() float64
}

// Circle implementation
type Circle struct {
    Radius float64
}

func (c Circle) Area() float64 {
    return math.Pi * c.Radius * c.Radius
}

func (c Circle) String() string {
    return fmt.Sprintf("Circle(radius=%.2f)", c.Radius)
}

// Rectangle implementation
type Rectangle struct {
    Width  float64
    Height float64
}

func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

func (r Rectangle) String() string {
    return fmt.Sprintf("Rectangle(%.2f x %.2f)", r.Width, r.Height)
}

// Triangle implementation (bonus)
type Triangle struct {
    Base   float64
    Height float64
}

func (t Triangle) Area() float64 {
    return 0.5 * t.Base * t.Height
}

func (t Triangle) String() string {
    return fmt.Sprintf("Triangle(base=%.2f, height=%.2f)", t.Base, t.Height)
}

// Describe shape using type switch
func describe(s Shape) {
    fmt.Printf("%s has area %.2f\n", s, s.Area())
    
    // Type switch for specific details
    switch shape := s.(type) {
    case Circle:
        fmt.Printf("  Circumference: %.2f\n", 2*math.Pi*shape.Radius)
    case Rectangle:
        fmt.Printf("  Perimeter: %.2f\n", 2*(shape.Width+shape.Height))
    case Triangle:
        fmt.Printf("  Base: %.2f, Height: %.2f\n", shape.Base, shape.Height)
    default:
        fmt.Printf("  Unknown shape type: %T\n", shape)
    }
}

func main() {
    shapes := []Shape{
        Circle{Radius: 5},
        Rectangle{Width: 4, Height: 6},
        Triangle{Base: 3, Height: 4},
    }
    
    fmt.Println("Shape Calculator")
    fmt.Println("================")
    
    for _, shape := range shapes {
        describe(shape)
        fmt.Println()
    }
    
    // Calculate total area
    totalArea := 0.0
    for _, shape := range shapes {
        totalArea += shape.Area()
    }
    fmt.Printf("Total area of all shapes: %.2f\n", totalArea)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Type assertions</strong> extract concrete values from interfaces
                                            </li>
                                            <li><strong>Use two-value form</strong> to avoid panics:
                                                <code>v, ok := i.(Type)</code>
                                            </li>
                                            <li><strong>Type switches</strong> handle multiple types cleanly</li>
                                            <li><strong>fmt.Stringer</strong> customizes string representation</li>
                                            <li><strong>io.Reader/Writer</strong> are fundamental for I/O operations
                                            </li>
                                            <li><strong>error interface</strong> is used for error handling</li>
                                            <li><strong>Small interfaces</strong> are more flexible and composable</li>
                                            <li><strong>Standard library interfaces</strong> enable powerful
                                                abstractions</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing the Pointers & Interfaces module! You now
                                        understand Go's memory
                                        model and polymorphism. Next, you'll learn about <strong>Error
                                            Handling</strong>—Go's
                                        philosophy on errors, custom errors, and best practices.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="interfaces-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Interface Basics" />
                                    <jsp:param name="nextLink" value="errors-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Error Basics" />
                                    <jsp:param name="currentLessonId" value="type-switches" />
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