<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "best-practices" );
        request.setAttribute("currentModule", "Advanced & Professional" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Best Practices in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go best practices, idioms, code organization, error handling patterns, and professional development.">
            <meta name="keywords" content="go best practices, golang idioms, go code style, effective go, go patterns">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Best Practices in Go">
            <meta property="og:description" content="Master Go best practices and professional development.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/best-practices.jsp">
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
    "name": "Best Practices in Go",
    "description": "Learn Go best practices, idioms, and professional development patterns.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/best-practices.jsp",
    "teaches": ["best practices", "idioms", "code style", "patterns", "professional development"],
    "timeRequired": "PT40M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="best-practices">
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
                                    <span>Best Practices</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Best Practices</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Writing idiomatic Go code makes it readable, maintainable, and
                                        professional. In
                                        this final lesson, you'll learn Go's best practices, common idioms, and patterns
                                        used by
                                        experienced Go developers.</p>

                                    <!-- Section 1: Code Style -->
                                    <h2>Code Style and Formatting</h2>

                                    <h3>Use gofmt</h3>
                                    <pre><code class="language-bash"># Format all Go files
gofmt -w .

# Or use goimports (also organizes imports)
go install golang.org/x/tools/cmd/goimports@latest
goimports -w .</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Golden Rule:</strong> Always run <code>gofmt</code> before committing.
                                        Most editors
                                        can auto-format on save. There's no debate about style—gofmt is the standard.
                                    </div>

                                    <h3>Naming Conventions</h3>
                                    <pre><code class="language-go">// ✅ Good names
var userCount int
var maxRetries = 3
type UserService struct{}
func GetUserByID(id int) (*User, error)

// ❌ Bad names
var usrCnt int           // Unclear abbreviation
var MAX_RETRIES = 3      // Not Go style (use maxRetries)
type user_service struct{} // Use camelCase
func get_user_by_id(id int) // Use camelCase

// Acronyms
var userID int    // ✅ ID, not Id
var httpServer    // ✅ HTTP, not Http
var urlPath       // ✅ URL, not Url</code></pre>

                                    <!-- Section 2: Error Handling -->
                                    <h2>Error Handling Patterns</h2>

                                    <h3>Check Errors Immediately</h3>
                                    <pre><code class="language-go">// ✅ Good - check immediately
file, err := os.Open("file.txt")
if err != nil {
    return err
}
defer file.Close()

// ❌ Bad - delayed check
file, err := os.Open("file.txt")
// ... other code ...
if err != nil {  // Too late!
    return err
}</code></pre>

                                    <h3>Wrap Errors with Context</h3>
                                    <pre><code class="language-go">// ✅ Good - add context
user, err := db.GetUser(id)
if err != nil {
    return fmt.Errorf("failed to get user %d: %w", id, err)
}

// ❌ Bad - lose context
user, err := db.GetUser(id)
if err != nil {
    return err  // What failed? Which user?
}</code></pre>

                                    <h3>Don't Panic</h3>
                                    <pre><code class="language-go">// ✅ Good - return error
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

// ❌ Bad - panic for expected errors
func divide(a, b float64) float64 {
    if b == 0 {
        panic("division by zero")  // Don't panic!
    }
    return a / b
}

// ✅ OK - panic only for programmer errors
func mustCompile(pattern string) *regexp.Regexp {
    re, err := regexp.Compile(pattern)
    if err != nil {
        panic(err)  // OK in init or must* functions
    }
    return re
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Interfaces -->
                                    <h2>Interface Best Practices</h2>

                                    <h3>Accept Interfaces, Return Structs</h3>
                                    <pre><code class="language-go">// ✅ Good - accept interface
func ProcessData(r io.Reader) error {
    // Works with files, network, strings, etc.
}

// ❌ Bad - accept concrete type
func ProcessData(f *os.File) error {
    // Only works with files
}

// ✅ Good - return concrete type
func NewUser(name string) *User {
    return &User{Name: name}
}

// ❌ Bad - return interface (usually)
func NewUser(name string) UserInterface {
    return &User{Name: name}
}</code></pre>

                                    <h3>Keep Interfaces Small</h3>
                                    <pre><code class="language-go">// ✅ Good - small, focused interfaces
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// Compose when needed
type ReadWriter interface {
    Reader
    Writer
}

// ❌ Bad - large interface
type DataStore interface {
    GetUser(id int) (*User, error)
    SaveUser(user *User) error
    DeleteUser(id int) error
    GetProduct(id int) (*Product, error)
    SaveProduct(product *Product) error
    // ... 20 more methods
}</code></pre>

                                    <!-- Section 4: Concurrency -->
                                    <h2>Concurrency Patterns</h2>

                                    <h3>Use Context for Cancellation</h3>
                                    <pre><code class="language-go">// ✅ Good - use context
func ProcessWithTimeout(ctx context.Context, data []int) error {
    ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
    defer cancel()
    
    for _, item := range data {
        select {
        case <-ctx.Done():
            return ctx.Err()
        default:
            process(item)
        }
    }
    return nil
}

// ❌ Bad - no cancellation
func Process(data []int) error {
    for _, item := range data {
        process(item)  // Can't cancel!
    }
    return nil
}</code></pre>

                                    <h3>Don't Start Goroutines Without Knowing When They Stop</h3>
                                    <pre><code class="language-go">// ✅ Good - controlled lifecycle
func StartWorker(ctx context.Context) {
    go func() {
        for {
            select {
            case <-ctx.Done():
                return  // Clean shutdown
            default:
                doWork()
            }
        }
    }()
}

// ❌ Bad - goroutine leak
func StartWorker() {
    go func() {
        for {
            doWork()  // Never stops!
        }
    }()
}</code></pre>

                                    <!-- Section 5: Package Design -->
                                    <h2>Package Organization</h2>

                                    <h3>Package Names</h3>
                                    <pre><code class="language-go">// ✅ Good package names
package user
package http
package json

// ❌ Bad package names
package user_service  // No underscores
package utils         // Too generic
package helpers       // Too generic
package common        // Too generic</code></pre>

                                    <h3>Avoid Package-Level State</h3>
                                    <pre><code class="language-go">// ❌ Bad - global state
package database

var DB *sql.DB

func init() {
    DB, _ = sql.Open("postgres", "...")
}

// ✅ Good - explicit dependencies
package database

type Store struct {
    db *sql.DB
}

func NewStore(connStr string) (*Store, error) {
    db, err := sql.Open("postgres", connStr)
    if err != nil {
        return nil, err
    }
    return &Store{db: db}, nil
}</code></pre>

                                    <!-- Section 6: Performance -->
                                    <h2>Performance Best Practices</h2>

                                    <h3>Preallocate Slices</h3>
                                    <pre><code class="language-go">// ✅ Good - preallocate
users := make([]User, 0, 100)
for i := 0; i < 100; i++ {
    users = append(users, User{ID: i})
}

// ❌ Slow - grows dynamically
var users []User
for i := 0; i < 100; i++ {
    users = append(users, User{ID: i})
}</code></pre>

                                    <h3>Use strings.Builder for Concatenation</h3>
                                    <pre><code class="language-go">// ✅ Good - efficient
var sb strings.Builder
for i := 0; i < 100; i++ {
    sb.WriteString("x")
}
result := sb.String()

// ❌ Slow - creates many strings
result := ""
for i := 0; i < 100; i++ {
    result += "x"
}</code></pre>

                                    <h3>Avoid Unnecessary Allocations</h3>
                                    <pre><code class="language-go">// ✅ Good - reuse
var buf bytes.Buffer
for _, item := range items {
    buf.Reset()
    buf.WriteString(item)
    process(buf.Bytes())
}

// ❌ Bad - allocates every time
for _, item := range items {
    buf := bytes.NewBuffer(nil)
    buf.WriteString(item)
    process(buf.Bytes())
}</code></pre>

                                    <!-- Section 7: Code Organization -->
                                    <h2>Code Organization Tips</h2>

                                    <div class="best-practice-box">
                                        <strong>Project Structure:</strong>
                                        <ul>
                                            <li><strong>cmd/</strong> - Main applications</li>
                                            <li><strong>internal/</strong> - Private application code</li>
                                            <li><strong>pkg/</strong> - Public library code</li>
                                            <li><strong>api/</strong> - API definitions</li>
                                            <li><strong>web/</strong> - Web assets</li>
                                            <li><strong>scripts/</strong> - Build and deployment scripts</li>
                                            <li><strong>docs/</strong> - Documentation</li>
                                        </ul>
                                    </div>

                                    <h3>Group Related Code</h3>
                                    <pre><code class="language-go">// ✅ Good - grouped by feature
user/
  user.go          // User type and core logic
  repository.go    // Database operations
  service.go       // Business logic
  handler.go       // HTTP handlers

// ❌ Bad - grouped by type
models/
  user.go
  product.go
repositories/
  user_repository.go
  product_repository.go
services/
  user_service.go
  product_service.go</code></pre>

                                    <!-- Section 8: Documentation -->
                                    <h2>Documentation</h2>

                                    <pre><code class="language-go">// ✅ Good - clear documentation
// Package user provides user management functionality.
package user

// User represents a user in the system.
// Users have a unique ID and email address.
type User struct {
    ID    int
    Email string
}

// GetByEmail retrieves a user by their email address.
// It returns ErrNotFound if the user doesn't exist.
func GetByEmail(email string) (*User, error) {
    // ...
}

// ❌ Bad - no documentation
package user

type User struct {
    ID    int
    Email string
}

func GetByEmail(email string) (*User, error) {
    // ...
}</code></pre>

                                    <!-- Section 9: Testing -->
                                    <h2>Testing Best Practices</h2>

                                    <div class="best-practice-box">
                                        <strong>Testing Guidelines:</strong>
                                        <ul>
                                            <li>Write tests for exported functions</li>
                                            <li>Use table-driven tests</li>
                                            <li>Test behavior, not implementation</li>
                                            <li>Use interfaces for mocking</li>
                                            <li>Aim for 70-80% coverage</li>
                                            <li>Run tests in CI/CD</li>
                                        </ul>
                                    </div>

                                    <!-- Section 10: Go Proverbs -->
                                    <h2>Go Proverbs</h2>

                                    <div class="info-box">
                                        <strong>Wisdom from the Go Community:</strong>
                                        <ul>
                                            <li>Don't communicate by sharing memory, share memory by communicating</li>
                                            <li>Concurrency is not parallelism</li>
                                            <li>Channels orchestrate; mutexes serialize</li>
                                            <li>The bigger the interface, the weaker the abstraction</li>
                                            <li>Make the zero value useful</li>
                                            <li>interface{} says nothing</li>
                                            <li>Gofmt's style is no one's favorite, yet gofmt is everyone's favorite
                                            </li>
                                            <li>A little copying is better than a little dependency</li>
                                            <li>Clear is better than clever</li>
                                            <li>Errors are values</li>
                                            <li>Don't just check errors, handle them gracefully</li>
                                        </ul>
                                    </div>

                                    <!-- Section 11: Tools -->
                                    <h2>Essential Go Tools</h2>

                                    <pre><code class="language-bash"># Format code
gofmt -w .
goimports -w .

# Lint code
go install golang.org/x/lint/golint@latest
golint ./...

# Static analysis
go vet ./...

# Security check
go install github.com/securego/gosec/v2/cmd/gosec@latest
gosec ./...

# Detect race conditions
go test -race ./...

# Generate documentation
godoc -http=:6060</code></pre>

                                    <!-- Congratulations -->
                                    <h2>🎉 Congratulations!</h2>

                                    <div class="success-box">
                                        <h3>You've Completed the Go Tutorial!</h3>
                                        <p>You've learned:</p>
                                        <ul>
                                            <li>✅ Go fundamentals and syntax</li>
                                            <li>✅ Data structures and algorithms</li>
                                            <li>✅ Pointers and interfaces</li>
                                            <li>✅ Error handling patterns</li>
                                            <li>✅ Concurrency with goroutines and channels</li>
                                            <li>✅ Package organization and modules</li>
                                            <li>✅ File I/O and JSON</li>
                                            <li>✅ HTTP clients and servers</li>
                                            <li>✅ Testing and benchmarking</li>
                                            <li>✅ Best practices and idioms</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>

                                    <div class="info-box">
                                        <strong>Continue Your Go Journey:</strong>
                                        <ul>
                                            <li><strong>Build Projects</strong> - Create real applications</li>
                                            <li><strong>Read Effective Go</strong> - <a
                                                    href="https://go.dev/doc/effective_go" target="_blank">Official
                                                    guide</a></li>
                                            <li><strong>Explore Standard Library</strong> - Read package documentation
                                            </li>
                                            <li><strong>Join the Community</strong> - Gophers Slack, Reddit r/golang
                                            </li>
                                            <li><strong>Contribute to Open Source</strong> - Find Go projects on GitHub
                                            </li>
                                            <li><strong>Learn Advanced Topics</strong> - Reflection, unsafe, cgo</li>
                                            <li><strong>Study Go Source Code</strong> - Learn from the masters</li>
                                        </ul>
                                    </div>

                                    <h3>Recommended Resources</h3>
                                    <ul>
                                        <li><a href="https://go.dev/" target="_blank">Official Go Website</a></li>
                                        <li><a href="https://go.dev/tour/" target="_blank">A Tour of Go</a></li>
                                        <li><a href="https://gobyexample.com/" target="_blank">Go by Example</a></li>
                                        <li><a href="https://github.com/golang/go/wiki" target="_blank">Go Wiki</a></li>
                                        <li><a href="https://www.youtube.com/c/GopherAcademy"
                                                target="_blank">GopherAcademy
                                                Videos</a></li>
                                    </ul>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Use gofmt</strong> for consistent formatting</li>
                                            <li><strong>Check errors immediately</strong> and add context</li>
                                            <li><strong>Accept interfaces, return structs</strong></li>
                                            <li><strong>Keep interfaces small</strong> and focused</li>
                                            <li><strong>Use context</strong> for cancellation</li>
                                            <li><strong>Avoid global state</strong> and package-level variables</li>
                                            <li><strong>Preallocate slices</strong> when size is known</li>
                                            <li><strong>Document exported items</strong></li>
                                            <li><strong>Write tests</strong> for all exported functions</li>
                                            <li><strong>Clear is better than clever</strong></li>
                                        </ul>
                                    </div>

                                    <div class="success-box" style="margin-top: 2rem; text-align: center;">
                                        <h3>🚀 You're Now a Go Developer! 🚀</h3>
                                        <p>Go forth and build amazing things!</p>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="benchmarking.jsp" />
                                    <jsp:param name="prevTitle" value="Benchmarking" />
                                    <jsp:param name="nextLink" value="generics-reflection.jsp" />
                                    <jsp:param name="nextTitle" value="Generics & Reflection" />
                                    <jsp:param name="currentLessonId" value="best-practices" />
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