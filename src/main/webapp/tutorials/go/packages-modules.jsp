<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "packages-modules" );
        request.setAttribute("currentModule", "Packages & Standard Library" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Packages & Modules in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go packages, modules, imports, exports, go.mod, and package organization. Master Go project structure.">
            <meta name="keywords"
                content="go packages, golang modules, go.mod, go imports, package organization, go project structure">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Packages & Modules in Go">
            <meta property="og:description" content="Master Go packages and module system.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/packages-modules.jsp">
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
    "name": "Packages & Modules in Go",
    "description": "Learn Go packages, modules, and project organization with examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/packages-modules.jsp",
    "teaches": ["packages", "modules", "imports", "exports", "go.mod"],
    "timeRequired": "PT30M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="packages-modules">
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
                                    <span>Packages & Modules</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Packages & Modules</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Packages are Go's way of organizing code. Modules are collections of
                                        packages
                                        with versioning. In this lesson, you'll learn how to create packages, use
                                        modules, and
                                        organize Go projects professionally.</p>

                                    <!-- Section 1: Packages -->
                                    <h2>What is a Package?</h2>
                                    <p>A package is a collection of Go source files in the same directory that are
                                        compiled
                                        together.</p>

                                    <div class="info-box">
                                        <strong>Package Rules:</strong>
                                        <ul>
                                            <li>Every Go file belongs to a package</li>
                                            <li>Package name is declared at the top: <code>package name</code></li>
                                            <li>Package name should match directory name (convention)</li>
                                            <li><code>main</code> package is special—it's executable</li>
                                            <li>Exported names start with capital letter</li>
                                        </ul>
                                    </div>

                                    <h3>Creating a Package</h3>
                                    <pre><code class="language-go">// File: math/calculator.go
package math

// Add is exported (capital A)
func Add(a, b int) int {
    return a + b
}

// subtract is not exported (lowercase s)
func subtract(a, b int) int {
    return a - b
}</code></pre>

                                    <h3>Using a Package</h3>
                                    <pre><code class="language-go">// File: main.go
package main

import (
    "fmt"
    "myproject/math"  // Import custom package
)

func main() {
    result := math.Add(5, 3)
    fmt.Println(result)  // 8
    
    // math.subtract(5, 3)  // Error: subtract is not exported
}</code></pre>

                                    <!-- Section 2: Modules -->
                                    <h2>Go Modules</h2>
                                    <p>Modules are collections of packages with dependency management and versioning.
                                    </p>

                                    <h3>Creating a Module</h3>
                                    <pre><code class="language-bash"># Initialize a new module
go mod init github.com/username/myproject

# This creates go.mod file</code></pre>

                                    <h3>go.mod File</h3>
                                    <pre><code class="language-go">module github.com/username/myproject

go 1.21

require (
    github.com/gorilla/mux v1.8.0
    github.com/lib/pq v1.10.9
)</code></pre>

                                    <div class="info-box">
                                        <strong>Module Commands:</strong>
                                        <ul>
                                            <li><code>go mod init</code> - Initialize module</li>
                                            <li><code>go mod tidy</code> - Add missing/remove unused dependencies</li>
                                            <li><code>go get package@version</code> - Add/update dependency</li>
                                            <li><code>go mod download</code> - Download dependencies</li>
                                            <li><code>go mod vendor</code> - Copy dependencies to vendor/</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Project Structure -->
                                    <h2>Project Structure</h2>

                                    <h3>Standard Layout</h3>
                                    <pre><code class="language-plaintext">myproject/
├── go.mod
├── go.sum
├── main.go
├── cmd/
│   └── server/
│       └── main.go
├── internal/
│   ├── auth/
│   │   └── auth.go
│   └── database/
│       └── db.go
├── pkg/
│   └── utils/
│       └── helpers.go
└── vendor/</code></pre>

                                    <div class="info-box">
                                        <strong>Directory Conventions:</strong>
                                        <ul>
                                            <li><code>cmd/</code> - Main applications (executables)</li>
                                            <li><code>internal/</code> - Private packages (not importable by others)
                                            </li>
                                            <li><code>pkg/</code> - Public packages (importable by others)</li>
                                            <li><code>vendor/</code> - Vendored dependencies</li>
                                            <li><code>api/</code> - API definitions (OpenAPI, Protocol Buffers)</li>
                                            <li><code>web/</code> - Web assets (HTML, CSS, JS)</li>
                                        </ul>
                                    </div>

                                    <!-- Section 4: Imports -->
                                    <h2>Import Statements</h2>

                                    <h3>Import Styles</h3>
                                    <pre><code class="language-go">// Single import
import "fmt"

// Multiple imports
import (
    "fmt"
    "os"
    "strings"
)

// Aliased import
import (
    f "fmt"
    str "strings"
)

// Blank import (for side effects)
import _ "github.com/lib/pq"

// Dot import (not recommended)
import . "fmt"  // Now can use Println instead of fmt.Println</code></pre>

                                    <h3>Import Paths</h3>
                                    <pre><code class="language-go">import (
    // Standard library
    "fmt"
    "net/http"
    
    // External packages
    "github.com/gorilla/mux"
    "github.com/lib/pq"
    
    // Local packages
    "myproject/internal/auth"
    "myproject/pkg/utils"
)</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Group imports into three sections: standard
                                        library,
                                        external packages, and local packages. Use <code>goimports</code> to format
                                        automatically.
                                    </div>

                                    <!-- Section 5: Exports -->
                                    <h2>Exported vs Unexported</h2>

                                    <pre><code class="language-go">package user

// Exported type (capital U)
type User struct {
    Name  string  // Exported field
    email string  // Unexported field
}

// Exported function
func NewUser(name, email string) *User {
    return &User{
        Name:  name,
        email: email,
    }
}

// Exported method
func (u *User) GetEmail() string {
    return u.email
}

// Unexported function
func validateEmail(email string) bool {
    return strings.Contains(email, "@")
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use unexported fields with exported getter/setter
                                        methods to
                                        control access and maintain encapsulation.
                                    </div>

                                    <!-- Section 6: Init Function -->
                                    <h2>Package Initialization</h2>

                                    <pre><code class="language-go">package database

import "database/sql"

var db *sql.DB

// init runs automatically when package is imported
func init() {
    var err error
    db, err = sql.Open("postgres", "connection-string")
    if err != nil {
        panic(err)
    }
}

func GetDB() *sql.DB {
    return db
}</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> <code>init()</code> functions run automatically in
                                        order:
                                        <ol>
                                            <li>Imported packages' init functions</li>
                                            <li>Package-level variables</li>
                                            <li>Current package's init functions</li>
                                        </ol>
                                        Use sparingly—explicit initialization is often better!
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Circular imports</h4>
                                        <pre><code class="language-go">// ❌ Wrong - circular dependency
// package a imports package b
// package b imports package a
// Error: import cycle not allowed

// ✅ Correct - extract common code
// Create package c with shared code
// Both a and b import c</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Package name doesn't match directory</h4>
                                        <pre><code class="language-go">// ❌ Wrong
// Directory: utils/
// File: package helpers

// ✅ Correct
// Directory: utils/
// File: package utils</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not using go mod tidy</h4>
                                        <pre><code class="language-bash"># ❌ Wrong - manually editing go.mod
# Don't manually add dependencies

# ✅ Correct - use go commands
go get github.com/gorilla/mux
go mod tidy  # Clean up</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Create a Math Package</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a reusable math package.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a module called <code>mathlib</code></li>
                                            <li>Create package <code>calculator</code> with Add, Subtract, Multiply,
                                                Divide</li>
                                            <li>Create package <code>geometry</code> with Circle and Rectangle types
                                            </li>
                                            <li>Export appropriate functions and types</li>
                                            <li>Use from main.go</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-bash"># Project structure
mathlib/
├── go.mod
├── main.go
├── calculator/
│   └── calculator.go
└── geometry/
    └── shapes.go</code></pre>

                                            <pre><code class="language-go">// go.mod
module mathlib

go 1.21

// calculator/calculator.go
package calculator

func Add(a, b float64) float64 {
    return a + b
}

func Subtract(a, b float64) float64 {
    return a - b
}

func Multiply(a, b float64) float64 {
    return a * b
}

func Divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, fmt.Errorf("division by zero")
    }
    return a / b, nil
}

