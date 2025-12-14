<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "intro" ); request.setAttribute("currentModule", "Getting Started" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Go Tutorial for Beginners - Learn Golang | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go (Golang) programming from scratch. Free Go tutorial for beginners with interactive examples. Master simplicity, concurrency, and performance. Start coding today!">
            <meta name="keywords"
                content="go tutorial, golang tutorial, learn go, learn golang, go programming, golang programming, go beginner, golang beginner, go examples, golang course, go online tutorial">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Introduction to Go - Simple, Fast, Reliable">
            <meta property="og:description"
                content="Master Go: the programming language built for modern cloud and infrastructure development.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/intro.jsp">
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
    "name": "Go Tutorial for Beginners - Learn Golang",
    "description": "Learn Go (Golang) programming from scratch. Free Go tutorial for beginners with interactive examples. Master simplicity, concurrency, and performance.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/intro.jsp",
    "keywords": "go tutorial, golang tutorial, learn go, learn golang, go programming, golang programming, go beginner, golang beginner, go examples, golang course",
    "teaches": ["Go basics", "Golang introduction", "Go philosophy", "Why Go", "Go use cases", "Getting started with Go", "Go vs other languages"],
    "timeRequired": "PT30M",
    "isPartOf": {
        "@type": "Course",
        "name": "Go Tutorial",
        "description": "Complete Go (Golang) programming course from beginner to advanced with interactive examples",
        "url": "https://8gwifi.org/tutorials/go/",
        "provider": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        }
    },
    "author": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
    }
}
    </script>

            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        {
            "@type": "ListItem",
            "position": 1,
            "name": "Tutorials",
            "item": "https://8gwifi.org/tutorials/"
        },
        {
            "@type": "ListItem",
            "position": 2,
            "name": "Go",
            "item": "https://8gwifi.org/tutorials/go/"
        },
        {
            "@type": "ListItem",
            "position": 3,
            "name": "Introduction"
        }
    ]
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="intro">
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
                                    <span>Introduction</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Introduction to Go</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Go (also called Golang) is a modern programming language designed by
                                        Google for building simple, reliable, and efficient software. With its focus on
                                        simplicity, fast compilation, and built-in concurrency, Go has become the
                                        language of choice for cloud infrastructure, DevOps tools, and microservices.
                                    </p>

                                    <!-- Section 1: What is Go? -->
                                    <h2>What is Go?</h2>
                                    <p>Go is a statically-typed, compiled programming language created at Google in 2009
                                        by Robert Griesemer, Rob Pike, and Ken Thompson. It was designed to address
                                        shortcomings in other languages while combining the best features of both
                                        compiled and interpreted languages.</p>

                                    <div class="info-box">
                                        <strong>Key Features:</strong>
                                        <ul>
                                            <li><strong>Simple Syntax:</strong> Clean, readable code with minimal
                                                keywords</li>
                                            <li><strong>Fast Compilation:</strong> Near-instant builds, even for large
                                                projects</li>
                                            <li><strong>Built-in Concurrency:</strong> Goroutines and channels make
                                                concurrent programming easy</li>
                                            <li><strong>Static Binaries:</strong> Single executable with no dependencies
                                            </li>
                                            <li><strong>Garbage Collection:</strong> Automatic memory management</li>
                                            <li><strong>Standard Library:</strong> Rich, comprehensive standard library
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-intro-features.svg"
                                            alt="Go Programming Language - Key Features" class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Go's Six Core Strengths - Simple, Concurrent,
                                            Productive, Reliable, Scalable, and Modern</p>
                                    </div>

                                    <h3>Your First Go Program</h3>
                                    <p>Let's start with the traditional "Hello, World!" program to see Go in action:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/intro-what-is-go.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-intro" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Every Go program starts with a <code>package</code>
                                        declaration. The <code>main</code> package is special—it defines an executable
                                        program rather than a library. The <code>main()</code> function is the entry
                                        point of your program.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: Why Choose Go? -->
                                    <h2>Why Choose Go?</h2>
                                    <p>Go was created to solve real-world problems at Google's scale. Here's why it has
                                        become so popular:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Problem</th>
                                                <th>Traditional Approach</th>
                                                <th>Go Solution</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Slow Compilation</td>
                                                <td>C++ can take hours to build</td>
                                                <td>Compiles in seconds</td>
                                            </tr>
                                            <tr>
                                                <td>Complex Syntax</td>
                                                <td>C++ templates, Java verbosity</td>
                                                <td>25 keywords, simple grammar</td>
                                            </tr>
                                            <tr>
                                                <td>Concurrency</td>
                                                <td>Threads, locks, complex patterns</td>
                                                <td>Goroutines and channels</td>
                                            </tr>
                                            <tr>
                                                <td>Deployment</td>
                                                <td>Dependencies, runtime requirements</td>
                                                <td>Single static binary</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Real-World Use Cases</h3>
                                    <p>Go powers some of the most critical infrastructure in the world:</p>
                                    <ul>
                                        <li><strong>Docker:</strong> Container platform revolutionizing deployment</li>
                                        <li><strong>Kubernetes:</strong> Container orchestration system</li>
                                        <li><strong>Terraform:</strong> Infrastructure as code tool</li>
                                        <li><strong>Prometheus:</strong> Monitoring and alerting toolkit</li>
                                        <li><strong>Etcd:</strong> Distributed key-value store</li>
                                        <li><strong>Hugo:</strong> Fast static site generator</li>
                                        <li><strong>CockroachDB:</strong> Distributed SQL database</li>
                                    </ul>

                                    <!-- Section 3: The Go Philosophy -->
                                    <h2>The Go Philosophy</h2>
                                    <p>Go's design is guided by core principles that make it unique:</p>

                                    <div class="best-practice-box">
                                        <strong>Simplicity:</strong> Go deliberately has a small language specification.
                                        There's usually one obvious way to do things, making code easier to read and
                                        maintain. "Less is more" is a core Go principle.
                                    </div>

                                    <div class="best-practice-box">
                                        <strong>Practicality:</strong> Go was built to solve real problems at scale. It
                                        prioritizes practical solutions over theoretical purity. Features are added only
                                        when they solve concrete problems.
                                    </div>

                                    <div class="best-practice-box">
                                        <strong>Concurrency:</strong> Go makes concurrent programming accessible through
                                        goroutines and channels. You can write concurrent code that's both efficient and
                                        easy to understand.
                                    </div>

                                    <div class="warning-box">
                                        <strong>Learning Curve:</strong> While Go's syntax is simple, some concepts like
                                        interfaces, goroutines, and channels may be new if you're coming from languages
                                        like Python or JavaScript. The good news? Once you understand these concepts,
                                        they're incredibly powerful!
                                    </div>

                                    <!-- Section 4: Go vs Other Languages -->
                                    <h2>Go vs Other Languages</h2>
                                    <p>Understanding where Go fits in the programming language ecosystem:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Language</th>
                                                <th>Speed</th>
                                                <th>Simplicity</th>
                                                <th>Best For</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Go</strong></td>
                                                <td>⚡⚡⚡</td>
                                                <td>✨✨✨</td>
                                                <td>Cloud services, CLI tools, DevOps</td>
                                            </tr>
                                            <tr>
                                                <td>Python</td>
                                                <td>⚡</td>
                                                <td>✨✨✨</td>
                                                <td>Scripting, data science, web</td>
                                            </tr>
                                            <tr>
                                                <td>Java</td>
                                                <td>⚡⚡</td>
                                                <td>✨</td>
                                                <td>Enterprise applications, Android</td>
                                            </tr>
                                            <tr>
                                                <td>Rust</td>
                                                <td>⚡⚡⚡</td>
                                                <td>✨</td>
                                                <td>Systems programming, performance-critical</td>
                                            </tr>
                                            <tr>
                                                <td>Node.js</td>
                                                <td>⚡⚡</td>
                                                <td>✨✨</td>
                                                <td>Web servers, real-time apps</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 5: Installation Overview -->
                                    <h2>Getting Started with Go</h2>
                                    <p>Installing Go is straightforward on all major platforms:</p>

                                    <h3>Installation Steps</h3>
                                    <ol>
                                        <li><strong>Download:</strong> Visit <a href="https://go.dev/dl/"
                                                target="_blank" rel="noopener">go.dev/dl/</a> and download the installer
                                            for your OS</li>
                                        <li><strong>Install:</strong> Run the installer (it sets up everything
                                            automatically)</li>
                                        <li><strong>Verify:</strong> Open a terminal and run <code>go version</code>
                                        </li>
                                    </ol>

                                    <p>Let's verify your Go installation:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/intro-setup.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-setup" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Go Modules:</strong> Modern Go uses modules for dependency management.
                                        You don't need to set up a GOPATH anymore! We'll cover modules in the next
                                        lesson.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Expecting Go to be like Java or C++</h4>
                                        <p>Go is intentionally minimal. There are no classes, no inheritance, no
                                            generics (until Go 1.18), and no exceptions. This simplicity is a feature,
                                            not a limitation!</p>
                                        <pre><code class="language-go">// Go doesn't have classes, but has structs and methods
