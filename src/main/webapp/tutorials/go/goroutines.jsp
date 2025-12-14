<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "goroutines" ); request.setAttribute("currentModule", "Concurrency" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Goroutines in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go goroutines, lightweight threads, concurrent execution, and goroutine patterns. Master Go's approach to concurrency.">
            <meta name="keywords"
                content="go goroutines, golang concurrency, go lightweight threads, concurrent programming, go parallelism">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Goroutines in Go">
            <meta property="og:description" content="Master Go goroutines and concurrent programming.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/goroutines.jsp">
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
    "name": "Goroutines in Go",
    "description": "Learn Go goroutines and concurrent programming with visual diagrams and examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/goroutines.jsp",
    "teaches": ["goroutines", "concurrency", "parallelism", "concurrent programming"],
    "timeRequired": "PT40M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="goroutines">
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
                                    <span>Goroutines</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Goroutines</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Goroutines are lightweight threads managed by the Go runtime.
                                        They're one of Go's
                                        most powerful features, making concurrent programming simple and efficient. In
                                        this lesson,
                                        you'll learn how goroutines work and how to use them effectively.</p>

                                    <!-- Section 1: What is a Goroutine? -->
                                    <h2>What is a Goroutine?</h2>
                                    <p>A goroutine is a lightweight thread of execution. Unlike OS threads, goroutines
                                        are managed
                                        by the Go runtime and are extremely cheap to create.</p>

                                    <div class="diagram-container">
                                        <svg viewBox="0 0 800 400" xmlns="http://www.w3.org/2000/svg">
                                            <!-- Title -->
                                            <text x="400" y="30" text-anchor="middle" font-size="20" font-weight="bold"
                                                fill="#333">Goroutines vs OS Threads</text>

                                            <!-- OS Threads (Left) -->
                                            <text x="200" y="70" text-anchor="middle" font-size="16" font-weight="bold"
                                                fill="#E74C3C">OS Threads</text>
                                            <rect x="100" y="90" width="200" height="80" fill="#E74C3C" opacity="0.2"
                                                stroke="#E74C3C" stroke-width="2" rx="5" />
                                            <text x="200" y="120" text-anchor="middle" font-size="14" fill="#333">Heavy
                                                (~1-2 MB)</text>
                                            <text x="200" y="145" text-anchor="middle" font-size="14" fill="#333">OS
                                                Managed</text>

                                            <rect x="100" y="190" width="200" height="80" fill="#E74C3C" opacity="0.2"
                                                stroke="#E74C3C" stroke-width="2" rx="5" />
                                            <text x="200" y="220" text-anchor="middle" font-size="14"
                                                fill="#333">Expensive to create</text>
                                            <text x="200" y="245" text-anchor="middle" font-size="14"
                                                fill="#333">Context switching</text>

                                            <!-- Goroutines (Right) -->
                                            <text x="600" y="70" text-anchor="middle" font-size="16" font-weight="bold"
                                                fill="#27AE60">Goroutines</text>
                                            <rect x="500" y="90" width="200" height="40" fill="#27AE60" opacity="0.2"
                                                stroke="#27AE60" stroke-width="2" rx="5" />
                                            <text x="600" y="115" text-anchor="middle" font-size="14"
                                                fill="#333">Lightweight (~2 KB)</text>

                                            <rect x="500" y="140" width="200" height="40" fill="#27AE60" opacity="0.2"
                                                stroke="#27AE60" stroke-width="2" rx="5" />
                                            <text x="600" y="165" text-anchor="middle" font-size="14" fill="#333">Go
                                                Runtime Managed</text>

                                            <rect x="500" y="190" width="200" height="40" fill="#27AE60" opacity="0.2"
                                                stroke="#27AE60" stroke-width="2" rx="5" />
                                            <text x="600" y="215" text-anchor="middle" font-size="14" fill="#333">Cheap
                                                to create</text>

                                            <rect x="500" y="240" width="200" height="40" fill="#27AE60" opacity="0.2"
                                                stroke="#27AE60" stroke-width="2" rx="5" />
                                            <text x="600" y="265" text-anchor="middle" font-size="14"
                                                fill="#333">Efficient scheduling</text>

                                            <!-- Comparison -->
                                            <text x="400" y="320" text-anchor="middle" font-size="14"
                                                fill="#666">Thousands of goroutines = Few OS threads</text>
                                            <line x1="150" y1="330" x2="350" y2="330" stroke="#E74C3C"
                                                stroke-width="3" />
                                            <line x1="450" y1="330" x2="650" y2="330" stroke="#27AE60"
                                                stroke-width="3" />
                                            <text x="200" y="355" text-anchor="middle" font-size="12" fill="#E74C3C">1
                                                Thread</text>
                                            <text x="550" y="355" text-anchor="middle" font-size="12"
                                                fill="#27AE60">1000s Goroutines</text>
                                        </svg>
                                        <div class="diagram-caption">Goroutines are much lighter than OS threads</div>
                                    </div>

                                    <div class="info-box">
                                        <strong>Goroutine Characteristics:</strong>
                                        <ul>
                                            <li><strong>Lightweight</strong> - Start with ~2KB stack (grows as needed)
                                            </li>
                                            <li><strong>Cheap</strong> - Can create millions of goroutines</li>
                                            <li><strong>Multiplexed</strong> - Many goroutines run on few OS threads
                                            </li>
                                            <li><strong>Managed</strong> - Go runtime handles scheduling</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Creating Goroutines -->
                                    <h2>Creating Goroutines</h2>
                                    <p>Use the <code>go</code> keyword to start a goroutine:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/goroutines-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-goroutines" />
                                    </jsp:include>

                                    <div class="diagram-container">
                                        <svg viewBox="0 0 800 300" xmlns="http://www.w3.org/2000/svg">
                                            <!-- Title -->
                                            <text x="400" y="30" text-anchor="middle" font-size="18" font-weight="bold"
                                                fill="#333">Goroutine Execution Flow</text>

                                            <!-- Main goroutine -->
                                            <rect x="50" y="60" width="150" height="200" fill="#3498DB" opacity="0.2"
                                                stroke="#3498DB" stroke-width="2" rx="5" />
                                            <text x="125" y="85" text-anchor="middle" font-size="14" font-weight="bold"
                                                fill="#3498DB">Main Goroutine</text>

                                            <circle cx="125" cy="110" r="15" fill="#3498DB" />
                                            <text x="125" y="115" text-anchor="middle" font-size="10"
                                                fill="white">1</text>
                                            <text x="210" y="115" text-anchor="start" font-size="12"
                                                fill="#333">Start</text>

                                            <circle cx="125" cy="150" r="15" fill="#3498DB" />
                                            <text x="125" y="155" text-anchor="middle" font-size="10"
                                                fill="white">2</text>
                                            <text x="210" y="155" text-anchor="start" font-size="12" fill="#333">go
                                                func()</text>

                                            <circle cx="125" cy="190" r="15" fill="#3498DB" />
                                            <text x="125" y="195" text-anchor="middle" font-size="10"
                                                fill="white">3</text>
                                            <text x="210" y="195" text-anchor="start" font-size="12"
                                                fill="#333">Continue</text>

                                            <circle cx="125" cy="230" r="15" fill="#3498DB" />
                                            <text x="125" y="235" text-anchor="middle" font-size="10"
                                                fill="white">4</text>
                                            <text x="210" y="235" text-anchor="start" font-size="12"
                                                fill="#333">End</text>

                                            <!-- Arrow from main to goroutine -->
                                            <path d="M 200 150 L 400 110" stroke="#27AE60" stroke-width="2" fill="none"
                                                marker-end="url(#arrowgreen)" />
                                            <text x="300" y="120" text-anchor="middle" font-size="12"
                                                fill="#27AE60">spawns</text>

                                            <!-- New goroutines -->
                                            <rect x="420" y="60" width="150" height="80" fill="#27AE60" opacity="0.2"
                                                stroke="#27AE60" stroke-width="2" rx="5" />
                                            <text x="495" y="85" text-anchor="middle" font-size="14" font-weight="bold"
                                                fill="#27AE60">Goroutine 1</text>
                                            <text x="495" y="110" text-anchor="middle" font-size="12" fill="#333">Runs
                                                concurrently</text>
                                            <text x="495" y="130" text-anchor="middle" font-size="12" fill="#333">with
                                                main</text>

                                            <rect x="420" y="160" width="150" height="80" fill="#27AE60" opacity="0.2"
                                                stroke="#27AE60" stroke-width="2" rx="5" />
                                            <text x="495" y="185" text-anchor="middle" font-size="14" font-weight="bold"
                                                fill="#27AE60">Goroutine 2</text>
                                            <text x="495" y="210" text-anchor="middle" font-size="12"
                                                fill="#333">Independent</text>
                                            <text x="495" y="230" text-anchor="middle" font-size="12"
                                                fill="#333">execution</text>

                                            <!-- Arrow marker -->
                                            <defs>
                                                <marker id="arrowgreen" markerWidth="10" markerHeight="10" refX="9"
                                                    refY="3" orient="auto" markerUnits="strokeWidth">
                                                    <path d="M0,0 L0,6 L9,3 z" fill="#27AE60" />
                                                </marker>
                                            </defs>
                                        </svg>
                                        <div class="diagram-caption">Main goroutine spawns child goroutines that run
                                            concurrently</div>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Goroutine Patterns -->
                                    <h2>Common Goroutine Patterns</h2>

                                    <h3>1. Anonymous Function Goroutines</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/goroutines-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-anonymous" />
                                    </jsp:include>

                                    <h3>2. Multiple Goroutines</h3>
                                    <pre><code class="language-go">func main() {
    for i := 0; i < 5; i++ {
        go func(id int) {
            fmt.Printf("Goroutine %d starting\n", id)
            time.Sleep(time.Second)
            fmt.Printf("Goroutine %d done\n", id)
        }(i)  // Pass i as argument!
    }
    
    time.Sleep(2 * time.Second)  // Wait for goroutines
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Always pass loop variables as arguments to
                                        goroutines! Otherwise,
                                        all goroutines will see the final value of the loop variable.
                                    </div>

                                    <!-- Section 4: WaitGroups -->
                                    <h2>Synchronizing with WaitGroups</h2>
                                    <p>Use <code>sync.WaitGroup</code> to wait for goroutines to finish:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/goroutines-waitgroup.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-waitgroup" />
                                    </jsp:include>

                                    <div class="diagram-container">
                                        <svg viewBox="0 0 800 350" xmlns="http://www.w3.org/2000/svg">
                                            <!-- Title -->
                                            <text x="400" y="30" text-anchor="middle" font-size="18" font-weight="bold"
                                                fill="#333">WaitGroup Synchronization</text>

                                            <!-- Main goroutine timeline -->
                                            <line x1="100" y1="100" x2="700" y2="100" stroke="#3498DB"
                                                stroke-width="3" />
                                            <text x="50" y="105" text-anchor="end" font-size="14"
                                                fill="#3498DB">Main</text>

                                            <!-- WaitGroup operations -->
                                            <circle cx="150" cy="100" r="8" fill="#3498DB" />
                                            <text x="150" y="85" text-anchor="middle" font-size="12"
                                                fill="#333">wg.Add(3)</text>

                                            <circle cx="650" cy="100" r="8" fill="#3498DB" />
                                            <text x="650" y="85" text-anchor="middle" font-size="12"
                                                fill="#333">wg.Wait()</text>

                                            <circle cx="700" cy="100" r="8" fill="#3498DB" />
                                            <text x="700" y="85" text-anchor="middle" font-size="12"
                                                fill="#333">Continue</text>

                                            <!-- Goroutine 1 -->
                                            <line x1="200" y1="150" x2="500" y2="150" stroke="#27AE60"
                                                stroke-width="2" />
                                            <text x="50" y="155" text-anchor="end" font-size="14" fill="#27AE60">Go
                                                1</text>
                                            <circle cx="200" cy="150" r="6" fill="#27AE60" />
                                            <circle cx="500" cy="150" r="6" fill="#27AE60" />
                                            <text x="500" y="170" text-anchor="middle" font-size="11"
                                                fill="#27AE60">wg.Done()</text>

                                            <!-- Goroutine 2 -->
                                            <line x1="200" y1="200" x2="550" y2="200" stroke="#27AE60"
                                                stroke-width="2" />
                                            <text x="50" y="205" text-anchor="end" font-size="14" fill="#27AE60">Go
                                                2</text>
                                            <circle cx="200" cy="200" r="6" fill="#27AE60" />
                                            <circle cx="550" cy="200" r="6" fill="#27AE60" />
                                            <text x="550" y="220" text-anchor="middle" font-size="11"
                                                fill="#27AE60">wg.Done()</text>

                                            <!-- Goroutine 3 -->
                                            <line x1="200" y1="250" x2="600" y2="250" stroke="#27AE60"
                                                stroke-width="2" />
                                            <text x="50" y="255" text-anchor="end" font-size="14" fill="#27AE60">Go
                                                3</text>
                                            <circle cx="200" cy="250" r="6" fill="#27AE60" />
                                            <circle cx="600" cy="250" r="6" fill="#27AE60" />
                                            <text x="600" y="270" text-anchor="middle" font-size="11"
                                                fill="#27AE60">wg.Done()</text>

                                            <!-- Wait block -->
                                            <rect x="640" y="120" width="60" height="150" fill="#E74C3C" opacity="0.1"
                                                stroke="#E74C3C" stroke-width="2" stroke-dasharray="5,5" rx="3" />
                                            <text x="670" y="300" text-anchor="middle" font-size="11"
                                                fill="#E74C3C">Blocked</text>
                                            <text x="670" y="315" text-anchor="middle" font-size="11"
                                                fill="#E74C3C">until all</text>
                                            <text x="670" y="330" text-anchor="middle" font-size="11"
                                                fill="#E74C3C">Done()</text>
                                        </svg>
                                        <div class="diagram-caption">WaitGroup blocks main until all goroutines call
                                            Done()</div>
                                    </div>

                                    <div class="info-box">
                                        <strong>WaitGroup Methods:</strong>
                                        <ul>
                                            <li><code>Add(n)</code> - Increment counter by n</li>
                                            <li><code>Done()</code> - Decrement counter by 1</li>
                                            <li><code>Wait()</code> - Block until counter is 0</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Goroutine Scheduling -->
                                    <h2>How Goroutines Are Scheduled</h2>

                                    <div class="diagram-container">
                                        <svg viewBox="0 0 800 400" xmlns="http://www.w3.org/2000/svg">
                                            <!-- Title -->
                                            <text x="400" y="30" text-anchor="middle" font-size="18" font-weight="bold"
                                                fill="#333">Go Scheduler: M:N Model</text>

                                            <!-- Goroutines (top) -->
                                            <text x="400" y="65" text-anchor="middle" font-size="14" fill="#27AE60"
                                                font-weight="bold">Goroutines (G)</text>
                                            <circle cx="150" cy="100" r="20" fill="#27AE60" opacity="0.3"
                                                stroke="#27AE60" stroke-width="2" />
                                            <text x="150" y="105" text-anchor="middle" font-size="12"
                                                fill="#333">G1</text>

                                            <circle cx="250" cy="100" r="20" fill="#27AE60" opacity="0.3"
                                                stroke="#27AE60" stroke-width="2" />
                                            <text x="250" y="105" text-anchor="middle" font-size="12"
                                                fill="#333">G2</text>

                                            <circle cx="350" cy="100" r="20" fill="#27AE60" opacity="0.3"
                                                stroke="#27AE60" stroke-width="2" />
                                            <text x="350" y="105" text-anchor="middle" font-size="12"
                                                fill="#333">G3</text>

                                            <circle cx="450" cy="100" r="20" fill="#27AE60" opacity="0.3"
                                                stroke="#27AE60" stroke-width="2" />
                                            <text x="450" y="105" text-anchor="middle" font-size="12"
                                                fill="#333">G4</text>

                                            <circle cx="550" cy="100" r="20" fill="#27AE60" opacity="0.3"
                                                stroke="#27AE60" stroke-width="2" />
                                            <text x="550" y="105" text-anchor="middle" font-size="12"
                                                fill="#333">G5</text>

                                            <circle cx="650" cy="100" r="20" fill="#27AE60" opacity="0.3"
                                                stroke="#27AE60" stroke-width="2" />
                                            <text x="650" y="105" text-anchor="middle" font-size="12"
                                                fill="#333">G6</text>

                                            <!-- Arrows down -->
                                            <path d="M 200 130 L 200 180" stroke="#666" stroke-width="2"
                                                marker-end="url(#arrow)" />
                                            <path d="M 400 130 L 400 180" stroke="#666" stroke-width="2"
                                                marker-end="url(#arrow)" />
                                            <path d="M 600 130 L 600 180" stroke="#666" stroke-width="2"
                                                marker-end="url(#arrow)" />

                                            <!-- Go Runtime / Scheduler (middle) -->
                                            <rect x="100" y="190" width="600" height="60" fill="#3498DB" opacity="0.2"
                                                stroke="#3498DB" stroke-width="2" rx="5" />
                                            <text x="400" y="215" text-anchor="middle" font-size="14" fill="#3498DB"
                                                font-weight="bold">Go Runtime Scheduler</text>
                                            <text x="400" y="235" text-anchor="middle" font-size="12"
                                                fill="#333">Multiplexes M goroutines onto N OS threads</text>

                                            <!-- Arrows down -->
                                            <path d="M 250 260 L 250 290" stroke="#666" stroke-width="2"
                                                marker-end="url(#arrow)" />
                                            <path d="M 550 260 L 550 290" stroke="#666" stroke-width="2"
                                                marker-end="url(#arrow)" />

                                            <!-- OS Threads (bottom) -->
                                            <text x="400" y="315" text-anchor="middle" font-size="14" fill="#E74C3C"
                                                font-weight="bold">OS Threads (M)</text>
                                            <rect x="150" y="330" width="150" height="50" fill="#E74C3C" opacity="0.2"
                                                stroke="#E74C3C" stroke-width="2" rx="5" />
                                            <text x="225" y="360" text-anchor="middle" font-size="12" fill="#333">Thread
                                                1</text>

                                            <rect x="350" y="330" width="150" height="50" fill="#E74C3C" opacity="0.2"
                                                stroke="#E74C3C" stroke-width="2" rx="5" />
                                            <text x="425" y="360" text-anchor="middle" font-size="12" fill="#333">Thread
                                                2</text>

                                            <rect x="550" y="330" width="150" height="50" fill="#E74C3C" opacity="0.2"
                                                stroke="#E74C3C" stroke-width="2" rx="5" />
                                            <text x="625" y="360" text-anchor="middle" font-size="12" fill="#333">Thread
                                                3</text>

                                            <!-- Arrow marker -->
                                            <defs>
                                                <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3"
                                                    orient="auto" markerUnits="strokeWidth">
                                                    <path d="M0,0 L0,6 L9,3 z" fill="#666" />
                                                </marker>
                                            </defs>
                                        </svg>
                                        <div class="diagram-caption">Many goroutines (M) run on few OS threads (N)</div>
                                    </div>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> The Go scheduler uses a work-stealing algorithm to
                                        balance load
                                        across OS threads. You don't need to manage this—it happens automatically!
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Not waiting for goroutines</h4>
                                        <pre><code class="language-go">// ❌ Wrong - main exits before goroutine runs
func main() {
    go fmt.Println("Hello")
    // Program exits immediately!
}

// ✅ Correct - wait for goroutine
func main() {
    var wg sync.WaitGroup
    wg.Add(1)
    go func() {
        defer wg.Done()
        fmt.Println("Hello")
    }()
    wg.Wait()
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Capturing loop variables</h4>
                                        <pre><code class="language-go">// ❌ Wrong - all goroutines see final value
for i := 0; i < 5; i++ {
    go func() {
        fmt.Println(i)  // All print 5!
    }()
}

// ✅ Correct - pass as argument
for i := 0; i < 5; i++ {
    go func(n int) {
        fmt.Println(n)  // Prints 0, 1, 2, 3, 4
    }(i)
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Goroutine leaks</h4>
                                        <pre><code class="language-go">// ❌ Wrong - goroutine never exits
func leak() {
    go func() {
        for {
            // Infinite loop with no exit condition
            time.Sleep(time.Second)
        }
    }()
}

// ✅ Correct - provide exit mechanism
func noLeak(ctx context.Context) {
    go func() {
        for {
            select {
            case <-ctx.Done():
                return  // Exit when context cancelled
            default:
                time.Sleep(time.Second)
            }
        }
    }()
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Concurrent URL Fetcher</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a concurrent URL fetcher using goroutines.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Fetch multiple URLs concurrently</li>
                                            <li>Use WaitGroup to wait for all fetches</li>
                                            <li>Print the status of each fetch</li>
                                            <li>Measure total time taken</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
    "net/http"
    "sync"
    "time"
)

func fetchURL(url string, wg *sync.WaitGroup) {
    defer wg.Done()
    
    start := time.Now()
    resp, err := http.Get(url)
    duration := time.Since(start)
    
    if err != nil {
        fmt.Printf("❌ %s - Error: %v (%.2fs)\n", url, err, duration.Seconds())
        return
    }
    defer resp.Body.Close()
    
    fmt.Printf("✅ %s - Status: %s (%.2fs)\n", url, resp.Status, duration.Seconds())
}

func main() {
    urls := []string{
        "https://golang.org",
        "https://google.com",
        "https://github.com",
        "https://stackoverflow.com",
        "https://reddit.com",
    }
    
    var wg sync.WaitGroup
    start := time.Now()
    
    fmt.Println("Fetching URLs concurrently...")
    fmt.Println("==============================")
    
    for _, url := range urls {
        wg.Add(1)
        go fetchURL(url, &wg)
    }
    
    wg.Wait()
    
    totalDuration := time.Since(start)
    fmt.Println("==============================")
    fmt.Printf("Total time: %.2fs\n", totalDuration.Seconds())
    fmt.Printf("Fetched %d URLs concurrently\n", len(urls))
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Goroutines</strong> are lightweight threads managed by Go
                                                runtime</li>
                                            <li><strong>go keyword</strong> starts a new goroutine</li>
                                            <li><strong>Very cheap</strong> - can create millions of goroutines</li>
                                            <li><strong>WaitGroup</strong> synchronizes goroutine completion</li>
                                            <li><strong>Pass loop variables</strong> as arguments to goroutines</li>
                                            <li><strong>M:N scheduling</strong> - many goroutines on few OS threads</li>
                                            <li><strong>Always provide exit</strong> mechanisms to avoid leaks</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand goroutines, you're ready to learn about
                                        <strong>Channels</strong>—Go's
                                        way of communicating between goroutines. Channels make concurrent programming
                                        safe and
                                        elegant!
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="errors-wrapping.jsp" />
                                    <jsp:param name="prevTitle" value="Error Wrapping" />
                                    <jsp:param name="nextLink" value="channels.jsp" />
                                    <jsp:param name="nextTitle" value="Channels" />
                                    <jsp:param name="currentLessonId" value="goroutines" />
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