<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "memory-management" ); request.setAttribute("currentModule", "Advanced" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Memory Management in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Go memory management: stack vs heap, garbage collection, profiling with pprof, optimization techniques, and memory leak prevention.">
            <meta name="keywords"
                content="go memory management, golang gc, stack heap, pprof, memory optimization, escape analysis">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Memory Management in Go">
            <meta property="og:description" content="Learn Go's memory management, GC, and optimization techniques.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/memory-management.jsp">
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
    "name": "Memory Management in Go",
    "description": "Learn Go's memory management system, garbage collection, and optimization techniques.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/memory-management.jsp",
    "teaches": ["Memory Management", "Garbage Collection", "Stack vs Heap", "Memory Profiling", "Optimization"],
    "timeRequired": "PT50M"
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="memory-management">
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
                                    <span>Memory Management</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Memory Management</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~50 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Understanding Go's memory management is crucial for writing
                                        high-performance
                                        applications. This lesson covers stack vs heap allocation, garbage collection,
                                        memory
                                        profiling with pprof, and optimization techniques to minimize allocations and
                                        reduce GC
                                        pressure.</p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-memory-management.png"
                                            alt="Go Memory Management System" class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Go Memory Management - Stack, Heap, and
                                            Garbage Collection</p>
                                    </div>

                                    <!-- Section 1: Stack vs Heap -->
                                    <h2>Stack vs Heap Allocation</h2>
                                    <p>Go automatically decides where to allocate memory based on escape analysis:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/memory-stack-heap.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-stack-heap" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Aspect</th>
                                                <th>Stack</th>
                                                <th>Heap</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Speed</td>
                                                <td>✅ Very fast</td>
                                                <td>⚠️ Slower</td>
                                            </tr>
                                            <tr>
                                                <td>Management</td>
                                                <td>✅ Automatic (function scope)</td>
                                                <td>⚠️ Garbage collected</td>
                                            </tr>
                                            <tr>
                                                <td>Size</td>
                                                <td>⚠️ Limited (per goroutine)</td>
                                                <td>✅ Large, flexible</td>
                                            </tr>
                                            <tr>
                                                <td>Lifetime</td>
                                                <td>⚠️ Function scope only</td>
                                                <td>✅ Until GC collects</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 2: Garbage Collection -->
                                    <h2>Garbage Collection</h2>
                                    <p>Go uses a concurrent, tri-color mark-and-sweep garbage collector:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/memory-gc-demo.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-gc" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>GC Phases:</strong>
                                        <ol>
                                            <li><strong>Mark</strong> - Find all reachable objects</li>
                                            <li><strong>Sweep</strong> - Free unreachable memory</li>
                                            <li><strong>Concurrent</strong> - Runs alongside your program</li>
                                        </ol>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Memory Profiling -->
                                    <h2>Memory Profiling with pprof</h2>
                                    <p>Use pprof to identify memory hotspots and optimize allocations:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/memory-profiling.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-profiling" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>pprof Commands:</strong>
                                        <pre><code class="language-bash"># Create profile
go test -memprofile=mem.prof

# Analyze profile
go tool pprof mem.prof

# Interactive commands:
top       # Show top memory consumers
list main # Show line-by-line allocation
web       # Visualize (requires graphviz)</code></pre>
                                    </div>

                                    <!-- Section 4: sync.Pool -->
                                    <h2>Object Reuse with sync.Pool</h2>
                                    <p>Reduce allocations by reusing objects with sync.Pool:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/memory-pool-sync.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-pool" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>sync.Pool Best Practices:</strong>
                                        <ul>
                                            <li>Use for frequently allocated, short-lived objects</li>
                                            <li>Reset object state before Put()</li>
                                            <li>Don't rely on objects staying in pool</li>
                                            <li>Pool is safe for concurrent use</li>
                                            <li>Objects may be garbage collected at any time</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Escape Analysis -->
                                    <h2>Understanding Escape Analysis</h2>
                                    <p>The compiler analyzes whether variables can stay on the stack or must escape to
                                        the heap:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/memory-escape.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-escape" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Variables Escape When:</strong>
                                        <ul>
                                            <li>Pointer is returned from function</li>
                                            <li>Stored in interface{}</li>
                                            <li>Captured by closure</li>
                                            <li>Too large for stack</li>
                                            <li>Size unknown at compile time</li>
                                        </ul>
                                    </div>

                                    <!-- Section 6: Optimization Techniques -->
                                    <h2>Memory Optimization Techniques</h2>
                                    <p>Practical techniques to reduce memory allocations:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/memory-optimization.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-optimization" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Optimization Checklist:</strong>
                                        <ul>
                                            <li>✓ Preallocate slices: <code>make([]T, 0, capacity)</code></li>
                                            <li>✓ Use <code>strings.Builder</code> for string concatenation</li>
                                            <li>✓ Return values instead of pointers when possible</li>
                                            <li>✓ Reuse objects with <code>sync.Pool</code></li>
                                            <li>✓ Avoid unnecessary interface{} conversions</li>
                                            <li>✓ Profile with pprof to find hotspots</li>
                                        </ul>
                                    </div>

                                    <!-- Section 7: Memory Leaks -->
                                    <h2>Preventing Memory Leaks</h2>
                                    <p>Common memory leak patterns and how to fix them:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/memory-leak-fix.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-leaks" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Common Memory Leaks:</strong>
                                        <ul>
                                            <li>Goroutine leaks (no cancellation mechanism)</li>
                                            <li>Unbounded caches (no eviction policy)</li>
                                            <li>Forgotten timers (not stopped)</li>
                                            <li>Global variables holding references</li>
                                            <li>Unclosed resources (files, connections)</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Not preallocating slices</h4>
                                        <pre><code class="language-go">// ❌ Wrong - grows dynamically
var items []Item
for i := 0; i < 10000; i++ {
    items = append(items, Item{}) // Multiple reallocations
}

// ✅ Correct - preallocate
items := make([]Item, 0, 10000)
for i := 0; i < 10000; i++ {
    items = append(items, Item{}) // No reallocation
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. String concatenation in loops</h4>
                                        <pre><code class="language-go">// ❌ Wrong - creates many strings
result := ""
for i := 0; i < 1000; i++ {
    result += "x" // Each += allocates
}

// ✅ Correct - use strings.Builder
var builder strings.Builder
builder.Grow(1000) // Preallocate
for i := 0; i < 1000; i++ {
    builder.WriteString("x")
}
result := builder.String()</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Ignoring escape analysis</h4>
                                        <pre><code class="language-go">// ❌ Wrong - unnecessary heap allocation
func getPointer() *int {
    x := 42
    return &x // x escapes to heap
}

// ✅ Correct - return by value
func getValue() int {
    x := 42
    return x // Stays on stack
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Memory-Efficient Cache</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Build a memory-efficient LRU cache.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Fixed maximum size (100 items)</li>
                                            <li>Evict least recently used items</li>
                                            <li>Use sync.Pool for temporary objects</li>
                                            <li>Minimize allocations</li>
                                            <li>Thread-safe</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "container/list"
    "fmt"
    "sync"
)

type entry struct {
    key   string
    value interface{}
}

var entryPool = sync.Pool{
    New: func() interface{} {
        return &entry{}
    },
}

type LRUCache struct {
    mu       sync.Mutex
    capacity int
    cache    map[string]*list.Element
    lru      *list.List
}

func NewLRUCache(capacity int) *LRUCache {
    return &LRUCache{
        capacity: capacity,
        cache:    make(map[string]*list.Element),
        lru:      list.New(),
    }
}

func (c *LRUCache) Get(key string) (interface{}, bool) {
    c.mu.Lock()
    defer c.mu.Unlock()
    
    if elem, ok := c.cache[key]; ok {
        c.lru.MoveToFront(elem)
        return elem.Value.(*entry).value, true
    }
    return nil, false
}

func (c *LRUCache) Put(key string, value interface{}) {
    c.mu.Lock()
    defer c.mu.Unlock()
    
    if elem, ok := c.cache[key]; ok {
        c.lru.MoveToFront(elem)
        elem.Value.(*entry).value = value
        return
    }
    
    // Get entry from pool
    e := entryPool.Get().(*entry)
    e.key = key
    e.value = value
    
    elem := c.lru.PushFront(e)
    c.cache[key] = elem
    
    // Evict if over capacity
    if c.lru.Len() > c.capacity {
        oldest := c.lru.Back()
        if oldest != nil {
            c.lru.Remove(oldest)
            oldEntry := oldest.Value.(*entry)
            delete(c.cache, oldEntry.key)
            
            // Return to pool
            entryPool.Put(oldEntry)
        }
    }
}

func main() {
    cache := NewLRUCache(100)
    
    // Add items
    for i := 0; i < 150; i++ {
        cache.Put(fmt.Sprintf("key%d", i), i)
    }
    
    // Check cache
    if val, ok := cache.Get("key0"); ok {
        fmt.Printf("Found: %v\n", val)
    } else {
        fmt.Println("key0 evicted (LRU)")
    }
    
    if val, ok := cache.Get("key100"); ok {
        fmt.Printf("Found: %v\n", val)
    }
    
    fmt.Println("Cache working with LRU eviction!")
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Stack</strong> is fast, automatic, function-scoped</li>
                                            <li><strong>Heap</strong> is flexible, garbage collected, slower</li>
                                            <li><strong>Escape analysis</strong> determines stack vs heap</li>
                                            <li><strong>GC</strong> uses concurrent mark-and-sweep</li>
                                            <li><strong>pprof</strong> identifies memory hotspots</li>
                                            <li><strong>sync.Pool</strong> reuses objects to reduce allocations</li>
                                            <li><strong>Preallocate</strong> slices when size is known</li>
                                            <li><strong>strings.Builder</strong> for efficient concatenation</li>
                                            <li><strong>Return values</strong> instead of pointers when possible</li>
                                            <li><strong>Prevent leaks</strong> with proper resource management</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered Go's memory management! Next, you'll learn about <strong>Escape
                                            Analysis</strong> in depth, understanding exactly when and why variables
                                        escape to the
                                        heap, and how to optimize your code accordingly.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="generics-reflection.jsp" />
                                    <jsp:param name="prevTitle" value="Generics & Reflection" />
                                    <jsp:param name="nextLink" value="escape-analysis.jsp" />
                                    <jsp:param name="nextTitle" value="Escape Analysis" />
                                    <jsp:param name="currentLessonId" value="memory-management" />
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