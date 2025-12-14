<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "functions-returns" ); request.setAttribute("currentModule", "Functions" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Functions & Returns in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go functions, parameters, return values, multiple returns, named returns, and variadic functions. Master function basics with interactive examples.">
            <meta name="keywords"
                content="go functions, golang functions, go return values, go multiple returns, go variadic functions, go named returns, go function parameters">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Functions & Returns in Go">
            <meta property="og:description"
                content="Master Go functions with parameters, returns, and variadic functions.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/functions-returns.jsp">
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
    "name": "Functions & Returns in Go",
    "description": "Learn Go functions, parameters, return values, multiple returns, and variadic functions.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/functions-returns.jsp",
    "teaches": ["functions", "parameters", "return values", "multiple returns", "named returns", "variadic functions"],
    "timeRequired": "PT35M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="functions-returns">
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
                                    <span>Functions & Returns</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Functions & Returns</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Functions are reusable blocks of code that perform specific tasks.
                                        In this
                                        lesson, you'll learn how to define functions, pass parameters, return values,
                                        and use Go's
                                        unique features like multiple return values and variadic parameters.</p>

                                    <!-- Section 1: Function Basics -->
                                    <h2>Function Basics</h2>
                                    <p>A function is declared using the <code>func</code> keyword:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/functions-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-func-basic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Function Syntax:</strong>
                                        <pre><code class="language-go">func functionName(param1 type1, param2 type2) returnType {
    // function body
    return value
}</code></pre>
                                        <ul>
                                            <li><code>func</code> - keyword to declare a function</li>
                                            <li><code>functionName</code> - name of the function</li>
                                            <li><code>parameters</code> - input values (optional)</li>
                                            <li><code>returnType</code> - type of value returned (optional)</li>
                                        </ul>
                                    </div>

                                    <h3>Functions Without Return Values</h3>
                                    <pre><code class="language-go">func greet(name string) {
    fmt.Printf("Hello, %s!\n", name)
}

func main() {
    greet("Alice")  // Hello, Alice!
}</code></pre>

                                    <h3>Functions With Return Values</h3>
                                    <pre><code class="language-go">func add(a int, b int) int {
    return a + b
}

func main() {
    result := add(5, 3)
    fmt.Println(result)  // 8
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> If consecutive parameters have the same type, you can
                                        omit the type
                                        for all but the last: <code>func add(a, b int) int</code>
                                    </div>

                                    <!-- Section 2: Multiple Return Values -->
                                    <h2>Multiple Return Values</h2>
                                    <p>One of Go's most powerful features is the ability to return multiple values from
                                        a function:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/functions-multiple-return.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-multiple-return" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Multiple Returns Syntax:</strong>
                                        <pre><code class="language-go">func functionName(params) (type1, type2, type3) {
    return value1, value2, value3
}</code></pre>
                                    </div>

                                    <h3>Common Pattern: Returning Error</h3>
                                    <p>The most common use of multiple returns is returning a value and an error:</p>

                                    <pre><code class="language-go">func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func main() {
    result, err := divide(10, 2)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Println("Result:", result)
}</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> In Go, errors are returned as values, not thrown
                                        as
                                        exceptions. Always check the error before using the result!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Named Return Values -->
                                    <h2>Named Return Values</h2>
                                    <p>You can name return values in the function signature. Named returns are
                                        automatically
                                        initialized to their zero values:</p>

                                    <pre><code class="language-go">func split(sum int) (x, y int) {
    x = sum * 4 / 9
    y = sum - x
    return  // "naked" return
}

func main() {
    a, b := split(17)
    fmt.Println(a, b)  // 7 10
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Caution:</strong> Naked returns (return without values) can reduce
                                        readability in
                                        longer functions. Use them only in short functions.
                                    </div>

                                    <h3>Named Returns for Documentation</h3>
                                    <pre><code class="language-go">// Named returns make the function signature self-documenting
func getCoordinates() (x, y, z float64) {
    x = 10.5
    y = 20.3
    z = 5.7
    return
}

// vs unnamed returns (less clear)
func getCoordinates() (float64, float64, float64) {
    return 10.5, 20.3, 5.7
}</code></pre>

                                    <!-- Section 4: Variadic Functions -->
                                    <h2>Variadic Functions</h2>
                                    <p>Variadic functions accept a variable number of arguments:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/functions-variadic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-variadic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Variadic Syntax:</strong>
                                        <pre><code class="language-go">func functionName(args ...type) {
    // args is a slice of type
}</code></pre>
                                        <ul>
                                            <li>The <code>...</code> before the type makes it variadic</li>
                                            <li>Inside the function, args is a slice</li>
                                            <li>Must be the last parameter</li>
                                        </ul>
                                    </div>

                                    <h3>Passing a Slice to Variadic Function</h3>
                                    <pre><code class="language-go">func sum(numbers ...int) int {
    total := 0
    for _, num := range numbers {
        total += num
    }
    return total
}

func main() {
    // Pass individual values
    fmt.Println(sum(1, 2, 3))  // 6
    
    // Pass a slice using ...
    nums := []int{1, 2, 3, 4, 5}
    fmt.Println(sum(nums...))  // 15
}</code></pre>

                                    <!-- Section 5: Function Parameters -->
                                    <h2>Function Parameters</h2>

                                    <h3>Pass by Value</h3>
                                    <p>Go passes arguments by value (copies the value):</p>

                                    <pre><code class="language-go">func modify(x int) {
    x = 100  // Only modifies the copy
}

func main() {
    num := 5
    modify(num)
    fmt.Println(num)  // Still 5
}</code></pre>

                                    <h3>Pass by Reference (Using Pointers)</h3>
                                    <p>To modify the original value, pass a pointer:</p>

                                    <pre><code class="language-go">func modify(x *int) {
    *x = 100  // Modifies the original
}

func main() {
    num := 5
    modify(&num)
    fmt.Println(num)  // Now 100
}</code></pre>

                                    <!-- Function Types -->
                                    <h2>Functions as Values</h2>
                                    <p>Functions are first-class citizens in Go—they can be assigned to variables:</p>

                                    <pre><code class="language-go">func main() {
    // Assign function to variable
    add := func(a, b int) int {
        return a + b
    }
    
    result := add(5, 3)
    fmt.Println(result)  // 8
    
    // Pass function as argument
    operate(10, 5, add)
}

func operate(a, b int, op func(int, int) int) {
    result := op(a, b)
    fmt.Println("Result:", result)
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Ignoring return values</h4>
                                        <pre><code class="language-go">// ❌ Wrong - ignoring error
result, _ := divide(10, 0)  // Don't ignore errors!
fmt.Println(result)

// ✅ Correct - check errors
result, err := divide(10, 0)
if err != nil {
    fmt.Println("Error:", err)
    return
}
fmt.Println(result)</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Wrong number of return values</h4>
                                        <pre><code class="language-go">// ❌ Wrong - function returns 2 values
func getValues() (int, int) {
    return 5, 10
}

x := getValues()  // Error: multiple-value in single-value context

// ✅ Correct - capture both values
x, y := getValues()
// Or ignore one
x, _ := getValues()</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Modifying parameters expecting change</h4>
                                        <pre><code class="language-go">// ❌ Wrong - won't modify original
func double(x int) {
    x = x * 2
}

num := 5
double(num)
fmt.Println(num)  // Still 5

// ✅ Correct - use pointer or return value
func double(x *int) {
    *x = *x * 2
}

num := 5
double(&num)
fmt.Println(num)  // 10</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Variadic parameter not last</h4>
                                        <pre><code class="language-go">// ❌ Wrong - variadic must be last
func process(nums ...int, name string) {
    // Error!
}

// ✅ Correct - variadic parameter last
func process(name string, nums ...int) {
    // OK
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Statistics Calculator</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create functions to calculate statistics for a set of
                                            numbers.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a variadic function <code>average</code> that calculates the mean
                                            </li>
                                            <li>Create a function <code>minMax</code> that returns both minimum and
                                                maximum</li>
                                            <li>Test with the numbers: 5, 2, 8, 1, 9, 3</li>
                                            <li>Print average, min, and max</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

// Calculate average of numbers
func average(numbers ...float64) float64 {
    if len(numbers) == 0 {
        return 0
    }
    
    sum := 0.0
    for _, num := range numbers {
        sum += num
    }
    return sum / float64(len(numbers))
}

// Find minimum and maximum
func minMax(numbers ...float64) (min, max float64) {
    if len(numbers) == 0 {
        return 0, 0
    }
    
    min = numbers[0]
    max = numbers[0]
    
    for _, num := range numbers {
        if num < min {
            min = num
        }
        if num > max {
            max = num
        }
    }
    return
}

func main() {
    numbers := []float64{5, 2, 8, 1, 9, 3}
    
    // Calculate average
    avg := average(numbers...)
    fmt.Printf("Average: %.2f\n", avg)
    
    // Find min and max
    min, max := minMax(numbers...)
    fmt.Printf("Min: %.2f, Max: %.2f\n", min, max)
    
    // Bonus: Calculate range
    rangeValue := max - min
    fmt.Printf("Range: %.2f\n", rangeValue)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Functions</strong> are declared with the <code>func</code>
                                                keyword</li>
                                            <li><strong>Parameters</strong> are passed by value (copied)</li>
                                            <li><strong>Multiple return values</strong> are a key Go feature</li>
                                            <li><strong>Error handling</strong> uses return values, not exceptions</li>
                                            <li><strong>Named returns</strong> can improve readability</li>
                                            <li><strong>Variadic functions</strong> accept variable number of arguments
                                            </li>
                                            <li><strong>Functions are values</strong> and can be assigned to variables
                                            </li>
                                            <li><strong>Use pointers</strong> to modify original values</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand basic functions, you're ready to learn about
                                        <strong>Closures &
                                            Defer</strong>. In the next lesson, you'll discover anonymous functions,
                                        closures, and
                                        the defer statement for resource cleanup.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="loops-range.jsp" />
                                    <jsp:param name="prevTitle" value="Loops & Range" />
                                    <jsp:param name="nextLink" value="closures-defer.jsp" />
                                    <jsp:param name="nextTitle" value="Closures & Defer" />
                                    <jsp:param name="currentLessonId" value="functions-returns" />
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