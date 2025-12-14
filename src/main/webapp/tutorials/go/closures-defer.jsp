<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "closures-defer" ); request.setAttribute("currentModule", "Functions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Closures & Defer in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go closures, anonymous functions, defer statement, and resource cleanup. Master advanced function concepts with interactive examples.">
            <meta name="keywords"
                content="go closures, golang closures, go defer, go anonymous functions, go resource cleanup, go defer statement">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Closures & Defer in Go">
            <meta property="og:description" content="Master Go closures and defer for advanced function patterns.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/closures-defer.jsp">
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
    "name": "Closures & Defer in Go",
    "description": "Learn Go closures, anonymous functions, and defer statement with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/closures-defer.jsp",
    "teaches": ["closures", "anonymous functions", "defer", "resource cleanup"],
    "timeRequired": "PT30M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="closures-defer">
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
                                    <span>Closures & Defer</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Closures & Defer</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Closures and defer are powerful features in Go. Closures allow
                                        functions to
                                        capture and use variables from their surrounding scope, while defer ensures
                                        cleanup code runs
                                        at the right time. Together, they enable elegant patterns for resource
                                        management and
                                        functional programming.</p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-closures-defer.svg"
                                            alt="Closures and Defer in Go - Side by Side Comparison"
                                            class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Closures vs Defer - Two powerful Go features
                                            for advanced function patterns and resource management</p>
                                    </div>

                                    <!-- Section 1: Anonymous Functions -->
                                    <h2>Anonymous Functions</h2>
                                    <p>Anonymous functions are functions without a name. They can be defined inline and
                                        assigned to
                                        variables:</p>

                                    <pre><code class="language-go">func main() {
    // Anonymous function assigned to variable
    greet := func(name string) {
        fmt.Printf("Hello, %s!\n", name)
    }
    
    greet("Alice")  // Hello, Alice!
    
    // Immediately invoked function
    func(msg string) {
        fmt.Println(msg)
    }("This runs immediately!")
}</code></pre>

                                    <div class="info-box">
                                        <strong>Anonymous Function Uses:</strong>
                                        <ul>
                                            <li>One-time operations</li>
                                            <li>Callbacks</li>
                                            <li>Goroutines (concurrent functions)</li>
                                            <li>Creating closures</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Closures -->
                                    <h2>Closures</h2>
                                    <p>A closure is a function that references variables from outside its body. The
                                        function "closes
                                        over" these variables:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/closures-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-closures" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>How Closures Work:</strong>
                                        <ul>
                                            <li>The inner function can access variables from the outer function</li>
                                            <li>Variables are "captured" by reference, not by value</li>
                                            <li>Each closure maintains its own copy of captured variables</li>
                                            <li>Captured variables persist as long as the closure exists</li>
                                        </ul>
                                    </div>

                                    <h3>Practical Example: Counter</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/closures-counter.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-counter" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Closures are perfect for creating factory functions
                                        that generate
                                        customized functions with specific behavior!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Defer Statement -->
                                    <h2>The Defer Statement</h2>
                                    <p>The <code>defer</code> keyword schedules a function call to run after the
                                        surrounding function
                                        returns:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/defer-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-defer" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Defer Rules:</strong>
                                        <ul>
                                            <li>Deferred calls are executed in <strong>LIFO</strong> order (last in,
                                                first out)</li>
                                            <li>Arguments are evaluated immediately, but the call is delayed</li>
                                            <li>Runs even if the function panics</li>
                                            <li>Perfect for cleanup operations</li>
                                        </ul>
                                    </div>

                                    <h3>Common Use: Resource Cleanup</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/defer-file.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-defer-file" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Always defer cleanup operations (closing files,
                                        unlocking
                                        mutexes, etc.) immediately after acquiring the resource. This ensures cleanup
                                        happens even if
                                        an error occurs!
                                    </div>

                                    <h3>Defer Execution Order</h3>
                                    <pre><code class="language-go">func main() {
    defer fmt.Println("First defer")
    defer fmt.Println("Second defer")
    defer fmt.Println("Third defer")
    fmt.Println("Main function")
}

// Output:
// Main function
// Third defer
// Second defer
// First defer</code></pre>

                                    <!-- Section 4: Defer with Arguments -->
                                    <h2>Defer with Arguments</h2>
                                    <p>When you defer a function, its arguments are evaluated immediately:</p>

                                    <pre><code class="language-go">func main() {
    x := 10
    
    // Arguments evaluated now (x = 10)
    defer fmt.Println("Deferred:", x)
    
    x = 20
    fmt.Println("Current:", x)
}

// Output:
// Current: 20
// Deferred: 10  (uses the value when defer was called)</code></pre>

                                    <h3>Using Closures with Defer</h3>
                                    <p>To capture the final value, use a closure:</p>

                                    <pre><code class="language-go">func main() {
    x := 10
    
    // Closure captures x by reference
    defer func() {
        fmt.Println("Deferred:", x)
    }()
    
    x = 20
    fmt.Println("Current:", x)
}

