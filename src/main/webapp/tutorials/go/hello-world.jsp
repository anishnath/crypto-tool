<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "hello-world" ); request.setAttribute("currentModule", "Getting Started" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Hello World & Workspace - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to write your first Go program, understand Go modules, and set up your workspace. Free interactive tutorial with examples.">
            <meta name="keywords"
                content="go hello world, golang hello world, go modules, go workspace, go run, go build, learn go, go tutorial">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Hello World & Workspace - Go Tutorial">
            <meta property="og:description"
                content="Write your first Go program and learn about Go modules and workspace setup.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/hello-world.jsp">
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
    "name": "Hello World & Workspace - Go Tutorial",
    "description": "Learn how to write your first Go program, understand Go modules, and set up your workspace.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/hello-world.jsp",
    "keywords": "go hello world, golang hello world, go modules, go workspace, go run, go build",
    "teaches": ["Hello World program", "Go modules", "Go workspace", "go run command", "go build command", "package main", "func main"],
    "timeRequired": "PT30M",
    "isPartOf": {
        "@type": "Course",
        "name": "Go Tutorial",
        "description": "Complete Go programming course from beginner to advanced",
        "url": "https://8gwifi.org/tutorials/go/",
        "provider": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        }
    }
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="hello-world">
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
                                    <span>Hello World & Workspace</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Hello World & Workspace</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">In this lesson, you'll write your first Go program, understand the
                                        structure
                                        of a Go application, and learn how to use Go modules for dependency management.
                                        By the end,
                                        you'll know how to create, run, and build Go programs.</p>

                                    <!-- Section 1: Your First Go Program -->
                                    <h2>Your First Go Program</h2>
                                    <p>Let's start with the classic "Hello, World!" program. This simple program
                                        demonstrates
                                        the basic structure of every Go application.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/hello-world.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-hello" />
                                    </jsp:include>

                                    <h3>Understanding the Code</h3>
                                    <p>Let's break down each part of this program:</p>

                                    <div class="info-box">
                                        <strong>Code Breakdown:</strong>
                                        <ul>
                                            <li><code>package main</code> - Declares this file belongs to the main
                                                package. The main
                                                package is special—it defines an executable program.</li>
                                            <li><code>import "fmt"</code> - Imports the fmt (format) package from the
                                                standard library
                                                for formatted I/O.</li>
                                            <li><code>func main()</code> - The main function is the entry point of the
                                                program. Every
                                                executable Go program must have a main function in the main package.
                                            </li>
                                            <li><code>fmt.Println()</code> - Prints text to the console with a newline.
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> In Go, the opening brace <code>{</code> must be on the
                                        same line as
                                        the function declaration. This is enforced by the language syntax!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: Running Go Programs -->
                                    <h2>Running Go Programs</h2>
                                    <p>Go provides two main ways to execute your code:</p>

                                    <h3>1. go run (Quick Execution)</h3>
                                    <p>The <code>go run</code> command compiles and runs your program in one step. It's
                                        perfect for
                                        development and testing:</p>

                                    <pre><code class="language-bash"># Run the program directly
go run hello-world.go

# Output: Hello, World!</code></pre>

                                    <div class="info-box">
                                        <strong>How it works:</strong> <code>go run</code> compiles your code to a
                                        temporary executable
                                        and runs it immediately. The executable is deleted after the program finishes.
                                    </div>

                                    <h3>2. go build (Create Executable)</h3>
                                    <p>The <code>go build</code> command creates a standalone executable file:</p>

                                    <pre><code class="language-bash"># Build an executable
go build hello-world.go

# This creates an executable named 'hello-world' (or 'hello-world.exe' on Windows)

# Run the executable
./hello-world

# Output: Hello, World!</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use <code>go run</code> during development for
                                        quick testing,
                                        and <code>go build</code> when you need to distribute your program or measure
                                        performance.
                                    </div>

                                    <!-- Section 3: Go Modules -->
                                    <h2>Go Modules</h2>
                                    <p>Go modules are the standard way to manage dependencies in Go projects. A module
                                        is a collection
                                        of related Go packages that are versioned together.</p>

                                    <h3>Creating a Module</h3>
                                    <p>To create a new Go module, use the <code>go mod init</code> command:</p>

                                    <pre><code class="language-bash"># Create a new directory for your project
mkdir myproject
cd myproject

# Initialize a new module
go mod init example.com/myproject

# This creates a go.mod file</code></pre>

                                    <p>The <code>go.mod</code> file tracks your module's dependencies:</p>

                                    <pre><code class="language-go">module example.com/myproject

go 1.21</code></pre>

                                    <div class="info-box">
                                        <strong>Module Path:</strong> The module path (e.g.,
                                        <code>example.com/myproject</code>) is
                                        typically a URL where your code could be found. For local projects, you can use
                                        any name, but
                                        it's good practice to use a domain-style path.
                                    </div>

                                    <h3>Module Demo</h3>
                                    <p>Here's a program that demonstrates basic module concepts:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/workspace-demo.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-workspace" />
                                    </jsp:include>

                                    <!-- Section 4: Project Structure -->
                                    <h2>Go Project Structure</h2>
                                    <p>A typical Go project follows this structure:</p>

                                    <pre><code class="language-plaintext">myproject/
├── go.mod              # Module definition
├── go.sum              # Dependency checksums (auto-generated)
├── main.go             # Main application
├── utils/              # Package directory
│   └── helper.go       # Package file
└── README.md           # Documentation</code></pre>

                                    <div class="info-box">
                                        <strong>Key Points:</strong>
                                        <ul>
                                            <li>Each directory is a package</li>
                                            <li>Package name should match directory name (except for main)</li>
                                            <li>Files in the same directory must have the same package declaration</li>
                                            <li>The <code>main</code> package can be in any directory</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Package vs Module -->
                                    <h2>Package vs Module</h2>
                                    <p>Understanding the difference between packages and modules is important:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Concept</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Package</strong></td>
                                                <td>A collection of Go files in the same directory</td>
                                                <td><code>package main</code>, <code>package fmt</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Module</strong></td>
                                                <td>A collection of packages versioned together</td>
                                                <td><code>module example.com/myapp</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Import Path</strong></td>
                                                <td>How you reference a package</td>
                                                <td><code>import "fmt"</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 6: Common Commands -->
                                    <h2>Essential Go Commands</h2>
                                    <p>Here are the most important Go commands you'll use:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Command</th>
                                                <th>Purpose</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>go run</code></td>
                                                <td>Compile and run</td>
                                                <td><code>go run main.go</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>go build</code></td>
                                                <td>Compile to executable</td>
                                                <td><code>go build</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>go mod init</code></td>
                                                <td>Initialize module</td>
                                                <td><code>go mod init myapp</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>go mod tidy</code></td>
                                                <td>Clean up dependencies</td>
                                                <td><code>go mod tidy</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>go fmt</code></td>
                                                <td>Format code</td>
                                                <td><code>go fmt ./...</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>go version</code></td>
                                                <td>Check Go version</td>
                                                <td><code>go version</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Wrong package name</h4>
                                        <p>Executable programs must use <code>package main</code>:</p>
                                        <pre><code class="language-go">// ❌ Wrong - won't create executable
package myapp

func main() {
    // ...
}

// ✅ Correct
package main

func main() {
    // ...
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Missing main function</h4>
                                        <p>The main package must have a main function:</p>
                                        <pre><code class="language-go">// ❌ Wrong - no entry point
package main

func start() {
    fmt.Println("Hello")
}

// ✅ Correct
package main

func main() {
    fmt.Println("Hello")
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Incorrect brace placement</h4>
                                        <p>Opening braces must be on the same line:</p>
                                        <pre><code class="language-go">// ❌ Wrong - syntax error
func main()
{
    fmt.Println("Hello")
}

// ✅ Correct
func main() {
    fmt.Println("Hello")
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Create Your First Project</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a Go program that prints information about
                                            yourself.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ol>
                                            <li>Create a new directory called <code>myinfo</code></li>
                                            <li>Initialize it as a Go module</li>
                                            <li>Create a <code>main.go</code> file</li>
                                            <li>Print your name, age, and favorite hobby</li>
                                            <li>Use <code>fmt.Printf</code> for formatted output</li>
                                        </ol>

                                        <p><strong>Steps:</strong></p>
                                        <pre><code class="language-bash"># 1. Create and enter directory
mkdir myinfo
cd myinfo

# 2. Initialize module
go mod init myinfo

# 3. Create main.go with your code

# 4. Run it
go run main.go</code></pre>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import "fmt"

func main() {
    name := "Alice"
    age := 25
    hobby := "coding in Go"
    
    fmt.Printf("Hi! I'm %s\n", name)
    fmt.Printf("I'm %d years old\n", age)
    fmt.Printf("I love %s!\n", hobby)
    
    // Alternative: using Println
    fmt.Println("\n--- About Me ---")
    fmt.Println("Name:", name)
    fmt.Println("Age:", age)
    fmt.Println("Hobby:", hobby)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Every Go program</strong> starts with a package declaration</li>
                                            <li><strong>Executable programs</strong> use <code>package main</code> and
                                                <code>func main()</code></li>
                                            <li><strong>go run</strong> compiles and runs code in one step (development)
                                            </li>
                                            <li><strong>go build</strong> creates a standalone executable (distribution)
                                            </li>
                                            <li><strong>Go modules</strong> manage dependencies with <code>go.mod</code>
                                            </li>
                                            <li><strong>go mod init</strong> initializes a new module</li>
                                            <li><strong>Opening braces</strong> must be on the same line in Go</li>
                                            <li><strong>fmt package</strong> provides formatted I/O functions</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you can create and run Go programs, it's time to learn about
                                        <strong>Variables &
                                            Types</strong>. In the next lesson, you'll discover how to store and
                                        manipulate data in Go,
                                        including Go's type system and variable declarations.</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="intro.jsp" />
                                    <jsp:param name="prevTitle" value="Introduction" />
                                    <jsp:param name="nextLink" value="variables-types.jsp" />
                                    <jsp:param name="nextTitle" value="Variables & Types" />
                                    <jsp:param name="currentLessonId" value="hello-world" />
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