<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "goroutines-waitgroups" );
        request.setAttribute("currentModule", "Concurrency" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Goroutine Coordination Patterns - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master goroutine coordination patterns: worker pools, fan-out/fan-in, pipelines, and bounded concurrency. Learn production-ready concurrent patterns in Go.">
            <meta name="keywords"
                content="go goroutines, golang concurrency patterns, worker pool, fan-out fan-in, go pipeline, bounded concurrency">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Goroutine Coordination Patterns">
            <meta property="og:description" content="Learn production-ready goroutine coordination patterns in Go.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/goroutines-waitgroups.jsp">
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
    "name": "Goroutine Coordination Patterns in Go",
    "description": "Learn production-ready goroutine coordination patterns including worker pools, fan-out/fan-in, and pipelines.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/goroutines-waitgroups.jsp",
    "teaches": ["Worker Pool", "Fan-Out Pattern", "Fan-In Pattern", "Pipeline Pattern", "Bounded Concurrency", "Error Handling"],
    "timeRequired": "PT45M"
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="goroutines-waitgroups">
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
                                    <span>Goroutine Coordination</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Goroutine Coordination Patterns</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~45 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Coordinating multiple goroutines is essential for building scalable
                                        concurrent
                                        applications. This lesson covers production-ready patterns: worker pools,
                                        fan-out/fan-in,
                                        pipelines, and bounded concurrency. Master these patterns to write efficient,
                                        maintainable
                                        concurrent Go code.</p>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-waitgroup-coordination.svg"
                                            alt="Goroutine Coordination with WaitGroup" class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: WaitGroup Lifecycle and Coordination Patterns
                                            (Worker Pool, Fan-Out/Fan-In)</p>
                                    </div>

                                    <!-- Section 1: WaitGroup Pattern -->
                                    <h2>WaitGroup Coordination Pattern</h2>
                                    <p>The fundamental pattern for coordinating goroutines uses
                                        <code>sync.WaitGroup</code> to wait
                                        for a collection of goroutines to complete:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/waitgroup-pattern.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-waitgroup-pattern" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Pattern Steps:</strong>
                                        <ol>
                                            <li><code>wg.Add(1)</code> - Increment counter before starting goroutine
                                            </li>
                                            <li><code>defer wg.Done()</code> - Decrement counter when goroutine
                                                completes</li>
                                            <li><code>wg.Wait()</code> - Block until all goroutines finish</li>
                                        </ol>
                                    </div>

                                    <!-- Section 2: Worker Pool Pattern -->
                                    <h2>Worker Pool Pattern</h2>
                                    <p>The worker pool pattern uses a fixed number of workers to process jobs from a
                                        queue. This
                                        limits concurrency and provides better resource management:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/worker-pool.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-worker-pool" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Worker Pool Benefits:</strong>
                                        <ul>
                                            <li>Limits concurrent goroutines (prevents resource exhaustion)</li>
                                            <li>Reuses goroutines (reduces overhead)</li>
                                            <li>Provides backpressure (buffered job channel)</li>
                                            <li>Easy to scale (adjust number of workers)</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Fan-Out Pattern -->
                                    <h2>Fan-Out Pattern</h2>
                                    <p>Fan-out distributes work across multiple goroutines to parallelize processing:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/fan-out.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-fan-out" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>When to Use Fan-Out:</strong> Use when you have independent tasks that
                                        can be
                                        processed in parallel, like processing multiple files, making concurrent API
                                        calls, or
                                        performing parallel computations.
                                    </div>

                                    <!-- Section 4: Fan-In Pattern -->
                                    <h2>Fan-In Pattern</h2>
                                    <p>Fan-in merges multiple input channels into a single output channel:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/fan-in.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-fan-in" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Fan-In Use Cases:</strong>
                                        <ul>
                                            <li>Collecting results from multiple workers</li>
                                            <li>Merging log streams</li>
                                            <li>Aggregating data from multiple sources</li>
                                            <li>Combining outputs from parallel computations</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Pipeline Pattern -->
                                    <h2>Pipeline Pattern with WaitGroup</h2>
                                    <p>Pipelines chain multiple stages together, with each stage processing data and
                                        passing it to
                                        the next:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/pipeline-waitgroup.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-pipeline" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Stage</th>
                                                <th>Input</th>
                                                <th>Processing</th>
                                                <th>Output</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Generate</td>
                                                <td>-</td>
                                                <td>Create numbers</td>
                                                <td>Channel of ints</td>
                                            </tr>
                                            <tr>
                                                <td>Square</td>
                                                <td>Channel of ints</td>
                                                <td>Square each number</td>
                                                <td>Channel of ints</td>
                                            </tr>
                                            <tr>
                                                <td>Print</td>
                                                <td>Channel of ints</td>
                                                <td>Print results</td>
                                                <td>-</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 6: Error Handling -->
                                    <h2>Error Handling in Concurrent Code</h2>
                                    <p>Collecting errors from multiple goroutines requires careful coordination:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/error-collection.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-errors" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> For more sophisticated error handling, consider using
                                        the
                                        <code>golang.org/x/sync/errgroup</code> package, which provides a WaitGroup with
                                        error
                                        collection built-in.
                                    </div>

                                    <!-- Section 7: Bounded Concurrency -->
                                    <h2>Bounded Concurrency</h2>
                                    <p>Limit the number of concurrent goroutines using a semaphore pattern:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/bounded-concurrency.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-bounded" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Semaphore Pattern:</strong> A buffered channel acts as a semaphore.
                                        Sending to the
                                        channel acquires a slot, receiving releases it. The buffer size limits
                                        concurrency.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Adding to WaitGroup inside goroutine</h4>
                                        <pre><code class="language-go">// ❌ Wrong - race condition
for i := 0; i < 10; i++ {
    go func() {
        wg.Add(1)  // Too late! Main might call Wait() first
        defer wg.Done()
        // work
    }()
}

// ✅ Correct - Add before starting goroutine
for i := 0; i < 10; i++ {
    wg.Add(1)
    go func() {
        defer wg.Done()
        // work
    }()
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Closing channel too early</h4>
                                        <pre><code class="language-go">// ❌ Wrong - channel closed before workers finish
close(jobs)
wg.Wait()  // Workers might still be reading!

// ✅ Correct - close after sending all jobs
for j := 1; j <= numJobs; j++ {
    jobs <- j
}
close(jobs)  // Now safe to close
wg.Wait()</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not closing results channel</h4>
                                        <pre><code class="language-go">// ❌ Wrong - range will block forever
for result := range results {
    fmt.Println(result)
}

// ✅ Correct - close results when done
go func() {
    wg.Wait()
    close(results)  // Signal no more results
}()

for result := range results {
    fmt.Println(result)
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Concurrent File Processor</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Build a concurrent file processor using the worker
                                            pool pattern.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Process 20 "files" (simulated with numbers)</li>
                                            <li>Use 4 workers in a worker pool</li>
                                            <li>Each file takes 200-500ms to process</li>
                                            <li>Collect and display all results</li>
                                            <li>Handle errors gracefully</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
    "math/rand"
    "sync"
    "time"
)

type FileResult struct {
    FileID int
    Size   int
    Err    error
}

func processFile(fileID int) (int, error) {
    // Simulate processing time
    time.Sleep(time.Duration(200+rand.Intn(300)) * time.Millisecond)
    
    // Simulate occasional errors
    if fileID%7 == 0 {
        return 0, fmt.Errorf("failed to process file %d", fileID)
    }
    
    return rand.Intn(1000), nil
}

func worker(id int, files <-chan int, results chan<- FileResult, wg *sync.WaitGroup) {
    defer wg.Done()
    
    for fileID := range files {
        fmt.Printf("Worker %d processing file %d\n", id, fileID)
        size, err := processFile(fileID)
        results <- FileResult{FileID: fileID, Size: size, Err: err}
    }
}

func main() {
    const numWorkers = 4
    const numFiles = 20
    
    files := make(chan int, numFiles)
    results := make(chan FileResult, numFiles)
    var wg sync.WaitGroup
    
    // Start worker pool
    fmt.Printf("Starting %d workers...\n", numWorkers)
    for w := 1; w <= numWorkers; w++ {
        wg.Add(1)
        go worker(w, files, results, &wg)
    }
    
    // Send files to process
    for f := 1; f <= numFiles; f++ {
        files <- f
    }
    close(files)
    
    // Close results when all workers done
    go func() {
        wg.Wait()
        close(results)
    }()
    
    // Collect results
    var totalSize int
    var errors []error
    
    for result := range results {
        if result.Err != nil {
            errors = append(errors, result.Err)
        } else {
            totalSize += result.Size
        }
    }
    
    // Display summary
    fmt.Printf("\n=== Processing Complete ===\n")
    fmt.Printf("Files processed: %d\n", numFiles-len(errors))
    fmt.Printf("Total size: %d bytes\n", totalSize)
    if len(errors) > 0 {
        fmt.Printf("Errors: %d\n", len(errors))
        for _, err := range errors {
            fmt.Printf("  - %v\n", err)
        }
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>WaitGroup</strong> coordinates multiple goroutines (Add, Done,
                                                Wait)</li>
                                            <li><strong>Worker Pool</strong> limits concurrency with fixed workers</li>
                                            <li><strong>Fan-Out</strong> distributes work across multiple goroutines
                                            </li>
                                            <li><strong>Fan-In</strong> merges multiple channels into one</li>
                                            <li><strong>Pipeline</strong> chains processing stages together</li>
                                            <li><strong>Error Collection</strong> requires dedicated error channel</li>
                                            <li><strong>Bounded Concurrency</strong> uses semaphore pattern</li>
                                            <li><strong>Always Add() before</strong> starting goroutine</li>
                                            <li><strong>Always defer Done()</strong> to ensure cleanup</li>
                                            <li><strong>Close channels</strong> when no more data will be sent</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered goroutine coordination patterns! These patterns form the
                                        foundation of
                                        production Go concurrency. Continue exploring advanced topics like generics and
                                        reflection
                                        to complete your Go expertise.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="sync-context.jsp" />
                                    <jsp:param name="prevTitle" value="Sync & Context" />
                                    <jsp:param name="nextLink" value="packages-modules.jsp" />
                                    <jsp:param name="nextTitle" value="Packages & Modules" />
                                    <jsp:param name="currentLessonId" value="goroutines-waitgroups" />
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