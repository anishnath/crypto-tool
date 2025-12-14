<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "constants-operators" ); request.setAttribute("currentModule", "Basics" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Constants & Operators in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go constants, iota, and operators. Master const keyword, enumerated constants, arithmetic, comparison, logical, and bitwise operators.">
            <meta name="keywords"
                content="go constants, golang constants, go iota, go operators, const keyword, go arithmetic operators, go comparison, go logical operators">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Constants & Operators in Go">
            <meta property="og:description" content="Master Go constants and operators with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/constants-operators.jsp">
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
    "name": "Constants & Operators in Go",
    "description": "Learn Go constants, iota, and all operator types with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/constants-operators.jsp",
    "teaches": ["Go constants", "const keyword", "iota", "Operators", "Arithmetic", "Comparison", "Logical", "Bitwise"],
    "timeRequired": "PT30M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="constants-operators">
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
                                    <span>Constants & Operators</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Constants & Operators</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Constants are immutable values that cannot be changed after
                                        declaration. In this
                                        lesson, you'll learn how to define constants, use the powerful <code>iota</code>
                                        identifier,
                                        and master all of Go's operators.</p>

                                    <!-- Section 1: Constants -->
                                    <h2>Constants in Go</h2>
                                    <p>Constants are declared using the <code>const</code> keyword. Unlike variables,
                                        constants
                                        cannot be changed once set:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/constants-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-const-basic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Points:</strong>
                                        <ul>
                                            <li>Constants are declared with <code>const</code></li>
                                            <li>They must be assigned at declaration time</li>
                                            <li>Values must be computable at compile time</li>
                                            <li>Can be typed or untyped</li>
                                        </ul>
                                    </div>

                                    <h3>Typed vs Untyped Constants</h3>
                                    <pre><code class="language-go">// Typed constant
const MaxUsers int = 100

// Untyped constant (more flexible)
const Pi = 3.14159

// Untyped constants can be used with different types
var radius float32 = 5.0
var area = Pi * radius * radius  // Pi adapts to float32</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use untyped constants when possible. They're
                                        more flexible
                                        and can be used in more contexts without explicit conversion.
                                    </div>

                                    <!-- Section 2: iota -->
                                    <h2>The iota Identifier</h2>
                                    <p><code>iota</code> is a special identifier used to create enumerated constants. It
                                        starts at 0
                                        and increments by 1 for each constant in a <code>const</code> block:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/constants-iota.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-iota" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>How iota Works:</strong>
                                        <ul>
                                            <li>Starts at 0 in each <code>const</code> block</li>
                                            <li>Increments by 1 for each line</li>
                                            <li>Resets to 0 in each new <code>const</code> block</li>
                                            <li>Can be used in expressions</li>
                                        </ul>
                                    </div>

                                    <h3>Advanced iota Patterns</h3>
                                    <pre><code class="language-go">// Skip values with blank identifier
const (
    _  = iota  // Skip 0
    KB = 1 << (10 * iota)  // 1024
    MB                      // 1048576
    GB                      // 1073741824
)

// Multiple constants per line
const (
    a, b = iota, iota + 10  // 0, 10
    c, d                     // 1, 11
    e, f                     // 2, 12
)</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Operators -->
                                    <h2>Operators in Go</h2>
                                    <p>Go provides a comprehensive set of operators for working with data:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/operators.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-operators" />
                                    </jsp:include>

                                    <h3>Arithmetic Operators</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Example</th>
                                                <th>Result</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>+</code></td>
                                                <td>Addition</td>
                                                <td><code>5 + 3</code></td>
                                                <td>8</td>
                                            </tr>
                                            <tr>
                                                <td><code>-</code></td>
                                                <td>Subtraction</td>
                                                <td><code>5 - 3</code></td>
                                                <td>2</td>
                                            </tr>
                                            <tr>
                                                <td><code>*</code></td>
                                                <td>Multiplication</td>
                                                <td><code>5 * 3</code></td>
                                                <td>15</td>
                                            </tr>
                                            <tr>
                                                <td><code>/</code></td>
                                                <td>Division</td>
                                                <td><code>10 / 3</code></td>
                                                <td>3 (integer division)</td>
                                            </tr>
                                            <tr>
                                                <td><code>%</code></td>
                                                <td>Modulus</td>
                                                <td><code>10 % 3</code></td>
                                                <td>1</td>
                                            </tr>
                                            <tr>
                                                <td><code>++</code></td>
                                                <td>Increment</td>
                                                <td><code>x++</code></td>
                                                <td>x = x + 1</td>
                                            </tr>
                                            <tr>
                                                <td><code>--</code></td>
                                                <td>Decrement</td>
                                                <td><code>x--</code></td>
                                                <td>x = x - 1</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Important:</strong> In Go, <code>++</code> and <code>--</code> are
                                        statements, not
                                        expressions. You can't use them in assignments: <code>y = x++</code> is invalid!
                                    </div>

                                    <h3>Comparison Operators</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Example</th>
                                                <th>Result</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>==</code></td>
                                                <td>Equal to</td>
                                                <td><code>5 == 5</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>!=</code></td>
                                                <td>Not equal to</td>
                                                <td><code>5 != 3</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;</code></td>
                                                <td>Greater than</td>
                                                <td><code>5 &gt; 3</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;</code></td>
                                                <td>Less than</td>
                                                <td><code>5 &lt; 3</code></td>
                                                <td>false</td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;=</code></td>
                                                <td>Greater than or equal</td>
                                                <td><code>5 &gt;= 5</code></td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;=</code></td>
                                                <td>Less than or equal</td>
                                                <td><code>5 &lt;= 3</code></td>
                                                <td>false</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Logical Operators</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Example</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>&&</code></td>
                                                <td>AND</td>
                                                <td><code>true && false</code></td>
                                                <td>true if both are true</td>
                                            </tr>
                                            <tr>
                                                <td><code>||</code></td>
                                                <td>OR</td>
                                                <td><code>true || false</code></td>
                                                <td>true if at least one is true</td>
                                            </tr>
                                            <tr>
                                                <td><code>!</code></td>
                                                <td>NOT</td>
                                                <td><code>!true</code></td>
                                                <td>Inverts the boolean value</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Bitwise Operators</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Example</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>&</code></td>
                                                <td>AND</td>
                                                <td><code>5 & 3</code></td>
                                                <td>Bitwise AND</td>
                                            </tr>
                                            <tr>
                                                <td><code>|</code></td>
                                                <td>OR</td>
                                                <td><code>5 | 3</code></td>
                                                <td>Bitwise OR</td>
                                            </tr>
                                            <tr>
                                                <td><code>^</code></td>
                                                <td>XOR</td>
                                                <td><code>5 ^ 3</code></td>
                                                <td>Bitwise XOR</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;&lt;</code></td>
                                                <td>Left shift</td>
                                                <td><code>5 &lt;&lt; 1</code></td>
                                                <td>Shift bits left</td>
                                            </tr>
                                            <tr>
                                                <td><code>&gt;&gt;</code></td>
                                                <td>Right shift</td>
                                                <td><code>5 &gt;&gt; 1</code></td>
                                                <td>Shift bits right</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Assignment Operators</h3>
                                    <pre><code class="language-go">x = 5      // Simple assignment
x += 3     // x = x + 3
x -= 2     // x = x - 2
x *= 4     // x = x * 4
x /= 2     // x = x / 2
x %=  3    // x = x % 3
x &= 3     // x = x & 3
x |= 3     // x = x | 3
x ^= 3     // x = x ^ 3
x <<= 2    // x = x << 2
x >>= 2    // x = x >> 2</code></pre>

                                    <!-- Operator Precedence -->
                                    <h2>Operator Precedence</h2>
                                    <p>When multiple operators appear in an expression, they're evaluated in order of
                                        precedence:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Precedence</th>
                                                <th>Operators</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Highest</td>
                                                <td><code>* / % &lt;&lt; &gt;&gt; & &</code></td>
                                            </tr>
                                            <tr>
                                                <td>↓</td>
                                                <td><code>+ - | ^</code></td>
                                            </tr>
                                            <tr>
                                                <td>↓</td>
                                                <td><code>== != &lt; &lt;= &gt; &gt;=</code></td>
                                            </tr>
                                            <tr>
                                                <td>↓</td>
                                                <td><code>&&</code></td>
                                            </tr>
                                            <tr>
                                                <td>Lowest</td>
                                                <td><code>||</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use parentheses to make your code clearer, even when
                                        not strictly
                                        necessary: <code>(a + b) * c</code> is more readable than
                                        <code>a + b * c</code>.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Trying to modify constants</h4>
                                        <pre><code class="language-go">// ❌ Wrong
const Pi = 3.14
Pi = 3.14159  // Error: cannot assign to Pi

// ✅ Correct - use variables for changing values
var pi = 3.14
pi = 3.14159  // OK</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using ++ or -- in expressions</h4>
                                        <pre><code class="language-go">// ❌ Wrong
x := 5
y := x++  // Error: syntax error

// ✅ Correct
x := 5
x++
y := x  // y = 6</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Integer division surprise</h4>
                                        <pre><code class="language-go">// ❌ Unexpected result
result := 5 / 2  // result = 2 (not 2.5!)

// ✅ Correct - use float for decimal division
result := 5.0 / 2.0  // result = 2.5
// or
result := float64(5) / float64(2)  // result = 2.5</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Circle Calculator</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a program that calculates circle properties.
                                        </p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Define a constant for Pi (3.14159)</li>
                                            <li>Create a variable for radius (use 5.0)</li>
                                            <li>Calculate circumference: 2 × π × r</li>
                                            <li>Calculate area: π × r²</li>
                                            <li>Print both results with labels</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

const Pi = 3.14159

func main() {
    radius := 5.0
    
    // Calculate circumference
    circumference := 2 * Pi * radius
    
    // Calculate area
    area := Pi * radius * radius
    
    // Print results
    fmt.Printf("Circle with radius %.1f:\n", radius)
    fmt.Printf("Circumference: %.2f\n", circumference)
    fmt.Printf("Area: %.2f\n", area)
    
    // Bonus: Calculate diameter
    diameter := 2 * radius
    fmt.Printf("Diameter: %.1f\n", diameter)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Constants</strong> are immutable values declared with
                                                <code>const</code></li>
                                            <li><strong>Untyped constants</strong> are more flexible than typed ones
                                            </li>
                                            <li><strong>iota</strong> creates enumerated constants starting at 0</li>
                                            <li><strong>Arithmetic operators</strong>: +, -, *, /, %, ++, --</li>
                                            <li><strong>Comparison operators</strong>: ==, !=, &lt;, &gt;, &lt;=, &gt;=
                                            </li>
                                            <li><strong>Logical operators</strong>: &&, ||, !</li>
                                            <li><strong>Bitwise operators</strong>: &, |, ^, &lt;&lt;, &gt;&gt;</li>
                                            <li><strong>++ and --</strong> are statements, not expressions in Go</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand constants and operators, you're ready to learn about
                                        <strong>Strings</strong>. In the next lesson, you'll discover how to work with
                                        text data,
                                        string operations, and Unicode in Go.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="variables-types.jsp" />
                                    <jsp:param name="prevTitle" value="Variables & Types" />
                                    <jsp:param name="nextLink" value="strings.jsp" />
                                    <jsp:param name="nextTitle" value="Strings" />
                                    <jsp:param name="currentLessonId" value="constants-operators" />
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