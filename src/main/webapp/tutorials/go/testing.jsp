<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "testing" );
        request.setAttribute("currentModule", "Advanced & Professional" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Testing in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go testing, unit tests, table-driven tests, test coverage, mocking, and testing best practices.">
            <meta name="keywords"
                content="go testing, golang unit tests, go test, table driven tests, test coverage, go mocking">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Testing in Go">
            <meta property="og:description" content="Master Go testing and test-driven development.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/testing.jsp">
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
    "name": "Testing in Go",
    "description": "Learn Go testing with unit tests, table-driven tests, and coverage.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/testing.jsp",
    "teaches": ["testing", "unit tests", "table driven tests", "test coverage", "mocking"],
    "timeRequired": "PT35M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="testing">
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
                                    <span>Testing</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Testing</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Testing is built into Go's toolchain. The testing package provides
                                        everything you
                                        need for unit tests, benchmarks, and examples. In this lesson, you'll learn to
                                        write
                                        effective tests and ensure code quality.</p>

                                    <!-- Section 1: Basic Testing -->
                                    <h2>Writing Your First Test</h2>

                                    <h3>Code to Test</h3>
                                    <pre><code class="language-go">// math.go
package math

func Add(a, b int) int {
    return a + b
}

func Multiply(a, b int) int {
    return a * b
}</code></pre>

                                    <h3>Test File</h3>
                                    <pre><code class="language-go">// math_test.go
package math

import "testing"

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    expected := 5
    
    if result != expected {
        t.Errorf("Add(2, 3) = %d; want %d", result, expected)
    }
}

func TestMultiply(t *testing.T) {
    result := Multiply(4, 5)
    expected := 20
    
    if result != expected {
        t.Errorf("Multiply(4, 5) = %d; want %d", result, expected)
    }
}</code></pre>

                                    <div class="info-box">
                                        <strong>Test File Rules:</strong>
                                        <ul>
                                            <li>File name ends with <code>_test.go</code></li>
                                            <li>Test functions start with <code>Test</code></li>
                                            <li>Take <code>*testing.T</code> parameter</li>
                                            <li>Use <code>t.Error()</code> or <code>t.Fatal()</code> to fail</li>
                                        </ul>
                                    </div>

                                    <h3>Running Tests</h3>
                                    <pre><code class="language-bash"># Run all tests
go test

# Verbose output
go test -v

# Run specific test
go test -run TestAdd

# Run tests in all subdirectories
go test ./...</code></pre>

                                    <!-- Section 2: Table-Driven Tests -->
                                    <h2>Table-Driven Tests</h2>
                                    <p>The idiomatic way to test multiple cases:</p>

                                    <pre><code class="language-go">func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive numbers", 2, 3, 5},
        {"negative numbers", -2, -3, -5},
        {"mixed signs", -2, 3, 1},
        {"zeros", 0, 0, 0},
        {"large numbers", 1000, 2000, 3000},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%d, %d) = %d; want %d", 
                    tt.a, tt.b, result, tt.expected)
            }
        })
    }
}</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use table-driven tests for multiple test cases.
                                        They're
                                        easier to read, maintain, and extend. Use <code>t.Run()</code> for subtests.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Test Helpers -->
                                    <h2>Test Helpers and Assertions</h2>

                                    <pre><code class="language-go">// Helper function
func assertEqual(t *testing.T, got, want interface{}) {
    t.Helper()  // Marks this as helper (better error messages)
    if got != want {
        t.Errorf("got %v; want %v", got, want)
    }
}

func TestWithHelper(t *testing.T) {
    result := Add(2, 3)
    assertEqual(t, result, 5)
}</code></pre>

                                    <h3>Testing Errors</h3>
                                    <pre><code class="language-go">func Divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func TestDivide(t *testing.T) {
    // Test success case
    result, err := Divide(10, 2)
    if err != nil {
        t.Fatalf("unexpected error: %v", err)
    }
    if result != 5.0 {
        t.Errorf("got %v; want 5.0", result)
    }
    
    // Test error case
    _, err = Divide(10, 0)
    if err == nil {
        t.Error("expected error, got nil")
    }
}</code></pre>

                                    <!-- Section 4: Test Coverage -->
                                    <h2>Test Coverage</h2>

                                    <pre><code class="language-bash"># Run tests with coverage
go test -cover

# Generate coverage report
go test -coverprofile=coverage.out

# View coverage in browser
go tool cover -html=coverage.out

# Coverage for all packages
go test -cover ./...</code></pre>

                                    <div class="info-box">
                                        <strong>Coverage Metrics:</strong>
                                        <ul>
                                            <li><strong>Statement coverage</strong> - Which lines executed</li>
                                            <li><strong>Branch coverage</strong> - Which branches taken</li>
                                            <li><strong>Function coverage</strong> - Which functions called</li>
                                            <li>Aim for 70-80% coverage (100% not always necessary)</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Mocking -->
                                    <h2>Mocking and Interfaces</h2>

                                    <pre><code class="language-go">// Interface for database
type UserStore interface {
    GetUser(id int) (*User, error)
    SaveUser(user *User) error
}

// Real implementation
type DBUserStore struct {
    db *sql.DB
}

func (s *DBUserStore) GetUser(id int) (*User, error) {
    // Real database query
}

// Mock for testing
type MockUserStore struct {
    users map[int]*User
}

func (m *MockUserStore) GetUser(id int) (*User, error) {
    user, ok := m.users[id]
    if !ok {
        return nil, errors.New("user not found")
    }
    return user, nil
}

func (m *MockUserStore) SaveUser(user *User) error {
    m.users[user.ID] = user
    return nil
}

// Service that uses UserStore
type UserService struct {
    store UserStore
}

