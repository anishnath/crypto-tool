<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "benchmarking" );
        request.setAttribute("currentModule", "Advanced & Professional" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Benchmarking in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go benchmarking, performance testing, profiling, optimization, and benchstat.">
            <meta name="keywords" content="go benchmarking, golang performance, go profiling, benchstat, optimization">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Benchmarking in Go">
            <meta property="og:description" content="Master Go benchmarking and performance optimization.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/benchmarking.jsp">
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
    "name": "Benchmarking in Go",
    "description": "Learn Go benchmarking and performance optimization.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/benchmarking.jsp",
    "teaches": ["benchmarking", "performance", "profiling", "optimization"],
    "timeRequired": "PT30M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="benchmarking">
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
                                    <span>Benchmarking</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Benchmarking</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Benchmarking measures code performance. Go's testing package
                                        includes built-in
                                        benchmarking tools. In this lesson, you'll learn to write benchmarks, analyze
                                        results, and
                                        optimize your code.</p>

                                    <!-- Section 1: Writing Benchmarks -->
                                    <h2>Writing Benchmarks</h2>

                                    <pre><code class="language-go">// fibonacci.go
package fib

func Fibonacci(n int) int {
    if n <= 1 {
        return n
    }
    return Fibonacci(n-1) + Fibonacci(n-2)
}

// fibonacci_test.go
package fib

import "testing"

func BenchmarkFibonacci(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Fibonacci(10)
    }
}

func BenchmarkFibonacci20(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Fibonacci(20)
    }
}</code></pre>

                                    <div class="info-box">
                                        <strong>Benchmark Rules:</strong>
                                        <ul>
                                            <li>Function name starts with <code>Benchmark</code></li>
                                            <li>Takes <code>*testing.B</code> parameter</li>
                                            <li>Loop <code>b.N</code> times (framework sets N)</li>
                                            <li>File name ends with <code>_test.go</code></li>
                                        </ul>
                                    </div>

                                    <h3>Running Benchmarks</h3>
                                    <pre><code class="language-bash"># Run all benchmarks
go test -bench=.

# Run specific benchmark
go test -bench=BenchmarkFibonacci

# Run with memory stats
go test -bench=. -benchmem

# Run for longer (more accurate)
go test -bench=. -benchtime=10s</code></pre>

                                    <!-- Section 2: Benchmark Output -->
                                    <h2>Understanding Benchmark Output</h2>

                                    <pre><code class="language-plaintext">BenchmarkFibonacci-8     3000000    450 ns/op    0 B/op    0 allocs/op
BenchmarkFibonacci20-8      5000  250000 ns/op    0 B/op    0 allocs/op</code></pre>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Column</th>
                                                <th>Meaning</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>BenchmarkFibonacci-8</code></td>
                                                <td>Benchmark name, 8 = GOMAXPROCS</td>
                                            </tr>
                                            <tr>
                                                <td><code>3000000</code></td>
                                                <td>Number of iterations (b.N)</td>
                                            </tr>
                                            <tr>
                                                <td><code>450 ns/op</code></td>
                                                <td>Time per operation</td>
                                            </tr>
                                            <tr>
                                                <td><code>0 B/op</code></td>
                                                <td>Bytes allocated per operation</td>
                                            </tr>
                                            <tr>
                                                <td><code>0 allocs/op</code></td>
                                                <td>Allocations per operation</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Benchmark Patterns -->
                                    <h2>Benchmark Patterns</h2>

                                    <h3>Table-Driven Benchmarks</h3>
                                    <pre><code class="language-go">func BenchmarkFibonacci(b *testing.B) {
    benchmarks := []struct {
        name string
        n    int
    }{
        {"Fib10", 10},
        {"Fib20", 20},
        {"Fib30", 30},
    }
    
    for _, bm := range benchmarks {
        b.Run(bm.name, func(b *testing.B) {
            for i := 0; i < b.N; i++ {
                Fibonacci(bm.n)
            }
        })
    }
}</code></pre>

                                    <h3>Resetting Timer</h3>
                                    <pre><code class="language-go">func BenchmarkWithSetup(b *testing.B) {
    // Expensive setup
    data := generateLargeDataset()
    
    b.ResetTimer()  // Don't count setup time
    
    for i := 0; i < b.N; i++ {
        process(data)
    }
}</code></pre>

                                    <h3>Stopping and Starting Timer</h3>
                                    <pre><code class="language-go">func BenchmarkWithPauses(b *testing.B) {
    for i := 0; i < b.N; i++ {
        b.StopTimer()
        // Expensive setup per iteration
        data := setup()
        b.StartTimer()
        
        // Actual code to benchmark
        process(data)
    }
}</code></pre>

                                    <!-- Section 4: Comparing Benchmarks -->
                                    <h2>Comparing Performance</h2>

                                    <h3>Example: String Concatenation</h3>
                                    <pre><code class="language-go">func BenchmarkStringConcat(b *testing.B) {
    for i := 0; i < b.N; i++ {
        s := ""
        for j := 0; j < 100; j++ {
            s += "x"
        }
    }
}