// Output:
// Current: 20
// Deferred: 20  (uses the final value)</code></pre>

                                    <!-- Section 5: Practical Patterns -->
                                    <h2>Practical Patterns</h2>

                                    <h3>1. Timing Function Execution</h3>
                                    <pre><code class="language-go">func timeTrack(start time.Time, name string) {
    elapsed := time.Since(start)
    fmt.Printf("%s took %s\n", name, elapsed)
}

func slowFunction() {
    defer timeTrack(time.Now(), "slowFunction")
    // Function body
    time.Sleep(2 * time.Second)
}</code></pre>

                                    <h3>2. Mutex Locking</h3>
                                    <pre><code class="language-go">var mu sync.Mutex
var balance int

func deposit(amount int) {
    mu.Lock()
    defer mu.Unlock()  // Ensures unlock even if panic occurs
    
    balance += amount
}</code></pre>

                                    <h3>3. Database Transactions</h3>
                                    <pre><code class="language-go">func updateUser(db *sql.DB, user User) error {
    tx, err := db.Begin()
    if err != nil {
        return err
    }
    defer tx.Rollback()  // Rollback if commit not called
    
    // Perform updates...
    
    return tx.Commit()  // Commit overrides rollback
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Defer in a loop</h4>
                                        <pre><code class="language-go">// ❌ Wrong - defers accumulate, files stay open
func processFiles(files []string) {
    for _, filename := range files {
        f, _ := os.Open(filename)
        defer f.Close()  // Won't close until function ends!
        // Process file...
    }
}

// ✅ Correct - use a separate function
func processFiles(files []string) {
    for _, filename := range files {
        processFile(filename)
    }
}

func processFile(filename string) {
    f, _ := os.Open(filename)
    defer f.Close()  // Closes when processFile returns
    // Process file...
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Ignoring defer return values</h4>
                                        <pre><code class="language-go">// ❌ Wrong - error from Close is ignored
func readFile(filename string) error {
    f, err := os.Open(filename)
    if err != nil {
        return err
    }
    defer f.Close()  // Error ignored!
    
    // Read file...
    return nil
}

// ✅ Correct - check error in named return
func readFile(filename string) (err error) {
    f, err := os.Open(filename)
    if err != nil {
        return err
    }
    defer func() {
        if cerr := f.Close(); cerr != nil && err == nil {
            err = cerr
        }
    }()
    
    // Read file...
    return nil
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Closure variable capture in loops</h4>
                                        <pre><code class="language-go">// ❌ Wrong - all closures reference same variable
for i := 0; i < 3; i++ {
    defer func() {
        fmt.Println(i)  // All print 3!
    }()
}

// ✅ Correct - pass as parameter
for i := 0; i < 3; i++ {
    defer func(n int) {
        fmt.Println(n)  // Prints 2, 1, 0
    }(i)
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Function Timer</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a reusable function timer using defer and
                                            closures.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a <code>timer()</code> function that returns a cleanup function
                                            </li>
                                            <li>Use defer to call the cleanup function</li>
                                            <li>Measure and print execution time</li>
                                            <li>Test with a slow function (use time.Sleep)</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
    "time"
)

// timer returns a function that prints elapsed time
func timer(name string) func() {
    start := time.Now()
    return func() {
        elapsed := time.Since(start)
        fmt.Printf("%s took %v\n", name, elapsed)
    }
}

// Example slow function
func slowOperation() {
    defer timer("slowOperation")()  // Note the ()()
    
    fmt.Println("Starting slow operation...")
    time.Sleep(2 * time.Second)
    fmt.Println("Operation complete!")
}

// Alternative: using named return
func fastOperation() {
    stop := timer("fastOperation")
    defer stop()
    
    fmt.Println("Fast operation")
    time.Sleep(500 * time.Millisecond)
}

func main() {
    slowOperation()
    fmt.Println()
    fastOperation()
}

// Bonus: Generic timer with closure
func measure(fn func()) time.Duration {
    start := time.Now()
    fn()
    return time.Since(start)
}

func exampleUsage() {
    duration := measure(func() {
        time.Sleep(1 * time.Second)
    })
    fmt.Printf("Took: %v\n", duration)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Anonymous functions</strong> are functions without names</li>
                                            <li><strong>Closures</strong> capture variables from their surrounding scope
                                            </li>
                                            <li><strong>Closures maintain state</strong> across multiple calls</li>
                                            <li><strong>defer</strong> schedules function calls to run after the
                                                function returns</li>
                                            <li><strong>Deferred calls execute in LIFO order</strong> (last in, first
                                                out)</li>
                                            <li><strong>defer is perfect for cleanup</strong> (closing files, unlocking
                                                mutexes)</li>
                                            <li><strong>Arguments to defer</strong> are evaluated immediately</li>
                                            <li><strong>Use closures with defer</strong> to capture final values</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand closures and defer, you're ready to learn about
                                        <strong>Panic &
                                            Recover</strong>. In the next lesson, you'll discover Go's approach to
                                        handling
                                        exceptional situations and recovering from runtime errors.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="functions-returns.jsp" />
                                    <jsp:param name="prevTitle" value="Functions & Returns" />
                                    <jsp:param name="nextLink" value="panic-recover.jsp" />
                                    <jsp:param name="nextTitle" value="Panic & Recover" />
                                    <jsp:param name="currentLessonId" value="closures-defer" />
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