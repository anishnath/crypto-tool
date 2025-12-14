<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "channels" ); request.setAttribute("currentModule", "Concurrency" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Channels in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go channels, buffered channels, channel operations, and communication patterns. Master safe concurrent communication.">
            <meta name="keywords"
                content="go channels, golang channels, buffered channels, channel communication, concurrent programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Channels in Go">
            <meta property="og:description" content="Master Go channels for safe concurrent communication.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/channels.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

            <style>
                .diagram-container {
                    margin: 2rem 0;
                    padding: 1.5rem;
                    background: #f8f9fa;
                    border-radius: 8px;
                    text-align: center;
                }

                .diagram-container svg {
                    max-width: 100%;
                    height: auto;
                }

                .diagram-caption {
                    margin-top: 1rem;
                    font-size: 0.9rem;
                    color: #666;
                    font-style: italic;
                }
            </style>

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
    "name": "Channels in Go",
    "description": "Learn Go channels and concurrent communication patterns with visual diagrams.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/channels.jsp",
    "teaches": ["channels", "buffered channels", "channel operations", "concurrent communication"],
    "timeRequired": "PT40M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="channels">
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
                                    <span>Channels</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Channels</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Channels are Go's pipes for communication between goroutines. They
                                        provide a safe
                                        way to send and receive values, following the principle: "Don't communicate by
                                        sharing
                                        memory; share memory by communicating."</p>

                                    <!-- Section 1: What is a Channel? -->
                                    <h2>What is a Channel?</h2>
                                    <p>A channel is a typed conduit through which you can send and receive values:</p>

                                    <div class="diagram-container">
                                        <svg viewBox="0 0 800 300" xmlns="http://www.w3.org/2000/svg">
                                            <!-- Title -->
                                            <text x="400" y="30" text-anchor="middle" font-size="20" font-weight="bold"
                                                fill="#333">Channel Communication</text>

                                            <!-- Sender Goroutine -->
                                            <rect x="50" y="100" width="150" height="100" fill="#27AE60" opacity="0.2"
                                                stroke="#27AE60" stroke-width="2" rx="5" />
                                            <text x="125" y="130" text-anchor="middle" font-size="14" font-weight="bold"
                                                fill="#27AE60">Sender</text>
                                            <text x="125" y="150" text-anchor="middle" font-size="12"
                                                fill="#333">Goroutine</text>
                                            <text x="125" y="175" text-anchor="middle" font-size="13" fill="#333"
                                                font-family="monospace">ch <- value</text>

                                                    <!-- Channel (pipe) -->
                                                    <rect x="250" y="130" width="300" height="40" fill="#3498DB"
                                                        opacity="0.3" stroke="#3498DB" stroke-width="3" rx="5" />
                                                    <text x="400" y="155" text-anchor="middle" font-size="14"
                                                        font-weight="bold" fill="#3498DB">Channel (ch)</text>

                                                    <!-- Arrow -->
                                                    <path d="M 200 150 L 240 150" stroke="#27AE60" stroke-width="3"
                                                        marker-end="url(#arrowgreen2)" />
                                                    <path d="M 560 150 L 600 150" stroke="#E74C3C" stroke-width="3"
                                                        marker-end="url(#arrowred)" />

                                                    <!-- Data flow -->
                                                    <circle cx="320" cy="150" r="12" fill="#F39C12" />
                                                    <text x="320" y="155" text-anchor="middle" font-size="10"
                                                        fill="white" font-weight="bold">42</text>
                                                    <path d="M 332 150 L 468 150" stroke="#F39C12" stroke-width="2"
                                                        stroke-dasharray="5,5" />
                                                    <circle cx="480" cy="150" r="12" fill="#F39C12" />
                                                    <text x="480" y="155" text-anchor="middle" font-size="10"
                                                        fill="white" font-weight="bold">42</text>

                                                    <!-- Receiver Goroutine -->
                                                    <rect x="600" y="100" width="150" height="100" fill="#E74C3C"
                                                        opacity="0.2" stroke="#E74C3C" stroke-width="2" rx="5" />
                                                    <text x="675" y="130" text-anchor="middle" font-size="14"
                                                        font-weight="bold" fill="#E74C3C">Receiver</text>
                                                    <text x="675" y="150" text-anchor="middle" font-size="12"
                                                        fill="#333">Goroutine</text>
                                                    <text x="675" y="175" text-anchor="middle" font-size="13"
                                                        fill="#333" font-family="monospace">value := <-ch< /text>

                                                            <!-- Labels -->
                                                            <text x="400" y="240" text-anchor="middle" font-size="12"
                                                                fill="#666">Safe, synchronized communication</text>
                                                            <text x="400" y="260" text-anchor="middle" font-size="12"
                                                                fill="#666">No shared memory, no race conditions</text>

                                                            <!-- Arrow markers -->
                                                            <defs>
                                                                <marker id="arrowgreen2" markerWidth="10"
                                                                    markerHeight="10" refX="9" refY="3" orient="auto"
                                                                    markerUnits="strokeWidth">
                                                                    <path d="M0,0 L0,6 L9,3 z" fill="#27AE60" />
                                                                </marker>
                                                                <marker id="arrowred" markerWidth="10" markerHeight="10"
                                                                    refX="9" refY="3" orient="auto"
                                                                    markerUnits="strokeWidth">
                                                                    <path d="M0,0 L0,6 L9,3 z" fill="#E74C3C" />
                                                                </marker>
                                                            </defs>
                                        </svg>
                                        <div class="diagram-caption">Channels provide safe communication between
                                            goroutines</div>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/channels-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-channels" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Channel Operations:</strong>
                                        <ul>
                                            <li><code>ch <- value</code> - Send value to channel</li>
                                            <li><code>value := <-ch</code> - Receive value from channel</li>
                                            <li><code>close(ch)</code> - Close channel (sender only)</li>
                                            <li><code>value, ok := <-ch</code> - Receive with closed check</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Unbuffered vs Buffered -->
                                    <h2>Unbuffered vs Buffered Channels</h2>

                                    <div class="diagram-container">
                                        <svg viewBox="0 0 800 450" xmlns="http://www.w3.org/2000/svg">
                                            <!-- Title -->
                                            <text x="400" y="30" text-anchor="middle" font-size="20" font-weight="bold"
                                                fill="#333">Unbuffered vs Buffered Channels</text>

                                            <!-- Unbuffered Channel -->
                                            <text x="200" y="70" text-anchor="middle" font-size="16" font-weight="bold"
                                                fill="#E74C3C">Unbuffered (Synchronous)</text>

                                            <rect x="100" y="90" width="80" height="60" fill="#27AE60" opacity="0.2"
                                                stroke="#27AE60" stroke-width="2" rx="3" />
                                            <text x="140" y="125" text-anchor="middle" font-size="12"
                                                fill="#333">Sender</text>

                                            <rect x="220" y="100" width="60" height="40" fill="#3498DB" opacity="0.3"
                                                stroke="#3498DB" stroke-width="2" rx="3" />
                                            <text x="250" y="125" text-anchor="middle" font-size="11"
                                                fill="#333">ch</text>

                                            <rect x="320" y="90" width="80" height="60" fill="#E74C3C" opacity="0.2"
                                                stroke="#E74C3C" stroke-width="2" rx="3" />
                                            <text x="360" y="125" text-anchor="middle" font-size="12"
                                                fill="#333">Receiver</text>

                                            <path d="M 180 120 L 215 120" stroke="#27AE60" stroke-width="2"
                                                marker-end="url(#arrow2)" />
                                            <path d="M 285 120 L 315 120" stroke="#E74C3C" stroke-width="2"
                                                marker-end="url(#arrow2)" />

                                            <text x="200" y="180" text-anchor="middle" font-size="12" fill="#666">✓
                                                Sender blocks until receiver ready</text>
                                            <text x="200" y="200" text-anchor="middle" font-size="12" fill="#666">✓
                                                Guaranteed synchronization</text>
                                            <text x="200" y="220" text-anchor="middle" font-size="12" fill="#666">✗ No
                                                capacity</text>

                                            <!-- Buffered Channel -->
                                            <text x="600" y="70" text-anchor="middle" font-size="16" font-weight="bold"
                                                fill="#27AE60">Buffered (Asynchronous)</text>

                                            <rect x="500" y="90" width="80" height="60" fill="#27AE60" opacity="0.2"
                                                stroke="#27AE60" stroke-width="2" rx="3" />
                                            <text x="540" y="125" text-anchor="middle" font-size="12"
                                                fill="#333">Sender</text>

                                            <!-- Buffer with slots -->
                                            <rect x="620" y="100" width="100" height="40" fill="#3498DB" opacity="0.3"
                                                stroke="#3498DB" stroke-width="2" rx="3" />
                                            <line x1="650" y1="100" x2="650" y2="140" stroke="#3498DB"
                                                stroke-width="1" />
                                            <line x1="680" y1="100" x2="680" y2="140" stroke="#3498DB"
                                                stroke-width="1" />
                                            <line x1="710" y1="100" x2="710" y2="140" stroke="#3498DB"
                                                stroke-width="1" />
                                            <circle cx="635" cy="120" r="8" fill="#F39C12" />
                                            <circle cx="665" cy="120" r="8" fill="#F39C12" />
                                            <text x="670" y="95" text-anchor="middle" font-size="11" fill="#333">ch
                                                (cap=3)</text>

                                            <path d="M 580 120 L 615 120" stroke="#27AE60" stroke-width="2"
                                                marker-end="url(#arrow2)" />

                                            <text x="600" y="180" text-anchor="middle" font-size="12" fill="#666">✓
                                                Sender doesn't block (if space)</text>
                                            <text x="600" y="200" text-anchor="middle" font-size="12" fill="#666">✓
                                                Decouples sender/receiver</text>
                                            <text x="600" y="220" text-anchor="middle" font-size="12" fill="#666">✓ Has
                                                capacity</text>

                                            <!-- Code examples -->
                                            <rect x="50" y="260" width="350" height="150" fill="#f0f0f0" stroke="#ccc"
                                                stroke-width="1" rx="5" />
                                            <text x="225" y="285" text-anchor="middle" font-size="14" font-weight="bold"
                                                fill="#333">Unbuffered</text>
                                            <text x="80" y="310" font-size="12" font-family="monospace" fill="#333">ch
                                                := make(chan int)</text>
                                            <text x="80" y="335" font-size="12" font-family="monospace" fill="#666">//
                                                Capacity: 0</text>
                                            <text x="80" y="360" font-size="12" font-family="monospace" fill="#666">//
                                                Send blocks until receive</text>
                                            <text x="80" y="385" font-size="12" font-family="monospace" fill="#666">//
                                                Receive blocks until send</text>

                                            <rect x="420" y="260" width="350" height="150" fill="#f0f0f0" stroke="#ccc"
                                                stroke-width="1" rx="5" />
                                            <text x="595" y="285" text-anchor="middle" font-size="14" font-weight="bold"
                                                fill="#333">Buffered</text>
                                            <text x="450" y="310" font-size="12" font-family="monospace" fill="#333">ch
                                                := make(chan int, 3)</text>
                                            <text x="450" y="335" font-size="12" font-family="monospace" fill="#666">//
                                                Capacity: 3</text>
                                            <text x="450" y="360" font-size="12" font-family="monospace" fill="#666">//
                                                Send blocks when full</text>
                                            <text x="450" y="385" font-size="12" font-family="monospace" fill="#666">//
                                                Receive blocks when empty</text>

                                            <defs>
                                                <marker id="arrow2" markerWidth="10" markerHeight="10" refX="9" refY="3"
                                                    orient="auto" markerUnits="strokeWidth">
                                                    <path d="M0,0 L0,6 L9,3 z" fill="#666" />
                                                </marker>
                                            </defs>
                                        </svg>
                                        <div class="diagram-caption">Unbuffered channels synchronize; buffered channels
                                            decouple</div>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/channels-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-buffered" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Channel Direction -->
                                    <h2>Channel Direction</h2>
                                    <p>You can restrict channels to send-only or receive-only:</p>

                                    <pre><code class="language-go">// Send-only channel
func sender(ch chan<- int) {
    ch <- 42  // OK
    // val := <-ch  // Error: receive from send-only
}

// Receive-only channel
func receiver(ch <-chan int) {
    val := <-ch  // OK
    // ch <- 42  // Error: send to receive-only
}

func main() {
    ch := make(chan int)  // Bidirectional
    go sender(ch)         // Converts to send-only
    receiver(ch)          // Converts to receive-only
}</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use directional channels in function parameters
                                        to make
                                        intent clear and prevent misuse. The compiler will catch errors!
                                    </div>

                                    <!-- Section 4: Closing Channels -->
                                    <h2>Closing Channels</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/channels-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-close" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important Rules:</strong>
                                        <ul>
                                            <li>Only the sender should close a channel</li>
                                            <li>Sending to a closed channel causes panic</li>
                                            <li>Receiving from a closed channel returns zero value</li>
                                            <li>Closing is optional (for signaling completion)</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Range over Channels -->
                                    <h2>Range over Channels</h2>
                                    <pre><code class="language-go">func producer(ch chan<- int) {
    for i := 0; i < 5; i++ {
        ch <- i
    }
    close(ch)  // Signal completion
}

func main() {
    ch := make(chan int)
    go producer(ch)
    
    // Range automatically stops when channel closed
    for value := range ch {
        fmt.Println(value)
    }
}</code></pre>

                                    <!-- Section 6: Common Patterns -->
                                    <h2>Common Channel Patterns</h2>

                                    <h3>1. Pipeline Pattern</h3>
                                    <div class="diagram-container">
                                        <svg viewBox="0 0 800 200" xmlns="http://www.w3.org/2000/svg">
                                            <!-- Title -->
                                            <text x="400" y="30" text-anchor="middle" font-size="18" font-weight="bold"
                                                fill="#333">Pipeline Pattern</text>

                                            <!-- Stage 1 -->
                                            <rect x="50" y="70" width="120" height="60" fill="#27AE60" opacity="0.2"
                                                stroke="#27AE60" stroke-width="2" rx="5" />
                                            <text x="110" y="95" text-anchor="middle" font-size="13" font-weight="bold"
                                                fill="#27AE60">Generator</text>
                                            <text x="110" y="115" text-anchor="middle" font-size="11"
                                                fill="#333">Produces data</text>

                                            <!-- Channel 1 -->
                                            <rect x="190" y="90" width="80" height="20" fill="#3498DB" opacity="0.3"
                                                stroke="#3498DB" stroke-width="2" rx="3" />
                                            <text x="230" y="105" text-anchor="middle" font-size="10"
                                                fill="#333">ch1</text>

                                            <!-- Stage 2 -->
                                            <rect x="290" y="70" width="120" height="60" fill="#F39C12" opacity="0.2"
                                                stroke="#F39C12" stroke-width="2" rx="5" />
                                            <text x="350" y="95" text-anchor="middle" font-size="13" font-weight="bold"
                                                fill="#F39C12">Processor</text>
                                            <text x="350" y="115" text-anchor="middle" font-size="11"
                                                fill="#333">Transforms data</text>

                                            <!-- Channel 2 -->
                                            <rect x="430" y="90" width="80" height="20" fill="#3498DB" opacity="0.3"
                                                stroke="#3498DB" stroke-width="2" rx="3" />
                                            <text x="470" y="105" text-anchor="middle" font-size="10"
                                                fill="#333">ch2</text>

                                            <!-- Stage 3 -->
                                            <rect x="530" y="70" width="120" height="60" fill="#E74C3C" opacity="0.2"
                                                stroke="#E74C3C" stroke-width="2" rx="5" />
                                            <text x="590" y="95" text-anchor="middle" font-size="13" font-weight="bold"
                                                fill="#E74C3C">Consumer</text>
                                            <text x="590" y="115" text-anchor="middle" font-size="11" fill="#333">Uses
                                                data</text>

                                            <!-- Arrows -->
                                            <path d="M 170 100 L 185 100" stroke="#666" stroke-width="2"
                                                marker-end="url(#arrow3)" />
                                            <path d="M 270 100 L 285 100" stroke="#666" stroke-width="2"
                                                marker-end="url(#arrow3)" />
                                            <path d="M 410 100 L 425 100" stroke="#666" stroke-width="2"
                                                marker-end="url(#arrow3)" />
                                            <path d="M 510 100 L 525 100" stroke="#666" stroke-width="2"
                                                marker-end="url(#arrow3)" />

                                            <text x="400" y="170" text-anchor="middle" font-size="12" fill="#666">Data
                                                flows through stages via channels</text>

                                            <defs>
                                                <marker id="arrow3" markerWidth="10" markerHeight="10" refX="9" refY="3"
                                                    orient="auto" markerUnits="strokeWidth">
                                                    <path d="M0,0 L0,6 L9,3 z" fill="#666" />
                                                </marker>
                                            </defs>
                                        </svg>
                                        <div class="diagram-caption">Pipeline: Chain stages with channels</div>
                                    </div>

                                    <pre><code class="language-go">func generator() <-chan int {
    ch := make(chan int)
    go func() {
        for i := 0; i < 5; i++ {
            ch <- i
        }
        close(ch)
    }()
    return ch
}

func square(in <-chan int) <-chan int {
    out := make(chan int)
    go func() {
        for n := range in {
            out <- n * n
        }
        close(out)
    }()
    return out
}

func main() {
    nums := generator()
    squares := square(nums)
    
    for result := range squares {
        fmt.Println(result)
    }
}</code></pre>

                                    <h3>2. Fan-Out, Fan-In</h3>
                                    <pre><code class="language-go">// Fan-out: Multiple workers read from same channel
func worker(id int, jobs <-chan int, results chan<- int) {
    for job := range jobs {
        results <- job * 2  // Process job
    }
}

// Fan-in: Merge multiple channels into one
func merge(channels ...<-chan int) <-chan int {
    out := make(chan int)
    var wg sync.WaitGroup
    
    for _, ch := range channels {
        wg.Add(1)
        go func(c <-chan int) {
            defer wg.Done()
            for v := range c {
                out <- v
            }
        }(ch)
    }
    
    go func() {
        wg.Wait()
        close(out)
    }()
    
    return out
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Deadlock - no receiver</h4>
                                        <pre><code class="language-go">// ❌ Wrong - deadlock!
ch := make(chan int)
ch <- 42  // Blocks forever (no receiver)

// ✅ Correct - use goroutine
ch := make(chan int)
go func() {
    ch <- 42
}()
value := <-ch</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Sending to closed channel</h4>
                                        <pre><code class="language-go">// ❌ Wrong - panic!
ch := make(chan int)
close(ch)
ch <- 42  // panic: send on closed channel

// ✅ Correct - only sender closes
// Never close from receiver side</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not closing channels in range</h4>
                                        <pre><code class="language-go">// ❌ Wrong - range never exits
func producer(ch chan int) {
    for i := 0; i < 5; i++ {
        ch <- i
    }
    // Forgot to close!
}

// ✅ Correct - close when done
func producer(ch chan int) {
    for i := 0; i < 5; i++ {
        ch <- i
    }
    close(ch)  // Signal completion
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Worker Pool</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a worker pool using channels.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create 3 workers that process jobs concurrently</li>
                                            <li>Send 10 jobs through a jobs channel</li>
                                            <li>Collect results through a results channel</li>
                                            <li>Print which worker processed each job</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
    "time"
)

func worker(id int, jobs <-chan int, results chan<- string) {
    for job := range jobs {
        fmt.Printf("Worker %d started job %d\n", id, job)
        time.Sleep(time.Millisecond * 500)  // Simulate work
        result := fmt.Sprintf("Worker %d completed job %d (result: %d)", id, job, job*2)
        results <- result
    }
}

func main() {
    const numJobs = 10
    const numWorkers = 3
    
    jobs := make(chan int, numJobs)
    results := make(chan string, numJobs)
    
    // Start workers
    for w := 1; w <= numWorkers; w++ {
        go worker(w, jobs, results)
    }
    
    // Send jobs
    for j := 1; j <= numJobs; j++ {
        jobs <- j
    }
    close(jobs)
    
    // Collect results
    for a := 1; a <= numJobs; a++ {
        fmt.Println(<-results)
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Channels</strong> provide safe communication between goroutines
                                            </li>
                                            <li><strong>Unbuffered channels</strong> synchronize sender and receiver
                                            </li>
                                            <li><strong>Buffered channels</strong> decouple with capacity</li>
                                            <li><strong>Directional channels</strong> restrict send/receive operations
                                            </li>
                                            <li><strong>close()</strong> signals no more values (sender only)</li>
                                            <li><strong>range</strong> loops until channel is closed</li>
                                            <li><strong>Patterns</strong>: pipeline, fan-out, fan-in</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand channels, you're ready to learn about <strong>Select &
                                            Patterns</strong>.
                                        The select statement lets you work with multiple channels, enabling powerful
                                        concurrent
                                        patterns!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="goroutines.jsp" />
                                    <jsp:param name="prevTitle" value="Goroutines" />
                                    <jsp:param name="nextLink" value="select-patterns.jsp" />
                                    <jsp:param name="nextTitle" value="Select & Patterns" />
                                    <jsp:param name="currentLessonId" value="channels" />
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