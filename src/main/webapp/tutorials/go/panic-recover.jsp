<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "panic-recover" ); request.setAttribute("currentModule", "Functions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Panic & Recover in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go panic and recover for error handling. Master exceptional situations, stack unwinding, and recovery patterns with interactive examples.">
            <meta name="keywords"
                content="go panic, golang panic, go recover, go error handling, go stack unwinding, go panic recover">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Panic & Recover in Go">
            <meta property="og:description" content="Master Go panic and recover for handling exceptional situations.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/panic-recover.jsp">
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
    "name": "Panic & Recover in Go",
    "description": "Learn Go panic and recover for handling exceptional situations with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/panic-recover.jsp",
    "teaches": ["panic", "recover", "error handling", "stack unwinding"],
    "timeRequired": "PT30M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="panic-recover">
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
                                    <span>Panic & Recover</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Panic & Recover</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">While Go prefers explicit error handling, it provides
                                        <code>panic</code> and
                                        <code>recover</code> for exceptional situations. In this lesson, you'll learn
                                        when to use
                                        panic, how to recover from panics, and best practices for error handling in Go.
                                    </p>

                                    <!-- Section 1: Understanding Panic -->
                                    <h2>What is Panic?</h2>
                                    <p>A panic is a runtime error that stops the normal execution of a program. When a
                                        function panics:
                                    </p>

                                    <ol>
                                        <li>The function stops executing</li>
                                        <li>Deferred functions are executed</li>
                                        <li>The panic propagates up the call stack</li>
                                        <li>The program crashes (unless recovered)</li>
                                    </ol>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/panic-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-panic" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Panic is <strong>not</strong> the same as exceptions
                                        in other
                                        languages. In Go, use errors for expected failures and panic only for truly
                                        exceptional
                                        situations!
                                    </div>

                                    <h3>When to Use Panic</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Use Panic For</th>
                                                <th>Use Error For</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Unrecoverable errors (out of memory)</td>
                                                <td>Expected failures (file not found)</td>
                                            </tr>
                                            <tr>
                                                <td>Programming errors (nil pointer)</td>
                                                <td>Validation errors</td>
                                            </tr>
                                            <tr>
                                                <td>Initialization failures</td>
                                                <td>Network errors</td>
                                            </tr>
                                            <tr>
                                                <td>Impossible situations</td>
                                                <td>User input errors</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 2: Recover -->
                                    <h2>Recovering from Panic</h2>
                                    <p>The <code>recover</code> function stops a panic and returns the value passed to
                                        panic:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/panic-recover.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-recover" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Recover Rules:</strong>
                                        <ul>
                                            <li><code>recover</code> only works inside deferred functions</li>
                                            <li>Returns <code>nil</code> if there's no panic</li>
                                            <li>Returns the panic value if recovering from a panic</li>
                                            <li>Stops the panic from propagating</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Panic vs Errors -->
                                    <h2>Panic vs Errors</h2>
                                    <p>Go philosophy: <strong>Errors are values, not exceptions</strong></p>

                                    <h3>❌ Don't Use Panic</h3>
                                    <pre><code class="language-go">// Bad: Using panic for expected errors
func divide(a, b float64) float64 {
    if b == 0 {
        panic("division by zero")  // Don't do this!
    }
    return a / b
}</code></pre>

                                    <h3>✅ Use Errors Instead</h3>
                                    <pre><code class="language-go">// Good: Return error for expected failures
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func main() {
    result, err := divide(10, 0)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Println("Result:", result)
}</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use errors for all expected failures. Reserve
                                        panic for
                                        situations where the program cannot continue (programming bugs, impossible
                                        states).
                                    </div>

                                    <!-- Section 4: Practical Patterns -->
                                    <h2>Practical Patterns</h2>

                                    <h3>1. Protecting Against Panics in Goroutines</h3>
                                    <pre><code class="language-go">func safeGoroutine(fn func()) {
    go func() {
        defer func() {
            if r := recover(); r != nil {
                fmt.Println("Recovered in goroutine:", r)
            }
        }()
        fn()
    }()
}

func main() {
    safeGoroutine(func() {
        panic("Something went wrong!")
    })
    
    time.Sleep(time.Second)
    fmt.Println("Main continues...")
}</code></pre>

                                    <h3>2. Cleanup with Defer and Recover</h3>
                                    <pre><code class="language-go">func processFile(filename string) (err error) {
    f, err := os.Open(filename)
    if err != nil {
        return err
    }
    
    defer func() {
        f.Close()
        if r := recover(); r != nil {
            err = fmt.Errorf("panic: %v", r)
        }
    }()
    
    // Process file (might panic)
    // ...
    
    return nil
}</code></pre>

                                    <h3>3. Must Functions (Initialization)</h3>
                                    <pre><code class="language-go">// Common pattern: "Must" functions panic on error
func MustCompile(pattern string) *regexp.Regexp {
    re, err := regexp.Compile(pattern)
    if err != nil {
        panic(err)
    }
    return re
}

// Used during initialization
var emailRegex = MustCompile(`^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$`)</code></pre>

                                    <!-- Section 5: Stack Traces -->
                                    <h2>Understanding Stack Traces</h2>
                                    <p>When a panic occurs, Go prints a stack trace:</p>

                                    <pre><code class="language-go">func level3() {
    panic("Something went wrong!")
}

func level2() {
    level3()
}

func level1() {
    level2()
}

func main() {
    level1()
}

// Output shows the call stack:
// panic: Something went wrong!
// 
// goroutine 1 [running]:
// main.level3()
//     /path/to/file.go:4
// main.level2()
//     /path/to/file.go:8
// main.level1()
//     /path/to/file.go:12
// main.main()
//     /path/to/file.go:16</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using panic for normal errors</h4>
                                        <pre><code class="language-go">// ❌ Wrong - panic for expected errors
func readConfig(filename string) Config {
    data, err := os.ReadFile(filename)
    if err != nil {
        panic(err)  // Don't panic for file errors!
    }
    // ...
}

// ✅ Correct - return error
func readConfig(filename string) (Config, error) {
    data, err := os.ReadFile(filename)
    if err != nil {
        return Config{}, err
    }
    // ...
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Recover outside defer</h4>
                                        <pre><code class="language-go">// ❌ Wrong - recover doesn't work here
func bad() {
    if r := recover(); r != nil {
        fmt.Println("Recovered:", r)
    }
    panic("Error!")
}

// ✅ Correct - recover in defer
func good() {
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("Recovered:", r)
        }
    }()
    panic("Error!")
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Swallowing panics silently</h4>
                                        <pre><code class="language-go">// ❌ Wrong - hiding panics
func bad() {
    defer func() {
        recover()  // Silently ignores panic!
    }()
    // ...
}

// ✅ Correct - log or handle panic
func good() {
    defer func() {
        if r := recover(); r != nil {
            log.Printf("Panic recovered: %v", r)
            // Take appropriate action
        }
    }()
    // ...
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Safe Division Calculator</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a safe calculator that handles panics
                                            gracefully.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a <code>safeDivide</code> function that uses recover</li>
                                            <li>Handle division by zero with recover</li>
                                            <li>Return both result and error</li>
                                            <li>Test with various inputs including zero</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
)

// safeDivide performs division with panic recovery
func safeDivide(a, b float64) (result float64, err error) {
    defer func() {
        if r := recover(); r != nil {
            err = fmt.Errorf("panic recovered: %v", r)
        }
    }()
    
    if b == 0 {
        panic("division by zero")
    }
    
    result = a / b
    return result, nil
}

// Better approach: use errors instead of panic
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, fmt.Errorf("cannot divide by zero")
    }
    return a / b, nil
}

