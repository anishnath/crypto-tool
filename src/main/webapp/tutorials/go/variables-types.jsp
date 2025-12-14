<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "variables-types" ); request.setAttribute("currentModule", "Basics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Variables & Types in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go variables, type system, declarations, and type inference. Master var, short declaration, zero values, and type conversion with examples.">
            <meta name="keywords"
                content="go variables, golang variables, go types, go type system, var keyword, short declaration, go type inference, zero values">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Variables & Types in Go">
            <meta property="og:description" content="Master Go variables and type system with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/variables-types.jsp">
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
    "name": "Variables & Types in Go",
    "description": "Learn Go variables, type system, declarations, and type inference with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/variables-types.jsp",
    "teaches": ["Go variables", "Type system", "var keyword", "Short declaration", "Type inference", "Zero values", "Type conversion"],
    "timeRequired": "PT35M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="variables-types">
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
                                    <span>Variables & Types</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Variables & Types</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Variables are the foundation of any programming language. In this
                                        lesson, you'll
                                        learn how to declare variables in Go, understand Go's type system, and master
                                        type inference
                                        and conversions.</p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-variables-types-hierarchy.svg"
                                            alt="Go Variables and Types - Complete Hierarchy" class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Complete Go Variables & Types Hierarchy -
                                            Declarations, Basic Types, Composite Types, Reference Types, and Conversions
                                        </p>
                                    </div>

                                    <!-- Section 1: Variable Declaration with var -->
                                    <h2>Variable Declaration with var</h2>
                                    <p>Go provides the <code>var</code> keyword for declaring variables. The syntax is:
                                    </p>

                                    <pre><code class="language-go">var name type = value</code></pre>

                                    <p>Let's see it in action:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/variables-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-var-basic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Points:</strong>
                                        <ul>
                                            <li><code>var</code> declares a variable</li>
                                            <li>Type comes <strong>after</strong> the variable name (unlike C/Java)</li>
                                            <li>You can initialize the variable immediately</li>
                                            <li>Variables without initialization get their "zero value"</li>
                                        </ul>
                                    </div>

                                    <h3>Zero Values</h3>
                                    <p>In Go, variables declared without an explicit initial value are given their
                                        <strong>zero
                                            value</strong>:
                                    </p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Zero Value</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Numeric types (<code>int</code>, <code>float64</code>)</td>
                                                <td><code>0</code></td>
                                                <td><code>var count int</code> → 0</td>
                                            </tr>
                                            <tr>
                                                <td>Boolean (<code>bool</code>)</td>
                                                <td><code>false</code></td>
                                                <td><code>var active bool</code> → false</td>
                                            </tr>
                                            <tr>
                                                <td>String (<code>string</code>)</td>
                                                <td><code>""</code> (empty string)</td>
                                                <td><code>var name string</code> → ""</td>
                                            </tr>
                                            <tr>
                                                <td>Pointers, slices, maps, channels, functions, interfaces</td>
                                                <td><code>nil</code></td>
                                                <td><code>var ptr *int</code> → nil</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Zero values make Go programs safer. You never
                                        have
                                        uninitialized variables with random values like in C/C++!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: Short Variable Declaration -->
                                    <h2>Short Variable Declaration (:=)</h2>
                                    <p>Go provides a shorthand syntax using <code>:=</code> for declaring and
                                        initializing variables
                                        inside functions:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/variables-short-declaration.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-short-decl" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Short Declaration (:=) Rules:</strong>
                                        <ul>
                                            <li>Can <strong>only</strong> be used inside functions</li>
                                            <li>Type is inferred from the value</li>
                                            <li>More concise than <code>var</code></li>
                                            <li>Most common way to declare variables in Go</li>
                                        </ul>
                                    </div>

                                    <h3>var vs := When to Use Which?</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Use <code>var</code></th>
                                                <th>Use <code>:=</code></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Package-level variables</td>
                                                <td>Local variables in functions</td>
                                            </tr>
                                            <tr>
                                                <td>When you need to specify the type explicitly</td>
                                                <td>When type can be inferred</td>
                                            </tr>
                                            <tr>
                                                <td>When declaring without initialization</td>
                                                <td>When initializing immediately</td>
                                            </tr>
                                            <tr>
                                                <td><code>var count int</code></td>
                                                <td><code>count := 0</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 3: Go's Type System -->
                                    <h2>Go's Type System</h2>
                                    <p>Go is a <strong>statically typed</strong> language, meaning variable types are
                                        known at
                                        compile time. Here are the basic types:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/types-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-types" />
                                    </jsp:include>

                                    <h3>Numeric Types</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Size</th>
                                                <th>Range/Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>int</code></td>
                                                <td>32 or 64 bits</td>
                                                <td>Platform dependent (most common)</td>
                                            </tr>
                                            <tr>
                                                <td><code>int8</code></td>
                                                <td>8 bits</td>
                                                <td>-128 to 127</td>
                                            </tr>
                                            <tr>
                                                <td><code>int16</code></td>
                                                <td>16 bits</td>
                                                <td>-32,768 to 32,767</td>
                                            </tr>
                                            <tr>
                                                <td><code>int32</code></td>
                                                <td>32 bits</td>
                                                <td>-2 billion to 2 billion</td>
                                            </tr>
                                            <tr>
                                                <td><code>int64</code></td>
                                                <td>64 bits</td>
                                                <td>Very large numbers</td>
                                            </tr>
                                            <tr>
                                                <td><code>uint</code>, <code>uint8</code>, <code>uint16</code>, etc.
                                                </td>
                                                <td>Varies</td>
                                                <td>Unsigned (positive only)</td>
                                            </tr>
                                            <tr>
                                                <td><code>float32</code></td>
                                                <td>32 bits</td>
                                                <td>Single precision</td>
                                            </tr>
                                            <tr>
                                                <td><code>float64</code></td>
                                                <td>64 bits</td>
                                                <td>Double precision (default for decimals)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Other Basic Types</h3>
                                    <ul>
                                        <li><code>bool</code> - Boolean values (<code>true</code> or <code>false</code>)
                                        </li>
                                        <li><code>string</code> - UTF-8 encoded text</li>
                                        <li><code>byte</code> - Alias for <code>uint8</code></li>
                                        <li><code>rune</code> - Alias for <code>int32</code>, represents a Unicode code
                                            point</li>
                                    </ul>

                                    <!-- Section 4: Type Inference -->
                                    <h2>Type Inference</h2>
                                    <p>Go can automatically infer the type of a variable from its initial value:</p>

                                    <pre><code class="language-go">// Type is inferred
message := "Hello"      // string
count := 42             // int
pi := 3.14159          // float64
isActive := true       // bool

// You can check the type using %T in Printf
fmt.Printf("Type of message: %T\n", message)  // string
fmt.Printf("Type of count: %T\n", count)      // int
fmt.Printf("Type of pi: %T\n", pi)            // float64</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> When Go infers numeric types:
                                        <ul>
                                            <li>Integers default to <code>int</code></li>
                                            <li>Floating-point numbers default to <code>float64</code></li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Type Conversion -->
                                    <h2>Type Conversion</h2>
                                    <p>Unlike some languages, Go requires <strong>explicit type conversion</strong>.
                                        There are no
                                        automatic conversions:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/types-conversion.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-conversion" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Type conversion syntax is <code>Type(value)</code>,
                                        not
                                        <code>(Type)value</code> like in C/Java. For example: <code>float64(x)</code>,
                                        not
                                        <code>(float64)x</code>.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using := outside functions</h4>
                                        <pre><code class="language-go">// ❌ Wrong - syntax error
package main

count := 0  // Can't use := at package level

func main() {
    // ...
}

// ✅ Correct
package main

var count = 0  // Use var at package level

func main() {
    // ...
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Redeclaring variables with :=</h4>
                                        <pre><code class="language-go">// ❌ Wrong - redeclaration
func main() {
    name := "Alice"
    name := "Bob"  // Error: no new variables on left side
}

// ✅ Correct - use = for reassignment
func main() {
    name := "Alice"
    name = "Bob"   // Reassignment, not declaration
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Mixing types without conversion</h4>
                                        <pre><code class="language-go">// ❌ Wrong - type mismatch
var x int = 10
var y float64 = 3.14
result := x + y  // Error: mismatched types

// ✅ Correct - explicit conversion
var x int = 10
var y float64 = 3.14
result := float64(x) + y  // Works!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Unused variables</h4>
                                        <pre><code class="language-go">// ❌ Wrong - declared but not used
func main() {
    name := "Alice"  // Error: name declared but not used
    fmt.Println("Hello")
}

// ✅ Correct - use the variable or remove it
func main() {
    name := "Alice"
    fmt.Println(name)  // Now it's used
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Temperature Converter</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a program that converts temperatures between
                                            Celsius and
                                            Fahrenheit.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Declare a variable for Celsius temperature (use 25.0)</li>
                                            <li>Convert to Fahrenheit using the formula: F = C × 9/5 + 32</li>
                                            <li>Print both temperatures with proper labels</li>
                                            <li>Use appropriate types (float64)</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

func main() {
    // Celsius temperature
    celsius := 25.0
    
    // Convert to Fahrenheit
    fahrenheit := celsius * 9/5 + 32
    
    // Print results
    fmt.Printf("%.1f°C = %.1f°F\n", celsius, fahrenheit)
    
    // Bonus: Convert back to verify
    celsiusCheck := (fahrenheit - 32) * 5/9
    fmt.Printf("%.1f°F = %.1f°C\n", fahrenheit, celsiusCheck)
    
    // Type information
    fmt.Printf("\nType of celsius: %T\n", celsius)
    fmt.Printf("Type of fahrenheit: %T\n", fahrenheit)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>var keyword</strong> declares variables with explicit types</li>
                                            <li><strong>:= operator</strong> provides short declaration with type
                                                inference (functions
                                                only)</li>
                                            <li><strong>Zero values</strong> ensure variables are always initialized (0,
                                                false, "", nil)
                                            </li>
                                            <li><strong>Type comes after</strong> the variable name in Go</li>
                                            <li><strong>Static typing</strong> means types are checked at compile time
                                            </li>
                                            <li><strong>Type inference</strong> automatically determines types from
                                                values</li>
                                            <li><strong>Explicit conversion</strong> required between different types
                                            </li>
                                            <li><strong>Unused variables</strong> cause compilation errors</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand variables and types, you're ready to learn about
                                        <strong>Constants &
                                            Operators</strong>. In the next lesson, you'll discover how to define
                                        immutable values and
                                        perform operations on your data.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="hello-world.jsp" />
                                    <jsp:param name="prevTitle" value="Hello World & Workspace" />
                                    <jsp:param name="nextLink" value="constants-operators.jsp" />
                                    <jsp:param name="nextTitle" value="Constants & Operators" />
                                    <jsp:param name="currentLessonId" value="variables-types" />
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