func BenchmarkStringBuilder(b *testing.B) {
    for i := 0; i < b.N; i++ {
        var sb strings.Builder
        for j := 0; j < 100; j++ {
            sb.WriteString("x")
        }
        _ = sb.String()
    }
}</code></pre>

                                    <h3>Using benchstat</h3>
                                    <pre><code class="language-bash"># Install benchstat
go install golang.org/x/perf/cmd/benchstat@latest

# Run benchmark before optimization
go test -bench=. -count=10 > old.txt

# Make changes, run again
go test -bench=. -count=10 > new.txt

# Compare
benchstat old.txt new.txt</code></pre>

                                    <!-- Section 5: Profiling -->
                                    <h2>Profiling</h2>

                                    <h3>CPU Profiling</h3>
                                    <pre><code class="language-bash"># Generate CPU profile
go test -bench=. -cpuprofile=cpu.prof

# Analyze with pprof
go tool pprof cpu.prof

# Commands in pprof:
# top - Show top functions
# list FunctionName - Show source
# web - Open in browser (requires graphviz)</code></pre>

                                    <h3>Memory Profiling</h3>
                                    <pre><code class="language-bash"># Generate memory profile
go test -bench=. -memprofile=mem.prof

# Analyze
go tool pprof mem.prof</code></pre>

                                    <h3>In-Code Profiling</h3>
                                    <pre><code class="language-go">import (
    "os"
    "runtime/pprof"
)

func main() {
    // CPU profiling
    f, _ := os.Create("cpu.prof")
    pprof.StartCPUProfile(f)
    defer pprof.StopCPUProfile()
    
    // Your code here
    
    // Memory profiling
    mf, _ := os.Create("mem.prof")
    pprof.WriteHeapProfile(mf)
    mf.Close()
}</code></pre>

                                    <!-- Section 6: Optimization Tips -->
                                    <h2>Optimization Tips</h2>

                                    <div class="best-practice-box">
                                        <strong>Optimization Rules:</strong>
                                        <ol>
                                            <li><strong>Measure first</strong> - Don't guess, benchmark!</li>
                                            <li><strong>Optimize hot paths</strong> - Focus on frequently called code
                                            </li>
                                            <li><strong>Avoid premature optimization</strong> - Clarity first, speed
                                                second</li>
                                            <li><strong>Use profiling</strong> - Find real bottlenecks</li>
                                            <li><strong>Benchmark changes</strong> - Verify improvements</li>
                                        </ol>
                                    </div>

                                    <h3>Common Optimizations</h3>
                                    <pre><code class="language-go">// 1. Reduce allocations
// ❌ Slow - allocates every time
func slow() []int {
    return []int{1, 2, 3}
}

// ✅ Fast - reuse slice
var pool = []int{1, 2, 3}
func fast() []int {
    return pool
}