func main() {
    // Test safeDivide
    fmt.Println("=== Using safeDivide (with panic/recover) ===")
    
    result, err := safeDivide(10, 2)
    if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Printf("10 / 2 = %.2f\n", result)
    }
    
    result, err = safeDivide(10, 0)
    if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Printf("10 / 0 = %.2f\n", result)
    }
    
    // Test divide (better approach)
    fmt.Println("\n=== Using divide (with errors) ===")
    
    result, err = divide(10, 2)
    if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Printf("10 / 2 = %.2f\n", result)
    }
    
    result, err = divide(10, 0)
    if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Printf("10 / 0 = %.2f\n", result)
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>panic</strong> stops normal execution and unwinds the stack</li>
                                            <li><strong>recover</strong> catches panics and returns the panic value</li>
                                            <li><strong>recover only works</strong> inside deferred functions</li>
                                            <li><strong>Use errors, not panic</strong> for expected failures</li>
                                            <li><strong>Panic is for exceptional situations</strong> only</li>
                                            <li><strong>Deferred functions run</strong> even during a panic</li>
                                            <li><strong>Must functions</strong> use panic for initialization errors</li>
                                            <li><strong>Always log recovered panics</strong> for debugging</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing the Functions module! You now understand functions,
                                        closures,
                                        defer, panic, and recover. Next, you'll learn about <strong>Data
                                            Structures</strong>,
                                        starting with arrays and slices—Go's powerful collection types.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="closures-defer.jsp" />
                                    <jsp:param name="prevTitle" value="Closures & Defer" />
                                    <jsp:param name="nextLink" value="arrays-slices.jsp" />
                                    <jsp:param name="nextTitle" value="Arrays & Slices" />
                                    <jsp:param name="currentLessonId" value="panic-recover" />
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