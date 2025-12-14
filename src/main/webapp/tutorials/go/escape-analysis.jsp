<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "escape-analysis" ); request.setAttribute("currentModule", "Advanced" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Escape Analysis in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Go escape analysis: understand when variables escape to heap, use compiler flags to analyze code, and optimize for stack allocation.">
            <meta name="keywords"
                content="go escape analysis, golang heap stack, gcflags, compiler optimization, memory allocation">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Escape Analysis in Go">
            <meta property="og:description" content="Learn Go's escape analysis and optimize memory allocation.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/escape-analysis.jsp">
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
    "name": "Escape Analysis in Go",
    "description": "Learn Go's escape analysis to optimize memory allocation and performance.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/escape-analysis.jsp",
    "teaches": ["Escape Analysis", "Stack Allocation", "Heap Allocation", "Compiler Optimization", "Performance"],
    "timeRequired": "PT40M"
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="escape-analysis">
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
                                    <span>Escape Analysis</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Escape Analysis</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Escape analysis is the compiler's process of determining whether a
                                        variable can
                                        be safely allocated on the stack or must "escape" to the heap. Understanding
                                        escape analysis
                                        helps you write more efficient Go code by minimizing heap allocations and
                                        reducing garbage
                                        collection pressure.</p>

                                    <!-- Section 1: What is Escape Analysis -->
                                    <h2>What is Escape Analysis?</h2>
                                    <p>The Go compiler analyzes your code to determine the lifetime and scope of
                                        variables. If a
                                        variable's lifetime is limited to a function's scope, it can be allocated on the
                                        stack.
                                        Otherwise, it "escapes" to the heap.</p>

                                    <div class="info-box">
                                        <strong>Escape Analysis Determines:</strong>
                                        <ul>
                                            <li><strong>Stack allocation</strong> - Fast, automatic cleanup</li>
                                            <li><strong>Heap allocation</strong> - Slower, requires garbage collection
                                            </li>
                                            <li><strong>Performance impact</strong> - Stack is ~10-100x faster</li>
                                        </ul>
                                    </div>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-escape-analysis.png"
                                            alt="Go Escape Analysis Decision Flow" class="tutorial-diagram">
                                        <p class="diagram-caption">Escape Analysis: How Go decides between stack and
                                            heap allocation</p>
                                    </div>

                                    <h3>Using the Compiler Flag</h3>
                                    <p>View escape analysis with the <code>-gcflags='-m'</code> flag:</p>

                                    <pre><code class="language-bash"># Basic escape analysis
go build -gcflags='-m' yourfile.go

# Detailed analysis (more verbose)
go build -gcflags='-m -m' yourfile.go

# Very detailed (all optimizations)
go build -gcflags='-m -m -m' yourfile.go</code></pre>

                                    <div class="tip-box">
                                        <strong>Reading the Output:</strong>
                                        <ul>
                                            <li><code>moved to heap: x</code> - Variable x allocated on heap</li>
                                            <li><code>x escapes to heap</code> - Variable x must be on heap</li>
                                            <li><code>x does not escape</code> - Variable x stays on stack</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Basic Escape Scenarios -->
                                    <h2>Basic Escape Scenarios</h2>
                                    <p>Let's explore common cases where variables escape or stay on the stack:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/escape-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-escape-basic" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Scenario</th>
                                                <th>Location</th>
                                                <th>Reason</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Return value</td>
                                                <td>✅ Stack</td>
                                                <td>Copied to caller's stack</td>
                                            </tr>
                                            <tr>
                                                <td>Return pointer</td>
                                                <td>❌ Heap</td>
                                                <td>Outlives function scope</td>
                                            </tr>
                                            <tr>
                                                <td>Small struct</td>
                                                <td>✅ Stack</td>
                                                <td>Fits in stack frame</td>
                                            </tr>
                                            <tr>
                                                <td>Large struct</td>
                                                <td>❌ Heap</td>
                                                <td>Too large for stack</td>
                                            </tr>
                                            <tr>
                                                <td>Fixed-size slice</td>
                                                <td>✅ Stack</td>
                                                <td>Size known at compile time</td>
                                            </tr>
                                            <tr>
                                                <td>Dynamic slice</td>
                                                <td>❌ Heap</td>
                                                <td>Size unknown at compile time</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Pointer Escapes -->
                                    <h2>Pointer Escape Scenarios</h2>
                                    <p>Pointers are a common cause of escape to heap:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/escape-pointers.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-escape-pointers" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Pointer Escape Rules:</strong>
                                        <ul>
                                            <li>Returning a pointer to a local variable causes escape</li>
                                            <li>Storing a pointer in a parameter causes escape</li>
                                            <li>Putting a pointer in a struct that escapes causes escape</li>
                                            <li>Pointer slices cause all elements to escape</li>
                                        </ul>
                                    </div>

                                    <!-- Section 4: Interface Escapes -->
                                    <h2>Interface Escape Scenarios</h2>
                                    <p>Converting to <code>interface{}</code> almost always causes escape:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/escape-interfaces.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-escape-interfaces" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Why Interfaces Cause Escape:</strong>
                                        <ul>
                                            <li>Interface values contain a pointer to the actual value</li>
                                            <li>Compiler can't know the concrete type at compile time</li>
                                            <li>Value must be on heap to ensure it outlives the interface</li>
                                            <li>Type assertions don't prevent the initial escape</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Closure Escapes -->
                                    <h2>Closure Escape Scenarios</h2>
                                    <p>Closures capture variables, causing them to escape:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/escape-closures.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-escape-closures" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Closure Best Practices:</strong>
                                        <ul>
                                            <li>Captured variables always escape to heap</li>
                                            <li>In loops, create a new variable for each iteration</li>
                                            <li>Minimize closures in performance-critical code</li>
                                            <li>Consider passing values as parameters instead</li>
                                        </ul>
                                    </div>

                                    <!-- Section 6: Optimization Techniques -->
                                    <h2>Preventing Unnecessary Escapes</h2>
                                    <p>Techniques to keep variables on the stack:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/escape-optimization.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-escape-optimization" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Optimization Checklist:</strong>
                                        <ul>
                                            <li>✓ Return values instead of pointers for small types</li>
                                            <li>✓ Use concrete types instead of <code>interface{}</code></li>
                                            <li>✓ Preallocate slices with known capacity</li>
                                            <li>✓ Avoid unnecessary closures</li>
                                            <li>✓ Use pointer receivers only for large structs</li>
                                            <li>✓ Profile with <code>-gcflags='-m'</code> to verify</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Returning pointer to local variable</h4>
                                        <pre><code class="language-go">// ❌ Wrong - x escapes unnecessarily
func getPointer() *int {
    x := 42
    return &x // x must be on heap
}

// ✅ Correct - return by value
func getValue() int {
    x := 42
    return x // stays on stack
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using interface{} when not needed</h4>
                                        <pre><code class="language-go">// ❌ Wrong - causes escape
func process(v interface{}) {
    fmt.Println(v) // v escaped to heap
}

// ✅ Correct - use concrete type
func process(v int) {
    fmt.Println(v) // no escape
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Closure in loop without new variable</h4>
                                        <pre><code class="language-go">// ❌ Wrong - all closures share same i
for i := 0; i < 10; i++ {
    go func() {
        fmt.Println(i) // i escapes, all print 10
    }()
}

// ✅ Correct - create new variable
for i := 0; i < 10; i++ {
    i := i // new variable for each iteration
    go func() {
        fmt.Println(i) // prints 0-9
    }()
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Optimize for Stack Allocation</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Refactor code to minimize heap allocations.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Analyze with <code>-gcflags='-m'</code></li>
                                            <li>Reduce heap allocations by 50%</li>
                                            <li>Maintain functionality</li>
                                            <li>Document changes</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

// ❌ Original - many escapes
type DataBad struct {
    values []int
}

func processBad(data interface{}) *DataBad {
    d := &DataBad{
        values: make([]int, 0),
    }
    
    for i := 0; i < 100; i++ {
        d.values = append(d.values, i)
    }
    
    return d
}

// ✅ Optimized - fewer escapes
type DataGood struct {
    values []int
}

func processGood(size int) DataGood {
    d := DataGood{
        values: make([]int, 0, size), // Preallocate
    }
    
    for i := 0; i < size; i++ {
        d.values = append(d.values, i)
    }
    
    return d // Return by value for small structs
}

func main() {
    // Bad version
    fmt.Println("Bad version:")
    bad := processBad(100)
    fmt.Printf("Length: %d\n\n", len(bad.values))
    
    // Good version
    fmt.Println("Good version:")
    good := processGood(100)
    fmt.Printf("Length: %d\n\n", len(good.values))
    
    fmt.Println("Improvements:")
    fmt.Println("  • Removed interface{} parameter")
    fmt.Println("  • Preallocated slice capacity")
    fmt.Println("  • Return by value instead of pointer")
    fmt.Println("  • Reduced heap allocations by ~60%")
    
    fmt.Println("\nVerify with:")
    fmt.Println("  go build -gcflags='-m' solution.go")
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Escape analysis</strong> determines stack vs heap allocation
                                            </li>
                                            <li><strong>Stack allocation</strong> is fast and automatic</li>
                                            <li><strong>Heap allocation</strong> requires garbage collection</li>
                                            <li><strong>-gcflags='-m'</strong> shows escape analysis</li>
                                            <li><strong>Pointers</strong> to locals escape to heap</li>
                                            <li><strong>Interfaces</strong> cause values to escape</li>
                                            <li><strong>Closures</strong> capture variables on heap</li>
                                            <li><strong>Return values</strong> instead of pointers when possible</li>
                                            <li><strong>Preallocate</strong> slices to avoid escapes</li>
                                            <li><strong>Profile</strong> to verify optimizations</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered escape analysis! Understanding when and why variables escape
                                        helps you write
                                        more efficient Go code. In future lessons, you'll explore more advanced topics
                                        like CGO,
                                        the unsafe package, and compiler optimizations.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="memory-management.jsp" />
                                    <jsp:param name="prevTitle" value="Memory Management" />
                                    <jsp:param name="nextLink" value="cgo-basics.jsp" />
                                    <jsp:param name="nextTitle" value="CGO Basics" />
                                    <jsp:param name="currentLessonId" value="escape-analysis" />
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