// 2. Use sync.Pool for temporary objects
var bufferPool = sync.Pool{
    New: func() interface{} {
        return new(bytes.Buffer)
    },
}

func process() {
    buf := bufferPool.Get().(*bytes.Buffer)
    defer bufferPool.Put(buf)
    buf.Reset()
    // Use buf
}

// 3. Preallocate slices
// ❌ Slow - grows dynamically
s := []int{}
for i := 0; i < 1000; i++ {
    s = append(s, i)
}

// ✅ Fast - preallocated
s := make([]int, 0, 1000)
for i := 0; i < 1000; i++ {
    s = append(s, i)
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Not running enough iterations</h4>
                                        <pre><code class="language-go">// ❌ Wrong - fixed iterations
func BenchmarkWrong(b *testing.B) {
    for i := 0; i < 100; i++ {
        doWork()
    }
}

// ✅ Correct - use b.N
func BenchmarkCorrect(b *testing.B) {
    for i := 0; i < b.N; i++ {
        doWork()
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Including setup in benchmark</h4>
                                        <pre><code class="language-go">// ❌ Wrong - setup counted
func BenchmarkWrong(b *testing.B) {
    for i := 0; i < b.N; i++ {
        data := setup()  // Counted!
        process(data)
    }
}

// ✅ Correct - reset timer
func BenchmarkCorrect(b *testing.B) {
    data := setup()
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        process(data)
    }
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Optimize String Building</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Benchmark and optimize string concatenation.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Benchmark 3 methods: +=, strings.Builder, bytes.Buffer</li>
                                            <li>Test with 100 and 1000 iterations</li>
                                            <li>Include memory stats</li>
                                            <li>Identify the fastest method</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package stringbench

import (
    "bytes"
    "strings"
    "testing"
)

func BenchmarkStringConcat(b *testing.B) {
    benchmarks := []struct {
        name string
        n    int
    }{
        {"100", 100},
        {"1000", 1000},
    }
    
    for _, bm := range benchmarks {
        b.Run("Plus_"+bm.name, func(b *testing.B) {
            for i := 0; i < b.N; i++ {
                s := ""
                for j := 0; j < bm.n; j++ {
                    s += "x"
                }
            }
        })
        
        b.Run("Builder_"+bm.name, func(b *testing.B) {
            for i := 0; i < b.N; i++ {
                var sb strings.Builder
                for j := 0; j < bm.n; j++ {
                    sb.WriteString("x")
                }
                _ = sb.String()
            }
        })
        
        b.Run("Buffer_"+bm.name, func(b *testing.B) {
            for i := 0; i < b.N; i++ {
                var buf bytes.Buffer
                for j := 0; j < bm.n; j++ {
                    buf.WriteString("x")
                }
                _ = buf.String()
            }
        })
    }
}

// Run with: go test -bench=. -benchmem</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Benchmarks</strong> start with <code>Benchmark</code></li>
                                            <li><strong>Loop b.N times</strong> for accurate results</li>
                                            <li><strong>go test -bench=.</strong> runs benchmarks</li>
                                            <li><strong>-benchmem</strong> shows memory stats</li>
                                            <li><strong>b.ResetTimer()</strong> excludes setup time</li>
                                            <li><strong>benchstat</strong> compares results</li>
                                            <li><strong>pprof</strong> profiles CPU and memory</li>
                                            <li><strong>Measure before optimizing</strong></li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've learned to measure and optimize performance! Now you're ready for the
                                        final lesson:
                                        <strong>Best Practices</strong>. You'll learn Go idioms, code organization, and
                                        professional development practices to write production-ready code!
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="testing.jsp" />
                                    <jsp:param name="prevTitle" value="Testing" />
                                    <jsp:param name="nextLink" value="best-practices.jsp" />
                                    <jsp:param name="nextTitle" value="Best Practices" />
                                    <jsp:param name="currentLessonId" value="benchmarking" />
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