func (s *UserService) GetUserName(id int) (string, error) {
    user, err := s.store.GetUser(id)
    if err != nil {
        return "", err
    }
    return user.Name, nil
}

// Test with mock
func TestUserService(t *testing.T) {
    mock := &MockUserStore{
        users: map[int]*User{
            1: {ID: 1, Name: "Alice"},
        },
    }
    
    service := &UserService{store: mock}
    
    name, err := service.GetUserName(1)
    if err != nil {
        t.Fatalf("unexpected error: %v", err)
    }
    if name != "Alice" {
        t.Errorf("got %s; want Alice", name)
    }
}</code></pre>

                                    <!-- Section 6: Testing Patterns -->
                                    <h2>Advanced Testing Patterns</h2>

                                    <h3>Setup and Teardown</h3>
                                    <pre><code class="language-go">func TestMain(m *testing.M) {
    // Setup
    fmt.Println("Setting up tests...")
    
    // Run tests
    code := m.Run()
    
    // Teardown
    fmt.Println("Cleaning up...")
    
    os.Exit(code)
}

func TestWithSetup(t *testing.T) {
    // Per-test setup
    setup := func() *Database {
        db := &Database{}
        db.Connect()
        return db
    }
    
    // Per-test teardown
    teardown := func(db *Database) {
        db.Close()
    }
    
    db := setup()
    defer teardown(db)
    
    // Test code
}</code></pre>

                                    <h3>Testing HTTP Handlers</h3>
                                    <pre><code class="language-go">func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, World!")
}

func TestHandler(t *testing.T) {
    req := httptest.NewRequest("GET", "/", nil)
    w := httptest.NewRecorder()
    
    handler(w, req)
    
    resp := w.Result()
    body, _ := io.ReadAll(resp.Body)
    
    if resp.StatusCode != http.StatusOK {
        t.Errorf("got status %d; want %d", resp.StatusCode, http.StatusOK)
    }
    
    if string(body) != "Hello, World!" {
        t.Errorf("got body %s; want Hello, World!", body)
    }
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Not using t.Helper()</h4>
                                        <pre><code class="language-go">// ❌ Wrong - error points to helper function
func assertEqual(t *testing.T, got, want int) {
    if got != want {
        t.Errorf("got %d; want %d", got, want)
    }
}

// ✅ Correct - error points to test
func assertEqual(t *testing.T, got, want int) {
    t.Helper()  // Mark as helper
    if got != want {
        t.Errorf("got %d; want %d", got, want)
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Testing implementation instead of behavior</h4>
                                        <pre><code class="language-go">// ❌ Wrong - testing internal details
func TestSort(t *testing.T) {
    // Testing which sorting algorithm is used
}

// ✅ Correct - testing behavior
func TestSort(t *testing.T) {
    input := []int{3, 1, 2}
    Sort(input)
    expected := []int{1, 2, 3}
    // Test that output is sorted
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not running tests in parallel</h4>
                                        <pre><code class="language-go">// ❌ Slow - sequential tests
func TestSlow(t *testing.T) {
    time.Sleep(time.Second)
}

// ✅ Fast - parallel tests
func TestFast(t *testing.T) {
    t.Parallel()  // Run in parallel
    time.Sleep(time.Second)
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Test a Calculator</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Write comprehensive tests for a calculator.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Test Add, Subtract, Multiply, Divide functions</li>
                                            <li>Use table-driven tests</li>
                                            <li>Test error cases (division by zero)</li>
                                            <li>Achieve >80% coverage</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">// calculator.go
package calculator

import "errors"

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
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

// calculator_test.go
package calculator

import "testing"

func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     float64
        expected float64
    }{
        {"positive", 2.5, 3.5, 6.0},
        {"negative", -2.5, -3.5, -6.0},
        {"mixed", -2.5, 3.5, 1.0},
        {"zeros", 0, 0, 0},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%.2f, %.2f) = %.2f; want %.2f",
                    tt.a, tt.b, result, tt.expected)
            }
        })
    }
}

func TestDivide(t *testing.T) {
    // Success cases
    tests := []struct {
        name     string
        a, b     float64
        expected float64
    }{
        {"normal", 10, 2, 5},
        {"decimal", 7, 2, 3.5},
        {"negative", -10, 2, -5},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result, err := Divide(tt.a, tt.b)
            if err != nil {
                t.Fatalf("unexpected error: %v", err)
            }
            if result != tt.expected {
                t.Errorf("Divide(%.2f, %.2f) = %.2f; want %.2f",
                    tt.a, tt.b, result, tt.expected)
            }
        })
    }
    
    // Error case
    t.Run("division by zero", func(t *testing.T) {
        _, err := Divide(10, 0)
        if err == nil {
            t.Error("expected error, got nil")
        }
    })
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Test files</strong> end with <code>_test.go</code></li>
                                            <li><strong>Test functions</strong> start with <code>Test</code></li>
                                            <li><strong>Table-driven tests</strong> are idiomatic Go</li>
                                            <li><strong>t.Helper()</strong> improves error messages</li>
                                            <li><strong>go test -cover</strong> shows coverage</li>
                                            <li><strong>Interfaces</strong> enable mocking</li>
                                            <li><strong>t.Parallel()</strong> runs tests concurrently</li>
                                            <li><strong>Test behavior</strong>, not implementation</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you can write tests, you're ready to learn about
                                        <strong>Benchmarking</strong>.
                                        You'll discover how to measure performance, optimize code, and ensure your
                                        programs run
                                        efficiently!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="json-http.jsp" />
                                    <jsp:param name="prevTitle" value="JSON & HTTP" />
                                    <jsp:param name="nextLink" value="benchmarking.jsp" />
                                    <jsp:param name="nextTitle" value="Benchmarking" />
                                    <jsp:param name="currentLessonId" value="testing" />
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