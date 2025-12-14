<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "errors-wrapping" ); request.setAttribute("currentModule", "Error Handling"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Error Wrapping & Best Practices in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go error wrapping, %w verb, errors.Unwrap, error chains, and best practices. Master advanced error handling patterns.">
            <meta name="keywords"
                content="go error wrapping, golang error chains, errors.Unwrap, %w verb, error best practices">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Error Wrapping & Best Practices in Go">
            <meta property="og:description" content="Master Go error wrapping and advanced error handling.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/errors-wrapping.jsp">
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
    "name": "Error Wrapping & Best Practices in Go",
    "description": "Learn Go error wrapping, error chains, and best practices with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/errors-wrapping.jsp",
    "teaches": ["error wrapping", "error chains", "errors.Unwrap", "error best practices"],
    "timeRequired": "PT35M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="errors-wrapping">
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
                                    <span>Error Wrapping & Best Practices</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Error Wrapping & Best Practices</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Error wrapping adds context while preserving the original error.
                                        This creates an
                                        error chain that helps with debugging and allows checking for specific errors.
                                        In this
                                        lesson, you'll master error wrapping and learn professional error handling
                                        practices.</p>

                                    <!-- Section 1: Error Wrapping -->
                                    <h2>Error Wrapping with %w</h2>
                                    <p>The <code>%w</code> verb in fmt.Errorf wraps an error:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/errors-wrapping.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-wrapping" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>%w vs %v:</strong>
                                        <ul>
                                            <li><code>%w</code> - Wraps the error (preserves it for errors.Is/As)</li>
                                            <li><code>%v</code> - Converts to string (loses the original error)</li>
                                        </ul>
                                        <pre><code class="language-go">// Wrapping (preserves original)
err := fmt.Errorf("failed to process: %w", originalErr)

// Not wrapping (just formatting)
err := fmt.Errorf("failed to process: %v", originalErr)</code></pre>
                                    </div>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use <code>%w</code> when you want to preserve
                                        the error for
                                        checking with errors.Is() or errors.As(). Use <code>%v</code> when you want to
                                        hide
                                        implementation details.
                                    </div>

                                    <!-- Section 2: Error Chains -->
                                    <h2>Error Chains</h2>
                                    <p>Wrapping creates a chain of errors:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/errors-wrapping.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-chain" />
                                    </jsp:include>

                                    <h3>Unwrapping Errors</h3>
                                    <pre><code class="language-go">import "errors"

// Unwrap returns the wrapped error
err := fmt.Errorf("outer: %w", innerErr)
unwrapped := errors.Unwrap(err)  // Returns innerErr

// Unwrap returns nil if not wrapped
simple := errors.New("simple error")
unwrapped := errors.Unwrap(simple)  // nil</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: errors.Is and errors.As -->
                                    <h2>Working with Wrapped Errors</h2>

                                    <h3>errors.Is() - Check Error Type</h3>
                                    <pre><code class="language-go">var ErrNotFound = errors.New("not found")

func findUser(id int) error {
    // ... some code ...
    return fmt.Errorf("user lookup failed: %w", ErrNotFound)
}

err := findUser(123)

// errors.Is() works through the chain
if errors.Is(err, ErrNotFound) {
    fmt.Println("User not found!")  // This works!
}

// Direct comparison doesn't work
if err == ErrNotFound {
    fmt.Println("Won't print")  // err is wrapped
}</code></pre>

                                    <h3>errors.As() - Extract Error Type</h3>
                                    <pre><code class="language-go">type ValidationError struct {
    Field string
    Value interface{}
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("invalid %s: %v", e.Field, e.Value)
}

func validate(age int) error {
    if age < 0 {
        return fmt.Errorf("validation failed: %w", 
            &ValidationError{Field: "age", Value: age})
    }
    return nil
}

err := validate(-5)

// errors.As() extracts the ValidationError
var ve *ValidationError
if errors.As(err, &ve) {
    fmt.Printf("Field: %s, Value: %v\n", ve.Field, ve.Value)
}</code></pre>

                                    <!-- Section 4: Best Practices -->
                                    <h2>Error Handling Best Practices</h2>

                                    <h3>1. Add Context at Each Layer</h3>
                                    <pre><code class="language-go">// Database layer
func (db *DB) GetUser(id int) (*User, error) {
    user, err := db.query(id)
    if err != nil {
        return nil, fmt.Errorf("database query failed: %w", err)
    }
    return user, nil
}

// Service layer
func (s *Service) LoadUser(id int) (*User, error) {
    user, err := s.db.GetUser(id)
    if err != nil {
        return nil, fmt.Errorf("failed to load user %d: %w", id, err)
    }
    return user, nil
}

// Handler layer
func (h *Handler) HandleRequest(id int) error {
    user, err := h.service.LoadUser(id)
    if err != nil {
        return fmt.Errorf("request handling failed: %w", err)
    }
    // ...
}</code></pre>

                                    <h3>2. Don't Wrap Errors Unnecessarily</h3>
                                    <pre><code class="language-go">// ❌ Too much wrapping
func process() error {
    err := doSomething()
    if err != nil {
        return fmt.Errorf("error: %w", err)  // Not adding value
    }
    return nil
}

// ✅ Add meaningful context
func process() error {
    err := doSomething()
    if err != nil {
        return fmt.Errorf("failed to process data: %w", err)
    }
    return nil
}</code></pre>

                                    <h3>3. Handle Errors at the Right Level</h3>
                                    <pre><code class="language-go">// ❌ Wrong - handling too early
func readConfig() (*Config, error) {
    data, err := os.ReadFile("config.json")
    if err != nil {
        log.Fatal(err)  // Don't log.Fatal in library code!
    }
    // ...
}

// ✅ Correct - return error, let caller decide
func readConfig() (*Config, error) {
    data, err := os.ReadFile("config.json")
    if err != nil {
        return nil, fmt.Errorf("failed to read config: %w", err)
    }
    // ...
}

// Caller decides how to handle
func main() {
    config, err := readConfig()
    if err != nil {
        log.Fatal(err)  // OK in main
    }
}</code></pre>

                                    <h3>4. Use Sentinel Errors for Expected Conditions</h3>
                                    <pre><code class="language-go">var (
    ErrNotFound    = errors.New("not found")
    ErrUnauthorized = errors.New("unauthorized")
    ErrInvalidInput = errors.New("invalid input")
)

func getUser(id int) (*User, error) {
    if id <= 0 {
        return nil, ErrInvalidInput
    }
    
    user := findInDB(id)
    if user == nil {
        return nil, ErrNotFound
    }
    
    return user, nil
}

// Caller can check specific errors
user, err := getUser(123)
if errors.Is(err, ErrNotFound) {
    // Handle not found
} else if errors.Is(err, ErrInvalidInput) {
    // Handle invalid input
}</code></pre>

                                    <!-- Section 5: Logging Errors -->
                                    <h2>Logging Errors</h2>

                                    <h3>Log Once, Return Once</h3>
                                    <pre><code class="language-go">// ❌ Wrong - logging at every level
func layer1() error {
    err := layer2()
    if err != nil {
        log.Printf("layer1 error: %v", err)  // Logged
        return err
    }
    return nil
}

func layer2() error {
    err := layer3()
    if err != nil {
        log.Printf("layer2 error: %v", err)  // Logged again!
        return err
    }
    return nil
}

// ✅ Correct - log at top level only
func layer1() error {
    err := layer2()
    if err != nil {
        return fmt.Errorf("layer1: %w", err)  // Add context, don't log
    }
    return nil
}

func main() {
    err := layer1()
    if err != nil {
        log.Printf("Error: %v", err)  // Log once at top
    }
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using %v instead of %w</h4>
                                        <pre><code class="language-go">// ❌ Wrong - loses original error
err := fmt.Errorf("failed: %v", originalErr)
if errors.Is(err, ErrNotFound) {  // Won't work!
    // ...
}

// ✅ Correct - preserves original
err := fmt.Errorf("failed: %w", originalErr)
if errors.Is(err, ErrNotFound) {  // Works!
    // ...
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Wrapping nil errors</h4>
                                        <pre><code class="language-go">// ❌ Wrong - wrapping nil
func process() error {
    err := doSomething()
    return fmt.Errorf("process failed: %w", err)  // err might be nil!
}

// ✅ Correct - check before wrapping
func process() error {
    err := doSomething()
    if err != nil {
        return fmt.Errorf("process failed: %w", err)
    }
    return nil
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Exposing internal errors</h4>
                                        <pre><code class="language-go">// ❌ Wrong - exposing database details to API
func (api *API) GetUser(id int) (*User, error) {
    user, err := db.Query("SELECT * FROM users WHERE id = ?", id)
    return user, err  // Exposes SQL errors!
}

// ✅ Correct - wrap with generic message
func (api *API) GetUser(id int) (*User, error) {
    user, err := db.Query("SELECT * FROM users WHERE id = ?", id)
    if err != nil {
        return nil, fmt.Errorf("failed to get user: %w", ErrInternal)
    }
    return user, nil
}</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: File Processor with Error Handling</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a file processor with proper error handling.
                                        </p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create functions: readFile, processData, writeFile</li>
                                            <li>Wrap errors with context at each layer</li>
                                            <li>Use sentinel errors for specific conditions</li>
                                            <li>Handle errors appropriately in main</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "errors"
    "fmt"
    "os"
    "strings"
)

// Sentinel errors
var (
    ErrEmptyFile = errors.New("file is empty")
    ErrInvalidData = errors.New("invalid data format")
)

// readFile reads a file
func readFile(filename string) (string, error) {
    data, err := os.ReadFile(filename)
    if err != nil {
        return "", fmt.Errorf("failed to read file %s: %w", filename, err)
    }
    
    if len(data) == 0 {
        return "", fmt.Errorf("file %s: %w", filename, ErrEmptyFile)
    }
    
    return string(data), nil
}

// processData processes the data
func processData(data string) (string, error) {
    if !strings.Contains(data, ":") {
        return "", fmt.Errorf("data processing: %w", ErrInvalidData)
    }
    
    // Simple processing: convert to uppercase
    processed := strings.ToUpper(data)
    return processed, nil
}

// writeFile writes data to a file
func writeFile(filename, data string) error {
    err := os.WriteFile(filename, []byte(data), 0644)
    if err != nil {
        return fmt.Errorf("failed to write file %s: %w", filename, err)
    }
    return nil
}

// processFile orchestrates the entire process
func processFile(inputFile, outputFile string) error {
    // Read
    data, err := readFile(inputFile)
    if err != nil {
        return fmt.Errorf("processFile: %w", err)
    }
    
    // Process
    processed, err := processData(data)
    if err != nil {
        return fmt.Errorf("processFile: %w", err)
    }
    
    // Write
    err = writeFile(outputFile, processed)
    if err != nil {
        return fmt.Errorf("processFile: %w", err)
    }
    
    return nil
}

func main() {
    err := processFile("input.txt", "output.txt")
    if err != nil {
        // Check for specific errors
        if errors.Is(err, os.ErrNotExist) {
            fmt.Println("Error: Input file does not exist")
        } else if errors.Is(err, ErrEmptyFile) {
            fmt.Println("Error: Input file is empty")
        } else if errors.Is(err, ErrInvalidData) {
            fmt.Println("Error: Data format is invalid")
        } else {
            fmt.Printf("Error: %v\n", err)
        }
        os.Exit(1)
    }
    
    fmt.Println("File processed successfully!")
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>%w verb</strong> wraps errors, preserving them for Is/As</li>
                                            <li><strong>%v verb</strong> formats errors as strings (doesn't wrap)</li>
                                            <li><strong>Error chains</strong> provide context at each layer</li>
                                            <li><strong>errors.Is()</strong> checks wrapped errors</li>
                                            <li><strong>errors.As()</strong> extracts custom error types</li>
                                            <li><strong>errors.Unwrap()</strong> returns the wrapped error</li>
                                            <li><strong>Add context</strong> at each layer, but don't over-wrap</li>
                                            <li><strong>Log once</strong> at the top level, return errors below</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing the Error Handling module! You now understand Go's
                                        error
                                        philosophy and best practices. Next, you'll dive into
                                        <strong>Concurrency</strong>—one of
                                        Go's most powerful features with goroutines and channels!
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="errors-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Error Basics" />
                                    <jsp:param name="nextLink" value="goroutines.jsp" />
                                    <jsp:param name="nextTitle" value="Goroutines" />
                                    <jsp:param name="currentLessonId" value="errors-wrapping" />
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