<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "sync-context" ); request.setAttribute("currentModule", "Concurrency" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Sync & Context - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Go's sync primitives (WaitGroup, Mutex, RWMutex, Once) and Context package for goroutine coordination and cancellation. Interactive examples included.">
            <meta name="keywords"
                content="go sync, golang sync, go context, sync.WaitGroup, sync.Mutex, context cancellation, go concurrency">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Sync & Context in Go">
            <meta property="og:description"
                content="Learn sync primitives and Context for production-ready Go concurrency.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/sync-context.jsp">
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
    "name": "Sync & Context in Go",
    "description": "Learn Go's sync primitives and Context package for goroutine coordination and cancellation.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/sync-context.jsp",
    "teaches": ["sync.WaitGroup", "sync.Mutex", "sync.RWMutex", "sync.Once", "Context package", "Cancellation", "Timeout"],
    "timeRequired": "PT40M"
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="sync-context">
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
                                    <span>Sync & Context</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Sync & Context</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Production Go code requires proper synchronization and cancellation.
                                        The
                                        <code>sync</code> package provides primitives for coordinating goroutines, while
                                        the
                                        <code>context</code> package enables cancellation, timeouts, and request-scoped
                                        values.
                                        Master these essential tools for building robust concurrent applications.
                                    </p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-sync-context.svg"
                                            alt="Sync Primitives and Context in Go" class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Sync Primitives (WaitGroup, Mutex, RWMutex,
                                            Once) and Context Package (Cancellation, Timeout, Values)</p>
                                    </div>

                                    <!-- Section 1: sync.WaitGroup -->
                                    <h2>sync.WaitGroup</h2>
                                    <p>A <code>WaitGroup</code> waits for a collection of goroutines to finish. It's the
                                        most
                                        common way to coordinate multiple goroutines:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/sync-waitgroup-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-waitgroup" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>WaitGroup Methods:</strong>
                                        <ul>
                                            <li><code>Add(n)</code> - Increment the counter by n</li>
                                            <li><code>Done()</code> - Decrement the counter by 1 (same as Add(-1))</li>
                                            <li><code>Wait()</code> - Block until counter reaches 0</li>
                                        </ul>
                                    </div>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Always call <code>wg.Add()</code> before
                                        starting the
                                        goroutine, and use <code>defer wg.Done()</code> to ensure Done() is called even
                                        if the
                                        goroutine panics.
                                    </div>

                                    <!-- Section 2: sync.Mutex -->
                                    <h2>sync.Mutex</h2>
                                    <p>A <code>Mutex</code> (mutual exclusion lock) protects shared data from concurrent
                                        access:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/sync-mutex-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-mutex" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Critical Section:</strong> The code between <code>Lock()</code> and
                                        <code>Unlock()</code> is the critical section. Only one goroutine can execute it
                                        at a time.
                                    </div>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Always use <code>defer mu.Unlock()</code> immediately
                                        after
                                        <code>mu.Lock()</code> to ensure the lock is released even if the function
                                        panics.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: sync.RWMutex -->
                                    <h2>sync.RWMutex</h2>
                                    <p>A <code>RWMutex</code> is a reader/writer mutual exclusion lock. Multiple readers
                                        can hold
                                        the lock simultaneously, but writers have exclusive access:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/sync-rwmutex-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-rwmutex" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Lock Type</th>
                                                <th>Methods</th>
                                                <th>Use Case</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Read Lock</td>
                                                <td><code>RLock()</code>, <code>RUnlock()</code></td>
                                                <td>Multiple concurrent readers</td>
                                            </tr>
                                            <tr>
                                                <td>Write Lock</td>
                                                <td><code>Lock()</code>, <code>Unlock()</code></td>
                                                <td>Exclusive write access</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 4: sync.Once -->
                                    <h2>sync.Once</h2>
                                    <p><code>sync.Once</code> ensures a function is executed only once, even when called
                                        from
                                        multiple goroutines. Perfect for initialization:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/sync-once-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-once" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Singleton Pattern:</strong> <code>sync.Once</code> is commonly used to
                                        implement
                                        thread-safe singletons in Go.
                                    </div>

                                    <!-- Section 5: Context Basics -->
                                    <h2>Context Package</h2>
                                    <p>The <code>context</code> package provides a way to carry deadlines, cancellation
                                        signals,
                                        and request-scoped values across API boundaries and between goroutines:</p>

                                    <h3>Context Types</h3>
                                    <pre><code class="language-go">// Root contexts
ctx := context.Background()  // Main context, never cancelled
ctx := context.TODO()        // Placeholder when context is unclear

// Derived contexts
ctx, cancel := context.WithCancel(parent)
ctx, cancel := context.WithTimeout(parent, duration)
ctx, cancel := context.WithDeadline(parent, time)
ctx = context.WithValue(parent, key, value)</code></pre>

                                    <!-- Section 6: Context Cancellation -->
                                    <h2>Context Cancellation</h2>
                                    <p>Use <code>WithCancel</code> to create a cancellable context:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/context-cancel-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-cancel" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Always call <code>cancel()</code> when you're
                                        done with a
                                        context, even if it's not explicitly cancelled. Use <code>defer cancel()</code>
                                        to ensure
                                        cleanup.
                                    </div>

                                    <!-- Section 7: Context Timeout -->
                                    <h2>Context Timeout & Deadline</h2>
                                    <p>Use <code>WithTimeout</code> or <code>WithDeadline</code> to automatically cancel
                                        operations
                                        after a duration:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/context-timeout-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-timeout" />
                                    </jsp:include>

                                    <h3>Deadline Example</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/context-deadline-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-deadline" />
                                    </jsp:include>

                                    <!-- Section 8: Context Values -->
                                    <h2>Context Values</h2>
                                    <p>Context can carry request-scoped values, but use this feature sparingly:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/context-values-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-values" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Warning:</strong> Context values should only be used for request-scoped
                                        data that
                                        crosses API boundaries (like request IDs, auth tokens). Don't use them to pass
                                        optional
                                        parameters to functions!
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to call Done()</h4>
                                        <pre><code class="language-go">// ❌ Wrong - goroutine might panic before Done()
go func() {
    wg.Add(1)
    // ... work ...
    wg.Done()  // Might not be called!
}()

// ✅ Correct - defer ensures Done() is called
go func() {
    wg.Add(1)
    defer wg.Done()
    // ... work ...
}()</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Not deferring Unlock()</h4>
                                        <pre><code class="language-go">// ❌ Wrong - might forget to unlock
func (c *Counter) Increment() {
    c.mu.Lock()
    c.count++
    c.mu.Unlock()  // Might be skipped if panic occurs
}

// ✅ Correct - defer ensures unlock
func (c *Counter) Increment() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.count++
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not calling cancel()</h4>
                                        <pre><code class="language-go">// ❌ Wrong - context leak
func doWork() {
    ctx, cancel := context.WithTimeout(parent, time.Second)
    // ... work ...
    // Forgot to call cancel()!
}

// ✅ Correct - always defer cancel
func doWork() {
    ctx, cancel := context.WithTimeout(parent, time.Second)
    defer cancel()
    // ... work ...
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Concurrent Task Processor</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Build a concurrent task processor with cancellation
                                            support.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Process 100 tasks using 5 workers</li>
                                            <li>Use WaitGroup to coordinate workers</li>
                                            <li>Use Context to support cancellation</li>
                                            <li>Use Mutex to safely collect results</li>
                                            <li>Cancel all workers after 3 seconds</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "context"
    "fmt"
    "sync"
    "time"
)

type Results struct {
    mu      sync.Mutex
    results []int
}

func (r *Results) Add(value int) {
    r.mu.Lock()
    defer r.mu.Unlock()
    r.results = append(r.results, value)
}

func worker(ctx context.Context, id int, tasks <-chan int, results *Results, wg *sync.WaitGroup) {
    defer wg.Done()
    
    for {
        select {
        case <-ctx.Done():
            fmt.Printf("Worker %d cancelled\n", id)
            return
        case task, ok := <-tasks:
            if !ok {
                return
            }
            // Process task
            result := task * 2
            results.Add(result)
            fmt.Printf("Worker %d processed task %d\n", id, task)
            time.Sleep(100 * time.Millisecond)
        }
    }
}

func main() {
    ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
    defer cancel()
    
    tasks := make(chan int, 100)
    results := &Results{}
    var wg sync.WaitGroup
    
    // Start workers
    for i := 1; i <= 5; i++ {
        wg.Add(1)
        go worker(ctx, i, tasks, results, &wg)
    }
    
    // Send tasks
    go func() {
        for i := 1; i <= 100; i++ {
            tasks <- i
        }
        close(tasks)
    }()
    
    // Wait for completion or timeout
    wg.Wait()
    
    fmt.Printf("\nProcessed %d tasks\n", len(results.results))
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>sync.WaitGroup</strong> coordinates multiple goroutines</li>
                                            <li><strong>sync.Mutex</strong> protects shared data with exclusive locks
                                            </li>
                                            <li><strong>sync.RWMutex</strong> allows multiple readers or one writer</li>
                                            <li><strong>sync.Once</strong> ensures initialization happens only once</li>
                                            <li><strong>context.Context</strong> carries cancellation signals and
                                                deadlines</li>
                                            <li><strong>WithCancel</strong> creates manually cancellable contexts</li>
                                            <li><strong>WithTimeout/WithDeadline</strong> creates auto-cancelling
                                                contexts</li>
                                            <li><strong>Context values</strong> should only be used for request-scoped
                                                data</li>
                                            <li><strong>Always defer</strong> Done(), Unlock(), and cancel()</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand sync primitives and context, you're ready to explore
                                        <strong>Packages & Modules</strong>. In the next lesson, you'll learn how to
                                        organize
                                        your code into reusable packages and manage dependencies with Go modules.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="select-patterns.jsp" />
                                    <jsp:param name="prevTitle" value="Select & Patterns" />
                                    <jsp:param name="nextLink" value="goroutines-waitgroups.jsp" />
                                    <jsp:param name="nextTitle" value="Goroutine Coordination" />
                                    <jsp:param name="currentLessonId" value="sync-context" />
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