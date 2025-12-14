<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "select-patterns" ); request.setAttribute("currentModule", "Concurrency" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Select & Patterns in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go select statement, timeout patterns, context, and advanced concurrency patterns. Master concurrent programming.">
            <meta name="keywords" content="go select, golang select, timeout patterns, context, concurrency patterns">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Select & Patterns in Go">
            <meta property="og:description" content="Master Go select statement and concurrency patterns.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/select-patterns.jsp">
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
    "name": "Select & Patterns in Go",
    "description": "Learn Go select statement and advanced concurrency patterns with visual diagrams.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/select-patterns.jsp",
    "teaches": ["select statement", "timeout patterns", "context", "concurrency patterns"],
    "timeRequired": "PT25M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="select-patterns">
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
                                    <span>Select & Patterns</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Select & Patterns</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The select statement lets you wait on multiple channel operations.
                                        It's like a
                                        switch for channels, enabling powerful concurrent patterns. In this lesson,
                                        you'll master
                                        select and learn professional concurrency patterns.</p>

                                    <!-- Section 1: Select Statement -->
                                    <h2>The Select Statement</h2>
                                    <p>Select waits on multiple channel operations:</p>

                                    <div class="diagram-container">
                                        <svg viewBox="0 0 800 350" xmlns="http://www.w3.org/2000/svg">
                                            <!-- Title -->
                                            <text x="400" y="30" text-anchor="middle" font-size="20" font-weight="bold"
                                                fill="#333">Select Statement</text>

                                            <!-- Channels -->
                                            <rect x="100" y="80" width="100" height="40" fill="#27AE60" opacity="0.3"
                                                stroke="#27AE60" stroke-width="2" rx="5" />
                                            <text x="150" y="105" text-anchor="middle" font-size="13"
                                                fill="#333">Channel 1</text>

                                            <rect x="100" y="150" width="100" height="40" fill="#3498DB" opacity="0.3"
                                                stroke="#3498DB" stroke-width="2" rx="5" />
                                            <text x="150" y="175" text-anchor="middle" font-size="13"
                                                fill="#333">Channel 2</text>

                                            <rect x="100" y="220" width="100" height="40" fill="#F39C12" opacity="0.3"
                                                stroke="#F39C12" stroke-width="2" rx="5" />
                                            <text x="150" y="245" text-anchor="middle" font-size="13"
                                                fill="#333">Channel 3</text>

                                            <!-- Arrows to select -->
                                            <path d="M 200 100 L 280 160" stroke="#27AE60" stroke-width="2" />
                                            <path d="M 200 170 L 280 170" stroke="#3498DB" stroke-width="2" />
                                            <path d="M 200 240 L 280 180" stroke="#F39C12" stroke-width="2" />

                                            <!-- Select box -->
                                            <rect x="280" y="130" width="140" height="80" fill="#E74C3C" opacity="0.2"
                                                stroke="#E74C3C" stroke-width="3" rx="5" />
                                            <text x="350" y="160" text-anchor="middle" font-size="16" font-weight="bold"
                                                fill="#E74C3C">SELECT</text>
                                            <text x="350" y="185" text-anchor="middle" font-size="12" fill="#333">Waits
                                                for first</text>
                                            <text x="350" y="200" text-anchor="middle" font-size="12" fill="#333">ready
                                                channel</text>

                                            <!-- Cases -->
                                            <rect x="480" y="70" width="280" height="220" fill="#f0f0f0" stroke="#ccc"
                                                stroke-width="1" rx="5" />
                                            <text x="620" y="95" text-anchor="middle" font-size="14" font-weight="bold"
                                                fill="#333">select {</text>

                                            <text x="500" y="125" font-size="12" font-family="monospace"
                                                fill="#27AE60">case v := <-ch1:< /text>
                                                    <text x="520" y="145" font-size="11" font-family="monospace"
                                                        fill="#666">// Handle ch1</text>

                                                    <text x="500" y="175" font-size="12" font-family="monospace"
                                                        fill="#3498DB">case v := <-ch2:< /text>
                                                            <text x="520" y="195" font-size="11" font-family="monospace"
                                                                fill="#666">// Handle ch2</text>

                                                            <text x="500" y="225" font-size="12" font-family="monospace"
                                                                fill="#F39C12">case v := <-ch3:< /text>
                                                                    <text x="520" y="245" font-size="11"
                                                                        font-family="monospace" fill="#666">// Handle
                                                                        ch3</text>

                                                                    <text x="620" y="275" text-anchor="middle"
                                                                        font-size="14" font-weight="bold"
                                                                        fill="#333">}</text>

                                                                    <text x="400" y="325" text-anchor="middle"
                                                                        font-size="12" fill="#666">Blocks until one case
                                                                        can proceed</text>
                                        </svg>
                                        <div class="diagram-caption">Select waits for the first ready channel</div>
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/channels-select.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-select" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Select Behavior:</strong>
                                        <ul>
                                            <li>Waits until one case can proceed</li>
                                            <li>If multiple cases ready, chooses randomly</li>
                                            <li>Default case runs if no channel ready</li>
                                            <li>Empty select blocks forever</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Timeout Pattern -->
                                    <h2>Timeout Pattern</h2>
                                    <p>Use select with time.After for timeouts:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/channels-select.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-timeout" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Non-blocking Operations -->
                                    <h2>Non-blocking Channel Operations</h2>
                                    <pre><code class="language-go">// Non-blocking receive
select {
case msg := <-ch:
    fmt.Println("Received:", msg)
default:
    fmt.Println("No message")
}

// Non-blocking send
select {
case ch <- msg:
    fmt.Println("Sent message")
default:
    fmt.Println("Channel full")
}</code></pre>

                                    <!-- Section 4: Common Patterns -->
                                    <h2>Common Concurrency Patterns</h2>

                                    <h3>1. Done Channel Pattern</h3>
                                    <pre><code class="language-go">func worker(done <-chan bool) {
    for {
        select {
        case <-done:
            fmt.Println("Worker stopping")
            return
        default:
            // Do work
            fmt.Println("Working...")
            time.Sleep(time.Second)
        }
    }
}

func main() {
    done := make(chan bool)
    go worker(done)
    
    time.Sleep(3 * time.Second)
    done <- true  // Signal worker to stop
    time.Sleep(time.Second)
}</code></pre>

                                    <h3>2. Ticker Pattern</h3>
                                    <pre><code class="language-go">func main() {
    ticker := time.NewTicker(500 * time.Millisecond)
    done := make(chan bool)
    
    go func() {
        for {
            select {
            case <-done:
                return
            case t := <-ticker.C:
                fmt.Println("Tick at", t)
            }
        }
    }()
    
    time.Sleep(2 * time.Second)
    ticker.Stop()
    done <- true
}</code></pre>

                                    <h3>3. Context Pattern</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/context-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-context" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use context.Context for cancellation and
                                        timeouts in
                                        production code. It's the standard way to manage goroutine lifecycles.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting default in non-blocking select</h4>
                                        <pre><code class="language-go">// ❌ Wrong - blocks if channel not ready
select {
case msg := <-ch:
    fmt.Println(msg)
}

// ✅ Correct - non-blocking
select {
case msg := <-ch:
    fmt.Println(msg)
default:
    fmt.Println("No message")
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Not handling all channels in loop</h4>
                                        <pre><code class="language-go">// ❌ Wrong - done channel ignored in loop
for {
    select {
    case msg := <-messages:
        fmt.Println(msg)
    }
    // done channel never checked!
}

// ✅ Correct - check done channel
for {
    select {
    case <-done:
        return
    case msg := <-messages:
        fmt.Println(msg)
    }
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Rate Limiter</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a rate limiter using select and ticker.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Process requests at most once per second</li>
                                            <li>Use time.Ticker for rate limiting</li>
                                            <li>Handle 5 requests</li>
                                            <li>Print when each request is processed</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
    "time"
)

func main() {
    requests := make(chan int, 5)
    for i := 1; i <= 5; i++ {
        requests <- i
    }
    close(requests)
    
    // Rate limiter: 1 request per second
    limiter := time.NewTicker(time.Second)
    defer limiter.Stop()
    
    fmt.Println("Rate Limiter: Processing requests...")
    fmt.Println("====================================")
    
    for req := range requests {
        <-limiter.C  // Wait for tick
        fmt.Printf("Request %d processed at %s\n", req, time.Now().Format("15:04:05"))
    }
    
    fmt.Println("====================================")
    fmt.Println("All requests processed!")
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>select</strong> waits on multiple channel operations</li>
                                            <li><strong>Random choice</strong> if multiple cases ready</li>
                                            <li><strong>default case</strong> makes select non-blocking</li>
                                            <li><strong>Timeout pattern</strong> with time.After</li>
                                            <li><strong>Done channel</strong> signals goroutine termination</li>
                                            <li><strong>Ticker</strong> for periodic operations</li>
                                            <li><strong>Context</strong> for cancellation and timeouts</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing the Concurrency module! You've mastered goroutines,
                                        channels,
                                        and select—Go's most powerful features. Next, you'll explore <strong>Packages &
                                            Standard
                                            Library</strong> to build real-world applications!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="channels.jsp" />
                                    <jsp:param name="prevTitle" value="Channels" />
                                    <jsp:param name="nextLink" value="sync-context.jsp" />
                                    <jsp:param name="nextTitle" value="Sync & Context" />
                                    <jsp:param name="currentLessonId" value="select-patterns" />
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