type Person struct {
    Name string
    Age  int
}

// Methods are defined outside the struct
func (p Person) Greet() string {
    return "Hello, I'm " + p.Name
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Not using gofmt</h4>
                                        <p>Go has an official code formatter (<code>gofmt</code>) that enforces a
                                            standard style. Always format your code! Most editors do this automatically.
                                        </p>
                                        <pre><code class="language-bash"># Format a single file
go fmt myfile.go

# Format all files in current directory
go fmt ./...</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Ignoring error handling</h4>
                                        <p>Go uses explicit error returns instead of exceptions. Always check errors!
                                            The compiler will warn you about unused values.</p>
                                        <pre><code class="language-go">// Wrong: ignoring errors
data, _ := os.ReadFile("file.txt")  // Don't do this!

// Correct: handle errors
data, err := os.ReadFile("file.txt")
if err != nil {
    log.Fatal(err)
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Your First Go Program</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a program that introduces yourself and your
                                            interest in Go.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a variable for your name</li>
                                            <li>Create a variable for your favorite programming language (before Go!)
                                            </li>
                                            <li>Print a message introducing yourself</li>
                                            <li>Print why you're learning Go</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="go/hello-world.go" />
                                            <jsp:param name="language" value="go" />
                                            <jsp:param name="editorId" value="exercise-intro" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

func main() {
    // Variables using short declaration
    name := "Alice"
    previousLanguage := "Python"
    
    // Print introduction
    fmt.Printf("Hi, I'm %s!\n", name)
    fmt.Printf("I used to code in %s.\n", previousLanguage)
    fmt.Println("Now I'm learning Go because:")
    fmt.Println("  • It's simple and fast")
    fmt.Println("  • Great for cloud services")
    fmt.Println("  • Built-in concurrency!")
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Go is a modern, compiled language</strong> designed for
                                                simplicity, speed, and reliability</li>
                                            <li><strong>Created by Google</strong> to solve real-world problems at scale
                                            </li>
                                            <li><strong>Fast compilation</strong> makes development productive and
                                                enjoyable</li>
                                            <li><strong>Built-in concurrency</strong> with goroutines and channels</li>
                                            <li><strong>Single static binary</strong> deployment makes distribution easy
                                            </li>
                                            <li><strong>Powers critical infrastructure</strong> like Docker, Kubernetes,
                                                and Terraform</li>
                                            <li><strong>Simple syntax</strong> with only 25 keywords</li>
                                            <li><strong>Rich standard library</strong> for common tasks</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand what Go is and why it's valuable, it's time to write
                                        your first real Go program! In the next lesson, we'll cover <strong>Hello World
                                            & Workspace</strong>, where you'll learn about Go's project structure, the
                                        <code>main</code> package, and Go modules.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="" />
                                    <jsp:param name="prevTitle" value="" />
                                    <jsp:param name="nextLink" value="hello-world.jsp" />
                                    <jsp:param name="nextTitle" value="Hello World & Workspace" />
                                    <jsp:param name="currentLessonId" value="intro" />
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