// geometry/shapes.go
package geometry

import "math"

type Circle struct {
    Radius float64
}

func (c Circle) Area() float64 {
    return math.Pi * c.Radius * c.Radius
}

func (c Circle) Perimeter() float64 {
    return 2 * math.Pi * c.Radius
}

type Rectangle struct {
    Width  float64
    Height float64
}

func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

func (r Rectangle) Perimeter() float64 {
    return 2 * (r.Width + r.Height)
}

// main.go
package main

import (
    "fmt"
    "mathlib/calculator"
    "mathlib/geometry"
)

func main() {
    // Calculator
    sum := calculator.Add(10, 5)
    fmt.Printf("10 + 5 = %.2f\n", sum)
    
    diff := calculator.Subtract(10, 5)
    fmt.Printf("10 - 5 = %.2f\n", diff)
    
    product := calculator.Multiply(10, 5)
    fmt.Printf("10 * 5 = %.2f\n", product)
    
    quotient, err := calculator.Divide(10, 5)
    if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Printf("10 / 5 = %.2f\n", quotient)
    }
    
    // Geometry
    circle := geometry.Circle{Radius: 5}
    fmt.Printf("\nCircle (r=5):\n")
    fmt.Printf("  Area: %.2f\n", circle.Area())
    fmt.Printf("  Perimeter: %.2f\n", circle.Perimeter())
    
    rect := geometry.Rectangle{Width: 4, Height: 6}
    fmt.Printf("\nRectangle (4x6):\n")
    fmt.Printf("  Area: %.2f\n", rect.Area())
    fmt.Printf("  Perimeter: %.2f\n", rect.Perimeter())
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Packages</strong> organize code into reusable units</li>
                                            <li><strong>Modules</strong> manage dependencies and versioning</li>
                                            <li><strong>Exported names</strong> start with capital letter</li>
                                            <li><strong>go.mod</strong> defines module and dependencies</li>
                                            <li><strong>Standard layout</strong>: cmd/, internal/, pkg/</li>
                                            <li><strong>init()</strong> runs automatically on import</li>
                                            <li><strong>Avoid circular imports</strong> by extracting common code</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand packages and modules, you're ready to learn about
                                        <strong>File
                                            I/O</strong>. You'll discover how to read and write files, work with
                                        directories, and
                                        handle file operations in Go.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="goroutines-waitgroups.jsp" />
                                    <jsp:param name="prevTitle" value="Goroutine Coordination" />
                                    <jsp:param name="nextLink" value="file-io.jsp" />
                                    <jsp:param name="nextTitle" value="File I/O" />
                                    <jsp:param name="currentLessonId" value="packages-modules" />
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