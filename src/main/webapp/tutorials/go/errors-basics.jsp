<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "errors-basics" ); request.setAttribute("currentModule", "Error Handling"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Error Basics & Custom Errors in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go error handling, error interface, custom errors, sentinel errors, and error creation. Master Go's approach to error handling.">
            <meta name="keywords"
                content="go errors, golang error handling, custom errors, sentinel errors, error interface, go error creation">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Error Basics & Custom Errors in Go">
            <meta property="og:description" content="Master Go error handling and custom error types.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/errors-basics.jsp">
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
    "name": "Error Basics & Custom Errors in Go",
    "description": "Learn Go error handling, custom errors, and error creation with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/errors-basics.jsp",
    "teaches": ["error handling", "custom errors", "sentinel errors", "error interface"],
    "timeRequired": "PT35M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="errors-basics">
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
                                    <span>Error Basics & Custom Errors</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Error Basics & Custom Errors</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Go treats errors as values, not exceptions. This simple but powerful
                                        approach
                                        makes error handling explicit and predictable. In this lesson, you'll learn Go's
                                        error
                                        philosophy, how to create and handle errors, and how to design custom error
                                        types.</p>

                                    <!-- Section 1: Error Basics -->
                                    <h2>The Error Interface</h2>
                                    <p>In Go, errors are just values that implement the error interface:</p>

                                    <pre><code class="language-go">type error interface {
    Error() string
}</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/errors-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-errors" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Go's Error Philosophy:</strong>
                                        <ul>
                                            <li><strong>Errors are values</strong> - Not exceptions to be thrown/caught
                                            </li>
                                            <li><strong>Explicit handling</strong> - Check errors where they occur</li>
                                            <li><strong>Return errors</strong> - Functions return errors as values</li>
                                            <li><strong>No hidden control flow</strong> - No try/catch blocks</li>
                                        </ul>
                                    </div>

                                    <h3>Creating Errors</h3>
                                    <pre><code class="language-go">import "errors"

// Simple error
err := errors.New("something went wrong")

// Formatted error
import "fmt"
err := fmt.Errorf("invalid value: %d", value)</code></pre>

                                    <!-- Section 2: Error Handling Patterns -->
                                    <h2>Error Handling Patterns</h2>

                                    <h3>1. Check and Return</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/errors-patterns.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-handling" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Handle errors immediately after they occur.
                                        Don't ignore
                                        them! The pattern <code>if err != nil { return err }</code> is idiomatic Go.
                                    </div>

                                    <h3>2. Early Return</h3>
                                    <pre><code class="language-go">func processData(filename string) error {
    data, err := readFile(filename)
    if err != nil {
        return err  // Early return on error
    }
    
    result, err := transform(data)
    if err != nil {
        return err
    }
    
    err = save(result)
    if err != nil {
        return err
    }
    
    return nil  // Success
}</code></pre>

                                    <h3>3. Error with Context</h3>
                                    <pre><code class="language-go">func readConfig(filename string) (*Config, error) {
    data, err := os.ReadFile(filename)
    if err != nil {
        return nil, fmt.Errorf("failed to read config: %w", err)
    }
    
    var config Config
    err = json.Unmarshal(data, &config)
    if err != nil {
        return nil, fmt.Errorf("failed to parse config: %w", err)
    }
    
    return &config, nil
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Custom Errors -->
                                    <h2>Custom Error Types</h2>
                                    <p>Create custom errors by implementing the error interface:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/errors-custom.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-custom" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>When to Use Custom Errors:</strong>
                                        <ul>
                                            <li>Need to include additional context (fields)</li>
                                            <li>Want to distinguish error types programmatically</li>
                                            <li>Need structured error information</li>
                                            <li>Building libraries or APIs</li>
                                        </ul>
                                    </div>

                                    <!-- Section 4: Sentinel Errors -->
                                    <h2>Sentinel Errors</h2>
                                    <p>Sentinel errors are predefined error values for specific conditions:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/errors-sentinel.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-sentinel" />
                                    </jsp:include>

                                    <h3>Standard Library Sentinel Errors</h3>
                                    <pre><code class="language-go">import (
    "io"
    "os"
)

// io package
io.EOF           // End of file
io.ErrClosedPipe // Pipe closed
io.ErrUnexpectedEOF

// os package
os.ErrNotExist   // File doesn't exist
os.ErrExist      // File already exists
os.ErrPermission // Permission denied</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use <code>errors.Is()</code> to check for sentinel
                                        errors, not
                                        <code>==</code>. This works even when errors are wrapped!
                                    </div>

                                    <!-- Section 5: Error Type Assertions -->
                                    <h2>Checking Error Types</h2>

                                    <h3>Using errors.As()</h3>
                                    <pre><code class="language-go">import "errors"

var validationErr *ValidationError
if errors.As(err, &validationErr) {
    // err is a ValidationError
    fmt.Println("Field:", validationErr.Field)
    fmt.Println("Message:", validationErr.Message)
}

// Works with wrapped errors too!
err := fmt.Errorf("processing failed: %w", &ValidationError{
    Field: "age",
    Message: "must be positive",
})

var ve *ValidationError
if errors.As(err, &ve) {
    fmt.Println("Found:", ve.Field)  // Works!
}</code></pre>

                                    <!-- Section 6: Error Patterns -->
                                    <h2>Common Error Patterns</h2>

                                    <h3>1. Multiple Return Values</h3>
                                    <pre><code class="language-go">// Return result and error
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

// Usage
result, err := divide(10, 0)
if err != nil {
    log.Fatal(err)
}
fmt.Println(result)</code></pre>

                                    <h3>2. Named Return Values</h3>
                                    <pre><code class="language-go">func readFile(name string) (data []byte, err error) {
    f, err := os.Open(name)
    if err != nil {
        return  // Returns nil, err
    }
    defer f.Close()
    
    data, err = io.ReadAll(f)
    return  // Returns data, err
}</code></pre>

                                    <h3>3. Error Aggregation</h3>
                                    <pre><code class="language-go">type MultiError struct {
    Errors []error
}

func (m *MultiError) Error() string {
    var msgs []string
    for _, err := range m.Errors {
        msgs = append(msgs, err.Error())
    }
    return strings.Join(msgs, "; ")
}

func (m *MultiError) Add(err error) {
    if err != nil {
        m.Errors = append(m.Errors, err)
    }
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Ignoring errors</h4>
                                        <pre><code class="language-go">// ❌ Wrong - ignoring error
data, _ := os.ReadFile("config.json")

// ✅ Correct - handle error
data, err := os.ReadFile("config.json")
if err != nil {
    log.Fatal(err)
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Using panic for normal errors</h4>
                                        <pre><code class="language-go">// ❌ Wrong - panic for expected errors
func divide(a, b int) int {
    if b == 0 {
        panic("division by zero")
    }
    return a / b
}

// ✅ Correct - return error
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not adding context to errors</h4>
                                        <pre><code class="language-go">// ❌ Less helpful
func loadConfig() error {
    _, err := os.ReadFile("config.json")
    return err  // Where did this error come from?
}

// ✅ Better - add context
func loadConfig() error {
    _, err := os.ReadFile("config.json")
    if err != nil {
        return fmt.Errorf("failed to load config: %w", err)
    }
    return nil
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Comparing errors with ==</h4>
                                        <pre><code class="language-go">// ❌ Wrong - doesn't work with wrapped errors
if err == io.EOF {
    // Won't match if err is wrapped
}

// ✅ Correct - use errors.Is()
if errors.Is(err, io.EOF) {
    // Works even if wrapped!
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: User Validation</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a user validation system with custom errors.
                                        </p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a <code>ValidationError</code> type with Field and Message</li>
                                            <li>Create a <code>validateUser</code> function</li>
                                            <li>Validate: name not empty, age >= 0, email contains @</li>
                                            <li>Return appropriate validation errors</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "errors"
    "fmt"
    "strings"
)

// ValidationError represents a validation failure
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation error: %s - %s", e.Field, e.Message)
}

// User represents a user
type User struct {
    Name  string
    Age   int
    Email string
}

// validateUser validates a user
func validateUser(u User) error {
    if u.Name == "" {
        return &ValidationError{
            Field:   "name",
            Message: "cannot be empty",
        }
    }
    
    if u.Age < 0 {
        return &ValidationError{
            Field:   "age",
            Message: "must be non-negative",
        }
    }
    
    if !strings.Contains(u.Email, "@") {
        return &ValidationError{
            Field:   "email",
            Message: "must contain @",
        }
    }
    
    return nil
}

func main() {
    // Test cases
    users := []User{
        {Name: "Alice", Age: 25, Email: "alice@example.com"},
        {Name: "", Age: 30, Email: "bob@example.com"},
        {Name: "Carol", Age: -5, Email: "carol@example.com"},
        {Name: "Dave", Age: 40, Email: "invalid-email"},
    }
    
    for i, user := range users {
        fmt.Printf("Validating user %d: %+v\n", i+1, user)
        
        err := validateUser(user)
        if err != nil {
            // Check if it's a ValidationError
            var ve *ValidationError
            if errors.As(err, &ve) {
                fmt.Printf("  ❌ Invalid %s: %s\n", ve.Field, ve.Message)
            } else {
                fmt.Printf("  ❌ Error: %v\n", err)
            }
        } else {
            fmt.Println("  ✅ Valid")
        }
        fmt.Println()
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Errors are values</strong> in Go, not exceptions</li>
                                            <li><strong>error interface</strong> requires only Error() string method
                                            </li>
                                            <li><strong>Check errors explicitly</strong> with if err != nil</li>
                                            <li><strong>Create errors</strong> with errors.New() or fmt.Errorf()</li>
                                            <li><strong>Custom errors</strong> implement the error interface</li>
                                            <li><strong>Sentinel errors</strong> are predefined error values</li>
                                            <li><strong>errors.Is()</strong> checks for specific errors</li>
                                            <li><strong>errors.As()</strong> extracts custom error types</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand error basics and custom errors, you're ready to learn
                                        about
                                        <strong>Error Wrapping & Best Practices</strong>. You'll discover how to wrap
                                        errors for
                                        better context and explore advanced error handling patterns.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="type-switches.jsp" />
                                    <jsp:param name="prevTitle" value="Type Switches" />
                                    <jsp:param name="nextLink" value="errors-wrapping.jsp" />
                                    <jsp:param name="nextTitle" value="Error Wrapping & Best Practices" />
                                    <jsp:param name="currentLessonId" value="errors-basics" />
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